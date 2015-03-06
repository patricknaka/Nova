SELECT  
  DISTINCT
    PD.whseid                                PLANTA,
    PL_DB.DB_ALIAS                           DSC_PLANTA,
    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')          
                                             DIA,
    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')      
                                             HORA,
    IT.ADDWHO                                OPERADOR,
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',') - 4 )    NOME_OP,
    loc.putawayzone                          GRUPO_CLASSE_LOCAL,
    count(distinct IT.sku)                            ITEM,    
    count(distinct IT.fromloc)               LOCAL,
    count(distinct PD.orderkey )             ORDEM_COL,
    sum(IT.qty)                              PECAS
    
FROM       WMWHSE5.PICKDETAIL PD

INNER JOIN WMWHSE5.ITRN IT
        ON IT.TRANTYPE = 'MV'
       AND IT.SOURCEKEY = PD.PICKDETAILKEY
       AND IT.SOURCETYPE = 'PICKING'
    
 LEFT JOIN WMWHSE5.taskmanageruser tu 
        ON tu.userkey = IT.ADDWHO
    
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)
  
INNER JOIN WMWHSE5.loc 
        ON loc.loc = IT.fromloc
  
WHERE PL_DB.ISACTIVE = 1
  AND PL_DB.DB_ENTERPRISE = 0

  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)) 
      Between :DataDe 
          And :DataAte
    
GROUP BY PD.whseid, 
         PL_DB.DB_ALIAS,
         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'), 
         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),
         IT.ADDWHO,
         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ), 
         loc.putawayzone
    
ORDER BY DSC_PLANTA, DIA



