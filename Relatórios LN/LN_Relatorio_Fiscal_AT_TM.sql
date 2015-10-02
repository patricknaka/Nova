select Q1.* 
  from  ( SELECT DISTINCT
                 301                        CIA,
                 tcemm030.t$euca            ID_FILIAL,  

                 tcemm030.T$EUNT ||
                 ' - '           ||
                 tcemm030.t$dsca            CHAVE_NM_FILIAL,
     
                 Trim(cisli941.t$item$l)    ID_ITEM,
                 Trim(tcibd001.t$dscb$c)    DESC_ITEM,
                 cisli941.t$dqua$l          QTD_FIS,
                 cisli941.t$pric$l          PR_UNIT,
                 tcibd001.t$ceat$l          COD_EAN,
                 tcibd001.t$citg            ID_DEPTO,
                 tcmcs023.t$dsca            NOME_DEPTO,
                 znmcs030.t$seto$c          COD_SETOR,
                 znmcs030.t$dsca$c          NOME_SETOR,
                 cisli941.t$cwar$l          ID_ARMAZEM,
                 tcmcs003.t$dsca            NOME_ARMAZEM,
                 cisli940.t$bpid$l          CLIE_FAT,
                 cisli940.t$fids$l          CLIE_NOME,
                 cisli940.t$docn$l          ID_NOTA,
                 cisli940.t$seri$l          ID_SERIE,
                 TIPO.                      ID_DOC,
                 cisli941.t$line$l          LINHA_REF,
     
                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)  
                                            DT_NF,     
                 STATUS.DESCR               SITUACAO_NF,           
                 cisli941.t$ccfo$l          ID_CFOP,
                 tcmcs940.t$dsca$l          DESC_CFOP,
                 cisli940.t$fdty$l          TIPO_DOCTO_FIS, 
                 FGET.                      DESC_TIPO_DOC_FIS,
                 cisli940.t$fdtc$l          COD_TIPO_DOC_REMESSA,
                 tcmcs966.t$dsca$l          DESC_COD_TIPO_DOC_REMESSA,
     
                 CASE WHEN tdrec940.t$docn$l is null
                        THEN 'Não'
                      ELSE   'Sim'
                 END                        ENTRADA,
                 tdrec955.t$lfir$l          REF_REC,
                 tdrec955.t$llin$l          LIN_REC,
                 tdrec940.t$docn$l          NF_ENTRADA,
                 tdrec940.t$seri$l          SERI_NF_ENTRADA,
                 NOTA_ENT.CNST              COD_STATUS_REC,
                 NOTA_ENT.STATUS            DSC_STATUS_REC
                 
            FROM baandb.tcisli940301  cisli940  
           
       LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOC_FIS
                     FROM baandb.tttadv401000 d, 
                          baandb.tttadv140000 l 
                    WHERE d.t$cpac = 'ci' 
                      AND d.t$cdom = 'sli.tdff.l'
                      AND l.t$clan = 'p'
                      AND l.t$cpac = 'ci'
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
                                                  and l1.t$cpac = l.t$cpac ) ) FGET
              ON cisli940.t$fdty$l = FGET.CNST

       LEFT JOIN ( SELECT d.t$cnst CNST, 
                          l.t$desc ID_DOC
                     FROM baandb.tttadv401000 d, 
                          baandb.tttadv140000 l 
                    WHERE d.t$cpac = 'tc' 
                      AND d.t$cdom = 'doty.l'
                      AND l.t$clan = 'p'
                      AND l.t$cpac = 'tc'
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
                                                  and l1.t$cpac = l.t$cpac ) ) TIPO
              ON cisli940.t$doty$l = TIPO.CNST
     
    LEFT JOIN ( SELECT d.t$cnst CNST, 
                         l.t$desc DESCR
                    FROM baandb.tttadv401000 d, 
                         baandb.tttadv140000 l 
                   WHERE d.t$cpac = 'ci' 
                     AND d.t$cdom = 'sli.stat'
                     AND l.t$clan = 'p'
                     AND l.t$cpac = 'ci'
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
                                                 and l1.t$cpac = l.t$cpac ) ) STATUS
              ON cisli940.t$stat$l = STATUS.CNST
              
      INNER JOIN baandb.tcisli941301 cisli941
              ON cisli940.t$fire$l = cisli941.t$fire$l
  
       LEFT JOIN baandb.ttcmcs940301 tcmcs940
              ON tcmcs940.T$OFSO$L = cisli941.t$ccfo$l

      INNER JOIN baandb.ttcibd001301 tcibd001
              ON tcibd001.t$item = cisli941.t$item$l  
                   
      INNER JOIN baandb.tznmcs030301 znmcs030
              ON znmcs030.t$citg$c = tcibd001.t$citg
             AND znmcs030.t$seto$c = tcibd001.t$seto$c
                          
      INNER JOIN baandb.ttcemm124301 tcemm124
              ON tcemm124.t$cwoc  = cisli940.t$cofc$l 

      INNER JOIN baandb.ttcemm030301 tcemm030
              ON tcemm030.t$eunt = tcemm124.t$grid
        
      INNER JOIN baandb.ttcmcs023301 tcmcs023
              ON tcmcs023.t$citg = tcibd001.t$citg
  
      INNER JOIN baandb.tznmcs031301 znmcs031
              ON znmcs031.t$citg$c = tcibd001.t$citg 
             AND znmcs031.t$seto$c = tcibd001.t$seto$c 
             AND znmcs031.t$fami$c = tcibd001.t$fami$c
 
       LEFT JOIN baandb.ttcmcs966301 tcmcs966
              ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l
      
       LEFT JOIN baandb.ttcmcs003301 tcmcs003
              ON tcmcs003.t$cwar = cisli941.t$cwar$l
              
       LEFT JOIN baandb.ttdrec955301 tdrec955
              ON tdrec955.t$fire$l = cisli941.t$fire$l
             AND tdrec955.t$line$l = cisli941.t$line$l
             AND tdrec955.t$sern$l = 1
      
      LEFT JOIN baandb.ttdrec940301 tdrec940
             ON tdrec940.t$fire$l = tdrec955.t$lfir$l
             
      LEFT JOIN ( select 0                    CNST, 
                         'Sem NF de Entrada'  STATUS
                    from Dual
                   UNION 
                  select d.t$cnst CNST, l.t$desc STATUS
                    from baandb.tttadv401000 d, 
                         baandb.tttadv140000 l 
                   where d.t$cpac = 'td' 
                     and d.t$cdom = 'rec.stat.l'
                     and l.t$clan = 'p'
                     and l.t$cpac = 'td'
                     and l.t$clab = d.t$za_clab
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
                                                 and l1.t$cpac = l.t$cpac )
                order by 2 ) NOTA_ENT
              ON NVL(tdrec940.t$stat$l, 0) = NOTA_ENT.CNST
              
           WHERE cisli940.t$stat$l = 6
             AND cisli940.t$fdty$l = 17
             AND tcemm124.t$dtyp = 1
             AND STATUS.CNST IN (:StatusNF)
			 
        ORDER BY CHAVE_NM_FILIAL, ID_ITEM ) Q1
          
where ID_FILIAL in (:Filial)
  and ENTRADA in (:Entrada)
  and trunc(DT_NF) 
      between :DataEmissaoNFDe
          and :DataEmissaoNFAte
  and Q1.COD_STATUS_REC IN (:Status)