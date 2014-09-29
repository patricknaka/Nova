SELECT
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL, 
    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,
    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,
    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,
    
    SUM( ( SELECT REC942A.T$AMNT$L 
             FROM BAANDB.TTDREC942301@pln01 REC942A
            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l
              AND REC942A.T$LINE$L = REC941.T$LINE$l
              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,

    SUM( ( SELECT REC942B.T$AMNT$L 
             FROM BAANDB.TTDREC942301@pln01 REC942B
            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l
              AND REC942B.T$LINE$L = REC941.T$LINE$l
              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,

    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO
  
FROM BAANDB.TTDREC941301@pln01 REC941

INNER JOIN BAANDB.TTDREC947301@pln01 REC947
        ON REC941.T$FIRE$L = REC947.T$FIRE$L
       AND REC941.T$LINE$L = REC947.T$LINE$L

INNER JOIN WMWHSE5.RECEIPT
        ON REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT

INNER JOIN WMWHSE5.RECEIPTDETAIL
        ON RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY
        
INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = RECEIPTDETAIL.SKU

INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID
   
WHERE RECEIPT.STATUS IN (9,11)

--  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || :RecebidoDe) 
--                                     And ( To_Char(LAST_DAY('01/' || :RecebidoAte), 'dd/MM/yyyy') )  )
--        OR :RecebidoDe Is Null OR :RecebidoAte Is Null )

GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')

ORDER BY TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')



"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                 " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,             " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,         " &
"                                                                              " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942A                           " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,              " &
"                                                                              " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942B                           " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,          " &
"                                                                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO           " &
"                                                                              " &
"FROM       BAANDB.TTDREC941301@pln01 REC941                                   " &
"INNER JOIN BAANDB.TTDREC947301@pln01 REC947                                   " &
"        ON REC941.T$FIRE$L = REC947.T$FIRE$L                                  " &
"       AND REC941.T$LINE$L = REC947.T$LINE$L                                  " &
"INNER JOIN " + Parameters!Table.Value + ".RECEIPT                             " &
"        ON REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                        " &
"INNER JOIN " + Parameters!Table.Value + ".RECEIPTDETAIL                       " &
"        ON RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                      " &
"INNER JOIN " + Parameters!Table.Value + ".SKU                                 " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')     " &
"                                                                              " &
"ORDER BY TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')                              " 

-- Query com UNION **************************************************************************

"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                 " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,             " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,         " &
"                                                                              " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942A                           " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,              " &
"                                                                              " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942B                           " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,          " &
"                                                                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO           " &
"                                                                              " &
"FROM       BAANDB.TTDREC941301@pln01 REC941                                   " &
"INNER JOIN BAANDB.TTDREC947301@pln01 REC947                                   " &
"        ON REC941.T$FIRE$L = REC947.T$FIRE$L                                  " &
"       AND REC941.T$LINE$L = REC947.T$LINE$L                                  " &
"INNER JOIN WMWHSE1.RECEIPT                                                    " &
"        ON REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                        " &
"INNER JOIN WMWHSE1.RECEIPTDETAIL                                              " &
"        ON RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                      " &
"INNER JOIN WMWHSE1.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')     " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                 " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,             " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,         " &
"                                                                              " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942A                           " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,              " &
"                                                                              " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942B                           " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,          " &
"                                                                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO           " &
"                                                                              " &
"FROM       BAANDB.TTDREC941301@pln01 REC941                                   " &
"INNER JOIN BAANDB.TTDREC947301@pln01 REC947                                   " &
"        ON REC941.T$FIRE$L = REC947.T$FIRE$L                                  " &
"       AND REC941.T$LINE$L = REC947.T$LINE$L                                  " &
"INNER JOIN WMWHSE2.RECEIPT                                                    " &
"        ON REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                        " &
"INNER JOIN WMWHSE2.RECEIPTDETAIL                                              " &
"        ON RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                      " &
"INNER JOIN WMWHSE2.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')     " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                 " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,             " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,         " &
"                                                                              " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942A                           " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,              " &
"                                                                              " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942B                           " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,          " &
"                                                                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO           " &
"                                                                              " &
"FROM       BAANDB.TTDREC941301@pln01 REC941                                   " &
"INNER JOIN BAANDB.TTDREC947301@pln01 REC947                                   " &
"        ON REC941.T$FIRE$L = REC947.T$FIRE$L                                  " &
"       AND REC941.T$LINE$L = REC947.T$LINE$L                                  " &
"INNER JOIN WMWHSE3.RECEIPT                                                    " &
"        ON REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                        " &
"INNER JOIN WMWHSE3.RECEIPTDETAIL                                              " &
"        ON RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                      " &
"INNER JOIN WMWHSE3.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')     " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                 " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,             " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,         " &
"                                                                              " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942A                           " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,              " &
"                                                                              " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942B                           " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,          " &
"                                                                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO           " &
"                                                                              " &
"FROM       BAANDB.TTDREC941301@pln01 REC941                                   " &
"INNER JOIN BAANDB.TTDREC947301@pln01 REC947                                   " &
"        ON REC941.T$FIRE$L = REC947.T$FIRE$L                                  " &
"       AND REC941.T$LINE$L = REC947.T$LINE$L                                  " &
"INNER JOIN WMWHSE4.RECEIPT                                                    " &
"        ON REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                        " &
"INNER JOIN WMWHSE4.RECEIPTDETAIL                                              " &
"        ON RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                      " &
"INNER JOIN WMWHSE4.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')     " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                 " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,             " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,         " &
"                                                                              " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942A                           " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,              " &
"                                                                              " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942B                           " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,          " &
"                                                                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO           " &
"                                                                              " &
"FROM       BAANDB.TTDREC941301@pln01 REC941                                   " &
"INNER JOIN BAANDB.TTDREC947301@pln01 REC947                                   " &
"        ON REC941.T$FIRE$L = REC947.T$FIRE$L                                  " &
"       AND REC941.T$LINE$L = REC947.T$LINE$L                                  " &
"INNER JOIN WMWHSE5.RECEIPT                                                    " &
"        ON REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                        " &
"INNER JOIN WMWHSE5.RECEIPTDETAIL                                              " &
"        ON RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                      " &
"INNER JOIN WMWHSE5.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')     " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                 " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,             " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,         " &
"                                                                              " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942A                           " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,              " &
"                                                                              " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942B                           " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,          " &
"                                                                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO           " &
"                                                                              " &
"FROM       BAANDB.TTDREC941301@pln01 REC941                                   " &
"INNER JOIN BAANDB.TTDREC947301@pln01 REC947                                   " &
"        ON REC941.T$FIRE$L = REC947.T$FIRE$L                                  " &
"       AND REC941.T$LINE$L = REC947.T$LINE$L                                  " &
"INNER JOIN WMWHSE6.RECEIPT                                                    " &
"        ON REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                        " &
"INNER JOIN WMWHSE6.RECEIPTDETAIL                                              " &
"        ON RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                      " &
"INNER JOIN WMWHSE6.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')     " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')           MESANO,                 " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED)                    QTDE_PECAS,             " &
"    SUM(REC941.T$GAMT$L)                              VALOR_RECEBIDO,         " &
"                                                                              " &
"    SUM( ( SELECT REC942A.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942A                           " &
"            WHERE REC942A.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942A.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942A.T$BRTY$L = 3 ) )            VALOR_IPI,              " &
"                                                                              " &
"    SUM( ( SELECT REC942B.T$AMNT$L                                            " &
"             FROM BAANDB.TTDREC942301@pln01 REC942B                           " &
"            WHERE REC942B.T$FIRE$L = REC941.T$FIRE$l                          " &
"              AND REC942B.T$LINE$L = REC941.T$LINE$l                          " &
"              AND REC942B.T$BRTY$L = 2 ) )            VALOR_ICMS_ST,          " &
"                                                                              " &
"    SUM(RECEIPTDETAIL.QTYRECEIVED * SKU.STDCUBE)      VOLUME_CUBADO           " &
"                                                                              " &
"FROM       BAANDB.TTDREC941301@pln01 REC941                                   " &
"INNER JOIN BAANDB.TTDREC947301@pln01 REC947                                   " &
"        ON REC941.T$FIRE$L = REC947.T$FIRE$L                                  " &
"       AND REC941.T$LINE$L = REC947.T$LINE$L                                  " &
"INNER JOIN WMWHSE7.RECEIPT                                                    " &
"        ON REC947.T$ORNO$L = RECEIPT.REFERENCEDOCUMENT                        " &
"INNER JOIN WMWHSE7.RECEIPTDETAIL                                              " &
"        ON RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                      " &
"INNER JOIN WMWHSE7.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( (RECEIPT.RECEIPTDATE) Between ('01/' || '" + Parameters!RecebidoDe.Value + "')                                         " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )                      " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TO_CHAR(RECEIPT.RECEIPTDATE, 'MM/yyyy')     " &
"                                                                              " &
"ORDER BY FILIAL, MESANO                                                       " 