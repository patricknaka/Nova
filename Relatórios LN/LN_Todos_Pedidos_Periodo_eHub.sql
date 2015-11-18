SELECT
REGEXP_REPLACE(znsls400.t$fovn$c, '[^0-9]', '')   ID_CLIENTE,
znsls401.t$pecl$c             PEDIDO,
znsls401.t$entr$c             ENTREGA,
CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                              DATA_VENDA,
znsls402.t$idmp$c             MEIO_PAGTO,
'Aprovado'                    SITUACAO_PAGAMENTO,
CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$dtra$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                              DATA_SITUACAO_PAGAMENTO,
znsls410.PT_CONTR             PONTO_PEDIDO,
znsls400.t$idpo$c             ORIGEM

FROM  baandb.tznsls401601 znsls401

INNER JOIN baandb.tznsls400601  znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
       
INNER JOIN baandb.tznsls402601  znsls402
        ON znsls402.t$ncia$c = znsls401.t$ncia$c
       AND znsls402.t$uneg$c = znsls401.t$uneg$c
       AND znsls402.t$pecl$c = znsls401.t$pecl$c
       AND znsls402.t$sqpd$c = znsls401.t$sqpd$c
       
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    max(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) PT_CONTR
               from baandb.tznsls410601 znsls410
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
    
 LEFT JOIN baandb.tznmcs002301 znmcs002
        ON znmcs002.t$poco$c = znsls410.PT_CONTR

        
