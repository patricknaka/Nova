SELECT                                                                     
  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,             
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           
      AT time zone 'America/Sao_Paulo') AS DATE), 'DD')                        
                                DATA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                   
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           
      AT time zone 'America/Sao_Paulo') AS DATE)                               
                                HORA_FECHADA,                                    
  znsls401.t$pecl$c             PEDIDO,
  znsls002.t$dsca$c             TIPO_ENTREGA,
  taskdetail.addwho             OPERADOR,                                  
  subStr( tu.usr_name, 4,                                                  
          inStr(tu.usr_name, ',') -4 )                                     
                                NOME_OPERADOR,                                   
  SUM(taskdetail.qty)           QUANT,
  pickdetail.sku                ITEM,                                      
  tcibd001.t$dscb$c             DESCR_ITEM,
  tcibd001.t$cean               EAN,
  tcmcs023.t$dsca               DEPARTAMENTO,
  znmcs030.t$dsca$c             SETOR,
  loc.PUTAWAYZONE               ZONA,
  putawayzone.DESCR             DESC_ZONA,
  itrn.FROMLOC                  LOCAL,
  Q1.mauc                       PRECO
      
                                                                           
FROM    WMWHSE9.pickdetail                  

INNER JOIN WMWHSE9.taskdetail
        ON taskdetail.SOURCETYPE = 'PICKDETAIL'
       AND taskdetail.SOURCEKEY = pickdetail.PICKDETAILKEY

INNER JOIN  WMWHSE9.orderdetail                        
        ON orderdetail.ORDERKEY = pickdetail.ORDERKEY
       AND orderdetail.ORDERLINENUMBER = pickdetail.ORDERLINENUMBER

INNER JOIN baandb.tznsls401601@pln01 znsls401
        ON znsls401.t$orno$c = orderdetail.SALESORDERDOCUMENT
       AND znsls401.t$pono$c = orderdetail.SALESORDERLINE

INNER JOIN baandb.ttcibd001601@pln01 tcibd001
        ON tcibd001.t$item = znsls401.t$itml$c

INNER JOIN baandb.ttcmcs023601@pln01 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
        
INNER JOIN baandb.tznmcs030601@pln01 znmcs030
        ON znmcs030.t$seto$c = tcibd001.t$seto$c
       AND znmcs030.t$citg$c = tcibd001.t$citg
       
left JOIN WMWHSE9.itrn
        ON itrn.TRANTYPE = 'MV'
       AND itrn.SOURCEKEY = pickdetail.PICKDETAILKEY
       AND itrn.SOURCETYPE = 'PICKING'

INNER JOIN WMWHSE9.loc
        ON loc.LOC = itrn.FROMLOC

INNER JOIN WMWHSE9.putawayzone
        ON putawayzone.PUTAWAYZONE = loc.PUTAWAYZONE

LEFT JOIN baandb.tznsls002601@pln01 znsls002
        ON znsls002.t$tpen$c = znsls401.t$itpe$c

LEFT JOIN ( select whwmd217.t$item,
                   case when (max(whwmd215.t$qhnd)) = 0 then 0
                   else round(sum(whwmd217.t$mauc$1) / (max(whwmd215.t$qhnd)), 4) end mauc
             from baandb.twhwmd217601@pln01 whwmd217
                    inner join baandb.twhwmd215601@pln01 whwmd215
                            on whwmd215.t$item = whwmd217.t$item
             group by  whwmd217.t$item) Q1 
        ON Q1.t$item = znsls401.t$itml$c 
                  
 LEFT JOIN  WMWHSE9.taskmanageruser tu               
        ON tu.userkey = taskdetail.EDITWHO,                                
                                                                           
           WMSADMIN.PL_DB                                                  
                                                                           
WHERE taskdetail.status = 9                                                
  AND taskdetail.tasktype = 'PK'                                           
  AND UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)                     
  AND PL_DB.ISACTIVE = 1                                                   
  AND PL_DB.DB_ENTERPRISE = 0
                                                                             
GROUP BY  
          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,             
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           
          AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),                        
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime,                   
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')           
          AT time zone 'America/Sao_Paulo') AS DATE),                                                                   
          znsls401.t$pecl$c,
          znsls002.t$dsca$c,
          taskdetail.addwho,                                  
          subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 ),
          pickdetail.sku,                                      
          tcibd001.t$dscb$c,
          tcibd001.t$cean,
          tcmcs023.t$dsca,
          znmcs030.t$dsca$c,
          loc.PUTAWAYZONE,
          putawayzone.DESCR,
          itrn.FROMLOC,
          Q1.mauc
          
ORDER BY DATA, HORA_FECHADA, PEDIDO
