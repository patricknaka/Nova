SELECT  
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL, 
    TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')              MES,
    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,
    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,
    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO
 
FROM WMWHSE4.ORDERDETAIL, 
     WMWHSE4.SKU, 
     WMWHSE4.ORDERS,
     WMSADMIN.PL_DB,  
     BAANDB.TZNSLS401201@dln01 SLS401
 
WHERE SKU.SKU = ORDERDETAIL.SKU 
  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT
  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY
  AND ORDERS.STATUS >= 95
  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID
  AND ORDERS.ACTUALSHIPDATE IS NOT NULL
--  AND (   (TO_CHAR(ORDERS.ACTUALSHIPDATE, 'MM/yyyy') = :Expedido) 
--       OR (:Expedido is null) )
  AND (  ( (ORDERS.ACTUALSHIPDATE) Between ('01/' || :ExpedidoDe) 
                                     And ( To_Char(LAST_DAY('01/' || :ExpedidoAte), 'dd/MM/yyyy') )  )
        OR :ExpedidoDe Is Null OR :ExpedidoAte Is Null )

	
GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')


"SELECT                                                                                        " &
"  DISTINCT                                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                                  " &
"    TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')              MES,                                     " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,                              " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,                          " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO                            " &
"                                                                                              " &
"FROM " + Parameters!Table.Value + ".ORDERDETAIL,                                              " &
"     " + Parameters!Table.Value + ".SKU,                                                      " &
"     " + Parameters!Table.Value + ".ORDERS,                                                   " &
"     WMSADMIN.PL_DB,                                                                          " &
"     BAANDB.TZNSLS401201@dln01 SLS401                                                         " &
"                                                                                              " &
"WHERE SKU.SKU = ORDERDETAIL.SKU                                                               " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                              " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                  " &
"  AND ORDERS.STATUS >= 95                                                                     " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                          " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                                       " &
"  AND (  ( (ORDERS.ACTUALSHIPDATE) Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')                                       " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null )                      " &
"	                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')                         " &
"                                                                                              " &
"ORDER BY WMSADMIN.PL_DB.DB_ALIAS, TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')                         "

-- Query com UNION *******************************************************************************

