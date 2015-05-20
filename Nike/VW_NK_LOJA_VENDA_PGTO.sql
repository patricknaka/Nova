
--***************************************************************************************************************************
--				VENDA
--***************************************************************************************************************************
SELECT
		ZNSLS004.T$PECL$C || ZNSLS004.T$SQPD$C					TICKET,
		'NIKE.COM'												FILIAL,
		' '														TERMINAL,
		DECODE(ZNSLS402.T$IDMP$C,													--	LN										NIKE
				1,	'08',                                                           --1	Cartão de Crédito						08 - CARTAO DE CREDITO TEF
				2,	'11',                                                           --2	Boleto B2C (BV)							11 - BOLETO BANCARIO
				3,	'  ',                                                           --3	Boleto B2B Spot							' ' - Não existe
				4,	'13',                                                           --4	Vale (VA)								13 - VOUCHER
				5,	'12',                                                           --5	Debito/Transferência (BV)				12 - TRANSFERENCIA BANCARIA
				8,	'  ',                                                           --8	Boleto à Prazo B2B (PZ)					' ' - Não existe
				9,	'11',                                                           --9	Boleto a prazo Atacado (PZ)				11 - BOLETO BANCARIO
				10,	'11',                                                           --10	Boleto à vista Atacado (BV)			11 - BOLETO BANCARIO
				11, '  ',                                                           --11	Pagamento Complementar				' ' - Não existe
				12, '09',                                                           --12	Cartão de Débito (DB)				09 - CARTAO DE DEBITO TEF
				13, '  ',                                                           --13	Pagamento Antecipado				' ' - Não existe
				15,	'  ')										COD_FORMA_PGTO,     --15	BNDES								' ' - Não existe
		
		' '														CAIXA_VENDEDOR,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS402.T$DTRA$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA,
		TO_CHAR(ZNSLS004.T$ENTR$C)										NUMERO_CUPOM_FISCAL,
		ZNSLS401.T$VLDI$C										DESCONTO_PGTO,
		ZNSLS402.T$VLMR$C										TOTAL_VENDA,
		' '														CANCELADO_FISCAL,
		ZNSLS402.T$NUPA$C										PARCELA,
		' '														LANCAMENTO_CAIXA,
		0														VALOR_CANCELADO,
		NULL														NUMERO_FISCAL_TROCA,
		' '														VENDA_FINALIZADA,
		' '														SERIE_NF_ENTRADA,
		CASE WHEN CISLI940.T$FDTY$L=15
		 THEN CISLI940_FAT.T$SERI$L
		 ELSE CISLI940.T$SERI$L END								SERIE_NF_SAIDA,
		' '														SERIE_NF_CANCELAMENTO,
		CASE WHEN CISLI940.T$FDTY$L=15
		 THEN CISLI940_FAT.T$DOCN$L
		 ELSE CISLI940.T$DOCN$L END								NUMERO_FISCAL_VENDA,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA_VENDA
FROM
		(	SELECT	A.T$FIRE$L,
					A.T$SLSO
			FROM	BAANDB.TCISLI245201 A
			WHERE	A.T$SLCP=201
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
			FROM 	BAANDB.TZNSLS004201 B
			GROUP BY B.T$NCIA$C,
			         B.T$UNEG$C,
                     B.T$PECL$C,
                     B.T$SQPD$C,
					 B.T$ENTR$C,
                     B.T$ORNO$C) ZNSLS004	ON	ZNSLS004.T$ORNO$C	=	CISLI245.T$SLSO

INNER JOIN	BAANDB.TZNSLS400201	ZNSLS400	ON	ZNSLS400.T$NCIA$C	=	ZNSLS004.T$NCIA$C
                                            AND ZNSLS400.T$UNEG$C   =	ZNSLS004.T$UNEG$C
                                            AND ZNSLS400.T$PECL$C   =	ZNSLS004.T$PECL$C
                                            AND ZNSLS400.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											
