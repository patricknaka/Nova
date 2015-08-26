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
		znibd005.t$desc$c										          TAMANHO,
		''														                CODIGO_BARRA,
		CISLI941.T$AMNT$L										          VALOR ,
		CISLI941.T$PRIC$L										          PRECO1,
		CISLI941.T$DQUA$L										          QTDE_ITEM,
    2														                  TIPO_TRANSACAO,     --Saídas
    cisli941.t$fire$l                             REF_FISCAL,
    case when cisli941.t$line$l/10 < 1 then
          cisli941.t$line$l                         
    else  cisli941.t$line$l/10 end                LIN_REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)    DT_ULT_ALTERACAO,
    tcibd001.t$mdfb$c                             MOD_FABR_ITEM,
    cisli940.t$ccfo$l                             CFO,
    cisli940.t$fdtc$l                             COD_DOC_FISCAL
    
FROM  BAANDB.TCISLI940601	CISLI940
INNER JOIN	BAANDB.TCISLI941601 CISLI941	ON	CISLI941.T$FIRE$L	=	CISLI940.T$FIRE$L

INNER JOIN	BAANDB.TTCIBD001601	TCIBD001	ON	TCIBD001.T$ITEM		=	CISLI941.T$ITEM$L

LEFT JOIN	BAANDB.TTCIBD004601	TCIBD004	ON	TCIBD004.T$CITT		=	'000'
											AND	TCIBD004.T$BPID		=	' '
											AND	TCIBD004.T$ITEM		=	CISLI941.T$ITEM$L
                      
LEFT JOIN baandb.tznsls000601 znsls000
       ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')

LEFT JOIN baandb.tznibd005601 znibd005
       ON znibd005.t$size$c = TCIBD001.T$SIZE$C
       
--WHERE
--			CISLI940.T$FDTY$L IN (4,5,9,17,18,19,22,23,26,32,33)
--AND	  CISLI940.T$STAT$L IN (5, 6)			-- IMPRESSO, LANÇADO			
WHERE CISLI940.T$STAT$L IN (2, 5, 6, 101)			-- 2-CANCELADA, 5-IMPRESSO, 6-LANÇADO, 101-ESTORNADA
AND   cisli940.t$cnfe$l != ' '
AND   exists (select *
                  from  baandb.tznnfe011601 znnfe011
                  where znnfe011.t$oper$c = 1         
                  and   znnfe011.t$fire$c = cisli940.t$fire$l
                  and   znnfe011.t$stfa$c = 5
                  and   (znnfe011.t$nfes$c = 2 or znnfe011.t$nfes$c = 5))
AND      cisli940.t$fdty$l != 2     --venda sem pedido			
AND cisli941.t$item$l != znsls000.t$itmf$c      --ITEM FRETE
AND cisli941.t$item$l != znsls000.t$itmd$c      --ITEM DESPESAS
AND cisli941.t$item$l != znsls000.t$itjl$c      --ITEM JUROS			
			
			

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
		znibd005.t$desc$c										          TAMANHO,
		''														                CODIGO_BARRA,
		TDREC941.T$TAMT$L										          VALOR ,
		TDREC941.T$PRIC$L										          PRECO1,
		TDREC941.T$QNTY$L										          QTDE_ITEM,
    1														                  TIPO_TRANSACAO,   --Entradas
    tdrec941.t$fire$l                             REF_FISCAL,
    tdrec941.t$line$l                             LIN_REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)    DT_ULT_ALTERACAO,
    tcibd001.t$mdfb$c                             MOD_FABR_ITEM,
    tdrec940.t$opfc$l                             CFO,
    tdrec940.t$fdtc$l                             COD_DOC_FISCAL
    
FROM  BAANDB.TTDREC940601	TDREC940

INNER JOIN	BAANDB.TTDREC941601 TDREC941	ON	TDREC941.T$FIRE$L	=	TDREC940.T$FIRE$L

INNER JOIN	BAANDB.TTCIBD001601	TCIBD001	ON	TCIBD001.T$ITEM		=	TDREC941.T$ITEM$L

LEFT JOIN	BAANDB.TTCIBD004601	TCIBD004	ON	TCIBD004.T$CITT		=	'000'
											AND	TCIBD004.T$BPID		=	' '
											AND	TCIBD004.T$ITEM		=	TDREC941.T$ITEM$L
                      
LEFT JOIN baandb.tznsls000601 znsls000
       ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')

LEFT JOIN baandb.tznibd005601 znibd005
       ON znibd005.t$size$c = TCIBD001.T$SIZE$C
       
--WHERE
--			TDREC940.T$RFDT$L IN (1,2,4,5,10,26,27,28,32,33,35,36,37,40)
--AND   TDREC940.T$STAT$L IN (4,5)    --APROVADO, APROVADO COM PROBLEMAS
WHERE TDREC940.T$STAT$L IN (4,5,6)  --4-Aprovado, 5-Aprovado com Problemas, 6-estornada
  AND	tdrec940.t$cnfe$l != ' '
  AND tdrec941.t$item$l != znsls000.t$itmf$c      --ITEM FRETE
  AND tdrec941.t$item$l != znsls000.t$itmd$c      --ITEM DESPESAS
  AND tdrec941.t$item$l != znsls000.t$itjl$c      --ITEM JUROS			
  
  ORDER BY TIPO_TRANSACAO, REF_FISCAL, LIN_REF_FISCAL
