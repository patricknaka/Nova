SELECT
  znfmd630.t$pecl$c	NUME_PEDIDO,
  znfmd630.t$etiq$c	NUME_ETIQUETA

FROM
  baandb.tznfmd630201  znfmd630,
  baandb.tznmcs086201  znmcs086
  
WHERE
  znfmd630.t$cfrw$c = znmcs086.t$cfrw$c
AND  
  znfmd630.t$fili$c = znmcs086.t$bchc$c
AND
  znmcs086.t$padr$c = 2 


