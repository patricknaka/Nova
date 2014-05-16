SELECT  DISTINCT
        tdsls400.t$rcd_utc DT_ATUALIZACAO, --Alteração teste
        201 COMPANHIA,
        tdsls400.t$orno ORDEM,
        tdsls400.t$ofbp COD_CLIENTE,
        znsls400.t$dtin$c DATA_COMPRA,
        znsls400.t$dtin$c HORA_COMPRA, -- * CAMPO DATA-HORA
        znsls400.t$uneg$c COD_UNIDADE_NEGOCIO,
        sls401q.t$pecl$c NUM_PEDIDO,
		sls401q.t$entr$c NUM_ENTREGA,
		CONCAT(TRIM(sls401q.t$pecl$c), TRIM(to_char(sls401q.t$entr$c))) PEDIDO_ENTREGA, 
        znsls400.t$cven$c VENDEDOR,
        tcemm030.t$euca COD_FILIAL,
		tcemm112.t$grid UNID_EMPRESARIAL,
        sls401q.t$opfc$l NATUREZA_OPERA��O,
        ' ' SEQ_NATUREZA_OPERA��O,        -- *** NAO EXISTE NA PREVISAO DE IMPOSTOS
        tdsls400.t$ccur MOEDA,
        tdsls400.t$hdst SITUACAO_PEDIDO,
        (SELECT 
			CAST((FROM_TZ(CAST(TO_CHAR(Max(ttdsls450201.t$trdt), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE)
         FROM ttdsls450201
         WHERE ttdsls450201.t$orno=tdsls400.t$orno) DATA_SIT_PEDIDO,
        znsls400.t$vlfr$c VALOR_FRETE_CLIENTE,
        nvl((select sum(f.t$vlft$c) from tznfmd630201 f
             where f.T$PECL$C=znsls400.t$pecl$c),0) VALOR_FRETE_CIA,
        znsls400.t$idca$c COD_CANAL_VENDAS,
        --znsls402.t$vlju$c VALOR_JUROS,
        znsls004.t$orig$c COD_ORIGEM_PEDIDO,
        znsls400.t$ipor$c IP_CLIENTE,
        znsls400.t$vlme$c VALOR_PEDIDO,
        nvl((select sum(f.t$vlfc$c) from tznfmd630201 f
			where f.t$pecl$c=znsls400.t$pecl$c),0) VALOR_FRETE_TABELA,
        endfat.t$ccit COD_CIDADE_FATURA,
        endfat.t$ccty COD_PAIS_FATURA,
        endfat.t$cste COD_ESTADO_FAURA,
        endfat.t$pstc CEP_FATURA,
        tdsls400.t$stbp COD_CLIENTE_ENTREGA,
        endent.t$ccit COD_CIDADE_ENTREGA,
        endent.t$ccty COD_PAIS_ENTREGA,
        endent.t$cste COD_ESTADO_ENTREGA,
        endent.t$pstc CEP_ENTREGA,
        znsls400.t$idli$c NUM_LISTA_CASAMENTO,
        znsls400.t$idco$c NUM_CONTRATO_B2B,
        znsls400.t$idcp$c NUM_CAMPANHA_B2B,
        sls401q.t$pztr$c PRAZO_TRANSIT_TIME,
        sls401q.t$pzcd$c PRAZO_CD,
        ' ' NUM_NOTA_CONSOLIDADA,      -- *** AGUARDANDO DEFINICAO FUNCIONAL ****
        ' ' SERIE_NOTA_CONSOLIDADA,    -- *** AGUARDANDO DEFINICAO FUNCIONAL ****
        sls401q.t$pcga$c NUM_PEDIDO_GARANTIA,
        sls401q.t$dtep$c DATA_LIMITE_EXPED,
        znsls400.t$tped$c COD_TIPO_PEDIDO,
        (SELECT  DISTINCT znsls402.t$idmp$c
        FROM    tznsls402201 znsls402
        WHERE   znsls402.t$ncia$c=znsls400.t$ncia$c
        AND     znsls402.t$uneg$c=znsls400.t$uneg$c
        AND     znsls402.t$pecl$c=znsls400.t$pecl$c
        AND     znsls402.t$sqpd$c=znsls400.t$sqpd$c
        AND     znsls402.t$vlmr$c = (SELECT Max(znsls402b.t$vlmr$c)
                              FROM tznsls402201 znsls402b
                              WHERE   znsls402b.t$ncia$c=znsls402.t$ncia$c
                              AND     znsls402b.t$uneg$c=znsls402.t$uneg$c
                              AND     znsls402b.t$pecl$c=znsls402.t$pecl$c
                              AND     znsls402b.t$sqpd$c=znsls402.t$sqpd$c)) COD_MEIO_PAGAMENTO_PRINCIPAL,
        znsls400.t$peex$c NUM_PEDIDO_EXTERNO,
        sls401q.t$itpe$c COD_TIPO_ENTREGA,
        sls401q.t$tptr$c COD_TIPO_TRANSPORTE,
		(select tcmcs080.t$suno from ttcmcs080201 tcmcs080
		where tcmcs080.t$cfrw=tdsls400.t$cfrw) COD_TRANSPORTADORA,
        --tdsls400.t$cfrw COD_TRANSPORTADORA,
        sls401q.t$mgrt$c COD_MEGA_ROTA,
        ulttrc.poco STATUS_PEDIDO,
		CAST((FROM_TZ(CAST(TO_CHAR(tdsls400.t$odat, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DATA_STATUS_PEDIDO
FROM    ttdsls400201 tdsls400
        LEFT JOIN tznsls004201 znsls004 ON znsls004.t$orno$c=tdsls400.t$orno,
        tznsls400201 znsls400,
         (SELECT
          znsls401.t$ncia$c		    t$ncia$c,
          znsls401.t$uneg$c       t$uneg$c,
          znsls401.t$pecl$c       t$pecl$c,
          znsls401.t$sqpd$c       t$sqpd$c,
          znsls401.t$entr$c       t$entr$c,
          max(znsls401.t$pztr$c)  t$pztr$c,
          max(znsls401.t$pzcd$c)  t$pzcd$c,
          znsls401.t$pcga$c       t$pcga$c,
		  CAST((FROM_TZ(CAST(TO_CHAR(max(znsls401.t$dtep$c), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) t$dtep$c,
          znsls401.t$itpe$c       t$itpe$c,
          znsls401.t$mgrt$c       t$mgrt$c,
          znsls401.t$orno$c       t$orno,
          --znsls401.t$pono$c       t$pono$c,
          tcibd001.t$tptr$c       t$tptr$c,
          brmcs941.t$opfc$l       t$opfc$l
         FROM tznsls401201 znsls401,
              ttcibd001201 tcibd001,
              ttdsls401201 tdsls401
              LEFT JOIN tbrmcs941201 brmcs941 ON  brmcs941.t$txre$l=tdsls401.t$txre$l
              AND brmcs941.t$line$l=tdsls401.t$txli$l
         WHERE  tcibd001.t$item=tdsls401.t$item
         AND    znsls401.t$orno$c=tdsls401.t$orno
         AND    znsls401.t$pono$c=tdsls401.t$pono
         GROUP BY
          znsls401.t$ncia$c,
          znsls401.t$uneg$c,
          znsls401.t$pecl$c,
          znsls401.t$sqpd$c,
          znsls401.t$entr$c,
          znsls401.t$pcga$c,
          znsls401.t$itpe$c,
          znsls401.t$mgrt$c,
          znsls401.t$orno$c,
          tcibd001.t$tptr$c,
          brmcs941.t$opfc$l) sls401q,
        ttcemm112201 tcemm112,
		ttcemm030201 tcemm030,
        ttccom130201 endfat,
        ttccom130201 endent,
		( SELECT Max(tznsls410201.t$poco$c) poco,
                 tznsls410201.t$ncia$c ncia,
                 tznsls410201.t$uneg$c uneg,
                 tznsls410201.t$pecl$c pecl,
                 tznsls410201.t$sqpd$c sqpd,
				 CAST((FROM_TZ(CAST(TO_CHAR(Max(tznsls410201.t$dtoc$c), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
				  AT time zone sessiontimezone) AS DATE) dtoc
          FROM tznsls410201
          WHERE
          tznsls410201.t$dtoc$c = (SELECT Max(b.t$dtoc$c)
                                    FROM tznsls410201 b
                                    WHERE   b.t$ncia$c=tznsls410201.t$ncia$c
                                    AND     b.t$uneg$c=tznsls410201.t$uneg$c
                                    AND     b.t$pecl$c=tznsls410201.t$pecl$c
                                    AND     b.t$sqpd$c=tznsls410201.t$sqpd$c)
          GROUP BY --tznsls410201.t$poco$c,
                   tznsls410201.t$ncia$c,
                   tznsls410201.t$uneg$c,
                   tznsls410201.t$pecl$c,
                   tznsls410201.t$sqpd$c) ulttrc
WHERE   sls401q.t$orno=tdsls400.t$orno
AND     znsls400.t$ncia$c=sls401q.t$ncia$c
AND     znsls400.t$uneg$c=sls401q.t$uneg$c
AND     znsls400.t$pecl$c=sls401q.t$pecl$c
AND     znsls400.t$sqpd$c=sls401q.t$sqpd$c
AND     tdsls400.t$cwar=tcemm112.t$waid
AND		tcemm030.t$eunt=tcemm112.t$grid
AND     endfat.t$cadr=tdsls400.t$itad
AND     endent.t$cadr=tdsls400.t$stad
AND     ulttrc.ncia=sls401q.t$ncia$c
AND     ulttrc.uneg=sls401q.t$uneg$c
AND     ulttrc.pecl=sls401q.t$pecl$c
AND     ulttrc.sqpd=sls401q.t$sqpd$c
ORDER BY tdsls400.t$orno
