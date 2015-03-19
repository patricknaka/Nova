SELECT  DISTINCT

  znfmd630.t$pecl$c         ENTREGA,
  znfmd630.t$docn$c         NOTA,
  znfmd630.t$seri$c         SERIE,
  znfmd630.t$fili$c         FILIAL,
  znfmd001.t$dsca$c         DESC_FILIAL,
  znfmd630.t$cfrw$c         TRANSPORTADORA,
  tcmcs080.t$dsca           DESC_TRANSPORTADORA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                             DATA_SAIDA,
  znfmd630.t$cnfe$c          CHAVE_ACESSO,
  znfmd630.t$ncar$c          NUMERO_CARGA
        
FROM  baandb.tznfmd630301  znfmd630

  INNER JOIN baandb.tznfmd001301 znfmd001
         ON znfmd001.t$fili$c=znfmd630.t$fili$c
         
  LEFT JOIN baandb.ttcmcs080301  tcmcs080
         ON tcmcs080.t$cfrw=znfmd630.t$cfrw$c
         
  LEFT JOIN baandb.tznsls004301 znsls004
         ON znsls004.t$orno$c=znfmd630.t$orno$c
        AND ROWNUM=1
        
  LEFT JOIN baandb.tznsls410301 znsls410
         ON znsls410.t$ncia$c=znsls004.t$ncia$c
        AND znsls410.t$uneg$c=znsls004.t$uneg$c
        AND znsls410.t$pecl$c=znsls004.t$pecl$c
        AND znsls410.t$sqpd$c=znsls004.t$sqpd$c
        AND znsls410.t$poco$c='ETR'
        
  LEFT JOIN baandb.tcisli940301 cisli940
         ON cisli940.t$fire$l=znfmd630.t$fire$c
         
WHERE (cisli940.t$fdty$l=1 OR cisli940.t$fdty$l=5)

ORDER BY ENTREGA, NOTA, SERIE
