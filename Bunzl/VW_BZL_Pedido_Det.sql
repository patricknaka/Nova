SELECT
--*********************************************************************************************************************
--	LISTA TODOS AS ENTREGAS INTEGRADAS E OS PRODUTOS IDEPENDDDENTE DO STATUS
--*********************************************************************************************************************
			to_char(ZNSLS401.T$ENTR$C)								PEDIDO_WEB,
			to_char(ZNSLS401.T$SEQU$C)								SEQUENCIAL,
			to_char(ZNSLS401.T$ITEM$C)								ITEM,
			ZNSLS401.T$QTVE$C													QTD,
			ZNSLS401.T$VLUN$C													PRIC_UNIT,
			CASE WHEN COUNTDT.CTDT>1
				THEN
				CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C, 
				'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
				AT time zone 'America/Sao_Paulo') AS DATE)
				ELSE NULL END													DT_ENTREGA

FROM

			BAANDB.TZNSLS400201	ZNSLS400
			
INNER JOIN	BAANDB.TZNSLS401201 ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS400.T$NCIA$C
                                            AND ZNSLS401.T$UNEG$C   =	ZNSLS400.T$UNEG$C
                                            AND ZNSLS401.T$PECL$C   =	ZNSLS400.T$PECL$C
                                            AND ZNSLS401.T$SQPD$C   =	ZNSLS400.T$SQPD$C

INNER JOIN (SELECT	C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
                    C.T$ENTR$C,
					COUNT(DISTINCT TRUNC(C.T$DTEP$C)) CTDT
			FROM	BAANDB.TZNSLS401201 C
			GROUP BY C.T$NCIA$C,
			         C.T$UNEG$C,
			         C.T$PECL$C,
			         C.T$SQPD$C,
               			 C.T$ENTR$C) COUNTDT	ON	COUNTDT.T$NCIA$C	=	ZNSLS400.T$NCIA$C
					                        AND COUNTDT.T$UNEG$C   =	ZNSLS400.T$UNEG$C
					                        AND COUNTDT.T$PECL$C   =	ZNSLS400.T$PECL$C
					                        AND COUNTDT.T$SQPD$C   =	ZNSLS400.T$SQPD$C	
