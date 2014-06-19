
-- Banco MIS_SHARED_DIMENSION
-------------------------------------------------------------------------------------------------------------------
--Alteração Data Type
--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_SHARED_DIMENSION.dim.ods_produto
ALTER COLUMN ds_ean NUMERIC(15)


--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_SHARED_DIMENSION.aux.aux_ods_produto_embalagem
ALTER COLUMN DS_EAN NUMERIC(15)


--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_SHARED_DIMENSION.aux.aux_ods_produto_sige
alter column ds_ean numeric(15)

--DE VARCHAR(40) PARA VARCHAR(60)
ALTER TABLE aux.aux_ods_produto_sige
ALTER COLUMN DS_PROCEDENCIA VARCHAR(60)

--DE VARCHAR(15) PARA VARCHAR(20)
ALTER TABLE aux.aux_ods_produto_sige
ALTER COLUMN DS_APELIDO VARCHAR(20)

-------------------------------------------------------------------------------------------------------------------

USE [MIS_SHARED_DIMENSION]
GO

CREATE TABLE [dim].[ods_parceiro_endereco](
	[nr_parceiro] [nvarchar](9) NULL,
	[nr_endereco] [nvarchar](9) NULL,
	[nr_cnpj_cpf] [nvarchar](20) NULL,
	[ds_endereco_principal] [nvarchar](30) NULL,
	[ds_bairro] [nvarchar](30) NULL,
	[nr_numero] [nvarchar](10) NULL,
	[ds_municipio] [nvarchar](8) NULL,
	[nr_cep] [nvarchar](10) NULL,
	[ds_complemento] [nvarchar](30) NULL,
	[nr_telefone_principal] [nvarchar](15) NULL,
	[nr_telefone_secundario] [nvarchar](15) NULL,
	[nr_fax] [nvarchar](15) NULL,
	[ds_matriz_filial] [nvarchar](10) NULL,
	[nr_status] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[dt_atualizacao] [datetime] NULL
) ON [PRIMARY]

GO


--------------------------------------------------------------------------------------------------------------------


USE [MIS_SHARED_DIMENSION]
GO


CREATE TABLE [dim].[ods_parceiro_cadastro](
	[nr_parceiro] [numeric](9,0) NULL,
	[nr_cnpj_cpf] [numeric](14) NULL,
	[ds_parceiro] [nvarchar](35) NULL,
	[ds_apelido] [nvarchar](16) NULL,
	[nr_tipo_cliente] [nvarchar](3) NULL,
	[ds_tipo_cadastro] [nvarchar](40) NULL,
	[dt_cadastro] [datetime] NULL,
	[dt_atualizacao] [datetime] NULL,
	[in_idoneo] [nvarchar](1) NULL,
	[ds_status] [int] NULL
) ON [PRIMARY]

GO


