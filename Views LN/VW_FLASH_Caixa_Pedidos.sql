SELECT  
		Q_ENTREGA.t$UNEG$C			CD_UNIDADE_NEGOCIO,
    Q_ENTREGA.t$PECL$C			NR_PEDIDO,
		Q_ENTREGA.t$ENTR$C			NR_ENTREGA,
    tdsls400.t$ORNO         NR_ORDEM,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE) DT_LIMITE_EXP,
		--tdsls400.t$ddat				  DT_LIMITE_EXP,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)  DT_EMISSAO,
		--znsls400.t$dtem$c			  DT_EMISSAO,
		znfmd001.t$fili$c			  CD_FILIAL,
		znfmd001.t$dsca$c			  DS_FILIAL,
		Q_ENTREGA.VL_TOTAL      VL_TOTAL,
		Q_ENTREGA.QUANTIDADE    QT_VENDIDA,
		Q_ENTREGA.t$itml$c			CD_ITEM,
		whwmd400.t$hght*
		whwmd400.t$wdth*
		whwmd400.t$dpth*
		Q_ENTREGA.QUANTIDADE		VL_VOLUME_M3,
		tcibd001.t$citg				  CD_DEPARTAMENTO,
		tcmcs023.t$dsca				  DS_DEPARTAMENTO
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
				sum(znsls401.t$vldi$c) 	VL_TOTAL,
				sum(znsls401.t$qtve$c) 	QUANTIDADE
FROM baandb.tznsls401201 znsls401
GROUP BY
				znsls401.T$NCIA$C,
                znsls401.T$UNEG$C,
                znsls401.T$PECL$C,
                znsls401.T$SQPD$C,
                znsls401.T$ENTR$C,
				znsls401.t$itml$c) Q_ENTREGA

INNER JOIN baandb.tznsls400201 znsls400		ON	znsls400.T$NCIA$C = Q_ENTREGA.T$NCIA$C
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
					znsls410.t$ORNO$C,
					MAX(znsls410.T$POCO$C) 
					  KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C, 
													 znsls410.T$SEQN$C)      ID_ULTIMO_PONTO
	FROM  baandb.tznsls410201 znsls410
	GROUP BY        znsls410.T$NCIA$C,
					znsls410.T$UNEG$C,
					znsls410.T$PECL$C,
					znsls410.T$SQPD$C,
					znsls410.T$ENTR$C,
					znsls410.t$ORNO$C) Q_UPONTO
											ON	Q_UPONTO.T$NCIA$C = Q_ENTREGA.T$NCIA$C
											AND Q_UPONTO.T$UNEG$C = Q_ENTREGA.T$UNEG$C
											AND Q_UPONTO.T$PECL$C = Q_ENTREGA.T$PECL$C
											AND Q_UPONTO.T$SQPD$C = Q_ENTREGA.T$SQPD$C
											AND Q_UPONTO.T$ENTR$C = Q_ENTREGA.T$ENTR$C
				
INNER JOIN	baandb.ttdsls400201 tdsls400	ON	tdsls400.t$orno = Q_UPONTO.t$ORNO$C
INNER JOIN	baandb.ttcmcs065201 tcmcs065	ON	tcmcs065.t$cwoc = tdsls400.t$cofc
INNER JOIN	baandb.ttccom130201 tccom130	ON	tccom130.t$cadr = tcmcs065.t$cadr
INNER JOIN	baandb.tznfmd001201 znfmd001	ON	znfmd001.t$fovn$c = tccom130.t$fovn$l
INNER JOIN	baandb.twhwmd400201 whwmd400	ON	whwmd400.t$item = Q_ENTREGA.t$itml$c
INNER JOIN	baandb.ttcibd001201 tcibd001 	ON	tcibd001.t$item = Q_ENTREGA.t$itml$c
INNER JOIN	baandb.ttcmcs023201	tcmcs023	ON	tcmcs023.t$citg = tcibd001.t$citg

WHERE Q_UPONTO.ID_ULTIMO_PONTO='WMS'
AND Q_ENTREGA.QUANTIDADE>0