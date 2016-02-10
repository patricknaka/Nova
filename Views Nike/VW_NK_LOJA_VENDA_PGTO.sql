SELECT
--***************************************************************************************************************************
--				VENDA LJ
--***************************************************************************************************************************
    TO_CHAR(znsls004.t$entr$c)                      TICKET,
		'NIKE.COM'												              FILIAL,
		''														                  TERMINAL,
    CASE WHEN ZNSLS402.NO_IDMP > 1 THEN
          '$$'
    ELSE
              DECODE(ZNSLS402.T$IDMP$C,													                            --	LN										NIKE
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
                  15,	'  ')			END 					                                        --15	BNDES								' ' - Não existe                                             
                                                    COD_FORMA_PGTO, 
		
		''														                  CAIXA_VENDEDOR,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS402.T$DTVB$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA,
		TO_CHAR(ZNSLS004.T$ENTR$C)										  NUMERO_CUPOM_FISCAL,
    CASE WHEN CISLI940.T$FDTY$L=15 THEN
          cisli940_FAT.t$fght$l * (-1)
    ELSE  cisli940.t$fght$l * (-1) END              DESCONTO_PGTO,
    CASE WHEN CISLI940.T$FDTY$L=15 THEN
          cisli940_FAT.t$amnt$l
    ELSE  cisli940.t$amnt$l END                     TOTAL_VENDA,
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
    CASE WHEN CISLI940.T$FDTY$L=15 THEN
          CISLI940_FAT.T$FIRE$L
    ELSE  cisli940.t$fire$l END                   REF_FISCAL,
    CASE WHEN CISLI940.T$FDTY$L=15 THEN
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940_FAT.t$SADT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
          AT time zone 'America/Sao_Paulo') AS DATE)
    ELSE
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$SADT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
          AT time zone 'America/Sao_Paulo') AS DATE)
    END                                             DT_ULT_ALTERACAO,
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
					MIN(D.T$DTVB$C) T$DTVB$C,
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

INNER JOIN (SELECT	D.T$NCIA$C,
                    D.T$UNEG$C,
                    D.T$PECL$C,
                    D.T$SQPD$C,
          COUNT(D.T$IDMP$C) NO_IDMP
			FROM BAANDB.TZNSLS402601 D
			GROUP BY D.T$NCIA$C,
			         D.T$UNEG$C,
			         D.T$PECL$C,
			         D.T$SQPD$C ) ZNSLS402	
       ON	ZNSLS402.T$NCIA$C	=	ZNSLS004.T$NCIA$C
      AND ZNSLS402.T$UNEG$C =	ZNSLS004.T$UNEG$C
      AND ZNSLS402.T$PECL$C =	ZNSLS004.T$PECL$C
      AND ZNSLS402.T$SQPD$C =	ZNSLS004.T$SQPD$C
                                  
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
                  where znnfe011.t$oper$c = 1   --faturamento
                  and   znnfe011.t$fire$c = cisli940.t$fire$l
                  and   znnfe011.t$stfa$c = 5   --nota impressa
                  and   znnfe011.t$nfes$c = 5)  --nfe processada
   AND      cisli940.t$fdty$l NOT IN (2,14)     --2-venda sem pedido, 14-retorno mercadoria cliente
   AND      znsls400.t$idpo$c = 'LJ'
  
--***************************************************************************************************************************
--				TROCA
--***************************************************************************************************************************
UNION

SELECT
		TDREC940.T$DOCN$L || TDREC940.T$SERI$L					TICKET,
		'NIKE.COM'												              FILIAL,
		''														                  TERMINAL,
