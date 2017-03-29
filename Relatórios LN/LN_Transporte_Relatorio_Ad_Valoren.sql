select cast((from_tz(to_timestamp(to_char(cisli940.t$date$l, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DT_FATURAMENTO,
       cast((from_tz(to_timestamp(to_char(znsls410.DATA_OCORR, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DT_SITUACAO,
       cisli940.t$cfrw$l                                   ID_TRANPORTADORA,
       tcmcs080.t$dsca                                     APELIDO,
       znsls004.t$ncia$c                                   COMPANHIA,
       znsls004.t$uneg$c                                   UNIDADE_NEGOCIO,
       znsls004.t$pecl$c                                   PEDIDO,
       cisli940.t$fght$l                                   ADVALOREN,
       znsls410.PT_CONTR                                   SITUACAO

  from baandb.tcisli940301 cisli940

left join baandb.ttcmcs080301 tcmcs080
       on tcmcs080.t$cfrw = cisli940.t$cfrw$l

left join ( select   a.t$fire$l,
                     a.t$slso
              from baandb.tcisli245301 a
             where a.t$koor = 3 
          group by a.t$fire$l,
                   a.t$slso ) cisli245
       on cisli245.t$fire$l = cisli940.t$fire$l

left join ( select a.t$orno$c,
                   a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c
              from baandb.tznsls004301 a
          group by a.t$orno$c,
                   a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c) znsls004
       on znsls004.t$orno$c = cisli245.t$slso

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
            		   a.t$entr$c,
                   max(a.t$dtoc$c) DATA_OCORR,
                   max(a.t$poco$c) keep (dense_rank last order by a.t$dtoc$c,  a.t$seqn$c) PT_CONTR
              from baandb.tznsls410301 a
          group by a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c) znsls410
       on  znsls410.t$ncia$c = znsls004.t$ncia$c
       and znsls410.t$uneg$c = znsls004.t$uneg$c
       and znsls410.t$pecl$c = znsls004.t$pecl$c
       and znsls410.t$sqpd$c = znsls004.t$sqpd$c
       and znsls410.t$entr$c = znsls004.t$entr$c

where cisli940.t$stat$l in (5,6)
and  trunc(cast((from_tz(to_timestamp(to_char(cisli940.t$date$l, 
                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') as date))
           between :DT_FATURAMENTO_DE and :DT_FATURAMENTO_ATE
