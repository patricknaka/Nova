select Q1.*
  from ( SELECT
           DISTINCT
             brnfe940.t$fovn$l     id_fiscal,
             brnfe940.t$fids$l     razao_social,
             brnfe940.t$fire$l     num_rascunho,
             znnfe007.t$orno$c     num_pedido,
             brnfe940.t$docn$l     num_nota_fiscal,
             brnfe940.t$fdot$l     natureza_oper,
             brnfe940.t$idat$l     data_fiscal,                    
             brnfe940.t$slog$c     login_usuário,
             tdpur400.t$cdec       linha_doc_fiscal,
             tdpur400.t$cofc       departamento,
             brnfe940.t$idat$l     data_emissao_nf,
             brnfe941.t$qnty$l     qtde_total_pecas,
             brnfe941.t$tamt$l     vlr_total_batimento,
             brnfe940.t$stat$l     status_batimento,
         	
             CASE WHEN brnfe940.t$stpr$c = 3 
                    THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(brnfe940.t$fcdt$c, 
                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                             AT time zone 'America/Sao_Paulo') AS DATE) 
              END                  data_status_altera_erro,
         						  
             CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(brnfe940.t$sdat$c, 
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                 AT time zone 'America/Sao_Paulo') AS DATE) 
                                   data_status_altera_agenda
         
         FROM       baandb.tbrnfe940301  brnfe940
         
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
          
          LEFT JOIN baandb.ttccom100301 tccom100
                 ON tccom100.t$bpid = tdpur400.t$otbp 
          
          LEFT JOIN baandb.ttccom130301 tccom130
                 ON tccom130.t$cadr = tdpur400.t$otad ) Q1
		
where Trunc(NVL(Q1.data_status_altera_erro, sysdate)) 
      Between NVL(:DtAlteraDe,  Trunc(NVL(Q1.data_status_altera_erro, sysdate))) 
          And NVL(:DtAlteraAte, Trunc(NVL(Q1.data_status_altera_erro, sysdate)))
  and Trunc(NVL(Q1.data_status_altera_agenda, sysdate)) 
      Between NVL(:DtAgendaDe,  Trunc(NVL(Q1.data_status_altera_agenda, sysdate)))
          And NVL(:DtAgendaAte, Trunc(NVL(Q1.data_status_altera_agenda, sysdate)))
  and ( (:Filial is null) OR
        ( (case when q1.departamento is null
                  then 'N/A' 
                else Upper(q1.departamento) 
           end) = Upper(:Filial) ) )
  and Q1.id_fiscal Like NVL('%'  || (:CNPJ) || '%', Q1.id_fiscal)
  and Q1.status_batimento = NVL(:Status, Q1.status_batimento) 