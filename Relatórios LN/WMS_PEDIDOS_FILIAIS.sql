SELECT  
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS                FILIAL,
    Sum( case when ORDERS.SUSR2= 'B2C' 
                then 1 
                else 0 
          end )                            B2C,
    
    Sum( case when ORDERS.SUSR2= 'B2B' 
                then 1 
                else 0 
          end )                            B2B,
    
    Count(distinct ORDERDETAIL.SKU)        ITENS,
    ORDERSTATUSSETUP.DESCRIPTION           EVENTO_WMS,
    ORDERS.SCHEDULEDSHIPDATE               LIMITE,
    ORDERS.C_VAT                           MEGA_ROTA
 
FROM WMWHSE4.ORDERS, 
     WMWHSE4.ORDERDETAIL, 
     WMWHSE4.ORDERSTATUSSETUP,
     WMSADMIN.PL_DB
	 
WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY 
  AND ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS 
  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID
  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between :DataLimiteDe 
  AND :DataLimiteAte

GROUP BY ORDERSTATUSSETUP.DESCRIPTION, 
         ORDERS.SCHEDULEDSHIPDATE, 
         ORDERS.C_VAT, 
         WMSADMIN.PL_DB.DB_ALIAS
		 
		 
"SELECT                                                                                  " &
"  DISTINCT                                                                              " &
"    WMSADMIN.PL_DB.DB_ALIAS                FILIAL,                                      " &
"    Sum( case when ORDERS.SUSR2= 'B2C'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2C,                                         " &
"                                                                                        " &
"    Sum( case when ORDERS.SUSR2= 'B2B'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2B,                                         " &
"                                                                                        " &
"    Count(distinct ORDERDETAIL.SKU)        ITENS,                                       " &
"    ORDERSTATUSSETUP.DESCRIPTION           EVENTO_WMS,                                  " &
"    ORDERS.SCHEDULEDSHIPDATE               LIMITE,                                      " &
"    ORDERS.C_VAT                           MEGA_ROTA                                    " &
"                                                                                        " &
"FROM " + Parameters!Table.Value + ".ORDERS,                                             " &
"     " + Parameters!Table.Value + ".ORDERDETAIL,                                        " &
"     " + Parameters!Table.Value + ".ORDERSTATUSSETUP,                                   " &
"     WMSADMIN.PL_DB                                                                     " &
"	                                                                                     " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                            " &
"  AND ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                    " &
"                                                                                        " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'   " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                          " &
"                                                                                        " &
"GROUP BY ORDERSTATUSSETUP.DESCRIPTION,                                                  " &
"         ORDERS.SCHEDULEDSHIPDATE,                                                      " &
"         ORDERS.C_VAT,                                                                  " &
"         WMSADMIN.PL_DB.DB_ALIAS                                                        "

-- Query com UNION ***********************************************************************

