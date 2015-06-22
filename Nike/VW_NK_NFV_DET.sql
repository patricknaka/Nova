SELECT DISTINCT
-- O campo CD_CIA foi incluido para diferenciar NIKE(601) E BUNZL(602)
--**********************************************************************************************************************************************************
    601 CD_CIA,
    CASE WHEN tcemm030.t$euca = ' ' then substr(tcemm124.t$grid,-2,2) else tcemm030.t$euca end as CD_FILIAL,
    cisli940.t$docn$l NR_NF,
    cisli940.t$seri$l NR_SERIE_NF,
    ltrim(rtrim(cisli941.t$item$l)) CD_ITEM,
    cisli941.t$dqua$l QT_FATURADA,
    nvl((select dv.t$dqua$l from baandb.tcisli941601 dv
      where dv.t$fire$l=tdsls401.t$fire$l and dv.t$line$l=tdsls401.t$line$l),'0') QT_DEVOLVIDA,
    cisli941.t$pric$l VL_UNITARIO_PRODUTO,
    nvl(ICMS.t$amnt$l, 0) VL_ICMS,															
    (SELECT cisli943.t$amnt$l FROM baandb.tcisli943601 cisli943
      WHERE cisli943.t$fire$l=cisli941.t$fire$l
      AND cisli943.t$line$l=cisli941.t$line$l
      AND cisli943.t$brty$l=2) VL_ICMS_ST,
    (SELECT cisli943.t$amnt$l FROM baandb.tcisli943601 cisli943
      WHERE cisli943.t$fire$l=cisli941.t$fire$l
      AND cisli943.t$line$l=cisli941.t$line$l
      AND cisli943.t$brty$l=3) VL_IPI,
    cisli941.t$gamt$l VL_PRODUTO,
    cisli941.t$fght$l VL_FRETE,																	
    cisli941.t$insr$l VL_SEGURO,
    case when cisli941.t$item$l not in															
		(select a.t$itjl$c 
				from baandb.tznsls000601 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000601 b)
		 UNION ALL
		 select a.t$itmd$c 
				from baandb.tznsls000601 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000601 b)
		 UNION ALL
		 select a.t$itmf$c 
				from baandb.tznsls000601 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000601 b))
	then 
	cisli941.t$gexp$l-
		nvl((select sum(c.t$amnt$l) from baandb.tcisli941601 c
			where c.t$fire$l=cisli941.t$fire$l
			and   c.t$item$l=(select a.t$itjl$c 
							  from baandb.tznsls000601 a 
							  where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000601 b))),0) 
	else 0 end VL_DESPESA,
	(SELECT cisli943.t$amnt$l FROM baandb.tcisli943601 cisli943
	WHERE cisli943.t$fire$l=cisli941.t$fire$l
	AND cisli943.t$line$l=cisli941.t$line$l
	AND cisli943.t$brty$l=16) VL_IMPOSTO_IMPORTACAO,
	cisli941.t$ldam$l VL_DESCONTO,
	cisli941.t$iprt$l VL_TOTAL_ITEM,
	nvl(to_char((select cdv.t$docn$l from baandb.tcisli940601 cdv
	where cdv.t$fire$l=tdsls401.t$fire$l)),' ') NR_NFR_DEVOLUCAO,
	case when cisli941.t$item$l not in															
		(select a.t$itjl$c 
				from baandb.tznsls000601 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000601 b)
		 UNION ALL
		 select a.t$itmd$c 
				from baandb.tznsls000601 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000601 b)
		 UNION ALL
		 select a.t$itmf$c 
				from baandb.tznsls000601 a 
				where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000601 b))
	then 	
		nvl((select sum(c.t$amnt$l) from baandb.tcisli941601 c
			where c.t$fire$l=cisli941.t$fire$l
			and   c.t$item$l=(select a.t$itjl$c 
							  from baandb.tznsls000601 a 
							  where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000601 b))),0)	
	else 0 end VL_DESPESA_FINANCEIRA,
	nvl(PIS.t$amnt$l,0) VL_PIS,																	
	cisli941.t$iprt$l*(nvl(ICMS.t$rate$l,0)/100) VL_ICMS_PRODUTO,								
	cisli941.t$fght$l*(nvl(ICMS.t$rate$l,0)/100) VL_ICMS_FRETE,									
	CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 THEN					
	nvl(ICMS.t$amnt$l, 0)																				
	-cisli941.t$iprt$l*(nvl(ICMS.t$rate$l,0)/100)
	-cisli941.t$fght$l*(nvl(ICMS.t$rate$l,0)/100) 
	ELSE 0 END	VL_ICMS_OUTROS,																
	nvl(COFINS.t$amnt$l,0) VL_COFINS,														
  cisli941.t$iprt$l*(nvl(COFINS.t$rate$l,0)/100) VL_COFINS_PRODUTO,  									 
	cisli941.t$fght$l*(nvl(COFINS.t$rate$l,0)/100) VL_COFINS_FRETE,    						
	CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 THEN						
	nvl(COFINS.t$amnt$l, 0)
	-cisli941.t$iprt$l*(nvl(COFINS.t$rate$l,0)/100)
	-cisli941.t$fght$l*(nvl(COFINS.t$rate$l,0)/100) 
	ELSE 0 END	VL_COFINS_OUTROS,																
	cisli941.t$iprt$l*(nvl(PIS.t$rate$l,0)/100) VL_PIS_PRODUTO,									
  cisli941.t$fght$l*(nvl(PIS.t$rate$l,0)/100) VL_PIS_FRETE,									
	CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 THEN						
    nvl(PIS.t$amnt$l, 0)
    -cisli941.t$iprt$l*(nvl(PIS.t$rate$l,0)/100)
    -cisli941.t$fght$l*(nvl(PIS.t$rate$l,0)/100) 
    ELSE 0 END	VL_PIS_OUTROS,  																	
  nvl(CSLL.t$amnt$l,0)  VL_CSLL,																	
  cisli941.t$iprt$l*(nvl(CSLL.t$rate$l,0)/100) VL_CSLL_PRODUTO,								 
  cisli941.t$fght$l*(nvl(CSLL.t$rate$l,0)/100) VL_CSLL_FRETE,								
	CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 
    THEN	nvl(CSLL.t$amnt$l, 0)
          -cisli941.t$iprt$l*(nvl(CSLL.t$rate$l,0)/100)
          -cisli941.t$fght$l*(nvl(CSLL.t$rate$l,0)/100) 
	ELSE 0 END	VL_CSLL_OUTROS,  															
	znsls401.t$vldi$c VL_DESCONTO_INCONDICIONAL,
	cisli941.t$line$l NR_ITEM_NF,
	cisli941.t$ccfo$l CD_NATUREZA_OPERACAO,
	cisli941.t$opor$l SQ_NATUREZA_OPERACAO,
	cisli941.t$cchr$l VL_DESPESA_ADUANEIRA,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN cisli941.t$gexp$l
    ELSE 0 END VL_ADICIONAL_IMPORTACAO,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN nvl(PIS.t$amnt$l,0)																	
    ELSE 0 END VL_PIS_IMPORTACAO,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN nvl(COFINS.t$amnt$l,0)																	
    ELSE 0 END VL_COFINS_IMPORTACAO,
	CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN cisli941.t$fght$l
    ELSE 0 END VL_CIF_IMPORTACAO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli941.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ATUALIZACAO,
	tcemm124.t$grid CD_UNIDADE_EMPRESARIAL,
	cisli941.t$fire$l NR_REFERENCIA_FISCAL,				
	nvl(ICMS.t$sbas$l,0) 			VL_BASE_ICMS,													
	(SELECT cisli943.t$sbas$l FROM baandb.tcisli943601 cisli943
		WHERE cisli943.t$fire$l=cisli941.t$fire$l
		AND cisli943.t$line$l=cisli941.t$line$l
		AND cisli943.t$brty$l=3) VL_BASE_IPI,
	CASE WHEN cisli940.t$fdty$l=15 then cisli941.t$refr$l										
			ELSE NULL END	NR_REFERENCIA_FISCAL_FATURA,
	CASE WHEN cisli940.t$fdty$l=15 then TO_CHAR(cisli941.t$rfdl$l)
			ELSE NULL END	NR_ITEM_NF_FATURA,														
	cisli941.t$refr$l		NR_REFERENCIA_FISCAL_RELATIVA,														
	cisli941.t$rfdl$l		NR_LINHA_REF_FISCAL_RELATIVA													
