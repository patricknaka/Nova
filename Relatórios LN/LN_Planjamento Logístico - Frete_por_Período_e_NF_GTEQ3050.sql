SELECT DISTINCT 
  znfmd630.t$fili$c    FILIAL,
  tcmcs031.t$dsca      MARCA,  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$dats$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)      
                       DATA_EXPEDICAO,
  znfmd630.t$docn$c    NUME_NOTA,
  znfmd630.t$seri$c    NUME_SERIE,   
  cisli940.t$fdty$l    NUME_TIPO_DOCUMENTO, 
  FGET.                DESC_TIPO_DOCUMENTO,
  znsls401.t$pecl$c    NUME_PEDIDO,  
  znfmd630.t$pecl$c    NUME_ENTREGA,
  znfmd630.t$qvol$c    QTDE_VOLUMES,
  znsls401.t$itpe$c    NUME_TIPO_ENTREGA_NOME,
  znsls002.t$dsca$c    DESC_TIPO_ENTREGA_NOME,
  znfmd630.t$wght$c    PESO,
  znfmd610.t$cube$c    ITEM_CUBAGEM,
  znfmd630.t$vlmr$c    ITEM_VALOR,
  znfmd630.t$vlfc$c    FRETE_GTE,
  cisli940.t$fght$l    FRETE_NF,
  znsls401.t$vlfr$c    FRETE_SITE,
  cisli940.t$amnt$l    VLR_TOTAL_NF,
  cisli940.t$lipl$l    PLACA,
  tcmcs080.t$dsca      TRANSP_NOME,
  znsls400.t$cepf$c    CEP,
  znsls400.t$cidf$c    CIDADE,
  znsls400.t$uffa$c    UF,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$dats$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)        
                       DATA_ENTREGA,
  znsls400.t$idca$c    CANAL_VENDA,
  CASE WHEN znfmd630.t$stat$c = 'F' 
         THEN 'FECHADO' 
       ELSE 'ABERTO' 
   END                 SITUACAO_ENTREGA,  
  znfmd067.t$fate$c    FILIAL_TRANSPORTADORA,
  cisli940.t$styp$l    TIPO_VENDA,
  
  CASE WHEN regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '') IS NULL
         THEN '00000000000000' 
       WHEN LENGTH(regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')) < 11
         THEN '00000000000000'
       ELSE regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '') 
   END                 CNPJ_TRANSPORTADORA,
  
  ( select znfmd061.t$dzon$c
      from baandb.tznfmd062301 znfmd062, 
           baandb.tznfmd061301 znfmd061
     where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c 
       and znfmd062.t$cono$c = znfmd630.t$cono$c
       and znfmd062.t$cepd$c <= tccom130.t$pstc
       and znfmd062.t$cepa$c >= tccom130.t$pstc
       and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c
       and znfmd061.t$cono$c = znfmd062.t$cono$c
       and znfmd061.t$creg$c = znfmd062.t$creg$c
       and rownum = 1 )REGIAO,
  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)      
                      DATA_PROMETIDA,
  znsls401.t$idpa$c   PERIODO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtre$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)      
                      DATA_AJUSTADA,
  znfmd630.t$cono$c   CONTRATO,
  znfmd640.t$coci$c   ULTIMA_OCORRENCIA,
  znfmd640.t$obsv$c   OCORRENCIA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)      
                      DATA_OCORRENCIA,
  znsls401.t$pzfo$c   PRAZO_ENTREGA,
  nvl( ( select sum(cisli941.t$dqua$l)
           from baandb.tcisli941301 cisli941
          where cisli941.t$fire$l = cisli940.t$fire$l
            and cisli941.t$item$l not in ( select a.t$itjl$c 
                                             from baandb.tznsls000301 a 
                                            where a.t$indt$c = ( select min(b.t$indt$c) 
                                                                   from baandb.tznsls000301 b )
                                        UNION ALL
                                           select a.t$itmd$c 
                                             from baandb.tznsls000301 a 
                                            where a.t$indt$c = ( select min(b.t$indt$c) 
                                                                   from baandb.tznsls000301 b )
                                        UNION ALL
                                           select a.t$itmf$c 
                                            from baandb.tznsls000301 a 
                                            where a.t$indt$c = ( select min(b.t$indt$c) 
                                                                   from baandb.tznsls000301 b ) ) ), 0 )     
                       QTDE_FATURADA,
  znfmd610.t$qvol$c    QTDE_ITEM,
  znsls401.t$qtve$c    QTDE_PEDIDO,
  znfmd630.t$etiq$c    ETIQUETA
  
FROM       baandb.tznfmd630301  znfmd630   

INNER JOIN baandb.ttcmcs080301  tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c

LEFT JOIN baandb.ttdsls400301  tdsls400
        ON tdsls400.t$orno = znfmd630.t$orno$c

LEFT JOIN baandb.ttccom130301  tccom130
        ON tccom130.t$cadr = tdsls400.t$stad
  
LEFT JOIN ( select a1.t$ncia$c,
                    a1.t$uneg$c,
                    a1.t$pecl$c,
                    a1.t$sqpd$c,
                    a1.t$entr$c,
                    a1.t$orno$c
               from baandb.tznsls004301 a1
           group by a1.t$ncia$c,
                    a1.t$uneg$c,
                    a1.t$pecl$c,
                    a1.t$sqpd$c,
                    a1.t$entr$c,
                    a1.t$orno$c ) znsls004
        ON znsls004.t$orno$c = znfmd630.t$orno$c
           
