SELECT                                                                                        
  CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' ' THEN 'INT'                                         
   ELSE TDSLS400.T$CREG END                            CANAL,                                 
  ORDERS.whseid                                        ID_FILIAL,                             
  CODELKUP.UDF2                                        DESCR_FILIAL,                          
  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                          
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                              
      AT time zone 'America/Sao_Paulo') AS DATE),'DD')     DATA_LIMITE,                           
  ORDERS.SUSR4                                          UNEG,                                                            
  nvl(OH.STATUS, ORDERS.STATUS)                        ULT_EVENTO,                            
  OS.DESCRIPTION                                       ULT_EVENTO_DESCR,                      
  COUNT(DISTINCT ORDERS.ORDERKEY)                      PEDIDOS,                               
  CASE WHEN ORDERS.SCHEDULEDSHIPDATE<ORDERS.ADDDATE 
  THEN 
      'ATRASO TERCEIRO'                    
  WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                          
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                        
            AT time zone 'America/Sao_Paulo') AS DATE)<SYSDATE 
  THEN 
      'ATRASO OP'                   
  ELSE 
      ' ' 
  END                                                  DIF_ATRASO_TERCEIRO,                   
  ORDERS.ADDDATE                                       DATA_REGISTRO                          
                                                                                              
FROM      WMWHSE5.ORDERS                                                                      

INNER JOIN baandb.tznsls401301@pln01 znsls401
       ON znsls401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT
                                                                                              
LEFT JOIN BAANDB.TTDSLS400301@pln01 TDSLS400                                                  
       ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT                                          
                                                                                              
LEFT JOIN ( select a.orderkey,                                                                
                   a.status from WMWHSE5.orderstatushistory a                                 
             where a.serialkey = (SELECT MAX(b.serialkey)                                     
                                    FROM WMWHSE5.orderstatushistory b                         
                                   WHERE b.orderkey = a.orderkey) ) OH                        
       ON OH.ORDERKEY = ORDERS.ORDERKEY                                                       
                                                                                              
LEFT JOIN ( select to_char(a.code) code,                                                      
                   to_char(a.description) description                                         
              from WMWHSE5.ORDERSTATUSSETUP a                                                 
            union                                                                             
            select '-5',                                                                      
                   'Nota fiscal Inutilizada'                                                  
              from dual) OS                                                                   
       ON OS.CODE = nvl(OH.STATUS, ORDERS.STATUS)                                             
                                                                                              
LEFT JOIN WMWHSE5.CODELKUP                                                                    
       ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)                                         
      AND CODELKUP.LISTNAME = 'SCHEMA'                                                        
                                                                                              
WHERE ORDERS.STATUS not in ('95', '96', '97', '98', '99', '100')       
AND	   TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                          
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                              
      AT time zone 'America/Sao_Paulo') AS DATE),'DD') between :DataLimiteDe and :DataLimiteAte
                                                                                              
GROUP BY CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' ' THEN 'INT'                                  
          ELSE TDSLS400.T$CREG END,                                                           
         ORDERS.whseid,                                                                       
         CODELKUP.UDF2,                                                                       
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                   
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                       
             AT time zone 'America/Sao_Paulo') AS DATE),'DD'),                                    
         ORDERS.SUSR4,                                                                        
         nvl(OH.STATUS, ORDERS.STATUS),                                                       
         OS.DESCRIPTION,                                                                      
         CASE WHEN ORDERS.SCHEDULEDSHIPDATE<ORDERS.ADDDATE THEN 'ATRASO TERCEIRO'             
          WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                   
                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 
                   AT time zone 'America/Sao_Paulo') AS DATE)<SYSDATE THEN 'ATRASO OP'            
           ELSE ' ' END,                                                                      
         ORDERS.ADDDATE                        
