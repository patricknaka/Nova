SELECT DISTINCT
  znfmd630.t$fili$c    FILIAL,
  tcmcs031.t$dsca      MARCA,  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)      
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
  znfmd630.t$vlfc$c    FRETE_GTE,
  cisli941.t$fght$l    FRETE_NF,
  znsls401.t$vlfr$c    FRETE_SITE,
  cisli941.t$amnt$l    VLR_TOTAL_NF,
  cisli940.t$lipl$l    PLACA,
  tcmcs080.t$dsca      TRANSP_NOME,
  znsls400.t$cepf$c    CEP,
  znsls400.t$cidf$c    CIDADE,
  znsls400.t$uffa$c    UF,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli245.t$ddat, 
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
  CASE WHEN regexp_replace(znfmd170.t$fovn$c, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
    WHEN LENGTH(regexp_replace(znfmd170.t$fovn$c, '[^0-9]', ''))<11
    THEN '00000000000000'
    ELSE regexp_replace(znfmd170.t$fovn$c, '[^0-9]', '') END CNPJ_TRANSPORTADORA,
  NVL(REGIAO.DSC,'BR') REGIAO,
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
  cisli941.t$dqua$l   QTDE_FATURADA,
  znfmd915.t$iqty$c   QTDE_ITEM,
  znsls401.t$qtve$c   QTDE_PEDIDO,
  znfmd630.t$etiq$c   ETIQUETA
  
FROM       baandb.ttcmcs080301     tcmcs080

INNER JOIN baandb.tznfmd630301     znfmd630
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c
           
INNER JOIN baandb.tznsls401301     znsls401
        ON TO_CHAR(znsls401.t$entr$c) = TO_CHAR(znfmd630.t$pecl$c)  
       AND znsls401.t$orno$c = znfmd630.t$orno$c   
  
INNER JOIN baandb.tznsls400301     znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c 
       AND znsls400.t$uneg$c = znsls401.T$UNEG$c 
       AND znsls400.t$pecl$c = znsls401.T$pecl$c 
       AND znsls400.t$sqpd$c = znsls401.T$sqpd$c
       
 LEFT JOIN ( SELECT znfmd006.t$creg$c DSC,
                    TO_NUMBER(znfmd006.t$fpst$c) t$fpst$c,
                    TO_NUMBER(znfmd006.t$tpst$c) t$tpst$c
               FROM baandb.tznfmd006301  znfmd006
              WHERE znfmd006.t$creg$c != 'BR' ) REGIAO
        ON REGIAO.t$fpst$c <= znsls401.t$cepe$c 
       AND REGIAO.t$tpst$c >= znsls401.t$cepe$c 
            
 LEFT JOIN baandb.tznint002301     znint002
        ON znint002.t$ncia$c = znsls401.t$ncia$c
       AND znint002.t$uneg$c = znsls401.t$uneg$c
 
 LEFT JOIN baandb.ttcmcs031301     tcmcs031
        ON znint002.t$cbrn$c = tcmcs031.t$cbrn
          
 LEFT JOIN baandb.tcisli245301  cisli245  
        ON cisli245.t$slso = znsls401.t$orno$c
       AND cisli245.t$pono = znsls401.t$pono$c
       AND cisli245.t$item = znsls401.t$itml$c
       
 LEFT JOIN baandb.tcisli941301  cisli941  
        ON cisli941.t$fire$l = cisli245.t$fire$l
       AND cisli941.t$line$l = cisli245.t$line$l
 
 LEFT JOIN baandb.tznsls002301 znsls002
        ON znsls002.t$tpen$c = znsls401.t$itpe$c
        
 LEFT JOIN baandb.twhwmd400301 whwmd400
        ON whwmd400.t$item = znsls401.t$itml$c
        
 LEFT JOIN baandb.tznfmd067301  znfmd067
        ON znfmd067.t$cfrw$c = znfmd630.t$cfrw$c 
       AND znfmd067.t$cono$c = znfmd630.t$cono$c
       AND znfmd067.t$fili$c = znfmd630.t$fili$c  
       
 LEFT JOIN baandb.tznfmd170301 znfmd170
        ON znfmd170.t$fili$c = znfmd630.t$fili$c 
       AND znfmd170.t$cfrw$c = znfmd630.t$cfrw$c
       
 LEFT JOIN baandb.tcisli940301  cisli940
        ON cisli940.t$fire$l = znfmd630.t$fire$c 
       AND cisli940.t$docn$l = znfmd630.t$docn$c 
       AND cisli940.t$seri$l = znfmd630.t$seri$c
         
 LEFT JOIN baandb.tznfmd640301 znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c 
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
       
 LEFT JOIN baandb.tznfmd915301  znfmd915
        ON znfmd915.t$cage$c = znfmd630.t$ngai$c
       AND znfmd915.t$orid$c = znfmd630.t$etiq$c
       
 LEFT JOIN ( SELECT d.t$cnst CODE_STAT, l.t$desc DESC_TIPO_DOCUMENTO
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'ci' 
                AND d.t$cdom = 'sli.tdff.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) FGET
        ON cisli940.t$fdty$l = FGET.CODE_STAT
        
WHERE (   (znfmd640.t$date$c is null) 
       OR (znfmd640.t$date$c = ( select max(oc.t$date$c) 
                                   from baandb.tznfmd640301 oc
                                  where oc.t$fili$c = znfmd640.t$fili$c
                                    and oc.t$etiq$c = znfmd640.t$etiq$c )) )

  AND znsls401.t$itpe$c IN (:TipoEntrega)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE)) 
      BETWEEN :DtExpIni 
          AND :DtExpFim
  AND tcmcs080.t$cfrw = CASE WHEN :Transportadora = 'T' THEN tcmcs080.t$cfrw ELSE :Transportadora END
  AND tcmcs031.t$cbrn = CASE WHEN :Marca = 'T' THEN tcmcs031.t$cbrn ELSE :Marca END