SELECT 
  Q1.DATA,
  Q1.HORA,
  Q1.ID_LOCAL,
  Q1.DESCR_LOCAL,
  SUM(CASE WHEN Q1.TIPO='SAIDA' THEN Q1.PEDIDOS ELSE 0 END) PEDIDOS_SAIDA,
  SUM(CASE WHEN Q1.TIPO='ENTRADA' THEN Q1.PEDIDOS ELSE 0 END) PEDIDOS_ENTRADA
FROM
(SELECT                                                                    
  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ACTUALSHIPDATE,                     
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          
      AT time zone sessiontimezone) AS DATE))         DATA,               
  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ACTUALSHIPDATE,                     
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          
      AT time zone sessiontimezone) AS DATE), 'HH24') HORA,               
  O.WHSEID                                            ID_LOCAL,           
  ( select a.UDF2                                                         
     from ENTERPRISE.CODELKUP a                                           
    where upper(a.UDF1) = O.WHSEID                                        
      and a.listname = 'SCHEMA' )                     DESCR_LOCAL,        
  COUNT(O.ORDERKEY)                                   PEDIDOS,             
  'SAIDA'                                             TIPO                                                                        
FROM    WMWHSE5.ORDERS O                           
                      
WHERE O.STATUS='95'   
AND O.ACTUALSHIPDATE IS NOT NULL
GROUP BY  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ACTUALSHIPDATE,             
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
              AT time zone sessiontimezone) AS DATE)),                    
          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ACTUALSHIPDATE,             
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
              AT time zone sessiontimezone) AS DATE), 'HH24'),            
          O.WHSEID                                                        
                                                                        
UNION
SELECT                                                                    
  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.RECEIPTDATE,                     
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          
      AT time zone sessiontimezone) AS DATE))         DATA,               
  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.RECEIPTDATE,                     
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          
      AT time zone sessiontimezone) AS DATE), 'HH24') HORA,               
  O.WHSEID                                            ID_LOCAL,           
  ( select a.UDF2                                                         
     from ENTERPRISE.CODELKUP a                                           
    where upper(a.UDF1) = O.WHSEID                                        
      and a.listname = 'SCHEMA' )                     DESCR_LOCAL,        
  COUNT(O.RECEIPTKEY)                                   PEDIDOS,             
  'ENTRADA'                                             TIPO                                                                         
FROM    WMWHSE5.RECEIPT O                           
                      
WHERE O.STATUS IN ('9', '11', '15')                                                                          
GROUP BY  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.RECEIPTDATE,             
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
              AT time zone sessiontimezone) AS DATE)),                    
          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.RECEIPTDATE,             
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
              AT time zone sessiontimezone) AS DATE), 'HH24'),            
          O.WHSEID) Q1  
GROUP BY 
  Q1.DATA,
  Q1.HORA,
  Q1.ID_LOCAL,
  Q1.DESCR_LOCAL



=IIF(Parameters!Table.Value <> "AAA",

"SELECT                                                                    " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))         DATA,               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'HH24') HORA,               " &
"  O.WHSEID                                            ID_LOCAL,           " &
"  ( select a.UDF2                                                         " &
"     from ENTERPRISE.CODELKUP a                                           " &
"    where upper(a.UDF1) = O.WHSEID                                        " &
"      and a.listname = 'SCHEMA' )                     DESCR_LOCAL,        " &
"  COUNT(O.ORDERKEY)                                   PEDIDOS             " &
"                                                                          " &
"FROM    " + Parameters!Table.Value + ".ORDERS O                           " &
"                                                                          " &
"WHERE   TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"            AT time zone sessiontimezone) AS DATE))                       " &
"         Between '" + Parameters!DataDe.Value + "'                        " &
"             AND '" + Parameters!DataAte.Value + "'                       " &
"                                                                          " &
"GROUP BY  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE)),                    " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),            " &
"          O.WHSEID                                                        " &
"                                                                          " &
"ORDER BY ID_LOCAL, DATA                                                   " 
                                                                           
