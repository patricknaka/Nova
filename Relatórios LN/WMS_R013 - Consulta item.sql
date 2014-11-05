SELECT  
  WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,
  ll.sku                               ITEM,
  sku.DESCR                            DECR_ITEM,
  ( select asku.altsku 
      from WMWHSE5.altsku asku
     where asku.sku = ll.sku
       and rownum = 1 )                EAN,

  Trim(pz.DESCR)                       CLAL,
  ll.loc                               LOCA,
  CASE WHEN TO_CHAR(ll.holdreason) = ' ' 
         THEN 'OK'
       ELSE  TO_CHAR(ll.holdreason) 
   END                                 WARR,
  sum(llid.qty)                        QTD_EST
    
FROM       WMWHSE5.lotxloc ll

INNER JOIN WMWHSE5.lotxlocxid llid 
        ON llid.sku = ll.sku 
       AND llid.loc = ll.loc
     
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID 

INNER JOIN ENTERPRISE.CODELKUP cl 
        ON UPPER(cl.UDF1) = llid.WHSEID
       AND cl.LISTNAME = 'SCHEMA'
     
INNER JOIN WMWHSE5.sku 
        ON sku.SKU = ll.SKU
      
INNER JOIN WMWHSE5.loc 
        ON loc.loc = ll.loc
    
 LEFT JOIN WMWHSE5.PUTAWAYZONE pz 
        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE

       
--WHERE 
--   ( (Trim(ll.sku) IN (:Itens) And (:ItensTodos = 0)) OR (:ItensTodos = 1) )
    
GROUP BY 
  WMSADMIN.PL_DB.DB_ALIAS,
  ll.sku,
  sku.DESCR,
  Trim(pz.DESCR),
  ll.loc,
  CASE WHEN TO_CHAR(ll.holdreason) = ' ' 
         THEN 'OK'
       ELSE  TO_CHAR(ll.holdreason) 
   END