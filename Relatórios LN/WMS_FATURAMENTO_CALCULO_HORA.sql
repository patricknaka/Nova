SELECT 
  DISTINCT
    ORDERS.WHSEID                                  ID_FILIAL,
    WMSADMIN.PL_DB.DB_ALIAS                        FILIAL_NOME,
    ORDERSTATUSHISTORY.ADDWHO                      ID_USUARIO,
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',')-4 )            NOME_USUARIO,
    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')       
                                                   DATA,
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')    
                                                   HORA,
    ORDERS.LANE                                    SERIE,
    count(distinct ORDERS.INVOICENUMBER)           QT_NOTA,
    count(distinct ORDERS.ORDERKEY)                QT_PED,
    count(ORDERDETAIL.SKU)                         QT_ITEM,
    sum(ORDERDETAIL.SHIPPEDQTY)                    QT_PECAS,
    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' 
         ELSE 'LEVE' 
     END                                           TP_TRANSP_ITEM 
  
FROM      WMWHSE4.ORDERS, 
          WMWHSE4.ORDERDETAIL, 
          WMWHSE4.ORDERSTATUSHISTORY
    
LEFT JOIN WMWHSE4.taskmanageruser tu 
       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,
    
          WMWHSE4.SKU, 
          WMSADMIN.PL_DB

WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY 
  AND ORDERSTATUSHISTORY.STATUS = 95 
  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY 
  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER 
  AND SKU.SKU = ORDERDETAIL.SKU 
  AND UPPER(WMSADMIN.PL_DB.db_logid) = ORDERS.WHSEID
  AND ORDERDETAIL.SHIPPEDQTY > 0
  AND ORDERS.INVOICENUMBER != 0 
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataUltEventoDe AND :DataUltEventoAte
  
GROUP BY  PL_DB.DB_ALIAS,
          ORDERS.WHSEID, 
          WMSADMIN.PL_DB.DB_ALIAS, 
          ORDERSTATUSHISTORY.ADDWHO,
          subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ), 
          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'DD') ,
          TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),
          ORDERS.LANE,
          SKU.SUSR2
          
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    ORDERS.WHSEID                                  ID_FILIAL,                                " &
"    WMSADMIN.PL_DB.DB_ALIAS                        FILIAL_NOME,                              " &
"    ORDERSTATUSHISTORY.ADDWHO                      ID_USUARIO,                               " &
"    subStr( tu.usr_name,4,                                                                   " &
"            inStr(tu.usr_name, ',')-4 )            NOME_USUARIO,                             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                                        " &       
"                                                   DATA,                                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                       " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                                  " &    
"                                                   HORA,                                     " &
"    ORDERS.LANE                                    SERIE,                                    " &
"    count(distinct ORDERS.INVOICENUMBER)           QT_NOTA,                                  " &
"    count(distinct ORDERS.ORDERKEY)                QT_PED,                                   " &
"    count(ORDERDETAIL.SKU)                         QT_ITEM,                                  " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                    QT_PECAS,                                 " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                                                    " &
"         ELSE 'LEVE'                                                                         " &
"     END                                           TP_TRANSP_ITEM                            " &
"                                                                                             " &
"FROM      " + Parameters!Table.Value + ".ORDERS,                                             " &
"          " + Parameters!Table.Value + ".ORDERDETAIL,                                        " &
"          " + Parameters!Table.Value + ".ORDERSTATUSHISTORY                                  " &
"                                                                                             " &
"LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu                                  " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                            " &
"                                                                                             " &
"          " + Parameters!Table.Value + ".SKU,                                                " &
"          WMSADMIN.PL_DB                                                                     " &
"                                                                                             " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                 " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                                         " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                     " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                       " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                              " &
"  AND UPPER(WMSADMIN.PL_DB.db_logid) = ORDERS.WHSEID                                         " &
"  AND ORDERDETAIL.SHIPPEDQTY > 0                                                             " &
"  AND ORDERS.INVOICENUMBER != 0                                                              " &
"                                                                                             " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                                " &
"		AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataUltEventoDe AND :DataUltEventoAte    " &
"                                                                                             " &
"GROUP BY PL_DB.DB_ALIAS,                                                                     " &
"         ORDERS.WHSEID,                                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                            " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                          " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                                 " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,               " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD') ,                                " &
"          TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,             " & 
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"                  AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),                           " &
"         ORDERS.LANE,                                                                        " &
"         SKU.SUSR2                                                                           "

