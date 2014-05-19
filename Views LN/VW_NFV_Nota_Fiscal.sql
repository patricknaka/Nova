SELECT
    201 COMPANHIA,
    (SELECT tcemm030.t$euca FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm030.t$eunt=tcemm124.t$grid
    AND tcemm124.t$loco=201
    AND rownum=1) FILIAL,
   (SELECT tcemm124.t$grid FROM ttcemm124201 tcemm124
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm124.t$loco=201
    AND rownum=1) UNID_EMPRESARIAL,
		cisli940.t$docn$l NUM_NOTA_FISCAL,
		cisli940.t$seri$l SER_NOTA_FISCAL,
		cisli940.t$ccfo$l COD_NATUREZA_OPERACAO_NOTA,
		cisli940.t$opor$l SEQUENCIA_NATUREZA_OPERACAO,
		cisli940.t$fdty$l COD_TIPO_NOTA,
		
		CAST((FROM_TZ(CAST(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_EMISSAO_NOTA,
		CAST((FROM_TZ(CAST(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) HORA_EMISSAO_NOTA,
		cisli940.t$itbp$l COD_CLIENTE_FATURA,
		cisli940.t$stbp$l COD_CLIENTE_ENTREGA,
		entr.t$pecl$c NUM_PEDIDO,
		entr.t$entr$c NUM_ENTREGA,
		CONCAT(TRIM(entr.t$pecl$c), TRIM(to_char(entr.t$entr$c))) PEDIDO_ENTREGA,
		entr.t$orno$c ORDEM,
		(SELECT cisli942.t$amnt$l FROM tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=1) VALOR_ICMS,
		(SELECT cisli942.t$amnt$l FROM tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=2) VALOR_ICMS_ST,
		(SELECT cisli942.t$amnt$l FROM tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=3) VALOR_IPI,
		cisli940.t$gamt$l VALOR_PRODUTO,
		cisli940.t$fght$l VALOR_FRETE,
		cisli940.t$insr$l VALOR_SEGURO,
		cisli940.t$gexp$l VALOR_DESPESA,
		(SELECT cisli942.t$amnt$l FROM tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=16) VALOR_IMPOSTO_IMPORTACAO,
		(SELECT sum(cisli941.t$ldam$l) FROM tcisli941201 cisli941
		WHERE cisli941.t$fire$l=cisli940.t$fire$l) VALOR_DESCONTO,
		cisli940.t$amnt$l VALOR_TOTAL_NOTA,
        CASE WHEN cisli940.t$fdty$l=15 then
          (select distinct a.t$docn$l from tcisli940201 a, tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l)
          else 0
          end  NUMERO_NF_FATURA,
       CASE WHEN cisli940.t$fdty$l=15 then
          (select distinct a.t$seri$l from tcisli940201 a, tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l)
          else ' '
          end  SERIE_NF_FATURA, 
        CASE WHEN cisli940.t$fdty$l=16 then
          (select distinct a.t$docn$l from tcisli940201 a, tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l)
          else 0
          end NUMERO_NF_REMESSA,
        CASE WHEN cisli940.t$fdty$l=16 then
          (select distinct a.t$seri$l from tcisli940201 a, tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l)
          else ' '
          end SERIE_NF_REMESSA,
		CAST((FROM_TZ(CAST(TO_CHAR(Greatest(cisli940.t$datg$l, cisli940.t$date$l, cisli940.t$dats$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_SITUACAO_NOTA,
		cisli940.t$stat$l SITUACAO_NOTA,
		cisli940.t$amfi$l VALOR_DESPESA_FINANCEIRA,
		(SELECT cisli942.t$amnt$l FROM tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=5) VALOR_PIS,
		(SELECT cisli942.t$amnt$l FROM tcisli942201 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=6) VALOR_COFINS,
		0 VALOR_CSLL,								-- *** PEDENTE DE DEFINI플O FUNCIONAL ****
		(SELECT SUM(znsls401.t$vldi$c) 
		FROM tznsls401201 znsls401,
			 tcisli245201 cisli245
		WHERE cisli245.t$slso=znsls401.t$orno$c
		AND   cisli245.t$pono=znsls401.t$pono$c
		AND   cisli245.t$fire$l=cisli940.t$fire$l) VALOR_DESCONTO_INCONDICIONAL,
		cisli940.t$cchr$l VALOR_DESPESA_ADUANEIRO,
		0 VALOR_ADICIONAL_IMPORTACAO,					-- *** PENDENTE DE DEFINI플O FUNCIONAL ***
		0 VALOR_PIS_IMPORTACAO,							-- *** PENDENTE DE DEFINI플O FUNCIONAL ***
		0 VALOR_COFINS_IMPORTACAO,						-- *** PENDENTE DE DEFINI플O FUNCIONAL ***
		0 VALOR_CIF_IMPORTACAO,							-- *** PENDENTE DE DEFINI플O FUNCIONAL ***
		CAST((FROM_TZ(CAST(TO_CHAR(Greatest(cisli940.t$datg$l, cisli940.t$date$l, cisli940.t$dats$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO_NOTA_FISCAL
FROM
		tcisli940201 cisli940
		LEFT JOIN (SELECT DISTINCT znsls401.t$entr$c, cisli245.t$fire$l, znsls401.t$pecl$c , znsls401.t$orno$c 
		FROM tznsls401201 znsls401 ,
         tcisli245201 cisli245
		WHERE cisli245.t$slso=znsls401.t$orno$c
		AND   cisli245.t$pono=znsls401.t$pono$c) entr ON entr.t$fire$l=cisli940.t$fire$l,
    ttcemm124201 tcemm124,
    ttcemm030201 tcemm030
WHERE tcemm124.t$loco=201
AND   tcemm124.t$dtyp=1
AND   tcemm124.t$cwoc=cisli940.t$cofc$l
AND   tcemm030.t$eunt=tcemm124.t$grid
