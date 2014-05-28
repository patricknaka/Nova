-- 06-mai-2014, Fabio Ferreira, Correção timezone
--								Alteração para cia 201
-- FAF.002 - 09-mai-2014, Fabio Ferreira, Quando a data no LN é zero (01/01/1970) não é feita a conversão de timezone
--****************************************************************************************************************************************************************
SELECT
	tccom125.t$ptbp CD_PARCEIRO,
	tfcmg011.t$baoc$l CD_BANCO,
	tfcmg011.t$agcd$l NR_AGENCIA,
	tfcmg011.t$agdg$l NR_DIGITO_AGENCIA,
	tccom125.t$bano NR_CONTA,
	tccom125.t$dacc$d NR_DIGITO_CONTA,
	CASE WHEN tccom125.t$rcd_utc<TO_DATE('1990-01-01', 'YYYY-MM-DD') THEN tccom125.t$rcd_utc				--#FAF.002.sn
	ELSE CAST((FROM_TZ(CAST(TO_CHAR(tccom125.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
				AT time zone sessiontimezone) AS DATE) 
	END DT_ATUALIZACAO																			--#FAF.002.en
--	CAST((FROM_TZ(CAST(TO_CHAR(tccom125.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 		--#FAF.002.so
--				AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO							--#FAF.002.eo
FROM
	ttccom125201 tccom125,
	ttfcmg011201 tfcmg011
WHERE tfcmg011.t$bank=tccom125.t$brch
order by 1