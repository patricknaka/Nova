SELECT
--*********************************************************************************************************************
--	LISTA TODOS AS ENTREGAS INTEGRADAS E OS PRODUTOS INDEPENDENTE DO STATUS
--*********************************************************************************************************************
    to_char(ZNSLS004.T$ENTR$C)									PEDIDO,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)  DATA_FATURAMENTO,
		to_char(CISLI940.T$DOCN$L)									NF,
		CISLI940.T$SERI$L														SERIE,
		TRIM(CISLI941.T$ITEM$L)											PRODUTO,
		CISLI941.T$DQUA$L														QTD_FAT,
		CISLI941.T$PRIC$L														PRECO,
			CASE WHEN COUNTDT.CTDT>1
				THEN
				CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C, 
				'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
				AT time zone 'America/Sao_Paulo') AS DATE)
				ELSE NULL END													  DT_ENTREGA,		
		ICMS_ST.T$BASE$L														BASE_CALCULO,
--		ICMS_ST.T$NMRG$L														IVA,
    cisli941.t$tpot$l                           IVA,
		ICMS_ST.T$RATE$L														ALIQUOTA,
    tcibd001.t$mdfb$c                           MOD_FABR_ITEM,
    CASE WHEN cisli940.t$stat$l = 2 THEN
        'C' ELSE ' ' END                        CANCELADA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)    DATA_INCLUSAO

FROM
		(	SELECT	A.T$FIRE$L,
					A.T$LINE$L,
					A.T$SLSO,
					A.T$PONO
			FROM	BAANDB.TCISLI245602 A
			WHERE	A.T$SLCP=602
			AND		A.T$ORTP=1
			AND		A.T$KOOR=3
			GROUP BY A.T$FIRE$L,
			         A.T$LINE$L,
			         A.T$SLSO,
			         A.T$PONO)	CISLI245
					 
INNER JOIN (SELECT	B.T$NCIA$C,
					B.T$UNEG$C,
					B.T$PECL$C,
					B.T$SQPD$C,
					B.T$ENTR$C,
					B.T$SEQU$C,
					B.T$ORNO$C,
					B.T$PONO$C
			FROM 	BAANDB.TZNSLS004602 B
			GROUP BY B.T$NCIA$C,
			         B.T$UNEG$C,
                     B.T$PECL$C,
                     B.T$SQPD$C,
					 B.T$ENTR$C,
					 B.T$SEQU$C,
                     B.T$ORNO$C,
					 B.T$PONO$C) ZNSLS004	ON	ZNSLS004.T$ORNO$C	=	CISLI245.T$SLSO
											AND	ZNSLS004.T$PONO$C	=	CISLI245.T$PONO
					 
INNER JOIN 	BAANDB.TCISLI940602	CISLI940	ON	CISLI940.T$FIRE$L	=	CISLI245.T$FIRE$L

INNER JOIN 	BAANDB.TCISLI941602	CISLI941	ON	CISLI941.T$FIRE$L	=	CISLI245.T$FIRE$L
											AND	CISLI941.T$LINE$L	=	CISLI245.T$LINE$L
											
INNER JOIN	BAANDB.TZNSLS401602	ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS004.T$NCIA$C
											AND ZNSLS401.T$UNEG$C	=	ZNSLS004.T$UNEG$C
											AND ZNSLS401.T$PECL$C	=	ZNSLS004.T$PECL$C
											AND ZNSLS401.T$SQPD$C	=	ZNSLS004.T$SQPD$C
                                            AND ZNSLS401.T$ENTR$C	=	ZNSLS004.T$ENTR$C
                                            AND ZNSLS401.T$SEQU$C	=	ZNSLS004.T$SEQU$C

INNER JOIN (SELECT	C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
                    C.T$ENTR$C,
					COUNT(DISTINCT TRUNC(C.T$DTEP$C)) CTDT
			FROM	BAANDB.TZNSLS401602 C
			GROUP BY C.T$NCIA$C,
			         C.T$UNEG$C,
			         C.T$PECL$C,
			         C.T$SQPD$C,
               C.T$ENTR$C) COUNTDT	ON	COUNTDT.T$NCIA$C	=	ZNSLS004.T$NCIA$C
					                        AND COUNTDT.T$UNEG$C   	=	ZNSLS004.T$UNEG$C
					                        AND COUNTDT.T$PECL$C   	=	ZNSLS004.T$PECL$C
					                        AND COUNTDT.T$SQPD$C   	=	ZNSLS004.T$SQPD$C	
					                        AND COUNTDT.T$ENTR$C   	=	ZNSLS004.T$ENTR$C	

LEFT JOIN (	SELECT	A.T$FIRE$L,
					A.T$LINE$L,
					A.T$RATE$L,
					A.T$BASE$L,
					A.T$NMRG$L
			FROM	BAANDB.TCISLI943602 A
			WHERE 	A.T$BRTY$L=2) ICMS_ST	ON	ICMS_ST.T$FIRE$L	=	CISLI941.T$FIRE$L
											AND	ICMS_ST.T$LINE$L	=	CISLI941.T$LINE$L

LEFT JOIN baandb.tznsls000601 znsls000
       ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')

INNER JOIN baandb.ttcibd001602  tcibd001
        ON tcibd001.t$item = cisli941.t$item$l

INNER JOIN	BAANDB.TZNSLS400602	ZNSLS400	
        ON	ZNSLS400.T$NCIA$C	=	ZNSLS004.T$NCIA$C
       AND  ZNSLS400.T$UNEG$C	=	ZNSLS004.T$UNEG$C
       AND  ZNSLS400.T$PECL$C	=	ZNSLS004.T$PECL$C
       AND  ZNSLS400.T$SQPD$C	=	ZNSLS004.T$SQPD$C
        
WHERE cisli941.t$item$l != znsls000.t$itmf$c      --ITEM FRETE 
  AND cisli941.t$item$l != znsls000.t$itmd$c      --ITEM DESPESAS
  AND cisli941.t$item$l != znsls000.t$itjl$c      --ITEM JUROS
   
ORDER BY PEDIDO
