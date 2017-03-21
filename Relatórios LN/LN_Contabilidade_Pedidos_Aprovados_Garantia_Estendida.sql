select znsls400.t$pecl$c                                   PEDIDO,
       znsls400.t$sqpd$c                                   SEQ_PEDIDO,
       cast((from_tz(to_timestamp(to_char(znsls400.t$dtem$c,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_EMISSAO,
       znsls401.t$item$c                                   ITEM,
       znsls401.t$orno$c                                   ORDEM_VENDA,
       znsls401.t$qtve$c                                   QTDE_VENDIDA,
       znsls401.t$vlun$c                                   VALOR_UNITARIO,
       znsls412.t$ttyp$c                                   TIPO_TRANSACAO,
       znsls412.t$ninv$c                                   DOCUMENTO,
       case when znsls400.t$sige$c = 1 then
            'SIM'
       else
            'NAO'
       end                                                 PEDIDO_SIGE,
       case when znsls400.t$migr$c = 1 then
            'SIM'
       else
            'NAO'
       end                                                 MIGRACAO

  from ( select a.t$ncia$c,
                a.t$uneg$c,
                a.t$pecl$c,
                a.t$sqpd$c,
                a.t$item$c,
                a.t$orno$c,
                a.t$vlun$c,
                a.t$qtve$c
           from baandb.tznsls401301 a
          where a.t$item$c in (5837695,5837696,5837697,5837698)
       group by a.t$ncia$c,
                a.t$uneg$c,
                a.t$pecl$c,
                a.t$sqpd$c,
                a.t$item$c,
                a.t$orno$c,
                a.t$vlun$c,
                a.t$qtve$c) znsls401

inner join baandb.tznsls400301 znsls400
        on znsls400.t$ncia$c = znsls401.t$ncia$c
       and znsls400.t$uneg$c = znsls401.t$uneg$c
       and znsls400.t$pecl$c = znsls401.t$pecl$c
       and znsls400.t$sqpd$c = znsls401.t$sqpd$c

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$orno$c,
                   a.t$ttyp$c,
                   a.t$ninv$c
              from baandb.tznsls412301 a 
          group by a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$orno$c,
                   a.t$ttyp$c,
                   a.t$ninv$c ) znsls412
       on znsls412.t$ncia$c = znsls401.t$ncia$c
      and znsls412.t$uneg$c = znsls401.t$uneg$c
      and znsls412.t$pecl$c = znsls401.t$pecl$c
      and znsls412.t$sqpd$c = znsls401.t$sqpd$c

where trunc(cast((from_tz(to_timestamp(to_char(znsls400.t$dtem$c,
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                   AT time zone 'America/Sao_Paulo') as date))
      between :DATA_EMISSAO_DE
          and :DATA_EMISSAO_ATE
  and znsls400.t$pecl$c in (:PEDIDO)
  and znsls400.t$sqpd$c in (:SEQ_PEDIDO)
