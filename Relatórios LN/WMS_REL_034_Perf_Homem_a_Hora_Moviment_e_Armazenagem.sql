SELECT
  WMSADMIN.DB_ALIAS                       PLANTA,
  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE), 'DD')        
                                          DATA,
  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')    
                                          HORA,
  IT.EDITWHO                              OPERADOR,
  subStr( tu.usr_name,4,
          inStr(tu.usr_name, ',') -4 )    NOME_OP,
  COUNT(distinct IT.SKU)                  ITEM,
  COUNT(distinct IT.FROMLOC)              LOCAL,
  LOC.PUTAWAYZONE                         CLA_LOC,
  TOLOC.PUTAWAYZONE                       CLA_LOC_PARA,
  SUM(IT.QTY)                             PECAS

FROM       WMWHSE5.ITRN IT

INNER JOIN WMWHSE5.LOC LOC
        ON LOC.LOC = IT.FROMLOC
  
INNER JOIN WMWHSE5.LOC TOLOC
        ON TOLOC.LOC = IT.TOLOC

 LEFT JOIN WMWHSE5.taskmanageruser tu 
        ON tu.userkey = IT.EDITWHO
    
INNER JOIN WMSADMIN.PL_DB    WMSADMIN
        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID
  
WHERE IT.QTY > 0
  AND IT.TRANTYPE = 'MV'
  AND IT.SOURCETYPE != 'PICKING'

  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataDe
          And :DataAte

GROUP BY WMSADMIN.DB_ALIAS,
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),
         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),
         IT.EDITWHO,
         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),
         LOC.PUTAWAYZONE,
         TOLOC.PUTAWAYZONE



=IIF(Parameters!Table.Value <> "AAA",

"SELECT                                                                  " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                       " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                 " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'DD')           " &
"                                          DATA,                         " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')         " &
"                                          HORA,                         " &
"  IT.EDITWHO                              OPERADOR,                     " &
"  subStr( tu.usr_name,4,                                                " &
"          inStr(tu.usr_name, ',') -4 )    NOME_OP,                      " &
"  COUNT(distinct IT.SKU)                  ITEM,                         " &
"  COUNT(distinct IT.FROMLOC)              LOCAL,                        " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                      " &
"  TOLOC.PUTAWAYZONE                       CLA_LOC_PARA,                 " &
"  SUM(IT.QTY)                             PECAS                         " &
"                                                                        " &
"FROM       " + Parameters!Table.Value + ".ITRN IT                       " &
"                                                                        " &
"INNER JOIN " + Parameters!Table.Value + ".LOC LOC                       " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN " + Parameters!Table.Value + ".LOC TOLOC                     " &
"        ON TOLOC.LOC = IT.TOLOC                                         " &
"                                                                        " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu            " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                   " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"                                                                        " &
"WHERE IT.QTY > 0                                                        " &
"  AND IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"              AT time zone 'America/Sao_Paulo') AS DATE))               " &
"      Between '" + Parameters!DataDe.Value + "'                         " &
"          And '" + Parameters!DataAte.Value + "'                        " &
"                                                                        " &
"GROUP BY WMSADMIN.DB_ALIAS,                                             " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,          " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,        " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.EDITWHO,                                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),           " &
"         LOC.PUTAWAYZONE,                                               " &
"         TOLOC.PUTAWAYZONE                                              " &
"                                                                        " &
"ORDER BY DATA                                                           "

,

