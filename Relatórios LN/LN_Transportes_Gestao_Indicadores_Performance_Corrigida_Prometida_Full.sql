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
        znfmd630.t$docn$c                                  NOTA_FISCAL,
        znfmd630.t$seri$c                                  SERIE,
        cast((from_tz(to_timestamp(to_char(cisli940.t$date$l,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_EMISSAO_NF,
        znsls401.t$pecl$c                                  PEDIDO,
        znsls401.t$entr$c                                  ENTREGA,
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
        znfmd062.t$creg$c                                  REGIAO,
        znfmd630.t$ncar$c                                  NRO_CARGA,
        znfmd630.t$etiq$c                                  ETIQUETA,
        cast((from_tz(to_timestamp(to_char(CRIACAO_WMS.DATA_OCORRENCIA,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_WMS,
        znsls401.t$pzcd$c                                  PRAZO_CD,
        cast((from_tz(to_timestamp(to_char(tdsls400.t$odat,
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
	              AT time zone 'America/Sao_Paulo') as date)
	
                                                            DATA_LIM_EXPEDICAO,
        cast((from_tz(to_timestamp(to_char(tdsls401.t$prdt,
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') as date)

                                                            DATA_PROMETIDA,
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
        nvl(znfmd640_F.t$coci$c,
	nvl(znfmd640.t$coci$c,
	nvl(znsls410_F.t$poco$c,
            znsls410.t$poco$c)))                           ULTIMA_OCORRENCIA,
        nvl(znfmd030_FTRA.t$dsci$c,
        nvl(znfmd030_TRA.t$dsci$c,
        nvl(znmcs002_TRA.t$desc$c,
        nvl(znfmd030_F.t$dsci$c,
        nvl(znfmd030.t$dsci$c,
            znmcs002.t$desc$c)))))                         ULTIMA_DESC_OCORRENCIA,
        nvl(cast((from_tz(to_timestamp(to_char(znfmd640_F.t$date$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date),
        nvl(cast((from_tz(to_timestamp(to_char(znfmd640.t$date$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date),
        nvl(cast((from_tz(to_timestamp(to_char(znsls410_F.t$dtoc$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date),
            cast((from_tz(to_timestamp(to_char(znsls410.t$dtoc$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date))))
                                                           ULTIMA_DATA_OCORRENCIA,
        own_mis.filtro_mis(znsls400.t$nomf$c)              NOME_DESTINATARIO,
        znsng108.t$pvvv$c                                  PEDIDO_VIA_VAREJO,
        cast((from_tz(to_timestamp(to_char(znsng108.t$dhpr$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_VIA_VAREJO,
        PONTO_ETL.DATA_OCORRENCIA                          DATA_PONTO_ETL,
        own_mis.filtro_mis(znsls401.t$obet$c)              ETIQUETA_TRANSPORTADORA

from (select       a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   min(a.t$sequ$c) t$sequ$c,
                   a.t$orno$c,
                   a.t$ufen$c,
                   a.t$itpe$c,
                   a.t$dtep$c,
                   a.t$dtap$c,
                   a.t$pzcd$c,
                   a.t$cide$c,
                   a.t$cepe$c,
                   a.t$obet$c
            from baandb.tznsls401301 a
            where a.t$iitm$c = 'P'
              and a.t$qtve$c > 0
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$entr$c,
                     a.t$orno$c,
                     a.t$ufen$c,
                     a.t$itpe$c,
                     a.t$dtep$c,
                     a.t$dtap$c,
                     a.t$pzcd$c,
                     a.t$cide$c,
                     a.t$cepe$c,
                     a.t$obet$c ) znsls401
                     
left join ( select a.t$fili$c,
                 a.t$pecl$c,
                 a.t$orno$c,
                 a.t$cfrw$c,
                 a.t$dtpe$c,
                 a.t$dtco$c,
                 a.t$cono$c,
                 a.t$fire$c,
                 a.t$ncar$c,
                 a.t$qvol$c,
                 a.t$docn$c,
                 a.t$seri$c,
                 max(a.t$etiq$c) t$etiq$c
          from baandb.tznfmd630301 a
          where a.t$torg$c = 1    --vendas
          group by a.t$fili$c,
                   a.t$pecl$c,
                   a.t$orno$c,
                   a.t$cfrw$c,
                   a.t$dtpe$c,
                   a.t$dtco$c,
                   a.t$cono$c,
                   a.t$fire$c,
                   a.t$ncar$c,
                   a.t$qvol$c,
                   a.t$docn$c,
                   a.t$seri$c) znfmd630
       on znfmd630.t$pecl$c = to_char(znsls401.t$entr$c)
       
inner join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
--                    a.t$sequ$c,
                    max(a.t$orno$c) t$orno$c,
                    min(a.t$pono$c) t$pono$c
             from baandb.tznsls004301 a 
             group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c ) znsls004
        on znsls004.t$ncia$c = znsls401.t$ncia$c
       and znsls004.t$uneg$c = znsls401.t$uneg$c
       and znsls004.t$pecl$c = znsls401.t$pecl$c
       and znsls004.t$sqpd$c = znsls401.t$sqpd$c
       and znsls004.t$entr$c = znsls401.t$entr$c
       
inner join baandb.ttdsls400301 tdsls400
        on tdsls400.t$orno = znsls004.t$orno$c

inner join baandb.ttdsls401301 tdsls401
        on tdsls401.t$orno = znsls004.t$orno$c
       and tdsls401.t$pono = znsls004.t$pono$c
       and tdsls401.t$sqnb = 0

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
       on tdsls400.t$orno = znfmd630.t$orno$c

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

left join baandb.tznsls400301 znsls400
       on znsls400.t$ncia$c = znsls401.t$ncia$c
      and znsls400.t$uneg$c = znsls401.t$uneg$c
      and znsls400.t$pecl$c = znsls401.t$pecl$c
      and znsls400.t$sqpd$c = znsls401.t$sqpd$c

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

left join ( select a.t$fili$c,
                   a.t$etiq$c,
                   max(a.t$date$c) t$date$c,
                   max(a.t$coci$c) keep (dense_rank last order by t$date$c) t$coci$c
            from baandb.tznfmd640301 a,
                 baandb.tznfmd030301 b
            where  b.t$ocin$c = a.t$coci$c
              and  b.t$finz$c = 1
              and  a.t$torg$c = 1     --vendas
            group by a.t$fili$c,
                     a.t$etiq$c ) znfmd640_F
       on znfmd640_F.t$fili$c = znfmd630.t$fili$c
      and znfmd640_F.t$etiq$c = znfmd630.t$etiq$c

left join baandb.tznfmd030301 znfmd030_FTRA
       on znfmd030_FTRA.t$ocin$c = znfmd640_F.t$coci$c

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

left join ( select znsls410.t$poco$c,
                   znsls410.t$ncia$c,
                   znsls410.t$uneg$c,
                   znsls410.t$pecl$c,
                   znsls410.t$sqpd$c,
                   znsls410.t$entr$c,
                   cast((from_tz(to_timestamp(to_char(max(znsls410.t$dtoc$c),
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') as date) DATA_OCORRENCIA
               from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'WMS'
           group by znsls410.t$poco$c,
                    znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    znsls410.t$entr$c ) CRIACAO_WMS
        ON CRIACAO_WMS.t$ncia$c = znsls401.t$ncia$c
       AND CRIACAO_WMS.t$uneg$c = znsls401.t$uneg$c
       AND CRIACAO_WMS.t$pecl$c = znsls401.t$pecl$c
       AND CRIACAO_WMS.t$sqpd$c = znsls401.t$sqpd$c
       AND CRIACAO_WMS.t$entr$c = znsls401.t$entr$c

left join ( select znsng108.t$orln$c,
                   znsng108.t$pvvv$c,
                   min(znsng108.t$dhpr$c) t$dhpr$c
            from   baandb.tznsng108301 znsng108
            where trim(znsng108.t$pvvv$c) is not null
            group by znsng108.t$orln$c,
                     znsng108.t$pvvv$c ) znsng108
       on znsng108.t$orln$c = znsls004.t$orno$c

left join ( select a.t$fili$c,
                   a.t$etiq$c,
                   max(a.t$date$c) t$date$c,
                   max(a.t$coci$c) keep (dense_rank last order by t$date$c) t$coci$c
            from baandb.tznfmd640301 a
            where a.t$torg$c = 1     --vendas
            group by a.t$fili$c,
                     a.t$etiq$c ) znfmd640
       on znfmd640.t$fili$c = znfmd630.t$fili$c
      and znfmd640.t$etiq$c = znfmd630.t$etiq$c

left join baandb.tznfmd030301 znfmd030_TRA
       on znfmd030_TRA.t$ocin$c = znfmd640.t$coci$c

left join baandb.tznmcs002301 znmcs002_TRA
       on znmcs002_TRA.t$poco$c = znfmd640.t$coci$c

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
                                        'SEF',
                                        'ENT',
                                        'FER',
                                        'MPD',
                                        'AGE',
                                        'SEF',
                                        'ENL')
            and znfmd640.t$torg$c = 1   --vendas
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

left join ( select  a.t$cfrw$c,
                    a.t$cono$c,
                    a.t$cepd$c,
                    a.t$cepa$c,
                    a.t$creg$c
            from baandb.tznfmd062301 a 
            where a.t$ativ$c = 1 
            group by  a.t$cfrw$c,
                      a.t$cono$c,
                      a.t$creg$c,
                      a.t$cepd$c,
                      a.t$cepa$c ) znfmd062
		   on znfmd062.t$cfrw$c = znfmd630.t$cfrw$c
			and	znfmd062.t$cono$c = znfmd630.t$cono$c
      and tccom130.t$pstc between znfmd062.t$cepd$c and znfmd062.t$cepa$c 
      
left join ( select znsls410.t$poco$c,
                   znsls410.t$ncia$c,
                   znsls410.t$uneg$c,
                   znsls410.t$pecl$c,
                   znsls410.t$sqpd$c,
                   znsls410.t$entr$c,
                   cast((from_tz(to_timestamp(to_char(max(znsls410.t$dtoc$c),
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') as date) DATA_OCORRENCIA
               from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'ETL'
           group by znsls410.t$poco$c,
                    znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    znsls410.t$entr$c ) PONTO_ETL
        ON PONTO_ETL.t$ncia$c = znsls401.t$ncia$c
       AND PONTO_ETL.t$uneg$c = znsls401.t$uneg$c
       AND PONTO_ETL.t$pecl$c = znsls401.t$pecl$c
       AND PONTO_ETL.t$sqpd$c = znsls401.t$sqpd$c
       AND PONTO_ETL.t$entr$c = znsls401.t$entr$c
       
  where cisli940.t$fdty$l != 14  -- Retorno mercadoria de cliente 
    and tdsls401.t$prdt
          between :DATA_DE
              and :DATA_ATE 

