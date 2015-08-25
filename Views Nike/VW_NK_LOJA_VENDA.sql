SELECT
--***************************************************************************************************************************
--				SAIDA
--***************************************************************************************************************************
		'NIKE.COM'								FILIAL,
--		ZNSLS004.T$PECL$C || ZNSLS004.T$SQPD$C					TICKET,
    TO_CHAR(znsls401.t$entr$c)         TICKET,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA_VENDA,
		nvl(to_char(ZNSLS400.T$ICLF$C),' ')							CPF_CGC,		-- VERIFICAR FORMATAÇÃO
		''									PERIODO,
		''									VENDEDOR,
		'004'									OPERACAO_VENDA,
		''									CODIGO_TAB_PRECO,
		0									COMISSAO,
		0									DESCONTO,
		ZNSLS401.T$QTVE$C							QTDE_TOTAL,
		CASE WHEN CISLI940.T$FDTY$L=15			
		 THEN CISLI940_FAT.T$AMNT$L			
		 ELSE CISLI940.T$AMNT$L	END						VALOR_TIKET,
		ZNSLS402.T$VLMR$C							VALOR_PAGO,
		CASE WHEN CISLI940.T$FDTY$L=15
		 THEN CISLI940_FAT.T$AMNT$L + CISLI941.T$TLDM$L_FAT
		 ELSE CISLI940.T$AMNT$L + CISLI941.T$TLDM$L END				VALOR_VENDA_BRUTA,
		0									VALOR_TROCA,
		0									QTDE_TROCA_TOTAL,
		'' 									TICKET_IMPRESSO,
		''									TERMINAL,
		''									GERENTE_LOJA,
		''									GERENTE_PERIODO,
		''									LANCAMENTO_CAIXA,
		0									VALOR_CANCELADO,
		0									TOTAL_QTDE_CANCELADA,
		ZNSLS401.QITM						QTDE_ITEM,						-- alt1
		''									MOTIVO_CANCELAMENTO,
		CASE WHEN ZNSLS400.T$FTYP$C='PF'			
		 THEN nvl(to_char(ZNSLS400.T$ICLF$C),' ')			
		 ELSE NULL END								CPF_CGC_ECF,
		''									DATA_HORA_CANCELAMENTO,
		''									SUGESTAO_COD_FORMA_PGTO,
		nvl(Q_IPI.T$AMNT$L,0)								VALOR_IPI,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				EMISSAO,
		TO_CHAR(ZNSLS401.T$PZTR$C)							TRANSIT_TIME,
    'S'                           TP_MOVTO,                 -- Criado para separar na tabela as entradas e saídas
    cisli940.t$fire$l             REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DT_ULT_ALTERACAO

FROM (	SELECT	A.T$FIRE$L,
                A.T$SLSO
        FROM	BAANDB.TCISLI245601 A
        WHERE	A.T$SLCP=601
        AND		A.T$ORTP=1
        AND		A.T$KOOR=3
        GROUP BY A.T$FIRE$L,
		             A.T$SLSO)	CISLI245
					 
INNER JOIN (SELECT	B.T$NCIA$C,
					B.T$UNEG$C,
					B.T$PECL$C,
					B.T$SQPD$C,
					B.T$ENTR$C,
					B.T$ORNO$C
			FROM 	BAANDB.TZNSLS004601 B
			GROUP BY B.T$NCIA$C,
			         B.T$UNEG$C,
                     B.T$PECL$C,
                     B.T$SQPD$C,
					 B.T$ENTR$C,
                     B.T$ORNO$C) ZNSLS004	ON	ZNSLS004.T$ORNO$C	=	CISLI245.T$SLSO

INNER JOIN	BAANDB.TZNSLS400601	ZNSLS400	ON	ZNSLS400.T$NCIA$C	=	ZNSLS004.T$NCIA$C
                                            AND ZNSLS400.T$UNEG$C   =	ZNSLS004.T$UNEG$C
                                            AND ZNSLS400.T$PECL$C   =	ZNSLS004.T$PECL$C
                                            AND ZNSLS400.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											
INNER JOIN (SELECT	C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
                    C.T$ENTR$C,
                    SUM(C.T$QTVE$C) T$QTVE$C,
					MAX(C.T$PZTR$C) T$PZTR$C,
					COUNT(DISTINCT C.T$ITEM$C) QITM
			FROM	BAANDB.TZNSLS401601 C
			WHERE	C.T$IITM$C='P'
			GROUP BY C.T$NCIA$C,
			         C.T$UNEG$C,
			         C.T$PECL$C,
			         C.T$SQPD$C,
			         C.T$ENTR$C) ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS004.T$NCIA$C
					                        AND ZNSLS401.T$UNEG$C   =	ZNSLS004.T$UNEG$C
					                        AND ZNSLS401.T$PECL$C   =	ZNSLS004.T$PECL$C
					                        AND ZNSLS401.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											AND ZNSLS401.T$ENTR$C   =	ZNSLS004.T$ENTR$C
											
