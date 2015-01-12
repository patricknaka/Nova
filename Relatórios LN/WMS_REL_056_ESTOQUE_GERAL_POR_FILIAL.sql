SELECT Trim(tcibd001.t$item)             ID_ITEM, 
       tcibd001.t$dsca                   NOME, 
       CASE WHEN tcibd001.t$csig = ' ' 
              THEN 'ATIVO'
            ELSE 'INATIVO' 
        END                              ITEG_SITUACAO, 
       tcibd001.t$citg                   COD_DEPTO, 
       tcmcs023.t$dsca                   DEPTO, 
       tcibd001.t$seto$c                 COD_SETOR, 
       znmcs030.t$dsca$c                 SETOR, 
       tcibd001.t$fami$c                 COD_FAMILIA, 
       znmcs031.t$dsca$c                 FAMILIA, 
       tcibd001.t$subf$c                 COD_SUB, 
       znmcs032.t$dsca$c                 SUB, 
       WHSE.WHSEID                       ID_FILIAL, 
       WHSE.UDF2                         FILIAL,
       sum(whinr140.t$qhnd)              QT_FISICA,
       sum (nvl(Q2.bloc,0)+
            nvl(ats.qty,0))              QT_BLOQUEADA,
       sum(nvl(Q3.roma,0))               QT_ROMANEADA, 
       sum(whinr140.t$qlal-
           nvl(Q3.roma,0))               QT_RESERVADA, 
       sum(whinr140.t$qhnd -  
           whinr140.t$qlal )             QT_SALDO, 
       max(Q1.mauc)                      VL_UNITARIO, 
        
       CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL 
              THEN '00000000000000'  
            WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')) < 11 
              THEN '00000000000000' 
            ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')  
        END                              ID_FORNECEDOR, 
       tccom100.t$nama                   FORN_NOME, 
       tccom100.t$seak                   FORN_APELIDO 
             
FROM       baandb.ttcibd001301 tcibd001

INNER JOIN baandb.twhinr140301 whinr140 
        ON whinr140.t$item   = tcibd001.t$item 
 
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
                    b.t$grid, 
                    case when sum(a.t$qhnd) = 0  
                           then 0 
                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
                     end mauc 
               from baandb.twhwmd217301 whwmd217  
         inner join baandb.twhinr140301 a 
                 on a.t$cwar = whwmd217.t$cwar 
                and a.t$item = whwmd217.t$item
         inner join baandb.ttcemm112301 b 
                 on b.t$waid = a.t$cwar 
              where whwmd217.t$mauc$1 != 0
           group by whwmd217.t$item, 
                    b.t$grid ) Q1
        ON Q1.t$item = whinr140.t$item 
       AND Q1.t$grid = tcemm112.t$grid 
            
 LEFT JOIN ( select whwmd630.t$item,
                    whwmd630.t$loca,
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
                    whwmd630.t$loca,
                    whwmd630.t$cwar ) Q2  
        ON Q2.t$item = whinr140.t$item
       AND Q2.t$loca = whinr140.t$loca 
       AND Q2.t$cwar = whinr140.t$cwar 
  
 LEFT JOIN ( select whinh220.t$item,  
                    whinh220.t$cwar,  
                    sum(whinh220.t$qord) roma 
              from baandb.twhinh220301 whinh220
              inner join baandb.ttcmcs003301 wt on wt.t$cwar = whinh220.t$cwar
             where whinh220.t$wmss in (40, 50) 
               and whinh220.t$lsta < 30
               and wt.t$tpar$l != 2
          group by whinh220.t$item,  
                   whinh220.t$cwar ) Q3  
        ON Q3.t$item = whinr140.t$item  
       AND Q3.t$cwar = whinr140.t$cwar 
    
 LEFT JOIN ( select ats1.t$item, 
                    ats1.t$cwar, 
                    ats3.t$grid, 
                    sum(ats1.t$qhnd) qty
               from baandb.twhinr140301 ats1
         inner join baandb.ttcmcs003301 ats2 
                 on ats2.t$cwar = ats1.t$cwar
         inner join baandb.ttcemm112301 ats3 
                 on ats3.t$waid = ats1.t$cwar 
              where ats2.t$tpar$l = 2
           group by ats1.t$item, 
                    ats1.t$cwar, 
                    ats3.t$grid ) ats
        ON ats.t$item = whinr140.t$item
       AND ats.t$cwar = whinr140.t$cwar
       AND ats.t$grid = tcemm112.t$grid
            
 
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
 
INNER JOIN ( select ue.t$grid, 
                    UPPER(cl.UDF1) WHSEID, 
                    cl.UDF2 
               from baandb.ttcemm300301 wr
         inner join ENTERPRISE.CODELKUP@DL_LN_WMS cl 
                 on cl.DESCRIPTION = wr.t$LCTN
                and cl.listname = 'SCHEMA'
         inner join baandb.ttcemm112301 ue 
                 on ue.t$waid = wr.t$CODE
           group by ue.t$grid, 
                    UPPER(cl.UDF1), 
                    cl.UDF2 ) WHSE 
        ON WHSE.t$grid = tcemm112.t$grid
 
WHERE tcemm112.t$loco = 301
  AND ( (:Filial = 'AAA') OR (WHSE.WHSEID = :Filial) )
--and Trim(tcibd001.t$item) in ('2220','2198089')
HAVING sum(whinr140.t$qhnd - nvl(Q2.bloc,0)) > 0 
     
GROUP BY Trim(tcibd001.t$item),  
         tcibd001.t$dsca,  
         CASE WHEN tcibd001.t$csig = ' ' 
                THEN 'ATIVO'
              ELSE 'INATIVO' 
          END,
         tcibd001.t$citg, 
         tcmcs023.t$dsca, 
         tcibd001.t$seto$c,  
         znmcs030.t$dsca$c,  
         tcibd001.t$fami$c,   
         znmcs031.t$dsca$c,  
         tcibd001.t$subf$c,  
         znmcs032.t$dsca$c,  
         tcemm030.t$euca, 
         WHSE.WHSEID,
         WHSE.UDF2,
         tccom130.t$fovn$l,  
         tccom100.t$nama,  
         tccom100.t$seak

ORDER BY ID_FILIAL, NOME