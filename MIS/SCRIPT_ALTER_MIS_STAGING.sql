--Banco MIS_STAGING
------------------------------------------------------------------------------------------------------------------------
--Script Altera��o Data Type

--DE VARCHAR(30) PARA VARCHAR(60)
ALTER TABLE MIS_STAGING.SIGE.STG_DEPT
ALTER COLUMN DS_DEPT VARCHAR(60)

--DE VARCHAR(1) PARA VARCHAR(3)
ALTER TABLE MIS_STAGING.SIGE.STG_PRODUCT
ALTER COLUMN DS_STATUS VARCHAR(3)

--DE VARCHAR(1) PARA VARCHAR(3)
ALTER TABLE MIS_STAGING.SIGE.STG_PRODUCT
ALTER COLUMN DS_ABC VARCHAR(3)

--NUMERIC(9) PARA BIGINT
ALTER TABLE MIS_STAGING.SIGE.STG_PRODUCT
ALTER COLUMN nr_product BIGINT

--NUMERIC(9) PARA BIGINT
ALTER TABLE MIS_STAGING.SIGE.STG_PRODUCT
ALTER COLUMN nr_item BIGINT


--de NUMERIC(2) PARA NUMERIC(4)
ALTER TABLE MIS_STAGING.SIGE.STG_CATEGORIA
ALTER COLUMN nr_cia NUMERIC(4)

-- de VARCHAR(1) PARA VARCHAR(3)
ALTER TABLE MIS_STAGING.SIGE.STG_ITEM
ALTER COLUMN DS_STATUS VARCHAR(3)

--de VARCHAR(15) para VARCHAR(20)
ALTER TABLE MIS_STAGING.SIGE.STG_ITEM
ALTER COLUMN DS_APELIDO VARCHAR(20)

--DE NUMERIC(2) PARA NUMERIC(3)
ALTER TABLE MIS_STAGING.SIGE.STG_ITEM
ALTER COLUMN NR_CIA NUMERIC(3)

--DE NUMERIC(9) PARA NUMERIC(15)
ALTER TABLE MIS_STAGING.SIGE.STG_ITEM
ALTER COLUMN NR_ID_ITEM NUMERIC(15)

--DE NUMERIC(13) PARA NUMERIC(15)
ALTER TABLE MIS_STAGING.SIGE.STG_ITEM
ALTER COLUMN DS_EAN NUMERIC(15)

--DE NUMERIC(10) PARA NUMERIC(15)
ALTER TABLE MIS_STAGING.SIGE.STG_ITEM
ALTER COLUMN NR_NBM NUMERIC(15)


--DE INT para NUMERIC(15)
ALTER TABLE MIS_STAGING.SIGE.STG_ITEM
ALTER COLUMN NR_SKU_ITEM_VINCULADO NUMERIC(15)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE MIS_STAGING.FIN.stg_sige_titulo_receber_movimento
ALTER COLUMN MOCO_ID_TRANSACAO NUMERIC(3)

--------------------------------------------------------------------
--DE NUMERIC(1) PARA NUMERIC(2)
ALTER TABLE MIS_STAGING.FIN.stg_sige_titulo_receber_movimento
ALTER COLUMN MOCO_SINAL NUMERIC(2)

--------------------------------------------------------------------
--DE NUMERIC(7) para NUMERIC(9)

ALTER TABLE MIS_STAGING.FIN.stg_sige_titulo_receber
ALTER COLUMN TITC_ID_CENTRO_CUSTO NUMERIC(9)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)

ALTER TABLE MIS_STAGING.fin.stg_sige_titulo_receber_movimento
ALTER COLUMN MOCO_ID_TRANSACAO numeric(3)


--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE MIS_STAGING.fin.stg_sige_titulo_pagamento
ALTER COLUMN TIPA_ID_TRANSACAO numeric(3)

--------------------------------------------------------------------
--DE varchar(30) para varchar(35)
ALTER TABLE MIS_STAGING.FIN.STG_SIGE_FORNECEDOR_CONTATO
ALTER COLUMN TCON_NOME VARCHAR(35)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE MIS_STAGING.FIN.aux_ods_sige_titulo_pagamento
ALTER COLUMN NR_ID_TRANSACAO NUMERIC(3)

