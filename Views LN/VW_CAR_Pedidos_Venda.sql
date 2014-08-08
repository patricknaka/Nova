SELECT DISTINCT 
    znsls412.t$ttyp$c || znsls412.t$ninv$c    CD_CHAVE_PRIMARIA,
    znsls412.t$ncia$c                         CD_CIA,
    znsls412.t$pecl$c                         NR_PEDIDO_VENDA,
    znsls401.t$orno$c                         NR_ORDEM,
    znsls412.t$rcd_utc                        DT_ATUALIZACAO,
    CASE WHEN znsls400.t$idcp$c = 0 THEN Null 
         ELSE znsls400.t$idcp$c END           CAMPANHA,
    CASE WHEN znsls400.t$idco$c = 0 THEN Null
         ELSE znsls400.t$idco$c END           CONTRATO
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
