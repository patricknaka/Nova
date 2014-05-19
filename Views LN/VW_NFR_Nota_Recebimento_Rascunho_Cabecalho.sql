SELECT DISTINCT
	tdpur401.t$txre$l NUM_RASCUNHO,
	brmcs941q.opfc COD_NATUREZA_OPERACAO_COMPRA,
	' ' SEQ_NATUREZA_OPR_COMPRA,															-- *** PEDENTE DE DEFINIÇÃO FUNCIONAL ***
    201 COD_CIA,
	(SELECT tcemm030.t$euca FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
	WHERE tcemm124.t$cwoc=tdpur400.t$cofc
	AND tcemm030.t$eunt=tcemm124.t$grid
	AND tcemm124.t$loco=201
	AND rownum=1) COD_FILIAL,
	(SELECT tcemm124.t$grid FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
	WHERE tcemm124.t$cwoc=tdpur400.t$cofc
	AND tcemm124.t$loco=201
	AND rownum=1) UNID_EMPRESARIAL,	
	tdpur401.t$otbp COD_FORNECEDOR,											
	' ' NUM_NOTA_FISCAL_REFERENCIA,															-- *** PEDENTE DE DEFINIÇÃO FUNCIONAL ***
	' ' SÉRIE_NOTA_FISCAL_REFERENCIA,														-- *** PEDENTE DE DEFINIÇÃO FUNCIONAL ***
	' ' DT_EMISSAO_NOTA_FISCAL,																-- *** PEDENTE DE DEFINIÇÃO FUNCIONAL ***
	' ' DT_SAIDA_NOTA_FISCAL,																-- *** PEDENTE DE DEFINIÇÃO FUNCIONAL ***
	tdpur401.t$orno NUM_PEDIDO_COMPRA,
	brmcs941q.t$iprt$l VALOR_PRODUTO,
	brmcs941q.t$gexp$l VALOR_DESPESA,
	brmcs941q.t$addc$l VALOR_DESCONTO,
	brmcs941q.t$fght$l VALOR_FRETE,
	brmcs941q.t$insr$l VALOR_SEGURO,
	-- VALOR_DESCONTO_CONDICIONAL															-- *** DESCONSIDERAR ****
	brmcs941q.t$addc$l VALOR_DESCONTO_INCONDICIONAL,
	(SELECT SUM(tbrmcs942201.t$amnt$l)
	FROM tbrmcs942201
	WHERE tbrmcs942201.t$txre$l=tdpur401.t$txre$l
	AND tbrmcs942201.t$brty$l=1) VALOR_ICMS,
	(SELECT SUM(tbrmcs942201.t$amnt$l)
	FROM tbrmcs942201
	WHERE tbrmcs942201.t$txre$l=tdpur401.t$txre$l
	AND tbrmcs942201.t$brty$l=2) VALOR_ICMS_ST,
	(SELECT SUM(tbrmcs942201.t$amnt$l)
	FROM tbrmcs942201
	WHERE tbrmcs942201.t$txre$l=tdpur401.t$txre$l
	AND tbrmcs942201.t$brty$l=3) VALOR_IPI,
	brmcs941q.t$tamt$l VALOR_TOTAL ,
	tdpur401.t$odat DT_GERACAO_REGISTRO,
	' ' SITUACAO_ANALISE,																	-- *** PEDENTE DE CUSTOMIZAÇÃO	***
	0 DATA_ANALISE,																			-- *** PEDENTE DE CUSTOMIZAÇÃO	***
	' ' SITUACAO_RASCUNHO,																	-- *** PEDENTE DE CUSTOMIZAÇÃO	***
	' ' OBSERVACAO,																			-- *** PEDENTE DE CUSTOMIZAÇÃO	***
	(select ttdpur451201.t$logn
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur401.t$orno
	and ttdpur451201.t$trdt=(select min(d.t$trdt)
							 from ttdpur451201 d 
							 where d.t$orno=ttdpur451201.t$orno)
	and rownum=1) COD_USUARIO_INCLUSAO,
	(select min(ttdpur451201.t$trdt)
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur401.t$orno) DT_INCLUSAO,
	(select ttdpur451201.t$logn
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur401.t$orno
	and ttdpur451201.t$trdt=(select max(d.t$trdt)
							 from ttdpur451201 d 
							 where d.t$orno=ttdpur451201.t$orno)
	and rownum=1) COD_USUARIO_ALTERACAO,
	(select max(ttdpur451201.t$trdt)
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur401.t$orno) DT_ALTERACAO,
	(select ttdpur451201.t$logn
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur401.t$orno
	and ttdpur451201.t$trdt=(select min(d.t$trdt)
							 from ttdpur451201 d 
							 where d.t$orno=ttdpur451201.t$orno
							 and d.t$clyn=1)
	and rownum=1
	and ttdpur451201.t$clyn=1) COD_USUARIO_CANCELAMENTO,
	(select min(ttdpur451201.t$trdt)
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur401.t$orno
	and ttdpur451201.t$clyn=1) DT_CANCELAMENTO,
	' ' ESPÉCIE_NOTA_FISCAL_RECEBIDA,														-- *** PENDENTE DE DUVIDA ***
	' ' NUM_NOTA_RECEBIMENTO,																-- *** PENDENTE DE DUVIDA ***
	tdpur401.t$cwar COD_DEPOSITO,
	tdpur400.t$cpay COD_CONDICAO_PAGAMENTO,
	(SELECT SUM(tbrmcs942201.t$amnt$l)
	FROM tbrmcs942201
	WHERE tbrmcs942201.t$txre$l=tdpur401.t$txre$l
	AND tbrmcs942201.t$brty$l=16) VALOR_IMPOSTO_IMPORTACAO,
	brmcs941q.t$cchr$l VALOR_DESPESA_ADUANEIRO,
	0 VALOR_ADICIONAL_IMPORTACAO,															-- *** PEDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_PIS_IMPORTACAO,																	-- *** PEDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_COFINS_IMPORTACAO,																-- *** PEDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_CIF_IMPORTACAO																	-- *** PEDENTE DE DEFINIÇÃO FUNCIONAL ***
FROM
	ttdpur401201 tdpur401,
	(SELECT brmcs941.t$txre$l,
	(SELECT b.t$opfc$l
	FROM tbrmcs941201 b
	WHERE b.t$tamt$l = (SELECT MAX(c.t$tamt$l)
						FROM tbrmcs941201 c
						WHERE c.t$txre$l=b.t$txre$l
						AND   c.t$line$l=b.t$line$l)
	and b.t$txre$l=brmcs941.t$txre$l
	and rownum=1) opfc,
	SUM(brmcs941.t$iprt$l) t$iprt$l, 
	SUM(brmcs941.t$gexp$l) t$gexp$l, 
	SUM(brmcs941.t$fght$l) t$fght$l, 
	SUM(brmcs941.t$insr$l) t$insr$l, 
	SUM(brmcs941.t$addc$l) t$addc$l, 
	SUM(brmcs941.t$tamt$l) t$tamt$l,
	SUM(brmcs941.t$cchr$l) t$cchr$l
	FROM tbrmcs941201 brmcs941
	GROUP BY brmcs941.t$txre$l,	brmcs941.t$opfc$l) brmcs941q,
	ttdpur400201 tdpur400	
WHERE
	brmcs941q.t$txre$l=tdpur401.t$txre$l
AND	tdpur400.t$orno=tdpur401.t$orno

