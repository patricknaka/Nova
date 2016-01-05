SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(NVL(pt_vale.dtoc,znsls400.t$dtem$c), 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)                         
                                            DT_EMISSAO_VALE,
       ABS(znsls402.t$vlmr$c)               VALOR_VALE,
       tfacr201.t$liqd                      DATA_VALIDADE,
       znsls400.t$fovn$c                    CPF_CLIENTE,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacr200.t$rcd_utc, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)
                                            ULTIMA_ALTERACAO,
       znsls402.t$pecl$c                    PEDIDO_CLIENTE,
       znsls402.t$sqpd$c                    PEDIDO_SEQ,
       tfacr200.t$balc

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
       
 LEFT JOIN ( select a.t$ncia$c,
                  a.t$uneg$c,
                  a.t$pecl$c,
                  a.t$sqpd$c,
                  max(a.t$dtoc$c) dtoc
             from baandb.tznsls410601 a
            where a.t$poco$c = 'CAN'
         group by a.t$ncia$c,
                  a.t$uneg$c,
                  a.t$pecl$c,
                  a.t$sqpd$c ) pt_cancel
        ON pt_cancel.t$ncia$c = znsls402.t$ncia$c
       AND pt_cancel.t$uneg$c = znsls402.t$uneg$c
       AND pt_cancel.t$pecl$c = znsls402.t$pecl$c
       AND pt_cancel.t$sqpd$c = znsls402.t$sqpd$c
       
 LEFT JOIN baandb.tznsls412601 znsls412
        ON znsls412.t$ncia$c = znsls402.t$ncia$c
       AND znsls412.t$uneg$c = znsls402.t$uneg$c
       AND znsls412.t$pecl$c = znsls402.t$pecl$c
       AND znsls412.t$sqpd$c = znsls402.t$sqpd$c
       AND znsls412.t$sequ$c = znsls402.t$sequ$c
       
 LEFT JOIN baandb.ttfacr201601 tfacr201
        ON tfacr201.t$ttyp = znsls412.t$ttyp$c
       AND tfacr201.t$ninv = znsls412.t$ninv$c
 
 LEFT JOIN ( select a.t$ttyp,
                    a.t$ninv,
                    a.t$amnt,
                    a.t$balc,
                    a.t$rcd_utc
             from  baandb.ttfacr200601 a
             where a.t$docn = 0 ) tfacr200
        ON tfacr200.t$ttyp = znsls412.t$ttyp$c
       AND tfacr200.t$ninv = znsls412.t$ninv$c
        
