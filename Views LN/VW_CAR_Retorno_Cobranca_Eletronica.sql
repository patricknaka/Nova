-- #FAF.233 - 	18-jul-2014, 	Fabio Ferreira, 	Ajuste campo NR_TITULO
--*************************************************************************************************************************************************************
SELECT
	tfcmg949.t$bank$l CD_BANCO,
	tfcmg949.t$sern$l NR_RETORNO,
	tfcmg949.t$seqf$l NM_ARQUIVO_RETORNO,
	tfcmg949.t$ttyp$l || TO_CHAR(tfcmg949.t$ninv$l) CD_CHAVE_PRIMARIA,									--#FAF.233.o
	tfcmg949.t$occu$l CD_OCORRENCIA,
	tfcmg949.t$dare$l DT_OCORRENCIA,
	tfcmg011.t$baoc$l NR_CONTA_CORRENTE,
	tfcmg949.t$baof$l NR_AGENCIA,
	tfcmg949.t$dued$l DT_VENCIMENTO,
	tfcmg949.t$amth$l VL_TITULO,
	tfcmg949.t$oexp$l VL_DESPESA,
	tfcmg949.t$ream$l VL_ABATIMENTO,
	tfcmg949.t$disa$l VL_DESCONTO,
	tfcmg949.t$paid$l VL_PAGO,
	tfcmg949.t$inam$l VL_JUROS,
	tfcmg949.t$acce$l CD_SITUACAO
FROM
	baandb.ttfcmg949201 tfcmg949
	LEFT JOIN baandb.ttfcmg001201 tfcmg001
	ON  tfcmg001.t$bank=tfcmg949.t$bank$l
	LEFT JOIN baandb.ttfcmg011201 tfcmg011
	ON  tfcmg011.t$bank=tfcmg001.t$brch
WHERE tfcmg949.t$ninv$l>0 AND tfcmg949.t$ttyp$l IS NOT NULL 