-- Query com UNION ******************************************************************************

"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    ORDERS.WHSEID                                  ID_FILIAL,                                " &
"    WMSADMIN.PL_DB.DB_ALIAS                        FILIAL_NOME,                              " &
"    ORDERSTATUSHISTORY.ADDWHO                      ID_USUARIO,                               " &
"    subStr( tu.usr_name,4,                                                                   " &
"            inStr(tu.usr_name, ',')-4 )            NOME_USUARIO,                             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                                        " &       
"                                                   DATA,                                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                       " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                                  " &    
"                                                   HORA,                                     " &
"    ORDERS.LANE                                    SERIE,                                    " &
"    count(distinct ORDERS.INVOICENUMBER)           QT_NOTA,                                  " &
"    count(distinct ORDERS.ORDERKEY)                QT_PED,                                   " &
"    count(ORDERDETAIL.SKU)                         QT_ITEM,                                  " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                    QT_PECAS,                                 " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                                                    " &
"         ELSE 'LEVE'                                                                         " &
"     END                                           TP_TRANSP_ITEM                            " &
"                                                                                             " &
"FROM      WMWHSE1.ORDERS,                                                                    " &
"          WMWHSE1.ORDERDETAIL,                                                               " &
"          WMWHSE1.ORDERSTATUSHISTORY                                                         " &
"                                                                                             " &
"LEFT JOIN WMWHSE1.taskmanageruser tu                                                         " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                            " &
"                                                                                             " &
"          WMWHSE1.SKU,                                                                       " &
"          WMSADMIN.PL_DB                                                                     " &
"                                                                                             " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                 " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                                         " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                     " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                       " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                              " &
"  AND UPPER(WMSADMIN.PL_DB.db_logid) = ORDERS.WHSEID                                         " &
"  AND ORDERDETAIL.SHIPPEDQTY > 0                                                             " &
"  AND ORDERS.INVOICENUMBER != 0                                                              " &
"                                                                                             " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                                " &
"		AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataUltEventoDe AND :DataUltEventoAte    " &
"                                                                                             " &
"GROUP BY PL_DB.DB_ALIAS,                                                                     " &
"         ORDERS.WHSEID,                                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                            " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                          " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                                 " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,               " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD') ,                                " &
"          TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,             " & 
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"                  AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),                           " &
"         ORDERS.LANE,                                                                        " &
"         SKU.SUSR2                                                                           " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    ORDERS.WHSEID                                  ID_FILIAL,                                " &
"    WMSADMIN.PL_DB.DB_ALIAS                        FILIAL_NOME,                              " &
"    ORDERSTATUSHISTORY.ADDWHO                      ID_USUARIO,                               " &
"    subStr( tu.usr_name,4,                                                                   " &
"            inStr(tu.usr_name, ',')-4 )            NOME_USUARIO,                             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                                        " &       
"                                                   DATA,                                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                       " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                                  " &    
"                                                   HORA,                                     " &
"    ORDERS.LANE                                    SERIE,                                    " &
"    count(distinct ORDERS.INVOICENUMBER)           QT_NOTA,                                  " &
"    count(distinct ORDERS.ORDERKEY)                QT_PED,                                   " &
"    count(ORDERDETAIL.SKU)                         QT_ITEM,                                  " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                    QT_PECAS,                                 " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                                                    " &
"         ELSE 'LEVE'                                                                         " &
"     END                                           TP_TRANSP_ITEM                            " &
"                                                                                             " &
"FROM      WMWHSE2.ORDERS,                                                                    " &
"          WMWHSE2.ORDERDETAIL,                                                               " &
"          WMWHSE2.ORDERSTATUSHISTORY                                                         " &
"                                                                                             " &
"LEFT JOIN WMWHSE2.taskmanageruser tu                                                         " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                            " &
"                                                                                             " &
"          WMWHSE2.SKU,                                                                       " &
"          WMSADMIN.PL_DB                                                                     " &
"                                                                                             " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                 " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                                         " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                     " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                       " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                              " &
"  AND UPPER(WMSADMIN.PL_DB.db_logid) = ORDERS.WHSEID                                         " &
"  AND ORDERDETAIL.SHIPPEDQTY > 0                                                             " &
"  AND ORDERS.INVOICENUMBER != 0                                                              " &
"                                                                                             " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                                " &
"		AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataUltEventoDe AND :DataUltEventoAte    " &
"                                                                                             " &
"GROUP BY PL_DB.DB_ALIAS,                                                                     " &
"         ORDERS.WHSEID,                                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                            " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                          " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                                 " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,               " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD') ,                                " &
"          TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,             " & 
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"                  AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),                           " &
"         ORDERS.LANE,                                                                        " &
"         SKU.SUSR2                                                                           " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    ORDERS.WHSEID                                  ID_FILIAL,                                " &
"    WMSADMIN.PL_DB.DB_ALIAS                        FILIAL_NOME,                              " &
"    ORDERSTATUSHISTORY.ADDWHO                      ID_USUARIO,                               " &
"    subStr( tu.usr_name,4,                                                                   " &
"            inStr(tu.usr_name, ',')-4 )            NOME_USUARIO,                             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                                        " &       
"                                                   DATA,                                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                       " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                                  " &    
"                                                   HORA,                                     " &
"    ORDERS.LANE                                    SERIE,                                    " &
"    count(distinct ORDERS.INVOICENUMBER)           QT_NOTA,                                  " &
"    count(distinct ORDERS.ORDERKEY)                QT_PED,                                   " &
"    count(ORDERDETAIL.SKU)                         QT_ITEM,                                  " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                    QT_PECAS,                                 " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                                                    " &
"         ELSE 'LEVE'                                                                         " &
"     END                                           TP_TRANSP_ITEM                            " &
"                                                                                             " &
"FROM      WMWHSE3.ORDERS,                                                                    " &
"          WMWHSE3.ORDERDETAIL,                                                               " &
"          WMWHSE3.ORDERSTATUSHISTORY                                                         " &
"                                                                                             " &
"LEFT JOIN WMWHSE3.taskmanageruser tu                                                         " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                            " &
"                                                                                             " &
"          WMWHSE3.SKU,                                                                       " &
"          WMSADMIN.PL_DB                                                                     " &
"                                                                                             " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                 " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                                         " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                     " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                       " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                              " &
"  AND UPPER(WMSADMIN.PL_DB.db_logid) = ORDERS.WHSEID                                         " &
"  AND ORDERDETAIL.SHIPPEDQTY > 0                                                             " &
"  AND ORDERS.INVOICENUMBER != 0                                                              " &
"                                                                                             " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                                " &
"		AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataUltEventoDe AND :DataUltEventoAte    " &
"                                                                                             " &
"GROUP BY PL_DB.DB_ALIAS,                                                                     " &
"         ORDERS.WHSEID,                                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                            " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                          " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                                 " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,               " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD') ,                                " &
"          TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,             " & 
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"                  AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),                           " &
"         ORDERS.LANE,                                                                        " &
"         SKU.SUSR2                                                                           " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    ORDERS.WHSEID                                  ID_FILIAL,                                " &
"    WMSADMIN.PL_DB.DB_ALIAS                        FILIAL_NOME,                              " &
"    ORDERSTATUSHISTORY.ADDWHO                      ID_USUARIO,                               " &
"    subStr( tu.usr_name,4,                                                                   " &
"            inStr(tu.usr_name, ',')-4 )            NOME_USUARIO,                             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                                        " &       
"                                                   DATA,                                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                       " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                                  " &    
"                                                   HORA,                                     " &
"    ORDERS.LANE                                    SERIE,                                    " &
"    count(distinct ORDERS.INVOICENUMBER)           QT_NOTA,                                  " &
"    count(distinct ORDERS.ORDERKEY)                QT_PED,                                   " &
"    count(ORDERDETAIL.SKU)                         QT_ITEM,                                  " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                    QT_PECAS,                                 " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                                                    " &
"         ELSE 'LEVE'                                                                         " &
"     END                                           TP_TRANSP_ITEM                            " &
"                                                                                             " &
"FROM      WMWHSE4.ORDERS,                                                                    " &
"          WMWHSE4.ORDERDETAIL,                                                               " &
"          WMWHSE4.ORDERSTATUSHISTORY                                                         " &
"                                                                                             " &
"LEFT JOIN WMWHSE4.taskmanageruser tu                                                         " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                            " &
"                                                                                             " &
"          WMWHSE4.SKU,                                                                       " &
"          WMSADMIN.PL_DB                                                                     " &
"                                                                                             " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                 " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                                         " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                     " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                       " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                              " &
"  AND UPPER(WMSADMIN.PL_DB.db_logid) = ORDERS.WHSEID                                         " &
"  AND ORDERDETAIL.SHIPPEDQTY > 0                                                             " &
"  AND ORDERS.INVOICENUMBER != 0                                                              " &
"                                                                                             " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                                " &
"		AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataUltEventoDe AND :DataUltEventoAte    " &
"                                                                                             " &
"GROUP BY PL_DB.DB_ALIAS,                                                                     " &
"         ORDERS.WHSEID,                                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                            " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                          " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                                 " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,               " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD') ,                                " &
"          TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,             " & 
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"                  AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),                           " &
"         ORDERS.LANE,                                                                        " &
"         SKU.SUSR2                                                                           " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    ORDERS.WHSEID                                  ID_FILIAL,                                " &
"    WMSADMIN.PL_DB.DB_ALIAS                        FILIAL_NOME,                              " &
"    ORDERSTATUSHISTORY.ADDWHO                      ID_USUARIO,                               " &
"    subStr( tu.usr_name,4,                                                                   " &
"            inStr(tu.usr_name, ',')-4 )            NOME_USUARIO,                             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                                        " &       
"                                                   DATA,                                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                       " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                                  " &    
"                                                   HORA,                                     " &
"    ORDERS.LANE                                    SERIE,                                    " &
"    count(distinct ORDERS.INVOICENUMBER)           QT_NOTA,                                  " &
"    count(distinct ORDERS.ORDERKEY)                QT_PED,                                   " &
"    count(ORDERDETAIL.SKU)                         QT_ITEM,                                  " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                    QT_PECAS,                                 " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                                                    " &
"         ELSE 'LEVE'                                                                         " &
"     END                                           TP_TRANSP_ITEM                            " &
"                                                                                             " &
"FROM      WMWHSE5.ORDERS,                                                                    " &
"          WMWHSE5.ORDERDETAIL,                                                               " &
"          WMWHSE5.ORDERSTATUSHISTORY                                                         " &
"                                                                                             " &
"LEFT JOIN WMWHSE5.taskmanageruser tu                                                         " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                            " &
"                                                                                             " &
"          WMWHSE5.SKU,                                                                       " &
"          WMSADMIN.PL_DB                                                                     " &
"                                                                                             " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                 " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                                         " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                     " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                       " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                              " &
"  AND UPPER(WMSADMIN.PL_DB.db_logid) = ORDERS.WHSEID                                         " &
"  AND ORDERDETAIL.SHIPPEDQTY > 0                                                             " &
"  AND ORDERS.INVOICENUMBER != 0                                                              " &
"                                                                                             " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                                " &
"		AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataUltEventoDe AND :DataUltEventoAte    " &
"                                                                                             " &
"GROUP BY PL_DB.DB_ALIAS,                                                                     " &
"         ORDERS.WHSEID,                                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                            " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                          " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                                 " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,               " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD') ,                                " &
"          TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,             " & 
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"                  AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),                           " &
"         ORDERS.LANE,                                                                        " &
"         SKU.SUSR2                                                                           " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    ORDERS.WHSEID                                  ID_FILIAL,                                " &
"    WMSADMIN.PL_DB.DB_ALIAS                        FILIAL_NOME,                              " &
"    ORDERSTATUSHISTORY.ADDWHO                      ID_USUARIO,                               " &
"    subStr( tu.usr_name,4,                                                                   " &
"            inStr(tu.usr_name, ',')-4 )            NOME_USUARIO,                             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                                        " &       
"                                                   DATA,                                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                       " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                                  " &    
"                                                   HORA,                                     " &
"    ORDERS.LANE                                    SERIE,                                    " &
"    count(distinct ORDERS.INVOICENUMBER)           QT_NOTA,                                  " &
"    count(distinct ORDERS.ORDERKEY)                QT_PED,                                   " &
"    count(ORDERDETAIL.SKU)                         QT_ITEM,                                  " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                    QT_PECAS,                                 " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                                                    " &
"         ELSE 'LEVE'                                                                         " &
"     END                                           TP_TRANSP_ITEM                            " &
"                                                                                             " &
"FROM      WMWHSE6.ORDERS,                                                                    " &
"          WMWHSE6.ORDERDETAIL,                                                               " &
"          WMWHSE6.ORDERSTATUSHISTORY                                                         " &
"                                                                                             " &
"LEFT JOIN WMWHSE6.taskmanageruser tu                                                         " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                            " &
"                                                                                             " &
"          WMWHSE6.SKU,                                                                       " &
"          WMSADMIN.PL_DB                                                                     " &
"                                                                                             " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                 " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                                         " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                     " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                       " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                              " &
"  AND UPPER(WMSADMIN.PL_DB.db_logid) = ORDERS.WHSEID                                         " &
"  AND ORDERDETAIL.SHIPPEDQTY > 0                                                             " &
"  AND ORDERS.INVOICENUMBER != 0                                                              " &
"                                                                                             " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                                " &
"		AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataUltEventoDe AND :DataUltEventoAte    " &
"                                                                                             " &
"GROUP BY PL_DB.DB_ALIAS,                                                                     " &
"         ORDERS.WHSEID,                                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                            " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                          " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                                 " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,               " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD') ,                                " &
"          TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,             " & 
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"                  AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),                           " &
"         ORDERS.LANE,                                                                        " &
"         SKU.SUSR2                                                                           " &
"                                                                                             " &
"Union                                                                                        " &
"                                                                                             " &
"SELECT                                                                                       " &
"  DISTINCT                                                                                   " &
"    ORDERS.WHSEID                                  ID_FILIAL,                                " &
"    WMSADMIN.PL_DB.DB_ALIAS                        FILIAL_NOME,                              " &
"    ORDERSTATUSHISTORY.ADDWHO                      ID_USUARIO,                               " &
"    subStr( tu.usr_name,4,                                                                   " &
"            inStr(tu.usr_name, ',')-4 )            NOME_USUARIO,                             " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                           " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                                        " &       
"                                                   DATA,                                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                       " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                                  " &    
"                                                   HORA,                                     " &
"    ORDERS.LANE                                    SERIE,                                    " &
"    count(distinct ORDERS.INVOICENUMBER)           QT_NOTA,                                  " &
"    count(distinct ORDERS.ORDERKEY)                QT_PED,                                   " &
"    count(ORDERDETAIL.SKU)                         QT_ITEM,                                  " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                    QT_PECAS,                                 " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                                                    " &
"         ELSE 'LEVE'                                                                         " &
"     END                                           TP_TRANSP_ITEM                            " &
"                                                                                             " &
"FROM      WMWHSE7.ORDERS,                                                                    " &
"          WMWHSE7.ORDERDETAIL,                                                               " &
"          WMWHSE7.ORDERSTATUSHISTORY                                                         " &
"                                                                                             " &
"LEFT JOIN WMWHSE7.taskmanageruser tu                                                         " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                            " &
"                                                                                             " &
"          WMWHSE7.SKU,                                                                       " &
"          WMSADMIN.PL_DB                                                                     " &
"                                                                                             " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                                 " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                                         " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                     " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                       " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                              " &
"  AND UPPER(WMSADMIN.PL_DB.db_logid) = ORDERS.WHSEID                                         " &
"  AND ORDERDETAIL.SHIPPEDQTY > 0                                                             " &
"  AND ORDERS.INVOICENUMBER != 0                                                              " &
"                                                                                             " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,                   " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                                " &
"		AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataUltEventoDe AND :DataUltEventoAte    " &
"                                                                                             " &
"GROUP BY PL_DB.DB_ALIAS,                                                                     " &
"         ORDERS.WHSEID,                                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                            " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                          " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                                 " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,               " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                     " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD') ,                                " &
"          TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,             " & 
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"                  AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),                           " &
"         ORDERS.LANE,                                                                        " &
"         SKU.SUSR2                                                                           " &
"                                                                                             " &
"order by FILIAL_NOME                                                                         "