SELECT 	Trim(tcibd001.t$item)             										ID_ITEM, 
		tcibd001.t$dsca                   										NOME, 
		tcibd001.t$citg                   										COD_DEPTO, 
		tcmcs023.t$dsca                   										DEPTO, 
		tcibd001.t$seto$c                 										COD_SETOR, 
		znmcs030.t$dsca$c                 										SETOR, 
		tcibd001.t$fami$c                 										COD_FAMILIA, 
		znmcs031.t$dsca$c                 										FAMILIA, 
		-- tcibd001.t$subf$c                 									COD_SUB, 
		-- znmcs032.t$dsca$c                 									SUB, 
		WHSE.UDF1                       										ID_FILIAL, 
		WHSE.UDF2                         										FILIAL,	   	   
		sum(whinr140.t$qhnd)              										QT_FISICA,
		max(whinr110.t$qstk)													QT_ULTIMA_SAIDA,	   
		WHWMD400.T$HGHT *        
		WHWMD400.T$WDTH *        
		WHWMD400.T$DPTH          												M3_UNI,
	   
		sum((WHWMD400.T$HGHT *
	       WHWMD400.T$WDTH *
	       WHWMD400.T$DPTH)*
		   whinr140.t$qhnd) 													M3_TOTAL,
		   
		max(MAUC.mauc)                      									VL_UNITARIO,
		sum(whinr140.t$qhnd* MAUC.mauc)     									VL_TOTAL,		   

		CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL 
              THEN '00000000000000'  
            WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')) < 11 
              THEN '00000000000000' 
            ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')  
        END                              										ID_FORNECEDOR, 
       tccom100.t$nama                   										FORN_NOME, 
       tccom100.t$seak                   										FORN_APELIDO,

	   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(whinr110.t$trdt), 
		'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		  AT time zone 'America/Sao_Paulo') AS DATE)
																				DATA_ULTIMA_SAIDA,

		TRUNC(sysdate-max(whinr110.t$trdt))										AGING
     
FROM       baandb.ttcibd001301 tcibd001

INNER JOIN baandb.twhinr140301 whinr140 
        ON whinr140.t$item   = tcibd001.t$item 

INNER JOIN BAANDB.TWHWMD400301 WHWMD400
        ON WHWMD400.T$ITEM = tcibd001.T$ITEM      
		
 LEFT JOIN baandb.ttdipu001301 tdipu001  
        ON tdipu001.t$item = tcibd001.t$item 
      
 LEFT JOIN baandb.ttccom100301 tccom100  
        ON tccom100.t$bpid = tdipu001.t$otbp 
      
 LEFT JOIN baandb.ttccom130301 tccom130  
        ON tccom130.t$cadr = tccom100.t$cadr 
     
 LEFT JOIN ( select whwmd217.t$item item,                             
                    whwmd217.t$cwar cwar,                                   
                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0                             
                           then sum(whwmd217.t$ftpa$1)                                              
                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
                    end mauc                                                
               from baandb.twhwmd217301 whwmd217                      
          left join baandb.twhinr140301 a                             
                 on a.t$cwar = whwmd217.t$cwar                              
                and a.t$item = whwmd217.t$item                              
           group by whwmd217.t$item,                                        
                    whwmd217.t$cwar ) mauc                                
        ON mauc.cwar = whinr140.T$CWAR                         
       AND mauc.item = whinr140.T$ITEM 
            
INNER JOIN baandb.ttcmcs023301 tcmcs023 
        ON tcmcs023.t$citg   = tcibd001.t$citg 
 
INNER JOIN baandb.tznmcs030301 znmcs030 
        ON znmcs030.t$citg$c = tcibd001.t$citg  
       AND znmcs030.t$seto$c = tcibd001.t$seto$c 
 
INNER JOIN baandb.tznmcs031301 znmcs031 
        ON znmcs031.t$citg$c = tcibd001.t$citg  
       AND znmcs031.t$seto$c = tcibd001.t$seto$c  
       AND znmcs031.t$fami$c = tcibd001.t$fami$c 
 
-- INNER JOIN baandb.tznmcs032301 znmcs032 
        -- ON znmcs032.t$citg$c = tcibd001.t$citg  
       -- AND znmcs032.t$seto$c = tcibd001.t$seto$c  
       -- AND znmcs032.t$fami$c = tcibd001.t$fami$c 
       -- AND znmcs032.t$subf$c = tcibd001.t$subf$c 
 
INNER JOIN BAANDB.TTCEMM300301 TCEMM300
        ON TCEMM300.T$COMP = 301 
       AND TCEMM300.T$TYPE = 20
       AND TRIM(TCEMM300.T$CODE) = TRIM(whinr140.T$CWAR)
 
 
INNER JOIN ( select A.LONG_VALUE,
                    UPPER(A.UDF1) UDF1,
                    A.UDF2
               from ENTERPRISE.CODELKUP@DL_LN_WMS A
              where A.LISTNAME = 'SCHEMA') WHSE
        ON WHSE.LONG_VALUE = TCEMM300.T$LCTN 
 

LEFT JOIN	(	select 	a.t$item,
						a.t$cwar,
						sum(a.t$qstk) t$qstk,
						max(a.t$trdt) t$trdt
				from	baandb.twhinr110301 a
				where	a.t$kost = 5
				and 	a.t$koor != 52
				and 	a.t$trdt = (select max(b.t$trdt)
									from baandb.twhinr110301 b
									where b.t$cwar = a.t$cwar
									and b.t$item = a.t$item
									and b.t$kost = 5
									and b.t$koor != 52)
				group by a.t$item,
				         a.t$cwar) whinr110
			ON	whinr110.t$cwar = whinr140.t$cwar
			AND	whinr110.t$item = whinr140.t$item

 
 
--WHERE 
-- ( (:Filial = 'AAA') OR (WHSE.WHSEID = :Filial) )
-- Trim(tcibd001.t$item) in ('3380804')
     
GROUP BY Trim(tcibd001.t$item),  tcibd001.t$dsca,
         tcibd001.t$citg, 
         tcmcs023.t$dsca, 
         tcibd001.t$seto$c,  
         znmcs030.t$dsca$c,  
         tcibd001.t$fami$c,   
         znmcs031.t$dsca$c,  
--         tcibd001.t$subf$c,  
--         znmcs032.t$dsca$c,  		 
         WHSE.UDF1,
         WHSE.UDF2,
         tccom130.t$fovn$l,  
         tccom100.t$nama,  
         tccom100.t$seak,
		 WHWMD400.T$HGHT *
		 WHWMD400.T$WDTH *
		 WHWMD400.T$DPTH  

ORDER BY ID_FILIAL, NOME