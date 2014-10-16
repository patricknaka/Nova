SELECT Q1.*
   FROM ( SELECT Trim(tcibd001.t$item)             ID_ITEM,
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
                 'WN'                              TIPDEP,
                 sum(whwmd215.t$qhnd - 
                     nvl(Q2.bloc,0))               QT_FISICA,
                 sum(nvl(Q3.roma,0))               QT_ROMANEADA,
                 sum(whwmd215.t$qall)              QT_RESERVADA,
                 sum(whwmd215.t$qhnd - 
                     whwmd215.t$qall - 
                     nvl(Q2.bloc,0))               QT_SALDO,
                 Round(max(Q1.mauc), 4)            VL_UNITARIO,
                 
                 CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
                        THEN '00000000000000' 
                      WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')) < 11
                        THEN '00000000000000'
                      ELSE   regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') 
                  END                              ID_FORNECEDOR,
                 tccom100.t$nama                   FORN_NOME,
                 tccom100.t$seak                   FORN_APELIDO
                  
            FROM baandb.ttcibd001301 tcibd001
          
       LEFT JOIN baandb.ttdipu001301 tdipu001 
              ON tdipu001.t$item = tcibd001.t$item
           
       LEFT JOIN baandb.ttccom100301 tccom100 
              ON tccom100.t$bpid = tdipu001.t$otbp
           
       LEFT JOIN baandb.ttccom130301 tccom130 
              ON tccom130.t$cadr = tccom100.t$cadr
          
      INNER JOIN baandb.twhwmd215301 whwmd215
              ON whwmd215.t$item = tcibd001.t$item
   
      INNER JOIN baandb.ttcemm112301 tcemm112
              ON tcemm112.t$waid = whwmd215.t$cwar
      
      INNER JOIN baandb.ttcemm030301 tcemm030
              ON tcemm030.t$eunt = tcemm112.t$grid
      
       LEFT JOIN ( select a.t$item ITEM, 
                          c.t$grid GRID, 
                          sum(a.t$mauc$1 * b.t$qstk) / sum(b.t$qstk) MAUC
                     from baandb.twhina113301 a, 
                          baandb.twhina112301 b, 
                          baandb.ttcemm112301 c
                    where a.t$item = b.t$item
                      and a.t$cwar = b.t$cwar
                      and a.t$trdt = b.t$trdt
                      and a.t$seqn = b.t$seqn
                      and a.t$inwp = b.t$inwp
                      and c.t$waid = a.t$cwar
                 group by a.t$item, c.t$grid ) Q1 
              ON Q1.item = whwmd215.t$item 
             AND Q1.grid = tcemm112.t$grid
                     
       LEFT JOIN ( select whwmd630.t$item, 
                          whwmd630.t$cwar, 
                          sum(whwmd630.t$qbls) bloc
                     from baandb.twhwmd630301 whwmd630
                    where not exists ( SELECT * 
                                         FROM baandb.ttcmcs095301 tcmcs095
                                        WHERE tcmcs095.t$modu = 'BOD' 
                                          AND tcmcs095.t$sumd = 0 
                                          AND tcmcs095.t$prcd = 9999
                                          AND tcmcs095.t$koda = whwmd630.t$bloc )
                 group by whwmd630.t$item, 
                          whwmd630.t$cwar ) Q2 
              ON Q2.t$item = whwmd215.t$item 
             AND Q2.t$cwar = whwmd215.t$cwar
           
       LEFT JOIN ( select whinh220.t$item, 
                          whinh220.t$cwar, 
                          sum(whinh220.t$qord) roma
                    from baandb.twhinh220301 whinh220
                   where whinh220.t$wmss = 40
                group by whinh220.t$item, 
                         whinh220.t$cwar ) Q3 
              ON Q3.t$item = whwmd215.t$item 
             AND Q3.t$cwar = whwmd215.t$cwar
      
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
    
          HAVING sum(whwmd215.t$qhnd - nvl(Q2.bloc,0)) > 0
          
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
                 tccom130.t$fovn$l, 
                 tccom100.t$nama, 
                 tccom100.t$seak
          
UNION
          
          SELECT Trim(tcibd001.t$item)             ID_ITEM,
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
                 0                                 QT_RESERVADA,
                 0                                 QT_SALDO,
                 Round(sum(Q1.mauc), 4)            VL_UNITARIO,
                 CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
                        THEN '00000000000000' 
                      WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')) < 11
                        THEN '00000000000000'
                      ELSE   regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') 
                  END                              ID_FORNECEDOR,
                 tccom100.t$nama                   FORN_NOME,
                 tccom100.t$seak                   FORN_APELIDO
                  
            FROM baandb.ttcibd001301 tcibd001
          
       LEFT JOIN baandb.ttdipu001301 tdipu001 
              ON tdipu001.t$item = tcibd001.t$item
        
       LEFT JOIN baandb.ttccom100301 tccom100 
              ON tccom100.t$bpid = tdipu001.t$otbp
        
       LEFT JOIN baandb.ttccom130301 tccom130 
              ON tccom130.t$cadr = tccom100.t$cadr
        
      INNER JOIN baandb.twhwmd630301 whwmd630
              ON whwmd630.t$item = tcibd001.t$item
    
      INNER JOIN baandb.ttcemm112301 tcemm112
              ON tcemm112.t$waid = whwmd630.t$cwar
      
      INNER JOIN baandb.ttcemm030301 tcemm030
              ON tcemm030.t$eunt = tcemm112.t$grid
        
       LEFT JOIN ( select a.t$item ITEM, 
                          c.t$grid GRID, 
                          sum(a.t$mauc$1 * b.t$qstk) / sum(b.t$qstk) MAUC
                     from baandb.twhina113301 a, 
                          baandb.twhina112301 b, 
                          baandb.ttcemm112301 c
                    where a.t$item = b.t$item
                      and a.t$cwar = b.t$cwar
                      and a.t$trdt = b.t$trdt
                      and a.t$seqn = b.t$seqn
                      and a.t$inwp = b.t$inwp
                      and c.t$waid = a.t$cwar
                 group by a.t$item, c.t$grid ) Q1 
              ON Q1.item = whwmd630.t$item 
             AND Q1.grid = tcemm112.t$grid
                   
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
                 tccom100.t$seak ) Q1
   
WHERE CHAVE_FILIAL IN (:Filial)
  AND COD_DEPTO IN (:Depto)
  AND TIPDEP IN (:TipRestricao)