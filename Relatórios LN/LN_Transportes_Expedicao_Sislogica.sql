select  
        znfmd630.t$fili$c                                  ID_FILIAL,
        (select a.t$idca$c
         from   baandb.tznsls400301 a
         where  a.t$ncia$c = znsls401.t$ncia$c
           and  a.t$uneg$c = znsls401.t$uneg$c
           and  a.t$pecl$c = znsls401.t$pecl$c
           and  a.t$sqpd$c = znsls401.t$sqpd$c)            CANAL,
        znsls401.t$itpe$c                                  ID_TIPO_ENTREGA,
        znsls002.t$dsca$c                                  DESCR_TIPO_ENTREGA,   
        znsls401.t$uneg$c                                  ID_UNEG,
        znint002.t$desc$c                                  DESCR_UNEG,
        znsls401.t$entr$c                                  ENTREGA,
        znsls401.t$pecl$c                                  PEDIDO,
        znsls410.t$docn$c                                  NOTA,
        znsls410.t$seri$c                                  SERIE,
        nvl(OXV.NOTES1, znfmd630.t$etiq$c)                 ETIQUETA,
        znfmd060.t$cdes$c                                  CONTRATO,
        replace(tccom130.t$fovn$l,'/','')                  CNPJ,
        znfmd630.t$cfrw$c || ' - ' || tcmcs080.t$dsca      TRANSPORTADORA,   
        tcmcs080.t$SEAK  APELIDO,   
        cast((from_tz(to_timestamp(to_char(znsls401.t$dtep$c - znsls401.t$pzcd$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)
                                                           DT_LIMITE,
        znfmd630.t$ncar$c                                  CARGA,
        cast((from_tz(to_timestamp(to_char(znsls410.t$dtoc$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)
                                                           DT_ETR,    
        cast((from_tz(to_timestamp(to_char(znsls401.t$dtep$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)
                                                           DT_PROMET,
        case when trunc(znfmd630.t$dtpe$c) <= to_date('01/01/1970','DD/MM/YYYY')
             then null
        else
             cast((from_tz(to_timestamp(to_char(znfmd630.t$dtpe$c,
                   'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') AS DATE)
        end                                                DATA_PREVISTA,      
        case when trunc(znfmd630.t$dtco$c) <= to_date('01/01/1970','DD/MM/YYYY')
             then null
        else
             cast((from_tz(to_timestamp(to_char(znfmd630.t$dtco$c,
                   'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') AS DATE)
        end                                                DATA_CORRIGIDA,
        (select cast((from_tz(to_timestamp(to_char(a.t$dtem$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)
         from   baandb.tznsls400301 a
         where  a.t$ncia$c = znsls401.t$ncia$c
           and  a.t$uneg$c = znsls401.t$uneg$c
           and  a.t$pecl$c = znsls401.t$pecl$c
           and  a.t$sqpd$c = znsls401.t$sqpd$c)            DT_COMPRA

from    ( select a.t$fili$c,
                 a.t$cfrw$c,
                 a.t$cono$c,
                 a.t$orno$c,
                 a.t$ncar$c,
                 a.t$dtpe$c,
                 a.t$dtco$c,
                 a.t$pecl$c,
                 max(a.t$etiq$c) t$etiq$c
          from   baandb.tznfmd630301 a
          group by a.t$fili$c,
                   a.t$cfrw$c,
                   a.t$cono$c,
                   a.t$orno$c,
                   a.t$ncar$c,
                   a.t$dtpe$c,
                   a.t$dtco$c,
                   a.t$pecl$c) znfmd630

inner join baandb.tznfmd060301 znfmd060
        on znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
       and znfmd060.t$cono$c = znfmd630.t$cono$c

inner join baandb.ttcmcs080301 tcmcs080
        on tcmcs080.t$cfrw = znfmd630.t$cfrw$c

inner join baandb.ttccom130301 tccom130
        on tccom130.t$cadr = tcmcs080.t$cadr$l

inner join ( select a.t$worg,
                    a.t$worn,
                    a.t$shpm
             from   baandb.twhinh431301 a
             group by a.t$worg,
                      a.t$worn,
                      a.t$shpm) whinh431
        on whinh431.t$worg = 1  -- Venda
       and whinh431.t$worn = znfmd630.t$orno$c

inner join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$itpe$c,
                    a.t$orno$c,
                    a.t$dtep$c,
                    a.t$pzcd$c
             from   baandb.tznsls401301 a
             group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                      a.t$itpe$c,
                      a.t$orno$c,
                      a.t$dtep$c,
                      a.t$pzcd$c ) znsls401
        on znsls401.t$orno$c = whinh431.t$worn

inner join baandb.tznint002301 znint002
        on znint002.t$ncia$c = znsls401.t$ncia$c
       and znint002.t$uneg$c = znsls401.t$uneg$c

inner join baandb.tznsls002301 znsls002
        on znsls002.t$tpen$c = znsls401.t$itpe$c

inner join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$docn$c,
                    a.t$seri$c,  
                    min(a.t$dtoc$c) t$dtoc$c,
                    min(a.t$poco$c) KEEP (DENSE_RANK FIRST ORDER BY a.T$DTOC$C,  a.T$SEQN$C) t$poco$c
             from baandb.tznsls410301 a
             where a.t$poco$c = 'ETR'
             group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                      a.t$docn$c,
                      a.t$seri$c) znsls410
        on znsls410.t$ncia$c = znsls401.t$ncia$c
       and znsls410.t$uneg$c = znsls401.t$uneg$c
       and znsls410.t$pecl$c = znsls401.t$pecl$c
       and znsls410.t$sqpd$c = znsls401.t$sqpd$c
       and znsls410.t$entr$c = znsls401.t$entr$c

left join wmwhse3.orderdetail@dl_ln_wms shd
       on substr(shd.externorderkey,5,9) = whinh431.t$shpm

left join wmwhse3.orderdetailxvas@dl_ln_wms oxv
       on oxv.orderkey = shd.orderkey
      and oxv.orderlinenumber = shd.orderlinenumber
      
where znsls410.t$dtoc$c is not null
  and trunc(cast((from_tz(to_timestamp(to_char(znsls410.t$dtoc$c,
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                   AT time zone 'America/Sao_Paulo') AS DATE)) 
      between :DATA_INI
          and :DATA_FIM
