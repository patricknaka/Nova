SELECT
	tdpur401.t$txre$l NUM_RASCUNHO,
	tdpur401.t$pono SEQU_ITEM,
	ltrim(rtrim(tdpur401.t$item)) COD_ITEM,
	tdpur401.t$cuqp COD_UNIDADE_DE_MEDIDA,
	tdpur401.t$orno NUM_PEDIDO_COMPRA,
	tdpur401.t$qoor QUANTIDADE,
	tdpur401.t$pric VALOR_UNITARIO,
	brmcs941.t$iprt$l VALOR_PRODUTO,
	(SELECT SUM(tbrmcs942201.t$amnt$l)
	FROM tbrmcs942201
	WHERE tbrmcs942201.t$txre$l=tdpur401.t$txre$l
	AND tbrmcs942201.t$line$l=tdpur401.t$txli$l
	AND tbrmcs942201.t$brty$l=3) VALOR_IPI,
	(SELECT SUM(tbrmcs942201.t$amnt$l)
	FROM tbrmcs942201
	WHERE tbrmcs942201.t$txre$l=tdpur401.t$txre$l
	AND tbrmcs942201.t$line$l=tdpur401.t$txli$l
	AND tbrmcs942201.t$brty$l=1) VALOR_ICMS,
	(SELECT SUM(tbrmcs942201.t$amnt$l)
	FROM tbrmcs942201
	WHERE tbrmcs942201.t$txre$l=tdpur401.t$txre$l
	AND tbrmcs942201.t$line$l=tdpur401.t$txli$l
	AND tbrmcs942201.t$brty$l=2) VALOR_ICMS_ST,
	brmcs941.t$gexp$l VALOR_DESPESA,
	brmcs941.t$addc$l VALOR_DESCONTO,
	brmcs941.t$fght$l VALOR_FRETE,
	brmcs941.t$insr$l VALOR_SEGURO,
	brmcs941.t$addc$l VALOR_DESCONTO_INCONDICIONAL,
	brmcs941.t$tamt$l VALOR_TOTAL_ITEM,
	(SELECT SUM(tbrmcs942201.t$amnt$l)
	FROM tbrmcs942201
	WHERE tbrmcs942201.t$txre$l=tdpur401.t$txre$l
	AND tbrmcs942201.t$line$l=tdpur401.t$txli$l
	AND tbrmcs942201.t$brty$l=16) VALOR_IMPOSTO_IMPORTACAO,
	brmcs941.t$cchr$l VALOR_DESPESA_ADUANEIRO,
	0 VALOR_ADICIONAL_IMPORTACAO,							-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	0 VALOR_PIS_IMPORTACAO,									-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	0 VALOR_COFINS_IMPORTACAO,								-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
	0 VALOR_CIF_IMPORTACAO									-- *** PEDENTE DE DEFINI플O FUNCIONAL ***
FROM
	ttdpur401201 tdpur401,
	tbrmcs941201 brmcs941	
WHERE
	brmcs941.t$txre$l=tdpur401.t$txre$l	
AND brmcs941.t$line$l=tdpur401.t$txli$l
	