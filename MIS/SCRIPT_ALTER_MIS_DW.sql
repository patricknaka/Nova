use mis_dw
go

---ALTERAÇÕES NA BASE DE DADOS MIS_DW/MIS_DW

---------------------------------------------------------------------------------------------------------------------------------------------
--ALTERAÇÕES DE DATA TYPE

--DE NUMERIC(2) PARA INT
ALTER TABLE DBO.STG_DESPESA
ALTER COLUMN ID_CIA INT

--DE NUMERIC(2) PARA INT
ALTER TABLE DBO.STG_DESPESA
ALTER COLUMN ID_CUSTO NUMERIC(9)

--DE NUMERIC(2) PARA INT
ALTER TABLE DBO.STG_DESPESA_LANCAMENTO
ALTER COLUMN LANC_ID_CIA INT

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE DBO.STG_DESPESA
ALTER COLUMN ID_CONTA NUMERIC(24)

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE DBO.STG_DESPESA_LANCAMENTO
ALTER COLUMN LANC_ID_CONTA NUMERIC(24)

--DE NUMERIC(2) PARA INT
ALTER TABLE DBO.STG_SIGE_PURCHASE_FULL
ALTER COLUMN NR_CIA numeric(3)

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE DBO.STG_DESPESA_CONTAS
ALTER COLUMN CONT_ID_CONTA NUMERIC(24)

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE DBO.STG_DESPESA_CONTAS
ALTER COLUMN CONT_ID_CONTAPAI NUMERIC(24)


--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE DBO.stg_estoque_sige
ALTER COLUMN ID_CIA NUMERIC(3)

--DE VARCHAR(30) PARA VARCHAR(35)
ALTER TABLE DBO.stg_estoque_sige
ALTER COLUMN DS_MODALIDADE VARCHAR(35)

--DE VARCHAR(30) PARA VARCHAR(40)
ALTER TABLE DBO.STG_ESTOQUE_SIGE_MODALIDADE
ALTER COLUMN DS_MODALIDADE VARCHAR(40)

--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE dbo.ods_product
alter column ds_ean numeric(15)

--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE dbo.dim_product
alter column ds_ean numeric(15)


--DE VARCHAR(30) para VARCHAR(40)
ALTER TABLE dbo.ods_estoque_modalidade
ALTER COLUMN ds_modalidade VARCHAR(40)

--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE dbo.aux_produto_dw
alter column ds_ean numeric(15)

--DE NUMERIC(3) para NUMERIC(2)
alter table mis_dw.dbo.stg_estoque_ln
alter column id_cia numeric(2)
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
ALTER TABLE DBO.ODS_DESPESA_CONTAS
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


ALTER TABLE DBO.ODS_DESPESA
ALTER COLUMN ID_CONTA NUMERIC(9)


--DE NUMERIC (2) para NUMERIC(3)
ALTER TABLE dbo.ODS_DESPESA
ALTER COLUMN id_cia NUMERIC(3)


--DE NUMERIC (2) para NUMERIC(3)
ALTER TABLE dbo.AUX_ODS_DESPESA_LANCAMENTO
ALTER COLUMN id_cia NUMERIC(3)
----------------------------------------------------------------------------------------------------------------------------

--APAGA INDICES
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_despesa_lancamento]') AND name = N'idx_v1')
DROP INDEX [idx_v1] ON [dbo].[ods_despesa_lancamento] WITH ( ONLINE = OFF )

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_despesa_lancamento]') AND name = N'idx_v2')
DROP INDEX [idx_v2] ON [dbo].[ods_despesa_lancamento] WITH ( ONLINE = OFF )

--DE NUMERIC (2) para NUMERIC(3) --PROBLEMAS COM INDICE NA TABELA
ALTER TABLE dbo.ODS_DESPESA_LANCAMENTO
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
ALTER TABLE dbo.aux_ods_despesa_contas
ALTER COLUMN id_conta NUMERIC(9)

----------------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_despesa_lancamento]') AND name = N'idx_v1')
DROP INDEX [idx_v1] ON [dbo].[ods_despesa_lancamento] WITH ( ONLINE = OFF )

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_despesa_lancamento]') AND name = N'idx_v2')
DROP INDEX [idx_v2] ON [dbo].[ods_despesa_lancamento] WITH ( ONLINE = OFF )

--DE NUMERIC(7) PARA NUMERIC(9) --PROBLEMA NO ALTER DEVIDO A DEPENDENCIA DE INDICE
ALTER TABLE dbo.ods_despesa_lancamento
ALTER COLUMN ID_CONTA NUMERIC(9)

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

