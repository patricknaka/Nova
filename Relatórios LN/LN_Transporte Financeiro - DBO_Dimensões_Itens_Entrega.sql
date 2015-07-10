SELECT 
  DISTINCT
    znfmd630.t$pecl$c                  NUME_ENTREGA,
    cisli940.t$docn$l                  NUME_NOTA,
    cisli940.t$seri$l                  NUME_SERIE,
    znfmd630.t$fili$c                  NUME_FILIAL,
    Trim(cisli941.t$item$l)            NUME_ITEM,
    cisli941.t$desc$l                  DESC_ITEM,
    cisli941.T$IPRT$L                  VALOR_ITEM,
    cisli941.T$DQUA$L                  QTDE_ITEM,
    whwmd400.t$hght                    ALTURA,
    whwmd400.t$wdth                    LARGURA,
    whwmd400.t$dpth                    COMPRIMENTO,
    znfmd630.t$wght$c                  PESO,
    whwmd400.t$hght * whwmd400.t$wdth *  
    whwmd400.t$dpth * cisli941.t$dqua$l  M3,
    CASE WHEN znsls409.t$dved$c = 1 THEN
      'Sim'
    ELSE 'Não' END                    Forçado

FROM       baandb.tznfmd630301 znfmd630

INNER JOIN baandb.tcisli941301 cisli941
        ON cisli941.T$FIRE$L = znfmd630.t$fire$c

INNER JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = cisli941.t$fire$l

INNER JOIN baandb.twhwmd400301 whwmd400
        ON whwmd400.t$item = cisli941.T$ITEM$L
        
LEFT JOIN baandb.tznsls409301 znsls409
       ON TRIM(TO_CHAR(znsls409.t$entr$c)) = TRIM(znfmd630.t$pecl$c)

WHERE znfmd630.t$pecl$c IN (:Entrega)
