--	FAF.004 - 13-mai-2014, Fabio Ferreira, 	Corre��o timezone
--											Corre��o na quantidade de itens
--*******************************************************************************************************************************************
SELECT
	WAVE.WAVEKEY CD_ONDA, WAVE.WHSEID CD_ARMAZEM,
	' ' CD_PROGRAMA  ,                              			-- *** AGAURDANDO DUVIDA *** 
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.ADDDATE , 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_CADASTRO,
	W_COUNT.ORD_COUNT QT_PEDIDOS,
	W_COUNT.SKU_COUNT QT_ITENS,
	WAVE.STATUS CD_SITUACAO_ONDA,
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.EDITDATE , 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO
FROM 	WMWHSE2.WAVE WAVE,
		(SELECT WAVEDETAIL.WAVEKEY, 
		COUNT(DISTINCT WAVEDETAIL.ORDERKEY) ORD_COUNT,
		COUNT(ORDERDETAIL.SKU) SKU_COUNT
		FROM WMWHSE2.WAVEDETAIL WAVEDETAIL, WMWHSE2.ORDERDETAIL ORDERDETAIL
		WHERE ORDERDETAIL.ORDERKEY=WAVEDETAIL.ORDERKEY
		GROUP BY WAVEDETAIL.WAVEKEY) W_COUNT
WHERE	W_COUNT.WAVEKEY=WAVE.WAVEKEY
UNION
SELECT
	WAVE.WAVEKEY COD_ONDA, WAVE.WHSEID CD_ARMAZEM,
	' ' COD_PROGRAMA  ,                              			-- *** AGAURDANDO DUVIDA *** 
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.ADDDATE , 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DATA_CADASTRO,
	W_COUNT.ORD_COUNT QUANTIDADE_PEDIDOS,
	W_COUNT.SKU_COUNT QUANTIDADE_ITENS,
	WAVE.STATUS SITUACAO_ONDA,
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.EDITDATE , 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO
FROM 	WMWHSE2.WAVE WAVE,
		(SELECT WAVEDETAIL.WAVEKEY, 
		COUNT(DISTINCT WAVEDETAIL.ORDERKEY) ORD_COUNT,
		COUNT(ORDERDETAIL.SKU) SKU_COUNT
		FROM WMWHSE2.WAVEDETAIL WAVEDETAIL, WMWHSE2.ORDERDETAIL ORDERDETAIL
		WHERE ORDERDETAIL.ORDERKEY=WAVEDETAIL.ORDERKEY
		GROUP BY WAVEDETAIL.WAVEKEY) W_COUNT
WHERE	W_COUNT.WAVEKEY=WAVE.WAVEKEY
UNION
SELECT
	WAVE.WAVEKEY CD_ONDA, WAVE.WHSEID CD_ARMAZEM,
	' ' CD_PROGRAMA  ,                              			-- *** AGAURDANDO DUVIDA *** 
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.ADDDATE , 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_CADASTRO,
	W_COUNT.ORD_COUNT QT_PEDIDOS,
	W_COUNT.SKU_COUNT QT_ITENS,
	WAVE.STATUS CD_SITUACAO_ONDA,
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.EDITDATE , 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO
FROM 	WMWHSE3.WAVE WAVE,
		(SELECT WAVEDETAIL.WAVEKEY, 
		COUNT(DISTINCT WAVEDETAIL.ORDERKEY) ORD_COUNT,
		COUNT(ORDERDETAIL.SKU) SKU_COUNT
		FROM WMWHSE3.WAVEDETAIL WAVEDETAIL, WMWHSE3.ORDERDETAIL ORDERDETAIL
		WHERE ORDERDETAIL.ORDERKEY=WAVEDETAIL.ORDERKEY
		GROUP BY WAVEDETAIL.WAVEKEY) W_COUNT
