SELECT
  znfmd630.t$pecl$c  NUME_PEDIDO,
  znfmd630.t$etiq$c  NUME_ETIQUETA

FROM       BAANDB.tznfmd630301 znfmd630
  
INNER JOIN BAANDB.tznmcs086301 znmcs086
        ON znfmd630.t$cfrw$c = znmcs086.t$cfrw$c
       AND znfmd630.t$fili$c = znmcs086.t$bchc$c
  
WHERE znmcs086.t$padr$c = 2
AND ( (:EtiquetaTodas = 0) or (znfmd630.t$etiq$c IN (:Etiqueta) and (:EtiquetaTodas = 1)) )
OR  ( (:EntregaTodas = 0) or (znfmd630.t$pecl$c IN (:Entrega) and (:EntregaTodas = 1)) )