SELECT
  DISTINCT
    SKUXLOC.SKU                             ID_ITEM,
    SKU.DESCR                               NOME,
    SKU.ACTIVE                              ITEG_SITUACAO,
    ENT_SKU.ID_DEPART                       COD_DEPTO,
    ENT_SKU.DEPART_NAME                     DEPTO,
    ENT_SKU.ID_SECTOR                       COD_SETOR,
    ENT_SKU.SECTOR_NAME                     SETOR,
    LN_ITEM.T$FAMI$C                        COD_FAMILIA,
    LN_ITEM.DS_FAMI                         FAMILIA,
    LN_ITEM.T$SUBF$C                        COD_SUB,
    LN_ITEM.DS_SUBF                         SUB,
    cl.UDF2                                 ID_FILIAL,
    SUM(SKUXLOC.QTY)                        QT_FISICA,
    NVL(ROMANEADA.QT_ROMANEADA, 0)          QT_ROMANEADA,
    SUM(SKUXLOC.QTYALLOCATED)               QT_RESERVADA,
    SUM(SKUXLOC.QTY - SKUXLOC.QTYALLOCATED) QT_SALDO,
    NVL(max(maucLN.mauc),0)                 VL_UNITARIO,
    SKU.SUSR5                               ID_FORNECEDOR,
    STORER.COMPANY                          FORN_NOME

FROM       WMWHSE5.SKU

INNER JOIN ENTERPRISE.CODELKUP cl
        ON UPPER(cl.UDF1) = sku.WHSEID
    
