SELECT
	tfcmg949.t$bank$l COD_BANCO,
	tfcmg949.t$sern$l NUM_RETORNO,
	tfcmg949.t$seqf$l NOME_ARQUIVO_DE_RETORNO,
	tfcmg949.t$ttyp$l + TO_CHAR(tfcmg949.t$ninv$l) NUM_TITULO,
	tfcmg949.t$occu$l COD_OCORRENCIA,
	tfcmg949.t$dare$l DATA_OCORRENCIA,
	tfcmg011.t$baoc$l NUM_BANCARIO,
	tfcmg949.t$baof$l NUM_AGENCIA,
	tfcmg949.t$dued$l DATA_DE_VENCIMENTO,
	tfcmg949.t$amth$l VALOR_TITULO,
	tfcmg949.t$oexp$l VALOR_DESPESA,
	tfcmg949.t$ream$l VALOR_ABATIMENTO,
	tfcmg949.t$disa$l VALOR_DESCONTO,
	tfcmg949.t$paid$l VALOR_PAGO,
	tfcmg949.t$inam$l VALOR_DE_JUROS,
	tfcmg949.t$acce$l SITUACAO
FROM
	ttfcmg949201 tfcmg949
	LEFT JOIN ttfcmg001201 tfcmg001
	ON  tfcmg001.t$bank=tfcmg949.t$bank$l
	LEFT JOIN ttfcmg011201 tfcmg011
	ON  tfcmg011.t$bank=tfcmg001.t$brch
