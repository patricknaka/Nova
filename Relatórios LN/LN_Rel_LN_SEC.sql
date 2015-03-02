SELECT                                                                   
  ORDERS.WHSEID         PLANTA,                                          
  CL.UDF2               DESC_PLANTA,                                     
  ORDERS.ORDERKEY       PEDIDO,                                          
  ORDERS.INVOICENUMBER  NF,                                              
  ORDERS.LANE           SR,                                              
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                  
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         
      AT time zone sessiontimezone) AS DATE)                             
                        DT_FATURAMENTO,                                  
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       
        AT time zone sessiontimezone) AS DATE)                           
                        DT_FECHA_GAIOLA,                                 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,                   
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       
        AT time zone sessiontimezone) AS DATE)                           
                        DT_LIQ,
    CASE WHEN ORDERS.ACTUALSHIPDATE IS NOT NULL THEN 'FINALIZADO' ELSE 'PENDENTE' END STATUS
FROM       WMWHSE5.ORDERS                                                
 LEFT JOIN WMWHSE5.CAGEIDDETAIL                                          
        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        
 LEFT JOIN WMWHSE5.CAGEID                                                
        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                           
 LEFT JOIN ENTERPRISE.CODELKUP cl                                        
        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)                         
       AND cl.LISTNAME='SCHEMA'                                          
 LEFT JOIN BAANDB.TTCMCS003301@pln01 TCMCS003                            
        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)                 
 LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940                            
        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                      
       AND CISLI940.T$SERI$L = ORDERS.LANE                               
       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR                           
       AND CISLI940.T$DOCN$L ! = 0                                       
    AND CISLI940.T$FDTY$L ! = 11                                         
-- LEFT JOIN ( SELECT MIN(A.T$DTOC$C) DATA_LIQ,                            
--                    A.T$ORNO$C                                           
--               FROM BAANDB.TZNSLS410301@pln01 A                          
--              WHERE A.T$POCO$C IN ('ETR', 'ENT')                         
--           GROUP BY A.T$ORNO$C) TRACK                                    
--        ON TRACK.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                     
WHERE ORDERS.INVOICENUMBER != 0 


=IIF(Parameters!Table.Value <> "AAA",

"SELECT DISTINCT                                                          " &
"  ORDERS.WHSEID         PLANTA,                                          " &
"  CL.UDF2               DESC_PLANTA,                                     " &
"  ORDERS.ORDERKEY       PEDIDO,                                          " &
"  ORDERS.INVOICENUMBER  NF,                                              " &
"  ORDERS.LANE           SR,                                              " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"      AT time zone sessiontimezone) AS DATE)                             " &
"                        DT_FATURAMENTO,                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_FECHA_GAIOLA,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TRACK.DATA_LIQ,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_LIQ                                           " &
"FROM       " + Parameters!Table.Value + ".ORDERS                         " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEIDDETAIL                   " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEID                         " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                           " &
" LEFT JOIN ENTERPRISE.CODELKUP cl                                        " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)                         " &
"       AND cl.LISTNAME='SCHEMA'                                          " &
" LEFT JOIN BAANDB.TTCMCS003301@pln01 TCMCS003                            " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)                 " &
" LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940                            " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                      " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                               " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR                           " &
"       AND CISLI940.T$DOCN$L ! = 0                                       " &
"    AND CISLI940.T$FDTY$L ! = 11                                         " &
" LEFT JOIN ( SELECT MIN(A.T$DTOC$C) DATA_LIQ,                            " &
"                    A.T$ORNO$C                                           " &
"               FROM BAANDB.TZNSLS410301@pln01 A                          " &
"              WHERE A.T$POCO$C IN ('ETR', 'ENT')                         " &
"           GROUP BY A.T$ORNO$C) TRACK                                    " &
"        ON TRACK.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                     " &
"WHERE ORDERS.INVOICENUMBER != 0                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone sessiontimezone) AS DATE))                        " &
"      Between :DataFaturamentoDe                                         " &
"          And :DataFaturamentoAte                                        " &
"ORDER BY DESC_PLANTA, PEDIDO                                             "
                                                                        
,                                                                         
                                                                          
