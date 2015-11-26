SELECT                                                                   
  ORDERS.WHSEID         PLANTA,                                          
  CL.UDF2               DESC_PLANTA,                                     
  ORDERS.ORDERKEY       PEDIDO,                                          
  ORDERS.INVOICENUMBER  NF,                                              
  ORDERS.LANE           SR,                                              
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                  
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         
      AT time zone 'America/Sao_Paulo') AS DATE)                             
                        DT_FATURAMENTO,

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

LEFT JOIN ( select CAGEIDDETAIL.ORDERID,
                   CAGEIDDETAIL.CAGEID 
              from WMWHSE5.CAGEIDDETAIL
          group by CAGEIDDETAIL.ORDERID,
                   CAGEIDDETAIL.CAGEID ) CAGEIDDETAIL
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
	
WHERE TO_CHAR(ORDERS.INVOICENUMBER) != '0'
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataFaturamentoDe
          And :DataFaturamentoAte



		  
=IIF(Parameters!Table.Value <> "AAA",

" SELECT  " &
"   ORDERS.WHSEID         PLANTA,  " &
"   CL.UDF2               DESC_PLANTA,  " &
"   ORDERS.ORDERKEY       PEDIDO,  " &
"   ORDERS.INVOICENUMBER  NF,  " &
"   ORDERS.LANE           SR,  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                         DT_FATURAMENTO,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_FECHA_GAIOLA,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_LIQ,  " &
"  " &
"   CASE WHEN ORDERS.ACTUALSHIPDATE IS NOT NULL  " &
"          THEN 'FINALIZADO'  " &
"        ELSE   'PENDENTE'  " &
"    END                STATUS  " &
"  " &
" FROM      " + Parameters!Table.Value + ".ORDERS  " &
"  " &
" LEFT JOIN ( select CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID  " &
"               from " + Parameters!Table.Value + ".CAGEIDDETAIL  " &
"           group by CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID ) CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)  " &
"       AND cl.LISTNAME = 'SCHEMA'  " &
"  " &
" LEFT JOIN BAANDB.TTCMCS003201@dln01 TCMCS003  " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)  " &
"  " &
" LEFT JOIN BAANDB.tcisli940201@dln01 CISLI940  " &
"        ON TO_CHAR(CISLI940.T$DOCN$L) = TRIM(ORDERS.INVOICENUMBER)  " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE  " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR  " &
"       AND CISLI940.T$DOCN$L != 0  " &
"       AND CISLI940.T$FDTY$L != 11  " &
"  " &
" WHERE TO_CHAR(ORDERS.INVOICENUMBER) != '0'  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataFaturamentoDe  " &
"           And :DataFaturamentoAte  " &
"  " &
"ORDER BY DESC_PLANTA, PEDIDO  "
                                                                        
,                                                                         
                                                                          
