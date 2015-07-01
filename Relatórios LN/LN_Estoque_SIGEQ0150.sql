SELECT      
--           whinr140.t$cwar                   ARMAZEM,
           Trim(tcibd001.t$item)             ID_ITEM, 
           tcibd001.t$dsca                   NOME, 
           tcibd001.t$csig                   ITEG_SITUACAO, 
           tcibd001.t$citg                   COD_DEPTO, 
           tcmcs023.t$dsca                   DEPTO, 
           tcibd001.t$seto$c                 COD_SETOR, 
           znmcs030.t$dsca$c                 SETOR, 
           tcibd001.t$fami$c                 COD_FAMILIA, 
           znmcs031.t$dsca$c                 FAMILIA, 
           tcibd001.t$subf$c                 COD_SUB, 
           znmcs032.t$dsca$c                 SUB, 
           tcemm030.t$euca                   ID_FILIAL, 
           tcemm030.T$EUNT                   CHAVE_FILIAL, 
           CASE WHEN (tcmcs003.t$tpar$l = 2 ) 
                  THEN 'AT' 
                ELSE   'WN' 
            END                              TIPDEP, 
           sum(whinr140.t$qhnd -  
               nvl(Q2.bloc,0))               QT_FISICA,
      
           CASE WHEN tcmcs003.t$tpar$l = 2 
                  THEN 0
                ELSE   sum(nvl(Q3.roma,0))   
            END                              QT_ROMANEADA, 
   
           CASE WHEN tcmcs003.t$tpar$l = 2 
                  THEN 0
                ELSE   sum(nvl(reserva.quan, 0))
            END                              QT_RESERVADA,
           
		   GREATEST ( CASE WHEN tcmcs003.t$tpar$l = 2 
                             THEN sum(whinr140.t$qhnd - nvl(Q2.bloc,0))
                           ELSE   sum(whinr140.t$qhnd - nvl(reserva.quan, 0) - nvl(Q2.bloc,0))               
                       END, 0)               QT_SALDO, 
    
           max(Q1.mauc)                      VL_UNITARIO, 
            
           CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL 
                  THEN '00000000000000'  
                WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')) < 11 
                  THEN '00000000000000' 
                ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')  
            END                              ID_FORNECEDOR, 
           tccom100.t$nama                   FORN_NOME, 
           tccom100.t$seak                   FORN_APELIDO,
           whwmd400.t$hght * 
           whwmd400.t$wdth * 
           whwmd400.t$dpth                   M3,
           
           whwmd400.t$hght * 
           whwmd400.t$wdth * 
           whwmd400.t$dpth *
           (sum(whinr140.t$qhnd - 
                nvl(Q2.bloc,0)))             M3_TOTAL 
              
      FROM baandb.ttcibd001301 tcibd001
     
INNER JOIN baandb.twhinr140301 whinr140 
        ON whinr140.t$item   = tcibd001.t$item

 LEFT JOIN baandb.twhwmd400301 whwmd400
        ON whwmd400.t$item = tcibd001.t$item

 LEFT JOIN ( select a.t$item,
                    a.t$cwar,
                    sum(a.t$qana) quan
               from baandb.twhinp100301 a
              where a.t$koor IN (3, 34, 36)
                and a.t$kotr = 2
                and a.t$cdis$c = ' '
           group by a.t$item,
                    a.t$cwar ) reserva
        ON reserva.t$item = whinr140.t$item
       AND reserva.t$cwar = whinr140.t$cwar

 LEFT JOIN baandb.ttdipu001301 tdipu001  
        ON tdipu001.t$item = tcibd001.t$item 
      
 LEFT JOIN baandb.ttccom100301 tccom100  
        ON tccom100.t$bpid = tdipu001.t$otbp 
      
 LEFT JOIN baandb.ttccom130301 tccom130  
        ON tccom130.t$cadr = tccom100.t$cadr 

INNER JOIN baandb.ttcemm112301 tcemm112 
        ON tcemm112.t$waid   = whinr140.t$cwar 
 
