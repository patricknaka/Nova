-- 05-mai-2014, Fabio Ferreira, Retirados os campos COD_PAIS_FATURA, COD_ESTADO_FATURA, COD_CEP_FATURA, COD_PAIS_ENTREGA, COD_ESTADO_ENTREGA, COD_CEP_ENTREGA,
--								Inclusão dos campos VALOR_TOTAL_MERCADOR, CPF/CNPJ CLIENTE FATURA, TIPO CLENTE
-- 06-mai-2014, Fabio Ferreira, Correcção timezone ULTIMA_ATUALIZACAO, DATA_FATURA, DT_ENTREGA
--								Correção formatação campo PEDIDO_ENTREGA;
--								Correção informação da quantidade de volumes
-- 07-mai-2014, Fabio Ferreira, Incluído campo COD_CIDADE_ENTREGA (Excluido indevidamente)
--								Corrigido campo VALOR_CMV
-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Retirado campo PEDIDO_ENTREGA;
-- #FAF.008 - 17-mai-2014, Fabio Ferreira, 	Incluida condição para evitar divisão por zero
--****************************************************************************************************************************************************************
SELECT  CAST((FROM_TZ(CAST(TO_CHAR(Greatest(cisli940.t$datg$l, cisli940.t$date$l, cisli940.t$dats$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) ULTIMA_ATUALIZACAO,
        cisli940.t$sfcp$l CODIGO_CIA,
		(SELECT tcemm030.t$euca FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
		WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
		AND tcemm030.t$eunt=tcemm124.t$grid
		AND tcemm124.t$loco=201
		AND rownum=1) CODIGO_FILIAL,
		(SELECT tcemm124.t$grid FROM ttcemm124201 tcemm124
		WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
		AND tcemm124.t$loco=201
		AND rownum=1) UNID_EMPRESARIAL,	
        cisli940.t$docn$l NUMERO_NF,
        cisli940.t$seri$l SERIE_NF,
        cisli940.t$ccfo$l COD_NATUREZA_OPERACAO,
        cisli940.t$opor$l SEQ_NATUREZA_OPERACAO,
		CAST((FROM_TZ(CAST(TO_CHAR(cisli940.t$datg$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DATA_FATURA,
        cisli940.t$itbp$l COD_CLIENTE_FATURA,
        cisli940.t$stbp$l COD_CLIENTE_ENTREGA ,
        znsls401.t$sequ$c NUM_SEQ_ENTREGA,
        znsls401.t$pecl$c NUM_PEDIDO,
        znsls401.t$entr$c NUM_ENTREGA,
--        CONCAT(TRIM(znsls401.t$pecl$c), TRIM(to_char(znsls401.t$entr$c))) PEDIDO_ENTREGA,						#FAF.007.o
		znsls401.t$orno$c ORDEM,
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
        ' ' NUMERO_NF_CONSOLIDADA,       -- *** AGUARDANDO DEFINIÇAO FUNCIONAL
        ' ' SERIE_NF_CONSOLIDADA,        -- *** AGUARDANDO DEFINIÇAO FUNCIONAL
        cisli940.t$stat$l STATUS_NFE,
        (Select 
		 CAST((FROM_TZ(CAST(TO_CHAR(max(brnfe020.t$date$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE)
		 FROM tbrnfe020201 brnfe020
		Where brnfe020.t$refi$l=cisli940.t$fire$l AND brnfe020.t$ncmp$l=201) DATA_HR_STATUS,
        cisli940.t$fdty$l COD_TIPO_NF,
        ltrim(rtrim(cisli941.t$item$l)) COD_ITEM,
        cisli941.t$dqua$l QTD_FATURADA,
        Nvl((SELECT cisli943.t$amnt$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941.t$fire$l
             AND    cisli943.t$line$l=cisli941.t$line$l
             AND    cisli943.t$brty$l=1),0) VALOR_ICMS,
        Nvl((SELECT cisli943.t$amnt$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941.t$fire$l
             AND    cisli943.t$line$l=cisli941.t$line$l
             AND    cisli943.t$brty$l=2),0) VALOR_ICMS_ST,
        cisli941.t$gamt$l VALOR_PRODUTO,
        znsls401.t$vlfr$c VALOR_FRETE,
        nvl((select sum(f.t$vlfc$c) from tznfmd630201 f
			 where f.t$fire$c=cisli940.t$fire$l),0) * (cisli941.t$gamt$l/nvl((select sum(cisli941b.t$gamt$l) 
														 from tcisli941201 cisli941b, ttcibd001201 tcibd001b
														 where cisli941b.t$fire$l=cisli941.t$fire$l
														 and   cisli941b.t$line$l=cisli941.t$line$l
                             and   tcibd001b.T$ITEM=cisli941b.t$item$l
                             and   cisli941b.t$gamt$l!=0                                                --#FAF.008.n                              
														 and   tcibd001b.t$kitm<3),1)) VALOR_FRETE_CIA,            
        cisli941.t$gexp$l VALOR_DESPESA,
        cisli941.t$ldam$l VALOR_DESCONTO,
        cisli941.t$iprt$l VALOR_TOTAL_ITEM,
        cisli941.t$AMFI$l VALOR_DESPESA_FINANDEIRA,
        Nvl((SELECT cisli943.t$amnt$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941.t$fire$l
             AND    cisli943.t$line$l=cisli941.t$line$l
             AND    cisli943.t$brty$l=5),0) VALOR_PIS,
        0 VALOR_ICMS_PRODUTO,         -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        0 VALOR_ICMS_FRETE,           -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        0 VALOR_ICMS_OUTROS,          -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        Nvl((SELECT cisli943.t$amnt$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941.t$fire$l
             AND    cisli943.t$line$l=cisli941.t$line$l
             AND    cisli943.t$brty$l=6),0) VALOR_COFINS,
        0 VALOR_COFINS_PRODUTO,         -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        0 VALOR_COFINS_FRETE,           -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        0 VALOR_COFINS_OUTROS,          -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        0 VALOR_PIS_PRODUTO,            -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        0 VALOR_PIS_FRETE,              -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        0 VALOR_PIS_OUTROS,             -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        0 VALOR_CSLl,                   -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        0 VALOR_CSLl_PRODUTO,           -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        0 VALOR_CSLl_FRETE,             -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        0 VALOR_CSLl_OUTROS,            -- ***  AGUARDANDO DEFINIÇÃO FUNCIONAL ****
        cisli941.t$tldm$l VALOR_DESCONTO_INCONDICIONAL,
		CAST((FROM_TZ(CAST(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DATA_PEDIDO,
        znsls400.t$idca$c COD_CANAL,
        endfat.t$ccit COD_CIDADE_FATURA,
        --endfat.t$ccty COD_PAIS_FATURA,
        --endfat.t$cste COD_ESTADO_FATURA,
        --endfat.t$pstc COD_CEP_FATURA,
        endent.t$ccit COD_CIDADE_ENTREGA,
        --endent.t$ccty COD_PAIS_ENTREGA,
        --endent.t$cste COD_ESTADO_ENTREGA,
        --endent.t$pstc COD_CEP_ENTREGA,
        nvl((select sum(b.t$mauc$1) from twhina114201 a, twhina113201 b 
			where b.t$item=A.T$ITEM
			and   b.T$CWAR=a.t$cwar
			and   b.T$TRDT=A.T$TRDT
			and   b.t$seqn=A.T$SEQN
			and   b.T$INWP=A.T$INWP
			and   a.t$orno=tdsls401.t$orno
			and	  a.t$pono=tdsls401.t$pono),0) VALOR_CMV,
        znsls401.t$uneg$c COD_UNID_NEGOCIO,
        ' ' COD_MODULO_GERENCIAL,        -- *** AGUARDANDO DUVIDAS
        cisli941.t$ccfo$l NATUREZA_OPR_ITEM,
        cisli941.t$opor$l SEQ_NATUREZA_OPR_ITEM,
        znsls400.t$cven$c COD_VENDEDOR,
        Nvl((SELECT cisli943.t$base$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941.t$fire$l
             AND    cisli943.t$line$l=cisli941.t$line$l
             AND    cisli943.t$brty$l=1),0) VALOR_BASE_ICMS,
        Nvl((SELECT cisli943.t$base$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941.t$fire$l
             AND    cisli943.t$line$l=cisli941.t$line$l
             AND    cisli943.t$brty$l=3),0) VALOR_BASE_IPI,
        cisli940.t$cfrw$l COD_TRANSPORTADOR,
		CAST((FROM_TZ(CAST(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_ENTREGA,
        (Select sum(znfmd630.t$qvol$c) From tznfmd630201 znfmd630 WHERE znfmd630.t$fire$c=cisli941.t$fire$l) QTD_VOLUMES,
        cisli940.t$gwgt$l PESO_BRUTO,
        cisli940.t$nwgt$l PESO_LIQ,
        znsls401.t$itpe$c TIPO_ENTREGA,
        tcibd001.t$tptr$c TIPO_TRANSPORTE,
        znsls400.t$idli$c NUM_LISTA_CASAMENTO,
		(select e.t$fovn$l from ttccom130201 e where e.t$cadr=cisli940.t$stoa$l) CNPJ_CPF_ENTREGA,
		(select e.t$ftyp$l from ttccom130201 e where e.t$cadr=cisli940.t$stoa$l) TIPO_CLIENTE_ENTREGA,
		(select e.t$fovn$l from ttccom130201 e where e.t$cadr=cisli940.t$itoa$l) CNPJ_CPF_FATURA,
		(select e.t$ftyp$l from ttccom130201 e where e.t$cadr=cisli940.t$itoa$l) TIPO_CLIENTE_FATURA
FROM    tcisli940201 cisli940,
        tcisli941201 cisli941,
        
        tcisli245201 cisli245,
        ttdsls401201 tdsls401,
        tznsls401201 znsls401,
        tznsls400201 znsls400,
        ttccom130201 endfat,
        ttccom130201 endent,
        ttcibd001201 tcibd001
WHERE   cisli941.t$fire$l=cisli940.t$fire$l
AND     cisli245.t$fire$l=cisli941.t$fire$l
AND     cisli245.t$line$l=cisli941.t$line$l
AND     tdsls401.t$orno = cisli245.t$slso
AND     tdsls401.t$pono = cisli245.t$pono
AND     znsls401.t$orno$c=tdsls401.t$orno
AND     znsls401.t$pono$c=tdsls401.t$pono
AND     znsls400.t$ncia$c=znsls401.t$ncia$c
AND     znsls400.t$uneg$c=znsls401.t$uneg$c
AND     znsls400.t$pecl$c=znsls401.t$pecl$c
AND     znsls400.t$sqpd$c=znsls401.t$sqpd$c
AND     endfat.t$cadr=cisli940.t$itoa$l
AND     endent.t$cadr=cisli940.t$stoa$l
AND     tcibd001.t$item=cisli941.t$item$l