----------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE dbo.stg_sige_titulo_movimento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE DBO.stg_sige_titulo
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE DBO.stg_sige_titulo
ALTER COLUMN ID_CIA NUMERIC(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE DBO.stg_sige_titulo_documento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)

ALTER TABLE DBO.stg_sige_titulo_transacao
ALTER COLUMN ID_MODULO VARCHAR(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE DBO.ods_sige_titulo_documento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE DBO.ods_sige_titulo_transacao
ALTER COLUMN ID_MODULO VARCHAR(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE DBO.ods_sige_titulo_movimento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dim_condicao_pagamento]') AND name = N'PK_dim_condicao_pagamento')
ALTER TABLE [dbo].[dim_condicao_pagamento] DROP CONSTRAINT [PK_dim_condicao_pagamento]

--DE NUMERIC(2) para NUMERIC(3)  --PROBLEMAS DE CONVERSÃO DEVIDO FALHA DE PK
ALTER TABLE DBO.DIM_CONDICAO_PAGAMENTO
ALTER COLUMN NR_CIA NUMERIC (3) NOT NULL

ALTER TABLE [dbo].[dim_condicao_pagamento] ADD  CONSTRAINT [PK_dim_condicao_pagamento] PRIMARY KEY CLUSTERED 
(
	[nr_cia] ASC,
	[cd_pagamento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--------------------------------------------------------------------
--DE VARCHAR(30) para VARCHAR(40)

ALTER TABLE DBO.DIM_ESTOQUE_MODALIDADE
ALTER COLUMN DS_MODALIDADE VARCHAR(40)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3) --PROBLEMAS COM PK (DROPAR INDICE E PK)
ALTER TABLE DBO.ods_purchase_full
ALTER COLUMN NR_CIA NUMERIC(3) not null

--------------------------------------------------------------------
--DE NUMERIC(12) PARA NUMERIC(40)
ALTER TABLE DBO.ODS_SIGE_CMV_HIST
ALTER COLUMN ID_ITEM NUMERIC(32)


--------------------------------------------------------------------
--DE NUMERIC(12) PARA NUMERIC(40)
ALTER TABLE DBO.aux_ods_sige_cmv_hist
ALTER COLUMN ID_ITEM NUMERIC(32)

--------------------------------------------------------------------

--DE nvarchar (100) para varchar(100)
ALTER TABLE dbo.ods_vendedor
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
ALTER TABLE DBO.STG_SIGE_ESTABELECIMENTO
ADD FILI_ID_CIA_LN NUMERIC(3)

--INCLUSAO DE COLUNA DE FILIAL DO LN
ALTER TABLE DBO.STG_SIGE_ESTABELECIMENTO
ADD FILI_ID_FILIAL_LN NUMERIC(3)

--ODS
ALTER TABLE DBO.ODS_ESTABELECIMENTO
ADD nr_id_cia_ln NUMERIC(3)

ALTER TABLE DBO.ODS_ESTABELECIMENTO
ADD nr_id_filial_ln NUMERIC(3)


--------------------------------------------------------------------
--INCLUSÃO DE ATRIBUTO PARA ADAPTAÇÃO AS REGRAS DO LN
ALTER TABLE DBO.STG_SIGE_METAS_ORCAMENTO
ADD nr_id_unidade_negocio int


--------------------------------------------------------------------
--INCLUSÃO DE ATRIBUTO DE REFERENCIA FISCAL, in_flagprepagto E STATUS_TITULO

ALTER TABLE DBO.STG_SIGE_TITULO
ADD ID_REF_FISCAL varchar(40)

ALTER TABLE dbo.ods_sige_titulo
ADD in_flagprepagto BIT NULL,
	NR_STATUS_TITULO SMALLINT NULL,
	in_ativo bit null

alter table dbo.aux_ods_sige_titulo
add in_flagprepagto bit null,
	status_titulo smallint null

--INCLUSÃO DS_MATRICULA
alter table dbo.ods_vendedor
add ds_matricula varchar(100) null

--------------------------------------------------------------------
--DE NUMERIC(12) PARA NUMERIC(40)
ALTER TABLE DBO.stg_sige_cmv_hist
ALTER COLUMN ID_ITEM NUMERIC(32)

alter table stg_sige_cmv_hist
alter column nr_cia numeric(3)

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_sige_cmv_hist]') AND name = N'IDX_0')
DROP INDEX [IDX_0] ON [dbo].[ods_sige_cmv_hist] WITH ( ONLINE = OFF )

alter table ods_sige_cmv_hist
alter column ID_ITEM numeric(32) not null

alter table ods_sige_cmv_hist
alter column nr_cia numeric(3) not null

CREATE NONCLUSTERED INDEX [IDX_0] ON [dbo].[ods_sige_cmv_hist] 
(
	[nr_cia] ASC,
	[ID_FILIAL] ASC,
	[DT_CMV] ASC,
	[ID_ITEM] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

alter table aux_sige_cmv_hist
alter column nr_cia numeric(3)


--------------------------------------------------------------------
--Inclusão do flag kit
ALTER TABLE dbo.stg_sige_detalhe_pedido 
ADD NR_KIT int NULL

--------------------------------------------------------------------
--DROP OBJETO DEPENDENCIA

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_estoque_sige]') AND name = N'idx_v1')
DROP INDEX [idx_v1] ON [dbo].[ods_estoque_sige] WITH ( ONLINE = OFF )


--DE NUMERIC(2) PARA NUMERIC(3)
 ALTER TABLE DBO.ods_estoque_sige
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

--Inclusão Atributo Tipo Bloqueio
ALTER TABLE DBO.ods_estoque_sige
ADD id_tipo_bloqueio varchar(5)


--------------------------------------------------------------------

 --DE NUMERIC(2) PARA NUMERIC(3)
 ALTER TABLE DBO.ods_estoque_sige
 ALTER COLUMN ID_CIA NUMERIC(3)


--------------------------------------------------------------------

--Inclusão Atributo Tipo Bloqueio
ALTER TABLE DBO.ods_estoque_sige
ADD id_tipo_bloqueio varchar(5)

--------------------------------------------------------------------

CREATE TABLE dbo.dim_estoque_tipo_bloqueio
(
id_tipo_bloqueio varchar(10),
ds_tipo_bloqueio varchar(50)
)


CREATE TABLE dbo.stg_estoque_tipo_bloqueio
(
ID_TIPOBLOQ varchar(10),
DS_TIPOBLOQ varchar(50)
)

CREATE TABLE dbo.ods_estoque_tipo_bloqueio
(
id_tipo_bloqueio varchar(10),
ds_tipo_bloqueio varchar(50)
)

CREATE TABLE [dbo].[aux_ods_vendedor]
(
	nr_id_unidade_negocio int NOT NULL,
	nr_vendedor int NOT NULL,
	ds_vendedor varchar(100) NULL,
	ds_vendedor_afiliado varchar(100) NULL
) 

---------------------------------------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE dbo.stg_sige_pagamento_pedido
ALTER COLUMN NR_ID_CIA numeric(3,0)


ALTER TABLE dbo.stg_sige_faturamento
ALTER COLUMN NR_NATOPE_SEQ_DET numeric(5,0)


ALTER TABLE dbo.stg_sige_faturamento
ALTER COLUMN NR_CIA INT


---------------------------------------------------------------------------------------------------

--EXCLUSÃO DE FK DEVIDO A DESATIVAÇÃO DE CARGA DA TABELA ODS_ESTOQUE_DEPOSITO SUBSTITUIDA PELA TABELA ODS_ESTOQUE_TIPO_BLOQUEIO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ods_estoque_sige_ods_estoque_deposito]') AND parent_object_id = OBJECT_ID(N'[dbo].[ods_estoque_sige]'))
ALTER TABLE [dbo].[ods_estoque_sige] DROP CONSTRAINT [FK_ods_estoque_sige_ods_estoque_deposito]
GO

