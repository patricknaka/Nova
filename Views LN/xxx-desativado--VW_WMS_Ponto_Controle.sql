SELECT
        t.t$pecl$c NR_PEDIDO,
        t.t$entr$c NR_ENTREGA,
        t.t$poco$c CD_PONTO,
        CAST((FROM_TZ(CAST(TO_CHAR(t.t$dtoc$c, 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT') 
        AT time zone sessiontimezone) AS DATE) DT_PONTO
FROM    
        baandb.tznsls410201 t