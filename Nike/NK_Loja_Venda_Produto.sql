
--***************************************************************************************************************************
--				VENDA
--***************************************************************************************************************************
SELECT
		ZNSLS004.T$PECL$C || ZNSLS004.T$SQPD$C					TICKET,	
		'NIKE.COM'												FILIAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 							DATA_VENDA,
		CISLI941.T$LINE$L										ITEM,
		' '														CODIGO_BARRA,
		CISLI941.T$DQUA$L										QTDE,
		CISLI941.T$PRIC$L										PRECO_LIQUIDO,
		CISLI941.T$TLDM$L										DESCONTO_ITEM,
		' '														ID_VENDEDOR,
		' '														TERMINAL,
		NVL(TCIBD004.T$AITC, TCIBD001.T$ITEM) 					PRODUTO,				-- Estamos usando a tabela de código alternativo de item mas ainda esperamos a resposta dos consultores para confirmar se será usado este conveito na Nike
		0														ITEM_EXCLUIDO,
		0														QTDE_BRINDE,
		0														NÃO_MOVIMENTA_ESTOQUE,
		' '														INDICA_ENTREGA_FUTURA,
		0														QTDE_CANCELADA,
		NVL(Q_IPI.T$AMNT$L,0)									IPI,
		NVL(Q_ICMS.T$RATE$L,0)									ALIQUOTA,
		NVL(CUSTO.MAUC,0)										CUSTO,
		'01'													COR_PRODUTO,
		TCIBD001.T$SIZE$C										TAMANHO
FROM
			BAANDB.TCISLI245301	CISLI245

INNER JOIN	BAANDB.TCISLI941301 CISLI941	ON	CISLI941.T$FIRE$L	=	CISLI245.T$FIRE$L
											AND	CISLI941.T$LINE$L	=	CISLI245.T$LINE$L
											
INNER JOIN	BAANDB.TCISLI940301 CISLI940	ON	CISLI940.T$FIRE$L	=	CISLI941.T$FIRE$L											

INNER JOIN	BAANDB.TZNSLS004301	ZNSLS004	ON	ZNSLS004.T$ORNO$C	=	CISLI245.T$SLSO
											AND	ZNSLS004.T$PONO$C	=	CISLI245.T$PONO

INNER JOIN	BAANDB.TZNSLS400301	ZNSLS400	ON	ZNSLS400.T$NCIA$C	=	ZNSLS004.T$NCIA$C
											AND ZNSLS400.T$UNEG$C   =	ZNSLS004.T$UNEG$C
                                            AND ZNSLS400.T$PECL$C   =	ZNSLS004.T$PECL$C
                                            AND ZNSLS400.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											
INNER JOIN	BAANDB.TZNSLS401301 ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS004.T$NCIA$C
                                            AND ZNSLS401.T$UNEG$C   =	ZNSLS004.T$UNEG$C
                                            AND ZNSLS401.T$PECL$C   =	ZNSLS004.T$PECL$C
                                            AND ZNSLS401.T$SQPD$C   =	ZNSLS004.T$SQPD$C
											AND ZNSLS401.T$ENTR$C   =	ZNSLS004.T$ENTR$C
											AND ZNSLS401.T$SEQU$C   =	ZNSLS004.T$SEQU$C
											
INNER JOIN	BAANDB.TTCIBD001301	TCIBD001	ON	TCIBD001.T$ITEM		=	CISLI941.T$ITEM$L

LEFT JOIN	BAANDB.TTCIBD004301	TCIBD004	ON	TCIBD004.T$CITT		=	'000'
											AND	TCIBD004.T$BPID		=	' '
											AND	TCIBD004.T$ITEM		=	TCIBD001.T$ITEM
											
 LEFT JOIN ( 	select 		whwmd217.t$item item,                             
							--whwmd217.t$cwar cwar,                                   
							case when sum(nvl(whwmd217.t$mauc$1,0)) = 0                             
							 then round(sum(whwmd217.t$ftpa$1*a.t$qhnd)/sum(a.t$qhnd), 4)                                           
							 else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
							 end mauc                                                
				from baandb.twhwmd217301 whwmd217                      
				left join baandb.twhinr140301 a                             
								on a.t$cwar = whwmd217.t$cwar                              
								and a.t$item = whwmd217.t$item                              
				group by 	whwmd217.t$item                                        
							--whwmd217.t$cwar 
											 ) custo           						-- Custo médio do item em todos os armazens                     
											--ON custo.cwar = TDSLS401.T$CWAR                         
											ON	custo.item 			= 	TCIBD001.T$ITEM

