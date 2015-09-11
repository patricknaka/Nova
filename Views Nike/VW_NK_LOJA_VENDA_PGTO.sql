SELECT
--***************************************************************************************************************************
--				VENDA
--***************************************************************************************************************************
    TO_CHAR(znsls004.t$entr$c)                      TICKET,
		'NIKE.COM'												              FILIAL,
		''														                  TERMINAL,
		CASE WHEN ZNSLS400.T$IDPO$C='TD' THEN										--	LN										NIKE
				'T'																	--											T - TROCA
    ELSE
      DECODE(ZNSLS402.T$IDMP$C,													--	LN										NIKE
          1,	'08',                                                           --1	Cartão de Crédito						A - CARTAO DE CREDITO POS 
          2,	'11',                                                           --2	Boleto B2C (BV)							J - DUPLICATA
          3,	' ',                                                           --3	Boleto B2B Spot							J - DUPLICATA
          4,	'13',                                                           --4	Vale (VA)								    R - VALE PRODUTO
          5,	'12',                                                           --5	Debito/Transferência (BV)		5 - TRANSFERENCIA BANCARIA
          8,	' ',                                                           --8	Boleto à Prazo B2B (PZ)					' ' - Não existe
          9,	'11',                                                           --9	Boleto a prazo Atacado (PZ)				' ' - Não existe
          10,	'11',                                                           --10	Boleto à vista Atacado (BV)			' ' - Não existe
          11, '  ',                                                          --11	Pagamento Complementar				' ' - Não existe
          12, '09',                                                           --12	Cartão de Débito (DB)				E - CARTAO DE DEBITO
          13, '  ',                                                          --13	Pagamento Antecipado				' ' - Não existe
          15,	'  ')			END 					              COD_FORMA_PGTO,           --15	BNDES								' ' - Não existe			
		
		''														                  CAIXA_VENDEDOR,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS402.T$DTRA$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA,
		TO_CHAR(ZNSLS004.T$ENTR$C)										  NUMERO_CUPOM_FISCAL,
    cisli940.t$fght$l * (-1)                         DESCONTO_PGTO,
    cisli940.t$amnt$l                               TOTAL_VENDA,
		''														                  CANCELADO_FISCAL,
		ZNSLS402.T$NUPA$C										            PARCELA,
		''														                  LANCAMENTO_CAIXA,
		0														                    VALOR_CANCELADO,
		NULL														                NUMERO_FISCAL_TROCA,
		''														                  VENDA_FINALIZADA,
		''														                  SERIE_NF_ENTRADA,
		CASE WHEN CISLI940.T$FDTY$L=15
		 THEN CISLI940_FAT.T$SERI$L
		 ELSE CISLI940.T$SERI$L END								      SERIE_NF_SAIDA,
		''														                  SERIE_NF_CANCELAMENTO,
		CASE WHEN CISLI940.T$FDTY$L=15
		 THEN TO_CHAR(CISLI940_FAT.T$DOCN$L)
		 ELSE TO_CHAR(CISLI940.T$DOCN$L) END						NUMERO_FISCAL_VENDA,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 			DATA_VENDA,
    'S'                           TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    cisli940.t$fire$l             REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 			DT_ULT_ALTERACAO,
    ''                                             NUMERO_FISCAL_CANCELAMENTO

