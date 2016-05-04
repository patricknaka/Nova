select Q1.*
         from ( SELECT
                  DISTINCT
                    brnfe940.t$fovn$l        id_fiscal,
                    brnfe940.t$fids$l        razao_social,
                    brnfe940.t$fire$l        num_rascunho,
                    znnfe007.t$orno$c        num_pedido,
                    brnfe940.t$docn$l        num_nota_fiscal,
                    brnfe940.t$seri$l        ser_nota_fiscal,
                    brnfe940.t$fdot$l        natureza_oper,

                    CASE WHEN TO_CHAR(brnfe940.t$idat$l) = '01/01/4712 00:00:00'
                           THEN NULL
                         ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(brnfe940.t$idat$l, 
                                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                                   AT time zone 'America/Sao_Paulo') AS DATE)
                    END                      data_fiscal,
                    brnfe940.t$slog$c        login_usuário,
                    tdpur400.t$cdec          linha_doc_fiscal,
                    tdpur400.t$cofc          departamento, 
                    znfmd001.t$fili$c        filial,
                    znfmd001.t$dsca$c        desc_filial,
                    
                    CASE WHEN TO_CHAR(brnfe940.t$idat$l) = '01/01/4712 00:00:00'
                           THEN NULL
                         ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(brnfe940.t$idat$l, 
                                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                                   AT time zone 'America/Sao_Paulo') AS DATE)
                    END                      data_emissao_nf,

                    brnfe941.t$qnty$l        qtde_total_pecas,
                    brnfe941.t$tamt$l        vlr_total_batimento,
                    brnfe940.t$stat$l        cod_status_NFE,
                    Status_NFE.DESCR         dsc_status_NFE,

                    brnfe940.t$stpr$c        cod_status_pre_recebimento,
                    StatusPreRec.descr       dsc_status_pre_recebimento,

                    CASE WHEN brnfe940.t$stpr$c = 3 
                           THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(brnfe940.t$fcdt$c, 
                                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                                    AT time zone 'America/Sao_Paulo') AS DATE) 
                    END                      data_status_altera_erro,

                    CASE WHEN Trunc(brnfe940.t$sdat$c) = '01/01/1970'
                           THEN NULL
                         ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(brnfe940.t$sdat$c, 
                                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                                   AT time zone 'America/Sao_Paulo') AS DATE)
                    END                      data_status_altera_agenda

               FROM baandb.tbrnfe940301  brnfe940

         INNER JOIN ( select sum(l.t$qnty$l) t$qnty$l, 
                             sum(l.t$tamt$l) t$tamt$l,
                             l.t$fire$l
                        from baandb.tbrnfe941301 l
                    group by l.t$fire$l ) brnfe941
                 ON brnfe941.t$fire$l = brnfe940.t$fire$l
                     
          LEFT JOIN baandb.tznnfe007301 znnfe007
                 ON brnfe941.t$fire$l = znnfe007.t$fire$c 
                 
          LEFT JOIN baandb.ttdpur401301 tdpur401 
                 ON tdpur401.t$orno = znnfe007.t$orno$c 
                AND tdpur401.t$pono = znnfe007.t$pono$c 
                AND tdpur401.t$sqnb = znnfe007.t$seqn$c
          
          LEFT JOIN baandb.ttdpur400301 tdpur400
                 ON tdpur400.t$orno = znnfe007.t$orno$c 

          LEFT JOIN baandb.ttcmcs065301 tcmcs065
                 ON tcmcs065.t$cwoc = tdpur400.t$cofc

          LEFT JOIN baandb.ttccom130301 tccom130
                 ON tccom130.t$cadr = tcmcs065.t$cadr

          LEFT JOIN baandb.tznfmd001301 znfmd001
                 ON znfmd001.t$fovn$c = tccom130.t$fovn$l

          LEFT JOIN ( SELECT d.t$cnst CODE,
                             l.t$desc DESCR
                        FROM baandb.tttadv401000 d,      
                             baandb.tttadv140000 l
                       WHERE d.t$cpac = 'zn'      
                         AND d.t$cdom = 'nfe.stpr.c'     
                         AND l.t$clan = 'p'
                         AND l.t$cpac = 'zn'      
                         AND l.t$clab = d.t$za_clab      
                         AND rpad(d.t$vers,4) ||  
                             rpad(d.t$rele,2) ||  
                             rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||    
                                                             rpad(l1.t$rele,2) ||    
                                                             rpad(l1.t$cust,4))      
                                                    from baandb.tttadv401000 l1      
                                                   where l1.t$cpac = d.t$cpac 
                                                     and l1.t$cdom = d.t$cdom )      
                         AND rpad(l.t$vers,4) ||  
                             rpad(l.t$rele,2) ||  
                             rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||    
                                                             rpad(l1.t$rele,2) ||    
                                                             rpad(l1.t$cust,4))      
                                                    from baandb.tttadv140000 l1      
                                                   where l1.t$clab = l.t$clab 
                                                     and l1.t$clan = l.t$clan
                                                     and l1.t$cpac = l.t$cpac ) ) StatusPreRec
                 ON StatusPreRec.CODE = brnfe940.t$stpr$c
			   
          LEFT JOIN ( SELECT d.t$cnst CODE,
                             l.t$desc DESCR
                        FROM baandb.tttadv401000 d,
                             baandb.tttadv140000 l
                       WHERE d.t$cpac = 'br'
                         AND d.t$cdom = 'nfe.tsta.l'
                         AND l.t$clan = 'p'
                         AND l.t$cpac = 'br'
                         AND l.t$clab = d.t$za_clab
                         AND rpad(d.t$vers,4) ||
                             rpad(d.t$rele,2) ||
                             rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                             rpad(l1.t$rele,2) ||
                                                             rpad(l1.t$cust,4)) 
                                                    from baandb.tttadv401000 l1 
                                                   where l1.t$cpac = d.t$cpac 
                                                     and l1.t$cdom = d.t$cdom )
                         AND rpad(l.t$vers,4) ||
                             rpad(l.t$rele,2) ||
                             rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                             rpad(l1.t$rele,2) ||
                                                             rpad(l1.t$cust,4))
                                                    from baandb.tttadv140000 l1 
                                                   where l1.t$clab = l.t$clab 
                                                     and l1.t$clan = l.t$clan 
                                                     and l1.t$cpac = l.t$cpac ) ) Status_NFE
                 ON Status_NFE.CODE = brnfe940.t$stat$l                   ) Q1
		
where Trunc(NVL(Q1.data_status_altera_erro, sysdate)) 
      Between NVL(:DtAlteraDe,  Trunc(NVL(Q1.data_status_altera_erro, sysdate))) 
          And NVL(:DtAlteraAte, Trunc(NVL(Q1.data_status_altera_erro, sysdate)))
  and Trunc(NVL(Q1.data_status_altera_agenda, sysdate)) 
      Between NVL(:DtAgendaDe,  Trunc(NVL(Q1.data_status_altera_agenda, sysdate)))
          And NVL(:DtAgendaAte, Trunc(NVL(Q1.data_status_altera_agenda, sysdate)))
  and ( (:Filial is null) OR
        ( nvl(q1.filial, 0) = :Filial ) )
  and Q1.id_fiscal Like NVL('%'  || (:CNPJ) || '%', Q1.id_fiscal)
  and Q1.cod_status_NFE = NVL(:Status, Q1.cod_status_NFE)