--		DECODE(ZNSLS402.T$IDMP$C,													                      --	LN										NIKE
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
    TDREC940.T$FGHT$L * -1							            DESCONTO_PGTO,
		(TDREC940.T$GTAM$L + TDREC940.T$ADDC$L + TDREC940.T$GEXP$L + TDREC940.T$CCHR$L + TDREC940.T$FGHT$L)*-1	    TOTAL_VENDA,
		''														                  CANCELADO_FISCAL,
		1														                    PARCELA,
		''														                  LANCAMENTO_CAIXA,
		0														                    VALOR_CANCELADO,
--    CASE WHEN CISLI940.T$DOCN$L IS NULL THEN
--        ZNMCS095.T$DOCN$C
--		ELSE CISLI940.T$DOCN$L	END		                  NUMERO_FISCAL_TROCA,
    tdrec940.t$docn$l                               NUMERO_FISCAL_TROCA,
		''														                  VENDA_FINALIZADA,
		TDREC940.T$SERI$L										            SERIE_NF_ENTRADA,
		''														                  SERIE_NF_SAIDA,
		''														                  SERIE_NF_CANCELAMENTO,
		TO_CHAR(TDREC940.T$DOCN$L)										  NUMERO_FISCAL_VENDA,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 			DATA_VENDA,
    'C'                           TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    tdrec940.t$fire$l             REF_FISCAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$ADAT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
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
			

--LEFT JOIN  BAANDB.TCISLI940601 CISLI940  
--       ON CISLI940.T$FIRE$L = TDREC941.T$DVRF$C
--      AND CISLI940.T$DOCN$L != 0
--      AND CISLI940.T$STAT$L IN (5,6)    --impresso-5, lanÃ§ado-6

--LEFT JOIN baandb.tznmcs095601  znmcs095
--        ON znmcs095.t$ncmp$c = 2     --Faturamento
--       AND znmcs095.t$fire$c = TDREC941.T$DVRF$C

WHERE
      tdrec940.t$stat$l IN (4,5,6)                --4-aprovado, 5-aprovado com problemas, 6-estornado
AND	  tdrec940.t$cnfe$l != ' '
AND 	TDREC940.T$RFDT$L = 10                      --10-retorno de mercadoria
AND   tdrec940.t$rfdt$l NOT IN (19,20,21,22,23)   --Conhecimento de Frete Aéreo-19, Ferroviário-20, Aquaviário-21, Rodoviário--22, Multimodal-23


UNION

SELECT
--***************************************************************************************************************************
--				VENDA TD - TROCA
--***************************************************************************************************************************
    TO_CHAR(znsls004.t$entr$c)                      TICKET,
		'NIKE.COM'												              FILIAL,
		''														                  TERMINAL,
    
    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
          '13'
    ELSE
        CASE WHEN CONT.NO_IDMP > 1 THEN
              '$$'
        ELSE
                  DECODE(SLS402_VENDA.T$IDMP$C,													                            --	LN										NIKE
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
                      15,	'  ')			END 					                                        --15	BNDES								' ' - Não existe                                             
    END                                             COD_FORMA_PGTO, 
		
		''														                  CAIXA_VENDEDOR,
    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTIN$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  --OK
          AT time zone 'America/Sao_Paulo') AS DATE)
    ELSE
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS402_VENDA.T$DTVB$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
    END                                             DATA,
		TO_CHAR(ZNSLS004.T$ENTR$C)										  NUMERO_CUPOM_FISCAL,
    CASE WHEN CISLI940.T$FDTY$L=15 THEN
          cisli940_FAT.t$fght$l * (-1)
    ELSE  cisli940.t$fght$l * (-1) END              DESCONTO_PGTO,
    CASE WHEN CISLI940.T$FDTY$L=15 THEN
          cisli940_FAT.t$amnt$l
    ELSE  cisli940.t$amnt$l END                     TOTAL_VENDA,
		''														                  CANCELADO_FISCAL,
    CASE WHEN NOTA_VENDA.T$FIRE$L != ' ' OR PED_VENDA.T$PECL$C IS NULL THEN    --NOTA VENDA FATURADA NO LN OU NOTA VENDA FATURADA NO SIGE
          1
    ELSE  SLS402_VENDA.T$NUPA$C	END			            PARCELA,
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
    'S'                                             TP_MOVTO,                  -- Criado para separar na tabela as entradas e saídas
    CASE WHEN CISLI940.T$FDTY$L=15 THEN
          CISLI940_FAT.T$FIRE$L
    ELSE  cisli940.t$fire$l END                     REF_FISCAL,
    CASE WHEN CISLI940.T$FDTY$L=15 THEN
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940_FAT.t$SADT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
          AT time zone 'America/Sao_Paulo') AS DATE)
    ELSE
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$SADT$L, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
          AT time zone 'America/Sao_Paulo') AS DATE)
    END                                             DT_ULT_ALTERACAO,
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
LEFT JOIN ( select  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c
            from    baandb.tznsls400601 a
            where   a.t$idpo$c = 'LJ' ) PED_VENDA
       ON   PED_VENDA.T$NCIA$C = ZNSLS004.T$NCIA$C
      AND   PED_VENDA.T$NCIA$C = ZNSLS004.T$UNEG$C
      AND   PED_VENDA.T$PECL$C = ZNSLS004.T$PECL$C
                   
