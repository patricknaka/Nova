select  
        znfmd630.t$fili$c                                  ID_FILIAL,
        znsls400.t$idca$c                                  CANAL,
        znsls401.t$itpe$c                                  ID_TIPO_ENTREGA,
        znsls002.t$dsca$c                                  DESCR_TIPO_ENTREGA,   
        znsls401.t$uneg$c                                  ID_UNEG,
        znint002.t$desc$c                                  DESCR_UNEG,
        znsls401.t$entr$c                                  ENTREGA,
        znsls401.t$pecl$c                                  PEDIDO,
        cisli940.t$docn$l                                  NOTA,
        cisli940.t$seri$l                                  SERIE,
        nvl(oxv.notes1, znfmd630.t$etiq$c)                 ETIQUETA,
        znfmd060.t$cdes$c                                  CONTRATO,
        replace(tccom130.t$fovn$l,'/','')                  CNPJ,
        znfmd630.t$cfrw$c || ' - ' || tcmcs080.t$dsca      TRANSPORTADORA,   
        tcmcs080.t$seak                                    APELIDO,   
        ( select a.t$creg$c
            from baandb.tznfmd062601 a 
           where a.t$cfrw$c = znfmd630.t$cfrw$c
             and a.t$cono$c = znfmd630.t$cono$c
             and a.t$cepd$c <= znsls400.t$cepf$c
             and a.t$cepa$c >= znsls400.t$cepf$c
             and rownum = 1)                               CAPITAL_INTERIOR,
        nvl(shd.originalqty,znsls401.t$qtve$c)             QTD_VOL,
        nvl(shd.product_cube, ( select sum(a.t$quan$l) t$quan$l
                                  from baandb.tcisli956601 a
                                 where a.t$fire$l = cisli940.t$fire$l ))
                                                           VOLUME,
        nvl(shd.product_weight,cisli940.t$nwgt$l)          PESO,
        cisli940.t$gamt$l                                  VL_SEM_FRETE,
        znfmd630.t$vlfc$c                                  FRETE,
        ''                                                 FRETE_MODIF,
        cisli940.t$fght$l                                  FRETE_SITE,
        cisli940.t$amnt$l                                  VL_TOTAL,
        cast((from_tz(to_timestamp(to_char(znsls401.t$dtep$c - znsls401.t$pzcd$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)  DT_LIMITE,
        znsls401.t$pzcd$c                                  PZ_CD,
        znsls401.t$pztr$c                                  PZ_TRANSIT,
        znfmd630.t$ncar$c                                  CARGA,
        cast((from_tz(to_timestamp(to_char(znfmd640.t$udat$c,
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
        cast(replace(own_mis.filtro_mis(znsls400.t$nomf$c),';','')
             as varchar(120))                              CLIENTE,
        znsls400.t$fovn$c                                  CPF_CNPJ,
        cast(replace(own_mis.filtro_mis(znsls400.t$logf$c),';','')
             as varchar(180))                              ENDERECO,
        znsls400.t$numf$c                                  NUMERO,
        cast(replace(own_mis.filtro_mis(znsls400.t$baif$c),';','')
             as varchar(90))                               BAIRRO,
        cast(replace(own_mis.filtro_mis(znsls400.t$reff$c),';','')
             as varchar(300))                              REFERENCIA,
        znsls400.t$cepf$c                                  CEP,
        znsls400.t$cidf$c                                  CIDADE,
        znsls400.t$uffa$c                                  UF,
        znsls400.t$telf$c                                  TELEFONE_1,
        znsls400.t$te1f$c                                  TELEFONE_2,
        znsls400.t$te2f$c                                  TELEFONE_3,
        znsls400.t$emaf$c                                  EMAIL,
        case when znsls401.t$idpa$c = '1' then 'Manhã'
             when znsls401.t$idpa$c = '2' then 'Tarde'
             when znsls401.t$idpa$c = '3' then 'Noite'
        else ''
        end                                                PERIODO,
        cast((from_tz(to_timestamp(to_char(znsls400.t$dtem$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)  DT_COMPRA

  from ( select a.t$pecl$c,
                b.t$fili$c,
                b.t$etiq$c,
                b.t$udat$c                
           from baandb.tznfmd630601 a
     inner join baandb.tznfmd640601 b
             on b.t$fili$c = a.t$fili$c
            and b.t$etiq$c = a.t$etiq$c
          where b.t$coct$c = 'ETR'
            and b.t$torg$c = 1
       group by a.t$pecl$c,
                b.t$fili$c,
                b.t$etiq$c,
                b.t$udat$c ) znfmd640

inner join baandb.tznfmd630601 znfmd630
        on znfmd630.t$fili$c = znfmd640.t$fili$c
       and znfmd630.t$etiq$c = znfmd640.t$etiq$c
       and znfmd630.t$pecl$c = znfmd640.t$pecl$c

inner join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$orno$c
               from baandb.tznsls004601 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$orno$c ) znsls004
        on znsls004.t$orno$c = znfmd630.t$orno$c

inner join baandb.tznfmd060601 znfmd060
        on znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
       and znfmd060.t$cono$c = znfmd630.t$cono$c

inner join baandb.ttcmcs080601 tcmcs080
        on tcmcs080.t$cfrw = znfmd630.t$cfrw$c

inner join baandb.ttccom130601 tccom130
        on tccom130.t$cadr = tcmcs080.t$cadr$l

inner join baandb.tcisli940601 cisli940
        on cisli940.t$fire$l = znfmd630.t$fire$c
       and cisli940.t$fdty$l != 14

inner join ( select a.t$worg,
                    a.t$worn,
                    a.t$shpm
             from   baandb.twhinh431601 a
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
                    a.t$orno$c,
                    a.t$itpe$c,
                    a.t$pzcd$c,
                    a.t$pztr$c,
                    min(a.t$dtep$c) t$dtep$c,
                    min(a.t$idpa$c) t$idpa$c,
                    sum(a.t$qtve$c) t$qtve$c
               from baandb.tznsls401601 a
              where a.t$iitm$c = 'P'
             group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                      a.t$orno$c,
                      a.t$itpe$c,
                      a.t$pzcd$c,
                      a.t$pztr$c) znsls401
        on znsls401.t$ncia$c = znsls004.t$ncia$c
       and znsls401.t$uneg$c = znsls004.t$uneg$c
       and znsls401.t$pecl$c = znsls004.t$pecl$c
       and znsls401.t$sqpd$c = znsls004.t$sqpd$c
       and znsls401.t$entr$c = znsls004.t$entr$c

inner join baandb.tznsls400601 znsls400
        on znsls400.t$ncia$c = znsls401.t$ncia$c
       and znsls400.t$uneg$c = znsls401.t$uneg$c
       and znsls400.t$pecl$c = znsls401.t$pecl$c
       and znsls400.t$sqpd$c = znsls401.t$sqpd$c

left join baandb.tznint002601 znint002
       on znint002.t$ncia$c = znsls401.t$ncia$c
      and znint002.t$uneg$c = znsls401.t$uneg$c

left join baandb.tznsls002601 znsls002
       on znsls002.t$tpen$c = znsls401.t$itpe$c

left join wmwhse3.orderdetail@dl_ln_wms shd
       on substr(shd.externorderkey,5,9) = whinh431.t$shpm

left join wmwhse3.orderdetailxvas@dl_ln_wms oxv
       on oxv.orderkey = shd.orderkey
      and oxv.orderlinenumber = shd.orderlinenumber
      
where trunc(cast((from_tz(to_timestamp(to_char(znfmd640.t$udat$c,
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                   AT time zone 'America/Sao_Paulo') AS DATE))
      between :DATA_INI
          and :DATA_FIM