------------------------------------------------------------------------------------------------------------------------
--Inclus�o de Atributo

--ADICIONAR COLUNA DE CODIGO CATEGORIA
ALTER TABLE MIS_STAGING.SIGE.STG_ITEM
ADD nr_categoria int

--INCLUS�O DO CAMPO YN MKTPLACE
--Tratamento direto na origem
ALTER TABLE MIS_STAGING.SIGE.STG_ITEM
ADD YN_MARKETPLACE BIT


--INCLUSAO DA COLUNA DE CODIGO DEPARTAMENTO LN
ALTER TABLE MIS_STAGING.SIGE.STG_DEPT
ADD nr_dept_ln VARCHAR(6)

--CRIAÇÃO DA TABELA TEMPORÁRIA para o Relatório Minha Casa Minha Vida
CREATE TABLE [dbo].[stg_rel_pedidos_minha_casa_amc](
	[IdCliente] [int] NULL,
	[Nome] [varchar](50) NULL,
	[IdCanalVenda] [varchar](20) NULL,
	[Data] [datetime] NULL,
	[IdCompra] [int] NULL,
	[_ValorTotalComDesconto] [money] NULL,
	[ped_externo] [varchar](50) NULL,
	[_nr_id_unidade_negocio] [int] NULL,
	[ds_unidade_negocio] [varchar](50) NULL,
	[CpfCnpj] [varchar](50) NULL,
	[DataStatus] [datetime] NULL
) ON [PRIMARY]
GO

------------------------------------------------------------------------------------------------------

--INCLUSÃO DE TABELAS SURROGATE KEY

CREATE TABLE ln.stg_companhia_ref (
  nr_id_companhia_sige INTEGER NULL,
  nr_id_companhia_ln INTEGER NULL
);

CREATE TABLE ln.stg_condicao_pagamento_ref (
  nr_id_condicao_pagamento INT NOT NULL IDENTITY,
  nr_id_companhia INT NULL,
  ds_id_condicao_pagamento VARCHAR(6) NULL,
  ds_condicao_pagamento VARCHAR(60) NULL,
  PRIMARY KEY(nr_id_condicao_pagamento)
);

CREATE TABLE ln.stg_departamento_ref (
  nr_id_departamento BIGINT NOT NULL IDENTITY,
  ds_id_departamento VARCHAR(6) NULL,
  ds_departamento VARCHAR(60) NULL,
  PRIMARY KEY(nr_id_departamento)
);

CREATE TABLE ln.stg_deposito_estoque_ref (
  nr_id_deposito BIGINT NOT NULL IDENTITY,
  nr_id_companhia INT NULL,
  ds_id_filial VARCHAR(12) NULL,
  ds_id_deposito VARCHAR(255) NULL,
  PRIMARY KEY(nr_id_deposito)
);

CREATE TABLE ln.stg_nota_recebimento_ref (
  nr_id_nota_recebimento BIGINT NOT NULL IDENTITY,
  nr_id_compania INTEGER NULL,
  ds_id_filial VARCHAR(12) NULL,
  ds_id_nota_recebimento VARCHAR(18) NULL,
  PRIMARY KEY(nr_id_nota_recebimento)
);

CREATE TABLE ln.stg_pedido_compra_cabecalho_ref (
  nr_id_pedido_compra BIGINT NOT NULL IDENTITY,
  nr_id_cia INT NULL,
  ds_id_filial VARCHAR(12) NULL,
  ds_num_ped_compra VARCHAR(18) NULL,
  PRIMARY KEY(nr_id_pedido_compra)
);

CREATE TABLE ln.stg_titulo_cap_ref (
  nr_id_titulo BIGINT NOT NULL IDENTITY,
  ds_id_titulo VARCHAR(50) NULL,
  ds_tipo_transacao VARCHAR(10) NULL,
  PRIMARY KEY(nr_id_titulo)
);

