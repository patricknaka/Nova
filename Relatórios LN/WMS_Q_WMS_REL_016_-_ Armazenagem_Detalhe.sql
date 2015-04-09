SELECT WMSADMIN.DB_ALIAS                    PLANTA,
       TO_CHAR(IT.ITRNKEY)                  ID_OM,
       IT.EDITWHO                           ROMA_ID_OPERADOR,  
       subStr( tu.usr_name,4,
               inStr(tu.usr_name, ',') -4 ) USUA_NOME,  
       IT.SKU                               ID_ITEM,
       SKU.DESCR                            DESC_ITEM,
       DEPARTSECTORSKU.SECTOR_NAME          SETOR,  
       DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,  
       IT.QTY                               QT,
       LOC.PUTAWAYZONE                      CLA_ORIGEM,
       IT.FROMLOC                           ID_LOC_ORIG,
       LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,      -- RETIRAR DO RELATÓRIO  
       IT.TOLOC                             ID_LOCAL,
       aTOLOC.LOGICALLOCATION               DESC_LOC,              -- RETIRAR DO RELATÓRIO
       aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,
       'Concluído'                          ID_SIT,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)                 
                                            DT_SIT,
       CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')
              THEN 'PUTAWAY'
            ELSE 'MOVE' 
        END                                 TIPO,
		STORER.COMPANY						FORNECEDOR,
		NVL(maucLN.mauc,0)*IT.QTY			VALOR
		
  
FROM       WMWHSE5.ITRN          IT

INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = IT.SKU

 LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU
        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)
       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)
    
 LEFT JOIN WMWHSE5.taskmanageruser tu 
        ON tu.userkey = IT.EDITWHO
 
 LEFT JOIN WMWHSE5.LOC  aTOLOC
        ON aTOLOC.LOC = IT.TOLOC
     
 LEFT JOIN WMWHSE5.LOC
        ON LOC.LOC = IT.FROMLOC
    
INNER JOIN WMSADMIN.PL_DB  WMSADMIN
        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID
		
 LEFT JOIN WMWHSE5.STORER 
        ON STORER.STORERKEY = sku.SUSR5 
       AND STORER.WHSEID = sku.WHSEID 
       AND STORER.TYPE = 5

LEFT JOIN ENTERPRISE.CODELKUP cl 
        ON UPPER(cl.UDF1) = IT.WHSEID
       AND cl.LISTNAME = 'SCHEMA'
	   
 LEFT JOIN ( select trim(whwmd217.t$item) item,                             
                    whwmd217.t$cwar cwar,                                   
                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0                             
                           then sum(whwmd217.t$ftpa$1)                                              
                         else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
                    end mauc                                                
               from baandb.twhwmd217301@pln01 whwmd217                      
          left join baandb.twhinr140301@pln01 a                             
                 on a.t$cwar = whwmd217.t$cwar                              
                and a.t$item = whwmd217.t$item                              
           group by whwmd217.t$item,                                        
                    whwmd217.t$cwar ) maucLN                                
        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         
       AND maucLN.item = IT.sku

	   
WHERE IT.TRANTYPE = 'MV'
  AND IT.SOURCETYPE != 'PICKING' 
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE, 
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone 'America/Sao_Paulo') AS DATE)) 
      Between :DataSituacaoDe
          And :DataSituacaoAte
  AND CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')
             THEN 'PUTAWAY'
           ELSE 'MOVE'
       END IN (:TIPO)

  

  
