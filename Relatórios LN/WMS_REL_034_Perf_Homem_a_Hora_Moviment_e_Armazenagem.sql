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
  IT.EDITWHO                      OPERADOR,
  subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',')-4 )   NOME_OP,
  COUNT(DISTINCT IT.SKU)                   ITEM,
  COUNT(distinct IT.FROMLOC)      LOCAL,
  LOC.PUTAWAYZONE                         CLA_LOC,
  TOLOC.PUTAWAYZONE                       CLA_LOC_PARA,
  SUM(IT.QTY)                     PECAS

FROM       WMWHSE5.ITRN IT

INNER JOIN WMWHSE5.LOC LOC
        ON LOC.LOC = IT.FROMLOC
		
INNER JOIN WMWHSE5.LOC TOLOC
        ON TOLOC.LOC = IT.TOLOC

 LEFT JOIN WMWHSE5.taskmanageruser tu 
        ON tu.userkey = IT.EDITWHO
    
INNER JOIN WMSADMIN.PL_DB    WMSADMIN
        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID
		
WHERE 	IT.QTY > 0
	AND IT.TRANTYPE = 'MV'
	AND IT.SOURCETYPE != 'PICKING'

  -- AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE, 
	    -- 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		  -- AT time zone 'America/Sao_Paulo') AS DATE))
      -- Between :DataDe
          -- And :DataAte

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


"SELECT                                                                   " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                        " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,          " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                     " &
"                                          DATA,                          " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,        " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                   " &
"                                          HORA,                          " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                      " &
"  subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                       " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                          " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                         " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                       " &
"  SUM(TASKDETAIL.QTY)                     PECAS                          " &
"                                                                         " &
"FROM       " + Parameters!Table.Value + ".LOC                            " &
"                                                                         " &
"INNER JOIN " + Parameters!Table.Value + ".TASKDETAIL                     " &
"        ON LOC.LOC = TASKDETAIL.FROMLOC                                  " &
"                                                                         " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu             " &
"        ON tu.userkey = TASKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                    " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                  " &
"		                                                                  " &
"WHERE TASKDETAIL.QTY > 0                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,      " &
"	    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"		  AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY WMSADMIN.DB_ALIAS,                                              " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,   " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),              " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE, " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),            " &
"         TASKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),            " &
"         LOC.PUTAWAYZONE                                                 " &
"ORDER BY DATA                                                            "

-- Query com UNION **********************************************************

