select  distinct
        znfmd630.t$fili$c                                  ID_FILIAL,
        znsls400.t$idca$c                                  CANAL,
        znsls401.t$itpe$c                                  ID_TIPO_ENTREGA,
        znsls002.t$dsca$c                                  DESCR_TIPO_ENTREGA,   
        znsls401.t$uneg$c                                  ID_UNEG,
        znint002.t$desc$c                                  DESCR_UNEG,
        znsls401.t$entr$c                                  ENTREGA,
        znsls401.t$pecl$c                                  PEDIDO,
        znsls410.t$docn$c                                  NOTA,
        znsls410.t$seri$c                                  SERIE,
        OXV.NOTES1                                         ETIQUETA,
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
        cast((from_tz(to_timestamp(to_char(znsls400.t$dtem$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE) as
                                                           DT_COMPRA
from    baandb.tznfmd630301 znfmd630

inner join baandb.twhinh431301 whinh431
        on whinh431.t$worg = 1  -- Venda
       and whinh431.t$worn = znfmd630.t$orno$c

inner join baandb.tznsls004301 znsls004
        on znsls004.t$orno$c = whinh431.t$worn
       and znsls004.t$pono$c = whinh431.t$wpon

inner join baandb.tznsls401301 znsls401
        on znsls401.t$ncia$c = znsls004.t$ncia$c
       and znsls401.t$uneg$c = znsls004.t$uneg$c
       and znsls401.t$pecl$c = znsls004.t$pecl$c
       and znsls401.t$sqpd$c = znsls004.t$sqpd$c
       and znsls401.t$entr$c = znsls004.t$entr$c
       and znsls401.t$sequ$c = znsls004.t$sequ$c

inner join baandb.tznsls400301 znsls400
        on znsls400.t$ncia$c = znsls004.t$ncia$c
       and znsls400.t$uneg$c = znsls004.t$uneg$c
       and znsls400.t$pecl$c = znsls004.t$pecl$c
       and znsls400.t$sqpd$c = znsls004.t$sqpd$c

inner join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$docn$c,
                    a.t$seri$c,  
                    min(a.t$dtoc$c) t$dtoc$c,
                    min(a.t$cono$c) t$cono$c
             from baandb.tznsls410301 a
             where a.t$poco$c = 'ETR'
             group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                      a.t$docn$c,
                      a.t$seri$c ) znsls410
        on znsls410.t$ncia$c = znsls004.t$ncia$c
       and znsls410.t$uneg$c = znsls004.t$uneg$c
       and znsls410.t$pecl$c = znsls004.t$pecl$c
       and znsls410.t$sqpd$c = znsls004.t$sqpd$c
       and znsls410.t$entr$c = znsls004.t$entr$c

inner join baandb.tznint002301 znint002
        on znint002.t$ncia$c = znsls401.t$ncia$c
       and znint002.t$uneg$c = znsls401.t$uneg$c

inner join baandb.tznsls002301 znsls002
        on znsls002.t$tpen$c = znsls401.t$itpe$c

inner join baandb.ttcmcs080301 tcmcs080
        on tcmcs080.t$cfrw = znfmd630.t$cfrw$c

inner join baandb.ttccom130301 tccom130
        on tccom130.t$cadr = tcmcs080.t$cadr$l

inner join baandb.tznfmd060301 znfmd060
        on znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
       and znfmd060.t$cono$c = znfmd630.t$cono$c

left join wmwhse3.orderdetail@dl_ln_wms shd
       on substr(shd.externorderkey,5,9) = whinh431.t$shpm
      and to_char(shd.externlineno) = to_char(whinh431.t$pono) 

left join wmwhse3.orderdetailxvas@dl_ln_wms oxv
       on oxv.orderkey = shd.orderkey
      and oxv.orderlinenumber = shd.orderlinenumber

left join wmwhse3.orders@dl_ln_wms sho
       on sho.orderkey = shd.orderkey

left join wmwhse3.sku@dl_ln_wms sku
       on sku.sku = shd.sku

left join enterprise.codelkup@dl_ln_wms cl
       on upper(cl.udf1) = sho.whseid
      and cl.listname = 'SCHEMA'

where znsls410.t$dtoc$c is not null
  and oxv.notes1 is not null
  and trunc(cast((from_tz(to_timestamp(to_char(znsls410.t$dtoc$c,
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                   AT time zone 'America/Sao_Paulo') AS DATE)) 
      between trunc(sysdate) 
          and trunc(sysdate+1)
