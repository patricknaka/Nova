=IIF(Parameters!Table.Value <> "AAA", 

"SELECT                                                                    " &
"  taskdetail.whseid             PLANTA,                                   " &
"  PL_DB.DB_ALIAS                DSC_PLANTA,                               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'DD')                       " &
"                                DATA_COL,                                 " &
"  OS.SCHEDULEDSHIPDATE          DATA_LIM,                                 " &
"  (select a.t$entr$c ENTREGA                                              " &
"     from baandb.tznsls004301@pln01 a                                     " &
"    where a.t$orno$c = os.referencedocument                               " &
"      and rownum=1)             ENTREGA,                                  " &
"  OS.REFERENCEDOCUMENT          ORDEM_LN,                                 " &
"  OS.ORDERKEY                   ORDEM_WMS,                                " &
"  WD.WAVEKEY                    ONDA,                                     " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,                " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_INICIO,                                " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_FIM,                                   " &
"  taskdetail.addwho             OPERADOR,                                 " &
"  subStr( tu.usr_name, 4,                                                 " &
"          inStr(tu.usr_name, ',') -4 )                                    " &
"                                NOME_OP,                                  " &
"  taskdetail.sku                ITEM,                                     " &
"  sk.descr                      DESCR_ITEM,                               " &
"  SUM(taskdetail.qty)           QUANT                                     " &
"                                                                          " &
"FROM       " + Parameters!Table.Value + ".taskdetail                      " &
"                                                                          " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERS OS                       " &
"        ON OS.ORDERKEY = taskdetail.ORDERKEY                              " &
"                                                                          " &
"INNER JOIN " + Parameters!Table.Value + ".SKU SK                          " &
"        ON SK.SKU = taskdetail.SKU                                        " &
"                                                                          " &
"INNER JOIN (select max(b.WAVEKEY) WAVEKEY,                                " &
"                       b.ORDERKEY                                         " &
"                  from " + Parameters!Table.Value + ".WAVEDETAIL b        " &
"              group by b.ORDERKEY) WD                                     " &
"        ON WD.ORDERKEY = OS.ORDERKEY                                      " &
"                                                                          " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu              " &
"        ON tu.userkey = TASKDETAIL.EDITWHO,                               " &
"                                                                          " &
"           WMSADMIN.PL_DB                                                 " &
"                                                                          " &
"WHERE taskdetail.status = 9                                               " &
"  AND taskdetail.tasktype = 'PK'                                          " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                    " &
"  AND PL_DB.ISACTIVE = 1                                                  " &
"  AND PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"          AT time zone sessiontimezone) AS DATE))                         " &
"  between '" + Parameters!DataDe.Value + "'                               " &
"      and '" + Parameters!DataAte.Value + "'                              " &
"                                                                          " &
"GROUP BY  taskdetail.whseid,                                              " &
"          PL_DB.DB_ALIAS,                                                 " &
"          OS.SCHEDULEDSHIPDATE,                                           " &
"          OS.REFERENCEDOCUMENT,                                           " &
"          OS.ORDERKEY,                                                    " &
"          WD.WAVEKEY,                                                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,        " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE),                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone sessiontimezone) AS DATE),                      " &
"          taskdetail.addwho,                                              " &
"          subStr( tu.usr_name,4,                                          " &
"                  inStr(tu.usr_name, ',')-4 ),                            " &
"          taskdetail.sku,                                                 " &
"          sk.descr                                                        " &
"                                                                          " &
"ORDER BY 2, DATA_COL                                                                " 

,                                                                          

