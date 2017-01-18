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
       LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,    
       CASE WHEN Trim(TO_CHAR(ll_ORIGEM.holdreason)) is null
              THEN 'OK'
            ELSE  TO_CHAR(ll_ORIGEM.holdreason)
       END                                  RESTRICAO_ORIGEM, 
       CASE WHEN Trim(TO_CHAR(ll_DESTINO.holdreason)) is null
              THEN 'OK'
            ELSE  TO_CHAR(ll_DESTINO.holdreason)
       END                                  RESTRICAO_DESTINO, 
       IT.TOLOC                             ID_LOCAL,                            
       aTOLOC.LOGICALLOCATION               DESC_LOC,                            
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
       STORER.COMPANY                       FORNECEDOR,                          
       NVL(maucLN.mauc, 0) * IT.QTY         VALOR,
       CASE WHEN TO_CHAR(IH_ORIGEM.STATUS) IS NULL  
             THEN 'OK'  
            ELSE TO_CHAR(IH_ORIGEM.STATUS) END       STATUS_ORIGEM,  
       CASE WHEN TO_CHAR(IH_DESTINO.STATUS) IS NULL  
             THEN 'OK' 
            ELSE TO_CHAR(IH_DESTINO.STATUS) END      STATUS_DESTINO    

FROM       WMWHSE5.ITRN  IT

INNER JOIN WMWHSE5.SKU                                    
        ON SKU.SKU = IT.SKU
        
 LEFT JOIN ( select distinct 
                    ll.holdreason,
                    ll.LOC
               from WMWHSE5.lotxloc ll
              where Trim(ll.holdreason) is not null ) ll_ORIGEM
        ON ll_ORIGEM.LOC = IT.FROMLOC

 LEFT JOIN  ( select distinct 
                    ll.holdreason,
                    ll.LOC
               from WMWHSE5.lotxloc ll
              where Trim(ll.holdreason) is not null ) ll_DESTINO
        ON ll_DESTINO.LOC = IT.TOLOC
		
 LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU                           
        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)            
       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)           

 LEFT JOIN WMWHSE5.taskmanageruser  tu                    
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

 LEFT JOIN ENTERPRISE.CODELKUP  cl                                               
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
       
   left join WMWHSE5.INVENTORYHOLD IH_ORIGEM  
   	  on IH_ORIGEM.LOC = IT.FROMLOC  
       
   left join WMWHSE5..INVENTORYHOLD IH_DESTINO  
          on IH_DESTINO.LOC = IT.TOLOC  

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
           

  

  
=

