SELECT  
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL, 
    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE), 'DD')
                                                     DATA,
    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,
    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,
    count(RECEIPTDETAIL.SKU)                         NU_ITENS,
    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,
    Round( ( count(RECEIPTDETAIL.SKU) / 
             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 ) 
                                                     ITENS_P_RECBTO,
    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) / 
             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,
    CASE WHEN SKU.SUSR8 = 'MINUCIOSO' 
           THEN 'SIM' 
         ELSE   'NÃO' 
     END                                             IN_MINUNCIOSO,
    CODELKUP.LONG_VALUE                              TP_NOTA
 
FROM       WMWHSE5.RECEIPTDETAIL

INNER JOIN WMWHSE5.RECEIPT
        ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY

INNER JOIN WMWHSE5.CODELKUP
        ON CODELKUP.CODE = RECEIPT.TYPE

INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = RECEIPTDETAIL.SKU

INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID
   
WHERE RECEIPTDETAIL.STATUS >= 9 
  AND RECEIPTDETAIL.QTYRECEIVED > 0
  AND CODELKUP.LISTNAME = 'RECEIPTYPE' 
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)) 
      Between :DataRectoDe
          And :DataRectoAte

GROUP BY PL_DB.DB_ALIAS,
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE), 'DD'), 
         CODELKUP.LONG_VALUE,
         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' 
                THEN 'SIM' 
              ELSE   'NÃO' 
          END
    
ORDER BY DATA

"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                         " &
"                                                     DATA,                    " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,              " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,              " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                    " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                                       " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )                  " &
"                                                     ITENS_P_RECBTO,          " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                                 " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,             " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                         " &
"           THEN 'SIM'                                                         " &
"         ELSE   'NÃO'                                                         " &
"     END                                             IN_MINUNCIOSO,           " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                  " &
"                                                                              " &
"FROM       " + Parameters!Table.Value + ".RECEIPTDETAIL                       " &
"INNER JOIN " + Parameters!Table.Value + ".RECEIPT                             " &
"        ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                      " &
"INNER JOIN " + Parameters!Table.Value + ".CODELKUP                            " &
"        ON CODELKUP.CODE = RECEIPT.TYPE                                       " &
"INNER JOIN " + Parameters!Table.Value + ".SKU                                 " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                               " &
"  AND RECEIPTDETAIL.QTYRECEIVED > 0                                           " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE))                               " &
"      Between '" + Parameters!DataRectoDe.Value + "'                          " &
"          And '" + Parameters!DataRectoAte.Value + "'                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                      " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                  " &
"         CODELKUP.LONG_VALUE,                                                 " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                    " &
"                THEN 'SIM'                                                    " &
"              ELSE   'NÃO'                                                    " &
"          END                                                                 " &
"ORDER BY FILIAL, DATA                                                         "

-- Query com UNION ***************************************************************

