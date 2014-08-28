
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
	[ds_municipio] [bigint] NULL,
	[nr_cep] [nvarchar](10) NULL,
	[ds_complemento] [nvarchar](30) NULL,
	[nr_telefone_principal] [nvarchar](15) NULL,
	[nr_telefone_secundario] [nvarchar](15) NULL,
	[nr_fax] [nvarchar](15) NULL,
	[ds_matriz_filial] [nvarchar](10) NULL,
	[nr_status] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[dt_atualizacao] [datetime] NULL,
	[nr_condicao_pagamento] [numeric] (3,0) NULL
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
--------------------------------------------------------------------------------------------------------------------

CREATE TABLE dim.ods_produto_preco_compra
(
nr_product_sku bigint,
vl_preco_compra numeric(18,2),
 CONSTRAINT [PK_dim_produto_preco_compra] PRIMARY KEY CLUSTERED 
(
	[nr_product_sku] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


--------------------------------------------------------------------------------------------------------------------

ALTER TABLE dim.ods_parceiro_endereco
add ds_email varchar(100)

--------------------------------------------------------------------------------------------------------------------


CREATE NONCLUSTERED INDEX IDX_1 ON dim.ods_produto
(
nr_id_product_type ASC
)INCLUDE(nr_item_sku,nr_product_sku

--------------------------------------------------------------------------------------------------------------------


CREATE TABLE [dim].[ods_municipio](
	[nr_municipio] [bigint] NOT NULL,
	[ds_municipio] [varchar](30) NULL,
	[nr_pais] [varchar](30) NULL,
	[ds_pais] [varchar](30) NULL,
	[nr_estado] [varchar](2) NULL,
	[ds_estado] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[nr_municipio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

--------------------------------------------------------------------------------------------------------------------
CREATE TABLE dim.ods_tipo_ordem_compra
(
nr_tipo_ordem varchar(4) not null primary key,
ds_tipo_ordem varchar(40)
)
--------------------------------------------------------------------------------------------------------------------
create table dim.ods_tipo_entrega
(
nr_tipo_entrega int not null primary key,
ds_tipo_entrega varchar(50)
)
----------------------------------------------
ALTER TABLE dim.ods_produto
ALTER COLUMN ds_apelido VARCHAR(20)

ALTER TABLE DIM.DIM_PRODUTO
ALTER COLUMN DS_APELIDO VARCHAR(20)


alter table aux_produto_dw
alter column ds_procedencia varchar(60)

alter table ods_product
alter column ds_procedencia varchar(60)
