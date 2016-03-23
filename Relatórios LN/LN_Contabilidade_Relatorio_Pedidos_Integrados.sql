SELECT
  DISTINCT
    znsls400.t$ncia$c  CIA,
    znsls400.t$uneg$c  UNID_NEGOCIO,
    znsls400.t$pecl$c  PEDIDO,      
    znsls400.t$sqpd$c  SEQ_PEDIDO,
    znsls402.t$sequ$c  SEQ_PAGAMENTO,
    znsls402.t$cccd$c  NUM_BANDEIRA,
    zncmg009.t$desc$c  DSC_BANDEIRA,
    znsls402.t$idad$c  ID_ADQUIRENTE, 
    znsls402.t$idmp$c  NUM_MEIO_PAGTO,  
    zncmg007.t$desc$c  DSC_MEIO_PAGTO, 
    znsls400.t$nomf$c  NOME_CLIENTE, 
    znsls402.t$cpft$c  CPF_CLIENTE, 
    znsls402.t$vlmr$c  VALOR_MEIO_PGTO,
    znsls412.t$ttyp$c  TIPO_TRANSACAO,
    znsls412.t$ninv$c  DOC_TRANSACAO,
 
    CASE WHEN tfgld018.t$dcdt < TO_DATE('01/01/1990','DD/MM/YYYY') THEN NULL
         ELSE tfgld018.t$dcdt END AS DATA_DOC
 
FROM      baandb.tznsls400301 znsls400

LEFT JOIN baandb.tznsls402301 znsls402 
       ON znsls402.t$ncia$c = znsls400.t$ncia$c
      AND znsls402.t$uneg$c = znsls400.t$uneg$c
      AND znsls402.t$pecl$c = znsls400.t$pecl$c
      AND znsls402.t$sqpd$c = znsls400.t$sqpd$c

LEFT JOIN baandb.tznsls412301 znsls412 
       ON znsls412.t$ncia$c = znsls402.t$ncia$c
      AND znsls412.t$uneg$c = znsls402.t$uneg$c
      AND znsls412.t$pecl$c = znsls402.t$pecl$c
      AND znsls412.t$sqpd$c = znsls402.t$sqpd$c
      AND znsls412.t$sequ$c = znsls402.t$sequ$c
       
LEFT JOIN baandb.ttfgld018301 tfgld018
       ON tfgld018.t$ttyp = znsls412.t$ttyp$c
      AND tfgld018.t$docn = znsls412.t$ninv$c

LEFT JOIN baandb.tzncmg007301 zncmg007 
       ON zncmg007.t$mpgt$c = znsls402.t$idmp$c
  
LEFT JOIN baandb.tzncmg009301 zncmg009
       ON zncmg009.t$band$c = znsls402.t$cccd$c

WHERE NVL(znsls412.t$ttyp$c,' ') NOT IN ('LPJ', 'FAT', 'RWC')
