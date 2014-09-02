-- 05-mai-2014, Fabio Ferreira, Correção registros duplicados (relacionamento cisli245),
--								Não mostrar linhas de frete e mostar o valor de frete rateado na coluna valor frete (frete da znsls401)
-- #FAF.041 - 29-mai-2014, Fabio Ferreira, 	Correções de informações que estavam pendente do fiscal
-- #FAF.041b - 29-mai-2014, Fabio Ferreira, Alteração no relacionamento para melhora de performace
-- #FAF.109 - 07-jun-2014, Fabio Ferreira, 	Inclusão do campo ref.fiscal
-- #FAF.247.1 - 30-jun-2014, Fabio Ferreira, 	Correções Frete
-- #MAT.001 - 31-jul-2014, Marcia A. Torres, Correção do campo DT_ATUALIZACAO_NF
-- #FAF.253 - 13-aug-2014, Fabio Ferreira, 	Inclusão do campo ref fiscal e linha de fatura
-- #FAF.287 - 14-aug-2014, Fabio Ferreira, Correção do campo DT_ATUALIZACAO_NF
-- 21/08/2014  Atualização do timezone
-- #FAF.298 - 22-aug-2014, Fabio Ferreira, Ref fiscal relativa e linha
-- #FAF.302 - 25-aug-2014, Fabio Ferreira, Correção impostos
-- #FAF.302.1 - 25-aug-2014, Fabio Ferreira, Correção despesas
-- #FAF.302.2 - 01-sep-2014, Fabio Ferreira, Correção despesas
--****************************************************************************************************************************************************************
SELECT DISTINCT 
    201 CD_CIA,
    --tcemm030.t$euca,
    CASE WHEN tcemm030.t$euca = ' ' then substr(tcemm124.t$grid,-2,2) else tcemm030.t$euca end as CD_FILIAL,
	cisli940.t$docn$l NR_NF,
	cisli940.t$seri$l NR_SERIE_NF,
	ltrim(rtrim(cisli941.t$item$l)) CD_ITEM,
	cisli941.t$dqua$l QT_FATURADA,
	nvl((select dv.t$dqua$l from baandb.tcisli941201 dv
	where dv.t$fire$l=tdsls401.t$fire$l and dv.t$line$l=tdsls401.t$line$l),'0') QT_DEVOLVIDA,
	cisli941.t$pric$l VL_UNITARIO_PRODUTO,
	-- (SELECT cisli943.t$amnt$l FROM baandb.tcisli943201 cisli943							--#FAF.302.so
	-- WHERE cisli943.t$fire$l=cisli941.t$fire$l
	-- AND cisli943.t$line$l=cisli941.t$line$l
	-- AND cisli943.t$brty$l=1) VL_ICMS,													--#FAF.302.eo
	nvl(ICMS.t$amnt$l, 0) VL_ICMS,															--#FAF.302.n
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
	-- cisli941.t$gexp$l VL_DESPESA,															--#FAF.302.1.o
	
	-- CASE WHEN cisli941.t$gexp$l>=nvl(znsls402.t$vlju$c,0) THEN								--#FAF.302.1.sn		--#FAF.302.1.so		
		-- cisli941.t$gexp$l-nvl(znsls402.t$vlju$c,0) 
	-- ELSE cisli941.t$gexp$l END VL_DESPESA,													--#FAF.302.1.en		--#FAF.302.1.eo
	
	case when cisli941.t$item$l not in															--#FAF.302.1.sn
		(select a.t$itjl$c 
				from baandb.tznsls000201 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000201 b)
		 UNION ALL
		 select a.t$itmd$c 
				from baandb.tznsls000201 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000201 b)
		 UNION ALL
		 select a.t$itmf$c 
				from baandb.tznsls000201 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000201 b))
	then 
	cisli941.t$gexp$l-
		nvl((select sum(c.t$amnt$l) from baandb.tcisli941201 c
			where c.t$fire$l=cisli941.t$fire$l
			and   c.t$item$l=(select a.t$itjl$c 
							  from baandb.tznsls000201 a 
							  where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000201 b))),0) 
	else 0 end VL_DESPESA,												
																							--#FAF.302.1.en
	(SELECT cisli943.t$amnt$l FROM baandb.tcisli943201 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=16) VL_IMPOSTO_IMPORTACAO,
	cisli941.t$ldam$l VL_DESCONTO,
	cisli941.t$iprt$l VL_TOTAL_ITEM,
	nvl(to_char((select cdv.t$docn$l from baandb.tcisli940201 cdv
	where cdv.t$fire$l=tdsls401.t$fire$l)),' ') NR_NFR_DEVOLUCAO,
	-- cisli941.t$amfi$l VL_DESPESA_FINANCEIRA,													--#FAF.302.1.o
	-- nvl(znsls402.t$vlju$c,0) VL_DESPESA_FINANCEIRA,											--#FAF.302.1.n		--#FAF.302.1.o
	
	case when cisli941.t$item$l not in															--#FAF.302.1.sn
		(select a.t$itjl$c 
				from baandb.tznsls000201 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000201 b)
		 UNION ALL
		 select a.t$itmd$c 
				from baandb.tznsls000201 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000201 b)
		 UNION ALL
		 select a.t$itmf$c 
				from baandb.tznsls000201 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000201 b))
	then 	
		nvl((select sum(c.t$amnt$l) from baandb.tcisli941201 c
			where c.t$fire$l=cisli941.t$fire$l
			and   c.t$item$l=(select a.t$itjl$c 
							  from baandb.tznsls000201 a 
							  where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000201 b))),0)	
	else 0 end VL_DESPESA_FINANCEIRA,
																								--#FAF.302.1.en
						  
	-- (SELECT cisli943.t$amnt$l FROM baandb.tcisli943201 cisli943								--#FAF.302.so
	-- WHERE cisli943.t$fire$l=cisli941.t$fire$l
	-- AND cisli943.t$line$l=cisli941.t$line$l
	-- AND cisli943.t$brty$l=5) VL_PIS,															--#FAF.302.eo
	nvl(PIS.t$amnt$l,0) VL_PIS,																	--#FAF.302.n	
	
	-- Nvl((SELECT cisli943.t$amni$l from baandb.tcisli943201 cisli943							--#FAF.302.so
             -- WHERE  cisli943.t$fire$l=cisli941.t$fire$l
             -- AND    cisli943.t$line$l=cisli941.t$line$l
             -- AND    cisli943.t$brty$l=1),0) VL_ICMS_PRODUTO,									--#FAF.302.eo
	cisli941.t$iprt$l*(nvl(ICMS.t$rate$l,0)/100) VL_ICMS_PRODUTO,								--#FAF.302.n
	
	-- nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 					--#FAF.302.so
												-- baandb.tcisli941201 cisli941b,
												-- baandb.ttcibd001201 tcibd001b
		-- WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
		-- AND 	cisli941b.t$fire$l=cisli941.t$fire$l
		-- AND		tcibd001b.t$item=cisli941b.t$item$l
		-- AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
		-- AND		tcibd001b.t$ctyp$l=2
		-- AND 	cisli943.t$brty$l=1),0) VL_ICMS_FRETE,											--#FAF.302.eo
	cisli941.t$fght$l*(nvl(ICMS.t$rate$l,0)/100) VL_ICMS_FRETE,									--#FAF.302.n
	
	-- nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 					--#FAF.302.so
												-- baandb.tcisli941201 cisli941b,
												-- baandb.ttcibd001201 tcibd001b
		-- WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
		-- AND 	cisli941b.t$fire$l=cisli941.t$fire$l
		-- AND		tcibd001b.t$item=cisli941b.t$item$l
		-- AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
		-- AND		tcibd001b.t$kitm>3
		-- AND		tcibd001b.t$ctyp$l!=2
		-- AND 	cisli943.t$brty$l=1),0) VL_ICMS_OUTROS,											--#FAF.302.eo
	CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 THEN						--#FAF.302.sn
	nvl(ICMS.t$amnt$l, 0)																				
	-cisli941.t$iprt$l*(nvl(ICMS.t$rate$l,0)/100)
	-cisli941.t$fght$l*(nvl(ICMS.t$rate$l,0)/100) 
	ELSE 0 END	VL_ICMS_OUTROS,																	--#FAF.302.en
	
	-- (SELECT cisli943.t$amnt$l FROM baandb.tcisli943201 cisli943								--#FAF.302.so
	-- WHERE cisli943.t$fire$l=cisli941.t$fire$l
	-- AND cisli943.t$line$l=cisli941.t$line$l
	-- AND cisli943.t$brty$l=6) VL_COFINS,														--#FAF.302.eo
	nvl(COFINS.t$amnt$l,0) VL_COFINS,															--#FAF.302.n
	
	-- Nvl((SELECT cisli943.t$amni$l from baandb.tcisli943201 cisli943							--#FAF.302.so
		 -- WHERE  cisli943.t$fire$l=cisli941.t$fire$l
		 -- AND    cisli943.t$line$l=cisli941.t$line$l
		 -- AND    cisli943.t$brty$l=6),0) VL_COFINS_PRODUTO,									--#FAF.302.eo
    cisli941.t$iprt$l*(nvl(COFINS.t$rate$l,0)/100) VL_COFINS_PRODUTO,  							--#FAF.302.n		 
	-- nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 					--#FAF.302.s0
												-- baandb.tcisli941201 cisli941b,
												-- baandb.ttcibd001201 tcibd001b
		-- WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
		-- AND 	cisli941b.t$fire$l=cisli941.t$fire$l
		-- AND		tcibd001b.t$item=cisli941b.t$item$l
		-- AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
		-- AND		tcibd001b.t$ctyp$l=2
		-- AND 	cisli943.t$brty$l=6),0) VL_COFINS_FRETE,										--#FAF.302.eo
	cisli941.t$fght$l*(nvl(COFINS.t$rate$l,0)/100) VL_COFINS_FRETE,    						--#FAF.302.n
	-- nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 					--#FAF.302.so
												-- baandb.tcisli941201 cisli941b,
												-- baandb.ttcibd001201 tcibd001b
		-- WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
		-- AND 	cisli941b.t$fire$l=cisli941.t$fire$l
		-- AND		tcibd001b.t$item=cisli941b.t$item$l
		-- AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
		-- AND		tcibd001b.t$kitm>3
		-- AND		tcibd001b.t$ctyp$l!=2
		-- AND 	cisli943.t$brty$l=6),0) VL_COFINS_OUTROS,										--#FAF.302.eo
	CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 THEN						--#FAF.302.sn
	nvl(COFINS.t$amnt$l, 0)
	-cisli941.t$iprt$l*(nvl(COFINS.t$rate$l,0)/100)
	-cisli941.t$fght$l*(nvl(COFINS.t$rate$l,0)/100) 
	ELSE 0 END	VL_COFINS_OUTROS,																--#FAF.302.en
	-- Nvl((SELECT cisli943.t$amni$l from baandb.tcisli943201 cisli943							--#FAF.302.so
		 -- WHERE  cisli943.t$fire$l=cisli941.t$fire$l
		 -- AND    cisli943.t$line$l=cisli941.t$line$l
		 -- AND    cisli943.t$brty$l=5),0) VL_PIS_PRODUTO,										--#FAF.302.eo
	cisli941.t$iprt$l*(nvl(PIS.t$rate$l,0)/100) VL_PIS_PRODUTO,									--#FAF.302.n
	
	-- nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 					--#FAF.302.so
											-- baandb.tcisli941201 cisli941b,
											-- baandb.ttcibd001201 tcibd001b
	-- WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
	-- AND 	cisli941b.t$fire$l=cisli941.t$fire$l
	-- AND		tcibd001b.t$item=cisli941b.t$item$l
	-- AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
	-- AND		tcibd001b.t$ctyp$l=2
	-- AND 	cisli943.t$brty$l=5),0) VL_PIS_FRETE,												--#FAF.302.eo
    cisli941.t$fght$l*(nvl(PIS.t$rate$l,0)/100) VL_PIS_FRETE,									--#FAF.302.n
	-- nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 					--#FAF.302.so
											-- baandb.tcisli941201 cisli941b,
											-- baandb.ttcibd001201 tcibd001b
	-- WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
	-- AND 	cisli941b.t$fire$l=cisli941.t$fire$l
	-- AND		tcibd001b.t$item=cisli941b.t$item$l
	-- AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
	-- AND		tcibd001b.t$kitm>3
	-- AND		tcibd001b.t$ctyp$l!=2
	-- AND 	cisli943.t$brty$l=5),0)	VL_PIS_OUTROS,												--#FAF.302.eo
	CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 THEN						--#FAF.302.sn	
	nvl(PIS.t$amnt$l, 0)
	-cisli941.t$iprt$l*(nvl(PIS.t$rate$l,0)/100)
	-cisli941.t$fght$l*(nvl(PIS.t$rate$l,0)/100) 
	ELSE 0 END	VL_PIS_OUTROS,  																--#FAF.302.en	
	
	-- Nvl((SELECT cisli943.t$amnt$l from baandb.tcisli943201 cisli943							--#FAF.302.so
		 -- WHERE  cisli943.t$fire$l=cisli941.t$fire$l
		 -- AND    cisli943.t$line$l=cisli941.t$line$l
		 -- AND    cisli943.t$brty$l=13),0) VL_CSLL,											--#FAF.302.eo
    nvl(CSLL.t$amnt$l,0)  VL_CSLL,																--#FAF.302.n	
	-- Nvl((SELECT cisli943.t$amni$l from baandb.tcisli943201 cisli943							--#FAF.302.so
		 -- WHERE  cisli943.t$fire$l=cisli941.t$fire$l
		 -- AND    cisli943.t$line$l=cisli941.t$line$l
		 -- AND    cisli943.t$brty$l=13),0) VL_CSLL_PRODUTO,									--#FAF.302.eo
    cisli941.t$iprt$l*(nvl(CSLL.t$rate$l,0)/100) VL_CSLL_PRODUTO,								--#FAF.302.n 
	-- nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 					--#FAF.302.
											-- baandb.tcisli941201 cisli941b,
											-- baandb.ttcibd001201 tcibd001b
	-- WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
	-- AND 	cisli941b.t$fire$l=cisli941.t$fire$l
	-- AND		tcibd001b.t$item=cisli941b.t$item$l
	-- AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
	-- AND		tcibd001b.t$ctyp$l=2
	-- AND 	cisli943.t$brty$l=13),0) VL_CSLL_FRETE,												--#FAF.302.eo
    cisli941.t$fght$l*(nvl(CSLL.t$rate$l,0)/100) VL_CSLL_FRETE,									--#FAF.302.n
	
	-- nvl((SELECT sum(cisli943.t$amnt$l) FROM baandb.tcisli943201 cisli943, 					--#FAF.302.so
											-- baandb.tcisli941201 cisli941b,
											-- baandb.ttcibd001201 tcibd001b
	-- WHERE 	cisli943.t$fire$l=cisli941b.t$fire$l
	-- AND 	cisli941b.t$fire$l=cisli941.t$fire$l
	-- AND		tcibd001b.t$item=cisli941b.t$item$l
	-- AND   	cisli943.t$line$l=cisli941b.t$line$l												--#FAF.247.1.n
	-- AND		tcibd001b.t$kitm>3
	-- AND		tcibd001b.t$ctyp$l!=2
	-- AND 	cisli943.t$brty$l=13),0) VL_CSLL_OUTROS,											--#FAF.302.eo
	CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 THEN						--#FAF.302.sn
	nvl(CSLL.t$amnt$l, 0)
	-cisli941.t$iprt$l*(nvl(CSLL.t$rate$l,0)/100)
	-cisli941.t$fght$l*(nvl(CSLL.t$rate$l,0)/100) 
	ELSE 0 END	VL_CSLL_OUTROS,  																--#FAF.302.en
	
	znsls401.t$vldi$c VL_DESCONTO_INCONDICIONAL,
	cisli941.t$line$l NR_ITEM_NF,
	cisli941.t$ccfo$l CD_NATUREZA_OPERACAO,
	cisli941.t$opor$l SQ_NATUREZA_OPERACAO,
	cisli941.t$cchr$l VL_DESPESA_ADUANEIRA,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN cisli941.t$gexp$l
	ELSE 0 END VL_ADICIONAL_IMPORTACAO,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN
	-- nvl((select li.t$amnt$l from baandb.tcisli943201 li										--#FAF.302.so
	-- where	li.t$fire$l=cisli941.t$fire$l
	-- and		li.t$line$l=cisli941.t$line$l
	-- and 	li.t$brty$l=5),0) 																	--#FAF.302.eo
		nvl(PIS.t$amnt$l,0)																		--#FAF.302.n
	ELSE 0 END VL_PIS_IMPORTACAO,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN
	-- nvl((select li.t$amnt$l from baandb.tcisli943201 li										--#FAF.302.so
	-- where	li.t$fire$l=cisli941.t$fire$l
	-- and		li.t$line$l=cisli941.t$line$l
	-- and 	li.t$brty$l=6),0) 																	--#FAF.302.eo
		nvl(COFINS.t$amnt$l,0)																	--#FAF.302.n
	ELSE 0 END VL_COFINS_IMPORTACAO,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN cisli941.t$fght$l
	ELSE 0 END VL_CIF_IMPORTACAO,