"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                         " &
"                                                     DATA,                    " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,              " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,              " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                    " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                                       " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )                  " &
"                                                     ITENS_P_RECBTO,          " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                                 " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,             " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                         " &
"           THEN 'SIM'                                                         " &
"         ELSE   'NÃO'                                                         " &
"     END                                             IN_MINUNCIOSO,           " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                  " &
"                                                                              " &
"FROM       WMWHSE1.RECEIPTDETAIL                                              " &
"INNER JOIN WMWHSE1.RECEIPT                                                    " &
"        ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                      " &
"INNER JOIN WMWHSE1.CODELKUP                                                   " &
"        ON CODELKUP.CODE = RECEIPT.TYPE                                       " &
"INNER JOIN WMWHSE1.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                               " &
"  AND RECEIPTDETAIL.QTYRECEIVED > 0                                           " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE))                               " &
"      Between '" + Parameters!DataRectoDe.Value + "'                          " &
"          And '" + Parameters!DataRectoAte.Value + "'                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                      " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                  " &
"         CODELKUP.LONG_VALUE,                                                 " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                    " &
"                THEN 'SIM'                                                    " &
"              ELSE   'NÃO'                                                    " &
"          END                                                                 " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                         " &
"                                                     DATA,                    " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,              " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,              " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                    " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                                       " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )                  " &
"                                                     ITENS_P_RECBTO,          " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                                 " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,             " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                         " &
"           THEN 'SIM'                                                         " &
"         ELSE   'NÃO'                                                         " &
"     END                                             IN_MINUNCIOSO,           " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                  " &
"                                                                              " &
"FROM       WMWHSE2.RECEIPTDETAIL                                              " &
"INNER JOIN WMWHSE2.RECEIPT                                                    " &
"        ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                      " &
"INNER JOIN WMWHSE2.CODELKUP                                                   " &
"        ON CODELKUP.CODE = RECEIPT.TYPE                                       " &
"INNER JOIN WMWHSE2.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                               " &
"  AND RECEIPTDETAIL.QTYRECEIVED > 0                                           " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE))                               " &
"      Between '" + Parameters!DataRectoDe.Value + "'                          " &
"          And '" + Parameters!DataRectoAte.Value + "'                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                      " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                  " &
"         CODELKUP.LONG_VALUE,                                                 " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                    " &
"                THEN 'SIM'                                                    " &
"              ELSE   'NÃO'                                                    " &
"          END                                                                 " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                         " &
"                                                     DATA,                    " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,              " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,              " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                    " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                                       " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )                  " &
"                                                     ITENS_P_RECBTO,          " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                                 " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,             " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                         " &
"           THEN 'SIM'                                                         " &
"         ELSE   'NÃO'                                                         " &
"     END                                             IN_MINUNCIOSO,           " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                  " &
"                                                                              " &
"FROM       WMWHSE3.RECEIPTDETAIL                                              " &
"INNER JOIN WMWHSE3.RECEIPT                                                    " &
"        ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                      " &
"INNER JOIN WMWHSE3.CODELKUP                                                   " &
"        ON CODELKUP.CODE = RECEIPT.TYPE                                       " &
"INNER JOIN WMWHSE3.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                               " &
"  AND RECEIPTDETAIL.QTYRECEIVED > 0                                           " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE))                               " &
"      Between '" + Parameters!DataRectoDe.Value + "'                          " &
"          And '" + Parameters!DataRectoAte.Value + "'                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                      " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                  " &
"         CODELKUP.LONG_VALUE,                                                 " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                    " &
"                THEN 'SIM'                                                    " &
"              ELSE   'NÃO'                                                    " &
"          END                                                                 " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                         " &
"                                                     DATA,                    " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,              " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,              " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                    " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                                       " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )                  " &
"                                                     ITENS_P_RECBTO,          " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                                 " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,             " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                         " &
"           THEN 'SIM'                                                         " &
"         ELSE   'NÃO'                                                         " &
"     END                                             IN_MINUNCIOSO,           " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                  " &
"                                                                              " &
"FROM       WMWHSE4.RECEIPTDETAIL                                              " &
"INNER JOIN WMWHSE4.RECEIPT                                                    " &
"        ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                      " &
"INNER JOIN WMWHSE4.CODELKUP                                                   " &
"        ON CODELKUP.CODE = RECEIPT.TYPE                                       " &
"INNER JOIN WMWHSE4.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                               " &
"  AND RECEIPTDETAIL.QTYRECEIVED > 0                                           " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE))                               " &
"      Between '" + Parameters!DataRectoDe.Value + "'                          " &
"          And '" + Parameters!DataRectoAte.Value + "'                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                      " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                  " &
"         CODELKUP.LONG_VALUE,                                                 " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                    " &
"                THEN 'SIM'                                                    " &
"              ELSE   'NÃO'                                                    " &
"          END                                                                 " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                         " &
"                                                     DATA,                    " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,              " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,              " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                    " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                                       " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )                  " &
"                                                     ITENS_P_RECBTO,          " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                                 " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,             " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                         " &
"           THEN 'SIM'                                                         " &
"         ELSE   'NÃO'                                                         " &
"     END                                             IN_MINUNCIOSO,           " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                  " &
"                                                                              " &
"FROM       WMWHSE5.RECEIPTDETAIL                                              " &
"INNER JOIN WMWHSE5.RECEIPT                                                    " &
"        ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                      " &
"INNER JOIN WMWHSE5.CODELKUP                                                   " &
"        ON CODELKUP.CODE = RECEIPT.TYPE                                       " &
"INNER JOIN WMWHSE5.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                               " &
"  AND RECEIPTDETAIL.QTYRECEIVED > 0                                           " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE))                               " &
"      Between '" + Parameters!DataRectoDe.Value + "'                          " &
"          And '" + Parameters!DataRectoAte.Value + "'                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                      " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                  " &
"         CODELKUP.LONG_VALUE,                                                 " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                    " &
"                THEN 'SIM'                                                    " &
"              ELSE   'NÃO'                                                    " &
"          END                                                                 " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                         " &
"                                                     DATA,                    " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,              " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,              " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                    " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                                       " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )                  " &
"                                                     ITENS_P_RECBTO,          " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                                 " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,             " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                         " &
"           THEN 'SIM'                                                         " &
"         ELSE   'NÃO'                                                         " &
"     END                                             IN_MINUNCIOSO,           " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                  " &
"                                                                              " &
"FROM       WMWHSE6.RECEIPTDETAIL                                              " &
"INNER JOIN WMWHSE6.RECEIPT                                                    " &
"        ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                      " &
"INNER JOIN WMWHSE6.CODELKUP                                                   " &
"        ON CODELKUP.CODE = RECEIPT.TYPE                                       " &
"INNER JOIN WMWHSE6.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                               " &
"  AND RECEIPTDETAIL.QTYRECEIVED > 0                                           " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE))                               " &
"      Between '" + Parameters!DataRectoDe.Value + "'                          " &
"          And '" + Parameters!DataRectoAte.Value + "'                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                      " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                  " &
"         CODELKUP.LONG_VALUE,                                                 " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                    " &
"                THEN 'SIM'                                                    " &
"              ELSE   'NÃO'                                                    " &
"          END                                                                 " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  DISTINCT                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                         " &
"                                                     DATA,                    " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,              " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,              " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                    " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                                       " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )                  " &
"                                                     ITENS_P_RECBTO,          " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                                 " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,             " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                         " &
"           THEN 'SIM'                                                         " &
"         ELSE   'NÃO'                                                         " &
"     END                                             IN_MINUNCIOSO,           " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                  " &
"                                                                              " &
"FROM       WMWHSE7.RECEIPTDETAIL                                              " &
"INNER JOIN WMWHSE7.RECEIPT                                                    " &
"        ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY                      " &
"INNER JOIN WMWHSE7.CODELKUP                                                   " &
"        ON CODELKUP.CODE = RECEIPT.TYPE                                       " &
"INNER JOIN WMWHSE7.SKU                                                        " &
"        ON SKU.SKU = RECEIPTDETAIL.SKU                                        " &
"INNER JOIN WMSADMIN.PL_DB                                                     " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                    " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                               " &
"  AND RECEIPTDETAIL.QTYRECEIVED > 0                                           " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone sessiontimezone) AS DATE))                               " &
"      Between '" + Parameters!DataRectoDe.Value + "'                          " &
"          And '" + Parameters!DataRectoAte.Value + "'                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                      " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPTDETAIL.DATERECEIVED, " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                  " &
"         CODELKUP.LONG_VALUE,                                                 " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                    " &
"                THEN 'SIM'                                                    " &
"              ELSE   'NÃO'                                                    " &
"          END                                                                 " &
"ORDER BY FILIAL, DATA                                                         "
