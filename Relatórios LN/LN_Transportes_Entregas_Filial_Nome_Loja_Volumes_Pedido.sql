select  znsls401.t$entr$c                        ENTREGA,
        cisli940.t$docn$l                        NF,
        cisli940.t$seri$l                        SERIE,
        tcemm030.t$euca                          FILIAL,
        tccom130.t$fovn$l                        ENTIDADE_FISCAL_REDESPACHO,
        tccom130.t$nama                          NOME_LOJA,
        (select sum(cisli956.t$quan$l) t$quan$l
           from baandb.tcisli956301 cisli956
          where cisli956.t$fire$l = cisli940.t$fire$l)
                                                 QTD_VOLUMES_PEDIDO

  from  ( select a.t$ncia$c,
                 a.t$uneg$c,
                 a.t$entr$c,
                 a.t$orno$c,
                 a.t$eftr$c
            from baandb.tznsls401301 a
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$entr$c,
                     a.t$orno$c,
                     a.t$eftr$c ) znsls401

left join ( select a.t$slcp,
                   a.t$ortp,
                   a.t$koor,
                   a.t$slso,
                   min(a.t$fire$l) t$fire$l
            from baandb.tcisli245301 a
            group by a.t$slcp,
                     a.t$ortp,
                     a.t$koor,
                     a.t$slso ) cisli245
       on cisli245.t$slcp = 301     -- Cia
      and cisli245.t$ortp = 1       -- Ordem/Programação de venda
      and cisli245.t$koor = 3       -- Ordem de venda
      and cisli245.t$slso = znsls401.t$orno$c
 
inner join baandb.tcisli940301 cisli940
       on cisli940.t$fire$l = cisli245.t$fire$l

left join baandb.ttcemm124301 tcemm124
       on tcemm124.t$cwoc = cisli940.t$cofc$l

left join baandb.ttcemm030301 tcemm030
       on tcemm030.t$eunt = tcemm124.t$grid

left join ( select a.t$ftyp$l,
                   a.t$fovn$l,
                   min(a.t$nama) t$nama
              from baandb.ttccom130301 a
              group by a.t$ftyp$l,
                       a.t$fovn$l ) tccom130
       on tccom130.t$ftyp$l = 'PJ'
      and tccom130.t$fovn$l = substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),1,8) || '/' || 
                              substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),9,4) || '-' ||
                              substr(trim(to_char(znsls401.t$eftr$c,'00000000000000')),13,2)

 where znsls401.t$entr$c in (:ENTREGA) 
   and tcemm030.t$euca   in (:FILIAL)
   and tccom130.t$nama   in (:NOME_LOJA)
   and znsls401.t$eftr$c > 0
