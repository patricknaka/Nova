select
        znint002.t$desc$c                        UNIDAD_NEG,
        cast((from_tz(to_timestamp(to_char(tdsls400.t$odat,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_COMPRA,
        znsls400.t$iclc$c                        CODIGO_CLIENTE,
        znsls400.t$emaf$c                        EMAIL_CLIENTE,
        znsls400.t$nomf$c                        NOME,
        znsls400.t$idca$c                        CANAL,
        znsls400.t$pecl$c                        PEDIDO,
        znsls401.t$entr$c                        ENTREGA,
        cisli940.t$docn$l                        NOTA_FISCAL,
        cisli940.t$seri$l                        SERIE,
        znsls401.t$vlun$c * znsls401.t$qtve$c    VALOR_PEDIDO,
        tcibd001.t$item                          SKU,
        tcibd001.t$dscb$c                        DESCRICAO_ITEM,
        MEIO_PAGTO.t$desc$c                      MEIO_PAGAMENTO,
        znsls400.t$cven$c                        VENDEDOR,
        znmcs002.t$desc$c                        STATUS_PEDIDO,
        znsls400.t$telf$c                        TEL_1,
        znsls400.t$te1f$c                        TEL_2,
        znsls400.t$te2f$c                        TEL_3,
        tcibd001_GARANTIA.t$mdfb$c               GARANTIA_ESTENDIDA,
        znsls401_GARANTIA.t$vlun$c * znsls401_GARANTIA.t$qtve$c
                                                 VALOR_GARANTIA_ESTENDIDA

from baandb.tznsls400301 znsls400

left join baandb.tznint002301 znint002
       on znint002.t$uneg$c = znsls400.t$uneg$c

inner join baandb.tznsls401301 znsls401
        on znsls401.t$ncia$c = znsls400.t$ncia$c
       and znsls401.t$uneg$c = znsls400.t$uneg$c
       and znsls401.t$pecl$c = znsls400.t$pecl$c
       and znsls401.t$sqpd$c = znsls400.t$sqpd$c
       and znsls401.t$iitm$c = 'P'  -- Produto

left join baandb.tznsls401301 znsls401_GARANTIA
       on znsls401_GARANTIA.t$ncia$c = znsls401.t$ncia$c
      and znsls401_GARANTIA.t$uneg$c = znsls401.t$uneg$c
      and znsls401_GARANTIA.t$pecl$c = znsls401.t$pecl$c
      and znsls401_GARANTIA.t$sqpd$c = znsls401.t$sqpd$c
      and znsls401_GARANTIA.t$entr$c = znsls401.t$entr$c
      and znsls401_GARANTIA.t$igar$c = znsls401.t$item$c
      and znsls401_GARANTIA.t$pcga$c = znsls401.t$pecl$c

left join baandb.ttcibd001301 tcibd001
       on tcibd001.t$item = znsls401.t$itml$c

left join baandb.ttcibd001301 tcibd001_GARANTIA
       on tcibd001_GARANTIA.t$item = znsls401_GARANTIA.t$itml$c

left  join  ( select a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     b.t$desc$c
              from baandb.tznsls402301 a,
                   baandb.tzncmg007301 b
              where  b.t$mpgs$c = a.t$idmp$c ) MEIO_PAGTO
        on MEIO_PAGTO.t$ncia$c = znsls400.t$ncia$c
       and MEIO_PAGTO.t$uneg$c = znsls400.t$uneg$c
       and MEIO_PAGTO.t$pecl$c = znsls400.t$pecl$c
       and MEIO_PAGTO.t$sqpd$c = znsls400.t$sqpd$c

left join baandb.ttdsls400301 tdsls400
       on tdsls400.t$orno = znsls401.t$orno$c

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   max(a.t$dtoc$c),
                   max(a.t$poco$c) keep (dense_rank last order by a.t$dtoc$c, a.t$seqn$c) POCO
            from baandb.tznsls410301 a
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$entr$c ) znsls410
       on znsls410.t$ncia$c = znsls401.t$ncia$c
      and znsls410.t$uneg$c = znsls401.t$uneg$c
      and znsls410.t$pecl$c = znsls401.t$pecl$c
      and znsls410.t$sqpd$c = znsls401.t$sqpd$c
      and znsls410.t$entr$c = znsls401.t$entr$c

left join baandb.tznmcs002301 znmcs002
       on znmcs002.t$poco$c = znsls410.POCO

left join baandb.tcisli245301 cisli245
       on cisli245.t$slcp = 301
      and cisli245.t$ortp = 1   -- Ordem/programação de venda
      and cisli245.t$koor = 3   -- Ordem de venda
      and cisli245.t$slso = znsls401.t$orno$c
      and cisli245.t$pono = znsls401.t$pono$c

left join baandb.tcisli940301 cisli940
       on cisli940.t$fire$l = cisli245.t$fire$l

where   cast((from_tz(to_timestamp(to_char(tdsls400.t$odat,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)
        between :DATA_COMPRA_DE
            and :DATA_COMPRA_ATE
  and   znsls400.t$idca$c = 'TVE'
  and   znsls400.t$idpo$c = 'LJ'