"SELECT                                                                  " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                       " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                 " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'DD')           " &
"                                          DATA,                         " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')         " &
"                                          HORA,                         " &
"  IT.EDITWHO                              OPERADOR,                     " &
"  subStr( tu.usr_name,4,                                                " &
"          inStr(tu.usr_name, ',') -4 )    NOME_OP,                      " &
"  COUNT(distinct IT.SKU)                  ITEM,                         " &
"  COUNT(distinct IT.FROMLOC)              LOCAL,                        " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                      " &
"  TOLOC.PUTAWAYZONE                       CLA_LOC_PARA,                 " &
"  SUM(IT.QTY)                             PECAS                         " &
"                                                                        " &
"FROM       WMWHSE1.ITRN IT                                              " &
"                                                                        " &
"INNER JOIN WMWHSE1.LOC LOC                                              " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMWHSE1.LOC TOLOC                                            " &
"        ON TOLOC.LOC = IT.TOLOC                                         " &
"                                                                        " &
" LEFT JOIN WMWHSE1.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                   " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"                                                                        " &
"WHERE IT.QTY > 0                                                        " &
"  AND IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"              AT time zone 'America/Sao_Paulo') AS DATE))               " &
"      Between '" + Parameters!DataDe.Value + "'                         " &
"          And '" + Parameters!DataAte.Value + "'                        " &
"                                                                        " &
"GROUP BY WMSADMIN.DB_ALIAS,                                             " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,          " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,        " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.EDITWHO,                                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),           " &
"         LOC.PUTAWAYZONE,                                               " &
"         TOLOC.PUTAWAYZONE                                              " &
"                                                                        " &
"Union                                                                   " &
"                                                                        " &
"SELECT                                                                  " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                       " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                 " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'DD')           " &
"                                          DATA,                         " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')         " &
"                                          HORA,                         " &
"  IT.EDITWHO                              OPERADOR,                     " &
"  subStr( tu.usr_name,4,                                                " &
"          inStr(tu.usr_name, ',') -4 )    NOME_OP,                      " &
"  COUNT(distinct IT.SKU)                  ITEM,                         " &
"  COUNT(distinct IT.FROMLOC)              LOCAL,                        " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                      " &
"  TOLOC.PUTAWAYZONE                       CLA_LOC_PARA,                 " &
"  SUM(IT.QTY)                             PECAS                         " &
"                                                                        " &
"FROM       WMWHSE2.ITRN IT                                              " &
"                                                                        " &
"INNER JOIN WMWHSE2.LOC LOC                                              " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMWHSE2.LOC TOLOC                                            " &
"        ON TOLOC.LOC = IT.TOLOC                                         " &
"                                                                        " &
" LEFT JOIN WMWHSE2.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                   " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"                                                                        " &
"WHERE IT.QTY > 0                                                        " &
"  AND IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"              AT time zone 'America/Sao_Paulo') AS DATE))               " &
"      Between '" + Parameters!DataDe.Value + "'                         " &
"          And '" + Parameters!DataAte.Value + "'                        " &
"                                                                        " &
"GROUP BY WMSADMIN.DB_ALIAS,                                             " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,          " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,        " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.EDITWHO,                                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),           " &
"         LOC.PUTAWAYZONE,                                               " &
"         TOLOC.PUTAWAYZONE                                              " &
"                                                                        " &
"Union                                                                   " &
"                                                                        " &
"SELECT                                                                  " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                       " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                 " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'DD')           " &
"                                          DATA,                         " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')         " &
"                                          HORA,                         " &
"  IT.EDITWHO                              OPERADOR,                     " &
"  subStr( tu.usr_name,4,                                                " &
"          inStr(tu.usr_name, ',') -4 )    NOME_OP,                      " &
"  COUNT(distinct IT.SKU)                  ITEM,                         " &
"  COUNT(distinct IT.FROMLOC)              LOCAL,                        " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                      " &
"  TOLOC.PUTAWAYZONE                       CLA_LOC_PARA,                 " &
"  SUM(IT.QTY)                             PECAS                         " &
"                                                                        " &
"FROM       WMWHSE3.ITRN IT                                              " &
"                                                                        " &
"INNER JOIN WMWHSE3.LOC LOC                                              " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMWHSE3.LOC TOLOC                                            " &
"        ON TOLOC.LOC = IT.TOLOC                                         " &
"                                                                        " &
" LEFT JOIN WMWHSE3.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                   " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"                                                                        " &
"WHERE IT.QTY > 0                                                        " &
"  AND IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"              AT time zone 'America/Sao_Paulo') AS DATE))               " &
"      Between '" + Parameters!DataDe.Value + "'                         " &
"          And '" + Parameters!DataAte.Value + "'                        " &
"                                                                        " &
"GROUP BY WMSADMIN.DB_ALIAS,                                             " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,          " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,        " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.EDITWHO,                                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),           " &
"         LOC.PUTAWAYZONE,                                               " &
"         TOLOC.PUTAWAYZONE                                              " &
"                                                                        " &
"Union                                                                   " &
"                                                                        " &
"SELECT                                                                  " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                       " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                 " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'DD')           " &
"                                          DATA,                         " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')         " &
"                                          HORA,                         " &
"  IT.EDITWHO                              OPERADOR,                     " &
"  subStr( tu.usr_name,4,                                                " &
"          inStr(tu.usr_name, ',') -4 )    NOME_OP,                      " &
"  COUNT(distinct IT.SKU)                  ITEM,                         " &
"  COUNT(distinct IT.FROMLOC)              LOCAL,                        " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                      " &
"  TOLOC.PUTAWAYZONE                       CLA_LOC_PARA,                 " &
"  SUM(IT.QTY)                             PECAS                         " &
"                                                                        " &
"FROM       WMWHSE4.ITRN IT                                              " &
"                                                                        " &
"INNER JOIN WMWHSE4.LOC LOC                                              " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMWHSE4.LOC TOLOC                                            " &
"        ON TOLOC.LOC = IT.TOLOC                                         " &
"                                                                        " &
" LEFT JOIN WMWHSE4.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                   " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"                                                                        " &
"WHERE IT.QTY > 0                                                        " &
"  AND IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"              AT time zone 'America/Sao_Paulo') AS DATE))               " &
"      Between '" + Parameters!DataDe.Value + "'                         " &
"          And '" + Parameters!DataAte.Value + "'                        " &
"                                                                        " &
"GROUP BY WMSADMIN.DB_ALIAS,                                             " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,          " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,        " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.EDITWHO,                                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),           " &
"         LOC.PUTAWAYZONE,                                               " &
"         TOLOC.PUTAWAYZONE                                              " &
"                                                                        " &
"Union                                                                   " &
"                                                                        " &
"SELECT                                                                  " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                       " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                 " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'DD')           " &
"                                          DATA,                         " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')         " &
"                                          HORA,                         " &
"  IT.EDITWHO                              OPERADOR,                     " &
"  subStr( tu.usr_name,4,                                                " &
"          inStr(tu.usr_name, ',') -4 )    NOME_OP,                      " &
"  COUNT(distinct IT.SKU)                  ITEM,                         " &
"  COUNT(distinct IT.FROMLOC)              LOCAL,                        " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                      " &
"  TOLOC.PUTAWAYZONE                       CLA_LOC_PARA,                 " &
"  SUM(IT.QTY)                             PECAS                         " &
"                                                                        " &
"FROM       WMWHSE5.ITRN IT                                              " &
"                                                                        " &
"INNER JOIN WMWHSE5.LOC LOC                                              " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMWHSE5.LOC TOLOC                                            " &
"        ON TOLOC.LOC = IT.TOLOC                                         " &
"                                                                        " &
" LEFT JOIN WMWHSE5.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                   " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"                                                                        " &
"WHERE IT.QTY > 0                                                        " &
"  AND IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"              AT time zone 'America/Sao_Paulo') AS DATE))               " &
"      Between '" + Parameters!DataDe.Value + "'                         " &
"          And '" + Parameters!DataAte.Value + "'                        " &
"                                                                        " &
"GROUP BY WMSADMIN.DB_ALIAS,                                             " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,          " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,        " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.EDITWHO,                                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),           " &
"         LOC.PUTAWAYZONE,                                               " &
"         TOLOC.PUTAWAYZONE                                              " &
"                                                                        " &
"Union                                                                   " &
"                                                                        " &
"SELECT                                                                  " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                       " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                 " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'DD')           " &
"                                          DATA,                         " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')         " &
"                                          HORA,                         " &
"  IT.EDITWHO                              OPERADOR,                     " &
"  subStr( tu.usr_name,4,                                                " &
"          inStr(tu.usr_name, ',') -4 )    NOME_OP,                      " &
"  COUNT(distinct IT.SKU)                  ITEM,                         " &
"  COUNT(distinct IT.FROMLOC)              LOCAL,                        " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                      " &
"  TOLOC.PUTAWAYZONE                       CLA_LOC_PARA,                 " &
"  SUM(IT.QTY)                             PECAS                         " &
"                                                                        " &
"FROM       WMWHSE6.ITRN IT                                              " &
"                                                                        " &
"INNER JOIN WMWHSE6.LOC LOC                                              " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMWHSE6.LOC TOLOC                                            " &
"        ON TOLOC.LOC = IT.TOLOC                                         " &
"                                                                        " &
" LEFT JOIN WMWHSE6.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                   " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"                                                                        " &
"WHERE IT.QTY > 0                                                        " &
"  AND IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"              AT time zone 'America/Sao_Paulo') AS DATE))               " &
"      Between '" + Parameters!DataDe.Value + "'                         " &
"          And '" + Parameters!DataAte.Value + "'                        " &
"                                                                        " &
"GROUP BY WMSADMIN.DB_ALIAS,                                             " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,          " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,        " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.EDITWHO,                                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),           " &
"         LOC.PUTAWAYZONE,                                               " &
"         TOLOC.PUTAWAYZONE                                              " &
"                                                                        " &
"Union                                                                   " &
"                                                                        " &
"SELECT                                                                  " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                       " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                 " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'DD')           " &
"                                          DATA,                         " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')         " &
"                                          HORA,                         " &
"  IT.EDITWHO                              OPERADOR,                     " &
"  subStr( tu.usr_name,4,                                                " &
"          inStr(tu.usr_name, ',') -4 )    NOME_OP,                      " &
"  COUNT(distinct IT.SKU)                  ITEM,                         " &
"  COUNT(distinct IT.FROMLOC)              LOCAL,                        " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                      " &
"  TOLOC.PUTAWAYZONE                       CLA_LOC_PARA,                 " &
"  SUM(IT.QTY)                             PECAS                         " &
"                                                                        " &
"FROM       WMWHSE7.ITRN IT                                              " &
"                                                                        " &
"INNER JOIN WMWHSE7.LOC LOC                                              " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMWHSE7.LOC TOLOC                                            " &
"        ON TOLOC.LOC = IT.TOLOC                                         " &
"                                                                        " &
" LEFT JOIN WMWHSE7.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                   " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"                                                                        " &
"WHERE IT.QTY > 0                                                        " &
"  AND IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"              AT time zone 'America/Sao_Paulo') AS DATE))               " &
"      Between '" + Parameters!DataDe.Value + "'                         " &
"          And '" + Parameters!DataAte.Value + "'                        " &
"                                                                        " &
"GROUP BY WMSADMIN.DB_ALIAS,                                             " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,          " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,        " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.EDITWHO,                                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),           " &
"         LOC.PUTAWAYZONE,                                               " &
"         TOLOC.PUTAWAYZONE                                              " &
"                                                                        " &
"ORDER BY PLANTA, DATA                                                   "

)