SELECT
--***************************************************************************************************************************
--				VENDA
--***************************************************************************************************************************
		''														TERMINAL,
		''														LANCAMENTO_CAIXA,
		'NIKE.COM'												FILIAL,		
		ZNSLS402.T$NUPA$C										PARCELA,
		DECODE(ZNSLS402.T$IDAD$C,
			1,	'03',																		-- 1	Visa							03 - VISA CREDITO	
			2,	'04',                                                       				-- 2	Mastercard                      04 - MASTERCARD
			3,	'01',                                                       				-- 3	Amex                            01- AMERICAN EXPRESS
			4,	'07',                                                       				-- 4	Diners                          07 - DINERS
			5,	'10',                                                       				-- 5	Hipercard                       10 - HIPERCARD
			18,	'04',                                                       				-- 18	Extra Mastercard                04 - MASTERCARD
			38,	'11',                                                       				-- 38	Paypal                          11 - PAYPAL
			15,	'  ',                                                       				-- 15	Multicheque/Multicash           
			50,	'  ',                                                       				-- 50	Multicheque/Multicash           
			19,	'03',                                                       				-- 19	Extra Visa                      03 - VISA CREDITO
			11,	'03',                                                       				-- 11	Ponto Frio Visa                 03 - VISA CREDITO
			8,	'04',                                                       				-- 8	Ponto Frio Mastercard           04 - MASTERCARD
			10,	'11',                                                       				-- 10	Cartão Pão de Açúcar            
			7, 	'  ',                                                       				-- 7	Aura                            
			37,	'08',                                                       				-- 37	Elo                             08 - ELO CREDITO
			43,	'  ',                                                       				-- 43	Primeira Compra                 
			21, '  ',                                                       				-- 21	Ponto Frio Private Label        
			17, '  ',                                                       				-- 17	Extra Private Label             
			40, '04',                                                       				-- 40	Mobile Mastercard               04 - MASTERCARD
			42,	'05',                                                       				-- 42	Visa Electron                   05 - VISA ELECTRON
			49,	'04',                                                       				-- 49	Minha Casa Melhor Mastercard    04 - MASTERCARD
			39,	'03',                                                       				-- 39	Mobile Visa                     03 - VISA CREDITO
			22,	'  ',                                                       				-- 22	Itaucard
			48,	'  ',                                                       				-- 48	Minha Casa Melhor Elo
			44,	'  ',                                                       				-- 44	Clube Extra
			70, '  ')											CODIGO_ADMINISTRADORA,      -- 70	Bndes

		CASE WHEN ZNSLS400.T$IDPO$C='TD' THEN										--	LN										NIKE
				'T'																	--											T - TROCA
		 ELSE DECODE(ZNSLS402.T$IDMP$C,													
				1,	'A',                                                           --1	Cartão de Crédito						A - CARTAO DE CREDITO POS             /*Venda SIGE*/
				2,	'D',                                                           --2	Boleto B2C (BV)							J - DUPLICATA                         CASE WHEN b.pepa_id_meio_pagto = 'Cartão de Crédito' THEN 'A'
				3,	'D',                                                           --3	Boleto B2B Spot							J - DUPLICATA                         WHEN b.pepa_id_meio_pagto = 'Debito/transferencia' THEN '5'
				4,	'1',                                                           --4	Vale (VA)								    R - VALE PRODUTO                      WHEN b.pepa_id_meio_pagto = 'Vale' OR b.pepa_id_meio_pagto = 'Livre de Debito' THEN '1'
				5,	'5',                                                           --5	Debito/Transferência (BV)		5 - TRANSFERENCIA BANCARIA            WHEN b.pepa_id_meio_pagto = 'Boleto' OR b.pepa_id_meio_pagto = 'Boleto Globex' THEN 'D' END as
				8,	'D',                                                           --8	Boleto à Prazo B2B (PZ)					' ' - Não existe
				9,	'D',                                                           --9	Boleto a prazo Atacado (PZ)				' ' - Não existe
				10,	'D',                                                           --10	Boleto à vista Atacado (BV)			' ' - Não existe
				11, '  ',                                                          --11	Pagamento Complementar				' ' - Não existe
				12, '5',                                                           --12	Cartão de Débito (DB)				E - CARTAO DE DEBITO
				13, '  ',                                                          --13	Pagamento Antecipado				' ' - Não existe
				15,	'  ')	END									  TIPO_PAGTO,                        --15	BNDES								' ' - Não existe			
		ZNSLS402.T$VLPG$C										VALOR,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS402.T$PVEN$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 							VENCIMENTO,
		ZNSLS402.T$AUTO$C										NUMERO_TITULO,	
		''														MOEDA,
		''														AGENCIA,
		''														BANCO,
		''														CONTA_CORRENTE,
		ABS(ZNSLS402.T$NSUA$C)					NUMERO_APROVACAO_CARTAO,
		ZNSLS402.T$NUPA$C										PARCELAS_CARTAO,
		0														VALOR_CANCELADO,
		''														CHEQUE_CARTAO,
		''														NUMERO_LOTE,
		0														TROCO,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS402.T$DTRA$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 							DATA_HORA_TEF,
		''												ID_DOCUMENTO_ECF,
