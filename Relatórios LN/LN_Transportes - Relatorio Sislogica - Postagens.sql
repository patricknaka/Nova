select  /*+ use_concat no_cpu_costing */  
        DISTINCT
        znsls401.t$pecl$c                                  NR_PEDIDO,
        znsls401.t$entr$c                                  ENTREGA_DEVOLUCAO,
        znfmd630.t$ncol$c                                  NR_AUTORIZACAO,
        znfmd630.t$etiq$c                                  ETIQUETA,
        replace(tccom130.t$fovn$l,'/','')                  CNPJ,
        cast(replace(replace(own_mis.filtro_mis(tccom130.t$nama),';',''),'"','')   as varchar(100)) FORNECEDOR,                         
        cisli940.t$ccfo$l                                  CFOP,
        cisli940.t$opor$l                                  SEQ_CFOP,
        cisli941.t$item$l                                  SEQ_PEDIDO,
        cast(replace(replace(own_mis.filtro_mis(tcibd001.t$dscb$c),';',''),'"','')   as varchar(100)) DESCRICAO,                                   
        cisli941.t$dqua$l                                  QTDE,
        cisli941.t$pric$l                                  PRECO_UNIT,
        cisli941.t$amnt$l                                  VALOR_TOTAL,
        znsls401.t$fovn$c                                  CPF_CLIENTE,
        
--        cast(replace(replace(own_mis.filtro_mis(znsls401.t$nome$c),';',''),'"','')   as varchar(100)) NOME_REMETENTE,

                                          
        znsls401.t$cepe$c                                  CEP_REMETENTE,
        
        cast(replace(replace(own_mis.filtro_mis(znsls401.t$loge$c),';',''),'"','')   as varchar(100)) END_REMETENTE,
                                          
        znsls401.t$nume$c                                  NUME_REMETENTE,
        
        cast(replace(replace(own_mis.filtro_mis(znsls401.t$come$c),';',''),'"','')   as varchar(100)) COMP_REMETENTE,        

        cast(replace(replace(own_mis.filtro_mis(znsls401.t$baie$c),';',''),'"','')   as varchar(100)) BAIRRO_REMETENTE,                                          
        cast(replace(replace(own_mis.filtro_mis(znsls401.t$cide$c),';',''),'"','')   as varchar(100)) CIDADE_REMETENTE,                                          
                                          
        znsls401.t$ufen$c                                  UF_REMETENTE,
        znsls401.t$paie$c                                  PAIS_REMETENTE,
        znsls401.t$tele$c                                  TEL_REMETENTE,
        znsls401.t$te1e$c                                  TEL1_REMETENTE,
        znsls410.t$poco$c                                  ULT_PONTO_CONTROLE,
        cast((from_tz(to_timestamp(to_char(znsls410.t$dtoc$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE)   DATA_ULT_PONTO

from ( select a.t$pecl$c,
                b.t$fili$c,
                b.t$etiq$c,
                b.t$udat$c,
                trunc(cast((from_tz(to_timestamp(to_char(b.t$udat$c,
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                   AT time zone 'America/Sao_Paulo') AS DATE))  DATA_FILTRO,
                b.t$coci$c
        from baandb.tznfmd630301 a
        inner join baandb.tznfmd640301 b
                on b.t$fili$c = a.t$fili$c
               and b.t$etiq$c = a.t$etiq$c
        where b.t$coci$c in ('APC','SPC')
          and b.t$udat$c between to_date(:data_ini) and to_date(:data_fim)+2 
--            and a.t$pecl$c = '12820696602'
       group by a.t$pecl$c,
                b.t$fili$c,
                b.t$etiq$c,
                b.t$udat$c,
                b.t$coci$c) znfmd640

inner join baandb.tznfmd630301 znfmd630
        on znfmd630.t$fili$c = znfmd640.t$fili$c
       and znfmd630.t$etiq$c = znfmd640.t$etiq$c
       and znfmd630.t$pecl$c = znfmd640.t$pecl$c

inner join ( select distinct
                    a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$nome$c,
                    a.t$cepe$c,
                    a.t$loge$c,
                    a.t$nume$c,
                    a.t$come$c,
                    a.t$baie$c,
                    a.t$cide$c,
                    a.t$ufen$c,
                    a.t$paie$c,
                    a.t$tele$c,
                    a.t$te1e$c,
                    a.t$fovn$c
              from baandb.tznsls401301 a ) znsls401
          on znsls401.t$entr$c = to_char(znfmd630.t$pecl$c)
                    
inner join baandb.ttcmcs080301 tcmcs080
        on tcmcs080.t$cfrw = znfmd630.t$cfrw$c

inner join baandb.ttccom130301 tccom130
        on tccom130.t$cadr = tcmcs080.t$cadr$l

left join baandb.tcisli245301 cisli245
       on cisli245.t$ortp = 1
      and cisli245.t$koor = 3
      and cisli245.t$slso = znfmd630.t$orno$c

left join baandb.tcisli940301 cisli940
        on cisli940.t$fire$l = cisli245.t$fire$l

left join baandb.tcisli941301 cisli941
        on cisli941.t$fire$l = cisli245.t$fire$l
       and cisli941.t$line$l = cisli245.t$line$l

left join baandb.ttcibd001301 tcibd001
        on tcibd001.t$item = cisli941.t$item$l

inner join baandb.tznsls000301 znsls000
        on znsls000.t$indt$c = to_date('01-01-1970')

  LEFT JOIN ( select a.t$ncia$c,
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
                        a.t$entr$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
       AND znsls410.t$entr$c = znsls401.t$entr$c
        
where cisli941.t$item$l not in (znsls000.t$itmd$c,znsls000.t$itmf$c,znsls000.t$itjl$c)
  and znfmd640.DATA_FILTRO
      between :data_ini
          and :data_fim
