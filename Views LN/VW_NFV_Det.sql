-- 05-jan-2014, Fabio Ferreira, Correção registros duplicados (relacionamento cisli245),
--								Não mostrar linhas de frete e mostar o valor de frete rateado na coluna valor frete (frete da znsls401)
--****************************************************************************************************************************************************************
SELECT DISTINCT 
    201 CD_CIA,
    tcemm030.t$euca CD_FILIAL,
	tcemm124.t$grid CD_UNIDADE_EMPRESARIAL,
	cisli940.t$docn$l NR_NF,
	cisli940.t$seri$l NR_SERIE_NF,
	ltrim(rtrim(cisli941.t$item$l)) CD_ITEM,
	cisli941.t$dqua$l QT_FATURADA,
	nvl((select dv.t$dqua$l from tcisli941201 dv
	where dv.t$fire$l=tdsls401.t$fire$l and dv.t$line$l=tdsls401.t$line$l),'0') QT_DEVOLVIDA,
	cisli941.t$pric$l VL_UNITARIO_PRODUTO,
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=1) VL_ICMS,
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=2) VL_ICMS_ST,
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=3) VL_IPI,
	cisli941.t$gamt$l VL_PRODUTO,
	znsls401.T$VLFR$C VL_FRETE,
	cisli941.t$insr$l VL_SEGURO,
	cisli941.t$gexp$l VL_DESPESA,
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=16) VL_IMPOSTO_IMPORTACAO,
	cisli941.t$ldam$l VL_DESCONTO,
	cisli941.t$iprt$l VL_TOTAL_ITEM,
	nvl(to_char((select cdv.t$docn$l from tcisli940201 cdv
	where cdv.t$fire$l=tdsls401.t$fire$l)),' ') NR_NFR_DEVOLUCAO,
	cisli941.t$amfi$l VL_DESPESA_FINANCEIRA,
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=5) VL_PIS,
	0 VL_ICMS_PRODUTO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_ICMS_FRETE,							-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_ICMS_OUTROS,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=6) VL_COFINS,
	0 VL_COFINS_PRODUTO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_COFINS_FRETE,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_COFINS_OUTROS,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_PIS_PRODUTO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_PIS_FRETE,							-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_PIS_OUTROS,							-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_CSLL,								-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_CSLL_PRODUTO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_CSLL_FRETE,							-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_CSLL_OUTROS,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	znsls401.t$vldi$c VL_DESCONTO_INCONDICIONAL,
	cisli941.t$line$l NR_ITEM_NF,
	cisli941.t$ccfo$l CD_NATUREZA_OPERACAO,
	cisli941.t$opor$l SQ_NATUREZA_OPERACAO,
	cisli941.t$cchr$l VL_DESPESA_ADUANEIRA,
	0 VL_ADICIONAL_IMPORTACAO,				-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_PIS_IMPORTACAO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_COFINS_IMPORTACAO,					-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VL_CIF_IMPORTACAO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	CAST((FROM_TZ(CAST(TO_CHAR(Greatest(cisli940.t$datg$l, cisli940.t$date$l, cisli940.t$dats$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE)  DT_ATUALIZACAO_NF
FROM 
	tcisli941201 cisli941,
	tcisli940201 cisli940,
	ttcemm124201 tcemm124,
	ttcemm030201 tcemm030,
	tcisli245201 cisli245
	LEFT JOIN tznsls401201 znsls401 ON cisli245.t$slso=znsls401.t$orno$c
									AND cisli245.t$pono=znsls401.t$pono$c,
	ttdsls401201 tdsls401,
  ttcibd001201 tcibd001
WHERE
		cisli940.t$fire$l=cisli941.t$fire$l
	--AND entr.t$fire$l=cisli940.t$fire$l
	AND tcemm124.t$loco=201
	AND tcemm124.t$dtyp=1
	AND tcemm124.t$cwoc=cisli940.t$cofc$l
	AND tcemm030.t$eunt=tcemm124.t$grid
	AND cisli245.t$fire$l=cisli941.t$fire$l
	AND cisli245.t$line$l=cisli941.t$line$l
	AND cisli245.t$slso=tdsls401.t$orno
	AND cisli245.t$pono=tdsls401.t$pono
	AND cisli245.t$sqnb=tdsls401.t$sqnb
  AND tcibd001.t$item=cisli941.t$item$l
  AND tcibd001.t$ctyp$l!=2