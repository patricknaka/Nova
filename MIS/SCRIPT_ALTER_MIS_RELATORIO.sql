USE MIS_RELATORIO_
GO

ALTER TABLE fin.aux_ods_cap_reembolso
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

ALTER TABLE fin.ods_cap_reembolso
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)


------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[fin].[ods_cap_reembolso]') AND name = N'PK_id_titulo')
ALTER TABLE [fin].[ods_cap_reembolso] DROP CONSTRAINT [PK_id_titulo]
GO

ALTER TABLE fin.ODS_CAP_REEMBOLSO
ALTER COLUMN id_documento varchar(3) not null
GO

/****** Object:  Index [PK_id_titulo]    Script Date: 06/10/2014 14:09:00 ******/
ALTER TABLE [fin].[ods_cap_reembolso] ADD  CONSTRAINT [PK_id_titulo] PRIMARY KEY NONCLUSTERED 
(
	[id_titulo] ASC,
	[id_filial] ASC,
	[id_documento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

---------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE stg_sige_extranet_fornecedores_liquidado
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

---------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE stg_tb_planilhao
ALTER COLUMN EAN numeric(15)

ALTER TABLE stg_tb_planilhao
ADD ds_cor varchar(25)

ALTER TABLE stg_tb_planilhao
ADD ds_tamanho varchar(60)

alter table stg_sige_preco_tabela
alter column ITEM_NR_ITEM numeric(15)

alter table ods_tb_planilhao
alter column Ean numeric(15,0)

USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[stg_comp_ods_product]    Script Date: 08/04/2014 10:50:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stg_comp_ods_product]') AND type in (N'U'))
DROP TABLE [dbo].[stg_comp_ods_product]
GO

USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[stg_comp_ods_product]    Script Date: 08/04/2014 10:50:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_comp_ods_product](
	[ITEG_ID] [numeric](9, 0) NULL,
	[NPIT_ID_ITEM] [numeric](14, 0) NULL,
	[SUFA_NOME] [nvarchar](80) NULL,
	[SUFA_ID_SUB] [numeric](9, 0) NULL,
	[NBM_DESCRICAO] [nvarchar](30) NULL,
	[ITEG_OBSERVACAO] [nvarchar](1000) NULL,
	[ITEG_DT_INCLUSAO] [nvarchar](16) NULL,
	[ITEG_DATAHORA] [nvarchar](16) NULL,
	[ITEG_USUARIO] [nvarchar](30) NULL,
	[TAPF_DT_VALIDADE] [nvarchar](10) NULL,
	[NPIT_PZ_GARANTIA] [numeric](2, 0) NULL,
	[ITEG_TP_LOTE_SERIE] [nvarchar](3) NULL,
	[ITEG_IN_FABRIC_VALID] [nvarchar](10) NULL,
	[ITEG_PZ_VALIDADE] [numeric](6, 0) NULL,
	[ITEG_PZ_ALARME_VALID] [numeric](6, 0) NULL,
	[ITEG_PZ_MIN_RECEBTO] [numeric](6, 0) NULL,
	[ITEG_PZ_MIN_EXPED] [numeric](6, 0) NULL,
	[ITEG_ID_CONITE] [numeric](3, 0) NULL,
	[ITEG_FABRICANTE_MODELO] [nvarchar](50) NULL,
	[ID_EAN] [nvarchar](40) NULL,
	[CONI_NOME] [nvarchar](30) NULL,
	[ITTK_ID_ITEM_TIK] [numeric](9, 0) NULL,
	[ITTK_IN_INTERFACE] [nvarchar](1) NULL,
	[FILI_ID_FILIAL] [numeric](6, 0) NULL,
	[ITEM_DT_ULT_ALT] [datetime] NULL
) ON [PRIMARY]

GO


USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[ods_product_complemento]    Script Date: 08/04/2014 11:22:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ods_product_complemento]') AND type in (N'U'))
DROP TABLE [dbo].[ods_product_complemento]
GO

USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[ods_product_complemento]    Script Date: 08/04/2014 11:22:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ods_product_complemento](
	[nr_product_sku] [bigint] NOT NULL,
	[nr_item_sku] [bigint] NOT NULL,
	[ds_sufa_nome] [varchar](80) NULL,
	[nr_sufa] [int] NULL,
	[ds_nbm_desc] [varchar](50) NULL,
	[ds_observacao] [varchar](1000) NULL,
	[dt_inclusao_item] [datetime] NULL,
	[dt_datahora_item] [datetime] NULL,
	[ds_usuario] [varchar](50) NULL,
	[dt_validade] [varchar](50) NULL,
	[nr_pz_garantia] [int] NULL,
	[ds_tp_lote_serie] [varchar](50) NULL,
	[ds_in_fabric_valid] [varchar](50) NULL,
	[nr_pz_validade] [int] NULL,
	[nr_pz_alarme_valid] [int] NULL,
	[nr_pz_min_recebto] [int] NULL,
	[nr_pz_min_exped] [int] NULL,
	[nr_id_conite] [int] NULL,
	[ds_modelo_fabricante] [varchar](50) NULL,
	[nr_ean] [varchar](50) NULL,
	[ds_coni_nome] [varchar](50) NULL,
	[nr_id_item_tik] [bigint] NULL,
	[ds_in_interface] [char](1) NULL,
	[id_filial] [int] NULL,
	[dt_ult_alt] [datetime] NULL,
 CONSTRAINT [PK_ods_product_complemento] PRIMARY KEY CLUSTERED 
(
	[nr_product_sku] ASC,
	[nr_item_sku] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[aux_ods_product_compl]    Script Date: 08/04/2014 11:22:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aux_ods_product_compl]') AND type in (N'U'))
DROP TABLE [dbo].[aux_ods_product_compl]
GO

USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[aux_ods_product_compl]    Script Date: 08/04/2014 11:22:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[aux_ods_product_compl](
	[nr_product_sku] [bigint] NOT NULL,
	[nr_item_sku] [bigint] NOT NULL,
	[ds_sufa_nome] [varchar](80) NULL,
	[nr_sufa] [int] NULL,
	[ds_nbm_desc] [varchar](50) NULL,
	[ds_observacao] [varchar](1000) NULL,
	[dt_inclusao_item] [datetime] NULL,
	[dt_datahora_item] [datetime] NULL,
	[ds_usuario] [varchar](50) NULL,
	[dt_validade] [varchar](50) NULL,
	[nr_pz_garantia] [int] NULL,
	[ds_tp_lote_serie] [varchar](50) NULL,
	[ds_in_fabric_valid] [varchar](50) NULL,
	[nr_pz_validade] [int] NULL,
	[nr_pz_alarme_valid] [int] NULL,
	[nr_pz_min_recebto] [int] NULL,
	[nr_pz_min_exped] [int] NULL,
	[nr_id_conite] [int] NULL,
	[ds_modelo_fabricante] [varchar](50) NULL,
	[nr_ean] [varchar](50) NULL,
	[ds_coni_nome] [varchar](50) NULL,
	[nr_id_item_tik] [bigint] NULL,
	[ds_in_interface] [char](1) NULL,
	[id_filial] [int] NULL,
	[dt_ult_alt] [datetime] NULL,
 CONSTRAINT [PK_aux_product_complemento] PRIMARY KEY CLUSTERED 
(
	[nr_product_sku] ASC,
	[nr_item_sku] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


use MIS_RELATORIO
alter table dbo.stg_planilhao_ruptura
add vl_cmv_ponderado numeric(26,5), dt_purchase int