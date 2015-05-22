SELECT
--*********************************************************************************************************************
--	LISTA TODOS OS PEDIDOS INTEGRADOS INCLUSIVE TROCAS E DEVOLUÇÕES IDEPENDDDENTE DO STATUS
--*********************************************************************************************************************
			to_char(ZNSLS401.T$ENTR$C)												PEDIDO,
			TO_CHAR(ZNSLS402.T$NUPA$C,'000')									COND_PGTO,
			DECODE(ZNSLS402.T$IDMP$C,																--	LN								
				1,	'CC',                                                           				--1	Cartão de Crédito				
				2,	'BOL',                                                           				--2	Boleto B2C (BV)					
				3,	'BOL',                                                           				--3	Boleto B2B Spot					
				4,	'VAL',                                                           				--4	Vale (VA)						
				5,	'DP',                                                           				--5	Debito/Transferência (BV)		
				8,	'BOL',                                                           				--8	Boleto à Prazo B2B (PZ)			
				9,	'BOL',                                                           				--9	Boleto a prazo Atacado (PZ)		
				10,	'BOL',                                                           				--10	Boleto à vista Atacado (BV)	
				11, 'DEP',                                                           				--11	Pagamento Complementar		
				12, 'CD',                                                           				--12	Cartão de Débito (DB)		
				13, 'DEP',                                                           				--13	Pagamento Antecipado		
				15,	'BNDS')														COD_FORMA_PGTO,     --15	BNDES						
			DECODE(ZNSLS402.T$CCCD$C,
				1,	'001',																			--	VISA
				2,	'002',																			--	MASTERCARD
				3,	'003',																			--	AMEX
				5,	'004',																			--	HIPERCARD
				TO_CHAR(ZNSLS402.T$CCCD$C))										BANDEIRA,			--	OUTROS CÓDIGOS PODE SER CONSULTADOS NA TABELA ZNCMG009
			ZNSLS402.T$BOPG$C													ID_PAGTO,
																
			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTAP$C, 
				'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
				AT time zone 'America/Sao_Paulo') AS DATE)						DT_APROV,
			ZNSLS402.T$VLMR$C													VL_PAGAMENTO
			
FROM
			BAANDB.TZNSLS402201	ZNSLS402
			
INNER JOIN (SELECT	C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
					MIN(C.T$ENTR$C) T$ENTR$C,
					MIN(C.T$DTAP$C) T$DTAP$C
			FROM	BAANDB.TZNSLS401201 C
			GROUP BY C.T$NCIA$C,
			         C.T$UNEG$C,
			         C.T$PECL$C,
			         C.T$SQPD$C) ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS402.T$NCIA$C
					                        AND ZNSLS401.T$UNEG$C   =	ZNSLS402.T$UNEG$C
					                        AND ZNSLS401.T$PECL$C   =	ZNSLS402.T$PECL$C
					                        AND ZNSLS401.T$SQPD$C   =	ZNSLS402.T$SQPD$C	