--		ZNSLS402.T$PECL$C || ZNSLS402.T$SQPD$C								TICKET,
    TO_CHAR(ZNSLS004.T$ENTR$C)         TICKET,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 							DATA_VENDA,
    'S'                           TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    cisli940.t$fire$l             REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 							DT_ULT_ALTERACAO
    
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
					SUM(C.T$VLDI$C) T$VLDI$C
                    --SUM(C.T$QTVE$C) T$QTVE$C,
					--MAX(C.T$PZTR$C) T$PZTR$C
			FROM	BAANDB.TZNSLS401601 C
			GROUP BY C.T$NCIA$C,
			         C.T$UNEG$C,
			         C.T$PECL$C,
			         C.T$SQPD$C,
			         C.T$ENTR$C) ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS004.T$NCIA$C
					                        AND ZNSLS401.T$UNEG$C   =	ZNSLS004.T$UNEG$C
					                        AND ZNSLS401.T$PECL$C   =	ZNSLS004.T$PECL$C
					                        AND ZNSLS401.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											AND ZNSLS401.T$ENTR$C   =	ZNSLS004.T$ENTR$C
											
INNER JOIN BAANDB.TZNSLS402601 ZNSLS402		ON	ZNSLS402.T$NCIA$C	=	ZNSLS004.T$NCIA$C
					                        AND ZNSLS402.T$UNEG$C   =	ZNSLS004.T$UNEG$C
					                        AND ZNSLS402.T$PECL$C   =	ZNSLS004.T$PECL$C
					                        AND ZNSLS402.T$SQPD$C   =	ZNSLS004.T$SQPD$C

INNER JOIN	BAANDB.TCISLI940601	CISLI940	ON	CISLI940.T$FIRE$L	=	CISLI245.T$FIRE$L

INNER JOIN (SELECT	E.T$FIRE$L,
					E.T$REFR$L
					-- SUM(E.T$TLDM$L) T$TLDM$L,
					-- SUM(E1.T$TLDM$L) T$TLDM$L_FAT,
					-- SUM(E.T$DQUA$L) T$DQUA$L
			FROM	BAANDB.TCISLI941601 E
			-- LEFT JOIN BAANDB.TCISLI941601 E1 
						-- ON	E1.T$FIRE$L=E.T$REFR$L
						-- AND	E1.T$LINE$L=E.T$RFDL$L
			GROUP BY E.T$FIRE$L,
					 E.T$REFR$L) CISLI941	ON	CISLI941.T$FIRE$L	=	CISLI940.T$FIRE$L
					 
LEFT JOIN	BAANDB.TCISLI940601	CISLI940_FAT ON	CISLI940_FAT.T$FIRE$L =	CISLI941.T$REFR$L
											AND	CISLI940_FAT.T$FDTY$L =	16
			
