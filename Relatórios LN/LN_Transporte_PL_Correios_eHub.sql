SELECT

znfmd630.t$etiq$c             ETIQUETA,
znfmd065.t$cser$c             CODIGO_SERVICO,
tccom130.t$pstc               CEP_DESTINO,
znfmd630.t$wght$c             PESO_TARIFADO,
znfmd630.t$ncar$c             CARGA,
znsls401.t$item$c             ITEM,
whwmd400.t$hght               Altura,
whwmd400.t$wdth               Largura,
whwmd400.t$dpth               Comprimento,
znfmd170.t$vpla$c             PLACA

FROM  baandb.tznfmd630601    znfmd630

LEFT JOIN baandb.tznfmd060601 znfmd060
       ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
      AND znfmd060.t$cono$c = znfmd630.t$cono$c

LEFT JOIN baandb.tznfmd065601 znfmd065
       ON znfmd065.t$cfrw$c = znfmd060.t$cfrw$c
      AND znfmd065.t$cono$c = znfmd060.t$cono$c
      AND znfmd065.t$iden$c = znfmd060.t$refe$c
      
LEFT JOIN baandb.tcisli940601 cisli940
       ON cisli940.t$fire$l = znfmd630.t$fire$c
       
LEFT JOIN baandb.ttccom130601 tccom130
       ON tccom130.t$cadr = cisli940.t$stoa$l
       
LEFT JOIN baandb.tznsls401601 znsls401
       ON znsls401.t$orno$c = znfmd630.t$orno$c
       
LEFT JOIN baandb.twhwmd400601 whwmd400
       ON TRIM(TO_CHAR(whwmd400.t$item)) = TRIM(TO_CHAR(znsls401.t$item$c))
       
LEFT JOIN baandb.tznfmd171601 znfmd171
       ON znfmd171.t$ncar$c = znfmd630.t$ncar$c
       
LEFT JOIN baandb.tznfmd170601 znfmd170
       ON znfmd170.t$fili$c = znfmd171.t$fili$c
      AND znfmd170.t$nent$c = znfmd171.t$nent$c
      AND znfmd170.t$cfrw$c = znfmd171.t$cfrw$c

order by ETIQUETA
