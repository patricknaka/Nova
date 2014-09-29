SELECT DISTINCT
  znfmd630.t$fili$c    FILIAL,
  tcmcs031.t$dsca      MARCA,  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)      
                       DATA_EXPEDICAO, 
  znfmd630.t$docn$c    NUME_NOTA,
  znfmd630.t$seri$c    NUME_SERIE,   
  cisli940.t$fdty$l    NUME_TIPO_DOCUMENTO, FGET.DESC_TIPO_DOCUMENTO,
  znsls401.t$pecl$c    NUME_PEDIDO,  
  znsls401.t$entr$c    NUME_ENTREGA,
  znfmd630.t$qvol$c    QTDE_VOLUMES,
  znsls401.t$itpe$c    NUME_TIPO_ENTREGA_NOME,
  znsls002.t$dsca$c    DESC_TIPO_ENTREGA_NOME,
  znfmd630.t$wght$c    PESO,
  whwmd400.t$hght*
  whwmd400.t$wdth      ITEM_CUBAGEM,
  znsls401.t$vlun$c    ITEM_VALOR,
  znfmd630.t$vlft$c    FRETE_GTE,
  cisli941.t$fght$l    FRETE_NF,
  znsls401.t$vlfr$c    FRETE_SITE,
  znfmd630.t$vlmr$c    VLR_TOTAL_NF,
  cisli940.t$lipl$l    PLACA,
  tcmcs080.t$dsca      TRANSP_NOME,
  znsls400.t$cepf$c    CEP,
  znsls400.t$cidf$c    CIDADE,
  znsls400.t$uffa$c    UF,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli245.t$ddat, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)        
                       DATA_ENTREGA,
  znsls400.t$idca$c    CANAL_VENDA,
  CASE WHEN znfmd630.t$stat$c = 'F' 
         THEN 'FECHADO' 
       ELSE 'ABERTO' 
   END                 SITUACAO_ENTREGA,  
  znfmd067.t$fate$c    FILIAL_TRANSPORTADORA,
  cisli940.t$styp$l    TIPO_VENDA,
  znfmd170.t$fovn$c    CNPJ_TRANSPORTADORA,
  
  nvl( ( SELECT znfmd006.t$creg$c  
           FROM tznfmd006201  znfmd006
          WHERE TO_NUMBER(znfmd006.t$fpst$c) <= znsls401.t$cepe$c 
            AND TO_NUMBER(znfmd006.t$tpst$c) >= znsls401.t$cepe$c 
            AND znfmd006.t$creg$c != 'BR'
            AND rownum=1 ),'BR' )
                      REGIAO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)      
                      DATA_PROMETIDA,
  znsls401.t$idpa$c   PERIODO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtre$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)      
                      DATA_AJUSTADA,
  znfmd630.t$cono$c   CONTRATO,
  znfmd640.t$coci$c   ULTIMA_OCORRENCIA,
  znfmd640.t$obsv$c   OCORRENCIA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)      
                      DATA_OCORRENCIA,
  znsls401.t$pzfo$c   PRAZO_ENTREGA,
  cisli941.t$dqua$l   QTDE_FATURADA,
  znfmd915.t$iqty$c   QTDE_ITEM,
  znsls401.t$qtve$c   QTDE_PEDIDO,
  znfmd630.t$etiq$c   ETIQUETA
  
FROM  baandb.ttcmcs080201     tcmcs080,
      baandb.tznsls004201     znsls004,
      baandb.tznsls400201     znsls400,
      baandb.tznsls401201     znsls401

LEFT JOIN baandb.tznint002201     znint002
       ON znint002.t$ncia$c = znsls401.t$ncia$c
      AND znint002.t$uneg$c = znsls401.t$uneg$c

LEFT JOIN baandb.ttcmcs031201     tcmcs031
       ON znint002.t$cbrn$c = tcmcs031.t$cbrn
         
LEFT JOIN baandb.tcisli245201  cisli245  
       ON cisli245.t$slso = znsls401.t$orno$c
      AND cisli245.t$pono = znsls401.t$pono$c
      AND cisli245.t$item = znsls401.t$itml$c
      
LEFT JOIN baandb.tcisli941201  cisli941  
       ON cisli941.t$fire$l = cisli245.t$fire$l
      AND cisli941.t$line$l = cisli245.t$line$l

