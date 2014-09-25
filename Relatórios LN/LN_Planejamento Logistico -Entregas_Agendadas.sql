SELECT
  DISTINCT
  znfmd630.t$pecl$c ENTREGA,
  CAST((FROM_TZ(CAST(TO_CHAR(znsls400.t$dtin$c, 	'DD-MON-YYYY HH:MI:SS AM') AS 
                                                    TIMESTAMP), 'GMT') AT time zone sessiontimezone) AS DATE)  
                    DATA_COMPRA, 
                    ( SELECT  znfmd640.t$coci$c
                      FROM    BAANDB.tznfmd640201 znfmd640
                      WHERE   znfmd640.t$date$c =  (
                                        SELECT  MAX(znfmd640.t$date$c)	
                                        FROM    BAANDB.tznfmd640201 znfmd640
                                        WHERE   znfmd640.t$fili$c = znfmd630.t$fili$c
                                        AND     znfmd640.t$etiq$c = znfmd630.t$etiq$c) AND ROWNUM=1)	  
                    ULT_PONTO,   
                    ( SELECT  znfmd030d.t$dsci$c
                      FROM    BAANDB.tznfmd640201 znfmd640d,
                              BAANDB.tznfmd030201 znfmd030d
                      WHERE   znfmd640d.t$date$c = (
                                        SELECT  MAX(znfmd640x.t$date$c) 
                                        FROM    BAANDB.tznfmd640201 znfmd640x
                                        WHERE   znfmd640x.t$fili$c = znfmd630.t$fili$c                                        
                                        AND     znfmd640x.t$etiq$c = znfmd630.t$etiq$c
                                        AND     znfmd030d.t$ocin$c = znfmd640d.t$coci$c)
                                        AND ROWNUM = 1)
                    DESCRICAO
                      
FROM
  BAANDB. tznfmd630201 znfmd630,
  BAANDB. tznsls400201 znsls400,  
  BAANDB. tznsls401201 znsls401
  
WHERE
  znsls401.t$itpe$c = 5 -- Agendado
AND
  znsls401.t$pecl$c = znfmd630.t$pecl$c 
AND
  znsls401.T$ORNO$C = znfmd630.T$ORNO$C
AND      
  znsls401.t$ncia$c = znsls400.t$ncia$c
AND  
  znsls401.t$uneg$c = znsls400.t$uneg$c
AND  
  znsls401.t$pecl$c = znsls400.t$pecl$c
AND  
  znsls401.t$sqpd$c = znsls400.t$sqpd$c