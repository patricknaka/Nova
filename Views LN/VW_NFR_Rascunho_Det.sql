-- #FAF.022 - 27-mai-2014, Fabio Ferreira, 	Correções e alteração da origem da informação para os dados da pré-nota			
--************************************************************************************************************************************************************
SELECT
	brnfe941.t$fire$l NR_NF_RASCUNHO,
	tdpur401.t$pono SQ_ITEM,
	ltrim(rtrim(tdpur401.t$item)) CD_ITEM,
	tdpur401.t$cuqp CD_UNIDADE_MEDIDA,
	tdpur401.t$orno NR_PEDIDO_COMPRA,
	tdpur401.t$qoor QT_RECEBIMENTO,
	tdpur401.t$pric VL_UNITARIO,
	brnfe941.t$pric$l VL_PRODUTO,

	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$l
	AND i.t$line$l=brnfe941.t$line$l
	AND i.t$brty$l=3) VL_IPI,
	
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$l
	AND i.t$line$l=brnfe941.t$line$l
	AND i.t$brty$l=1) VL_ICMS,

	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$l
	AND i.t$line$l=brnfe941.t$line$l
	AND i.t$brty$l=2) VL_ICMS_ST,
	
	
	brnfe941.t$gexp$l VL_DESPESA,
	brnfe941.t$addc$l VL_DESCONTO,
	brnfe941.t$fght$l VL_FRETE,
	brnfe941.t$insr$l VL_SEGURO,
	brnfe941.t$addc$l VL_DESCONTO_INCONDICIONAL,									-- *** Não existe no LN na pré nota a separação da despes e despesa incondicional
	brnfe941.t$tamt$l VL_TOTAL_ITEM,

	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$l
	AND i.t$line$l=brnfe941.t$line$l
	AND i.t$brty$l=2) VL_IMPOSTO_IMPORTACAO,
	
	nvl((select sum(r.T$CCHR$L) FROM ttdrec941201 r
	where r.t$fire$l=brnfe941.t$fire$c
	and r.t$line$l=brnfe941.t$line$c),0) VL_DESPESA_ADUANEIRA,
	
	CASE WHEN tdpur400.t$rfdt$l=37 THEN brnfe941.t$addc$l ELSE 0 END VL_ADICIONAL_IMPORTACAO,

	CASE WHEN tdpur400.t$rfdt$l=37 THEN
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$c
	AND i.t$line$l=brnfe941.t$line$c
	AND i.t$brty$l=5)
	ELSE 0 END VL_PIS_IMPORTACAO,	

	CASE WHEN tdpur400.t$rfdt$l=37 THEN
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe941.t$fire$c
	AND i.t$line$l=brnfe941.t$line$c
	AND i.t$brty$l=5)
	ELSE 0 END VL_COFINS_IMPORTACAO,
	
  CASE WHEN
	nvl((select a.t$cdec from ttdpur400201 a
		where a.t$orno=tdpur400.t$orno
		and a.t$cdec='001'
		and rownum=1),0)=0 THEN 0
	ELSE brnfe941.t$fght$l
	END VL_CIF_IMPORTACAO

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