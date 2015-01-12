SELECT
  DISTINCT
  znfmd630.t$pecl$c  ENTREGA,
  
  CAST((FROM_TZ(CAST(TO_CHAR(znsls400.t$dtin$c,'DD-MON-YYYY HH:MI:SS AM') AS 
    TIMESTAMP), 'GMT') AT time zone sessiontimezone) AS DATE)  
                     DATA_COMPRA,
  
  ( SELECT znfmd640.t$coci$c
      FROM BAANDB.tznfmd640201 znfmd640
     WHERE znfmd640.t$date$c = ( select max(znfmd640.t$date$c)  
                                  from BAANDB.tznfmd640201 znfmd640
                                 where znfmd640.t$fili$c = znfmd630.t$fili$c
                                   and znfmd640.t$etiq$c = znfmd630.t$etiq$c) 
     AND ROWNUM = 1 )    
                     ULT_PONTO,   

  ( SELECT znfmd030d.t$dsci$c
      FROM BAANDB.tznfmd640201 znfmd640d,
           BAANDB.tznfmd030201 znfmd030d
     WHERE znfmd640d.t$date$c = ( select max(znfmd640x.t$date$c) 
                                    from BAANDB.tznfmd640201 znfmd640x
                                   where znfmd640x.t$fili$c = znfmd630.t$fili$c                                        
                                     and znfmd640x.t$etiq$c = znfmd630.t$etiq$c
                                     and znfmd030d.t$ocin$c = znfmd640d.t$coci$c)
     AND ROWNUM = 1 )
                    DESCRICAO
                      
FROM       BAANDB.tznfmd630201 znfmd630

INNER JOIN BAANDB.tznsls401201 znsls401
        ON znsls401.t$pecl$c = znfmd630.t$pecl$c
       AND znsls401.T$ORNO$C = znfmd630.T$ORNO$C

INNER JOIN BAANDB.tznsls400201 znsls400
        ON znsls401.t$ncia$c = znsls400.t$ncia$c
       AND znsls401.t$uneg$c = znsls400.t$uneg$c
       AND znsls401.t$pecl$c = znsls400.t$pecl$c
       AND znsls401.t$sqpd$c = znsls400.t$sqpd$c
  
WHERE znsls401.t$itpe$c = 5 --Agendado
  
  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE))
      BETWEEN :Data_Compra_De
          AND :Data_Compra_Ate