INNER JOIN (SELECT	C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
                    C.T$ENTR$C,
					SUM(C.T$VLDI$C) T$VLDI$C
                    --SUM(C.T$QTVE$C) T$QTVE$C,
					--MAX(C.T$PZTR$C) T$PZTR$C
			FROM	BAANDB.TZNSLS401201 C
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
					D.T$IDMP$C,
					MIN(D.T$DTRA$C) T$DTRA$C,
					SUM(D.T$VLMR$C) T$VLMR$C,
					MAX(D.T$NUPA$C) T$NUPA$C
			FROM BAANDB.TZNSLS402201 D
			GROUP BY D.T$NCIA$C,
			         D.T$UNEG$C,
			         D.T$PECL$C,
			         D.T$SQPD$C,
			         D.T$IDMP$C) ZNSLS402	ON	ZNSLS402.T$NCIA$C	=	ZNSLS004.T$NCIA$C
					                        AND ZNSLS402.T$UNEG$C   =	ZNSLS004.T$UNEG$C
					                        AND ZNSLS402.T$PECL$C   =	ZNSLS004.T$PECL$C
					                        AND ZNSLS402.T$SQPD$C   =	ZNSLS004.T$SQPD$C

INNER JOIN	BAANDB.TCISLI940201	CISLI940	ON	CISLI940.T$FIRE$L	=	CISLI245.T$FIRE$L

INNER JOIN (SELECT	E.T$FIRE$L,
					E.T$REFR$L
					-- SUM(E.T$TLDM$L) T$TLDM$L,
					-- SUM(E1.T$TLDM$L) T$TLDM$L_FAT,
					-- SUM(E.T$DQUA$L) T$DQUA$L
			FROM	BAANDB.TCISLI941201 E
			-- LEFT JOIN BAANDB.TCISLI941201 E1 
						-- ON	E1.T$FIRE$L=E.T$REFR$L
						-- AND	E1.T$LINE$L=E.T$RFDL$L
			GROUP BY E.T$FIRE$L,
					 E.T$REFR$L) CISLI941	ON	CISLI941.T$FIRE$L	=	CISLI940.T$FIRE$L
					 
LEFT JOIN	BAANDB.TCISLI940201	CISLI940_FAT ON	CISLI940_FAT.T$FIRE$L =	CISLI941.T$REFR$L
											AND	CISLI940_FAT.T$FDTY$L =	16
			
-- LEFT JOIN (	SELECT	F.T$FIRE$L,
					-- F.T$AMNT$L
			-- FROM	BAANDB.TCISLI942201 F
			-- WHERE	F.T$BRTY$L=3) Q_IPI		ON	Q_IPI.T$FIRE$L		=	CISLI940.T$FIRE$L

											
WHERE
		CISLI940.T$STAT$L IN (5, 6)			-- IMPRESSO, LANÇADO
AND 	CISLI940.T$FDTY$L != 14

		
		




--***************************************************************************************************************************
--				COLETA
--***************************************************************************************************************************
UNION
SELECT
		TDREC940.T$DOCN$L || TDREC940.T$SERI$L					TICKET,
		'NIKE.COM'												FILIAL,
		' '														TERMINAL,
		DECODE(ZNSLS402.T$IDMP$C,													--	LN										NIKE
				1,	'08',                                                           --1	Cartão de Crédito						08 - CARTAO DE CREDITO TEF
				2,	'11',                                                           --2	Boleto B2C (BV)							11 - BOLETO BANCARIO
				3,	'  ',                                                           --3	Boleto B2B Spot							' ' - Não existe
				4,	'13',                                                           --4	Vale (VA)								13 - VOUCHER
				5,	'12',                                                           --5	Debito/Transferência (BV)				12 - TRANSFERENCIA BANCARIA
				8,	'  ',                                                           --8	Boleto à Prazo B2B (PZ)					' ' - Não existe
				9,	'11',                                                           --9	Boleto a prazo Atacado (PZ)				11 - BOLETO BANCARIO
				10,	'11',                                                           --10	Boleto à vista Atacado (BV)			11 - BOLETO BANCARIO
				11, '  ',                                                           --11	Pagamento Complementar				' ' - Não existe
				12, '09',                                                           --12	Cartão de Débito (DB)				09 - CARTAO DE DEBITO TEF
				13, '  ',                                                           --13	Pagamento Antecipado				' ' - Não existe
				15,	'  ')										COD_FORMA_PGTO,     --15	BNDES								' ' - Não existe
		
		' '														CAIXA_VENDEDOR,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA,
		TDREC940.T$DOCN$L || TDREC940.T$SERI$L					NUMERO_CUPOM_FISCAL,
		ZNSLS401.T$VLFR$C*-1									DESCONTO_PGTO,
		TDREC940.T$TFDA$L*-1									TOTAL_VENDA,
		' '														CANCELADO_FISCAL,
		1														PARCELA,
		' '														LANCAMENTO_CAIXA,
		0														VALOR_CANCELADO,
		CISLI940.T$DOCN$L							NUMERO_FISCAL_TROCA,
		' '														VENDA_FINALIZADA,
		TDREC940.T$SERI$L										SERIE_NF_ENTRADA,
		' '														SERIE_NF_SAIDA,
		' '														SERIE_NF_CANCELAMENTO,
		TDREC940.T$DOCN$L										NUMERO_FISCAL_VENDA,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA_VENDA
