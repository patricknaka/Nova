SELECT
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS             ID_PLANTA,
    TASKDETAIL.EDITWHO                  ID_OPERADOR,
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',')-4 ) NOME_OPERADOR,
    TASKDETAIL.wavekey                  ID_PROG,
    TASKDETAIL.TASKDETAILkey            ID_ONDA,
    TASKDETAIL.ORDERKEY                 ID_PEDIDO,
    SLS401.T$ENTR$C                     ID_ENTREGA,
    TASKDETAIL.SKU                      ID_ITEM,
    SKU.DESCR                           ID_ITEM_DESC,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)                     
                                        DT_LIQUID_ROM,
    TASKDETAIL.FROMLOC                  ID_LOCAL,
    LOC.PUTAWAYZONE                     ID_CLA_LOC,
    ORDERS.C_VAT                        ID_MEGA_ROTA
  
FROM      WMWHSE5.TASKDETAIL
    
LEFT JOIN WMWHSE5.taskmanageruser tu 
       ON tu.userkey = TASKDETAIL.EDITWHO,
    
          WMSADMIN.PL_DB,
          WMWHSE5.LOC,
          WMWHSE5.SKU,
          BAANDB.TZNSLS401301@pln01 SLS401,
          WMWHSE5.ORDERS
    
WHERE TASKDETAIL.STATUS = 9 
  AND TASKDETAIL.TASKTYPE = 'PK'
  AND TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY 
  AND LOC.LOC = TASKDETAIL.FROMLOC 
  AND SKU.SKU = TASKDETAIL.SKU 
  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID 
  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataFimPickingDe AND :DataFimPickingAte


"SELECT                                                                                " &
"  DISTINCT                                                                            " &
"    WMSADMIN.PL_DB.DB_ALIAS             ID_PLANTA,                                    " &
"    TASKDETAIL.EDITWHO                  ID_OPERADOR,                                  " &
"    subStr( tu.usr_name,4,                                                            " &
"            inStr(tu.usr_name, ',')-4 ) NOME_OPERADOR,                                " &
"    TASKDETAIL.wavekey                  ID_PROG,                                      " &
"    TASKDETAIL.TASKDETAILkey            ID_ONDA,                                      " &
"    TASKDETAIL.ORDERKEY                 ID_PEDIDO,                                    " &
"    SLS401.T$ENTR$C                     ID_ENTREGA,                                   " &
"    TASKDETAIL.SKU                      ID_ITEM,                                      " &
"    SKU.DESCR                           ID_ITEM_DESC,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                        " &                     
"                                        DT_LIQUID_ROM,                                " &
"    TASKDETAIL.FROMLOC                  ID_LOCAL,                                     " &
"    LOC.PUTAWAYZONE                     ID_CLA_LOC,                                   " &
"    ORDERS.C_VAT                        ID_MEGA_ROTA                                  " &
"                                                                                      " &
"FROM      " + Parameters!Table.Value + ".TASKDETAIL                                   " &
"                                                                                      " &
"LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu                           " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                              " &
"                                                                                      " &
"          WMSADMIN.PL_DB,                                                             " &
"          " + Parameters!Table.Value + ".LOC,                                         " &
"          " + Parameters!Table.Value + ".SKU,                                         " &
"          BAANDB.TZNSLS401301@pln01 SLS401,                                           " &
"          " + Parameters!Table.Value + ".ORDERS                                       " &
"                                                                                      " &
"WHERE TASKDETAIL.STATUS = 9                                                           " &
"  AND TASKDETAIL.TASKTYPE = 'PK'                                                      " &
"  AND TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY                                           " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                    " &
"  AND SKU.SKU = TASKDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                              " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                      " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataFimPickingDe.Value + "'   " &
"  AND '" + Parameters!DataFimPickingAte.Value + "'                                    "

-- Query com UNION ***********************************************************************

