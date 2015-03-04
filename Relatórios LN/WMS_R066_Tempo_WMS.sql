SELECT
  DISTINCT
    WMSADMIN.DB_ALIAS               PLANTA,
    ORDERS.ORDERKEY                 ENTREGA,
    ORDERS.STATUS                   SIT,
    ORDERSTATUSSETUP.DESCRIPTION    DESCR_SIT,
    nvl( ( select A.STATUS
             from WMWHSE5.ORDERSTATUSHISTORY  A
            where A.ADDDATE = ( select max(A1.ADDDATE) 
                                  from WMWHSE5.ORDERSTATUSHISTORY  A1
                                 where A1.ORDERKEY = A.ORDERKEY )
              and A.ORDERKEY = ORDERS.ORDERKEY
              and rownum = 1 ), ORDERS.STATUS ) 
                                    ULT_EVENTO,
  
    nvl( ( select B.DESCRIPTION
             from WMWHSE5.ORDERSTATUSHISTORY  A,
                  WMWHSE5.ORDERSTATUSSETUP    B
            where A.ADDDATE = ( select max(A1.ADDDATE) 
                                  from WMWHSE5.ORDERSTATUSHISTORY  A1
                                 where A1.ORDERKEY = A.ORDERKEY )
              and A.ORDERKEY = ORDERS.ORDERKEY
              and B.CODE = A.STATUS
              and rownum = 1 ), ( select B.DESCRIPTION 
                                    from WMWHSE5.ORDERSTATUSSETUP  B
                                   where B.CODE = ORDERS.STATUS ) ) 
                                    DESCRICAO,
                  
    nvl( ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.ADDDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE)
             from WMWHSE5.ORDERSTATUSHISTORY  A
            where A.ADDDATE = ( select max(A1.ADDDATE) 
                                  from WMWHSE5.ORDERSTATUSHISTORY  A1
                                 where A1.ORDERKEY = A.ORDERKEY )
              and A.ORDERKEY = ORDERS.ORDERKEY
              and rownum = 1 ), CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE, 
                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                              AT time zone 'America/Sao_Paulo') AS DATE)) 
                                    DT_ULT_EVENTO,
                  
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone 'America/Sao_Paulo') AS DATE)                  
                                    DT_WMS,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone 'America/Sao_Paulo') AS DATE)                 
                                    PETK_DT_FECHAMENTO_GAIOLA,  
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone 'America/Sao_Paulo') AS DATE)        
                                    DT_LIMITE,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone 'America/Sao_Paulo') AS DATE)        
                                    DT_PROMETIDA,
    ORDERS.C_VAT                    MEGA_ROTA,
    znsls401.t$fovn$c               PEDV_ID_TRANSP,
    ORDERS.CARRIERNAME              TRASNPORTADORA
  
FROM       BAANDB.TZNSLS401301@pln01  znsls401

INNER JOIN WMWHSE5.ORDERS             ORDERS
        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT
        
 LEFT JOIN WMWHSE5.ORDERDETAIL        ORDERDETAIL
        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY
         
 LEFT JOIN WMWHSE5.ORDERSTATUSSETUP
        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS
  
INNER JOIN WMSADMIN.PL_DB             WMSADMIN
        ON UPPER(WMSADMIN.DB_LOGID) = ORDERS.WHSEID
        
 LEFT JOIN WMWHSE5.CAGEIDDETAIL       CAGEIDDETAIL                                    
        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY
 
 LEFT JOIN WMWHSE5.CAGEID             CAGEID
        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID

WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataLimiteDe
  AND :DataLimiteAte
  

