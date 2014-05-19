SELECT
	tfcmg948.t$bank$l COD_BANCO,
	tfcmg948.t$btno$l NUM_REMESSA,
	tfcmg948.t$occ2$l COD_COMANDO,
	CONCAT(tfcmg948.t$ttyp$l, TO_CHAR(tfcmg948.t$ninv$l)) NUM_TITULO,
	'ACR' COD_MODALIDADE,
	tfcmg948.t$stat$l SITUACAO,
	CAST((FROM_TZ(CAST(TO_CHAR(tfcmg948.t$lach$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE)  DATA_E_HORA_ATUALIZACAO
FROM
	ttfcmg948201 tfcmg948
