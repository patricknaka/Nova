SELECT  
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL, 
    TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD')          DATA,
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
 
FROM WMWHSE4.RECEIPTDETAIL,
     WMWHSE4.RECEIPT,
     WMWHSE4.CODELKUP,
     WMWHSE4.SKU,
     WMSADMIN.PL_DB
   
WHERE RECEIPTDETAIL.STATUS >= 9 
  AND CODELKUP.CODE = RECEIPT.TYPE 
  AND CODELKUP.LISTNAME = 'RECEIPTYPE' 
  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY 
  AND SKU.SKU = RECEIPTDETAIL.SKU
  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID
  AND Trunc(RECEIPTDETAIL.DATERECEIVED) Between :DataRectoDe
  AND :DataRectoAte

GROUP BY PL_DB.DB_ALIAS,
         TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD'), 
         CODELKUP.LONG_VALUE,
         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' 
                THEN 'SIM' 
              ELSE   'NÃO' 
          END
    
ORDER BY TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD')


"SELECT                                                                                   " &
"  DISTINCT                                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,            			      " &
"    TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD')          DATA,                               " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,                         " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,                         " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                           " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                               " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                             			          " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )        			          " &
"                                                     ITENS_P_RECBTO,    			      " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                       			          " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,       			      " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                    " &
"           THEN 'SIM'                                                                    " &
"         ELSE   'NÃO'                                                                    " &
"     END                                             IN_MINUNCIOSO,                      " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                             " &
"                                                                                         " &
"FROM " + Parameters!Table.Value + ".RECEIPTDETAIL,                                       " &
"     " + Parameters!Table.Value + ".RECEIPT,                                             " &
"     " + Parameters!Table.Value + ".CODELKUP,                                            " &
"     " + Parameters!Table.Value + ".SKU,                                                 " &
"     WMSADMIN.PL_DB                                                                      " &
"                                                                                         " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                                          " &
"  AND CODELKUP.CODE = RECEIPT.TYPE                                                       " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                   " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                      " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                    " &
"  AND Trunc(RECEIPTDETAIL.DATERECEIVED) Between '" + Parameters!DataRectoDe.Value + "'   " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                            " &
"                                                                                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                                 " &
"         TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD'),                                        " &
"         CODELKUP.LONG_VALUE,                                                            " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                               " &
"                THEN 'SIM'                                                               " &
"              ELSE   'NÃO'                                                               " &
"          END                                                                            " &
"                                                                                         " &
"ORDER BY TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD')                                         "

-- Query com UNION **************************************************************************