--CASO PRECISE RECRIAR

/*ALTER TABLE [dbo].[ods_estoque_sige]  WITH CHECK ADD  CONSTRAINT [FK_ods_estoque_sige_ods_estoque_deposito] FOREIGN KEY([id_filial], [id_deposito])
REFERENCES [dbo].[ods_estoque_deposito] ([id_filial], [id_deposito])
GO
ALTER TABLE [dbo].[ods_estoque_sige] CHECK CONSTRAINT [FK_ods_estoque_sige_ods_estoque_deposito]
GO*/

---------------------------------------------------------------------------------------------------

--DE VARCHAR(30) PARA VARCHAR(40)

ALTER TABLE dbo.dim_estoque_modalidade
ALTER COLUMN ds_modalidade VARCHAR(40)

---------------------------------------------------------------------------------------------------
--Inclusão de coluna ODS_ESTOQUE_SIGE

ALTER TABLE ods_estoque_sige
DROP COLUMN [id_tipo_bloqueio]

ALTER TABLE ods_estoque_sige
ADD [id_tipo_bloqueio] [varchar](10) NULL


--ALTERAÇÃO DE VIEW (INCLUSÃO ATRIBUTO ID_TIPO_BLOQUEIO)

ALTER view [dbo].[vw_fact_estoque_sige] as 
select a.id_cia,
a.id_filial,
a.id_deposito,
a.fl_disponivel,
a.nr_item_sku,
a.nr_product_sku,
a.id_modalidade,
a.id_tipo_bloqueio,
sum(qt_fisica) as qt_fisica,
sum(qt_romaneada) as qt_romaneada,
sum(qt_saldo) as qt_saldo,
sum(qt_reservada_dep) as qt_reservada_dep,
sum(vl_cmv) as vl_cmv,
sum(vl_cmv_total) as vl_cmv_total,
sum(vl_venda) as vl_venda,
sum(vl_venda_total) as vl_venda_total,
sum(vl_cmv_fisico) as vl_cmv_fisico
from ods_estoque_sige a
	inner join MIS_SHARED_DIMENSION.dim.ods_produto b
	on a.nr_item_sku = b.nr_item_sku
	and a.nr_product_sku = b.nr_product_sku
