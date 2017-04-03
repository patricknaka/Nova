    select tcemm030.t$eunt                                                      FILIAL,
           tcemm030.t$dsca                                                      DESCRICAO_FILIAL,
           cast((from_tz(to_timestamp(to_char(cisli940.t$date$l,
                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') as date)                    DATA_EMISSAO,
           cisli940.t$docn$l                                                    NOTA,
           cisli940.t$seri$l                                                    SERIE,
           znsls401.t$pecl$c                                                    PEDIDO,
           NVL(Trim(cisli940.t$fdtc$l), cisli940.t$fdty$l)                      COD_TIPO_DOC_FISCAL,
           NVL(Trim(tcmcs966.t$dsca$l), TIPO_DOC_FISC.DESCR)                    DESC_TIPO_DOC_FISCAL,
           cisli940.t$ccfo$l                                                    CFOP,
           tcmcs940.t$dsca$l                                                    DESCRICAO_CFOP,
           cisli940.t$opor$l                                                    NATUREZA_OPERACAO,
           tcmcs964.t$desc$d                                                    DESCRICAO_NAT_OPERACAO,
           cisli941.t$item$l                                                    ITEM,
           tcibd001.t$dscb$c                                                    DESCRICAO_ITEM,
           cisli941.t$dqua$l                                                    QTDE,
           cisli941.t$pric$l                                                    VALOR_UNITARIO,
           cisli941.t$gamt$l                                                    VALOR_TOTAL,
           cisli941.t$amnt$l                                                    CMV_TOTAL,
           tccom130_FABR.t$nama                                                 FABRICANTE,
           tccom130.t$nama                                                      NOME_CLIENTE,
           tccom130.t$namc                                                      ENDERECO,
           tccom130.t$dist$l                                                    BAIRRO,
           tccom130.t$pstc                                                      CEP,
           tccom130.t$dsca                                                      MUNICIPIO,
           tccom130.t$cste                                                      UF

  from     baandb.tcisli940301 cisli940

inner join baandb.tcisli941301 cisli941
        on cisli941.t$fire$l = cisli940.t$fire$l

inner join baandb.ttcibd001301 tcibd001
        on tcibd001.t$item = cisli941.t$item$l
       and tcibd001.t$kitm = 1 -- Comprado

 left join baandb.ttcmcs966301 tcmcs966
        on tcmcs966.t$fdtc$l = cisli940.t$fdtc$l
 
 left join baandb.ttcmcs940301 tcmcs940
        on tcmcs940.t$ofso$l = cisli940.t$ccfo$l
 
 left join baandb.ttcmcs964301 tcmcs964
        on tcmcs964.t$opor$d = cisli940.t$opor$l
 
 left join baandb.ttccom130301 tccom130
        on tccom130.t$cadr = nvl(trim(cisli940.t$itoa$l),cisli940.t$ifba$l)
 
 left join baandb.ttcmcs060301 tcmcs060
        on tcmcs060.t$cmnf = tcibd001.t$cmnf
 
 left join baandb.ttccom130301 tccom130_FABR
        on tccom130_FABR.t$cadr = tcmcs060.t$cadr
 
 left join baandb.ttcemm124301 tcemm124
        on tcemm124.t$cwoc = cisli940.t$cofc$l
 
 left join baandb.ttcemm030301 tcemm030
        on tcemm030.t$eunt = tcemm124.t$grid
 
 left join baandb.tcisli245301 cisli245
        on cisli245.t$fire$l = cisli941.t$fire$l
       and cisli245.t$line$l = cisli941.t$line$l
       and cisli245.t$slcp   = 301  -- Cia
       and cisli245.t$ortp   = 1    -- Ordem/programação de venda
       and cisli245.t$koor   = 3    -- Ordem de venda
 
 left join baandb.tznsls401301 znsls401
        on znsls401.t$orno$c = cisli245.t$slso
       and znsls401.t$pono$c = cisli245.t$pono

 left join ( select l.t$desc DESCR,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'ci'
                and d.t$cdom = 'sli.tdff.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'ci'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) TIPO_DOC_FISC
        on TIPO_DOC_FISC.t$cnst = cisli940.t$fdty$l

     where cisli940.t$stat$l in (5,6) -- Impresso,Lançado

       and Trunc(cast((from_tz(to_timestamp(to_char(cisli940.t$date$l,
                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') as date))
           Between :DataEmissaoDe
               And :DataEmissaoAte
       and tcemm030.t$eunt in (:Filial)
       and cisli940.t$opor$l in (:NaturezaOperacao)