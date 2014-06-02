USE MIS_DW
GO


---ALTERAÇÕES NA BASE DE DADOS MIS_DW/MIS_DW

---------------------------------------------------------------------------------------------------------------------------------------------
--ALTERAÇÕES DE DATA TYPE

--DE NUMERIC(2) PARA INT
ALTER TABLE MIS_DW.DBO.STG_DESPESA
ALTER COLUMN ID_CIA INT

--DE NUMERIC(2) PARA INT
ALTER TABLE MIS_DW.DBO.STG_DESPESA_LANCAMENTO
ALTER COLUMN LANC_ID_CIA INT

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE MIS_DW.DBO.STG_DESPESA
ALTER COLUMN ID_CONTA NUMERIC(24)

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE MIS_DW.DBO.STG_DESPESA_LANCAMENTO
ALTER COLUMN LANC_ID_CONTA NUMERIC(24)

--DE NUMERIC(2) PARA INT
ALTER TABLE MIS_DW.DBO.STG_SIGE_PURCHASE_FULL
ALTER COLUMN NR_CIA INT

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE MIS_DW.DBO.STG_DESPESA_CONTAS
ALTER COLUMN CONT_ID_CONTA NUMERIC(24)

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE MIS_DW.DBO.STG_DESPESA_CONTAS
ALTER COLUMN CONT_ID_CONTAPAI NUMERIC(24)


--DE NUMERIC(2) para NUMERIC(4)
ALTER TABLE MIS_DW.DBO.stg_estoque_sige
ALTER COLUMN ID_CIA NUMERIC(4)

--DE VARCHAR(30) PARA VARCHAR(35)
ALTER TABLE MIS_DW.DBO.stg_estoque_sige
ALTER COLUMN DS_MODALIDADE VARCHAR(35)

--DE VARCHAR(30) PARA VARCHAR(40)
ALTER TABLE MIS_DW.DBO.STG_ESTOQUE_SIGE_MODALIDADE
ALTER COLUMN DS_MODALIDADE VARCHAR(40)

--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_DW.dbo.ods_product
alter column ds_ean numeric(15)

--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_DW.dbo.dim_product
alter column ds_ean numeric(15)


--DE VARCHAR(30) para VARCHAR(40)
ALTER TABLE MIS_DW.dbo.ods_estoque_modalidade
ALTER COLUMN ds_modalidade VARCHAR(40)

--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_DW.dbo.aux_produto_dw
alter column ds_ean numeric(15)
----------------------------------------------------------------------------------------------------------------

--ALTERAÇÃO ATRIBUTO ID_CONTA TABELA ODS_DESPESA_CONTAS

--DROP OBJETO DEPENDENCIA
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ods_despesa_ods_despesa_contas]') AND parent_object_id = OBJECT_ID(N'[dbo].[ods_despesa]'))
ALTER TABLE [dbo].[ods_despesa] DROP CONSTRAINT [FK_ods_despesa_ods_despesa_contas]
GO

--DROP OBJETO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_despesa_contas]') AND name = N'PK_ods_despesa_contas')
ALTER TABLE [dbo].[ods_despesa_contas] DROP CONSTRAINT [PK_ods_despesa_contas]
GO

--EFETIVA ALTERAÇÃO
--DE NUMERIC(7) para NUMERIC(9) --ESTA ALTERAÇÃO DEVERÁ FALHAR DEVIDO A USO DE CONSTRAINT
ALTER TABLE MIS_DW.DBO.ODS_DESPESA_CONTAS
ALTER COLUMN ID_CONTA NUMERIC(9) NOT NULL


--RECRIA OBJETO
ALTER TABLE [dbo].[ods_despesa_contas] ADD  CONSTRAINT [PK_ods_despesa_contas] PRIMARY KEY CLUSTERED 
(
	[id_conta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

--ALTERA OBJETO REFERENCIA
ALTER TABLE [dbo].[ods_despesa]
ALTER COLUMN ID_CONTA numeric(9)

--RECRIA OBJETO DEPENDENCIA
ALTER TABLE [dbo].[ods_despesa]  WITH CHECK ADD  CONSTRAINT [FK_ods_despesa_ods_despesa_contas] FOREIGN KEY([id_conta])
REFERENCES [dbo].[ods_despesa_contas] ([id_conta])
GO

ALTER TABLE [dbo].[ods_despesa] CHECK CONSTRAINT [FK_ods_despesa_ods_despesa_contas]
GO

----------------------------------------------------------------------------------------------------------------


ALTER TABLE MIS_DW.DBO.ODS_DESPESA
ALTER COLUMN ID_CONTA NUMERIC(9)


--DE NUMERIC (2) para NUMERIC(3)
ALTER TABLE MIS_DW.dbo.ODS_DESPESA
ALTER COLUMN id_cia NUMERIC(3)


--DE NUMERIC (2) para NUMERIC(3)
ALTER TABLE MIS_DW.dbo.AUX_ODS_DESPESA_LANCAMENTO
ALTER COLUMN id_cia NUMERIC(3)
----------------------------------------------------------------------------------------------------------------------------

--APAGA INDICES
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_despesa_lancamento]') AND name = N'idx_v1')
DROP INDEX [idx_v1] ON [dbo].[ods_despesa_lancamento] WITH ( ONLINE = OFF )

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_despesa_lancamento]') AND name = N'idx_v2')
DROP INDEX [idx_v2] ON [dbo].[ods_despesa_lancamento] WITH ( ONLINE = OFF )

