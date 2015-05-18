--*********************************************************************************************************************
--	LISTA TODOS AS ENTREGAS INTEGRADAS E OS PRODUTOS IDEPENDDDENTE DO STATUS
--*********************************************************************************************************************
SELECT

			ZNSLS401.T$ENTR$C													PEDIDO_WEB,
			ZNSLS401.T$SEQU$C													SEQUENCIAL,
			ZNSLS401.T$ITEM$C													ITEM,
			ZNSLS401.T$QTVE$C													QTD,
			ZNSLS401.T$VLUN$C													PRIC_UNIT,
			CASE WHEN COUNTDT.CTDT>1
				THEN
				CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C, 
				'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
				AT time zone 'America/Sao_Paulo') AS DATE)
				ELSE NULL END													DT_ENTREGA


FROM

			BAANDB.TZNSLS400301	ZNSLS400
			
INNER JOIN	BAANDB.TZNSLS401301 ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS400.T$NCIA$C
                                            AND ZNSLS401.T$UNEG$C   =	ZNSLS400.T$UNEG$C
                                            AND ZNSLS401.T$PECL$C   =	ZNSLS400.T$PECL$C
                                            AND ZNSLS401.T$SQPD$C   =	ZNSLS400.T$SQPD$C

INNER JOIN (SELECT	C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
					COUNT(DISTINCT TRUNC(C.T$DTEP$C)) CTDT
			FROM	BAANDB.TZNSLS401301 C
			GROUP BY C.T$NCIA$C,
			         C.T$UNEG$C,
			         C.T$PECL$C,
			         C.T$SQPD$C) COUNTDT	ON	COUNTDT.T$NCIA$C	=	ZNSLS400.T$NCIA$C
					                        AND COUNTDT.T$UNEG$C   =	ZNSLS400.T$UNEG$C
					                        AND COUNTDT.T$PECL$C   =	ZNSLS400.T$PECL$C
					                        AND COUNTDT.T$SQPD$C   =	ZNSLS400.T$SQPD$C	