LEFT JOIN ( select e.t$ncia$c,
                    e.t$uneg$c,
                    e.t$pecl$c,
                    e.t$sqpd$c,
                    e.t$entr$c,
                    e.t$itpe$c,
                    min(e.t$dtep$c) t$dtep$c,
                    sum(e.t$vlun$c) t$vlun$c,
                    sum(e.t$vlfr$c) t$vlfr$c,
                    min(e.t$idpa$c) t$idpa$c,
                    min(e.t$dtre$c) t$dtre$c,
                    min(e.t$pzfo$c) t$pzfo$c,
                    sum(e.t$qtve$c) t$qtve$c
               from baandb.tznsls401301 e
           group by e.t$ncia$c,
                    e.t$uneg$c,
                    e.t$pecl$c,
                    e.t$sqpd$c,
                    e.t$entr$c,
                    e.t$itpe$c ) znsls401
        ON znsls401.t$ncia$c = znsls004.t$ncia$c
       AND znsls401.t$uneg$c = znsls004.t$uneg$c
       AND znsls401.t$pecl$c = znsls004.t$pecl$c
       AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
       AND znsls401.t$entr$c = znsls004.t$entr$c

LEFT JOIN baandb.tznsls400301  znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c 
       AND znsls400.t$uneg$c = znsls401.T$UNEG$c 
       AND znsls400.t$pecl$c = znsls401.T$pecl$c 
       AND znsls400.t$sqpd$c = znsls401.T$sqpd$c
            
 LEFT JOIN baandb.tznint002301  znint002
        ON znint002.t$ncia$c = znsls401.t$ncia$c
       AND znint002.t$uneg$c = znsls401.t$uneg$c
 
 LEFT JOIN baandb.ttcmcs031301  tcmcs031
        ON znint002.t$cbrn$c = tcmcs031.t$cbrn
 
 LEFT JOIN baandb.tznsls002301 znsls002
        ON znsls002.t$tpen$c = znsls401.t$itpe$c

 LEFT JOIN baandb.tznfmd067301  znfmd067
        ON znfmd067.t$cfrw$c = znfmd630.t$cfrw$c 
       AND znfmd067.t$cono$c = znfmd630.t$cono$c
       AND znfmd067.t$fili$c = znfmd630.t$fili$c  

 LEFT JOIN baandb.ttccom130301 tccom130t
        ON tccom130t.t$cadr = tcmcs080.t$cadr$l
       
 LEFT JOIN baandb.tcisli940301  cisli940
        ON cisli940.t$fire$l = znfmd630.t$fire$c 

 LEFT JOIN ( select a.t$fili$c,
                    a.t$etiq$c,
                    max(a.t$coci$c) t$coci$c,
                    max(a.t$obsv$c) t$obsv$c,
                    max(a.t$date$c) t$date$c
               from baandb.tznfmd640301 a
              where a.t$date$c = ( select max(oc.t$date$c) 
                                     from baandb.tznfmd640301 oc
                                    where oc.t$fili$c = a.t$fili$c
                                      and oc.t$etiq$c = a.t$etiq$c )
           group by a.t$fili$c,
                    a.t$etiq$c ) znfmd640 
        ON znfmd640.t$fili$c = znfmd630.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c             
       
 LEFT JOIN baandb.tznfmd610301  znfmd610
        ON znfmd610.t$fili$c = znfmd630.t$fili$c
       AND znfmd610.t$cfrw$c = znfmd630.t$cfrw$c  
       AND znfmd610.t$ngai$c = znfmd630.t$ngai$c  
       AND znfmd610.t$etiq$c = znfmd630.t$etiq$c
       
 LEFT JOIN ( SELECT d.t$cnst CODE_STAT,
                    l.t$desc DESC_TIPO_DOCUMENTO
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'ci' 
                AND d.t$cdom = 'sli.tdff.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) || '|' ||
                    rpad(d.t$rele,2) || '|' ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||
                                                    rpad(l1.t$rele,2) || '|' ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) || '|' ||
                    rpad(l.t$rele,2) || '|' ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||
                                                    rpad(l1.t$rele,2) || '|' || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) FGET
        ON cisli940.t$fdty$l = FGET.CODE_STAT
         
  WHERE ( select a.t$coci$c 
            from baandb.tznfmd640301 a
           where a.t$fili$c = znfmd630.t$fili$c
             and a.t$etiq$c = znfmd630.t$etiq$c
             and a.t$coci$c IN ('ETR', 'ENT')
             and rownum = 1 ) IS NOT NULL
    AND cisli940.t$fdty$l != 14

	
    AND znsls401.t$itpe$c IN (:TipoEntrega)
    AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)) 
        BETWEEN :DtExpIni 
            AND :DtExpFim
    AND tcmcs080.t$cfrw = CASE WHEN :Transportadora = 'T' THEN tcmcs080.t$cfrw ELSE :Transportadora END
    AND tcmcs031.t$cbrn = CASE WHEN :Marca = 'T' THEN tcmcs031.t$cbrn ELSE :Marca END