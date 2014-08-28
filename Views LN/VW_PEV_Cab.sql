-- 05-mai-2014, Fabio Ferreira, Correções de timezone de todos os campos Data/hora
-- #FAF.006 - 15-mai-2014, Fabio Ferreira, 	Inclusão do campo Nota e Serie consolidada
-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Retirado campo Pedido_Entrega
-- #FAF.028 - 17-mai-2014, Fabio Ferreira, 	Correção registros duplicados
-- #FAF.046 - 23-mai-2014, Fabio Ferreira, 	Conversão do campo NUM_ENTREGA para String
-- #FAF.104 - 04-jun-2014, Fabio Ferreira, 	Correção da data do status
-- #FAF.143 - 16-jun-2014, Fabio Ferreira, 	Correções
-- #FAF.165 - 23-jun-2014, Fabio Ferreira, 	Tipo de entrega duplicado
-- #FAF.174 - 23-jun-2014, Fabio Ferreira, 	Correções de duplicidade
-- #FAF.177 - 26-jun-2014, Fabio Ferreira, 	Correções de duplicidade
-- #MAR.265 - 07-ago-2014, Marcia A. R. Torres, Correção na DT_ATUALIZACAO
-- #FAF.276 - 11-aug-2014, Fabio Ferreira, 	Correção
-- #MAR.306 - 28-ago-2014, Marcia A. R. Torres, Inclusao do TIPO_ORDEM_VENDA.
--***************************************************************************************************************************************************************
SELECT  DISTINCT
         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(greatest(tdsls400.t$rcd_utc, ulttrc.dtoc), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO,                                                                 --#MAR.265.en
        201 CD_CIA,
        tdsls400.t$orno NR_ORDEM,
        tdsls400.t$ofbp CD_CLIENTE,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) DT_COMPRA,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) HR_COMPRA, -- * CAMPO DATA-HORA
        znsls400.t$uneg$c CD_UNIDADE_NEGOCIO,
        sls401q.t$pecl$c NR_PEDIDO_LOJA,
        TO_CHAR(sls401q.t$entr$c) NR_ENTREGA,																			--#FAF.046.n
        znsls400.t$cven$c CD_VENDEDOR,
        tcemm030.t$euca CD_FILIAL,
        sls401q.t$opfc$l CD_NATUREZA_OPERACAO,
        ' ' SQ_NATUREZA_OPERACAO,        -- *** NAO EXISTE NA PREVISAO DE IMPOSTOS
        tdsls400.t$ccur CD_MOEDA,
        tdsls400.t$hdst CD_SITUACAO_PEDIDO,
        (SELECT 
			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(ttdsls450201.t$trdt), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)
         FROM baandb.ttdsls450201
         WHERE ttdsls450201.t$orno=tdsls400.t$orno) DT_SITUACAO_PEDIDO,
        abs(znsls400.t$vlfr$c) VL_FRETE_CLIENTE,
        abs(nvl((select sum(f.t$vlft$c) from baandb.tznfmd630201 f
             where f.T$PECL$C=znsls400.t$pecl$c),0)) VL_FRETE_CIA,
        znsls400.t$idca$c CD_CANAL_VENDAS,
        znsls004.t$orig$c CD_ORIGEM_PEDIDO,
        znsls400.t$ipor$c NR_IP_CLIENTE,
        abs(znsls400.t$vlme$c) VL_PEDIDO,
        nvl((select sum(f.t$vlfc$c) from baandb.tznfmd630201 f
			where f.t$pecl$c=znsls400.t$pecl$c),0) VL_FRETE_TABELA,
        endfat.t$ccit CD_CIDADE_FATURA,
        endfat.t$ccty CD_PAIS_FATURA,
        endfat.t$cste CD_ESTADO_FATURA,
        endfat.t$pstc CD_CEP_FATURA,
        tdsls400.t$stbp CD_CLIENTE_ENTREGA,
        endent.t$ccit CD_CIDADE_ENTREGA,
        endent.t$ccty CD_PAIS_ENTREGA,
        endent.t$cste CD_ESTADO_ENTREGA,
        endent.t$pstc CD_CEP_ENTREGA,
        znsls400.t$idli$c NR_LISTA_CASAMENTO,
        znsls400.t$idco$c NR_CONTRATO_B2B,
        znsls400.t$idcp$c NR_CAMPANHA_B2B,
        sls401q.t$pztr$c QT_PRAZO_TRANSIT_TIME,
        sls401q.t$pzcd$c QT_PRAZO_CD,
        CASE WHEN tdsls094.t$bill$c!=3 THEN consold.NOTA ELSE 0 END NR_NF_CONSOLIDADA,						--#FAF.006.n      
        CASE WHEN tdsls094.t$bill$c!=3 THEN consold.SERIE ELSE ' ' END NR_SERIE_NF_CONSOLIDADA,					--#FAF.006.n
        sls401q.t$pcga$c NR_PEDIDO_GARANTIA,
        sls401q.t$dtep$c DT_LIMITE_EXPED,
        znsls400.t$tped$c CD_TIPO_PEDIDO,
        (SELECT  DISTINCT znsls402.t$idmp$c
        FROM    baandb.tznsls402201 znsls402
        WHERE   znsls402.t$ncia$c=znsls400.t$ncia$c
        AND     znsls402.t$uneg$c=znsls400.t$uneg$c
        AND     znsls402.t$pecl$c=znsls400.t$pecl$c
        AND     znsls402.t$sqpd$c=znsls400.t$sqpd$c
		AND     rownum=1																				
        AND     znsls402.t$vlmr$c = (SELECT Max(znsls402b.t$vlmr$c)
                              FROM    baandb.tznsls402201 znsls402b
                              WHERE   znsls402b.t$ncia$c=znsls402.t$ncia$c
                              AND     znsls402b.t$uneg$c=znsls402.t$uneg$c
                              AND     znsls402b.t$pecl$c=znsls402.t$pecl$c
                              AND     znsls402b.t$sqpd$c=znsls402.t$sqpd$c)) CD_MEIO_PAGAMENTO_PRINCIPAL,
        znsls400.t$peex$c NR_PEDIDO_EXTERNO,
        sls401q.t$itpe$c CD_TIPO_ENTREGA,
        sls401q.t$tptr$c CD_TIPO_TRANSPORTE,
		(select tcmcs080.t$suno from baandb.ttcmcs080201 tcmcs080
		where tcmcs080.t$cfrw=tdsls400.t$cfrw) CD_TRANSPORTADORA,
        sls401q.t$mgrt$c CD_MEGA_ROTA,
        ulttrc.poco CD_STATUS,
        ulttrc.dtoc DT_STATUS_PEDIDO,
	tcemm124.t$grid CD_UNIDADE_EMPRESARIAL,
	sls401q.t$idor$c CD_TIPO_SITE,																				--#FAF.143.n
  tdsls400.t$sotp  CD_TIPO_ORDEM_VENDA                                 --#MAR.306.n