" SELECT WMSADMIN.DB_ALIAS                    PLANTA,  " &
"        TO_CHAR(IT.ITRNKEY)                  ID_OM,  " &
"        IT.EDITWHO                           ROMA_ID_OPERADOR,  " &
"        subStr( tu.usr_name,4,  " &
"                inStr(tu.usr_name, ',') -4 ) USUA_NOME,  " &
"        IT.SKU                               ID_ITEM,  " &
"        SKU.DESCR                            DESC_ITEM,  " &
"        DEPARTSECTORSKU.SECTOR_NAME          SETOR,  " &
"        DEPARTSECTORSKU.DEPART_NAME          DEPARTAMENTO,  " &
"        IT.QTY                               QT,  " &
"        LOC.PUTAWAYZONE                      CLA_ORIGEM,  " &
"        IT.FROMLOC                           ID_LOC_ORIG,  " &
"        LOC.LOGICALLOCATION                  ID_DESC_LOC_ORIG,  " &
"        CASE WHEN Trim(TO_CHAR(ll_ORIGEM.holdreason)) is null  " &
"               THEN 'OK'  " &
"             ELSE  TO_CHAR(ll_ORIGEM.holdreason)  " &
"        END                                  RESTRICAO_ORIGEM,  " &
"        CASE WHEN Trim(TO_CHAR(ll_DESTINO.holdreason)) is null  " &
"               THEN 'OK'  " &
"             ELSE  TO_CHAR(ll_DESTINO.holdreason)  " &
"        END                                  RESTRICAO_DESTINO,  " &
"        IT.TOLOC                             ID_LOCAL,  " &
"        aTOLOC.LOGICALLOCATION               DESC_LOC,  " &
"        aTOLOC.PUTAWAYZONE                   ID_CLA_LOC,  " &
"        'Concluído'                          ID_SIT,  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                             DT_SIT,  " &
"        CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')  " &
"               THEN 'PUTAWAY'  " &
"             ELSE 'MOVE'  " &
"         END                                 TIPO,  " &
"        STORER.COMPANY                       FORNECEDOR,  " &
"        NVL(maucLN.mauc, 0) * IT.QTY         VALOR,  " &
"       CASE WHEN TO_CHAR(IH_ORIGEM.STATUS) IS NULL  " & 
"             THEN 'OK'  " &
"            ELSE TO_CHAR(IH_ORIGEM.STATUS) END       STATUS_ORIGEM,  " &
"       CASE WHEN TO_CHAR(IH_DESTINO.STATUS) IS NULL   " &
"             THEN 'OK'  " &
"            ELSE TO_CHAR(IH_DESTINO.STATUS) END      STATUS_DESTINO  " &  
"  " &
" FROM       " + Parameters!Table.Value + ".ITRN  IT  " &
"  " &
" INNER JOIN " + Parameters!Table.Value + ".SKU  " &
"         ON SKU.SKU = IT.SKU  " &
"  " &
"  LEFT JOIN ( select distinct  " &
"                     ll.holdreason,  " &
"                     ll.LOC  " &
"                from " + Parameters!Table.Value + ".lotxloc ll  " &
"               where Trim(ll.holdreason) is not null ) ll_ORIGEM  " &
"         ON ll_ORIGEM.LOC = IT.FROMLOC  " &
"  " &
"  LEFT JOIN  ( select distinct  " &
"                     ll.holdreason,  " &
"                     ll.LOC  " &
"                from " + Parameters!Table.Value + ".lotxloc ll  " &
"               where Trim(ll.holdreason) is not null ) ll_DESTINO  " &
"         ON ll_DESTINO.LOC = IT.TOLOC  " &
"  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU  " &
"         ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"        AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  " &
"  LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser  tu  " &
"         ON tu.userkey = IT.EDITWHO  " &
"  " &
"  LEFT JOIN " + Parameters!Table.Value + ".LOC  aTOLOC  " &
"         ON aTOLOC.LOC = IT.TOLOC  " &
"  " &
"  LEFT JOIN " + Parameters!Table.Value + ".LOC  " &
"         ON LOC.LOC = IT.FROMLOC  " &
"  " &
" INNER JOIN WMSADMIN.PL_DB  WMSADMIN  " &
"         ON UPPER(WMSADMIN.DB_LOGID) = IT.WHSEID  " &
"  " &
"  LEFT JOIN " + Parameters!Table.Value + ".STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"        AND STORER.TYPE = 5  " &
"  " &
"  LEFT JOIN ENTERPRISE.CODELKUP  cl  " &
"         ON UPPER(cl.UDF1) = IT.WHSEID  " &
"        AND cl.LISTNAME = 'SCHEMA'  " &
"  " &
"  LEFT JOIN ( select trim(whwmd217.t$item) item,  " &
"                     whwmd217.t$cwar cwar,  " &
"                     case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &
"                            then sum(whwmd217.t$ftpa$1)  " &
"                          else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc  " &
"                from baandb.twhwmd217301@pln01 whwmd217  " &
"           left join baandb.twhinr140301@pln01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN  " &
"         ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN.item = IT.sku  " &
"  " &
"   left join " + Parameters!Table.Value + ".INVENTORYHOLD IH_ORIGEM  " &
"          on IH_ORIGEM.LOC = IT.FROMLOC  " &
"  " &       
"   left join " + Parameters!Table.Value + ".INVENTORYHOLD IH_DESTINO  " &
"          on IH_DESTINO.LOC = IT.TOLOC  " &
"  " &
" WHERE IT.TRANTYPE = 'MV'  " &
"   AND IT.SOURCETYPE != 'PICKING'  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.EDITDATE,  " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"          AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between '" + Parameters!DataSituacaoDe.Value + "'  " &
"           And '" + Parameters!DataSituacaoAte.Value + "'  " &
"   AND CASE WHEN IT.FROMLOC IN ('STAGE', 'RETURN')  " &
"              THEN 'PUTAWAY'  " &
"            ELSE 'MOVE'  " &
"       END IN (" + Replace(("'" + JOIN(Parameters!Tipo.Value, "',") + "'"),",",",'") + ")  " &
"  " &
"Order By 1,2,5,6  "

