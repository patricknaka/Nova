SELECT 
  DISTINCT 
    tcemm030.t$euca                                  NUME_FILIAL,
    tccom130.t$fovn$l                                CNPJ_FILIAL, 
    tdrec940.t$fire$l                                NUME_RFISCAL,

    CASE WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 
              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) < '01/01/1980'
           THEN NULL
         ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l, 'DD-MON-YYYY HH24:MI:SS'), 
              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
     END                                             DATA_NR,
 
    CASE WHEN tdrec947.t$oorg$l = 1 
           THEN ( select distinct 
                         a.t$fdty$l 
                    from baandb.tcisli940201 a, 
                         baandb.tcisli245201 b
                   where b.t$slso = tdrec947.t$orno$l
                     and b.t$pono = tdrec947.t$pono$l
                     and b.t$fire$l = a.t$fire$l )
         ELSE tdrec940.t$rfdt$l     
     END                                             TP_DOCTO_FISCAL,

    CASE WHEN tdrec947.t$oorg$l = 1 
           THEN TIPO_OPERACAO_A.DS_TIPO_OPERACAO
         ELSE   TIPO_OPERACAO_B.DS_TIPO_OPERACAO
     END                                             DESCR_TP_DOCTO_FISCAL,

    tdrec940.t$stat$l                                STAT_RFISCAL, 
    DESC_STAT_RFISCAL, 
    tccom130.t$ftyp$l                                TP_FORNECEDOR,
    tdrec940.t$fovn$l                                CNPJ_FORNECEDOR,  
    tdrec940.t$bpid$l                                DESC_FORNECEDOR,    
    tdrec940.t$opfc$l                                NUME_CCFO,  
    TO_CHAR(tdrec940.t$idat$l, 'MM')                 MES_EMISSAO,  
    tdrec940.t$docn$l                                NUME_NOTA,
    tdrec940.t$seri$l                                SERIE_NOTA,  
    tdrec949.t$amnt$l                                VALOR_ICMS, 
    tdrec940.t$tfda$l                                VALOR_TOTAL,  
    tdrec940.t$lipl$l                                PLACA_CAMINHAO,  
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 'DD-MON-YYYY HH24:MI:SS'), 
    'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                                     DATA_EMISSAO,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 'DD-MON-YYYY HH24:MI:SS'), 
    'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                                     DATA_REGISTRO
FROM       baandb.ttdrec940201 tdrec940  

INNER JOIN baandb.ttdrec947201 tdrec947
        ON tdrec947.t$fire$l = tdrec940.t$fire$l

INNER JOIN baandb.ttcemm124201 tcemm124
        ON tcemm124.t$cwoc = tdrec940.t$cofc$l 

INNER JOIN baandb.ttcemm030201 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid  
  
INNER JOIN baandb.ttccom100201 tccom100
        ON tccom100.t$bpid = tdrec940.t$bpid$l
  
INNER JOIN baandb.ttdrec949201 tdrec949
        ON tdrec949.t$fire$l = tdrec940.t$fire$l

 LEFT JOIN baandb.tttaad200000 ttaad200
        ON ttaad200.t$user = tdrec940.t$logn$l
  
 LEFT JOIN baandb.ttccom130201 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr
    
INNER JOIN ( SELECT d.t$cnst CODE_STAT, 
                    l.t$desc DESC_STAT_RFISCAL
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'td' 
                AND d.t$cdom = 'rec.stat.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'td'
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
                                            and l1.t$cpac = l.t$cpac ) ) iTABLE
        ON iTABLE.CODE_STAT = tdrec940.t$stat$l

 LEFT JOIN ( select l.t$desc DS_TIPO_OPERACAO,
                    b.t$slso,
                    b.t$pono
               from baandb.tcisli940201 a, 
                    baandb.tcisli245201 b,
                    baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where b.t$fire$l = a.t$fire$l
                and d.t$cnst = a.t$fdty$l 
                and l.t$clab = d.t$za_clab
                and d.t$cpac = 'ci'
                and d.t$cdom = 'sli.tdff.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'ci'
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) TIPO_OPERACAO_A
        ON TIPO_OPERACAO_A.t$slso = tdrec947.t$orno$l
       AND TIPO_OPERACAO_A.t$pono = tdrec947.t$pono$l
    
 LEFT JOIN (  select l.t$desc DS_TIPO_OPERACAO,
                     d.t$orno$l,
                     d.t$pono$l 
                from baandb.ttdrec940201 c, 
                     baandb.ttdrec947201 d,
                     baandb.tttadv401000 d,
                     baandb.tttadv140000 l
               where d.t$fire$l = c.t$fire$l
                 and d.t$cnst = c.t$rfdt$l 
                 and l.t$clab = d.t$za_clab
                 and d.t$cpac = 'td'   
                 and d.t$cdom = 'rec.trfd.l'    
                 and l.t$clan = 'p'
                 and l.t$cpac = 'td'    
                 and rpad(d.t$vers,4) ||
                     rpad(d.t$rele,2) ||
                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                     rpad(l1.t$rele,2) ||
                                                     rpad(l1.t$cust,4)) 
                                            from baandb.tttadv401000 l1 
                                           where l1.t$cpac = d.t$cpac 
                                             and l1.t$cdom = d.t$cdom )
                 and rpad(l.t$vers,4) ||
                     rpad(l.t$rele,2) ||
                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                     rpad(l1.t$rele,2) || 
                                                     rpad(l1.t$cust,4)) 
                                            from baandb.tttadv140000 l1 
                                           where l1.t$clab = l.t$clab 
                                             and l1.t$clan = l.t$clan 
                                             and l1.t$cpac = l.t$cpac ) ) TIPO_OPERACAO_B
        ON TIPO_OPERACAO_B.t$orno$l = tdrec947.t$orno$l
       AND TIPO_OPERACAO_B.t$pono$l = tdrec947.t$pono$l
    
WHERE tcemm124.t$dtyp = 1 
  AND tdrec949.t$brty$l = 1
  AND tdrec940.t$rfdt$l = 22 -- Conhec. Transp. Rodoviário
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 
            'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) 
			Between :DataEmissaoDe 
			    And :DataEmissaoAte