--WHERE
--		CISLI940.T$STAT$L IN (5, 6)			-- IMPRESSO, LANÇADO
--AND 	CISLI940.T$FDTY$L != 14
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
		''														TERMINAL,
		''														LANCAMENTO_CAIXA,
		'NIKE.COM'												FILIAL,		
		ZNSLS402.T$NUPA$C										PARCELA,
		DECODE(ZNSLS402.T$IDAD$C,
			1,	'03',																		-- 1	Visa							03 - VISA CREDITO	
			2,	'04',                                                       				-- 2	Mastercard                      04 - MASTERCARD
			3,	'01',                                                       				-- 3	Amex                            01- AMERICAN EXPRESS
			4,	'07',                                                       				-- 4	Diners                          07 - DINERS
			5,	'10',                                                       				-- 5	Hipercard                       10 - HIPERCARD
			18,	'04',                                                       				-- 18	Extra Mastercard                04 - MASTERCARD
			38,	'11',                                                       				-- 38	Paypal                          11 - PAYPAL
			15,	'  ',                                                       				-- 15	Multicheque/Multicash           
			50,	'  ',                                                       				-- 50	Multicheque/Multicash           
			19,	'03',                                                       				-- 19	Extra Visa                      03 - VISA CREDITO
			11,	'03',                                                       				-- 11	Ponto Frio Visa                 03 - VISA CREDITO
			8,	'04',                                                       				-- 8	Ponto Frio Mastercard           04 - MASTERCARD
			10,	'11',                                                       				-- 10	Cartão Pão de Açúcar            
			7, 	'  ',                                                       				-- 7	Aura                            
			37,	'08',                                                       				-- 37	Elo                             08 - ELO CREDITO
			43,	'  ',                                                       				-- 43	Primeira Compra                 
			21, '  ',                                                       				-- 21	Ponto Frio Private Label        
			17, '  ',                                                       				-- 17	Extra Private Label             
			40, '04',                                                       				-- 40	Mobile Mastercard               04 - MASTERCARD
			42,	'05',                                                       				-- 42	Visa Electron                   05 - VISA ELECTRON
			49,	'04',                                                       				-- 49	Minha Casa Melhor Mastercard    04 - MASTERCARD
			39,	'03',                                                       				-- 39	Mobile Visa                     03 - VISA CREDITO
			22,	'  ',                                                       				-- 22	Itaucard
			48,	'  ',                                                       				-- 48	Minha Casa Melhor Elo
			44,	'  ',                                                       				-- 44	Clube Extra
			70, '  ')											CODIGO_ADMINISTRADORA,      -- 70	Bndes

		
		'D'														TIPO_PAGTO,
		ZNSLS402.T$VLPG$C											VALOR,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L+1, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) 							VENCIMENTO,
		ZNSLS402.T$AUTO$C										NUMERO_TITULO,	
		''														MOEDA,
		''														AGENCIA,
		''														BANCO,
		''														CONTA_CORRENTE,
		ABS(ZNSLS402.T$NSUA$C)				NUMERO_APROVACAO_CARTAO,
		ZNSLS402.T$NUPA$C							PARCELAS_CARTAO,
		0														VALOR_CANCELADO,
		''														CHEQUE_CARTAO,
		''														NUMERO_LOTE,
		0														TROCO,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS402.T$DTRA$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) 							DATA_HORA_TEF,
		''														ID_DOCUMENTO_ECF,
		TDREC940.T$DOCN$L || TDREC940.T$SERI$L					TICKET,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) 							DATA_VENDA,												
    'C'                           TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    tdrec940.t$fire$l             REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) 							DT_ULT_ALTERACAO
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
					 
INNER JOIN BAANDB.TZNSLS402601 ZNSLS402		ON	ZNSLS402.T$NCIA$C	=	ZNSLS004.T$NCIA$C
					                        AND ZNSLS402.T$UNEG$C   =	ZNSLS004.T$UNEG$C
					                        AND ZNSLS402.T$PECL$C   =	ZNSLS004.T$PECL$C
					                        AND ZNSLS402.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											
