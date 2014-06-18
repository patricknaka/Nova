select        o.WHSEID ARMAZEM,
              o.ORDERKEY COD_PEDIDO,
              CAST((FROM_TZ(CAST(TO_CHAR(o.ADDDATE , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'WMS' COD_EVENTO_TERCE
from WMWHSE1.ORDERS o
UNION select  cd.WHSEID ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(CAST(TO_CHAR(min(cd.ADDDATE) , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'GAI' 
from WMWHSE1.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(CAST(TO_CHAR(o.actualshipdate , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'SEC' 
from WMWHSE1.ORDERS o 
WHERE o.actualshipdate IS NOT NULL

UNION
select        o.WHSEID ARMAZEM,
              o.ORDERKEY COD_PEDIDO,
              CAST((FROM_TZ(CAST(TO_CHAR(o.ADDDATE , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'WMS' COD_EVENTO_TERCE
from WMWHSE2.ORDERS o
UNION select  cd.WHSEID ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(CAST(TO_CHAR(min(cd.ADDDATE) , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'GAI' 
from WMWHSE2.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(CAST(TO_CHAR(o.actualshipdate , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'SEC' 
from WMWHSE2.ORDERS o 
WHERE o.actualshipdate IS NOT NULL

UNION
select        o.WHSEID ARMAZEM,
              o.ORDERKEY COD_PEDIDO,
              CAST((FROM_TZ(CAST(TO_CHAR(o.ADDDATE , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'WMS' COD_EVENTO_TERCE
from WMWHSE3.ORDERS o
UNION select  cd.WHSEID ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(CAST(TO_CHAR(min(cd.ADDDATE) , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'GAI' 
from WMWHSE3.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(CAST(TO_CHAR(o.actualshipdate , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'SEC' 
from WMWHSE3.ORDERS o 
WHERE o.actualshipdate IS NOT NULL

UNION
select        o.WHSEID ARMAZEM,
              o.ORDERKEY COD_PEDIDO,
              CAST((FROM_TZ(CAST(TO_CHAR(o.ADDDATE , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'WMS' COD_EVENTO_TERCE
from WMWHSE4.ORDERS o
UNION select  cd.WHSEID ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(CAST(TO_CHAR(min(cd.ADDDATE) , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'GAI' 
from WMWHSE4.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(CAST(TO_CHAR(o.actualshipdate , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'SEC' 
from WMWHSE4.ORDERS o 
WHERE o.actualshipdate IS NOT NULL

UNION
select        o.WHSEID ARMAZEM,
              o.ORDERKEY COD_PEDIDO,
              CAST((FROM_TZ(CAST(TO_CHAR(o.ADDDATE , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'WMS' COD_EVENTO_TERCE
from WMWHSE5.ORDERS o
UNION select  cd.WHSEID ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(CAST(TO_CHAR(min(cd.ADDDATE) , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'GAI' 
from WMWHSE5.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(CAST(TO_CHAR(o.actualshipdate , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'SEC' 
from WMWHSE5.ORDERS o 
WHERE o.actualshipdate IS NOT NULL

UNION
select        o.WHSEID ARMAZEM,
              o.ORDERKEY COD_PEDIDO,
              CAST((FROM_TZ(CAST(TO_CHAR(o.ADDDATE , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'WMS' COD_EVENTO_TERCE
from WMWHSE6.ORDERS o
UNION select  cd.WHSEID ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(CAST(TO_CHAR(min(cd.ADDDATE) , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'GAI' 
from WMWHSE6.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(CAST(TO_CHAR(o.actualshipdate , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'SEC' 
from WMWHSE6.ORDERS o 
WHERE o.actualshipdate IS NOT NULL

UNION
select        o.WHSEID ARMAZEM,
              o.ORDERKEY COD_PEDIDO,
              CAST((FROM_TZ(CAST(TO_CHAR(o.ADDDATE , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'WMS' COD_EVENTO_TERCE
from WMWHSE7.ORDERS o
UNION select  cd.WHSEID ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(CAST(TO_CHAR(min(cd.ADDDATE) , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'GAI' 
from WMWHSE7.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(CAST(TO_CHAR(o.actualshipdate , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'SEC' 
from WMWHSE7.ORDERS o 
WHERE o.actualshipdate IS NOT NULL

UNION
select        o.WHSEID ARMAZEM,
              o.ORDERKEY COD_PEDIDO,
              CAST((FROM_TZ(CAST(TO_CHAR(o.ADDDATE , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'WMS' COD_EVENTO_TERCE
from WMWHSE8.ORDERS o
UNION select  cd.WHSEID ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(CAST(TO_CHAR(min(cd.ADDDATE) , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'GAI' 
from WMWHSE8.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(CAST(TO_CHAR(o.actualshipdate , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'SEC' 
from WMWHSE8.ORDERS o 
WHERE o.actualshipdate IS NOT NULL

UNION
select        o.WHSEID ARMAZEM,
              o.ORDERKEY COD_PEDIDO,
              CAST((FROM_TZ(CAST(TO_CHAR(o.ADDDATE , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'WMS' COD_EVENTO_TERCE
from WMWHSE9.ORDERS o
UNION select  cd.WHSEID ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(CAST(TO_CHAR(min(cd.ADDDATE) , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'GAI' 
from WMWHSE9.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(CAST(TO_CHAR(o.actualshipdate , 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
              AT time zone sessiontimezone) AS DATE) DATA_REGISTRO,
              'SEC' 
from WMWHSE9.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
