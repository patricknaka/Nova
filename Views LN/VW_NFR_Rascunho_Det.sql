-- #FAF.022 - 27-mai-2014, Fabio Ferreira, 	Correções e alteração da origem da informação para os dados da pré-nota			
--************************************************************************************************************************************************************
SELECT
	brnfe941.t$fire$l NUM_RASCUNHO,
	tdpur401.t$pono SEQU_ITEM,
	ltrim(rtrim(tdpur401.t$item)) COD_ITEM,
	tdpur401.t$cuqp COD_UNIDADE_DE_MEDIDA,
	tdpur401.t$orno NUM_PEDIDO_COMPRA,
	tdpur401.t$qoor QUANTIDADE,
	tdpur401.t$pric VALOR_UNITARIO,
	brnfe941.t$pric$l VALOR_PRODUTO,

	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$l
	AND i.t$line$l=brnfe941.t$line$l
	AND i.t$brty$l=3) VALOR_IPI,
	
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$l
	AND i.t$line$l=brnfe941.t$line$l
	AND i.t$brty$l=1) VALOR_ICMS,

	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$l
	AND i.t$line$l=brnfe941.t$line$l
	AND i.t$brty$l=2) VALOR_ICMS_ST,
	
	
	brnfe941.t$gexp$l VALOR_DESPESA,
	brnfe941.t$addc$l VALOR_DESCONTO,
	brnfe941.t$fght$l VALOR_FRETE,
	brnfe941.t$insr$l VALOR_SEGURO,
	brnfe941.t$addc$l VALOR_DESCONTO_INCONDICIONAL,									-- *** Não existe no LN na pré nota a separação da despes e despesa incondicional
	brnfe941.t$tamt$l VALOR_TOTAL_ITEM,

	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$l
	AND i.t$line$l=brnfe941.t$line$l
	AND i.t$brty$l=2) VALOR_IMPOSTO_IMPORTACAO,
	
	nvl((select sum(r.T$CCHR$L) FROM ttdrec941201 r
	where r.t$fire$l=brnfe941.t$fire$c
	and r.t$line$l=brnfe941.t$line$c),0) VALOR_DESPESA_ADUANEIRO,
	
	CASE WHEN tdpur400.t$rfdt$l=37 THEN brnfe941.t$addc$l ELSE 0 END VALOR_ADICIONAL_IMPORTACAO,

	CASE WHEN tdpur400.t$rfdt$l=37 THEN
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$c
	AND i.t$line$l=brnfe941.t$line$c
	AND i.t$brty$l=5)
	ELSE 0 END VALOR_PIS_IMPORTACAO,	

	CASE WHEN tdpur400.t$rfdt$l=37 THEN
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$c
	AND i.t$line$l=brnfe941.t$line$c
	AND i.t$brty$l=5)
	ELSE 0 END VALOR_COFINS_IMPORTACAO,
	
  CASE WHEN
	nvl((select a.t$cdec from ttdpur400201 a
		where a.t$orno=tdpur400.t$orno
		and a.t$cdec='001'
		and rownum=1),0)=0 THEN 0
	ELSE brnfe941.t$fght$l
	END VALOR_CIF_IMPORTACAO

FROM
	tbrnfe941201 brnfe941,
	ttdpur401201 tdpur401,
	ttdpur400201 tdpur400,
	tznnfe007201 znnfe007
WHERE	znnfe007.t$fire$c=brnfe941.t$fire$l
AND		znnfe007.t$line$c=brnfe941.t$line$l	
AND		tdpur401.t$orno=znnfe007.t$orno$c
AND		tdpur401.t$pono=znnfe007.t$pono$c
AND		tdpur400.t$orno=tdpur401.t$orno
AND		znnfe007.t$oorg$c=80