FROM
		(	SELECT	A.T$FIRE$L,
					A.T$ORNO$L
			FROM	BAANDB.TTDREC947201 A
			WHERE	A.T$NCMP$L=201
			AND		A.T$OORG$L=1
			GROUP BY A.T$FIRE$L,
		             A.T$ORNO$L)	TDREC947
					 
INNER JOIN (SELECT	B.T$NCIA$C,
					B.T$UNEG$C,
					B.T$PECL$C,
					B.T$SQPD$C,
					B.T$ENTR$C,
					B.T$ORNO$C
			FROM 	BAANDB.TZNSLS004201 B
			GROUP BY B.T$NCIA$C,
			         B.T$UNEG$C,
                     B.T$PECL$C,
                     B.T$SQPD$C,
					 B.T$ENTR$C,
                     B.T$ORNO$C) ZNSLS004	ON	ZNSLS004.T$ORNO$C	=	TDREC947.T$ORNO$L
					 
INNER JOIN (SELECT	D.T$NCIA$C,
                    D.T$UNEG$C,
                    D.T$PECL$C,
                    D.T$SQPD$C,
					D.T$IDMP$C,
					MIN(D.T$DTRA$C) T$DTRA$C,
					SUM(D.T$VLMR$C) T$VLMR$C,
					MAX(D.T$NUPA$C) T$NUPA$C
			FROM BAANDB.TZNSLS402201 D
			GROUP BY D.T$NCIA$C,
			         D.T$UNEG$C,
			         D.T$PECL$C,
			         D.T$SQPD$C,
			         D.T$IDMP$C) ZNSLS402	ON	ZNSLS402.T$NCIA$C	=	ZNSLS004.T$NCIA$C
					                        AND ZNSLS402.T$UNEG$C   =	ZNSLS004.T$UNEG$C
					                        AND ZNSLS402.T$PECL$C   =	ZNSLS004.T$PECL$C
					                        AND ZNSLS402.T$SQPD$C   =	ZNSLS004.T$SQPD$C

-- INNER JOIN	BAANDB.TZNSLS400201	ZNSLS400	ON	ZNSLS400.T$NCIA$C	=	ZNSLS004.T$NCIA$C
                                            -- AND ZNSLS400.T$UNEG$C   =	ZNSLS004.T$UNEG$C
                                            -- AND ZNSLS400.T$PECL$C   =	ZNSLS004.T$PECL$C
                                            -- AND ZNSLS400.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											
INNER JOIN (SELECT	C.T$NCIA$C,
					C.T$UNEG$C,
					C.T$PECL$C,
					C.T$SQPD$C,
					C.T$ENTR$C,
					SUM(C.T$VLFR$C) T$VLFR$C
			FROM	BAANDB.TZNSLS401201 C
			GROUP BY C.T$NCIA$C,
			         C.T$UNEG$C,
			         C.T$PECL$C,
			         C.T$SQPD$C,
			         C.T$ENTR$C) ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS004.T$NCIA$C
					                        AND ZNSLS401.T$UNEG$C   =	ZNSLS004.T$UNEG$C
					                        AND ZNSLS401.T$PECL$C   =	ZNSLS004.T$PECL$C
					                        AND ZNSLS401.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											AND ZNSLS401.T$ENTR$C   =	ZNSLS004.T$ENTR$C
											

INNER JOIN	BAANDB.TTDREC940201	TDREC940	ON	TDREC940.T$FIRE$L	=	TDREC947.T$FIRE$L

INNER JOIN (SELECT	L.T$FIRE$L,
                    L.T$DVRF$C
			FROM BAANDB.TTDREC941201 L
			GROUP BY L.T$FIRE$L,
               L.T$DVRF$C) TDREC941		ON	TDREC941.T$FIRE$L = TDREC940.T$FIRE$L
			

INNER JOIN  BAANDB.TCISLI940201 CISLI940  ON CISLI940.T$FIRE$L = TDREC941.T$DVRF$C

											
WHERE
		TDREC940.T$STAT$L IN (4, 5)			-- APROVADO, APROVADO COM PROBLEMAS
AND 	TDREC940.T$RFDT$L = 10








