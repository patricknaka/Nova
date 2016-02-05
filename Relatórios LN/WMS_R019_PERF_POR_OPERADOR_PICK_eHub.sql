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
    count(distinct IT.sku)                   ITEM,    
    count(distinct IT.fromloc)               LOCAL,
    count(distinct PD.orderkey )             QTDE_ORDEM_COL,
    sum(IT.qty)                              PECAS,
    COUNT(DISTINCT PD.orderkey)              PEDIDOS,
    PD.wavekey                               PROGRAMA,
    IT.FROMLOC                               ORDEM_COL,
    PD.ORDERKEY                              PEDIDO_HOST
 
    
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
         loc.putawayzone,
         PD.wavekey,
         IT.FROMLOC,
         PD.ORDERKEY

ORDER BY DSC_PLANTA, DIA



=IIF(Parameters!Table.Value <> "AAA",

"SELECT  " &
"  DISTINCT  " &
"    PD.whseid                                PLANTA,  " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')  " &
"                                             DIA,  " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  " &
"                                             HORA,  " &
"    IT.ADDWHO                                OPERADOR,  " &
"    subStr( tu.usr_name,4,  " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,  " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,  " &
"    count(distinct IT.sku)                   ITEM,  " &
"    count(distinct IT.fromloc)               LOCAL,  " &
"    count(distinct PD.orderkey )             QTDE_ORDEM_COL,  " &
"    sum(IT.qty)                              PECAS,  " &
"    COUNT(DISTINCT PD.orderkey)              PEDIDOS,  " &
"    PD.wavekey                               PROGRAMA,  " &
"    IT.FROMLOC                               ORDEM_COL,  " &
"    PD.ORDERKEY                              PEDIDO_HOST  " &
"  " &
"FROM       " + Parameters!Table.Value + ".PICKDETAIL PD  " &
"  " &
"INNER JOIN " + Parameters!Table.Value + ".ITRN IT  " &
"        ON IT.TRANTYPE = 'MV'  " &
"       AND IT.SOURCEKEY = PD.PICKDETAILKEY  " &
"       AND IT.SOURCETYPE = 'PICKING'  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu  " &
"        ON tu.userkey = IT.ADDWHO  " &
"  " &
"INNER JOIN WMSADMIN.PL_DB  " &
"        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)  " &
"  " &
"INNER JOIN " + Parameters!Table.Value + ".loc  " &
"        ON loc.loc = IT.fromloc  " &
"  " &
"WHERE PL_DB.ISACTIVE = 1  " &
"  AND PL_DB.DB_ENTERPRISE = 0  " &
"  " &
"  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataDe.Value + "'  " &
"          And '" + Parameters!DataAte.Value + "'  " &
"  " &
"GROUP BY PD.whseid,  " &
"         PL_DB.DB_ALIAS,  " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),  " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),  " &
"         IT.ADDWHO,  " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),  " &
"         loc.putawayzone,  " &
"         PD.wavekey,  " &
"         IT.FROMLOC,  " &
"         PD.ORDERKEY  " &
"  " &
"ORDER BY DSC_PLANTA, DIA                                                 "

,