LEFT JOIN ( select  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$orno$c
            from    baandb.tznsls401601 a
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$orno$c ) ENT_VENDA
       ON   ENT_VENDA.T$NCIA$C = PED_VENDA.T$NCIA$C
      AND   ENT_VENDA.T$NCIA$C = PED_VENDA.T$UNEG$C
      AND   ENT_VENDA.T$PECL$C = PED_VENDA.T$PECL$C
      AND   ENT_VENDA.T$SQPD$C = PED_VENDA.T$SQPD$C
                     
LEFT JOIN ( select  a.t$slso,
                    a.t$fire$l
            from    baandb.tcisli245601 a
            group by a.t$slso,
                     a.t$fire$l ) NOTA_VENDA
       ON NOTA_VENDA.T$SLSO = ENT_VENDA.T$ORNO$C
            
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
											
LEFT JOIN (SELECT	D.T$NCIA$C,
                    D.T$UNEG$C,
                    D.T$PECL$C,
                    D.T$SQPD$C,
                    D.T$IDMP$C,
					MIN(D.T$DTVB$C) T$DTVB$C,
					SUM(D.T$VLMR$C) T$VLMR$C,
					MAX(D.T$NUPA$C) T$NUPA$C
			FROM BAANDB.TZNSLS402601 D
			GROUP BY D.T$NCIA$C,
			         D.T$UNEG$C,
			         D.T$PECL$C,
			         D.T$SQPD$C,
			         D.T$IDMP$C) SLS402_VENDA	
      ON SLS402_VENDA.T$NCIA$C	=	ENT_VENDA.T$NCIA$C
     AND SLS402_VENDA.T$UNEG$C  =	ENT_VENDA.T$UNEG$C
     AND SLS402_VENDA.T$PECL$C  =	ENT_VENDA.T$PECL$C
     AND SLS402_VENDA.T$SQPD$C  =	ENT_VENDA.T$SQPD$C

LEFT JOIN (SELECT	D.T$NCIA$C,
                    D.T$UNEG$C,
                    D.T$PECL$C,
                    D.T$SQPD$C,
          COUNT(D.T$IDMP$C) NO_IDMP
			FROM BAANDB.TZNSLS402601 D
			GROUP BY D.T$NCIA$C,
			         D.T$UNEG$C,
			         D.T$PECL$C,
			         D.T$SQPD$C ) CONT	
       ON	CONT.T$NCIA$C	=	ENT_VENDA.T$NCIA$C
      AND CONT.T$UNEG$C =	ENT_VENDA.T$UNEG$C
      AND CONT.T$PECL$C =	ENT_VENDA.T$PECL$C
      AND CONT.T$SQPD$C =	ENT_VENDA.T$SQPD$C
                                  
INNER JOIN	BAANDB.TCISLI940601	CISLI940	ON	CISLI940.T$FIRE$L	=	CISLI245.T$FIRE$L

INNER JOIN (SELECT	E.T$FIRE$L,
                    E.T$REFR$L

			FROM	BAANDB.TCISLI941601 E

			GROUP BY  E.T$FIRE$L,
                E.T$REFR$L) CISLI941	ON	CISLI941.T$FIRE$L	=	CISLI940.T$FIRE$L
					 
LEFT JOIN	BAANDB.TCISLI940601	CISLI940_FAT ON	CISLI940_FAT.T$FIRE$L =	CISLI941.T$REFR$L
											AND	CISLI940_FAT.T$FDTY$L =	16
														

    WHERE cisli940.t$stat$l IN (2,5,6,101)      --cancelada, impressa, lançada, estornada
    AND   cisli940.t$cnfe$l != ' '
    AND   exists (select *
                  from  baandb.tznnfe011601 znnfe011
                  where znnfe011.t$oper$c = 1   --faturamento
                  and   znnfe011.t$fire$c = cisli940.t$fire$l
                  and   znnfe011.t$stfa$c = 5   --nota impressa
                  and   znnfe011.t$nfes$c = 5)  --nfe processada
   AND      cisli940.t$fdty$l NOT IN (2,14)     --2-venda sem pedido, 14-retorno mercadoria cliente
   AND      znsls400.t$idpo$c = 'TD'
