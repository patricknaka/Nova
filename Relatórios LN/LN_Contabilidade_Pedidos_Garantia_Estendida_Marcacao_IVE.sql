select cisli940.t$fire$l                                   REF_FISCAL,
       cisli941.t$item$l                                   ITEM,
       cast((from_tz(to_timestamp(to_char(cisli940.t$date$l,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_EMISSAO,
       cisli940.t$ityp$l                                   TIPO_TRANSACAO,
       cisli940.t$idoc$l                                   DOCUMENTO,
       cisli940.t$fdtc$l ||' - ' || tcmcs966.t$dsca$l      COD_TIPO_DOC_FISCAL,
       TIPO_DOC.DESCRICAO                                  TIPO_DOC_FISCAL,
       cisli941.t$amnt$l                                   VALOR,
       cisli245.t$slso                                     ORDEM_VENDA,
       znsls401.t$pecl$c                                   PEDIDO
  from baandb.tcisli941301 cisli941

inner join baandb.tcisli940301 cisli940
        on cisli940.t$fire$l = cisli941.t$fire$l
       and cisli940.t$fdty$l = 1  -- Venda com pedido

left join baandb.ttcmcs966301 tcmcs966
       on tcmcs966.t$fdtc$l = cisli940.t$fdtc$l

left  join ( select l.t$desc DESCRICAO,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'ci'
                and d.t$cdom = 'sli.tdff.l'
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
                                            and l1.t$cpac = l.t$cpac ) )
                                                                  TIPO_DOC
        on TIPO_DOC.t$cnst = cisli940.t$fdty$l

inner join baandb.tcisli245301 cisli245
        on cisli245.t$fire$l = cisli941.t$fire$l
       and cisli245.t$line$l = cisli941.t$line$l

left join ( select a.t$pecl$c,
                   a.t$orno$c
            from baandb.tznsls401301 a
            group by a.t$pecl$c,
                     a.t$orno$c) znsls401
       on znsls401.t$orno$c = cisli245.t$slso

 where trunc(cast((from_tz(to_timestamp(to_char(cisli940.t$date$l,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date))
       between :DATA_EMISSAO_DE
           and :DATA_EMISSAO_ATE
   and cisli940.t$fire$l in (:REF_FISCAL)
   and cisli941.t$item$l in (5837695,5837696,5837697,5837698)