"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    WMSADMIN.DB_ALIAS               PLANTA,                                                  " &
"    ORDERS.ORDERKEY                 ENTREGA,                                                 " &
"    ORDERS.STATUS                   SIT,                                                     " &
"    ORDERSTATUSSETUP.DESCRIPTION    DESCR_SIT,                                               " &
"    nvl( ( select A.STATUS                                                                   " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), ORDERS.STATUS )                                              " &
"                                    ULT_EVENTO,                                              " &
"                                                                                             " &
"    nvl( ( select B.DESCRIPTION                                                              " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A,                      " &
"                  " + Parameters!Table.Value + ".ORDERSTATUSSETUP    B                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and B.CODE = A.STATUS                                                          " &
"              and rownum = 1 ), ( select B.DESCRIPTION                                       " &
"                                    from " + Parameters!Table.Value + ".ORDERSTATUSSETUP  B  " &
"                                   where B.CODE = ORDERS.STATUS ) )                          " &
"                                    DESCRICAO,                                               " &
"                                                                                             " &
"    nvl( ( select select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.ADDDATE,                       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE)                                         " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,          " & 
"                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"                              AT time zone 'America/Sao_Paulo') AS DATE) )                       " &
"                                    DT_ULT_EVENTO,                                           " &
"                                                                                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                                       " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                  
"                                    DT_WMS,                                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                 
"                                    PETK_DT_FECHAMENTO_GAIOLA,                               " &  
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_LIMITE,                                               " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_PROMETIDA,                                            " &
"    ORDERS.C_VAT                    MEGA_ROTA,                                               " &
"    znsls401.t$fovn$c               PEDV_ID_TRANSP,                                          " &
"    ORDERS.CARRIERNAME              TRASNPORTADORA                                           " &
"                                                                                             " &
"FROM       BAANDB.TZNSLS401301@pln01  znsls401                                               " &
"                                                                                             " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERS             ORDERS                          " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                             " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERDETAIL        ORDERDETAIL                     " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP                                   " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                             " &
"                                                                                             " &
"INNER JOIN WMSADMIN.PL_DB             WMSADMIN                                               " &
"        ON UPPER(WMSADMIN.DB_LOGID) = ORDERS.WHSEID                                          " &
"                                                                                             " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEIDDETAIL       CAGEIDDETAIL                    " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEID             CAGEID                          " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                                               " &
"                                                                                             " &
"WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                     " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                                             " & 
"  Between '" + Parameters!DataLimiteDe.Value + "'                                            " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                               " & 

-- Query com UNION ******************************************************************************

