SELECT                                                                      
  LL.WHSEID                         ID_PLANTA,                              
  CL.UDF2                           DESCR_PLANTA,                           
  BM.SKU                            TIK_PAI,                                
  PS.DESCR                          TIK_PAI_DESCR,                          
  BM.COMPONENTSKU                   TIK_FILHO,                              
  FS.DESCR                          TIK_FILHO_DESCR,                        
  IH.STATUS                         RESTRICAO,                              
  SUM(LL.QTY)                       QTD,                                    
  ( select asku.altsku                                                      
      from WMWHSE5.altsku asku                       
     where asku.sku = BM.SKU                                                
       and rownum = 1 )             EAN_PAI,                                
  ( select asku.altsku                                                      
      from WMWHSE5.altsku asku                       
     where asku.sku = BM.COMPONENTSKU                                       
       and rownum = 1 )             EAN_FILHO,                              
  LC.PUTAWAYZONE                    CLASSE_LOCAL,                           
  LC.LOC                            LOCAL,                                  
  Trim(PZ.DESCR)                    DESCR_LOCAL,                            
  nvl(max(maucLN.mauc),0) *                                                 
  sum(LL.qty)                       VALOR,                                  
  SUM(FS.STDCUBE*LL.qty)            CUBAGEM                                 
                                                                            
FROM       WMWHSE5.BILLOFMATERIAL BM                 
                                                                            
INNER JOIN WMWHSE5.LOTXLOCXID LL                     
        ON LL.SKU = BM.COMPONENTSKU                                         
                                                                            
INNER JOIN WMWHSE5.SKU PS                            
        ON PS.SKU = BM.SKU                                                  
                                                                            
INNER JOIN WMWHSE5.SKU FS                            
        ON FS.SKU = BM.COMPONENTSKU                                         
                                                                            
INNER JOIN WMWHSE5.LOC LC                            
        ON LC.LOC = LL.LOC                                                  
                                                                            
 LEFT JOIN WMWHSE5.INVENTORYHOLD IH                  
        ON IH.LOC = LL.LOC                                                  
       AND IH.HOLD = 1                                                      
       AND IH.LOC <> ' '                                                    
                                                                            
 LEFT JOIN WMWHSE5.PUTAWAYZONE PZ                    
        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                                  
                                                                            
 LEFT JOIN ENTERPRISE.CODELKUP CL                                           
        ON UPPER(cl.UDF1) = LL.WHSEID                                       
       AND CL.LISTNAME = 'SCHEMA'                                           
                                                                            
 LEFT JOIN ( select trim(whwmd217.t$item) item,                             
                    whwmd217.t$cwar cwar,                                   
                    case when sum(a.t$qhnd) = 0                             
                     then 0                                                 
                     else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)    
                    end mauc                                                
               from baandb.twhwmd217301@pln01 whwmd217                      
         inner join baandb.twhinr140301@pln01 a                             
                 on a.t$cwar = whwmd217.t$cwar                              
                and a.t$item = whwmd217.t$item                              
              where whwmd217.t$mauc$1 != 0                                  
           group by whwmd217.t$item,                                        
                    whwmd217.t$cwar ) maucLN                                 
        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         
        AND maucLN.item = PS.SKU                                            

WHERE LL.QTY>0                                                                            
GROUP BY  LL.WHSEID,                                                        
          CL.UDF2,                                                          
          BM.SKU,                                                           
          PS.DESCR,                                                         
          BM.COMPONENTSKU,                                                  
          FS.DESCR,                                                         
          IH.STATUS,                                                        
          LC.PUTAWAYZONE,                                                   
          LC.LOC,                                                           
          PZ.DESCR                                                          
                                                                            
ORDER BY ID_PLANTA                                                          



