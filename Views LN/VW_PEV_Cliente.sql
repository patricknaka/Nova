-- 05-mai-2014, Fabio Ferreira, Correção timezone DATA_CHEGADA_PED
-- 07-mai-2014, Fabio Ferreira, Correção cia 201
-- FAF.002 - Fabio Ferreira, 09-mai-2014, Fabio Ferreira, 	Correção de alias
-- FAF.005 - Fabio Ferreira, 14-mai-2014, Fabio Ferreira, 	Iclusão do camo ID_LISTA_CASAMENTO
-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Retirado campo Pedido_Entrega
-- #FAF.048 - 17-mai-2014, Fabio Ferreira, 	Retirado campo Pedido_Entrega
-- #FAF.048.1 - 23-mai-2014, Fabio Ferreira, 	NUM_ENTREGA convertido para string
-- #FAF.048.1 - 26-mai-2014, Fabio Ferreira, 	Agrupado registros duplicados
-- #FAF.113 - 	26-mai-2014, Fabio Ferreira, 	Inclusão do campo CIA
-- #FAF.252 - 	30-jul-2014, Fabio Ferreira, 	Correção data atualização
--***************************************************************************************************************************************************************
SELECT DISTINCT
		znsls400.t$ncia$c CD_CIA,																								--#FAF.113.n
	   znsls401.t$pecl$c NR_PEDIDO,
       TO_CHAR(znsls401.t$entr$c) NR_ENTREGA,																	-- #FAF.048.1.n
	   tdsls400.t$orno NR_ORDEM,
       tdsls400.t$ofbp CD_CLIENTE_FATURA,
       tccom130.t$ftyp$l CD_TIPO_CLIENTE,
       tccom130.t$ccit CD_CIDADE_FATURA,
       tccom130.t$ccty CD_PAIS_FATURA,
       tccom130.t$cste CD_ESTADO_FATURA,
       tccom130.t$pstc CD_CEP_FATURA,
       tccom130.t$namc DS_ENDERECO_FATURA,
       tccom130.t$dist$l DS_BAIRRO_FATURA,
       tccom130.t$hono NR_FATURA,
       znsls400.t$comf$c DS_COMPLEMENTO_FATURA,
       znsls400.t$reff$c DS_REFERENCIA_ENDERECO_FATURA,
       tdsls400.t$stbp CD_CLIENTE_ENTREGA,
       tccom130c.t$ccit CD_CIDADE_ENTREGA,
       tccom130c.t$ccty CD_PAIS_ENTREGA,
       tccom130c.t$cste CD_ESTADO_ENTREGA,
       tccom130c.t$pstc CD_CEP_ENTREGA,
       tccom130c.t$namc DS_ENDERECO_ENTREGA,
       tccom130c.t$dist$l DS_BAIRRO_ENTREGA,
       tccom130c.t$hono NR_ENTREGA_ENDERECO,																		--#FAF.002.n
       znsls401.t$come$c DS_COMPLEMENTO_ENTREGA,
       znsls401.t$refe$c DS_REFERENCIA_ENDERECO_ENTREGA,
	   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_EMISSAO,
	   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_CHEGADA_PEDIDO,
	   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO,
	   znsls400.t$idli$c NR_LISTA_CASAMENTO																		--#FAF.005.n
FROM baandb.tznsls401201 znsls401,
     baandb.tznsls400201 znsls400,
     baandb.ttdsls400201 tdsls400,
     baandb.ttccom130201 tccom130,
     baandb.ttccom130201 tccom130c
WHERE znsls400.t$ncia$c = znsls401.t$ncia$c
AND znsls400.t$uneg$c = znsls401.t$uneg$c
AND znsls400.t$pecl$c = znsls401.t$pecl$c
AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
AND tdsls400.t$orno = znsls401.t$orno$c
AND tccom130.t$cadr = tdsls400.t$itad
AND tccom130c.t$cadr = tdsls400.t$stad