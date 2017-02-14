select  
        znsls401.t$entr$c                        PEDIDO,
        znsls401_INSTANCIA.t$entr$c              INSTANCIA,
        cisli940.t$docn$l                        NF_ORIGINAL,
        cisli940.t$seri$l                        SERIE_ORIGINAL,
        znfmd630.t$etiq$c                        ETIQUETA,
        cast((from_tz(to_timestamp(to_char(cisli940.t$date$l,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_NF,
        cast((from_tz(to_timestamp(to_char(znsls409.t$fdat$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_FORCADO,
        cisli941.t$item$l                        ITEM,
        cisli941.t$desc$l                        ITEM_NOME,
        znsls401.t$vlun$c * znsls401.t$qtve$c    VALOR_NF,
        znsls401.t$vlfr$c                        FRETE,
        cisli941.t$amnt$l                        VALOR_TOTAL,
        tcemm030.t$euca                          FILIAL,
        DADOS_TRANSP.t$dsca                      APELIDO_TRANS,
        DADOS_TRANSP.t$fovn$l                    CNPJ_TRANSP,
        znsls410.t$poco$c                        ULTIMO_PONTO_CONTROLE,
        znmcs002.t$desc$c                        DESCR_PONTO_CONTROLE,
        cast((from_tz(to_timestamp(to_char(znsls410.t$dtoc$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_OCORRENCIA,
        znfmd640.t$ulog$c                        USUARIO_BAIXA,
        znfmd640.t$name                          NOME_USUARIO,
        case when substr(znfmd640.t$ulog$c,1,3) = 'job' then
             'Automática'
        else
             'Manual'
        end                                      BAIXA_AUTOMATICA_MANUAL,
        znfmd640.t$obsv$c                        ARQUIVO_BAIXA

from    baandb.tznsls401301 znsls401

inner join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    max(a.t$dtoc$c) t$dtoc$c,
                    max(a.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C,  a.T$SEQN$C) t$poco$c
             from baandb.tznsls410301 a
             where a.t$poco$c in ('ROU','EXT','EXP','AVA','EXF')
             group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c) znsls410
        on znsls410.t$ncia$c = znsls401.t$ncia$c
       and znsls410.t$uneg$c = znsls401.t$uneg$c
       and znsls410.t$pecl$c = znsls401.t$pecl$c
       and znsls410.t$sqpd$c = znsls401.t$sqpd$c
       and znsls410.t$entr$c = znsls401.t$entr$c

left join baandb.tznmcs002301 znmcs002
       on znmcs002.t$poco$c = znsls410.t$poco$c

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$sequ$c,
                   min(a.t$orno$c) t$orno$c,
                   min(a.t$pono$c) t$pono$c
            from baandb.tznsls004301 a
            where a.t$orig$c = 1  -- Site
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$entr$c,
                     a.t$sequ$c ) znsls004
       on znsls004.t$ncia$c = znsls401.t$ncia$c
      and znsls004.t$uneg$c = znsls401.t$uneg$c
      and znsls004.t$pecl$c = znsls401.t$pecl$c
      and znsls004.t$sqpd$c = znsls401.t$sqpd$c
      and znsls004.t$entr$c = znsls401.t$entr$c
      and znsls004.t$sequ$c = znsls401.t$sequ$c

left join ( select a.t$slcp,
                   a.t$ortp,
                   a.t$koor,
                   a.t$slso,
                   a.t$pono,
                   a.t$item,
                   a.t$chtp,
                   min(a.t$fire$l) t$fire$l,
                   min(a.t$line$l) t$line$l
            from baandb.tcisli245301 a
            group by a.t$slcp,
                     a.t$ortp,
                     a.t$koor,
                     a.t$slso,
                     a.t$pono,
                     a.t$item,
                     a.t$chtp ) cisli245
       on cisli245.t$slcp = 301     -- Cia
      and cisli245.t$ortp = 1       -- Ordem/Programação de venda
      and cisli245.t$koor = 3       -- Ordem de venda
      and cisli245.t$slso = znsls004.t$orno$c
      and cisli245.t$pono = znsls004.t$pono$c
      and cisli245.t$chtp = 10      -- Mercadorias
 
inner join baandb.tcisli940301 cisli940
        on cisli940.t$fire$l = cisli245.t$fire$l

inner join baandb.tcisli941301 cisli941
        on cisli941.t$fire$l = cisli245.t$fire$l
       and cisli941.t$line$l = cisli245.t$line$l

left join ( select a.t$orno$c,
                   a.t$pecl$c,
                   a.t$torg$c,
                   a.t$cfrw$c,
                   a.t$cono$c,
                   a.t$stat$c,
                   a.t$dtco$c,
                   a.t$fili$c,
                   min(a.t$etiq$c) t$etiq$c
            from  baandb.tznfmd630301 a
            group by a.t$orno$c,
                     a.t$pecl$c,
                     a.t$torg$c,
                     a.t$cfrw$c,
                     a.t$cono$c,
                     a.t$stat$c,
                     a.t$dtco$c,
                     a.t$fili$c) znfmd630
       on znfmd630.t$orno$c = znsls004.t$orno$c

left join ( select max(a.t$udat$c) t$udat$c,
                   max(a.t$ulog$c) t$ulog$c,
                   a.t$etiq$c, 
                   a.t$fili$c,
                   a.t$obsv$c,
                   b.t$name
            from baandb.tznfmd640301 a,
                 baandb.tttaad200000 b
            where a.t$coci$c in ('ROU','EXT','EXP','AVA','EXF')
              and a.t$tORG$C = 1
              and b.t$user = a.t$ulog$c
            group by a.t$fili$c,
                     a.t$etiq$c,
                     a.t$obsv$c,
                     b.t$name) znfmd640
       on znfmd640.t$fili$c = znfmd630.t$fili$c
      and znfmd640.t$etiq$c = znfmd630.t$etiq$c

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$pvdt$c,
                   a.t$sedt$c,
                   a.t$endt$c
            from   baandb.tznsls401301 a
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$entr$c,
                     a.t$pvdt$c,
                     a.t$sedt$c,
                     a.t$endt$c ) znsls401_INSTANCIA
       on znsls401_INSTANCIA.t$ncia$c = znsls401.t$ncia$c
      and znsls401_INSTANCIA.t$uneg$c = znsls401.t$uneg$c
      and znsls401_INSTANCIA.t$pvdt$c = znsls401.t$pecl$c
      and znsls401_INSTANCIA.t$sedt$c = znsls401.t$sqpd$c
      and znsls401_INSTANCIA.t$endt$c = znsls401.t$entr$c

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   max(a.t$fdat$c) t$fdat$c
               from baandb.tznsls409301 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c ) znsls409
       on znsls409.t$ncia$c = znsls401_INSTANCIA.t$ncia$c
      and znsls409.t$uneg$c = znsls401_INSTANCIA.t$uneg$c
      and znsls409.t$pecl$c = znsls401_INSTANCIA.t$pecl$c
      and znsls409.t$sqpd$c = znsls401_INSTANCIA.t$sqpd$c
      and znsls409.t$entr$c = znsls401_INSTANCIA.t$entr$c

left join baandb.ttcemm124301 tcemm124
       on tcemm124.t$cwoc = cisli940.t$cofc$l

left join baandb.ttcemm030301 tcemm030
       on tcemm030.t$eunt = tcemm124.t$grid

left join ( select a.t$cfrw,
                   a.t$dsca,
                   b.t$fovn$l
            from   baandb.ttcmcs080301 a,
                   baandb.ttccom130301 b
            where  b.t$cadr = a.t$cadr$l ) DADOS_TRANSP
       on DADOS_TRANSP.t$cfrw = znfmd630.t$cfrw$c

where   trunc(cast((from_tz(to_timestamp(to_char(znsls410.t$dtoc$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date))
        between :DATA_OCORRENCIA_DE
            and :DATA_OCORRENCIA_ATE
  and   znsls401.t$iitm$c = 'P'  -- Produto