INNER JOIN baandb.ttcemm030301 tcemm030 
        ON tcemm030.t$eunt   = tcemm112.t$grid 
  
INNER JOIN baandb.ttcmcs003301 tcmcs003 
        ON tcmcs003.t$cwar = whinr140.t$cwar 
  
 LEFT JOIN ( select whwmd217.t$item, 
                    b.t$cadr, 
                    case when sum(a.t$qhnd) = 0  
                           then 0 
                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
                     end mauc 
               from baandb.twhwmd217301 whwmd217  
         inner join baandb.twhinr140301 a 
                 on a.t$cwar = whwmd217.t$cwar 
                and a.t$item = whwmd217.t$item
         inner join baandb.ttcmcs003301 b 
                 on b.t$cwar = a.t$cwar 
              where whwmd217.t$mauc$1 != 0
           group by whwmd217.t$item, b.t$cadr ) Q1    
        ON Q1.t$item = whinr140.t$item 
       AND Q1.t$cadr = tcmcs003.t$cadr 
                 
 LEFT JOIN ( select whwmd630.t$item,  
                    whwmd630.t$cwar, 
                    whwmd630.t$loca,
                    sum(whwmd630.t$qbls) bloc 
               from baandb.twhwmd630301 whwmd630 
              where not exists ( SELECT *  
                                   FROM baandb.ttcmcs095301 tcmcs095 
                                  WHERE tcmcs095.t$modu = 'BOD'  
                                    AND tcmcs095.t$sumd = 0  
                                    AND tcmcs095.t$prcd = 9999 
                                    AND tcmcs095.t$koda = whwmd630.t$bloc ) 
           group by whwmd630.t$item,  
                    whwmd630.t$cwar,
                    whwmd630.t$loca ) Q2  
        ON Q2.t$item = whinr140.t$item  
       AND Q2.t$cwar = whinr140.t$cwar
       AND Q2.t$loca = whinr140.t$loca
       
 LEFT JOIN ( select whinh220.t$item,  
                    whinh220.t$cwar,  
                    sum(whinh220.t$qord) roma 
               from baandb.twhinh220301 whinh220 
              where whinh220.t$wmss = 40 
           group by whinh220.t$item,  
                    whinh220.t$cwar ) Q3  
        ON Q3.t$item = whinr140.t$item  
       AND Q3.t$cwar = whinr140.t$cwar 
      
INNER JOIN baandb.ttcmcs023301 tcmcs023 
        ON tcmcs023.t$citg   = tcibd001.t$citg 
 
INNER JOIN baandb.tznmcs030301 znmcs030 
        ON znmcs030.t$citg$c = tcibd001.t$citg  
       AND znmcs030.t$seto$c = tcibd001.t$seto$c 
 
INNER JOIN baandb.tznmcs031301 znmcs031 
        ON znmcs031.t$citg$c = tcibd001.t$citg  
       AND znmcs031.t$seto$c = tcibd001.t$seto$c  
       AND znmcs031.t$fami$c = tcibd001.t$fami$c 
 
INNER JOIN baandb.tznmcs032301 znmcs032 
        ON znmcs032.t$citg$c = tcibd001.t$citg  
       AND znmcs032.t$seto$c = tcibd001.t$seto$c  
       AND znmcs032.t$fami$c = tcibd001.t$fami$c 
       AND znmcs032.t$subf$c = tcibd001.t$subf$c 
                
     WHERE tcemm112.t$loco = 301
      AND tcemm030.T$EUNT IN (:Filial)
      AND tcibd001.t$citg IN (:Depto)
      AND CASE WHEN tcmcs003.t$tpar$l = 2 
                 THEN 'AT' 
               ELSE   'WN' 
           END IN (:TipRestricao)
      AND tcmcs003.t$tpar$l IN (:TipoArmazem)