"SELECT  " &
"  DISTINCT  " &
"    PD.whseid                                PLANTA,  " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')  " &
"                                             DIA,  " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  " &
"                                             HORA,  " &
"    IT.ADDWHO                                OPERADOR,  " &
"    subStr( tu.usr_name,4,  " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,  " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,  " &
"    count(distinct IT.sku)                   ITEM,  " &
"    count(distinct IT.fromloc)               LOCAL,  " &
"    count(distinct PD.orderkey )             QTDE_ORDEM_COL,  " &
"    sum(IT.qty)                              PECAS,  " &
"    COUNT(DISTINCT PD.orderkey)              PEDIDOS,  " &
"    PD.wavekey                               PROGRAMA,  " &
"    IT.FROMLOC                               ORDEM_COL,  " &
"    PD.ORDERKEY                              PEDIDO_HOST  " &
"  " &
"FROM       WMWHSE9.PICKDETAIL PD  " &
"  " &
"INNER JOIN WMWHSE9.ITRN IT  " &
"        ON IT.TRANTYPE = 'MV'  " &
"       AND IT.SOURCEKEY = PD.PICKDETAILKEY  " &
"       AND IT.SOURCETYPE = 'PICKING'  " &
"  " &
" LEFT JOIN WMWHSE9.taskmanageruser tu  " &
"        ON tu.userkey = IT.ADDWHO  " &
"  " &
"INNER JOIN WMSADMIN.PL_DB  " &
"        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)  " &
"  " &
"INNER JOIN WMWHSE9.loc  " &
"        ON loc.loc = IT.fromloc  " &
"  " &
"WHERE PL_DB.ISACTIVE = 1  " &
"  AND PL_DB.DB_ENTERPRISE = 0  " &
"  " &
"  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataDe.Value + "'  " &
"          And '" + Parameters!DataAte.Value + "'  " &
"  " &
"GROUP BY PD.whseid,  " &
"         PL_DB.DB_ALIAS,  " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),  " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),  " &
"         IT.ADDWHO,  " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),  " &
"         loc.putawayzone,  " &
"         PD.wavekey,  " &
"         IT.FROMLOC,  " &
"         PD.ORDERKEY  " &
"  " &
"Union  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    PD.whseid                                PLANTA,  " &
"    PL_DB.DB_ALIAS                           DSC_PLANTA,  " &
"    trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')  " &
"                                             DIA,  " &
"    to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  " &
"                                             HORA,  " &
"    IT.ADDWHO                                OPERADOR,  " &
"    subStr( tu.usr_name,4,  " &
"            inStr(tu.usr_name, ',') - 4 )    NOME_OP,  " &
"    loc.putawayzone                          GRUPO_CLASSE_LOCAL,  " &
"    count(distinct IT.sku)                   ITEM,  " &
"    count(distinct IT.fromloc)               LOCAL,  " &
"    count(distinct PD.orderkey )             ORDEM_COL,  " &
"    sum(IT.qty)                              PECAS,  " &
"    COUNT(DISTINCT PD.orderkey)              PEDIDOS,  " &
"    PD.wavekey                               PROGRAMA,  " &
"    IT.FROMLOC                               ORDEM_COL,  " &
"    PD.ORDERKEY                              PEDIDO_HOST  " &
"  " &
"FROM       WMWHSE10.PICKDETAIL PD  " &
"  " &
"INNER JOIN WMWHSE10.ITRN IT  " &
"        ON IT.TRANTYPE = 'MV'  " &
"       AND IT.SOURCEKEY = PD.PICKDETAILKEY  " &
"       AND IT.SOURCETYPE = 'PICKING'  " &
"  " &
" LEFT JOIN WMWHSE10.taskmanageruser tu  " &
"        ON tu.userkey = IT.ADDWHO  " &
"  " &
"INNER JOIN WMSADMIN.PL_DB  " &
"        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)  " &
"  " &
"INNER JOIN WMWHSE10.loc  " &
"        ON loc.loc = IT.fromloc  " &
"  " &
"WHERE PL_DB.ISACTIVE = 1  " &
"  AND PL_DB.DB_ENTERPRISE = 0  " &
"  " &
"  AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataDe.Value + "'  " &
"          And '" + Parameters!DataAte.Value + "'  " &
"  " &
"GROUP BY PD.whseid,  " &
"         PL_DB.DB_ALIAS,  " &
"         trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),  " &
"         to_char(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),  " &
"         IT.ADDWHO,  " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',') - 4 ),  " &
"         loc.putawayzone,  " &
"         PD.wavekey,  " &
"         IT.FROMLOC,  " &
"         PD.ORDERKEY  " &
"  " &
"ORDER BY DSC_PLANTA, DIA "

)