FROM 
	baandb.tcisli940601 cisli940,
	baandb.ttcemm124601 tcemm124,
	baandb.ttcemm030601 tcemm030,
	baandb.tcisli941601 cisli941																	
	LEFT JOIN baandb.tcisli245601 cisli245															
				ON cisli245.t$fire$l=cisli941.t$fire$l
				AND cisli245.t$line$l=cisli941.t$line$l												

		LEFT JOIN baandb.tcisli943601 ICMS	ON 	ICMS.t$fire$l=cisli941.t$fire$l					
											AND	ICMS.t$line$l=cisli941.t$line$l
											AND ICMS.t$brty$l=1
		LEFT JOIN baandb.tcisli943601 COFINS ON COFINS.t$fire$l=cisli941.t$fire$l									
											AND	COFINS.t$line$l=cisli941.t$line$l
											AND COFINS.t$brty$l=6
		LEFT JOIN baandb.tcisli943601 PIS 	ON 	PIS.t$fire$l=cisli941.t$fire$l									
											AND	PIS.t$line$l=cisli941.t$line$l
											AND PIS.t$brty$l=5
		LEFT JOIN baandb.tcisli943601 CSLL 	ON 	CSLL.t$fire$l=cisli941.t$fire$l									
											AND	CSLL.t$line$l=cisli941.t$line$l
											AND CSLL.t$brty$l=13
                      
    LEFT JOIN baandb.tznsls401601 znsls401 ON cisli245.t$slso=znsls401.t$orno$c
                      AND cisli245.t$pono=znsls401.t$pono$c

    LEFT JOIN baandb.ttdsls401601 tdsls401 ON cisli245.t$slso=tdsls401.t$orno
                      AND cisli245.t$pono=tdsls401.t$pono
                      AND cisli245.t$sqnb=tdsls401.t$sqnb,													
	
    baandb.ttcibd001601 tcibd001
    
WHERE cisli940.t$fire$l=cisli941.t$fire$l
	AND tcemm124.t$loco=601
	AND tcemm124.t$dtyp=1
	AND tcemm124.t$cwoc=cisli940.t$cofc$l
	AND tcemm030.t$eunt=tcemm124.t$grid
  AND tcibd001.t$item=cisli941.t$item$l
  AND tcibd001.t$ctyp$l!=2