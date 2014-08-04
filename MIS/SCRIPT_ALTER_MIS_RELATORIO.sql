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