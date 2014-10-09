SELECT  
        ltrim(rtrim(tcibd001.t$item))     ID_ITEM,
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
        'WN'                              TIPDEP,
        sum(whwmd215.t$qhnd - nvl(q2.bloc,0))  QT_FISICA,
        sum(nvl(q3.roma,0))                    QT_ROMANEADA,
        sum(whwmd215.t$qall)                   QT_RESERVADA,
        sum(whwmd215.t$qhnd - whwmd215.t$qall - nvl(q2.bloc,0)) QT_SALDO,
        sum(q1.mauc)                           VL_UNITARIO,
        CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
        THEN '00000000000000' 
        WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
        THEN '00000000000000'
        ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') END ID_FORNECEDOR,
        tccom100.t$nama                   FORN_NOME,
        tccom100.t$seak                   FORN_APELIDO
        
FROM      baandb.ttcibd001201 tcibd001
LEFT JOIN baandb.ttdipu001201 tdipu001 ON tdipu001.t$item=tcibd001.t$item
LEFT JOIN baandb.ttccom100201 tccom100 ON tccom100.t$bpid=tdipu001.t$otbp
LEFT JOIN baandb.ttccom130201 tccom130 ON tccom130.t$cadr=tccom100.t$cadr,
          baandb.twhwmd215201 whwmd215
LEFT JOIN ( SELECT whwmd217.t$item, whwmd217.t$cwar,
					         case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
					         else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
					         end mauc
					 FROM baandb.twhwmd217201 whwmd217, baandb.twhwmd215201 whwmd215
					 WHERE whwmd215.t$cwar = whwmd217.t$cwar
					 AND   whwmd215.t$item = whwmd217.t$item
					 group by whwmd217.t$item, whwmd217.t$cwar) q1 
           ON q1.t$item = whwmd215.t$item AND q1.t$cwar = whwmd215.t$cwar
           
LEFT JOIN ( SELECT whwmd630.t$item, whwmd630.t$cwar, sum(whwmd630.t$qbls) bloc
					 FROM baandb.twhwmd630201 whwmd630, baandb.twhwmd215201 whwmd215
					 WHERE whwmd215.t$cwar = whwmd630.t$cwar
					 AND   whwmd215.t$item = whwmd630.t$item
           AND NOT EXISTS (SELECT * FROM baandb.ttcmcs095201 tcmcs095
                           WHERE  tcmcs095.t$modu = 'BOD' 
                           AND    tcmcs095.t$sumd = 0 
                           AND    tcmcs095.t$prcd = 9999
                           AND    tcmcs095.t$koda = whwmd630.t$bloc)
					 group by whwmd630.t$item, whwmd630.t$cwar) q2 
           ON q2.t$item = whwmd215.t$item AND q2.t$cwar = whwmd215.t$cwar
 
LEFT JOIN ( SELECT whinh220.t$item, whinh220.t$cwar, sum(whinh220.t$qord) roma
					 FROM baandb.twhinh220201 whinh220, baandb.twhwmd215201 whwmd215
					 WHERE whwmd215.t$cwar = whinh220.t$cwar
					 AND   whwmd215.t$item = whinh220.t$item
           AND   whinh220.t$wmss = 40
					 group by whinh220.t$item, whinh220.t$cwar) q3 
           ON q3.t$item = whwmd215.t$item AND q3.t$cwar = whwmd215.t$cwar,
         
          baandb.ttcemm112201 tcemm112,
          baandb.ttcemm030201 tcemm030,
          baandb.ttcmcs023301 tcmcs023,
          baandb.tznmcs030301 znmcs030,
          baandb.tznmcs031301 znmcs031,
          baandb.tznmcs032301 znmcs032
          
WHERE     tcemm112.t$loco = 201
AND       tcemm112.t$waid   = whwmd215.t$cwar
AND 	    tcemm030.t$eunt   = tcemm112.t$grid
AND       (whwmd215.t$qhnd>0 or whwmd215.t$qall>0)
AND       whwmd215.t$item   = tcibd001.t$item
AND       tcmcs023.t$citg   = tcibd001.t$citg
AND       znmcs030.t$citg$c = tcibd001.t$citg 
AND       znmcs030.t$seto$c = tcibd001.t$seto$c 
AND       znmcs031.t$citg$c = tcibd001.t$citg 
AND       znmcs031.t$seto$c = tcibd001.t$seto$c 
AND       znmcs031.t$fami$c = tcibd001.t$fami$c
AND       znmcs032.t$citg$c = tcibd001.t$citg 
AND       znmcs032.t$seto$c = tcibd001.t$seto$c 
AND       znmcs032.t$fami$c = tcibd001.t$fami$c
AND       znmcs032.t$subf$c = tcibd001.t$subf$c
GROUP BY
        ltrim(rtrim(tcibd001.t$item)), tcibd001.t$dsca, tcibd001.t$csig, tcibd001.t$citg,
        tcmcs023.t$dsca, tcibd001.t$seto$c, znmcs030.t$dsca$c, tcibd001.t$fami$c,  
        znmcs031.t$dsca$c, tcibd001.t$subf$c, znmcs032.t$dsca$c, tcemm030.t$euca,
        tccom130.t$fovn$l, tccom100.t$nama, tccom100.t$seak

