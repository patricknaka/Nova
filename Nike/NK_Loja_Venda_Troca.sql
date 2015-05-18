--***************************************************************************************************************************
--				COLETA
--***************************************************************************************************************************

SELECT
		TDREC940.T$DOCN$L || TDREC940.T$SERI$L					TICKET,	
		'NIKE.COM'												FILIAL,
		TDREC941.T$LINE$L										ITEM,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') --#FAF.004.sn
		AT time zone 'America/Sao_Paulo') AS DATE) 				DATA_VENDA,
		' '														CODIGO_BARRA,
		ltrim(rtrim(NVL(TCIBD004.T$AITC, TCIBD001.T$ITEM)))			PRODUTO,				-- Estamos usando a tabela de código alternativo de item mas ainda esperamos a resposta dos consultores para confirmar se será usado este conveito na Nike
		'01'													COR_PRODUTO,
		TCIBD001.T$SIZE$C										TAMANHO,
		TDREC941.T$QNTY$L										QTDE,		
		TDREC941.T$PRIC$L										PRECO_LIQUIDO,
		TDREC941.T$ADDC$L										DESCONTO_ITEM,
		0														QTDE_CANCELADA,
		NVL(CUSTO.MAUC,0)										CUSTO,
		NVL(Q_IPI.T$AMNT$L,0)									IPI,		
		' '														ID_VENDEDOR,
		0														ITEM_EXCLUIDO,
		0														NÃO_MOVIMENTA_ESTOQUE,		
		' '														INDICA_ENTREGA_FUTURA

FROM
			BAANDB.TTDREC947301	TDREC947

INNER JOIN	BAANDB.TTDREC941301 TDREC941	ON	TDREC941.T$FIRE$L	=	TDREC947.T$FIRE$L
											AND	TDREC941.T$LINE$L	=	TDREC947.T$LINE$L
											
INNER JOIN	BAANDB.TTDREC940301 TDREC940	ON	TDREC940.T$FIRE$L	=	TDREC941.T$FIRE$L											

INNER JOIN	BAANDB.TZNSLS004301	ZNSLS004	ON	ZNSLS004.T$ORNO$C	=	TDREC947.T$ORNO$L
											AND	ZNSLS004.T$PONO$C	=	TDREC947.T$PONO$L

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
											
INNER JOIN	BAANDB.TTCIBD001301	TCIBD001	ON	TCIBD001.T$ITEM		=	TDREC941.T$ITEM$L

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
			FROM BAANDB.TTDREC942301 A
			WHERE	A.T$BRTY$L=3) Q_IPI		ON	Q_IPI.T$FIRE$L		=	TDREC941.T$FIRE$L
											AND	Q_IPI.T$LINE$L		=	TDREC941.T$LINE$L

-- LEFT JOIN (	SELECT 	A.T$FIRE$L,
					-- A.T$LINE$L,
					-- A.T$AMNT$L,
					-- A.T$RATE$L
			-- FROM BAANDB.TTDREC942301 A
			-- WHERE	A.T$BRTY$L=1) Q_ICMS	ON	Q_ICMS.T$FIRE$L		=	TDREC941.T$FIRE$L
											-- AND	Q_ICMS.T$LINE$L		=	TDREC941.T$LINE$L											

WHERE
			TDREC947.T$NCMP$L=301
		AND	TDREC947.T$OORG$L=1
        AND	TDREC940.T$STAT$L IN (4, 5)
		AND	TDREC940.T$RFDT$L = 10
		
		