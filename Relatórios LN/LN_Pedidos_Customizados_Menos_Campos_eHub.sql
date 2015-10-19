SELECT

CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)    DATA_EMISSAO,
znsls401.t$pecl$c     PEDIDO,
znsls410.STATUS       STATUS_PED,
CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)    DATA_FATURAMENTO,

znsls430_1.t$coit$c     ITEM_CUSTOMIZADO,
znsls430_1.t$codc$c     ITEM_CUST,
znsls430_2.t$coit$c     ITEM_CUSTOMIZADO_2,
znsls430_2.t$codc$c     ITEM_CUST_2,
znsls430_3.t$coit$c     ITEM_CUSTOMIZADO_3,
znsls430_3.t$codc$c     ITEM_CUST_3,
znsls430_4.t$coit$c     ITEM_CUSTOMIZADO_4,
znsls430_4.t$codc$c     ITEM_CUST_4,
znsls430_5.t$coit$c     ITEM_CUSTOMIZADO_5,
znsls430_5.t$codc$c     ITEM_CUST_5,
znsls430_6.t$coit$c     ITEM_CUSTOMIZADO_6,
znsls430_6.t$codc$c     ITEM_CUST_6,
znsls401.t$item$c       ITEM,
tcibd001.t$dscb$c       ITEM_NOME,
tcibd001.t$mdfb$c       CODIGO_FORNEC,
znsls430_1.t$coqt$c     QTDE_CUST_1,
znsls430_2.t$coqt$c     QTDE_CUST_2,
znsls430_3.t$coqt$c     QTDE_CUST_3,
znsls430_4.t$coqt$c     QTDE_CUST_4,
znsls430_5.t$coqt$c     QTDE_CUST_5,
znsls430_6.t$coqt$c     QTDE_CUST_6,
znsls430_7.t$coqt$c     QTDE_CUST_7,
tcmcs023.t$dsca         DEPARTAMENTO

FROM  baandb.tznsls401601 znsls401

INNER JOIN baandb.tznsls400601  znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
       
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) STATUS
               from baandb.tznsls410301 znsls410
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$entr$c = znsls401.t$entr$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
       
INNER JOIN ( select  a.t$slso,
                    a.t$fire$l
            from    baandb.tcisli245601 a
            group by a.t$slso,
                     a.t$fire$l ) cisli245
       ON trim(TO_CHAR(cisli245.t$slso)) = trim(TO_CHAR(znsls401.t$orno$c))
       
INNER JOIN baandb.tcisli940601 cisli940
       ON cisli940.t$fire$l = cisli245.t$fire$l
      AND (cisli940.t$stat$l = 5 or cisli940.t$stat$l = 6)

LEFT JOIN baandb.ttcibd001601  tcibd001
       ON TRIM(TO_CHAR(tcibd001.t$item)) = TRIM(TO_CHAR(znsls401.t$item$c))
--          ON tcibd001.t$item = znsls401.t$item$c
        
LEFT JOIN baandb.ttcmcs023601  tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
        
LEFT JOIN baandb.tznsls430601 znsls430_1
       ON znsls430_1.t$ncia$c = znsls401.t$ncia$c
      AND znsls430_1.t$uneg$c = znsls401.t$uneg$c
      AND znsls430_1.t$pecl$c = znsls401.t$pecl$c
      AND znsls430_1.t$sqpd$c = znsls401.t$sqpd$c
      AND znsls430_1.t$entr$c = znsls401.t$entr$c
      AND znsls430_1.t$sequ$c = znsls401.t$sequ$c
      AND znsls430_1.t$cosq$c = 1
      
LEFT JOIN baandb.tznsls430601 znsls430_2
       ON znsls430_2.t$ncia$c = znsls401.t$ncia$c
      AND znsls430_2.t$uneg$c = znsls401.t$uneg$c
      AND znsls430_2.t$pecl$c = znsls401.t$pecl$c
      AND znsls430_2.t$sqpd$c = znsls401.t$sqpd$c
      AND znsls430_2.t$entr$c = znsls401.t$entr$c
      AND znsls430_2.t$sequ$c = znsls401.t$sequ$c
      AND znsls430_2.t$cosq$c = 2
      
LEFT JOIN baandb.tznsls430601 znsls430_3
       ON znsls430_3.t$ncia$c = znsls401.t$ncia$c
      AND znsls430_3.t$uneg$c = znsls401.t$uneg$c
      AND znsls430_3.t$pecl$c = znsls401.t$pecl$c
      AND znsls430_3.t$sqpd$c = znsls401.t$sqpd$c
      AND znsls430_3.t$entr$c = znsls401.t$entr$c
      AND znsls430_3.t$sequ$c = znsls401.t$sequ$c
      AND znsls430_3.t$cosq$c = 3
      
LEFT JOIN baandb.tznsls430601 znsls430_4
       ON znsls430_4.t$ncia$c = znsls401.t$ncia$c
      AND znsls430_4.t$uneg$c = znsls401.t$uneg$c
      AND znsls430_4.t$pecl$c = znsls401.t$pecl$c
      AND znsls430_4.t$sqpd$c = znsls401.t$sqpd$c
      AND znsls430_4.t$entr$c = znsls401.t$entr$c
      AND znsls430_4.t$sequ$c = znsls401.t$sequ$c
      AND znsls430_4.t$cosq$c = 4

LEFT JOIN baandb.tznsls430601 znsls430_5
       ON znsls430_5.t$ncia$c = znsls401.t$ncia$c
      AND znsls430_5.t$uneg$c = znsls401.t$uneg$c
      AND znsls430_5.t$pecl$c = znsls401.t$pecl$c
      AND znsls430_5.t$sqpd$c = znsls401.t$sqpd$c
      AND znsls430_5.t$entr$c = znsls401.t$entr$c
      AND znsls430_5.t$sequ$c = znsls401.t$sequ$c
      AND znsls430_5.t$cosq$c = 5
      
LEFT JOIN baandb.tznsls430601 znsls430_6
       ON znsls430_6.t$ncia$c = znsls401.t$ncia$c
      AND znsls430_6.t$uneg$c = znsls401.t$uneg$c
      AND znsls430_6.t$pecl$c = znsls401.t$pecl$c
      AND znsls430_6.t$sqpd$c = znsls401.t$sqpd$c
      AND znsls430_6.t$entr$c = znsls401.t$entr$c
      AND znsls430_6.t$sequ$c = znsls401.t$sequ$c
      AND znsls430_6.t$cosq$c = 6

LEFT JOIN baandb.tznsls430601 znsls430_7
       ON znsls430_7.t$ncia$c = znsls401.t$ncia$c
      AND znsls430_7.t$uneg$c = znsls401.t$uneg$c
      AND znsls430_7.t$pecl$c = znsls401.t$pecl$c
      AND znsls430_7.t$sqpd$c = znsls401.t$sqpd$c
      AND znsls430_7.t$entr$c = znsls401.t$entr$c
      AND znsls430_7.t$sequ$c = znsls401.t$sequ$c
      AND znsls430_7.t$cosq$c = 7
      
WHERE  (znsls430_1.t$cosq$c IS NOT NULL OR
        znsls430_2.t$cosq$c IS NOT NULL OR
        znsls430_3.t$cosq$c IS NOT NULL OR
        znsls430_4.t$cosq$c IS NOT NULL OR
        znsls430_5.t$cosq$c IS NOT NULL OR
        znsls430_6.t$cosq$c IS NOT NULL OR
        znsls430_7.t$cosq$c IS NOT NULL )
