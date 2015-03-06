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
    COUNT(distinct IT.sku)                      ITEM,                        
    IT.FROMLOC                         			ORDEM_COL,
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

WHERE   PL_DB.ISACTIVE = 1                                                     
  AND PL_DB.DB_ENTERPRISE = 0                                                

--  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(IT.ADDDATE, 
--        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--          AT time zone 'America/Sao_Paulo') AS DATE)) 
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
         IT.FROMLOC        
   
ORDER BY 2