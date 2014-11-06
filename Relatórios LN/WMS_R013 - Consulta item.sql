SELECT WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,
       ll.loc                               LOCA,
       Trim(pz.DESCR)                       CLAL,
       ll.sku                               ITEM,
       sku.DESCR                            DECR_ITEM,
       ( select asku.altsku 
           from WMWHSE5.altsku asku
          where asku.sku = ll.sku
            and rownum = 1 )                EAN,
       CASE WHEN TO_CHAR(ll.holdreason) = ' ' 
              THEN 'OK'
            ELSE   TO_CHAR(ll.holdreason) 
        END                                 WARR,
       SUM(llid.qty)                        QTD_EST
    
FROM       WMWHSE5.lotxloc ll

INNER JOIN WMWHSE5.lotxlocxid llid 
        ON llid.sku = ll.sku 
       AND llid.loc = ll.loc
     
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID 

INNER JOIN ENTERPRISE.CODELKUP cl 
        ON UPPER(cl.UDF1) = llid.WHSEID
     
INNER JOIN WMWHSE5.sku 
        ON sku.SKU = ll.SKU
      
INNER JOIN WMWHSE5.loc 
        ON loc.loc = ll.loc
    
 LEFT JOIN WMWHSE5.PUTAWAYZONE pz 
        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE

WHERE cl.LISTNAME = 'SCHEMA'
  AND ( (Trim(ll.sku) IN (:Itens) And (:ItensTodos = 0)) OR (:ItensTodos = 1) )
    
GROUP BY WMSADMIN.PL_DB.DB_ALIAS,
         ll.sku,
         sku.DESCR,
         Trim(pz.DESCR),
         ll.loc,
         CASE WHEN TO_CHAR(ll.holdreason) = ' ' 
                THEN 'OK'
              ELSE   TO_CHAR(ll.holdreason) 
          END
		  
		  
		  
		  
"SELECT WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,                                                             " &
"       ll.loc                               LOCA,                                                                " &
"       Trim(pz.DESCR)                       CLAL,                                                                " &
"       ll.sku                               ITEM,                                                                " &
"       sku.DESCR                            DECR_ITEM,                                                           " &
"       ( select asku.altsku                                                                                      " &
"           from "+ Parameters!Table.Value + ".altsku asku                                                        " &
"          where asku.sku = ll.sku                                                                                " &
"            and rownum = 1 )                EAN,                                                                 " &
"       CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                    " &
"              THEN 'OK'                                                                                          " &
"            ELSE   TO_CHAR(ll.holdreason)                                                                        " &
"        END                                 WARR,                                                                " &
"       SUM(llid.qty)                        QTD_EST                                                              " &
"                                                                                                                 " &
"FROM       "+ Parameters!Table.Value + ".lotxloc ll                                                              " &
"                                                                                                                 " &
"INNER JOIN "+ Parameters!Table.Value + ".lotxlocxid llid                                                         " &
"        ON llid.sku = ll.sku                                                                                     " &
"       AND llid.loc = ll.loc                                                                                     " &
"                                                                                                                 " &
"INNER JOIN WMSADMIN.PL_DB                                                                                        " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID                                                          " &
"                                                                                                                 " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                                                                " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                                                                          " &
"                                                                                                                 " &
"INNER JOIN "+ Parameters!Table.Value + ".sku                                                                     " &
"        ON sku.SKU = ll.SKU                                                                                      " &
"                                                                                                                 " &
"INNER JOIN "+ Parameters!Table.Value + ".loc                                                                     " &
"        ON loc.loc = ll.loc                                                                                      " &
"                                                                                                                 " &
" LEFT JOIN "+ Parameters!Table.Value + ".PUTAWAYZONE pz                                                          " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                                                                      " &
"                                                                                                                 " &
"WHERE cl.LISTNAME = 'SCHEMA'                                                                                     " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )    " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                       " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                      " &
"                                                                                                                 " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                                                                " &
"         ll.sku,                                                                                                 " &
"         sku.DESCR,                                                                                              " &
"         Trim(pz.DESCR),                                                                                         " &
"         ll.loc,                                                                                                 " &
"         CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                  " &
"                THEN 'OK'                                                                                        " &
"              ELSE   TO_CHAR(ll.holdreason)                                                                      " &
"          END                                                                                                    " &
"                                                                                                                 " &
"ORDER BY ARMAZEM                                                                                                 "

