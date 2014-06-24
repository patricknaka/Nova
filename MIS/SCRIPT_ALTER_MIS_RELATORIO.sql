USE MIS_RELATORIO
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [INDEX]
GO

---------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE stg_sige_extranet_fornecedores_liquidado
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

---------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE stg_tb_planilhao
ALTER COLUMN EAN numeric(15)