"SELECT                                                                                  " &
"  DISTINCT                                                                              " &
"    WMSADMIN.PL_DB.DB_ALIAS                FILIAL,                                      " &
"    Sum( case when ORDERS.SUSR2= 'B2C'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2C,                                         " &
"                                                                                        " &
"    Sum( case when ORDERS.SUSR2= 'B2B'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2B,                                         " &
"                                                                                        " &
"    Count(distinct ORDERDETAIL.SKU)        ITENS,                                       " &
"    ORDERSTATUSSETUP.DESCRIPTION           EVENTO_WMS,                                  " &
"    ORDERS.SCHEDULEDSHIPDATE               LIMITE,                                      " &
"    ORDERS.C_VAT                           MEGA_ROTA                                    " &
"                                                                                        " &
"FROM WMWHSE1.ORDERS,                                                                    " &
"     WMWHSE1.ORDERDETAIL,                                                               " &
"     WMWHSE1.ORDERSTATUSSETUP,                                                          " &
"     WMSADMIN.PL_DB                                                                     " &
"	                                                                                     " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                            " &
"  AND ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                    " &
"                                                                                        " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'   " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                          " &
"                                                                                        " &
"GROUP BY ORDERSTATUSSETUP.DESCRIPTION,                                                  " &
"         ORDERS.SCHEDULEDSHIPDATE,                                                      " &
"         ORDERS.C_VAT,                                                                  " &
"         WMSADMIN.PL_DB.DB_ALIAS                                                        " &
"                                                                                        " &
"Union                                                                                   " &
"                                                                                        " &
"SELECT                                                                                  " &
"  DISTINCT                                                                              " &
"    WMSADMIN.PL_DB.DB_ALIAS                FILIAL,                                      " &
"    Sum( case when ORDERS.SUSR2= 'B2C'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2C,                                         " &
"                                                                                        " &
"    Sum( case when ORDERS.SUSR2= 'B2B'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2B,                                         " &
"                                                                                        " &
"    Count(distinct ORDERDETAIL.SKU)        ITENS,                                       " &
"    ORDERSTATUSSETUP.DESCRIPTION           EVENTO_WMS,                                  " &
"    ORDERS.SCHEDULEDSHIPDATE               LIMITE,                                      " &
"    ORDERS.C_VAT                           MEGA_ROTA                                    " &
"                                                                                        " &
"FROM WMWHSE2.ORDERS,                                                                    " &
"     WMWHSE2.ORDERDETAIL,                                                               " &
"     WMWHSE2.ORDERSTATUSSETUP,                                                          " &
"     WMSADMIN.PL_DB                                                                     " &
"	                                                                                     " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                            " &
"  AND ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                    " &
"                                                                                        " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'   " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                          " &
"                                                                                        " &
"GROUP BY ORDERSTATUSSETUP.DESCRIPTION,                                                  " &
"         ORDERS.SCHEDULEDSHIPDATE,                                                      " &
"         ORDERS.C_VAT,                                                                  " &
"         WMSADMIN.PL_DB.DB_ALIAS                                                        " &
"                                                                                        " &
"Union                                                                                   " &
"                                                                                        " &
"SELECT                                                                                  " &
"  DISTINCT                                                                              " &
"    WMSADMIN.PL_DB.DB_ALIAS                FILIAL,                                      " &
"    Sum( case when ORDERS.SUSR2= 'B2C'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2C,                                         " &
"                                                                                        " &
"    Sum( case when ORDERS.SUSR2= 'B2B'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2B,                                         " &
"                                                                                        " &
"    Count(distinct ORDERDETAIL.SKU)        ITENS,                                       " &
"    ORDERSTATUSSETUP.DESCRIPTION           EVENTO_WMS,                                  " &
"    ORDERS.SCHEDULEDSHIPDATE               LIMITE,                                      " &
"    ORDERS.C_VAT                           MEGA_ROTA                                    " &
"                                                                                        " &
"FROM WMWHSE3.ORDERS,                                                                    " &
"     WMWHSE3.ORDERDETAIL,                                                               " &
"     WMWHSE3.ORDERSTATUSSETUP,                                                          " &
"     WMSADMIN.PL_DB                                                                     " &
"	                                                                                     " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                            " &
"  AND ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                    " &
"                                                                                        " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'   " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                          " &
"                                                                                        " &
"GROUP BY ORDERSTATUSSETUP.DESCRIPTION,                                                  " &
"         ORDERS.SCHEDULEDSHIPDATE,                                                      " &
"         ORDERS.C_VAT,                                                                  " &
"         WMSADMIN.PL_DB.DB_ALIAS                                                        " &
"                                                                                        " &
"Union                                                                                   " &
"                                                                                        " &
"SELECT                                                                                  " &
"  DISTINCT                                                                              " &
"    WMSADMIN.PL_DB.DB_ALIAS                FILIAL,                                      " &
"    Sum( case when ORDERS.SUSR2= 'B2C'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2C,                                         " &
"                                                                                        " &
"    Sum( case when ORDERS.SUSR2= 'B2B'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2B,                                         " &
"                                                                                        " &
"    Count(distinct ORDERDETAIL.SKU)        ITENS,                                       " &
"    ORDERSTATUSSETUP.DESCRIPTION           EVENTO_WMS,                                  " &
"    ORDERS.SCHEDULEDSHIPDATE               LIMITE,                                      " &
"    ORDERS.C_VAT                           MEGA_ROTA                                    " &
"                                                                                        " &
"FROM WMWHSE4.ORDERS,                                                                    " &
"     WMWHSE4.ORDERDETAIL,                                                               " &
"     WMWHSE4.ORDERSTATUSSETUP,                                                          " &
"     WMSADMIN.PL_DB                                                                     " &
"	                                                                                     " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                            " &
"  AND ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                    " &
"                                                                                        " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'   " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                          " &
"                                                                                        " &
"GROUP BY ORDERSTATUSSETUP.DESCRIPTION,                                                  " &
"         ORDERS.SCHEDULEDSHIPDATE,                                                      " &
"         ORDERS.C_VAT,                                                                  " &
"         WMSADMIN.PL_DB.DB_ALIAS                                                        " &
"                                                                                        " &
"Union                                                                                   " &
"                                                                                        " &
"SELECT                                                                                  " &
"  DISTINCT                                                                              " &
"    WMSADMIN.PL_DB.DB_ALIAS                FILIAL,                                      " &
"    Sum( case when ORDERS.SUSR2= 'B2C'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2C,                                         " &
"                                                                                        " &
"    Sum( case when ORDERS.SUSR2= 'B2B'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2B,                                         " &
"                                                                                        " &
"    Count(distinct ORDERDETAIL.SKU)        ITENS,                                       " &
"    ORDERSTATUSSETUP.DESCRIPTION           EVENTO_WMS,                                  " &
"    ORDERS.SCHEDULEDSHIPDATE               LIMITE,                                      " &
"    ORDERS.C_VAT                           MEGA_ROTA                                    " &
"                                                                                        " &
"FROM WMWHSE5.ORDERS,                                                                    " &
"     WMWHSE5.ORDERDETAIL,                                                               " &
"     WMWHSE5.ORDERSTATUSSETUP,                                                          " &
"     WMSADMIN.PL_DB                                                                     " &
"	                                                                                     " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                            " &
"  AND ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                    " &
"                                                                                        " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'   " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                          " &
"                                                                                        " &
"GROUP BY ORDERSTATUSSETUP.DESCRIPTION,                                                  " &
"         ORDERS.SCHEDULEDSHIPDATE,                                                      " &
"         ORDERS.C_VAT,                                                                  " &
"         WMSADMIN.PL_DB.DB_ALIAS                                                        " &
"                                                                                        " &
"Union                                                                                   " &
"                                                                                        " &
"SELECT                                                                                  " &
"  DISTINCT                                                                              " &
"    WMSADMIN.PL_DB.DB_ALIAS                FILIAL,                                      " &
"    Sum( case when ORDERS.SUSR2= 'B2C'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2C,                                         " &
"                                                                                        " &
"    Sum( case when ORDERS.SUSR2= 'B2B'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2B,                                         " &
"                                                                                        " &
"    Count(distinct ORDERDETAIL.SKU)        ITENS,                                       " &
"    ORDERSTATUSSETUP.DESCRIPTION           EVENTO_WMS,                                  " &
"    ORDERS.SCHEDULEDSHIPDATE               LIMITE,                                      " &
"    ORDERS.C_VAT                           MEGA_ROTA                                    " &
"                                                                                        " &
"FROM WMWHSE6.ORDERS,                                                                    " &
"     WMWHSE6.ORDERDETAIL,                                                               " &
"     WMWHSE6.ORDERSTATUSSETUP,                                                          " &
"     WMSADMIN.PL_DB                                                                     " &
"	                                                                                     " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                            " &
"  AND ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                    " &
"                                                                                        " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'   " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                          " &
"                                                                                        " &
"GROUP BY ORDERSTATUSSETUP.DESCRIPTION,                                                  " &
"         ORDERS.SCHEDULEDSHIPDATE,                                                      " &
"         ORDERS.C_VAT,                                                                  " &
"         WMSADMIN.PL_DB.DB_ALIAS                                                        " &
"                                                                                        " &
"Union                                                                                   " &
"                                                                                        " &
"SELECT                                                                                  " &
"  DISTINCT                                                                              " &
"    WMSADMIN.PL_DB.DB_ALIAS                FILIAL,                                      " &
"    Sum( case when ORDERS.SUSR2= 'B2C'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2C,                                         " &
"                                                                                        " &
"    Sum( case when ORDERS.SUSR2= 'B2B'                                                  " &
"                then 1                                                                  " &
"                else 0                                                                  " &
"          end )                            B2B,                                         " &
"                                                                                        " &
"    Count(distinct ORDERDETAIL.SKU)        ITENS,                                       " &
"    ORDERSTATUSSETUP.DESCRIPTION           EVENTO_WMS,                                  " &
"    ORDERS.SCHEDULEDSHIPDATE               LIMITE,                                      " &
"    ORDERS.C_VAT                           MEGA_ROTA                                    " &
"                                                                                        " &
"FROM WMWHSE7.ORDERS,                                                                    " &
"     WMWHSE7.ORDERDETAIL,                                                               " &
"     WMWHSE7.ORDERSTATUSSETUP,                                                          " &
"     WMSADMIN.PL_DB                                                                     " &
"	                                                                                     " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                            " &
"  AND ORDERSTATUSSETUP.CODE = ORDERDETAIL.STATUS                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                    " &
"                                                                                        " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'   " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                          " &
"                                                                                        " &
"GROUP BY ORDERSTATUSSETUP.DESCRIPTION,                                                  " &
"         ORDERS.SCHEDULEDSHIPDATE,                                                      " &
"         ORDERS.C_VAT,                                                                  " &
"         WMSADMIN.PL_DB.DB_ALIAS                                                        " &
"                                                                                        " &
"order by FILIAL                                                                         "