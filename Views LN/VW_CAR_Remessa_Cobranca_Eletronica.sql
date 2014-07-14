--	#FAF.224 - 14-jul-2014,	Fabio Ferreira,	Corrção de duplicidade
--****************************************************************************************************************************************************************
--SELECT																								--#FAF.224.o
SELECT DISTINCT																							--#FAF.224.o
	tfcmg948.t$bank$l CD_BANCO,
	tfcmg948.t$btno$l NR_REMESSA,
	tfcmg948.t$occ2$l COD_COMANDO,
	CONCAT(tfcmg948.t$ttyp$l, TO_CHAR(tfcmg948.t$ninv$l)) NR_TITULO,
	'ACR' CD_MODALIDADE,
	tfcmg948.t$stat$l SITUACAO,
	CAST((FROM_TZ(CAST(TO_CHAR(tfcmg948.t$lach$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE)  DT_ATUALIZACAO
FROM
	ttfcmg948201 tfcmg948