INNER JOIN (SELECT	D.T$NCIA$C,
                    D.T$UNEG$C,
                    D.T$PECL$C,
                    D.T$SQPD$C,
                    SUM(D.T$VLMR$C) T$VLMR$C
			FROM	BAANDB.TZNSLS402601 D
			GROUP BY D.T$NCIA$C,
			         D.T$UNEG$C,
			         D.T$PECL$C,
			         D.T$SQPD$C) ZNSLS402	ON	ZNSLS402.T$NCIA$C	=	ZNSLS004.T$NCIA$C
					                        AND ZNSLS402.T$UNEG$C   =	ZNSLS004.T$UNEG$C
					                        AND ZNSLS402.T$PECL$C   =	ZNSLS004.T$PECL$C
					                        AND ZNSLS402.T$SQPD$C   =	ZNSLS004.T$SQPD$C

INNER JOIN	BAANDB.TCISLI940601	CISLI940	ON	CISLI940.T$FIRE$L	=	CISLI245.T$FIRE$L

INNER JOIN (SELECT	E.T$FIRE$L,
					E.T$REFR$L,
					SUM(E.T$TLDM$L) T$TLDM$L,
					SUM(E1.T$TLDM$L) T$TLDM$L_FAT,
					SUM(E.T$DQUA$L) T$DQUA$L
			FROM	BAANDB.TCISLI941601 E
			LEFT JOIN BAANDB.TCISLI941601 E1 
						ON	E1.T$FIRE$L=E.T$REFR$L
						AND	E1.T$LINE$L=E.T$RFDL$L
			GROUP BY E.T$FIRE$L,
					 E.T$REFR$L) CISLI941	ON	CISLI941.T$FIRE$L	=	CISLI940.T$FIRE$L
					 
LEFT JOIN	BAANDB.TCISLI940601	CISLI940_FAT ON	CISLI940_FAT.T$FIRE$L =	CISLI941.T$REFR$L
											AND	CISLI940_FAT.T$FDTY$L =	16
			
LEFT JOIN (	SELECT	F.T$FIRE$L,
					F.T$AMNT$L
			FROM	BAANDB.TCISLI942601 F
			WHERE	F.T$BRTY$L=3) Q_IPI		ON	Q_IPI.T$FIRE$L		=	CISLI940.T$FIRE$L

											
--WHERE
--		CISLI940.T$STAT$L IN (5, 6)			-- IMPRESSO, LANÇADO
--AND 	CISLI940.T$FDTY$L NOT IN (2,14)
    WHERE cisli940.t$stat$l IN (2,5,6,101)      --cancelada, impressa, lançada, estornada
    AND   cisli940.t$cnfe$l != ' '
    AND   exists (select *
                  from  baandb.tznnfe011601 znnfe011
                  where znnfe011.t$oper$c = 1
                  and   znnfe011.t$fire$c = cisli940.t$fire$l
                  and   znnfe011.t$stfa$c = 5
                  and   (znnfe011.t$nfes$c = 2 or znnfe011.t$nfes$c = 5))
   AND      cisli940.t$fdty$l NOT IN (2,14)     --2-venda sem pedido, 14-retorno mercadoria cliente
--***************************************************************************************************************************
--				COLETA
--***************************************************************************************************************************

