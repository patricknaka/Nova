SELECT Q1.ID_INVENTARIO,
       Q1.ID_LOCAL,
       Q1.ENDERECO,
       Q1.ITEM_WMS,
       Q1.ITEM_LN,
       Q1.NOME_ITEM,
       Q1.EAN,    
       sum(Q1.QT_LOGICA) QT_LOGICA,
       sum(Q1.QT_FISICA) QT_FISICA,
       sum(Q1.VAR_QTDE) VAR_QTDE,
       sum(Q1.VL_LOGICO) VL_LOGICO,
       sum(Q1.VL_FISICO) VL_FISICO,
       sum(Q1.VL_DIVERGENCIA) VL_DIVERGENCIA,
       Q1.SIMULACAO,  
       Q1.ID_PLANTA,
       Q1.NOME_PLANTA  
FROM ( select TO_CHAR(CC.CCKEY)         ID_INVENTARIO,
              CD.LOC                    ID_LOCAL,
              LC.PUTAWAYZONE            ENDERECO,
              CD.SKU                    ITEM_WMS,
              TCIBD001.T$ITEM           ITEM_LN,
              SK.DESCR                  NOME_ITEM,
              ( SELECT asku.altsku  
                  FROM WMWHSE5.altsku asku 
                 WHERE asku.sku = cd.sku 
                   AND ROWNUM = 1 )     EAN,    
              CD.SYSQTY                 QT_LOGICA,
              CD.SYSQTY+CD.ADJQTY       QT_FISICA,
              CD.ADJQTY                 VAR_QTDE,
              CD.SYSQTY*maucLN.mauc     VL_LOGICO,
              (CD.SYSQTY + CD.ADJQTY) * 
               maucLN.mauc              VL_FISICO,
              CD.ADJQTY * maucLN.mauc   VL_DIVERGENCIA,
              ' '                       SIMULACAO,          -- PENDENTE DE CUSTOMIZAÇÃO
              CC.WHSEID                 ID_PLANTA,
              CL.UDF2                   NOME_PLANTA  
         from WMWHSE5.CC   CC
   inner join WMWHSE5.CCDETAIL CD 
           on CD.CCKEY  = CC.CCKEY
   inner join ENTERPRISE.CODELKUP CL
           on UPPER(CL.UDF1)  =  CC.WHSEID
          and CL.LISTNAME  =  'SCHEMA'  
   inner join WMWHSE5.LOC   LC
           on LC.LOC   = CD.LOC
   inner join WMWHSE5.SKU   SK 
           on SK.SKU   = CD.SKU
   inner join BAANDB.TTCIBD001301@PLN01 TCIBD001 
           on TRIM(TCIBD001.T$ITEM) = CD.SKU
    left join ( SELECT trim(whwmd217.t$item) item,                             
                       whwmd217.t$cwar       cwar,                                   
                       case when sum(a.t$qhnd) = 0                             
                              then 0                                                 
                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)    
                        end                  mauc                                                
                  FROM baandb.twhwmd217301@PLN01 whwmd217                      
            INNER JOIN baandb.twhinr140301@PLN01 a                             
                    ON a.t$cwar = whwmd217.t$cwar                              
                   AND a.t$item = whwmd217.t$item                              
                 WHERE whwmd217.t$mauc$1 != 0                                  
              GROUP BY whwmd217.t$item,                                        
                       whwmd217.t$cwar ) maucLN                                 
           on  maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         
          and maucLN.item = CD.SKU
        where CC.STATUS < 9
  
        UNION

       SELECT ' '                       ID_INVENTARIO,
              CD.LOC                    ID_LOCAL,
              LC.PUTAWAYZONE            ENDERECO,
              CD.SKU                    ITEM_WMS,
              TCIBD001.T$ITEM           ITEM_LN,
              SK.DESCR                  NOME_ITEM,
              ( select asku.altsku  
                  from WMWHSE5.altsku asku 
                 where asku.sku = cd.sku 
                   and rownum = 1 )     EAN,    
              nvl(LL.QTY,0)             QT_LOGICA,
              CD.QTY                    QT_FISICA,
              CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,
              nvl(LL.QTY*maucLN.mauc,0) VL_LOGICO,
              CD.QTY*maucLN.mauc        VL_FISICO,
              (CD.QTY - nvl(LL.QTY,0))* 
               maucLN.mauc              VL_DIVERGENCIA,
              ' '                       SIMULACAO,          --PENDENTE DE CUSTOMIZAÇÃO
              CD.WHSEID       ID_PLANTA,
              CL.UDF2         NOME_PLANTA  
         FROM WMWHSE5.PHYSICAL CD
   INNER JOIN ENTERPRISE.CODELKUP CL
           ON UPPER(CL.UDF1)  =  CD.WHSEID
          AND CL.LISTNAME  =  'SCHEMA'  
   INNER JOIN WMWHSE5.LOC   LC 
           ON LC.LOC   = CD.LOC
   INNER JOIN WMWHSE5.SKU   SK 
           ON SK.SKU   = CD.SKU
   INNER JOIN BAANDB.TTCIBD001301@PLN01 TCIBD001 
           ON TRIM(TCIBD001.T$ITEM) = CD.SKU
    LEFT JOIN WMWHSE5.LOTXLOCXID LL 
           ON LL.LOT = CD.LOT
          AND LL.LOC = CD.LOC
          AND LL.ID = CD.ID
          AND LL.SKU = CD.SKU
    LEFT JOIN ( select trim(whwmd217.t$item) item,                             
                       whwmd217.t$cwar       cwar,                                   
                       case when sum(a.t$qhnd) = 0                             
                              then 0                                                 
                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)    
                        end                  mauc                                                
                  from baandb.twhwmd217301@PLN01 whwmd217                      
            inner join baandb.twhinr140301@PLN01 a                             
                    on a.t$cwar = whwmd217.t$cwar                              
                   and a.t$item = whwmd217.t$item                              
                 where whwmd217.t$mauc$1 != 0                                  
              group by whwmd217.t$item,                                        
                whwmd217.t$cwar ) maucLN                                 
           ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         
          AND maucLN.item = CD.SKU) Q1
        WHERE Q1.ID_INVENTARIO 
              BETWEEN NVL(:InventarioDe,  Q1.ID_INVENTARIO) 
                  AND NVL(:InventarioAte, Q1.ID_INVENTARIO)
     GROUP BY Q1.ID_INVENTARIO,
              Q1.ID_LOCAL,
              Q1.ENDERECO,
              Q1.ITEM_WMS,
              Q1.ITEM_LN,
              Q1.NOME_ITEM,
              Q1.EAN,    
              Q1.SIMULACAO,  
              Q1.ID_PLANTA,
              Q1.NOME_PLANTA 






