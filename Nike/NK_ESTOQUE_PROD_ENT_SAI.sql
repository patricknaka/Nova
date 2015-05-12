SELECT
		WHINH520.T$ORNO || '1'									ROMANEIO_PRODUTO,
		'NIKE.COM'												FILIAL,			
		' ' 													ORDEM_PRODUCAO,
		WHINH520.T$ODAT											EMISSAO,
		' '														RESPONSAVEL,
		' '														NOME_CLIFOR,
		' '														NF_ENTRADA,
		' '														FILIAL_DESTINO,
		' '														PEDIDO,
		' '														ROMANEIO_ORIGEM,
		' '														FILIAL_ORIGEM,
		TTTXT010.T$TEXT											OBS,
		' '														SEGUNDA_QUALIDADE,
		' '														ORDEM_SERVICO,
		' '														ACERTO_ENTRADA,
		' '														ENTREGA_PEDIDO,
		' '														SERIE_NF_ENTRADA,
		1														TIPO_ENTRADA,
		'AJUSTE POSITIVO ECOMMERCE'								TIPO_ROMANEIO,
		' '														COMENTARIO,
		' '														DATA_DIGITACAO,
		' '														NAO_VALIDAR_ENTRADA,
		' '														CAIXA,
		' '														RATEIO_CENTRO_CUSTO,
		'003'													CM_OPERACAO,
		' '														RATEIO_FILIAL,
		' '														CONTA_CONTABIL,
		' '														NF_ENTRADA_PROPRIA,
		' '														ROMANEIO_DESTINO,
		' '														FILIAL_DESTINO,
		' '														NF_FILIAL,
		' '														NF_SAIDA,
		' '														SERIE_NF,
		' '														CTB_LANCAMENTO
	
FROM
				BAANDB.TWHINH520301 WHINH520
		
	LEFT JOIN	BAANDB.TTTTXT010301 TTTXT010	ON	TTTXT010.T$CTXT	=	WHINH520.T$TXTA
												AND	TTTXT010.T$CLAN = 	'p'
												AND	TTTXT010.T$SEQE = 	1
	
	
WHERE
		(	SELECT COUNT(*)
			FROM BAANDB.TWHINH521301 A
			WHERE A.T$ORNO = WHINH520.T$ORNO
			AND A.T$QVRR>0) > 0
			
-------------------------------------------------------------------------------------------------------------------
UNION
SELECT
		WHINH520.T$ORNO || '2'									ROMANEIO_PRODUTO,
		'NIKE.COM'												FILIAL,			
		' ' 													ORDEM_PRODUCAO,
		WHINH520.T$ODAT											EMISSAO,
		' '														RESPONSAVEL,
		' '														NOME_CLIFOR,
		' '														NF_ENTRADA,
		' '														FILIAL_DESTINO,
		' '														PEDIDO,
		' '														ROMANEIO_ORIGEM,
		' '														FILIAL_ORIGEM,
		TTTXT010.T$TEXT											OBS,
		' '														SEGUNDA_QUALIDADE,
		' '														ORDEM_SERVICO,
		' '														ACERTO_ENTRADA,
		' '														ENTREGA_PEDIDO,
		' '														SERIE_NF_ENTRADA,
		2														TIPO_ENTRADA,
		'AJUSTE NEGATIVO ECOMMERCE'								TIPO_ROMANEIO,
		' '														COMENTARIO,
		' '														DATA_DIGITACAO,
		' '														NAO_VALIDAR_ENTRADA,
		' '														CAIXA,
		' '														RATEIO_CENTRO_CUSTO,
		'013'													CM_OPERACAO,
		' '														RATEIO_FILIAL,
		' '														CONTA_CONTABIL,
		' '														NF_ENTRADA_PROPRIA,
		' '														ROMANEIO_DESTINO,
		' '														FILIAL_DESTINO,
		' '														NF_FILIAL,
		' '														NF_SAIDA,
		' '														SERIE_NF,
		' '														CTB_LANCAMENTO
	
FROM
				BAANDB.TWHINH520301 WHINH520
		
	LEFT JOIN	BAANDB.TTTTXT010301 TTTXT010	ON	TTTXT010.T$CTXT	=	WHINH520.T$TXTA
												AND	TTTXT010.T$CLAN = 	'p'
												AND	TTTXT010.T$SEQE = 	1
	
	
WHERE
		(	SELECT COUNT(*)
			FROM BAANDB.TWHINH521301 A
			WHERE A.T$ORNO = WHINH520.T$ORNO
			AND A.T$QVRR<0) > 0