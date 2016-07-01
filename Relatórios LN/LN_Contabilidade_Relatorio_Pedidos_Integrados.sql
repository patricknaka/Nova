SELECT
  DISTINCT
    znsls400.t$ncia$c                                  CIA,
    znsls400.t$uneg$c                                  UNID_NEGOCIO,
    znsls400.t$pecl$c                                  PEDIDO,      
    znsls400.t$sqpd$c                                  SEQ_PEDIDO,
    znsls402.t$sequ$c                                  SEQ_PAGAMENTO,
    znsls402.t$cccd$c                                  NUM_BANDEIRA,
    nvl(zncmg009.t$desc$c, ' ')                        DSC_BANDEIRA,
    znsls402.t$idad$c                                  ID_ADQUIRENTE, 
    znsls402.t$idmp$c                                  NUM_MEIO_PAGTO,  
    zncmg007.t$desc$c                                  DSC_MEIO_PAGTO, 
    znsls400.t$nomf$c                                  NOME_CLIENTE, 
    znsls402.t$cpft$c                                  CPF_CLIENTE, 
    znsls412.t$ttyp$c                                  TIPO_TRANSACAO,
    znsls412.t$ninv$c                                  DOC_TRANSACAO,
    ROUND(zncmg010.t$trbd$c, 2)                        TAXA_CARTAO,
    ABS(znsls402.t$vlmr$c)                             VALOR_MEIO_PGTO,
    CASE WHEN zncmg010.t$trbd$c IS NULL
           THEN NULL
         ELSE ROUND((ABS(znsls402.t$vlmr$c) * zncmg010.t$trbd$c / 100), 2)
    END                                                VALOR_TAXA_CARTAO,
 
    CASE WHEN tfgld018.t$dcdt < TO_DATE('01/01/1990','DD/MM/YYYY') 
           THEN NULL
         ELSE tfgld018.t$dcdt 
    END                                                DATA_DOC
 
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
       ON zncmg007.t$mpgs$c = znsls402.t$idmp$c        -- buscar pelo codigo do site
       
LEFT JOIN baandb.tzncmg007301 zncmg007 
       ON zncmg007.t$mpgs$c = znsls402.t$idmp$c        -- buscar pelo codigo do site
       
LEFT JOIN baandb.tzncmg009301 zncmg009
       ON zncmg009.t$band$c = znsls402.t$cccd$c

LEFT JOIN baandb.tzncmg008301 zncmg008                 -- BP do banco
       ON zncmg008.t$adqs$c = znsls402.t$idad$c
      AND zncmg008.t$cias$c = znsls402.t$ncia$c

LEFT JOIN ( select zncmg010_.t$band$c,                 -- data de inicio da vigencia
                   zncmg010_.t$adqu$c,
                   zncmg010_.t$cias$c,
                   max(zncmg010_.t$dtin$c) DATA_INICIO
              from baandb.tzncmg010301 zncmg010_        
          group by zncmg010_.t$band$c, 
                   zncmg010_.t$adqu$c, 
                   zncmg010_.t$cias$c ) zncmg010_dt
      ON zncmg010_dt.t$band$c = zncmg009.t$band$c
     AND zncmg010_dt.t$adqu$c = zncmg008.t$adqu$c
     AND zncmg010_dt.t$cias$c = znsls402.t$ncia$c
 
LEFT JOIN ( select zncmg010_.t$band$c,                 -- numero de parcelas
                   zncmg010_.t$adqu$c,
                   zncmg010_.t$cias$c,
                   zncmg010_.t$dtin$c,
                   min(zncmg010_.t$prct$c) NUM_PARC
              from baandb.tzncmg010301 zncmg010_        
          group by zncmg010_.t$band$c, 
                   zncmg010_.t$adqu$c, 
                   zncmg010_.t$cias$c, 
                   zncmg010_.t$dtin$c ) zncmg010_np
       ON zncmg010_np.t$band$c = zncmg009.t$band$c
      AND zncmg010_np.t$adqu$c = zncmg008.t$adqu$c
      AND zncmg010_np.t$cias$c = znsls402.t$ncia$c
      AND zncmg010_np.t$dtin$c = zncmg010_dt.DATA_INICIO

LEFT JOIN baandb.tzncmg010301 zncmg010            
       ON zncmg010.t$band$c = zncmg009.t$band$c
      AND zncmg010.t$adqu$c = zncmg008.t$adqu$c
      AND zncmg010.t$cias$c = znsls402.t$ncia$c
      AND zncmg010.t$prct$c = zncmg010_np.NUM_PARC
      AND zncmg010.t$dtin$c = zncmg010_dt.DATA_INICIO

WHERE NVL(Trim(znsls412.t$ttyp$c), '000') in (:Transacao)
  AND NVL(tfgld018.t$dcdt, :DataDocDe) 
      Between :DataDocDe 
          And :DataDocAte
  AND NVL(znsls412.t$ttyp$c,' ') NOT IN ('LPJ', 'FAT', 'RWC')