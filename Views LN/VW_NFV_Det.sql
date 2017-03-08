
--  CREATE OR REPLACE FORCE VIEW "OWN_MIS"."VW_NFV_DET" ("CD_CIA", "CD_FILIAL", "NR_NF", "NR_SERIE_NF", "CD_ITEM", "QT_FATURADA", "QT_DEVOLVIDA", "VL_UNITARIO_PRODUTO", "VL_ICMS", "VL_ICMS_ST", "VL_IPI", "VL_PRODUTO", "VL_FRETE", "VL_SEGURO", "VL_DESPESA", "VL_IMPOSTO_IMPORTACAO", "VL_DESCONTO", "VL_TOTAL_ITEM", "NR_NFR_DEVOLUCAO", "VL_DESPESA_FINANCEIRA", "VL_PIS", "VL_ICMS_PRODUTO", "VL_ICMS_FRETE", "VL_ICMS_OUTROS", "VL_COFINS", "VL_COFINS_PRODUTO", "VL_COFINS_FRETE", "VL_COFINS_OUTROS", "VL_PIS_PRODUTO", "VL_PIS_FRETE", "VL_PIS_OUTROS", "VL_CSLL", "VL_CSLL_PRODUTO", "VL_CSLL_FRETE", "VL_CSLL_OUTROS", "VL_DESCONTO_INCONDICIONAL", "NR_ITEM_NF", "CD_NATUREZA_OPERACAO", "SQ_NATUREZA_OPERACAO", "VL_DESPESA_ADUANEIRA", "VL_ADICIONAL_IMPORTACAO", "VL_PIS_IMPORTACAO", "VL_COFINS_IMPORTACAO", "VL_CIF_IMPORTACAO", "DT_ULT_ATUALIZACAO", "CD_UNIDADE_EMPRESARIAL", "NR_REFERENCIA_FISCAL", "VL_BASE_ICMS", "VL_BASE_IPI", "NR_REFERENCIA_FISCAL_FATURA", "NR_ITEM_NF_FATURA", "NR_REFERENCIA_FISCAL_RELATIVA", "NR_LINHA_REF_FISCAL_RELATIVA") AS 
  SELECT 
    1                                                                          CD_CIA,
    CASE WHEN tcemm030.t$euca = ' ' 
      then substr(tcemm124.t$grid,-2,2) 
      else tcemm030.t$euca end as                                              CD_FILIAL,
	  cisli940.t$docn$l                                                          NR_NF,
	  cisli940.t$seri$l                                                          NR_SERIE_NF,
	  ltrim(rtrim(cisli941.t$item$l))                                            CD_ITEM,
	  cisli941.t$dqua$l                                                          QT_FATURADA,

	  nvl((select dv.t$dqua$l 
         from baandb.tcisli941301 dv
	       where dv.t$fire$l=tdsls401.t$fire$l 
         and dv.t$line$l=tdsls401.t$line$l),'0')                               QT_DEVOLVIDA,

    cisli941.t$pric$l                                                          VL_UNITARIO_PRODUTO,
	  nvl(ICMS.t$amnt$l, 0)                                                      VL_ICMS,

	  (SELECT cisli943.t$amnt$l 
       FROM baandb.tcisli943301 cisli943
	     WHERE cisli943.t$fire$l=cisli941.t$fire$l
	       AND cisli943.t$line$l=cisli941.t$line$l
	       AND cisli943.t$brty$l=2)                                              VL_ICMS_ST,

    (SELECT cisli943.t$amnt$l 
      FROM baandb.tcisli943301 cisli943
	    WHERE cisli943.t$fire$l=cisli941.t$fire$l
        AND cisli943.t$line$l=cisli941.t$line$l
	      AND cisli943.t$brty$l=3)                                               VL_IPI,
	   cisli941.t$gamt$l                                                         VL_PRODUTO,
	   cisli941.t$fght$l                                                         VL_FRETE,
	   cisli941.t$insr$l                                                         VL_SEGURO,
	
	   case when cisli941.t$item$l not in
		   (select a.t$itjl$c 
				 from baandb.tznsls000301 a 
				 where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000301 b)
      UNION ALL
		    select a.t$itmd$c 
				 from baandb.tznsls000301 a 
				 where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000301 b)
		  UNION ALL
		    select a.t$itmf$c 
				 from baandb.tznsls000301 a 
				 where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000301 b))
	   then 
	     cisli941.t$gexp$l-
      nvl((select sum(c.t$amnt$l) from baandb.tcisli941301 c
			      where c.t$fire$l=cisli941.t$fire$l
			        and c.t$item$l=(select a.t$itjl$c 
							  from baandb.tznsls000301 a 
							  where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000301 b))),0) 
	    else 0 end                                                               VL_DESPESA,												
	
	   (SELECT cisli943.t$amnt$l 
        FROM baandb.tcisli943301 cisli943
	      WHERE cisli943.t$fire$l=cisli941.t$fire$l
          AND cisli943.t$line$l=cisli941.t$line$l
          AND cisli943.t$brty$l=16)                                            VL_IMPOSTO_IMPORTACAO,

     cisli941.t$ldam$l VL_DESCONTO,
     cisli941.t$iprt$l VL_TOTAL_ITEM,
     nvl(to_char((select cdv.t$docn$l 
                    from baandb.tcisli940301 cdv
                    where cdv.t$fire$l=tdsls401.t$fire$l)),' ')                NR_NFR_DEVOLUCAO,
	
	   case when cisli941.t$item$l not in
		   (select a.t$itjl$c 
				   from baandb.tznsls000301 a 
				   where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000301 b)
		  UNION ALL
		    select a.t$itmd$c 
				   from baandb.tznsls000301 a 
				   where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000301 b)
      UNION ALL
        select a.t$itmf$c 
				   from baandb.tznsls000301 a 
				   where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000301 b))
	   then 	
		    nvl((select sum(c.t$amnt$l) from baandb.tcisli941301 c
			       where c.t$fire$l=cisli941.t$fire$l
               and c.t$item$l=(select a.t$itjl$c 
                                from baandb.tznsls000301 a 
							                  where a.t$indt$c=(select min(b.t$indt$c) 
                                                   from baandb.tznsls000301 b))),0)	
	   else 0 end                                                                VL_DESPESA_FINANCEIRA,

	   nvl(PIS.t$amnt$l,0)                                                       VL_PIS,
	   cisli941.t$iprt$l*(nvl(ICMS.t$rate$l,0)/100)                              VL_ICMS_PRODUTO,
   	 cisli941.t$fght$l*(nvl(ICMS.t$rate$l,0)/100)                              VL_ICMS_FRETE,

	   CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 THEN
	     nvl(ICMS.t$amnt$l, 0)																				
	     - cisli941.t$iprt$l * (nvl(ICMS.t$rate$l,0)/100)
	     - cisli941.t$fght$l * (nvl(ICMS.t$rate$l,0)/100) 
	   ELSE 0 END	                                                               VL_ICMS_OUTROS,
	
	   nvl(COFINS.t$amnt$l,0)                                                    VL_COFINS,
     cisli941.t$iprt$l*(nvl(COFINS.t$rate$l,0)/100)                            VL_COFINS_PRODUTO,
	   cisli941.t$fght$l*(nvl(COFINS.t$rate$l,0)/100)                            VL_COFINS_FRETE,

	   CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 THEN				
      nvl(COFINS.t$amnt$l, 0)
	    - cisli941.t$iprt$l * (nvl(COFINS.t$rate$l,0)/100)
	    - cisli941.t$fght$l * (nvl(COFINS.t$rate$l,0)/100) 
 	   ELSE 0 END	                                                               VL_COFINS_OUTROS,
	
     cisli941.t$iprt$l*(nvl(PIS.t$rate$l,0)/100)                               VL_PIS_PRODUTO,
     cisli941.t$fght$l*(nvl(PIS.t$rate$l,0)/100)                               VL_PIS_FRETE,
     
	   CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 THEN
	     nvl(PIS.t$amnt$l, 0)
	     - cisli941.t$iprt$l * (nvl(PIS.t$rate$l,0)/100)
	     - cisli941.t$fght$l * (nvl(PIS.t$rate$l,0)/100) 
    ELSE 0 END	                                                               VL_PIS_OUTROS,

    nvl(CSLL.t$amnt$l,0)                                                       VL_CSLL,	
    cisli941.t$iprt$l*(nvl(CSLL.t$rate$l,0)/100)                               VL_CSLL_PRODUTO,	
    cisli941.t$fght$l*(nvl(CSLL.t$rate$l,0)/100)                               VL_CSLL_FRETE,
    
	   CASE WHEN cisli941.t$insr$l+cisli941.t$gexp$l+cisli941.t$cchr$l>0 THEN
	     nvl(CSLL.t$amnt$l, 0)
	     - cisli941.t$iprt$l * (nvl(CSLL.t$rate$l,0)/100)
	     - cisli941.t$fght$l * (nvl(CSLL.t$rate$l,0)/100) 
	   ELSE 0 END	                                                               VL_CSLL_OUTROS,
	
	   znsls401.t$vldi$c                                                         VL_DESCONTO_INCONDICIONAL,
	   cisli941.t$line$l                                                         NR_ITEM_NF,
	   cisli941.t$ccfo$l                                                         CD_NATUREZA_OPERACAO,
	   cisli941.t$opor$l                                                         SQ_NATUREZA_OPERACAO,
	   cisli941.t$cchr$l                                                         VL_DESPESA_ADUANEIRA,

	   CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN 
       cisli941.t$gexp$l
	   ELSE 0 END                                                                VL_ADICIONAL_IMPORTACAO,

	   CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN
		   nvl(PIS.t$amnt$l,0)
	   ELSE 0 END                                                                VL_PIS_IMPORTACAO,

	   CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN
		   nvl(COFINS.t$amnt$l,0)
	   ELSE 0 END                                                                VL_COFINS_IMPORTACAO,

	   CASE WHEN (cisli941.t$sour$l=2 or cisli941.t$sour$l=8) THEN 
       cisli941.t$fght$l
	   ELSE 0 END                                                                VL_CIF_IMPORTACAO,
                                                                               
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                               AT time zone 'America/Sao_Paulo') AS DATE)    
                                                                              DT_ULT_ATUALIZACAO,                                           
                                                                               
	   tcemm124.t$grid                                                           CD_UNIDADE_EMPRESARIAL,
	   cisli941.t$fire$l                                                         NR_REFERENCIA_FISCAL,
		 nvl(ICMS.t$sbas$l,0)                                                      VL_BASE_ICMS,
	
	   (SELECT cisli943.t$sbas$l 
        FROM baandb.tcisli943301 cisli943
		    WHERE cisli943.t$fire$l=cisli941.t$fire$l
		    AND cisli943.t$line$l=cisli941.t$line$l
		    AND cisli943.t$brty$l=3)                                               VL_BASE_IPI,

	   CASE WHEN cisli940.t$fdty$l=15 then 
       cisli941.t$refr$l											
     ELSE NULL END	                                                           NR_REFERENCIA_FISCAL_FATURA,

	   CASE WHEN cisli940.t$fdty$l=15 then 
       TO_CHAR(cisli941.t$rfdl$l)
     ELSE NULL END	                                                           NR_ITEM_NF_FATURA,

	   cisli941.t$refr$l		                                                     NR_REFERENCIA_FISCAL_RELATIVA,	
	   cisli941.t$rfdl$l		                                                     NR_LINHA_REF_FISCAL_RELATIVA	