INNER JOIN WMWHSE5.SKUXLOC
        ON SKUXLOC.SKU = SKU.SKU
       AND SKUXLOC.WHSEID = SKU.WHSEID

 LEFT JOIN ( SELECT IBD001.T$ITEM, 
                    IBD001.T$FAMI$C, 
                    IBD001.T$SUBF$C, 
                    MCS031.T$DSCA$C DS_FAMI, 
                    MCS032.T$DSCA$C DS_SUBF             
               FROM BAANDB.TTCIBD001301@pln01 IBD001
          LEFT JOIN BAANDB.TZNMCS031301@pln01 MCS031
                 ON MCS031.T$FAMI$C = IBD001.T$FAMI$C
                AND MCS031.T$CITG$C = IBD001.T$CITG
                AND MCS031.T$SETO$C = IBD001.T$SETO$C
          LEFT JOIN BAANDB.TZNMCS032301@pln01 MCS032
                 ON MCS032.T$SUBF$C = IBD001.T$SUBF$C
                AND MCS032.T$CITG$C = IBD001.T$CITG
                AND MCS032.T$SETO$C = IBD001.T$SETO$C
                AND MCS032.T$FAMI$C = IBD001.T$FAMI$C ) LN_ITEM
        ON TRIM(LN_ITEM.T$ITEM) = SKU.SKU

 LEFT JOIN ( select whwmd217.t$item,
                    whwmd217.t$cwar,
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
        ON maucLN.t$cwar = subStr(cl.DESCRIPTION,3,6)
       AND trim(maucLN.t$item) = sku.sku
    
 LEFT JOIN ENTERPRISE.DEPARTSECTORSKU ENT_SKU
        ON TO_CHAR(ENT_SKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)
       AND TO_CHAR(ENT_SKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)

 LEFT JOIN WMWHSE5.STORER
        ON STORER.STORERKEY = SKU.SUSR5
       AND STORER.WHSEID = SKU.WHSEID
       
 LEFT JOIN ( SELECT SUM(OD.QTYALLOCATED) QT_ROMANEADA,
                    OD.SKU
               FROM WMWHSE5.orderdetail OD
              WHERE OD.STATUS BETWEEN '29' AND '94' 
           GROUP BY OD.SKU ) ROMANEADA
        ON ROMANEADA.SKU = SKUXLOC.SKU
       
WHERE STORER.TYPE = 5
  AND cl.LISTNAME = 'SCHEMA'
  AND SKUXLOC.QTY > 0

GROUP BY SKUXLOC.SKU,
         SKU.DESCR,
         SKU.ACTIVE,
         ENT_SKU.ID_DEPART,
         ENT_SKU.DEPART_NAME,
         ENT_SKU.ID_SECTOR,
         ENT_SKU.SECTOR_NAME,
         LN_ITEM.T$FAMI$C,
         LN_ITEM.DS_FAMI,
         LN_ITEM.T$SUBF$C,
         LN_ITEM.DS_SUBF,
         cl.UDF2,
         ROMANEADA.QT_ROMANEADA,
         SKU.SUSR5,
         STORER.COMPANY


"SELECT                                                            " &
"  DISTINCT                                                        " &
"    SKUXLOC.SKU                             ID_ITEM,              " &
"    SKU.DESCR                               NOME,                 " &
"    SKU.ACTIVE                              ITEG_SITUACAO,        " &
"    ENT_SKU.ID_DEPART                       COD_DEPTO,            " &
"    ENT_SKU.DEPART_NAME                     DEPTO,                " &
"    ENT_SKU.ID_SECTOR                       COD_SETOR,            " &
"    ENT_SKU.SECTOR_NAME                     SETOR,                " &
"    LN_ITEM.T$FAMI$C                        COD_FAMILIA,          " &
"    LN_ITEM.DS_FAMI                         FAMILIA,              " &
"    LN_ITEM.T$SUBF$C                        COD_SUB,              " &
"    LN_ITEM.DS_SUBF                         SUB,                  " &
"    cl.UDF2                                 ID_FILIAL,            " &
"    SUM(SKUXLOC.QTY)                        QT_FISICA,            " &
"    NVL(ROMANEADA.QT_ROMANEADA, 0)          QT_ROMANEADA,         " &
"    SUM(SKUXLOC.QTYALLOCATED)               QT_RESERVADA,         " &
"    SUM(SKUXLOC.QTY - SKUXLOC.QTYALLOCATED) QT_SALDO,             " &
"    NVL(max(maucLN.mauc),0)                 VL_UNITARIO,          " &
"    SKU.SUSR5                               ID_FORNECEDOR,        " &
"    STORER.COMPANY                          FORN_NOME             " &
"                                                                  " &
"FROM       " + Parameters!Table.Value + ".SKU                     " &
"                                                                  " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                 " &
"        ON UPPER(cl.UDF1) = sku.WHSEID                            " &
"                                                                  " &
"INNER JOIN " + Parameters!Table.Value + ".SKUXLOC                 " &
"        ON SKUXLOC.SKU = SKU.SKU                                  " &
"       AND SKUXLOC.WHSEID = SKU.WHSEID                            " &
"                                                                  " &
" LEFT JOIN ( SELECT IBD001.T$ITEM,                                " &
"                    IBD001.T$FAMI$C,                              " &
"                    IBD001.T$SUBF$C,                              " &
"                    MCS031.T$DSCA$C DS_FAMI,                      " &
"                    MCS032.T$DSCA$C DS_SUBF                       " &
"               FROM BAANDB.TTCIBD001301@pln01 IBD001              " &
"          LEFT JOIN BAANDB.TZNMCS031301@pln01 MCS031              " &
"                 ON MCS031.T$FAMI$C = IBD001.T$FAMI$C             " &
"                AND MCS031.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS031.T$SETO$C = IBD001.T$SETO$C             " &
"          LEFT JOIN BAANDB.TZNMCS032301@pln01 MCS032              " &
"                 ON MCS032.T$SUBF$C = IBD001.T$SUBF$C             " &
"                AND MCS032.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS032.T$SETO$C = IBD001.T$SETO$C             " &
"                AND MCS032.T$FAMI$C = IBD001.T$FAMI$C ) LN_ITEM   " &
"        ON TRIM(LN_ITEM.T$ITEM) = SKU.SKU                         " &
"                                                                  " &
" LEFT JOIN ( select whwmd217.t$item,                              " &
"                    whwmd217.t$cwar,                              " &
"                    case when sum(a.t$qhnd) = 0                   " &
"                           then 0                                 " &
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc                                     " &
"               from baandb.twhwmd217301@pln01 whwmd217            " &
"         inner join baandb.twhinr140301@pln01 a                   " &
"                 on a.t$cwar = whwmd217.t$cwar                    " &
"                and a.t$item = whwmd217.t$item                    " &
"              where whwmd217.t$mauc$1 != 0                        " &
"           group by whwmd217.t$item,                              " &
"                    whwmd217.t$cwar ) maucLN                      " &
"        ON maucLN.t$cwar = subStr(cl.DESCRIPTION,3,6)             " &
"       AND trim(maucLN.t$item) = sku.sku                          " &
"                                                                  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU ENT_SKU                     " &
"        ON TO_CHAR(ENT_SKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)     " &
"       AND TO_CHAR(ENT_SKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)    " &
"                                                                  " &
" LEFT JOIN " + Parameters!Table.Value + ".STORER                  " &
"        ON STORER.STORERKEY = SKU.SUSR5                           " &
"       AND STORER.WHSEID = SKU.WHSEID                             " &
"                                                                  " &
" LEFT JOIN ( SELECT SUM(OD.QTYALLOCATED) QT_ROMANEADA,            " &
"                    OD.SKU                                        " &
"               FROM " + Parameters!Table.Value + ".orderdetail OD " &
"              WHERE OD.STATUS BETWEEN '29' AND '94'               " &
"           GROUP BY OD.SKU ) ROMANEADA                            " &
"        ON ROMANEADA.SKU = SKUXLOC.SKU                            " &
"                                                                  " &
"WHERE STORER.TYPE = 5                                             " &
"  AND cl.LISTNAME = 'SCHEMA'                                      " &
"  AND SKUXLOC.QTY > 0                                             " &
"                                                                  " &
"GROUP BY SKUXLOC.SKU,                                             " &
"         SKU.DESCR,                                               " &
"         SKU.ACTIVE,                                              " &
"         ENT_SKU.ID_DEPART,                                       " &
"         ENT_SKU.DEPART_NAME,                                     " &
"         ENT_SKU.ID_SECTOR,                                       " &
"         ENT_SKU.SECTOR_NAME,                                     " &
"         LN_ITEM.T$FAMI$C,                                        " &
"         LN_ITEM.DS_FAMI,                                         " &
"         LN_ITEM.T$SUBF$C,                                        " &
"         LN_ITEM.DS_SUBF,                                         " &
"         cl.UDF2,                                                 " &
"         ROMANEADA.QT_ROMANEADA,                                  " &
"         SKU.SUSR5,                                               " &
"         STORER.COMPANY                                           "		 
		 
-- Query com UNION ****************************************************
		 
"SELECT                                                            " &
"  DISTINCT                                                        " &
"    SKUXLOC.SKU                             ID_ITEM,              " &
"    SKU.DESCR                               NOME,                 " &
"    SKU.ACTIVE                              ITEG_SITUACAO,        " &
"    ENT_SKU.ID_DEPART                       COD_DEPTO,            " &
"    ENT_SKU.DEPART_NAME                     DEPTO,                " &
"    ENT_SKU.ID_SECTOR                       COD_SETOR,            " &
"    ENT_SKU.SECTOR_NAME                     SETOR,                " &
"    LN_ITEM.T$FAMI$C                        COD_FAMILIA,          " &
"    LN_ITEM.DS_FAMI                         FAMILIA,              " &
"    LN_ITEM.T$SUBF$C                        COD_SUB,              " &
"    LN_ITEM.DS_SUBF                         SUB,                  " &
"    cl.UDF2                                 ID_FILIAL,            " &
"    SUM(SKUXLOC.QTY)                        QT_FISICA,            " &
"    NVL(ROMANEADA.QT_ROMANEADA, 0)          QT_ROMANEADA,         " &
"    SUM(SKUXLOC.QTYALLOCATED)               QT_RESERVADA,         " &
"    SUM(SKUXLOC.QTY - SKUXLOC.QTYALLOCATED) QT_SALDO,             " &
"    NVL(max(maucLN.mauc),0)                 VL_UNITARIO,          " &
"    SKU.SUSR5                               ID_FORNECEDOR,        " &
"    STORER.COMPANY                          FORN_NOME             " &
"                                                                  " &
"FROM       WMWHSE1.SKU                                            " &
"                                                                  " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                 " &
"        ON UPPER(cl.UDF1) = sku.WHSEID                            " &
"                                                                  " &
"INNER JOIN WMWHSE1.SKUXLOC                                        " &
"        ON SKUXLOC.SKU = SKU.SKU                                  " &
"       AND SKUXLOC.WHSEID = SKU.WHSEID                            " &
"                                                                  " &
" LEFT JOIN ( SELECT IBD001.T$ITEM,                                " &
"                    IBD001.T$FAMI$C,                              " &
"                    IBD001.T$SUBF$C,                              " &
"                    MCS031.T$DSCA$C DS_FAMI,                      " &
"                    MCS032.T$DSCA$C DS_SUBF                       " &
"               FROM BAANDB.TTCIBD001301@pln01 IBD001              " &
"          LEFT JOIN BAANDB.TZNMCS031301@pln01 MCS031              " &
"                 ON MCS031.T$FAMI$C = IBD001.T$FAMI$C             " &
"                AND MCS031.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS031.T$SETO$C = IBD001.T$SETO$C             " &
"          LEFT JOIN BAANDB.TZNMCS032301@pln01 MCS032              " &
"                 ON MCS032.T$SUBF$C = IBD001.T$SUBF$C             " &
"                AND MCS032.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS032.T$SETO$C = IBD001.T$SETO$C             " &
"                AND MCS032.T$FAMI$C = IBD001.T$FAMI$C ) LN_ITEM   " &
"        ON TRIM(LN_ITEM.T$ITEM) = SKU.SKU                         " &
"                                                                  " &
" LEFT JOIN ( select whwmd217.t$item,                              " &
"                    whwmd217.t$cwar,                              " &
"                    case when sum(a.t$qhnd) = 0                   " &
"                           then 0                                 " &
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc                                     " &
"               from baandb.twhwmd217301@pln01 whwmd217            " &
"         inner join baandb.twhinr140301@pln01 a                   " &
"                 on a.t$cwar = whwmd217.t$cwar                    " &
"                and a.t$item = whwmd217.t$item                    " &
"              where whwmd217.t$mauc$1 != 0                        " &
"           group by whwmd217.t$item,                              " &
"                    whwmd217.t$cwar ) maucLN                      " &
"        ON maucLN.t$cwar = subStr(cl.DESCRIPTION,3,6)             " &
"       AND trim(maucLN.t$item) = sku.sku                          " &
"                                                                  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU ENT_SKU                     " &
"        ON TO_CHAR(ENT_SKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)     " &
"       AND TO_CHAR(ENT_SKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)    " &
"                                                                  " &
" LEFT JOIN WMWHSE1.STORER                                         " &
"        ON STORER.STORERKEY = SKU.SUSR5                           " &
"       AND STORER.WHSEID = SKU.WHSEID                             " &
"                                                                  " &
" LEFT JOIN ( SELECT SUM(OD.QTYALLOCATED) QT_ROMANEADA,            " &
"                    OD.SKU                                        " &
"               FROM WMWHSE1.orderdetail OD                        " &
"              WHERE OD.STATUS BETWEEN '29' AND '94'               " &
"           GROUP BY OD.SKU ) ROMANEADA                            " &
"        ON ROMANEADA.SKU = SKUXLOC.SKU                            " &
"                                                                  " &
"WHERE STORER.TYPE = 5                                             " &
"  AND cl.LISTNAME = 'SCHEMA'                                      " &
"  AND SKUXLOC.QTY > 0                                             " &
"                                                                  " &
"GROUP BY SKUXLOC.SKU,                                             " &
"         SKU.DESCR,                                               " &
"         SKU.ACTIVE,                                              " &
"         ENT_SKU.ID_DEPART,                                       " &
"         ENT_SKU.DEPART_NAME,                                     " &
"         ENT_SKU.ID_SECTOR,                                       " &
"         ENT_SKU.SECTOR_NAME,                                     " &
"         LN_ITEM.T$FAMI$C,                                        " &
"         LN_ITEM.DS_FAMI,                                         " &
"         LN_ITEM.T$SUBF$C,                                        " &
"         LN_ITEM.DS_SUBF,                                         " &
"         cl.UDF2,                                                 " &
"         ROMANEADA.QT_ROMANEADA,                                  " &
"         SKU.SUSR5,                                               " &
"         STORER.COMPANY                                           " &
"                                                                  " &
"Union                                                             " &
"                                                                  " &
"SELECT                                                            " &
"  DISTINCT                                                        " &
"    SKUXLOC.SKU                             ID_ITEM,              " &
"    SKU.DESCR                               NOME,                 " &
"    SKU.ACTIVE                              ITEG_SITUACAO,        " &
"    ENT_SKU.ID_DEPART                       COD_DEPTO,            " &
"    ENT_SKU.DEPART_NAME                     DEPTO,                " &
"    ENT_SKU.ID_SECTOR                       COD_SETOR,            " &
"    ENT_SKU.SECTOR_NAME                     SETOR,                " &
"    LN_ITEM.T$FAMI$C                        COD_FAMILIA,          " &
"    LN_ITEM.DS_FAMI                         FAMILIA,              " &
"    LN_ITEM.T$SUBF$C                        COD_SUB,              " &
"    LN_ITEM.DS_SUBF                         SUB,                  " &
"    cl.UDF2                                 ID_FILIAL,            " &
"    SUM(SKUXLOC.QTY)                        QT_FISICA,            " &
"    NVL(ROMANEADA.QT_ROMANEADA, 0)          QT_ROMANEADA,         " &
"    SUM(SKUXLOC.QTYALLOCATED)               QT_RESERVADA,         " &
"    SUM(SKUXLOC.QTY - SKUXLOC.QTYALLOCATED) QT_SALDO,             " &
"    NVL(max(maucLN.mauc),0)                 VL_UNITARIO,          " &
"    SKU.SUSR5                               ID_FORNECEDOR,        " &
"    STORER.COMPANY                          FORN_NOME             " &
"                                                                  " &
"FROM       WMWHSE2.SKU                                            " &
"                                                                  " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                 " &
"        ON UPPER(cl.UDF1) = sku.WHSEID                            " &
"                                                                  " &
"INNER JOIN WMWHSE2.SKUXLOC                                        " &
"        ON SKUXLOC.SKU = SKU.SKU                                  " &
"       AND SKUXLOC.WHSEID = SKU.WHSEID                            " &
"                                                                  " &
" LEFT JOIN ( SELECT IBD001.T$ITEM,                                " &
"                    IBD001.T$FAMI$C,                              " &
"                    IBD001.T$SUBF$C,                              " &
"                    MCS031.T$DSCA$C DS_FAMI,                      " &
"                    MCS032.T$DSCA$C DS_SUBF                       " &
"               FROM BAANDB.TTCIBD001301@pln01 IBD001              " &
"          LEFT JOIN BAANDB.TZNMCS031301@pln01 MCS031              " &
"                 ON MCS031.T$FAMI$C = IBD001.T$FAMI$C             " &
"                AND MCS031.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS031.T$SETO$C = IBD001.T$SETO$C             " &
"          LEFT JOIN BAANDB.TZNMCS032301@pln01 MCS032              " &
"                 ON MCS032.T$SUBF$C = IBD001.T$SUBF$C             " &
"                AND MCS032.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS032.T$SETO$C = IBD001.T$SETO$C             " &
"                AND MCS032.T$FAMI$C = IBD001.T$FAMI$C ) LN_ITEM   " &
"        ON TRIM(LN_ITEM.T$ITEM) = SKU.SKU                         " &
"                                                                  " &
" LEFT JOIN ( select whwmd217.t$item,                              " &
"                    whwmd217.t$cwar,                              " &
"                    case when sum(a.t$qhnd) = 0                   " &
"                           then 0                                 " &
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc                                     " &
"               from baandb.twhwmd217301@pln01 whwmd217            " &
"         inner join baandb.twhinr140301@pln01 a                   " &
"                 on a.t$cwar = whwmd217.t$cwar                    " &
"                and a.t$item = whwmd217.t$item                    " &
"              where whwmd217.t$mauc$1 != 0                        " &
"           group by whwmd217.t$item,                              " &
"                    whwmd217.t$cwar ) maucLN                      " &
"        ON maucLN.t$cwar = subStr(cl.DESCRIPTION,3,6)             " &
"       AND trim(maucLN.t$item) = sku.sku                          " &
"                                                                  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU ENT_SKU                     " &
"        ON TO_CHAR(ENT_SKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)     " &
"       AND TO_CHAR(ENT_SKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)    " &
"                                                                  " &
" LEFT JOIN WMWHSE2.STORER                                         " &
"        ON STORER.STORERKEY = SKU.SUSR5                           " &
"       AND STORER.WHSEID = SKU.WHSEID                             " &
"                                                                  " &
" LEFT JOIN ( SELECT SUM(OD.QTYALLOCATED) QT_ROMANEADA,            " &
"                    OD.SKU                                        " &
"               FROM WMWHSE2.orderdetail OD                        " &
"              WHERE OD.STATUS BETWEEN '29' AND '94'               " &
"           GROUP BY OD.SKU ) ROMANEADA                            " &
"        ON ROMANEADA.SKU = SKUXLOC.SKU                            " &
"                                                                  " &
"WHERE STORER.TYPE = 5                                             " &
"  AND cl.LISTNAME = 'SCHEMA'                                      " &
"  AND SKUXLOC.QTY > 0                                             " &
"                                                                  " &
"GROUP BY SKUXLOC.SKU,                                             " &
"         SKU.DESCR,                                               " &
"         SKU.ACTIVE,                                              " &
"         ENT_SKU.ID_DEPART,                                       " &
"         ENT_SKU.DEPART_NAME,                                     " &
"         ENT_SKU.ID_SECTOR,                                       " &
"         ENT_SKU.SECTOR_NAME,                                     " &
"         LN_ITEM.T$FAMI$C,                                        " &
"         LN_ITEM.DS_FAMI,                                         " &
"         LN_ITEM.T$SUBF$C,                                        " &
"         LN_ITEM.DS_SUBF,                                         " &
"         cl.UDF2,                                                 " &
"         ROMANEADA.QT_ROMANEADA,                                  " &
"         SKU.SUSR5,                                               " &
"         STORER.COMPANY                                           " &
"                                                                  " &
"Union                                                             " &
"                                                                  " &
"SELECT                                                            " &
"  DISTINCT                                                        " &
"    SKUXLOC.SKU                             ID_ITEM,              " &
"    SKU.DESCR                               NOME,                 " &
"    SKU.ACTIVE                              ITEG_SITUACAO,        " &
"    ENT_SKU.ID_DEPART                       COD_DEPTO,            " &
"    ENT_SKU.DEPART_NAME                     DEPTO,                " &
"    ENT_SKU.ID_SECTOR                       COD_SETOR,            " &
"    ENT_SKU.SECTOR_NAME                     SETOR,                " &
"    LN_ITEM.T$FAMI$C                        COD_FAMILIA,          " &
"    LN_ITEM.DS_FAMI                         FAMILIA,              " &
"    LN_ITEM.T$SUBF$C                        COD_SUB,              " &
"    LN_ITEM.DS_SUBF                         SUB,                  " &
"    cl.UDF2                                 ID_FILIAL,            " &
"    SUM(SKUXLOC.QTY)                        QT_FISICA,            " &
"    NVL(ROMANEADA.QT_ROMANEADA, 0)          QT_ROMANEADA,         " &
"    SUM(SKUXLOC.QTYALLOCATED)               QT_RESERVADA,         " &
"    SUM(SKUXLOC.QTY - SKUXLOC.QTYALLOCATED) QT_SALDO,             " &
"    NVL(max(maucLN.mauc),0)                 VL_UNITARIO,          " &
"    SKU.SUSR5                               ID_FORNECEDOR,        " &
"    STORER.COMPANY                          FORN_NOME             " &
"                                                                  " &
"FROM       WMWHSE3.SKU                                            " &
"                                                                  " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                 " &
"        ON UPPER(cl.UDF1) = sku.WHSEID                            " &
"                                                                  " &
"INNER JOIN WMWHSE3.SKUXLOC                                        " &
"        ON SKUXLOC.SKU = SKU.SKU                                  " &
"       AND SKUXLOC.WHSEID = SKU.WHSEID                            " &
"                                                                  " &
" LEFT JOIN ( SELECT IBD001.T$ITEM,                                " &
"                    IBD001.T$FAMI$C,                              " &
"                    IBD001.T$SUBF$C,                              " &
"                    MCS031.T$DSCA$C DS_FAMI,                      " &
"                    MCS032.T$DSCA$C DS_SUBF                       " &
"               FROM BAANDB.TTCIBD001301@pln01 IBD001              " &
"          LEFT JOIN BAANDB.TZNMCS031301@pln01 MCS031              " &
"                 ON MCS031.T$FAMI$C = IBD001.T$FAMI$C             " &
"                AND MCS031.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS031.T$SETO$C = IBD001.T$SETO$C             " &
"          LEFT JOIN BAANDB.TZNMCS032301@pln01 MCS032              " &
"                 ON MCS032.T$SUBF$C = IBD001.T$SUBF$C             " &
"                AND MCS032.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS032.T$SETO$C = IBD001.T$SETO$C             " &
"                AND MCS032.T$FAMI$C = IBD001.T$FAMI$C ) LN_ITEM   " &
"        ON TRIM(LN_ITEM.T$ITEM) = SKU.SKU                         " &
"                                                                  " &
" LEFT JOIN ( select whwmd217.t$item,                              " &
"                    whwmd217.t$cwar,                              " &
"                    case when sum(a.t$qhnd) = 0                   " &
"                           then 0                                 " &
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc                                     " &
"               from baandb.twhwmd217301@pln01 whwmd217            " &
"         inner join baandb.twhinr140301@pln01 a                   " &
"                 on a.t$cwar = whwmd217.t$cwar                    " &
"                and a.t$item = whwmd217.t$item                    " &
"              where whwmd217.t$mauc$1 != 0                        " &
"           group by whwmd217.t$item,                              " &
"                    whwmd217.t$cwar ) maucLN                      " &
"        ON maucLN.t$cwar = subStr(cl.DESCRIPTION,3,6)             " &
"       AND trim(maucLN.t$item) = sku.sku                          " &
"                                                                  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU ENT_SKU                     " &
"        ON TO_CHAR(ENT_SKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)     " &
"       AND TO_CHAR(ENT_SKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)    " &
"                                                                  " &
" LEFT JOIN WMWHSE3.STORER                                         " &
"        ON STORER.STORERKEY = SKU.SUSR5                           " &
"       AND STORER.WHSEID = SKU.WHSEID                             " &
"                                                                  " &
" LEFT JOIN ( SELECT SUM(OD.QTYALLOCATED) QT_ROMANEADA,            " &
"                    OD.SKU                                        " &
"               FROM WMWHSE3.orderdetail OD                        " &
"              WHERE OD.STATUS BETWEEN '29' AND '94'               " &
"           GROUP BY OD.SKU ) ROMANEADA                            " &
"        ON ROMANEADA.SKU = SKUXLOC.SKU                            " &
"                                                                  " &
"WHERE STORER.TYPE = 5                                             " &
"  AND cl.LISTNAME = 'SCHEMA'                                      " &
"  AND SKUXLOC.QTY > 0                                             " &
"                                                                  " &
"GROUP BY SKUXLOC.SKU,                                             " &
"         SKU.DESCR,                                               " &
"         SKU.ACTIVE,                                              " &
"         ENT_SKU.ID_DEPART,                                       " &
"         ENT_SKU.DEPART_NAME,                                     " &
"         ENT_SKU.ID_SECTOR,                                       " &
"         ENT_SKU.SECTOR_NAME,                                     " &
"         LN_ITEM.T$FAMI$C,                                        " &
"         LN_ITEM.DS_FAMI,                                         " &
"         LN_ITEM.T$SUBF$C,                                        " &
"         LN_ITEM.DS_SUBF,                                         " &
"         cl.UDF2,                                                 " &
"         ROMANEADA.QT_ROMANEADA,                                  " &
"         SKU.SUSR5,                                               " &
"         STORER.COMPANY                                           " &
"                                                                  " &
"Union                                                             " &
"                                                                  " &
"SELECT                                                            " &
"  DISTINCT                                                        " &
"    SKUXLOC.SKU                             ID_ITEM,              " &
"    SKU.DESCR                               NOME,                 " &
"    SKU.ACTIVE                              ITEG_SITUACAO,        " &
"    ENT_SKU.ID_DEPART                       COD_DEPTO,            " &
"    ENT_SKU.DEPART_NAME                     DEPTO,                " &
"    ENT_SKU.ID_SECTOR                       COD_SETOR,            " &
"    ENT_SKU.SECTOR_NAME                     SETOR,                " &
"    LN_ITEM.T$FAMI$C                        COD_FAMILIA,          " &
"    LN_ITEM.DS_FAMI                         FAMILIA,              " &
"    LN_ITEM.T$SUBF$C                        COD_SUB,              " &
"    LN_ITEM.DS_SUBF                         SUB,                  " &
"    cl.UDF2                                 ID_FILIAL,            " &
"    SUM(SKUXLOC.QTY)                        QT_FISICA,            " &
"    NVL(ROMANEADA.QT_ROMANEADA, 0)          QT_ROMANEADA,         " &
"    SUM(SKUXLOC.QTYALLOCATED)               QT_RESERVADA,         " &
"    SUM(SKUXLOC.QTY - SKUXLOC.QTYALLOCATED) QT_SALDO,             " &
"    NVL(max(maucLN.mauc),0)                 VL_UNITARIO,          " &
"    SKU.SUSR5                               ID_FORNECEDOR,        " &
"    STORER.COMPANY                          FORN_NOME             " &
"                                                                  " &
"FROM       WMWHSE4.SKU                                            " &
"                                                                  " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                 " &
"        ON UPPER(cl.UDF1) = sku.WHSEID                            " &
"                                                                  " &
"INNER JOIN WMWHSE4.SKUXLOC                                        " &
"        ON SKUXLOC.SKU = SKU.SKU                                  " &
"       AND SKUXLOC.WHSEID = SKU.WHSEID                            " &
"                                                                  " &
" LEFT JOIN ( SELECT IBD001.T$ITEM,                                " &
"                    IBD001.T$FAMI$C,                              " &
"                    IBD001.T$SUBF$C,                              " &
"                    MCS031.T$DSCA$C DS_FAMI,                      " &
"                    MCS032.T$DSCA$C DS_SUBF                       " &
"               FROM BAANDB.TTCIBD001301@pln01 IBD001              " &
"          LEFT JOIN BAANDB.TZNMCS031301@pln01 MCS031              " &
"                 ON MCS031.T$FAMI$C = IBD001.T$FAMI$C             " &
"                AND MCS031.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS031.T$SETO$C = IBD001.T$SETO$C             " &
"          LEFT JOIN BAANDB.TZNMCS032301@pln01 MCS032              " &
"                 ON MCS032.T$SUBF$C = IBD001.T$SUBF$C             " &
"                AND MCS032.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS032.T$SETO$C = IBD001.T$SETO$C             " &
"                AND MCS032.T$FAMI$C = IBD001.T$FAMI$C ) LN_ITEM   " &
"        ON TRIM(LN_ITEM.T$ITEM) = SKU.SKU                         " &
"                                                                  " &
" LEFT JOIN ( select whwmd217.t$item,                              " &
"                    whwmd217.t$cwar,                              " &
"                    case when sum(a.t$qhnd) = 0                   " &
"                           then 0                                 " &
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc                                     " &
"               from baandb.twhwmd217301@pln01 whwmd217            " &
"         inner join baandb.twhinr140301@pln01 a                   " &
"                 on a.t$cwar = whwmd217.t$cwar                    " &
"                and a.t$item = whwmd217.t$item                    " &
"              where whwmd217.t$mauc$1 != 0                        " &
"           group by whwmd217.t$item,                              " &
"                    whwmd217.t$cwar ) maucLN                      " &
"        ON maucLN.t$cwar = subStr(cl.DESCRIPTION,3,6)             " &
"       AND trim(maucLN.t$item) = sku.sku                          " &
"                                                                  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU ENT_SKU                     " &
"        ON TO_CHAR(ENT_SKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)     " &
"       AND TO_CHAR(ENT_SKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)    " &
"                                                                  " &
" LEFT JOIN WMWHSE4.STORER                                         " &
"        ON STORER.STORERKEY = SKU.SUSR5                           " &
"       AND STORER.WHSEID = SKU.WHSEID                             " &
"                                                                  " &
" LEFT JOIN ( SELECT SUM(OD.QTYALLOCATED) QT_ROMANEADA,            " &
"                    OD.SKU                                        " &
"               FROM WMWHSE4.orderdetail OD                        " &
"              WHERE OD.STATUS BETWEEN '29' AND '94'               " &
"           GROUP BY OD.SKU ) ROMANEADA                            " &
"        ON ROMANEADA.SKU = SKUXLOC.SKU                            " &
"                                                                  " &
"WHERE STORER.TYPE = 5                                             " &
"  AND cl.LISTNAME = 'SCHEMA'                                      " &
"  AND SKUXLOC.QTY > 0                                             " &
"                                                                  " &
"GROUP BY SKUXLOC.SKU,                                             " &
"         SKU.DESCR,                                               " &
"         SKU.ACTIVE,                                              " &
"         ENT_SKU.ID_DEPART,                                       " &
"         ENT_SKU.DEPART_NAME,                                     " &
"         ENT_SKU.ID_SECTOR,                                       " &
"         ENT_SKU.SECTOR_NAME,                                     " &
"         LN_ITEM.T$FAMI$C,                                        " &
"         LN_ITEM.DS_FAMI,                                         " &
"         LN_ITEM.T$SUBF$C,                                        " &
"         LN_ITEM.DS_SUBF,                                         " &
"         cl.UDF2,                                                 " &
"         ROMANEADA.QT_ROMANEADA,                                  " &
"         SKU.SUSR5,                                               " &
"         STORER.COMPANY                                           " &
"                                                                  " &
"Union                                                             " &
"                                                                  " &
"SELECT                                                            " &
"  DISTINCT                                                        " &
"    SKUXLOC.SKU                             ID_ITEM,              " &
"    SKU.DESCR                               NOME,                 " &
"    SKU.ACTIVE                              ITEG_SITUACAO,        " &
"    ENT_SKU.ID_DEPART                       COD_DEPTO,            " &
"    ENT_SKU.DEPART_NAME                     DEPTO,                " &
"    ENT_SKU.ID_SECTOR                       COD_SETOR,            " &
"    ENT_SKU.SECTOR_NAME                     SETOR,                " &
"    LN_ITEM.T$FAMI$C                        COD_FAMILIA,          " &
"    LN_ITEM.DS_FAMI                         FAMILIA,              " &
"    LN_ITEM.T$SUBF$C                        COD_SUB,              " &
"    LN_ITEM.DS_SUBF                         SUB,                  " &
"    cl.UDF2                                 ID_FILIAL,            " &
"    SUM(SKUXLOC.QTY)                        QT_FISICA,            " &
"    NVL(ROMANEADA.QT_ROMANEADA, 0)          QT_ROMANEADA,         " &
"    SUM(SKUXLOC.QTYALLOCATED)               QT_RESERVADA,         " &
"    SUM(SKUXLOC.QTY - SKUXLOC.QTYALLOCATED) QT_SALDO,             " &
"    NVL(max(maucLN.mauc),0)                 VL_UNITARIO,          " &
"    SKU.SUSR5                               ID_FORNECEDOR,        " &
"    STORER.COMPANY                          FORN_NOME             " &
"                                                                  " &
"FROM       WMWHSE5.SKU                                            " &
"                                                                  " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                 " &
"        ON UPPER(cl.UDF1) = sku.WHSEID                            " &
"                                                                  " &
"INNER JOIN WMWHSE5.SKUXLOC                                        " &
"        ON SKUXLOC.SKU = SKU.SKU                                  " &
"       AND SKUXLOC.WHSEID = SKU.WHSEID                            " &
"                                                                  " &
" LEFT JOIN ( SELECT IBD001.T$ITEM,                                " &
"                    IBD001.T$FAMI$C,                              " &
"                    IBD001.T$SUBF$C,                              " &
"                    MCS031.T$DSCA$C DS_FAMI,                      " &
"                    MCS032.T$DSCA$C DS_SUBF                       " &
"               FROM BAANDB.TTCIBD001301@pln01 IBD001              " &
"          LEFT JOIN BAANDB.TZNMCS031301@pln01 MCS031              " &
"                 ON MCS031.T$FAMI$C = IBD001.T$FAMI$C             " &
"                AND MCS031.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS031.T$SETO$C = IBD001.T$SETO$C             " &
"          LEFT JOIN BAANDB.TZNMCS032301@pln01 MCS032              " &
"                 ON MCS032.T$SUBF$C = IBD001.T$SUBF$C             " &
"                AND MCS032.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS032.T$SETO$C = IBD001.T$SETO$C             " &
"                AND MCS032.T$FAMI$C = IBD001.T$FAMI$C ) LN_ITEM   " &
"        ON TRIM(LN_ITEM.T$ITEM) = SKU.SKU                         " &
"                                                                  " &
" LEFT JOIN ( select whwmd217.t$item,                              " &
"                    whwmd217.t$cwar,                              " &
"                    case when sum(a.t$qhnd) = 0                   " &
"                           then 0                                 " &
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc                                     " &
"               from baandb.twhwmd217301@pln01 whwmd217            " &
"         inner join baandb.twhinr140301@pln01 a                   " &
"                 on a.t$cwar = whwmd217.t$cwar                    " &
"                and a.t$item = whwmd217.t$item                    " &
"              where whwmd217.t$mauc$1 != 0                        " &
"           group by whwmd217.t$item,                              " &
"                    whwmd217.t$cwar ) maucLN                      " &
"        ON maucLN.t$cwar = subStr(cl.DESCRIPTION,3,6)             " &
"       AND trim(maucLN.t$item) = sku.sku                          " &
"                                                                  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU ENT_SKU                     " &
"        ON TO_CHAR(ENT_SKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)     " &
"       AND TO_CHAR(ENT_SKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)    " &
"                                                                  " &
" LEFT JOIN WMWHSE5.STORER                                         " &
"        ON STORER.STORERKEY = SKU.SUSR5                           " &
"       AND STORER.WHSEID = SKU.WHSEID                             " &
"                                                                  " &
" LEFT JOIN ( SELECT SUM(OD.QTYALLOCATED) QT_ROMANEADA,            " &
"                    OD.SKU                                        " &
"               FROM WMWHSE5.orderdetail OD                        " &
"              WHERE OD.STATUS BETWEEN '29' AND '94'               " &
"           GROUP BY OD.SKU ) ROMANEADA                            " &
"        ON ROMANEADA.SKU = SKUXLOC.SKU                            " &
"                                                                  " &
"WHERE STORER.TYPE = 5                                             " &
"  AND cl.LISTNAME = 'SCHEMA'                                      " &
"  AND SKUXLOC.QTY > 0                                             " &
"                                                                  " &
"GROUP BY SKUXLOC.SKU,                                             " &
"         SKU.DESCR,                                               " &
"         SKU.ACTIVE,                                              " &
"         ENT_SKU.ID_DEPART,                                       " &
"         ENT_SKU.DEPART_NAME,                                     " &
"         ENT_SKU.ID_SECTOR,                                       " &
"         ENT_SKU.SECTOR_NAME,                                     " &
"         LN_ITEM.T$FAMI$C,                                        " &
"         LN_ITEM.DS_FAMI,                                         " &
"         LN_ITEM.T$SUBF$C,                                        " &
"         LN_ITEM.DS_SUBF,                                         " &
"         cl.UDF2,                                                 " &
"         ROMANEADA.QT_ROMANEADA,                                  " &
"         SKU.SUSR5,                                               " &
"         STORER.COMPANY                                           " &
"                                                                  " &
"Union                                                             " &
"                                                                  " &
"SELECT                                                            " &
"  DISTINCT                                                        " &
"    SKUXLOC.SKU                             ID_ITEM,              " &
"    SKU.DESCR                               NOME,                 " &
"    SKU.ACTIVE                              ITEG_SITUACAO,        " &
"    ENT_SKU.ID_DEPART                       COD_DEPTO,            " &
"    ENT_SKU.DEPART_NAME                     DEPTO,                " &
"    ENT_SKU.ID_SECTOR                       COD_SETOR,            " &
"    ENT_SKU.SECTOR_NAME                     SETOR,                " &
"    LN_ITEM.T$FAMI$C                        COD_FAMILIA,          " &
"    LN_ITEM.DS_FAMI                         FAMILIA,              " &
"    LN_ITEM.T$SUBF$C                        COD_SUB,              " &
"    LN_ITEM.DS_SUBF                         SUB,                  " &
"    cl.UDF2                                 ID_FILIAL,            " &
"    SUM(SKUXLOC.QTY)                        QT_FISICA,            " &
"    NVL(ROMANEADA.QT_ROMANEADA, 0)          QT_ROMANEADA,         " &
"    SUM(SKUXLOC.QTYALLOCATED)               QT_RESERVADA,         " &
"    SUM(SKUXLOC.QTY - SKUXLOC.QTYALLOCATED) QT_SALDO,             " &
"    NVL(max(maucLN.mauc),0)                 VL_UNITARIO,          " &
"    SKU.SUSR5                               ID_FORNECEDOR,        " &
"    STORER.COMPANY                          FORN_NOME             " &
"                                                                  " &
"FROM       WMWHSE6.SKU                                            " &
"                                                                  " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                 " &
"        ON UPPER(cl.UDF1) = sku.WHSEID                            " &
"                                                                  " &
"INNER JOIN WMWHSE6.SKUXLOC                                        " &
"        ON SKUXLOC.SKU = SKU.SKU                                  " &
"       AND SKUXLOC.WHSEID = SKU.WHSEID                            " &
"                                                                  " &
" LEFT JOIN ( SELECT IBD001.T$ITEM,                                " &
"                    IBD001.T$FAMI$C,                              " &
"                    IBD001.T$SUBF$C,                              " &
"                    MCS031.T$DSCA$C DS_FAMI,                      " &
"                    MCS032.T$DSCA$C DS_SUBF                       " &
"               FROM BAANDB.TTCIBD001301@pln01 IBD001              " &
"          LEFT JOIN BAANDB.TZNMCS031301@pln01 MCS031              " &
"                 ON MCS031.T$FAMI$C = IBD001.T$FAMI$C             " &
"                AND MCS031.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS031.T$SETO$C = IBD001.T$SETO$C             " &
"          LEFT JOIN BAANDB.TZNMCS032301@pln01 MCS032              " &
"                 ON MCS032.T$SUBF$C = IBD001.T$SUBF$C             " &
"                AND MCS032.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS032.T$SETO$C = IBD001.T$SETO$C             " &
"                AND MCS032.T$FAMI$C = IBD001.T$FAMI$C ) LN_ITEM   " &
"        ON TRIM(LN_ITEM.T$ITEM) = SKU.SKU                         " &
"                                                                  " &
" LEFT JOIN ( select whwmd217.t$item,                              " &
"                    whwmd217.t$cwar,                              " &
"                    case when sum(a.t$qhnd) = 0                   " &
"                           then 0                                 " &
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc                                     " &
"               from baandb.twhwmd217301@pln01 whwmd217            " &
"         inner join baandb.twhinr140301@pln01 a                   " &
"                 on a.t$cwar = whwmd217.t$cwar                    " &
"                and a.t$item = whwmd217.t$item                    " &
"              where whwmd217.t$mauc$1 != 0                        " &
"           group by whwmd217.t$item,                              " &
"                    whwmd217.t$cwar ) maucLN                      " &
"        ON maucLN.t$cwar = subStr(cl.DESCRIPTION,3,6)             " &
"       AND trim(maucLN.t$item) = sku.sku                          " &
"                                                                  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU ENT_SKU                     " &
"        ON TO_CHAR(ENT_SKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)     " &
"       AND TO_CHAR(ENT_SKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)    " &
"                                                                  " &
" LEFT JOIN WMWHSE6.STORER                                         " &
"        ON STORER.STORERKEY = SKU.SUSR5                           " &
"       AND STORER.WHSEID = SKU.WHSEID                             " &
"                                                                  " &
" LEFT JOIN ( SELECT SUM(OD.QTYALLOCATED) QT_ROMANEADA,            " &
"                    OD.SKU                                        " &
"               FROM WMWHSE6.orderdetail OD                        " &
"              WHERE OD.STATUS BETWEEN '29' AND '94'               " &
"           GROUP BY OD.SKU ) ROMANEADA                            " &
"        ON ROMANEADA.SKU = SKUXLOC.SKU                            " &
"                                                                  " &
"WHERE STORER.TYPE = 5                                             " &
"  AND cl.LISTNAME = 'SCHEMA'                                      " &
"  AND SKUXLOC.QTY > 0                                             " &
"                                                                  " &
"GROUP BY SKUXLOC.SKU,                                             " &
"         SKU.DESCR,                                               " &
"         SKU.ACTIVE,                                              " &
"         ENT_SKU.ID_DEPART,                                       " &
"         ENT_SKU.DEPART_NAME,                                     " &
"         ENT_SKU.ID_SECTOR,                                       " &
"         ENT_SKU.SECTOR_NAME,                                     " &
"         LN_ITEM.T$FAMI$C,                                        " &
"         LN_ITEM.DS_FAMI,                                         " &
"         LN_ITEM.T$SUBF$C,                                        " &
"         LN_ITEM.DS_SUBF,                                         " &
"         cl.UDF2,                                                 " &
"         ROMANEADA.QT_ROMANEADA,                                  " &
"         SKU.SUSR5,                                               " &
"         STORER.COMPANY                                           " &
"                                                                  " &
"Union                                                             " &
"                                                                  " &
"SELECT                                                            " &
"  DISTINCT                                                        " &
"    SKUXLOC.SKU                             ID_ITEM,              " &
"    SKU.DESCR                               NOME,                 " &
"    SKU.ACTIVE                              ITEG_SITUACAO,        " &
"    ENT_SKU.ID_DEPART                       COD_DEPTO,            " &
"    ENT_SKU.DEPART_NAME                     DEPTO,                " &
"    ENT_SKU.ID_SECTOR                       COD_SETOR,            " &
"    ENT_SKU.SECTOR_NAME                     SETOR,                " &
"    LN_ITEM.T$FAMI$C                        COD_FAMILIA,          " &
"    LN_ITEM.DS_FAMI                         FAMILIA,              " &
"    LN_ITEM.T$SUBF$C                        COD_SUB,              " &
"    LN_ITEM.DS_SUBF                         SUB,                  " &
"    cl.UDF2                                 ID_FILIAL,            " &
"    SUM(SKUXLOC.QTY)                        QT_FISICA,            " &
"    NVL(ROMANEADA.QT_ROMANEADA, 0)          QT_ROMANEADA,         " &
"    SUM(SKUXLOC.QTYALLOCATED)               QT_RESERVADA,         " &
"    SUM(SKUXLOC.QTY - SKUXLOC.QTYALLOCATED) QT_SALDO,             " &
"    NVL(max(maucLN.mauc),0)                 VL_UNITARIO,          " &
"    SKU.SUSR5                               ID_FORNECEDOR,        " &
"    STORER.COMPANY                          FORN_NOME             " &
"                                                                  " &
"FROM       WMWHSE7.SKU                                            " &
"                                                                  " &
"INNER JOIN ENTERPRISE.CODELKUP cl                                 " &
"        ON UPPER(cl.UDF1) = sku.WHSEID                            " &
"                                                                  " &
"INNER JOIN WMWHSE7.SKUXLOC                                        " &
"        ON SKUXLOC.SKU = SKU.SKU                                  " &
"       AND SKUXLOC.WHSEID = SKU.WHSEID                            " &
"                                                                  " &
" LEFT JOIN ( SELECT IBD001.T$ITEM,                                " &
"                    IBD001.T$FAMI$C,                              " &
"                    IBD001.T$SUBF$C,                              " &
"                    MCS031.T$DSCA$C DS_FAMI,                      " &
"                    MCS032.T$DSCA$C DS_SUBF                       " &
"               FROM BAANDB.TTCIBD001301@pln01 IBD001              " &
"          LEFT JOIN BAANDB.TZNMCS031301@pln01 MCS031              " &
"                 ON MCS031.T$FAMI$C = IBD001.T$FAMI$C             " &
"                AND MCS031.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS031.T$SETO$C = IBD001.T$SETO$C             " &
"          LEFT JOIN BAANDB.TZNMCS032301@pln01 MCS032              " &
"                 ON MCS032.T$SUBF$C = IBD001.T$SUBF$C             " &
"                AND MCS032.T$CITG$C = IBD001.T$CITG               " &
"                AND MCS032.T$SETO$C = IBD001.T$SETO$C             " &
"                AND MCS032.T$FAMI$C = IBD001.T$FAMI$C ) LN_ITEM   " &
"        ON TRIM(LN_ITEM.T$ITEM) = SKU.SKU                         " &
"                                                                  " &
" LEFT JOIN ( select whwmd217.t$item,                              " &
"                    whwmd217.t$cwar,                              " &
"                    case when sum(a.t$qhnd) = 0                   " &
"                           then 0                                 " &
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc                                     " &
"               from baandb.twhwmd217301@pln01 whwmd217            " &
"         inner join baandb.twhinr140301@pln01 a                   " &
"                 on a.t$cwar = whwmd217.t$cwar                    " &
"                and a.t$item = whwmd217.t$item                    " &
"              where whwmd217.t$mauc$1 != 0                        " &
"           group by whwmd217.t$item,                              " &
"                    whwmd217.t$cwar ) maucLN                      " &
"        ON maucLN.t$cwar = subStr(cl.DESCRIPTION,3,6)             " &
"       AND trim(maucLN.t$item) = sku.sku                          " &
"                                                                  " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU ENT_SKU                     " &
"        ON TO_CHAR(ENT_SKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)     " &
"       AND TO_CHAR(ENT_SKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)    " &
"                                                                  " &
" LEFT JOIN WMWHSE7.STORER                                         " &
"        ON STORER.STORERKEY = SKU.SUSR5                           " &
"       AND STORER.WHSEID = SKU.WHSEID                             " &
"                                                                  " &
" LEFT JOIN ( SELECT SUM(OD.QTYALLOCATED) QT_ROMANEADA,            " &
"                    OD.SKU                                        " &
"               FROM WMWHSE7.orderdetail OD                        " &
"              WHERE OD.STATUS BETWEEN '29' AND '94'               " &
"           GROUP BY OD.SKU ) ROMANEADA                            " &
"        ON ROMANEADA.SKU = SKUXLOC.SKU                            " &
"                                                                  " &
"WHERE STORER.TYPE = 5                                             " &
"  AND cl.LISTNAME = 'SCHEMA'                                      " &
"  AND SKUXLOC.QTY > 0                                             " &
"                                                                  " &
"GROUP BY SKUXLOC.SKU,                                             " &
"         SKU.DESCR,                                               " &
"         SKU.ACTIVE,                                              " &
"         ENT_SKU.ID_DEPART,                                       " &
"         ENT_SKU.DEPART_NAME,                                     " &
"         ENT_SKU.ID_SECTOR,                                       " &
"         ENT_SKU.SECTOR_NAME,                                     " &
"         LN_ITEM.T$FAMI$C,                                        " &
"         LN_ITEM.DS_FAMI,                                         " &
"         LN_ITEM.T$SUBF$C,                                        " &
"         LN_ITEM.DS_SUBF,                                         " &
"         cl.UDF2,                                                 " &
"         ROMANEADA.QT_ROMANEADA,                                  " &
"         SKU.SUSR5,                                               " &
"         STORER.COMPANY                                           " &
"                                                                  " &
"ORDER BY ID_FILIAL                                                "