=IIF(Parameters!Table.Value <> "AAA", 

"SELECT                                                                      " &
"  LL.WHSEID                         ID_PLANTA,                              " &
"  CL.UDF2                           DESCR_PLANTA,                           " &
"  BM.SKU                            TIK_PAI,                                " &
"  PS.DESCR                          TIK_PAI_DESCR,                          " &
"  BM.COMPONENTSKU                   TIK_FILHO,                              " &
"  FS.DESCR                          TIK_FILHO_DESCR,                        " &
"  IH.STATUS                         RESTRICAO,                              " &
"  SUM(LL.QTY)                       QTD,                                    " &
"  ( select asku.altsku                                                      " &
"      from " + Parameters!Table.Value + ".altsku asku                       " &
"     where asku.sku = BM.SKU                                                " &
"       and rownum = 1 )             EAN_PAI,                                " &
"  ( select asku.altsku                                                      " &
"      from " + Parameters!Table.Value + ".altsku asku                       " &
"     where asku.sku = BM.COMPONENTSKU                                       " &
"       and rownum = 1 )             EAN_FILHO,                              " &
"  LC.PUTAWAYZONE                    CLASSE_LOCAL,                           " &
"  LC.LOC                            LOCAL,                                  " &
"  Trim(PZ.DESCR)                    DESCR_LOCAL,                            " &
"  nvl(max(maucLN.mauc),0) *                                                 " &
"  sum(LL.qty)                       VALOR,                                  " &
"  SUM(FS.STDCUBE*LL.qty)            CUBAGEM                                 " &
"                                                                            " &
"FROM       " + Parameters!Table.Value + ".BILLOFMATERIAL BM                 " &
"                                                                            " &
"INNER JOIN " + Parameters!Table.Value + ".LOTXLOCXID LL                     " &
"        ON LL.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN " + Parameters!Table.Value + ".SKU PS                            " &
"        ON PS.SKU = BM.SKU                                                  " &
"                                                                            " &
"INNER JOIN " + Parameters!Table.Value + ".SKU FS                            " &
"        ON FS.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN " + Parameters!Table.Value + ".LOC LC                            " &
"        ON LC.LOC = LL.LOC                                                  " &
"                                                                            " &
" LEFT JOIN " + Parameters!Table.Value + ".INVENTORYHOLD IH                  " &
"        ON IH.LOC = LL.LOC                                                  " &
"       AND IH.HOLD = 1                                                      " &
"       AND IH.LOC <> ' '                                                    " &
"                                                                            " &
" LEFT JOIN " + Parameters!Table.Value + ".PUTAWAYZONE PZ                    " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                                  " &
"                                                                            " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                           " &
"        ON UPPER(cl.UDF1) = LL.WHSEID                                       " &
"       AND CL.LISTNAME = 'SCHEMA'                                           " &
"                                                                            " &
" LEFT JOIN ( select trim(whwmd217.t$item) item,                             " &
"                    whwmd217.t$cwar cwar,                                   " &
"                    case when sum(a.t$qhnd) = 0                             " &
"                     then 0                                                 " &
"                     else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &  
"                    end mauc                                                " &
"               from baandb.twhwmd217301@pln01 whwmd217                      " &
"         inner join baandb.twhinr140301@pln01 a                             " &
"                 on a.t$cwar = whwmd217.t$cwar                              " &
"                and a.t$item = whwmd217.t$item                              " &
"              where whwmd217.t$mauc$1 != 0                                  " &
"           group by whwmd217.t$item,                                        " &
"                    whwmd217.t$cwar ) maucLN                                " & 
"        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         " &
"        AND maucLN.item = PS.SKU                                            " &
"                                                                            " &
"GROUP BY  LL.WHSEID,                                                        " &
"          CL.UDF2,                                                          " &
"          BM.SKU,                                                           " &
"          PS.DESCR,                                                         " &
"          BM.COMPONENTSKU,                                                  " &
"          FS.DESCR,                                                         " &
"          IH.STATUS,                                                        " &
"          LC.PUTAWAYZONE,                                                   " &
"          LC.LOC,                                                           " &
"          PZ.DESCR                                                          " &
"                                                                            " &
"ORDER BY ID_PLANTA                                                          "
                                                                             
,                                                                            
                                                                             
"SELECT                                                                      " &
"  LL.WHSEID                         ID_PLANTA,                              " &
"  CL.UDF2                           DESCR_PLANTA,                           " &
"  BM.SKU                            TIK_PAI,                                " &
"  PS.DESCR                          TIK_PAI_DESCR,                          " &
"  BM.COMPONENTSKU                   TIK_FILHO,                              " &
"  FS.DESCR                          TIK_FILHO_DESCR,                        " &
"  IH.STATUS                         RESTRICAO,                              " &
"  SUM(LL.QTY)                       QTD,                                    " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE1.altsku asku                                              " &
"     where asku.sku = BM.SKU                                                " &
"       and rownum = 1 )             EAN_PAI,                                " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE1.altsku asku                                              " &
"     where asku.sku = BM.COMPONENTSKU                                       " &
"       and rownum = 1 )             EAN_FILHO,                              " &
"  LC.PUTAWAYZONE                    CLASSE_LOCAL,                           " &
"  LC.LOC                            LOCAL,                                  " &
"  Trim(PZ.DESCR)                    DESCR_LOCAL,                            " &
"  nvl(max(maucLN.mauc),0) *                                                 " &
"  sum(LL.qty)                       VALOR,                                  " &
"  SUM(FS.STDCUBE*LL.qty)            CUBAGEM                                 " &
"                                                                            " &
"FROM       WMWHSE1.BILLOFMATERIAL BM                                        " &
"                                                                            " &
"INNER JOIN WMWHSE1.LOTXLOCXID LL                                            " &
"        ON LL.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE1.SKU PS                                                   " &
"        ON PS.SKU = BM.SKU                                                  " &
"                                                                            " &
"INNER JOIN WMWHSE1.SKU FS                                                   " &
"        ON FS.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE1.LOC LC                                                   " &
"        ON LC.LOC = LL.LOC                                                  " &
"                                                                            " &
" LEFT JOIN WMWHSE1.INVENTORYHOLD IH                                         " &
"        ON IH.LOC = LL.LOC                                                  " &
"       AND IH.HOLD = 1                                                      " &
"       AND IH.LOC <> ' '                                                    " &
"                                                                            " &
" LEFT JOIN WMWHSE1.PUTAWAYZONE PZ                                           " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                                  " &
"                                                                            " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                           " &
"        ON UPPER(cl.UDF1) = LL.WHSEID                                       " &
"       AND CL.LISTNAME = 'SCHEMA'                                           " &
"                                                                            " &
" LEFT JOIN ( select trim(whwmd217.t$item) item,                             " &
"                    whwmd217.t$cwar cwar,                                   " &
"                    case when sum(a.t$qhnd) = 0                             " &
"                     then 0                                                 " &
"                     else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                    end mauc                                                " &
"               from baandb.twhwmd217301@pln01 whwmd217                      " &
"         inner join baandb.twhinr140301@pln01 a                             " &
"                 on a.t$cwar = whwmd217.t$cwar                              " &
"                and a.t$item = whwmd217.t$item                              " &
"              where whwmd217.t$mauc$1 != 0                                  " &
"           group by whwmd217.t$item,                                        " &
"                    whwmd217.t$cwar ) maucLN                                " &
"        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         " &
"       AND maucLN.item = PS.SKU                                             " &
"                                                                            " &
"GROUP BY  LL.WHSEID,                                                        " &
"          CL.UDF2,                                                          " &
"          BM.SKU,                                                           " &
"          PS.DESCR,                                                         " &
"          BM.COMPONENTSKU,                                                  " &
"          FS.DESCR,                                                         " &
"          IH.STATUS,                                                        " &
"          LC.PUTAWAYZONE,                                                   " &
"          LC.LOC,                                                           " &
"          PZ.DESCR                                                          " &
"                                                                            " &
"UNION                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  LL.WHSEID                         ID_PLANTA,                              " &
"  CL.UDF2                           DESCR_PLANTA,                           " &
"  BM.SKU                            TIK_PAI,                                " &
"  PS.DESCR                          TIK_PAI_DESCR,                          " &
"  BM.COMPONENTSKU                   TIK_FILHO,                              " &
"  FS.DESCR                          TIK_FILHO_DESCR,                        " &
"  IH.STATUS                         RESTRICAO,                              " &
"  SUM(LL.QTY)                       QTD,                                    " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE2.altsku asku                                              " &
"     where asku.sku = BM.SKU                                                " &
"       and rownum = 1 )             EAN_PAI,                                " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE2.altsku asku                                              " &
"     where asku.sku = BM.COMPONENTSKU                                       " &
"       and rownum = 1 )             EAN_FILHO,                              " &
"  LC.PUTAWAYZONE                    CLASSE_LOCAL,                           " &
"  LC.LOC                            LOCAL,                                  " &
"  Trim(PZ.DESCR)                    DESCR_LOCAL,                            " &
"  nvl(max(maucLN.mauc),0) *                                                 " &
"  sum(LL.qty)                       VALOR,                                  " &
"  SUM(FS.STDCUBE*LL.qty)            CUBAGEM                                 " &
"                                                                            " &
"FROM       WMWHSE2.BILLOFMATERIAL BM                                        " &
"                                                                            " &
"INNER JOIN WMWHSE2.LOTXLOCXID LL                                            " &
"        ON LL.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE2.SKU PS                                                   " &
"        ON PS.SKU = BM.SKU                                                  " &
"                                                                            " &
"INNER JOIN WMWHSE2.SKU FS                                                   " &
"        ON FS.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE2.LOC LC                                                   " &
"        ON LC.LOC = LL.LOC                                                  " &
"                                                                            " &
" LEFT JOIN WMWHSE2.INVENTORYHOLD IH                                         " &
"        ON IH.LOC = LL.LOC                                                  " &
"       AND IH.HOLD = 1                                                      " &
"       AND IH.LOC <> ' '                                                    " &
"                                                                            " &
" LEFT JOIN WMWHSE2.PUTAWAYZONE PZ                                           " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                                  " &
"                                                                            " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                           " &
"        ON UPPER(cl.UDF1) = LL.WHSEID                                       " &
"       AND CL.LISTNAME = 'SCHEMA'                                           " &
"                                                                            " &
" LEFT JOIN ( select trim(whwmd217.t$item) item,                             " &
"                    whwmd217.t$cwar cwar,                                   " &
"                    case when sum(a.t$qhnd) = 0                             " &
"                     then 0                                                 " &
"                     else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                    end mauc                                                " &
"               from baandb.twhwmd217301@pln01 whwmd217                      " &
"         inner join baandb.twhinr140301@pln01 a                             " &
"                 on a.t$cwar = whwmd217.t$cwar                              " &
"                and a.t$item = whwmd217.t$item                              " &
"              where whwmd217.t$mauc$1 != 0                                  " &
"           group by whwmd217.t$item,                                        " &
"                    whwmd217.t$cwar ) maucLN                                " &
"        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         " &
"       AND maucLN.item = PS.SKU                                             " &
"                                                                            " &
"GROUP BY  LL.WHSEID,                                                        " &
"          CL.UDF2,                                                          " &
"          BM.SKU,                                                           " &
"          PS.DESCR,                                                         " &
"          BM.COMPONENTSKU,                                                  " &
"          FS.DESCR,                                                         " &
"          IH.STATUS,                                                        " &
"          LC.PUTAWAYZONE,                                                   " &
"          LC.LOC,                                                           " &
"          PZ.DESCR                                                          " &
"                                                                            " &
"UNION                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  LL.WHSEID                         ID_PLANTA,                              " &
"  CL.UDF2                           DESCR_PLANTA,                           " &
"  BM.SKU                            TIK_PAI,                                " &
"  PS.DESCR                          TIK_PAI_DESCR,                          " &
"  BM.COMPONENTSKU                   TIK_FILHO,                              " &
"  FS.DESCR                          TIK_FILHO_DESCR,                        " &
"  IH.STATUS                         RESTRICAO,                              " &
"  SUM(LL.QTY)                       QTD,                                    " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE3.altsku asku                                              " &
"     where asku.sku = BM.SKU                                                " &
"       and rownum = 1 )             EAN_PAI,                                " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE3.altsku asku                                              " &
"     where asku.sku = BM.COMPONENTSKU                                       " &
"       and rownum = 1 )             EAN_FILHO,                              " &
"  LC.PUTAWAYZONE                    CLASSE_LOCAL,                           " &
"  LC.LOC                            LOCAL,                                  " &
"  Trim(PZ.DESCR)                    DESCR_LOCAL,                            " &
"  nvl(max(maucLN.mauc),0) *                                                 " &
"  sum(LL.qty)                       VALOR,                                  " &
"  SUM(FS.STDCUBE*LL.qty)            CUBAGEM                                 " &
"                                                                            " &
"FROM       WMWHSE3.BILLOFMATERIAL BM                                        " &
"                                                                            " &
"INNER JOIN WMWHSE3.LOTXLOCXID LL                                            " &
"        ON LL.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE3.SKU PS                                                   " &
"        ON PS.SKU = BM.SKU                                                  " &
"                                                                            " &
"INNER JOIN WMWHSE3.SKU FS                                                   " &
"        ON FS.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE3.LOC LC                                                   " &
"        ON LC.LOC = LL.LOC                                                  " &
"                                                                            " &
" LEFT JOIN WMWHSE3.INVENTORYHOLD IH                                         " &
"        ON IH.LOC = LL.LOC                                                  " &
"       AND IH.HOLD = 1                                                      " &
"       AND IH.LOC <> ' '                                                    " &
"                                                                            " &
" LEFT JOIN WMWHSE3.PUTAWAYZONE PZ                                           " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                                  " &
"                                                                            " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                           " &
"        ON UPPER(cl.UDF1) = LL.WHSEID                                       " &
"       AND CL.LISTNAME = 'SCHEMA'                                           " &
"                                                                            " &
" LEFT JOIN ( select trim(whwmd217.t$item) item,                             " &
"                    whwmd217.t$cwar cwar,                                   " &
"                    case when sum(a.t$qhnd) = 0                             " &
"                     then 0                                                 " &
"                     else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                    end mauc                                                " &
"               from baandb.twhwmd217301@pln01 whwmd217                      " &
"         inner join baandb.twhinr140301@pln01 a                             " &
"                 on a.t$cwar = whwmd217.t$cwar                              " &
"                and a.t$item = whwmd217.t$item                              " &
"              where whwmd217.t$mauc$1 != 0                                  " &
"           group by whwmd217.t$item,                                        " &
"                    whwmd217.t$cwar ) maucLN                                " &
"        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         " &
"       AND maucLN.item = PS.SKU                                             " &
"                                                                            " &
"GROUP BY  LL.WHSEID,                                                        " &
"          CL.UDF2,                                                          " &
"          BM.SKU,                                                           " &
"          PS.DESCR,                                                         " &
"          BM.COMPONENTSKU,                                                  " &
"          FS.DESCR,                                                         " &
"          IH.STATUS,                                                        " &
"          LC.PUTAWAYZONE,                                                   " &
"          LC.LOC,                                                           " &
"          PZ.DESCR                                                          " &
"                                                                            " &
"UNION                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  LL.WHSEID                         ID_PLANTA,                              " &
"  CL.UDF2                           DESCR_PLANTA,                           " &
"  BM.SKU                            TIK_PAI,                                " &
"  PS.DESCR                          TIK_PAI_DESCR,                          " &
"  BM.COMPONENTSKU                   TIK_FILHO,                              " &
"  FS.DESCR                          TIK_FILHO_DESCR,                        " &
"  IH.STATUS                         RESTRICAO,                              " &
"  SUM(LL.QTY)                       QTD,                                    " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE4.altsku asku                                              " &
"     where asku.sku = BM.SKU                                                " &
"       and rownum = 1 )             EAN_PAI,                                " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE4.altsku asku                                              " &
"     where asku.sku = BM.COMPONENTSKU                                       " &
"       and rownum = 1 )             EAN_FILHO,                              " &
"  LC.PUTAWAYZONE                    CLASSE_LOCAL,                           " &
"  LC.LOC                            LOCAL,                                  " &
"  Trim(PZ.DESCR)                    DESCR_LOCAL,                            " &
"  nvl(max(maucLN.mauc),0) *                                                 " &
"  sum(LL.qty)                       VALOR,                                  " &
"  SUM(FS.STDCUBE*LL.qty)            CUBAGEM                                 " &
"                                                                            " &
"FROM       WMWHSE4.BILLOFMATERIAL BM                                        " &
"                                                                            " &
"INNER JOIN WMWHSE4.LOTXLOCXID LL                                            " &
"        ON LL.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE4.SKU PS                                                   " &
"        ON PS.SKU = BM.SKU                                                  " &
"                                                                            " &
"INNER JOIN WMWHSE4.SKU FS                                                   " &
"        ON FS.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE4.LOC LC                                                   " &
"        ON LC.LOC = LL.LOC                                                  " &
"                                                                            " &
" LEFT JOIN WMWHSE4.INVENTORYHOLD IH                                         " &
"        ON IH.LOC = LL.LOC                                                  " &
"       AND IH.HOLD = 1                                                      " &
"       AND IH.LOC <> ' '                                                    " &
"                                                                            " &
" LEFT JOIN WMWHSE4.PUTAWAYZONE PZ                                           " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                                  " &
"                                                                            " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                           " &
"        ON UPPER(cl.UDF1) = LL.WHSEID                                       " &
"       AND CL.LISTNAME = 'SCHEMA'                                           " &
"                                                                            " &
" LEFT JOIN ( select trim(whwmd217.t$item) item,                             " &
"                    whwmd217.t$cwar cwar,                                   " &
"                    case when sum(a.t$qhnd) = 0                             " &
"                     then 0                                                 " &
"                     else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                    end mauc                                                " &
"               from baandb.twhwmd217301@pln01 whwmd217                      " &
"         inner join baandb.twhinr140301@pln01 a                             " &
"                 on a.t$cwar = whwmd217.t$cwar                              " &
"                and a.t$item = whwmd217.t$item                              " &
"              where whwmd217.t$mauc$1 != 0                                  " &
"           group by whwmd217.t$item,                                        " &
"                    whwmd217.t$cwar ) maucLN                                " &
"        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         " &
"       AND maucLN.item = PS.SKU                                             " &
"                                                                            " &
"GROUP BY  LL.WHSEID,                                                        " &
"          CL.UDF2,                                                          " &
"          BM.SKU,                                                           " &
"          PS.DESCR,                                                         " &
"          BM.COMPONENTSKU,                                                  " &
"          FS.DESCR,                                                         " &
"          IH.STATUS,                                                        " &
"          LC.PUTAWAYZONE,                                                   " &
"          LC.LOC,                                                           " &
"          PZ.DESCR                                                          " &
"                                                                            " &
"UNION                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  LL.WHSEID                         ID_PLANTA,                              " &
"  CL.UDF2                           DESCR_PLANTA,                           " &
"  BM.SKU                            TIK_PAI,                                " &
"  PS.DESCR                          TIK_PAI_DESCR,                          " &
"  BM.COMPONENTSKU                   TIK_FILHO,                              " &
"  FS.DESCR                          TIK_FILHO_DESCR,                        " &
"  IH.STATUS                         RESTRICAO,                              " &
"  SUM(LL.QTY)                       QTD,                                    " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE5.altsku asku                                              " &
"     where asku.sku = BM.SKU                                                " &
"       and rownum = 1 )             EAN_PAI,                                " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE5.altsku asku                                              " &
"     where asku.sku = BM.COMPONENTSKU                                       " &
"       and rownum = 1 )             EAN_FILHO,                              " &
"  LC.PUTAWAYZONE                    CLASSE_LOCAL,                           " &
"  LC.LOC                            LOCAL,                                  " &
"  Trim(PZ.DESCR)                    DESCR_LOCAL,                            " &
"  nvl(max(maucLN.mauc),0) *                                                 " &
"  sum(LL.qty)                       VALOR,                                  " &
"  SUM(FS.STDCUBE*LL.qty)            CUBAGEM                                 " &
"                                                                            " &
"FROM       WMWHSE5.BILLOFMATERIAL BM                                        " &
"                                                                            " &
"INNER JOIN WMWHSE5.LOTXLOCXID LL                                            " &
"        ON LL.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE5.SKU PS                                                   " &
"        ON PS.SKU = BM.SKU                                                  " &
"                                                                            " &
"INNER JOIN WMWHSE5.SKU FS                                                   " &
"        ON FS.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE5.LOC LC                                                   " &
"        ON LC.LOC = LL.LOC                                                  " &
"                                                                            " &
" LEFT JOIN WMWHSE5.INVENTORYHOLD IH                                         " &
"        ON IH.LOC = LL.LOC                                                  " &
"       AND IH.HOLD = 1                                                      " &
"       AND IH.LOC <> ' '                                                    " &
"                                                                            " &
" LEFT JOIN WMWHSE5.PUTAWAYZONE PZ                                           " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                                  " &
"                                                                            " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                           " &
"        ON UPPER(cl.UDF1) = LL.WHSEID                                       " &
"       AND CL.LISTNAME = 'SCHEMA'                                           " &
"                                                                            " &
" LEFT JOIN ( select trim(whwmd217.t$item) item,                             " &
"                    whwmd217.t$cwar cwar,                                   " &
"                    case when sum(a.t$qhnd) = 0                             " &
"                     then 0                                                 " &
"                     else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                    end mauc                                                " &
"               from baandb.twhwmd217301@pln01 whwmd217                      " &
"         inner join baandb.twhinr140301@pln01 a                             " &
"                 on a.t$cwar = whwmd217.t$cwar                              " &
"                and a.t$item = whwmd217.t$item                              " &
"              where whwmd217.t$mauc$1 != 0                                  " &
"           group by whwmd217.t$item,                                        " &
"                    whwmd217.t$cwar ) maucLN                                " &
"        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         " &
"       AND maucLN.item = PS.SKU                                             " &
"                                                                            " &
"GROUP BY  LL.WHSEID,                                                        " &
"          CL.UDF2,                                                          " &
"          BM.SKU,                                                           " &
"          PS.DESCR,                                                         " &
"          BM.COMPONENTSKU,                                                  " &
"          FS.DESCR,                                                         " &
"          IH.STATUS,                                                        " &
"          LC.PUTAWAYZONE,                                                   " &
"          LC.LOC,                                                           " &
"          PZ.DESCR                                                          " &
"                                                                            " &
"UNION                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  LL.WHSEID                         ID_PLANTA,                              " &
"  CL.UDF2                           DESCR_PLANTA,                           " &
"  BM.SKU                            TIK_PAI,                                " &
"  PS.DESCR                          TIK_PAI_DESCR,                          " &
"  BM.COMPONENTSKU                   TIK_FILHO,                              " &
"  FS.DESCR                          TIK_FILHO_DESCR,                        " &
"  IH.STATUS                         RESTRICAO,                              " &
"  SUM(LL.QTY)                       QTD,                                    " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE6.altsku asku                                              " &
"     where asku.sku = BM.SKU                                                " &
"       and rownum = 1 )             EAN_PAI,                                " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE6.altsku asku                                              " &
"     where asku.sku = BM.COMPONENTSKU                                       " &
"       and rownum = 1 )             EAN_FILHO,                              " &
"  LC.PUTAWAYZONE                    CLASSE_LOCAL,                           " &
"  LC.LOC                            LOCAL,                                  " &
"  Trim(PZ.DESCR)                    DESCR_LOCAL,                            " &
"  nvl(max(maucLN.mauc),0) *                                                 " &
"  sum(LL.qty)                       VALOR,                                  " &
"  SUM(FS.STDCUBE*LL.qty)            CUBAGEM                                 " &
"                                                                            " &
"FROM       WMWHSE6.BILLOFMATERIAL BM                                        " &
"                                                                            " &
"INNER JOIN WMWHSE6.LOTXLOCXID LL                                            " &
"        ON LL.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE6.SKU PS                                                   " &
"        ON PS.SKU = BM.SKU                                                  " &
"                                                                            " &
"INNER JOIN WMWHSE6.SKU FS                                                   " &
"        ON FS.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE6.LOC LC                                                   " &
"        ON LC.LOC = LL.LOC                                                  " &
"                                                                            " &
" LEFT JOIN WMWHSE6.INVENTORYHOLD IH                                         " &
"        ON IH.LOC = LL.LOC                                                  " &
"       AND IH.HOLD = 1                                                      " &
"       AND IH.LOC <> ' '                                                    " &
"                                                                            " &
" LEFT JOIN WMWHSE6.PUTAWAYZONE PZ                                           " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                                  " &
"                                                                            " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                           " &
"        ON UPPER(cl.UDF1) = LL.WHSEID                                       " &
"       AND CL.LISTNAME = 'SCHEMA'                                           " &
"                                                                            " &
" LEFT JOIN ( select trim(whwmd217.t$item) item,                             " &
"                    whwmd217.t$cwar cwar,                                   " &
"                    case when sum(a.t$qhnd) = 0                             " &
"                     then 0                                                 " &
"                     else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                    end mauc                                                " &
"               from baandb.twhwmd217301@pln01 whwmd217                      " &
"         inner join baandb.twhinr140301@pln01 a                             " &
"                 on a.t$cwar = whwmd217.t$cwar                              " &
"                and a.t$item = whwmd217.t$item                              " &
"              where whwmd217.t$mauc$1 != 0                                  " &
"           group by whwmd217.t$item,                                        " &
"                    whwmd217.t$cwar ) maucLN                                " &
"        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         " &
"       AND maucLN.item = PS.SKU                                             " &
"                                                                            " &
"GROUP BY  LL.WHSEID,                                                        " &
"          CL.UDF2,                                                          " &
"          BM.SKU,                                                           " &
"          PS.DESCR,                                                         " &
"          BM.COMPONENTSKU,                                                  " &
"          FS.DESCR,                                                         " &
"          IH.STATUS,                                                        " &
"          LC.PUTAWAYZONE,                                                   " &
"          LC.LOC,                                                           " &
"          PZ.DESCR                                                          " &
"                                                                            " &
"UNION                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  LL.WHSEID                         ID_PLANTA,                              " &
"  CL.UDF2                           DESCR_PLANTA,                           " &
"  BM.SKU                            TIK_PAI,                                " &
"  PS.DESCR                          TIK_PAI_DESCR,                          " &
"  BM.COMPONENTSKU                   TIK_FILHO,                              " &
"  FS.DESCR                          TIK_FILHO_DESCR,                        " &
"  IH.STATUS                         RESTRICAO,                              " &
"  SUM(LL.QTY)                       QTD,                                    " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE7.altsku asku                                              " &
"     where asku.sku = BM.SKU                                                " &
"       and rownum = 1 )             EAN_PAI,                                " &
"  ( select asku.altsku                                                      " &
"      from WMWHSE7.altsku asku                                              " &
"     where asku.sku = BM.COMPONENTSKU                                       " &
"       and rownum = 1 )             EAN_FILHO,                              " &
"  LC.PUTAWAYZONE                    CLASSE_LOCAL,                           " &
"  LC.LOC                            LOCAL,                                  " &
"  Trim(PZ.DESCR)                    DESCR_LOCAL,                            " &
"  nvl(max(maucLN.mauc),0) *                                                 " &
"  sum(LL.qty)                       VALOR,                                  " &
"  SUM(FS.STDCUBE*LL.qty)            CUBAGEM                                 " &
"                                                                            " &
"FROM       WMWHSE7.BILLOFMATERIAL BM                                        " &
"                                                                            " &
"INNER JOIN WMWHSE7.LOTXLOCXID LL                                            " &
"        ON LL.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE7.SKU PS                                                   " &
"        ON PS.SKU = BM.SKU                                                  " &
"                                                                            " &
"INNER JOIN WMWHSE7.SKU FS                                                   " &
"        ON FS.SKU = BM.COMPONENTSKU                                         " &
"                                                                            " &
"INNER JOIN WMWHSE7.LOC LC                                                   " &
"        ON LC.LOC = LL.LOC                                                  " &
"                                                                            " &
" LEFT JOIN WMWHSE7.INVENTORYHOLD IH                                         " &
"        ON IH.LOC = LL.LOC                                                  " &
"       AND IH.HOLD = 1                                                      " &
"       AND IH.LOC <> ' '                                                    " &
"                                                                            " &
" LEFT JOIN WMWHSE7.PUTAWAYZONE PZ                                           " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                                  " &
"                                                                            " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                           " &
"        ON UPPER(cl.UDF1) = LL.WHSEID                                       " &
"       AND CL.LISTNAME = 'SCHEMA'                                           " &
"                                                                            " &
" LEFT JOIN ( select trim(whwmd217.t$item) item,                             " &
"                    whwmd217.t$cwar cwar,                                   " &
"                    case when sum(a.t$qhnd) = 0                             " &
"                     then 0                                                 " &
"                     else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                    end mauc                                                " &
"               from baandb.twhwmd217301@pln01 whwmd217                      " &
"         inner join baandb.twhinr140301@pln01 a                             " &
"                 on a.t$cwar = whwmd217.t$cwar                              " &
"                and a.t$item = whwmd217.t$item                              " &
"              where whwmd217.t$mauc$1 != 0                                  " &
"           group by whwmd217.t$item,                                        " &
"                    whwmd217.t$cwar ) maucLN                                " &
"        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         " &
"       AND maucLN.item = PS.SKU                                             " &
"                                                                            " &
"GROUP BY  LL.WHSEID,                                                        " &
"          CL.UDF2,                                                          " &
"          BM.SKU,                                                           " &
"          PS.DESCR,                                                         " &
"          BM.COMPONENTSKU,                                                  " &
"          FS.DESCR,                                                         " &
"          IH.STATUS,                                                        " &
"          LC.PUTAWAYZONE,                                                   " &
"          LC.LOC,                                                           " &
"          PZ.DESCR                                                          " &
"                                                                            " &
"ORDER BY ID_PLANTA                                                          " 
)