LEFT JOIN baandb.tznsls002201 znsls002
       ON znsls002.t$tpen$c = znsls401.t$itpe$c
       
LEFT JOIN baandb.twhwmd400201 whwmd400
       ON whwmd400.t$item = znsls401.t$itml$c,
       
          baandb.tznfmd630201      znfmd630
          
LEFT JOIN baandb.tznfmd067201  znfmd067
       ON znfmd067.t$cfrw$c = znfmd630.t$cfrw$c 
      AND znfmd067.t$cono$c = znfmd630.t$cono$c
      AND znfmd067.t$fili$c = znfmd630.t$fili$c  
      
LEFT JOIN baandb.tznfmd170201 znfmd170
       ON znfmd170.t$fili$c = znfmd630.t$fili$c 
      AND znfmd170.t$cfrw$c = znfmd630.t$cfrw$c
      
LEFT JOIN baandb.tcisli940201  cisli940
       ON cisli940.t$fire$l = znfmd630.t$fire$c 
      AND cisli940.t$docn$l = znfmd630.t$docn$c 
      AND cisli940.t$seri$l = znfmd630.t$seri$c
        
LEFT JOIN baandb.tznfmd640201 znfmd640
       ON znfmd640.t$fili$c = znfmd630.t$fili$c 
      AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
      
LEFT JOIN baandb.tznfmd915201  znfmd915
       ON znfmd915.t$cage$c = znfmd630.t$ngai$c
      AND znfmd915.t$orid$c = znfmd630.t$etiq$c ,
      
        ( SELECT d.t$cnst CODE_STAT, l.t$desc DESC_TIPO_DOCUMENTO
            FROM baandb.tttadv401000 d, 
                 baandb.tttadv140000 l 
           WHERE d.t$cpac='ci' 
             AND d.t$cdom ='sli.tdff.l'
             AND d.t$vers='B61U'
             AND d.t$rele='a7'
             AND d.t$cust='glo1'
             AND l.t$clab=d.t$za_clab
             AND l.t$clan='p'
             AND l.t$cpac='ci'
             AND l.t$vers=( SELECT max(l1.t$vers) 
                              FROM tttadv140000 l1 
                             WHERE l1.t$clab=l.t$clab 
                               AND l1.t$clan=l.t$clan 
                               AND l1.t$cpac=l.t$cpac ) ) FGET
                               
WHERE znsls400.t$ncia$c = znsls401.t$ncia$c 
  AND znsls400.t$uneg$c = znsls401.T$UNEG$c 
  AND znsls400.t$pecl$c = znsls401.T$pecl$c 
  AND znsls400.t$sqpd$c = znsls401.T$sqpd$c
  AND znsls004.t$ncia$c = znsls401.t$ncia$c 
  AND znsls004.t$uneg$c = znsls401.T$UNEG$c 
  AND znsls004.t$pecl$c = znsls401.T$pecl$c 
  AND znsls004.t$sqpd$c = znsls401.T$sqpd$c 
  AND znsls004.t$orno$c = znsls401.T$orno$c
  AND znsls004.t$pono$c = znsls401.T$pono$c    
  AND znsls401.t$entr$c = znfmd630.t$pecl$c  
  AND znsls401.t$orno$c = znfmd630.t$orno$c   
  AND tcmcs080.t$cfrw = znfmd630.t$cfrw$c
  AND cisli940.t$fdty$l = FGET.CODE_STAT
  AND znfmd640.t$date$c = ( select max(oc.t$date$c) 
                              from baandb.tznfmd640201 oc
                             where oc.t$fili$c = znfmd640.t$fili$c
                               and oc.t$etiq$c = znfmd640.t$etiq$c )

/*
  AND cisli940.t$fdty$l = NVL(:TipoEntrega, cisli940.t$fdty$l)
  AND znsls400.t$dtem$c BETWEEN :DtExpIni AND :DtExpFim
  AND tcmcs080.t$dsca = CASE WHEN :Transportadora = 'Todas' THEN tcmcs080.t$dsca ELSE :Transportadora END
  AND tcmcs031.t$dsca = CASE WHEN :Marca = 'Todas' THEN tcmcs031.t$dsca ELSE :Marca END
*/