"SELECT                                                                                        " &
"  DISTINCT                                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                                  " &
"    TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')              MES,                                     " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,                              " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,                          " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO                            " &
"                                                                                              " &
"FROM WMWHSE1.ORDERDETAIL,                                                                     " &
"     WMWHSE1.SKU,                                                                             " &
"     WMWHSE1.ORDERS,                                                                          " &
"     WMSADMIN.PL_DB,                                                                          " &
"     BAANDB.TZNSLS401201@dln01 SLS401                                                         " &
"                                                                                              " &
"WHERE SKU.SKU = ORDERDETAIL.SKU                                                               " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                              " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                  " &
"  AND ORDERS.STATUS >= 95                                                                     " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                          " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                                       " &
"  AND (  ( (ORDERS.ACTUALSHIPDATE) Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')                                       " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null )                      " &
"	                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')                         " &
"                                                                                              " &
"Union                                                                                         " &
"                                                                                              " &
"SELECT                                                                                        " &
"  DISTINCT                                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                                  " &
"    TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')              MES,                                     " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,                              " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,                          " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO                            " &
"                                                                                              " &
"FROM WMWHSE2.ORDERDETAIL,                                                                     " &
"     WMWHSE2.SKU,                                                                             " &
"     WMWHSE2.ORDERS,                                                                          " &
"     WMSADMIN.PL_DB,                                                                          " &
"     BAANDB.TZNSLS401201@dln01 SLS401                                                         " &
"                                                                                              " &
"WHERE SKU.SKU = ORDERDETAIL.SKU                                                               " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                              " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                  " &
"  AND ORDERS.STATUS >= 95                                                                     " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                          " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                                       " &
"  AND (  ( (ORDERS.ACTUALSHIPDATE) Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')                                       " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null )                      " &
"	                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')                         " &
"                                                                                              " &
"Union                                                                                         " &
"                                                                                              " &
"SELECT                                                                                        " &
"  DISTINCT                                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                                  " &
"    TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')              MES,                                     " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,                              " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,                          " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO                            " &
"                                                                                              " &
"FROM WMWHSE3.ORDERDETAIL,                                                                     " &
"     WMWHSE3.SKU,                                                                             " &
"     WMWHSE3.ORDERS,                                                                          " &
"     WMSADMIN.PL_DB,                                                                          " &
"     BAANDB.TZNSLS401201@dln01 SLS401                                                         " &
"                                                                                              " &
"WHERE SKU.SKU = ORDERDETAIL.SKU                                                               " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                              " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                  " &
"  AND ORDERS.STATUS >= 95                                                                     " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                          " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                                       " &
"  AND (  ( (ORDERS.ACTUALSHIPDATE) Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')                                       " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null )                      " &
"	                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')                         " &
"                                                                                              " &
"Union                                                                                         " &
"                                                                                              " &
"SELECT                                                                                        " &
"  DISTINCT                                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                                  " &
"    TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')              MES,                                     " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,                              " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,                          " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO                            " &
"                                                                                              " &
"FROM WMWHSE4.ORDERDETAIL,                                                                     " &
"     WMWHSE4.SKU,                                                                             " &
"     WMWHSE4.ORDERS,                                                                          " &
"     WMSADMIN.PL_DB,                                                                          " &
"     BAANDB.TZNSLS401201@dln01 SLS401                                                         " &
"                                                                                              " &
"WHERE SKU.SKU = ORDERDETAIL.SKU                                                               " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                              " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                  " &
"  AND ORDERS.STATUS >= 95                                                                     " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                          " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                                       " &
"  AND (  ( (ORDERS.ACTUALSHIPDATE) Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')                                       " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null )                      " &
"	                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')                         " &
"                                                                                              " &
"Union                                                                                         " &
"                                                                                              " &
"SELECT                                                                                        " &
"  DISTINCT                                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                                  " &
"    TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')              MES,                                     " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,                              " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,                          " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO                            " &
"                                                                                              " &
"FROM WMWHSE5.ORDERDETAIL,                                                                     " &
"     WMWHSE5.SKU,                                                                             " &
"     WMWHSE5.ORDERS,                                                                          " &
"     WMSADMIN.PL_DB,                                                                          " &
"     BAANDB.TZNSLS401201@dln01 SLS401                                                         " &
"                                                                                              " &
"WHERE SKU.SKU = ORDERDETAIL.SKU                                                               " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                              " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                  " &
"  AND ORDERS.STATUS >= 95                                                                     " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                          " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                                       " &
"  AND (  ( (ORDERS.ACTUALSHIPDATE) Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')                                       " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null )                      " &
"	                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')                         " &
"                                                                                              " &
"Union                                                                                         " &
"                                                                                              " &
"SELECT                                                                                        " &
"  DISTINCT                                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                                  " &
"    TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')              MES,                                     " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,                              " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,                          " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO                            " &
"                                                                                              " &
"FROM WMWHSE6.ORDERDETAIL,                                                                     " &
"     WMWHSE6.SKU,                                                                             " &
"     WMWHSE6.ORDERS,                                                                          " &
"     WMSADMIN.PL_DB,                                                                          " &
"     BAANDB.TZNSLS401201@dln01 SLS401                                                         " &
"                                                                                              " &
"WHERE SKU.SKU = ORDERDETAIL.SKU                                                               " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                              " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                  " &
"  AND ORDERS.STATUS >= 95                                                                     " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                          " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                                       " &
"  AND (  ( (ORDERS.ACTUALSHIPDATE) Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')                                       " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null )                      " &
"	                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')                         " &
"                                                                                              " &
"Union                                                                                         " &
"                                                                                              " &
"SELECT                                                                                        " &
"  DISTINCT                                                                                    " &
"    WMSADMIN.PL_DB.DB_ALIAS                          FILIAL,                                  " &
"    TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')              MES,                                     " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                      QTDE_PECAS,                              " &
"    sum(SLS401.T$VLUN$C * ORDERDETAIL.SHIPPEDQTY)    VALOR_EXPEDIDO,                          " &
"    sum(SKU.STDCUBE * ORDERDETAIL.SHIPPEDQTY)        VOLUME_CUBADO                            " &
"                                                                                              " &
"FROM WMWHSE7.ORDERDETAIL,                                                                     " &
"     WMWHSE7.SKU,                                                                             " &
"     WMWHSE7.ORDERS,                                                                          " &
"     WMSADMIN.PL_DB,                                                                          " &
"     BAANDB.TZNSLS401201@dln01 SLS401                                                         " &
"                                                                                              " &
"WHERE SKU.SKU = ORDERDETAIL.SKU                                                               " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                              " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                  " &
"  AND ORDERS.STATUS >= 95                                                                     " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                          " &
"  AND ORDERS.ACTUALSHIPDATE IS NOT NULL                                                       " &
"  AND (  ( (ORDERS.ACTUALSHIPDATE) Between ('01/' || '" + Parameters!ExpedidoDe.Value + "')                                       " &
"                                     And ( To_Char(LAST_DAY('01/' || '" + Parameters!ExpedidoAte.Value + "'), 'dd/MM/yyyy') )  )  " &
"        OR '" + Parameters!ExpedidoDe.Value + "' Is Null OR '" + Parameters!ExpedidoAte.Value + "' Is Null )                      " &
"	                                                                                           " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS, TRUNC(ORDERS.ACTUALSHIPDATE, 'MON')                         " &
"                                                                                              " &
"ORDER BY FILIAL, MES                                                                          "