INNER JOIN (SELECT	C.T$NCIA$C,
					C.T$UNEG$C,
					C.T$PECL$C,
					C.T$SQPD$C,
					C.T$ENTR$C,
					SUM(C.T$VLFR$C) T$VLFR$C
			FROM	BAANDB.TZNSLS401601 C
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

INNER JOIN (SELECT	L.T$FIRE$L,
                    L.T$DVRF$C
			FROM BAANDB.TTDREC941601 L
			GROUP BY L.T$FIRE$L,
               L.T$DVRF$C) TDREC941		ON	TDREC941.T$FIRE$L = TDREC940.T$FIRE$L
			

INNER JOIN  BAANDB.TCISLI940601 CISLI940  ON CISLI940.T$FIRE$L = TDREC941.T$DVRF$C

											
--WHERE
--		TDREC940.T$STAT$L IN (4, 5)			-- APROVADO, APROVADO COM PROBLEMAS
--AND 	TDREC940.T$RFDT$L = 10
WHERE
      tdrec940.t$stat$l IN (4,5,6)      --4-aprovado, 5-aprovado com problemas, 6-estornado
AND	  tdrec940.t$cnfe$l != ' '
AND 	TDREC940.T$RFDT$L = 10        --10-retorno de mercadoria

--***************************************************************************************************************************
--				INSTANCIA
--***************************************************************************************************************************
UNION
SELECT
		''														TERMINAL,
		''														LANCAMENTO_CAIXA,
		'NIKE.COM'												FILIAL,		
		ZNSLS402.T$NUPA$C										PARCELA,
		DECODE(ZNSLS402.T$IDAD$C,
			1,	'03',																		-- 1	Visa							03 - VISA CREDITO	
			2,	'04',                                                       				-- 2	Mastercard                      04 - MASTERCARD
			3,	'01',                                                       				-- 3	Amex                            01- AMERICAN EXPRESS
			4,	'07',                                                       				-- 4	Diners                          07 - DINERS
			5,	'10',                                                       				-- 5	Hipercard                       10 - HIPERCARD
			18,	'04',                                                       				-- 18	Extra Mastercard                04 - MASTERCARD
			38,	'11',                                                       				-- 38	Paypal                          11 - PAYPAL
			15,	'  ',                                                       				-- 15	Multicheque/Multicash           
			50,	'  ',                                                       				-- 50	Multicheque/Multicash           
			19,	'03',                                                       				-- 19	Extra Visa                      03 - VISA CREDITO
			11,	'03',                                                       				-- 11	Ponto Frio Visa                 03 - VISA CREDITO
			8,	'04',                                                       				-- 8	Ponto Frio Mastercard           04 - MASTERCARD
			10,	'11',                                                       				-- 10	Cartão Pão de Açúcar            
			7, 	'  ',                                                       				-- 7	Aura                            
			37,	'08',                                                       				-- 37	Elo                             08 - ELO CREDITO
			43,	'  ',                                                       				-- 43	Primeira Compra                 
			21, '  ',                                                       				-- 21	Ponto Frio Private Label        
			17, '  ',                                                       				-- 17	Extra Private Label             
			40, '04',                                                       				-- 40	Mobile Mastercard               04 - MASTERCARD
			42,	'05',                                                       				-- 42	Visa Electron                   05 - VISA ELECTRON
			49,	'04',                                                       				-- 49	Minha Casa Melhor Mastercard    04 - MASTERCARD
			39,	'03',                                                       				-- 39	Mobile Visa                     03 - VISA CREDITO
			22,	'  ',                                                       				-- 22	Itaucard
			48,	'  ',                                                       				-- 48	Minha Casa Melhor Elo
			44,	'  ',                                                       				-- 44	Clube Extra
			70, '  ')											CODIGO_ADMINISTRADORA,      -- 70	Bndes

		'6'														TIPO_PAGTO,
			
		-- ZNSLS401.VL_MERCD 
		-- - ZNSLS401.VL_DSCONT 
		-- + ZNSLS401.VL_FRETE										VALOR,
		ZNSLS402.T$VLPG$C											VALOR,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTIN$C+1, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) 							VENCIMENTO,
		ZNSLS402.T$AUTO$C										NUMERO_TITULO,	
		''														MOEDA,
		''														AGENCIA,
		''														BANCO,
		''														CONTA_CORRENTE,
		ZNSLS402.T$NSUA$C										NUMERO_APROVACAO_CARTAO,
		ZNSLS402.T$NUPA$C										PARCELAS_CARTAO,
		0														VALOR_CANCELADO,
		''														CHEQUE_CARTAO,
		''														NUMERO_LOTE,
		0														TROCO,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS402.T$DTRA$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) 							DATA_HORA_TEF,
		''														ID_DOCUMENTO_ECF,
--		ZNSLS400.T$PECL$C || ZNSLS400.T$SQPD$C					TICKET,
    TO_CHAR(znsls401.t$entr$c)             TICKET,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTIN$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) 							DATA_VENDA,
    'I'                           TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    cisli940.t$fire$l             REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) 							DT_ULT_ALTERACAO

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
											
INNER JOIN BAANDB.TZNSLS402601 ZNSLS402		ON	ZNSLS402.T$NCIA$C	=	ZNSLS400.T$NCIA$C
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