WHERE znsls402.t$idmp$c = 4                         --Meio de Pagto tipo Vale
  AND pt_cancel.dtoc IS NULL                        --Restrição para pedidos cancelados
  AND ( znsls402.t$vlmr$c > 0 OR                    --Vales utilizados
       (     znsls402.t$vlmr$c < 0 
         AND pt_vale.dtoc IS NOT NULL  
         AND tfacr200.t$balc = tfacr200.t$amnt ) )  --Vales emitidos e não utilizados
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(pt_vale.dtoc, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataEmissaoDe
          And :DataEmissaoAte
     
ORDER BY DT_EMISSAO_VALE, 
         PEDIDO_CLIENTE,
         PEDIDO_SEQ
		 
		 
		 
" SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(NVL(pt_vale.dtoc,znsls400.t$dtem$c),  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                             DT_EMISSAO_VALE,  " &
"        ABS(znsls402.t$vlmr$c)               VALOR_VALE,  " &
"        tfacr201.t$liqd                      DATA_VALIDADE,  " &
"        znsls400.t$fovn$c                    CPF_CLIENTE,  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacr200.t$rcd_utc,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                             ULTIMA_ALTERACAO,  " &
"        znsls402.t$pecl$c                    PEDIDO_CLIENTE,  " &
"        znsls402.t$sqpd$c                    PEDIDO_SEQ,  " &
"        tfacr200.t$balc  " &
"  " &
" FROM    baandb.tznsls402" + Parameters!Compania.Value + " znsls402  " &
"  " &
" INNER JOIN baandb.tznsls400" + Parameters!Compania.Value + " znsls400  " &
"         ON znsls400.t$ncia$c = znsls402.t$ncia$c  " &
"        AND znsls400.t$uneg$c = znsls402.t$uneg$c  " &
"        AND znsls400.t$pecl$c = znsls402.t$pecl$c  " &
"        AND znsls400.t$sqpd$c = znsls402.t$sqpd$c  " &
"  " &
"  LEFT JOIN ( select a.t$ncia$c,  " &
"                     a.t$uneg$c,  " &
"                     a.t$pecl$c,  " &
"                     a.t$sqpd$c,  " &
"                     max(a.t$dtoc$c) dtoc  " &
"                from baandb.tznsls410" + Parameters!Compania.Value + " a  " &
"                where a.t$poco$c = 'VAL'  " &
"            group by a.t$ncia$c,  " &
"                     a.t$uneg$c,  " &
"                     a.t$pecl$c,  " &
"                     a.t$sqpd$c ) pt_vale  " &
"         ON pt_vale.t$ncia$c = znsls402.t$ncia$c  " &
"        AND pt_vale.t$uneg$c = znsls402.t$uneg$c  " &
"        AND pt_vale.t$pecl$c = znsls402.t$pecl$c  " &
"        AND pt_vale.t$sqpd$c = znsls402.t$sqpd$c  " &
"  " &
"  LEFT JOIN ( select a.t$ncia$c,  " &
"                   a.t$uneg$c,  " &
"                   a.t$pecl$c,  " &
"                   a.t$sqpd$c,  " &
"                   max(a.t$dtoc$c) dtoc  " &
"              from baandb.tznsls410" + Parameters!Compania.Value + " a  " &
"             where a.t$poco$c = 'CAN'  " &
"          group by a.t$ncia$c,  " &
"                   a.t$uneg$c,  " &
"                   a.t$pecl$c,  " &
"                   a.t$sqpd$c ) pt_cancel  " &
"         ON pt_cancel.t$ncia$c = znsls402.t$ncia$c  " &
"        AND pt_cancel.t$uneg$c = znsls402.t$uneg$c  " &
"        AND pt_cancel.t$pecl$c = znsls402.t$pecl$c  " &
"        AND pt_cancel.t$sqpd$c = znsls402.t$sqpd$c  " &
"  " &
"  LEFT JOIN baandb.tznsls412" + Parameters!Compania.Value + " znsls412  " &
"         ON znsls412.t$ncia$c = znsls402.t$ncia$c  " &
"        AND znsls412.t$uneg$c = znsls402.t$uneg$c  " &
"        AND znsls412.t$pecl$c = znsls402.t$pecl$c  " &
"        AND znsls412.t$sqpd$c = znsls402.t$sqpd$c  " &
"        AND znsls412.t$sequ$c = znsls402.t$sequ$c  " &
"  " &
"  LEFT JOIN baandb.ttfacr201" + Parameters!Compania.Value + " tfacr201  " &
"         ON tfacr201.t$ttyp = znsls412.t$ttyp$c  " &
"        AND tfacr201.t$ninv = znsls412.t$ninv$c  " &
"  " &
"  LEFT JOIN ( select a.t$ttyp,  " &
"                     a.t$ninv,  " &
"                     a.t$amnt,  " &
"                     a.t$balc,  " &
"                     a.t$rcd_utc  " &
"              from  baandb.ttfacr200" + Parameters!Compania.Value + " a  " &
"              where a.t$docn = 0 ) tfacr200  " &
"         ON tfacr200.t$ttyp = znsls412.t$ttyp$c  " &
"        AND tfacr200.t$ninv = znsls412.t$ninv$c  " &
"  " &
" WHERE znsls402.t$idmp$c = 4  " &
"   AND pt_cancel.dtoc IS NULL  " &
"   AND ( znsls402.t$vlmr$c > 0 OR  " &
"        (     znsls402.t$vlmr$c < 0  " &
"          AND pt_vale.dtoc IS NOT NULL  " &
"          AND tfacr200.t$balc = tfacr200.t$amnt ) )  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(pt_vale.dtoc,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataEmissaoDe  " &
"           And :DataEmissaoAte  " &
"  " &
" ORDER BY DT_EMISSAO_VALE,  " &
"          PEDIDO_CLIENTE,  " &
"          PEDIDO_SEQ  "