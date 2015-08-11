﻿SELECT 
--***************************************************************************************************************************
--				SAIDA
--***************************************************************************************************************************
		TO_CHAR(CISLI940.T$DOCN$L)
		|| TO_CHAR(CISLI940.T$SERI$L)
		|| CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)	ROMANEIO_PRODUTO,
		'NIKE.COM'												FILIAL,	
		21														CODIGO_TAB_PRECO,
		CISLI940.T$CCFO$L										TIPO_ENTRADA_SAIDA,
		REGEXP_REPLACE(TCCOM130_ORG.T$FOVN$L, '[^0-9]', '')		FILIAL_ORIGEM_DESTINO,
		' '														RESPONSAVEL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) EMISSAO,
 		(	SELECT SUM(A.T$DQUA$L)
			FROM BAANDB.TCISLI941601 A
			WHERE A.T$FIRE$L = CISLI940.T$FIRE$L)				QTDE_TOTAL,
		CISLI940.T$AMNT$L										VALOR_TOTAL,
		REGEXP_REPLACE(TCCOM130_TRN.T$FOVN$L, '[^0-9]', '')		CGC,
		' '														OBS,
		' '														ENTRADA_SAIDA_ENCERRADA,
		' '														ENTRADA_SAIDA_CANCELADA,
		CISLI940.T$SERI$L										SERIE_NF,
		TO_CHAR(CISLI940.T$DOCN$L, '000000000')					NF_NUMERO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATS$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) DATA_SAIDA,
		' '														ENTRADA_CONFERIDA,
		' '														ENTRADA_SEM_PRODUTOS,
		0														ENTRADA_POR,
		CASE WHEN CISLI940.T$FDTY$L=9
			THEN 1
			ELSE 0 END											INDICA_DEVOLUCAO,
		' '														ROMANEIO_AJUSTE,
		' '														FORNECEDOR,
		2														TIPO_TRANSACAO,
    cisli940.t$fire$l           REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ALTERACAO
    
FROM
			BAANDB.TCISLI940601	CISLI940
INNER JOIN	BAANDB.TTCCOM130601	TCCOM130_ORG	ON	TCCOM130_ORG.T$CADR	=	CISLI940.T$SFRA$L
INNER JOIN	BAANDB.TTCCOM130601 TCCOM130_TRN	ON	TCCOM130_TRN.T$CADR	=	CISLI940.T$ITOA$L

WHERE
			CISLI940.T$FDTY$L IN (2,4,5,9,17,18,19,22,23,26,32,33)
AND	  CISLI940.T$STAT$L IN (5, 6)			-- IMPRESSO, LANÇADO
			
--***************************************************************************************************************************
--				ENTRADA
--***************************************************************************************************************************
UNION
SELECT 
		TO_CHAR(TDREC940.T$DOCN$L)
		|| TO_CHAR(TDREC940.T$SERI$L)
		|| CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) ROMANEIO_PRODUTO,
		'NIKE.COM'												FILIAL,	
		21														CODIGO_TAB_PRECO,
		TDREC940.T$OPFC$L										TIPO_ENTRADA_SAIDA,
		REGEXP_REPLACE(TCCOM130_ORG.T$FOVN$L, '[^0-9]', '')		FILIAL_ORIGEM_DESTINO,
		' '														RESPONSAVEL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) EMISSAO,
		(	SELECT SUM(A.T$QNTY$L)
			FROM BAANDB.TTDREC941601 A
			WHERE A.T$FIRE$L = TDREC940.T$FIRE$L)				QTDE_TOTAL,
		TDREC940.T$TFDA$L										VALOR_TOTAL,
		REGEXP_REPLACE(TDREC940.T$FOVN$L, '[^0-9]', '')			CGC,
		' '														OBS,
		' '														ENTRADA_SAIDA_ENCERRADA,
		' '														ENTRADA_SAIDA_CANCELADA,
		TDREC940.T$SERI$L										SERIE_NF,
		TO_CHAR(TDREC940.T$DOCN$L, '000000000')					NF_NUMERO,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$ODAT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) DATA_SAIDA,
		' '														ENTRADA_CONFERIDA,
		' '														ENTRADA_SEM_PRODUTOS,
		CASE WHEN TCEMM122.T$BUPA IS NULL
			THEN 1
			ELSE 2 END											ENTRADA_POR,
		0														INDICA_DEVOLUCAO,
		' '														ROMANEIO_AJUSTE,
		' '														FORNECEDOR,
		1														TIPO_TRANSACAO,
    tdrec940.t$fire$l           REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ALTERACAO
    
FROM
			BAANDB.TTDREC940601	TDREC940
INNER JOIN	BAANDB.TTCCOM130601	TCCOM130_ORG	ON	TCCOM130_ORG.T$CADR	=	TDREC940.T$SFRA$L
LEFT JOIN	BAANDB.TTCEMM122601	TCEMM122		ON	TCEMM122.T$LOCO		=	601
												AND	TCEMM122.T$BUPA		=	TDREC940.T$BPID$L

WHERE
			TDREC940.T$RFDT$L IN (1,2,4,5,10,26,27,28,32,33,35,36,37,40)
AND   TDREC940.T$STAT$L IN (4,5)  --Aprovado, Aprovado com Problemas
