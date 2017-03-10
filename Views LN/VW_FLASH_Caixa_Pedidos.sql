--  CREATE OR REPLACE FORCE VIEW "OWN_MIS"."VW_FLASH_CAIXA_PEDIDO" ("CD_UNIDADE_NEGOCIO", "NR_PEDIDO", "NR_ENTREGA", "NR_ORDEM", "DT_LIMITE_EXP", "DT_EMISSAO", "CD_FILIAL", "DS_FILIAL", "VL_TOTAL", "QT_VENDIDA", "CD_ITEM", "VL_VOLUME_M3", "CD_DEPARTAMENTO", "DS_DEPARTAMENTO") AS 
  SELECT  
    znsls401.t$UNEG$C                              CD_UNIDADE_NEGOCIO,
    znsls401.t$PECL$C                              NR_PEDIDO,
    znsls401.t$ENTR$C                              NR_ENTREGA,
    tdsls400.t$ORNO                                NR_ORDEM,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls401.t$ddta, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)   DT_LIMITE_EXP,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)   DT_EMISSAO,
    cast(znfmd001.t$fili$c as int)                 CD_FILIAL,
    znfmd001.t$dsca$c                              DS_FILIAL,
    cast(((znsls401.t$vlun$c * znsls401.t$qtve$c) + znsls401.t$vlfr$c - znsls401.t$vldi$c) as numeric(15,2))
                                                   VL_TOTAL,
    cast(znsls401.t$qtve$c as int)                 QT_VENDIDA,
    ltrim(rtrim(znsls401.t$itml$c))                CD_ITEM,
    cast((whwmd400.t$hght*
          whwmd400.t$wdth*
          whwmd400.t$dpth*
          znsls401.t$qtve$c) as numeric(15,4))     VL_VOLUME_M3,
    tcibd001.t$citg                                CD_DEPARTAMENTO,
    tcmcs023.t$dsca                                DS_DEPARTAMENTO
    
FROM baandb.tznsls401301 znsls401

INNER JOIN baandb.tznsls400301 znsls400    
        ON znsls400.T$NCIA$C = znsls401.T$NCIA$C
       AND znsls400.T$UNEG$C = znsls401.T$UNEG$C
       AND znsls400.T$PECL$C = znsls401.T$PECL$C
       AND znsls400.T$SQPD$C = znsls401.T$SQPD$C

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    MAX(a.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C, a.T$SEQN$C) ID_ULTIMO_PONTO
              from baandb.tznsls410301 a
              group by a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c,
                       a.t$entr$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
       AND znsls410.t$entr$c = znsls401.t$entr$c
       
INNER JOIN (SELECT
                A.T$NCIA$C,
                A.T$UNEG$C,
                A.T$PECL$C,
                A.T$SQPD$C,
                A.T$ENTR$C,
                MAX(A.T$ORNO$C) T$ORNO$C,
                MIN(A.T$PONO$C) T$PONO$C
                FROM BAANDB.TZNSLS004301 A
                GROUP BY	A.T$NCIA$C,
                          A.T$UNEG$C,
                          A.T$PECL$C,
                          A.T$SQPD$C,
                          A.T$ENTR$C) ZNSLS004
					ON	ZNSLS004.T$NCIA$C	=	znsls401.T$NCIA$C
					AND ZNSLS004.T$UNEG$C	=	znsls401.T$UNEG$C
					AND ZNSLS004.T$PECL$C	=	znsls401.T$PECL$C
          AND ZNSLS004.T$SQPD$C	=	znsls401.T$SQPD$C
          AND ZNSLS004.T$ENTR$C	=	znsls401.T$ENTR$C
						  
INNER JOIN  baandb.ttdsls400301 tdsls400  
        ON  tdsls400.t$orno = ZNSLS004.t$ORNO$C
        
INNER JOIN baandb.ttdsls401301 tdsls401
        ON tdsls401.t$orno = znsls004.t$orno$c
       AND tdsls401.t$pono = znsls004.t$pono$c
       
INNER JOIN  baandb.ttcmcs065301 tcmcs065  
        ON  tcmcs065.t$cwoc = tdsls400.t$cofc
        
INNER JOIN  baandb.ttccom130301 tccom130  
        ON  tccom130.t$cadr = tcmcs065.t$cadr
        
INNER JOIN  baandb.tznfmd001301 znfmd001  
        ON  znfmd001.t$fovn$c = tccom130.t$fovn$l
        
INNER JOIN  baandb.twhwmd400301 whwmd400  
        ON  whwmd400.t$item = znsls401.t$itml$c
        
INNER JOIN  baandb.ttcibd001301 tcibd001  
        ON  tcibd001.t$item = znsls401.t$itml$c
        
INNER JOIN  baandb.ttcmcs023301 tcmcs023  
        ON  tcmcs023.t$citg = tcibd001.t$citg
        
WHERE znsls410.ID_ULTIMO_PONTO = 'WMS'
  AND znsls401.t$qtve$c > 0
  AND tdsls400.t$hdst != 35  
  ;
