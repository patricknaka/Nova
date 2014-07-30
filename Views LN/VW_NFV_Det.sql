-- 05-mai-2014, Fabio Ferreira, Correção registros duplicados (relacionamento cisli245),
--								Não mostrar linhas de frete e mostar o valor de frete rateado na coluna valor frete (frete da znsls401)
-- #FAF.041 - 29-mai-2014, Fabio Ferreira, 	Correções de informações que estavam pendente do fiscal
-- #FAF.041b - 29-mai-2014, Fabio Ferreira, Alteração no relacionamento para melhora de performace
-- #FAF.109 - 07-jun-2014, Fabio Ferreira, 	Inclusão do campo ref.fiscal
-- #FAF.247.1 - 30-jun-2014, Fabio Ferreira, 	Correções Frete
--****************************************************************************************************************************************************************
SELECT DISTINCT 
    201 CD_CIA,
    tcemm030.t$euca CD_FILIAL,
	cisli940.t$docn$l NR_NF,
	cisli940.t$seri$l NR_SERIE_NF,
	ltrim(rtrim(cisli941.t$item$l)) CD_ITEM,
	cisli941.t$dqua$l QT_FATURADA,
	nvl((select dv.t$dqua$l from baandb.tcisli941201 dv
	where dv.t$fire$l=tdsls401.t$fire$l and dv.t$line$l=tdsls401.t$line$l),'0') QT_DEVOLVIDA,
	cisli941.t$pric$l VL_UNITARIO_PRODUTO,
	(SELECT cisli943.t$amnt$l FROM baandb.tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=1) VL_ICMS,
	(SELECT cisli943.t$amnt$l FROM baandb.tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=2) VL_ICMS_ST,
	(SELECT cisli943.t$amnt$l FROM baandb.tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=3) VL_IPI,
	cisli941.t$gamt$l VL_PRODUTO,
