-- 05-mai-2014, Fabio Ferreira, Correção timezone DATA_CHEGADA_PED
-- 07-mai-2014, Fabio Ferreira, Correção cia 201
-- FAF.002 - Fabio Ferreira, 09-mai-2014, Fabio Ferreira, 	Correção alias
-- FAF.005 - Fabio Ferreira, 14-mai-2014, Fabio Ferreira, 	Iclusão do camo ID_LISTA_CASAMENTO
-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Retirado campo Pedido_Entrega
-- #FAF.048 - 17-mai-2014, Fabio Ferreira, 	Retirado campo Pedido_Entrega
--***************************************************************************************************************************************************************
SELECT znsls401.t$pecl$c NUM_PEDIDO,
       znsls401.t$entr$c NUM_ENTREGA,
--	   CONCAT(TRIM(znsls401.t$pecl$c), TRIM(to_char(znsls401.t$entr$c))) PEDIDO_ENTREGA, 						-- #FAF.007.o
--	   znsls401.t$entr$c PEDIDO_ENTREGA, 																		-- #FAF.048.n	#FAF.048.n
	   tdsls400.t$orno ORDEM,
       tdsls400.t$ofbp CLIENTE_FATURA,
       tccom130.t$ftyp$l TIPO_CLIENTE,
       tccom130.t$ccit CIDADE_FATURA,
       tccom130.t$ccty PAIS_FATURA,
       tccom130.t$cste ESTADO_FATURA,
       tccom130.t$pstc CEP_FATURA,
       tccom130.t$namc LOGRAD_FATURA,
       tccom130.t$dist$l BAIRRO_FATURA,
       tccom130.t$hono NUM_FATURA,
       znsls400.t$comf$c COMPLEMENTO_FATURA,
       znsls400.t$reff$c REFERENCIA_FATURA,
       tdsls400.t$stbp CLIENTE_ENTREGA,
       tccom130c.t$ccit CIDADE_ENTREGA,
       tccom130c.t$ccty PAIS_ENTREGA,
       tccom130c.t$cste ESTADO_ENTREGA,
       tccom130c.t$pstc CEP_ENTREGA,
       tccom130c.t$namc LOGRAD_ENTREGA,
       tccom130c.t$dist$l BAIRRO_ENTREGA,
--       tccom130c.t$hono NUM_ENTREGA ,																		--#FAF.002.o
       tccom130c.t$hono NUM_ENTREGA_END ,																		--#FAF.002.n
       znsls401.t$come$c COMPLEMENTO_ENTREGA,
       znsls401.t$refe$c REFERENCIA_ENTREGA,
	   CAST((FROM_TZ(CAST(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DATA_EMISSAO,
	   CAST((FROM_TZ(CAST(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DATA_CHEGADA_PED,
       Q1.trdt DATA_HR_ULTIMA_ATUALIZACAO,
	   znsls400.t$idli$c ID_LISTA_CASAMENTO																	--#FAF.005.n
FROM tznsls401201 znsls401,
     tznsls400201 znsls400,
     ttdsls400201 tdsls400,
     ttccom130201 tccom130,
     ttccom130201 tccom130c,
      (SELECT ttdsls450201.t$orno torno, 
			CAST((FROM_TZ(CAST(TO_CHAR(Max(ttdsls450201.t$trdt), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			    AT time zone sessiontimezone) AS DATE) trdt
      FROM ttdsls450201
      GROUP BY ttdsls450201.t$orno) q1
WHERE znsls400.t$ncia$c = znsls401.t$ncia$c
AND znsls400.t$uneg$c = znsls401.t$uneg$c
AND znsls400.t$pecl$c = znsls401.t$pecl$c
AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
AND tdsls400.t$orno = znsls401.t$orno$c
AND tccom130.t$cadr = tdsls400.t$itad
AND tccom130c.t$cadr = tdsls400.t$stad
AND q1.torno = tdsls400.t$orno