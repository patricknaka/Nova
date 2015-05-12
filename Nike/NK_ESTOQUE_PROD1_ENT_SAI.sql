SELECT

		CASE WHEN WHINH521.T$QVRR>0
			THEN WHINH521.T$ORNO || '1'
			ELSE WHINH521.T$ORNO || '2' END						ROMANEIO_PRODUTO,
		NVL(TCIBD004.T$AITC, TCIBD001.T$ITEM)					PRODUTO,
		'NIKE.COM'												FILIAL,
		'01'													COR_PRODUTO,
		WHINH521.T$QVRC											QTDE,
		TCIBD001.T$SIZE$C										TAMANHO,
		' '														CODIGO_BARRA,
		' '														ORDEM_PRODUCAO,
		' '														TAREFA,
		' '														SEGUNDA_QUALIDADE,
		' '														CUSTO1,
		' '														DATA_CUSTO,
		' '														VALOR,
		' '														DESCONTO_ITEM,
		' '														ITEM_IMPRESSAO,
		' '														MATA_SALDO_PEDIDO,
		' '														ITEM_IMPRESSAO_FATURA,
		' '														CUSTO_PRODUCAO,
		' '														CUSTO_INDIRETO,
		' '														IPI,
		' '														COMISSAO,
		' '														COMISSAO_GERENTE,
		' '														COD_REPRESENTANTE,
		' '														COD_REPRESENTANTE_GERENTE,
		' '														ID_MODIFICACAO,
		' '														PEDIDO_VENDA,
		' '														PEDIDO_VENDA_ENTREGA,
		' '														PEDIDO_VENDA_ITEM,
		' '														PACKS,
		' '														NF_SAIDA,
		' '														SERIE_NF

FROM
			BAANDB.TWHINH521301 WHINH521
INNER JOIN	BAANDB.TTCIBD001301 TCIBD001	ON	TCIBD001.T$ITEM		=	WHINH521.T$ITEM
LEFT JOIN	BAANDB.TTCIBD004301	TCIBD004	ON	TCIBD004.T$CITT		=	'000'
											AND	TCIBD004.T$BPID		=	' '
											AND	TCIBD004.T$ITEM		=	WHINH521.T$ITEM