--	CAST((FROM_TZ(CAST(TO_CHAR(Greatest(cisli940.t$datg$l, cisli940.t$date$l, cisli940.t$dats$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') --#MAT.001.o
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli941.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO,
	tcemm124.t$grid CD_UNIDADE_EMPRESARIAL,
	cisli941.t$fire$l NR_REFERENCIA_FISCAL,				--#FAF.109.n
	-- (SELECT cisli943.t$sbas$l FROM baandb.tcisli943201 cisli943									--#FAF.302.so
		-- WHERE cisli943.t$fire$l=cisli941.t$fire$l
		-- AND cisli943.t$line$l=cisli941.t$line$l
		-- AND cisli943.t$brty$l=1) VL_BASE_ICMS,													--#FAF.302.eo
	nvl(ICMS.t$sbas$l,0) 			VL_BASE_ICMS,													--#FAF.302.n
	
	(SELECT cisli943.t$sbas$l FROM baandb.tcisli943201 cisli943
		WHERE cisli943.t$fire$l=cisli941.t$fire$l
		AND cisli943.t$line$l=cisli941.t$line$l
		AND cisli943.t$brty$l=3) VL_BASE_IPI,
	CASE WHEN cisli940.t$fdty$l=15 then cisli941.t$refr$l											--#FAF.253.sn
			ELSE NULL END	NR_REFERENCIA_FISCAL_FATURA,
	CASE WHEN cisli940.t$fdty$l=15 then cisli941.t$rfdl$l
			ELSE NULL END	NR_ITEM_NF_FATURA,														--#FAF.253.en
	cisli941.t$refr$l		NR_REFERENCIA_FISCAL_RELATIVA,														--#FAF.298.n
	cisli941.t$rfdl$l		NR_LINHA_REF_FISCAL_RELATIVA													--#FAF.298.n
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

		LEFT JOIN baandb.tcisli943201 ICMS	ON 	ICMS.t$fire$l=cisli941.t$fire$l					--#FAF.302.sn
											AND	ICMS.t$line$l=cisli941.t$line$l
											AND ICMS.t$brty$l=1
		LEFT JOIN baandb.tcisli943201 COFINS ON COFINS.t$fire$l=cisli941.t$fire$l									
											AND	COFINS.t$line$l=cisli941.t$line$l
											AND COFINS.t$brty$l=6
		LEFT JOIN baandb.tcisli943201 PIS 	ON 	PIS.t$fire$l=cisli941.t$fire$l									
											AND	PIS.t$line$l=cisli941.t$line$l
											AND PIS.t$brty$l=5
		LEFT JOIN baandb.tcisli943201 CSLL 	ON 	CSLL.t$fire$l=cisli941.t$fire$l									
											AND	CSLL.t$line$l=cisli941.t$line$l
											AND CSLL.t$brty$l=13
																									--#FAF.302.en				
	
	LEFT JOIN baandb.tznsls401201 znsls401 ON cisli245.t$slso=znsls401.t$orno$c
							AND cisli245.t$pono=znsls401.t$pono$c
--	LEFT JOIN
		-- (select 																					--#FAF.302.1.sn
			-- znsls402q.t$ncia$c,
			-- znsls402q.t$uneg$c,
			-- znsls402q.t$pecl$c,
			-- znsls402q.t$sqpd$c,
			-- sum(znsls402q.t$vlju$c) t$vlju$c, 
			-- sum(znsls402q.t$vlja$c) t$vlja$c  
		 -- from	baandb.tznsls402201 znsls402q
		 -- group by
			-- znsls402q.t$ncia$c,
			-- znsls402q.t$uneg$c,
			-- znsls402q.t$pecl$c,
			-- znsls402q.t$sqpd$c) znsls402	ON     	znsls402.t$ncia$c=znsls401.t$ncia$c
			                                -- AND     znsls402.t$uneg$c=znsls401.t$uneg$c
			                                -- AND     znsls402.t$pecl$c=znsls401.t$pecl$c
			                                -- AND     znsls402.t$sqpd$c=znsls401.t$sqpd$c				--#FAF.302.1.en
			
			
							
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