--DE NUMERIC (2) para NUMERIC(3) --PROBLEMAS COM INDICE NA TABELA
ALTER TABLE MIS_DW.dbo.ODS_DESPESA_LANCAMENTO
ALTER COLUMN id_cia NUMERIC(3)

--RECRIA INDICES
CREATE NONCLUSTERED INDEX [idx_v1] ON [dbo].[ods_despesa_lancamento] 
(
	[id_cia] ASC,
	[dt_lancamento] ASC,
	[id_natlanc] ASC,
	[num_lote] ASC,
	[seq_lote] ASC
)
INCLUDE ( [ds_in_dc],
[ds_lancamento],
[vl_lancamento],
[id_conta],
[id_custo],
[id_filial]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_v2] ON [dbo].[ods_despesa_lancamento] 
(
	[id_cia] ASC,
	[id_filial] ASC,
	[dt_lancamento] ASC,
	[id_conta] ASC,
	[id_custo] ASC
)
INCLUDE ( [vl_lancamento],
[ds_in_dc],
[ds_lancamento]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

----------------------------------------------------------------------------------------------------------------------------

--DE NUMERIC(7) para NUMERIC(9)
ALTER TABLE MIS_DW.dbo.aux_ods_despesa_contas
ALTER COLUMN id_conta NUMERIC(9)



--DE NUMERIC(7) PARA NUMERIC(9) --PROBLEMA NO ALTER DEVIDO A DEPENDENCIA DE INDICE
ALTER TABLE MIS_DW.dbo.ods_despesa_lancamento
ALTER COLUMN ID_CONTA NUMERIC(9)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE MIS_DW.dbo.stg_sige_titulo_movimento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE MIS_DW.DBO.stg_sige_titulo
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE MIS_DW.DBO.stg_sige_titulo
ALTER COLUMN ID_CIA NUMERIC(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE MIS_DW.DBO.stg_sige_titulo_documento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)

ALTER TABLE MIS_DW.DBO.stg_sige_titulo_transacao
ALTER COLUMN ID_MODULO VARCHAR(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE MIS_DW.DBO.ods_sige_titulo_documento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE MIS_DW.DBO.ods_sige_titulo_transacao
ALTER COLUMN ID_MODULO VARCHAR(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE MIS_DW.DBO.ods_sige_titulo_movimento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)  --PROBLEMAS DE CONVERSÃO DEVIDO FALHA DE PK
ALTER TABLE MIS_DW.DBO.DIM_CONDICAO_PAGAMENTO
ALTER COLUMN NR_CIA NUMERIC (3)


--------------------------------------------------------------------
--DE VARCHAR(30) para VARCHAR(40)

ALTER TABLE MIS_DW.DBO.DIM_ESTOQUE_MODALIDADE
ALTER COLUMN DS_MODALIDADE VARCHAR(40)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3) --PROBLEMAS COM PK (DROPAR INDICE E PK)
ALTER TABLE MIS_DW.DBO.ods_purchase_full
ALTER COLUMN NR_CIA NUMERIC(3) not null

--------------------------------------------------------------------
--DE NUMERIC(12) PARA NUMERIC(40)
ALTER TABLE MIS_DW.DBO.ODS_SIGE_CMV_HIST
ALTER COLUMN ID_ITEM NUMERIC(32)


--------------------------------------------------------------------
--DE NUMERIC(12) PARA NUMERIC(40)
ALTER TABLE MIS_DW.DBO.aux_ods_sige_cmv_hist
ALTER COLUMN ID_ITEM NUMERIC(32)

--------------------------------------------------------------------

--DE nvarchar (100) para varchar(100)
ALTER TABLE MIS_DW.dbo.ods_vendedor
ALTER COLUMN ds_vendedor_afiliado varchar(100)


--Inclusão Atributos
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------



--ALTERAÇÕES DE DE-PARA DO SIGE PARA LN NA ESTRUTURA DE COMPANHIA/FILIAL
--STAGE
--INCLUSAO DE COLUNA DE COMPANHIA DO LN
ALTER TABLE MIS_DW.DBO.STG_SIGE_ESTABELECIMENTO
ADD FILI_ID_CIA_LN NUMERIC(3)

--INCLUSAO DE COLUNA DE FILIAL DO LN
ALTER TABLE MIS_DW.DBO.STG_SIGE_ESTABELECIMENTO
ADD FILI_ID_FILIAL_LN NUMERIC(3)

--ODS
ALTER TABLE MIS_DW.DBO.ODS_ESTABELECIMENTO
ADD nr_id_cia_ln NUMERIC(3)

ALTER TABLE MIS_DW.DBO.ODS_ESTABELECIMENTO
ADD nr_id_filial_ln NUMERIC(3)


--------------------------------------------------------------------
--INCLUSÃO DE ATRIBUTO PARA ADAPTAÇÃO AS REGRAS DO LN
ALTER TABLE MIS_DW.DBO.STG_SIGE_METAS_ORCAMENTO
ADD nr_id_unidade_negocio int


--------------------------------------------------------------------
--INCLUSÃO DE ATRIBUTO DE REFERENCIA FISCAL

ALTER TABLE MIS_DW.DBO.STG_SIGE_TITULO
ADD ID_REF_FISCAL varchar(40)

--------------------------------------------------------------------
--DE NUMERIC(12) PARA NUMERIC(40)
ALTER TABLE MIS_DW.DBO.stg_sige_cmv_hist
ALTER COLUMN ID_ITEM NUMERIC(32)


--------------------------------------------------------------------
--Inclusão do flag kit
ALTER TABLE dbo.stg_sige_detalhe_pedido 
ADD NR_KIT int NULL

--------------------------------------------------------------------
--DROP OBJETO DEPENDENCIA

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_estoque_sige]') AND name = N'idx_v1')
DROP INDEX [idx_v1] ON [dbo].[ods_estoque_sige] WITH ( ONLINE = OFF )


