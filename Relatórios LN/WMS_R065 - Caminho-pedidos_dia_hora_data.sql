SELECT
   
        TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE)) DATA,
        TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE), 'HH24') HORA,
        O.WHSEID          ID_LOCAL,
        (select a.UDF2 from ENTERPRISE.CODELKUP a
         where upper(a.UDF1) = O.WHSEID 
         and a.listname='SCHEMA')  DESCR_LOCAL,
        COUNT(O.ORDERKEY) PEDIDOS
FROM WMWHSE5.ORDERS O
GROUP BY
        TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE)),
        TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ADDDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE), 'HH24'),
        O.WHSEID