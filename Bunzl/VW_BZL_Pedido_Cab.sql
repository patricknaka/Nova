SELECT
--*********************************************************************************************************************
--	LISTA TODOS OS PEDIDOS INTEGRADOS INCLUSIVE TROCAS E DEVOLUÇÕES IDEPENDDDENTE DO STATUS
--*********************************************************************************************************************
		to_char(ZNSLS401.T$ENTR$C)								PEDIDO_WEB,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS400.T$DTEM$C, 
			'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE)												
                                              DT_EMISSAO_PED,
		to_char(ZNSLS400.T$ICLF$C)								CNPJ_CLIENTE,
		ZNSLS401.T$LOGE$C													LOGRADOURO_ENTR,
		ZNSLS401.T$NUME$C													NUM_LOGRAD_ENTR,
		ZNSLS401.T$COME$C													COMPLEM_LOGRAD_ENTR,
		ZNSLS401.T$BAIE$C													BAIRRO_LOGRAD_ENTR,
		ZNSLS401.T$CIDE$C													CIDADE_LOGRAD,
		ZNSLS401.T$UFEN$C													ESTADO_LOGRAD,
		to_char(ZNSLS401.T$CEPE$C)								CEP_LOGRAD,
		ZNSLS400.T$VLFR$C													VL_FRETE,

		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C, 
			'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE)						DT_ENTR_PROMETIDA,

		to_char(ZNSLS401.T$IDTR$C)								CNPJ_TRANSP,		-- CNPJ DA TRANSPORTADORA QUE FOI CARRGADO PELO FRONT NA INTEGRAÇÃO DO PEDIDO
		'01'																      TIPO_OPERACAO,
		to_char(ZNSLS400.T$PEEX$C)								PEDIDO_CLIENTE

FROM

			BAANDB.TZNSLS400201	ZNSLS400
			
INNER JOIN (SELECT	C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
                    C.T$ENTR$C,
					C.T$LOGE$C,
					C.T$NUME$C,
					C.T$COME$C,
					C.T$BAIE$C,
					C.T$CIDE$C,
					C.T$UFEN$C,
					C.T$CEPE$C,
					C.T$DTEP$C,
					C.T$IDTR$C
			FROM	BAANDB.TZNSLS401201 C
			GROUP BY C.T$NCIA$C,
			         C.T$UNEG$C,
			         C.T$PECL$C,
			         C.T$SQPD$C,
			         C.T$ENTR$C,
					 C.T$LOGE$C,
					 C.T$NUME$C,
					 C.T$COME$C,
					 C.T$BAIE$C,
					 C.T$CIDE$C,
					 C.T$UFEN$C,
					 C.T$CEPE$C,
					 C.T$DTEP$C,
					 C.T$IDTR$C) ZNSLS401	ON	ZNSLS401.T$NCIA$C	=	ZNSLS400.T$NCIA$C
					                        AND ZNSLS401.T$UNEG$C   =	ZNSLS400.T$UNEG$C
					                        AND ZNSLS401.T$PECL$C   =	ZNSLS400.T$PECL$C
					                        AND ZNSLS401.T$SQPD$C   =	ZNSLS400.T$SQPD$C	