UNION
SELECT
		'NIKE.COM'												FILIAL,
		TDREC940.T$DOCN$L || TDREC940.T$SERI$L				TICKET,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA_VENDA,
		nvl(to_char(ZNSLS400.T$ICLF$C),' ')										CPF_CGC,		-- VERIFICAR FORMATAÇÃO
		''														PERIODO,
		''														VENDEDOR,
		'004'													OPERACAO_VENDA,
		''														CODIGO_TAB_PRECO,
		0														COMISSAO,
		0														DESCONTO,
		0														QTDE_TOTAL,
		(TDREC940.T$TFDA$L + TDREC940.T$FGHT$L)*-1				VALOR_TIKET,
		TDREC940.T$TFDA$L*-1									VALOR_PAGO,
		(TDREC940.T$TFDA$L + TDREC940.T$FGHT$L)*-1				VALOR_VENDA_BRUTA,
		(TDREC940.T$TFDA$L + TDREC940.T$FGHT$L)*-1				VALOR_TROCA,
		ZNSLS401.T$QTVE$C							QTDE_TROCA_TOTAL,					--ALT2
		'' 													TICKET_IMPRESSO,
		''														TERMINAL,
		''														GERENTE_LOJA,
		''														GERENTE_PERIODO,
		''														LANCAMENTO_CAIXA,
		0														VALOR_CANCELADO,
		0														TOTAL_QTDE_CANCELADA,
		ZNSLS401.QITM											QTDE_ITEM,							-- ALT2
		''														MOTIVO_CANCELAMENTO,
		CASE WHEN ZNSLS400.T$FTYP$C='PF'			
		 THEN nvl(to_char(ZNSLS400.T$ICLF$C),' ')			
		 ELSE NULL END											CPF_CGC_ECF,
		''														DATA_HORA_CANCELAMENTO,
		''														SUGESTAO_COD_FORMA_PGTO,
		nvl(Q_IPI.T$AMNT$L,0)											VALOR_IPI,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$IDAT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				EMISSAO,
		TO_CHAR(0)														TRANSIT_TIME,
    'C'                         TP_MOVTO,                 -- Criado para separar na tabela as entradas e saídas
    tdrec940.t$fire$l           REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DT_ULT_ALTERACAO
		
FROM
		(	SELECT	A.T$FIRE$L,
					A.T$ORNO$L
			FROM	BAANDB.TTDREC947601 A
			WHERE	A.T$NCMP$L=601
			AND		A.T$OORG$L=1
			GROUP BY A.T$FIRE$L,
		             A.T$ORNO$L)	TDREC947
					 
INNER JOIN (SELECT	B.T$NCIA$C,
					B.T$UNEG$C,
					B.T$PECL$C,
					B.T$SQPD$C,
					B.T$ENTR$C,
					B.T$ORNO$C
			FROM 	BAANDB.TZNSLS004601 B
			GROUP BY B.T$NCIA$C,
			         B.T$UNEG$C,
                     B.T$PECL$C,
                     B.T$SQPD$C,
					 B.T$ENTR$C,
                     B.T$ORNO$C) ZNSLS004	ON	ZNSLS004.T$ORNO$C	=	TDREC947.T$ORNO$L

INNER JOIN	BAANDB.TZNSLS400601	ZNSLS400	ON	ZNSLS400.T$NCIA$C	=	ZNSLS004.T$NCIA$C
                                            AND ZNSLS400.T$UNEG$C   =	ZNSLS004.T$UNEG$C
                                            AND ZNSLS400.T$PECL$C   =	ZNSLS004.T$PECL$C
                                            AND ZNSLS400.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											
INNER JOIN (SELECT	C.T$NCIA$C,
					C.T$UNEG$C,
					C.T$PECL$C,
					C.T$SQPD$C,
					C.T$ENTR$C,
					SUM(C.T$QTVE$C) T$QTVE$C,
					-- MAX(C.T$PZTR$C) T$PZTR$C
					COUNT(DISTINCT C.T$ITEM$C) QITM	
			FROM	BAANDB.TZNSLS401601 C
			WHERE	C.T$IITM$C='P'
			GROUP BY C.T$NCIA$C,
			         C.T$UNEG$C,
			         C.T$PECL$C,
			         C.T$SQPD$C,
			         C.T$ENTR$C) ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS004.T$NCIA$C
					                        AND ZNSLS401.T$UNEG$C   =	ZNSLS004.T$UNEG$C
					                        AND ZNSLS401.T$PECL$C   =	ZNSLS004.T$PECL$C
					                        AND ZNSLS401.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											AND ZNSLS401.T$ENTR$C   =	ZNSLS004.T$ENTR$C
											
INNER JOIN	BAANDB.TTDREC940601	TDREC940	ON	TDREC940.T$FIRE$L	=	TDREC947.T$FIRE$L
					 			
LEFT JOIN (	SELECT	F.T$FIRE$L,
					F.T$AMNT$L
			FROM	BAANDB.TTDREC949601 F
			WHERE	F.T$BRTY$L=3) Q_IPI		ON	Q_IPI.T$FIRE$L		=	TDREC940.T$FIRE$L
											
WHERE
--		TDREC940.T$STAT$L IN (4, 5)			-- APROVADO, APROVADO COM PROBLEMAS
    tdrec940.t$stat$l IN (4,5,6)      --4-aprovado, 5-aprovado com problemas, 6-estornado
    AND	  tdrec940.t$cnfe$l != ' '
AND 	TDREC940.T$RFDT$L = 10        --10-retorno de mercadoria

--***************************************************************************************************************************
--				INSTANCIA
--***************************************************************************************************************************

UNION
SELECT
		'NIKE.COM'												FILIAL,