" SELECT  " &
"   ORDERS.WHSEID         PLANTA,  " &
"   CL.UDF2               DESC_PLANTA,  " &
"   ORDERS.ORDERKEY       PEDIDO,  " &
"   ORDERS.INVOICENUMBER  NF,  " &
"   ORDERS.LANE           SR,  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                         DT_FATURAMENTO,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_FECHA_GAIOLA,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_LIQ,  " &
"  " &
"   CASE WHEN ORDERS.ACTUALSHIPDATE IS NOT NULL  " &
"          THEN 'FINALIZADO'  " &
"        ELSE   'PENDENTE'  " &
"    END                STATUS  " &
"  " &
" FROM      WMWHSE1.ORDERS  " &
"  " &
" LEFT JOIN ( select CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID  " &
"               from WMWHSE1.CAGEIDDETAIL  " &
"           group by CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID ) CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE1.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)  " &
"       AND cl.LISTNAME = 'SCHEMA'  " &
"  " &
" LEFT JOIN BAANDB.TTCMCS003201@dln01 TCMCS003  " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)  " &
"  " &
" LEFT JOIN BAANDB.tcisli940201@dln01 CISLI940  " &
"        ON TO_CHAR(CISLI940.T$DOCN$L) = TRIM(ORDERS.INVOICENUMBER)  " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE  " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR  " &
"       AND CISLI940.T$DOCN$L != 0  " &
"       AND CISLI940.T$FDTY$L != 11  " &
"  " &
" WHERE TO_CHAR(ORDERS.INVOICENUMBER) != '0'  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataFaturamentoDe  " &
"           And :DataFaturamentoAte  " &
"  " &
"Union  " &
"  " &
" SELECT  " &
"   ORDERS.WHSEID         PLANTA,  " &
"   CL.UDF2               DESC_PLANTA,  " &
"   ORDERS.ORDERKEY       PEDIDO,  " &
"   ORDERS.INVOICENUMBER  NF,  " &
"   ORDERS.LANE           SR,  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                         DT_FATURAMENTO,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_FECHA_GAIOLA,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_LIQ,  " &
"  " &
"   CASE WHEN ORDERS.ACTUALSHIPDATE IS NOT NULL  " &
"          THEN 'FINALIZADO'  " &
"        ELSE   'PENDENTE'  " &
"    END                STATUS  " &
"  " &
" FROM      WMWHSE2.ORDERS  " &
"  " &
" LEFT JOIN ( select CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID  " &
"               from WMWHSE2.CAGEIDDETAIL  " &
"           group by CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID ) CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE2.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)  " &
"       AND cl.LISTNAME = 'SCHEMA'  " &
"  " &
" LEFT JOIN BAANDB.TTCMCS003201@dln01 TCMCS003  " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)  " &
"  " &
" LEFT JOIN BAANDB.tcisli940201@dln01 CISLI940  " &
"        ON TO_CHAR(CISLI940.T$DOCN$L) = TRIM(ORDERS.INVOICENUMBER)  " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE  " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR  " &
"       AND CISLI940.T$DOCN$L != 0  " &
"       AND CISLI940.T$FDTY$L != 11  " &
"  " &
" WHERE TO_CHAR(ORDERS.INVOICENUMBER) != '0'  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataFaturamentoDe  " &
"           And :DataFaturamentoAte  " &
"  " &
"Union  " &
"  " &
" SELECT  " &
"   ORDERS.WHSEID         PLANTA,  " &
"   CL.UDF2               DESC_PLANTA,  " &
"   ORDERS.ORDERKEY       PEDIDO,  " &
"   ORDERS.INVOICENUMBER  NF,  " &
"   ORDERS.LANE           SR,  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                         DT_FATURAMENTO,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_FECHA_GAIOLA,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_LIQ,  " &
"  " &
"   CASE WHEN ORDERS.ACTUALSHIPDATE IS NOT NULL  " &
"          THEN 'FINALIZADO'  " &
"        ELSE   'PENDENTE'  " &
"    END                STATUS  " &
"  " &
" FROM      WMWHSE3.ORDERS  " &
"  " &
" LEFT JOIN ( select CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID  " &
"               from WMWHSE3.CAGEIDDETAIL  " &
"           group by CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID ) CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE3.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)  " &
"       AND cl.LISTNAME = 'SCHEMA'  " &
"  " &
" LEFT JOIN BAANDB.TTCMCS003201@dln01 TCMCS003  " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)  " &
"  " &
" LEFT JOIN BAANDB.tcisli940201@dln01 CISLI940  " &
"        ON TO_CHAR(CISLI940.T$DOCN$L) = TRIM(ORDERS.INVOICENUMBER)  " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE  " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR  " &
"       AND CISLI940.T$DOCN$L != 0  " &
"       AND CISLI940.T$FDTY$L != 11  " &
"  " &
" WHERE TO_CHAR(ORDERS.INVOICENUMBER) != '0'  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataFaturamentoDe  " &
"           And :DataFaturamentoAte  " &
"  " &
"Union  " &
"  " &
" SELECT  " &
"   ORDERS.WHSEID         PLANTA,  " &
"   CL.UDF2               DESC_PLANTA,  " &
"   ORDERS.ORDERKEY       PEDIDO,  " &
"   ORDERS.INVOICENUMBER  NF,  " &
"   ORDERS.LANE           SR,  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                         DT_FATURAMENTO,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_FECHA_GAIOLA,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_LIQ,  " &
"  " &
"   CASE WHEN ORDERS.ACTUALSHIPDATE IS NOT NULL  " &
"          THEN 'FINALIZADO'  " &
"        ELSE   'PENDENTE'  " &
"    END                STATUS  " &
"  " &
" FROM      WMWHSE4.ORDERS  " &
"  " &
" LEFT JOIN ( select CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID  " &
"               from WMWHSE4.CAGEIDDETAIL  " &
"           group by CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID ) CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE4.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)  " &
"       AND cl.LISTNAME = 'SCHEMA'  " &
"  " &
" LEFT JOIN BAANDB.TTCMCS003201@dln01 TCMCS003  " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)  " &
"  " &
" LEFT JOIN BAANDB.tcisli940201@dln01 CISLI940  " &
"        ON TO_CHAR(CISLI940.T$DOCN$L) = TRIM(ORDERS.INVOICENUMBER)  " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE  " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR  " &
"       AND CISLI940.T$DOCN$L != 0  " &
"       AND CISLI940.T$FDTY$L != 11  " &
"  " &
" WHERE TO_CHAR(ORDERS.INVOICENUMBER) != '0'  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataFaturamentoDe  " &
"           And :DataFaturamentoAte  " &
"  " &
"Union  " &
"  " &
" SELECT  " &
"   ORDERS.WHSEID         PLANTA,  " &
"   CL.UDF2               DESC_PLANTA,  " &
"   ORDERS.ORDERKEY       PEDIDO,  " &
"   ORDERS.INVOICENUMBER  NF,  " &
"   ORDERS.LANE           SR,  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                         DT_FATURAMENTO,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_FECHA_GAIOLA,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_LIQ,  " &
"  " &
"   CASE WHEN ORDERS.ACTUALSHIPDATE IS NOT NULL  " &
"          THEN 'FINALIZADO'  " &
"        ELSE   'PENDENTE'  " &
"    END                STATUS  " &
"  " &
" FROM      WMWHSE5.ORDERS  " &
"  " &
" LEFT JOIN ( select CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID  " &
"               from WMWHSE5.CAGEIDDETAIL  " &
"           group by CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID ) CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE5.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)  " &
"       AND cl.LISTNAME = 'SCHEMA'  " &
"  " &
" LEFT JOIN BAANDB.TTCMCS003201@dln01 TCMCS003  " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)  " &
"  " &
" LEFT JOIN BAANDB.tcisli940201@dln01 CISLI940  " &
"        ON TO_CHAR(CISLI940.T$DOCN$L) = TRIM(ORDERS.INVOICENUMBER)  " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE  " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR  " &
"       AND CISLI940.T$DOCN$L != 0  " &
"       AND CISLI940.T$FDTY$L != 11  " &
"  " &
" WHERE TO_CHAR(ORDERS.INVOICENUMBER) != '0'  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataFaturamentoDe  " &
"           And :DataFaturamentoAte  " &
"  " &
"Union  " &
"  " &
" SELECT  " &
"   ORDERS.WHSEID         PLANTA,  " &
"   CL.UDF2               DESC_PLANTA,  " &
"   ORDERS.ORDERKEY       PEDIDO,  " &
"   ORDERS.INVOICENUMBER  NF,  " &
"   ORDERS.LANE           SR,  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                         DT_FATURAMENTO,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_FECHA_GAIOLA,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_LIQ,  " &
"  " &
"   CASE WHEN ORDERS.ACTUALSHIPDATE IS NOT NULL  " &
"          THEN 'FINALIZADO'  " &
"        ELSE   'PENDENTE'  " &
"    END                STATUS  " &
"  " &
" FROM      WMWHSE6.ORDERS  " &
"  " &
" LEFT JOIN ( select CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID  " &
"               from WMWHSE6.CAGEIDDETAIL  " &
"           group by CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID ) CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE6.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)  " &
"       AND cl.LISTNAME = 'SCHEMA'  " &
"  " &
" LEFT JOIN BAANDB.TTCMCS003201@dln01 TCMCS003  " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)  " &
"  " &
" LEFT JOIN BAANDB.tcisli940201@dln01 CISLI940  " &
"        ON TO_CHAR(CISLI940.T$DOCN$L) = TRIM(ORDERS.INVOICENUMBER)  " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE  " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR  " &
"       AND CISLI940.T$DOCN$L != 0  " &
"       AND CISLI940.T$FDTY$L != 11  " &
"  " &
" WHERE TO_CHAR(ORDERS.INVOICENUMBER) != '0'  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataFaturamentoDe  " &
"           And :DataFaturamentoAte  " &
"  " &
"Union  " &
"  " &
" SELECT  " &
"   ORDERS.WHSEID         PLANTA,  " &
"   CL.UDF2               DESC_PLANTA,  " &
"   ORDERS.ORDERKEY       PEDIDO,  " &
"   ORDERS.INVOICENUMBER  NF,  " &
"   ORDERS.LANE           SR,  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                         DT_FATURAMENTO,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_FECHA_GAIOLA,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                       DT_LIQ,  " &
"  " &
"   CASE WHEN ORDERS.ACTUALSHIPDATE IS NOT NULL  " &
"          THEN 'FINALIZADO'  " &
"        ELSE   'PENDENTE'  " &
"    END                STATUS  " &
"  " &
" FROM      WMWHSE7.ORDERS  " &
"  " &
" LEFT JOIN ( select CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID  " &
"               from WMWHSE7.CAGEIDDETAIL  " &
"           group by CAGEIDDETAIL.ORDERID,  " &
"                    CAGEIDDETAIL.CAGEID ) CAGEIDDETAIL  " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE7.CAGEID  " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
"  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)  " &
"       AND cl.LISTNAME = 'SCHEMA'  " &
"  " &
" LEFT JOIN BAANDB.TTCMCS003201@dln01 TCMCS003  " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)  " &
"  " &
" LEFT JOIN BAANDB.tcisli940201@dln01 CISLI940  " &
"        ON TO_CHAR(CISLI940.T$DOCN$L) = TRIM(ORDERS.INVOICENUMBER)  " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE  " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR  " &
"       AND CISLI940.T$DOCN$L != 0  " &
"       AND CISLI940.T$FDTY$L != 11  " &
"  " &
" WHERE TO_CHAR(ORDERS.INVOICENUMBER) != '0'  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataFaturamentoDe  " &
"           And :DataFaturamentoAte  " &
"  " &
"ORDER BY DESC_PLANTA, PEDIDO  "

)