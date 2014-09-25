SELECT
  WMSADMIN.DB_ALIAS                       PLANTA,
  TRUNC(TASKDETAIL.EDITDATE, 'DD')        DATA,
  TO_CHAR(TASKDETAIL.EDITDATE, 'HH24')    HORA,
  TASKDETAIL.EDITWHO                      OPERADOR,
  subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',')-4 )   NOME_OP,
  COUNT(TASKDETAIL.SKU)                   ITEM,
  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,
  LOC.PUTAWAYZONE                         CLA_LOC,
  SUM(TASKDETAIL.QTY)                     PECAS

FROM      WMWHSE4.LOC,
          WMWHSE4.TASKDETAIL

LEFT JOIN WMWHSE4.taskmanageruser tu 
       ON tu.userkey = TASKDETAIL.EDITWHO,
    
          WMSADMIN.PL_DB    WMSADMIN
  
WHERE UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID
  AND LOC.LOC = TASKDETAIL.FROMLOC
  AND Trunc(TASKDETAIL.EDITDATE) Between :DataDe 
  AND :DataAte

GROUP BY WMSADMIN.DB_ALIAS,
         TRUNC(TASKDETAIL.EDITDATE, 'DD'),
         TO_CHAR(TASKDETAIL.EDITDATE, 'HH24'),
         TASKDETAIL.EDITWHO,
         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),
         LOC.PUTAWAYZONE

   

"SELECT                                                                        " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                             " &
"  TRUNC(TASKDETAIL.EDITDATE, 'DD')        DATA,                               " &
"  TO_CHAR(TASKDETAIL.EDITDATE, 'HH24')    HORA,                               " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                           " &
"  subStr( tu.usr_name,4,                                                      " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                            " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                               " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                              " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                            " &
"  SUM(TASKDETAIL.QTY)                     PECAS                               " &
"                                                                              " &
"FROM      " + Parameters!Table.Value + ".LOC,                                 " &
"          " + Parameters!Table.Value + ".TASKDETAIL                           " &
"                                                                              " &
"LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu                   " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                    " &
"                                                                              " &
"          WMSADMIN.PL_DB    WMSADMIN                                          " &
"                                                                              " &
"WHERE UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                            " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                            " &
"  AND Trunc(TASKDETAIL.EDITDATE) Between '" + Parameters!DataDe.Value + "'    " &
"  AND '" + Parameters!DataAte.Value + "'                                      " &
"                                                                              " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                   " &
"         TRUNC(TASKDETAIL.EDITDATE, 'DD'),                                    " &
"         TO_CHAR(TASKDETAIL.EDITDATE, 'HH24'),                                " &
"         TASKDETAIL.EDITWHO,                                                  " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         LOC.PUTAWAYZONE                                                      " &
"ORDER BY DATA                                                                 "

-- Query com UNION ****************************************