"SELECT                                                                                " &
"  DISTINCT                                                                            " &
"    WMSADMIN.PL_DB.DB_ALIAS             ID_PLANTA,                                    " &
"    TASKDETAIL.EDITWHO                  ID_OPERADOR,                                  " &
"    subStr( tu.usr_name,4,                                                            " &
"            inStr(tu.usr_name, ',')-4 ) NOME_OPERADOR,                                " &
"    TASKDETAIL.wavekey                  ID_PROG,                                      " &
"    TASKDETAIL.TASKDETAILkey            ID_ONDA,                                      " &
"    TASKDETAIL.ORDERKEY                 ID_PEDIDO,                                    " &
"    SLS401.T$ENTR$C                     ID_ENTREGA,                                   " &
"    TASKDETAIL.SKU                      ID_ITEM,                                      " &
"    SKU.DESCR                           ID_ITEM_DESC,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                        " &                     
"                                        DT_LIQUID_ROM,                                " &
"    TASKDETAIL.FROMLOC                  ID_LOCAL,                                     " &
"    LOC.PUTAWAYZONE                     ID_CLA_LOC,                                   " &
"    ORDERS.C_VAT                        ID_MEGA_ROTA                                  " &
"                                                                                      " &
"FROM      WMWHSE1.TASKDETAIL                                                          " &
"                                                                                      " &
"LEFT JOIN WMWHSE1.taskmanageruser tu                                                  " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                              " &
"                                                                                      " &
"          WMSADMIN.PL_DB,                                                             " &
"          WMWHSE1.LOC,                                                                " &
"          WMWHSE1.SKU,                                                                " &
"          BAANDB.TZNSLS401301@pln01 SLS401,                                           " &
"          WMWHSE1.ORDERS                                                              " &
"                                                                                      " &
"WHERE TASKDETAIL.STATUS = 9                                                           " &
"  AND TASKDETAIL.TASKTYPE = 'PK'                                                      " &
"  AND TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY                                           " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                    " &
"  AND SKU.SKU = TASKDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                              " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                      " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataFimPickingDe.Value + "'   " &
"  AND '" + Parameters!DataFimPickingAte.Value + "'                                    "
"                                                                                      " &
"Union                                                                                 " &
"                                                                                      " &
"SELECT                                                                                " &
"  DISTINCT                                                                            " &
"    WMSADMIN.PL_DB.DB_ALIAS             ID_PLANTA,                                    " &
"    TASKDETAIL.EDITWHO                  ID_OPERADOR,                                  " &
"    subStr( tu.usr_name,4,                                                            " &
"            inStr(tu.usr_name, ',')-4 ) NOME_OPERADOR,                                " &
"    TASKDETAIL.wavekey                  ID_PROG,                                      " &
"    TASKDETAIL.TASKDETAILkey            ID_ONDA,                                      " &
"    TASKDETAIL.ORDERKEY                 ID_PEDIDO,                                    " &
"    SLS401.T$ENTR$C                     ID_ENTREGA,                                   " &
"    TASKDETAIL.SKU                      ID_ITEM,                                      " &
"    SKU.DESCR                           ID_ITEM_DESC,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                        " &                     
"                                        DT_LIQUID_ROM,                                " &
"    TASKDETAIL.FROMLOC                  ID_LOCAL,                                     " &
"    LOC.PUTAWAYZONE                     ID_CLA_LOC,                                   " &
"    ORDERS.C_VAT                        ID_MEGA_ROTA                                  " &
"                                                                                      " &
"FROM      WMWHSE2.TASKDETAIL                                                          " &
"                                                                                      " &
"LEFT JOIN WMWHSE2.taskmanageruser tu                                                  " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                              " &
"                                                                                      " &
"          WMSADMIN.PL_DB,                                                             " &
"          WMWHSE2.LOC,                                                                " &
"          WMWHSE2.SKU,                                                                " &
"          BAANDB.TZNSLS401301@pln01 SLS401,                                           " &
"          WMWHSE2.ORDERS                                                              " &
"                                                                                      " &
"WHERE TASKDETAIL.STATUS = 9                                                           " &
"  AND TASKDETAIL.TASKTYPE = 'PK'                                                      " &
"  AND TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY                                           " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                    " &
"  AND SKU.SKU = TASKDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                              " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                      " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataFimPickingDe.Value + "'   " &
"  AND '" + Parameters!DataFimPickingAte.Value + "'                                    "
"                                                                                      " &
"Union                                                                                 " &
"                                                                                      " &
"SELECT                                                                                " &
"  DISTINCT                                                                            " &
"    WMSADMIN.PL_DB.DB_ALIAS             ID_PLANTA,                                    " &
"    TASKDETAIL.EDITWHO                  ID_OPERADOR,                                  " &
"    subStr( tu.usr_name,4,                                                            " &
"            inStr(tu.usr_name, ',')-4 ) NOME_OPERADOR,                                " &
"    TASKDETAIL.wavekey                  ID_PROG,                                      " &
"    TASKDETAIL.TASKDETAILkey            ID_ONDA,                                      " &
"    TASKDETAIL.ORDERKEY                 ID_PEDIDO,                                    " &
"    SLS401.T$ENTR$C                     ID_ENTREGA,                                   " &
"    TASKDETAIL.SKU                      ID_ITEM,                                      " &
"    SKU.DESCR                           ID_ITEM_DESC,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                        " &                     
"                                        DT_LIQUID_ROM,                                " &
"    TASKDETAIL.FROMLOC                  ID_LOCAL,                                     " &
"    LOC.PUTAWAYZONE                     ID_CLA_LOC,                                   " &
"    ORDERS.C_VAT                        ID_MEGA_ROTA                                  " &
"                                                                                      " &
"FROM      WMWHSE3.TASKDETAIL                                                          " &
"                                                                                      " &
"LEFT JOIN WMWHSE3.taskmanageruser tu                                                  " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                              " &
"                                                                                      " &
"          WMSADMIN.PL_DB,                                                             " &
"          WMWHSE3.LOC,                                                                " &
"          WMWHSE3.SKU,                                                                " &
"          BAANDB.TZNSLS401301@pln01 SLS401,                                           " &
"          WMWHSE3.ORDERS                                                              " &
"                                                                                      " &
"WHERE TASKDETAIL.STATUS = 9                                                           " &
"  AND TASKDETAIL.TASKTYPE = 'PK'                                                      " &
"  AND TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY                                           " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                    " &
"  AND SKU.SKU = TASKDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                              " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                      " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataFimPickingDe.Value + "'   " &
"  AND '" + Parameters!DataFimPickingAte.Value + "'                                    "
"                                                                                      " &
"Union                                                                                 " &
"                                                                                      " &
"SELECT                                                                                " &
"  DISTINCT                                                                            " &
"    WMSADMIN.PL_DB.DB_ALIAS             ID_PLANTA,                                    " &
"    TASKDETAIL.EDITWHO                  ID_OPERADOR,                                  " &
"    subStr( tu.usr_name,4,                                                            " &
"            inStr(tu.usr_name, ',')-4 ) NOME_OPERADOR,                                " &
"    TASKDETAIL.wavekey                  ID_PROG,                                      " &
"    TASKDETAIL.TASKDETAILkey            ID_ONDA,                                      " &
"    TASKDETAIL.ORDERKEY                 ID_PEDIDO,                                    " &
"    SLS401.T$ENTR$C                     ID_ENTREGA,                                   " &
"    TASKDETAIL.SKU                      ID_ITEM,                                      " &
"    SKU.DESCR                           ID_ITEM_DESC,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                        " &                     
"                                        DT_LIQUID_ROM,                                " &
"    TASKDETAIL.FROMLOC                  ID_LOCAL,                                     " &
"    LOC.PUTAWAYZONE                     ID_CLA_LOC,                                   " &
"    ORDERS.C_VAT                        ID_MEGA_ROTA                                  " &
"                                                                                      " &
"FROM      WMWHSE4.TASKDETAIL                                                          " &
"                                                                                      " &
"LEFT JOIN WMWHSE4.taskmanageruser tu                                                  " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                              " &
"                                                                                      " &
"          WMSADMIN.PL_DB,                                                             " &
"          WMWHSE4.LOC,                                                                " &
"          WMWHSE4.SKU,                                                                " &
"          BAANDB.TZNSLS401301@pln01 SLS401,                                           " &
"          WMWHSE4.ORDERS                                                              " &
"                                                                                      " &
"WHERE TASKDETAIL.STATUS = 9                                                           " &
"  AND TASKDETAIL.TASKTYPE = 'PK'                                                      " &
"  AND TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY                                           " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                    " &
"  AND SKU.SKU = TASKDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                              " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                      " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataFimPickingDe.Value + "'   " &
"  AND '" + Parameters!DataFimPickingAte.Value + "'                                    "
"                                                                                      " &
"Union                                                                                 " &
"                                                                                      " &
"SELECT                                                                                " &
"  DISTINCT                                                                            " &
"    WMSADMIN.PL_DB.DB_ALIAS             ID_PLANTA,                                    " &
"    TASKDETAIL.EDITWHO                  ID_OPERADOR,                                  " &
"    subStr( tu.usr_name,4,                                                            " &
"            inStr(tu.usr_name, ',')-4 ) NOME_OPERADOR,                                " &
"    TASKDETAIL.wavekey                  ID_PROG,                                      " &
"    TASKDETAIL.TASKDETAILkey            ID_ONDA,                                      " &
"    TASKDETAIL.ORDERKEY                 ID_PEDIDO,                                    " &
"    SLS401.T$ENTR$C                     ID_ENTREGA,                                   " &
"    TASKDETAIL.SKU                      ID_ITEM,                                      " &
"    SKU.DESCR                           ID_ITEM_DESC,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                        " &                     
"                                        DT_LIQUID_ROM,                                " &
"    TASKDETAIL.FROMLOC                  ID_LOCAL,                                     " &
"    LOC.PUTAWAYZONE                     ID_CLA_LOC,                                   " &
"    ORDERS.C_VAT                        ID_MEGA_ROTA                                  " &
"                                                                                      " &
"FROM      WMWHSE5.TASKDETAIL                                                          " &
"                                                                                      " &
"LEFT JOIN WMWHSE5.taskmanageruser tu                                                  " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                              " &
"                                                                                      " &
"          WMSADMIN.PL_DB,                                                             " &
"          WMWHSE5.LOC,                                                                " &
"          WMWHSE5.SKU,                                                                " &
"          BAANDB.TZNSLS401301@pln01 SLS401,                                           " &
"          WMWHSE5.ORDERS                                                              " &
"                                                                                      " &
"WHERE TASKDETAIL.STATUS = 9                                                           " &
"  AND TASKDETAIL.TASKTYPE = 'PK'                                                      " &
"  AND TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY                                           " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                    " &
"  AND SKU.SKU = TASKDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                              " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                      " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataFimPickingDe.Value + "'   " &
"  AND '" + Parameters!DataFimPickingAte.Value + "'                                    "
"                                                                                      " &
"Union                                                                                 " &
"                                                                                      " &
"SELECT                                                                                " &
"  DISTINCT                                                                            " &
"    WMSADMIN.PL_DB.DB_ALIAS             ID_PLANTA,                                    " &
"    TASKDETAIL.EDITWHO                  ID_OPERADOR,                                  " &
"    subStr( tu.usr_name,4,                                                            " &
"            inStr(tu.usr_name, ',')-4 ) NOME_OPERADOR,                                " &
"    TASKDETAIL.wavekey                  ID_PROG,                                      " &
"    TASKDETAIL.TASKDETAILkey            ID_ONDA,                                      " &
"    TASKDETAIL.ORDERKEY                 ID_PEDIDO,                                    " &
"    SLS401.T$ENTR$C                     ID_ENTREGA,                                   " &
"    TASKDETAIL.SKU                      ID_ITEM,                                      " &
"    SKU.DESCR                           ID_ITEM_DESC,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                        " &                     
"                                        DT_LIQUID_ROM,                                " &
"    TASKDETAIL.FROMLOC                  ID_LOCAL,                                     " &
"    LOC.PUTAWAYZONE                     ID_CLA_LOC,                                   " &
"    ORDERS.C_VAT                        ID_MEGA_ROTA                                  " &
"                                                                                      " &
"FROM      WMWHSE6.TASKDETAIL                                                          " &
"                                                                                      " &
"LEFT JOIN WMWHSE6.taskmanageruser tu                                                  " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                              " &
"                                                                                      " &
"          WMSADMIN.PL_DB,                                                             " &
"          WMWHSE6.LOC,                                                                " &
"          WMWHSE6.SKU,                                                                " &
"          BAANDB.TZNSLS401301@pln01 SLS401,                                           " &
"          WMWHSE6.ORDERS                                                              " &
"                                                                                      " &
"WHERE TASKDETAIL.STATUS = 9                                                           " &
"  AND TASKDETAIL.TASKTYPE = 'PK'                                                      " &
"  AND TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY                                           " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                    " &
"  AND SKU.SKU = TASKDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                              " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                      " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataFimPickingDe.Value + "'   " &
"  AND '" + Parameters!DataFimPickingAte.Value + "'                                    "
"                                                                                      " &
"Union                                                                                 " &
"                                                                                      " &
"SELECT                                                                                " &
"  DISTINCT                                                                            " &
"    WMSADMIN.PL_DB.DB_ALIAS             ID_PLANTA,                                    " &
"    TASKDETAIL.EDITWHO                  ID_OPERADOR,                                  " &
"    subStr( tu.usr_name,4,                                                            " &
"            inStr(tu.usr_name, ',')-4 ) NOME_OPERADOR,                                " &
"    TASKDETAIL.wavekey                  ID_PROG,                                      " &
"    TASKDETAIL.TASKDETAILkey            ID_ONDA,                                      " &
"    TASKDETAIL.ORDERKEY                 ID_PEDIDO,                                    " &
"    SLS401.T$ENTR$C                     ID_ENTREGA,                                   " &
"    TASKDETAIL.SKU                      ID_ITEM,                                      " &
"    SKU.DESCR                           ID_ITEM_DESC,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                        " &                     
"                                        DT_LIQUID_ROM,                                " &
"    TASKDETAIL.FROMLOC                  ID_LOCAL,                                     " &
"    LOC.PUTAWAYZONE                     ID_CLA_LOC,                                   " &
"    ORDERS.C_VAT                        ID_MEGA_ROTA                                  " &
"                                                                                      " &
"FROM      WMWHSE7.TASKDETAIL                                                          " &
"                                                                                      " &
"LEFT JOIN WMWHSE7.taskmanageruser tu                                                  " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                              " &
"                                                                                      " &
"          WMSADMIN.PL_DB,                                                             " &
"          WMWHSE7.LOC,                                                                " &
"          WMWHSE7.SKU,                                                                " &
"          BAANDB.TZNSLS401301@pln01 SLS401,                                           " &
"          WMWHSE7.ORDERS                                                              " &
"                                                                                      " &
"WHERE TASKDETAIL.STATUS = 9                                                           " &
"  AND TASKDETAIL.TASKTYPE = 'PK'                                                      " &
"  AND TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY                                           " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                    " &
"  AND SKU.SKU = TASKDETAIL.SKU                                                        " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                              " &
"  AND SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                      " &
"                                                                                      " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.ENDTIME,                    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                    " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataFimPickingDe.Value + "'   " &
"  AND '" + Parameters!DataFimPickingAte.Value + "'                                    "
"                                                                                      " &
"order by ID_PLANTA                                                                    "