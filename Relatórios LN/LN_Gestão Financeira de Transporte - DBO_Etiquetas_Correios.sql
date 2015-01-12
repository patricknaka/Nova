SELECT
  znfmd630.t$pecl$c  NUME_PEDIDO,
  znfmd630.t$etiq$c  NUME_ETIQUETA

FROM       BAANDB.tznfmd630201 znfmd630
  
INNER JOIN BAANDB.tznmcs086201 znmcs086
        ON znfmd630.t$cfrw$c = znmcs086.t$cfrw$c
       AND znfmd630.t$fili$c = znmcs086.t$bchc$c
  
WHERE znmcs086.t$padr$c = 2
  AND znfmd630.t$etiq$c in (:Etiqueta)


