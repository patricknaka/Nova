SELECT
  znfmd630.t$pecl$c  NUME_PEDIDO,
  znfmd630.t$etiq$c  NUME_ETIQUETA

FROM       BAANDB.tznfmd630301 znfmd630
  
/*INNER JOIN BAANDB.tznmcs086301 znmcs086
        ON znfmd630.t$cfrw$c = znmcs086.t$cfrw$c  --comentando a condição abaixo o join não é mais necessário
       AND znfmd630.t$fili$c = znmcs086.t$bchc$c
  
WHERE znmcs086.t$padr$c = 2  -- limita os pedidos que foram enviados para os correios
*/
WHERE
     ( (:EtiquetaTodas = '-1') or (znfmd630.t$etiq$c IN (:Etiqueta) and (:EtiquetaTodas = '1')) )
AND  ( (:EntregaTodas = '-1') or (znfmd630.t$pecl$c IN (:Entrega) and (:EntregaTodas = '1')) )
AND  trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.T$DATE$C,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE)) 
between :DataNotaDe
and :DataNotaAte
