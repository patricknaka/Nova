SELECT
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL, 
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')           
                                                      MESANO,
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

--  AND (  ( (CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE, 
--        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--          AT time zone 'America/Sao_Paulo') AS DATE)) Between ('01/' || :RecebidoDe) 
--        And ( To_Char(LAST_DAY('01/' || :RecebidoAte), 'dd/MM/yyyy') )  )
--        OR :RecebidoDe Is Null OR :RecebidoAte Is Null )

GROUP BY WMSADMIN.PL_DB.DB_ALIAS, 
         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')

ORDER BY TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')



"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,           " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " & 
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &            
"                                                      MESANO,                 " &
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
"                                                                              " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( ((CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,          " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                             " & 
"        Between ('01/' || '" + Parameters!RecebidoDe.Value + "')              " &
"        And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )           " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )  " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')              " &
"                                                                              " &
"ORDER BY TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &

-- Query com UNION **************************************************************************

"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,           " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " & 
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &            
"                                                      MESANO,                 " &
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
"                                                                              " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( ((CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,          " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                             " & 
"        Between ('01/' || '" + Parameters!RecebidoDe.Value + "')              " &
"        And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )           " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )  " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')              " &
"                                                                              " &
"ORDER BY TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,           " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " & 
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &            
"                                                      MESANO,                 " &
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
"                                                                              " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( ((CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,          " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                             " & 
"        Between ('01/' || '" + Parameters!RecebidoDe.Value + "')              " &
"        And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )           " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )  " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')              " &
"                                                                              " &
"ORDER BY TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,           " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " & 
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &            
"                                                      MESANO,                 " &
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
"                                                                              " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( ((CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,          " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                             " & 
"        Between ('01/' || '" + Parameters!RecebidoDe.Value + "')              " &
"        And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )           " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )  " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')              " &
"                                                                              " &
"ORDER BY TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,           " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " & 
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &            
"                                                      MESANO,                 " &
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
"                                                                              " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( ((CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,          " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                             " & 
"        Between ('01/' || '" + Parameters!RecebidoDe.Value + "')              " &
"        And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )           " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )  " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')              " &
"                                                                              " &
"ORDER BY TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                           FILIAL,                 " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,           " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " & 
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &            
"                                                      MESANO,                 " &
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
"                                                                              " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( ((CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,          " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                             " & 
"        Between ('01/' || '" + Parameters!RecebidoDe.Value + "')              " &
"        And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )           " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )  " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')              " &
"                                                                              " &
"ORDER BY TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &
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
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,           " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " & 
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &            
"                                                      MESANO,                 " &
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
"                                                                              " &
"WHERE RECEIPT.STATUS IN (9,11)                                                " &
"  AND (  ( ((CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,          " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                             " & 
"        Between ('01/' || '" + Parameters!RecebidoDe.Value + "')              " &
"        And ( To_Char(LAST_DAY('01/' || '" + Parameters!RecebidoAte.Value + "'), 'dd/MM/yyyy') )  )           " &
"        OR '" + Parameters!RecebidoDe.Value + "' Is Null OR '" + Parameters!RecebidoAte.Value + "' is null )  " &
"                                                                              " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')              " &
"                                                                              " &
"ORDER BY TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,      " & 
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"          AT time zone 'America/Sao_Paulo') AS DATE), 'MM/yyyy')                  " &