"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    WMSADMIN.DB_ALIAS               PLANTA,                                                  " &
"    ORDERS.ORDERKEY                 ENTREGA,                                                 " &
"    ORDERS.STATUS                   SIT,                                                     " &
"    ORDERSTATUSSETUP.DESCRIPTION    DESCR_SIT,                                               " &
"    nvl( ( select A.STATUS                                                                   " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), ORDERS.STATUS )                                              " &
"                                    ULT_EVENTO,                                              " &
"                                                                                             " &
"    nvl( ( select B.DESCRIPTION                                                              " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A,                      " &
"                  " + Parameters!Table.Value + ".ORDERSTATUSSETUP    B                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and B.CODE = A.STATUS                                                          " &
"              and rownum = 1 ), ( select B.DESCRIPTION                                       " &
"                                    from " + Parameters!Table.Value + ".ORDERSTATUSSETUP  B  " &
"                                   where B.CODE = ORDERS.STATUS ) )                          " &
"                                    DESCRICAO,                                               " &
"                                                                                             " &
"    nvl( ( select select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.ADDDATE,                       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE)                                         " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,          " & 
"                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"                              AT time zone 'America/Sao_Paulo') AS DATE) )                       " &
"                                    DT_ULT_EVENTO,                                           " &
"                                                                                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                                       " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                  
"                                    DT_WMS,                                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                 
"                                    PETK_DT_FECHAMENTO_GAIOLA,                               " &  
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_LIMITE,                                               " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_PROMETIDA,                                            " &
"    ORDERS.C_VAT                    MEGA_ROTA,                                               " &
"    znsls401.t$fovn$c               PEDV_ID_TRANSP,                                          " &
"    ORDERS.CARRIERNAME              TRASNPORTADORA                                           " &
"                                                                                             " &
"FROM       BAANDB.TZNSLS401301@pln01  znsls401                                               " &
"                                                                                             " &
"INNER JOIN WMWHSE1.ORDERS             ORDERS                                                 " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                             " &
" LEFT JOIN WMWHSE1.ORDERDETAIL        ORDERDETAIL                                            " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE1.ORDERSTATUSSETUP                                                          " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                             " &
"                                                                                             " &
"INNER JOIN WMSADMIN.PL_DB             WMSADMIN                                               " &
"        ON UPPER(WMSADMIN.DB_LOGID) = ORDERS.WHSEID                                          " &
"                                                                                             " &
" LEFT JOIN WMWHSE1.CAGEIDDETAIL       CAGEIDDETAIL                                           " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE1.CAGEID             CAGEID                                                 " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                                               " &
"                                                                                             " &
"WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                     " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                                             " & 
"  Between '" + Parameters!DataLimiteDe.Value + "'                                            " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                               " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    WMSADMIN.DB_ALIAS               PLANTA,                                                  " &
"    ORDERS.ORDERKEY                 ENTREGA,                                                 " &
"    ORDERS.STATUS                   SIT,                                                     " &
"    ORDERSTATUSSETUP.DESCRIPTION    DESCR_SIT,                                               " &
"    nvl( ( select A.STATUS                                                                   " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), ORDERS.STATUS )                                              " &
"                                    ULT_EVENTO,                                              " &
"                                                                                             " &
"    nvl( ( select B.DESCRIPTION                                                              " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A,                      " &
"                  " + Parameters!Table.Value + ".ORDERSTATUSSETUP    B                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and B.CODE = A.STATUS                                                          " &
"              and rownum = 1 ), ( select B.DESCRIPTION                                       " &
"                                    from " + Parameters!Table.Value + ".ORDERSTATUSSETUP  B  " &
"                                   where B.CODE = ORDERS.STATUS ) )                          " &
"                                    DESCRICAO,                                               " &
"                                                                                             " &
"    nvl( ( select select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.ADDDATE,                       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE)                                         " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,          " & 
"                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"                              AT time zone 'America/Sao_Paulo') AS DATE) )                       " &
"                                    DT_ULT_EVENTO,                                           " &
"                                                                                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                                       " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                  
"                                    DT_WMS,                                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                 
"                                    PETK_DT_FECHAMENTO_GAIOLA,                               " &  
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_LIMITE,                                               " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_PROMETIDA,                                            " &
"    ORDERS.C_VAT                    MEGA_ROTA,                                               " &
"    znsls401.t$fovn$c               PEDV_ID_TRANSP,                                          " &
"    ORDERS.CARRIERNAME              TRASNPORTADORA                                           " &
"                                                                                             " &
"FROM       BAANDB.TZNSLS401301@pln01  znsls401                                               " &
"                                                                                             " &
"INNER JOIN WMWHSE2.ORDERS             ORDERS                                                 " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                             " &
" LEFT JOIN WMWHSE2.ORDERDETAIL        ORDERDETAIL                                            " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE2.ORDERSTATUSSETUP                                                          " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                             " &
"                                                                                             " &
"INNER JOIN WMSADMIN.PL_DB             WMSADMIN                                               " &
"        ON UPPER(WMSADMIN.DB_LOGID) = ORDERS.WHSEID                                          " &
"                                                                                             " &
" LEFT JOIN WMWHSE2.CAGEIDDETAIL       CAGEIDDETAIL                                           " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE2.CAGEID             CAGEID                                                 " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                                               " &
"                                                                                             " &
"WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                     " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                                             " & 
"  Between '" + Parameters!DataLimiteDe.Value + "'                                            " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                               " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    WMSADMIN.DB_ALIAS               PLANTA,                                                  " &
"    ORDERS.ORDERKEY                 ENTREGA,                                                 " &
"    ORDERS.STATUS                   SIT,                                                     " &
"    ORDERSTATUSSETUP.DESCRIPTION    DESCR_SIT,                                               " &
"    nvl( ( select A.STATUS                                                                   " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), ORDERS.STATUS )                                              " &
"                                    ULT_EVENTO,                                              " &
"                                                                                             " &
"    nvl( ( select B.DESCRIPTION                                                              " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A,                      " &
"                  " + Parameters!Table.Value + ".ORDERSTATUSSETUP    B                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and B.CODE = A.STATUS                                                          " &
"              and rownum = 1 ), ( select B.DESCRIPTION                                       " &
"                                    from " + Parameters!Table.Value + ".ORDERSTATUSSETUP  B  " &
"                                   where B.CODE = ORDERS.STATUS ) )                          " &
"                                    DESCRICAO,                                               " &
"                                                                                             " &
"    nvl( ( select select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.ADDDATE,                       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE)                                         " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,          " & 
"                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"                              AT time zone 'America/Sao_Paulo') AS DATE) )                       " &
"                                    DT_ULT_EVENTO,                                           " &
"                                                                                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                                       " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                  
"                                    DT_WMS,                                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                 
"                                    PETK_DT_FECHAMENTO_GAIOLA,                               " &  
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_LIMITE,                                               " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_PROMETIDA,                                            " &
"    ORDERS.C_VAT                    MEGA_ROTA,                                               " &
"    znsls401.t$fovn$c               PEDV_ID_TRANSP,                                          " &
"    ORDERS.CARRIERNAME              TRASNPORTADORA                                           " &
"                                                                                             " &
"FROM       BAANDB.TZNSLS401301@pln01  znsls401                                               " &
"                                                                                             " &
"INNER JOIN WMWHSE3.ORDERS             ORDERS                                                 " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                             " &
" LEFT JOIN WMWHSE3.ORDERDETAIL        ORDERDETAIL                                            " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE3.ORDERSTATUSSETUP                                                          " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                             " &
"                                                                                             " &
"INNER JOIN WMSADMIN.PL_DB             WMSADMIN                                               " &
"        ON UPPER(WMSADMIN.DB_LOGID) = ORDERS.WHSEID                                          " &
"                                                                                             " &
" LEFT JOIN WMWHSE3.CAGEIDDETAIL       CAGEIDDETAIL                                           " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE3.CAGEID             CAGEID                                                 " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                                               " &
"                                                                                             " &
"WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                     " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                                             " & 
"  Between '" + Parameters!DataLimiteDe.Value + "'                                            " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                               " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    WMSADMIN.DB_ALIAS               PLANTA,                                                  " &
"    ORDERS.ORDERKEY                 ENTREGA,                                                 " &
"    ORDERS.STATUS                   SIT,                                                     " &
"    ORDERSTATUSSETUP.DESCRIPTION    DESCR_SIT,                                               " &
"    nvl( ( select A.STATUS                                                                   " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), ORDERS.STATUS )                                              " &
"                                    ULT_EVENTO,                                              " &
"                                                                                             " &
"    nvl( ( select B.DESCRIPTION                                                              " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A,                      " &
"                  " + Parameters!Table.Value + ".ORDERSTATUSSETUP    B                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and B.CODE = A.STATUS                                                          " &
"              and rownum = 1 ), ( select B.DESCRIPTION                                       " &
"                                    from " + Parameters!Table.Value + ".ORDERSTATUSSETUP  B  " &
"                                   where B.CODE = ORDERS.STATUS ) )                          " &
"                                    DESCRICAO,                                               " &
"                                                                                             " &
"    nvl( ( select select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.ADDDATE,                       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE)                                         " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,          " & 
"                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"                              AT time zone 'America/Sao_Paulo') AS DATE) )                       " &
"                                    DT_ULT_EVENTO,                                           " &
"                                                                                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                                       " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                  
"                                    DT_WMS,                                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                 
"                                    PETK_DT_FECHAMENTO_GAIOLA,                               " &  
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_LIMITE,                                               " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_PROMETIDA,                                            " &
"    ORDERS.C_VAT                    MEGA_ROTA,                                               " &
"    znsls401.t$fovn$c               PEDV_ID_TRANSP,                                          " &
"    ORDERS.CARRIERNAME              TRASNPORTADORA                                           " &
"                                                                                             " &
"FROM       BAANDB.TZNSLS401301@pln01  znsls401                                               " &
"                                                                                             " &
"INNER JOIN WMWHSE4.ORDERS             ORDERS                                                 " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                             " &
" LEFT JOIN WMWHSE4.ORDERDETAIL        ORDERDETAIL                                            " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE4.ORDERSTATUSSETUP                                                          " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                             " &
"                                                                                             " &
"INNER JOIN WMSADMIN.PL_DB             WMSADMIN                                               " &
"        ON UPPER(WMSADMIN.DB_LOGID) = ORDERS.WHSEID                                          " &
"                                                                                             " &
" LEFT JOIN WMWHSE4.CAGEIDDETAIL       CAGEIDDETAIL                                           " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE4.CAGEID             CAGEID                                                 " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                                               " &
"                                                                                             " &
"WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                     " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                                             " & 
"  Between '" + Parameters!DataLimiteDe.Value + "'                                            " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                               " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    WMSADMIN.DB_ALIAS               PLANTA,                                                  " &
"    ORDERS.ORDERKEY                 ENTREGA,                                                 " &
"    ORDERS.STATUS                   SIT,                                                     " &
"    ORDERSTATUSSETUP.DESCRIPTION    DESCR_SIT,                                               " &
"    nvl( ( select A.STATUS                                                                   " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), ORDERS.STATUS )                                              " &
"                                    ULT_EVENTO,                                              " &
"                                                                                             " &
"    nvl( ( select B.DESCRIPTION                                                              " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A,                      " &
"                  " + Parameters!Table.Value + ".ORDERSTATUSSETUP    B                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and B.CODE = A.STATUS                                                          " &
"              and rownum = 1 ), ( select B.DESCRIPTION                                       " &
"                                    from " + Parameters!Table.Value + ".ORDERSTATUSSETUP  B  " &
"                                   where B.CODE = ORDERS.STATUS ) )                          " &
"                                    DESCRICAO,                                               " &
"                                                                                             " &
"    nvl( ( select select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.ADDDATE,                       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE)                                         " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,          " & 
"                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"                              AT time zone 'America/Sao_Paulo') AS DATE) )                       " &
"                                    DT_ULT_EVENTO,                                           " &
"                                                                                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                                       " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                  
"                                    DT_WMS,                                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                 
"                                    PETK_DT_FECHAMENTO_GAIOLA,                               " &  
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_LIMITE,                                               " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_PROMETIDA,                                            " &
"    ORDERS.C_VAT                    MEGA_ROTA,                                               " &
"    znsls401.t$fovn$c               PEDV_ID_TRANSP,                                          " &
"    ORDERS.CARRIERNAME              TRASNPORTADORA                                           " &
"                                                                                             " &
"FROM       BAANDB.TZNSLS401301@pln01  znsls401                                               " &
"                                                                                             " &
"INNER JOIN WMWHSE5.ORDERS             ORDERS                                                 " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                             " &
" LEFT JOIN WMWHSE5.ORDERDETAIL        ORDERDETAIL                                            " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE5.ORDERSTATUSSETUP                                                          " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                             " &
"                                                                                             " &
"INNER JOIN WMSADMIN.PL_DB             WMSADMIN                                               " &
"        ON UPPER(WMSADMIN.DB_LOGID) = ORDERS.WHSEID                                          " &
"                                                                                             " &
" LEFT JOIN WMWHSE5.CAGEIDDETAIL       CAGEIDDETAIL                                           " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE5.CAGEID             CAGEID                                                 " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                                               " &
"                                                                                             " &
"WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                     " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                                             " & 
"  Between '" + Parameters!DataLimiteDe.Value + "'                                            " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                               " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    WMSADMIN.DB_ALIAS               PLANTA,                                                  " &
"    ORDERS.ORDERKEY                 ENTREGA,                                                 " &
"    ORDERS.STATUS                   SIT,                                                     " &
"    ORDERSTATUSSETUP.DESCRIPTION    DESCR_SIT,                                               " &
"    nvl( ( select A.STATUS                                                                   " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), ORDERS.STATUS )                                              " &
"                                    ULT_EVENTO,                                              " &
"                                                                                             " &
"    nvl( ( select B.DESCRIPTION                                                              " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A,                      " &
"                  " + Parameters!Table.Value + ".ORDERSTATUSSETUP    B                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and B.CODE = A.STATUS                                                          " &
"              and rownum = 1 ), ( select B.DESCRIPTION                                       " &
"                                    from " + Parameters!Table.Value + ".ORDERSTATUSSETUP  B  " &
"                                   where B.CODE = ORDERS.STATUS ) )                          " &
"                                    DESCRICAO,                                               " &
"                                                                                             " &
"    nvl( ( select select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.ADDDATE,                       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE)                                         " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,          " & 
"                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"                              AT time zone 'America/Sao_Paulo') AS DATE) )                       " &
"                                    DT_ULT_EVENTO,                                           " &
"                                                                                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                                       " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                  
"                                    DT_WMS,                                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                 
"                                    PETK_DT_FECHAMENTO_GAIOLA,                               " &  
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_LIMITE,                                               " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_PROMETIDA,                                            " &
"    ORDERS.C_VAT                    MEGA_ROTA,                                               " &
"    znsls401.t$fovn$c               PEDV_ID_TRANSP,                                          " &
"    ORDERS.CARRIERNAME              TRASNPORTADORA                                           " &
"                                                                                             " &
"FROM       BAANDB.TZNSLS401301@pln01  znsls401                                               " &
"                                                                                             " &
"INNER JOIN WMWHSE6.ORDERS             ORDERS                                                 " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                             " &
" LEFT JOIN WMWHSE6.ORDERDETAIL        ORDERDETAIL                                            " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE6.ORDERSTATUSSETUP                                                          " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                             " &
"                                                                                             " &
"INNER JOIN WMSADMIN.PL_DB             WMSADMIN                                               " &
"        ON UPPER(WMSADMIN.DB_LOGID) = ORDERS.WHSEID                                          " &
"                                                                                             " &
" LEFT JOIN WMWHSE6.CAGEIDDETAIL       CAGEIDDETAIL                                           " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE6.CAGEID             CAGEID                                                 " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                                               " &
"                                                                                             " &
"WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                     " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                                             " & 
"  Between '" + Parameters!DataLimiteDe.Value + "'                                            " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                               " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    WMSADMIN.DB_ALIAS               PLANTA,                                                  " &
"    ORDERS.ORDERKEY                 ENTREGA,                                                 " &
"    ORDERS.STATUS                   SIT,                                                     " &
"    ORDERSTATUSSETUP.DESCRIPTION    DESCR_SIT,                                               " &
"    nvl( ( select A.STATUS                                                                   " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), ORDERS.STATUS )                                              " &
"                                    ULT_EVENTO,                                              " &
"                                                                                             " &
"    nvl( ( select B.DESCRIPTION                                                              " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A,                      " &
"                  " + Parameters!Table.Value + ".ORDERSTATUSSETUP    B                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and B.CODE = A.STATUS                                                          " &
"              and rownum = 1 ), ( select B.DESCRIPTION                                       " &
"                                    from " + Parameters!Table.Value + ".ORDERSTATUSSETUP  B  " &
"                                   where B.CODE = ORDERS.STATUS ) )                          " &
"                                    DESCRICAO,                                               " &
"                                                                                             " &
"    nvl( ( select select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.ADDDATE,                       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE)                                         " &
"             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                       " &
"            where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                 where A1.ORDERKEY = A.ORDERKEY )                            " &
"              and A.ORDERKEY = ORDERS.ORDERKEY                                               " &
"              and rownum = 1 ), CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,          " & 
"                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"                              AT time zone 'America/Sao_Paulo') AS DATE) )                       " &
"                                    DT_ULT_EVENTO,                                           " &
"                                                                                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                                       " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                  
"                                    DT_WMS,                                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &                 
"                                    PETK_DT_FECHAMENTO_GAIOLA,                               " &  
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_LIMITE,                                               " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                             " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE)                                              " &        
"                                    DT_PROMETIDA,                                            " &
"    ORDERS.C_VAT                    MEGA_ROTA,                                               " &
"    znsls401.t$fovn$c               PEDV_ID_TRANSP,                                          " &
"    ORDERS.CARRIERNAME              TRASNPORTADORA                                           " &
"                                                                                             " &
"FROM       BAANDB.TZNSLS401301@pln01  znsls401                                               " &
"                                                                                             " &
"INNER JOIN WMWHSE7.ORDERS             ORDERS                                                 " &
"        ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                             " &
" LEFT JOIN WMWHSE7.ORDERDETAIL        ORDERDETAIL                                            " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE7.ORDERSTATUSSETUP                                                          " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                             " &
"                                                                                             " &
"INNER JOIN WMSADMIN.PL_DB             WMSADMIN                                               " &
"        ON UPPER(WMSADMIN.DB_LOGID) = ORDERS.WHSEID                                          " &
"                                                                                             " &
" LEFT JOIN WMWHSE7.CAGEIDDETAIL       CAGEIDDETAIL                                           " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                            " &
"                                                                                             " &
" LEFT JOIN WMWHSE7.CAGEID             CAGEID                                                 " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                                               " &
"                                                                                             " &
"WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,                     " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                                             " & 
"  Between '" + Parameters!DataLimiteDe.Value + "'                                            " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                               " &
"                                                                                             " &
"ORDER BY PLANTA                                                                              "