,                                                                          
	                                                                       
                                                                           
"SELECT                                                                    " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))         DATA,               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'HH24') HORA,               " &
"  O.WHSEID                                            ID_LOCAL,           " &
"  ( select a.UDF2                                                         " &
"     from ENTERPRISE.CODELKUP a                                           " &
"    where upper(a.UDF1) = O.WHSEID                                        " &
"      and a.listname = 'SCHEMA' )                     DESCR_LOCAL,        " &
"  COUNT(O.ORDERKEY)                                   PEDIDOS             " &
"                                                                          " &
"FROM    WMWHSE1.ORDERS O                                                  " &
"                                                                          " &
"WHERE   TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,               " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))                             " &
"   Between '" + Parameters!DataDe.Value + "'                              " &
"          AND '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE)),                    " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),            " &
"          O.WHSEID                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))         DATA,               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'HH24') HORA,               " &
"  O.WHSEID                                            ID_LOCAL,           " &
"  ( select a.UDF2                                                         " &
"     from ENTERPRISE.CODELKUP a                                           " &
"    where upper(a.UDF1) = O.WHSEID                                        " &
"      and a.listname = 'SCHEMA' )                     DESCR_LOCAL,        " &
"  COUNT(O.ORDERKEY)                                   PEDIDOS             " &
"                                                                          " &
"FROM    WMWHSE2.ORDERS O                                                  " &
"                                                                          " &
"WHERE   TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,               " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))                             " &
"   Between '" + Parameters!DataDe.Value + "'                              " &
"          AND '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE)),                    " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),            " &
"          O.WHSEID                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))         DATA,               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'HH24') HORA,               " &
"  O.WHSEID                                            ID_LOCAL,           " &
"  ( select a.UDF2                                                         " &
"     from ENTERPRISE.CODELKUP a                                           " &
"    where upper(a.UDF1) = O.WHSEID                                        " &
"      and a.listname = 'SCHEMA' )                     DESCR_LOCAL,        " &
"  COUNT(O.ORDERKEY)                                   PEDIDOS             " &
"                                                                          " &
"FROM    WMWHSE3.ORDERS O                                                  " &
"                                                                          " &
"WHERE   TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,               " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))                             " &
"   Between '" + Parameters!DataDe.Value + "'                              " &
"          AND '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE)),                    " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),            " &
"          O.WHSEID                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))         DATA,               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'HH24') HORA,               " &
"  O.WHSEID                                            ID_LOCAL,           " &
"  ( select a.UDF2                                                         " &
"     from ENTERPRISE.CODELKUP a                                           " &
"    where upper(a.UDF1) = O.WHSEID                                        " &
"      and a.listname = 'SCHEMA' )                     DESCR_LOCAL,        " &
"  COUNT(O.ORDERKEY)                                   PEDIDOS             " &
"                                                                          " &
"FROM    WMWHSE4.ORDERS O                                                  " &
"                                                                          " &
"WHERE   TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,               " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))                             " &
"   Between '" + Parameters!DataDe.Value + "'                              " &
"          AND '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE)),                    " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),            " &
"          O.WHSEID                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))         DATA,               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'HH24') HORA,               " &
"  O.WHSEID                                            ID_LOCAL,           " &
"  ( select a.UDF2                                                         " &
"     from ENTERPRISE.CODELKUP a                                           " &
"    where upper(a.UDF1) = O.WHSEID                                        " &
"      and a.listname = 'SCHEMA' )                     DESCR_LOCAL,        " &
"  COUNT(O.ORDERKEY)                                   PEDIDOS             " &
"                                                                          " &
"FROM    WMWHSE5.ORDERS O                                                  " &
"                                                                          " &
"WHERE   TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,               " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))                             " &
"   Between '" + Parameters!DataDe.Value + "'                              " &
"          AND '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE)),                    " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),            " &
"          O.WHSEID                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))         DATA,               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'HH24') HORA,               " &
"  O.WHSEID                                            ID_LOCAL,           " &
"  ( select a.UDF2                                                         " &
"     from ENTERPRISE.CODELKUP a                                           " &
"    where upper(a.UDF1) = O.WHSEID                                        " &
"      and a.listname = 'SCHEMA' )                     DESCR_LOCAL,        " &
"  COUNT(O.ORDERKEY)                                   PEDIDOS             " &
"                                                                          " &
"FROM    WMWHSE6.ORDERS O                                                  " &
"                                                                          " &
"WHERE   TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,               " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))                             " &
"   Between '" + Parameters!DataDe.Value + "'                              " &
"          AND '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE)),                    " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),            " &
"          O.WHSEID                                                        " &
"                                                                          " &
"UNION                                                                     " &
"                                                                          " &
"SELECT                                                                    " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))         DATA,               " &
"  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,                     " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE), 'HH24') HORA,               " &
"  O.WHSEID                                            ID_LOCAL,           " &
"  ( select a.UDF2                                                         " &
"     from ENTERPRISE.CODELKUP a                                           " &
"    where upper(a.UDF1) = O.WHSEID                                        " &
"      and a.listname = 'SCHEMA' )                     DESCR_LOCAL,        " &
"  COUNT(O.ORDERKEY)                                   PEDIDOS             " &
"                                                                          " &
"FROM    WMWHSE7.ORDERS O                                                  " &
"                                                                          " &
"WHERE   TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,               " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')          " &
"      AT time zone sessiontimezone) AS DATE))                             " &
"   Between '" + Parameters!DataDe.Value + "'                              " &
"          AND '" + Parameters!DataAte.Value + "'                          " &
"                                                                          " &
"GROUP BY  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE)),                    " &
"          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE,             " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone sessiontimezone) AS DATE), 'HH24'),            " &
"          O.WHSEID                                                        " &
"                                                                          " &
"ORDER BY ID_LOCAL, DATA                                                   " 
)                                                                          