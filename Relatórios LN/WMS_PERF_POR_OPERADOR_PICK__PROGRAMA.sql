SELECT  DISTINCT                                                                   
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
    taskdetail.addwho                           OPERADOR,                    
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',')-4 )         NOME_OP,                              
    taskdetail.wavekey                          PROGRAMA,                    
    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                     
    COUNT(taskdetail.sku)                       ITEM,                        
    LOC.LOGICALLOCATION                         ORDEM_COL,
    SUM(taskdetail.qty)                         PEÇAS,                       

    ( select min(a.orderkey)                                                 
        from WMWHSE4.taskdetail a                     
       where taskdetail.whseid  = a.whseid                                   
         and TRUNC(taskdetail.endtime, 'DD') = TRUNC(a.endtime, 'DD')        
         and TO_CHAR(taskdetail.endtime, 'HH24') = TO_CHAR(a.endtime, 'HH24')    
         and taskdetail.addwho  = a.addwho )    PEDIDO_HOST                  

FROM      WMWHSE4.taskdetail                      

LEFT JOIN WMWHSE4.taskmanageruser tu 
       ON tu.userkey = TASKDETAIL.EDITWHO,
    
          WMSADMIN.PL_DB,                                                        
          WMWHSE4.LOC

WHERE taskdetail.status = 9                                                  
  AND taskdetail.tasktype = 'PK'                                             
  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                       
  AND PL_DB.ISACTIVE = 1                                                     
  AND PL_DB.DB_ENTERPRISE = 0                                                
  AND LOC.LOC = taskdetail.FROMLOC

  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)) Between :DataDe 
  AND :DataAte

GROUP BY taskdetail.whseid,                                                  
         PL_DB.DB_ALIAS,                                                     
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE), 'DD'),                                    
         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE), 'HH24'),                                  
         taskdetail.addwho,                                                  
         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ), 
         taskdetail.wavekey, 
         LOC.LOGICALLOCATION              
ORDER BY 2

"SELECT                                                                           " &
"  DISTINCT                                                                       " &
"    taskdetail.whseid                           PLANTA,                          " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                      " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                 " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                            " &             
"                                                DIA,                             " &                         
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                          " &         
"                                                HORA,                            " &
"    taskdetail.addwho                           OPERADOR,                        " &
"    subStr( tu.usr_name,4,                                                       " &
"            inStr(tu.usr_name, ',')-4 )         NOME_OP,                         " &
"    taskdetail.wavekey                          PROGRAMA,                        " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                         " &
"    COUNT(taskdetail.sku)                       ITEM,                            " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                       " &
"    SUM(taskdetail.qty)                         PEÇAS,                           " &
"                                                                                 " &
"    ( select min(a.orderkey)                                                     " &
"        from " + Parameters!Table.Value + ".taskdetail a                         " &
"       where taskdetail.whseid  = a.whseid                                       " &
"         and TRUNC(taskdetail.endtime, 'DD') = TRUNC(a.endtime, 'DD')            " &
"         and TO_CHAR(taskdetail.endtime, 'HH24') = TO_CHAR(a.endtime, 'HH24')    " &
"         and taskdetail.addwho  = a.addwho )    PEDIDO_HOST                      " &
"                                                                                 " &
"FROM      " + Parameters!Table.Value + ".taskdetail                              " &
"                                                                                 " &
"LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu                      " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                       " &
"                                                                                 " &
"          WMSADMIN.PL_DB,                                                        " &
"          " + Parameters!Table.Value + ".LOC                                     " &"                                                                                 " &
"WHERE taskdetail.status = 9                                                      " &
"  AND taskdetail.tasktype = 'PK'                                                 " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                           " &
"  AND PL_DB.ISACTIVE = 1                                                         " &
"  AND PL_DB.DB_ENTERPRISE = 0                                                    " &
"  AND LOC.LOC = taskdetail.FROMLOC                                               " &
"                                                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE))                                  " & 
"  Between '" + Parameters!DataDe.Value + "'                                      " &
"  AND '" + Parameters!DataAte.Value + "'                                         " &
"                                                                                 " &
"GROUP BY taskdetail.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                     " &                                    
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),                   " &
"         taskdetail.addwho,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                     " &
"         taskdetail.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                                     " &
"ORDER BY 2                                                                       "

-- Query com UNION ******************************************************************