group by a.id_cia,
a.id_filial,
a.id_deposito,
a.fl_disponivel,
a.nr_item_sku,
a.nr_product_sku,
a.id_modalidade,
a.id_tipo_bloqueio

---------------------------------------------------------------------------------------------------

--DE NUMERIC(1) para NUMERIC(3)		
ALTER TABLE DBO.stg_sige_estabelecimento
ALTER COLUMN FILI_ID_CIA NUMERIC(3)		


--altera objeto referencia
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_estabelecimento]') AND name = N'PK_ods_estabelecimento')
ALTER TABLE [dbo].[ods_estabelecimento] DROP CONSTRAINT [PK_ods_estabelecimento]

--DE NUMERIC (1) para NUMERIC(3)
ALTER TABLE DBO.ods_estabelecimento
ALTER COLUMN NR_ID_CIA NUMERIC(3)	NOT NULL

--Recria objeto referencia
ALTER TABLE [dbo].[ods_estabelecimento] ADD  CONSTRAINT [PK_ods_estabelecimento] PRIMARY KEY CLUSTERED 
(
	[nr_id_filial] ASC,
	[nr_id_cia] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--delete objeto referencia
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dim_estabelecimento]') AND name = N'PK_dim_estabelecimento')
ALTER TABLE [dbo].[dim_estabelecimento] DROP CONSTRAINT [PK_dim_estabelecimento]

--DE NUMERIC(1) para NUMERIC(3)
ALTER TABLE DBO.dim_estabelecimento
ALTER COLUMN NR_ID_CIA NUMERIC(3)	NOT NULL	

--recria objeto referencia
ALTER TABLE [dbo].[dim_estabelecimento] ADD  CONSTRAINT [PK_dim_estabelecimento] PRIMARY KEY CLUSTERED 
(
	[nr_id_filial] ASC,
	[nr_id_cia] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


---------------------------------------------------------------------------------------------------
--de varchar(2) PARA varchar(3)
ALTER TABLE DBO.stg_sige_titulo_documento
ALTER COLUMN ID_MODULO varchar(3)

ALTER TABLE DBO.stg_sige_titulo_documento
ALTER COLUMN ID_DOCUMENTO varchar(3)

---------------------------------------------------------------------------------------------------

--DE INT PARA VARCHAR(3)
ALTER TABLE .stg_sige_titulo_movimento
ALTER COLUMN ID_TRANSACAO VARCHAR(3)

--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE .stg_sige_titulo
ALTER COLUMN ID_MODULO VARCHAR(3)

--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE .stg_sige_titulo
ALTER COLUMN ID_MODULO VARCHAR(3)

--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE dbo.stg_sige_titulo
ALTER COLUMN ID_CIA numeric(3)

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE dbo.stg_sige_titulo
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE dbo.ods_sige_titulo_documento
ALTER COLUMN ID_MODULO VARCHAR(3)

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE dbo.ods_sige_titulo_documento
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

---------------------------------------------------------------------------------------------------

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE dbo.ods_sige_titulo_movimento
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

--APAGA INDICE DEPENDENTE 1
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_sige_titulo_movimento]') AND name = N'ix_v1')
DROP INDEX [ix_v1] ON [dbo].[ods_sige_titulo_movimento] WITH ( ONLINE = OFF )

--APAGA INDICE DEPENDENTE 2
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_sige_titulo_movimento]') AND name = N'ix_v2')
DROP INDEX [ix_v2] ON [dbo].[ods_sige_titulo_movimento] WITH ( ONLINE = OFF )

