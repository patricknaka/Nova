SELECT           
        tfacr200.t$docd                      DT_EMISSAO_VALE,
        ABS(tfacr200.t$amnt)                 VALOR_VALE,
        ABS(tfacr200.t$balc)                 SALDO_VALE, 
        tfacr201.t$liqd                      DATA_VALIDADE,
        znacr200.t$fovn$c                    CPF_CLIENTE,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacr200.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                                             ULTIMA_ALTERACAO,
        znacr200.t$pecl$c                    PEDIDO_CLIENTE,
        znacr200.t$sgpd$c                    PEDIDO_SEQ,
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
              from  baandb.ttfacr200601 a
              where a.t$docn = 0 ) tfacr200
         ON tfacr200.t$ttyp = znacr200.t$ttyp$c
        AND tfacr200.t$ninv = znacr200.t$ninv$c
        
 LEFT JOIN baandb.tzngld006301 zngld006
        ON zngld006.t$code$c = znacr200.t$code$c

INNER JOIN ( SELECT d.t$cnst CODE_STAT, 
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
        
WHERE pt_cancel.pecl IS NULL      --Pedidos não cancelados
  AND tfacr200.t$balc != 0        --Vales com saldo

order by DT_EMISSAO_VALE, znacr200.t$ttyp$c, znacr200.t$ninv$c

		 
		 
		 
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