=IIF(Parameters!Table.Value <> "AAA",

"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                PLANTA,                     " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                 " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                             DIA,                        " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                             HORA,                       " &
"    IT.ADDWHO                                OPERADOR,                   " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                    " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,         " &
"    count(IT.sku)                            ITEM,                       " &
"    count(distinct IT.fromloc)               LOCAL,                      " &
"    count(distinct PD.orderkey )             ORDEM_COL,                  " &
"    sum(IT.qty)                              PECAS                       " &
"                                                                         " &
"FROM       " + Parameters!Table.Value + ".PICKDETAIL PD                  " &
"                                                                         " &
"INNER JOIN " + Parameters!Table.Value + ".ITRN IT                        " &
"        ON IT.TRANTYPE = 'MV'                                            " &
"       AND IT.SOURCEKEY = PD.PICKDETAILKEY                               " &
"       AND IT.SOURCETYPE = 'PICKING'                                     " &
"                                                                         " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu             " &
"        ON tu.userkey = IT.ADDWHO                                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)                      " &
"                                                                         " &
"INNER JOIN " + Parameters!Table.Value + ".loc                            " &
"        ON loc.loc = IT.fromloc                                          " &
"                                                                         " &
"WHERE PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),           " &
"         loc.putawayzone                                                 " &
"                                                                         " &
"ORDER BY DSC_PLANTA, DIA                                                 "

,

"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                PLANTA,                     " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                 " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                             DIA,                        " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                             HORA,                       " &
"    IT.ADDWHO                                OPERADOR,                   " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                    " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,         " &
"    count(IT.sku)                            ITEM,                       " &
"    count(distinct IT.fromloc)               LOCAL,                      " &
"    count(distinct PD.orderkey )             ORDEM_COL,                  " &
"    sum(IT.qty)                              PECAS                       " &
"                                                                         " &
"FROM       WMWHSE1.PICKDETAIL PD                                         " &
"                                                                         " &
"INNER JOIN WMWHSE1.ITRN IT                                               " &
"        ON IT.TRANTYPE = 'MV'                                            " &
"       AND IT.SOURCEKEY = PD.PICKDETAILKEY                               " &
"       AND IT.SOURCETYPE = 'PICKING'                                     " &
"                                                                         " &
" LEFT JOIN WMWHSE1.taskmanageruser tu                                    " &
"        ON tu.userkey = IT.ADDWHO                                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)                      " &
"                                                                         " &
"INNER JOIN WMWHSE1.loc                                                   " &
"        ON loc.loc = IT.fromloc                                          " &
"                                                                         " &
"WHERE PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),           " &
"         loc.putawayzone                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                PLANTA,                     " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                 " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                             DIA,                        " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                             HORA,                       " &
"    IT.ADDWHO                                OPERADOR,                   " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                    " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,         " &
"    count(IT.sku)                            ITEM,                       " &
"    count(distinct IT.fromloc)               LOCAL,                      " &
"    count(distinct PD.orderkey )             ORDEM_COL,                  " &
"    sum(IT.qty)                              PECAS                       " &
"                                                                         " &
"FROM       WMWHSE2.PICKDETAIL PD                                         " &
"                                                                         " &
"INNER JOIN WMWHSE2.ITRN IT                                               " &
"        ON IT.TRANTYPE = 'MV'                                            " &
"       AND IT.SOURCEKEY = PD.PICKDETAILKEY                               " &
"       AND IT.SOURCETYPE = 'PICKING'                                     " &
"                                                                         " &
" LEFT JOIN WMWHSE2.taskmanageruser tu                                    " &
"        ON tu.userkey = IT.ADDWHO                                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)                      " &
"                                                                         " &
"INNER JOIN WMWHSE2.loc                                                   " &
"        ON loc.loc = IT.fromloc                                          " &
"                                                                         " &
"WHERE PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),           " &
"         loc.putawayzone                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                PLANTA,                     " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                 " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                             DIA,                        " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                             HORA,                       " &
"    IT.ADDWHO                                OPERADOR,                   " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                    " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,         " &
"    count(IT.sku)                            ITEM,                       " &
"    count(distinct IT.fromloc)               LOCAL,                      " &
"    count(distinct PD.orderkey )             ORDEM_COL,                  " &
"    sum(IT.qty)                              PECAS                       " &
"                                                                         " &
"FROM       WMWHSE3.PICKDETAIL PD                                         " &
"                                                                         " &
"INNER JOIN WMWHSE3.ITRN IT                                               " &
"        ON IT.TRANTYPE = 'MV'                                            " &
"       AND IT.SOURCEKEY = PD.PICKDETAILKEY                               " &
"       AND IT.SOURCETYPE = 'PICKING'                                     " &
"                                                                         " &
" LEFT JOIN WMWHSE3.taskmanageruser tu                                    " &
"        ON tu.userkey = IT.ADDWHO                                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)                      " &
"                                                                         " &
"INNER JOIN WMWHSE3.loc                                                   " &
"        ON loc.loc = IT.fromloc                                          " &
"                                                                         " &
"WHERE PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),           " &
"         loc.putawayzone                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                PLANTA,                     " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                 " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                             DIA,                        " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                             HORA,                       " &
"    IT.ADDWHO                                OPERADOR,                   " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                    " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,         " &
"    count(IT.sku)                            ITEM,                       " &
"    count(distinct IT.fromloc)               LOCAL,                      " &
"    count(distinct PD.orderkey )             ORDEM_COL,                  " &
"    sum(IT.qty)                              PECAS                       " &
"                                                                         " &
"FROM       WMWHSE4.PICKDETAIL PD                                         " &
"                                                                         " &
"INNER JOIN WMWHSE4.ITRN IT                                               " &
"        ON IT.TRANTYPE = 'MV'                                            " &
"       AND IT.SOURCEKEY = PD.PICKDETAILKEY                               " &
"       AND IT.SOURCETYPE = 'PICKING'                                     " &
"                                                                         " &
" LEFT JOIN WMWHSE4.taskmanageruser tu                                    " &
"        ON tu.userkey = IT.ADDWHO                                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)                      " &
"                                                                         " &
"INNER JOIN WMWHSE4.loc                                                   " &
"        ON loc.loc = IT.fromloc                                          " &
"                                                                         " &
"WHERE PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),           " &
"         loc.putawayzone                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                PLANTA,                     " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                 " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                             DIA,                        " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                             HORA,                       " &
"    IT.ADDWHO                                OPERADOR,                   " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                    " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,         " &
"    count(IT.sku)                            ITEM,                       " &
"    count(distinct IT.fromloc)               LOCAL,                      " &
"    count(distinct PD.orderkey )             ORDEM_COL,                  " &
"    sum(IT.qty)                              PECAS                       " &
"                                                                         " &
"FROM       WMWHSE5.PICKDETAIL PD                                         " &
"                                                                         " &
"INNER JOIN WMWHSE5.ITRN IT                                               " &
"        ON IT.TRANTYPE = 'MV'                                            " &
"       AND IT.SOURCEKEY = PD.PICKDETAILKEY                               " &
"       AND IT.SOURCETYPE = 'PICKING'                                     " &
"                                                                         " &
" LEFT JOIN WMWHSE5.taskmanageruser tu                                    " &
"        ON tu.userkey = IT.ADDWHO                                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)                      " &
"                                                                         " &
"INNER JOIN WMWHSE5.loc                                                   " &
"        ON loc.loc = IT.fromloc                                          " &
"                                                                         " &
"WHERE PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),           " &
"         loc.putawayzone                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                PLANTA,                     " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                 " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                             DIA,                        " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                             HORA,                       " &
"    IT.ADDWHO                                OPERADOR,                   " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                    " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,         " &
"    count(IT.sku)                            ITEM,                       " &
"    count(distinct IT.fromloc)               LOCAL,                      " &
"    count(distinct PD.orderkey )             ORDEM_COL,                  " &
"    sum(IT.qty)                              PECAS                       " &
"                                                                         " &
"FROM       WMWHSE6.PICKDETAIL PD                                         " &
"                                                                         " &
"INNER JOIN WMWHSE6.ITRN IT                                               " &
"        ON IT.TRANTYPE = 'MV'                                            " &
"       AND IT.SOURCEKEY = PD.PICKDETAILKEY                               " &
"       AND IT.SOURCETYPE = 'PICKING'                                     " &
"                                                                         " &
" LEFT JOIN WMWHSE6.taskmanageruser tu                                    " &
"        ON tu.userkey = IT.ADDWHO                                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)                      " &
"                                                                         " &
"INNER JOIN WMWHSE6.loc                                                   " &
"        ON loc.loc = IT.fromloc                                          " &
"                                                                         " &
"WHERE PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),           " &
"         loc.putawayzone                                                 " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                PLANTA,                     " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,                 " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                             DIA,                        " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                             HORA,                       " &
"    IT.ADDWHO                                OPERADOR,                   " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,                    " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,         " &
"    count(IT.sku)                            ITEM,                       " &
"    count(distinct IT.fromloc)               LOCAL,                      " &
"    count(distinct PD.orderkey )             ORDEM_COL,                  " &
"    sum(IT.qty)                              PECAS                       " &
"                                                                         " &
"FROM       WMWHSE7.PICKDETAIL PD                                         " &
"                                                                         " &
"INNER JOIN WMWHSE7.ITRN IT                                               " &
"        ON IT.TRANTYPE = 'MV'                                            " &
"       AND IT.SOURCEKEY = PD.PICKDETAILKEY                               " &
"       AND IT.SOURCETYPE = 'PICKING'                                     " &
"                                                                         " &
" LEFT JOIN WMWHSE7.taskmanageruser tu                                    " &
"        ON tu.userkey = IT.ADDWHO                                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)                      " &
"                                                                         " &
"INNER JOIN WMWHSE7.loc                                                   " &
"        ON loc.loc = IT.fromloc                                          " &
"                                                                         " &
"WHERE PL_DB.ISACTIVE = 1                                                 " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                      " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),           " &
"         loc.putawayzone                                                 " &
"                                                                         " &
"ORDER BY DSC_PLANTA, DIA                                                 "

)