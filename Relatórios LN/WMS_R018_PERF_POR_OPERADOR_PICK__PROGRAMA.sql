SELECT                                                                       
  DISTINCT                                                                   
    PD.whseid                           PLANTA,                      
    PL_DB.DB_ALIAS                              DSC_PLANTA,                  
    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')             
                                                DIA,                         
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')         
                                                HORA,                        
    IT.ADDWHO                         OPERADOR,                    
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                              
    PD.wavekey                          PROGRAMA,                    
    COUNT(DISTINCT PD.orderkey)         PEDIDOS,                     
    COUNT(IT.sku)                       ITEM,                        
    LOC.LOGICALLOCATION                         ORDEM_COL,
    SUM(IT.qty)                         PEÇAS,                      
    min(PD.ORDERKEY)                    PEDIDO_HOST                  

FROM       WMWHSE5.PICKDETAIL PD

INNER JOIN WMWHSE5.ITRN	IT
        ON 	IT.TRANTYPE	=	'MV'
		AND	IT.SOURCEKEY = PD.PICKDETAILKEY
		AND	IT.SOURCETYPE = 'PICKING'         


 LEFT JOIN WMWHSE5.taskmanageruser tu 
        ON tu.userkey = IT.ADDWHO
    
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(PL_DB.db_logid) = UPPER(PD.whseid)

INNER JOIN WMWHSE5.LOC
        ON LOC.LOC = IT.FROMLOC

-- WHERE taskdetail.status = 9                                                  
  -- AND taskdetail.tasktype = 'PK'                                             
WHERE   PL_DB.ISACTIVE = 1                                                     
  AND PL_DB.DB_ENTERPRISE = 0                                                

 AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
       AT time zone 'America/Sao_Paulo') AS DATE)) 
--     Between :DataDe 
--         And :DataAte

      Between TO_DATE('05/03/2015 00:00:00','DD/MM/YYYY HH24:MI:SS') 
          And TO_DATE('05/03/2015 23:59:59','DD/MM/YYYY HH24:MI:SS')  
    AND IT.ADDWHO = 'bianca.gimenes'--'diego.cardoso'--'c603789'

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

"SELECT                                                                     " &
"  DISTINCT                                                                 " &
"    taskdetail.whseid                           PLANTA,                    " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,           " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                  " &
"                                                DIA,                       " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                " &
"                                                HORA,                      " &
"    USERACTIVITY.USERID                         OPERADOR,                  " &
"    subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                   " &
"    taskdetail.wavekey                          PROGRAMA,                  " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                   " &
"    COUNT(taskdetail.sku)                       ITEM,                      " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                 " &
"    SUM(taskdetail.qty)                         PEÇAS,                     " &
"    min(TASKDETAIL.ORDERKEY)                    PEDIDO_HOST                " &
"                                                                           " &
"FROM       " + Parameters!Table.Value + ".taskdetail                       " &
"                                                                           " &
"INNER JOIN " + Parameters!Table.Value + ".USERACTIVITY                     " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY           " &
"                                                                           " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu               " &
"        ON tu.userkey = USERACTIVITY.USERID                                " &
"                                                                           " &
"INNER JOIN WMSADMIN.PL_DB                                                  " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                " &
"                                                                           " &
"INNER JOIN " + Parameters!Table.Value + ".LOC                              " &
"        ON LOC.LOC = taskdetail.FROMLOC                                    " &
"                                                                           " &
"WHERE taskdetail.status = 9                                                " &
"  AND taskdetail.tasktype = 'PK'                                           " &
"  AND PL_DB.ISACTIVE = 1                                                   " &
"  AND PL_DB.DB_ENTERPRISE = 0                                              " &
"                                                                           " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"     Between '" + Parameters!DataDe.Value + "'                             " &
"         And '" + Parameters!DataAte.Value + "'                            " &
"                                                                           " &
"GROUP BY taskdetail.whseid,                                                " &
"         PL_DB.DB_ALIAS,                                                   " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,      " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),           " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),         " &
"         USERACTIVITY.USERID,                                              " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),            " &
"         taskdetail.wavekey,                                               " &
"         LOC.LOGICALLOCATION                                               " &
"ORDER BY DSC_PLANTA                                                        "