"SELECT                                                                                   " &
"  DISTINCT                                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,            			      " &
"    TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD')          DATA,                               " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,                         " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,                         " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                           " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                               " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                             			          " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )        			          " &
"                                                     ITENS_P_RECBTO,    			      " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                       			          " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,       			      " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                    " &
"           THEN 'SIM'                                                                    " &
"         ELSE   'NÃO'                                                                    " &
"     END                                             IN_MINUNCIOSO,                      " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                             " &
"                                                                                         " &
"FROM WMWHSE1.RECEIPTDETAIL,                                                              " &
"     WMWHSE1.RECEIPT,                                                                    " &
"     WMWHSE1.CODELKUP,                                                                   " &
"     WMWHSE1.SKU,                                                                        " &
"     WMSADMIN.PL_DB                                                                      " &
"                                                                                         " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                                          " &
"  AND CODELKUP.CODE = RECEIPT.TYPE                                                       " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                   " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                      " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                    " &
"  AND Trunc(RECEIPTDETAIL.DATERECEIVED) Between '" + Parameters!DataRectoDe.Value + "'   " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                            " &
"                                                                                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                                 " &
"         TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD'),                                        " &
"         CODELKUP.LONG_VALUE,                                                            " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                               " &
"                THEN 'SIM'                                                               " &
"              ELSE   'NÃO'                                                               " &
"          END                                                                            " &
"                                                                                         " &
"Union                                                                                    " &
"                                                                                         " &
"SELECT                                                                                   " &
"  DISTINCT                                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,            			      " &
"    TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD')          DATA,                               " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,                         " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,                         " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                           " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                               " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                             			          " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )        			          " &
"                                                     ITENS_P_RECBTO,    			      " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                       			          " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,       			      " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                    " &
"           THEN 'SIM'                                                                    " &
"         ELSE   'NÃO'                                                                    " &
"     END                                             IN_MINUNCIOSO,                      " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                             " &
"                                                                                         " &
"FROM WMWHSE2.RECEIPTDETAIL,                                                              " &
"     WMWHSE2.RECEIPT,                                                                    " &
"     WMWHSE2.CODELKUP,                                                                   " &
"     WMWHSE2.SKU,                                                                        " &
"     WMSADMIN.PL_DB                                                                      " &
"                                                                                         " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                                          " &
"  AND CODELKUP.CODE = RECEIPT.TYPE                                                       " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                   " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                      " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                    " &
"  AND Trunc(RECEIPTDETAIL.DATERECEIVED) Between '" + Parameters!DataRectoDe.Value + "'   " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                            " &
"                                                                                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                                 " &
"         TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD'),                                        " &
"         CODELKUP.LONG_VALUE,                                                            " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                               " &
"                THEN 'SIM'                                                               " &
"              ELSE   'NÃO'                                                               " &
"          END                                                                            " &
"                                                                                         " &
"Union                                                                                    " &
"                                                                                         " &
"SELECT                                                                                   " &
"  DISTINCT                                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,            			      " &
"    TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD')          DATA,                               " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,                         " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,                         " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                           " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                               " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                             			          " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )        			          " &
"                                                     ITENS_P_RECBTO,    			      " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                       			          " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,       			      " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                    " &
"           THEN 'SIM'                                                                    " &
"         ELSE   'NÃO'                                                                    " &
"     END                                             IN_MINUNCIOSO,                      " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                             " &
"                                                                                         " &
"FROM WMWHSE3.RECEIPTDETAIL,                                                              " &
"     WMWHSE3.RECEIPT,                                                                    " &
"     WMWHSE3.CODELKUP,                                                                   " &
"     WMWHSE3.SKU,                                                                        " &
"     WMSADMIN.PL_DB                                                                      " &
"                                                                                         " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                                          " &
"  AND CODELKUP.CODE = RECEIPT.TYPE                                                       " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                   " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                      " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                    " &
"  AND Trunc(RECEIPTDETAIL.DATERECEIVED) Between '" + Parameters!DataRectoDe.Value + "'   " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                            " &
"                                                                                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                                 " &
"         TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD'),                                        " &
"         CODELKUP.LONG_VALUE,                                                            " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                               " &
"                THEN 'SIM'                                                               " &
"              ELSE   'NÃO'                                                               " &
"          END                                                                            " &
"                                                                                         " &
"Union                                                                                    " &
"                                                                                         " &
"SELECT                                                                                   " &
"  DISTINCT                                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,            			      " &
"    TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD')          DATA,                               " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,                         " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,                         " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                           " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                               " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                             			          " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )        			          " &
"                                                     ITENS_P_RECBTO,    			      " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                       			          " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,       			      " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                    " &
"           THEN 'SIM'                                                                    " &
"         ELSE   'NÃO'                                                                    " &
"     END                                             IN_MINUNCIOSO,                      " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                             " &
"                                                                                         " &
"FROM WMWHSE4.RECEIPTDETAIL,                                                              " &
"     WMWHSE4.RECEIPT,                                                                    " &
"     WMWHSE4.CODELKUP,                                                                   " &
"     WMWHSE4.SKU,                                                                        " &
"     WMSADMIN.PL_DB                                                                      " &
"                                                                                         " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                                          " &
"  AND CODELKUP.CODE = RECEIPT.TYPE                                                       " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                   " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                      " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                    " &
"  AND Trunc(RECEIPTDETAIL.DATERECEIVED) Between '" + Parameters!DataRectoDe.Value + "'   " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                            " &
"                                                                                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                                 " &
"         TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD'),                                        " &
"         CODELKUP.LONG_VALUE,                                                            " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                               " &
"                THEN 'SIM'                                                               " &
"              ELSE   'NÃO'                                                               " &
"          END                                                                            " &
"                                                                                         " &
"Union                                                                                    " &
"                                                                                         " &
"SELECT                                                                                   " &
"  DISTINCT                                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,            			      " &
"    TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD')          DATA,                               " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,                         " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,                         " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                           " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                               " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                             			          " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )        			          " &
"                                                     ITENS_P_RECBTO,    			      " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                       			          " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,       			      " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                    " &
"           THEN 'SIM'                                                                    " &
"         ELSE   'NÃO'                                                                    " &
"     END                                             IN_MINUNCIOSO,                      " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                             " &
"                                                                                         " &
"FROM WMWHSE5.RECEIPTDETAIL,                                                              " &
"     WMWHSE5.RECEIPT,                                                                    " &
"     WMWHSE5.CODELKUP,                                                                   " &
"     WMWHSE5.SKU,                                                                        " &
"     WMSADMIN.PL_DB                                                                      " &
"                                                                                         " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                                          " &
"  AND CODELKUP.CODE = RECEIPT.TYPE                                                       " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                   " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                      " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                    " &
"  AND Trunc(RECEIPTDETAIL.DATERECEIVED) Between '" + Parameters!DataRectoDe.Value + "'   " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                            " &
"                                                                                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                                 " &
"         TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD'),                                        " &
"         CODELKUP.LONG_VALUE,                                                            " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                               " &
"                THEN 'SIM'                                                               " &
"              ELSE   'NÃO'                                                               " &
"          END                                                                            " &
"                                                                                         " &
"Union                                                                                    " &
"                                                                                         " &
"SELECT                                                                                   " &
"  DISTINCT                                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,            			      " &
"    TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD')          DATA,                               " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,                         " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,                         " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                           " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                               " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                             			          " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )        			          " &
"                                                     ITENS_P_RECBTO,    			      " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                       			          " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,       			      " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                    " &
"           THEN 'SIM'                                                                    " &
"         ELSE   'NÃO'                                                                    " &
"     END                                             IN_MINUNCIOSO,                      " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                             " &
"                                                                                         " &
"FROM WMWHSE6.RECEIPTDETAIL,                                                              " &
"     WMWHSE6.RECEIPT,                                                                    " &
"     WMWHSE6.CODELKUP,                                                                   " &
"     WMWHSE6.SKU,                                                                        " &
"     WMSADMIN.PL_DB                                                                      " &
"                                                                                         " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                                          " &
"  AND CODELKUP.CODE = RECEIPT.TYPE                                                       " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                   " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                      " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                    " &
"  AND Trunc(RECEIPTDETAIL.DATERECEIVED) Between '" + Parameters!DataRectoDe.Value + "'   " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                            " &
"                                                                                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                                 " &
"         TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD'),                                        " &
"         CODELKUP.LONG_VALUE,                                                            " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                               " &
"                THEN 'SIM'                                                               " &
"              ELSE   'NÃO'                                                               " &
"          END                                                                            " &
"                                                                                         " &
"Union                                                                                    " &
"                                                                                         " &
"SELECT                                                                                   " &
"  DISTINCT                                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,            			      " &
"    TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD')          DATA,                               " &
"    count(distinct RECEIPTDETAIL.RECEIPTKEY)         NU_RECBTOS,                         " &
"    count(distinct nvl(RECEIPT.SUPPLIERCODE, ' ') )  NU_FORNECS,                         " &
"    count(RECEIPTDETAIL.SKU)                         NU_ITENS,                           " &
"    sum(RECEIPTDETAIL.QTYRECEIVED)                   QTDE,                               " &
"    Round( ( count(RECEIPTDETAIL.SKU) /                             			          " &
"             count(distinct RECEIPTDETAIL.RECEIPTKEY) ), 4 )        			          " &
"                                                     ITENS_P_RECBTO,    			      " &
"    Round( ( sum(RECEIPTDETAIL.QTYRECEIVED) /                       			          " &
"             count(RECEIPTDETAIL.SKU) ), 4 )         QTDE_P_ITEM,       			      " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                                    " &
"           THEN 'SIM'                                                                    " &
"         ELSE   'NÃO'                                                                    " &
"     END                                             IN_MINUNCIOSO,                      " &
"    CODELKUP.LONG_VALUE                              TP_NOTA                             " &
"                                                                                         " &
"FROM WMWHSE7.RECEIPTDETAIL,                                                              " &
"     WMWHSE7.RECEIPT,                                                                    " &
"     WMWHSE7.CODELKUP,                                                                   " &
"     WMWHSE7.SKU,                                                                        " &
"     WMSADMIN.PL_DB                                                                      " &
"                                                                                         " &
"WHERE RECEIPTDETAIL.STATUS >= 9                                                          " &
"  AND CODELKUP.CODE = RECEIPT.TYPE                                                       " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                                   " &
"  AND RECEIPTDETAIL.RECEIPTKEY = RECEIPT.RECEIPTKEY                                      " &
"  AND SKU.SKU = RECEIPTDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = RECEIPT.WHSEID                                    " &
"  AND Trunc(RECEIPTDETAIL.DATERECEIVED) Between '" + Parameters!DataRectoDe.Value + "'   " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                            " &
"                                                                                         " &
"GROUP BY PL_DB.DB_ALIAS,                                                                 " &
"         TRUNC(RECEIPTDETAIL.DATERECEIVED, 'DD'),                                        " &
"         CODELKUP.LONG_VALUE,                                                            " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO'                                               " &
"                THEN 'SIM'                                                               " &
"              ELSE   'NÃO'                                                               " &
"          END                                                                            " &
"                                                                                         " &
"ORDER BY FILIAL, DATA                                                                    "