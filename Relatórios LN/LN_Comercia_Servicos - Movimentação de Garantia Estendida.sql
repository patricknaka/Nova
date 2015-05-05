SELECT 
		ZNCOM005.T$UNEG$C				UNEG,
		ZNSLS400.T$IDCA$C				ID_CANAL,
		TCMCS045.T$DSCA					DESCR_CANAL,
		ZNINT002.T$DESC$C				NOME,
		ZNSLS400.T$CVEN$C				VENDEDOR,			
		' '								NOME_VENDEDOR,			-- NÃO TEMOS O NOME NO LN, SÓ TEMOS O CÓDIGO QUE VEM DA INTERFACE DE PEDIDOS (COM O VALOR 100)
		ZNCOM005.T$CDVE$C				CERTIFICADO,
		TCIBD001_I.T$NRPE$C				PZ_GARANTIA_FABR,
						
		
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNCOM005.T$DATE$C, 'DD-MON-YYYY HH24:MI:SS'), 
		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)			
										INICIO_GAR_FABR,
		
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ADD_MONTHS(ZNCOM005.T$DATE$C, TCIBD001_I.T$NRPE$C), 'DD-MON-YYYY HH24:MI:SS'), 
		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)			
										FIN_GAR_FABR,
		
				
		TCIBD001_G.T$NRPE$C				PZ_GARATIA_EST,
		
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ADD_MONTHS(ZNCOM005.T$DATE$C, 
											TCIBD001_I.T$NRPE$C)+1, 'DD-MON-YYYY HH24:MI:SS'), 
          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)	
										INICIO_GAR_EST,
										
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ADD_MONTHS(ZNCOM005.T$DATE$C, 
										TCIBD001_I.T$NRPE$C
									+	TCIBD001_G.T$NRPE$C)+1, 'DD-MON-YYYY HH24:MI:SS'), 
		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)											
										FIN_GAR_EST,
                    
                    
		ZNCOM005.T$IGAR$C				ITEM_GARANTIDO,
		TCIBD001_I.T$DSCA				DESCRICAO,
		TCMCS023.T$CITG					ID_DEPARTAMENTO,
		TCMCS023.T$DSCA					DESCR_DEPARTAMENTO,
		TCIBD001_I.T$FAMI$C				ID_FAMILIA,
		ZNMCS031.T$DSCA$C				DESCR_FAMILIA,
		ZNSLS401.T$VLUN$C
		* ZNSLS401.T$QTVE$C				VL_PRODUTO,
		ZNCOM005.T$PRIS$C				VL_GARANTIA,
		NVL(CUSTO.VALOR,0)				CUSTO,
		ZNCOM005.T$PELI$C				PREMIO_LIQ,
		ZNCOM005.T$PIOF$C				IOF,
		ZNCOM005.T$PPIS$C				PIS,
		ZNCOM005.T$PCOF$C				COFINS,
		ZNCOM005.T$IRRF$C				IRRF,
		ZNCOM005.T$CCOR$C				VL_COMISSAO,
		ZNCOM005.T$CCOR$C
		- ZNCOM005.T$IRRF$C				MARGEM_CONTR,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATG$L, 'DD-MON-YYYY HH24:MI:SS'), 
		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)	
										DT_VENDA,
		CISLI940.T$DOCN$L				NUM_NOTA,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 
		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)			
										EMISSAO,
		ZNSLS400.T$ICLF$C				CPF_CLIENTE,
		ZNSLS400.T$NOMF$C				NOME_CLIENTE,
		ZNCOM005.T$PECL$C				NR_PEDIDO,
		ZNSLS400.T$DTEM$C				DT_PEDIDO,
		TGAR.DSC						TIPO_PLANO,
		ZNCOM005.T$ENGA$C				COD_PLANO_GAR
			
		
		
