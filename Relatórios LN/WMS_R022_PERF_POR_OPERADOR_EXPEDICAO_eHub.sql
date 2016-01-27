SELECT  
    ORDERS.WHSEID                                            ID_PLANTA,
    cl.UDF2                                                  DSC_PLANTA,
    ORDERS.ORDERKEY                                          PEDIDO,
    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE))          DATA,
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  HORA,
    CAGE.EDITWHO                                             ID_USUARIO,
    CASE WHEN subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 ) IS NULL THEN     
          CAGE.EDITWHO
    ELSE subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 ) END NOME_USUARIO,
    sum(ORDERDETAIL.ORIGINALQTY)                             QUANT,
    ORDERS.CARRIERCODE                                       ID_TRANSP,
    ORDERS.CARRIERNAME                                       TRANSP_NOME,
    ORDERS.DISCHARGEPLACE                                    ID_CONTRATO,
    CASE WHEN MAX(TO_CHAR(SKU.SUSR2)) = '2' 
           THEN 'PESADO' 
         ELSE   'LEVE' 
     END                                                     TP_TRANSP_ITEM ,
    MAX(WAVEDETAIL.WAVEKEY)                                  ONDA,
    ORDERS.INVOICENUMBER                                     NF,
    ORDERS.LANE                                              SERIE,
    TRUNC(CAGE.ADDDATE)                                      INCL_GAIOLA,
    CAGE.CAGEID                                              CARGA,
    MAX(CAGE.QT_VOL)                                         NFCA_QT_VOLUMES,
    SUM(NVL(CISLI940.T$AMNT$L, TDSLS400.T$OAMT))             VALOR             

FROM       WMWHSE5.ORDERS

INNER JOIN WMWHSE5.ORDERDETAIL
        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY

INNER JOIN ENTERPRISE.CODELKUP CL
        ON UPPER(CL.UDF1) = ORDERS.WHSEID

INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = ORDERDETAIL.SKU

INNER JOIN ( select cg.cageid,
                    cd.orderid,
                    cg.closedate,
                    cg.addwho,
                    cg.editwho,
                    max(cd.adddate) adddate,
                    count(cd.volumeid) qt_vol
               from wmwhse5.cageid cg
         inner join wmwhse5.cageiddetail cd 
                 on cd.cageid = cg.cageid
              where cg.status in (3,4,5,6) 
           group by cg.cageid,
                    cd.orderid,
                    cg.closedate,
                    cg.addwho,
                    cg.editwho) CAGE 
        ON CAGE.ORDERID = ORDERS.ORDERKEY
       
 LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940 
        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER
       AND CISLI940.T$SERI$L = ORDERS.LANE

 LEFT JOIN BAANDB.TTDSLS400301@PLN01 TDSLS400 
        ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT
        
 LEFT JOIN WMWHSE5.taskmanageruser tu 
        ON tu.userkey = CAGE.EDITWHO

 LEFT JOIN WMWHSE5.WAVEDETAIL
        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY
  
where TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataDe
          And :DataAte
  
GROUP BY ORDERS.WHSEID,                                            
         CL.UDF2,                                         
         ORDERS.ORDERKEY,                                          
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE)),
         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),
         CAGE.EDITWHO,                                
         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                                   
         ORDERS.CARRIERCODE,                                       
         ORDERS.CARRIERNAME,                                       
         ORDERS.DISCHARGEPLACE,                                                                                                      
         ORDERS.INVOICENUMBER,            
         ORDERS.LANE,               
         TRUNC(CAGE.ADDDATE),                            
         CAGE.CAGEID
		 
ORDER BY ORDERS.ORDERKEY               