=IIF(Parameters!Table.Value <> "AAA",

"SELECT WMSADMIN.DB_ALIAS                    PLANTA,                     " &
"       TO_CHAR(IT.ITRNKEY)                  ID_OM,                      " &
"       IT.EDITWHO                           ROMA_ID_OPERADOR,           " &
"       subStr( tu.usr_name,4,                                           " &
"               inStr(tu.usr_name, ',') -4 ) USUA_NOME,                  " &
"       IT.SKU                               ID_ITEM,                    " &
"       SKU.DESCR                            DESC_ITEM,                  " &
"       DEPARTSECTORSKU.SECTOR_NAME          SETOR,                      " &
"       DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,               " &
"       IT.QTY                               QT,                         " &
"       LOC.PUTAWAYZONE                      CLA_ORIGEM,                 " &
"       IT.FROMLOC                           ID_LOC_ORIG,                " &
"       LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,           " &
"       IT.TOLOC                             ID_LOCAL,                   " &
"       aTOLOC.LOGICALLOCATION               DESC_LOC,                   " &
"       aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                 " &
"       'Concluído'                          ID_SIT,                     " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                   " &
"                                            DT_SIT,                     " &
"       CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                      " &
"              THEN 'PUTAWAY'                                            " &
"            ELSE 'MOVE'                                                 " &
"        END                                 TIPO                        " &
"                                                                        " &
"FROM       " + Parameters!Table.Value + ".ITRN          IT              " &
"                                                                        " &
"INNER JOIN " + Parameters!Table.Value + ".SKU                           " &
"        ON SKU.SKU = IT.SKU                                             " &
"                                                                        " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                  " &
"        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"                                                                        " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu            " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
" LEFT JOIN " + Parameters!Table.Value + ".LOC  aTOLOC                   " &
"        ON aTOLOC.LOC = IT.TOLOC                                        " &
"                                                                        " &
" LEFT JOIN " + Parameters!Table.Value + ".LOC                           " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB  WMSADMIN                                     " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"		                                                                 " &
"WHERE IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"        Between '" + Parameters!DataSituacaoDe.Value + "'               " &
"            And '" + Parameters!DataSituacaoAte.Value + "'              " &
"  AND CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                                         " &
"             THEN 'PUTAWAY'                                                               " &
"           ELSE 'MOVE'                                                                    " &
"       END IN (" + Replace(("'" + JOIN(Parameters!Tipo.Value, "',") + "'"),",",",'") + ") " &
"		                                                                                   " &
"Order By 1,2,5,6                                                                          "

,

"SELECT WMSADMIN.DB_ALIAS                    PLANTA,                     " &
"       TO_CHAR(IT.ITRNKEY)                  ID_OM,                      " &
"       IT.EDITWHO                           ROMA_ID_OPERADOR,           " &
"       subStr( tu.usr_name,4,                                           " &
"               inStr(tu.usr_name, ',') -4 ) USUA_NOME,                  " &
"       IT.SKU                               ID_ITEM,                    " &
"       SKU.DESCR                            DESC_ITEM,                  " &
"       DEPARTSECTORSKU.SECTOR_NAME          SETOR,                      " &
"       DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,               " &
"       IT.QTY                               QT,                         " &
"       LOC.PUTAWAYZONE                      CLA_ORIGEM,                 " &
"       IT.FROMLOC                           ID_LOC_ORIG,                " &
"       LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,           " &
"       IT.TOLOC                             ID_LOCAL,                   " &
"       aTOLOC.LOGICALLOCATION               DESC_LOC,                   " &
"       aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                 " &
"       'Concluído'                          ID_SIT,                     " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                   " &
"                                            DT_SIT,                     " &
"       CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                      " &
"              THEN 'PUTAWAY'                                            " &
"            ELSE 'MOVE'                                                 " &
"        END                                 TIPO                        " &
"                                                                        " &
"FROM       WMWHSE1.ITRN          IT                                     " &
"                                                                        " &
"INNER JOIN WMWHSE1.SKU                                                  " &
"        ON SKU.SKU = IT.SKU                                             " &
"                                                                        " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                  " &
"        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"                                                                        " &
" LEFT JOIN WMWHSE1.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
" LEFT JOIN WMWHSE1.LOC  aTOLOC                                          " &
"        ON aTOLOC.LOC = IT.TOLOC                                        " &
"                                                                        " &
" LEFT JOIN WMWHSE1.LOC                                                  " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB  WMSADMIN                                     " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"		                                                                 " &
"WHERE IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"        Between '" + Parameters!DataSituacaoDe.Value + "'               " &
"            And '" + Parameters!DataSituacaoAte.Value + "'              " &
"  AND CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                                         " &
"             THEN 'PUTAWAY'                                                               " &
"           ELSE 'MOVE'                                                                    " &
"       END IN (" + Replace(("'" + JOIN(Parameters!Tipo.Value, "',") + "'"),",",",'") + ") " &
"		                                                                                   " &
"		                                                                 " &
"Union                                                                   " &
"		                                                                 " &
"SELECT WMSADMIN.DB_ALIAS                    PLANTA,                     " &
"       TO_CHAR(IT.ITRNKEY)                  ID_OM,                      " &
"       IT.EDITWHO                           ROMA_ID_OPERADOR,           " &
"       subStr( tu.usr_name,4,                                           " &
"               inStr(tu.usr_name, ',') -4 ) USUA_NOME,                  " &
"       IT.SKU                               ID_ITEM,                    " &
"       SKU.DESCR                            DESC_ITEM,                  " &
"       DEPARTSECTORSKU.SECTOR_NAME          SETOR,                      " &
"       DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,               " &
"       IT.QTY                               QT,                         " &
"       LOC.PUTAWAYZONE                      CLA_ORIGEM,                 " &
"       IT.FROMLOC                           ID_LOC_ORIG,                " &
"       LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,           " &
"       IT.TOLOC                             ID_LOCAL,                   " &
"       aTOLOC.LOGICALLOCATION               DESC_LOC,                   " &
"       aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                 " &
"       'Concluído'                          ID_SIT,                     " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                   " &
"                                            DT_SIT,                     " &
"       CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                      " &
"              THEN 'PUTAWAY'                                            " &
"            ELSE 'MOVE'                                                 " &
"        END                                 TIPO                        " &
"                                                                        " &
"FROM       WMWHSE2.ITRN          IT                                     " &
"                                                                        " &
"INNER JOIN WMWHSE2.SKU                                                  " &
"        ON SKU.SKU = IT.SKU                                             " &
"                                                                        " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                  " &
"        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"                                                                        " &
" LEFT JOIN WMWHSE2.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
" LEFT JOIN WMWHSE2.LOC  aTOLOC                                          " &
"        ON aTOLOC.LOC = IT.TOLOC                                        " &
"                                                                        " &
" LEFT JOIN WMWHSE2.LOC                                                  " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB  WMSADMIN                                     " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"		                                                                 " &
"WHERE IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"        Between '" + Parameters!DataSituacaoDe.Value + "'               " &
"            And '" + Parameters!DataSituacaoAte.Value + "'              " &
"  AND CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                                         " &
"             THEN 'PUTAWAY'                                                               " &
"           ELSE 'MOVE'                                                                    " &
"       END IN (" + Replace(("'" + JOIN(Parameters!Tipo.Value, "',") + "'"),",",",'") + ") " &
"		                                                                                   " &
"		                                                                 " &
"Union                                                                   " &
"		                                                                 " &
"SELECT WMSADMIN.DB_ALIAS                    PLANTA,                     " &
"       TO_CHAR(IT.ITRNKEY)                  ID_OM,                      " &
"       IT.EDITWHO                           ROMA_ID_OPERADOR,           " &
"       subStr( tu.usr_name,4,                                           " &
"               inStr(tu.usr_name, ',') -4 ) USUA_NOME,                  " &
"       IT.SKU                               ID_ITEM,                    " &
"       SKU.DESCR                            DESC_ITEM,                  " &
"       DEPARTSECTORSKU.SECTOR_NAME          SETOR,                      " &
"       DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,               " &
"       IT.QTY                               QT,                         " &
"       LOC.PUTAWAYZONE                      CLA_ORIGEM,                 " &
"       IT.FROMLOC                           ID_LOC_ORIG,                " &
"       LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,           " &
"       IT.TOLOC                             ID_LOCAL,                   " &
"       aTOLOC.LOGICALLOCATION               DESC_LOC,                   " &
"       aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                 " &
"       'Concluído'                          ID_SIT,                     " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                   " &
"                                            DT_SIT,                     " &
"       CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                      " &
"              THEN 'PUTAWAY'                                            " &
"            ELSE 'MOVE'                                                 " &
"        END                                 TIPO                        " &
"                                                                        " &
"FROM       WMWHSE3.ITRN          IT                                     " &
"                                                                        " &
"INNER JOIN WMWHSE3.SKU                                                  " &
"        ON SKU.SKU = IT.SKU                                             " &
"                                                                        " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                  " &
"        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"                                                                        " &
" LEFT JOIN WMWHSE3.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
" LEFT JOIN WMWHSE3.LOC  aTOLOC                                          " &
"        ON aTOLOC.LOC = IT.TOLOC                                        " &
"                                                                        " &
" LEFT JOIN WMWHSE3.LOC                                                  " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB  WMSADMIN                                     " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"		                                                                 " &
"WHERE IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"        Between '" + Parameters!DataSituacaoDe.Value + "'               " &
"            And '" + Parameters!DataSituacaoAte.Value + "'              " &
"  AND CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                                         " &
"             THEN 'PUTAWAY'                                                               " &
"           ELSE 'MOVE'                                                                    " &
"       END IN (" + Replace(("'" + JOIN(Parameters!Tipo.Value, "',") + "'"),",",",'") + ") " &
"		                                                                                   " &
"		                                                                 " &
"Union                                                                   " &
"		                                                                 " &
"SELECT WMSADMIN.DB_ALIAS                    PLANTA,                     " &
"       TO_CHAR(IT.ITRNKEY)                  ID_OM,                      " &
"       IT.EDITWHO                           ROMA_ID_OPERADOR,           " &
"       subStr( tu.usr_name,4,                                           " &
"               inStr(tu.usr_name, ',') -4 ) USUA_NOME,                  " &
"       IT.SKU                               ID_ITEM,                    " &
"       SKU.DESCR                            DESC_ITEM,                  " &
"       DEPARTSECTORSKU.SECTOR_NAME          SETOR,                      " &
"       DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,               " &
"       IT.QTY                               QT,                         " &
"       LOC.PUTAWAYZONE                      CLA_ORIGEM,                 " &
"       IT.FROMLOC                           ID_LOC_ORIG,                " &
"       LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,           " &
"       IT.TOLOC                             ID_LOCAL,                   " &
"       aTOLOC.LOGICALLOCATION               DESC_LOC,                   " &
"       aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                 " &
"       'Concluído'                          ID_SIT,                     " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                   " &
"                                            DT_SIT,                     " &
"       CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                      " &
"              THEN 'PUTAWAY'                                            " &
"            ELSE 'MOVE'                                                 " &
"        END                                 TIPO                        " &
"                                                                        " &
"FROM       WMWHSE4.ITRN          IT                                     " &
"                                                                        " &
"INNER JOIN WMWHSE4.SKU                                                  " &
"        ON SKU.SKU = IT.SKU                                             " &
"                                                                        " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                  " &
"        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"                                                                        " &
" LEFT JOIN WMWHSE4.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
" LEFT JOIN WMWHSE4.LOC  aTOLOC                                          " &
"        ON aTOLOC.LOC = IT.TOLOC                                        " &
"                                                                        " &
" LEFT JOIN WMWHSE4.LOC                                                  " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB  WMSADMIN                                     " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"		                                                                 " &
"WHERE IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"        Between '" + Parameters!DataSituacaoDe.Value + "'               " &
"            And '" + Parameters!DataSituacaoAte.Value + "'              " &
"  AND CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                                         " &
"             THEN 'PUTAWAY'                                                               " &
"           ELSE 'MOVE'                                                                    " &
"       END IN (" + Replace(("'" + JOIN(Parameters!Tipo.Value, "',") + "'"),",",",'") + ") " &
"		                                                                                   " &
"		                                                                 " &
"Union                                                                   " &
"		                                                                 " &
"SELECT WMSADMIN.DB_ALIAS                    PLANTA,                     " &
"       TO_CHAR(IT.ITRNKEY)                  ID_OM,                      " &
"       IT.EDITWHO                           ROMA_ID_OPERADOR,           " &
"       subStr( tu.usr_name,4,                                           " &
"               inStr(tu.usr_name, ',') -4 ) USUA_NOME,                  " &
"       IT.SKU                               ID_ITEM,                    " &
"       SKU.DESCR                            DESC_ITEM,                  " &
"       DEPARTSECTORSKU.SECTOR_NAME          SETOR,                      " &
"       DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,               " &
"       IT.QTY                               QT,                         " &
"       LOC.PUTAWAYZONE                      CLA_ORIGEM,                 " &
"       IT.FROMLOC                           ID_LOC_ORIG,                " &
"       LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,           " &
"       IT.TOLOC                             ID_LOCAL,                   " &
"       aTOLOC.LOGICALLOCATION               DESC_LOC,                   " &
"       aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                 " &
"       'Concluído'                          ID_SIT,                     " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                   " &
"                                            DT_SIT,                     " &
"       CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                      " &
"              THEN 'PUTAWAY'                                            " &
"            ELSE 'MOVE'                                                 " &
"        END                                 TIPO                        " &
"                                                                        " &
"FROM       WMWHSE5.ITRN          IT                                     " &
"                                                                        " &
"INNER JOIN WMWHSE5.SKU                                                  " &
"        ON SKU.SKU = IT.SKU                                             " &
"                                                                        " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                  " &
"        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"                                                                        " &
" LEFT JOIN WMWHSE5.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
" LEFT JOIN WMWHSE5.LOC  aTOLOC                                          " &
"        ON aTOLOC.LOC = IT.TOLOC                                        " &
"                                                                        " &
" LEFT JOIN WMWHSE5.LOC                                                  " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB  WMSADMIN                                     " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"		                                                                 " &
"WHERE IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"        Between '" + Parameters!DataSituacaoDe.Value + "'               " &
"            And '" + Parameters!DataSituacaoAte.Value + "'              " &
"  AND CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                                         " &
"             THEN 'PUTAWAY'                                                               " &
"           ELSE 'MOVE'                                                                    " &
"       END IN (" + Replace(("'" + JOIN(Parameters!Tipo.Value, "',") + "'"),",",",'") + ") " &
"		                                                                                   " &
"		                                                                 " &
"Union                                                                   " &
"		                                                                 " &
"SELECT WMSADMIN.DB_ALIAS                    PLANTA,                     " &
"       TO_CHAR(IT.ITRNKEY)                  ID_OM,                      " &
"       IT.EDITWHO                           ROMA_ID_OPERADOR,           " &
"       subStr( tu.usr_name,4,                                           " &
"               inStr(tu.usr_name, ',') -4 ) USUA_NOME,                  " &
"       IT.SKU                               ID_ITEM,                    " &
"       SKU.DESCR                            DESC_ITEM,                  " &
"       DEPARTSECTORSKU.SECTOR_NAME          SETOR,                      " &
"       DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,               " &
"       IT.QTY                               QT,                         " &
"       LOC.PUTAWAYZONE                      CLA_ORIGEM,                 " &
"       IT.FROMLOC                           ID_LOC_ORIG,                " &
"       LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,           " &
"       IT.TOLOC                             ID_LOCAL,                   " &
"       aTOLOC.LOGICALLOCATION               DESC_LOC,                   " &
"       aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                 " &
"       'Concluído'                          ID_SIT,                     " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                   " &
"                                            DT_SIT,                     " &
"       CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                      " &
"              THEN 'PUTAWAY'                                            " &
"            ELSE 'MOVE'                                                 " &
"        END                                 TIPO                        " &
"                                                                        " &
"FROM       WMWHSE6.ITRN          IT                                     " &
"                                                                        " &
"INNER JOIN WMWHSE6.SKU                                                  " &
"        ON SKU.SKU = IT.SKU                                             " &
"                                                                        " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                  " &
"        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"                                                                        " &
" LEFT JOIN WMWHSE6.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
" LEFT JOIN WMWHSE6.LOC  aTOLOC                                          " &
"        ON aTOLOC.LOC = IT.TOLOC                                        " &
"                                                                        " &
" LEFT JOIN WMWHSE6.LOC                                                  " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB  WMSADMIN                                     " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"		                                                                 " &
"WHERE IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"        Between '" + Parameters!DataSituacaoDe.Value + "'               " &
"            And '" + Parameters!DataSituacaoAte.Value + "'              " &
"  AND CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                                         " &
"             THEN 'PUTAWAY'                                                               " &
"           ELSE 'MOVE'                                                                    " &
"       END IN (" + Replace(("'" + JOIN(Parameters!Tipo.Value, "',") + "'"),",",",'") + ") " &
"		                                                                                   " &
"		                                                                 " &
"Union                                                                   " &
"		                                                                 " &
"SELECT WMSADMIN.DB_ALIAS                    PLANTA,                     " &
"       TO_CHAR(IT.ITRNKEY)                  ID_OM,                      " &
"       IT.EDITWHO                           ROMA_ID_OPERADOR,           " &
"       subStr( tu.usr_name,4,                                           " &
"               inStr(tu.usr_name, ',') -4 ) USUA_NOME,                  " &
"       IT.SKU                               ID_ITEM,                    " &
"       SKU.DESCR                            DESC_ITEM,                  " &
"       DEPARTSECTORSKU.SECTOR_NAME          SETOR,                      " &
"       DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,               " &
"       IT.QTY                               QT,                         " &
"       LOC.PUTAWAYZONE                      CLA_ORIGEM,                 " &
"       IT.FROMLOC                           ID_LOC_ORIG,                " &
"       LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,           " &
"       IT.TOLOC                             ID_LOCAL,                   " &
"       aTOLOC.LOGICALLOCATION               DESC_LOC,                   " &
"       aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,                 " &
"       'Concluído'                          ID_SIT,                     " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                   " &
"                                            DT_SIT,                     " &
"       CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                      " &
"              THEN 'PUTAWAY'                                            " &
"            ELSE 'MOVE'                                                 " &
"        END                                 TIPO                        " &
"                                                                        " &
"FROM       WMWHSE7.ITRN          IT                                     " &
"                                                                        " &
"INNER JOIN WMWHSE7.SKU                                                  " &
"        ON SKU.SKU = IT.SKU                                             " &
"                                                                        " &
" LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                  " &
"        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"                                                                        " &
" LEFT JOIN WMWHSE7.taskmanageruser tu                                   " &
"        ON tu.userkey = IT.EDITWHO                                      " &
"                                                                        " &
" LEFT JOIN WMWHSE7.LOC  aTOLOC                                          " &
"        ON aTOLOC.LOC = IT.TOLOC                                        " &
"                                                                        " &
" LEFT JOIN WMWHSE7.LOC                                                  " &
"        ON LOC.LOC = IT.FROMLOC                                         " &
"                                                                        " &
"INNER JOIN WMSADMIN.PL_DB  WMSADMIN                                     " &
"        ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID                         " &
"		                                                                 " &
"WHERE IT.TRANTYPE = 'MV'                                                " &
"  AND IT.SOURCETYPE != 'PICKING'                                        " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,             " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"         AT time zone 'America/Sao_Paulo') AS DATE))                    " &
"        Between '" + Parameters!DataSituacaoDe.Value + "'               " &
"            And '" + Parameters!DataSituacaoAte.Value + "'              " &
"  AND CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')                                         " &
"             THEN 'PUTAWAY'                                                               " &
"           ELSE 'MOVE'                                                                    " &
"       END IN (" + Replace(("'" + JOIN(Parameters!Tipo.Value, "',") + "'"),",",",'") + ") " &
"		                                                                                   " &
"		                                                                 " &
"Order By 1,2,5,6                                                        "

)