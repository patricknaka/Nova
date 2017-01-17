select  
        ( select znfmd001.t$fili$c
          from   baandb.tznfmd001301 znfmd001,
                 baandb.ttcmcs065301 tcmcs065,
                 baandb.ttccom130301 tccom130_filial
          where tcmcs065.t$cwoc = tdsls400.t$cofc
            and tccom130_filial.t$cadr = tcmcs065.t$cadr
            and znfmd001.t$fovn$c = tccom130_filial.t$fovn$l )
                                                           FILIAL,
        tcmcs031.t$dsca                                    MARCA,
        cast((from_tz(to_timestamp(to_char(znfmd640_ETR.DATA_OCORRENCIA,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_EXPEDICAO,
        znsls401.t$pecl$c                                  PEDIDO,
        znsls401.t$entr$c                                  ENTREGA,
        znsls002.t$dsca$c                                  TIPO_ENTREGA,
        tccom130t.t$dsca                                   TRANSPORTADOR,
        znsls401.t$ufen$c                                  UF,
        case when regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '') is null
             then '00000000000000'
             when length(regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')) < 11
             then '00000000000000'
        else regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')
        end                                                CNPJ_TRANSPORTADORA,
        cast((from_tz(to_timestamp(to_char(tdsls400.t$odat,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_COMPRA,
        ( select cast((from_tz(to_timestamp(to_char(max(tdsls401.t$ddta),
                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
          from  baandb.ttdsls401301 tdsls401
          where tdsls401.t$orno = tdsls400.t$orno )        DATA_LIM_EXPEDICAO,
        ( select cast((from_tz(to_timestamp(to_char(max(tdsls401.t$prdt),
                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
          from  baandb.ttdsls401301 tdsls401
          where tdsls401.t$orno = tdsls400.t$orno )        DATA_PROMETIDA,
        case when trunc(znfmd630.t$dtpe$c) = '01/01/1970'
             then null
        else cast((from_tz(to_timestamp(to_char(znfmd630.t$dtpe$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date)
        end                                                DATA_PREVISTA_ENTREGA,
        case when trunc(znfmd630.t$dtco$c) <= to_date('01/01/1970','DD/MM/YYYY')
             then null
        else cast((from_tz(to_timestamp(to_char(znfmd630.t$dtco$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date)
        end                                                DATA_CORRIGIDA,
        znfmd630.t$cono$c                                  CONTRATO,
        znfmd060.t$cdes$c                                  DESCRICAO_DO_CONTRATO,
        znfmd640_FIRST.t$coci$c                            PRIMEIRA_OCORRENCIA,
        znfmd030_FIRST.t$dsci$c                            PRIMEIRA_DESC_OCORRENCIA,
        cast((from_tz(to_timestamp(to_char(znfmd640_FIRST.t$date$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date)
                                                           PRIMEIRA_DATA_OCORRENCIA,
        nvl(znsls410_F.t$poco$c,znsls410.t$poco$c)         ULTIMA_OCORRENCIA,
        nvl(znfmd030_F.t$dsci$c,nvl(znfmd030.t$dsci$c,znmcs002.t$desc$c))
                                                           ULTIMA_DESC_OCORRENCIA,
        nvl(cast((from_tz(to_timestamp(to_char(znsls410_F.t$dtoc$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date),
            cast((from_tz(to_timestamp(to_char(znsls410.t$dtoc$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date))        
                                                           ULTIMA_DATA_OCORRENCIA
from     (  select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   min(a.t$sequ$c) t$sequ$c,
                   a.t$orno$c,
                   a.t$ufen$c,
                   a.t$itpe$c,
                   a.t$dtep$c
            from baandb.tznsls401301 a
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$entr$c,
                     a.t$orno$c,
                     a.t$ufen$c,
                     a.t$itpe$c,
                     a.t$dtep$c ) znsls401

left join ( select a.t$fili$c,
                 a.t$pecl$c,
                 a.t$orno$c,
                 a.t$cfrw$c,
                 a.t$dtpe$c,
                 a.t$dtco$c,
                 a.t$cono$c,
                 a.t$fire$c,
                 max(a.t$etiq$c) t$etiq$c
          from baandb.tznfmd630301 a 
          group by a.t$fili$c,
                   a.t$pecl$c,
                   a.t$orno$c,
                   a.t$cfrw$c,
                   a.t$dtpe$c,
                   a.t$dtco$c,
                   a.t$cono$c,
                   a.t$fire$c ) znfmd630
       on znfmd630.t$pecl$c = to_char(znsls401.t$entr$c)

left join baandb.tcisli940301 cisli940
       on cisli940.t$fire$l = znfmd630.t$fire$c

left join ( select max(a.t$udat$c)       DATA_OCORRENCIA,
                   a.t$etiq$c, 
                   a.t$fili$c
            from baandb.tznfmd640301 a
            where a.t$coct$c = 'ETR'
              and a.T$TORG$C = 1
            group by a.t$fili$c, a.t$etiq$c ) znfmd640_ETR
       on znfmd640_ETR.t$fili$c = znfmd630.t$fili$c
      and znfmd640_ETR.t$etiq$c = znfmd630.t$etiq$c

left join baandb.ttdsls400301 tdsls400
       on tdsls400.t$orno = znsls401.t$orno$c

left join baandb.ttccom130301 tccom130
       on tccom130.t$cadr = tdsls400.t$stad

left join baandb.tznint002301 znint002
       on znint002.t$ncia$c = znsls401.t$ncia$c
      and znint002.t$uneg$c = znsls401.t$uneg$c

left join baandb.ttcmcs031301 tcmcs031
       on tcmcs031.t$cbrn = znint002.t$cbrn$c

left join baandb.tznsls002301 znsls002
       on znsls002.t$tpen$c = NVL(znsls401.t$itpe$c, 16)

left join baandb.tznfmd060301 znfmd060
       on znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
      and znfmd060.t$cono$c = znfmd630.t$cono$c

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   max(a.t$dtoc$c) t$dtoc$c,
                   max(a.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C,  a.T$SEQN$C) t$poco$c
               from baandb.tznsls410301 a,
                    baandb.tznfmd030301 b
            where  b.t$ocin$c = a.t$poco$c
              and  b.t$finz$c = 1
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$entr$c) znsls410_F
       on znsls410_F.t$ncia$c = znsls401.t$ncia$c
      and znsls410_F.t$uneg$c = znsls401.t$uneg$c
      and znsls410_F.t$pecl$c = znsls401.t$pecl$c
      and znsls410_F.t$sqpd$c = znsls401.t$sqpd$c
      and znsls410_F.t$entr$c = znsls401.t$entr$c

left join baandb.tznfmd030301 znfmd030_F
       on znfmd030_F.t$ocin$c = znsls410_F.t$poco$c

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   max(a.t$dtoc$c) t$dtoc$c,
                   max(a.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C,  a.T$SEQN$C) t$poco$c
            from baandb.tznsls410301 a
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

left join baandb.tznfmd030301 znfmd030
       on znfmd030.t$ocin$c = znsls410.t$poco$c

left join baandb.tznmcs002301 znmcs002
       on znmcs002.t$poco$c = znsls410.t$poco$c

left join ( select znfmd640.t$fili$c,
                   znfmd640.t$etiq$c,
                   min(znfmd640.t$date$c) t$date$c,
                   min(znfmd640.t$coci$c) KEEP (DENSE_RANK FIRST ORDER BY t$date$c) t$coci$c
            from baandb.tznfmd640301 znfmd640
            where znfmd640.t$coci$c in ('CHU',
                                        'CME',
                                        'DDL',
                                        'DIE',
                                        'EA1',
                                        'EA2',
                                        'EA3',
                                        'ETL',
                                        'FIS',
                                        'PNR',
                                        'PRE',
                                        'RET',
                                        'SEF')
            group by znfmd640.t$fili$c,
                     znfmd640.t$etiq$c ) znfmd640_FIRST 
       on znfmd640_FIRST.t$fili$c = znfmd630.t$fili$c
      and znfmd640_FIRST.t$etiq$c = znfmd630.t$etiq$c

left join baandb.tznfmd030301 znfmd030_FIRST
       on znfmd030_FIRST.t$ocin$c = znfmd640_FIRST.t$coci$c
       
left join ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                   tcmcs080.t$dsca,
                   tcmcs080.t$cfrw
            from   baandb.ttcmcs080301 tcmcs080
            inner join baandb.ttccom130301 tccom130
                    on tccom130.t$cadr = tcmcs080.t$cadr$l
            where tccom130.t$ftyp$l = 'PJ' ) tccom130t
       on tccom130t.t$cfrw = znfmd630.t$cfrw$c

where    NVL( (case when trunc(znfmd630.t$dtco$c) <= to_date('01/01/1970','DD/MM/YYYY')
                  then null
              else trunc(cast((from_tz(to_timestamp(to_char(znfmd630.t$dtco$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date))end),
              trunc(cast((from_tz(to_timestamp(to_char(znsls401.t$dtep$c,
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                       AT time zone 'America/Sao_Paulo') as date)))             
          between :DATA_DE
              and :DATA_ATE
  and    cisli940.t$fdty$l != 14  -- Retorno mercadoria de cliente
