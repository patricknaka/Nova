select  /*+ use_concat no_cpu_costing */  
        DISTINCT

        cisli940.t$docn$l                                  NOTA,
        case when cisli940.t$docn$l = 0 then
          ' '
        else cisli940.t$seri$l end                         SERIE,
        znfmd630.t$fili$c                                  ID_FILIAL,
        case when cisli940.t$date$l = '01-01-1970' then
            null
        else
            cast((from_tz(to_timestamp(to_char(cisli940.t$date$l,
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                   AT time zone 'America/Sao_Paulo') AS DATE)  end
                                                           DATA_EMISSAO_NF,
        replace(tccom130.t$fovn$l,'/','')                  CNPJ,
        tccom130.t$nama                                    FORNECEDOR,
        cisli940.t$ccfo$l                                  CFOP,
        cisli940.t$opor$l                                  SEQ_CFOP,
        znsls004.t$pecl$c                                  NR_PEDIDO,
        cisli941.t$item$l                                  SEQ_PEDIDO,
        tcibd001.t$dscb$c                                  DESCRICAO,
        cisli941.t$dqua$l                                  QTDE,
        cisli941.t$pric$l                                  PRECO_UNIT,
        cisli941.t$amnt$l                                  VALOR_TOTAL,
        znfmd640.t$coci$c                                  PONTO_CONTROLE,
        cast((from_tz(to_timestamp(to_char(znfmd640.t$udat$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE)   DATA_PONTO,
        znfmd630.t$etiq$c                                  ETIQUETA

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
        where b.t$coci$c in ('APC','COP')
          and b.t$udat$c between to_date(:data_ini) and to_date(:data_fim)+2 
--            and a.t$pecl$c = '12678546202'
       group by a.t$pecl$c,
                b.t$fili$c,
                b.t$etiq$c,
                b.t$udat$c,
                b.t$coci$c) znfmd640

inner join baandb.tznfmd630301 znfmd630
        on znfmd630.t$fili$c = znfmd640.t$fili$c
       and znfmd630.t$etiq$c = znfmd640.t$etiq$c
       and znfmd630.t$pecl$c = znfmd640.t$pecl$c

inner join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$orno$c
               from baandb.tznsls004301 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$orno$c ) znsls004
          on to_char(znsls004.t$entr$c) = to_char(znfmd630.t$pecl$c)

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
        
where cisli941.t$item$l not in (znsls000.t$itmd$c,znsls000.t$itmf$c,znsls000.t$itjl$c)
  and znfmd640.DATA_FILTRO
      between :data_ini
          and :data_fim