--	znsls401.T$VLFR$C VL_FRETE,																	--#FAF.247.1.o
	cisli941.t$fght$l VL_FRETE,																	--#FAF.247.1.n
	cisli941.t$insr$l VL_SEGURO,
	cisli941.t$gexp$l VL_DESPESA,
	(SELECT cisli943.t$amnt$l FROM baandb.tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=16) VL_IMPOSTO_IMPORTACAO,
	cisli941.t$ldam$l VL_DESCONTO,
	cisli941.t$iprt$l VL_TOTAL_ITEM,
	nvl(to_char((select cdv.t$docn$l from baandb.tcisli940201 cdv
	where cdv.t$fire$l=tdsls401.t$fire$l)),' ') NR_NFR_DEVOLUCAO,
	cisli941.t$amfi$l VL_DESPESA_FINANCEIRA,
	(SELECT cisli943.t$amnt$l FROM baandb.tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=5) VL_PIS,
	Nvl((SELECT cisli943.t$amni$l from baandb.tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941.t$fire$l
             AND    cisli943.t$line$l=cisli941.t$line$l
             AND    cisli943.t$brty$l=1),0) VL_ICMS_PRODUTO,
	nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 
												baandb.tcisli941201 cisli941b,
												baandb.ttcibd001201 tcibd001b
		WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
		AND 	cisli941b.t$fire$l=cisli941.t$fire$l
		AND		tcibd001b.t$item=cisli941b.t$item$l
		AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
		AND		tcibd001b.t$ctyp$l=2
		AND 	cisli943.t$brty$l=1),0) VL_ICMS_FRETE,
	nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 
												baandb.tcisli941201 cisli941b,
												baandb.ttcibd001201 tcibd001b
		WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
		AND 	cisli941b.t$fire$l=cisli941.t$fire$l
		AND		tcibd001b.t$item=cisli941b.t$item$l
		AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
		AND		tcibd001b.t$kitm>3
		AND		tcibd001b.t$ctyp$l!=2
		AND 	cisli943.t$brty$l=1),0) VL_ICMS_OUTROS,
	(SELECT cisli943.t$amnt$l FROM baandb.tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=6) VL_COFINS,
	Nvl((SELECT cisli943.t$amni$l from baandb.tcisli943201 cisli943
		 WHERE  cisli943.t$fire$l=cisli941.t$fire$l
		 AND    cisli943.t$line$l=cisli941.t$line$l
		 AND    cisli943.t$brty$l=6),0) VL_COFINS_PRODUTO,
	nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 
												baandb.tcisli941201 cisli941b,
												baandb.ttcibd001201 tcibd001b
		WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
		AND 	cisli941b.t$fire$l=cisli941.t$fire$l
		AND		tcibd001b.t$item=cisli941b.t$item$l
		AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
		AND		tcibd001b.t$ctyp$l=2
		AND 	cisli943.t$brty$l=6),0) VL_COFINS_FRETE,
	nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 
												baandb.tcisli941201 cisli941b,
												baandb.ttcibd001201 tcibd001b
		WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
		AND 	cisli941b.t$fire$l=cisli941.t$fire$l
		AND		tcibd001b.t$item=cisli941b.t$item$l
		AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
		AND		tcibd001b.t$kitm>3
		AND		tcibd001b.t$ctyp$l!=2
		AND 	cisli943.t$brty$l=6),0) VL_COFINS_OUTROS,
	Nvl((SELECT cisli943.t$amni$l from baandb.tcisli943201 cisli943
		 WHERE  cisli943.t$fire$l=cisli941.t$fire$l
		 AND    cisli943.t$line$l=cisli941.t$line$l
		 AND    cisli943.t$brty$l=5),0) VL_PIS_PRODUTO,
	nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 
											baandb.tcisli941201 cisli941b,
											baandb.ttcibd001201 tcibd001b
	WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
	AND 	cisli941b.t$fire$l=cisli941.t$fire$l
	AND		tcibd001b.t$item=cisli941b.t$item$l
	AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
	AND		tcibd001b.t$ctyp$l=2
	AND 	cisli943.t$brty$l=5),0) VL_PIS_FRETE,
	nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 
											baandb.tcisli941201 cisli941b,
											baandb.ttcibd001201 tcibd001b
	WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
	AND 	cisli941b.t$fire$l=cisli941.t$fire$l
	AND		tcibd001b.t$item=cisli941b.t$item$l
	AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
	AND		tcibd001b.t$kitm>3
	AND		tcibd001b.t$ctyp$l!=2
	AND 	cisli943.t$brty$l=5),0)	VL_PIS_OUTROS,
	Nvl((SELECT cisli943.t$amnt$l from baandb.tcisli943201 cisli943
		 WHERE  cisli943.t$fire$l=cisli941.t$fire$l
		 AND    cisli943.t$line$l=cisli941.t$line$l
		 AND    cisli943.t$brty$l=13),0) VL_CSLL,
	Nvl((SELECT cisli943.t$amni$l from baandb.tcisli943201 cisli943
		 WHERE  cisli943.t$fire$l=cisli941.t$fire$l
		 AND    cisli943.t$line$l=cisli941.t$line$l
		 AND    cisli943.t$brty$l=13),0) VL_CSLL_PRODUTO,
	nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 
											baandb.tcisli941201 cisli941b,
											baandb.ttcibd001201 tcibd001b
	WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
	AND 	cisli941b.t$fire$l=cisli941.t$fire$l
	AND		tcibd001b.t$item=cisli941b.t$item$l
	AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
	AND		tcibd001b.t$ctyp$l=2
	AND 	cisli943.t$brty$l=13),0) VL_CSLL_FRETE,
	nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 
											baandb.tcisli941201 cisli941b,
											baandb.ttcibd001201 tcibd001b
	WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
	AND 	cisli941b.t$fire$l=cisli941.t$fire$l
	AND		tcibd001b.t$item=cisli941b.t$item$l
	AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
	AND		tcibd001b.t$kitm>3
	AND		tcibd001b.t$ctyp$l!=2
	AND 	cisli943.t$brty$l=13),0) VL_CSLL_OUTROS,	
	znsls401.t$vldi$c VL_DESCONTO_INCONDICIONAL,
	cisli941.t$line$l NR_ITEM_NF,
	cisli941.t$ccfo$l CD_NATUREZA_OPERACAO,
	cisli941.t$opor$l SQ_NATUREZA_OPERACAO,
	cisli941.t$cchr$l VL_DESPESA_ADUANEIRA,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN cisli941.t$gexp$l
	ELSE 0 END VL_ADICIONAL_IMPORTACAO,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN
	nvl((select li.t$amnt$l from baandb.tcisli943201 li
	where	li.t$fire$l=cisli941.t$fire$l
	and		li.t$line$l=cisli941.t$line$l
	and 	li.t$brty$l=5),0) 
	ELSE 0 END VL_PIS_IMPORTACAO,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN
	nvl((select li.t$amnt$l from baandb.tcisli943201 li
	where	li.t$fire$l=cisli941.t$fire$l
	and		li.t$line$l=cisli941.t$line$l
	and 	li.t$brty$l=6),0) 
	ELSE 0 END VL_COFINS_IMPORTACAO,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN cisli941.t$fght$l
	ELSE 0 END VL_CIF_IMPORTACAO,
	CAST((FROM_TZ(CAST(TO_CHAR(Greatest(cisli940.t$datg$l, cisli940.t$date$l, cisli940.t$dats$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE)  DT_ATUALIZACAO_NF,
	tcemm124.t$grid CD_UNIDADE_EMPRESARIAL,
	cisli941.t$fire$l NR_REFERENCIA_FISCAL,				--#FAF.109.n
	(SELECT cisli943.t$sbas$l FROM baandb.tcisli943201 cisli943
		WHERE cisli943.t$fire$l=cisli941.t$fire$l
		AND cisli943.t$line$l=cisli941.t$line$l
		AND cisli943.t$brty$l=1) VL_BASE_ICMS,
	(SELECT cisli943.t$sbas$l FROM baandb.tcisli943201 cisli943
		WHERE cisli943.t$fire$l=cisli941.t$fire$l
		AND cisli943.t$line$l=cisli941.t$line$l
		AND cisli943.t$brty$l=3) VL_BASE_IPI
FROM 
--	baandb.tcisli941201 cisli941,																	--#FAF.247.o
	baandb.tcisli940201 cisli940,
	baandb.ttcemm124201 tcemm124,
	baandb.ttcemm030201 tcemm030,
--	baandb.tcisli245201 cisli245																	--#FAF.247.o
	baandb.tcisli941201 cisli941																	--#FAF.247.sn
	LEFT JOIN baandb.tcisli245201 cisli245															
				ON cisli245.t$fire$l=cisli941.t$fire$l
				AND cisli245.t$line$l=cisli941.t$line$l												--#FAF.247.en
	
	
	LEFT JOIN baandb.tznsls401201 znsls401 ON cisli245.t$slso=znsls401.t$orno$c
							AND cisli245.t$pono=znsls401.t$pono$c
--	baandb.ttdsls401201 tdsls401,																	--#FAF.247.o
	LEFT JOIN baandb.ttdsls401201 tdsls401															--#FAF.247.sn
				ON cisli245.t$slso=tdsls401.t$orno
				AND cisli245.t$pono=tdsls401.t$pono
				AND cisli245.t$sqnb=tdsls401.t$sqnb,													--#FAF.247.en
	
	baandb.ttcibd001201 tcibd001
WHERE
		cisli940.t$fire$l=cisli941.t$fire$l
	--AND entr.t$fire$l=cisli940.t$fire$l
	AND tcemm124.t$loco=201
	AND tcemm124.t$dtyp=1
	AND tcemm124.t$cwoc=cisli940.t$cofc$l
	AND tcemm030.t$eunt=tcemm124.t$grid
--	AND cisli245.t$fire$l=cisli941.t$fire$l															--#FAF.247.so
--	AND cisli245.t$line$l=cisli941.t$line$l															
--	AND cisli245.t$slso=tdsls401.t$orno
--	AND cisli245.t$pono=tdsls401.t$pono
--	AND cisli245.t$sqnb=tdsls401.t$sqnb																--#FAF.247.eo
  AND tcibd001.t$item=cisli941.t$item$l
  AND tcibd001.t$ctyp$l!=2