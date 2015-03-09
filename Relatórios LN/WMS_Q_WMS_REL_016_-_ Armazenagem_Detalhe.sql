SELECT

    WMSADMIN.DB_ALIAS                    PLANTA,
    TO_CHAR(IT.ITRNKEY)             ID_OM,
    IT.EDITWHO                   ROMA_ID_OPERADOR,  
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',')-4 )  USUA_NOME,  
    IT.SKU                       ID_ITEM,
    SKU.DESCR                            DESC_ITEM,
    DEPARTSECTORSKU.SECTOR_NAME          SETOR,  
    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,  
    IT.QTY                       QT,
    LOC.PUTAWAYZONE                      CLA_ORIGEM,
    IT.FROMLOC                   ID_LOC_ORIG,
    LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,      -- RETIRAR DO RELATÓRIO  
    IT.TOLOC                     ID_LOCAL,
    aTOLOC.LOGICALLOCATION               DESC_LOC,              -- RETIRAR DO RELATÓRIO
    aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,
    'Concluído'                 ID_SIT,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)                 
                                         DT_SIT,
    CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')
      THEN 'PUTAWAY'
      ELSE 'MOVE' END     TIPO
  
FROM      

  
          WMWHSE5.ITRN          IT

INNER JOIN          WMWHSE5.SKU
    ON SKU.SKU = IT.SKU

LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU
	   ON 	TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)
       AND 	TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)
	   
                            
LEFT JOIN WMWHSE5.taskmanageruser tu 
       ON tu.userkey = IT.EDITWHO

LEFT JOIN WMWHSE5.LOC                 aTOLOC
       ON aTOLOC.LOC = IT.TOLOC
	   
LEFT JOIN WMWHSE5.LOC
      ON LOC.LOC = IT.FROMLOC,
	   
          WMSADMIN.PL_DB              WMSADMIN

WHERE 
   UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID
  
AND IT.TRANTYPE='MV'
AND IT.SOURCETYPE!='PICKING' 
  -- AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE, 
      -- 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        -- AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataSituacaoDe
  -- AND :DataSituacaoAte
  
"SELECT                                                                                    " &
"  DISTINCT                                                                                " &
"    WMSADMIN.DB_ALIAS                    PLANTA,                                          " &
"    TASKDETAIL.TASKDETAILKEY             ID_OM,                                           " &
"    TASKDETAIL.EDITWHO                   ROMA_ID_OPERADOR,                                " &
"    subStr( tu.usr_name,4,                                                                " &
"            inStr(tu.usr_name, ',')-4 )  USUA_NOME,                                       " &
"    TASKDETAIL.SKU                       ID_ITEM,                                         " &
"    SKU.DESCR                            DESC_ITEM,                                       " &
"    DEPARTSECTORSKU.SECTOR_NAME          SETOR,                                           " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,                                    " &
"    TASKDETAIL.QTY                       QT,                                              " &
"    LOC.PUTAWAYZONE                      CLA_ORIGEM,                                      " &
"    TASKDETAIL.FROMLOC                   ID_LOC_ORIG,                                     " &
"    LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,                                " &
"    TASKDETAIL.TOLOC                     ID_LOCAL,                                        " &
"    aTOLOC.LOGICALLOCATION               DESC_LOC,                                        " &
"    aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                                      " &
"    CODELKUP.DESCRIPTION                 ID_SIT,                                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " &                 
"                                         DT_SIT                                           " &
"                                                                                          " &
"FROM      " + Parameters!Table.Value + ".LOC,                                             " &
"          " + Parameters!Table.Value + ".SKU                                              " &
"                                                                                          " &
"LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                                     " &
"       ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP),          " &
"                                                                                          " &
"          " + Parameters!Table.Value + ".TASKDETAIL          TASKDETAIL                   " &
"                                                                                          " &
"LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu                               " &
"       ON tu.userkey = TASKDETAIL.EDITWHO                                                 " &
"                                                                                          " &
"LEFT JOIN " + Parameters!Table.Value + ".LOC                 aTOLOC                       " &
"       ON aTOLOC.LOC = TASKDETAIL.TOLOC                                                   " &
"	                                                                                       " &
"LEFT JOIN " + Parameters!Table.Value + ".CODELKUP                                         " &
"       ON CODELKUP.CODE = TASKDETAIL.STATUS                                               " &
"	  AND CODELKUP.LISTNAME = 'TMSTATUS',                                                  " &
"	                                                                                       " &
"          WMSADMIN.PL_DB              WMSADMIN                                            " &
"                                                                                          " &
"WHERE SKU.SKU = TASKDETAIL.SKU                                                            " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                                        " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                        " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " & 
"        Between '" + Parameters!DataSituacaoDe.Value + "'                                 " &
"  AND '" + Parameters!DataSituacaoAte.Value + "'                                          " &