,

"SELECT                                                                     " &
"  DISTINCT                                                                 " &
"    taskdetail.whseid                           PLANTA,                    " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,           " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                  " &
"                                                DIA,                       " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                " &
"                                                HORA,                      " &
"    USERACTIVITY.USERID                         OPERADOR,                  " &
"    subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                   " &
"    taskdetail.wavekey                          PROGRAMA,                  " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                   " &
"    COUNT(taskdetail.sku)                       ITEM,                      " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                 " &
"    SUM(taskdetail.qty)                         PEÇAS,                     " &
"    min(TASKDETAIL.ORDERKEY)                    PEDIDO_HOST                " &
"                                                                           " &
"FROM       WMWHSE1.taskdetail                                              " &
"                                                                           " &
"INNER JOIN WMWHSE1.USERACTIVITY                                            " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY           " &
"                                                                           " &
" LEFT JOIN WMWHSE1.taskmanageruser tu                                      " &
"        ON tu.userkey = USERACTIVITY.USERID                                " &
"                                                                           " &
"INNER JOIN WMSADMIN.PL_DB                                                  " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                " &
"                                                                           " &
"INNER JOIN WMWHSE1.LOC                                                     " &
"        ON LOC.LOC = taskdetail.FROMLOC                                    " &
"                                                                           " &
"WHERE taskdetail.status = 9                                                " &
"  AND taskdetail.tasktype = 'PK'                                           " &
"  AND PL_DB.ISACTIVE = 1                                                   " &
"  AND PL_DB.DB_ENTERPRISE = 0                                              " &
"                                                                           " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"     Between '" + Parameters!DataDe.Value + "'                             " &
"         And '" + Parameters!DataAte.Value + "'                            " &
"                                                                           " &
"GROUP BY taskdetail.whseid,                                                " &
"         PL_DB.DB_ALIAS,                                                   " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,      " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),           " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),         " &
"         USERACTIVITY.USERID,                                              " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),            " &
"         taskdetail.wavekey,                                               " &
"         LOC.LOGICALLOCATION                                               " &
"                                                                           " &
"Union                                                                      " &
"                                                                           " &
"SELECT                                                                     " &
"  DISTINCT                                                                 " &
"    taskdetail.whseid                           PLANTA,                    " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,           " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                  " &
"                                                DIA,                       " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                " &
"                                                HORA,                      " &
"    USERACTIVITY.USERID                         OPERADOR,                  " &
"    subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                   " &
"    taskdetail.wavekey                          PROGRAMA,                  " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                   " &
"    COUNT(taskdetail.sku)                       ITEM,                      " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                 " &
"    SUM(taskdetail.qty)                         PEÇAS,                     " &
"    min(TASKDETAIL.ORDERKEY)                    PEDIDO_HOST                " &
"                                                                           " &
"FROM       WMWHSE2.taskdetail                                              " &
"                                                                           " &
"INNER JOIN WMWHSE2.USERACTIVITY                                            " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY           " &
"                                                                           " &
" LEFT JOIN WMWHSE2.taskmanageruser tu                                      " &
"        ON tu.userkey = USERACTIVITY.USERID                                " &
"                                                                           " &
"INNER JOIN WMSADMIN.PL_DB                                                  " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                " &
"                                                                           " &
"INNER JOIN WMWHSE2.LOC                                                     " &
"        ON LOC.LOC = taskdetail.FROMLOC                                    " &
"                                                                           " &
"WHERE taskdetail.status = 9                                                " &
"  AND taskdetail.tasktype = 'PK'                                           " &
"  AND PL_DB.ISACTIVE = 1                                                   " &
"  AND PL_DB.DB_ENTERPRISE = 0                                              " &
"                                                                           " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"     Between '" + Parameters!DataDe.Value + "'                             " &
"         And '" + Parameters!DataAte.Value + "'                            " &
"                                                                           " &
"GROUP BY taskdetail.whseid,                                                " &
"         PL_DB.DB_ALIAS,                                                   " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,      " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),           " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),         " &
"         USERACTIVITY.USERID,                                              " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),            " &
"         taskdetail.wavekey,                                               " &
"         LOC.LOGICALLOCATION                                               " &
"                                                                           " &
"Union                                                                      " &
"                                                                           " &
"SELECT                                                                     " &
"  DISTINCT                                                                 " &
"    taskdetail.whseid                           PLANTA,                    " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,           " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                  " &
"                                                DIA,                       " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                " &
"                                                HORA,                      " &
"    USERACTIVITY.USERID                         OPERADOR,                  " &
"    subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                   " &
"    taskdetail.wavekey                          PROGRAMA,                  " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                   " &
"    COUNT(taskdetail.sku)                       ITEM,                      " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                 " &
"    SUM(taskdetail.qty)                         PEÇAS,                     " &
"    min(TASKDETAIL.ORDERKEY)                    PEDIDO_HOST                " &
"                                                                           " &
"FROM       WMWHSE3.taskdetail                                              " &
"                                                                           " &
"INNER JOIN WMWHSE3.USERACTIVITY                                            " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY           " &
"                                                                           " &
" LEFT JOIN WMWHSE3.taskmanageruser tu                                      " &
"        ON tu.userkey = USERACTIVITY.USERID                                " &
"                                                                           " &
"INNER JOIN WMSADMIN.PL_DB                                                  " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                " &
"                                                                           " &
"INNER JOIN WMWHSE3.LOC                                                     " &
"        ON LOC.LOC = taskdetail.FROMLOC                                    " &
"                                                                           " &
"WHERE taskdetail.status = 9                                                " &
"  AND taskdetail.tasktype = 'PK'                                           " &
"  AND PL_DB.ISACTIVE = 1                                                   " &
"  AND PL_DB.DB_ENTERPRISE = 0                                              " &
"                                                                           " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"     Between '" + Parameters!DataDe.Value + "'                             " &
"         And '" + Parameters!DataAte.Value + "'                            " &
"                                                                           " &
"GROUP BY taskdetail.whseid,                                                " &
"         PL_DB.DB_ALIAS,                                                   " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,      " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),           " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),         " &
"         USERACTIVITY.USERID,                                              " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),            " &
"         taskdetail.wavekey,                                               " &
"         LOC.LOGICALLOCATION                                               " &
"                                                                           " &
"Union                                                                      " &
"                                                                           " &
"SELECT                                                                     " &
"  DISTINCT                                                                 " &
"    taskdetail.whseid                           PLANTA,                    " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,           " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                  " &
"                                                DIA,                       " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                " &
"                                                HORA,                      " &
"    USERACTIVITY.USERID                         OPERADOR,                  " &
"    subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                   " &
"    taskdetail.wavekey                          PROGRAMA,                  " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                   " &
"    COUNT(taskdetail.sku)                       ITEM,                      " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                 " &
"    SUM(taskdetail.qty)                         PEÇAS,                     " &
"    min(TASKDETAIL.ORDERKEY)                    PEDIDO_HOST                " &
"                                                                           " &
"FROM       WMWHSE4.taskdetail                                              " &
"                                                                           " &
"INNER JOIN WMWHSE4.USERACTIVITY                                            " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY           " &
"                                                                           " &
" LEFT JOIN WMWHSE4.taskmanageruser tu                                      " &
"        ON tu.userkey = USERACTIVITY.USERID                                " &
"                                                                           " &
"INNER JOIN WMSADMIN.PL_DB                                                  " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                " &
"                                                                           " &
"INNER JOIN WMWHSE4.LOC                                                     " &
"        ON LOC.LOC = taskdetail.FROMLOC                                    " &
"                                                                           " &
"WHERE taskdetail.status = 9                                                " &
"  AND taskdetail.tasktype = 'PK'                                           " &
"  AND PL_DB.ISACTIVE = 1                                                   " &
"  AND PL_DB.DB_ENTERPRISE = 0                                              " &
"                                                                           " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"     Between '" + Parameters!DataDe.Value + "'                             " &
"         And '" + Parameters!DataAte.Value + "'                            " &
"                                                                           " &
"GROUP BY taskdetail.whseid,                                                " &
"         PL_DB.DB_ALIAS,                                                   " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,      " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),           " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),         " &
"         USERACTIVITY.USERID,                                              " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),            " &
"         taskdetail.wavekey,                                               " &
"         LOC.LOGICALLOCATION                                               " &
"                                                                           " &
"Union                                                                      " &
"                                                                           " &
"SELECT                                                                     " &
"  DISTINCT                                                                 " &
"    taskdetail.whseid                           PLANTA,                    " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,           " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                  " &
"                                                DIA,                       " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                " &
"                                                HORA,                      " &
"    USERACTIVITY.USERID                         OPERADOR,                  " &
"    subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                   " &
"    taskdetail.wavekey                          PROGRAMA,                  " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                   " &
"    COUNT(taskdetail.sku)                       ITEM,                      " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                 " &
"    SUM(taskdetail.qty)                         PEÇAS,                     " &
"    min(TASKDETAIL.ORDERKEY)                    PEDIDO_HOST                " &
"                                                                           " &
"FROM       WMWHSE5.taskdetail                                              " &
"                                                                           " &
"INNER JOIN WMWHSE5.USERACTIVITY                                            " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY           " &
"                                                                           " &
" LEFT JOIN WMWHSE5.taskmanageruser tu                                      " &
"        ON tu.userkey = USERACTIVITY.USERID                                " &
"                                                                           " &
"INNER JOIN WMSADMIN.PL_DB                                                  " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                " &
"                                                                           " &
"INNER JOIN WMWHSE5.LOC                                                     " &
"        ON LOC.LOC = taskdetail.FROMLOC                                    " &
"                                                                           " &
"WHERE taskdetail.status = 9                                                " &
"  AND taskdetail.tasktype = 'PK'                                           " &
"  AND PL_DB.ISACTIVE = 1                                                   " &
"  AND PL_DB.DB_ENTERPRISE = 0                                              " &
"                                                                           " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"     Between '" + Parameters!DataDe.Value + "'                             " &
"         And '" + Parameters!DataAte.Value + "'                            " &
"                                                                           " &
"GROUP BY taskdetail.whseid,                                                " &
"         PL_DB.DB_ALIAS,                                                   " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,      " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),           " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),         " &
"         USERACTIVITY.USERID,                                              " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),            " &
"         taskdetail.wavekey,                                               " &
"         LOC.LOGICALLOCATION                                               " &
"                                                                           " &
"Union                                                                      " &
"                                                                           " &
"SELECT                                                                     " &
"  DISTINCT                                                                 " &
"    taskdetail.whseid                           PLANTA,                    " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,           " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                  " &
"                                                DIA,                       " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                " &
"                                                HORA,                      " &
"    USERACTIVITY.USERID                         OPERADOR,                  " &
"    subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                   " &
"    taskdetail.wavekey                          PROGRAMA,                  " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                   " &
"    COUNT(taskdetail.sku)                       ITEM,                      " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                 " &
"    SUM(taskdetail.qty)                         PEÇAS,                     " &
"    min(TASKDETAIL.ORDERKEY)                    PEDIDO_HOST                " &
"                                                                           " &
"FROM       WMWHSE6.taskdetail                                              " &
"                                                                           " &
"INNER JOIN WMWHSE6.USERACTIVITY                                            " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY           " &
"                                                                           " &
" LEFT JOIN WMWHSE6.taskmanageruser tu                                      " &
"        ON tu.userkey = USERACTIVITY.USERID                                " &
"                                                                           " &
"INNER JOIN WMSADMIN.PL_DB                                                  " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                " &
"                                                                           " &
"INNER JOIN WMWHSE6.LOC                                                     " &
"        ON LOC.LOC = taskdetail.FROMLOC                                    " &
"                                                                           " &
"WHERE taskdetail.status = 9                                                " &
"  AND taskdetail.tasktype = 'PK'                                           " &
"  AND PL_DB.ISACTIVE = 1                                                   " &
"  AND PL_DB.DB_ENTERPRISE = 0                                              " &
"                                                                           " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"     Between '" + Parameters!DataDe.Value + "'                             " &
"         And '" + Parameters!DataAte.Value + "'                            " &
"                                                                           " &
"GROUP BY taskdetail.whseid,                                                " &
"         PL_DB.DB_ALIAS,                                                   " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,      " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),           " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),         " &
"         USERACTIVITY.USERID,                                              " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),            " &
"         taskdetail.wavekey,                                               " &
"         LOC.LOGICALLOCATION                                               " &
"                                                                           " &
"Union                                                                      " &
"                                                                           " &
"SELECT                                                                     " &
"  DISTINCT                                                                 " &
"    taskdetail.whseid                           PLANTA,                    " &
"    PL_DB.DB_ALIAS                              DSC_PLANTA,                " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,           " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                  " &
"                                                DIA,                       " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')                " &
"                                                HORA,                      " &
"    USERACTIVITY.USERID                         OPERADOR,                  " &
"    subStr( tu.usr_name,4,                                                 " &
"            inStr(tu.usr_name, ',') - 4 )       NOME_OP,                   " &
"    taskdetail.wavekey                          PROGRAMA,                  " &
"    COUNT(DISTINCT taskdetail.orderkey)         PEDIDOS,                   " &
"    COUNT(taskdetail.sku)                       ITEM,                      " &
"    LOC.LOGICALLOCATION                         ORDEM_COL,                 " &
"    SUM(taskdetail.qty)                         PEÇAS,                     " &
"    min(TASKDETAIL.ORDERKEY)                    PEDIDO_HOST                " &
"                                                                           " &
"FROM       WMWHSE7.taskdetail                                              " &
"                                                                           " &
"INNER JOIN WMWHSE7.USERACTIVITY                                            " &
"        ON USERACTIVITY.TASKDETAILKEY = TASKDETAIL.TASKDETAILKEY           " &
"                                                                           " &
" LEFT JOIN WMWHSE7.taskmanageruser tu                                      " &
"        ON tu.userkey = USERACTIVITY.USERID                                " &
"                                                                           " &
"INNER JOIN WMSADMIN.PL_DB                                                  " &
"        ON UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                " &
"                                                                           " &
"INNER JOIN WMWHSE7.LOC                                                     " &
"        ON LOC.LOC = taskdetail.FROMLOC                                    " &
"                                                                           " &
"WHERE taskdetail.status = 9                                                " &
"  AND taskdetail.tasktype = 'PK'                                           " &
"  AND PL_DB.ISACTIVE = 1                                                   " &
"  AND PL_DB.DB_ENTERPRISE = 0                                              " &
"                                                                           " &
" AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,          " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"       AT time zone 'America/Sao_Paulo') AS DATE))                         " &
"     Between '" + Parameters!DataDe.Value + "'                             " &
"         And '" + Parameters!DataAte.Value + "'                            " &
"                                                                           " &
"GROUP BY taskdetail.whseid,                                                " &
"         PL_DB.DB_ALIAS,                                                   " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,      " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),           " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,    " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),         " &
"         USERACTIVITY.USERID,                                              " &
"         subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') - 4 ),            " &
"         taskdetail.wavekey,                                               " &
"         LOC.LOGICALLOCATION                                               " &
"                                                                           " &
"ORDER BY DSC_PLANTA, DIA                                                   "

)