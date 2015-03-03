SELECT                                                                       
  DISTINCT                                                                   
    taskdetail.whseid                           PLANTA,                      
    PL_DB.DB_ALIAS                              DSC_PLANTA,                  
    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE), 'DD')             
                                                DIA,                         
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE), 'HH24')         
                                                HORA,                        
    USERACTIVITY.USERID                          OPERADOR,                    
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                              
    taskdetail.wavekey                          PROGRAMA,                    
    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                     
    COUNT(taskdetail.sku)                       ITEM,                        
    LOC.LOGICALLOCATION                         ORDEM_COL,
    SUM(taskdetail.qty)                         PEÇAS,                      
    min(TASKDETAIL.ORDERKEY)                    PEDIDO_HOST                  

FROM       WMWHSE5.taskdetail            

INNER JOIN WMWHSE5.USERACTIVITY
        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY

 LEFT JOIN WMWHSE5.taskmanageruser tu 
        ON tu.userkey = USERACTIVITY.USERID
    
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)

INNER JOIN WMWHSE5.LOC
        ON LOC.LOC = taskdetail.FROMLOC

WHERE taskdetail.status = 9                                                  
  AND taskdetail.tasktype = 'PK'                                             
  AND PL_DB.ISACTIVE = 1                                                     
  AND PL_DB.DB_ENTERPRISE = 0                                                

-- AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
--     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--       AT time zone sessiontimezone) AS DATE)) 
--     Between :DataDe 
--         And :DataAte

GROUP BY taskdetail.whseid,                                                  
         PL_DB.DB_ALIAS,                                                     
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE), 'DD'),
         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE), 'HH24'), 
         USERACTIVITY.USERID,                                                  
         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ), 
         taskdetail.wavekey, 
         LOC.LOGICALLOCATION         
		 
ORDER BY 2


=IIF(Parameters!Table.Value <> "AAA",

"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    taskdetail.whseid                           PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                    " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                  " &
"                                                HORA,                    " &
"    PICKDETAIL.EDITWHO                          OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    taskdetail.wavekey                          PROGRAMA,                " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                 " &
"    COUNT(taskdetail.sku)                       ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(taskdetail.qty)                         PEÇAS,                   " &
"    min(PICKDETAIL.ORDERKEY)                    PEDIDO_HOST              " &
"                                                                         " &
"FROM       " + Parameters!Table.Value + ".taskdetail                     " &
"                                                                         " &
"INNER JOIN " + Parameters!Table.Value + ".PICKDETAIL                     " &
"        ON PICKDETAIL.PICKDETAILKEY = TASKDETAIL.PICKDETAILKEY           " &
"                                                                         " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu             " &
"        ON tu.userkey = PICKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)              " &
"                                                                         " &
"INNER JOIN " + Parameters!Table.Value + ".LOC                            " &
"        ON LOC.LOC = taskdetail.FROMLOC                                  " &
"                                                                         " &
"WHERE taskdetail.status = 9                                              " &
"  AND taskdetail.tasktype = 'PK'                                         " &
"  AND PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"       AT time zone sessiontimezone) AS DATE))                           " &
"     Between '" + Parameters!DataDe.Value + "'                           " &
"         And '" + Parameters!DataAte.Value + "'                          " &
"                                                                         " &
"GROUP BY taskdetail.whseid,                                              " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),           " &
"         PICKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         taskdetail.wavekey,                                             " &
"         LOC.LOGICALLOCATION                                             " &
"ORDER BY DSC_PLANTA                                                      "

,

