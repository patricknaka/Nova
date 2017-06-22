select  /*+ no_cpu_costing use_merge(znsls401) use_merge(tccom130t) */
        
        ( select znfmd001.t$fili$c
          from   baandb.tznfmd001301 znfmd001,
                 baandb.ttcmcs065301 tcmcs065,
                 baandb.ttccom130301 tccom130_filial
          where tcmcs065.t$cwoc = SLS_fMD.t$cofc
            and tccom130_filial.t$cadr = tcmcs065.t$cadr
            and znfmd001.t$fovn$c = tccom130_filial.t$fovn$l )
                                                           FILIAL,
        (select t$dsca from baandb.ttcmcs031301 tcmcs031
         where tcmcs031.t$cbrn = znint002.t$cbrn$c)        MARCA,

        ( select cast((from_tz(to_timestamp(to_char(znfmd640.t$udat$c,
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') as date)                     
          from (  select  max(a.t$udat$c) t$udat$c,
                          a.t$etiq$c, 
                          a.t$fili$c
                  from baandb.tznfmd640301 a
                  where a.t$coct$c = 'ETR'
                    and a.T$TORG$C = 1
                  group by a.t$fili$c, a.t$etiq$c ) znfmd640
          where znfmd640.t$fili$c = SLS_FMD.t$fili$c
            and znfmd640.t$etiq$c = SLS_FMD.t$etiq$c )      
                                                           DATA_EXPEDICAO,
        cisli940.t$docn$l                                  NOTA_FISCAL,
        cisli940.t$seri$l                                  SERIE,
        cast((from_tz(to_timestamp(to_char(cisli940.t$date$l,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)    DATA_EMISSAO_NF,
        SLS_FMD.t$pecl$c                                    PEDIDO,
        SLS_FMD.t$entr$c                                    ENTREGA,
        SLS_FMD.t$orno$c                                    ORDEM_DE_VENDA,
        SLS_FMD.t$qvol$c                                    QTDE_VOLUMES,
        case when SLS_FMD.t$torg$c = 7 then
          'INSUCESSO DE ENTREGA'
        ELSE znsls002.t$dsca$c END                          TIPO_ENTREGA,
        cisli940.t$amnt$l                                   VALOR_TOTAL_NF,
        tccom130t.t$dsca                                    TRANSPORTADOR,
        SLS_FMD.t$cepe$c                                    CEP,
        SLS_FMD.t$cide$c                                    CIDADE,
        SLS_FMD.t$ufen$c                                    UF,
        case when regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '') is null
             then '00000000000000'
             when length(regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')) < 11
             then '00000000000000'
        else regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')
        end                                                CNPJ_TRANSPORTADORA,
          ( select znfmd062.t$creg$c
            from ( select a.t$cfrw$c,
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
              where znfmd062.t$cfrw$c = SLS_FMD.t$cfrw$c
                and	znfmd062.t$cono$c = SLS_FMD.t$cono$c
                and tccom130.t$pstc between znfmd062.t$cepd$c and znfmd062.t$cepa$c )
                                                          REGIAO,
        SLS_FMD.t$ncar$c                                  NRO_CARGA,
        SLS_FMD.t$etiq$c                                  ETIQUETA,
        ( select  znsls410.t$dtoc$c
          from ( select  a.t$poco$c,
                         a.t$ncia$c,
                         a.t$uneg$c,
                         a.t$pecl$c,
                         a.t$sqpd$c,
                         a.t$entr$c,
                         cast((from_tz(to_timestamp(to_char(max(a.t$dtoc$c),
                            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                              AT time zone 'America/Sao_Paulo') as date) t$dtoc$c
                  from baandb.tznsls410301 a
                  where a.t$poco$c = 'WMS'
                  group by  a.t$poco$c,
                            a.t$ncia$c,
                            a.t$uneg$c,
                            a.t$pecl$c,
                            a.t$sqpd$c,
                            a.t$entr$c ) znsls410
        where znsls410.t$ncia$c = SLS_FMD.t$ncia$c
          and znsls410.t$uneg$c = SLS_FMD.t$uneg$c
          and znsls410.t$pecl$c = SLS_FMD.t$pecl$c
          and znsls410.t$sqpd$c = SLS_FMD.t$sqpd$c
          and znsls410.t$entr$c = SLS_FMD.t$entr$c )
                                                          DATA_WMS,
        SLS_FMD.t$pzcd$c                                  PRAZO_CD,

        cast((from_tz(to_timestamp(to_char(SLS_FMD.t$odat,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)   DATA_COMPRA,
        case when trunc(SLS_FMD.t$dtap$c) = '01/01/1970'
             then null 
        else cast((from_tz(to_timestamp(to_char(SLS_FMD.t$dtap$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date)
        end                                                DATA_APROV_PAGTO,

        cast((from_tz(to_timestamp(to_char(SLS_FMD.t$ddta,
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') as date)    
                                                            DATA_LIM_EXPEDICAO,

        case when trunc(SLS_FMD.t$dtep$c) <= to_date('01/01/1970','DD-MM-YYYY')
              then null
        else SLS_FMD.t$dtep$c
        end                                                DATA_PROMETIDA_ENTREGA,
        
        case when trunc(SLS_FMD.t$dtpe$c) <= to_date('01/01/1970','DD-MM-YYYY')
             then null
        else SLS_FMD.t$dtpe$c
        end                                                DATA_PREVISTA_ENTREGA,
        
        case when trunc(SLS_FMD.t$dtco$c) <= to_date('01/01/1970','DD/MM/YYYY')
             then null
        else cast((from_tz(to_timestamp(to_char(SLS_FMD.t$dtco$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') as date)
        end                                                DATA_CORRIGIDA,
        SLS_FMD.t$cono$c                                   CONTRATO,
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
            
--        nvl(znfmd030_FTRA.t$dsci$c,           --Retirado, pois esta onerando muito a query
--          nvl(znfmd030_TRA.t$dsci$c,
--            nvl(znmcs002_TRA.t$desc$c,
--              nvl(znfmd030_F.t$dsci$c,
--                nvl(znfmd030.t$dsci$c,znmcs002.t$desc$c)))))                         ULTIMA_DESC_OCORRENCIA,
            
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
        own_mis.filtro_mis(SLS_FMD.t$nomf$c)               NOME_DESTINATARIO,

        ( select znsng108.t$pvvv$c
          from ( select a.t$orln$c,
                        a.t$pvvv$c,
                        min(a.t$dhpr$c) t$dhpr$c
                  from  baandb.tznsng108301 a
            where trim(a.t$pvvv$c) is not null
            group by a.t$orln$c,
                     a.t$pvvv$c ) znsng108
          where znsng108.t$orln$c = SLS_FMD.t$orno$c )
                                                            PEDIDO_VIA_VAREJO,

        ( select cast((from_tz(to_timestamp(to_char(znsng108.t$dhpr$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date) 
          from ( select a.t$orln$c,
                        a.t$pvvv$c,
                        min(a.t$dhpr$c) t$dhpr$c
                  from  baandb.tznsng108301 a
            where trim(a.t$pvvv$c) is not null
            group by a.t$orln$c,
                     a.t$pvvv$c ) znsng108
          where znsng108.t$orln$c = SLS_FMD.t$orno$c )
                                                            DATA_VIA_VAREJO,
        PONTO_ETL.DATA_OCORRENCIA                           DATA_PONTO_ETL,
        own_mis.filtro_mis(SLS_FMD.t$obet$c)                ETIQUETA_TRANSPORTADORA

from (  select  
                DISTINCT
                tdsls400.t$cofc,
                tdsls400.t$odat,
                tdsls400.t$stad,
                znsls400.t$nomf$c,
                znsls401.t$ncia$c,
                znsls401.t$uneg$c,
                znsls401.t$pecl$c,
                znsls401.t$sqpd$c,
                znsls401.t$entr$c,
                znsls401.t$sequ$c,
                znsls401.t$itpe$c,
                znsls401.t$cepe$c,
                znsls401.t$cide$c,
                znsls401.t$ufen$c,
                znsls401.t$pzcd$c,
                znsls401.t$dtap$c,
                znsls401.t$obet$c,
                cast((from_tz(to_timestamp(to_char(znsls401.t$dtep$c,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') as date) t$dtep$c,
                znfmd630.t$fili$c,
                znfmd630.t$fire$c,
                znfmd630.t$cfrw$c,
                znfmd630.t$cono$c,
                znfmd630.t$docn$c,
                znfmd630.t$date$c,
                znfmd630.t$seri$c,
                znfmd630.t$qvol$c,
                znfmd630.t$ncar$c,
                case when trunc(znfmd630.t$dtpe$c) = to_date('01-01-1970','DD-MM-YYYY') or znfmd630.t$dtpe$c is null then
                        cast((from_tz(to_timestamp(to_char(znsls401.t$dtep$c,
                        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') as date)
                else
                        cast((from_tz(to_timestamp(to_char(znfmd630.t$dtpe$c,
                        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') as date)
                end                         
                      data_filtro,
                znfmd630.t$dtco$c,
                znfmd630.t$etiq$c,
                znfmd630.t$torg$c,
                znfmd630.t$orno$c,
                cast((from_tz(to_timestamp(to_char(znfmd630.t$dtpe$c,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') as date) t$dtpe$c,
                tdsls401.t$ddta
                
        from baandb.tznsls401301 znsls401

        inner join baandb.tznsls400301 znsls400
                on znsls400.t$ncia$c = znsls401.t$ncia$c
               and znsls400.t$uneg$c = znsls401.t$uneg$c
               and znsls400.t$pecl$c = znsls401.t$pecl$c
               and znsls400.t$sqpd$c = znsls401.t$sqpd$c
        
        inner join ( select a.t$ncia$c,
                            a.t$uneg$c,
                            a.t$pecl$c,
                            a.t$sqpd$c,
                            a.t$entr$c,
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
        
        inner join ( select 
                            a.t$pecl$c,
                            a.t$fili$c,
                            min(a.t$etiq$c) t$etiq$c,
                            a.t$fire$c,
                            a.t$cfrw$c,
                            a.t$cono$c,
                            a.t$docn$c,
                            a.t$seri$c,
                            a.t$date$c,
                            a.t$qvol$c,
                            a.t$ncar$c,
                            a.t$dtpe$c,
                            a.t$dtco$c,
                            a.t$torg$c,
                            a.t$orno$c
                     from baandb.tznfmd630301 a
                     where a.t$torg$c = 1   --venda
                     group by a.t$pecl$c, 
                              a.t$fili$c,
                              a.t$fire$c,
                              a.t$cfrw$c,
                              a.t$cono$c,
                              a.t$docn$c,
                              a.t$seri$c,
                              a.t$date$c,
                              a.t$qvol$c,
                              a.t$ncar$c,
                              a.t$dtpe$c,
                              a.t$dtco$c,
                              a.t$torg$c,
                              a.t$orno$c ) znfmd630
                on znfmd630.t$pecl$c = to_char(znsls401.t$entr$c )
               
        where tdsls400.t$fdty$l != 14
          and znsls401.t$iitm$c = 'P'
          and znsls401.t$qtve$c > 0 ) SLS_FMD

left join baandb.tcisli940301 cisli940        
       on cisli940.t$fire$l = SLS_FMD.t$fire$c

left join ( select a.t$cadr,
                   a.t$pstc,
                   a.t$fovn$l
            from baandb.ttccom130301 a ) tccom130
       on tccom130.t$cadr = SLS_FMD.t$stad

left join baandb.tznint002301 znint002
       on znint002.t$ncia$c = SLS_FMD.t$ncia$c
      and znint002.t$uneg$c = SLS_FMD.t$uneg$c

left join baandb.tznsls002301 znsls002
       on znsls002.t$tpen$c = NVL(SLS_FMD.t$itpe$c, 16)

left join baandb.tznfmd060301 znfmd060
       on znfmd060.t$cfrw$c = SLS_FMD.t$cfrw$c
      and znfmd060.t$cono$c = SLS_FMD.t$cono$c

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
       on znsls410_F.t$ncia$c = SLS_FMD.t$ncia$c
      and znsls410_F.t$uneg$c = SLS_FMD.t$uneg$c
      and znsls410_F.t$pecl$c = SLS_FMD.t$pecl$c
      and znsls410_F.t$sqpd$c = SLS_FMD.t$sqpd$c
      and znsls410_F.t$entr$c = SLS_FMD.t$entr$c

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
       on znfmd640_F.t$fili$c = SLS_FMD.t$fili$c
      and znfmd640_F.t$etiq$c = SLS_FMD.t$etiq$c

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
       on znsls410.t$ncia$c = SLS_FMD.t$ncia$c
      and znsls410.t$uneg$c = SLS_FMD.t$uneg$c
      and znsls410.t$pecl$c = SLS_FMD.t$pecl$c
      and znsls410.t$sqpd$c = SLS_FMD.t$sqpd$c
      and znsls410.t$entr$c = SLS_FMD.t$entr$c

left join baandb.tznfmd030301 znfmd030
       on znfmd030.t$ocin$c = znsls410.t$poco$c

left join baandb.tznmcs002301 znmcs002
       on znmcs002.t$poco$c = znsls410.t$poco$c

left join ( select a.t$fili$c,
                   a.t$etiq$c,
                   max(a.t$date$c) t$date$c,
                   max(a.t$coci$c) keep (dense_rank last order by t$date$c) t$coci$c
            from baandb.tznfmd640301 a
            where a.t$torg$c = 1     --vendas
            group by a.t$fili$c,
                     a.t$etiq$c ) znfmd640
       on znfmd640.t$fili$c = SLS_FMD.t$fili$c
      and znfmd640.t$etiq$c = SLS_FMD.t$etiq$c

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
                                        'ENL',
                                        'GAL',
                                        'LFE',
                                        'ARO',
                                        'ARE')
            and znfmd640.t$torg$c = 1   --vendas
            group by znfmd640.t$fili$c,
                     znfmd640.t$etiq$c ) znfmd640_FIRST 
       on znfmd640_FIRST.t$fili$c = SLS_FMD.t$fili$c
      and znfmd640_FIRST.t$etiq$c = SLS_FMD.t$etiq$c

left join baandb.tznfmd030301 znfmd030_FIRST
       on znfmd030_FIRST.t$ocin$c = znfmd640_FIRST.t$coci$c

left join ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                   tcmcs080.t$dsca,
                   tcmcs080.t$cfrw
            from   baandb.ttcmcs080301 tcmcs080
            inner join baandb.ttccom130301 tccom130
                    on tccom130.t$cadr = tcmcs080.t$cadr$l
            where tccom130.t$ftyp$l = 'PJ' ) tccom130t
       on tccom130t.t$cfrw = SLS_FMD.t$cfrw$c
      
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
        ON PONTO_ETL.t$ncia$c = SLS_FMD.t$ncia$c
       AND PONTO_ETL.t$uneg$c = SLS_FMD.t$uneg$c
       AND PONTO_ETL.t$pecl$c = SLS_FMD.t$pecl$c
       AND PONTO_ETL.t$sqpd$c = SLS_FMD.t$sqpd$c
       AND PONTO_ETL.t$entr$c = SLS_FMD.t$entr$c
       
      where SLS_FMD.data_filtro between TRUNC(SYSDATE -1,'MONTH') and trunc(LAST_DAY(SYSDATE - 1))+0.99999
            
