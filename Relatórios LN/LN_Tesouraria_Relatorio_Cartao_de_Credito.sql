SELECT DISTINCT

tfacr200.t$docd                       DATA_DE_VENDA,
tfacr200.t$ninv                       TITULO,
tfacr200.t$ttyp                       TIPO_TRANSACAO,
znsls402.t$maqu$c                     MAQUINETA,
tfacr201.t$schn                       PARCELA,
tfacr201.t$amnt                       VALOR_TITULO,
(tfacr201.t$balc - tfacr201.t$bala)   SALDO_TITULO,
STATUS.Descr                          STATUS,
tfacr201.t$recd                       VENCIMENTO

FROM  baandb.ttfacr200301   tfacr200

LEFT JOIN baandb.ttfacr201301   tfacr201
       ON tfacr201.t$ttyp=tfacr200.t$ttyp
      AND tfacr201.t$ninv=tfacr200.t$ninv
      
LEFT JOIN baandb.tznsls412301 znsls412
       ON znsls412.t$ttyp$c=tfacr200.t$ttyp
      AND znsls412.t$ninv$c=tfacr200.t$ninv

LEFT JOIN baandb.tznsls402301   znsls402
       ON znsls402.t$ncia$c=znsls412.t$ncia$c
      AND znsls402.t$uneg$c=znsls412.t$uneg$c
      AND znsls402.t$pecl$c=znsls412.t$pecl$c
      AND znsls402.t$sqpd$c=znsls412.t$sqpd$c
      
 LEFT JOIN ( SELECT l.t$desc DESCR,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'acr.strp.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) STATUS
    ON STATUS.t$cnst=tfacr201.T$RPST$L

                
WHERE tfacr200.t$lino=0
AND   znsls402.t$idmp$c=1       --Meio de Pagamento Cartão de Crédito

order by tfacr200.T$TTYP, tfacr200.T$NINV, tfacr201.t$schn
      