--     AND (LTRIM(RTRIM(tcibd001.t$item)) = '2063315' )
--      AND (LTRIM(RTRIM(tcibd001.t$item)) = '1804966')
    HAVING sum(whinr140.t$qhnd - nvl(Q2.bloc,0)) > 0 
   

      
  GROUP BY CASE WHEN tcmcs003.t$tpar$l = 2 
                  THEN 'AT' 
                ELSE   'WN' 
            END,
           tcmcs003.t$tpar$l,
           Trim(tcibd001.t$item),  
           tcibd001.t$dsca,  
           tcibd001.t$csig,  
           tcibd001.t$citg, 
           tcmcs023.t$dsca, 
           tcibd001.t$seto$c,  
           znmcs030.t$dsca$c,  
           tcibd001.t$fami$c,   
           znmcs031.t$dsca$c,  
           tcibd001.t$subf$c,  
           znmcs032.t$dsca$c,  
           tcemm030.t$euca, 
           tcemm030.T$EUNT, 
           tccom130.t$fovn$l,  
           tccom100.t$nama,  
           tccom100.t$seak,
           whwmd400.t$hght, 
           whwmd400.t$wdth, 
           whwmd400.t$dpth
--           whinr140.t$cwar
UNION 
      
    SELECT 
--           whwmd630.t$cwar                   ARMAZEM,
           Trim(tcibd001.t$item)             ID_ITEM, 
           tcibd001.t$dsca                   NOME, 
           tcibd001.t$csig                   ITEG_SITUACAO, 
           tcibd001.t$citg                   COD_DEPTO, 
           tcmcs023.t$dsca                   DEPTO, 
           tcibd001.t$seto$c                 COD_SETOR, 
           znmcs030.t$dsca$c                 SETOR, 
           tcibd001.t$fami$c                 COD_FAMILIA, 
           znmcs031.t$dsca$c                 FAMILIA, 
           tcibd001.t$subf$c                 COD_SUB, 
           znmcs032.t$dsca$c                 SUB, 
           tcemm030.t$euca                   ID_FILIAL, 
           tcemm030.T$EUNT                   CHAVE_FILIAL, 
           whwmd630.t$bloc                   TIPDEP, 
           sum(whwmd630.t$qbls)              QT_FISICA,
           0                                 QT_ROMANEADA, 
           sum(nvl(reserva.quan,0))          QT_RESERVADA,
           GREATEST ( sum(whwmd630.t$qbls) -
                      sum(nvl(reserva.quan,0)), 0 )
                                             QT_SALDO, 
           max(Q1.mauc)                      VL_UNITARIO, 
           CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL 
                  THEN '00000000000000'  
                WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')) < 11 
                  THEN '00000000000000' 
                ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')  
            END                              ID_FORNECEDOR, 
           tccom100.t$nama                   FORN_NOME, 
           tccom100.t$seak                   FORN_APELIDO,
           whwmd400.t$hght * 
           whwmd400.t$wdth * 
           whwmd400.t$dpth                   M3,
           
           whwmd400.t$hght * 
           whwmd400.t$wdth * 
           whwmd400.t$dpth *
           sum(whwmd630.t$qbls)              M3_TOTAL
           
      FROM baandb.ttcibd001301 tcibd001 
     
 LEFT JOIN baandb.ttdipu001301 tdipu001  
        ON tdipu001.t$item = tcibd001.t$item 

LEFT JOIN baandb.twhwmd400301 whwmd400
        ON whwmd400.t$item = tcibd001.t$item
   
 LEFT JOIN baandb.ttccom100301 tccom100  
        ON tccom100.t$bpid = tdipu001.t$otbp 
   
 LEFT JOIN baandb.ttccom130301 tccom130  
        ON tccom130.t$cadr = tccom100.t$cadr 
   
INNER JOIN baandb.twhwmd630301 whwmd630 
        ON whwmd630.t$item   = tcibd001.t$item 

 LEFT JOIN ( select a.t$item,
                    a.t$cwar,
                    a.t$cdis$c,
                    sum(a.t$qana) quan
               from baandb.twhinp100301 a
              where a.t$koor IN(3, 34, 36)
                and a.t$kotr = 2
           group by a.t$item,
                    a.t$cwar,
                    a.t$cdis$c ) reserva
        ON reserva.t$item = whwmd630.t$item
       AND reserva.t$cwar = whwmd630.t$cwar
       AND reserva.t$cdis$c = whwmd630.t$bloc
 
