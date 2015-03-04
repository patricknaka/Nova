SELECT  
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL, 
    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'MON')              
                                                     MES,
    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,
    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,
    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO
 
FROM       BAANDB.TZNSLS401301@pln01 SLS401

INNER JOIN WMWHSE5.ORDERS
        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT
        
 LEFT JOIN WMWHSE5.ORDERDETAIL
        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY
        
 LEFT JOIN WMWHSE5.SKU
        ON SKU.SKU = ORDERDETAIL.SKU
        
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID
     
WHERE ORDERS.STATUS >= 95
  AND ORDERS.ACTUALSHIPDATE IS NOT NULL
--  AND (  ( (CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
--      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--        AT time zone 'America/Sao_Paulo') AS DATE)) Between ('01/' || :ExpedidoDe) 
--                                     And ( To_Char(LAST_DAY('01/' || :ExpedidoAte), 'dd/MM/yyyy') )  )
--        OR :ExpedidoDe Is Null OR :ExpedidoAte Is Null )
  
GROUP BY WMSADMIN.PL_DB.DB_ALIAS, 
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'MON')

"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'MON')                   " &
"                                                     MES,                " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,         " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,     " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO       " &
"                                                                         " &
"FROM       BAANDB.TZNSLS401301@pln01 SLS401                              " &
"                                                                         " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERS                         " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                    " &
"                                                                         " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERDETAIL                    " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
" LEFT JOIN " + Parameters!Table.Value + ".SKU                            " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"WHERE ORDERS.STATUS >= 95                                                " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                  " &
"  AND (  ( (CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                          " & 
"         Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')        " &
"         And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )         " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null ) " &
"                                                                         " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                        " & 
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, " & 
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'MON')              " &
"                                                                         " 

-- Query com UNION *******************************************************************************


"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'MON')                   " &
"                                                     MES,                " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,         " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,     " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO       " &
"                                                                         " &
"FROM       BAANDB.TZNSLS401301@pln01 SLS401                              " &
"                                                                         " &
"INNER JOIN WMWHSE1.ORDERS                                                " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                    " &
"                                                                         " &
" LEFT JOIN WMWHSE1.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
" LEFT JOIN WMWHSE1.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"WHERE ORDERS.STATUS >= 95                                                " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                  " &
"  AND (  ( (CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                          " & 
"         Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')        " &
"         And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )         " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null ) " &
"                                                                         " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                        " & 
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, " & 
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'MON')              " &
"                                                                         " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'MON')                   " &
"                                                     MES,                " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,         " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,     " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO       " &
"                                                                         " &
"FROM       BAANDB.TZNSLS401301@pln01 SLS401                              " &
"                                                                         " &
"INNER JOIN WMWHSE2.ORDERS                                                " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                    " &
"                                                                         " &
" LEFT JOIN WMWHSE2.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
" LEFT JOIN WMWHSE2.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"WHERE ORDERS.STATUS >= 95                                                " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                  " &
"  AND (  ( (CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                          " & 
"         Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')        " &
"         And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )         " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null ) " &
"                                                                         " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                        " & 
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, " & 
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'MON')              " &
"                                                                         " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'MON')                   " &
"                                                     MES,                " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,         " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,     " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO       " &
"                                                                         " &
"FROM       BAANDB.TZNSLS401301@pln01 SLS401                              " &
"                                                                         " &
"INNER JOIN WMWHSE3.ORDERS                                                " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                    " &
"                                                                         " &
" LEFT JOIN WMWHSE3.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
" LEFT JOIN WMWHSE3.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"WHERE ORDERS.STATUS >= 95                                                " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                  " &
"  AND (  ( (CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                          " & 
"         Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')        " &
"         And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )         " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null ) " &
"                                                                         " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                        " & 
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, " & 
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'MON')              " &
"                                                                         " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'MON')                   " &
"                                                     MES,                " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,         " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,     " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO       " &
"                                                                         " &
"FROM       BAANDB.TZNSLS401301@pln01 SLS401                              " &
"                                                                         " &
"INNER JOIN WMWHSE4.ORDERS                                                " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                    " &
"                                                                         " &
" LEFT JOIN WMWHSE4.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
" LEFT JOIN WMWHSE4.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"WHERE ORDERS.STATUS >= 95                                                " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                  " &
"  AND (  ( (CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                          " & 
"         Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')        " &
"         And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )         " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null ) " &
"                                                                         " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                        " & 
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, " & 
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'MON')              " &
"                                                                         " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'MON')                   " &
"                                                     MES,                " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,         " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,     " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO       " &
"                                                                         " &
"FROM       BAANDB.TZNSLS401301@pln01 SLS401                              " &
"                                                                         " &
"INNER JOIN WMWHSE5.ORDERS                                                " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                    " &
"                                                                         " &
" LEFT JOIN WMWHSE5.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
" LEFT JOIN WMWHSE5.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"WHERE ORDERS.STATUS >= 95                                                " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                  " &
"  AND (  ( (CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                          " & 
"         Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')        " &
"         And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )         " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null ) " &
"                                                                         " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                        " & 
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, " & 
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'MON')              " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'MON')                   " &
"                                                     MES,                " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,         " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,     " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO       " &
"                                                                         " &
"FROM       BAANDB.TZNSLS401301@pln01 SLS401                              " &
"                                                                         " &
"INNER JOIN WMWHSE6.ORDERS                                                " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                    " &
"                                                                         " &
" LEFT JOIN WMWHSE6.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
" LEFT JOIN WMWHSE6.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"WHERE ORDERS.STATUS >= 95                                                " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                  " &
"  AND (  ( (CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                          " & 
"         Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')        " &
"         And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )         " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null ) " &
"                                                                         " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                        " & 
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, " & 
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'MON')              " &
"                                                                         " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,      " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'MON')                   " &
"                                                     MES,                " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,         " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,     " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO       " &
"                                                                         " &
"FROM       BAANDB.TZNSLS401301@pln01 SLS401                              " &
"                                                                         " &
"INNER JOIN WMWHSE7.ORDERS                                                " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                    " &
"                                                                         " &
" LEFT JOIN WMWHSE7.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
" LEFT JOIN WMWHSE7.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"WHERE ORDERS.STATUS >= 95                                                " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                  " &
"  AND (  ( (CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                          " & 
"         Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')        " &
"         And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )         " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null ) " &
"                                                                         " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                        " & 
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, " & 
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'MON')              " &
"                                                                         " &
"ORDER BY WMSADMIN.PL_DB.DB_ALIAS, TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')    "