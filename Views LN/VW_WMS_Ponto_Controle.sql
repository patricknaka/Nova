SELECT
        t.t$pecl$c PEDIDO,
        t.t$entr$c ENTREGA,
        t.t$poco$c PONTO,
        CAST((FROM_TZ(CAST(TO_CHAR(t.t$dtoc$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
        AT time zone sessiontimezone) AS DATE) DT_PONTO
FROM    
        tznsls410201 t