-- Query com UNION ***************************************************************************

"SELECT                                                                                    " &
"  DISTINCT                                                                                " &
"    WMSADMIN.DB_ALIAS                    PLANTA,                                          " &
"    TASKDETAIL.TASKDETAILKEY             ID_OM,                                           " &
"    TASKDETAIL.EDITWHO                   ROMA_ID_OPERADOR,                                " &
"    subStr( tu.usr_name,4,                                                                " &
"            inStr(tu.usr_name, ',')-4 )  USUA_NOME,                                       " &
"    TASKDETAIL.SKU                       ID_ITEM,                                         " &
"    SKU.DESCR                            DESC_ITEM,                                       " &
"    DEPARTSECTORSKU.SECTOR_NAME          SETOR,                                           " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,                                    " &
"    TASKDETAIL.QTY                       QT,                                              " &
"    LOC.PUTAWAYZONE                      CLA_ORIGEM,                                      " &
"    TASKDETAIL.FROMLOC                   ID_LOC_ORIG,                                     " &
"    LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,                                " &
"    TASKDETAIL.TOLOC                     ID_LOCAL,                                        " &
"    aTOLOC.LOGICALLOCATION               DESC_LOC,                                        " &
"    aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                                      " &
"    CODELKUP.DESCRIPTION                 ID_SIT,                                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " &                 
"                                         DT_SIT                                           " &
"                                                                                          " &
"FROM      WMWHSE1.LOC,                                                                    " &
"          WMWHSE1.SKU                                                                     " &
"                                                                                          " &
"LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                                     " &
"       ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP),          " &
"                                                                                          " &
"          WMWHSE1.TASKDETAIL          TASKDETAIL                                          " &
"                                                                                          " &
"LEFT JOIN WMWHSE1.taskmanageruser tu                                                      " &
"       ON tu.userkey = TASKDETAIL.EDITWHO                                                 " &
"                                                                                          " &
"LEFT JOIN WMWHSE1.LOC                 aTOLOC                                              " &
"       ON aTOLOC.LOC = TASKDETAIL.TOLOC                                                   " &
"	                                                                                       " &
"LEFT JOIN WMWHSE1.CODELKUP                                                                " &
"       ON CODELKUP.CODE = TASKDETAIL.STATUS                                               " &
"	  AND CODELKUP.LISTNAME = 'TMSTATUS',                                                  " &
"	                                                                                       " &
"          WMSADMIN.PL_DB              WMSADMIN                                            " &
"                                                                                          " &
"WHERE SKU.SKU = TASKDETAIL.SKU                                                            " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                                        " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                        " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " & 
"        Between '" + Parameters!DataSituacaoDe.Value + "'                                 " &
"  AND '" + Parameters!DataSituacaoAte.Value + "'                                          " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                                                    " &
"  DISTINCT                                                                                " &
"    WMSADMIN.DB_ALIAS                    PLANTA,                                          " &
"    TASKDETAIL.TASKDETAILKEY             ID_OM,                                           " &
"    TASKDETAIL.EDITWHO                   ROMA_ID_OPERADOR,                                " &
"    subStr( tu.usr_name,4,                                                                " &
"            inStr(tu.usr_name, ',')-4 )  USUA_NOME,                                       " &
"    TASKDETAIL.SKU                       ID_ITEM,                                         " &
"    SKU.DESCR                            DESC_ITEM,                                       " &
"    DEPARTSECTORSKU.SECTOR_NAME          SETOR,                                           " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,                                    " &
"    TASKDETAIL.QTY                       QT,                                              " &
"    LOC.PUTAWAYZONE                      CLA_ORIGEM,                                      " &
"    TASKDETAIL.FROMLOC                   ID_LOC_ORIG,                                     " &
"    LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,                                " &
"    TASKDETAIL.TOLOC                     ID_LOCAL,                                        " &
"    aTOLOC.LOGICALLOCATION               DESC_LOC,                                        " &
"    aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                                      " &
"    CODELKUP.DESCRIPTION                 ID_SIT,                                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " &                 
"                                         DT_SIT                                           " &
"                                                                                          " &
"FROM      WMWHSE2.LOC,                                                                    " &
"          WMWHSE2.SKU                                                                     " &
"                                                                                          " &
"LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                                     " &
"       ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP),          " &
"                                                                                          " &
"          WMWHSE2.TASKDETAIL          TASKDETAIL                                          " &
"                                                                                          " &
"LEFT JOIN WMWHSE2.taskmanageruser tu                                                      " &
"       ON tu.userkey = TASKDETAIL.EDITWHO                                                 " &
"                                                                                          " &
"LEFT JOIN WMWHSE2.LOC                 aTOLOC                                              " &
"       ON aTOLOC.LOC = TASKDETAIL.TOLOC                                                   " &
"	                                                                                       " &
"LEFT JOIN WMWHSE2.CODELKUP                                                                " &
"       ON CODELKUP.CODE = TASKDETAIL.STATUS                                               " &
"	  AND CODELKUP.LISTNAME = 'TMSTATUS',                                                  " &
"	                                                                                       " &
"          WMSADMIN.PL_DB              WMSADMIN                                            " &
"                                                                                          " &
"WHERE SKU.SKU = TASKDETAIL.SKU                                                            " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                                        " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                        " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " & 
"        Between '" + Parameters!DataSituacaoDe.Value + "'                                 " &
"  AND '" + Parameters!DataSituacaoAte.Value + "'                                          " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                                                    " &
"  DISTINCT                                                                                " &
"    WMSADMIN.DB_ALIAS                    PLANTA,                                          " &
"    TASKDETAIL.TASKDETAILKEY             ID_OM,                                           " &
"    TASKDETAIL.EDITWHO                   ROMA_ID_OPERADOR,                                " &
"    subStr( tu.usr_name,4,                                                                " &
"            inStr(tu.usr_name, ',')-4 )  USUA_NOME,                                       " &
"    TASKDETAIL.SKU                       ID_ITEM,                                         " &
"    SKU.DESCR                            DESC_ITEM,                                       " &
"    DEPARTSECTORSKU.SECTOR_NAME          SETOR,                                           " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,                                    " &
"    TASKDETAIL.QTY                       QT,                                              " &
"    LOC.PUTAWAYZONE                      CLA_ORIGEM,                                      " &
"    TASKDETAIL.FROMLOC                   ID_LOC_ORIG,                                     " &
"    LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,                                " &
"    TASKDETAIL.TOLOC                     ID_LOCAL,                                        " &
"    aTOLOC.LOGICALLOCATION               DESC_LOC,                                        " &
"    aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                                      " &
"    CODELKUP.DESCRIPTION                 ID_SIT,                                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " &                 
"                                         DT_SIT                                           " &
"                                                                                          " &
"FROM      WMWHSE3.LOC,                                                                    " &
"          WMWHSE3.SKU                                                                     " &
"                                                                                          " &
"LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                                     " &
"       ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP),          " &
"                                                                                          " &
"          WMWHSE3.TASKDETAIL          TASKDETAIL                                          " &
"                                                                                          " &
"LEFT JOIN WMWHSE3.taskmanageruser tu                                                      " &
"       ON tu.userkey = TASKDETAIL.EDITWHO                                                 " &
"                                                                                          " &
"LEFT JOIN WMWHSE3.LOC                 aTOLOC                                              " &
"       ON aTOLOC.LOC = TASKDETAIL.TOLOC                                                   " &
"	                                                                                       " &
"LEFT JOIN WMWHSE3.CODELKUP                                                                " &
"       ON CODELKUP.CODE = TASKDETAIL.STATUS                                               " &
"	  AND CODELKUP.LISTNAME = 'TMSTATUS',                                                  " &
"	                                                                                       " &
"          WMSADMIN.PL_DB              WMSADMIN                                            " &
"                                                                                          " &
"WHERE SKU.SKU = TASKDETAIL.SKU                                                            " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                                        " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                        " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " & 
"        Between '" + Parameters!DataSituacaoDe.Value + "'                                 " &
"  AND '" + Parameters!DataSituacaoAte.Value + "'                                          " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                                                    " &
"  DISTINCT                                                                                " &
"    WMSADMIN.DB_ALIAS                    PLANTA,                                          " &
"    TASKDETAIL.TASKDETAILKEY             ID_OM,                                           " &
"    TASKDETAIL.EDITWHO                   ROMA_ID_OPERADOR,                                " &
"    subStr( tu.usr_name,4,                                                                " &
"            inStr(tu.usr_name, ',')-4 )  USUA_NOME,                                       " &
"    TASKDETAIL.SKU                       ID_ITEM,                                         " &
"    SKU.DESCR                            DESC_ITEM,                                       " &
"    DEPARTSECTORSKU.SECTOR_NAME          SETOR,                                           " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,                                    " &
"    TASKDETAIL.QTY                       QT,                                              " &
"    LOC.PUTAWAYZONE                      CLA_ORIGEM,                                      " &
"    TASKDETAIL.FROMLOC                   ID_LOC_ORIG,                                     " &
"    LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,                                " &
"    TASKDETAIL.TOLOC                     ID_LOCAL,                                        " &
"    aTOLOC.LOGICALLOCATION               DESC_LOC,                                        " &
"    aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                                      " &
"    CODELKUP.DESCRIPTION                 ID_SIT,                                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " &                 
"                                         DT_SIT                                           " &
"                                                                                          " &
"FROM      WMWHSE4.LOC,                                                                    " &
"          WMWHSE4.SKU                                                                     " &
"                                                                                          " &
"LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                                     " &
"       ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP),          " &
"                                                                                          " &
"          WMWHSE4.TASKDETAIL          TASKDETAIL                                          " &
"                                                                                          " &
"LEFT JOIN WMWHSE4.taskmanageruser tu                                                      " &
"       ON tu.userkey = TASKDETAIL.EDITWHO                                                 " &
"                                                                                          " &
"LEFT JOIN WMWHSE4.LOC                 aTOLOC                                              " &
"       ON aTOLOC.LOC = TASKDETAIL.TOLOC                                                   " &
"	                                                                                       " &
"LEFT JOIN WMWHSE4.CODELKUP                                                                " &
"       ON CODELKUP.CODE = TASKDETAIL.STATUS                                               " &
"	  AND CODELKUP.LISTNAME = 'TMSTATUS',                                                  " &
"	                                                                                       " &
"          WMSADMIN.PL_DB              WMSADMIN                                            " &
"                                                                                          " &
"WHERE SKU.SKU = TASKDETAIL.SKU                                                            " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                                        " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                        " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " & 
"        Between '" + Parameters!DataSituacaoDe.Value + "'                                 " &
"  AND '" + Parameters!DataSituacaoAte.Value + "'                                          " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                                                    " &
"  DISTINCT                                                                                " &
"    WMSADMIN.DB_ALIAS                    PLANTA,                                          " &
"    TASKDETAIL.TASKDETAILKEY             ID_OM,                                           " &
"    TASKDETAIL.EDITWHO                   ROMA_ID_OPERADOR,                                " &
"    subStr( tu.usr_name,4,                                                                " &
"            inStr(tu.usr_name, ',')-4 )  USUA_NOME,                                       " &
"    TASKDETAIL.SKU                       ID_ITEM,                                         " &
"    SKU.DESCR                            DESC_ITEM,                                       " &
"    DEPARTSECTORSKU.SECTOR_NAME          SETOR,                                           " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,                                    " &
"    TASKDETAIL.QTY                       QT,                                              " &
"    LOC.PUTAWAYZONE                      CLA_ORIGEM,                                      " &
"    TASKDETAIL.FROMLOC                   ID_LOC_ORIG,                                     " &
"    LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,                                " &
"    TASKDETAIL.TOLOC                     ID_LOCAL,                                        " &
"    aTOLOC.LOGICALLOCATION               DESC_LOC,                                        " &
"    aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                                      " &
"    CODELKUP.DESCRIPTION                 ID_SIT,                                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " &                 
"                                         DT_SIT                                           " &
"                                                                                          " &
"FROM      WMWHSE5.LOC,                                                                    " &
"          WMWHSE5.SKU                                                                     " &
"                                                                                          " &
"LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                                     " &
"       ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP),          " &
"                                                                                          " &
"          WMWHSE5.TASKDETAIL          TASKDETAIL                                          " &
"                                                                                          " &
"LEFT JOIN WMWHSE5.taskmanageruser tu                                                      " &
"       ON tu.userkey = TASKDETAIL.EDITWHO                                                 " &
"                                                                                          " &
"LEFT JOIN WMWHSE5.LOC                 aTOLOC                                              " &
"       ON aTOLOC.LOC = TASKDETAIL.TOLOC                                                   " &
"	                                                                                       " &
"LEFT JOIN WMWHSE5.CODELKUP                                                                " &
"       ON CODELKUP.CODE = TASKDETAIL.STATUS                                               " &
"	  AND CODELKUP.LISTNAME = 'TMSTATUS',                                                  " &
"	                                                                                       " &
"          WMSADMIN.PL_DB              WMSADMIN                                            " &
"                                                                                          " &
"WHERE SKU.SKU = TASKDETAIL.SKU                                                            " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                                        " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                        " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " & 
"        Between '" + Parameters!DataSituacaoDe.Value + "'                                 " &
"  AND '" + Parameters!DataSituacaoAte.Value + "'                                          " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                                                    " &
"  DISTINCT                                                                                " &
"    WMSADMIN.DB_ALIAS                    PLANTA,                                          " &
"    TASKDETAIL.TASKDETAILKEY             ID_OM,                                           " &
"    TASKDETAIL.EDITWHO                   ROMA_ID_OPERADOR,                                " &
"    subStr( tu.usr_name,4,                                                                " &
"            inStr(tu.usr_name, ',')-4 )  USUA_NOME,                                       " &
"    TASKDETAIL.SKU                       ID_ITEM,                                         " &
"    SKU.DESCR                            DESC_ITEM,                                       " &
"    DEPARTSECTORSKU.SECTOR_NAME          SETOR,                                           " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,                                    " &
"    TASKDETAIL.QTY                       QT,                                              " &
"    LOC.PUTAWAYZONE                      CLA_ORIGEM,                                      " &
"    TASKDETAIL.FROMLOC                   ID_LOC_ORIG,                                     " &
"    LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,                                " &
"    TASKDETAIL.TOLOC                     ID_LOCAL,                                        " &
"    aTOLOC.LOGICALLOCATION               DESC_LOC,                                        " &
"    aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                                      " &
"    CODELKUP.DESCRIPTION                 ID_SIT,                                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " &                 
"                                         DT_SIT                                           " &
"                                                                                          " &
"FROM      WMWHSE6.LOC,                                                                    " &
"          WMWHSE6.SKU                                                                     " &
"                                                                                          " &
"LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                                     " &
"       ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP),          " &
"                                                                                          " &
"          WMWHSE6.TASKDETAIL          TASKDETAIL                                          " &
"                                                                                          " &
"LEFT JOIN WMWHSE6.taskmanageruser tu                                                      " &
"       ON tu.userkey = TASKDETAIL.EDITWHO                                                 " &
"                                                                                          " &
"LEFT JOIN WMWHSE6.LOC                 aTOLOC                                              " &
"       ON aTOLOC.LOC = TASKDETAIL.TOLOC                                                   " &
"	                                                                                       " &
"LEFT JOIN WMWHSE6.CODELKUP                                                                " &
"       ON CODELKUP.CODE = TASKDETAIL.STATUS                                               " &
"	  AND CODELKUP.LISTNAME = 'TMSTATUS',                                                  " &
"	                                                                                       " &
"          WMSADMIN.PL_DB              WMSADMIN                                            " &
"                                                                                          " &
"WHERE SKU.SKU = TASKDETAIL.SKU                                                            " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                                        " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                        " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " & 
"        Between '" + Parameters!DataSituacaoDe.Value + "'                                 " &
"  AND '" + Parameters!DataSituacaoAte.Value + "'                                          " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                                                    " &
"  DISTINCT                                                                                " &
"    WMSADMIN.DB_ALIAS                    PLANTA,                                          " &
"    TASKDETAIL.TASKDETAILKEY             ID_OM,                                           " &
"    TASKDETAIL.EDITWHO                   ROMA_ID_OPERADOR,                                " &
"    subStr( tu.usr_name,4,                                                                " &
"            inStr(tu.usr_name, ',')-4 )  USUA_NOME,                                       " &
"    TASKDETAIL.SKU                       ID_ITEM,                                         " &
"    SKU.DESCR                            DESC_ITEM,                                       " &
"    DEPARTSECTORSKU.SECTOR_NAME          SETOR,                                           " &
"    DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,                                    " &
"    TASKDETAIL.QTY                       QT,                                              " &
"    LOC.PUTAWAYZONE                      CLA_ORIGEM,                                      " &
"    TASKDETAIL.FROMLOC                   ID_LOC_ORIG,                                     " &
"    LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,                                " &
"    TASKDETAIL.TOLOC                     ID_LOCAL,                                        " &
"    aTOLOC.LOGICALLOCATION               DESC_LOC,                                        " &
"    aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                                      " &
"    CODELKUP.DESCRIPTION                 ID_SIT,                                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                               " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " &                 
"                                         DT_SIT                                           " &
"                                                                                          " &
"FROM      WMWHSE7.LOC,                                                                    " &
"          WMWHSE7.SKU                                                                     " &
"                                                                                          " &
"LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                                     " &
"       ON TO_CHAR(ENTERPRISE.DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP),          " &
"                                                                                          " &
"          WMWHSE7.TASKDETAIL          TASKDETAIL                                          " &
"                                                                                          " &
"LEFT JOIN WMWHSE7.taskmanageruser tu                                                      " &
"       ON tu.userkey = TASKDETAIL.EDITWHO                                                 " &
"                                                                                          " &
"LEFT JOIN WMWHSE7.LOC                 aTOLOC                                              " &
"       ON aTOLOC.LOC = TASKDETAIL.TOLOC                                                   " &
"	                                                                                       " &
"LEFT JOIN WMWHSE7.CODELKUP                                                                " &
"       ON CODELKUP.CODE = TASKDETAIL.STATUS                                               " &
"	  AND CODELKUP.LISTNAME = 'TMSTATUS',                                                  " &
"	                                                                                       " &
"          WMSADMIN.PL_DB              WMSADMIN                                            " &
"                                                                                          " &
"WHERE SKU.SKU = TASKDETAIL.SKU                                                            " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID                                        " &
"  AND LOC.LOC = TASKDETAIL.FROMLOC                                                        " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TASKDETAIL.EDITDATE,                       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                                            " & 
"        Between '" + Parameters!DataSituacaoDe.Value + "'                                 " &
"  AND '" + Parameters!DataSituacaoAte.Value + "'                                          " &
"                                                                                          " &
"Order By PLANTA                                                                           "