--***************************************************************************************************************************
--				INSTANCIA
--***************************************************************************************************************************
UNION
SELECT
		ZNSLS400.T$PECL$C || ZNSLS400.T$SQPD$C					TICKET,
		'NIKE.COM'												FILIAL,
		' '														TERMINAL,
		DECODE(ZNSLS402.T$IDMP$C,													--	LN										NIKE
				1,	'08',                                                           --1	Cartão de Crédito						08 - CARTAO DE CREDITO TEF
				2,	'11',                                                           --2	Boleto B2C (BV)							11 - BOLETO BANCARIO
				3,	'  ',                                                           --3	Boleto B2B Spot							' ' - Não existe
				4,	'13',                                                           --4	Vale (VA)								13 - VOUCHER
				5,	'12',                                                           --5	Debito/Transferência (BV)				12 - TRANSFERENCIA BANCARIA
				8,	'  ',                                                           --8	Boleto à Prazo B2B (PZ)					' ' - Não existe
				9,	'11',                                                           --9	Boleto a prazo Atacado (PZ)				11 - BOLETO BANCARIO
				10,	'11',                                                           --10	Boleto à vista Atacado (BV)			11 - BOLETO BANCARIO
				11, '  ',                                                           --11	Pagamento Complementar				' ' - Não existe
				12, '09',                                                           --12	Cartão de Débito (DB)				09 - CARTAO DE DEBITO TEF
				13, '  ',                                                           --13	Pagamento Antecipado				' ' - Não existe
				15,	'  ')										COD_FORMA_PGTO,     --15	BNDES								' ' - Não existe
		
		' '														CAIXA_VENDEDOR,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTIN$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA,
		ZNSLS400.T$PECL$C || ZNSLS400.T$SQPD$C					NUMERO_CUPOM_FISCAL,
		ZNSLS401.VL_DSCONT									DESCONTO_PGTO,
		ZNSLS402.T$VLMR$C										TOTAL_VENDA,
		' '														CANCELADO_FISCAL,
		1														PARCELA,
		' '														LANCAMENTO_CAIXA,
		0														VALOR_CANCELADO,
		NULL														NUMERO_FISCAL_TROCA,
		' '														VENDA_FINALIZADA,
		' '														SERIE_NF_ENTRADA,
		' '														SERIE_NF_SAIDA,
		' '														SERIE_NF_CANCELAMENTO,
		NULL														NUMERO_FISCAL_VENDA,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA_VENDA
FROM
			BAANDB.TZNSLS400201	ZNSLS400
											
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
			FROM	BAANDB.TZNSLS401201 C
			GROUP BY C.T$NCIA$C,
			         C.T$UNEG$C,
			         C.T$PECL$C,
			         C.T$SQPD$C,
			         C.T$ENTR$C,
               C.T$ORNO$C) ZNSLS401			ON	ZNSLS401.T$NCIA$C	=	ZNSLS400.T$NCIA$C
					                        AND ZNSLS401.T$UNEG$C   =	ZNSLS400.T$UNEG$C
					                        AND ZNSLS401.T$PECL$C   =	ZNSLS400.T$PECL$C
					                        AND ZNSLS401.T$SQPD$C   =	ZNSLS400.T$SQPD$C

											
INNER JOIN	BAANDB.TTDSLS400201 TDSLS400	ON	TDSLS400.T$ORNO		=	ZNSLS401.T$ORNO$C
											
INNER JOIN (SELECT	D.T$NCIA$C,
                    D.T$UNEG$C,
                    D.T$PECL$C,
                    D.T$SQPD$C,
					D.T$IDMP$C,
                    SUM(D.T$VLMR$C) T$VLMR$C
			FROM	BAANDB.TZNSLS402201 D
			GROUP BY D.T$NCIA$C,
			         D.T$UNEG$C,
			         D.T$PECL$C,
			         D.T$SQPD$C,
               D.T$IDMP$C) ZNSLS402	ON	ZNSLS402.T$NCIA$C	=	ZNSLS400.T$NCIA$C
					                        AND ZNSLS402.T$UNEG$C   =	ZNSLS400.T$UNEG$C
					                        AND ZNSLS402.T$PECL$C   =	ZNSLS400.T$PECL$C
					                        AND ZNSLS402.T$SQPD$C   =	ZNSLS400.T$SQPD$C
											
WHERE
			ZNSLS400.T$IDPO$C	=		'TD'
		AND	TDSLS400.T$HDST		=		35
		AND TDSLS400.T$FDTY$L 	NOT IN (0,14)