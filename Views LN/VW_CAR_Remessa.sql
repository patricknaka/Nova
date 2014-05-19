SELECT DISTINCT
	tfcmg948.t$bank$l COD_DO_BANCO,
	tfcmg948.t$btno$l NUM_REMESSA,
	tfcmg948.t$docd$l DATA_REMESSA,
	tfcmg011.t$agcd$l NUM_AGENCIA,
	tfcmg948.t$acco$l NUM_CONTA,
    201 COMPANHIA,
	tfcmg948.t$stat$l SITUACAO_DO_ARQUIVO,
	tfcmg948.t$send$l SITUACAO_REMESSA,
	CAST((FROM_TZ(CAST(TO_CHAR(tfcmg948.t$lach$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_ATUALZACAO
FROM
	ttfcmg948201 tfcmg948
	LEFT JOIN ttfcmg001201 tfcmg001
	ON  tfcmg001.t$bank=tfcmg948.t$bank$l
	LEFT JOIN ttfcmg011201 tfcmg011
	ON  tfcmg011.t$bank=tfcmg001.t$brch