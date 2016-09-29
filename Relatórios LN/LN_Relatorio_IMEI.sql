SELECT
    znfmd001.t$fili$c           COD_FILIAL,
    znfmd001.t$dsca$c           FILIAL,
    znsls401.t$uneg$c           COD_UN_NEGOCIO,
    znint002.t$desc$c           UN_NEGOCIO,
    whinh433.t$cser             IMEI,
    cisli940.t$docn$l           NF,
    cisli940.t$seri$l           SERIE,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                DT_EMISSAO_NF,
    znsls401.t$itml$c           ITEM,
    tcibd001.t$dscb$c           DESCRICAO,
    znsls004.t$orno$c           ORDEM_VENDA,
    znsls004.t$pono$c           POSICAO,
    znsls401.t$entr$c           ENTREGA,
    cisli941.t$amnt$l           VL_TOTAL_ITEM
   
FROM   baandb.tcisli941301 cisli941

inner join baandb.tcisli940301 cisli940
        on cisli940.t$fire$l = cisli941.t$fire$l
        
inner join baandb.tcisli245301   cisli245
        on cisli245.t$fire$l = cisli941.t$fire$l
       and cisli245.t$line$l = cisli941.t$line$l
       and cisli245.t$ortp = 1    --venda com pedido
       and cisli245.t$koor = 3 

inner join baandb.twhinh433301 whinh433
        on whinh433.t$shpm = cisli245.t$shpm
       and whinh433.t$pono = cisli245.t$shln
      
inner join baandb.tznsls004301 znsls004
        on znsls004.t$orno$c = cisli245.t$slso
       and znsls004.t$pono$c = cisli245.t$pono

inner join baandb.tznsls401301 znsls401
        on znsls401.t$ncia$c = znsls004.t$ncia$c
       and znsls401.t$uneg$c = znsls004.t$uneg$c
       and znsls401.t$pecl$c = znsls004.t$pecl$c
       and znsls401.t$sqpd$c = znsls004.t$sqpd$c
       and znsls401.t$entr$c = znsls004.t$entr$c
       and znsls401.t$sequ$c = znsls004.t$sequ$c

inner join baandb.ttcibd001301  tcibd001
        on tcibd001.t$item = znsls401.t$itml$c
        
inner join baandb.ttccom130301 tccom130
        on tccom130.t$cadr = cisli940.t$sfra$l
        
inner join baandb.tznfmd001301 znfmd001
        on znfmd001.t$fovn$c = tccom130.t$fovn$l

inner join baandb.tznint002301 znint002
        on znint002.t$uneg$c = znsls401.t$uneg$c
        
WHERE cisli940.t$stat$l IN (5,6)
and   znsls004.t$uneg$c = :UNIDADE_NEGOCIO   --B2B PF
and   TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)) between  :DATA_EMISSAO_INICIAL AND :DATA_EMISSAO_FINAL 