INNER JOIN baandb.ttcemm112301 tcemm112 
        ON tcemm112.t$waid   = whwmd630.t$cwar 
 
INNER JOIN baandb.ttcemm030301 tcemm030 
        ON tcemm030.t$eunt   = tcemm112.t$grid 

INNER JOIN baandb.ttcmcs003301 tcmcs003 
        ON tcmcs003.t$cwar = whwmd630.t$cwar 
 
 LEFT JOIN ( select whwmd217.t$item, 
                    b.t$cadr, 
                    case when sum(a.t$qhnd) = 0  
                           then 0 
                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
                     end mauc 
               from baandb.twhwmd217301 whwmd217  
         inner join baandb.twhinr140301 a 
                 on a.t$cwar = whwmd217.t$cwar 
                and a.t$item = whwmd217.t$item
         inner join baandb.ttcmcs003301 b 
                 on b.t$cwar = a.t$cwar 
              where whwmd217.t$mauc$1 != 0
           group by whwmd217.t$item, b.t$cadr ) Q1    
        ON Q1.t$item = whwmd630.t$item  
       AND Q1.t$cadr = tcmcs003.t$cadr 
              
INNER JOIN baandb.ttcmcs023301 tcmcs023 
        ON tcmcs023.t$citg   = tcibd001.t$citg 
 
INNER JOIN baandb.tznmcs030301 znmcs030 
        ON znmcs030.t$citg$c = tcibd001.t$citg  
       AND znmcs030.t$seto$c = tcibd001.t$seto$c  
 
INNER JOIN baandb.tznmcs031301 znmcs031 
        ON znmcs031.t$citg$c = tcibd001.t$citg  
       AND znmcs031.t$seto$c = tcibd001.t$seto$c  
       AND znmcs031.t$fami$c = tcibd001.t$fami$c 
 
INNER JOIN baandb.tznmcs032301 znmcs032 
        ON znmcs032.t$citg$c = tcibd001.t$citg  
       AND znmcs032.t$seto$c = tcibd001.t$seto$c  
       AND znmcs032.t$fami$c = tcibd001.t$fami$c 
       AND znmcs032.t$subf$c = tcibd001.t$subf$c 
     
     WHERE tcemm112.t$loco = 301 
       AND (whwmd630.t$qbls > 0) 
       AND NOT EXISTS ( select *  
                          from baandb.ttcmcs095301 tcmcs095 
                         where tcmcs095.t$modu = 'BOD'  
                           and tcmcs095.t$sumd = 0  
                           and tcmcs095.t$prcd = 9999 
                           and tcmcs095.t$koda = whwmd630.t$bloc ) 
--        AND (LTRIM(RTRIM(tcibd001.t$item)) = '2063315')
--         AND (LTRIM(RTRIM(tcibd001.t$item)) = '1804966')
       
      AND tcemm030.T$EUNT IN (:Filial)
      AND tcibd001.t$citg IN (:Depto)
      AND whwmd630.t$bloc IN (:TipRestricao)
      AND tcmcs003.t$tpar$l IN (:TipoArmazem)

  GROUP BY Trim(tcibd001.t$item),  
           tcibd001.t$dsca,  
           tcibd001.t$csig,  
           tcibd001.t$citg, 
           tcmcs023.t$dsca,  
           tcibd001.t$seto$c,  
           znmcs030.t$dsca$c,  
           tcibd001.t$fami$c,   
           znmcs031.t$dsca$c,  
           tcibd001.t$subf$c,  
           znmcs032.t$dsca$c,  
           tcemm030.t$euca, 
           tcemm030.T$EUNT, 
           whwmd630.t$bloc,  
           tccom130.t$fovn$l,  
           tccom100.t$nama,  
           tccom100.t$seak,
           whwmd400.t$hght, 
           whwmd400.t$wdth, 
           whwmd400.t$dpth,
           whwmd630.t$item
--           whwmd630.t$cwar
