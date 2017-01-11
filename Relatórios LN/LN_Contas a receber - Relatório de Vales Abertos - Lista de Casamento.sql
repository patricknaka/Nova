SELECT
  znacr200.t$vale$c     VALE, 
  tfacr200.t$styp       TIPO_VENDA,
  znacr200.t$fovn$c     CPF_CLIENTE,
  tccom100.t$nama       NOME_CLIENTE,  
  znacr200.t$date$c     DATA_CRIACAO,
  tfacr201.t$dued$l     DATA_VENCIMENTO,
  tfacr201.t$amnt       VALOR,
  tfacr201.t$balc       SALDO

FROM  baandb.ttfacr200301 tfacr200  

INNER JOIN baandb.ttfacr201301 tfacr201
        ON tfacr201.t$ttyp = tfacr200.t$ttyp
       AND tfacr201.t$ninv = tfacr200.t$ninv
       
 LEFT JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid = tfacr201.T$ITBP
        
LEFT JOIN BAANDB. tznacr200301 znacr200
        ON znacr200.t$ttyp$c = tfacr201.t$ttyp
       AND znacr200.t$ninv$c = tfacr201.t$ninv
          
LEFT JOIN baandb.tznsls402301 znsls402
        ON znsls402.t$ncia$c = znacr200.t$ncia$c 
       AND znsls402.t$uneg$c = znacr200.t$UNEG$c 
       AND znsls402.t$pecl$c = znacr200.t$pecl$c 
       AND znsls402.t$sqpd$c = znacr200.t$sgpd$c 
 
where tfacr200.t$lino = 0
  and tfacr200.t$styp = 'VLISTA'
  and tfacr201.t$balc != 0
