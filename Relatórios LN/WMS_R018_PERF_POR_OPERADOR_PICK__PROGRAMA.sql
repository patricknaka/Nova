SELECT                                                                       
  DISTINCT                                                                   
    PD.whseid                                   PLANTA,                      
    PL_DB.DB_ALIAS                              DSC_PLANTA,                  
    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')             
                                                DIA,                         
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')         
                                                HORA,                        
    IT.ADDWHO                                   OPERADOR,                    
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                              
    PD.wavekey                                  PROGRAMA,                    
    COUNT(DISTINCT PD.orderkey)                 PEDIDOS,                     
    COUNT(IT.sku)                               ITEM,                        
    LOC.LOGICALLOCATION                         ORDEM_COL,
    SUM(IT.qty)                                 PEÇAS,                      
    min(PD.ORDERKEY)                            PEDIDO_HOST                  

FROM       WMWHSE5.PICKDETAIL PD

INNER JOIN WMWHSE5.ITRN IT
        ON IT.TRANTYPE = 'MV'
       AND IT.SOURCEKEY = PD.PICKDETAILKEY
       AND IT.SOURCETYPE = 'PICKING'         

 LEFT JOIN WMWHSE5.taskmanageruser tu 
        ON tu.userkey = IT.ADDWHO
    
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)

INNER JOIN WMWHSE5.LOC
        ON LOC.LOC = IT.FROMLOC

WHERE   PL_DB.ISACTIVE = 1                                                     
  AND PL_DB.DB_ENTERPRISE = 0                                                

  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)) 
--     Between :DataDe 
--         And :DataAte

GROUP BY PD.whseid,                                                  
         PL_DB.DB_ALIAS,                                                     
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),
         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'), 
         IT.ADDWHO,                                                  
         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ), 
         PD.wavekey, 
         LOC.LOGICALLOCATION         
   
ORDER BY 2


