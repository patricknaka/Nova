SELECT DISTINCT
    ZNSLS401.T$PECL$C                           PEDIDO,
    ZNSLS401.T$SQPD$C                           SEQ,
    ZNSLS401.T$ENTR$C                           ENTREGA,
    ZNSLS401.T$ORNO$C                           ORDEM_VENDA,
    ZNSLS410.PT_CONTR                           STATUS_PEDIDO,
    ZNMCS002.T$DESC$C                           DESC_STATUS,
    ZNSLS400.T$DTIN$C                           DATA_PEDIDO,
    ZNSLS401.T$VLUN$C * ZNSLS401.T$QTVE$C       VALOR_PEDIDO

FROM BAANDB.TZNSLS401301  ZNSLS401

    LEFT JOIN BAANDB.TZNSLS400301 ZNSLS400
           ON ZNSLS400.T$NCIA$C = ZNSLS401.T$NCIA$C
          AND ZNSLS400.T$UNEG$C = ZNSLS401.T$UNEG$C
          AND ZNSLS400.T$PECL$C = ZNSLS401.T$PECL$C
          AND ZNSLS400.T$SQPD$C = ZNSLS401.T$SQPD$C

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    znsls410.t$entr$c,
                    max(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) PT_CONTR
               from baandb.tznsls410301 znsls410
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$entr$c = znsls401.t$entr$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c

 LEFT JOIN baandb.tznmcs002301 znmcs002
        ON znmcs002.t$poco$c = znsls410.PT_CONTR
        
WHERE ZNSLS401.T$IDOR$C = 'TD'
AND   ZNSLS401.T$QTVE$C > 0         --Troca