"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    taskdetail.whseid                           PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                    " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                  " &
"                                                HORA,                    " &
"    PICKDETAIL.EDITWHO                          OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    taskdetail.wavekey                          PROGRAMA,                " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                 " &
"    COUNT(taskdetail.sku)                       ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(taskdetail.qty)                         PEÇAS,                   " &
"    min(PICKDETAIL.ORDERKEY)                    PEDIDO_HOST              " &
"                                                                         " &
"FROM       WMWHSE1.taskdetail                                            " &
"                                                                         " &
"INNER JOIN WMWHSE1.PICKDETAIL                                            " &
"        ON PICKDETAIL.PICKDETAILKEY = TASKDETAIL.PICKDETAILKEY           " &
"                                                                         " &
" LEFT JOIN WMWHSE1.taskmanageruser tu                                    " &
"        ON tu.userkey = PICKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)              " &
"                                                                         " &
"INNER JOIN WMWHSE1.LOC                                                   " &
"        ON LOC.LOC = taskdetail.FROMLOC                                  " &
"                                                                         " &
"WHERE taskdetail.status = 9                                              " &
"  AND taskdetail.tasktype = 'PK'                                         " &
"  AND PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"       AT time zone sessiontimezone) AS DATE))                           " &
"     Between '" + Parameters!DataDe.Value + "'                           " &
"         And '" + Parameters!DataAte.Value + "'                          " &
"                                                                         " &
"GROUP BY taskdetail.whseid,                                              " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),           " &
"         PICKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         taskdetail.wavekey,                                             " &
"         LOC.LOGICALLOCATION                                             " &
"		                                                                  " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    taskdetail.whseid                           PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                    " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                  " &
"                                                HORA,                    " &
"    PICKDETAIL.EDITWHO                          OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    taskdetail.wavekey                          PROGRAMA,                " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                 " &
"    COUNT(taskdetail.sku)                       ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(taskdetail.qty)                         PEÇAS,                   " &
"    min(PICKDETAIL.ORDERKEY)                    PEDIDO_HOST              " &
"                                                                         " &
"FROM       WMWHSE2.taskdetail                                            " &
"                                                                         " &
"INNER JOIN WMWHSE2.PICKDETAIL                                            " &
"        ON PICKDETAIL.PICKDETAILKEY = TASKDETAIL.PICKDETAILKEY           " &
"                                                                         " &
" LEFT JOIN WMWHSE2.taskmanageruser tu                                    " &
"        ON tu.userkey = PICKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)              " &
"                                                                         " &
"INNER JOIN WMWHSE2.LOC                                                   " &
"        ON LOC.LOC = taskdetail.FROMLOC                                  " &
"                                                                         " &
"WHERE taskdetail.status = 9                                              " &
"  AND taskdetail.tasktype = 'PK'                                         " &
"  AND PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"       AT time zone sessiontimezone) AS DATE))                           " &
"     Between '" + Parameters!DataDe.Value + "'                           " &
"         And '" + Parameters!DataAte.Value + "'                          " &
"                                                                         " &
"GROUP BY taskdetail.whseid,                                              " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),           " &
"         PICKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         taskdetail.wavekey,                                             " &
"         LOC.LOGICALLOCATION                                             " &
"		                                                                  " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    taskdetail.whseid                           PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                    " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                  " &
"                                                HORA,                    " &
"    PICKDETAIL.EDITWHO                          OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    taskdetail.wavekey                          PROGRAMA,                " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                 " &
"    COUNT(taskdetail.sku)                       ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(taskdetail.qty)                         PEÇAS,                   " &
"    min(PICKDETAIL.ORDERKEY)                    PEDIDO_HOST              " &
"                                                                         " &
"FROM       WMWHSE3.taskdetail                                            " &
"                                                                         " &
"INNER JOIN WMWHSE3.PICKDETAIL                                            " &
"        ON PICKDETAIL.PICKDETAILKEY = TASKDETAIL.PICKDETAILKEY           " &
"                                                                         " &
" LEFT JOIN WMWHSE3.taskmanageruser tu                                    " &
"        ON tu.userkey = PICKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)              " &
"                                                                         " &
"INNER JOIN WMWHSE3.LOC                                                   " &
"        ON LOC.LOC = taskdetail.FROMLOC                                  " &
"                                                                         " &
"WHERE taskdetail.status = 9                                              " &
"  AND taskdetail.tasktype = 'PK'                                         " &
"  AND PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"       AT time zone sessiontimezone) AS DATE))                           " &
"     Between '" + Parameters!DataDe.Value + "'                           " &
"         And '" + Parameters!DataAte.Value + "'                          " &
"                                                                         " &
"GROUP BY taskdetail.whseid,                                              " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),           " &
"         PICKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         taskdetail.wavekey,                                             " &
"         LOC.LOGICALLOCATION                                             " &
"		                                                                  " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    taskdetail.whseid                           PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                    " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                  " &
"                                                HORA,                    " &
"    PICKDETAIL.EDITWHO                          OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    taskdetail.wavekey                          PROGRAMA,                " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                 " &
"    COUNT(taskdetail.sku)                       ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(taskdetail.qty)                         PEÇAS,                   " &
"    min(PICKDETAIL.ORDERKEY)                    PEDIDO_HOST              " &
"                                                                         " &
"FROM       WMWHSE4.taskdetail                                            " &
"                                                                         " &
"INNER JOIN WMWHSE4.PICKDETAIL                                            " &
"        ON PICKDETAIL.PICKDETAILKEY = TASKDETAIL.PICKDETAILKEY           " &
"                                                                         " &
" LEFT JOIN WMWHSE4.taskmanageruser tu                                    " &
"        ON tu.userkey = PICKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)              " &
"                                                                         " &
"INNER JOIN WMWHSE4.LOC                                                   " &
"        ON LOC.LOC = taskdetail.FROMLOC                                  " &
"                                                                         " &
"WHERE taskdetail.status = 9                                              " &
"  AND taskdetail.tasktype = 'PK'                                         " &
"  AND PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"       AT time zone sessiontimezone) AS DATE))                           " &
"     Between '" + Parameters!DataDe.Value + "'                           " &
"         And '" + Parameters!DataAte.Value + "'                          " &
"                                                                         " &
"GROUP BY taskdetail.whseid,                                              " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),           " &
"         PICKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         taskdetail.wavekey,                                             " &
"         LOC.LOGICALLOCATION                                             " &
"		                                                                  " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    taskdetail.whseid                           PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                    " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                  " &
"                                                HORA,                    " &
"    PICKDETAIL.EDITWHO                          OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    taskdetail.wavekey                          PROGRAMA,                " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                 " &
"    COUNT(taskdetail.sku)                       ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(taskdetail.qty)                         PEÇAS,                   " &
"    min(PICKDETAIL.ORDERKEY)                    PEDIDO_HOST              " &
"                                                                         " &
"FROM       WMWHSE5.taskdetail                                            " &
"                                                                         " &
"INNER JOIN WMWHSE5.PICKDETAIL                                            " &
"        ON PICKDETAIL.PICKDETAILKEY = TASKDETAIL.PICKDETAILKEY           " &
"                                                                         " &
" LEFT JOIN WMWHSE5.taskmanageruser tu                                    " &
"        ON tu.userkey = PICKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)              " &
"                                                                         " &
"INNER JOIN WMWHSE5.LOC                                                   " &
"        ON LOC.LOC = taskdetail.FROMLOC                                  " &
"                                                                         " &
"WHERE taskdetail.status = 9                                              " &
"  AND taskdetail.tasktype = 'PK'                                         " &
"  AND PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"       AT time zone sessiontimezone) AS DATE))                           " &
"     Between '" + Parameters!DataDe.Value + "'                           " &
"         And '" + Parameters!DataAte.Value + "'                          " &
"                                                                         " &
"GROUP BY taskdetail.whseid,                                              " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),           " &
"         PICKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         taskdetail.wavekey,                                             " &
"         LOC.LOGICALLOCATION                                             " &
"		                                                                  " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    taskdetail.whseid                           PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                    " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                  " &
"                                                HORA,                    " &
"    PICKDETAIL.EDITWHO                          OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    taskdetail.wavekey                          PROGRAMA,                " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                 " &
"    COUNT(taskdetail.sku)                       ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(taskdetail.qty)                         PEÇAS,                   " &
"    min(PICKDETAIL.ORDERKEY)                    PEDIDO_HOST              " &
"                                                                         " &
"FROM       WMWHSE6.taskdetail                                            " &
"                                                                         " &
"INNER JOIN WMWHSE6.PICKDETAIL                                            " &
"        ON PICKDETAIL.PICKDETAILKEY = TASKDETAIL.PICKDETAILKEY           " &
"                                                                         " &
" LEFT JOIN WMWHSE6.taskmanageruser tu                                    " &
"        ON tu.userkey = PICKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)              " &
"                                                                         " &
"INNER JOIN WMWHSE6.LOC                                                   " &
"        ON LOC.LOC = taskdetail.FROMLOC                                  " &
"                                                                         " &
"WHERE taskdetail.status = 9                                              " &
"  AND taskdetail.tasktype = 'PK'                                         " &
"  AND PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"       AT time zone sessiontimezone) AS DATE))                           " &
"     Between '" + Parameters!DataDe.Value + "'                           " &
"         And '" + Parameters!DataAte.Value + "'                          " &
"                                                                         " &
"GROUP BY taskdetail.whseid,                                              " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),           " &
"         PICKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         taskdetail.wavekey,                                             " &
"         LOC.LOGICALLOCATION                                             " &
"		                                                                  " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    taskdetail.whseid                           PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                    " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                  " &
"                                                HORA,                    " &
"    PICKDETAIL.EDITWHO                          OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    taskdetail.wavekey                          PROGRAMA,                " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                 " &
"    COUNT(taskdetail.sku)                       ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(taskdetail.qty)                         PEÇAS,                   " &
"    min(PICKDETAIL.ORDERKEY)                    PEDIDO_HOST              " &
"                                                                         " &
"FROM       WMWHSE7.taskdetail                                            " &
"                                                                         " &
"INNER JOIN WMWHSE7.PICKDETAIL                                            " &
"        ON PICKDETAIL.PICKDETAILKEY = TASKDETAIL.PICKDETAILKEY           " &
"                                                                         " &
" LEFT JOIN WMWHSE7.taskmanageruser tu                                    " &
"        ON tu.userkey = PICKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)              " &
"                                                                         " &
"INNER JOIN WMWHSE7.LOC                                                   " &
"        ON LOC.LOC = taskdetail.FROMLOC                                  " &
"                                                                         " &
"WHERE taskdetail.status = 9                                              " &
"  AND taskdetail.tasktype = 'PK'                                         " &
"  AND PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"       AT time zone sessiontimezone) AS DATE))                           " &
"     Between '" + Parameters!DataDe.Value + "'                           " &
"         And '" + Parameters!DataAte.Value + "'                          " &
"                                                                         " &
"GROUP BY taskdetail.whseid,                                              " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),             " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),           " &
"         PICKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         taskdetail.wavekey,                                             " &
"         LOC.LOGICALLOCATION                                             " &
"		                                                                  " &
"                                                                         " &
"ORDER BY DSC_PLANTA, DIA                                                 "

)