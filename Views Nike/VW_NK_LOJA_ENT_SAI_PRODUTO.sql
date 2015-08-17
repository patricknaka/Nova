SELECT
--***************************************************************************************************************************
--				SAIDA
--***************************************************************************************************************************
		'NIKE.COM'												            FILIAL,	
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE), 'YY')
    || TO_CHAR(CISLI940.T$DOCN$L)
		|| TO_CHAR(CISLI940.T$SERI$L)                 ROMANEIO_PRODUTO,
		ltrim(rtrim(NVL(TCIBD004.T$AITC, TCIBD001.T$ITEM)))					PRODUTO,
		'01'													                COR_PRODUTO,
		TCIBD001.T$SIZE$C										          TAMANHO,
		' '														                CODIGO_BARRA,
		CISLI941.T$AMNT$L										          VALOR ,
		CISLI941.T$PRIC$L										          PRECO1,
		CISLI941.T$DQUA$L										          QTDE_ITEM,
    cisli940.t$fire$l                             REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)    DT_ULT_ALTERACAO
    
FROM  BAANDB.TCISLI940601	CISLI940
INNER JOIN	BAANDB.TCISLI941601 CISLI941	ON	CISLI941.T$FIRE$L	=	CISLI940.T$FIRE$L

INNER JOIN	BAANDB.TTCIBD001601	TCIBD001	ON	TCIBD001.T$ITEM		=	CISLI941.T$ITEM$L

LEFT JOIN	BAANDB.TTCIBD004601	TCIBD004	ON	TCIBD004.T$CITT		=	'000'
											AND	TCIBD004.T$BPID		=	' '
											AND	TCIBD004.T$ITEM		=	CISLI941.T$ITEM$L
WHERE
			CISLI940.T$FDTY$L IN (2,4,5,9,17,18,19,22,23,26,32,33)
AND	  CISLI940.T$STAT$L IN (5, 6)			-- IMPRESSO, LANÇADO			
			
			
			
			

--***************************************************************************************************************************
--				ENTRADA
--***************************************************************************************************************************

UNION
SELECT
		'NIKE.COM'												FILIAL,	
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE), 'YY')
		|| TO_CHAR(TDREC940.T$DOCN$L)
		|| TO_CHAR(TDREC940.T$SERI$L)                 ROMANEIO_PRODUTO,
		ltrim(rtrim(NVL(TCIBD004.T$AITC, TCIBD001.T$ITEM)))					PRODUTO,
		'01'													                COR_PRODUTO,
		TCIBD001.T$SIZE$C										          TAMANHO,
		' '														                CODIGO_BARRA,
		TDREC941.T$TAMT$L										          VALOR ,
		TDREC941.T$PRIC$L										          PRECO1,
		TDREC941.T$QNTY$L										          QTDE_ITEM,
    tdrec940.t$fire$l                             REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)    DT_ULT_ALTERACAO
    
FROM  BAANDB.TTDREC940601	TDREC940

INNER JOIN	BAANDB.TTDREC941601 TDREC941	ON	TDREC941.T$FIRE$L	=	TDREC940.T$FIRE$L

INNER JOIN	BAANDB.TTCIBD001601	TCIBD001	ON	TCIBD001.T$ITEM		=	TDREC941.T$ITEM$L

LEFT JOIN	BAANDB.TTCIBD004601	TCIBD004	ON	TCIBD004.T$CITT		=	'000'
											AND	TCIBD004.T$BPID		=	' '
											AND	TCIBD004.T$ITEM		=	TDREC941.T$ITEM$L
WHERE
			TDREC940.T$RFDT$L IN (1,2,4,5,10,26,27,28,32,33,35,36,37,40)
AND   TDREC940.T$STAT$L IN (4,5)    --APROVADO, APROVADO COM PROBLEMAS