WHERE	W_COUNT.WAVEKEY=WAVE.WAVEKEY
UNION
SELECT
	WAVE.WAVEKEY CD_ONDA, WAVE.WHSEID CD_ARMAZEM,
	' ' CD_PROGRAMA  ,                              			-- *** AGAURDANDO DUVIDA *** 
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.ADDDATE , 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_CADASTRO,
	W_COUNT.ORD_COUNT QT_PEDIDOS,
	W_COUNT.SKU_COUNT QT_ITENS,
	WAVE.STATUS CD_SITUACAO_ONDA,
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.EDITDATE , 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO
FROM 	WMWHSE4.WAVE WAVE,
		(SELECT WAVEDETAIL.WAVEKEY, 
		COUNT(DISTINCT WAVEDETAIL.ORDERKEY) ORD_COUNT,
		COUNT(ORDERDETAIL.SKU) SKU_COUNT
		FROM WMWHSE4.WAVEDETAIL WAVEDETAIL, WMWHSE4.ORDERDETAIL ORDERDETAIL
		WHERE ORDERDETAIL.ORDERKEY=WAVEDETAIL.ORDERKEY
		GROUP BY WAVEDETAIL.WAVEKEY) W_COUNT
WHERE	W_COUNT.WAVEKEY=WAVE.WAVEKEY
UNION
SELECT
	WAVE.WAVEKEY CD_ONDA, WAVE.WHSEID CD_ARMAZEM,
	' ' CD_PROGRAMA  ,                              			-- *** AGAURDANDO DUVIDA *** 
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.ADDDATE , 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_CADASTRO,
	W_COUNT.ORD_COUNT QT_PEDIDOS,
	W_COUNT.SKU_COUNT QT_ITENS,
	WAVE.STATUS CD_SITUACAO_ONDA,
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.EDITDATE , 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO
FROM 	WMWHSE5.WAVE WAVE,
		(SELECT WAVEDETAIL.WAVEKEY, 
		COUNT(DISTINCT WAVEDETAIL.ORDERKEY) ORD_COUNT,
		COUNT(ORDERDETAIL.SKU) SKU_COUNT
		FROM WMWHSE5.WAVEDETAIL WAVEDETAIL, WMWHSE5.ORDERDETAIL ORDERDETAIL
		WHERE ORDERDETAIL.ORDERKEY=WAVEDETAIL.ORDERKEY
		GROUP BY WAVEDETAIL.WAVEKEY) W_COUNT
WHERE	W_COUNT.WAVEKEY=WAVE.WAVEKEY
UNION
SELECT
	WAVE.WAVEKEY CD_ONDA, WAVE.WHSEID CD_ARMAZEM,
	' ' CD_PROGRAMA  ,                              			-- *** AGAURDANDO DUVIDA *** 
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.ADDDATE , 'DD-MON-YYYY HH:MI:SS ') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_CADASTRO,
	W_COUNT.ORD_COUNT QT_PEDIDOS,
	W_COUNT.SKU_COUNT QT_ITENS,
	WAVE.STATUS CD_SITUACAO_ONDA,
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.EDITDATE , 'DD-MON-YYYY HH:MI:SS ') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO
FROM 	WMWHSE6.WAVE WAVE,
		(SELECT WAVEDETAIL.WAVEKEY, 
		COUNT(DISTINCT WAVEDETAIL.ORDERKEY) ORD_COUNT,
		COUNT(ORDERDETAIL.SKU) SKU_COUNT
		FROM WMWHSE6.WAVEDETAIL WAVEDETAIL, WMWHSE6.ORDERDETAIL ORDERDETAIL
		WHERE ORDERDETAIL.ORDERKEY=WAVEDETAIL.ORDERKEY
		GROUP BY WAVEDETAIL.WAVEKEY) W_COUNT
