select  distinct
        znsls400.t$pecl$c                                   PEDIDO_MKP,
        cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)
                                                            DATA_PEDIDO,
        cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)
                                                            DATA_CANCELAMENTO,
        znsls401.VALOR                                      VALOR,
        STATUS.DESCR                                        STATUS,
        zncmg007.t$desc$c                                   FORMA_PAGAMENTO

from  baandb.tznsls400301 znsls400

inner join  ( select	a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                  sum(a.t$vlun$c * a.t$qtve$c)	VALOR
              from	baandb.tznsls401301 a
          		--identifica marketplace
          		inner join  baandb.ttcibd001301 tcibd001
          		        on  tcibd001.t$item = a.t$itml$c

              inner join  baandb.tznisa002301 znisa002
                      on  znisa002.t$npcl$c = tcibd001.t$npcl$c

              inner join  baandb.tznisa001301 znisa001
                      on  znisa001.t$nptp$c = znisa002.t$nptp$c
                     and  znisa001.t$emnf$c = 2  --não emite nf
                     and  znisa001.t$bpti$c = 5  --tabela muro
                     and  znisa001.t$siit$c = 1  --Envia na interface de item (sim)
                     and  znisa001.t$nfed$c = 2  --não Gera nota fiscal de entrada de devolução
              group by a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c,
                       a.t$entr$c) znsls401
        on  znsls401.t$ncia$c = znsls400.t$ncia$c
       and  znsls401.t$uneg$c = znsls400.t$uneg$c
       and  znsls401.t$pecl$c = znsls400.t$pecl$c
       and  znsls401.t$sqpd$c = znsls400.t$sqpd$c

inner join  baandb.tznsls410301 znsls410
        on  znsls410.t$ncia$c = znsls401.t$ncia$c
       and  znsls410.t$uneg$c = znsls401.t$uneg$c
       and  znsls410.t$pecl$c = znsls401.t$pecl$c
       and  znsls410.t$sqpd$c = znsls401.t$sqpd$c
       and  znsls410.t$entr$c = znsls401.t$entr$c
       and  znsls410.t$poco$c = 'CAN'

left  join  baandb.tznsls402301 znsls402
        on  znsls402.t$ncia$c = znsls400.t$ncia$c
       and  znsls402.t$uneg$c = znsls400.t$uneg$c
       and  znsls402.t$pecl$c = znsls400.t$pecl$c
       and  znsls402.t$sqpd$c = znsls400.t$sqpd$c

left  join  baandb.tzncmg007301 zncmg007
        on  zncmg007.t$mpgt$c = znsls402.t$idmp$c

left  join  baandb.tznsls412301 znsls412
        on  znsls412.t$ncia$c = znsls402.t$ncia$c
       and  znsls412.t$uneg$c = znsls402.t$uneg$c
       and  znsls412.t$pecl$c = znsls402.t$pecl$c
       and  znsls412.t$sqpd$c = znsls402.t$sqpd$c

left  join  ( select  a.t$ttyp,
                      a.t$ninv,
                      a.t$rpst$l
              from    baandb.ttfacr201301 a 
              group by a.t$ttyp,
                       a.t$ninv,
                       a.t$rpst$l ) tfacr201
        on  tfacr201.t$ttyp = znsls412.t$ttyp$c
       and  tfacr201.t$ninv = znsls412.t$ninv$c

left  join ( select 
                    l.t$desc DESCR,
                    d.t$cnst
              from baandb.tttadv401000 d,
                   baandb.tttadv140000 l
             where d.t$cpac = 'tf'
               and d.t$cdom = 'acr.strp.l'
               and l.t$clan = 'p'
               and l.t$cpac = 'tf'
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
        on STATUS.t$cnst = tfacr201.t$rpst$l

where  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
               between :DATA_CANCELAMENTO_DE and :DATA_CANCELAMENTO_ATE