--		ZNSLS400.T$PECL$C || ZNSLS400.T$SQPD$C					TICKET,
    TO_CHAR(znsls401.t$entr$c)                 TICKET,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA_VENDA,
		nvl(to_char(ZNSLS400.T$ICLF$C),' ')										CPF_CGC,		-- VERIFICAR FORMATAÇÃO
		''														PERIODO,
		''														VENDEDOR,
		'005'													OPERACAO_VENDA,
		''														CODIGO_TAB_PRECO,
		0														COMISSAO,
		0														DESCONTO,
		1														QTDE_TOTAL,
		ZNSLS401.VL_MERCD 
		+ ZNSLS401.VL_FRETE 
		- ZNSLS401.VL_DSCONT									VALOR_TIKET,
		ZNSLS402.T$VLMR$C										VALOR_PAGO,
		ZNSLS401.VL_MERCD 
		+ ZNSLS401.VL_FRETE 									VALOR_VENDA_BRUTA,
		0														VALOR_TROCA,
		0														QTDE_TROCA_TOTAL,
		'' 													TICKET_IMPRESSO,
		''														TERMINAL,
		''														GERENTE_LOJA,
		''														GERENTE_PERIODO,
		''														LANCAMENTO_CAIXA,
		0														VALOR_CANCELADO,
		0														TOTAL_QTDE_CANCELADA,
		1														QTDE_ITEM,
		''														MOTIVO_CANCELAMENTO,
		CASE WHEN ZNSLS400.T$FTYP$C='PF'			
		 THEN nvl(to_char(ZNSLS400.T$ICLF$C),' ')			
		 ELSE NULL END											CPF_CGC_ECF,
		''														DATA_HORA_CANCELAMENTO,
		''														SUGESTAO_COD_FORMA_PGTO,
		0														VALOR_IPI,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTIN$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				EMISSAO,
		TO_CHAR(0)														TRANSIT_TIME,
    'I'                         TP_MOVTO,                 -- Criado para separar na tabela as entradas e saídas
    CISLI940.T$FIRE$L           REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$RCD_UTC, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DT_ULT_ALTERACAO
		
FROM
			BAANDB.TZNSLS400601	ZNSLS400
											
INNER JOIN (SELECT	C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
                    C.T$ENTR$C,
					C.T$ORNO$C,
                    SUM(C.T$QTVE$C) T$QTVE$C,
					SUM(C.T$VLUN$C*C.T$QTVE$C)	VL_MERCD,
					SUM(C.T$VLDI$C) VL_DSCONT,
					SUM(C.T$VLFR$C) VL_FRETE,
					MAX(C.T$PZTR$C) T$PZTR$C
			FROM	BAANDB.TZNSLS401601 C
			GROUP BY C.T$NCIA$C,
			         C.T$UNEG$C,
			         C.T$PECL$C,
			         C.T$SQPD$C,
			         C.T$ENTR$C,
               C.T$ORNO$C) ZNSLS401			ON	ZNSLS401.T$NCIA$C	=	ZNSLS400.T$NCIA$C
					                        AND ZNSLS401.T$UNEG$C   =	ZNSLS400.T$UNEG$C
					                        AND ZNSLS401.T$PECL$C   =	ZNSLS400.T$PECL$C
					                        AND ZNSLS401.T$SQPD$C   =	ZNSLS400.T$SQPD$C

INNER JOIN	BAANDB.TTDSLS400601 TDSLS400	ON	TDSLS400.T$ORNO		=	ZNSLS401.T$ORNO$C
											
INNER JOIN (SELECT	D.T$NCIA$C,
                    D.T$UNEG$C,
                    D.T$PECL$C,
                    D.T$SQPD$C,
                    SUM(D.T$VLMR$C) T$VLMR$C
			FROM	BAANDB.TZNSLS402601 D
			GROUP BY D.T$NCIA$C,
			         D.T$UNEG$C,
			         D.T$PECL$C,
			         D.T$SQPD$C) ZNSLS402	ON	ZNSLS402.T$NCIA$C	=	ZNSLS400.T$NCIA$C
					                        AND ZNSLS402.T$UNEG$C   =	ZNSLS400.T$UNEG$C
					                        AND ZNSLS402.T$PECL$C   =	ZNSLS400.T$PECL$C
					                        AND ZNSLS402.T$SQPD$C   =	ZNSLS400.T$SQPD$C

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
       
WHERE
			ZNSLS400.T$IDPO$C	=		'TD'
		AND	TDSLS400.T$HDST		=		35
		AND TDSLS400.T$FDTY$L 	NOT IN (0,2,14)

ORDER BY TP_MOVTO, REF_FISCAL