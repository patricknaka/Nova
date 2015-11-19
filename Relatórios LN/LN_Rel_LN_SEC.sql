SELECT                                                                   
  ORDERS.WHSEID         PLANTA,                                          
  CL.UDF2               DESC_PLANTA,                                     
  ORDERS.ORDERKEY       PEDIDO,                                          
  NVL(CISLI940.T$DOCN$L, CISLI940_2.T$DOCN$L)  NF,
  CISLI245.T$FIRE$L     NF2,
  ORDERS.LANE           SR,
  CASE WHEN CISLI940.T$FIRE$L IS NULL THEN
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940_2.t$date$l,                  
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         
      AT time zone 'America/Sao_Paulo') AS DATE)
  ELSE
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                  
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         
      AT time zone 'America/Sao_Paulo') AS DATE)                             
  END                      DT_FATURAMENTO,

  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       
      AT time zone 'America/Sao_Paulo') AS DATE)                           
                      DT_FECHA_GAIOLA,

  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,                   
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       
      AT time zone 'America/Sao_Paulo') AS DATE)
                      DT_LIQ,
					  
  CASE WHEN ORDERS.ACTUALSHIPDATE IS NOT NULL 
         THEN 'FINALIZADO' 
       ELSE   'PENDENTE' 
   END                STATUS   
 
FROM      WMWHSE5.ORDERS

LEFT JOIN WMWHSE5.CAGEIDDETAIL
       ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY

LEFT JOIN WMWHSE5.CAGEID
       ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID

LEFT JOIN ENTERPRISE.CODELKUP cl
       ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)
      AND cl.LISTNAME = 'SCHEMA'
	   
LEFT JOIN BAANDB.TTCMCS003301@pln01 TCMCS003
       ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)
		
LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940
       ON TO_CHAR(CISLI940.T$DOCN$L) = TRIM(ORDERS.INVOICENUMBER)
      AND CISLI940.T$SERI$L = ORDERS.LANE
      AND CISLI940.T$SFRA$L = TCMCS003.T$CADR
      AND CISLI940.T$DOCN$L != 0
      AND CISLI940.T$FDTY$L != 11
	
LEFT JOIN ( select  a.t$slso,
                    a.t$fire$l,
                    max(a.t$shpm) EXP
            from BAANDB.tcisli245301@pln01 a 
            group by a.t$slso, a.t$fire$l) CISLI245
       ON CISLI245.t$slso = SUBSTR(ORDERS.REFERENCEDOCUMENT,4,9)

LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940_2
       ON CISLI940_2.T$FIRE$L = CISLI245.T$FIRE$L

WHERE ( cisli940.t$docn$l != 0 OR cisli940_2.t$docn$l != 0 )

  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataFaturamentoDe
          And :DataFaturamentoAte

order by ORDERS.ORDERKEY
