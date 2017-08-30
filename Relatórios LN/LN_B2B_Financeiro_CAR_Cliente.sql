SELECT NM_CLIENTE_PEDIDO 
	  ,NR_CONTRATO
	  ,NR_CAMPANHA
      ,NR_CNPJ
      ,NR_CNPJ_FILIAL_EMISSORA
      ,NM_FILIAL_EMISSORA
      ,a.NR_NF
      ,a.NR_SERIE_NF
      ,DT_EMISSAO_TITULO
      ,NR_PEDIDO_CLIENTE
      ,PONTO_ORIGEM
      ,NR_CPF_CLIENTE
      ,DT_EMISSAO_PEDIDO
      ,NM_CLIENTE_ENTREGA
      ,NR_ENTIDADE_FISCAL_ENTREGA
      ,NM_CLIENTE
      ,CD_ITEM
      ,a.DS_ITEM
      ,VL_QTDE
      ,VL_UNITARIO
      ,VL_MERCADORIA
      ,VL_DESC_INCL_TOTAL
      ,VL_TOTAL_FRETE
      ,VL_TOTAL_ITEM
      ,VL_TOTAL
      ,CD_CHAVE_ACESSO
      ,NM_CAMPANHA
      ,NR_PEDIDO_PARCEIRO
      ,VL_BASE_ICMS
      ,a.VL_ICMS
      ,VL_BASE_RAT_ANT
      ,VL_ICMS_RAT_ANT
      ,VL_BASE_RAT
      ,VL_ICMS_RAT
      ,VL_ICMS_ST
      ,a.CD_TIPO_PEDIDO
      ,NM_TIPO_PEDIDO
      ,CD_PARCEIRO
      ,a.DT_ULT_ATUALIZACAO
      ,a.CD_CHAVE_PRIMARIA
      ,VL_BOLETO
      ,VL_CARTAO
      ,VL_TITULO
      ,CD_TRANSACAO_TITULO
      ,NR_DOCTO
      ,VL_SALDO
	  ,st.ds_status
	  ,p.ds_depto 
      FROM MIS_ODS.ln.ods_car_cliente_b2b a  
INNER JOIN MIS_ODS.ln.ods_pev_cab pc (nolock)
        ON pc.NR_ENTREGA = a.NR_ENTIDADE_FISCAL_ENTREGA
INNER JOIN MIS_ODS.loja.ods_status st (nolock)
		ON pc.CD_STATUS = st.ds_id_status
INNER JOIN MIS_SHARED_DIMENSION.DIM.dim_produto p
	   ON a.CD_ITEM = p.nr_item_sku		
    WHERE DT_EMISSAO_TITULO between @emissaode and @emissaoate
      AND ((NR_CNPJ like '%' + lTrim(rtrim((@CPNJ))) + '%') OR (@CPNJ is null))
      AND dt_status_pedido = (select max(pc.dt_status_pedido) from MIS_ODS.ln.ods_pev_cab pc  where pc.NR_ENTREGA = a.NR_ENTIDADE_FISCAL_ENTREGA)
group by NM_CLIENTE_PEDIDO 
	  ,NR_CONTRATO
	  ,NR_CAMPANHA
      ,NR_CNPJ
      ,NR_CNPJ_FILIAL_EMISSORA
      ,NM_FILIAL_EMISSORA
      ,a.NR_NF
      ,a.NR_SERIE_NF
      ,DT_EMISSAO_TITULO
      ,NR_PEDIDO_CLIENTE
      ,PONTO_ORIGEM
      ,NR_CPF_CLIENTE
      ,DT_EMISSAO_PEDIDO
      ,NM_CLIENTE_ENTREGA
      ,NR_ENTIDADE_FISCAL_ENTREGA
      ,NM_CLIENTE
      ,CD_ITEM
      ,a.DS_ITEM
      ,VL_QTDE
      ,VL_UNITARIO
      ,VL_MERCADORIA
      ,VL_DESC_INCL_TOTAL
      ,VL_TOTAL_FRETE
      ,VL_TOTAL_ITEM
      ,VL_TOTAL
      ,CD_CHAVE_ACESSO
      ,NM_CAMPANHA
      ,NR_PEDIDO_PARCEIRO
      ,VL_BASE_ICMS
      ,a.VL_ICMS
      ,VL_BASE_RAT_ANT
      ,VL_ICMS_RAT_ANT
      ,VL_BASE_RAT
      ,VL_ICMS_RAT
      ,VL_ICMS_ST
      ,a.CD_TIPO_PEDIDO
      ,NM_TIPO_PEDIDO
      ,CD_PARCEIRO
      ,a.DT_ULT_ATUALIZACAO
      ,a.CD_CHAVE_PRIMARIA
      ,VL_BOLETO
      ,VL_CARTAO
      ,VL_TITULO
      ,CD_TRANSACAO_TITULO
      ,NR_DOCTO
      ,VL_SALDO
	  ,st.ds_status
	  ,p.ds_depto 
