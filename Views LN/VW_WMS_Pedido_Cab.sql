--	FAF.004 - 12-jan-2014, Fabio Ferreira, 	Correções de datas e outros campos
--	#FAF.150 - 24-jun-2014,	Fabio Ferreira,	Mostrar número da entrega do LN
--*******************************************************************************************************************************************
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
from WMWHSE1.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
from WMWHSE1.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
from WMWHSE1.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
from WMWHSE2.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
from WMWHSE2.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
from WMWHSE2.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
from WMWHSE3.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
from WMWHSE3.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
from WMWHSE3.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
from WMWHSE4.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
from WMWHSE4.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
from WMWHSE4.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
from WMWHSE5.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
from WMWHSE5.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
from WMWHSE5.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
from WMWHSE6.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
from WMWHSE6.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
from WMWHSE6.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
from WMWHSE7.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
from WMWHSE7.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
from WMWHSE7.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
from WMWHSE8.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
from WMWHSE8.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
from WMWHSE8.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
from WMWHSE9.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
from WMWHSE9.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
from WMWHSE9.ORDERS o 
WHERE o.actualshipdate IS NOT NULL