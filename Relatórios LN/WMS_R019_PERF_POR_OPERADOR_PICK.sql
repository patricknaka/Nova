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
    USERACTIVITY.USERID                      OPERADOR,
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',') - 4 )    NOME_OP,
    loc.putawayzone                          GRUPO_CLASSE_LOCAL,
    count(taskdetail.sku)                    ITEM,    
    count(distinct taskdetail.fromloc)       LOCAL,
    count(distinct taskdetail.orderkey )     ORDEM_COL,
    sum(taskdetail.qty)                      PECAS
    
FROM       WMWHSE5.taskdetail

INNER JOIN WMWHSE5.USERACTIVITY
        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY
    
 LEFT JOIN WMWHSE5.taskmanageruser tu 
        ON tu.userkey = USERACTIVITY.USERID
    
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)
		
INNER JOIN WMWHSE5.loc 
        ON loc.loc = taskdetail.fromloc
		
WHERE taskdetail.status = 9 
  and taskdetail.tasktype = 'PK' 
  and PL_DB.ISACTIVE = 1
  and PL_DB.DB_ENTERPRISE = 0

--  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
--      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--        AT time zone 'America/Sao_Paulo') AS DATE)) 
--      Between :DataDe 
--          And :DataAte
    
GROUP BY taskdetail.whseid, 
         PL_DB.DB_ALIAS,
         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'), 
         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),
         USERACTIVITY.USERID,
         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ), 
         loc.putawayzone
    
ORDER BY DSC_PLANTA, DIA



=IIF(Parameters!Table.Value <> "AAA",

"SELECT                                                                    " &
"  DISTINCT                                                                " &
"    taskdetail.whseid                        PLANTA,                      " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                 " &
"                                             DIA,                         " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')               " &
"                                             HORA,                        " &
"    USERACTIVITY.USERID                      OPERADOR,                    " &
"    subStr( tu.usr_name,4,                                                " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                     " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,          " &
"    count(taskdetail.sku)                    ITEM,                        " &
"    count(distinct taskdetail.fromloc)       LOCAL,                       " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                   " &
"    sum(taskdetail.qty)                      PECAS                        " &
"                                                                          " &
"FROM       " + Parameters!Table.Value + ".taskdetail                      " &
"                                                                          " &
"INNER JOIN " + Parameters!Table.Value + ".USERACTIVITY                    " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY          " &
"                                                                          " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu              " &
"        ON tu.userkey = USERACTIVITY.USERID                               " &
"                                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                                 " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)               " &
"		                                                                   " &
"INNER JOIN " + Parameters!Table.Value + ".loc                             " &
"        ON loc.loc = taskdetail.fromloc                                   " &
"		                                                                   " &
"WHERE taskdetail.status = 9                                               " &
"  and taskdetail.tasktype = 'PK'                                          " &
"  and PL_DB.ISACTIVE = 1                                                  " &
"  and PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                       " &
"      Between '" + Parameters!DataDe.Value + "'                           " &
"          And '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY taskdetail.whseid,                                               " &
"         PL_DB.DB_ALIAS,                                                  " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),          " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,   " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),        " &
"         USERACTIVITY.USERID,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),            " &
"         loc.putawayzone                                                  " &
"                                                                          " &
"ORDER BY DSC_PLANTA, DIA                                                  "

,

