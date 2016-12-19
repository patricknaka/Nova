select
        znsls400.t$pecl$c                 PEDIDO,
        znsls401.t$entr$c                 ENTREGA_DEV,
        cisli940.t$cfrn$l                 APELIDO_TRANSP_COLETA,
        znsls410_TRACKING.POCO            OCORRENCIA,
        znsls410_TRACKING.DTOC            DATA_OCORRENCIA,
        cisli940.t$docn$l                 NOTA_FISCAL_ENT,
        cisli940.t$seri$l                 SERIE_ENT,
        znfmd001.t$dsca$c                 FILIAL,
        cisli940.t$amnt$l                 VALOR_TOTAL_NF

from    baandb.tznsls400301 znsls400

inner join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$entr$c,
                        a.t$orno$c
              from  baandb.tznsls401301 a
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$entr$c,
                        a.t$orno$c) znsls401
        on  znsls401.t$ncia$c = znsls400.t$ncia$c
       and  znsls401.t$uneg$c = znsls400.t$uneg$c
       and  znsls401.t$pecl$c = znsls400.t$pecl$c
       and  znsls401.t$sqpd$c = znsls400.t$sqpd$c

left join ( select  a.t$slcp,
                    a.t$ortp,
                    a.t$koor,
                    a.t$slso,
                    a.t$fire$l
            from    baandb.tcisli245301 a
            where a.t$fire$l != ' '
            group by  a.t$slcp,
                      a.t$ortp,
                      a.t$koor,
                      a.t$slso,
                      a.t$fire$l ) cisli245
       on cisli245.t$slcp = 301 -- Companhia
      and cisli245.t$ortp = 1   -- Ordem/programaçao de venda
      and cisli245.t$koor = 3   -- Ordem de venda
      and cisli245.t$slso = znsls401.t$orno$c

left join baandb.tcisli940301 cisli940
       on cisli940.t$fire$l = cisli245.t$fire$l 

left join baandb.ttcmcs065301 tcmcs065
       on tcmcs065.t$cwoc = cisli940.t$cofc$l

left join baandb.ttccom130301 tccom130
       on tccom130.t$cadr = tcmcs065.t$cadr

left join baandb.tznfmd001301 znfmd001
        on znfmd001.t$fovn$c = tccom130.t$fovn$l

left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        max(a.t$dtoc$c) DTOC,
                        max(a.t$poco$c) 
                        keep (dense_rank last order by a.t$dtoc$c,  a.t$seqn$c)
                                        POCO
              from    baandb.tznsls410301 a
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c) znsls410_TRACKING
        on  znsls410_TRACKING.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_TRACKING.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_TRACKING.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_TRACKING.t$sqpd$c = znsls400.t$sqpd$c

where   znsls401.t$entr$c between :ENTREGA_DEV_DE and :ENTREGA_DEV_ATE
and     znsls400.t$idpo$c = 'TD'   -- Troca ou devolução