--DE NUMERIC(2) PARA NUMERIC(3)
 ALTER TABLE MIS_DW.DBO.ods_estoque_sige
 ALTER COLUMN ID_CIA NUMERIC(3)


--RECRIA OBJETO DEPENDENCIA
CREATE NONCLUSTERED INDEX [idx_v1] ON [dbo].[ods_estoque_sige] 
(
	[id_filial] ASC
)
INCLUDE ( [id_cia],
[id_deposito],
[fl_disponivel],
[nr_item_sku],
[nr_product_sku],
[id_modalidade],
[qt_saldo]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [INDEX]


--------------------------------------------------------------------
--DE NUMERIC(4) PARA NUMERIC(3)
ALTER TABLE MIS_DW.dbo.stg_estoque_sige
ALTER COLUMN ID_CIA NUMERIC(3)

--------------------------------------------------------------------

--DE VARCHAR(2) para VARCHAR(5)
ALTER TABLE MIS_DW.dbo.stg_estoque_sige
ALTER COLUMN ID_TIPODEPOSITO VARCHAR(5)

--------------------------------------------------------------------

--Inclusão Atributo Tipo Bloqueio
ALTER TABLE MIS_DW.DBO.ods_estoque_sige
ADD id_tipo_bloqueio varchar(5)


--------------------------------------------------------------------

 --DE NUMERIC(2) PARA NUMERIC(3)
 ALTER TABLE MIS_DW.DBO.ods_estoque_sige
 ALTER COLUMN ID_CIA NUMERIC(3)

--------------------------------------------------------------------
 
 --DE NUMERIC(4) PARA NUMERIC(3)
ALTER TABLE MIS_DW.dbo.stg_estoque_sige
ALTER COLUMN ID_CIA NUMERIC(3)

--------------------------------------------------------------------

ALTER TABLE MIS_DW.dbo.stg_estoque_sige
ALTER COLUMN ID_TIPODEPOSITO VARCHAR(5)

--------------------------------------------------------------------

--Inclusão Atributo Tipo Bloqueio
ALTER TABLE MIS_DW.DBO.ods_estoque_sige
ADD id_tipo_bloqueio varchar(5)

--------------------------------------------------------------------

CREATE TABLE MIS_DW.dbo.dim_estoque_tipo_bloqueio
(
id_tipo_bloqueio varchar(5),
ds_tipo_bloqueio varchar(50)
)


CREATE TABLE MIS_DW.dbo.stg_estoque_tipo_bloqueio
(
ID_TIPOBLOQ varchar(5),
DS_TIPOBLOQ varchar(50)
)

---------------------------------------------------------------------------------------------------
--VERIFICAR
--DE NUMERIC(24) para NUMERIC(9) --DEVIDO A FALHA NO LOOKUP
--ALTER TABLE MIS_DW.STG_DESPESA_CONTAS
--ALTER COLUMN CONT_ID_CONTA NUMERIC(9)


