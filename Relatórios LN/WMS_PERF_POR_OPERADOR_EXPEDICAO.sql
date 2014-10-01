SELECT  
  DISTINCT
    ORDERS.WHSEID                                        ID_PLANTA,
    PL_DB.DB_ALIAS                                       DSC_PLANTA,
    ORDERS.ORDERKEY                                      PEDIDO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)           DATA,
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE), 'HH')    HORA,
    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,
    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,
    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,
    ORDERS.CARRIERCODE                                   ID_TRANSP,
    ORDERS.CARRIERNAME                                   TRANSP_NOME,
    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,
    CASE WHEN max(SKU.SUSR2) = 2 
           THEN 'PESADO' 
         ELSE   'LEVE' 
     END                                                 TP_TRANSP_ITEM 

FROM      WMWHSE5.ORDERS,
          WMSADMIN.PL_DB,
          WMWHSE5.ORDERDETAIL, 
          WMWHSE5.ORDERSTATUSHISTORY
   
LEFT JOIN WMWHSE5.taskmanageruser tu 
       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,

          WMWHSE5.SKU

WHERE ORDERS.STATUS > =  95
  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY
  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY
  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' ' 
  AND ORDERSTATUSHISTORY.STATUS = 95
  AND SKU.SKU = ORDERDETAIL.SKU
  
  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)) BETWEEN :DataDe
  AND :DataAte
  
GROUP BY ORDERS.WHSEID,       
         PL_DB.DB_ALIAS,                          
         ORDERS.ORDERKEY ,                                               
         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),          
         ORDERSTATUSHISTORY.ADDWHO,                     
         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                                  
         ORDERS.CARRIERCODE,                            
         ORDERS.CARRIERNAME,
         ORDERS.DISCHARGEPLACE
		 

"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      " + Parameters!Table.Value + ".ORDERS,                                   " &
"          WMSADMIN.PL_DB,                                                          " &
"          " + Parameters!Table.Value + ".ORDERDETAIL,                              " &
"          " + Parameters!Table.Value + ".ORDERSTATUSHISTORY                        " &
"                                                                                   " &
"LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu                        " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          " + Parameters!Table.Value + ".SKU                                       " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     "

QUERY COM UNION ***********************************************************************

"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE1.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE1.ORDERDETAIL,                                                     " &
"          WMWHSE1.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE1.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE1.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    min(ORDERSTATUSHISTORY.ADDDATE )                     DATA,                     " &
"    TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH')                 HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE2.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE2.ORDERDETAIL,                                                     " &
"          WMWHSE2.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE2.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE2.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE3.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE3.ORDERDETAIL,                                                     " &
"          WMWHSE3.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE3.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE3.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE4.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE4.ORDERDETAIL,                                                     " &
"          WMWHSE4.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE4.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE4.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE5.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE5.ORDERDETAIL,                                                     " &
"          WMWHSE5.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE5.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE5.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE6.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE6.ORDERDETAIL,                                                     " &
"          WMWHSE6.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE6.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE6.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE7.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE7.ORDERDETAIL,                                                     " &
"          WMWHSE7.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE7.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE7.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone sessiontimezone) AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"                                                                                   " &
" ORDER BY DSC_PLANTA                                                               "