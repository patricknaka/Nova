SELECT           
        tfacr200.t$docd                      DT_EMISSAO_VALE,
        ABS(tfacr200.t$amnt)                 VALOR_VALE,
        ABS(tfacr200.t$balc)                 SALDO_VALE, 
        tfacr201.t$liqd                      DATA_VALIDADE,
        znacr200.t$fovn$c                    CPF_CLIENTE,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacr200.t$rcd_utc, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)
                                             ULTIMA_ALTERACAO,
        znacr200.t$pecl$c                    PEDIDO_CLIENTE,
        SUBSTR(znsls401.t$entr$c, LENGTH(znsls401.t$entr$c)-1, 2)     
                                             ENTREGA_SEQ,
        TIPO_VALE.DESCR                      TIPO_VALE

FROM    baandb.tznacr200601 znacr200
       
 LEFT JOIN ( select a.t$ncia$c ncia,
                    a.t$uneg$c uneg,
                    a.t$pecl$c pecl
               from baandb.tznsls410601 a
              where a.t$poco$c = 'CAN'
           group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c ) pt_cancel
        ON pt_cancel.ncia = znacr200.t$ncia$c
       AND pt_cancel.uneg = znacr200.t$uneg$c
       AND pt_cancel.pecl = znacr200.t$pecl$c
        
 LEFT JOIN baandb.ttfacr201601 tfacr201
        ON tfacr201.t$ttyp = znacr200.t$ttyp$c
       AND tfacr201.t$ninv = znacr200.t$ninv$c

 LEFT JOIN ( select a.t$ttyp,
                    a.t$ninv,
                    a.t$amnt,
                    a.t$balc,
                    a.t$docd,
                    a.t$itbp,
                    a.t$rcd_utc  
               from baandb.ttfacr200601 a
              where a.t$docn = 0 ) tfacr200
        ON tfacr200.t$ttyp = znacr200.t$ttyp$c
       AND tfacr200.t$ninv = znacr200.t$ninv$c
        
 LEFT JOIN baandb.tzngld006301 zngld006
        ON zngld006.t$code$c = znacr200.t$code$c

 LEFT JOIN ( SELECT d.t$cnst CODE_STAT, 
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'zn' 
                AND d.t$cdom = 'gld.vale.c'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'zn'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) TIPO_VALE
        ON TIPO_VALE.CODE_STAT = zngld006.t$type$c

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    min(a.t$entr$c) t$entr$c
              from baandb.tznsls401601 a
              group by a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c ) znsls401
        ON znsls401.t$ncia$c = znacr200.t$ncia$c
       AND znsls401.t$uneg$c = znacr200.t$uneg$c
       AND znsls401.t$pecl$c = znacr200.t$pecl$c
       AND znsls401.t$sqpd$c = znacr200.t$sgpd$c
                       
       
WHERE pt_cancel.pecl IS NULL      --Pedidos não cancelados
  AND tfacr200.t$balc != 0        --Vales com saldo
  AND Trunc(tfacr200.t$docd)
      Between :DataEmissaoDe
          And :DataEmissaoAte
  AND NVL(zngld006.t$type$c, 0) IN (:TipoVale)
  
ORDER BY DT_EMISSAO_VALE


=

" SELECT  " &
"         tfacr200.t$docd                      DT_EMISSAO_VALE,  " &
"         ABS(tfacr200.t$amnt)                 VALOR_VALE,  " &
"         ABS(tfacr200.t$balc)                 SALDO_VALE,  " &
"         tfacr201.t$liqd                      DATA_VALIDADE,  " &
"         znacr200.t$fovn$c                    CPF_CLIENTE,  " &
"         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacr200.t$rcd_utc,  " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                              ULTIMA_ALTERACAO,  " &
"         znacr200.t$pecl$c                    PEDIDO_CLIENTE,  " &
"         SUBSTR(znsls401.t$entr$c, LENGTH(znsls401.t$entr$c)-1, 2)  " &
"                                              ENTREGA_SEQ,  " &
"         TIPO_VALE.DESCR                      TIPO_VALE  " &
"  " &
" FROM    baandb.tznacr200" + Parameters!Compania.Value + " znacr200  " &
"  " &
"  LEFT JOIN ( select a.t$ncia$c ncia,  " &
"                     a.t$uneg$c uneg,  " &
"                     a.t$pecl$c pecl  " &
"                from baandb.tznsls410" + Parameters!Compania.Value + " a  " &
"               where a.t$poco$c = 'CAN'  " &
"            group by a.t$ncia$c,  " &
"                       a.t$uneg$c,  " &
"                       a.t$pecl$c ) pt_cancel  " &
"         ON pt_cancel.ncia = znacr200.t$ncia$c  " &
"        AND pt_cancel.uneg = znacr200.t$uneg$c  " &
"        AND pt_cancel.pecl = znacr200.t$pecl$c  " &
"  " &
"  LEFT JOIN baandb.ttfacr201" + Parameters!Compania.Value + " tfacr201  " &
"         ON tfacr201.t$ttyp = znacr200.t$ttyp$c  " &
"        AND tfacr201.t$ninv = znacr200.t$ninv$c  " &
"  " &
"  LEFT JOIN ( select a.t$ttyp,  " &
"                     a.t$ninv,  " &
"                     a.t$amnt,  " &
"                     a.t$balc,  " &
"                     a.t$docd,  " &
"                     a.t$itbp,  " &
"                     a.t$rcd_utc  " &
"                from baandb.ttfacr200" + Parameters!Compania.Value + " a  " &
"               where a.t$docn = 0 ) tfacr200  " &
"         ON tfacr200.t$ttyp = znacr200.t$ttyp$c  " &
"        AND tfacr200.t$ninv = znacr200.t$ninv$c  " &
"  " &
"  LEFT JOIN baandb.tzngld006301 zngld006  " &
"         ON zngld006.t$code$c = znacr200.t$code$c  " &
"  " &
"  LEFT JOIN ( SELECT d.t$cnst CODE_STAT,  " &
"                     l.t$desc DESCR  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'zn'  " &
"                 AND d.t$cdom = 'gld.vale.c'  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'zn'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) TIPO_VALE  " &
"         ON TIPO_VALE.CODE_STAT = zngld006.t$type$c  " &
"  " &
"  LEFT JOIN ( select a.t$ncia$c,  " &
"                     a.t$uneg$c,  " &
"                     a.t$pecl$c,  " &
"                     a.t$sqpd$c,  " &
"                     min(a.t$entr$c) t$entr$c  " &
"               from baandb.tznsls401" + Parameters!Compania.Value + " a  " &
"               group by a.t$ncia$c,  " &
"                        a.t$uneg$c,  " &
"                        a.t$pecl$c,  " &
"                        a.t$sqpd$c ) znsls401  " &
"         ON znsls401.t$ncia$c = znacr200.t$ncia$c  " &
"        AND znsls401.t$uneg$c = znacr200.t$uneg$c  " &
"        AND znsls401.t$pecl$c = znacr200.t$pecl$c  " &
"        AND znsls401.t$sqpd$c = znacr200.t$sgpd$c  " &
"  " &
"  " &
" WHERE pt_cancel.pecl IS NULL  " &
"   AND tfacr200.t$balc != 0  " &
"   AND Trunc(tfacr200.t$docd)  " &
"       Between :DataEmissaoDe  " &
"           And :DataEmissaoAte  " &
"   AND NVL(zngld006.t$type$c, 0) IN (" + JOIN(Parameters!TipoVale.Value, ", ") + ") " &
"  " &
" ORDER BY DT_EMISSAO_VALE "