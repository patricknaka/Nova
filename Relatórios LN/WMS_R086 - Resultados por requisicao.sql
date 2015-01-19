=IIF(Parameters!Table.Value <> "AAA",                         

"SELECT Q1.ITEM_WMS,                                             " &
"       Q1.NOME_ITEM,                                            " &
"       NVL(Q1.WARR, 'OK') ID_WARR,                              " &
"       NVL(IH.DESCRIPTION,'OK') DESC_WARR,                      " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                             " &
"       sum(Q1.QT_FISICA) QT_FISICA,                             " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                               " &
"       Q1.SIMULACAO,                                            " &
"       Q1.ID_PLANTA,                                            " &
"       Q1.NOME_PLANTA                                           " &
"FROM ( select TO_CHAR(CC.CCKEY)    ID_INVENTARIO,               " &
"              CD.LOC               ID_LOCAL,                    " &
"              CD.SKU               ITEM_WMS,                    " &
"              SK.DESCR             NOME_ITEM,                   " &
"              CD.SYSQTY            QT_LOGICA,                   " &
"              CD.SYSQTY+CD.ADJQTY  QT_FISICA,                   " &
"              CD.ADJQTY            VAR_QTDE,                    " &
"              ' '                  SIMULACAO,                   " &
"              CC.WHSEID            ID_PLANTA,                   " &
"              CL.UDF2              NOME_PLANTA,                 " &
"              T.STATUS             WARR                         " &
"         from " + Parameters!Table.Value + ".CC CC              " &
"   inner join " + Parameters!Table.Value + ".CCDETAIL CD        " &
"           on CD.CCKEY = CC.CCKEY                               " &
"   inner join ENTERPRISE.CODELKUP CL                            " &
"           on upper(CL.UDF1) = CC.WHSEID                        " &
"          and CL.LISTNAME = 'SCHEMA'                            " &
"   inner join " + Parameters!Table.Value + ".SKU SK             " &
"           on SK.SKU = CD.SKU                                   " &
" left outer join (SELECT LOC,status                             " &                         
"FROM " + Parameters!Table.Value + ".INVENTORYHOLD               " &
"   where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC          " &
"        where CC.STATUS < 9                                     " &
"UNION                                                           " &
"    SELECT ' '                       ID_INVENTARIO,             " &
"           CD.LOC                    ID_LOCAL,                  " &
"           CD.SKU                    ITEM_WMS,                  " &
"           SK.DESCR                  NOME_ITEM,                 " &
"           nvl(LL.QTY,0)             QT_LOGICA,                 " &
"           CD.QTY                    QT_FISICA,                 " &
"           CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,                  " &
"           ' '                       SIMULACAO,                 " &
"           CD.WHSEID                 ID_PLANTA,                 " &
"           CL.UDF2                   NOME_PLANTA,               " &
"           T.STATUS                  WARR                       " &
"      FROM " + Parameters!Table.Value + ".PHYSICAL CD           " &
"INNER JOIN ENTERPRISE.CODELKUP CL                               " &
"        ON UPPER(CL.UDF1) = CD.WHSEID                           " &
"       AND CL.LISTNAME = 'SCHEMA'                               " &
"INNER JOIN " + Parameters!Table.Value + ".SKU SK                " &
"        ON SK.SKU = CD.SKU                                      " &
" LEFT JOIN " + Parameters!Table.Value + ".LOTXLOCXID LL         " &
"        ON LL.LOT = CD.LOT                                      " &
"       AND LL.LOC = CD.LOC                                      " &
"       AND LL.ID = CD.ID                                        " &
"       AND LL.SKU = CD.SKU                                      " &
" LEFT OUTER JOIN (SELECT LOC,status                             " &
"FROM " + Parameters!Table.Value + ".INVENTORYHOLD               " &
"       where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC      " &
"       WHERE CD.STATUS = 9 ) Q1                                 " &
" LEFT JOIN " + Parameters!Table.Value + ".INVENTORYHOLDCODE     " &
"IH ON Q1.WARR = IH.CODE                                         " &
"GROUP BY Q1.ITEM_WMS, Q1.NOME_ITEM, NVL(Q1.WARR, 'OK'),         " &
"         NVL(IH.DESCRIPTION,'OK'), Q1.SIMULACAO,                " &
"         Q1.ID_PLANTA, Q1.NOME_PLANTA                           " &
"ORDER BY NOME_PLANTA, NOME_ITEM                                 " 
                                                                                       
,                                                                                      
                                                                                       
"SELECT Q1.ITEM_WMS,                                             " &
"       Q1.NOME_ITEM,                                            " &
"       NVL(Q1.WARR, 'OK') ID_WARR,                              " &
"       NVL(IH.DESCRIPTION,'OK') DESC_WARR,                      " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                             " &
"       sum(Q1.QT_FISICA) QT_FISICA,                             " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                               " &
"       Q1.SIMULACAO,                                            " &
"       Q1.ID_PLANTA,                                            " &
"       Q1.NOME_PLANTA                                           " &
"FROM ( select TO_CHAR(CC.CCKEY)    ID_INVENTARIO,               " &
"              CD.LOC               ID_LOCAL,                    " &
"              CD.SKU               ITEM_WMS,                    " &
"              SK.DESCR             NOME_ITEM,                   " &
"              CD.SYSQTY            QT_LOGICA,                   " &
"              CD.SYSQTY+CD.ADJQTY  QT_FISICA,                   " &
"              CD.ADJQTY            VAR_QTDE,                    " &
"              ' '                  SIMULACAO,                   " &
"              CC.WHSEID            ID_PLANTA,                   " &
"              CL.UDF2              NOME_PLANTA,                 " &
"              T.STATUS             WARR                         " &
"         from WMWHSE1.CC CC                                     " &
"   inner join WMWHSE1.CCDETAIL CD                               " &
"           on CD.CCKEY = CC.CCKEY                               " &
"   inner join ENTERPRISE.CODELKUP CL                            " &
"           on upper(CL.UDF1) = CC.WHSEID                        " &
"          and CL.LISTNAME = 'SCHEMA'                            " &
"   inner join WMWHSE1.SKU SK                                    " &
"           on SK.SKU = CD.SKU                                   " &
" left outer join (SELECT LOC,status FROM WMWHSE1.INVENTORYHOLD  " &
"   where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC          " &
"        where CC.STATUS < 9                                     " &
"UNION                                                           " &
"    SELECT ' '                       ID_INVENTARIO,             " &
"           CD.LOC                    ID_LOCAL,                  " &
"           CD.SKU                    ITEM_WMS,                  " &
"           SK.DESCR                  NOME_ITEM,                 " &
"           nvl(LL.QTY,0)             QT_LOGICA,                 " &
"           CD.QTY                    QT_FISICA,                 " &
"           CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,                  " &
"           ' '                       SIMULACAO,                 " &
"           CD.WHSEID                 ID_PLANTA,                 " &
"           CL.UDF2                   NOME_PLANTA,               " &
"           T.STATUS                  WARR                       " &
"      FROM WMWHSE1.PHYSICAL CD                                  " &
"INNER JOIN ENTERPRISE.CODELKUP CL                               " &
"        ON UPPER(CL.UDF1) = CD.WHSEID                           " &
"       AND CL.LISTNAME = 'SCHEMA'                               " &
"INNER JOIN WMWHSE1.SKU SK                                       " &
"        ON SK.SKU = CD.SKU                                      " &
" LEFT JOIN WMWHSE1.LOTXLOCXID LL                                " &
"        ON LL.LOT = CD.LOT                                      " &
"       AND LL.LOC = CD.LOC                                      " &
"       AND LL.ID = CD.ID                                        " &
"       AND LL.SKU = CD.SKU                                      " &
" LEFT OUTER JOIN (SELECT LOC,status FROM WMWHSE1.INVENTORYHOLD  " &
"       where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC      " &
"       WHERE CD.STATUS = 9 ) Q1                                 " &
" LEFT JOIN WMWHSE1.INVENTORYHOLDCODE IH ON Q1.WARR = IH.CODE    " &
"GROUP BY Q1.ITEM_WMS, Q1.NOME_ITEM, NVL(Q1.WARR, 'OK'),         " &
"         NVL(IH.DESCRIPTION,'OK'), Q1.SIMULACAO,                " &
"         Q1.ID_PLANTA, Q1.NOME_PLANTA                           " &
"                                                                " &
"UNION                                                           " &
"                                                                " &
"SELECT Q1.ITEM_WMS,                                             " &
"       Q1.NOME_ITEM,                                            " &
"       NVL(Q1.WARR, 'OK') ID_WARR,                              " &
"       NVL(IH.DESCRIPTION,'OK') DESC_WARR,                      " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                             " &
"       sum(Q1.QT_FISICA) QT_FISICA,                             " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                               " &
"       Q1.SIMULACAO,                                            " &
"       Q1.ID_PLANTA,                                            " &
"       Q1.NOME_PLANTA                                           " &
"FROM ( select TO_CHAR(CC.CCKEY)    ID_INVENTARIO,               " &
"              CD.LOC               ID_LOCAL,                    " &
"              CD.SKU               ITEM_WMS,                    " &
"              SK.DESCR             NOME_ITEM,                   " &
"              CD.SYSQTY            QT_LOGICA,                   " &
"              CD.SYSQTY+CD.ADJQTY  QT_FISICA,                   " &
"              CD.ADJQTY            VAR_QTDE,                    " &
"              ' '                  SIMULACAO,                   " &
"              CC.WHSEID            ID_PLANTA,                   " &
"              CL.UDF2              NOME_PLANTA,                 " &
"              T.STATUS             WARR                         " &
"         from WMWHSE2.CC CC                                     " &
"   inner join WMWHSE2.CCDETAIL CD                               " &
"           on CD.CCKEY = CC.CCKEY                               " &
"   inner join ENTERPRISE.CODELKUP CL                            " &
"           on upper(CL.UDF1) = CC.WHSEID                        " &
"          and CL.LISTNAME = 'SCHEMA'                            " &
"   inner join WMWHSE2.SKU SK                                    " &
"           on SK.SKU = CD.SKU                                   " &
" left outer join (SELECT LOC,status FROM WMWHSE2.INVENTORYHOLD  " &
"   where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC          " &
"        where CC.STATUS < 9                                     " &
"UNION                                                           " &
"    SELECT ' '                       ID_INVENTARIO,             " &
"           CD.LOC                    ID_LOCAL,                  " &
"           CD.SKU                    ITEM_WMS,                  " &
"           SK.DESCR                  NOME_ITEM,                 " &
"           nvl(LL.QTY,0)             QT_LOGICA,                 " &
"           CD.QTY                    QT_FISICA,                 " &
"           CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,                  " &
"           ' '                       SIMULACAO,                 " &
"           CD.WHSEID                 ID_PLANTA,                 " &
"           CL.UDF2                   NOME_PLANTA,               " &
"           T.STATUS                  WARR                       " &
"      FROM WMWHSE2.PHYSICAL CD                                  " &
"INNER JOIN ENTERPRISE.CODELKUP CL                               " &
"        ON UPPER(CL.UDF1) = CD.WHSEID                           " &
"       AND CL.LISTNAME = 'SCHEMA'                               " &
"INNER JOIN WMWHSE2.SKU SK                                       " &
"        ON SK.SKU = CD.SKU                                      " &
" LEFT JOIN WMWHSE2.LOTXLOCXID LL                                " &
"        ON LL.LOT = CD.LOT                                      " &
"       AND LL.LOC = CD.LOC                                      " &
"       AND LL.ID = CD.ID                                        " &
"       AND LL.SKU = CD.SKU                                      " &
" LEFT OUTER JOIN (SELECT LOC,status FROM WMWHSE2.INVENTORYHOLD  " &
"       where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC      " &
"       WHERE CD.STATUS = 9 ) Q1                                 " &
" LEFT JOIN WMWHSE2.INVENTORYHOLDCODE IH ON Q1.WARR = IH.CODE    " &
"GROUP BY Q1.ITEM_WMS, Q1.NOME_ITEM, NVL(Q1.WARR, 'OK'),         " &
"         NVL(IH.DESCRIPTION,'OK'), Q1.SIMULACAO,                " &
"         Q1.ID_PLANTA, Q1.NOME_PLANTA                           " &
"                                                                " &
"UNION                                                           " &
"                                                                " &
"SELECT Q1.ITEM_WMS,                                             " &
"       Q1.NOME_ITEM,                                            " &
"       NVL(Q1.WARR, 'OK') ID_WARR,                              " &
"       NVL(IH.DESCRIPTION,'OK') DESC_WARR,                      " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                             " &
"       sum(Q1.QT_FISICA) QT_FISICA,                             " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                               " &
"       Q1.SIMULACAO,                                            " &
"       Q1.ID_PLANTA,                                            " &
"       Q1.NOME_PLANTA                                           " &
"FROM ( select TO_CHAR(CC.CCKEY)    ID_INVENTARIO,               " &
"              CD.LOC               ID_LOCAL,                    " &
"              CD.SKU               ITEM_WMS,                    " &
"              SK.DESCR             NOME_ITEM,                   " &
"              CD.SYSQTY            QT_LOGICA,                   " &
"              CD.SYSQTY+CD.ADJQTY  QT_FISICA,                   " &
"              CD.ADJQTY            VAR_QTDE,                    " &
"              ' '                  SIMULACAO,                   " &
"              CC.WHSEID            ID_PLANTA,                   " &
"              CL.UDF2              NOME_PLANTA,                 " &
"              T.STATUS             WARR                         " &
"         from WMWHSE3.CC CC                                     " &
"   inner join WMWHSE3.CCDETAIL CD                               " &
"           on CD.CCKEY = CC.CCKEY                               " &
"   inner join ENTERPRISE.CODELKUP CL                            " &
"           on upper(CL.UDF1) = CC.WHSEID                        " &
"          and CL.LISTNAME = 'SCHEMA'                            " &
"   inner join WMWHSE3.SKU SK                                    " &
"           on SK.SKU = CD.SKU                                   " &
" left outer join (SELECT LOC,status FROM WMWHSE3.INVENTORYHOLD  " &
"   where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC          " &
"        where CC.STATUS < 9                                     " &
"UNION                                                           " &
"    SELECT ' '                       ID_INVENTARIO,             " &
"           CD.LOC                    ID_LOCAL,                  " &
"           CD.SKU                    ITEM_WMS,                  " &
"           SK.DESCR                  NOME_ITEM,                 " &
"           nvl(LL.QTY,0)             QT_LOGICA,                 " &
"           CD.QTY                    QT_FISICA,                 " &
"           CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,                  " &
"           ' '                       SIMULACAO,                 " &
"           CD.WHSEID                 ID_PLANTA,                 " &
"           CL.UDF2                   NOME_PLANTA,               " &
"           T.STATUS                  WARR                       " &
"      FROM WMWHSE3.PHYSICAL CD                                  " &
"INNER JOIN ENTERPRISE.CODELKUP CL                               " &
"        ON UPPER(CL.UDF1) = CD.WHSEID                           " &
"       AND CL.LISTNAME = 'SCHEMA'                               " &
"INNER JOIN WMWHSE3.SKU SK                                       " &
"        ON SK.SKU = CD.SKU                                      " &
" LEFT JOIN WMWHSE3.LOTXLOCXID LL                                " &
"        ON LL.LOT = CD.LOT                                      " &
"       AND LL.LOC = CD.LOC                                      " &
"       AND LL.ID = CD.ID                                        " &
"       AND LL.SKU = CD.SKU                                      " &
" LEFT OUTER JOIN (SELECT LOC,status FROM WMWHSE3.INVENTORYHOLD  " &
"       where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC      " &
"       WHERE CD.STATUS = 9 ) Q1                                 " &
" LEFT JOIN WMWHSE3.INVENTORYHOLDCODE IH ON Q1.WARR = IH.CODE    " &
"GROUP BY Q1.ITEM_WMS, Q1.NOME_ITEM, NVL(Q1.WARR, 'OK'),         " &
"         NVL(IH.DESCRIPTION,'OK'), Q1.SIMULACAO,                " &
"         Q1.ID_PLANTA, Q1.NOME_PLANTA                           " &
"                                                                " &
"UNION                                                           " &
"                                                                " &
"SELECT Q1.ITEM_WMS,                                             " &
"       Q1.NOME_ITEM,                                            " &
"       NVL(Q1.WARR, 'OK') ID_WARR,                              " &
"       NVL(IH.DESCRIPTION,'OK') DESC_WARR,                      " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                             " &
"       sum(Q1.QT_FISICA) QT_FISICA,                             " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                               " &
"       Q1.SIMULACAO,                                            " &
"       Q1.ID_PLANTA,                                            " &
"       Q1.NOME_PLANTA                                           " &
"FROM ( select TO_CHAR(CC.CCKEY)    ID_INVENTARIO,               " &
"              CD.LOC               ID_LOCAL,                    " &
"              CD.SKU               ITEM_WMS,                    " &
"              SK.DESCR             NOME_ITEM,                   " &
"              CD.SYSQTY            QT_LOGICA,                   " &
"              CD.SYSQTY+CD.ADJQTY  QT_FISICA,                   " &
"              CD.ADJQTY            VAR_QTDE,                    " &
"              ' '                  SIMULACAO,                   " &
"              CC.WHSEID            ID_PLANTA,                   " &
"              CL.UDF2              NOME_PLANTA,                 " &
"              T.STATUS             WARR                         " &
"         from WMWHSE4.CC CC                                     " &
"   inner join WMWHSE4.CCDETAIL CD                               " &
"           on CD.CCKEY = CC.CCKEY                               " &
"   inner join ENTERPRISE.CODELKUP CL                            " &
"           on upper(CL.UDF1) = CC.WHSEID                        " &
"          and CL.LISTNAME = 'SCHEMA'                            " &
"   inner join WMWHSE4.SKU SK                                    " &
"           on SK.SKU = CD.SKU                                   " &
" left outer join (SELECT LOC,status FROM WMWHSE4.INVENTORYHOLD  " &
"   where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC          " &
"        where CC.STATUS < 9                                     " &
"UNION                                                           " &
"    SELECT ' '                       ID_INVENTARIO,             " &
"           CD.LOC                    ID_LOCAL,                  " &
"           CD.SKU                    ITEM_WMS,                  " &
"           SK.DESCR                  NOME_ITEM,                 " &
"           nvl(LL.QTY,0)             QT_LOGICA,                 " &
"           CD.QTY                    QT_FISICA,                 " &
"           CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,                  " &
"           ' '                       SIMULACAO,                 " &
"           CD.WHSEID                 ID_PLANTA,                 " &
"           CL.UDF2                   NOME_PLANTA,               " &
"           T.STATUS                  WARR                       " &
"      FROM WMWHSE4.PHYSICAL CD                                  " &
"INNER JOIN ENTERPRISE.CODELKUP CL                               " &
"        ON UPPER(CL.UDF1) = CD.WHSEID                           " &
"       AND CL.LISTNAME = 'SCHEMA'                               " &
"INNER JOIN WMWHSE4.SKU SK                                       " &
"        ON SK.SKU = CD.SKU                                      " &
" LEFT JOIN WMWHSE4.LOTXLOCXID LL                                " &
"        ON LL.LOT = CD.LOT                                      " &
"       AND LL.LOC = CD.LOC                                      " &
"       AND LL.ID = CD.ID                                        " &
"       AND LL.SKU = CD.SKU                                      " &
" LEFT OUTER JOIN (SELECT LOC,status FROM WMWHSE4.INVENTORYHOLD  " &
"       where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC      " &
"       WHERE CD.STATUS = 9 ) Q1                                 " &
" LEFT JOIN WMWHSE4.INVENTORYHOLDCODE IH ON Q1.WARR = IH.CODE    " &
"GROUP BY Q1.ITEM_WMS, Q1.NOME_ITEM, NVL(Q1.WARR, 'OK'),         " &
"         NVL(IH.DESCRIPTION,'OK'), Q1.SIMULACAO,                " &
"         Q1.ID_PLANTA, Q1.NOME_PLANTA                           " &
"                                                                " &
"UNION                                                           " &
"                                                                " &
"SELECT Q1.ITEM_WMS,                                             " &
"       Q1.NOME_ITEM,                                            " &
"       NVL(Q1.WARR, 'OK') ID_WARR,                              " &
"       NVL(IH.DESCRIPTION,'OK') DESC_WARR,                      " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                             " &
"       sum(Q1.QT_FISICA) QT_FISICA,                             " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                               " &
"       Q1.SIMULACAO,                                            " &
"       Q1.ID_PLANTA,                                            " &
"       Q1.NOME_PLANTA                                           " &
"FROM ( select TO_CHAR(CC.CCKEY)    ID_INVENTARIO,               " &
"              CD.LOC               ID_LOCAL,                    " &
"              CD.SKU               ITEM_WMS,                    " &
"              SK.DESCR             NOME_ITEM,                   " &
"              CD.SYSQTY            QT_LOGICA,                   " &
"              CD.SYSQTY+CD.ADJQTY  QT_FISICA,                   " &
"              CD.ADJQTY            VAR_QTDE,                    " &
"              ' '                  SIMULACAO,                   " &
"              CC.WHSEID            ID_PLANTA,                   " &
"              CL.UDF2              NOME_PLANTA,                 " &
"              T.STATUS             WARR                         " &
"         from WMWHSE5.CC CC                                     " &
"   inner join WMWHSE5.CCDETAIL CD                               " &
"           on CD.CCKEY = CC.CCKEY                               " &
"   inner join ENTERPRISE.CODELKUP CL                            " &
"           on upper(CL.UDF1) = CC.WHSEID                        " &
"          and CL.LISTNAME = 'SCHEMA'                            " &
"   inner join WMWHSE5.SKU SK                                    " &
"           on SK.SKU = CD.SKU                                   " &
" left outer join (SELECT LOC,status FROM WMWHSE5.INVENTORYHOLD  " &
"   where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC          " &
"        where CC.STATUS < 9                                     " &
"UNION                                                           " &
"    SELECT ' '                       ID_INVENTARIO,             " &
"           CD.LOC                    ID_LOCAL,                  " &
"           CD.SKU                    ITEM_WMS,                  " &
"           SK.DESCR                  NOME_ITEM,                 " &
"           nvl(LL.QTY,0)             QT_LOGICA,                 " &
"           CD.QTY                    QT_FISICA,                 " &
"           CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,                  " &
"           ' '                       SIMULACAO,                 " &
"           CD.WHSEID                 ID_PLANTA,                 " &
"           CL.UDF2                   NOME_PLANTA,               " &
"           T.STATUS                  WARR                       " &
"      FROM WMWHSE5.PHYSICAL CD                                  " &
"INNER JOIN ENTERPRISE.CODELKUP CL                               " &
"        ON UPPER(CL.UDF1) = CD.WHSEID                           " &
"       AND CL.LISTNAME = 'SCHEMA'                               " &
"INNER JOIN WMWHSE5.SKU SK                                       " &
"        ON SK.SKU = CD.SKU                                      " &
" LEFT JOIN WMWHSE5.LOTXLOCXID LL                                " &
"        ON LL.LOT = CD.LOT                                      " &
"       AND LL.LOC = CD.LOC                                      " &
"       AND LL.ID = CD.ID                                        " &
"       AND LL.SKU = CD.SKU                                      " &
" LEFT OUTER JOIN (SELECT LOC,status FROM WMWHSE5.INVENTORYHOLD  " &
"       where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC      " &
"       WHERE CD.STATUS = 9 ) Q1                                 " &
" LEFT JOIN WMWHSE5.INVENTORYHOLDCODE IH ON Q1.WARR = IH.CODE    " &
"GROUP BY Q1.ITEM_WMS, Q1.NOME_ITEM, NVL(Q1.WARR, 'OK'),         " &
"         NVL(IH.DESCRIPTION,'OK'), Q1.SIMULACAO,                " &
"         Q1.ID_PLANTA, Q1.NOME_PLANTA                           " &
"                                                                " &
"UNION                                                           " &
"                                                                " &
"SELECT Q1.ITEM_WMS,                                             " &
"       Q1.NOME_ITEM,                                            " &
"       NVL(Q1.WARR, 'OK') ID_WARR,                              " &
"       NVL(IH.DESCRIPTION,'OK') DESC_WARR,                      " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                             " &
"       sum(Q1.QT_FISICA) QT_FISICA,                             " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                               " &
"       Q1.SIMULACAO,                                            " &
"       Q1.ID_PLANTA,                                            " &
"       Q1.NOME_PLANTA                                           " &
"FROM ( select TO_CHAR(CC.CCKEY)    ID_INVENTARIO,               " &
"              CD.LOC               ID_LOCAL,                    " &
"              CD.SKU               ITEM_WMS,                    " &
"              SK.DESCR             NOME_ITEM,                   " &
"              CD.SYSQTY            QT_LOGICA,                   " &
"              CD.SYSQTY+CD.ADJQTY  QT_FISICA,                   " &
"              CD.ADJQTY            VAR_QTDE,                    " &
"              ' '                  SIMULACAO,                   " &
"              CC.WHSEID            ID_PLANTA,                   " &
"              CL.UDF2              NOME_PLANTA,                 " &
"              T.STATUS             WARR                         " &
"         from WMWHSE6.CC CC                                     " &
"   inner join WMWHSE6.CCDETAIL CD                               " &
"           on CD.CCKEY = CC.CCKEY                               " &
"   inner join ENTERPRISE.CODELKUP CL                            " &
"           on upper(CL.UDF1) = CC.WHSEID                        " &
"          and CL.LISTNAME = 'SCHEMA'                            " &
"   inner join WMWHSE6.SKU SK                                    " &
"           on SK.SKU = CD.SKU                                   " &
" left outer join (SELECT LOC,status FROM WMWHSE6.INVENTORYHOLD  " &
"   where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC          " &
"        where CC.STATUS < 9                                     " &
"UNION                                                           " &
"    SELECT ' '                       ID_INVENTARIO,             " &
"           CD.LOC                    ID_LOCAL,                  " &
"           CD.SKU                    ITEM_WMS,                  " &
"           SK.DESCR                  NOME_ITEM,                 " &
"           nvl(LL.QTY,0)             QT_LOGICA,                 " &
"           CD.QTY                    QT_FISICA,                 " &
"           CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,                  " &
"           ' '                       SIMULACAO,                 " &
"           CD.WHSEID                 ID_PLANTA,                 " &
"           CL.UDF2                   NOME_PLANTA,               " &
"           T.STATUS                  WARR                       " &
"      FROM WMWHSE6.PHYSICAL CD                                  " &
"INNER JOIN ENTERPRISE.CODELKUP CL                               " &
"        ON UPPER(CL.UDF1) = CD.WHSEID                           " &
"       AND CL.LISTNAME = 'SCHEMA'                               " &
"INNER JOIN WMWHSE6.SKU SK                                       " &
"        ON SK.SKU = CD.SKU                                      " &
" LEFT JOIN WMWHSE6.LOTXLOCXID LL                                " &
"        ON LL.LOT = CD.LOT                                      " &
"       AND LL.LOC = CD.LOC                                      " &
"       AND LL.ID = CD.ID                                        " &
"       AND LL.SKU = CD.SKU                                      " &
" LEFT OUTER JOIN (SELECT LOC,status FROM WMWHSE6.INVENTORYHOLD  " &
"       where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC      " &
"       WHERE CD.STATUS = 9 ) Q1                                 " &
" LEFT JOIN WMWHSE6.INVENTORYHOLDCODE IH ON Q1.WARR = IH.CODE    " &
"GROUP BY Q1.ITEM_WMS, Q1.NOME_ITEM, NVL(Q1.WARR, 'OK'),         " &
"         NVL(IH.DESCRIPTION,'OK'), Q1.SIMULACAO,                " &
"         Q1.ID_PLANTA, Q1.NOME_PLANTA                           " &
"                                                                " &
"UNION                                                           " &
"                                                                " &
"SELECT Q1.ITEM_WMS,                                             " &
"       Q1.NOME_ITEM,                                            " &
"       NVL(Q1.WARR, 'OK') ID_WARR,                              " &
"       NVL(IH.DESCRIPTION,'OK') DESC_WARR,                      " &
"       sum(Q1.QT_LOGICA) QT_LOGICA,                             " &
"       sum(Q1.QT_FISICA) QT_FISICA,                             " &
"       sum(Q1.VAR_QTDE) VAR_QTDE,                               " &
"       Q1.SIMULACAO,                                            " &
"       Q1.ID_PLANTA,                                            " &
"       Q1.NOME_PLANTA                                           " &
"FROM ( select TO_CHAR(CC.CCKEY)    ID_INVENTARIO,               " &
"              CD.LOC               ID_LOCAL,                    " &
"              CD.SKU               ITEM_WMS,                    " &
"              SK.DESCR             NOME_ITEM,                   " &
"              CD.SYSQTY            QT_LOGICA,                   " &
"              CD.SYSQTY+CD.ADJQTY  QT_FISICA,                   " &
"              CD.ADJQTY            VAR_QTDE,                    " &
"              ' '                  SIMULACAO,                   " &
"              CC.WHSEID            ID_PLANTA,                   " &
"              CL.UDF2              NOME_PLANTA,                 " &
"              T.STATUS             WARR                         " &
"         from WMWHSE7.CC CC                                     " &
"   inner join WMWHSE7.CCDETAIL CD                               " &
"           on CD.CCKEY = CC.CCKEY                               " &
"   inner join ENTERPRISE.CODELKUP CL                            " &
"           on upper(CL.UDF1) = CC.WHSEID                        " &
"          and CL.LISTNAME = 'SCHEMA'                            " &
"   inner join WMWHSE7.SKU SK                                    " &
"           on SK.SKU = CD.SKU                                   " &
" left outer join (SELECT LOC,status FROM WMWHSE7.INVENTORYHOLD  " &
"   where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC          " &
"        where CC.STATUS < 9                                     " &
"UNION                                                           " &
"    SELECT ' '                       ID_INVENTARIO,             " &
"           CD.LOC                    ID_LOCAL,                  " &
"           CD.SKU                    ITEM_WMS,                  " &
"           SK.DESCR                  NOME_ITEM,                 " &
"           nvl(LL.QTY,0)             QT_LOGICA,                 " &
"           CD.QTY                    QT_FISICA,                 " &
"           CD.QTY - nvl(LL.QTY,0)    VAR_QTDE,                  " &
"           ' '                       SIMULACAO,                 " &
"           CD.WHSEID                 ID_PLANTA,                 " &
"           CL.UDF2                   NOME_PLANTA,               " &
"           T.STATUS                  WARR                       " &
"      FROM WMWHSE7.PHYSICAL CD                                  " &
"INNER JOIN ENTERPRISE.CODELKUP CL                               " &
"        ON UPPER(CL.UDF1) = CD.WHSEID                           " &
"       AND CL.LISTNAME = 'SCHEMA'                               " &
"INNER JOIN WMWHSE7.SKU SK                                       " &
"        ON SK.SKU = CD.SKU                                      " &
" LEFT JOIN WMWHSE7.LOTXLOCXID LL                                " &
"        ON LL.LOT = CD.LOT                                      " &
"       AND LL.LOC = CD.LOC                                      " &
"       AND LL.ID = CD.ID                                        " &
"       AND LL.SKU = CD.SKU                                      " &
" LEFT OUTER JOIN (SELECT LOC,status FROM WMWHSE7.INVENTORYHOLD  " &
"       where hold = 1 and loc <> ' ' ) T on CD.LOC = T.LOC      " &
"       WHERE CD.STATUS = 9 ) Q1                                 " &
" LEFT JOIN WMWHSE7.INVENTORYHOLDCODE IH ON Q1.WARR = IH.CODE    " &
"GROUP BY Q1.ITEM_WMS, Q1.NOME_ITEM, NVL(Q1.WARR, 'OK'),         " &
"         NVL(IH.DESCRIPTION,'OK'), Q1.SIMULACAO,                " &
"         Q1.ID_PLANTA, Q1.NOME_PLANTA                           " &
"ORDER BY NOME_PLANTA, NOME_ITEM                                 "
)