FROM baandb.tcisli940301 cisli940

    INNER JOIN baandb.tcisli941301 cisli941
            ON cisli941.t$fire$l = cisli940.t$fire$l
        
    INNER JOIN baandb.ttcemm124301 tcemm124
            ON tcemm124.t$loco = 301
           AND tcemm124.t$dtyp = 1
           AND tcemm124.t$cwoc = cisli940.t$cofc$l
    
    INNER JOIN baandb.ttcemm030301 tcemm030
            ON tcemm030.t$eunt = tcemm124.t$grid
															
  	LEFT JOIN baandb.tcisli245301 cisli245															
           ON cisli245.t$fire$l = cisli941.t$fire$l
          AND cisli245.t$line$l = cisli941.t$line$l												

		LEFT JOIN baandb.tcisli943301 ICMS	
           ON ICMS.t$fire$l = cisli941.t$fire$l					
          AND	ICMS.t$line$l = cisli941.t$line$l
          AND ICMS.t$brty$l = 1

		LEFT JOIN baandb.tcisli943301 COFINS 
           ON COFINS.t$fire$l = cisli941.t$fire$l									
          AND	COFINS.t$line$l = cisli941.t$line$l
          AND COFINS.t$brty$l = 6

		LEFT JOIN baandb.tcisli943301 PIS 	
           ON PIS.t$fire$l = cisli941.t$fire$l									
          AND	PIS.t$line$l = cisli941.t$line$l
          AND PIS.t$brty$l = 5

		LEFT JOIN baandb.tcisli943301 CSLL 	
           ON CSLL.t$fire$l = cisli941.t$fire$l									
          AND	CSLL.t$line$l = cisli941.t$line$l
          AND CSLL.t$brty$l = 13
	
	LEFT JOIN baandb.tznsls401301 znsls401 
         ON cisli245.t$slso = znsls401.t$orno$c
        AND cisli245.t$pono = znsls401.t$pono$c
        AND znsls401.t$IDOR$c not in ('TD')  ---mudança aplicada devido a duplicidade de desconto incondicional. Edição da Ordem de Venda para TD

	LEFT JOIN baandb.ttdsls401301 tdsls401															
				 ON cisli245.t$slso=tdsls401.t$orno
				AND cisli245.t$pono=tdsls401.t$pono
				AND cisli245.t$sqnb=tdsls401.t$sqnb
	
  INNER JOIN baandb.ttcibd001301 tcibd001
          ON tcibd001.t$item=cisli941.t$item$l
         AND tcibd001.t$ctyp$l not in (2,4) --juros estabelecimento, frete e outras despesas
         
--WHERE cisli940.t$rcd_utc BETWEEN :DATA_INI AND :DATA_FIM

;
