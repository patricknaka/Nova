SELECT
        pt_vale.dtoc                         DT_EMISSAO_VALE,
        ABS(znsls402.t$vlmr$c)               VALOR_VALE,
        tfacr201.t$liqd                      DATA_VALIDADE,
        znsls400.t$fovn$c                    CPF_CLIENTE,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                                             ULTIMA_ALTERACAO,
        znsls402.t$pecl$c                    PEDIDO_CLIENTE,
        znsls402.t$sqpd$c                    PEDIDO_SEQ

FROM    baandb.tznsls402601 znsls402

  INNER JOIN baandb.tznsls400601 znsls400
          ON znsls400.t$ncia$c = znsls402.t$ncia$c
         AND znsls400.t$uneg$c = znsls402.t$uneg$c
         AND znsls400.t$pecl$c = znsls402.t$pecl$c
         AND znsls400.t$sqpd$c = znsls402.t$sqpd$c
       
 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    max(a.t$dtoc$c) DATA_OCORR,
                    MAX(a.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C,  a.T$SEQN$C) PT_CONTR
               from baandb.tznsls410601 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls402.t$ncia$c
       AND znsls410.t$uneg$c = znsls402.t$uneg$c
       AND znsls410.t$pecl$c = znsls402.t$pecl$c
       AND znsls410.t$sqpd$c = znsls402.t$sqpd$c

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    max(a.t$dtoc$c) dtoc
               from baandb.tznsls410601 a
               where a.t$poco$c = 'VAL'
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c ) pt_vale
        ON pt_vale.t$ncia$c = znsls402.t$ncia$c
       AND pt_vale.t$uneg$c = znsls402.t$uneg$c
       AND pt_vale.t$pecl$c = znsls402.t$pecl$c
       AND pt_vale.t$sqpd$c = znsls402.t$sqpd$c
       
 LEFT JOIN baandb.tznmcs002301 znmcs002
        ON znmcs002.t$poco$c = znsls410.PT_CONTR
   
  LEFT JOIN baandb.tznsls412601 znsls412
         ON znsls412.t$ncia$c = znsls402.t$ncia$c
        AND znsls412.t$uneg$c = znsls402.t$uneg$c
        AND znsls412.t$pecl$c = znsls402.t$pecl$c
        AND znsls412.t$sqpd$c = znsls402.t$sqpd$c
        AND znsls412.t$sequ$c = znsls402.t$sequ$c
        
  LEFT JOIN baandb.ttfacr201601 tfacr201
         ON tfacr201.t$ttyp = znsls412.t$ttyp$c
        AND tfacr201.t$ninv = znsls412.t$ninv$c

WHERE znsls402.t$idmp$c = 4   --Vale
  AND znsls402.t$vlmr$c < 0   --Reembolso
  AND pt_vale.dtoc IS NOT NULL  --somente pedidos com vale emitido
     
order by znsls400.t$DTEM$c, ZNSLS402.T$PECL$C