FROM (		SELECT 
					A.T$NCIA$C,
					A.T$UNEG$C,
					A.T$PECL$C,
					A.T$SQPD$C,
					A.T$ENTR$C,
					A.T$SEQU$C,
					A.T$CDVE$C,
					A.T$DATE$C,
					A.T$IGAR$C,
					A.T$ENGA$C,
					A.T$ORNO$C,
					A.T$PONO$C,
					A.T$SQNB$C,
					A.T$FIRE$C,
					SUM(A.T$PRIS$C) T$PRIS$C,
					SUM(A.T$PELI$C) T$PELI$C,
					SUM(A.T$PIOF$C) T$PIOF$C,
					SUM(A.T$PPIS$C) T$PPIS$C,
					SUM(A.T$PCOF$C) T$PCOF$C,
          SUM(A.T$IRRF$C) T$IRRF$C,
          SUM(A.T$CCOR$C) T$CCOR$C
			FROM	BAANDB.TZNCOM005201 A
			GROUP BY
					A.T$NCIA$C,
					A.T$UNEG$C,
					A.T$PECL$C,
					A.T$SQPD$C,
					A.T$ENTR$C,
					A.T$SEQU$C,
					A.T$CDVE$C,
					A.T$DATE$C,
					A.T$IGAR$C,
			        A.T$ENGA$C,
					A.T$ORNO$C,
					A.T$PONO$C,
					A.T$SQNB$C,
					A.T$FIRE$C) ZNCOM005
			
INNER JOIN	BAANDB.TZNINT002201 ZNINT002
		ON	ZNINT002.T$NCIA$C	=	ZNCOM005.T$NCIA$C
		AND	ZNINT002.T$UNEG$C	=	ZNCOM005.T$UNEG$C
		
INNER JOIN	BAANDB.TZNSLS400201 ZNSLS400
		ON	ZNSLS400.T$NCIA$C	=	ZNCOM005.T$NCIA$C
		AND ZNSLS400.T$UNEG$C	=	ZNCOM005.T$UNEG$C
		AND ZNSLS400.T$PECL$C	=	ZNCOM005.T$PECL$C
		AND ZNSLS400.T$SQPD$C	=	ZNCOM005.T$SQPD$C

INNER JOIN	BAANDB.TTCMCS045201 TCMCS045
		ON	TCMCS045.T$CREG		=	ZNSLS400.T$IDCA$C
		
INNER JOIN	BAANDB.TTCIBD001201 TCIBD001_I
		ON	TRIM(TCIBD001_I.T$ITEM)	=	TO_CHAR(ZNCOM005.T$IGAR$C)
		
INNER JOIN	BAANDB.TZNSLS401201 ZNSLS401
		ON	ZNSLS401.T$NCIA$C	=	ZNCOM005.T$NCIA$C
		AND ZNSLS401.T$UNEG$C   =	ZNCOM005.T$UNEG$C
		AND ZNSLS401.T$PECL$C   =	ZNCOM005.T$PECL$C
		AND ZNSLS401.T$SQPD$C   =	ZNCOM005.T$SQPD$C
		AND ZNSLS401.T$ENTR$C   =	ZNCOM005.T$ENTR$C
		AND ZNSLS401.T$SEQU$C   =	ZNCOM005.T$SEQU$C

INNER JOIN	BAANDB.TTCIBD001201 TCIBD001_G
		ON	TCIBD001_G.T$ITEM	=	ZNSLS401.T$ITML$C
		
INNER JOIN	BAANDB.TTCMCS023201	TCMCS023
		ON	TCMCS023.T$CITG		=	TCIBD001_I.T$CITG

INNER JOIN	BAANDB.TZNMCS031201	ZNMCS031
		ON	ZNMCS031.T$CITG$C	=	TCIBD001_I.T$CITG
		AND	ZNMCS031.T$SETO$C	=	TCIBD001_I.T$SETO$C
		AND	ZNMCS031.T$FAMI$C	=	TCIBD001_I.T$FAMI$C
		
LEFT JOIN (	SELECT	A.T$ORNO,
					A.T$PONO,
					A.T$SQNB,
					SUM(A.T$FCOP$1) VALOR
			FROM	BAANDB.TTDSLS415201 A
			WHERE 	A.T$CSTO=2
      GROUP BY  A.T$ORNO,
                A.T$PONO,
                A.T$SQNB)	CUSTO
		ON	CUSTO.T$ORNO		=	ZNCOM005.T$ORNO$C
		AND	CUSTO.T$PONO		=	ZNCOM005.T$PONO$C
		AND	CUSTO.T$SQNB		=	ZNCOM005.T$SQNB$C
		
LEFT JOIN	BAANDB.TCISLI940201	CISLI940
		ON	CISLI940.T$FIRE$L	=	ZNCOM005.T$FIRE$C

LEFT JOIN ( SELECT d.t$cnst CNST, 
                    l.t$desc DSC
               FROM baandb.tttadv401000 d, baandb.tttadv140000 l 
              WHERE d.t$cpac = 'zn' 
                AND d.t$cdom = 'ibd.tgar.c'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'zn'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac)) TGAR
        ON TGAR.CNST = TCIBD001_G.T$TGAR$C
        
