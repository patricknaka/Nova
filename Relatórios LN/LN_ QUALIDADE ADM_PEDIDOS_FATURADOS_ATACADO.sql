select
        znfmd001.t$dsca$c                             PLANTA,
        znsls401.t$pecl$c                             DOCUMENTO_INICIAL,
        cisli940.t$fire$l                             REFERENCIA_FISCAL,
        ORDEM.STATUS_FATURA                           STATUS_DA_FATURA,
        cisli940.t$seri$l                             SERIE,
        cisli940.t$docn$l                             NOTA_FISCAL,
        cast((from_tz(to_timestamp(to_char(cisli940.t$date$l, 
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date) || '   ' ||
        to_char(cast((from_tz(to_timestamp(to_char(cisli940.t$date$l, 
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date), 'HH24:MI:SS')
                                                      DATA_EMISSAO,
        cisli940.t$amnt$l                             VALOR,
        cisli959.t$rsds$l                             MOTIVO_CANCELAMENTO,
        cisli940.t$cnfe$l                             LOCALIZADOR

from  baandb.tcisli940301 cisli940

inner join baandb.ttcmcs065301 tcmcs065
        on tcmcs065.t$cwoc = cisli940.t$cofc$l

inner join baandb.ttccom130301 tccom130
        on tccom130.t$cadr = tcmcs065.t$cadr

inner join baandb.tznfmd001301 znfmd001
        on znfmd001.t$fovn$c = tccom130.t$fovn$l

inner join ( select a.t$slso,
                    a.t$fire$l
             from baandb.tcisli245301 a
             group by a.t$slso,
                      a.t$fire$l) cisli245
        on cisli245.t$fire$l = cisli940.t$fire$l

inner join ( select a.t$orno$c,
                    a.t$pecl$c
             from baandb.tznsls401301 a
             group by a.t$orno$c,
                      a.t$pecl$c) znsls401
        on znsls401.t$orno$c = cisli245.t$slso

left  join ( select l.t$desc STATUS_FATURA,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'ci'
                and d.t$cdom = 'sli.stat'
                and l.t$clan = 'p'
                and l.t$cpac = 'ci'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) ORDEM
        on ORDEM.t$cnst = cisli940.t$stat$l

left join baandb.tcisli959301 cisli959
       on cisli959.t$rscd$l = cisli940.t$rscd$l

where   znfmd001.t$dsca$c in (:PLANTA)
and     trunc(cast((from_tz(to_timestamp(to_char(cisli940.t$date$l, 
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date))
        between :DATA_EMISSAO_DE and :DATA_EMISSAO_ATE
