SELECT
		OS.WHSEID															ID_FILIAL,
		(select cl.UDF2
		 from ENTERPRISE.CODELKUP cl
		 where cl.listname = 'SCHEMA'
		 and UPPER(cl.UDF1) = OS.WHSEID
		 and rownum=1)														DESCR_FILIAL,
														
		OL.T$UNEG$C															ID_UNEG,
		OL.T$DESC$C															DESCR_UNEG,
		
		TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OS.ADDDATE, 
			'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone sessiontimezone) AS DATE),'DD')					DATA_PED,
		
       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OS.ADDDATE, 
                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                         AT time zone sessiontimezone) AS DATE),'HH24'), 'HH24:MI')
       || ' ~ ' 
       || TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OS.ADDDATE, 
                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                         AT time zone sessiontimezone) AS DATE)+1/24,'HH24'), 'HH24:MI')
																			PERIODO,
															
		count(distinct OS.ORDERKEY)											PEDIDOS
FROM 	WMWHSE5.ORDERS OS
		LEFT JOIN (	select distinct	
							a.t$orno$c,
							a.t$uneg$c,
							b.t$desc$c
					from	baandb.tznsls004301@pln01 a
					inner join	baandb.tznint002301@pln01 b on 	b.t$ncia$c = a.t$ncia$c
															and	b.t$uneg$c = a.t$uneg$c) OL
															ON OL.t$orno$c = OS.REFERENCEDOCUMENT
GROUP BY 
		OS.WHSEID,	
		OL.T$UNEG$C,
		OL.T$DESC$C,
		TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OS.ADDDATE, 
			'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone sessiontimezone) AS DATE),'DD'),
       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OS.ADDDATE, 
                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                         AT time zone sessiontimezone) AS DATE),'HH24'), 'HH24:MI')
       || ' ~ ' 
       || TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OS.ADDDATE, 
                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                         AT time zone sessiontimezone) AS DATE)+1/24,'HH24'), 'HH24:MI')
                          