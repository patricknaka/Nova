SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(601) E BUNZL(602)
--**********************************************************************************************************************************************************
    Q_ENTREGA.t$UNEG$C      CD_UNIDADE_NEGOCIO,
    Q_ENTREGA.t$PECL$C      NR_PEDIDO,
    Q_ENTREGA.t$ENTR$C      NR_ENTREGA,
    tdsls400.t$ORNO         NR_ORDEM,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) DT_LIMITE_EXP,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)  DT_EMISSAO,
    cast(znfmd001.t$fili$c as int)    CD_FILIAL,
    znfmd001.t$dsca$c        DS_FILIAL,
    cast(Q_ENTREGA.VL_TOTAL as numeric(15,2))      VL_TOTAL,
    cast(Q_ENTREGA.QUANTIDADE as int)    QT_VENDIDA,
    ltrim(rtrim(Q_ENTREGA.t$itml$c))  CD_ITEM,
    cast((whwmd400.t$hght*
    whwmd400.t$wdth*
    whwmd400.t$dpth*
    Q_ENTREGA.QUANTIDADE) as numeric(15,4))    VL_VOLUME_M3,
    tcibd001.t$citg          CD_DEPARTAMENTO,
    tcmcs023.t$dsca          DS_DEPARTAMENTO,
    CAST(602 AS INT) CD_CIA
FROM
(SELECT

        znsls401.T$NCIA$C,
                znsls401.T$UNEG$C,
                znsls401.T$PECL$C,
                znsls401.T$SQPD$C,
                znsls401.T$ENTR$C,
        znsls401.t$itml$c,
        SUM(znsls401.t$vlun$c*znsls401.t$qtve$c)+
        sum(znsls401.t$vlfr$c) - 
        sum(znsls401.t$vldi$c)   VL_TOTAL,
        sum(znsls401.t$qtve$c)   QUANTIDADE
FROM baandb.tznsls401602 znsls401
GROUP BY
        znsls401.T$NCIA$C,
                znsls401.T$UNEG$C,
                znsls401.T$PECL$C,
                znsls401.T$SQPD$C,
                znsls401.T$ENTR$C,
        znsls401.t$itml$c) Q_ENTREGA

INNER JOIN baandb.tznsls400602 znsls400    ON  znsls400.T$NCIA$C = Q_ENTREGA.T$NCIA$C
                                            AND znsls400.T$UNEG$C = Q_ENTREGA.T$UNEG$C
                                            AND znsls400.T$PECL$C = Q_ENTREGA.T$PECL$C
                                            AND znsls400.T$SQPD$C = Q_ENTREGA.T$SQPD$C
    
INNER JOIN
  (SELECT                
          znsls410.T$NCIA$C,
          znsls410.T$UNEG$C,
          znsls410.T$PECL$C,
          znsls410.T$SQPD$C,
          znsls410.T$ENTR$C,
          --znsls410.t$ORNO$C,
          znsls410.T$POCO$C ID_ULTIMO_PONTO,
          ROW_NUMBER() OVER (PARTITION BY znsls410.T$NCIA$C,
                                          znsls410.T$UNEG$C,
                                          znsls410.T$PECL$C,
                                          znsls410.T$SQPD$C,
                                          znsls410.T$ENTR$C
                            ORDER BY znsls410.T$DTOC$C DESC, znsls410.T$SEQN$C DESC) RN
	FROM  baandb.tznsls410602 znsls410) Q_UPONTO
                      ON  Q_UPONTO.T$NCIA$C = Q_ENTREGA.T$NCIA$C
                      AND Q_UPONTO.T$UNEG$C = Q_ENTREGA.T$UNEG$C
                      AND Q_UPONTO.T$PECL$C = Q_ENTREGA.T$PECL$C
                      AND Q_UPONTO.T$SQPD$C = Q_ENTREGA.T$SQPD$C
                      AND Q_UPONTO.T$ENTR$C = Q_ENTREGA.T$ENTR$C

INNER JOIN (SELECT
				A.T$NCIA$C,
                A.T$UNEG$C,
                A.T$PECL$C,
                A.T$SQPD$C,
                A.T$ENTR$C,
				MAX(A.T$ORNO$C) T$ORNO$C
			FROM BAANDB.TZNSLS004602 A
			WHERE A.T$DATE$C=(	SELECT MAX(B.T$DATE$C)
								FROM BAANDB.TZNSLS004602 B
								WHERE B.T$NCIA$C=A.T$NCIA$C
								AND   B.T$UNEG$C=A.T$UNEG$C
								AND   B.T$PECL$C=A.T$PECL$C
								AND   B.T$SQPD$C=A.T$SQPD$C
								AND   B.T$ENTR$C=A.T$ENTR$C)
			GROUP BY	A.T$NCIA$C,
			            A.T$UNEG$C,
			            A.T$PECL$C,
			            A.T$SQPD$C,
			            A.T$ENTR$C) ZNSLS004
					ON	ZNSLS004.T$NCIA$C	=	Q_UPONTO.T$NCIA$C
					AND ZNSLS004.T$UNEG$C	=	Q_UPONTO.T$UNEG$C
					AND ZNSLS004.T$PECL$C	=	Q_UPONTO.T$PECL$C
			        AND ZNSLS004.T$SQPD$C	=	Q_UPONTO.T$SQPD$C
                    AND ZNSLS004.T$ENTR$C	=	Q_UPONTO.T$ENTR$C
			
					  
INNER JOIN  baandb.ttdsls400602 tdsls400  ON  tdsls400.t$orno = ZNSLS004.t$ORNO$C
INNER JOIN  baandb.ttcmcs065602 tcmcs065  ON  tcmcs065.t$cwoc = tdsls400.t$cofc
INNER JOIN  baandb.ttccom130602 tccom130  ON  tccom130.t$cadr = tcmcs065.t$cadr
INNER JOIN  baandb.tznfmd001602 znfmd001  ON  znfmd001.t$fovn$c = tccom130.t$fovn$l
INNER JOIN  baandb.twhwmd400602 whwmd400  ON  whwmd400.t$item = Q_ENTREGA.t$itml$c
INNER JOIN  baandb.ttcibd001602 tcibd001   ON  tcibd001.t$item = Q_ENTREGA.t$itml$c
INNER JOIN  baandb.ttcmcs023602  tcmcs023  ON  tcmcs023.t$citg = tcibd001.t$citg

WHERE Q_UPONTO.ID_ULTIMO_PONTO='WMS'
AND Q_UPONTO.RN=1
AND Q_ENTREGA.QUANTIDADE>0
AND tdsls400.t$hdst!=35