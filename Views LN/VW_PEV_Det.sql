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
-- MAR.306 - Marcia A. R. Torres, 28-ago-2014, 			Inclusao do TIPO_ORDEM_VENDA.
-- #FAF.276 - 28-aug-2014, Fabio Ferreira, 	Correção valor da linha
-- #FAF.313 - 01-sep-2014, Fabio Ferreira, 	Flag cancelado
-- #FAF.314 - 04-sep-2014, Fabio Ferreira, 	Correção valor do juros
--***************************************************************************************************************************************************************
SELECT DISTINCT
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(greatest(tdsls400.t$rcd_utc, tdsls401.t$rcd_utc), 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ATUALIZACAO,
		  znsls400.t$ncia$c CD_CIA,
          znsls401.t$uneg$c CD_UNIDADE_NEGOCIO,
          tdsls401.t$orno NR_ORDEM,
		  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) DT_COMPRA,			
		  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) DT_ENTREGA,
          CASE WHEN tdsls401.t$clyn=1 THEN 35 -- cancelado
			WHEN tdsls401.t$term=1 THEN 30	  -- finalizado
			WHEN tdsls401.t$modi=1 THEN 25	  -- modificado
			WHEN tdsls400.t$hdst=20 THEN	  --
				CASE WHEN nvl((Select max(atv.t$xcsq) 
					From baandb.ttdsls413201 atv 
					where atv.t$orno=tdsls401.t$orno 
					and   atv.t$pono=tdsls401.t$pono 
					and   atv.t$xcst>=15),99)=99 THEN 10 ELSE 20 END
			ELSE tdsls400.t$hdst END CD_SITUACAO_PEDIDO,
          znsls400.t$idca$c CD_CANAL_VENDA,
          ltrim(rtrim(tdsls401.t$item)) CD_ITEM,
          tdsls401.t$qoor QT_ITENS,
          tdsls401.t$pric*tdsls401.t$qoor VL_ITEM,																		--#FAF.123.n
          znsls401.t$vldi$c VL_DESCONTO_INCONDICIONAL,
          znsls401.t$vlfr$c VL_FRETE_CLIENTE,
          nvl((select sum(f.t$vlft$c) from baandb.tznfmd630201 f
          where f.t$pecl$c=znsls400.t$pecl$c),0) VL_FRETE_CIA,
          CASE WHEN znsls400.t$cven$c=100 THEN NULL ELSE znsls400.t$cven$c END CD_VENDEDOR,
          znsls400.t$idli$c NR_LISTA_CASAMENTO,
          'Aprovados' DS_STATUS_PAGAMENTO,        
          ' ' DT_PAGAMENTO,                -- **** DESCONSIDERAR - SOMENTE PGTO APROVADOS ESTÃO NO LN
          ' ' DS_UTM_PARCEIRO,                  -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
          ' ' DS_UTM_MIDIA,                     -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
          ' ' DS_UTM_CAMPANHA,                  -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
          znsls401.t$vlde$c VL_DESPESA_ACESSORIO,
          -- znsls400.t$vldf$c VL_JUROS,																					--#FAF.317.o
		  cast((((znsls401.t$vlun$c*znsls401.t$qtve$c)+znsls401.t$vlfr$c-znsls401.t$vldi$c+znsls401.t$vlde$c)
				/sls401p.VL_PGTO_PED)*znsls402.t$vlju$c as numeric(12,2)) VL_JUROS,															--#FAF.317.n
		  -- nvl((select a.t$tamt$l from baandb.tbrmcs941201 a
			  -- where a.t$txre$l=tdsls401.t$txre$l
			  -- and a.t$line$l=tdsls401.t$txli$l), tdsls401.t$oamt)	VL_TOTAL_ITEM,										--#FAF.311.n