LEFT JOIN (	SELECT 	A.T$FIRE$L,
					A.T$LINE$L,
					A.T$AMNT$L,
					A.T$RATE$L
			FROM BAANDB.TCISLI943301 A
			WHERE	A.T$BRTY$L=3) Q_IPI		ON	Q_IPI.T$FIRE$L		=	CISLI941.T$FIRE$L
											AND	Q_IPI.T$LINE$L		=	CISLI941.T$LINE$L

LEFT JOIN (	SELECT 	A.T$FIRE$L,
					A.T$LINE$L,
					A.T$AMNT$L,
					A.T$RATE$L
			FROM BAANDB.TCISLI943301 A
			WHERE	A.T$BRTY$L=1) Q_ICMS	ON	Q_ICMS.T$FIRE$L		=	CISLI941.T$FIRE$L
											AND	Q_ICMS.T$LINE$L		=	CISLI941.T$LINE$L											

WHERE
			CISLI245.T$SLCP=301
		AND	CISLI245.T$ORTP=1
        AND	CISLI245.T$KOOR=3
		AND	CISLI940.T$STAT$L IN (5, 6)			-- IMPRESSO, LANÇADO
		AND	CISLI940.T$FDTY$L != 14
		
		


		

--***************************************************************************************************************************
--				INSTANCIA
--***************************************************************************************************************************
UNION
SELECT
		ZNSLS400.T$PECL$C || ZNSLS400.T$SQPD$C					TICKET,	
		'NIKE.COM'												FILIAL,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 							DATA_VENDA,
		ZNSLS401.T$SEQU$C										ITEM,
		' '														CODIGO_BARRA,
		ZNSLS401.T$QTVE$C										QTDE,
		ZNSLS401.T$VLUN$C										PRECO_LIQUIDO,
		ZNSLS401.T$VLDI$C										DESCONTO_ITEM,
		' '														ID_VENDEDOR,
		' '														TERMINAL,
		NVL(TCIBD004.T$AITC, TCIBD001.T$ITEM) 					PRODUTO,				-- Estamos usando a tabela de código alternativo de item mas ainda esperamos a resposta dos consultores para confirmar se será usado este conveito na Nike
		0														ITEM_EXCLUIDO,
		0														QTDE_BRINDE,
		0														NÃO_MOVIMENTA_ESTOQUE,
		' '														INDICA_ENTREGA_FUTURA,
		0														QTDE_CANCELADA,
		0														IPI,
		0														ALIQUOTA,
		NVL(CUSTO.MAUC,0)										CUSTO,
		'01'													COR_PRODUTO,
		TCIBD001.T$SIZE$C										TAMANHO
FROM

			BAANDB.TZNSLS400301	ZNSLS400	

INNER JOIN	BAANDB.TZNSLS401301 ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS400.T$NCIA$C
                                            AND ZNSLS401.T$UNEG$C   =	ZNSLS400.T$UNEG$C
                                            AND ZNSLS401.T$PECL$C   =	ZNSLS400.T$PECL$C
                                            AND ZNSLS401.T$SQPD$C   =	ZNSLS400.T$SQPD$C
											
INNER JOIN	BAANDB.TTDSLS400301 TDSLS400	ON	TDSLS400.T$ORNO		=	ZNSLS401.T$ORNO$C
											
INNER JOIN	BAANDB.TTCIBD001301	TCIBD001	ON	TCIBD001.T$ITEM		=	ZNSLS401.T$ITML$C

LEFT JOIN	BAANDB.TTCIBD004301	TCIBD004	ON	TCIBD004.T$CITT		=	'000'
											AND	TCIBD004.T$BPID		=	' '
											AND	TCIBD004.T$ITEM		=	TCIBD001.T$ITEM
											
 LEFT JOIN ( 	select 		whwmd217.t$item item,                             
							--whwmd217.t$cwar cwar,                                   
							case when sum(nvl(whwmd217.t$mauc$1,0)) = 0                             
							 then round(sum(whwmd217.t$ftpa$1*a.t$qhnd)/sum(a.t$qhnd), 4)                                           
							 else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
							 end mauc                                                
				from baandb.twhwmd217301 whwmd217                      
				left join baandb.twhinr140301 a                             
								on a.t$cwar = whwmd217.t$cwar                              
								and a.t$item = whwmd217.t$item                              
				group by 	whwmd217.t$item                                        
							--whwmd217.t$cwar 
											 ) custo           						-- Custo médio do item em todos os armazens                     
											--ON custo.cwar = TDSLS401.T$CWAR                         
											ON	custo.item 			= 	TCIBD001.T$ITEM

											

WHERE
			ZNSLS400.T$IDPO$C	=		'TD'
		AND	TDSLS400.T$HDST		=		35
		AND TDSLS400.T$FDTY$L 	NOT IN (0,14)
		