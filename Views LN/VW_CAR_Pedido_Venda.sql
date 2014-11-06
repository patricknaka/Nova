-- 21/08/2014 Atualizacao timezone
--****************************************************************************************************************************************************************
SELECT DISTINCT 
    znsls412.t$ttyp$c || znsls412.t$ninv$c    CD_CHAVE_PRIMARIA,
    1				              CD_CIA,
    znsls412.t$pecl$c                         NR_PEDIDO,
    znsls401.t$orno$c                         NR_ORDEM,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls412.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO,
    CASE WHEN znsls400.t$idcp$c = 0 THEN Null 
         ELSE znsls400.t$idcp$c END           NR_CAMPANHA_B2B,
    CASE WHEN znsls400.t$idco$c = 0 THEN Null
         ELSE znsls400.t$idco$c END           NR_CONTRATO_B2B
FROM
    baandb.tznsls412201 znsls412,
    baandb.tznsls401201 znsls401,
    baandb.tznsls400201 znsls400
WHERE
    znsls401.t$ncia$c = znsls412.t$ncia$c
AND znsls401.t$uneg$c = znsls412.t$uneg$c
AND znsls401.t$pecl$c = znsls412.t$pecl$c
AND znsls401.t$sqpd$c = znsls412.t$sqpd$c
AND znsls400.t$ncia$c = znsls412.t$ncia$c
AND znsls400.t$uneg$c = znsls412.t$uneg$c
AND znsls400.t$pecl$c = znsls412.t$pecl$c
AND znsls400.t$sqpd$c = znsls412.t$sqpd$c
AND znsls412.t$ninv$c!=0