"SELECT                                                                           " &
"  DISTINCT                                                                       " &
"    taskdetail.whseid                           PLANTA,                          " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                      " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                 " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                            " &             
"                                                DIA,                             " &                         
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                          " &         
"                                                HORA,                            " &
"    taskdetail.addwho                           OPERADOR,                        " &
"    subStr( tu.usr_name,4,                                                       " &
"            inStr(tu.usr_name, ',')-4 )         NOME_OP,                         " &     
"    taskdetail.wavekey                          PROGRAMA,                        " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                         " &
"    COUNT(taskdetail.sku)                       ITEM,                            " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                       " &
"    SUM(taskdetail.qty)                         PEÇAS,                           " &
"                                                                                 " &
"    ( select min(a.orderkey)                                                     " &
"        from WMWHSE1.taskdetail a                                                " &
"       where taskdetail.whseid  = a.whseid                                       " &
"         and TRUNC(taskdetail.endtime, 'DD') = TRUNC(a.endtime, 'DD')            " &
"         and TO_CHAR(taskdetail.endtime, 'HH24') = TO_CHAR(a.endtime, 'HH24')    " &
"         and taskdetail.addwho  = a.addwho )    PEDIDO_HOST                      " &
"                                                                                 " &
"FROM      WMWHSE1.taskdetail                                                     " &
"                                                                                 " &
"LEFT JOIN WMWHSE1.taskmanageruser tu                                             " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                       " &
"                                                                                 " &
"          WMSADMIN.PL_DB,                                                        " &
"          WMWHSE1.LOC                                                            " &
"                                                                                 " &
"WHERE taskdetail.status = 9                                                      " &
"  AND taskdetail.tasktype = 'PK'                                                 " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                           " &
"  AND PL_DB.ISACTIVE = 1                                                         " &
"  AND PL_DB.DB_ENTERPRISE = 0                                                    " &
"  AND LOC.LOC = taskdetail.FROMLOC                                               " &
"                                                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE))                                  " & 
"  Between '" + Parameters!DataDe.Value + "'                                      " &
"  AND '" + Parameters!DataAte.Value + "'                                         " &
"                                                                                 " &
"GROUP BY taskdetail.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                     " &                                    
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),                   " &
"         taskdetail.addwho,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                     " &
"         taskdetail.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                                     " &
"                                                                                 " &
"Union                                                                            " &
"                                                                                 " &
"SELECT                                                                           " &
"  DISTINCT                                                                       " &
"    taskdetail.whseid                           PLANTA,                          " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                      " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                 " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                            " &             
"                                                DIA,                             " &                         
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                          " &         
"                                                HORA,                            " &
"    taskdetail.addwho                           OPERADOR,                        " &
"    subStr( tu.usr_name,4,                                                       " &
"            inStr(tu.usr_name, ',')-4 )         NOME_OP,                         " &     
"    taskdetail.wavekey                          PROGRAMA,                        " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                         " &
"    COUNT(taskdetail.sku)                       ITEM,                            " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                       " &
"    SUM(taskdetail.qty)                         PEÇAS,                           " &
"                                                                                 " &
"    ( select min(a.orderkey)                                                     " &
"        from WMWHSE2.taskdetail a                                                " &
"       where taskdetail.whseid  = a.whseid                                       " &
"         and TRUNC(taskdetail.endtime, 'DD') = TRUNC(a.endtime, 'DD')            " &
"         and TO_CHAR(taskdetail.endtime, 'HH24') = TO_CHAR(a.endtime, 'HH24')    " &
"         and taskdetail.addwho  = a.addwho )    PEDIDO_HOST                      " &
"                                                                                 " &
"FROM      WMWHSE2.taskdetail                                                     " &
"                                                                                 " &
"LEFT JOIN WMWHSE2.taskmanageruser tu                                             " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                       " &
"                                                                                 " &
"          WMSADMIN.PL_DB,                                                        " &
"          WMWHSE2.LOC                                                            " &
"                                                                                 " &
"WHERE taskdetail.status = 9                                                      " &
"  AND taskdetail.tasktype = 'PK'                                                 " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                           " &
"  AND PL_DB.ISACTIVE = 1                                                         " &
"  AND PL_DB.DB_ENTERPRISE = 0                                                    " &
"  AND LOC.LOC = taskdetail.FROMLOC                                               " &
"                                                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE))                                  " & 
"  Between '" + Parameters!DataDe.Value + "'                                      " &
"  AND '" + Parameters!DataAte.Value + "'                                         " &
"                                                                                 " &
"GROUP BY taskdetail.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                     " &                                    
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),                   " &
"         taskdetail.addwho,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                     " &
"         taskdetail.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                                     " &
"                                                                                 " &
"Union                                                                            " &
"                                                                                 " &
"SELECT                                                                           " &
"  DISTINCT                                                                       " &
"    taskdetail.whseid                           PLANTA,                          " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                      " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                 " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                            " &             
"                                                DIA,                             " &                         
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                          " &         
"                                                HORA,                            " &
"    taskdetail.addwho                           OPERADOR,                        " &
"    subStr( tu.usr_name,4,                                                       " &
"            inStr(tu.usr_name, ',')-4 )         NOME_OP,                         " &     
"    taskdetail.wavekey                          PROGRAMA,                        " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                         " &
"    COUNT(taskdetail.sku)                       ITEM,                            " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                       " &
"    SUM(taskdetail.qty)                         PEÇAS,                           " &
"                                                                                 " &
"    ( select min(a.orderkey)                                                     " &
"        from WMWHSE3.taskdetail a                                                " &
"       where taskdetail.whseid  = a.whseid                                       " &
"         and TRUNC(taskdetail.endtime, 'DD') = TRUNC(a.endtime, 'DD')            " &
"         and TO_CHAR(taskdetail.endtime, 'HH24') = TO_CHAR(a.endtime, 'HH24')    " &
"         and taskdetail.addwho  = a.addwho )    PEDIDO_HOST                      " &
"                                                                                 " &
"FROM      WMWHSE3.taskdetail                                                     " &
"                                                                                 " &
"LEFT JOIN WMWHSE3.taskmanageruser tu                                             " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                       " &
"                                                                                 " &
"          WMSADMIN.PL_DB,                                                        " &
"          WMWHSE3.LOC                                                            " &
"                                                                                 " &
"WHERE taskdetail.status = 9                                                      " &
"  AND taskdetail.tasktype = 'PK'                                                 " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                           " &
"  AND PL_DB.ISACTIVE = 1                                                         " &
"  AND PL_DB.DB_ENTERPRISE = 0                                                    " &
"  AND LOC.LOC = taskdetail.FROMLOC                                               " &
"                                                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE))                                  " & 
"  Between '" + Parameters!DataDe.Value + "'                                      " &
"  AND '" + Parameters!DataAte.Value + "'                                         " &
"                                                                                 " &
"GROUP BY taskdetail.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                     " &                                    
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),                   " &
"         taskdetail.addwho,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                     " &
"         taskdetail.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                                     " &
"                                                                                 " &
"Union                                                                            " &
"                                                                                 " &
"SELECT                                                                           " &
"  DISTINCT                                                                       " &
"    taskdetail.whseid                           PLANTA,                          " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                      " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                 " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                            " &             
"                                                DIA,                             " &                         
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                          " &         
"                                                HORA,                            " &
"    taskdetail.addwho                           OPERADOR,                        " &
"    subStr( tu.usr_name,4,                                                       " &
"            inStr(tu.usr_name, ',')-4 )         NOME_OP,                         " &     
"    taskdetail.wavekey                          PROGRAMA,                        " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                         " &
"    COUNT(taskdetail.sku)                       ITEM,                            " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                       " &
"    SUM(taskdetail.qty)                         PEÇAS,                           " &
"                                                                                 " &
"    ( select min(a.orderkey)                                                     " &
"        from WMWHSE4.taskdetail a                                                " &
"       where taskdetail.whseid  = a.whseid                                       " &
"         and TRUNC(taskdetail.endtime, 'DD') = TRUNC(a.endtime, 'DD')            " &
"         and TO_CHAR(taskdetail.endtime, 'HH24') = TO_CHAR(a.endtime, 'HH24')    " &
"         and taskdetail.addwho  = a.addwho )    PEDIDO_HOST                      " &
"                                                                                 " &
"FROM      WMWHSE4.taskdetail                                                     " &
"                                                                                 " &
"LEFT JOIN WMWHSE4.taskmanageruser tu                                             " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                       " &
"                                                                                 " &
"          WMSADMIN.PL_DB,                                                        " &
"          WMWHSE4.LOC                                                            " &
"                                                                                 " &
"WHERE taskdetail.status = 9                                                      " &
"  AND taskdetail.tasktype = 'PK'                                                 " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                           " &
"  AND PL_DB.ISACTIVE = 1                                                         " &
"  AND PL_DB.DB_ENTERPRISE = 0                                                    " &
"  AND LOC.LOC = taskdetail.FROMLOC                                               " &
"                                                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE))                                  " & 
"  Between '" + Parameters!DataDe.Value + "'                                      " &
"  AND '" + Parameters!DataAte.Value + "'                                         " &
"                                                                                 " &
"GROUP BY taskdetail.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                     " &                                    
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),                   " &
"         taskdetail.addwho,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                     " &
"         taskdetail.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                                     " &
"                                                                                 " &
"Union                                                                            " &
"                                                                                 " &
"SELECT                                                                           " &
"  DISTINCT                                                                       " &
"    taskdetail.whseid                           PLANTA,                          " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                      " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                 " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                            " &             
"                                                DIA,                             " &                         
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                          " &         
"                                                HORA,                            " &
"    taskdetail.addwho                           OPERADOR,                        " &
"    subStr( tu.usr_name,4,                                                       " &
"            inStr(tu.usr_name, ',')-4 )         NOME_OP,                         " &     
"    taskdetail.wavekey                          PROGRAMA,                        " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                         " &
"    COUNT(taskdetail.sku)                       ITEM,                            " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                       " &
"    SUM(taskdetail.qty)                         PEÇAS,                           " &
"                                                                                 " &
"    ( select min(a.orderkey)                                                     " &
"        from WMWHSE5.taskdetail a                                                " &
"       where taskdetail.whseid  = a.whseid                                       " &
"         and TRUNC(taskdetail.endtime, 'DD') = TRUNC(a.endtime, 'DD')            " &
"         and TO_CHAR(taskdetail.endtime, 'HH24') = TO_CHAR(a.endtime, 'HH24')    " &
"         and taskdetail.addwho  = a.addwho )    PEDIDO_HOST                      " &
"                                                                                 " &
"FROM      WMWHSE5.taskdetail                                                     " &
"                                                                                 " &
"LEFT JOIN WMWHSE5.taskmanageruser tu                                             " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                       " &
"                                                                                 " &
"          WMSADMIN.PL_DB,                                                        " &
"          WMWHSE5.LOC                                                            " &
"                                                                                 " &
"WHERE taskdetail.status = 9                                                      " &
"  AND taskdetail.tasktype = 'PK'                                                 " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                           " &
"  AND PL_DB.ISACTIVE = 1                                                         " &
"  AND PL_DB.DB_ENTERPRISE = 0                                                    " &
"  AND LOC.LOC = taskdetail.FROMLOC                                               " &
"                                                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE))                                  " & 
"  Between '" + Parameters!DataDe.Value + "'                                      " &
"  AND '" + Parameters!DataAte.Value + "'                                         " &
"                                                                                 " &
"GROUP BY taskdetail.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                     " &                                    
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),                   " &
"         taskdetail.addwho,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                     " &
"         taskdetail.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                                     " &
"                                                                                 " &
"Union                                                                            " &
"                                                                                 " &
"SELECT                                                                           " &
"  DISTINCT                                                                       " &
"    taskdetail.whseid                           PLANTA,                          " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                      " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                 " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'DD')                            " &             
"                                                DIA,                             " &                         
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE), 'HH24')                          " &         
"                                                HORA,                            " &
"    taskdetail.addwho                           OPERADOR,                        " &
"    subStr( tu.usr_name,4,                                                       " &
"            inStr(tu.usr_name, ',')-4 )         NOME_OP,                         " &     
"    taskdetail.wavekey                          PROGRAMA,                        " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                         " &
"    COUNT(taskdetail.sku)                       ITEM,                            " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                       " &
"    SUM(taskdetail.qty)                         PEÇAS,                           " &
"                                                                                 " &
"    ( select min(a.orderkey)                                                     " &
"        from WMWHSE6.taskdetail a                                                " &
"       where taskdetail.whseid  = a.whseid                                       " &
"         and TRUNC(taskdetail.endtime, 'DD') = TRUNC(a.endtime, 'DD')            " &
"         and TO_CHAR(taskdetail.endtime, 'HH24') = TO_CHAR(a.endtime, 'HH24')    " &
"         and taskdetail.addwho  = a.addwho )    PEDIDO_HOST                      " &
"                                                                                 " &
"FROM      WMWHSE6.taskdetail                                                     " &
"                                                                                 " &
"LEFT JOIN WMWHSE6.taskmanageruser tu                                             " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                       " &
"                                                                                 " &
"          WMSADMIN.PL_DB,                                                        " &
"          WMWHSE6.LOC                                                            " &
"                                                                                 " &
"WHERE taskdetail.status = 9                                                      " &
"  AND taskdetail.tasktype = 'PK'                                                 " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                           " &
"  AND PL_DB.ISACTIVE = 1                                                         " &
"  AND PL_DB.DB_ENTERPRISE = 0                                                    " &
"  AND LOC.LOC = taskdetail.FROMLOC                                               " &
"                                                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')               " &
"        AT time zone sessiontimezone) AS DATE))                                  " & 
"  Between '" + Parameters!DataDe.Value + "'                                      " &
"  AND '" + Parameters!DataAte.Value + "'                                         " &
"                                                                                 " &
"GROUP BY taskdetail.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                         " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'DD'),                     " &                                    
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),                   " &
"         taskdetail.addwho,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                     " &
"         taskdetail.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                                     " &
"                                                                                 " &
"ORDER BY 2                                                                       "
