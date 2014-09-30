SELECT  
  DISTINCT
    ORDERS.WHSEID                           FILIAL,
    PL_DB.DB_ALIAS                          DSC_PLANTA,
    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE), 'DD')      
                                            DT_EMISSAO,
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE), 'HH24')  
                                            HR,
    ORDERS.LANE                             SERIE,
    count(distinct ORDERS.ORDERKEY)         QTD_PEDIDO,
    count(distinct ORDERS.INVOICENUMBER)    QTD_NOTA,
    count(ORDERDETAIL.SKU)                  QTD_ITENS,
    sum(ORDERDETAIL.SHIPPEDQTY)             QTD_PECAS
	
FROM WMWHSE4.ORDERS, 
     WMWHSE4.ORDERDETAIL,
     WMSADMIN.PL_DB
	
WHERE ORDERS.INVOICENUMBER != 0 
  AND ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY
  AND UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)
  AND ORDERS.STATUS >= 95
  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE)) BETWEEN :DataDe AND :DataAte
	
GROUP BY ORDERS.WHSEID, 
         PL_DB.DB_ALIAS,
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE), 'DD'), 
         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE), 'HH24') , 
         ORDERS.LANE
		 

-- Seleção por Armazem ***************************************************************

" SELECT                                                                           " &
"   DISTINCT                                                                       " &
"     ORDERS.WHSEID                           FILIAL,                              " &
"     PL_DB.DB_ALIAS                          DSC_PLANTA,                          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,                " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD')                        " &      
"                                            DT_EMISSAO,                            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24')                      " &
"     ORDERS.LANE                             SERIE,                               " &
"     count(distinct ORDERS.ORDERKEY)         QTD_PEDIDO,                          " &
"     count(distinct ORDERS.INVOICENUMBER)    QTD_NOTA,                            " &
"     count(ORDERDETAIL.SKU)                  QTD_ITENS,                           " &
"     sum(ORDERDETAIL.SHIPPEDQTY)             QTD_PECAS                            " &
"                                                                                  " &
" FROM " + Parameters!Table.Value + ".ORDERS,                                      " &
"      " + Parameters!Table.Value + ".ORDERDETAIL,                                 " &
"      WMSADMIN.PL_DB                                                              " &
"                                                                                  " &
" WHERE ORDERS.INVOICENUMBER != 0                                                  " &
"   AND ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                     " &
"   AND UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                               " &
"   AND ORDERS.STATUS >= 95                                                        " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE)) BETWEEN :DataDe AND :DataAte " &
"                                                                                  " &
" GROUP BY ORDERS.WHSEID,                                                          " &
"          PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,           " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                       " & 
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,         " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24') ,                    " &
"          ORDERS.LANE                                                             "
		 
		 
		 
-- Query com UNION *******************************************************************

