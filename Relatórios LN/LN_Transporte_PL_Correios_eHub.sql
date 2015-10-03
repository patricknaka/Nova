SELECT

znfmd630.t$etiq$c                                   ETIQUETA,
znfmd065.t$cser$c                                   CODIGO_SERVICO,
tccom130.t$pstc                                     CEP_DESTINO,
znfmd630.t$wght$c                                   PESO_TARIFADO,
znfmd630.t$ncar$c                                   CARGA_TMS,
znsls401.t$item$c                                   ITEM,
tcibd001.t$dscb$c                                   DESC_ITEM,
whwmd400.t$hght                                     ALTURA,
whwmd400.t$wdth                                     LARGURA,
whwmd400.t$dpth                                     COMPRIMENTO,
znfmd170.t$vpla$c                                   PLACA,
CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)   DATA_ETR,
znfmd630.t$cfrw$c                                    TRANSPORTADORA

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

LEFT JOIN baandb.ttcibd001601 tcibd001
       ON TRIM(TO_CHAR(tcibd001.t$item)) = TRIM(TO_CHAR(znsls401.t$item$c))
       
LEFT JOIN baandb.tznfmd171601 znfmd171
       ON znfmd171.t$ncar$c = znfmd630.t$ncar$c
       
LEFT JOIN baandb.tznfmd170601 znfmd170
       ON znfmd170.t$fili$c = znfmd171.t$fili$c
      AND znfmd170.t$nent$c = znfmd171.t$nent$c
      AND znfmd170.t$cfrw$c = znfmd171.t$cfrw$c
      
 INNER JOIN ( Select znfmd640.t$fili$c,
                    znfmd640.t$etiq$c,
                    max(znfmd640.t$date$c) t$date$c
               from baandb.tznfmd640601 znfmd640
               where znfmd640.t$coct$c = 'ETR'
           group by znfmd640.t$fili$c,
                    znfmd640.t$etiq$c ) znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c

--WHERE znfmd630.T$CFRW$C = 'T03'

order by ETIQUETA