FROM	(	SELECT	A.T$FIRE$L,
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
											
INNER JOIN (SELECT	D.T$NCIA$C,
                    D.T$UNEG$C,
                    D.T$PECL$C,
                    D.T$SQPD$C,
					D.T$IDMP$C,
					MIN(D.T$DTRA$C) T$DTRA$C,
					SUM(D.T$VLMR$C) T$VLMR$C,
					MAX(D.T$NUPA$C) T$NUPA$C
			FROM BAANDB.TZNSLS402601 D
			GROUP BY D.T$NCIA$C,
			         D.T$UNEG$C,
			         D.T$PECL$C,
			         D.T$SQPD$C,
			         D.T$IDMP$C) ZNSLS402	ON	ZNSLS402.T$NCIA$C	=	ZNSLS004.T$NCIA$C
					                        AND ZNSLS402.T$UNEG$C   =	ZNSLS004.T$UNEG$C
					                        AND ZNSLS402.T$PECL$C   =	ZNSLS004.T$PECL$C
					                        AND ZNSLS402.T$SQPD$C   =	ZNSLS004.T$SQPD$C

INNER JOIN	BAANDB.TCISLI940601	CISLI940	ON	CISLI940.T$FIRE$L	=	CISLI245.T$FIRE$L

INNER JOIN (SELECT	E.T$FIRE$L,
					E.T$REFR$L

			FROM	BAANDB.TCISLI941601 E

			GROUP BY E.T$FIRE$L,
					 E.T$REFR$L) CISLI941	ON	CISLI941.T$FIRE$L	=	CISLI940.T$FIRE$L
					 
LEFT JOIN	BAANDB.TCISLI940601	CISLI940_FAT ON	CISLI940_FAT.T$FIRE$L =	CISLI941.T$REFR$L
											AND	CISLI940_FAT.T$FDTY$L =	16
														

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
--				TROCA
--***************************************************************************************************************************
UNION
SELECT
		TDREC940.T$DOCN$L || TDREC940.T$SERI$L					TICKET,
		'NIKE.COM'												              FILIAL,
		''														                  TERMINAL,
--		DECODE(ZNSLS402.T$IDMP$C,													--	LN										NIKE
--				1,	'08',                                                           --1	Cartão de Crédito						08 - CARTAO DE CREDITO TEF
--				2,	'11',                                                           --2	Boleto B2C (BV)							11 - BOLETO BANCARIO
--				3,	'  ',                                                           --3	Boleto B2B Spot							' ' - Não existe
--				4,	'13',                                                           --4	Vale (VA)								13 - VOUCHER
--				5,	'12',                                                           --5	Debito/Transferência (BV)				12 - TRANSFERENCIA BANCARIA
--				8,	'  ',                                                           --8	Boleto à Prazo B2B (PZ)					' ' - Não existe
--				9,	'11',                                                           --9	Boleto a prazo Atacado (PZ)				11 - BOLETO BANCARIO
--				10,	'11',                                                           --10	Boleto à vista Atacado (BV)			11 - BOLETO BANCARIO
--				11, '  ',                                                           --11	Pagamento Complementar				' ' - Não existe
--				12, '09',                                                           --12	Cartão de Débito (DB)				09 - CARTAO DE DEBITO TEF
--				13, '  ',                                                           --13	Pagamento Antecipado				' ' - Não existe
--				15,	'  ')										                COD_FORMA_PGTO,     --15	BNDES								' ' - Não existe
		'$$'                                            COD_FORMA_PGTO,
		''														                  CAIXA_VENDEDOR,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA,
		TDREC940.T$DOCN$L || TDREC940.T$SERI$L					NUMERO_CUPOM_FISCAL,
--		ZNSLS401.T$VLFR$C*-1									          DESCONTO_PGTO,
    0.0                                             DESCONTO_PGTO,
		(TDREC940.T$TFDA$L + ZNSLS401.T$VLFR$C )*-1	    TOTAL_VENDA,
		''														                  CANCELADO_FISCAL,
		1														                    PARCELA,
		''														                  LANCAMENTO_CAIXA,
		0														                    VALOR_CANCELADO,
		CISLI940.T$DOCN$L							                  NUMERO_FISCAL_TROCA,
		''														                  VENDA_FINALIZADA,
		TDREC940.T$SERI$L										            SERIE_NF_ENTRADA,
		''														                  SERIE_NF_SAIDA,
		''														                  SERIE_NF_CANCELAMENTO,
		TO_CHAR(TDREC940.T$DOCN$L)										  NUMERO_FISCAL_VENDA,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 			DATA_VENDA,
    'C'                           TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    tdrec940.t$fire$l             REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 			DT_ULT_ALTERACAO,
    ''                                             NUMERO_FISCAL_CANCELAMENTO

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
					 
LEFT JOIN (SELECT	D.T$NCIA$C,
                    D.T$UNEG$C,
                    D.T$PECL$C,
                    D.T$SQPD$C,
					D.T$IDMP$C,
					MIN(D.T$DTRA$C) T$DTRA$C,
					SUM(D.T$VLMR$C) T$VLMR$C,
					MAX(D.T$NUPA$C) T$NUPA$C
			FROM BAANDB.TZNSLS402601 D
			GROUP BY D.T$NCIA$C,
			         D.T$UNEG$C,
			         D.T$PECL$C,
			         D.T$SQPD$C,
			         D.T$IDMP$C) ZNSLS402	ON	ZNSLS402.T$NCIA$C	=	ZNSLS004.T$NCIA$C
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
											

WHERE
      tdrec940.t$stat$l IN (4,5,6)      --4-aprovado, 5-aprovado com problemas, 6-estornado
AND	  tdrec940.t$cnfe$l != ' '
AND 	TDREC940.T$RFDT$L = 10        --10-retorno de mercadoria

--***************************************************************************************************************************
--				INSTANCIA
--***************************************************************************************************************************
UNION
SELECT
--		ZNSLS400.T$PECL$C || ZNSLS400.T$SQPD$C					  TICKET,
    TO_CHAR(znsls401.t$entr$c)                        TICKET,
		'NIKE.COM'												                FILIAL,
		''														                    TERMINAL,
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
				15,	'  ')										                  COD_FORMA_PGTO,     --15	BNDES								' ' - Não existe
		
		''														                    CAIXA_VENDEDOR,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTIN$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA,
		ZNSLS400.T$PECL$C || ZNSLS400.T$SQPD$C					  NUMERO_CUPOM_FISCAL,
		ZNSLS401.VL_DSCONT									              DESCONTO_PGTO,
		ZNSLS402.T$VLMR$C	                                TOTAL_VENDA,
		''														                    CANCELADO_FISCAL,
		1														                      PARCELA,
		''														                    LANCAMENTO_CAIXA,
		0														                      VALOR_CANCELADO,
		NULL														                  NUMERO_FISCAL_TROCA,
		''														                    VENDA_FINALIZADA,
		''														                    SERIE_NF_ENTRADA,
		''														                    SERIE_NF_SAIDA,
		''														                    SERIE_NF_CANCELAMENTO,
		NULL														                  NUMERO_FISCAL_VENDA,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA_VENDA,
    'I'                                               TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    CISLI940.T$FIRE$L                                 REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$RCD_UTC, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DT_ULT_ALTERACAO,
    ''                                               NUMERO_FISCAL_CANCELAMENTO

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
					D.T$IDMP$C,
                    SUM(D.T$VLMR$C) T$VLMR$C
			FROM	BAANDB.TZNSLS402601 D
			GROUP BY D.T$NCIA$C,
			         D.T$UNEG$C,
			         D.T$PECL$C,
			         D.T$SQPD$C,
               D.T$IDMP$C) ZNSLS402	ON	ZNSLS402.T$NCIA$C	=	ZNSLS400.T$NCIA$C
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
		AND TDSLS400.T$FDTY$L 	NOT IN (0,2,14)   --branco, venda sem pedido, retorno de mercadoria de cliente
    
ORDER BY TICKET, TP_MOVTO, REF_FISCAL