"SELECT                                                                   " &
"  ORDERS.WHSEID         PLANTA,                                          " &
"  CL.UDF2               DESC_PLANTA,                                     " &
"  ORDERS.ORDERKEY       PEDIDO,                                          " &
"  ORDERS.INVOICENUMBER  NF,                                              " &
"  ORDERS.LANE           SR,                                              " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"      AT time zone sessiontimezone) AS DATE)                             " &
"                        DT_FATURAMENTO,                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_FECHA_GAIOLA,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TRACK.DATA_LIQ,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_LIQ                                           " &
"FROM       WMWHSE1.ORDERS                                                " &
" LEFT JOIN WMWHSE1.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
" LEFT JOIN WMWHSE1.CAGEID                                                " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                           " &
" LEFT JOIN ENTERPRISE.CODELKUP cl                                        " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)                         " &
"       AND cl.LISTNAME='SCHEMA'                                          " &
" LEFT JOIN BAANDB.TTCMCS003301@pln01 TCMCS003                            " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)                 " &
" LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940                            " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                      " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                               " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR                           " &
"       AND CISLI940.T$DOCN$L ! = 0                                       " &
"    AND CISLI940.T$FDTY$L ! = 11                                         " &
" LEFT JOIN ( SELECT MIN(A.T$DTOC$C) DATA_LIQ,                            " &
"                    A.T$ORNO$C                                           " &
"               FROM BAANDB.TZNSLS410301@pln01 A                          " &
"              WHERE A.T$POCO$C IN ('ETR', 'ENT')                         " &
"           GROUP BY A.T$ORNO$C) TRACK                                    " &
"        ON TRACK.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                     " &
"WHERE ORDERS.INVOICENUMBER != 0                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone sessiontimezone) AS DATE))                        " &
"      Between :DataFaturamentoDe                                         " &
"          And :DataFaturamentoAte                                        " &
"                                                                         " &
"UNION                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  ORDERS.WHSEID         PLANTA,                                          " &
"  CL.UDF2               DESC_PLANTA,                                     " &
"  ORDERS.ORDERKEY       PEDIDO,                                          " &
"  ORDERS.INVOICENUMBER  NF,                                              " &
"  ORDERS.LANE           SR,                                              " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"      AT time zone sessiontimezone) AS DATE)                             " &
"                        DT_FATURAMENTO,                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_FECHA_GAIOLA,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TRACK.DATA_LIQ,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_LIQ                                           " &
"FROM       WMWHSE2.ORDERS                                                " &
" LEFT JOIN WMWHSE2.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
" LEFT JOIN WMWHSE2.CAGEID                                                " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                           " &
" LEFT JOIN ENTERPRISE.CODELKUP cl                                        " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)                         " &
"       AND cl.LISTNAME='SCHEMA'                                          " &
" LEFT JOIN BAANDB.TTCMCS003301@pln01 TCMCS003                            " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)                 " &
" LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940                            " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                      " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                               " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR                           " &
"       AND CISLI940.T$DOCN$L ! = 0                                       " &
"    AND CISLI940.T$FDTY$L ! = 11                                         " &
" LEFT JOIN ( SELECT MIN(A.T$DTOC$C) DATA_LIQ,                            " &
"                    A.T$ORNO$C                                           " &
"               FROM BAANDB.TZNSLS410301@pln01 A                          " &
"              WHERE A.T$POCO$C IN ('ETR', 'ENT')                         " &
"           GROUP BY A.T$ORNO$C) TRACK                                    " &
"        ON TRACK.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                     " &
"WHERE ORDERS.INVOICENUMBER != 0                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,        " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"          AT time zone sessiontimezone) AS DATE))                        " &
"       Between :DataFaturamentoDe                                        " &
"           And :DataFaturamentoAte                                       " &
"                                                                         " &
"UNION                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  ORDERS.WHSEID         PLANTA,                                          " &
"  CL.UDF2               DESC_PLANTA,                                     " &
"  ORDERS.ORDERKEY       PEDIDO,                                          " &
"  ORDERS.INVOICENUMBER  NF,                                              " &
"  ORDERS.LANE           SR,                                              " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"      AT time zone sessiontimezone) AS DATE)                             " &
"                        DT_FATURAMENTO,                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_FECHA_GAIOLA,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TRACK.DATA_LIQ,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_LIQ                                           " &
"FROM       WMWHSE3.ORDERS                                                " &
" LEFT JOIN WMWHSE3.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
" LEFT JOIN WMWHSE3.CAGEID                                                " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                           " &
" LEFT JOIN ENTERPRISE.CODELKUP cl                                        " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)                         " &
"       AND cl.LISTNAME='SCHEMA'                                          " &
" LEFT JOIN BAANDB.TTCMCS003301@pln01 TCMCS003                            " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)                 " &
" LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940                            " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                      " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                               " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR                           " &
"       AND CISLI940.T$DOCN$L ! = 0                                       " &
"    AND CISLI940.T$FDTY$L ! = 11                                         " &
" LEFT JOIN ( SELECT MIN(A.T$DTOC$C) DATA_LIQ,                            " &
"                    A.T$ORNO$C                                           " &
"               FROM BAANDB.TZNSLS410301@pln01 A                          " &
"              WHERE A.T$POCO$C IN ('ETR', 'ENT')                         " &
"           GROUP BY A.T$ORNO$C) TRACK                                    " &
"        ON TRACK.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                     " &
"WHERE ORDERS.INVOICENUMBER != 0                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone sessiontimezone) AS DATE))                        " &
"      Between :DataFaturamentoDe                                         " &
"          And :DataFaturamentoAte                                        " &
"                                                                         " &
"UNION                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  ORDERS.WHSEID         PLANTA,                                          " &
"  CL.UDF2               DESC_PLANTA,                                     " &
"  ORDERS.ORDERKEY       PEDIDO,                                          " &
"  ORDERS.INVOICENUMBER  NF,                                              " &
"  ORDERS.LANE           SR,                                              " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"      AT time zone sessiontimezone) AS DATE)                             " &
"                        DT_FATURAMENTO,                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_FECHA_GAIOLA,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TRACK.DATA_LIQ,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_LIQ                                           " &
"FROM       WMWHSE4.ORDERS                                                " &
" LEFT JOIN WMWHSE4.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
" LEFT JOIN WMWHSE4.CAGEID                                                " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                           " &
" LEFT JOIN ENTERPRISE.CODELKUP cl                                        " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)                         " &
"       AND cl.LISTNAME='SCHEMA'                                          " &
" LEFT JOIN BAANDB.TTCMCS003301@pln01 TCMCS003                            " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)                 " &
" LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940                            " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                      " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                               " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR                           " &
"       AND CISLI940.T$DOCN$L ! = 0                                       " &
"    AND CISLI940.T$FDTY$L ! = 11                                         " &
" LEFT JOIN ( SELECT MIN(A.T$DTOC$C) DATA_LIQ,                            " &
"                    A.T$ORNO$C                                           " &
"               FROM BAANDB.TZNSLS410301@pln01 A                          " &
"              WHERE A.T$POCO$C IN ('ETR', 'ENT')                         " &
"           GROUP BY A.T$ORNO$C) TRACK                                    " &
"        ON TRACK.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                     " &
"WHERE ORDERS.INVOICENUMBER != 0                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone sessiontimezone) AS DATE))                        " &
"      Between :DataFaturamentoDe                                         " &
"          And :DataFaturamentoAte                                        " &
"                                                                         " &
"UNION                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  ORDERS.WHSEID         PLANTA,                                          " &
"  CL.UDF2               DESC_PLANTA,                                     " &
"  ORDERS.ORDERKEY       PEDIDO,                                          " &
"  ORDERS.INVOICENUMBER  NF,                                              " &
"  ORDERS.LANE           SR,                                              " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"      AT time zone sessiontimezone) AS DATE)                             " &
"                        DT_FATURAMENTO,                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_FECHA_GAIOLA,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TRACK.DATA_LIQ,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_LIQ                                           " &
"FROM       WMWHSE5.ORDERS                                                " &
" LEFT JOIN WMWHSE5.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
" LEFT JOIN WMWHSE5.CAGEID                                                " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                           " &
" LEFT JOIN ENTERPRISE.CODELKUP cl                                        " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)                         " &
"       AND cl.LISTNAME='SCHEMA'                                          " &
" LEFT JOIN BAANDB.TTCMCS003301@pln01 TCMCS003                            " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)                 " &
" LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940                            " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                      " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                               " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR                           " &
"       AND CISLI940.T$DOCN$L ! = 0                                       " &
"    AND CISLI940.T$FDTY$L ! = 11                                         " &
" LEFT JOIN ( SELECT MIN(A.T$DTOC$C) DATA_LIQ,                            " &
"                    A.T$ORNO$C                                           " &
"               FROM BAANDB.TZNSLS410301@pln01 A                          " &
"              WHERE A.T$POCO$C IN ('ETR', 'ENT')                         " &
"           GROUP BY A.T$ORNO$C) TRACK                                    " &
"        ON TRACK.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                     " &
"WHERE ORDERS.INVOICENUMBER != 0                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone sessiontimezone) AS DATE))                        " &
"      Between :DataFaturamentoDe                                         " &
"          And :DataFaturamentoAte                                        " &
"                                                                         " &
"UNION                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  ORDERS.WHSEID         PLANTA,                                          " &
"  CL.UDF2               DESC_PLANTA,                                     " &
"  ORDERS.ORDERKEY       PEDIDO,                                          " &
"  ORDERS.INVOICENUMBER  NF,                                              " &
"  ORDERS.LANE           SR,                                              " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"      AT time zone sessiontimezone) AS DATE)                             " &
"                        DT_FATURAMENTO,                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_FECHA_GAIOLA,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TRACK.DATA_LIQ,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_LIQ                                           " &
"FROM       WMWHSE6.ORDERS                                                " &
" LEFT JOIN WMWHSE6.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
" LEFT JOIN WMWHSE6.CAGEID                                                " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                           " &
" LEFT JOIN ENTERPRISE.CODELKUP cl                                        " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)                         " &
"       AND cl.LISTNAME='SCHEMA'                                          " &
" LEFT JOIN BAANDB.TTCMCS003301@pln01 TCMCS003                            " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)                 " &
" LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940                            " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                      " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                               " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR                           " &
"       AND CISLI940.T$DOCN$L ! = 0                                       " &
"    AND CISLI940.T$FDTY$L ! = 11                                         " &
" LEFT JOIN ( SELECT MIN(A.T$DTOC$C) DATA_LIQ,                            " &
"                    A.T$ORNO$C                                           " &
"               FROM BAANDB.TZNSLS410301@pln01 A                          " &
"              WHERE A.T$POCO$C IN ('ETR', 'ENT')                         " &
"           GROUP BY A.T$ORNO$C) TRACK                                    " &
"        ON TRACK.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                     " &
"WHERE ORDERS.INVOICENUMBER != 0                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone sessiontimezone) AS DATE))                        " &
"      Between :DataFaturamentoDe                                         " &
"          And :DataFaturamentoAte                                        " &
"                                                                         " &
"UNION                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  ORDERS.WHSEID         PLANTA,                                          " &
"  CL.UDF2               DESC_PLANTA,                                     " &
"  ORDERS.ORDERKEY       PEDIDO,                                          " &
"  ORDERS.INVOICENUMBER  NF,                                              " &
"  ORDERS.LANE           SR,                                              " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,                  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')         " &
"      AT time zone sessiontimezone) AS DATE)                             " &
"                        DT_FATURAMENTO,                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_FECHA_GAIOLA,                                 " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TRACK.DATA_LIQ,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                        DT_LIQ                                           " &
"FROM       WMWHSE7.ORDERS                                                " &
" LEFT JOIN WMWHSE7.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
" LEFT JOIN WMWHSE7.CAGEID                                                " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID                           " &
" LEFT JOIN ENTERPRISE.CODELKUP cl                                        " &
"        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)                         " &
"       AND cl.LISTNAME='SCHEMA'                                          " &
" LEFT JOIN BAANDB.TTCMCS003301@pln01 TCMCS003                            " &
"        ON TCMCS003.T$CWAR = SUBSTR(CL.DESCRIPTION,3,10)                 " &
" LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940                            " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                      " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                               " &
"       AND CISLI940.T$SFRA$L = TCMCS003.T$CADR                           " &
"       AND CISLI940.T$DOCN$L ! = 0                                       " &
"    AND CISLI940.T$FDTY$L ! = 11                                         " &
" LEFT JOIN ( SELECT MIN(A.T$DTOC$C) DATA_LIQ,                            " &
"                    A.T$ORNO$C                                           " &
"               FROM BAANDB.TZNSLS410301@pln01 A                          " &
"              WHERE A.T$POCO$C IN ('ETR', 'ENT')                         " &
"           GROUP BY A.T$ORNO$C) TRACK                                    " &
"        ON TRACK.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                     " &
"WHERE ORDERS.INVOICENUMBER != 0                                          " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,        " &
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"          AT time zone sessiontimezone) AS DATE))                        " &
"      Between :DataFaturamentoDe                                         " &
"          And :DataFaturamentoAte                                        " &
"ORDER BY DESC_PLANTA, PEDIDO                                             "
)