UNION

SELECT  
        ltrim(rtrim(tcibd001.t$item))     ID_ITEM,
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
        whwmd630.t$bloc                   TIPDEP,
        sum(whwmd630.t$qbls)              QT_FISICA,
        0                                 QT_ROMANEADA,
        0                                 QT_RESERVADA,
        0                                 QT_SALDO,
        sum(q1.mauc)                      VL_UNITARIO,
        CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
        THEN '00000000000000' 
        WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
        THEN '00000000000000'
        ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') END ID_FORNECEDOR,
        tccom100.t$nama               FORN_NOME,
        tccom100.t$seak               FORN_APELIDO
        
FROM      baandb.ttcibd001201 tcibd001
LEFT JOIN baandb.ttdipu001201 tdipu001 ON tdipu001.t$item=tcibd001.t$item
LEFT JOIN baandb.ttccom100201 tccom100 ON tccom100.t$bpid=tdipu001.t$otbp
LEFT JOIN baandb.ttccom130201 tccom130 ON tccom130.t$cadr=tccom100.t$cadr,
          baandb.twhwmd630201 whwmd630
LEFT JOIN ( SELECT whwmd217.t$item, whwmd217.t$cwar,
					         case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
					         else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
					         end mauc
					 FROM baandb.twhwmd217201 whwmd217, baandb.twhwmd215201 whwmd215
					 WHERE whwmd215.t$cwar = whwmd217.t$cwar
					 AND   whwmd215.t$item = whwmd217.t$item
					 group by whwmd217.t$item, whwmd217.t$cwar) q1 
           ON q1.t$item = whwmd630.t$item AND q1.t$cwar = whwmd630.t$cwar,
         
          baandb.ttcemm112201 tcemm112,
          baandb.ttcemm030201 tcemm030,
          baandb.ttcmcs023301 tcmcs023,
          baandb.tznmcs030301 znmcs030,
          baandb.tznmcs031301 znmcs031,
          baandb.tznmcs032301 znmcs032
          
WHERE     tcemm112.t$loco = 201
AND       tcemm112.t$waid   = whwmd630.t$cwar
AND 	    tcemm030.t$eunt   = tcemm112.t$grid
AND       whwmd630.t$item   = tcibd001.t$item
AND       tcmcs023.t$citg   = tcibd001.t$citg
AND       znmcs030.t$citg$c = tcibd001.t$citg 
AND       znmcs030.t$seto$c = tcibd001.t$seto$c 
AND       znmcs031.t$citg$c = tcibd001.t$citg 
AND       znmcs031.t$seto$c = tcibd001.t$seto$c 
AND       znmcs031.t$fami$c = tcibd001.t$fami$c
AND       znmcs032.t$citg$c = tcibd001.t$citg 
AND       znmcs032.t$seto$c = tcibd001.t$seto$c 
AND       znmcs032.t$fami$c = tcibd001.t$fami$c
AND       znmcs032.t$subf$c = tcibd001.t$subf$c
AND NOT EXISTS (SELECT * FROM baandb.ttcmcs095201 tcmcs095
                WHERE  tcmcs095.t$modu = 'BOD' 
                AND    tcmcs095.t$sumd = 0 
                AND    tcmcs095.t$prcd = 9999
                AND    tcmcs095.t$koda = whwmd630.t$bloc)
GROUP BY
        ltrim(rtrim(tcibd001.t$item)), tcibd001.t$dsca, tcibd001.t$csig, tcibd001.t$citg,
        tcmcs023.t$dsca, tcibd001.t$seto$c, znmcs030.t$dsca$c, tcibd001.t$fami$c,  
        znmcs031.t$dsca$c, tcibd001.t$subf$c, znmcs032.t$dsca$c, tcemm030.t$euca,
        whwmd630.t$bloc, tccom130.t$fovn$l, tccom100.t$nama, tccom100.t$seak
