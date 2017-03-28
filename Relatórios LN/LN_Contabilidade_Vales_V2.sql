SELECT DISTINCT 
  znacr200.t$bpid$c,
  301                   NUM_CIA,
  znacr200.t$dim2$c     NUM_FILIAL,
  znacr200.t$date$c     DTA_CRIACAO,  
  znacr200.t$pecl$c     NUM_ORDEM,
  znacr200.t$fovn$c     CPF_CLIENTE,
  tccom100.t$nama       NOME_CLIENTE,
  znacr200.t$code$c     NUM_VALE, 
  zngld006.t$desc$c     DESC_NUM_VALE, 
  zngld006.t$type$c     TIPO_VALE, 
  DTYPE.                DESC_TIPO_VALE,
  ABS(tfacr201.t$amnt)  VALOR_ORIGINAL,
  tfacr201.t$dued$l     DTA_VENCIMENTO,
  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$dtra$c, 
  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) 
                        DTA_UTILIZACAO, 
  
  znsls402.t$vlpg$c     VLR_UTILIZADO,
  ABS(tfacr201.t$balc)  VALE_SALDO,
  CASE
    WHEN tfacr201.t$dued$l < sysdate THEN 'Expirado' 
    WHEN tfacr201.t$balc   = 0       THEN 'Utilizado' 
    ELSE                                  'Aberto'
  END                   VALE_STATUS,
 zngld013.T$USER$C     USER_CRIACAO, 
 zngld013.T$APRO$C     USER_APROVACAO,
 tfgld010.t$desc              FILIAL_DESC,
 znint001.t$dsca$c          COMPANIA_DESC

FROM       baandb.ttfacr201301 tfacr201

 LEFT JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid = tfacr201.T$ITBP
        
INNER JOIN BAANDB. tznacr200301 znacr200
        ON znacr200.t$ttyp$c = tfacr201.t$ttyp
       AND znacr200.t$ninv$c = tfacr201.t$ninv

 LEFT JOIN baandb.tzngld006301 zngld006
        ON zngld006.t$code$c = znacr200.t$code$c
          
LEFT JOIN baandb.tznsls402301 znsls402
        ON znsls402.t$ncia$c = znacr200.t$ncia$c 
       AND znsls402.t$uneg$c = znacr200.t$UNEG$c 
       AND znsls402.t$pecl$c = znacr200.t$pecl$c 
       AND znsls402.t$sqpd$c = znacr200.t$sgpd$c 

INNER JOIN ( SELECT d.t$cnst CODE_STAT, 
                    l.t$desc DESC_TIPO_VALE
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
                                            and l1.t$cpac = l.t$cpac ) ) DTYPE
        ON DTYPE.CODE_STAT = zngld006.t$type$c

left join baandb.tzngld013301 zngld013
       on zngld013.T$NINV$C = znacr200.T$NINV$C
      and zngld013.T$TTYP$C = znacr200.T$TTYP$C

left join baandb.tznint001301 znint001
       on znint001.t$ncia$c = zngld013.t$ncia$c
       
left join baandb.ttfgld010301 tfgld010
       on tfgld010.t$dimx = zngld013.t$dim2$c
                      
WHERE znacr200.t$date$c BETWEEN :DTA_CRIACAO_DE AND :DTA_CRIACAO_ATE
  AND zngld006.t$type$c IN (:TipoVale)

  AND ( CASE WHEN tfacr201.t$dued$l < sysdate THEN 1  --'Expirado' 
             WHEN tfacr201.t$balc   = 0       THEN 0  --'Utilizado' 
             ELSE                                  2  --'Aberto'
         END ) in (:StatusVale)
