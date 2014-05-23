  -- #FAF.008 - 21-mai-2014, Fabio Ferreira, 	Diversas correções e inclusão de campos
  -- #FAF.043 - 22-mai-2014, Fabio Ferreira, 	Rtrim Ltrim no codigo da garantia
  -- #FAF.043.1 - 23-mai-2014, Fabio Ferreira, 	Ajustes
  --********************************************************************************************************************************************************
  SELECT
    znsls400.T$PECL$C PEDIDO,																													 
    znsls401.T$ENTR$C ENTREGA,
    tdsls400.T$ORNO ORDEM_VENDA,																				
    zncom005.t$idpa$c ID_GARANTIA_ESTENDIDA,
    tdsls400.t$hdst STATUS_PEDIDO, 										
    CAST((FROM_TZ(CAST(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
      AT time zone sessiontimezone) AS DATE) DATA_EMISSÃO_GARANTIA,											
    CAST((FROM_TZ(CAST(TO_CHAR(tdsls400.t$odat, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
      AT time zone sessiontimezone) AS DATE) DATA_PEDIDO_PRODUTO,												
    ltrim(rtrim(tdsls401p.t$item)) COD_PRODUTO,							
    ltrim(rtrim(tdsls401.t$item)) COD_GARANTIA,																	
    sum(zncom005.t$igva$c) VALOR_CUSTO,
    sum(tdsls401.t$pric)/count(tdsls401.t$qoor) VALOR_GARANTIA,
    sum(zncom005.t$piof$c) VALOR_IOF,										
    sum(zncom005.t$ppis$c) VALOR_PIS,
    sum(zncom005.t$pcof$c) VALOR_COFINS,
    0 VALOR_CSLL,														
    sum(zncom005.t$irrf$c) VALOR_IRRF,
    avg(tdsls401.t$qoor) QTD_GARANTIA
  FROM
    BAANDB.tzncom005201 zncom005,
    ttcibd001201 tcibd001,																						
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
    LEFT JOIN ttdsls401201 tdsls401p
      ON tdsls401p.t$orno=znsls401p.t$orno$c
      AND tdsls401p.t$pono=znsls401p.t$pono$c
  WHERE
    tdsls400.t$orno=zncom005.t$orno$c
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
  AND tdsls401.T$ORNO=znsls401.T$ORNO$C																			
  AND tdsls401.t$pono=znsls401.T$PONO$C
  AND tcibd001.T$ITEM=tdsls401.T$ITEM
  AND tcibd001.T$ITGA$C=1
  AND zncom005.T$TPAP$C=2
  GROUP BY	znsls400.T$PECL$C, znsls401.T$ENTR$C, tdsls400.T$ORNO, zncom005.t$idpa$c, tdsls400.t$hdst, znsls400.t$dtem$c,
        tdsls400.t$odat, tdsls401p.t$item, tdsls401.t$item
                                              
  