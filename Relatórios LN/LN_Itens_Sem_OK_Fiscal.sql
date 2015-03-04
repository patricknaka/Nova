SELECT  
    tcibd001.t$citg                      CODE_DEPARTAM,  
    tcmcs023.t$dsca                      DESC_DEPARTAM,  
    tcibd001.t$seto$c                    CODE_SETOR,  
    znmcs030.t$dsca$c                    DESC_SETOR,     
    tcibd001.t$kitm                      CODE_CONTR,  
    DESC_DOMAIN_KITM.DESC_CONTR          DESC_CONTR,
    Trim(tcibd001.t$item)                CODE_ITEM,     
    tcibd001.t$dsca                      DESC_ITEM,
    tcibd936.t$sour$l                    COD_PROCED,     
    DESC_DOMAIN_SOUR.DESC_PROCED         DESC_PROCED,
    301                                  CODE_CIA,            
    tccom130.t$fovn$l                    CNPJ_FORN,      
    tccom100.t$nama                      DESC_FORN,        
    tcibd001.t$csig                      CODE_STATUS,
    tcmcs018.T$DSCA                      DESC_STATUS,
    tcibd936.t$frat$l                    COD_NBM,
    
    ( SELECT znibd007.t$LOGN$C 
        FROM baandb.tznibd007301 znibd007 
       WHERE znibd007.t$item$C = TCIBD001.t$ITEM 
         AND znibd007.t$DATA$C = ( select min(a.t$DATA$C) 
                                     from baandb.tznibd007301 a 
                                    where a.t$item$c = znibd007.t$item$C ) 
         AND ROWNUM = 1 )                CODE_USUA,
    
    ( SELECT ln_user.t$NAME 
        FROM baandb.tznibd007301 znibd007, 
             baandb.tttaad200000 ln_user 
       WHERE znibd007.t$item$C = TCIBD001.t$ITEM 
         AND ln_user.t$USER = znibd007.t$LOGN$C 
         AND znibd007.t$DATA$C = ( select min(a.t$DATA$C) 
                                     from baandb.tznibd007301 a 
                                    where a.t$item$c = znibd007.t$item$C ) 
         AND ROWNUM = 1 )                DESCR_USUA,
         
    tccom100.t$okfi$c                    CODE_OKFI,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$dtcr$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                         DATE_INCL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$lmdt, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                         DATA_ALTER         

FROM       baandb.ttccom100301 tccom100

INNER JOIN baandb.ttdipu001301 tdipu001
        ON tdipu001.t$otbp   = tccom100.t$bpid    
  
INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item   = tdipu001.t$item

INNER JOIN baandb.ttcmcs023301 tcmcs023
        ON tcibd001.t$citg   = tcmcs023.t$citg

INNER JOIN baandb.tznmcs030301 znmcs030
        ON tcibd001.t$seto$c = znmcs030.t$seto$c
       AND tcibd001.t$citg   = znmcs030.t$citg$c

INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr   = tccom100.t$cadr

INNER JOIN baandb.ttcibd936301 tcibd936
        ON tcibd001.t$ifgc$l = tcibd936.t$ifgc$l
        
LEFT JOIN baandb.ttcmcs018301 tcmcs018
       ON tcmcs018.t$csig   = tcibd001.t$csig

 LEFT JOIN  ( SELECT d.t$cnst COD_DOMAIN_KITM, 
                     l.t$desc DESC_CONTR 
                FROM baandb.tttadv401000 d, 
                     baandb.tttadv140000 l 
               WHERE d.t$cpac = 'tc' 
                 AND d.t$cdom = 'kitm' 
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
                                             and l1.t$cpac = l.t$cpac ) ) DESC_DOMAIN_KITM
        ON DESC_DOMAIN_KITM.COD_DOMAIN_KITM = tcibd001.t$kitm
                     
 LEFT JOIN  ( SELECT d.t$cnst COD_DOMAIN_SOUR, 
                     l.t$desc DESC_PROCED 
                FROM baandb.tttadv401000 d, 
                     baandb.tttadv140000 l 
               WHERE d.t$cpac = 'tc' 
                 AND d.t$cdom = 'sour.l' 
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
                                             and l1.t$cpac = l.t$cpac ) ) DESC_DOMAIN_SOUR
        ON DESC_DOMAIN_SOUR.COD_DOMAIN_SOUR = tcibd936.t$sour$l
    
WHERE tcibd001.T$OKFI$C != 1
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$dtcr$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)) BETWEEN :DataInclusaoDe AND :DataInclusaoAte
  AND ( (tcibd001.t$citg = :Depto) or (:Depto = 0) )