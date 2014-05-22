-- #FAF.008 - 21-mai-2014, Fabio Ferreira, 	Diversas correções e inclusão de campos
-- #FAF.043 - 22-mai-2014, Fabio Ferreira, 	Rtrim Ltrim no codigo da garantia
--********************************************************************************************************************************************************
SELECT DISTINCT
	znsls400.T$PECL$C PEDIDO,																					--#FAF.008.sn									 
	znsls401.T$ENTR$C ENTREGA,
	tdsls400.T$ORNO ORDEM_VENDA,																				--#FAF.008.en
	zncom005.t$idpa$c ID_GARANTIA_ESTENDIDA,
	tdsls400.t$hdst STATUS_PEDIDO, 										-- Sataus da ordem de venda
	znsls400.t$dtem$c DATA_EMISSÃO_GARANTIA,							-- Data da emssão pedido / integração item garantido
	tdsls400.t$odat DATA_PEDIDO_PRODUTO,								-- Data incluão produto / integração
	ltrim(rtrim(tdsls401p.t$item)) COD_PRODUTO,							
--	tdsls401.t$item COD_GARANTIA,																				--#FAF.043.o
	ltrim(rtrim(tdsls401.t$item)) COD_GARANTIA,																	--#FAF.043.o
	zncom005.t$igva$c VALOR_CUSTO,
	tdsls401.t$pric VALOR_GARANTIA,
	zncom005.t$piof$c VALOR_IOF,										
	zncom005.t$ppis$c VALOR_PIS,
	zncom005.t$pcof$c VALOR_COFINS,
	0 VALOR_CSLL,														-- ***  PENDENTE DE DEFINIÇÂO  ***
	zncom005.t$irrf$c VALOR_IRRF
FROM
	BAANDB.tzncom005201 zncom005,
	ttcibd001201 tcibd001,																						--#FAF.008.n
	ttdsls400201 tdsls400,
	ttdsls401201 tdsls401,
	tznsls400201 znsls400,
	tznsls401201 znsls401
	LEFT JOIN tznsls401201 znsls401p
		ON	znsls401p.t$ncia$c=znsls401.t$ncia$c
		AND	znsls401p.t$uneg$c=znsls401.t$uneg$c
		AND znsls401p.t$pecl$c=znsls401.t$pcga$c
		AND znsls401p.t$sqpd$c=znsls401.t$sqpd$c
		AND znsls401p.t$entr$c=znsls401.t$entr$c
		AND znsls401p.t$sequ$c=znsls401.t$sgar$c	
--	LEFT JOIN tznsls400201 znsls400p																			--#FAF.008.so
--		ON	znsls400p.t$ncia$c=znsls401p.t$ncia$c
--		AND	znsls400p.t$uneg$c=znsls401p.t$uneg$c
--		AND znsls400p.t$pecl$c=znsls401p.t$pecl$c
--		AND znsls400p.t$sqpd$c=znsls401p.t$sqpd$c	
--	LEFT JOIN ttdsls400201 tdsls400p
--		ON tdsls400p.t$orno=znsls401p.t$orno$c																	--#FAF.008.eo
	LEFT JOIN ttdsls401201 tdsls401p
		ON tdsls401p.t$orno=znsls401p.t$orno$c
		AND tdsls401p.t$pono=znsls401p.t$pono$c
WHERE
	tdsls400.t$orno=zncom005.t$orno$c
--AND tdsls401.t$orno=zncom005.t$orno$c																			--#FAF.008.so
--AND tdsls401.t$orno=zncom005.t$orno$c
--AND tdsls401.t$pono=zncom005.t$pono$c
--AND tdsls401.t$sqnb=zncom005.t$sqnb$c																			--#FAF.008.eo
AND	znsls400.t$ncia$c=zncom005.t$ncia$c
AND	znsls400.t$uneg$c=zncom005.t$uneg$c
AND znsls400.t$pecl$c=zncom005.t$pecl$c
AND znsls400.t$sqpd$c=zncom005.t$sqpd$c
AND	znsls401.t$ncia$c=zncom005.t$ncia$c
AND	znsls401.t$uneg$c=zncom005.t$uneg$c
AND znsls401.t$pecl$c=zncom005.t$pecl$c
AND znsls401.t$sqpd$c=zncom005.t$sqpd$c
AND znsls401.t$entr$c=zncom005.t$entr$c
AND znsls401.t$sequ$c=zncom005.t$sequ$c
AND tdsls401.T$ORNO=znsls401.T$ORNO$C																			--#FAF.008.sn
AND tdsls401.t$pono=znsls401.T$PONO$C
AND tcibd001.T$ITEM=tdsls401.T$ITEM
AND tcibd001.T$ITGA$C=1
AND zncom005.T$TPAP$C=2																							--#FAF.008.en

