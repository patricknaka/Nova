-- 05-jan-2014, Fabio Ferreira, Correção registros duplicados (relacionamento cisli245),
--								Não mostrar linhas de frete e mostar o valor de frete rateado na coluna valor frete (frete da znsls401)
--****************************************************************************************************************************************************************
SELECT DISTINCT 
    201 COMPANHIA,
    tcemm030.t$euca FILIAL,
	tcemm124.t$grid UNID_EMPRESARIAL,
	cisli940.t$docn$l NUM_NOTA_FISCAL,
	cisli940.t$seri$l SER_NOTA_FISCAL,
	ltrim(rtrim(cisli941.t$item$l)) COD_ITEM,
	cisli941.t$dqua$l QTD_FATURADA,
	nvl((select dv.t$dqua$l from tcisli941201 dv
	where dv.t$fire$l=tdsls401.t$fire$l and dv.t$line$l=tdsls401.t$line$l),'0') QTD_DEVOLVIDA,
	cisli941.t$pric$l VALOR_UNITARIO_PRODUTO,
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=1) VALOR_ICMS,
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=2) VALOR_ICMS_ST,
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=3) VALOR_IPI,
	cisli941.t$gamt$l VALOR_PRODUTO,
	--cisli941.t$fght$l VALOR_FRETE,
	znsls401.T$VLFR$C VALOR_FRETE,
	cisli941.t$insr$l VALOR_SEGURO,
	cisli941.t$gexp$l VALOR_DESPESA,
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=16) VALOR_IMPOSTO_IMPORTACAO,
	cisli941.t$ldam$l VALOR_DESCONTO,
	cisli941.t$iprt$l VALOR_TOTAL_ITEM,
	nvl(to_char((select cdv.t$docn$l from tcisli940201 cdv
	where cdv.t$fire$l=tdsls401.t$fire$l)),' ') NUM_NOTA_RECEBIMENTO_DEVOLUCAO,
	cisli941.t$amfi$l VALOR_DESPESA_FINANCEIRA,
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=5) VALOR_PIS,
	0 VALOR_ICMS_PRODUTO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_ICMS_FRETE,							-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_ICMS_OUTROS,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	(SELECT cisli943.t$amnt$l FROM tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=6) VALOR_COFINS,
	0 VALOR_COFINS_PRODUTO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_COFINS_FRETE,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_COFINS_OUTROS,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_PIS_PRODUTO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_PIS_FRETE,							-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_PIS_OUTROS,							-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_CSLL,								-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_CSLL_PRODUTO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_CSLL_FRETE,							-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_CSLL_OUTROS,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	znsls401.t$vldi$c VALOR_DESCONTO_INCONDICIONAL,
	cisli941.t$line$l NUM_ITEM_NOTA,
	cisli941.t$ccfo$l COD_NATUREZA_OPERACAO,
	cisli941.t$opor$l SEQ_NATUREZA_OPERACAO,
	cisli941.t$cchr$l VALOR_DESPESA_ADUANEIRO,
	0 VALOR_ADICIONAL_IMPORTACAO,				-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_PIS_IMPORTACAO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_COFINS_IMPORTACAO,					-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	0 VALOR_CIF_IMPORTACAO,						-- *** PENDENTE DE DEFINIÇÃO FUNCIONAL ***
	CAST((FROM_TZ(CAST(TO_CHAR(Greatest(cisli940.t$datg$l, cisli940.t$date$l, cisli940.t$dats$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE)  DT_ATUALIZACAO_NOTA_FISCAL
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