"SELECT                                                                        " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                             " &
"  TRUNC(TASKDETAIL.EDITDATE, 'DD')        DATA,                               " &
"  TO_CHAR(TASKDETAIL.EDITDATE, 'HH24')    HORA,                               " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                           " &
"  subStr( tu.usr_name,4,                                                      " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                            " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                               " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                              " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                            " &
"  SUM(TASKDETAIL.QTY)                     PECAS                               " &
"                                                                              " &
"FROM      WMWHSE1.LOC,                                                        " &
"          WMWHSE1.TASKDETAIL                                                  " &
"                                                                              " &
"LEFT JOIN WMWHSE1.taskmanageruser tu                                          " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                    " &
"                                                                              " &
"          WMSADMIN.PL_DB    WMSADMIN                                          " &
"                                                                              " &
"WHERE UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                            " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                            " &
"  AND Trunc(TASKDETAIL.EDITDATE) Between '" + Parameters!DataDe.Value + "'    " &
"  AND '" + Parameters!DataAte.Value + "'                                      " &
"                                                                              " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                   " &
"         TRUNC(TASKDETAIL.EDITDATE, 'DD'),                                    " &
"         TO_CHAR(TASKDETAIL.EDITDATE, 'HH24'),                                " &
"         TASKDETAIL.EDITWHO,                                                  " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         LOC.PUTAWAYZONE                                                      " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                             " &
"  TRUNC(TASKDETAIL.EDITDATE, 'DD')        DATA,                               " &
"  TO_CHAR(TASKDETAIL.EDITDATE, 'HH24')    HORA,                               " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                           " &
"  subStr( tu.usr_name,4,                                                      " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                            " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                               " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                              " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                            " &
"  SUM(TASKDETAIL.QTY)                     PECAS                               " &
"                                                                              " &
"FROM      WMWHSE2.LOC,                                                        " &
"          WMWHSE2.TASKDETAIL                                                  " &
"                                                                              " &
"LEFT JOIN WMWHSE2.taskmanageruser tu                                          " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                    " &
"                                                                              " &
"          WMSADMIN.PL_DB    WMSADMIN                                          " &
"                                                                              " &
"WHERE UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                            " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                            " &
"  AND Trunc(TASKDETAIL.EDITDATE) Between '" + Parameters!DataDe.Value + "'    " &
"  AND '" + Parameters!DataAte.Value + "'                                      " &
"                                                                              " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                   " &
"         TRUNC(TASKDETAIL.EDITDATE, 'DD'),                                    " &
"         TO_CHAR(TASKDETAIL.EDITDATE, 'HH24'),                                " &
"         TASKDETAIL.EDITWHO,                                                  " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         LOC.PUTAWAYZONE                                                      " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                             " &
"  TRUNC(TASKDETAIL.EDITDATE, 'DD')        DATA,                               " &
"  TO_CHAR(TASKDETAIL.EDITDATE, 'HH24')    HORA,                               " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                           " &
"  subStr( tu.usr_name,4,                                                      " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                            " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                               " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                              " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                            " &
"  SUM(TASKDETAIL.QTY)                     PECAS                               " &
"                                                                              " &
"FROM      WMWHSE3.LOC,                                                        " &
"          WMWHSE3.TASKDETAIL                                                  " &
"                                                                              " &
"LEFT JOIN WMWHSE3.taskmanageruser tu                                          " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                    " &
"                                                                              " &
"          WMSADMIN.PL_DB    WMSADMIN                                          " &
"                                                                              " &
"WHERE UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                            " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                            " &
"  AND Trunc(TASKDETAIL.EDITDATE) Between '" + Parameters!DataDe.Value + "'    " &
"  AND '" + Parameters!DataAte.Value + "'                                      " &
"                                                                              " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                   " &
"         TRUNC(TASKDETAIL.EDITDATE, 'DD'),                                    " &
"         TO_CHAR(TASKDETAIL.EDITDATE, 'HH24'),                                " &
"         TASKDETAIL.EDITWHO,                                                  " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         LOC.PUTAWAYZONE                                                      " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                             " &
"  TRUNC(TASKDETAIL.EDITDATE, 'DD')        DATA,                               " &
"  TO_CHAR(TASKDETAIL.EDITDATE, 'HH24')    HORA,                               " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                           " &
"  subStr( tu.usr_name,4,                                                      " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                            " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                               " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                              " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                            " &
"  SUM(TASKDETAIL.QTY)                     PECAS                               " &
"                                                                              " &
"FROM      WMWHSE4.LOC,                                                        " &
"          WMWHSE4.TASKDETAIL                                                  " &
"                                                                              " &
"LEFT JOIN WMWHSE4.taskmanageruser tu                                          " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                    " &
"                                                                              " &
"          WMSADMIN.PL_DB    WMSADMIN                                          " &
"                                                                              " &
"WHERE UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                            " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                            " &
"  AND Trunc(TASKDETAIL.EDITDATE) Between '" + Parameters!DataDe.Value + "'    " &
"  AND '" + Parameters!DataAte.Value + "'                                      " &
"                                                                              " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                   " &
"         TRUNC(TASKDETAIL.EDITDATE, 'DD'),                                    " &
"         TO_CHAR(TASKDETAIL.EDITDATE, 'HH24'),                                " &
"         TASKDETAIL.EDITWHO,                                                  " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         LOC.PUTAWAYZONE                                                      " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                             " &
"  TRUNC(TASKDETAIL.EDITDATE, 'DD')        DATA,                               " &
"  TO_CHAR(TASKDETAIL.EDITDATE, 'HH24')    HORA,                               " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                           " &
"  subStr( tu.usr_name,4,                                                      " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                            " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                               " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                              " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                            " &
"  SUM(TASKDETAIL.QTY)                     PECAS                               " &
"                                                                              " &
"FROM      WMWHSE5.LOC,                                                        " &
"          WMWHSE5.TASKDETAIL                                                  " &
"                                                                              " &
"LEFT JOIN WMWHSE5.taskmanageruser tu                                          " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                    " &
"                                                                              " &
"          WMSADMIN.PL_DB    WMSADMIN                                          " &
"                                                                              " &
"WHERE UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                            " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                            " &
"  AND Trunc(TASKDETAIL.EDITDATE) Between '" + Parameters!DataDe.Value + "'    " &
"  AND '" + Parameters!DataAte.Value + "'                                      " &
"                                                                              " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                   " &
"         TRUNC(TASKDETAIL.EDITDATE, 'DD'),                                    " &
"         TO_CHAR(TASKDETAIL.EDITDATE, 'HH24'),                                " &
"         TASKDETAIL.EDITWHO,                                                  " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         LOC.PUTAWAYZONE                                                      " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                             " &
"  TRUNC(TASKDETAIL.EDITDATE, 'DD')        DATA,                               " &
"  TO_CHAR(TASKDETAIL.EDITDATE, 'HH24')    HORA,                               " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                           " &
"  subStr( tu.usr_name,4,                                                      " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                            " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                               " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                              " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                            " &
"  SUM(TASKDETAIL.QTY)                     PECAS                               " &
"                                                                              " &
"FROM      WMWHSE6.LOC,                                                        " &
"          WMWHSE6.TASKDETAIL                                                  " &
"                                                                              " &
"LEFT JOIN WMWHSE6.taskmanageruser tu                                          " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                    " &
"                                                                              " &
"          WMSADMIN.PL_DB    WMSADMIN                                          " &
"                                                                              " &
"WHERE UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                            " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                            " &
"  AND Trunc(TASKDETAIL.EDITDATE) Between '" + Parameters!DataDe.Value + "'    " &
"  AND '" + Parameters!DataAte.Value + "'                                      " &
"                                                                              " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                   " &
"         TRUNC(TASKDETAIL.EDITDATE, 'DD'),                                    " &
"         TO_CHAR(TASKDETAIL.EDITDATE, 'HH24'),                                " &
"         TASKDETAIL.EDITWHO,                                                  " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         LOC.PUTAWAYZONE                                                      " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                             " &
"  TRUNC(TASKDETAIL.EDITDATE, 'DD')        DATA,                               " &
"  TO_CHAR(TASKDETAIL.EDITDATE, 'HH24')    HORA,                               " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                           " &
"  subStr( tu.usr_name,4,                                                      " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                            " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                               " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                              " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                            " &
"  SUM(TASKDETAIL.QTY)                     PECAS                               " &
"                                                                              " &
"FROM      WMWHSE7.LOC,                                                        " &
"          WMWHSE7.TASKDETAIL                                                  " &
"                                                                              " &
"LEFT JOIN WMWHSE7.taskmanageruser tu                                          " &
"       ON tu.userkey = TASKDETAIL.EDITWHO,                                    " &
"                                                                              " &
"          WMSADMIN.PL_DB    WMSADMIN                                          " &
"                                                                              " &
"WHERE UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                            " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                            " &
"  AND Trunc(TASKDETAIL.EDITDATE) Between '" + Parameters!DataDe.Value + "'    " &
"  AND '" + Parameters!DataAte.Value + "'                                      " &
"                                                                              " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                   " &
"         TRUNC(TASKDETAIL.EDITDATE, 'DD'),                                    " &
"         TO_CHAR(TASKDETAIL.EDITDATE, 'HH24'),                                " &
"         TASKDETAIL.EDITWHO,                                                  " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         LOC.PUTAWAYZONE                                                      " &
"                                                                              " &
"ORDER BY PLANTA, DATA                                                         "
