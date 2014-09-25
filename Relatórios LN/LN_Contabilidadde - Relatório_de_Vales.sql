SELECT DISTINCT 
  znacr200.t$bpid$c,
  201                   NUM_CIA,
  znacr200.t$dim2$c     NUM_FILIAL,
  znacr200.t$date$c     DTA_CRIACAO,  
  znacr200.t$pecl$c     NUM_ORDEM,
  znacr200.t$fovn$c     CPF_CLIENTE,
  tccom100.t$nama       NOME_CLIENTE,
  znacr200.t$code$c     NUM_VALE, 
  zngld006.t$desc$c     DESC_NUM_VALE, 
  zngld006.t$type$c     TIPO_VALE, DESC_TIPO_VALE,
  ABS(tfacr201.t$amnt)  VALOR_ORIGINAL,
  tfacr201.t$dued$l     DTA_VENCIMENTO,
  znsls402.t$dtra$c     DTA_UTILIZACAO,
  znsls402.t$vlpg$c     VLR_UTILIZADO,
  ABS(tfacr201.t$balc)  VALE_SALDO,
  CASE
    WHEN tfacr201.t$dued$l < sysdate THEN 'Expirado' 
    WHEN tfacr201.t$balc   = 0       THEN 'Utilizado' 
    ELSE                                  'Aberto'
  END                   VALE_STATUS 

FROM      baandb.ttfacr201201  tfacr201

LEFT JOIN baandb.ttccom100201  tccom100
       ON tccom100.t$bpid = tfacr201.T$ITBP, 
        
          BAANDB. tznacr200201  znacr200

LEFT JOIN baandb.tzngld006201  zngld006
       ON zngld006.t$code$c = znacr200.t$code$c,
          
		  baandb.tznsls402201  znsls402,

  ( SELECT d.t$cnst CODE_STAT, l.t$desc DESC_TIPO_VALE
      FROM baandb.tttadv401000 d, 
           baandb.tttadv140000 l 
     WHERE d.t$cpac = 'zn' 
       AND d.t$cdom = 'gld.vale.c'
       AND d.t$vers = 'B61U'
       AND d.t$rele = 'a7'
       AND l.t$clab = d.t$za_clab
       AND l.t$clan = 'p'
       AND l.t$cpac = 'zn'
       AND l.t$vers = ( select max(l1.t$vers) 
                          from baandb.tttadv140000 l1 
                         where l1.t$clab = l.t$clab 
                           and l1.t$clan = l.t$clan 
                           and l1.t$cpac = l.t$cpac)) DTYPE
                      
WHERE zngld006.t$type$c = DTYPE.CODE_STAT                      
  AND tfacr201.t$ttyp   = znacr200.t$ttyp$c
  AND tfacr201.t$ninv   = znacr200.t$ninv$c
  AND znsls402.t$ncia$c = znacr200.t$ncia$c 
  AND znsls402.t$uneg$c = znacr200.t$UNEG$c 
  AND znsls402.t$pecl$c = znacr200.t$pecl$c 
  AND znsls402.t$sqpd$c = znacr200.t$sgpd$c  
  
  AND znacr200.t$date$c BETWEEN :DTA_CRIACAO_DE AND :DTA_CRIACAO_ATE
  AND Trunc(tfacr201.t$dued$l) BETWEEN :DTA_VENCIMENTO_DE AND :DTA_VENCIMENTO_ATE
  AND Trunc(znsls402.t$dtra$c) BETWEEN :DTA_UTILIZACAO_DE AND :DTA_UTILIZACAO_ATE
  AND zngld006.t$type$c IN (:TipoVale)

  AND ( CASE WHEN tfacr201.t$dued$l < sysdate THEN 1  --'Expirado' 
             WHEN tfacr201.t$balc   = 0       THEN 0  --'Utilizado' 
             ELSE                                  2  --'Aberto'
         END ) = :StatusVale