CREATE TABLE ln.stg_titulo_car_ref (
  nr_id_titulo BIGINT NOT NULL IDENTITY,
  ds_id_titulo VARCHAR(50) NULL,
  ds_tipo_transacao VARCHAR(10) NULL,
  PRIMARY KEY(nr_id_titulo)
);

------------------------------------------------------------------------------------------------------
--de numeric(7) para numeric(10)
ALTER TABLE fin.stg_sige_centro_custo
ALTER COLUMN CCUS_ID_CENTROCUSTOS numeric(10)

--de numeric(2) para numeric(3)
ALTER TABLE FIN.stg_sige_titulo_receber_movimento
ALTER COLUMN MOCO_ID_CIA numeric(3)

--de numeric(3) para varchar(3)
ALTER TABLE FIN.stg_sige_titulo_receber_movimento
ALTER COLUMN MOCO_ID_TRANSACAO varchar(3)

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE FIN.stg_sige_titulo_receber
ALTER COLUMN TITC_ID_MODULO VARCHAR(3)

--DE NUMERIC(2) PARA NUMERIC(3)
ALTER TABLE FIN.stg_sige_titulo_receber
ALTER COLUMN TITC_ID_CIA NUMERIC(3)

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE FIN.stg_sige_titulo_receber
ALTER COLUMN TITC_ID_CARTEIRA VARCHAR(3)

--DE NUMERIC(2) PARA NUMERIC(3)
ALTER TABLE FIN.stg_sige_titulo_complemento_nf
ALTER COLUMN NFCA_ID_CIA NUMERIC(3)

--DE NUMERIC(2) PARA NUMERIC(3)
ALTER TABLE FIN.stg_sige_contas_receber_campanha
ALTER COLUMN PEDC_ID_CIA NUMERIC(3)

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE fin.aux_ods_sige_titulo_receber
ALTER COLUMN DS_ID_MODULO VARCHAR(3)

--DE NUMERIC(2) PARA NUMERIC(3)
ALTER TABLE FIN.aux_ods_sige_titulo_receber_complemento
ALTER COLUMN NR_ID_CIA NUMERIC(3)


alter table sige.stg_item
ADD nr_id_filial_venda numeric(3)

alter table sige.stg_item
ADD nr_dt_cadastro numeric(8)

alter table sige.stg_item
add ds_modelo_fabricante varchar(60)

alter table sige.stg_item
add ds_kit_wms varchar(20)



USE [MIS_STAGING]
GO