"SELECT                                                                    " &
"  taskdetail.whseid             PLANTA,                                   " &
"  PL_DB.DB_ALIAS                DSC_PLANTA,                               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'DD')                       " &
"                                DATA_COL,                                 " &
"  OS.SCHEDULEDSHIPDATE          DATA_LIM,                                 " &
"  (select a.t$entr$c ENTREGA                                              " &
"     from baandb.tznsls004301@pln01 a                                     " &
"    where a.t$orno$c = os.referencedocument                               " &
"      and rownum=1)             ENTREGA,                                  " &
"  OS.REFERENCEDOCUMENT          ORDEM_LN,                                 " &
"  OS.ORDERKEY                   ORDEM_WMS,                                " &
"  WD.WAVEKEY                    ONDA,                                     " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,                " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_INICIO,                                " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_FIM,                                   " &
"  taskdetail.addwho             OPERADOR,                                 " &
"  subStr( tu.usr_name, 4,                                                 " &
"          inStr(tu.usr_name, ',') -4 )                                    " &
"                                NOME_OP,                                  " &
"  taskdetail.sku                ITEM,                                     " &
"  sk.descr                      DESCR_ITEM,                               " &
"  SUM(taskdetail.qty)           QUANT                                     " &
"                                                                          " &
"FROM       WMWHSE1.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE1.ORDERS OS                                              " &
"        ON OS.ORDERKEY = taskdetail.ORDERKEY                              " &
"                                                                          " &
"INNER JOIN WMWHSE1.SKU SK                                                 " &
"        ON SK.SKU = taskdetail.SKU                                        " &
"                                                                          " &
"INNER JOIN (select max(b.WAVEKEY) WAVEKEY,                                " &
"                       b.ORDERKEY                                         " &
"                  from WMWHSE1.WAVEDETAIL b                               " &
"              group by b.ORDERKEY) WD                                     " &
"        ON WD.ORDERKEY = OS.ORDERKEY                                      " &
"                                                                          " &
" LEFT JOIN WMWHSE1.taskmanageruser tu                                     " &
"        ON tu.userkey = TASKDETAIL.EDITWHO,                               " &
"                                                                          " &
"           WMSADMIN.PL_DB                                                 " &
"                                                                          " &
"WHERE taskdetail.status = 9                                               " &
"  AND taskdetail.tasktype = 'PK'                                          " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                    " &
"  AND PL_DB.ISACTIVE = 1                                                  " &
"  AND PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"          AT time zone sessiontimezone) AS DATE))                         " &
"  between '" + Parameters!DataDe.Value + "'                               " &
"      and '" + Parameters!DataAte.Value + "'                              " &
"                                                                          " &
"GROUP BY  taskdetail.whseid,                                              " &
"          PL_DB.DB_ALIAS,                                                 " &
"          OS.SCHEDULEDSHIPDATE,                                           " &
"          OS.REFERENCEDOCUMENT,                                           " &
"          OS.ORDERKEY,                                                    " &
"          WD.WAVEKEY,                                                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,        " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE),                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone sessiontimezone) AS DATE),                      " &
"          taskdetail.addwho,                                              " &
"          subStr( tu.usr_name,4,                                          " &
"                  inStr(tu.usr_name, ',')-4 ),                            " &
"          taskdetail.sku,                                                 " &
"          sk.descr                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  taskdetail.whseid             PLANTA,                                   " &
"  PL_DB.DB_ALIAS                DSC_PLANTA,                               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'DD')                       " &
"                                DATA_COL,                                 " &
"  OS.SCHEDULEDSHIPDATE          DATA_LIM,                                 " &
"  (select a.t$entr$c ENTREGA                                              " &
"     from baandb.tznsls004301@pln01 a                                     " &
"    where a.t$orno$c = os.referencedocument                               " &
"      and rownum=1)             ENTREGA,                                  " &
"  OS.REFERENCEDOCUMENT          ORDEM_LN,                                 " &
"  OS.ORDERKEY                   ORDEM_WMS,                                " &
"  WD.WAVEKEY                    ONDA,                                     " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,                " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_INICIO,                                " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_FIM,                                   " &
"  taskdetail.addwho             OPERADOR,                                 " &
"  subStr( tu.usr_name, 4,                                                 " &
"          inStr(tu.usr_name, ',') -4 )                                    " &
"                                NOME_OP,                                  " &
"  taskdetail.sku                ITEM,                                     " &
"  sk.descr                      DESCR_ITEM,                               " &
"  SUM(taskdetail.qty)           QUANT                                     " &
"                                                                          " &
"FROM       WMWHSE2.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE2.ORDERS OS                                              " &
"        ON OS.ORDERKEY = taskdetail.ORDERKEY                              " &
"                                                                          " &
"INNER JOIN WMWHSE2.SKU SK                                                 " &
"        ON SK.SKU = taskdetail.SKU                                        " &
"                                                                          " &
"INNER JOIN (select max(b.WAVEKEY) WAVEKEY,                                " &
"                       b.ORDERKEY                                         " &
"                  from WMWHSE2.WAVEDETAIL b                               " &
"              group by b.ORDERKEY) WD                                     " &
"        ON WD.ORDERKEY = OS.ORDERKEY                                      " &
"                                                                          " &
" LEFT JOIN WMWHSE2.taskmanageruser tu                                     " &
"        ON tu.userkey = TASKDETAIL.EDITWHO,                               " &
"                                                                          " &
"           WMSADMIN.PL_DB                                                 " &
"                                                                          " &
"WHERE taskdetail.status = 9                                               " &
"  AND taskdetail.tasktype = 'PK'                                          " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                    " &
"  AND PL_DB.ISACTIVE = 1                                                  " &
"  AND PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"          AT time zone sessiontimezone) AS DATE))                         " &
"  between '" + Parameters!DataDe.Value + "'                               " &
"      and '" + Parameters!DataAte.Value + "'                              " &
"                                                                          " &
"GROUP BY  taskdetail.whseid,                                              " &
"          PL_DB.DB_ALIAS,                                                 " &
"          OS.SCHEDULEDSHIPDATE,                                           " &
"          OS.REFERENCEDOCUMENT,                                           " &
"          OS.ORDERKEY,                                                    " &
"          WD.WAVEKEY,                                                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,        " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE),                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone sessiontimezone) AS DATE),                      " &
"          taskdetail.addwho,                                              " &
"          subStr( tu.usr_name,4,                                          " &
"                  inStr(tu.usr_name, ',')-4 ),                            " &
"          taskdetail.sku,                                                 " &
"          sk.descr                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  taskdetail.whseid             PLANTA,                                   " &
"  PL_DB.DB_ALIAS                DSC_PLANTA,                               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'DD')                       " &
"                                DATA_COL,                                 " &
"  OS.SCHEDULEDSHIPDATE          DATA_LIM,                                 " &
"  (select a.t$entr$c ENTREGA                                              " &
"     from baandb.tznsls004301@pln01 a                                     " &
"    where a.t$orno$c = os.referencedocument                               " &
"      and rownum=1)             ENTREGA,                                  " &
"  OS.REFERENCEDOCUMENT          ORDEM_LN,                                 " &
"  OS.ORDERKEY                   ORDEM_WMS,                                " &
"  WD.WAVEKEY                    ONDA,                                     " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,                " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_INICIO,                                " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_FIM,                                   " &
"  taskdetail.addwho             OPERADOR,                                 " &
"  subStr( tu.usr_name, 4,                                                 " &
"          inStr(tu.usr_name, ',') -4 )                                    " &
"                                NOME_OP,                                  " &
"  taskdetail.sku                ITEM,                                     " &
"  sk.descr                      DESCR_ITEM,                               " &
"  SUM(taskdetail.qty)           QUANT                                     " &
"                                                                          " &
"FROM       WMWHSE3.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE3.ORDERS OS                                              " &
"        ON OS.ORDERKEY = taskdetail.ORDERKEY                              " &
"                                                                          " &
"INNER JOIN WMWHSE3.SKU SK                                                 " &
"        ON SK.SKU = taskdetail.SKU                                        " &
"                                                                          " &
"INNER JOIN (select max(b.WAVEKEY) WAVEKEY,                                " &
"                       b.ORDERKEY                                         " &
"                  from WMWHSE3.WAVEDETAIL b                               " &
"              group by b.ORDERKEY) WD                                     " &
"        ON WD.ORDERKEY = OS.ORDERKEY                                      " &
"                                                                          " &
" LEFT JOIN WMWHSE3.taskmanageruser tu                                     " &
"        ON tu.userkey = TASKDETAIL.EDITWHO,                               " &
"                                                                          " &
"           WMSADMIN.PL_DB                                                 " &
"                                                                          " &
"WHERE taskdetail.status = 9                                               " &
"  AND taskdetail.tasktype = 'PK'                                          " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                    " &
"  AND PL_DB.ISACTIVE = 1                                                  " &
"  AND PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"          AT time zone sessiontimezone) AS DATE))                         " &
"  between '" + Parameters!DataDe.Value + "'                               " &
"      and '" + Parameters!DataAte.Value + "'                              " &
"                                                                          " &
"GROUP BY  taskdetail.whseid,                                              " &
"          PL_DB.DB_ALIAS,                                                 " &
"          OS.SCHEDULEDSHIPDATE,                                           " &
"          OS.REFERENCEDOCUMENT,                                           " &
"          OS.ORDERKEY,                                                    " &
"          WD.WAVEKEY,                                                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,        " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE),                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone sessiontimezone) AS DATE),                      " &
"          taskdetail.addwho,                                              " &
"          subStr( tu.usr_name,4,                                          " &
"                  inStr(tu.usr_name, ',')-4 ),                            " &
"          taskdetail.sku,                                                 " &
"          sk.descr                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  taskdetail.whseid             PLANTA,                                   " &
"  PL_DB.DB_ALIAS                DSC_PLANTA,                               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'DD')                       " &
"                                DATA_COL,                                 " &
"  OS.SCHEDULEDSHIPDATE          DATA_LIM,                                 " &
"  (select a.t$entr$c ENTREGA                                              " &
"     from baandb.tznsls004301@pln01 a                                     " &
"    where a.t$orno$c = os.referencedocument                               " &
"      and rownum=1)             ENTREGA,                                  " &
"  OS.REFERENCEDOCUMENT          ORDEM_LN,                                 " &
"  OS.ORDERKEY                   ORDEM_WMS,                                " &
"  WD.WAVEKEY                    ONDA,                                     " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,                " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_INICIO,                                " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_FIM,                                   " &
"  taskdetail.addwho             OPERADOR,                                 " &
"  subStr( tu.usr_name, 4,                                                 " &
"          inStr(tu.usr_name, ',') -4 )                                    " &
"                                NOME_OP,                                  " &
"  taskdetail.sku                ITEM,                                     " &
"  sk.descr                      DESCR_ITEM,                               " &
"  SUM(taskdetail.qty)           QUANT                                     " &
"                                                                          " &
"FROM       WMWHSE4.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE4.ORDERS OS                                              " &
"        ON OS.ORDERKEY = taskdetail.ORDERKEY                              " &
"                                                                          " &
"INNER JOIN WMWHSE4.SKU SK                                                 " &
"        ON SK.SKU = taskdetail.SKU                                        " &
"                                                                          " &
"INNER JOIN (select max(b.WAVEKEY) WAVEKEY,                                " &
"                       b.ORDERKEY                                         " &
"                  from WMWHSE4.WAVEDETAIL b                               " &
"              group by b.ORDERKEY) WD                                     " &
"        ON WD.ORDERKEY = OS.ORDERKEY                                      " &
"                                                                          " &
" LEFT JOIN WMWHSE4.taskmanageruser tu                                     " &
"        ON tu.userkey = TASKDETAIL.EDITWHO,                               " &
"                                                                          " &
"           WMSADMIN.PL_DB                                                 " &
"                                                                          " &
"WHERE taskdetail.status = 9                                               " &
"  AND taskdetail.tasktype = 'PK'                                          " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                    " &
"  AND PL_DB.ISACTIVE = 1                                                  " &
"  AND PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"          AT time zone sessiontimezone) AS DATE))                         " &
"  between '" + Parameters!DataDe.Value + "'                               " &
"      and '" + Parameters!DataAte.Value + "'                              " &
"                                                                          " &
"GROUP BY  taskdetail.whseid,                                              " &
"          PL_DB.DB_ALIAS,                                                 " &
"          OS.SCHEDULEDSHIPDATE,                                           " &
"          OS.REFERENCEDOCUMENT,                                           " &
"          OS.ORDERKEY,                                                    " &
"          WD.WAVEKEY,                                                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,        " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE),                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone sessiontimezone) AS DATE),                      " &
"          taskdetail.addwho,                                              " &
"          subStr( tu.usr_name,4,                                          " &
"                  inStr(tu.usr_name, ',')-4 ),                            " &
"          taskdetail.sku,                                                 " &
"          sk.descr                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  taskdetail.whseid             PLANTA,                                   " &
"  PL_DB.DB_ALIAS                DSC_PLANTA,                               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'DD')                       " &
"                                DATA_COL,                                 " &
"  OS.SCHEDULEDSHIPDATE          DATA_LIM,                                 " &
"  (select a.t$entr$c ENTREGA                                              " &
"     from baandb.tznsls004301@pln01 a                                     " &
"    where a.t$orno$c = os.referencedocument                               " &
"      and rownum=1)             ENTREGA,                                  " &
"  OS.REFERENCEDOCUMENT          ORDEM_LN,                                 " &
"  OS.ORDERKEY                   ORDEM_WMS,                                " &
"  WD.WAVEKEY                    ONDA,                                     " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,                " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_INICIO,                                " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_FIM,                                   " &
"  taskdetail.addwho             OPERADOR,                                 " &
"  subStr( tu.usr_name, 4,                                                 " &
"          inStr(tu.usr_name, ',') -4 )                                    " &
"                                NOME_OP,                                  " &
"  taskdetail.sku                ITEM,                                     " &
"  sk.descr                      DESCR_ITEM,                               " &
"  SUM(taskdetail.qty)           QUANT                                     " &
"                                                                          " &
"FROM       WMWHSE5.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE5.ORDERS OS                                              " &
"        ON OS.ORDERKEY = taskdetail.ORDERKEY                              " &
"                                                                          " &
"INNER JOIN WMWHSE5.SKU SK                                                 " &
"        ON SK.SKU = taskdetail.SKU                                        " &
"                                                                          " &
"INNER JOIN (select max(b.WAVEKEY) WAVEKEY,                                " &
"                       b.ORDERKEY                                         " &
"                  from WMWHSE5.WAVEDETAIL b                               " &
"              group by b.ORDERKEY) WD                                     " &
"        ON WD.ORDERKEY = OS.ORDERKEY                                      " &
"                                                                          " &
" LEFT JOIN WMWHSE5.taskmanageruser tu                                     " &
"        ON tu.userkey = TASKDETAIL.EDITWHO,                               " &
"                                                                          " &
"           WMSADMIN.PL_DB                                                 " &
"                                                                          " &
"WHERE taskdetail.status = 9                                               " &
"  AND taskdetail.tasktype = 'PK'                                          " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                    " &
"  AND PL_DB.ISACTIVE = 1                                                  " &
"  AND PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"          AT time zone sessiontimezone) AS DATE))                         " &
"  between '" + Parameters!DataDe.Value + "'                               " &
"      and '" + Parameters!DataAte.Value + "'                              " &
"                                                                          " &
"GROUP BY  taskdetail.whseid,                                              " &
"          PL_DB.DB_ALIAS,                                                 " &
"          OS.SCHEDULEDSHIPDATE,                                           " &
"          OS.REFERENCEDOCUMENT,                                           " &
"          OS.ORDERKEY,                                                    " &
"          WD.WAVEKEY,                                                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,        " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE),                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone sessiontimezone) AS DATE),                      " &
"          taskdetail.addwho,                                              " &
"          subStr( tu.usr_name,4,                                          " &
"                  inStr(tu.usr_name, ',')-4 ),                            " &
"          taskdetail.sku,                                                 " &
"          sk.descr                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  taskdetail.whseid             PLANTA,                                   " &
"  PL_DB.DB_ALIAS                DSC_PLANTA,                               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'DD')                       " &
"                                DATA_COL,                                 " &
"  OS.SCHEDULEDSHIPDATE          DATA_LIM,                                 " &
"  (select a.t$entr$c ENTREGA                                              " &
"     from baandb.tznsls004301@pln01 a                                     " &
"    where a.t$orno$c = os.referencedocument                               " &
"      and rownum=1)             ENTREGA,                                  " &
"  OS.REFERENCEDOCUMENT          ORDEM_LN,                                 " &
"  OS.ORDERKEY                   ORDEM_WMS,                                " &
"  WD.WAVEKEY                    ONDA,                                     " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,                " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_INICIO,                                " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_FIM,                                   " &
"  taskdetail.addwho             OPERADOR,                                 " &
"  subStr( tu.usr_name, 4,                                                 " &
"          inStr(tu.usr_name, ',') -4 )                                    " &
"                                NOME_OP,                                  " &
"  taskdetail.sku                ITEM,                                     " &
"  sk.descr                      DESCR_ITEM,                               " &
"  SUM(taskdetail.qty)           QUANT                                     " &
"                                                                          " &
"FROM       WMWHSE6.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE6.ORDERS OS                                              " &
"        ON OS.ORDERKEY = taskdetail.ORDERKEY                              " &
"                                                                          " &
"INNER JOIN WMWHSE6.SKU SK                                                 " &
"        ON SK.SKU = taskdetail.SKU                                        " &
"                                                                          " &
"INNER JOIN (select max(b.WAVEKEY) WAVEKEY,                                " &
"                       b.ORDERKEY                                         " &
"                  from WMWHSE6.WAVEDETAIL b                               " &
"              group by b.ORDERKEY) WD                                     " &
"        ON WD.ORDERKEY = OS.ORDERKEY                                      " &
"                                                                          " &
" LEFT JOIN WMWHSE6.taskmanageruser tu                                     " &
"        ON tu.userkey = TASKDETAIL.EDITWHO,                               " &
"                                                                          " &
"           WMSADMIN.PL_DB                                                 " &
"                                                                          " &
"WHERE taskdetail.status = 9                                               " &
"  AND taskdetail.tasktype = 'PK'                                          " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                    " &
"  AND PL_DB.ISACTIVE = 1                                                  " &
"  AND PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"          AT time zone sessiontimezone) AS DATE))                         " &
"  between '" + Parameters!DataDe.Value + "'                               " &
"      and '" + Parameters!DataAte.Value + "'                              " &
"                                                                          " &
"GROUP BY  taskdetail.whseid,                                              " &
"          PL_DB.DB_ALIAS,                                                 " &
"          OS.SCHEDULEDSHIPDATE,                                           " &
"          OS.REFERENCEDOCUMENT,                                           " &
"          OS.ORDERKEY,                                                    " &
"          WD.WAVEKEY,                                                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,        " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE),                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone sessiontimezone) AS DATE),                      " &
"          taskdetail.addwho,                                              " &
"          subStr( tu.usr_name,4,                                          " &
"                  inStr(tu.usr_name, ',')-4 ),                            " &
"          taskdetail.sku,                                                 " &
"          sk.descr                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  taskdetail.whseid             PLANTA,                                   " &
"  PL_DB.DB_ALIAS                DSC_PLANTA,                               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,            " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'DD')                       " &
"                                DATA_COL,                                 " &
"  OS.SCHEDULEDSHIPDATE          DATA_LIM,                                 " &
"  (select a.t$entr$c ENTREGA                                              " &
"     from baandb.tznsls004301@pln01 a                                     " &
"    where a.t$orno$c = os.referencedocument                               " &
"      and rownum=1)             ENTREGA,                                  " &
"  OS.REFERENCEDOCUMENT          ORDEM_LN,                                 " &
"  OS.ORDERKEY                   ORDEM_WMS,                                " &
"  WD.WAVEKEY                    ONDA,                                     " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,                " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_INICIO,                                " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE)                              " &
"                                HR_FIM,                                   " &
"  taskdetail.addwho             OPERADOR,                                 " &
"  subStr( tu.usr_name, 4,                                                 " &
"          inStr(tu.usr_name, ',') -4 )                                    " &
"                                NOME_OP,                                  " &
"  taskdetail.sku                ITEM,                                     " &
"  sk.descr                      DESCR_ITEM,                               " &
"  SUM(taskdetail.qty)           QUANT                                     " &
"                                                                          " &
"FROM       WMWHSE7.taskdetail                                             " &
"                                                                          " &
"INNER JOIN WMWHSE7.ORDERS OS                                              " &
"        ON OS.ORDERKEY = taskdetail.ORDERKEY                              " &
"                                                                          " &
"INNER JOIN WMWHSE7.SKU SK                                                 " &
"        ON SK.SKU = taskdetail.SKU                                        " &
"                                                                          " &
"INNER JOIN (select max(b.WAVEKEY) WAVEKEY,                                " &
"                       b.ORDERKEY                                         " &
"                  from WMWHSE7.WAVEDETAIL b                               " &
"              group by b.ORDERKEY) WD                                     " &
"        ON WD.ORDERKEY = OS.ORDERKEY                                      " &
"                                                                          " &
" LEFT JOIN WMWHSE7.taskmanageruser tu                                     " &
"        ON tu.userkey = TASKDETAIL.EDITWHO,                               " &
"                                                                          " &
"           WMSADMIN.PL_DB                                                 " &
"                                                                          " &
"WHERE taskdetail.status = 9                                               " &
"  AND taskdetail.tasktype = 'PK'                                          " &
"  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                    " &
"  AND PL_DB.ISACTIVE = 1                                                  " &
"  AND PL_DB.DB_ENTERPRISE = 0                                             " &
"                                                                          " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"          AT time zone sessiontimezone) AS DATE))                         " &
"  between '" + Parameters!DataDe.Value + "'                               " &
"      and '" + Parameters!DataAte.Value + "'                              " &
"                                                                          " &
"GROUP BY  taskdetail.whseid,                                              " &
"          PL_DB.DB_ALIAS,                                                 " &
"          OS.SCHEDULEDSHIPDATE,                                           " &
"          OS.REFERENCEDOCUMENT,                                           " &
"          OS.ORDERKEY,                                                    " &
"          WD.WAVEKEY,                                                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME,        " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE),                     " &
"          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone sessiontimezone) AS DATE),                      " &
"          taskdetail.addwho,                                              " &
"          subStr( tu.usr_name,4,                                          " &
"                  inStr(tu.usr_name, ',')-4 ),                            " &
"          taskdetail.sku,                                                 " &
"          sk.descr                                                        " &
"                                                                          " &
"ORDER BY 2, DATA_COL                                                                "   

)