SELECT 
  DISTINCT
    znfmd630.t$pecl$c     NUME_ENTREGA,
    cisli940.t$docn$l     NUME_NOTA,
    cisli940.t$seri$l     NUME_SERIE,
    znfmd630.t$fili$c     NUME_FILIAL,
    cisli941.t$item$l     NUME_ITEM,
    cisli941.t$desc$l     DESC_ITEM,
    cisli941.T$IPRT$L     VALOR_ITEM,
    cisli941.T$DQUA$L     QTDE_ITEM,
    whwmd400.t$hght       ALTURA,
    whwmd400.t$wdth       LARGURA,
    whwmd400.t$dpth       COMPRIMENTO,
    znfmd630.t$wght$c     PESO,
    whwmd400.t$hght*
    whwmd400.t$wdth       M3
                      
FROM baandb.tznfmd630201 znfmd630,
     baandb.tcisli941201 cisli941,
     baandb.tcisli940201 cisli940,
     baandb.twhwmd400201 whwmd400

WHERE cisli941.T$FIRE$L=znfmd630.t$fire$c
  AND cisli940.t$fire$l=cisli941.t$fire$l
  AND whwmd400.t$item=cisli941.T$ITEM$L
  
  AND znfmd630.t$pecl$c IN (:Entrega)