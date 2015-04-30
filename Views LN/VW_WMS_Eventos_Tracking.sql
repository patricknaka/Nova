select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE1.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
        ,TO_CHAR(cd.cageid) ID_GAIOLA
from WMWHSE1.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID, cd.cageid
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
        ,' ' ID_GAIOLA
from WMWHSE1.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE2.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
        ,TO_CHAR(cd.cageid) ID_GAIOLA
from WMWHSE2.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID, cd.cageid
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE2.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE3.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
        ,TO_CHAR(cd.cageid) ID_GAIOLA
from WMWHSE3.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID, cd.cageid
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE3.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE4.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
        ,TO_CHAR(cd.cageid) ID_GAIOLA
from WMWHSE4.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID, cd.cageid
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE4.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE5.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
        ,TO_CHAR(cd.cageid) ID_GAIOLA
from WMWHSE5.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID, cd.cageid
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE5.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE6.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
        ,TO_CHAR(cd.cageid) ID_GAIOLA
from WMWHSE6.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID, cd.cageid
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE6.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE7.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
        ,TO_CHAR(cd.cageid) ID_GAIOLA
from WMWHSE7.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID, cd.cageid
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE7.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE8.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
        ,TO_CHAR(cd.cageid) ID_GAIOLA
from WMWHSE8.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID, cd.cageid
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE8.ORDERS o 
WHERE o.actualshipdate IS NOT NULL
--********************************************************************************************************************************************************
UNION
select        o.WHSEID CD_ARMAZEM,
              o.ORDERKEY NR_PEDIDO_WMS,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'WMS' CD_OCORRENCIA_TERCEIRO
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE9.ORDERS o
UNION select  cd.WHSEID CD_ARMAZEM, 
              cd.orderid,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'GAI' 
			  ,'P' CD_SITUACAO
        ,TO_CHAR(cd.cageid) ID_GAIOLA
from WMWHSE9.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID, cd.cageid
UNION select  o.WHSEID CD_ARMAZEM, 
              o.ORDERKEY,
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE) DT_REGISTRO,
              'SEC' 
			  ,'P' CD_SITUACAO
        , ' ' ID_GAIOLA
from WMWHSE9.ORDERS o 
WHERE o.actualshipdate IS NOT NULL