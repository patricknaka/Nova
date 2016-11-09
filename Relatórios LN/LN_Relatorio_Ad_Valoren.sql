select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
                            DT_FATURAMENTO,
--                          DT_SITUACAO,
       cisli940.t$fire$l    REFERENCIA,
       cisli940.t$cfrw$l    ID_TRANPORTADORA,
       tcmcs080.t$dsca      APELIDO,
       znsls401.t$ncia$c    COMPANHIA,
       znsls401.t$uneg$c    UNIDADE_NEGOCIO,
       znsls401.t$pecl$c    PEDIDO
--                          ADVALOREN,
--                          SITUACAO

from  baandb.tcisli940301 cisli940

left join baandb.ttcmcs080301 tcmcs080
on tcmcs080.t$cfrw = cisli940.t$cfrw$l

left join ( select   a.t$fire$l,
                     a.t$slso
            from baandb.tcisli245301 a
            where a.t$koor = 3 
            group by a.t$fire$l, a.t$slso ) cisli245
on cisli245.t$fire$l = cisli940.t$fire$l

left join ( select b.t$orno$c, b.t$pecl$c,
                   b.t$ncia$c, b.t$uneg$c
            from   baandb.tznsls401301 b
            where  b.t$pecl$c = '102518813'
            group by b.t$orno$c, b.t$pecl$c,
                     b.t$ncia$c, b.t$uneg$c) znsls401
on znsls401.t$orno$c = cisli245.t$slso

where cisli940.t$stat$l in (5,6)
and  trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)) 
between :DataFaturamentoDe and :DataFaturamentoAte