FROM    baandb.ttdsls400201 tdsls400
		LEFT JOIN (	select DISTINCT c245.T$SLSO, c940.T$DOCN$L NOTA, c940.t$seri$l SERIE 						--#FAF.006.sn
					from baandb.tcisli245201 c245, baandb.tcisli941201 c941, baandb.tcisli940201 c940
					where c941.t$fire$l=c245.T$FIRE$L
					and c940.t$fire$l=c941.T$REFR$L) consold ON consold.T$SLSO=tdsls400.t$orno,					--#FAF.006.en
          baandb.tznsls400201 znsls400,
         (SELECT
          znsls401.t$ncia$c		    t$ncia$c,
          znsls401.t$uneg$c       t$uneg$c,
          znsls401.t$pecl$c       t$pecl$c,
          znsls401.t$sqpd$c       t$sqpd$c,
          znsls401.t$entr$c       t$entr$c,
          max(znsls401.t$pztr$c)  t$pztr$c,
          max(znsls401.t$pzcd$c)  t$pzcd$c,
          max(znsls401.t$pcga$c)       t$pcga$c,																	--#FAF.177.n
		  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(znsls401.t$dtep$c), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE) t$dtep$c,
          max(znsls401.t$itpe$c)       t$itpe$c,
          max(znsls401.t$mgrt$c)       t$mgrt$c,																	--#FAF.177.n
          znsls401.t$orno$c       t$orno,
          max(tcibd001.t$tptr$c)       t$tptr$c,																	--#FAF.177.n
          brmcs941.t$opfc$l       t$opfc$l,
    		  znsls401.t$idor$c		  t$idor$c	
         FROM baandb.tznsls401201 znsls401,
              baandb.ttcibd001201 tcibd001,
              baandb.ttdsls401201 tdsls401
              LEFT JOIN 
				(select o.t$orno, max(n.t$opfc$l) t$opfc$l  from baandb.tbrmcs941201 n, baandb.ttdsls401201 o
				where n.T$LINE$L=(select min(n1.t$line$l)   from baandb.tbrmcs941201 n1
								  where n1.T$GAMT$L=(select max(n2.T$GAMT$L) 
													  from baandb.tbrmcs941201 n2
													  where n2.T$TXRE$L=n1.T$TXRE$L))
        and o.T$TXRE$L=n.T$TXRE$L
		GROUP BY o.t$orno) brmcs941																						--#FAF.177.n
			  ON  brmcs941.t$orno=tdsls401.t$orno
             WHERE  tcibd001.t$item=tdsls401.t$item
         AND    znsls401.t$orno$c=tdsls401.t$orno
         AND    znsls401.t$pono$c=tdsls401.t$pono
         GROUP BY
          znsls401.t$ncia$c,
          znsls401.t$uneg$c,
          znsls401.t$pecl$c,
          znsls401.t$sqpd$c,
          znsls401.t$entr$c,
          znsls401.t$orno$c,
          brmcs941.t$opfc$l,
		  znsls401.t$idor$c) sls401q
		  LEFT JOIN  baandb.tznsls004201 znsls004 ON znsls004.t$orno$c=sls401q.t$orno AND znsls004.t$entr$c=sls401q.t$entr$c,			--#FAF.174.n
        baandb.ttcemm124201 tcemm124,
        baandb.ttcemm030201 tcemm030,
        baandb.ttccom130201 endfat,
        baandb.ttccom130201 endent,
        baandb.ttdsls094201 tdsls094,																				--#FAF.006.n
		( SELECT Max(tznsls410201.t$poco$c) poco,
                 tznsls410201.t$ncia$c ncia,
                 tznsls410201.t$uneg$c uneg,
                 tznsls410201.t$pecl$c pecl,
				 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(tznsls410201.t$dtoc$c), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE) dtoc
          FROM baandb.tznsls410201
          WHERE
          tznsls410201.t$dtoc$c = (SELECT Max(b.t$dtoc$c)
                                    FROM baandb.tznsls410201 b
                                    WHERE   b.t$ncia$c=tznsls410201.t$ncia$c
                                    AND     b.t$uneg$c=tznsls410201.t$uneg$c
                                    AND     b.t$pecl$c=tznsls410201.t$pecl$c
                                    AND     b.t$sqpd$c=tznsls410201.t$sqpd$c)
          GROUP BY 
                   tznsls410201.t$ncia$c,
                   tznsls410201.t$uneg$c,
                   tznsls410201.t$pecl$c) ulttrc	
WHERE   sls401q.t$orno=tdsls400.t$orno
AND     znsls400.t$ncia$c=sls401q.t$ncia$c
AND     znsls400.t$uneg$c=sls401q.t$uneg$c
AND     znsls400.t$pecl$c=sls401q.t$pecl$c
AND     znsls400.t$sqpd$c=sls401q.t$sqpd$c
AND     tdsls400.t$cofc=tcemm124.t$cwoc
AND		tcemm124.t$dtyp=1
AND		tcemm030.t$eunt=tcemm124.t$grid
AND     endfat.t$cadr=tdsls400.t$itad
AND     endent.t$cadr=tdsls400.t$stad
AND     ulttrc.ncia=sls401q.t$ncia$c
AND     ulttrc.uneg=sls401q.t$uneg$c
AND     ulttrc.pecl=sls401q.t$pecl$c
AND		tdsls094.t$sotp=tdsls400.t$sotp																--#FAF.006.n
