

select distinct
  TO_CHAR(znsls401.t$entr$c)                      ENTREGA,
  znsls410.t$poco$c                               PONTO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c, 
   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)    DATA_PONTO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$date$c, 
   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)    DATA_PROCESSAMENTO,
  cisli940.t$docn$l                               NOTA_FISCAL,
  cisli940.t$seri$l                               SERIE_NF,
  tcemm030.t$euca                                 FILIAL,
  tcmcs080.t$dsca                                 NOME_TRANSPORTADORA,
  znfmd640.t$ulog$c                               MATRICULA,
  ttaad200.t$name                                 NOME

from baandb.tznsls401301 znsls401

inner join baandb.tznsls400301 znsls400
on  znsls401.t$pecl$c = znsls400.t$pecl$c
and znsls401.t$sqpd$c = znsls400.t$sqpd$c

inner join baandb.tznsls410301 znsls410
on znsls410.t$entr$c = znsls401.t$entr$c

LEFT JOIN baandb.tcisli245301 cisli245
       ON cisli245.t$slso = znsls401.t$orno$c
      AND cisli245.t$pono = znsls401.t$pono$c

LEFT JOIN baandb.tcisli940301  cisli940
       ON cisli940.t$fire$l = cisli245.t$fire$l
       
LEFT JOIN baandb.ttcemm124301 tcemm124
       ON tcemm124.t$cwoc = cisli940.t$cofc$l

LEFT JOIN baandb.ttcemm030301 tcemm030
       ON tcemm030.t$eunt = tcemm124.t$grid
       
LEFT JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$pecl$c = TO_CHAR(znsls401.t$entr$c) 
       --AND znfmd630.T$ORNO$C = znsls401.t$orno$c
       
LEFT JOIN baandb.ttcmcs080301  tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c

LEFT JOIN baandb.tznfmd640301 znfmd640
        ON  znfmd640.t$fili$c = znfmd630.t$fili$c
        AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
        
        
LEFT JOIN baandb.tttaad200000 ttaad200
        ON  ttaad200.t$user = znfmd640.t$ulog$c

WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$date$c, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      BETWEEN :DataProceDe
          AND :DataProceAte
  
  AND ( (znsls401.t$entr$c IN (:Entrega) and :EntregaTodos = 1 ) or (:EntregaTodos = 0) )
  AND znsls410.t$poco$c IN (:Ponto)
  AND znsls400.t$idpo$c = 'TD' --Reversa
  AND znfmd640.t$coci$c = znsls410.t$poco$c

ORDER BY DATA_PONTO
