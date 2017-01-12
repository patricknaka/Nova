select  
        znfmd630.t$fili$c                                  FILIAL,
        tcmcs031.t$dsca                                    MARCA,
        cast((from_tz(to_timestamp(to_char(znfmd640_ETR.DATA_OCORRENCIA,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_EXPEDICAO,
        znfmd630.t$docn$c                                  NOTA_FISCAL,
        znfmd630.t$seri$c                                  SERIE,
        cast((from_tz(to_timestamp(to_char(cisli940.t$date$l,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_EMISSAO_NF,
        znsls401.t$pecl$c                                  PEDIDO,
        znfmd630.t$pecl$c                                  ENTREGA,
        tdsls400.t$orno                                    ORDEM_DE_VENDA,
        znfmd630.t$qvol$c                                  QTDE_VOLUMES,
        znsls002.t$dsca$c                                  TIPO_ENTREGA,
        cisli940.t$amnt$l                                  VALOR_TOTAL_NF,
        tccom130t.t$dsca                                   TRANSPORTADOR,
        znsls401.t$cepe$c                                  CEP,
        znsls401.t$cide$c                                  CIDADE,
        znsls401.t$ufen$c                                  UF,
        case when regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '') is null
             then '00000000000000'
             when length(regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')) < 11
             then '00000000000000'
        else regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')
        end                                                CNPJ_TRANSPORTADORA,
       ( select znfmd061.t$dzon$c
           from baandb.tznfmd062301 znfmd062,
                baandb.tznfmd061301 znfmd061
          where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c
            and znfmd062.t$cono$c = znfmd630.t$cono$c
            and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c
            and znfmd061.t$cono$c = znfmd062.t$cono$c
            and znfmd061.t$creg$c = znfmd062.t$creg$c
            and tccom130.t$pstc between znfmd062.t$cepd$c
                                    and znfmd062.t$cepa$c
            and rownum = 1 )                               REGIAO,
        znfmd630.t$ncar$c                                  NRO_CARGA,
        znfmd630.t$etiq$c                                  ETIQUETA,
        cast((from_tz(to_timestamp(to_char(CRIACAO_WMS.DATA_OCORRENCIA,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_WMS,
        znsls401.t$pzcd$c                                  PRAZO_CD,
        cast((from_tz(to_timestamp(to_char(tdsls401.t$odat,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_COMPRA,
        case when trunc(znsls401.t$dtap$c) = '01/01/1970'
             then null 
        else cast((from_tz(to_timestamp(to_char(znsls401.t$dtap$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date)
        end                                                DATA_APROV_PAGTO,
        cast((from_tz(to_timestamp(to_char(tdsls401.t$ddta,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_LIM_EXPEDICAO,
        cast((from_tz(to_timestamp(to_char(tdsls401.t$prdt,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_PROMETIDA,
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
        znfmd640.t$coci$c                                  ULTIMA_OCORRENCIA,
        znfmd640.t$desc$c                                  OCORRENCIA,
        znfmd640.t$date$c                                  DATA_OCORRENCIA,
        own_mis.filtro_mis(znsls400.t$nomf$c)              NOME_DESTINATARIO,
        znsng108.t$pvvv$c                                  PEDIDO_VIA_VAREJO,
        cast((from_tz(to_timestamp(to_char(znsng108.t$dhpr$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_VIA_VAREJO

from    baandb.tznsls401301 znsls401

inner join baandb.tznfmd630301 znfmd630
        on znfmd630.t$pecl$c = to_char(znsls401.t$entr$c)

left join ( select max(znfmd640_ETR.t$udat$c)       DATA_OCORRENCIA,
                   max(znfmd640_ETR.t$etiq$c) 
                   KEEP (DENSE_RANK LAST ORDER BY znfmd640_ETR.t$udat$c ) t$etiq$c,
                   znfmd640_ETR.t$fili$c
            from baandb.tznfmd640301 znfmd640_ETR
            where znfmd640_ETR.t$coct$c = 'ETR'
              and znfmd640_ETR.T$TORG$C = 1
            group by znfmd640_ETR.t$fili$c ) znfmd640_ETR
       on znfmd640_ETR.t$fili$c = znfmd630.t$fili$c
      and znfmd640_ETR.t$etiq$c = znfmd630.t$etiq$c

left join baandb.tcisli940301 cisli940
       on cisli940.t$fire$l = znfmd630.t$fire$c

left join baandb.tznsls400301 znsls400
       on znsls400.t$ncia$c = znsls401.t$ncia$c
      and znsls400.t$uneg$c = znsls401.t$uneg$c
      and znsls400.t$pecl$c = znsls401.t$pecl$c
      and znsls400.t$sqpd$c = znsls401.t$sqpd$c

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

left join ( select znsng108.t$orln$c,
                   znsng108.t$pvvv$c,
                   min(znsng108.t$dhpr$c) t$dhpr$c
            from   baandb.tznsng108301 znsng108
            where trim(znsng108.t$pvvv$c) is not null
            group by znsng108.t$orln$c,
                     znsng108.t$pvvv$c ) znsng108
       on znsng108.t$orln$c = znsls401.t$orno$c

left join ( select znfmd640.t$fili$c,
                   znfmd640.t$etiq$c,
                   znmcs002.t$desc$c,
                   max(znfmd640.t$coci$c) t$coci$c,
                   cast((from_tz(to_timestamp(to_char(max(znfmd640.t$date$c),
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') as date)  t$date$c
            from baandb.tznfmd640301 znfmd640
            inner join baandb.tznmcs002301 znmcs002
                    on znmcs002.t$poco$c = znfmd640.t$coci$c
            where (znfmd640.t$date$c, znfmd640.t$udat$c) = 
                  ( select max(oc.t$date$c) t$date$c, 
                           max(oc.t$udat$c)
                           KEEP (DENSE_RANK LAST ORDER BY oc.t$date$c ) t$udat$c
                    from baandb.tznfmd640301 oc
                    where oc.t$fili$c = znfmd640.t$fili$c
                      and oc.t$etiq$c = znfmd640.t$etiq$c )
            group by znfmd640.t$fili$c,
                     znfmd640.t$etiq$c,
                     znmcs002.t$desc$c ) znfmd640 
       on znfmd640.t$fili$c = znfmd630.t$fili$c
      and znfmd640.t$etiq$c = znfmd630.t$etiq$c

left join ( select znsls410.t$poco$c      CODE_OCORRENCIA,
                   znsls410.t$dtoc$c      DATA_OCORRENCIA,
                   znsls410.t$ncia$c,
                   znsls410.t$uneg$c,
                   znsls410.t$pecl$c,
                   znsls410.t$sqpd$c,
                   znsls410.t$entr$c
               from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'WMS'
           group by znsls410.t$poco$c,
                    znsls410.t$dtoc$c,
                    znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    znsls410.t$entr$c ) CRIACAO_WMS
       on CRIACAO_WMS.t$ncia$c = znsls401.t$ncia$c
      and CRIACAO_WMS.t$uneg$c = znsls401.t$uneg$c
      and CRIACAO_WMS.t$pecl$c = znsls401.t$pecl$c
      and CRIACAO_WMS.t$sqpd$c = znsls401.t$sqpd$c
      and CRIACAO_WMS.t$entr$c = znsls401.t$entr$c

left join ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                   tcmcs080.t$dsca,
                   tcmcs080.t$cfrw
            from   baandb.ttcmcs080301 tcmcs080
            inner join baandb.ttccom130301 tccom130
                    on tccom130.t$cadr = tcmcs080.t$cadr$l
            where tccom130.t$ftyp$l = 'PJ' ) tccom130t
       on tccom130t.t$cfrw = znfmd630.t$cfrw$c

left join ( select case when trunc(max(tdsls401.t$prdt)) <= to_date('01/01/1970','DD/MM/YYYY')
                        then null
                   else   cast((from_tz(to_timestamp(to_char(max(tdsls401.t$prdt), 'DD-MON-YYYY HH24:MI:SS'),
                                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') as date)
                   end                                                t$prdt,
                    
                   case when trunc(max(tdsls401.t$ddta)) <= to_date('01/01/1970','DD/MM/YYYY')
                        then null
                   else   cast((from_tz(to_timestamp(to_char(max(tdsls401.t$ddta), 'DD-MON-YYYY HH24:MI:SS'),
                                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') as date)
                   end                                                t$ddta,
                    
                   cast((from_tz(to_timestamp(to_char(max(tdsls401.t$odat),
                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                           AT time zone 'America/Sao_Paulo') as date) t$odat,
                   tdsls401.t$orno
            from baandb.ttdsls401301  tdsls401
            group by tdsls401.t$orno ) tdsls401
       on tdsls401.t$orno = tdsls400.t$orno

where   ( trunc(cast((from_tz(to_timestamp(to_char(znfmd630.t$dtco$c,
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                       AT time zone 'America/Sao_Paulo') as date))
          between :DATA_CORRIGIDA_DE
              and :DATA_CORRIGIDA_ATE  or
          trunc(cast((from_tz(to_timestamp(to_char(tdsls401.t$prdt,
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                       AT time zone 'America/Sao_Paulo') as date))
          between :DATA_CORRIGIDA_DE
              and :DATA_CORRIGIDA_ATE )