=IIF(Parameters!Table.Value <> "AAA",

"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                   PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                                HORA,                    " &
"    IT.ADDWHO                                   OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    PD.wavekey                                  PROGRAMA,                " &
"    COUNT(DISTINCT PD.orderkey)                 PEDIDOS,                 " &
"    COUNT(IT.sku)                               ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(IT.qty)                                 PEÇAS,                   " &
"    min(PD.ORDERKEY)                            PEDIDO_HOST              " &
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
"INNER JOIN " + Parameters!Table.Value + ".LOC                            " &
"        ON LOC.LOC = IT.FROMLOC                                          " &
"                                                                         " &
"WHERE   PL_DB.ISACTIVE = 1                                               " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         PD.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                             " &
"ORDER BY DSC_PLANTA                                                      "

,

"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                   PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                                HORA,                    " &
"    IT.ADDWHO                                   OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    PD.wavekey                                  PROGRAMA,                " &
"    COUNT(DISTINCT PD.orderkey)                 PEDIDOS,                 " &
"    COUNT(IT.sku)                               ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(IT.qty)                                 PEÇAS,                   " &
"    min(PD.ORDERKEY)                            PEDIDO_HOST              " &
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
"INNER JOIN WMWHSE1.LOC                                                   " &
"        ON LOC.LOC = IT.FROMLOC                                          " &
"                                                                         " &
"WHERE   PL_DB.ISACTIVE = 1                                               " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         PD.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                             " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                   PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                                HORA,                    " &
"    IT.ADDWHO                                   OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    PD.wavekey                                  PROGRAMA,                " &
"    COUNT(DISTINCT PD.orderkey)                 PEDIDOS,                 " &
"    COUNT(IT.sku)                               ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(IT.qty)                                 PEÇAS,                   " &
"    min(PD.ORDERKEY)                            PEDIDO_HOST              " &
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
"INNER JOIN WMWHSE2.LOC                                                   " &
"        ON LOC.LOC = IT.FROMLOC                                          " &
"                                                                         " &
"WHERE   PL_DB.ISACTIVE = 1                                               " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         PD.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                             " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                   PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                                HORA,                    " &
"    IT.ADDWHO                                   OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    PD.wavekey                                  PROGRAMA,                " &
"    COUNT(DISTINCT PD.orderkey)                 PEDIDOS,                 " &
"    COUNT(IT.sku)                               ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(IT.qty)                                 PEÇAS,                   " &
"    min(PD.ORDERKEY)                            PEDIDO_HOST              " &
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
"INNER JOIN WMWHSE3.LOC                                                   " &
"        ON LOC.LOC = IT.FROMLOC                                          " &
"                                                                         " &
"WHERE   PL_DB.ISACTIVE = 1                                               " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         PD.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                             " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                   PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                                HORA,                    " &
"    IT.ADDWHO                                   OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    PD.wavekey                                  PROGRAMA,                " &
"    COUNT(DISTINCT PD.orderkey)                 PEDIDOS,                 " &
"    COUNT(IT.sku)                               ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(IT.qty)                                 PEÇAS,                   " &
"    min(PD.ORDERKEY)                            PEDIDO_HOST              " &
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
"INNER JOIN WMWHSE4.LOC                                                   " &
"        ON LOC.LOC = IT.FROMLOC                                          " &
"                                                                         " &
"WHERE   PL_DB.ISACTIVE = 1                                               " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         PD.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                             " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                   PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                                HORA,                    " &
"    IT.ADDWHO                                   OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    PD.wavekey                                  PROGRAMA,                " &
"    COUNT(DISTINCT PD.orderkey)                 PEDIDOS,                 " &
"    COUNT(IT.sku)                               ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(IT.qty)                                 PEÇAS,                   " &
"    min(PD.ORDERKEY)                            PEDIDO_HOST              " &
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
"INNER JOIN WMWHSE5.LOC                                                   " &
"        ON LOC.LOC = IT.FROMLOC                                          " &
"                                                                         " &
"WHERE   PL_DB.ISACTIVE = 1                                               " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         PD.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                             " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                   PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                                HORA,                    " &
"    IT.ADDWHO                                   OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    PD.wavekey                                  PROGRAMA,                " &
"    COUNT(DISTINCT PD.orderkey)                 PEDIDOS,                 " &
"    COUNT(IT.sku)                               ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(IT.qty)                                 PEÇAS,                   " &
"    min(PD.ORDERKEY)                            PEDIDO_HOST              " &
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
"INNER JOIN WMWHSE6.LOC                                                   " &
"        ON LOC.LOC = IT.FROMLOC                                          " &
"                                                                         " &
"WHERE   PL_DB.ISACTIVE = 1                                               " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         PD.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                             " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PD.whseid                                   PLANTA,                  " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,              " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                " &
"                                                DIA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')              " &
"                                                HORA,                    " &
"    IT.ADDWHO                                   OPERADOR,                " &
"    subStr( tu.usr_name,4,                                               " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                 " &
"    PD.wavekey                                  PROGRAMA,                " &
"    COUNT(DISTINCT PD.orderkey)                 PEDIDOS,                 " &
"    COUNT(IT.sku)                               ITEM,                    " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,               " &
"    SUM(IT.qty)                                 PEÇAS,                   " &
"    min(PD.ORDERKEY)                            PEDIDO_HOST              " &
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
"INNER JOIN WMWHSE7.LOC                                                   " &
"        ON LOC.LOC = IT.FROMLOC                                          " &
"                                                                         " &
"WHERE   PL_DB.ISACTIVE = 1                                               " &
"  AND PL_DB.DB_ENTERPRISE = 0                                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,               " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"      Between '" + Parameters!DataDe.Value + "'                          " &
"          And '" + Parameters!DataAte.Value + "'                         " &
"                                                                         " &
"GROUP BY PD.whseid,                                                      " &
"         PL_DB.DB_ALIAS,                                                 " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,            " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),         " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE,          " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),       " &
"         IT.ADDWHO,                                                      " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),          " &
"         PD.wavekey,                                                     " &
"         LOC.LOGICALLOCATION                                             " &
"                                                                         " &
"ORDER BY DSC_PLANTA, DIA                                                   "

)