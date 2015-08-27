SELECT
--***************************************************************************************************************************
--				SAIDA
--***************************************************************************************************************************
    znsls004.t$entr$c                 TICKET,
		'NIKE.COM'												FILIAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 							DATA_VENDA,
    case when cisli941.t$line$l/10 < 1 then
        cisli941.t$line$l
    else
        CISLI941.T$LINE$L/10 end			ITEM,
		''														CODIGO_BARRA,
		CISLI941.T$DQUA$L										QTDE,
		CISLI941.T$PRIC$L	- cisli941.t$tldm$l									PRECO_LIQUIDO,
		CISLI941.T$TLDM$L										DESCONTO_ITEM,
		''														ID_VENDEDOR,
		''														TERMINAL,
		LTRIM(RTRIM(NVL(TCIBD004.T$AITC, TCIBD001.T$ITEM))) 					PRODUTO,				-- Estamos usando a tabela de código alternativo de item mas ainda esperamos a resposta dos consultores para confirmar se será usado este conveito na Nike
		0														ITEM_EXCLUIDO,
		0														QTDE_BRINDE,
		0														NÃO_MOVIMENTA_ESTOQUE,
		''														INDICA_ENTREGA_FUTURA,
		0														QTDE_CANCELADA,
		NVL(Q_IPI.T$RATE$L,0)									IPI,
		NVL(Q_ICMS.T$RATE$L,0)									ALIQUOTA,
		
		CAST((CASE CISLI941.T$DQUA$L WHEN 0.0 THEN 0.0 ELSE (TDSLS415.CTOT / CISLI941.T$DQUA$L) END) AS NUMERIC(38,4))
                                  CUSTO,
		'01'													COR_PRODUTO,
		znibd005.t$desc$c							TAMANHO,
    'S'                           TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    cisli940.t$fire$l             REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DT_ULT_ALTERACAO,
    tcibd001.t$mdfb$c             MOD_FABR_ITEM
    
FROM
			BAANDB.TCISLI245601	CISLI245

INNER JOIN	BAANDB.TCISLI941601 CISLI941	ON	CISLI941.T$FIRE$L	=	CISLI245.T$FIRE$L
											AND	CISLI941.T$LINE$L	=	CISLI245.T$LINE$L
											
INNER JOIN	BAANDB.TCISLI940601 CISLI940	ON	CISLI940.T$FIRE$L	=	CISLI941.T$FIRE$L											

INNER JOIN	BAANDB.TZNSLS004601	ZNSLS004	ON	ZNSLS004.T$ORNO$C	=	CISLI245.T$SLSO
											AND	ZNSLS004.T$PONO$C	=	CISLI245.T$PONO

INNER JOIN	BAANDB.TZNSLS400601	ZNSLS400	ON	ZNSLS400.T$NCIA$C	=	ZNSLS004.T$NCIA$C
											AND ZNSLS400.T$UNEG$C   =	ZNSLS004.T$UNEG$C
                                            AND ZNSLS400.T$PECL$C   =	ZNSLS004.T$PECL$C
                                            AND ZNSLS400.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											
INNER JOIN	BAANDB.TZNSLS401601 ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS004.T$NCIA$C
                                            AND ZNSLS401.T$UNEG$C   =	ZNSLS004.T$UNEG$C
                                            AND ZNSLS401.T$PECL$C   =	ZNSLS004.T$PECL$C
                                            AND ZNSLS401.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											AND ZNSLS401.T$ENTR$C   =	ZNSLS004.T$ENTR$C
											AND ZNSLS401.T$SEQU$C   =	ZNSLS004.T$SEQU$C
											
INNER JOIN	BAANDB.TTCIBD001601	TCIBD001	ON	TCIBD001.T$ITEM		=	CISLI941.T$ITEM$L

LEFT JOIN	BAANDB.TTCIBD004601	TCIBD004	ON	TCIBD004.T$CITT		=	'000'
											AND	TCIBD004.T$BPID		=	' '
											AND	TCIBD004.T$ITEM		=	TCIBD001.T$ITEM
											
LEFT JOIN (	SELECT	A.T$ORNO,
					A.T$PONO,
					A.T$SQNB,
					SUM(A.T$COGS$1) CTOT
			FROM	BAANDB.TTDSLS415601 A
			WHERE 	A.T$CSTO = 2
			GROUP BY A.T$ORNO,
			         A.T$PONO,
			         A.T$SQNB)	TDSLS415	ON	TDSLS415.T$ORNO		=	CISLI245.T$SLSO
											AND	TDSLS415.T$PONO		=	CISLI245.T$PONO
			                                AND	TDSLS415.T$SQNB		=	CISLI245.T$SQNB
			
LEFT JOIN (	SELECT 	A.T$FIRE$L,
					A.T$LINE$L,
					A.T$AMNT$L,
					A.T$RATE$L
			FROM BAANDB.TCISLI943601 A
			WHERE	A.T$BRTY$L=3) Q_IPI		ON	Q_IPI.T$FIRE$L		=	CISLI941.T$FIRE$L
											AND	Q_IPI.T$LINE$L		=	CISLI941.T$LINE$L

LEFT JOIN (	SELECT 	A.T$FIRE$L,
					A.T$LINE$L,
					A.T$AMNT$L,
					A.T$RATE$L
			FROM BAANDB.TCISLI943601 A
			WHERE	A.T$BRTY$L=1) Q_ICMS	ON	Q_ICMS.T$FIRE$L		=	CISLI941.T$FIRE$L
											AND	Q_ICMS.T$LINE$L		=	CISLI941.T$LINE$L											

