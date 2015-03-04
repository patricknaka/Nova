SELECT  
  DISTINCT
    taskdetail.whseid                        PLANTA,
    PL_DB.DB_ALIAS                           DSC_PLANTA,
    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')          
                                             DIA,
    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')      
                                             HORA,
    taskdetail.addwho                        OPERADOR,
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',')-4 )      NOME_OP,
    loc.putawayzone                          GRUPO_CLASSE_LOCAL,
    count(taskdetail.sku)                    ITEM,    
    count(distinct taskdetail.fromloc)       LOCAL,
    count(distinct taskdetail.orderkey )     ORDEM_COL,
    sum(taskdetail.qty)                      PECAS
    
FROM      WMWHSE4.taskdetail
    
LEFT JOIN WMWHSE4.taskmanageruser tu 
       ON tu.userkey = TASKDETAIL.EDITWHO,
    
          WMSADMIN.PL_DB,
          WMWHSE4.loc 
    
WHERE taskdetail.status = 9 
  and taskdetail.tasktype = 'PK' 
  and UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)
  and PL_DB.ISACTIVE = 1
  and PL_DB.DB_ENTERPRISE = 0
  and loc.loc = taskdetail.fromloc

  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)) between :DataDe and :DataAte
    
GROUP BY taskdetail.whseid, 
         PL_DB.DB_ALIAS,
         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'), 
         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),
         taskdetail.addwho,
         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ), 
         loc.putawayzone
    
ORDER BY 2

*************************************************************************************

"SELECT                                                                      " &
"  DISTINCT                                                                  " &
"    taskdetail.whseid                        PLANTA,                        " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                    " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                       " &
"                                             DIA,                           " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                     " &
"                                             HORA,                          " &
"    taskdetail.addwho                        OPERADOR,                      " &
"    subStr( tu.usr_name,4,                                                  " &
"            inStr(tu.usr_name, ',')-4 )      NOME_OP,                       " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,            " &
"    count(taskdetail.sku)                    ITEM,                          " &
"    count(distinct taskdetail.fromloc)       LOCAL,                         " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                     " &
"    sum(taskdetail.qty)                      PECAS                          " &
"                                                                            " &
"FROM      " + Parameters!Table.Value + ".taskdetail                         " &
"                                                                            " &
"LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu                 " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                  " &
"                                                                            " &
"          WMSADMIN.PL_DB,                                                   " &
"          " + Parameters!Table.Value + ".loc                                " &
"                                                                            " &
"WHERE taskdetail.status = 9                                                 " &
"  and taskdetail.tasktype = 'PK'                                            " &
"  and UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                      " &
"  and PL_DB.ISACTIVE = 1                                                    " &
"  and PL_DB.DB_ENTERPRISE = 0                                               " &
"  and loc.loc = taskdetail.fromloc                                          " &
"                                                                            " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                              " &
"  between '" + Parameters!DataDe.Value + "'   " &                           " &
"  and '" + Parameters!DataAte.Value + "'                                    " &
"                                                                            " &
"GROUP BY taskdetail.whseid,                                                 " &
"         PL_DB.DB_ALIAS,                                                    " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),                " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),              " &
"         taskdetail.addwho,                                                 " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                " &
"         loc.putawayzone                                                    " &
"                                                                            " &
"ORDER BY 2                                                                  "

-- QUERY COM UNION *************************************************************

