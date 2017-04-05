    select cisli940.t$fire$l                                                    REF_FISCAL,
           STATUS.DESCR                                                         STATUS,
           cisli941.t$item$l                                                    ITEM,
           cast((from_tz(to_timestamp(to_char(cisli940.t$date$l,
                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') as date)                    DATA_EMISSAO,
           cisli940.t$ityp$l                                                    TIPO_TRANSACAO,
           cisli940.t$idoc$l                                                    DOCUMENTO,
           cisli940.t$fdtc$l ||' - ' || tcmcs966.t$dsca$l                       COD_TIPO_DOC_FISCAL,
           TIPO_DOC.DESCRICAO                                                   TIPO_DOC_FISCAL,
           cisli941.t$iprt$l                                                    VALOR,
           cisli245.t$slso                                                      ORDEM_VENDA,
           znsls004.t$pecl$c                                                    PEDIDO,
           zncom005.t$cast$c                                                    COD_ATIVACAO_SERV,
           cast((from_tz(to_timestamp(to_char(znsls410.t$dtoc$c,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)                       DATA_IVE
               
      from baandb.tcisli941301 cisli941

inner join baandb.tcisli940301 cisli940
        on cisli940.t$fire$l = cisli941.t$fire$l
       and cisli940.t$fdty$l = 1  -- Venda com pedido

inner join baandb.tcisli245301 cisli245
        on cisli245.t$fire$l = cisli941.t$fire$l
       and cisli245.t$line$l = cisli941.t$line$l
       and cisli245.t$slcp = 301
       and cisli245.t$ortp = 1
       and cisli245.t$koor = 3
       and cisli245.t$sqnb = 0
       and cisli245.t$oset = 0

 left join baandb.ttcmcs966301 tcmcs966
        on tcmcs966.t$fdtc$l = cisli940.t$fdtc$l
 
 left join baandb.tznsls004301 znsls004
        on znsls004.t$orno$c = cisli245.t$slso
       and znsls004.t$pono$c = cisli245.t$pono
 
 left join baandb.tznsls410301 znsls410
        on znsls410.t$ncia$c = znsls004.t$ncia$c
       and znsls410.t$uneg$c = znsls004.t$uneg$c
       and znsls410.t$pecl$c = znsls004.t$pecl$c
       and znsls410.t$sqpd$c = znsls004.t$sqpd$c
       and znsls410.t$entr$c = znsls004.t$entr$c
       and znsls410.t$poco$c = 'IVE'

 left join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$sequ$c,
                    min(a.t$cast$c) t$cast$c
               from baandb.tzncom005301 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$sequ$c ) zncom005
        on zncom005.t$ncia$c = znsls004.t$ncia$c
       and zncom005.t$uneg$c = znsls004.t$uneg$c
       and zncom005.t$pecl$c = znsls004.t$pecl$c
       and zncom005.t$sqpd$c = znsls004.t$sqpd$c
       and zncom005.t$entr$c = znsls004.t$entr$c
       and zncom005.t$sequ$c = znsls004.t$sequ$c

 left join ( select l.t$desc DESCR,
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
                                            and l1.t$cpac = l.t$cpac ) ) STATUS
        on STATUS.t$cnst = cisli940.t$stat$l

 left join ( select l.t$desc DESCRICAO,
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
                                            and l1.t$cpac = l.t$cpac ) ) TIPO_DOC
        on TIPO_DOC.t$cnst = cisli940.t$fdty$l

     where cisli941.t$item$l in (5837695,5837696,5837697,5837698)
       and Trunc(cast((from_tz(to_timestamp(to_char(cisli940.t$date$l,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
           Between :DATA_EMISSAO_DE
               And :DATA_EMISSAO_ATE