"SELECT                                                                   " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                        " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,          " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                     " &
"                                          DATA,                          " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,        " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                   " &
"                                          HORA,                          " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                      " &
"  subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                       " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                          " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                         " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                       " &
"  SUM(TASKDETAIL.QTY)                     PECAS                          " &
"                                                                         " &
"FROM       WMWHSE1.LOC                                                   " &
"                                                                         " &
"INNER JOIN WMWHSE1.TASKDETAIL                                            " &
"        ON LOC.LOC = TASKDETAIL.FROMLOC                                  " &
"                                                                         " &
" LEFT JOIN WMWHSE1.taskmanageruser tu                                    " &
"        ON tu.userkey = TASKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                    " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                  " &
"		                                                                  " &
"WHERE TASKDETAIL.QTY > 0                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,      " &
"	    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"		  AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY WMSADMIN.DB_ALIAS,                                              " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,   " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),              " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE, " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),            " &
"         TASKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),            " &
"         LOC.PUTAWAYZONE                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                        " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,          " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                     " &
"                                          DATA,                          " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,        " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                   " &
"                                          HORA,                          " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                      " &
"  subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                       " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                          " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                         " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                       " &
"  SUM(TASKDETAIL.QTY)                     PECAS                          " &
"                                                                         " &
"FROM       WMWHSE2.LOC                                                   " &
"                                                                         " &
"INNER JOIN WMWHSE2.TASKDETAIL                                            " &
"        ON LOC.LOC = TASKDETAIL.FROMLOC                                  " &
"                                                                         " &
" LEFT JOIN WMWHSE2.taskmanageruser tu                                    " &
"        ON tu.userkey = TASKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                    " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                  " &
"		                                                                  " &
"WHERE TASKDETAIL.QTY > 0                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,      " &
"	    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"		  AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY WMSADMIN.DB_ALIAS,                                              " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,   " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),              " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE, " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),            " &
"         TASKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),            " &
"         LOC.PUTAWAYZONE                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                        " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,          " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                     " &
"                                          DATA,                          " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,        " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                   " &
"                                          HORA,                          " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                      " &
"  subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                       " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                          " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                         " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                       " &
"  SUM(TASKDETAIL.QTY)                     PECAS                          " &
"                                                                         " &
"FROM       WMWHSE3.LOC                                                   " &
"                                                                         " &
"INNER JOIN WMWHSE3.TASKDETAIL                                            " &
"        ON LOC.LOC = TASKDETAIL.FROMLOC                                  " &
"                                                                         " &
" LEFT JOIN WMWHSE3.taskmanageruser tu                                    " &
"        ON tu.userkey = TASKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                    " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                  " &
"		                                                                  " &
"WHERE TASKDETAIL.QTY > 0                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,      " &
"	    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"		  AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY WMSADMIN.DB_ALIAS,                                              " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,   " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),              " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE, " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),            " &
"         TASKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),            " &
"         LOC.PUTAWAYZONE                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                        " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,          " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                     " &
"                                          DATA,                          " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,        " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                   " &
"                                          HORA,                          " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                      " &
"  subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                       " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                          " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                         " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                       " &
"  SUM(TASKDETAIL.QTY)                     PECAS                          " &
"                                                                         " &
"FROM       WMWHSE4.LOC                                                   " &
"                                                                         " &
"INNER JOIN WMWHSE4.TASKDETAIL                                            " &
"        ON LOC.LOC = TASKDETAIL.FROMLOC                                  " &
"                                                                         " &
" LEFT JOIN WMWHSE4.taskmanageruser tu                                    " &
"        ON tu.userkey = TASKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                    " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                  " &
"		                                                                  " &
"WHERE TASKDETAIL.QTY > 0                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,      " &
"	    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"		  AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY WMSADMIN.DB_ALIAS,                                              " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,   " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),              " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE, " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),            " &
"         TASKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),            " &
"         LOC.PUTAWAYZONE                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                        " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,          " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                     " &
"                                          DATA,                          " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,        " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                   " &
"                                          HORA,                          " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                      " &
"  subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                       " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                          " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                         " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                       " &
"  SUM(TASKDETAIL.QTY)                     PECAS                          " &
"                                                                         " &
"FROM       WMWHSE5.LOC                                                   " &
"                                                                         " &
"INNER JOIN WMWHSE5.TASKDETAIL                                            " &
"        ON LOC.LOC = TASKDETAIL.FROMLOC                                  " &
"                                                                         " &
" LEFT JOIN WMWHSE5.taskmanageruser tu                                    " &
"        ON tu.userkey = TASKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                    " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                  " &
"		                                                                  " &
"WHERE TASKDETAIL.QTY > 0                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,      " &
"	    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"		  AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY WMSADMIN.DB_ALIAS,                                              " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,   " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),              " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE, " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),            " &
"         TASKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),            " &
"         LOC.PUTAWAYZONE                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                        " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,          " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                     " &
"                                          DATA,                          " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,        " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                   " &
"                                          HORA,                          " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                      " &
"  subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                       " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                          " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                         " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                       " &
"  SUM(TASKDETAIL.QTY)                     PECAS                          " &
"                                                                         " &
"FROM       WMWHSE6.LOC                                                   " &
"                                                                         " &
"INNER JOIN WMWHSE6.TASKDETAIL                                            " &
"        ON LOC.LOC = TASKDETAIL.FROMLOC                                  " &
"                                                                         " &
" LEFT JOIN WMWHSE6.taskmanageruser tu                                    " &
"        ON tu.userkey = TASKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                    " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                  " &
"		                                                                  " &
"WHERE TASKDETAIL.QTY > 0                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,      " &
"	    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"		  AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY WMSADMIN.DB_ALIAS,                                              " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,   " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),              " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE, " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),            " &
"         TASKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),            " &
"         LOC.PUTAWAYZONE                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  WMSADMIN.DB_ALIAS                       PLANTA,                        " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,          " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                     " &
"                                          DATA,                          " &
"  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,        " &
"	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"		AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                   " &
"                                          HORA,                          " &
"  TASKDETAIL.EDITWHO                      OPERADOR,                      " &
"  subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',')-4 )   NOME_OP,                       " &
"  COUNT(TASKDETAIL.SKU)                   ITEM,                          " &
"  COUNT(distinct TASKDETAIL.FROMLOC)      LOCAL,                         " &
"  LOC.PUTAWAYZONE                         CLA_LOC,                       " &
"  SUM(TASKDETAIL.QTY)                     PECAS                          " &
"                                                                         " &
"FROM       WMWHSE7.LOC                                                   " &
"                                                                         " &
"INNER JOIN WMWHSE7.TASKDETAIL                                            " &
"        ON LOC.LOC = TASKDETAIL.FROMLOC                                  " &
"                                                                         " &
" LEFT JOIN WMWHSE7.taskmanageruser tu                                    " &
"        ON tu.userkey = TASKDETAIL.EDITWHO                               " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB    WMSADMIN                                    " &
"        ON UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                  " &
"		                                                                  " &
"WHERE TASKDETAIL.QTY > 0                                                 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,      " &
"	    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')      " &
"		  AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY WMSADMIN.DB_ALIAS,                                              " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,   " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),              " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE, " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),            " &
"         TASKDETAIL.EDITWHO,                                             " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') -4 ),            " &
"         LOC.PUTAWAYZONE                                                 " &
"                                                                         " &
"ORDER BY PLANTA, DATA                                                    "