--APAGA INDICE DEPENDENTE 3
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_sige_titulo_movimento]') AND name = N'ix_v4')
DROP INDEX [ix_v4] ON [dbo].[ods_sige_titulo_movimento] WITH ( ONLINE = OFF )

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE dbo.ods_sige_titulo_movimento
ALTER COLUMN ID_TRANSACAO VARCHAR(3)

----RECRIA INDICE DEPENDENTE 1
CREATE NONCLUSTERED INDEX [ix_v1] ON [dbo].[ods_sige_titulo_movimento] 
(
	[id_titulo] ASC,
	[id_modulo] ASC,
	[id_documento] ASC
)
INCLUDE ( [ds_situacao],
[id_tipo_valor],
[id_transacao]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [INDEX]


----RECRIA INDICE DEPENDENTE 2
CREATE NONCLUSTERED INDEX [ix_v2] ON [dbo].[ods_sige_titulo_movimento] 
(
	[id_titulo] ASC
)
INCLUDE ( [ds_situacao],
[id_tipo_valor],
[id_transacao],
[id_modulo],
[id_documento]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [INDEX]


----RECRIA INDICE DEPENDENTE 3
CREATE NONCLUSTERED INDEX [ix_v4] ON [dbo].[ods_sige_titulo_movimento] 
(
	[ds_situacao] ASC,
	[id_tipo_valor] ASC,
	[id_transacao] ASC,
	[id_titulo] ASC,
	[id_modulo] ASC,
	[id_documento] ASC
)
INCLUDE ( [vl_transacao]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [INDEX]

---------------------------------------------------------------------------------------------------


--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE stg_sige_titulo_complemento
ALTER COLUMN CAP_ID_DOC nVARCHAR(3)

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE stg_sige_titulo_complemento
ALTER COLUMN TITD_ID_MODULO NVARCHAR(3)

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE stg_sige_titulo_complemento
ALTER COLUMN ID_CIA numeric(3)

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE stg_sige_titulo_complemento
ALTER COLUMN ID_NR NVARCHAR(10)

---------------------------------------------------------------------------------------------------

ALTER TABLE ods_estoque_sige
ALTER COLUMN ID_TIPO_BLOQUEIO VARCHAR(6)

---------------------------------------------------------------------------------------------------

ALTER TABLE .stg_estoque_sige
ALTER COLUMN ID_TIPODEPOSITO VARCHAR(10)

ALTER TABLE .ods_estoque_sige
ALTER COLUMN ID_TIPO_BLOQUEIO VARCHAR(10)

---------------------------------------------------------------------------------------------------
--De varchar(10) para Varchar(20)
alter table stg_sige_fornecedor
alter column CLIE_APELIDO varchar(20)


alter table stg_cfop
alter column ds_nome varchar(50)

alter table ods_cfop
alter column ds_nome varchar(50)

alter table dim_cfop
alter column ds_nome varchar(50)

---------------------------------------------------------------------------------------------------

ALTER TABLE stg_sige_purchase_full_complemento
ALTER COLUMN NOCA_ID_NR_COMP VARCHAR(18)
---------------------------------------------------------------------------------------------------

--EXCLUE OBJETO DEPENDENTE 

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dim_condicao_pagamento]') AND name = N'PK_dim_condicao_pagamento')
ALTER TABLE [dbo].[dim_condicao_pagamento] DROP CONSTRAINT [PK_dim_condicao_pagamento]

--ALTERA ATRIBUTO

ALTER TABLE dim_condicao_pagamento
ALTER COLUMN NR_CIA NUMERIC(3) NOT NULL

--RECRIA OBJETO DEPENDENTE

ALTER TABLE [dbo].[dim_condicao_pagamento] ADD  CONSTRAINT [PK_dim_condicao_pagamento] PRIMARY KEY CLUSTERED 
(
	[nr_cia] ASC,
	[cd_pagamento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

---------------------------------------------------------------------------------------------------


ALTER TABLE aux_ods_sige_cmv_hist
ALTER COLUMN ID_ITEM NUMERIC(18)

ALTER TABLE ods_sige_cmv_hist
ALTER COLUMN ID_ITEM NUMERIC(18)
---------------------------------------------------------------------------------------------------

ALTER TABLE ods_sige_titulo
ALTER COLUMN ID_MODULO VARCHAR(3)

ALTER TABLE ods_sige_titulo
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

ALTER TABLE aux_ods_sige_titulo
ALTER COLUMN ID_MODULO VARCHAR(3)

ALTER TABLE aux_ods_sige_titulo
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

---------------------------------------------------------------------------------------------------

ALTER TABLE stg_sige_titulo_movimento
ALTER COLUMN ID_MODULO VARCHAR(3)

ALTER TABLE stg_sige_titulo_movimento
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

ALTER TABLE stg_sige_titulo_movimento
ALTER COLUMN ID_MODULO_REF VARCHAR(3)

---------------------------------------------------------------------------------------------------

alter table ods_sige_titulo
alter column id_cia numeric(3)

alter table aux_ods_sige_titulo
alter column id_cia numeric(3)

---------------------------------------------------------------------------------------------------

ALTER TABLE ods_sige_titulo_movimento
ALTER COLUMN ID_MODULO VARCHAR(3)

ALTER TABLE ods_sige_titulo_movimento
ALTER COLUMN ID_MODULO_REF VARCHAR(3)

---------------------------------------------------------------------------------------------------

ALTER TABLE AUX_ODS_SIGE_TITULO_MOVIMENTO
ALTER COLUMN ID_MODULO VARCHAR(3)

ALTER TABLE AUX_ODS_SIGE_TITULO_MOVIMENTO
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

ALTER TABLE AUX_ODS_SIGE_TITULO_MOVIMENTO
ALTER COLUMN ID_MODULO_REF VARCHAR(3)
---------------------------------------------------------------------------------------------------

ALTER TABLE stg_sige_titulo_abatimento
ALTER COLUMN ID_DOCUMENTO_ABATIMENTO VARCHAR(3)

ALTER TABLE stg_sige_titulo_abatimento
ALTER COLUMN ID_MODULO_ABATIMENTO VARCHAR(3)

---------------------------------------------------------------------------------------------------

--DELETA OBJETO DEPENDENTE
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_purchase]') AND name = N'PK_ods_purchase')
ALTER TABLE [dbo].[ods_purchase] DROP CONSTRAINT [PK_ods_purchase]

--ALTERA DATA TYPE
ALTER TABLE ODS_PURCHASE
ALTER COLUMN NR_CIA NUMERIC(3) NOT NULL


--RECRIA OBJETO DEPENDENTE
ALTER TABLE [dbo].[ods_purchase] ADD  CONSTRAINT [PK_ods_purchase] PRIMARY KEY CLUSTERED 
(
	[nr_cia] ASC,
	[nr_ped] ASC,
	[nr_forn] ASC,
	[nr_item_ordem] ASC,
	[nr_item_sku] ASC,
	[nr_product_sku] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

---------------------------------------------------------------------------------------------------

ALTER TABLE STG_SIGE_PURCHASE
ADD ds_tipo_propriedade CHAR(1)

alter table ods_purchase
add ds_tipo_propriedade char(1)

---------------------------------------------------------------------------------------------------

alter table aux_ods_purchase
add ds_tipo_propriedade char(1)

alter table aux_ods_purchase
alter column nr_cia numeric(3)

---------------------------------------------------------------------------------------------------

ALTER TABLE dim_purchase_status
ALTER COLUMN DS_CD_STATUS VARCHAR(2)

---------------------------------------------------------------------------------------------------
--ATUALIZAÇÃO DE ADEQUAÇÃO AO DOMINIO LN

UPDATE ODS_PURCHASE
  SET ds_stts_ped = CASE ds_stts_ped WHEN 'A' THEN '99'
				     WHEN 'L' THEN '98'
				     WHEN 'C' THEN '30' END
---------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_purchase_full]') AND name = N'PK_ods_purchase_full')
ALTER TABLE [dbo].[ods_purchase_full] DROP CONSTRAINT [PK_ods_purchase_full]
  
alter table ods_purchase_full
alter column nr_cia numeric(3) not null

ALTER TABLE [dbo].[ods_purchase_full] ADD  CONSTRAINT [PK_ods_purchase_full] PRIMARY KEY CLUSTERED 
(
	[nr_cia] ASC,
	[nr_id_filial] ASC,
	[nr_id_nr] ASC,
	[nr_item_sku] ASC,
	[nr_product_sku] ASC,
	[nr_item_ordem] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--------------------------------------------------------------
--DE CHAR(1) PARA CHAR(2) - ADAPTAÇÃO LN
ALTER TABLE ods_purchase
ALTER COLUMN DS_STTS_PED CHAR(2)

ALTER TABLE ods_purchase
ALTER COLUMN DS_STTS_ITEM CHAR(2)

---------------------------------------------------------------------------------------------------

ALTER TABLE stg_cfop
ALTER COLUMN nr_cfop NUMERIC(5)

ALTER TABLE ods_cfop
ALTER COLUMN nr_cfop NUMERIC(5)

ALTER TABLE dim_cfop
ALTER COLUMN nr_cfop NUMERIC(5)

alter table ods_cfop
alter column nr_cfop_seq numeric(5)

---------------------------------------------------------------------------------------------------
--Performance no Processo de carga Shared Produto

CREATE CLUSTERED INDEX IDX_0 ON ods_estoque_loja
(
nr_item_sku ASC,
nr_product_sku ASC
)


CREATE NONCLUSTERED INDEX IDX_1 ON ods_estoque_loja
(
id_tipo_estoque ASC
)INCLUDE(nr_item_sku,nr_product_sku)

---------------------------------------------------------------------------------------------------

--DE SMALLINT PARA NUMERIC(6)

ALTER TABLE stg_cfop
ALTER COLUMN nr_cfop_seq NUMERIC(5)
---------------------------------------------------------------------------------------------------


ALTER TABLE ods_cfop
ALTER COLUMN nr_cfop_seq NUMERIC(5)

---------------------------------------------------------------------------------------------------


ALTER TABLE dim_cfop
ALTER COLUMN nr_cfop_seq NUMERIC(5)

---------------------------------------------------------------------------------------------------

alter table ods_purchase
alter column nr_seq numeric(5)

alter table ods_purchase
alter column ds_stts_ped varchar(1)

alter table ods_purchase
alter column ds_stts_item varchar(1)


alter table ods_purchase
alter column ds_stts_ped varchar(2)

alter table ods_purchase
alter column ds_stts_item varchar(2)

---------------------------------------------------------------------------------------------------
DROP TABLE [dbo].[stg_estoque_loja_precovenda_ln]
CREATE TABLE [dbo].[stg_estoque_loja_precovenda_ln](
	[Id_Sku] [bigint] NULL,
	[Vl_Venda] [money] NULL
) ON [PRIMARY]
---------------------------------------------------------------------------------------------------

alter table stg_sige_purchase
alter column ds_stts_ped char(2)

alter table stg_sige_purchase
alter column ds_stts_item varchar(1)

---------------------------------------------------------------------------------------------------

alter table ods_purchase_full
alter column ds_stts char(3)

alter table ods_purchase_full
alter column nr_cfop_seq numeric(5)

---------------------------------------------------------------------------------------------------

--TABELA DE STATUS DO PEDIDO PURCHASE 
drop table dim_purchase_order_status

create table dim_purchase_order_status
(
cd_status char(2) NOT NULL,
cd_agrupamento char(1) NOT NULL,
ds_status varchar(50) NULL,
 CONSTRAINT [PK_dim_purchase_order_status] PRIMARY KEY CLUSTERED 
(
	[cd_status] ASC,
	[cd_agrupamento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
)on [primary]
---------------------------------------------------------------------------------------------------

alter table aux_ods_purchase
alter column ds_stts_ped char(2)

alter table aux_ods_purchase
alter column ds_stts_item char(1)

alter table aux_ods_purchase
alter column nr_seq numeric(5)


alter table ods_purchase
alter column ds_stts_item char(1)


alter table ods_purchase
alter column nr_cfop numeric(5)

alter table ods_purchase
alter column nr_seq numeric(5)
---------------------------------------------------------------------------------------------------

alter table dim_purchase_status alter column ds_cd_status varchar(3)

alter table dim_purchase_status
alter column ds_cd_status char(3)

-----------------------------------------------------------------
alter table stg_cfop
alter column ds_nome varchar(45)

alter table stg_sige_purchase
add [ds_tipo_propriedade] [char](1) NULL

alter table stg_sige_fornecedor
alter column CLIE_APELIDO nvarchar(20)

alter table stg_sige_fornecedor
alter column MUNI_ID_ESTADO nvarchar(3)

alter table ods_cfop
alter column ds_nome varchar(50)


----------------------------------
--VERIFICAR
--DE NUMERIC(24) para NUMERIC(9) --DEVIDO A FALHA NO LOOKUP
--ALTER TABLE STG_DESPESA_CONTAS
--ALTER COLUMN CONT_ID_CONTA NUMERIC(9)




--Criar coluna
ALTER TABLE stg_sige_detalhe_pedido ADD NR_KIT int NULL
ALTER TABLE stg_sige_detalhe_pedido ADD NR_ID_PRODUTO int NULL
ALTER TABLE stg_sige_detalhe_pedido ADD NR_STATUS_PEDIDO_LN int NULL
ALTER TABLE stg_sige_detalhe_pedido ADD NR_STATUS_NF_LN int NULL
ALTER TABLE ods_sige_detalhe_pedido ADD nr_id_produto int NULL
ALTER TABLE aux_ods_sige_detalhe_pedido ADD nr_id_produto int NULL
ALTER TABLE ods_sige_faturamento ADD nr_id_produto int NULL
ALTER TABLE ods_fatdev ADD nr_id_cia numeric(3,0) NULL
ALTER TABLE aux_ods_fatdev ADD nr_id_cia numeric(3,0) NULL

--Alterar datatype
ALTER TABLE stg_sige_detalhe_pedido
ALTER COLUMN DS_STATUS_PEDIDO char(1)

ALTER TABLE ods_sige_detalhe_pedido
ALTER COLUMN NR_ID_CIA int

ALTER TABLE ods_sige_detalhe_pedido
ALTER COLUMN DS_STATUS_PEDIDO varchar(2)

ALTER TABLE aux_ods_approved	
ALTER COLUMN nr_cia int

ALTER TABLE aux_ods_fatdev	
ALTER COLUMN nr_cfop_seq_det numeric(5,5)

ALTER TABLE aux_ods_sige_detalhe_pedido	
ALTER COLUMN NR_ID_CIA int

ALTER TABLE aux_ods_sige_pagamento_pedido	
ALTER COLUMN NR_ID_CIA int

ALTER TABLE dump_ods_approved	
ALTER COLUMN nr_cia int

ALTER TABLE dump_ods_sige_detalhe_pedido	
ALTER COLUMN NR_ID_CIA int

ALTER TABLE dump_ods_sige_faturamento	
ALTER COLUMN NR_ID_CIA int

ALTER TABLE dump_ods_sige_faturamento	
ALTER COLUMN NR_CIA int

ALTER TABLE dump_ods_sige_pagamento_pedido	
ALTER COLUMN NR_ID_CIA int

ALTER TABLE ods_fatdev	
ALTER COLUMN nr_cfop_seq_det numeric(5,5)

ALTER TABLE ods_sige_faturamento	
ALTER COLUMN NR_ID_CIA int


ALTER TABLE ods_sige_pagamento_pedido	
ALTER COLUMN NR_ID_CIA int

ALTER TABLE stg_sige_detalhe_pedido	
ALTER COLUMN NR_ID_CIA int

ALTER TABLE stg_sige_pagamento_pedido	
ALTER COLUMN NR_ID_CIA int


ALTER TABLE stg_sige_purchase_full
ADD nr_qtt_fisica int

ALTER TABLE ods_purchase_full
ADD nr_qtt_fisica int

ALTER TABLE aux_ods_purchase_full
ADD nr_qtt_fisica int

ALTER TABLE stg_sige_purchase_full
ADD nr_id_pedido_compra bigint

ALTER TABLE ods_purchase_full
ADD nr_id_pedido_compra bigint

ALTER TABLE aux_ods_purchase_full
ADD nr_id_pedido_compra bigint


----------------------------------------------------
--Aplicado em 03/09/2014
/*alter table ods_terceiro_corporativo
add id_cliente numeric(14) not null default 0

begin
update a
set a.id_cliente = b.ID_CLIENTE
from ods_terceiro_corporativo a
inner join stg_sige_terceiro_corporativo b
on a.id_cliente_grupo = b.ID_CLIENTE_GRUPO
commit


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ods_terceiro_corporativo]') AND name = N'PK_ods_terceiro_corporativo')
ALTER TABLE [dbo].[ods_terceiro_corporativo] DROP CONSTRAINT [PK_ods_terceiro_corporativo]


ALTER TABLE [dbo].[ods_terceiro_corporativo] ADD  CONSTRAINT [PK_ods_terceiro_corporativo] PRIMARY KEY CLUSTERED 
(
	[id_cliente_grupo] ASC,
	[id_cliente] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
*/

--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE ods_sige_faturamento
ALTER COLUMN DS_SERIE varchar(3)


ALTER TABLE AUX_PRODUTO_DW
ALTER COLUMN DS_APELIDO VARCHAR(20)

ALTER TABLE ODS_PRODUCT
ALTER COLUMN DS_APELIDO VARCHAR(20)

ALTER TABLE DIM_PRODUCT
ALTER COLUMN DS_APELIDO VARCHAR(20)


alter table ods_purchase
add in_ativo bit default 0

alter table ods_sige_titulo
add in_ativo bit default 0

alter table dbo.ods_financiamento_pedido_aberto
alter column nr_cia numeric(3)

alter table aux_produto_dw
alter column ds_procedencia varchar(60)

alter table ods_product
alter column ds_procedencia varchar(60)

alter table dbo.stg_sige_titulo_movimento
add nr_tipo_movimento smallint null,
	nr_sq_movimento smallint null