"SELECT                                                                      " &
"  DISTINCT                                                                  " &
"    taskdetail.whseid                        PLANTA,                        " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                    " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                       " &
"                                             DIA,                           " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                     " &
"                                             HORA,                          " &
"    taskdetail.addwho                        OPERADOR,                      " &
"    subStr( tu.usr_name,4,                                                  " &
"            inStr(tu.usr_name, ',')-4 )      NOME_OP,                       " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,            " &
"    count(taskdetail.sku)                    ITEM,                          " &
"    count(distinct taskdetail.fromloc)       LOCAL,                         " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                     " &
"    sum(taskdetail.qty)                      PECAS                          " &
"                                                                            " &
"FROM      WMWHSE1.taskdetail                                                " &
"                                                                            " &
"LEFT JOIN WMWHSE1.taskmanageruser tu                                        " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                  " &
"                                                                            " &
"          WMSADMIN.PL_DB,                                                   " &
"          WMWHSE1.loc                                                       " &
"                                                                            " &
"WHERE taskdetail.status = 9                                                 " &
"  and taskdetail.tasktype = 'PK'                                            " &
"  and UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                      " &
"  and PL_DB.ISACTIVE = 1                                                    " &
"  and PL_DB.DB_ENTERPRISE = 0                                               " &
"  and loc.loc = taskdetail.fromloc                                          " &
"                                                                            " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                              " &
"  between '" + Parameters!DataDe.Value + "'   " &                           " &
"  and '" + Parameters!DataAte.Value + "'                                    " &
"                                                                            " &
"GROUP BY taskdetail.whseid,                                                 " &
"         PL_DB.DB_ALIAS,                                                    " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),                " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),              " &
"         taskdetail.addwho,                                                 " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                " &
"         loc.putawayzone                                                    " &
"                                                                            " &
"Union                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  DISTINCT                                                                  " &
"    taskdetail.whseid                        PLANTA,                        " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                    " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                       " &
"                                             DIA,                           " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                     " &
"                                             HORA,                          " &
"    taskdetail.addwho                        OPERADOR,                      " &
"    subStr( tu.usr_name,4,                                                  " &
"            inStr(tu.usr_name, ',')-4 )      NOME_OP,                       " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,            " &
"    count(taskdetail.sku)                    ITEM,                          " &
"    count(distinct taskdetail.fromloc)       LOCAL,                         " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                     " &
"    sum(taskdetail.qty)                      PECAS                          " &
"                                                                            " &
"FROM      WMWHSE2.taskdetail                                                " &
"                                                                            " &
"LEFT JOIN WMWHSE2.taskmanageruser tu                                        " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                  " &
"                                                                            " &
"          WMSADMIN.PL_DB,                                                   " &
"          WMWHSE2.loc                                                       " &
"                                                                            " &
"WHERE taskdetail.status = 9                                                 " &
"  and taskdetail.tasktype = 'PK'                                            " &
"  and UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                      " &
"  and PL_DB.ISACTIVE = 1                                                    " &
"  and PL_DB.DB_ENTERPRISE = 0                                               " &
"  and loc.loc = taskdetail.fromloc                                          " &
"                                                                            " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                              " &
"  between '" + Parameters!DataDe.Value + "'   " &                           " &
"  and '" + Parameters!DataAte.Value + "'                                    " &
"                                                                            " &
"GROUP BY taskdetail.whseid,                                                 " &
"         PL_DB.DB_ALIAS,                                                    " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),                " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),              " &
"         taskdetail.addwho,                                                 " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                " &
"         loc.putawayzone                                                    " &
"                                                                            " &
"Union                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  DISTINCT                                                                  " &
"    taskdetail.whseid                        PLANTA,                        " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                    " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                       " &
"                                             DIA,                           " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                     " &
"                                             HORA,                          " &
"    taskdetail.addwho                        OPERADOR,                      " &
"    subStr( tu.usr_name,4,                                                  " &
"            inStr(tu.usr_name, ',')-4 )      NOME_OP,                       " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,            " &
"    count(taskdetail.sku)                    ITEM,                          " &
"    count(distinct taskdetail.fromloc)       LOCAL,                         " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                     " &
"    sum(taskdetail.qty)                      PECAS                          " &
"                                                                            " &
"FROM      WMWHSE3.taskdetail                                                " &
"                                                                            " &
"LEFT JOIN WMWHSE3.taskmanageruser tu                                        " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                  " &
"                                                                            " &
"          WMSADMIN.PL_DB,                                                   " &
"          WMWHSE3.loc                                                       " &
"                                                                            " &
"WHERE taskdetail.status = 9                                                 " &
"  and taskdetail.tasktype = 'PK'                                            " &
"  and UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                      " &
"  and PL_DB.ISACTIVE = 1                                                    " &
"  and PL_DB.DB_ENTERPRISE = 0                                               " &
"  and loc.loc = taskdetail.fromloc                                          " &
"                                                                            " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                              " &
"  between '" + Parameters!DataDe.Value + "'   " &                           " &
"  and '" + Parameters!DataAte.Value + "'                                    " &
"                                                                            " &
"GROUP BY taskdetail.whseid,                                                 " &
"         PL_DB.DB_ALIAS,                                                    " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),                " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),              " &
"         taskdetail.addwho,                                                 " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                " &
"         loc.putawayzone                                                    " &
"                                                                            " &
"Union                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  DISTINCT                                                                  " &
"    taskdetail.whseid                        PLANTA,                        " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                    " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                       " &
"                                             DIA,                           " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                     " &
"                                             HORA,                          " &
"    taskdetail.addwho                        OPERADOR,                      " &
"    subStr( tu.usr_name,4,                                                  " &
"            inStr(tu.usr_name, ',')-4 )      NOME_OP,                       " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,            " &
"    count(taskdetail.sku)                    ITEM,                          " &
"    count(distinct taskdetail.fromloc)       LOCAL,                         " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                     " &
"    sum(taskdetail.qty)                      PECAS                          " &
"                                                                            " &
"FROM      WMWHSE4.taskdetail                                                " &
"                                                                            " &
"LEFT JOIN WMWHSE4.taskmanageruser tu                                        " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                  " &
"                                                                            " &
"          WMSADMIN.PL_DB,                                                   " &
"          WMWHSE4.loc                                                       " &
"                                                                            " &
"WHERE taskdetail.status = 9                                                 " &
"  and taskdetail.tasktype = 'PK'                                            " &
"  and UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                      " &
"  and PL_DB.ISACTIVE = 1                                                    " &
"  and PL_DB.DB_ENTERPRISE = 0                                               " &
"  and loc.loc = taskdetail.fromloc                                          " &
"                                                                            " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                              " &
"  between '" + Parameters!DataDe.Value + "'   " &                           " &
"  and '" + Parameters!DataAte.Value + "'                                    " &
"                                                                            " &
"GROUP BY taskdetail.whseid,                                                 " &
"         PL_DB.DB_ALIAS,                                                    " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),                " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),              " &
"         taskdetail.addwho,                                                 " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                " &
"         loc.putawayzone                                                    " &
"                                                                            " &
"Union                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  DISTINCT                                                                  " &
"    taskdetail.whseid                        PLANTA,                        " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                    " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                       " &
"                                             DIA,                           " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                     " &
"                                             HORA,                          " &
"    taskdetail.addwho                        OPERADOR,                      " &
"    subStr( tu.usr_name,4,                                                  " &
"            inStr(tu.usr_name, ',')-4 )      NOME_OP,                       " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,            " &
"    count(taskdetail.sku)                    ITEM,                          " &
"    count(distinct taskdetail.fromloc)       LOCAL,                         " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                     " &
"    sum(taskdetail.qty)                      PECAS                          " &
"                                                                            " &
"FROM      WMWHSE5.taskdetail                                                " &
"                                                                            " &
"LEFT JOIN WMWHSE5.taskmanageruser tu                                        " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                  " &
"                                                                            " &
"          WMSADMIN.PL_DB,                                                   " &
"          WMWHSE5.loc                                                       " &
"                                                                            " &
"WHERE taskdetail.status = 9                                                 " &
"  and taskdetail.tasktype = 'PK'                                            " &
"  and UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                      " &
"  and PL_DB.ISACTIVE = 1                                                    " &
"  and PL_DB.DB_ENTERPRISE = 0                                               " &
"  and loc.loc = taskdetail.fromloc                                          " &
"                                                                            " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                              " &
"  between '" + Parameters!DataDe.Value + "'   " &                           " &
"  and '" + Parameters!DataAte.Value + "'                                    " &
"                                                                            " &
"GROUP BY taskdetail.whseid,                                                 " &
"         PL_DB.DB_ALIAS,                                                    " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),                " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),              " &
"         taskdetail.addwho,                                                 " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                " &
"         loc.putawayzone                                                    " &
"                                                                            " &
"Union                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  DISTINCT                                                                  " &
"    taskdetail.whseid                        PLANTA,                        " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                    " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                       " &
"                                             DIA,                           " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                     " &
"                                             HORA,                          " &
"    taskdetail.addwho                        OPERADOR,                      " &
"    subStr( tu.usr_name,4,                                                  " &
"            inStr(tu.usr_name, ',')-4 )      NOME_OP,                       " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,            " &
"    count(taskdetail.sku)                    ITEM,                          " &
"    count(distinct taskdetail.fromloc)       LOCAL,                         " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                     " &
"    sum(taskdetail.qty)                      PECAS                          " &
"                                                                            " &
"FROM      WMWHSE6.taskdetail                                                " &
"                                                                            " &
"LEFT JOIN WMWHSE6.taskmanageruser tu                                        " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                  " &
"                                                                            " &
"          WMSADMIN.PL_DB,                                                   " &
"          WMWHSE6.loc                                                       " &
"                                                                            " &
"WHERE taskdetail.status = 9                                                 " &
"  and taskdetail.tasktype = 'PK'                                            " &
"  and UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                      " &
"  and PL_DB.ISACTIVE = 1                                                    " &
"  and PL_DB.DB_ENTERPRISE = 0                                               " &
"  and loc.loc = taskdetail.fromloc                                          " &
"                                                                            " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                              " &
"  between '" + Parameters!DataDe.Value + "'   " &                           " &
"  and '" + Parameters!DataAte.Value + "'                                    " &
"                                                                            " &
"GROUP BY taskdetail.whseid,                                                 " &
"         PL_DB.DB_ALIAS,                                                    " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),                " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),              " &
"         taskdetail.addwho,                                                 " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                " &
"         loc.putawayzone                                                    " &
"                                                                            " &
"Union                                                                       " &
"                                                                            " &
"SELECT                                                                      " &
"  DISTINCT                                                                  " &
"    taskdetail.whseid                        PLANTA,                        " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                    " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                       " &
"                                             DIA,                           " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                     " &
"                                             HORA,                          " &
"    taskdetail.addwho                        OPERADOR,                      " &
"    subStr( tu.usr_name,4,                                                  " &
"            inStr(tu.usr_name, ',')-4 )      NOME_OP,                       " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,            " &
"    count(taskdetail.sku)                    ITEM,                          " &
"    count(distinct taskdetail.fromloc)       LOCAL,                         " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                     " &
"    sum(taskdetail.qty)                      PECAS                          " &
"                                                                            " &
"FROM      WMWHSE7.taskdetail                                                " &
"                                                                            " &
"LEFT JOIN WMWHSE7.taskmanageruser tu                                        " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                  " &
"                                                                            " &
"          WMSADMIN.PL_DB,                                                   " &
"          WMWHSE7.loc                                                       " &
"                                                                            " &
"WHERE taskdetail.status = 9                                                 " &
"  and taskdetail.tasktype = 'PK'                                            " &
"  and UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                      " &
"  and PL_DB.ISACTIVE = 1                                                    " &
"  and PL_DB.DB_ENTERPRISE = 0                                               " &
"  and loc.loc = taskdetail.fromloc                                          " &
"                                                                            " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                              " &
"  between '" + Parameters!DataDe.Value + "'   " &                           " &
"  and '" + Parameters!DataAte.Value + "'                                    " &
"                                                                            " &
"GROUP BY taskdetail.whseid,                                                 " &
"         PL_DB.DB_ALIAS,                                                    " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,       " & 
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),                " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),              " &
"         taskdetail.addwho,                                                 " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                " &
"         loc.putawayzone                                                    " &
"                                                                            " &
"ORDER BY 2                                                                  "