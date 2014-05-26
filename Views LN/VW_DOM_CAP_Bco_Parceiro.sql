-- 06-mai-2014, Fabio Ferreira, Correção timezone
--								Alteração para cia 201
-- FAF.002 - 09-mai-2014, Fabio Ferreira, Quando a data no LN é zero (01/01/1970) não é feita a conversão de timezone
--****************************************************************************************************************************************************************
SELECT
	tccom125.t$ptbp CODIGO_CLIENTE,
	tfcmg011.t$baoc$l NUMERO_BANCO,
	tfcmg011.t$agcd$l AGENCIA,
	tfcmg011.t$agdg$l DIGITO_AGENCIA,
	tccom125.t$bano NUMERO_CONTA,
	tccom125.t$dacc$d DIGITO_CONTA,
	CASE WHEN tccom125.t$rcd_utc<TO_DATE('1990-01-01', 'YYYY-MM-DD') THEN tccom125.t$rcd_utc				--#FAF.002.sn
	ELSE CAST((FROM_TZ(CAST(TO_CHAR(tccom125.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
				AT time zone sessiontimezone) AS DATE) 
	END DATA_E_HORA_DE_ATUALIZACAO																			--#FAF.002.en
--	CAST((FROM_TZ(CAST(TO_CHAR(tccom125.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 		--#FAF.002.so
--				AT time zone sessiontimezone) AS DATE) DATA_E_HORA_DE_ATUALIZACAO							--#FAF.002.eo
FROM
	ttccom125201 tccom125,
	ttfcmg011201 tfcmg011
WHERE tfcmg011.t$bank=tccom125.t$brch
order by 1