=IIF(Parameters!Table.Value <> "AAA",

"SELECT Q1.ID_INVENTARIO,                                  " &
"       Q1.ID_LOCAL,                                       " &
"       Q1.ENDERECO,                                       " &
"       Q1.ITEM_WMS,                                       " &
"       Q1.ITEM_LN,                                        " &
"       Q1.NOME_ITEM,                                      " &
"       Q1.EAN,                                            " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                       " &
"       sum(Q1.QT_FISICA) QT_FISICA,                       " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                         " &
"       sum(Q1.VL_LOGICO) VL_LOGICO,                       " &
"       sum(Q1.VL_FISICO) VL_FISICO,                       " &
"       sum(Q1.VL_DIVERGENCIA) VL_DIVERGENCIA,             " &
"       Q1.SIMULACAO,                                      " &
"       Q1.ID_PLANTA,                                      " &
"       Q1.NOME_PLANTA                                     " &
"FROM ( select TO_CHAR(CC.CCKEY)         ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( SELECT asku.altsku                        " &
"                  FROM " + Parameters!Table.Value + ".altsku asku " &
"                 WHERE asku.sku = cd.sku                  " &
"                   AND ROWNUM = 1 )     EAN,              " &
"              CD.SYSQTY                 QT_LOGICA,        " &
"              CD.SYSQTY+CD.ADJQTY       QT_FISICA,        " &
"              CD.ADJQTY                 VAR_QTDE,         " &
"              CD.SYSQTY*maucLN.mauc     VL_LOGICO,        " &
"              (CD.SYSQTY + CD.ADJQTY) *                   " &
"               maucLN.mauc              VL_FISICO,        " &
"              CD.ADJQTY * maucLN.mauc   VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CC.WHSEID                 ID_PLANTA,        " &
"              CL.UDF2                   NOME_PLANTA       " &
"         from " + Parameters!Table.Value + ".CC   CC      " &
"   inner join " + Parameters!Table.Value + ".CCDETAIL CD  " &
"           on CD.CCKEY  = CC.CCKEY                        " &
"   inner join ENTERPRISE.CODELKUP CL                      " &
"           on UPPER(CL.UDF1)  =  CC.WHSEID                " &
"          and CL.LISTNAME  =  'SCHEMA'                    " &
"   inner join " + Parameters!Table.Value + ".LOC   LC     " &
"           on LC.LOC   = CD.LOC                           " &
"   inner join " + Parameters!Table.Value + ".SKU   SK     " &
"           on SK.SKU   = CD.SKU                           " &
"   inner join BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           on TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    left join ( SELECT trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  FROM baandb.twhwmd217301@PLN01 whwmd217 " &
"            INNER JOIN baandb.twhinr140301@PLN01 a        " &
"                    ON a.t$cwar = whwmd217.t$cwar         " &
"                   AND a.t$item = whwmd217.t$item         " &
"                 WHERE whwmd217.t$mauc$1 != 0             " &
"              GROUP BY whwmd217.t$item,                   " &
"                       whwmd217.t$cwar ) maucLN           " &
"           on  maucLN.cwar = subStr(CL.DESCRIPTION,3,6)   " &
"          and maucLN.item = CD.SKU                        " &
"        where CC.STATUS < 9                               " &
"                                                          " &
"        UNION                                             " &
"                                                          " &
"       SELECT ' '                       ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( select asku.altsku                        " &
"                  from " + Parameters!Table.Value + ".altsku asku " &
"                 where asku.sku = cd.sku                  " &
"                   and rownum = 1 )     EAN,              " &
"              nvl(LL.QTY,0)             QT_LOGICA,        " &
"              CD.QTY                    QT_FISICA,        " &
"              CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,         " &
"              nvl(LL.QTY*maucLN.mauc,0) VL_LOGICO,        " &
"              CD.QTY*maucLN.mauc        VL_FISICO,        " &
"              (CD.QTY - nvl(LL.QTY,0))*                   " &
"               maucLN.mauc              VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CD.WHSEID       ID_PLANTA,                  " &
"              CL.UDF2         NOME_PLANTA                 " &
"         FROM " + Parameters!Table.Value + ".PHYSICAL CD  " &
"   INNER JOIN ENTERPRISE.CODELKUP CL                      " &
"           ON UPPER(CL.UDF1)  =  CD.WHSEID                " &
"          AND CL.LISTNAME  =  'SCHEMA'                    " &
"   INNER JOIN " + Parameters!Table.Value + ".LOC   LC     " &
"           ON LC.LOC   = CD.LOC                           " &
"   INNER JOIN " + Parameters!Table.Value + ".SKU   SK     " &
"           ON SK.SKU   = CD.SKU                           " &
"   INNER JOIN BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           ON TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    LEFT JOIN " + Parameters!Table.Value + ".LOTXLOCXID LL" &
"           ON LL.LOT = CD.LOT                             " &
"          AND LL.LOC = CD.LOC                             " &
"          AND LL.ID = CD.ID                               " &
"          AND LL.SKU = CD.SKU                             " &
"    LEFT JOIN ( select trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  from baandb.twhwmd217301@PLN01 whwmd217 " &
"            inner join baandb.twhinr140301@PLN01 a        " &
"                    on a.t$cwar = whwmd217.t$cwar         " &
"                   and a.t$item = whwmd217.t$item         " &
"                 where whwmd217.t$mauc$1 != 0             " &
"              group by whwmd217.t$item,                   " &
"                whwmd217.t$cwar ) maucLN                  " &
"           ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)    " &
"          AND maucLN.item = CD.SKU) Q1                    " &
"        WHERE Q1.ID_INVENTARIO                            " &
"              BETWEEN NVL(Trim('" + Parameters!InventarioDe.Value + "'),  Q1.ID_INVENTARIO)  " &
"                  AND NVL(Trim('" + Parameters!InventarioAte.Value + "'), Q1.ID_INVENTARIO)  " &
"     GROUP BY Q1.ID_INVENTARIO, " &
"              Q1.ID_LOCAL,      " &
"              Q1.ENDERECO,      " &
"              Q1.ITEM_WMS,      " &
"              Q1.ITEM_LN,       " &
"              Q1.NOME_ITEM,     " &
"              Q1.EAN,           " &
"              Q1.SIMULACAO,     " &
"              Q1.ID_PLANTA,     " &
"              Q1.NOME_PLANTA    "
                                                                             
,

"SELECT Q1.ID_INVENTARIO,                                  " &
"       Q1.ID_LOCAL,                                       " &
"       Q1.ENDERECO,                                       " &
"       Q1.ITEM_WMS,                                       " &
"       Q1.ITEM_LN,                                        " &
"       Q1.NOME_ITEM,                                      " &
"       Q1.EAN,                                            " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                       " &
"       sum(Q1.QT_FISICA) QT_FISICA,                       " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                         " &
"       sum(Q1.VL_LOGICO) VL_LOGICO,                       " &
"       sum(Q1.VL_FISICO) VL_FISICO,                       " &
"       sum(Q1.VL_DIVERGENCIA) VL_DIVERGENCIA,             " &
"       Q1.SIMULACAO,                                      " &
"       Q1.ID_PLANTA,                                      " &
"       Q1.NOME_PLANTA                                     " &
"FROM ( select TO_CHAR(CC.CCKEY)         ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( SELECT asku.altsku                        " &
"                  FROM WMWHSE1.altsku asku                " &
"                 WHERE asku.sku = cd.sku                  " &
"                   AND ROWNUM = 1 )     EAN,              " &
"              CD.SYSQTY                 QT_LOGICA,        " &
"              CD.SYSQTY+CD.ADJQTY       QT_FISICA,        " &
"              CD.ADJQTY                 VAR_QTDE,         " &
"              CD.SYSQTY*maucLN.mauc     VL_LOGICO,        " &
"              (CD.SYSQTY + CD.ADJQTY) *                   " &
"               maucLN.mauc              VL_FISICO,        " &
"              CD.ADJQTY * maucLN.mauc   VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CC.WHSEID                 ID_PLANTA,        " &
"              CL.UDF2                   NOME_PLANTA       " &
"         from WMWHSE1.CC   CC                             " &
"   inner join WMWHSE1.CCDETAIL CD                         " &
"           on CD.CCKEY  = CC.CCKEY                        " &
"   inner join ENTERPRISE.CODELKUP CL                      " &
"           on UPPER(CL.UDF1)  =  CC.WHSEID                " &
"          and CL.LISTNAME  =  'SCHEMA'                    " &
"   inner join WMWHSE1.LOC   LC                            " &
"           on LC.LOC   = CD.LOC                           " &
"   inner join WMWHSE1.SKU   SK                            " &
"           on SK.SKU   = CD.SKU                           " &
"   inner join BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           on TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    left join ( SELECT trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  FROM baandb.twhwmd217301@PLN01 whwmd217 " &
"            INNER JOIN baandb.twhinr140301@PLN01 a        " &
"                    ON a.t$cwar = whwmd217.t$cwar         " &
"                   AND a.t$item = whwmd217.t$item         " &
"                 WHERE whwmd217.t$mauc$1 != 0             " &
"              GROUP BY whwmd217.t$item,                   " &
"                       whwmd217.t$cwar ) maucLN           " &
"           on  maucLN.cwar = subStr(CL.DESCRIPTION,3,6)   " &
"          and maucLN.item = CD.SKU                        " &
"        where CC.STATUS < 9                               " &
"                                                          " &
"        UNION                                             " &
"                                                          " &
"       SELECT ' '                       ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( select asku.altsku                        " &
"                  from WMWHSE1.altsku asku                " &
"                 where asku.sku = cd.sku                  " &
"                   and rownum = 1 )     EAN,              " &
"              nvl(LL.QTY,0)             QT_LOGICA,        " &
"              CD.QTY                    QT_FISICA,        " &
"              CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,         " &
"              nvl(LL.QTY*maucLN.mauc,0) VL_LOGICO,        " &
"              CD.QTY*maucLN.mauc        VL_FISICO,        " &
"              (CD.QTY - nvl(LL.QTY,0))*                   " &
"               maucLN.mauc              VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CD.WHSEID       ID_PLANTA,                  " &
"              CL.UDF2         NOME_PLANTA                 " &
"         FROM WMWHSE1.PHYSICAL CD                         " &
"   INNER JOIN ENTERPRISE.CODELKUP CL                      " &
"           ON UPPER(CL.UDF1)  =  CD.WHSEID                " &
"          AND CL.LISTNAME  =  'SCHEMA'                    " &
"   INNER JOIN WMWHSE1.LOC   LC                            " &
"           ON LC.LOC   = CD.LOC                           " &
"   INNER JOIN WMWHSE1.SKU   SK                            " &
"           ON SK.SKU   = CD.SKU                           " &
"   INNER JOIN BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           ON TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    LEFT JOIN WMWHSE1.LOTXLOCXID LL                       " &
"           ON LL.LOT = CD.LOT                             " &
"          AND LL.LOC = CD.LOC                             " &
"          AND LL.ID = CD.ID                               " &
"          AND LL.SKU = CD.SKU                             " &
"    LEFT JOIN ( select trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  from baandb.twhwmd217301@PLN01 whwmd217 " &
"            inner join baandb.twhinr140301@PLN01 a        " &
"                    on a.t$cwar = whwmd217.t$cwar         " &
"                   and a.t$item = whwmd217.t$item         " &
"                 where whwmd217.t$mauc$1 != 0             " &
"              group by whwmd217.t$item,                   " &
"                whwmd217.t$cwar ) maucLN                  " &
"           ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)    " &
"          AND maucLN.item = CD.SKU) Q1                    " &
"        WHERE Q1.ID_INVENTARIO                            " &
"              BETWEEN NVL(Trim('" + Parameters!InventarioDe.Value + "'),  Q1.ID_INVENTARIO)  " &
"                  AND NVL(Trim('" + Parameters!InventarioAte.Value + "'), Q1.ID_INVENTARIO)  " &
"     GROUP BY Q1.ID_INVENTARIO, " &
"              Q1.ID_LOCAL,      " &
"              Q1.ENDERECO,      " &
"              Q1.ITEM_WMS,      " &
"              Q1.ITEM_LN,       " &
"              Q1.NOME_ITEM,     " &
"              Q1.EAN,           " &
"              Q1.SIMULACAO,     " &
"              Q1.ID_PLANTA,     " &
"              Q1.NOME_PLANTA    " &
"Union                                                     " &
"SELECT Q1.ID_INVENTARIO,                                  " &
"       Q1.ID_LOCAL,                                       " &
"       Q1.ENDERECO,                                       " &
"       Q1.ITEM_WMS,                                       " &
"       Q1.ITEM_LN,                                        " &
"       Q1.NOME_ITEM,                                      " &
"       Q1.EAN,                                            " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                       " &
"       sum(Q1.QT_FISICA) QT_FISICA,                       " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                         " &
"       sum(Q1.VL_LOGICO) VL_LOGICO,                       " &
"       sum(Q1.VL_FISICO) VL_FISICO,                       " &
"       sum(Q1.VL_DIVERGENCIA) VL_DIVERGENCIA,             " &
"       Q1.SIMULACAO,                                      " &
"       Q1.ID_PLANTA,                                      " &
"       Q1.NOME_PLANTA                                     " &
"FROM ( select TO_CHAR(CC.CCKEY)         ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( SELECT asku.altsku                        " &
"                  FROM WMWHSE2.altsku asku                " &
"                 WHERE asku.sku = cd.sku                  " &
"                   AND ROWNUM = 1 )     EAN,              " &
"              CD.SYSQTY                 QT_LOGICA,        " &
"              CD.SYSQTY+CD.ADJQTY       QT_FISICA,        " &
"              CD.ADJQTY                 VAR_QTDE,         " &
"              CD.SYSQTY*maucLN.mauc     VL_LOGICO,        " &
"              (CD.SYSQTY + CD.ADJQTY) *                   " &
"               maucLN.mauc              VL_FISICO,        " &
"              CD.ADJQTY * maucLN.mauc   VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CC.WHSEID                 ID_PLANTA,        " &
"              CL.UDF2                   NOME_PLANTA       " &
"         from WMWHSE2.CC   CC                             " &
"   inner join WMWHSE2.CCDETAIL CD                         " &
"           on CD.CCKEY  = CC.CCKEY                        " &
"   inner join ENTERPRISE.CODELKUP CL                      " &
"           on UPPER(CL.UDF1)  =  CC.WHSEID                " &
"          and CL.LISTNAME  =  'SCHEMA'                    " &
"   inner join WMWHSE2.LOC   LC                            " &
"           on LC.LOC   = CD.LOC                           " &
"   inner join WMWHSE2.SKU   SK                            " &
"           on SK.SKU   = CD.SKU                           " &
"   inner join BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           on TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    left join ( SELECT trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  FROM baandb.twhwmd217301@PLN01 whwmd217 " &
"            INNER JOIN baandb.twhinr140301@PLN01 a        " &
"                    ON a.t$cwar = whwmd217.t$cwar         " &
"                   AND a.t$item = whwmd217.t$item         " &
"                 WHERE whwmd217.t$mauc$1 != 0             " &
"              GROUP BY whwmd217.t$item,                   " &
"                       whwmd217.t$cwar ) maucLN           " &
"           on  maucLN.cwar = subStr(CL.DESCRIPTION,3,6)   " &
"          and maucLN.item = CD.SKU                        " &
"        where CC.STATUS < 9                               " &
"                                                          " &
"        UNION                                             " &
"                                                          " &
"       SELECT ' '                       ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( select asku.altsku                        " &
"                  from WMWHSE2.altsku asku                " &
"                 where asku.sku = cd.sku                  " &
"                   and rownum = 1 )     EAN,              " &
"              nvl(LL.QTY,0)             QT_LOGICA,        " &
"              CD.QTY                    QT_FISICA,        " &
"              CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,         " &
"              nvl(LL.QTY*maucLN.mauc,0) VL_LOGICO,        " &
"              CD.QTY*maucLN.mauc        VL_FISICO,        " &
"              (CD.QTY - nvl(LL.QTY,0))*                   " &
"               maucLN.mauc              VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CD.WHSEID       ID_PLANTA,                  " &
"              CL.UDF2         NOME_PLANTA                 " &
"         FROM WMWHSE2.PHYSICAL CD                         " &
"   INNER JOIN ENTERPRISE.CODELKUP CL                      " &
"           ON UPPER(CL.UDF1)  =  CD.WHSEID                " &
"          AND CL.LISTNAME  =  'SCHEMA'                    " &
"   INNER JOIN WMWHSE2.LOC   LC                            " &
"           ON LC.LOC   = CD.LOC                           " &
"   INNER JOIN WMWHSE2.SKU   SK                            " &
"           ON SK.SKU   = CD.SKU                           " &
"   INNER JOIN BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           ON TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    LEFT JOIN WMWHSE2.LOTXLOCXID LL                       " &
"           ON LL.LOT = CD.LOT                             " &
"          AND LL.LOC = CD.LOC                             " &
"          AND LL.ID = CD.ID                               " &
"          AND LL.SKU = CD.SKU                             " &
"    LEFT JOIN ( select trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  from baandb.twhwmd217301@PLN01 whwmd217 " &
"            inner join baandb.twhinr140301@PLN01 a        " &
"                    on a.t$cwar = whwmd217.t$cwar         " &
"                   and a.t$item = whwmd217.t$item         " &
"                 where whwmd217.t$mauc$1 != 0             " &
"              group by whwmd217.t$item,                   " &
"                whwmd217.t$cwar ) maucLN                  " &
"           ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)    " &
"          AND maucLN.item = CD.SKU) Q1                    " &
"        WHERE Q1.ID_INVENTARIO                            " &
"              BETWEEN NVL(Trim('" + Parameters!InventarioDe.Value + "'),  Q1.ID_INVENTARIO)  " &
"                  AND NVL(Trim('" + Parameters!InventarioAte.Value + "'), Q1.ID_INVENTARIO)  " &
"     GROUP BY Q1.ID_INVENTARIO, " &
"              Q1.ID_LOCAL,      " &
"              Q1.ENDERECO,      " &
"              Q1.ITEM_WMS,      " &
"              Q1.ITEM_LN,       " &
"              Q1.NOME_ITEM,     " &
"              Q1.EAN,           " &
"              Q1.SIMULACAO,     " &
"              Q1.ID_PLANTA,     " &
"              Q1.NOME_PLANTA    " &
"Union                                                     " &
"SELECT Q1.ID_INVENTARIO,                                  " &
"       Q1.ID_LOCAL,                                       " &
"       Q1.ENDERECO,                                       " &
"       Q1.ITEM_WMS,                                       " &
"       Q1.ITEM_LN,                                        " &
"       Q1.NOME_ITEM,                                      " &
"       Q1.EAN,                                            " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                       " &
"       sum(Q1.QT_FISICA) QT_FISICA,                       " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                         " &
"       sum(Q1.VL_LOGICO) VL_LOGICO,                       " &
"       sum(Q1.VL_FISICO) VL_FISICO,                       " &
"       sum(Q1.VL_DIVERGENCIA) VL_DIVERGENCIA,             " &
"       Q1.SIMULACAO,                                      " &
"       Q1.ID_PLANTA,                                      " &
"       Q1.NOME_PLANTA                                     " &
"FROM ( select TO_CHAR(CC.CCKEY)         ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( SELECT asku.altsku                        " &
"                  FROM WMWHSE3.altsku asku                " &
"                 WHERE asku.sku = cd.sku                  " &
"                   AND ROWNUM = 1 )     EAN,              " &
"              CD.SYSQTY                 QT_LOGICA,        " &
"              CD.SYSQTY+CD.ADJQTY       QT_FISICA,        " &
"              CD.ADJQTY                 VAR_QTDE,         " &
"              CD.SYSQTY*maucLN.mauc     VL_LOGICO,        " &
"              (CD.SYSQTY + CD.ADJQTY) *                   " &
"               maucLN.mauc              VL_FISICO,        " &
"              CD.ADJQTY * maucLN.mauc   VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CC.WHSEID                 ID_PLANTA,        " &
"              CL.UDF2                   NOME_PLANTA       " &
"         from WMWHSE3.CC   CC                             " &
"   inner join WMWHSE3.CCDETAIL CD                         " &
"           on CD.CCKEY  = CC.CCKEY                        " &
"   inner join ENTERPRISE.CODELKUP CL                      " &
"           on UPPER(CL.UDF1)  =  CC.WHSEID                " &
"          and CL.LISTNAME  =  'SCHEMA'                    " &
"   inner join WMWHSE3.LOC   LC                            " &
"           on LC.LOC   = CD.LOC                           " &
"   inner join WMWHSE3.SKU   SK                            " &
"           on SK.SKU   = CD.SKU                           " &
"   inner join BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           on TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    left join ( SELECT trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  FROM baandb.twhwmd217301@PLN01 whwmd217 " &
"            INNER JOIN baandb.twhinr140301@PLN01 a        " &
"                    ON a.t$cwar = whwmd217.t$cwar         " &
"                   AND a.t$item = whwmd217.t$item         " &
"                 WHERE whwmd217.t$mauc$1 != 0             " &
"              GROUP BY whwmd217.t$item,                   " &
"                       whwmd217.t$cwar ) maucLN           " &
"           on  maucLN.cwar = subStr(CL.DESCRIPTION,3,6)   " &
"          and maucLN.item = CD.SKU                        " &
"        where CC.STATUS < 9                               " &
"                                                          " &
"        UNION                                             " &
"                                                          " &
"       SELECT ' '                       ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( select asku.altsku                        " &
"                  from WMWHSE3.altsku asku                " &
"                 where asku.sku = cd.sku                  " &
"                   and rownum = 1 )     EAN,              " &
"              nvl(LL.QTY,0)             QT_LOGICA,        " &
"              CD.QTY                    QT_FISICA,        " &
"              CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,         " &
"              nvl(LL.QTY*maucLN.mauc,0) VL_LOGICO,        " &
"              CD.QTY*maucLN.mauc        VL_FISICO,        " &
"              (CD.QTY - nvl(LL.QTY,0))*                   " &
"               maucLN.mauc              VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CD.WHSEID       ID_PLANTA,                  " &
"              CL.UDF2         NOME_PLANTA                 " &
"         FROM WMWHSE3.PHYSICAL CD                         " &
"   INNER JOIN ENTERPRISE.CODELKUP CL                      " &
"           ON UPPER(CL.UDF1)  =  CD.WHSEID                " &
"          AND CL.LISTNAME  =  'SCHEMA'                    " &
"   INNER JOIN WMWHSE3.LOC   LC                            " &
"           ON LC.LOC   = CD.LOC                           " &
"   INNER JOIN WMWHSE3.SKU   SK                            " &
"           ON SK.SKU   = CD.SKU                           " &
"   INNER JOIN BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           ON TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    LEFT JOIN WMWHSE3.LOTXLOCXID LL                       " &
"           ON LL.LOT = CD.LOT                             " &
"          AND LL.LOC = CD.LOC                             " &
"          AND LL.ID = CD.ID                               " &
"          AND LL.SKU = CD.SKU                             " &
"    LEFT JOIN ( select trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  from baandb.twhwmd217301@PLN01 whwmd217 " &
"            inner join baandb.twhinr140301@PLN01 a        " &
"                    on a.t$cwar = whwmd217.t$cwar         " &
"                   and a.t$item = whwmd217.t$item         " &
"                 where whwmd217.t$mauc$1 != 0             " &
"              group by whwmd217.t$item,                   " &
"                whwmd217.t$cwar ) maucLN                  " &
"           ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)    " &
"          AND maucLN.item = CD.SKU) Q1                    " &
"        WHERE Q1.ID_INVENTARIO                            " &
"              BETWEEN NVL(Trim('" + Parameters!InventarioDe.Value + "'),  Q1.ID_INVENTARIO)  " &
"                  AND NVL(Trim('" + Parameters!InventarioAte.Value + "'), Q1.ID_INVENTARIO)  " &
"     GROUP BY Q1.ID_INVENTARIO, " &
"              Q1.ID_LOCAL,      " &
"              Q1.ENDERECO,      " &
"              Q1.ITEM_WMS,      " &
"              Q1.ITEM_LN,       " &
"              Q1.NOME_ITEM,     " &
"              Q1.EAN,           " &
"              Q1.SIMULACAO,     " &
"              Q1.ID_PLANTA,     " &
"              Q1.NOME_PLANTA    " &
"Union                                                     " &
"SELECT Q1.ID_INVENTARIO,                                  " &
"       Q1.ID_LOCAL,                                       " &
"       Q1.ENDERECO,                                       " &
"       Q1.ITEM_WMS,                                       " &
"       Q1.ITEM_LN,                                        " &
"       Q1.NOME_ITEM,                                      " &
"       Q1.EAN,                                            " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                       " &
"       sum(Q1.QT_FISICA) QT_FISICA,                       " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                         " &
"       sum(Q1.VL_LOGICO) VL_LOGICO,                       " &
"       sum(Q1.VL_FISICO) VL_FISICO,                       " &
"       sum(Q1.VL_DIVERGENCIA) VL_DIVERGENCIA,             " &
"       Q1.SIMULACAO,                                      " &
"       Q1.ID_PLANTA,                                      " &
"       Q1.NOME_PLANTA                                     " &
"FROM ( select TO_CHAR(CC.CCKEY)         ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( SELECT asku.altsku                        " &
"                  FROM WMWHSE4.altsku asku                " &
"                 WHERE asku.sku = cd.sku                  " &
"                   AND ROWNUM = 1 )     EAN,              " &
"              CD.SYSQTY                 QT_LOGICA,        " &
"              CD.SYSQTY+CD.ADJQTY       QT_FISICA,        " &
"              CD.ADJQTY                 VAR_QTDE,         " &
"              CD.SYSQTY*maucLN.mauc     VL_LOGICO,        " &
"              (CD.SYSQTY + CD.ADJQTY) *                   " &
"               maucLN.mauc              VL_FISICO,        " &
"              CD.ADJQTY * maucLN.mauc   VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CC.WHSEID                 ID_PLANTA,        " &
"              CL.UDF2                   NOME_PLANTA       " &
"         from WMWHSE4.CC   CC                             " &
"   inner join WMWHSE4.CCDETAIL CD                         " &
"           on CD.CCKEY  = CC.CCKEY                        " &
"   inner join ENTERPRISE.CODELKUP CL                      " &
"           on UPPER(CL.UDF1)  =  CC.WHSEID                " &
"          and CL.LISTNAME  =  'SCHEMA'                    " &
"   inner join WMWHSE4.LOC   LC                            " &
"           on LC.LOC   = CD.LOC                           " &
"   inner join WMWHSE4.SKU   SK                            " &
"           on SK.SKU   = CD.SKU                           " &
"   inner join BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           on TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    left join ( SELECT trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  FROM baandb.twhwmd217301@PLN01 whwmd217 " &
"            INNER JOIN baandb.twhinr140301@PLN01 a        " &
"                    ON a.t$cwar = whwmd217.t$cwar         " &
"                   AND a.t$item = whwmd217.t$item         " &
"                 WHERE whwmd217.t$mauc$1 != 0             " &
"              GROUP BY whwmd217.t$item,                   " &
"                       whwmd217.t$cwar ) maucLN           " &
"           on  maucLN.cwar = subStr(CL.DESCRIPTION,3,6)   " &
"          and maucLN.item = CD.SKU                        " &
"        where CC.STATUS < 9                               " &
"                                                          " &
"        UNION                                             " &
"                                                          " &
"       SELECT ' '                       ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( select asku.altsku                        " &
"                  from WMWHSE4.altsku asku                " &
"                 where asku.sku = cd.sku                  " &
"                   and rownum = 1 )     EAN,              " &
"              nvl(LL.QTY,0)             QT_LOGICA,        " &
"              CD.QTY                    QT_FISICA,        " &
"              CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,         " &
"              nvl(LL.QTY*maucLN.mauc,0) VL_LOGICO,        " &
"              CD.QTY*maucLN.mauc        VL_FISICO,        " &
"              (CD.QTY - nvl(LL.QTY,0))*                   " &
"               maucLN.mauc              VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CD.WHSEID       ID_PLANTA,                  " &
"              CL.UDF2         NOME_PLANTA                 " &
"         FROM WMWHSE4.PHYSICAL CD                         " &
"   INNER JOIN ENTERPRISE.CODELKUP CL                      " &
"           ON UPPER(CL.UDF1)  =  CD.WHSEID                " &
"          AND CL.LISTNAME  =  'SCHEMA'                    " &
"   INNER JOIN WMWHSE4.LOC   LC                            " &
"           ON LC.LOC   = CD.LOC                           " &
"   INNER JOIN WMWHSE4.SKU   SK                            " &
"           ON SK.SKU   = CD.SKU                           " &
"   INNER JOIN BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           ON TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    LEFT JOIN WMWHSE4.LOTXLOCXID LL                       " &
"           ON LL.LOT = CD.LOT                             " &
"          AND LL.LOC = CD.LOC                             " &
"          AND LL.ID = CD.ID                               " &
"          AND LL.SKU = CD.SKU                             " &
"    LEFT JOIN ( select trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  from baandb.twhwmd217301@PLN01 whwmd217 " &
"            inner join baandb.twhinr140301@PLN01 a        " &
"                    on a.t$cwar = whwmd217.t$cwar         " &
"                   and a.t$item = whwmd217.t$item         " &
"                 where whwmd217.t$mauc$1 != 0             " &
"              group by whwmd217.t$item,                   " &
"                whwmd217.t$cwar ) maucLN                  " &
"           ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)    " &
"          AND maucLN.item = CD.SKU) Q1                    " &
"        WHERE Q1.ID_INVENTARIO                            " &
"              BETWEEN NVL(Trim('" + Parameters!InventarioDe.Value + "'),  Q1.ID_INVENTARIO)  " &
"                  AND NVL(Trim('" + Parameters!InventarioAte.Value + "'), Q1.ID_INVENTARIO)  " &
"     GROUP BY Q1.ID_INVENTARIO, " &
"              Q1.ID_LOCAL,      " &
"              Q1.ENDERECO,      " &
"              Q1.ITEM_WMS,      " &
"              Q1.ITEM_LN,       " &
"              Q1.NOME_ITEM,     " &
"              Q1.EAN,           " &
"              Q1.SIMULACAO,     " &
"              Q1.ID_PLANTA,     " &
"              Q1.NOME_PLANTA    " &
"Union                                                     " &
"SELECT Q1.ID_INVENTARIO,                                  " &
"       Q1.ID_LOCAL,                                       " &
"       Q1.ENDERECO,                                       " &
"       Q1.ITEM_WMS,                                       " &
"       Q1.ITEM_LN,                                        " &
"       Q1.NOME_ITEM,                                      " &
"       Q1.EAN,                                            " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                       " &
"       sum(Q1.QT_FISICA) QT_FISICA,                       " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                         " &
"       sum(Q1.VL_LOGICO) VL_LOGICO,                       " &
"       sum(Q1.VL_FISICO) VL_FISICO,                       " &
"       sum(Q1.VL_DIVERGENCIA) VL_DIVERGENCIA,             " &
"       Q1.SIMULACAO,                                      " &
"       Q1.ID_PLANTA,                                      " &
"       Q1.NOME_PLANTA                                     " &
"FROM ( select TO_CHAR(CC.CCKEY)         ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( SELECT asku.altsku                        " &
"                  FROM WMWHSE5.altsku asku                " &
"                 WHERE asku.sku = cd.sku                  " &
"                   AND ROWNUM = 1 )     EAN,              " &
"              CD.SYSQTY                 QT_LOGICA,        " &
"              CD.SYSQTY+CD.ADJQTY       QT_FISICA,        " &
"              CD.ADJQTY                 VAR_QTDE,         " &
"              CD.SYSQTY*maucLN.mauc     VL_LOGICO,        " &
"              (CD.SYSQTY + CD.ADJQTY) *                   " &
"               maucLN.mauc              VL_FISICO,        " &
"              CD.ADJQTY * maucLN.mauc   VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CC.WHSEID                 ID_PLANTA,        " &
"              CL.UDF2                   NOME_PLANTA       " &
"         from WMWHSE5.CC   CC                             " &
"   inner join WMWHSE5.CCDETAIL CD                         " &
"           on CD.CCKEY  = CC.CCKEY                        " &
"   inner join ENTERPRISE.CODELKUP CL                      " &
"           on UPPER(CL.UDF1)  =  CC.WHSEID                " &
"          and CL.LISTNAME  =  'SCHEMA'                    " &
"   inner join WMWHSE5.LOC   LC                            " &
"           on LC.LOC   = CD.LOC                           " &
"   inner join WMWHSE5.SKU   SK                            " &
"           on SK.SKU   = CD.SKU                           " &
"   inner join BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           on TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    left join ( SELECT trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  FROM baandb.twhwmd217301@PLN01 whwmd217 " &
"            INNER JOIN baandb.twhinr140301@PLN01 a        " &
"                    ON a.t$cwar = whwmd217.t$cwar         " &
"                   AND a.t$item = whwmd217.t$item         " &
"                 WHERE whwmd217.t$mauc$1 != 0             " &
"              GROUP BY whwmd217.t$item,                   " &
"                       whwmd217.t$cwar ) maucLN           " &
"           on  maucLN.cwar = subStr(CL.DESCRIPTION,3,6)   " &
"          and maucLN.item = CD.SKU                        " &
"        where CC.STATUS < 9                               " &
"                                                          " &
"        UNION                                             " &
"                                                          " &
"       SELECT ' '                       ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( select asku.altsku                        " &
"                  from WMWHSE5.altsku asku                " &
"                 where asku.sku = cd.sku                  " &
"                   and rownum = 1 )     EAN,              " &
"              nvl(LL.QTY,0)             QT_LOGICA,        " &
"              CD.QTY                    QT_FISICA,        " &
"              CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,         " &
"              nvl(LL.QTY*maucLN.mauc,0) VL_LOGICO,        " &
"              CD.QTY*maucLN.mauc        VL_FISICO,        " &
"              (CD.QTY - nvl(LL.QTY,0))*                   " &
"               maucLN.mauc              VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CD.WHSEID       ID_PLANTA,                  " &
"              CL.UDF2         NOME_PLANTA                 " &
"         FROM WMWHSE5.PHYSICAL CD                         " &
"   INNER JOIN ENTERPRISE.CODELKUP CL                      " &
"           ON UPPER(CL.UDF1)  =  CD.WHSEID                " &
"          AND CL.LISTNAME  =  'SCHEMA'                    " &
"   INNER JOIN WMWHSE5.LOC   LC                            " &
"           ON LC.LOC   = CD.LOC                           " &
"   INNER JOIN WMWHSE5.SKU   SK                            " &
"           ON SK.SKU   = CD.SKU                           " &
"   INNER JOIN BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           ON TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    LEFT JOIN WMWHSE5.LOTXLOCXID LL                       " &
"           ON LL.LOT = CD.LOT                             " &
"          AND LL.LOC = CD.LOC                             " &
"          AND LL.ID = CD.ID                               " &
"          AND LL.SKU = CD.SKU                             " &
"    LEFT JOIN ( select trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  from baandb.twhwmd217301@PLN01 whwmd217 " &
"            inner join baandb.twhinr140301@PLN01 a        " &
"                    on a.t$cwar = whwmd217.t$cwar         " &
"                   and a.t$item = whwmd217.t$item         " &
"                 where whwmd217.t$mauc$1 != 0             " &
"              group by whwmd217.t$item,                   " &
"                whwmd217.t$cwar ) maucLN                  " &
"           ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)    " &
"          AND maucLN.item = CD.SKU) Q1                    " &
"        WHERE Q1.ID_INVENTARIO                            " &
"              BETWEEN NVL(Trim('" + Parameters!InventarioDe.Value + "'),  Q1.ID_INVENTARIO)  " &
"                  AND NVL(Trim('" + Parameters!InventarioAte.Value + "'), Q1.ID_INVENTARIO)  " &
"     GROUP BY Q1.ID_INVENTARIO, " &
"              Q1.ID_LOCAL,      " &
"              Q1.ENDERECO,      " &
"              Q1.ITEM_WMS,      " &
"              Q1.ITEM_LN,       " &
"              Q1.NOME_ITEM,     " &
"              Q1.EAN,           " &
"              Q1.SIMULACAO,     " &
"              Q1.ID_PLANTA,     " &
"              Q1.NOME_PLANTA    " &
"Union                                                     " &
"SELECT Q1.ID_INVENTARIO,                                  " &
"       Q1.ID_LOCAL,                                       " &
"       Q1.ENDERECO,                                       " &
"       Q1.ITEM_WMS,                                       " &
"       Q1.ITEM_LN,                                        " &
"       Q1.NOME_ITEM,                                      " &
"       Q1.EAN,                                            " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                       " &
"       sum(Q1.QT_FISICA) QT_FISICA,                       " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                         " &
"       sum(Q1.VL_LOGICO) VL_LOGICO,                       " &
"       sum(Q1.VL_FISICO) VL_FISICO,                       " &
"       sum(Q1.VL_DIVERGENCIA) VL_DIVERGENCIA,             " &
"       Q1.SIMULACAO,                                      " &
"       Q1.ID_PLANTA,                                      " &
"       Q1.NOME_PLANTA                                     " &
"FROM ( select TO_CHAR(CC.CCKEY)         ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( SELECT asku.altsku                        " &
"                  FROM WMWHSE6.altsku asku                " &
"                 WHERE asku.sku = cd.sku                  " &
"                   AND ROWNUM = 1 )     EAN,              " &
"              CD.SYSQTY                 QT_LOGICA,        " &
"              CD.SYSQTY+CD.ADJQTY       QT_FISICA,        " &
"              CD.ADJQTY                 VAR_QTDE,         " &
"              CD.SYSQTY*maucLN.mauc     VL_LOGICO,        " &
"              (CD.SYSQTY + CD.ADJQTY) *                   " &
"               maucLN.mauc              VL_FISICO,        " &
"              CD.ADJQTY * maucLN.mauc   VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CC.WHSEID                 ID_PLANTA,        " &
"              CL.UDF2                   NOME_PLANTA       " &
"         from WMWHSE6.CC   CC                             " &
"   inner join WMWHSE6.CCDETAIL CD                         " &
"           on CD.CCKEY  = CC.CCKEY                        " &
"   inner join ENTERPRISE.CODELKUP CL                      " &
"           on UPPER(CL.UDF1)  =  CC.WHSEID                " &
"          and CL.LISTNAME  =  'SCHEMA'                    " &
"   inner join WMWHSE6.LOC   LC                            " &
"           on LC.LOC   = CD.LOC                           " &
"   inner join WMWHSE6.SKU   SK                            " &
"           on SK.SKU   = CD.SKU                           " &
"   inner join BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           on TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    left join ( SELECT trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  FROM baandb.twhwmd217301@PLN01 whwmd217 " &
"            INNER JOIN baandb.twhinr140301@PLN01 a        " &
"                    ON a.t$cwar = whwmd217.t$cwar         " &
"                   AND a.t$item = whwmd217.t$item         " &
"                 WHERE whwmd217.t$mauc$1 != 0             " &
"              GROUP BY whwmd217.t$item,                   " &
"                       whwmd217.t$cwar ) maucLN           " &
"           on  maucLN.cwar = subStr(CL.DESCRIPTION,3,6)   " &
"          and maucLN.item = CD.SKU                        " &
"        where CC.STATUS < 9                               " &
"                                                          " &
"        UNION                                             " &
"                                                          " &
"       SELECT ' '                       ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( select asku.altsku                        " &
"                  from WMWHSE6.altsku asku                " &
"                 where asku.sku = cd.sku                  " &
"                   and rownum = 1 )     EAN,              " &
"              nvl(LL.QTY,0)             QT_LOGICA,        " &
"              CD.QTY                    QT_FISICA,        " &
"              CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,         " &
"              nvl(LL.QTY*maucLN.mauc,0) VL_LOGICO,        " &
"              CD.QTY*maucLN.mauc        VL_FISICO,        " &
"              (CD.QTY - nvl(LL.QTY,0))*                   " &
"               maucLN.mauc              VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CD.WHSEID       ID_PLANTA,                  " &
"              CL.UDF2         NOME_PLANTA                 " &
"         FROM WMWHSE6.PHYSICAL CD                         " &
"   INNER JOIN ENTERPRISE.CODELKUP CL                      " &
"           ON UPPER(CL.UDF1)  =  CD.WHSEID                " &
"          AND CL.LISTNAME  =  'SCHEMA'                    " &
"   INNER JOIN WMWHSE6.LOC   LC                            " &
"           ON LC.LOC   = CD.LOC                           " &
"   INNER JOIN WMWHSE6.SKU   SK                            " &
"           ON SK.SKU   = CD.SKU                           " &
"   INNER JOIN BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           ON TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    LEFT JOIN WMWHSE6.LOTXLOCXID LL                       " &
"           ON LL.LOT = CD.LOT                             " &
"          AND LL.LOC = CD.LOC                             " &
"          AND LL.ID = CD.ID                               " &
"          AND LL.SKU = CD.SKU                             " &
"    LEFT JOIN ( select trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  from baandb.twhwmd217301@PLN01 whwmd217 " &
"            inner join baandb.twhinr140301@PLN01 a        " &
"                    on a.t$cwar = whwmd217.t$cwar         " &
"                   and a.t$item = whwmd217.t$item         " &
"                 where whwmd217.t$mauc$1 != 0             " &
"              group by whwmd217.t$item,                   " &
"                whwmd217.t$cwar ) maucLN                  " &
"           ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)    " &
"          AND maucLN.item = CD.SKU) Q1                    " &
"        WHERE Q1.ID_INVENTARIO                            " &
"              BETWEEN NVL(Trim('" + Parameters!InventarioDe.Value + "'),  Q1.ID_INVENTARIO)  " &
"                  AND NVL(Trim('" + Parameters!InventarioAte.Value + "'), Q1.ID_INVENTARIO)  " &
"     GROUP BY Q1.ID_INVENTARIO, " &
"              Q1.ID_LOCAL,      " &
"              Q1.ENDERECO,      " &
"              Q1.ITEM_WMS,      " &
"              Q1.ITEM_LN,       " &
"              Q1.NOME_ITEM,     " &
"              Q1.EAN,           " &
"              Q1.SIMULACAO,     " &
"              Q1.ID_PLANTA,     " &
"              Q1.NOME_PLANTA    " &
"Union                                                     " &
"SELECT Q1.ID_INVENTARIO,                                  " &
"       Q1.ID_LOCAL,                                       " &
"       Q1.ENDERECO,                                       " &
"       Q1.ITEM_WMS,                                       " &
"       Q1.ITEM_LN,                                        " &
"       Q1.NOME_ITEM,                                      " &
"       Q1.EAN,                                            " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                       " &
"       sum(Q1.QT_FISICA) QT_FISICA,                       " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                         " &
"       sum(Q1.VL_LOGICO) VL_LOGICO,                       " &
"       sum(Q1.VL_FISICO) VL_FISICO,                       " &
"       sum(Q1.VL_DIVERGENCIA) VL_DIVERGENCIA,             " &
"       Q1.SIMULACAO,                                      " &
"       Q1.ID_PLANTA,                                      " &
"       Q1.NOME_PLANTA                                     " &
"FROM ( select TO_CHAR(CC.CCKEY)         ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( SELECT asku.altsku                        " &
"                  FROM WMWHSE7.altsku asku                " &
"                 WHERE asku.sku = cd.sku                  " &
"                   AND ROWNUM = 1 )     EAN,              " &
"              CD.SYSQTY                 QT_LOGICA,        " &
"              CD.SYSQTY+CD.ADJQTY       QT_FISICA,        " &
"              CD.ADJQTY                 VAR_QTDE,         " &
"              CD.SYSQTY*maucLN.mauc     VL_LOGICO,        " &
"              (CD.SYSQTY + CD.ADJQTY) *                   " &
"               maucLN.mauc              VL_FISICO,        " &
"              CD.ADJQTY * maucLN.mauc   VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CC.WHSEID                 ID_PLANTA,        " &
"              CL.UDF2                   NOME_PLANTA       " &
"         from WMWHSE7.CC   CC                             " &
"   inner join WMWHSE7.CCDETAIL CD                         " &
"           on CD.CCKEY  = CC.CCKEY                        " &
"   inner join ENTERPRISE.CODELKUP CL                      " &
"           on UPPER(CL.UDF1)  =  CC.WHSEID                " &
"          and CL.LISTNAME  =  'SCHEMA'                    " &
"   inner join WMWHSE7.LOC   LC                            " &
"           on LC.LOC   = CD.LOC                           " &
"   inner join WMWHSE7.SKU   SK                            " &
"           on SK.SKU   = CD.SKU                           " &
"   inner join BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           on TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    left join ( SELECT trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  FROM baandb.twhwmd217301@PLN01 whwmd217 " &
"            INNER JOIN baandb.twhinr140301@PLN01 a        " &
"                    ON a.t$cwar = whwmd217.t$cwar         " &
"                   AND a.t$item = whwmd217.t$item         " &
"                 WHERE whwmd217.t$mauc$1 != 0             " &
"              GROUP BY whwmd217.t$item,                   " &
"                       whwmd217.t$cwar ) maucLN           " &
"           on  maucLN.cwar = subStr(CL.DESCRIPTION,3,6)   " &
"          and maucLN.item = CD.SKU                        " &
"        where CC.STATUS < 9                               " &
"                                                          " &
"        UNION                                             " &
"                                                          " &
"       SELECT ' '                       ID_INVENTARIO,    " &
"              CD.LOC                    ID_LOCAL,         " &
"              LC.PUTAWAYZONE            ENDERECO,         " &
"              CD.SKU                    ITEM_WMS,         " &
"              TCIBD001.T$ITEM           ITEM_LN,          " &
"              SK.DESCR                  NOME_ITEM,        " &
"              ( select asku.altsku                        " &
"                  from WMWHSE7.altsku asku                " &
"                 where asku.sku = cd.sku                  " &
"                   and rownum = 1 )     EAN,              " &
"              nvl(LL.QTY,0)             QT_LOGICA,        " &
"              CD.QTY                    QT_FISICA,        " &
"              CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,         " &
"              nvl(LL.QTY*maucLN.mauc,0) VL_LOGICO,        " &
"              CD.QTY*maucLN.mauc        VL_FISICO,        " &
"              (CD.QTY - nvl(LL.QTY,0))*                   " &
"               maucLN.mauc              VL_DIVERGENCIA,   " &
"              ' '                       SIMULACAO,        " &
"              CD.WHSEID       ID_PLANTA,                  " &
"              CL.UDF2         NOME_PLANTA                 " &
"         FROM WMWHSE7.PHYSICAL CD                         " &
"   INNER JOIN ENTERPRISE.CODELKUP CL                      " &
"           ON UPPER(CL.UDF1)  =  CD.WHSEID                " &
"          AND CL.LISTNAME  =  'SCHEMA'                    " &
"   INNER JOIN WMWHSE7.LOC   LC                            " &
"           ON LC.LOC   = CD.LOC                           " &
"   INNER JOIN WMWHSE7.SKU   SK                            " &
"           ON SK.SKU   = CD.SKU                           " &
"   INNER JOIN BAANDB.TTCIBD001301@PLN01 TCIBD001          " &
"           ON TRIM(TCIBD001.T$ITEM) = CD.SKU              " &
"    LEFT JOIN WMWHSE7.LOTXLOCXID LL                       " &
"           ON LL.LOT = CD.LOT                             " &
"          AND LL.LOC = CD.LOC                             " &
"          AND LL.ID = CD.ID                               " &
"          AND LL.SKU = CD.SKU                             " &
"    LEFT JOIN ( select trim(whwmd217.t$item) item,        " &
"                       whwmd217.t$cwar       cwar,        " &
"                       case when sum(a.t$qhnd) = 0        " &
"                              then 0                      " &
"                            else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4) " &
"                        end                  mauc         " &    
"                  from baandb.twhwmd217301@PLN01 whwmd217 " &
"            inner join baandb.twhinr140301@PLN01 a        " &
"                    on a.t$cwar = whwmd217.t$cwar         " &
"                   and a.t$item = whwmd217.t$item         " &
"                 where whwmd217.t$mauc$1 != 0             " &
"              group by whwmd217.t$item,                   " &
"                whwmd217.t$cwar ) maucLN                  " &
"           ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)    " &
"          AND maucLN.item = CD.SKU) Q1                    " &
"        WHERE Q1.ID_INVENTARIO                            " &
"              BETWEEN NVL(Trim('" + Parameters!InventarioDe.Value + "'),  Q1.ID_INVENTARIO)  " &
"                  AND NVL(Trim('" + Parameters!InventarioAte.Value + "'), Q1.ID_INVENTARIO)  " &
"     GROUP BY Q1.ID_INVENTARIO, " &
"              Q1.ID_LOCAL,      " &
"              Q1.ENDERECO,      " &
"              Q1.ITEM_WMS,      " &
"              Q1.ITEM_LN,       " &
"              Q1.NOME_ITEM,     " &
"              Q1.EAN,           " &
"              Q1.SIMULACAO,     " &
"              Q1.ID_PLANTA,     " &
"              Q1.NOME_PLANTA    "

)