"SELECT                                                                    " &
"  DISTINCT                                                                " &
"    taskdetail.whseid                        PLANTA,                      " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                 " &
"                                             DIA,                         " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')               " &
"                                             HORA,                        " &
"    USERACTIVITY.USERID                      OPERADOR,                    " &
"    subStr( tu.usr_name,4,                                                " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                     " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,          " &
"    count(taskdetail.sku)                    ITEM,                        " &
"    count(distinct taskdetail.fromloc)       LOCAL,                       " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                   " &
"    sum(taskdetail.qty)                      PECAS                        " &
"                                                                          " &
"FROM       WMWHSE1.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE1.USERACTIVITY                                           " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY          " &
"                                                                          " &
" LEFT JOIN WMWHSE1.taskmanageruser tu                                     " &
"        ON tu.userkey = USERACTIVITY.USERID                               " &
"                                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                                 " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)               " &
"		                                                                   " &
"INNER JOIN WMWHSE1.loc                                                    " &
"        ON loc.loc = taskdetail.fromloc                                   " &
"		                                                                   " &
"WHERE taskdetail.status = 9                                               " &
"  and taskdetail.tasktype = 'PK'                                          " &
"  and PL_DB.ISACTIVE = 1                                                  " &
"  and PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                       " &
"      Between '" + Parameters!DataDe.Value + "'                           " &
"          And '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY taskdetail.whseid,                                               " &
"         PL_DB.DB_ALIAS,                                                  " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),          " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,   " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),        " &
"         USERACTIVITY.USERID,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),            " &
"         loc.putawayzone                                                  " &
"                                                                          " &
"Union                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  DISTINCT                                                                " &
"    taskdetail.whseid                        PLANTA,                      " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                 " &
"                                             DIA,                         " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')               " &
"                                             HORA,                        " &
"    USERACTIVITY.USERID                      OPERADOR,                    " &
"    subStr( tu.usr_name,4,                                                " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                     " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,          " &
"    count(taskdetail.sku)                    ITEM,                        " &
"    count(distinct taskdetail.fromloc)       LOCAL,                       " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                   " &
"    sum(taskdetail.qty)                      PECAS                        " &
"                                                                          " &
"FROM       WMWHSE2.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE2.USERACTIVITY                                           " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY          " &
"                                                                          " &
" LEFT JOIN WMWHSE2.taskmanageruser tu                                     " &
"        ON tu.userkey = USERACTIVITY.USERID                               " &
"                                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                                 " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)               " &
"		                                                                   " &
"INNER JOIN WMWHSE2.loc                                                    " &
"        ON loc.loc = taskdetail.fromloc                                   " &
"		                                                                   " &
"WHERE taskdetail.status = 9                                               " &
"  and taskdetail.tasktype = 'PK'                                          " &
"  and PL_DB.ISACTIVE = 1                                                  " &
"  and PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                       " &
"      Between '" + Parameters!DataDe.Value + "'                           " &
"          And '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY taskdetail.whseid,                                               " &
"         PL_DB.DB_ALIAS,                                                  " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),          " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,   " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),        " &
"         USERACTIVITY.USERID,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),            " &
"         loc.putawayzone                                                  " &
"                                                                          " &
"Union                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  DISTINCT                                                                " &
"    taskdetail.whseid                        PLANTA,                      " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                 " &
"                                             DIA,                         " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')               " &
"                                             HORA,                        " &
"    USERACTIVITY.USERID                      OPERADOR,                    " &
"    subStr( tu.usr_name,4,                                                " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                     " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,          " &
"    count(taskdetail.sku)                    ITEM,                        " &
"    count(distinct taskdetail.fromloc)       LOCAL,                       " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                   " &
"    sum(taskdetail.qty)                      PECAS                        " &
"                                                                          " &
"FROM       WMWHSE3.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE3.USERACTIVITY                                           " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY          " &
"                                                                          " &
" LEFT JOIN WMWHSE3.taskmanageruser tu                                     " &
"        ON tu.userkey = USERACTIVITY.USERID                               " &
"                                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                                 " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)               " &
"		                                                                   " &
"INNER JOIN WMWHSE3.loc                                                    " &
"        ON loc.loc = taskdetail.fromloc                                   " &
"		                                                                   " &
"WHERE taskdetail.status = 9                                               " &
"  and taskdetail.tasktype = 'PK'                                          " &
"  and PL_DB.ISACTIVE = 1                                                  " &
"  and PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                       " &
"      Between '" + Parameters!DataDe.Value + "'                           " &
"          And '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY taskdetail.whseid,                                               " &
"         PL_DB.DB_ALIAS,                                                  " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),          " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,   " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),        " &
"         USERACTIVITY.USERID,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),            " &
"         loc.putawayzone                                                  " &
"                                                                          " &
"Union                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  DISTINCT                                                                " &
"    taskdetail.whseid                        PLANTA,                      " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                 " &
"                                             DIA,                         " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')               " &
"                                             HORA,                        " &
"    USERACTIVITY.USERID                      OPERADOR,                    " &
"    subStr( tu.usr_name,4,                                                " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                     " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,          " &
"    count(taskdetail.sku)                    ITEM,                        " &
"    count(distinct taskdetail.fromloc)       LOCAL,                       " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                   " &
"    sum(taskdetail.qty)                      PECAS                        " &
"                                                                          " &
"FROM       WMWHSE4.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE4.USERACTIVITY                                           " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY          " &
"                                                                          " &
" LEFT JOIN WMWHSE4.taskmanageruser tu                                     " &
"        ON tu.userkey = USERACTIVITY.USERID                               " &
"                                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                                 " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)               " &
"		                                                                   " &
"INNER JOIN WMWHSE4.loc                                                    " &
"        ON loc.loc = taskdetail.fromloc                                   " &
"		                                                                   " &
"WHERE taskdetail.status = 9                                               " &
"  and taskdetail.tasktype = 'PK'                                          " &
"  and PL_DB.ISACTIVE = 1                                                  " &
"  and PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                       " &
"      Between '" + Parameters!DataDe.Value + "'                           " &
"          And '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY taskdetail.whseid,                                               " &
"         PL_DB.DB_ALIAS,                                                  " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),          " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,   " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),        " &
"         USERACTIVITY.USERID,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),            " &
"         loc.putawayzone                                                  " &
"                                                                          " &
"Union                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  DISTINCT                                                                " &
"    taskdetail.whseid                        PLANTA,                      " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                 " &
"                                             DIA,                         " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')               " &
"                                             HORA,                        " &
"    USERACTIVITY.USERID                      OPERADOR,                    " &
"    subStr( tu.usr_name,4,                                                " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                     " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,          " &
"    count(taskdetail.sku)                    ITEM,                        " &
"    count(distinct taskdetail.fromloc)       LOCAL,                       " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                   " &
"    sum(taskdetail.qty)                      PECAS                        " &
"                                                                          " &
"FROM       WMWHSE5.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE5.USERACTIVITY                                           " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY          " &
"                                                                          " &
" LEFT JOIN WMWHSE5.taskmanageruser tu                                     " &
"        ON tu.userkey = USERACTIVITY.USERID                               " &
"                                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                                 " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)               " &
"		                                                                   " &
"INNER JOIN WMWHSE5.loc                                                    " &
"        ON loc.loc = taskdetail.fromloc                                   " &
"		                                                                   " &
"WHERE taskdetail.status = 9                                               " &
"  and taskdetail.tasktype = 'PK'                                          " &
"  and PL_DB.ISACTIVE = 1                                                  " &
"  and PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                       " &
"      Between '" + Parameters!DataDe.Value + "'                           " &
"          And '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY taskdetail.whseid,                                               " &
"         PL_DB.DB_ALIAS,                                                  " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),          " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,   " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),        " &
"         USERACTIVITY.USERID,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),            " &
"         loc.putawayzone                                                  " &
"                                                                          " &
"Union                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  DISTINCT                                                                " &
"    taskdetail.whseid                        PLANTA,                      " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                 " &
"                                             DIA,                         " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')               " &
"                                             HORA,                        " &
"    USERACTIVITY.USERID                      OPERADOR,                    " &
"    subStr( tu.usr_name,4,                                                " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                     " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,          " &
"    count(taskdetail.sku)                    ITEM,                        " &
"    count(distinct taskdetail.fromloc)       LOCAL,                       " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                   " &
"    sum(taskdetail.qty)                      PECAS                        " &
"                                                                          " &
"FROM       WMWHSE6.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE6.USERACTIVITY                                           " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY          " &
"                                                                          " &
" LEFT JOIN WMWHSE6.taskmanageruser tu                                     " &
"        ON tu.userkey = USERACTIVITY.USERID                               " &
"                                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                                 " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)               " &
"		                                                                   " &
"INNER JOIN WMWHSE6.loc                                                    " &
"        ON loc.loc = taskdetail.fromloc                                   " &
"		                                                                   " &
"WHERE taskdetail.status = 9                                               " &
"  and taskdetail.tasktype = 'PK'                                          " &
"  and PL_DB.ISACTIVE = 1                                                  " &
"  and PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                       " &
"      Between '" + Parameters!DataDe.Value + "'                           " &
"          And '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY taskdetail.whseid,                                               " &
"         PL_DB.DB_ALIAS,                                                  " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),          " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,   " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),        " &
"         USERACTIVITY.USERID,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),            " &
"         loc.putawayzone                                                  " &
"                                                                          " &
"Union                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  DISTINCT                                                                " &
"    taskdetail.whseid                        PLANTA,                      " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                 " &
"                                             DIA,                         " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')               " &
"                                             HORA,                        " &
"    USERACTIVITY.USERID                      OPERADOR,                    " &
"    subStr( tu.usr_name,4,                                                " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                     " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,          " &
"    count(taskdetail.sku)                    ITEM,                        " &
"    count(distinct taskdetail.fromloc)       LOCAL,                       " &
"    count(distinct taskdetail.orderkey )     ORDEM_COL,                   " &
"    sum(taskdetail.qty)                      PECAS                        " &
"                                                                          " &
"FROM       WMWHSE7.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE7.USERACTIVITY                                           " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY          " &
"                                                                          " &
" LEFT JOIN WMWHSE7.taskmanageruser tu                                     " &
"        ON tu.userkey = USERACTIVITY.USERID                               " &
"                                                                          " &
"INNER JOIN WMSADMIN.PL_DB                                                 " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)               " &
"		                                                                   " &
"INNER JOIN WMWHSE7.loc                                                    " &
"        ON loc.loc = taskdetail.fromloc                                   " &
"		                                                                   " &
"WHERE taskdetail.status = 9                                               " &
"  and taskdetail.tasktype = 'PK'                                          " &
"  and PL_DB.ISACTIVE = 1                                                  " &
"  and PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')        " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                       " &
"      Between '" + Parameters!DataDe.Value + "'                           " &
"          And '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY taskdetail.whseid,                                               " &
"         PL_DB.DB_ALIAS,                                                  " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,     " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),          " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,   " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),        " &
"         USERACTIVITY.USERID,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),            " &
"         loc.putawayzone                                                  " &
"                                                                          " &
"ORDER BY DSC_PLANTA, DIA                                                  "

)