" SELECT                                                                           " &
"   DISTINCT                                                                       " &
"     ORDERS.WHSEID                           FILIAL,                              " &
"     PL_DB.DB_ALIAS                          DSC_PLANTA,                          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,                " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD')                        " &      
"                                            DT_EMISSAO,                            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24')                      " &
"     ORDERS.LANE                             SERIE,                               " &
"     count(distinct ORDERS.ORDERKEY)         QTD_PEDIDO,                          " &
"     count(distinct ORDERS.INVOICENUMBER)    QTD_NOTA,                            " &
"     count(ORDERDETAIL.SKU)                  QTD_ITENS,                           " &
"     sum(ORDERDETAIL.SHIPPEDQTY)             QTD_PECAS                            " &
"                                                                                  " &
" FROM WMWHSE1.ORDERS,                                                             " &
"      WMWHSE1.ORDERDETAIL,                                                        " &
"      WMSADMIN.PL_DB                                                              " &
"                                                                                  " &
" WHERE ORDERS.INVOICENUMBER != 0                                                  " &
"   AND ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                     " &
"   AND UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                               " &
"   AND ORDERS.STATUS >= 95                                                        " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE)) BETWEEN :DataDe AND :DataAte " &
"                                                                                  " &
" GROUP BY ORDERS.WHSEID,                                                          " &
"          PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,           " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                       " & 
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,         " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24') ,                    " &
"          ORDERS.LANE                                                             " &
"                                                                                  " &
"Union                                                                             " &
"                                                                                  " &
" SELECT                                                                           " &
"   DISTINCT                                                                       " &
"     ORDERS.WHSEID                           FILIAL,                              " &
"     PL_DB.DB_ALIAS                          DSC_PLANTA,                          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,                " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD')                        " &      
"                                            DT_EMISSAO,                            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24')                      " &
"     ORDERS.LANE                             SERIE,                               " &
"     count(distinct ORDERS.ORDERKEY)         QTD_PEDIDO,                          " &
"     count(distinct ORDERS.INVOICENUMBER)    QTD_NOTA,                            " &
"     count(ORDERDETAIL.SKU)                  QTD_ITENS,                           " &
"     sum(ORDERDETAIL.SHIPPEDQTY)             QTD_PECAS                            " &
"                                                                                  " &
" FROM WMWHSE2.ORDERS,                                                             " &
"      WMWHSE2.ORDERDETAIL,                                                        " &
"      WMSADMIN.PL_DB                                                              " &
"                                                                                  " &
" WHERE ORDERS.INVOICENUMBER != 0                                                  " &
"   AND ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                     " &
"   AND UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                               " &
"   AND ORDERS.STATUS >= 95                                                        " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE)) BETWEEN :DataDe AND :DataAte " &
"                                                                                  " &
" GROUP BY ORDERS.WHSEID,                                                          " &
"          PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,           " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                       " & 
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,         " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24') ,                    " &
"          ORDERS.LANE                                                             " &
"                                                                                  " &
"Union                                                                             " &
"                                                                                  " &
" SELECT                                                                           " &
"   DISTINCT                                                                       " &
"     ORDERS.WHSEID                           FILIAL,                              " &
"     PL_DB.DB_ALIAS                          DSC_PLANTA,                          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,                " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD')                        " &      
"                                            DT_EMISSAO,                            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24')                      " &
"     ORDERS.LANE                             SERIE,                               " &
"     count(distinct ORDERS.ORDERKEY)         QTD_PEDIDO,                          " &
"     count(distinct ORDERS.INVOICENUMBER)    QTD_NOTA,                            " &
"     count(ORDERDETAIL.SKU)                  QTD_ITENS,                           " &
"     sum(ORDERDETAIL.SHIPPEDQTY)             QTD_PECAS                            " &
"                                                                                  " &
" FROM WMWHSE3.ORDERS,                                                             " &
"      WMWHSE3.ORDERDETAIL,                                                        " &
"      WMSADMIN.PL_DB                                                              " &
"                                                                                  " &
" WHERE ORDERS.INVOICENUMBER != 0                                                  " &
"   AND ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                     " &
"   AND UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                               " &
"   AND ORDERS.STATUS >= 95                                                        " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE)) BETWEEN :DataDe AND :DataAte " &
"                                                                                  " &
" GROUP BY ORDERS.WHSEID,                                                          " &
"          PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,           " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                       " & 
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,         " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24') ,                    " &
"          ORDERS.LANE                                                             " &
"                                                                                  " &
"Union                                                                             " &
"                                                                                  " &
" SELECT                                                                           " &
"   DISTINCT                                                                       " &
"     ORDERS.WHSEID                           FILIAL,                              " &
"     PL_DB.DB_ALIAS                          DSC_PLANTA,                          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,                " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD')                        " &      
"                                            DT_EMISSAO,                            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24')                      " &
"     ORDERS.LANE                             SERIE,                               " &
"     count(distinct ORDERS.ORDERKEY)         QTD_PEDIDO,                          " &
"     count(distinct ORDERS.INVOICENUMBER)    QTD_NOTA,                            " &
"     count(ORDERDETAIL.SKU)                  QTD_ITENS,                           " &
"     sum(ORDERDETAIL.SHIPPEDQTY)             QTD_PECAS                            " &
"                                                                                  " &
" FROM WMWHSE4.ORDERS,                                                             " &
"      WMWHSE4.ORDERDETAIL,                                                        " &
"      WMSADMIN.PL_DB                                                              " &
"                                                                                  " &
" WHERE ORDERS.INVOICENUMBER != 0                                                  " &
"   AND ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                     " &
"   AND UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                               " &
"   AND ORDERS.STATUS >= 95                                                        " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE)) BETWEEN :DataDe AND :DataAte " &
"                                                                                  " &
" GROUP BY ORDERS.WHSEID,                                                          " &
"          PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,           " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                       " & 
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,         " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24') ,                    " &
"          ORDERS.LANE                                                             " &
"                                                                                  " &
"Union                                                                             " &
"                                                                                  " &
" SELECT                                                                           " &
"   DISTINCT                                                                       " &
"     ORDERS.WHSEID                           FILIAL,                              " &
"     PL_DB.DB_ALIAS                          DSC_PLANTA,                          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,                " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD')                        " &      
"                                            DT_EMISSAO,                            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24')                      " &
"     ORDERS.LANE                             SERIE,                               " &
"     count(distinct ORDERS.ORDERKEY)         QTD_PEDIDO,                          " &
"     count(distinct ORDERS.INVOICENUMBER)    QTD_NOTA,                            " &
"     count(ORDERDETAIL.SKU)                  QTD_ITENS,                           " &
"     sum(ORDERDETAIL.SHIPPEDQTY)             QTD_PECAS                            " &
"                                                                                  " &
" FROM WMWHSE5.ORDERS,                                                             " &
"      WMWHSE5.ORDERDETAIL,                                                        " &
"      WMSADMIN.PL_DB                                                              " &
"                                                                                  " &
" WHERE ORDERS.INVOICENUMBER != 0                                                  " &
"   AND ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                     " &
"   AND UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                               " &
"   AND ORDERS.STATUS >= 95                                                        " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE)) BETWEEN :DataDe AND :DataAte " &
"                                                                                  " &
" GROUP BY ORDERS.WHSEID,                                                          " &
"          PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,           " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                       " & 
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,         " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24') ,                    " &
"          ORDERS.LANE                                                             " &
"                                                                                  " &
"Union                                                                             " &
"                                                                                  " &
" SELECT                                                                           " &
"   DISTINCT                                                                       " &
"     ORDERS.WHSEID                           FILIAL,                              " &
"     PL_DB.DB_ALIAS                          DSC_PLANTA,                          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,                " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD')                        " &      
"                                            DT_EMISSAO,                            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24')                      " &
"     ORDERS.LANE                             SERIE,                               " &
"     count(distinct ORDERS.ORDERKEY)         QTD_PEDIDO,                          " &
"     count(distinct ORDERS.INVOICENUMBER)    QTD_NOTA,                            " &
"     count(ORDERDETAIL.SKU)                  QTD_ITENS,                           " &
"     sum(ORDERDETAIL.SHIPPEDQTY)             QTD_PECAS                            " &
"                                                                                  " &
" FROM WMWHSE6.ORDERS,                                                             " &
"      WMWHSE6.ORDERDETAIL,                                                        " &
"      WMSADMIN.PL_DB                                                              " &
"                                                                                  " &
" WHERE ORDERS.INVOICENUMBER != 0                                                  " &
"   AND ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                     " &
"   AND UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                               " &
"   AND ORDERS.STATUS >= 95                                                        " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE)) BETWEEN :DataDe AND :DataAte " &
"                                                                                  " &
" GROUP BY ORDERS.WHSEID,                                                          " &
"          PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,           " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                       " & 
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,         " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24') ,                    " &
"          ORDERS.LANE                                                             " &
"                                                                                  " &
"Union                                                                             " &
"                                                                                  " &
" SELECT                                                                           " &
"   DISTINCT                                                                       " &
"     ORDERS.WHSEID                           FILIAL,                              " &
"     PL_DB.DB_ALIAS                          DSC_PLANTA,                          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,                " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD')                        " &      
"                                            DT_EMISSAO,                            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24')                      " &
"     ORDERS.LANE                             SERIE,                               " &
"     count(distinct ORDERS.ORDERKEY)         QTD_PEDIDO,                          " &
"     count(distinct ORDERS.INVOICENUMBER)    QTD_NOTA,                            " &
"     count(ORDERDETAIL.SKU)                  QTD_ITENS,                           " &
"     sum(ORDERDETAIL.SHIPPEDQTY)             QTD_PECAS                            " &
"                                                                                  " &
" FROM WMWHSE7.ORDERS,                                                             " &
"      WMWHSE7.ORDERDETAIL,                                                        " &
"      WMSADMIN.PL_DB                                                              " &
"                                                                                  " &
" WHERE ORDERS.INVOICENUMBER != 0                                                  " &
"   AND ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                     " &
"   AND UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                               " &
"   AND ORDERS.STATUS >= 95                                                        " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE)) BETWEEN :DataDe AND :DataAte " &
"                                                                                  " &
" GROUP BY ORDERS.WHSEID,                                                          " &
"          PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,           " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                       " & 
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,         " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           " &
"              AT time zone sessiontimezone) AS DATE), 'HH24') ,                    " &
"          ORDERS.LANE                                                             " &
"ORDER BY 2                                                                        "