/****** Object:  Table [com].[stg_cliente_venda_vendedor_samsung]    Script Date: 07/07/2014 14:38:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[com].[stg_cliente_venda_vendedor_samsung]') AND type in (N'U'))
DROP TABLE [com].[stg_cliente_venda_vendedor_samsung]
GO

USE [MIS_STAGING]
GO

/****** Object:  Table [com].[stg_cliente_venda_vendedor_samsung]    Script Date: 07/07/2014 14:38:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [com].[stg_cliente_venda_vendedor_samsung](
	[VENR_CPF] [numeric](11, 0) NULL,
	[VENR_NOME] [nvarchar](40) NULL,
	[FILI_CGC] [numeric](14, 0) NULL,
	[VENDEDOR] [nvarchar](8) NULL,
	[NFCA_ID_PED] [numeric](12, 0) NULL,
	[ITEG_EAN] [numeric](13, 0) NULL,
	[NFCA_DT_EMISSAO] [datetime] NULL,
	[VENR_MATRICULA] [nvarchar](30) NULL,
	[CLIE_ID_TERCEIRO] [numeric](14, 0) NULL,
	[TIPO_FATURAMENTO] [nvarchar](2) NULL,
	[NFDE_QT_VOLUMES] [numeric](18, 9) NULL,
	[NFDE_PR_UNIT] [numeric](16, 3) NULL,
	[NFDE_VL_TOTAL_ITEM] [numeric](15, 2) NULL,
	[VALOR_LIQUIDO] [numeric](15, 2) NULL,
	[NFDE_PERC_ICMS] [numeric](5, 2) NULL,
	[NFCA_SITUACAO] [nvarchar](1) NULL,
	[ITEG_COD_FORNEC] [nvarchar](50) NULL,
	[VENDA] [nvarchar](5) NULL,
	[CLIE_TEL] [nvarchar](15) NULL,
	[CLEN_CEP] [numeric](8, 0) NULL,
	[MUNI_ID_ESTADO] [nvarchar](2) NULL,
	[MUNI_NOME] [nvarchar](60) NULL,
	[CLEN_END] [nvarchar](80) NULL,
	[CLIE_NOME] [nvarchar](40) NULL,
	[CLIE_EMAIL] [nvarchar](45) NULL,
	[CLASSIFICACAO_VENDA] [nvarchar](1) NULL,
	[CLIENTE] [nvarchar](7) NULL
) ON [PRIMARY]

GO

USE [MIS_STAGING]
GO

/****** Object:  Table [com].[stg_estoque_samsung]    Script Date: 07/07/2014 14:39:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[com].[stg_estoque_samsung]') AND type in (N'U'))
DROP TABLE [com].[stg_estoque_samsung]
GO

USE [MIS_STAGING]
GO

/****** Object:  Table [com].[stg_estoque_samsung]    Script Date: 07/07/2014 14:39:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [com].[stg_estoque_samsung](
	[ITEG_EAN] [numeric](13, 0) NULL,
	[DATASELECT] [datetime] NULL,
	[FILI_CGC] [numeric](14, 0) NULL,
	[QT_FISICA] [numeric](38, 4) NULL,
	[TIPO_ESTOQUE] [nvarchar](2) NULL,
	[ITEG_COD_FORNEC] [nvarchar](50) NULL
) ON [PRIMARY]

GO


--------------------------------
alter table fin.stg_sige_titulo_receber_movimento
alter column MOCO_ID_MODULO varchar(3)

----------------------------------------

ALTER TABLE fin.stg_sige_titulo_receber_movimento
add MOCO_SQ_MOVIMENTO int null

---------------------------------------

alter table fin.aux_contas_receber_transacao
alter column ds_id_documento varchar(3)

alter table fin.aux_contas_receber_transacao
alter column ds_id_modulo varchar(3)


USE [MIS_STAGING]
GO

/****** Object:  Table [com].[stg_relatorio_vpc]    Script Date: 08/21/2014 17:49:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [com].[stg_relatorio_vpc](
	[COMPRADOR] [varchar](255) NULL,
	[DT_EMISSAO] [datetime] NULL,
	[TP_CONTRATO] [varchar](50) NULL,
	[ID_CONTRATO] [int] NULL,
	[CNPJ] [varchar](100) NULL,
	[RAZAO_SOCIAL] [varchar](255) NULL,
	[VALOR_CONTRATO] [numeric](20, 2) NULL,
	[ID_DEPTO] [varchar](10) NULL,
	[NOME_DEPTO] [varchar](100) NULL,
	[TITULO] [text] NULL,
	[VEICULO] [varchar](100) NULL,
	[COMPETENCIA] [int] NULL,
	[ASSINADO] [varchar](3) NULL,
	[DT_ASSINATURA] [datetime] NULL,
	[ASSINATURA_FORNEC] [text] NULL,
	[ASSINATURA_CIA] [datetime] NULL,
	[TIPO_PAGAMENTO] [varchar](100) NULL,
	[ID_MODALIDADE] [varchar](4) NULL,
	[DESC_MODALIDADE] [varchar](100) NULL,
	[INICIO_VIGENCIA] [datetime] NULL,
	[DT_VENCIMENTO] [datetime] NULL,
	[DT_CONTRATO] [datetime] NULL,
	[DT_ALTERACAO] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--===========================================================

USE [MIS_STAGING]
GO
/****** Object:  StoredProcedure [loja].[sp_ultimo_id_compra_boleto_prazo]    Script Date: 10/07/2014 14:38:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [loja].[sp_ultimo_id_compra_boleto_prazo] as
 
select
 MAX(nr_id_compra) nr_id_compra
from
 mis_ods.loja.ods_compra_boleto_prazo


--===========================================================
