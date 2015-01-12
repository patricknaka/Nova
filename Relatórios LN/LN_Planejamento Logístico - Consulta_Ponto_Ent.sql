SELECT
DISTINCT
  znfmd630.t$pecl$c   ENTREGA,
  znfmd640.t$coci$c	  PONTO,
  CAST((FROM_TZ(CAST(TO_CHAR(znfmd640.t$date$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
                      AT time zone sessiontimezone) AS DATE)     
                      DATA_PONTO,
  CAST((FROM_TZ(CAST(TO_CHAR(znfmd640.t$udat$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
                      AT time zone sessiontimezone) AS DATE)
                      DATA_PROCESSAMENTO
                      
FROM
  baandb.tznfmd630201 znfmd630,
  baandb.tznfmd640201 znfmd640
  
WHERE
  znfmd640.t$coci$c = 'ENT'
AND  
  znfmd640.t$fili$c = znfmd630.t$fili$c 
AND
  znfmd640.t$etiq$c = znfmd630.t$etiq$c