--          abs((znsls401.t$vlun$c*znsls401.t$qtve$c) + (znsls401.t$vlfr$c - znsls401.t$vldi$c)) VL_TOTAL_ITEM,				--#FAF.122.n
		  cast((znsls401.t$vlun$c*znsls401.t$qtve$c)+znsls401.t$vlfr$c-znsls401.t$vldi$c+znsls401.t$vlde$c+
		  (((znsls401.t$vlun$c*znsls401.t$qtve$c)+znsls401.t$vlfr$c-znsls401.t$vldi$c+znsls401.t$vlde$c)
				/sls401p.VL_PGTO_PED)*znsls402.t$vlju$c as numeric(18,2)) VL_TOTAL_ITEM,														--#FAF.319.n
          (SELECT Count(lc.t$pono)
           FROM  baandb.ttdsls401201 lc
           WHERE lc.t$orno=tdsls401.t$orno
           AND   lc.t$pono=tdsls401.t$pono
           AND   lc.t$clyn=1) QT_ITENS_CANCELADOS,
          --tcemm030.t$euca CD_FILIAL,
          case when tcemm030.t$euca = ' ' then substr(tcemm124.t$grid,-2,2) else tcemm030.t$euca end as CD_FILIAL,
	  tcemm124.t$grid CD_UNIDADE_EMPRESARIAL,
		  znsls401.t$tpcb$c CD_TIPO_COMBO,
      znsls401.t$pecl$c NR_PEDIDO,
      TO_CHAR(znsls401.T$ENTR$C) NR_ENTREGA,
	  znsls400.t$idco$c CD_CONTRATO_B2B,															--#FAF.003.sn
	  znsls400.t$idCP$c CD_CAMPANHA_B2B,
	  znsls004.t$orig$c CD_ORIGEM_PEDIDO,															--#FAF.003.en
	  (select min(cisli940.t$stat$l) 
	   from baandb.tcisli940201 cisli940, baandb.tcisli245201 cisli245
	   where cisli245.t$slso=tdsls401.t$orno
	   and cisli245.t$pono=tdsls401.t$pono
	   and cisli245.t$ortp=1
	   and cisli245.t$koor=3
	   and cisli940.t$fire$l=cisli245.t$fire$l) CD_SITUACAO_NF,										--#FAF.129.n
	  CASE WHEN znsls401.t$igar$c=0 THEN ltrim(rtrim(tdsls401.t$item))
	  ELSE TO_CHAR(znsls401.t$igar$c) END CD_PRODUTO,												--#FAF.147.n
	CAST(tdsls401.t$pono as varchar(10)) SQ_ORDEM,													--#FAF.201.n
	   tdsls400.t$sotp  CD_TIPO_ORDEM_VENDA,                                 						--#MAR.306.n
	case when znsls401.t$qtve$c<0 then 2 else 1 end IN_CANCELADO									--#FAF.313.n
  
FROM
        baandb.ttdsls401201 tdsls401,
        baandb.tznsls401201 znsls401
		
				LEFT JOIN baandb.tznsls004201 znsls004 													--#FAF.174.sn
										ON	znsls004.t$ncia$c=znsls401.t$ncia$c
										AND znsls004.t$uneg$c=znsls401.t$uneg$c
										AND znsls004.t$pecl$c=znsls401.t$pecl$c
										AND znsls004.t$sqpd$c=znsls401.t$sqpd$c
										AND znsls004.t$entr$c=znsls401.t$entr$c
										AND znsls004.t$sequ$c=znsls401.t$sequ$c										
										AND znsls004.t$orno$c=znsls401.t$orno$c  						
										AND znsls004.t$pono$c=znsls401.t$pono$c,					--#FAF.174.en						
		
        baandb.ttdsls400201 tdsls400,
        baandb.ttcemm124201 tcemm124,
        baandb.ttcemm030201 tcemm030,
        baandb.tznsls400201 znsls400,
		(select distinct 																									--#FAF.317.sn
			znsls401t.t$ncia$c      	t$ncia$c,
			znsls401t.t$uneg$c       t$uneg$c,
			znsls401t.t$pecl$c       t$pecl$c,
			znsls401t.t$sqpd$c       t$sqpd$c,
			sum((znsls401t.t$vlun$c*znsls401t.t$qtve$c)+znsls401t.t$vlfr$c-znsls401t.t$vldi$c+znsls401t.t$vlde$c) VL_PGTO_PED		
		from baandb.tznsls401201 znsls401t
		group by
			znsls401t.t$ncia$c,																				
			znsls401t.t$uneg$c,
			znsls401t.t$pecl$c,
			znsls401t.t$sqpd$c) sls401p,																							
		(select	sum(znsls402t.t$vlju$c) t$vlju$c,
				znsls402t.t$ncia$c,
				znsls402t.t$uneg$c,
				znsls402t.t$pecl$c,
                znsls402t.t$sqpd$c
		from baandb.tznsls402201 znsls402t
		group by
				znsls402t.t$ncia$c,
				znsls402t.t$uneg$c,
				znsls402t.t$pecl$c,
                znsls402t.t$sqpd$c) znsls402																				--#FAF.317.en
		
WHERE   znsls401.t$orno$c=tdsls401.t$orno
AND     znsls401.t$pono$c=tdsls401.t$pono
AND     tdsls400.t$orno=tdsls401.t$orno
AND     tcemm124.t$cwoc=tdsls400.t$cofc
AND 	tcemm030.t$eunt=tcemm124.t$grid
AND     znsls400.t$ncia$c=znsls401.t$ncia$c
AND     znsls400.t$uneg$c=znsls401.t$uneg$c
AND     znsls400.t$pecl$c=znsls401.t$pecl$c
AND     znsls400.t$sqpd$c=znsls401.t$sqpd$c
and	   sls401p.t$ncia$c=znsls401.t$ncia$c																					--#FAF.317.sn
and    sls401p.t$uneg$c=znsls401.t$uneg$c
and    sls401p.t$pecl$c=znsls401.t$pecl$c
and    sls401p.t$sqpd$c=znsls401.t$sqpd$c																					
and	   znsls402.t$ncia$c=znsls401.t$ncia$c
and    znsls402.t$uneg$c=znsls401.t$uneg$c
and    znsls402.t$pecl$c=znsls401.t$pecl$c
and    znsls402.t$sqpd$c=znsls401.t$sqpd$c