WHERE	W_COUNT.WAVEKEY=WAVE.WAVEKEY
UNION
SELECT
	WAVE.WAVEKEY CD_ONDA, WAVE.WHSEID CD_ARMAZEM,
	' ' CD_PROGRAMA  ,                              			-- *** AGAURDANDO DUVIDA *** 
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.ADDDATE , 'DD-MON-YYYY HH:MI:SS ') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_CADASTRO,
	W_COUNT.ORD_COUNT QT_PEDIDOS,
	W_COUNT.SKU_COUNT QT_ITENS,
	WAVE.STATUS CD_SITUACAO_ONDA,
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.EDITDATE , 'DD-MON-YYYY HH:MI:SS ') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO
FROM 	WMWHSE7.WAVE WAVE,
		(SELECT WAVEDETAIL.WAVEKEY, 
		COUNT(DISTINCT WAVEDETAIL.ORDERKEY) ORD_COUNT,
		COUNT(ORDERDETAIL.SKU) SKU_COUNT
		FROM WMWHSE7.WAVEDETAIL WAVEDETAIL, WMWHSE7.ORDERDETAIL ORDERDETAIL
		WHERE ORDERDETAIL.ORDERKEY=WAVEDETAIL.ORDERKEY
		GROUP BY WAVEDETAIL.WAVEKEY) W_COUNT
WHERE	W_COUNT.WAVEKEY=WAVE.WAVEKEY
UNION
SELECT
	WAVE.WAVEKEY CD_ONDA, WAVE.WHSEID CD_ARMAZEM,
	' ' CD_PROGRAMA  ,                              			-- *** AGAURDANDO DUVIDA *** 
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.ADDDATE , 'DD-MON-YYYY HH:MI:SS ') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_CADASTRO,
	W_COUNT.ORD_COUNT QT_PEDIDOS,
	W_COUNT.SKU_COUNT QT_ITENS,
	WAVE.STATUS CD_SITUACAO_ONDA,
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.EDITDATE , 'DD-MON-YYYY HH:MI:SS ') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO
FROM 	WMWHSE8.WAVE WAVE,
		(SELECT WAVEDETAIL.WAVEKEY, 
		COUNT(DISTINCT WAVEDETAIL.ORDERKEY) ORD_COUNT,
		COUNT(ORDERDETAIL.SKU) SKU_COUNT
		FROM WMWHSE8.WAVEDETAIL WAVEDETAIL, WMWHSE8.ORDERDETAIL ORDERDETAIL
		WHERE ORDERDETAIL.ORDERKEY=WAVEDETAIL.ORDERKEY
		GROUP BY WAVEDETAIL.WAVEKEY) W_COUNT
WHERE	W_COUNT.WAVEKEY=WAVE.WAVEKEY
UNION
SELECT
	WAVE.WAVEKEY CD_ONDA, WAVE.WHSEID CD_ARMAZEM,
	' ' CD_PROGRAMA  ,                              			-- *** AGAURDANDO DUVIDA *** 
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.ADDDATE , 'DD-MON-YYYY HH:MI:SS ') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_CADASTRO,
	W_COUNT.ORD_COUNT QT_PEDIDOS,
	W_COUNT.SKU_COUNT QT_ITENS,
	WAVE.STATUS CD_SITUACAO_ONDA,
	CAST((FROM_TZ(CAST(TO_CHAR(WAVE.EDITDATE , 'DD-MON-YYYY HH:MI:SS ') AS TIMESTAMP), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO
FROM 	WMWHSE9.WAVE WAVE,
		(SELECT WAVEDETAIL.WAVEKEY, 
		COUNT(DISTINCT WAVEDETAIL.ORDERKEY) ORD_COUNT,
		COUNT(ORDERDETAIL.SKU) SKU_COUNT
		FROM WMWHSE9.WAVEDETAIL WAVEDETAIL, WMWHSE9.ORDERDETAIL ORDERDETAIL
		WHERE ORDERDETAIL.ORDERKEY=WAVEDETAIL.ORDERKEY
		GROUP BY WAVEDETAIL.WAVEKEY) W_COUNT
WHERE	W_COUNT.WAVEKEY=WAVE.WAVEKEY