LEFT JOIN baandb.tznsls000601 znsls000
       ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')

LEFT JOIN baandb.tznibd005601 znibd005
       ON znibd005.t$size$c = TCIBD001.T$SIZE$C
       
WHERE CISLI245.T$SLCP=601
  AND	CISLI245.T$ORTP=1
  AND	CISLI245.T$KOOR=3
  AND	CISLI940.T$STAT$L IN (2,5,6,101)      --cancelada, impressa, lançada, estornada
  AND	CISLI940.T$FDTY$L NOT IN (2,14)
  AND CISLI941.T$ITEM$L != znsls000.t$itjl$c      -- item juros lojista
  AND CISLI941.T$ITEM$L != znsls000.t$itmd$c      -- item despesa
  AND CISLI941.T$ITEM$L != znsls000.t$itmf$c      -- item frete
  AND   cisli940.t$cnfe$l != ' '
  AND   exists (select *
                  from  baandb.tznnfe011601 znnfe011
                  where znnfe011.t$oper$c = 1
                  and   znnfe011.t$fire$c = cisli940.t$fire$l
                  and   znnfe011.t$stfa$c = 5
                  and   (znnfe011.t$nfes$c = 2 or znnfe011.t$nfes$c = 5))

--  AND cisli940.t$fire$l IN ('F00000246', 'F00000295')
--***************************************************************************************************************************
--				INSTANCIA
--***************************************************************************************************************************
UNION
SELECT
    ZNSLS401.T$ENTR$C                 TICKET,
		'NIKE.COM'												FILIAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 							DATA_VENDA,
		ZNSLS401.T$SEQU$C										ITEM,
		''														CODIGO_BARRA,
		ZNSLS401.T$QTVE$C										QTDE,
		ZNSLS401.T$VLUN$C										PRECO_LIQUIDO,
		ZNSLS401.T$VLDI$C										DESCONTO_ITEM,
		''														ID_VENDEDOR,
		''														TERMINAL,
		LTRIM(RTRIM(NVL(TCIBD004.T$AITC, TCIBD001.T$ITEM))) 					PRODUTO,				-- Estamos usando a tabela de código alternativo de item mas ainda esperamos a resposta dos consultores para confirmar se será usado este conveito na Nike
		0														ITEM_EXCLUIDO,
		0														QTDE_BRINDE,
		0 													NÃO_MOVIMENTA_ESTOQUE,
		''														INDICA_ENTREGA_FUTURA,
		0														QTDE_CANCELADA,
		0														IPI,
		0														ALIQUOTA,
		CAST ((CASE ZNSLS401.T$QTVE$C WHEN 0.0 THEN 0.0 ELSE (TDSLS415.CTOT / ZNSLS401.T$QTVE$C) END)	AS NUMERIC(38,4))					
                                  CUSTO,
		'01'													COR_PRODUTO,
		znibd005.t$desc$c							TAMANHO,
    'I'                           TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    cisli940.t$fire$l             REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 		DT_ULT_ALTERACAO,
    tcibd001.t$mdfb$c             MOD_FABR_ITEM

FROM

			BAANDB.TZNSLS400601	ZNSLS400	

INNER JOIN	BAANDB.TZNSLS401601 ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS400.T$NCIA$C
                                            AND ZNSLS401.T$UNEG$C   =	ZNSLS400.T$UNEG$C
                                            AND ZNSLS401.T$PECL$C   =	ZNSLS400.T$PECL$C
                                            AND ZNSLS401.T$SQPD$C   =	ZNSLS400.T$SQPD$C
											
INNER JOIN	BAANDB.TTDSLS400601 TDSLS400	ON	TDSLS400.T$ORNO		=	ZNSLS401.T$ORNO$C
											
INNER JOIN	BAANDB.TTCIBD001601	TCIBD001	ON	TCIBD001.T$ITEM		=	ZNSLS401.T$ITML$C

LEFT JOIN (	SELECT	A.T$ORNO,
					A.T$PONO,
					A.T$SQNB,
					SUM(A.T$COGS$1) CTOT
			FROM	BAANDB.TTDSLS415601 A
			WHERE 	A.T$CSTO = 2
			GROUP BY A.T$ORNO,
			         A.T$PONO,
			         A.T$SQNB)	TDSLS415	ON	TDSLS415.T$ORNO		=	ZNSLS401.T$ORNO$C
											AND	TDSLS415.T$PONO		=	ZNSLS401.T$PONO$C

LEFT JOIN	BAANDB.TTCIBD004601	TCIBD004	ON	TCIBD004.T$CITT		=	'000'
											AND	TCIBD004.T$BPID		=	' '
											AND	TCIBD004.T$ITEM		=	TCIBD001.T$ITEM

LEFT JOIN ( 	SELECT	A.T$FIRE$L,
                A.T$SLSO
        FROM	BAANDB.TCISLI245601 A
        WHERE	A.T$SLCP=601
        AND		A.T$ORTP=1
        AND		A.T$KOOR=3
        GROUP BY A.T$FIRE$L,
		             A.T$SLSO ) SLS245
      ON SLS245.T$SLSO = TDSLS400.T$ORNO
      
LEFT JOIN BAANDB.TCISLI940601 CISLI940
       ON CISLI940.T$FIRE$L = SLS245.T$FIRE$L
       
LEFT JOIN baandb.tznibd005601 znibd005
       ON znibd005.t$size$c = TCIBD001.T$SIZE$C       
WHERE
			ZNSLS400.T$IDPO$C	=		'TD'
		AND	TDSLS400.T$HDST		=		35
		AND TDSLS400.T$FDTY$L 	NOT IN (0,2,14)