-- Query com UNION **************************************************************************************************		  
		  
		  
		  
"SELECT WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,                                                             " &
"       ll.loc                               LOCA,                                                                " &
"       Trim(pz.DESCR)                       CLAL,                                                                " &
"       ll.sku                               ITEM,                                                                " &
"       sku.DESCR                            DECR_ITEM,                                                           " &
"       ( select asku.altsku                                                                                      " &
"           from WMWHSE1.altsku asku                                                                              " &
"          where asku.sku = ll.sku                                                                                " &
"            and rownum = 1 )                EAN,                                                                 " &
"       CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                    " &
"              THEN 'OK'                                                                                          " &
"            ELSE   TO_CHAR(ll.holdreason)                                                                        " &
"        END                                 WARR,                                                                " &
"       SUM(llid.qty)                        QTD_EST                                                              " &
"                                                                                                                 " &
"FROM       WMWHSE1.lotxloc ll                                                                                    " &
"                                                                                                                 " &
"INNER JOIN WMWHSE1.lotxlocxid llid                                                                               " &
"        ON llid.sku = ll.sku                                                                                     " &
"       AND llid.loc = ll.loc                                                                                     " &
"                                                                                                                 " &
"INNER JOIN WMSADMIN.PL_DB                                                                                        " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID                                                          " &
"                                                                                                                 " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                                                                " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                                                                          " &
"                                                                                                                 " &
"INNER JOIN WMWHSE1.sku                                                                                           " &
"        ON sku.SKU = ll.SKU                                                                                      " &
"                                                                                                                 " &
"INNER JOIN WMWHSE1.loc                                                                                           " &
"        ON loc.loc = ll.loc                                                                                      " &
"                                                                                                                 " &
" LEFT JOIN WMWHSE1.PUTAWAYZONE pz                                                                                " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                                                                      " &
"                                                                                                                 " &
"WHERE cl.LISTNAME = 'SCHEMA'                                                                                     " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )    " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                       " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                      " &
"                                                                                                                 " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                                                                " &
"         ll.sku,                                                                                                 " &
"         sku.DESCR,                                                                                              " &
"         Trim(pz.DESCR),                                                                                         " &
"         ll.loc,                                                                                                 " &
"         CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                  " &
"                THEN 'OK'                                                                                        " &
"              ELSE   TO_CHAR(ll.holdreason)                                                                      " &
"          END                                                                                                    " &
"                                                                                                                 " &
"Union                                                                                                            " &
"                                                                                                                 " &
"SELECT WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,                                                             " &
"       ll.loc                               LOCA,                                                                " &
"       Trim(pz.DESCR)                       CLAL,                                                                " &
"       ll.sku                               ITEM,                                                                " &
"       sku.DESCR                            DECR_ITEM,                                                           " &
"       ( select asku.altsku                                                                                      " &
"           from WMWHSE2.altsku asku                                                                              " &
"          where asku.sku = ll.sku                                                                                " &
"            and rownum = 1 )                EAN,                                                                 " &
"       CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                    " &
"              THEN 'OK'                                                                                          " &
"            ELSE   TO_CHAR(ll.holdreason)                                                                        " &
"        END                                 WARR,                                                                " &
"       SUM(llid.qty)                        QTD_EST                                                              " &
"                                                                                                                 " &
"FROM       WMWHSE2.lotxloc ll                                                                                    " &
"                                                                                                                 " &
"INNER JOIN WMWHSE2.lotxlocxid llid                                                                               " &
"        ON llid.sku = ll.sku                                                                                     " &
"       AND llid.loc = ll.loc                                                                                     " &
"                                                                                                                 " &
"INNER JOIN WMSADMIN.PL_DB                                                                                        " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID                                                          " &
"                                                                                                                 " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                                                                " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                                                                          " &
"                                                                                                                 " &
"INNER JOIN WMWHSE2.sku                                                                                           " &
"        ON sku.SKU = ll.SKU                                                                                      " &
"                                                                                                                 " &
"INNER JOIN WMWHSE2.loc                                                                                           " &
"        ON loc.loc = ll.loc                                                                                      " &
"                                                                                                                 " &
" LEFT JOIN WMWHSE2.PUTAWAYZONE pz                                                                                " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                                                                      " &
"                                                                                                                 " &
"WHERE cl.LISTNAME = 'SCHEMA'                                                                                     " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )    " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                       " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                      " &
"                                                                                                                 " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                                                                " &
"         ll.sku,                                                                                                 " &
"         sku.DESCR,                                                                                              " &
"         Trim(pz.DESCR),                                                                                         " &
"         ll.loc,                                                                                                 " &
"         CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                  " &
"                THEN 'OK'                                                                                        " &
"              ELSE   TO_CHAR(ll.holdreason)                                                                      " &
"          END                                                                                                    " &
"                                                                                                                 " &
"Union                                                                                                            " &
"                                                                                                                 " &
"SELECT WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,                                                             " &
"       ll.loc                               LOCA,                                                                " &
"       Trim(pz.DESCR)                       CLAL,                                                                " &
"       ll.sku                               ITEM,                                                                " &
"       sku.DESCR                            DECR_ITEM,                                                           " &
"       ( select asku.altsku                                                                                      " &
"           from WMWHSE3.altsku asku                                                                              " &
"          where asku.sku = ll.sku                                                                                " &
"            and rownum = 1 )                EAN,                                                                 " &
"       CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                    " &
"              THEN 'OK'                                                                                          " &
"            ELSE   TO_CHAR(ll.holdreason)                                                                        " &
"        END                                 WARR,                                                                " &
"       SUM(llid.qty)                        QTD_EST                                                              " &
"                                                                                                                 " &
"FROM       WMWHSE3.lotxloc ll                                                                                    " &
"                                                                                                                 " &
"INNER JOIN WMWHSE3.lotxlocxid llid                                                                               " &
"        ON llid.sku = ll.sku                                                                                     " &
"       AND llid.loc = ll.loc                                                                                     " &
"                                                                                                                 " &
"INNER JOIN WMSADMIN.PL_DB                                                                                        " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID                                                          " &
"                                                                                                                 " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                                                                " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                                                                          " &
"                                                                                                                 " &
"INNER JOIN WMWHSE3.sku                                                                                           " &
"        ON sku.SKU = ll.SKU                                                                                      " &
"                                                                                                                 " &
"INNER JOIN WMWHSE3.loc                                                                                           " &
"        ON loc.loc = ll.loc                                                                                      " &
"                                                                                                                 " &
" LEFT JOIN WMWHSE3.PUTAWAYZONE pz                                                                                " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                                                                      " &
"                                                                                                                 " &
"WHERE cl.LISTNAME = 'SCHEMA'                                                                                     " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )    " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                       " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                      " &
"                                                                                                                 " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                                                                " &
"         ll.sku,                                                                                                 " &
"         sku.DESCR,                                                                                              " &
"         Trim(pz.DESCR),                                                                                         " &
"         ll.loc,                                                                                                 " &
"         CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                  " &
"                THEN 'OK'                                                                                        " &
"              ELSE   TO_CHAR(ll.holdreason)                                                                      " &
"          END                                                                                                    " &
"                                                                                                                 " &
"Union                                                                                                            " &
"                                                                                                                 " &
"SELECT WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,                                                             " &
"       ll.loc                               LOCA,                                                                " &
"       Trim(pz.DESCR)                       CLAL,                                                                " &
"       ll.sku                               ITEM,                                                                " &
"       sku.DESCR                            DECR_ITEM,                                                           " &
"       ( select asku.altsku                                                                                      " &
"           from WMWHSE4.altsku asku                                                                              " &
"          where asku.sku = ll.sku                                                                                " &
"            and rownum = 1 )                EAN,                                                                 " &
"       CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                    " &
"              THEN 'OK'                                                                                          " &
"            ELSE   TO_CHAR(ll.holdreason)                                                                        " &
"        END                                 WARR,                                                                " &
"       SUM(llid.qty)                        QTD_EST                                                              " &
"                                                                                                                 " &
"FROM       WMWHSE4.lotxloc ll                                                                                    " &
"                                                                                                                 " &
"INNER JOIN WMWHSE4.lotxlocxid llid                                                                               " &
"        ON llid.sku = ll.sku                                                                                     " &
"       AND llid.loc = ll.loc                                                                                     " &
"                                                                                                                 " &
"INNER JOIN WMSADMIN.PL_DB                                                                                        " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID                                                          " &
"                                                                                                                 " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                                                                " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                                                                          " &
"                                                                                                                 " &
"INNER JOIN WMWHSE4.sku                                                                                           " &
"        ON sku.SKU = ll.SKU                                                                                      " &
"                                                                                                                 " &
"INNER JOIN WMWHSE4.loc                                                                                           " &
"        ON loc.loc = ll.loc                                                                                      " &
"                                                                                                                 " &
" LEFT JOIN WMWHSE4.PUTAWAYZONE pz                                                                                " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                                                                      " &
"                                                                                                                 " &
"WHERE cl.LISTNAME = 'SCHEMA'                                                                                     " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )    " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                       " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                      " &
"                                                                                                                 " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                                                                " &
"         ll.sku,                                                                                                 " &
"         sku.DESCR,                                                                                              " &
"         Trim(pz.DESCR),                                                                                         " &
"         ll.loc,                                                                                                 " &
"         CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                  " &
"                THEN 'OK'                                                                                        " &
"              ELSE   TO_CHAR(ll.holdreason)                                                                      " &
"          END                                                                                                    " &
"                                                                                                                 " &
"Union                                                                                                            " &
"                                                                                                                 " &
"SELECT WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,                                                             " &
"       ll.loc                               LOCA,                                                                " &
"       Trim(pz.DESCR)                       CLAL,                                                                " &
"       ll.sku                               ITEM,                                                                " &
"       sku.DESCR                            DECR_ITEM,                                                           " &
"       ( select asku.altsku                                                                                      " &
"           from WMWHSE5.altsku asku                                                                              " &
"          where asku.sku = ll.sku                                                                                " &
"            and rownum = 1 )                EAN,                                                                 " &
"       CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                    " &
"              THEN 'OK'                                                                                          " &
"            ELSE   TO_CHAR(ll.holdreason)                                                                        " &
"        END                                 WARR,                                                                " &
"       SUM(llid.qty)                        QTD_EST                                                              " &
"                                                                                                                 " &
"FROM       WMWHSE5.lotxloc ll                                                                                    " &
"                                                                                                                 " &
"INNER JOIN WMWHSE5.lotxlocxid llid                                                                               " &
"        ON llid.sku = ll.sku                                                                                     " &
"       AND llid.loc = ll.loc                                                                                     " &
"                                                                                                                 " &
"INNER JOIN WMSADMIN.PL_DB                                                                                        " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID                                                          " &
"                                                                                                                 " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                                                                " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                                                                          " &
"                                                                                                                 " &
"INNER JOIN WMWHSE5.sku                                                                                           " &
"        ON sku.SKU = ll.SKU                                                                                      " &
"                                                                                                                 " &
"INNER JOIN WMWHSE5.loc                                                                                           " &
"        ON loc.loc = ll.loc                                                                                      " &
"                                                                                                                 " &
" LEFT JOIN WMWHSE5.PUTAWAYZONE pz                                                                                " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                                                                      " &
"                                                                                                                 " &
"WHERE cl.LISTNAME = 'SCHEMA'                                                                                     " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )    " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                       " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                      " &
"                                                                                                                 " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                                                                " &
"         ll.sku,                                                                                                 " &
"         sku.DESCR,                                                                                              " &
"         Trim(pz.DESCR),                                                                                         " &
"         ll.loc,                                                                                                 " &
"         CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                  " &
"                THEN 'OK'                                                                                        " &
"              ELSE   TO_CHAR(ll.holdreason)                                                                      " &
"          END                                                                                                    " &
"                                                                                                                 " &
"Union                                                                                                            " &
"                                                                                                                 " &
"SELECT WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,                                                             " &
"       ll.loc                               LOCA,                                                                " &
"       Trim(pz.DESCR)                       CLAL,                                                                " &
"       ll.sku                               ITEM,                                                                " &
"       sku.DESCR                            DECR_ITEM,                                                           " &
"       ( select asku.altsku                                                                                      " &
"           from WMWHSE6.altsku asku                                                                              " &
"          where asku.sku = ll.sku                                                                                " &
"            and rownum = 1 )                EAN,                                                                 " &
"       CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                    " &
"              THEN 'OK'                                                                                          " &
"            ELSE   TO_CHAR(ll.holdreason)                                                                        " &
"        END                                 WARR,                                                                " &
"       SUM(llid.qty)                        QTD_EST                                                              " &
"                                                                                                                 " &
"FROM       WMWHSE6.lotxloc ll                                                                                    " &
"                                                                                                                 " &
"INNER JOIN WMWHSE6.lotxlocxid llid                                                                               " &
"        ON llid.sku = ll.sku                                                                                     " &
"       AND llid.loc = ll.loc                                                                                     " &
"                                                                                                                 " &
"INNER JOIN WMSADMIN.PL_DB                                                                                        " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID                                                          " &
"                                                                                                                 " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                                                                " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                                                                          " &
"                                                                                                                 " &
"INNER JOIN WMWHSE6.sku                                                                                           " &
"        ON sku.SKU = ll.SKU                                                                                      " &
"                                                                                                                 " &
"INNER JOIN WMWHSE6.loc                                                                                           " &
"        ON loc.loc = ll.loc                                                                                      " &
"                                                                                                                 " &
" LEFT JOIN WMWHSE6.PUTAWAYZONE pz                                                                                " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                                                                      " &
"                                                                                                                 " &
"WHERE cl.LISTNAME = 'SCHEMA'                                                                                     " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )    " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                       " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                      " &
"                                                                                                                 " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                                                                " &
"         ll.sku,                                                                                                 " &
"         sku.DESCR,                                                                                              " &
"         Trim(pz.DESCR),                                                                                         " &
"         ll.loc,                                                                                                 " &
"         CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                  " &
"                THEN 'OK'                                                                                        " &
"              ELSE   TO_CHAR(ll.holdreason)                                                                      " &
"          END                                                                                                    " &
"                                                                                                                 " &
"Union                                                                                                            " &
"                                                                                                                 " &
"SELECT WMSADMIN.PL_DB.DB_ALIAS              ARMAZEM,                                                             " &
"       ll.loc                               LOCA,                                                                " &
"       Trim(pz.DESCR)                       CLAL,                                                                " &
"       ll.sku                               ITEM,                                                                " &
"       sku.DESCR                            DECR_ITEM,                                                           " &
"       ( select asku.altsku                                                                                      " &
"           from WMWHSE7.altsku asku                                                                              " &
"          where asku.sku = ll.sku                                                                                " &
"            and rownum = 1 )                EAN,                                                                 " &
"       CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                    " &
"              THEN 'OK'                                                                                          " &
"            ELSE   TO_CHAR(ll.holdreason)                                                                        " &
"        END                                 WARR,                                                                " &
"       SUM(llid.qty)                        QTD_EST                                                              " &
"                                                                                                                 " &
"FROM       WMWHSE7.lotxloc ll                                                                                    " &
"                                                                                                                 " &
"INNER JOIN WMWHSE7.lotxlocxid llid                                                                               " &
"        ON llid.sku = ll.sku                                                                                     " &
"       AND llid.loc = ll.loc                                                                                     " &
"                                                                                                                 " &
"INNER JOIN WMSADMIN.PL_DB                                                                                        " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = llid.WHSEID                                                          " &
"                                                                                                                 " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                                                                " &
"        ON UPPER(cl.UDF1) = llid.WHSEID                                                                          " &
"                                                                                                                 " &
"INNER JOIN WMWHSE7.sku                                                                                           " &
"        ON sku.SKU = ll.SKU                                                                                      " &
"                                                                                                                 " &
"INNER JOIN WMWHSE7.loc                                                                                           " &
"        ON loc.loc = ll.loc                                                                                      " &
"                                                                                                                 " &
" LEFT JOIN WMWHSE7.PUTAWAYZONE pz                                                                                " &
"        ON pz.PUTAWAYZONE = loc.PUTAWAYZONE                                                                      " &
"                                                                                                                 " &
"WHERE cl.LISTNAME = 'SCHEMA'                                                                                     " &
"  AND (    (Trim(ll.sku) IN ( " + IIF(Parameters!Itens.Value Is Nothing, "''", Parameters!Itens.Value)  + " )    " &
"       AND (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 0))                                       " &
"        OR (" + IIF(Parameters!Itens.Value Is Nothing, "1", "0") + " = 1) )                                      " &
"                                                                                                                 " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                                                                " &
"         ll.sku,                                                                                                 " &
"         sku.DESCR,                                                                                              " &
"         Trim(pz.DESCR),                                                                                         " &
"         ll.loc,                                                                                                 " &
"         CASE WHEN TO_CHAR(ll.holdreason) = ' '                                                                  " &
"                THEN 'OK'                                                                                        " &
"              ELSE   TO_CHAR(ll.holdreason)                                                                      " &
"          END                                                                                                    " &
"                                                                                                                 " &
"ORDER BY ARMAZEM                                                                                                 "