-- 05-mai-2014, Fabio Ferreira, Correção timezone,
--								Campo ESTADO_PAGAMENTO alterado para 'aprovados',
--								Campo VALOR_TOTAL_ITEM alterado para  ( (Valor do Produto Unitário + Valor do Frete) - (valor desc incondicional)) * Quantidade
-- FAF.002 - Fabio Ferreira, 09-mai-2014, Fabio Ferreira, 	Retirado campo DESCONTO_CONDICIONAL
-- FAF.003 - Fabio Ferreira, 09-mai-2014, Fabio Ferreira, 	Incluido novos campos
-- FAF.004 - Fabio Ferreira, 13-mai-2014, Fabio Ferreira, 	Duplicando registros devido a problema de relacionamento na tabela znsls004
-- FAF.105 - Fabio Ferreira, 05-jun-2014, Fabio Ferreira, 	Campo vendedor deve ser NULL quando valor = 100
-- FAF.122 - Fabio Ferreira, 10-jun-2014, Fabio Ferreira, 	Correção campo VL_TOTAL_ITEM
-- FAF.123 - Fabio Ferreira, 10-jun-2014, Fabio Ferreira, 	Correção campo VL_ITEM
-- FAF.129 - Fabio Ferreira, 11-jun-2014, Fabio Ferreira, 	Status da ref,fiscal
-- FAF.147 - Fabio Ferreira, 17-jun-2014, Fabio Ferreira, 	Incluído campo CD produto com o código do produto da garantia estendida
-- FAF.164 - Fabio Ferreira, 23-jun-2014, Fabio Ferreira, 	Correção de duplicidade de registro devido ao rel. com a tabela znsls004
-- FAF.174 - Fabio Ferreira, 27-jun-2014, Fabio Ferreira, 	Correção relaconamento tabela znsls004
-- FAF.201 - Fabio Ferreira, 03-jul-2014, Fabio Ferreira, 	Inclusão do numero da linha da ordem para adicionar na chave e evitar duplicidade
--***************************************************************************************************************************************************************
SELECT DISTINCT
        (SELECT 
		CAST((FROM_TZ(CAST(TO_CHAR(Max(ttdsls451201.t$trdt), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE)
        FROM ttdsls451201
        WHERE ttdsls451201.t$orno=tdsls401.t$orno
        AND   ttdsls451201.t$pono=tdsls401.t$pono) DT_ATUALIZACAO,
		  201 CD_CIA,
          znsls401.t$uneg$c CD_UNIDADE_NEGOCIO,
          tdsls401.t$orno NR_ORDEM,
		  tdsls401.t$pono SQ_ORDEM,																						--#FAF.201.n
		  CAST((FROM_TZ(CAST(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_COMPRA,			
		  CAST((FROM_TZ(CAST(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_ENTREGA,
          CASE WHEN tdsls401.t$clyn=1 THEN 30
			WHEN tdsls401.t$term=1 THEN 25
			WHEN tdsls401.t$modi=1 THEN 35
			WHEN tdsls400.t$hdst=20 THEN CASE WHEN nvl((Select max(atv.t$xcsq) From ttdsls413201 atv
                                                  where atv.t$orno=tdsls401.t$orno and atv.t$pono=tdsls401.t$pono and atv.t$xcst>=15),99)=99 THEN 10 
										 ELSE 20 END
			ELSE tdsls400.t$hdst END CD_SITUACAO_PEDIDO,
          znsls400.t$idca$c CD_CANAL_VENDAS,
          ltrim(rtrim(tdsls401.t$item)) CD_ITEM,
          tdsls401.t$qoor QT_ITENS,
--          tdsls401.t$pric VL_ITEM,																					--#FAF.123.o
          tdsls401.t$pric*tdsls401.t$qoor VL_ITEM,																		--#FAF.123.n
--          0 VALOR_DESCONTO_CONDICIONAL,      -- **** DESCONSIDERAR - NÃO SERÁ USADO									--#FAF.002.o
          znsls401.t$vldi$c VL_DESCONTO_INCONDICIONAL,
          znsls401.t$vlfr$c VL_FRETE_CLIENTE,
          nvl((select sum(f.t$vlft$c) from tznfmd630201 f
          where f.t$pecl$c=znsls400.t$pecl$c),0) VL_FRETE_CIA,
          CASE WHEN znsls400.t$cven$c=100 THEN NULL ELSE znsls400.t$cven$c END CD_VENDEDOR,
          znsls400.t$idli$c NR_LISTA_CASAMENTO,
          'Aprovados' DS_STATUS_PAGAMENTO,        
          ' ' DT_PAGAMENTO,                -- **** DESCONSIDERAR - SOMENTE PGTO APROVADOS ESTÃO NO LN
          ' ' DS_UTM_PARCEIRO,                  -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
          ' ' DS_UTM_MIDIA,                     -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
          ' ' DS_UTM_CAMPANHA,                  -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
          znsls401.t$vlde$c VL_DESPESA_ACESSORIO,
          znsls400.t$vldf$c VL_JUROS,
--          (znsls401.t$vlun$c + znsls401.t$vlfr$c - znsls401.t$vldi$c)*znsls401.t$qtve$c VL_TOTAL_ITEM,				--#FAF.105.n	--#FAF.122.o
          (znsls401.t$vlun$c*znsls401.t$qtve$c) + (znsls401.t$vlfr$c - znsls401.t$vldi$c) VL_TOTAL_ITEM,				--#FAF.122.n
          (SELECT Count(lc.t$pono)
           FROM ttdsls401201 lc
           WHERE lc.t$orno=tdsls401.t$orno
           AND   lc.t$pono=tdsls401.t$pono
           AND   lc.t$clyn=1) QT_ITENS_CANCELADOS,
          tcemm030.t$euca CD_FILIAL,
	  tcemm124.t$grid CD_UNIDADE_EMPRESARIAL,
		  znsls401.t$tpcb$c CD_TIPO_COMBO,
      znsls401.t$pecl$c NR_PEDIDO,
      TO_CHAR(znsls401.T$ENTR$C) NR_ENTREGA,
	  znsls400.t$idco$c CD_CONTRATO_B2B,															--#FAF.003.sn
	  znsls400.t$idCP$c CD_CAMPANHA_B2B,
	  znsls004.t$orig$c CD_ORIGEM_PEDIDO,															--#FAF.003.en
	  (select min(cisli940.t$stat$l) 
	   from tcisli940201 cisli940, tcisli245201 cisli245
	   where cisli245.t$slso=tdsls401.t$orno
	   and cisli245.t$pono=tdsls401.t$pono
	   and cisli245.t$ortp=1
	   and cisli245.t$koor=3
	   and cisli940.t$fire$l=cisli245.t$fire$l) CD_SITUACAO_NF,										--#FAF.129.n
	  CASE WHEN znsls401.t$igar$c=0 THEN ltrim(rtrim(tdsls401.t$item))
	  ELSE TO_CHAR(znsls401.t$igar$c) END CD_PRODUTO												--#FAF.147.n
	   
FROM
        ttdsls401201 tdsls401,
--		LEFT JOIN tznsls004201 znsls004 ON znsls004.t$orno$c=tdsls401.t$orno,						--#FAF.004.o

        tznsls401201 znsls401
		
				LEFT JOIN tznsls004201 znsls004 													--#FAF.174.sn
										ON	znsls004.t$ncia$c=znsls401.t$ncia$c
										AND znsls004.t$uneg$c=znsls401.t$uneg$c
										AND znsls004.t$pecl$c=znsls401.t$pecl$c
										AND znsls004.t$sqpd$c=znsls401.t$sqpd$c
										AND znsls004.t$entr$c=znsls401.t$entr$c
										AND znsls004.t$sequ$c=znsls401.t$sequ$c										
										AND znsls004.t$orno$c=znsls401.t$orno$c  						
										AND znsls004.t$pono$c=znsls401.t$pono$c,					--#FAF.174.en						
		
        ttdsls400201 tdsls400,
        ttcemm124201 tcemm124,
		ttcemm030201 tcemm030,
        tznsls400201 znsls400
WHERE   znsls401.t$orno$c=tdsls401.t$orno
AND     znsls401.t$pono$c=tdsls401.t$pono
AND     tdsls400.t$orno=tdsls401.t$orno
AND     tcemm124.t$cwoc=tdsls400.t$cofc
AND 	tcemm030.t$eunt=tcemm124.t$grid
AND     znsls400.t$ncia$c=znsls401.t$ncia$c
AND     znsls400.t$uneg$c=znsls401.t$uneg$c
AND     znsls400.t$pecl$c=znsls401.t$pecl$c
AND     znsls400.t$sqpd$c=znsls401.t$sqpd$c
--AND     znsls004.T$ENTR$C=znsls401.T$ENTR$C															--#FAF.164.n	--#FAF.174.o
