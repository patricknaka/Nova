--Banco MIS_ODS
-------------------------------------------------------------------------------------------------------------------------
--Script Alteração Data Type

--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE MIS_ODS.fin.ods_sige_titulo_receber_movimento
ALTER COLUMN nr_id_transacao numeric(3)

--DE BIGINT para nvarchar(47)
alter table com.ods_devolucao_fornecedor
alter column nr_item_sku nvarchar(47)

alter table com.ods_devolucao_fornecedor
alter column nr_product_sku nvarchar(47)

--------------------------------------------------------------------
--DE numeric(2) para numeric(3)
ALTER TABLE MIS_ODS.FIN.ods_sige_titulo_pagamento
ALTER COLUMN NR_ID_TRANSACAO NUMERIC(3)


--------------------------------------------------------------------
--DE varchar(30) para varchar(35)
ALTER TABLE MIS_ODS.FIN.ODS_FORNECEDOR_CONTATO
ALTER COLUMN DS_NOME VARCHAR(35)

--DE VARCHAR(2) PARA VARCHAR(3)
ALTER TABLE FIN.ods_sige_titulo_receber
ALTER COLUMN DS_ID_MODULO VARCHAR(3)

--DE numeric(2) para numeric(3)
alter table fin.ods_sige_titulo_receber_transacao
alter column nr_id_cia numeric(3)
-------------------------------------------------------------------------------------------------------------------------------------


--APAGA OBJETO DEPENDENTE 1
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[fin].[ods_sige_titulo_receber_complemento]') AND name = N'idx_chave')
DROP INDEX [idx_chave] ON [fin].[ods_sige_titulo_receber_complemento] WITH ( ONLINE = OFF )

--APAGA OBJETO DEPENDENTE 2
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[fin].[ods_sige_titulo_receber_complemento]') AND name = N'idx_v1')
DROP INDEX [idx_v1] ON [fin].[ods_sige_titulo_receber_complemento] WITH ( ONLINE = OFF )

--ALTERAÇÃO TABELA
--DE NUMERIC(2) PARA NUMERIC(3)
ALTER TABLE FIN.ods_sige_titulo_receber_complemento
ALTER COLUMN NR_ID_CIA numeric(3)

--RECRIA OBJETO DEPENDENTE 1
CREATE NONCLUSTERED INDEX [idx_chave] ON [fin].[ods_sige_titulo_receber_complemento] 
(
	[nr_id_cia] ASC,
	[nr_id_filial] ASC,
	[nr_id_titulo] ASC
)
INCLUDE ( [nr_id_entrega],
[nr_id_ped_externo],
[ds_campanha]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

--RECRIA OBJETO DEPENDENTE 2
CREATE NONCLUSTERED INDEX [idx_v1] ON [fin].[ods_sige_titulo_receber_complemento] 
(
	[nr_id_cia] ASC,
	[nr_id_filial] ASC,
	[nr_id_nota] ASC,
	[ds_serie] ASC
)
INCLUDE ( [nr_id_unidade_negocio],
[nr_id_meio_pagto_principal],
[ds_id_ultimo_ponto],
[ds_situacao_nf],
[nr_dt_emissao_nf],
[nr_id_entrega]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

-------------------------------------------------------------------------------------------------------------------------------------


--DE NUMERIC(7) PARA NUMERIC(9)
ALTER TABLE FIN.ODS_CENTRO_CUSTO
ALTER COLUMN NR_ID_CENTRO_CUSTO NUMERIC(10)

--DE NUMERIC(2) PARA NUMERIC(3)
ALTER TABLE FIN.ods_sige_titulo_receber_movimento
ALTER COLUMN NR_ID_CIA NUMERIC(3)

--DE VARCHAR(3) PARA NUMERIC(3)
ALTER TABLE FIN.ods_sige_titulo_receber_movimento
ALTER COLUMN NR_ID_TRANSACAO VARCHAR(3)

-------------------------------------------------------------------------------------------------------------------------------------------------
--ADAPTAÇÃO A CRIAÇÃO DA NOVA PK
ALTER TABLE FIN.ods_sige_titulo_receber_movimento
ALTER COLUMN NR_ID_TITULO NUMERIC(8) NOT NULL

--APAGA OBJETO MODIFICADO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[fin].[ods_sige_titulo_receber_movimento]') AND name = N'PK_TituloMovimento')
ALTER TABLE [fin].[ods_sige_titulo_receber_movimento] DROP CONSTRAINT [PK_TituloMovimento]

--RECRIA OBJETO MODIFICADO
ALTER TABLE [fin].[ods_sige_titulo_receber_movimento] ADD  CONSTRAINT [PK_TituloMovimento] PRIMARY KEY NONCLUSTERED 
(	[nr_id_titulo] ASC,
	[nr_id_movimento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [INDEX]

-------------------------------------------------------------------------------------------------------------------------------------------------

select nr_id_cia, nr_id_filial, nr_id_titulo,nr_id_transacao, ds_id_documento, SUM(nr_vl_transacao) nr_vl_transacao 
from fin.ods_sige_titulo_receber_movimento b (nolock)
--where b.ds_id_situacao = 'A'
--and b.nr_id_transacao in(3,11,9)
--and b.nr_id_valor = 1
group by  nr_id_cia, nr_id_filial, nr_id_titulo,nr_id_transacao,ds_id_documento


-------------------------------------------------------------------------------------------------------------------------------------------------

-- Tabela de Caracterização do Movimento do Titulo (Pendente CAR - 09/06)
CREATE TABLE ln.ods_tipo_movimento
(
id_tipo_movimento int,
ds_tipo_movimento varchar(20),
cd_modulo varchar(3)
)

INSERT ln.ods_dom_tipo_movimento
values
(1,'Agrupamento','CAP'),
(2,'Abatimento','CAP'),
(3,'Pagamento','CAP'),
(4,'Reversão','CAP')


-------------------------------------------------------------------------------------------------------------------------------------------------

--TABELAS DE AGRUPAMENTO DE TRANSACÕES
CREATE TABLE ln.ods_agrupamento_transacao
(
id_agrupamento int,
cd_transacao varchar(3),
cd_modulo varchar(3)
)

CREATE TABLE ln.ods_agrupamento
(
id_agrupamento int,
ds_agrupamento varchar(20)
)

--INSERT DESCRICAO AGRUPAMENTO
insert ln.ods_agrupamento
values (1,'Reembolso')

--INSERT AGRUPAMENTO REEMBOLSO
INSERT ln.ods_agrupamento_transacao (id_agrupamento,cd_transacao,cd_modulo)
values (1,'PRD','CAP'),(1,'PRB','CAP'),(1,'PRQ','CAP'),(1,'PQR','CAP')


CREATE CLUSTERED INDEX IDX_0 ON ln.ods_agrupamento_transacao
(
ID_AGRUPAMENTO ASC,
CD_TRANSACAO ASC
)

/*
--utilizado em homologação. Copia do criciuma

insert into mis_ods.ln.ods_agrupamento
values  
('2','Abatimento DEV'),
('3','Abt. Concil. Frete'),
('4','Ante Pagto. Serviço'),
('5','Ante Pagto. Produto'),
('6','Abt. Marketplace'),
('7','Abt. Fornecedor'),
('8','Rel Titulo Aberto'),
('9','Encontro Contas'),
('10','Abatimento VPC'),
('11','Juros')

insert into mis_ods.ln.ods_agrupamento_transacao
values ('2','NCC','CAP')
,('2','PDA','CAP')
,('2','PNA','CAP')
,('2','PXA','CAP')
,('3','PAH','CAP')
,('4','PAO','CAP')
,('5','PAT','CAP')
,('6','PKL','CAP')
,('7','PAF','CAP')
,('7','PIP','CAP')
,('8','PFA','CAP')
,('8','PFS','CAP')
,('8','PFT','CAP')
,('8','PGA','CAP')
,('9','ENC','CAP')
,('10','RVA','CAR')
,('10','RVB','CAR')
,('10','RVF','CAR')
,('10','RVT','CAR')
,('11','COR','CAP')
,('11','PJD','CAP')
*/
-------------------------------------------------------------------------------------------------------------------------------------------------

--TABELAS DE CHAVE PARA PROCESSO DE EXTRAÇÃO DO ORÇAMENTO

--TABELA CHAVE DE AGRUPAMENTO
CREATE TABLE ln.ods_agrupamento_orcamento
(
id_unidade_negocio int,
id_tipo_orcamento int,
id_orcamento int
)

--TABELA DE DOMINIO
CREATE TABLE ln.ods_tipo_agrupamento_orcamento
(
id_tipo_orcamento int,
ds_tipo_orcamento varchar(6)
)

--VALORES PADRÕES SIGE

INSERT ln.ods_tipo_agrupamento_orcamento
VALUES (1,'Sales'),(2,'Orders')


--VALORES PADRÕES SIGE QUE SE MANTEM NO LN
INSERT ln.ods_agrupamento_orcamento
VALUES(1,1,1),(2,1,19),(4,1,8),(5,1,5),(6,1,15),(7,1,12),(8,1,9),(9,1,17),(11,1,21),(12,1,24),(13,1,26),
(1,2,2),(2,2,20),(4,2,7),(5,2,6),(6,2,16),(7,2,13),(8,2,10),(9,2,18),(11,2,22),(12,2,23),(13,2,25),(14,1,28),(14,2,27)

-------------------------------------------------------------------------------------------------------------------------------------------------

USE [mis_ods]
GO

/****** Object:  Table [com].[ods_cliente_asm_samsung]    Script Date: 07/08/2014 10:34:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[com].[ods_cliente_asm_samsung]') AND type in (N'U'))
DROP TABLE [com].[ods_cliente_asm_samsung]
GO

USE [mis_ods]
GO

/****** Object:  Table [com].[ods_cliente_asm_samsung]    Script Date: 07/08/2014 10:34:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [com].[ods_cliente_asm_samsung](
	[ds_cnpj_cliente] [varchar](14) NOT NULL,
	[ds_cpf] [varchar](11) NOT NULL,
	[nr_ddd] [char](2) NOT NULL,
	[nr_telefone] [varchar](8) NOT NULL,
	[nr_cep] [int] NOT NULL,
	[ds_uf] [char](2) NOT NULL,
	[ds_cidade] [varchar](50) NOT NULL,
	[ds_endereco] [varchar](100) NOT NULL,
	[ds_cliente] [varchar](50) NOT NULL,
	[ds_cnpj_distribuidor] [varchar](14) NOT NULL,
	[ds_email] [varchar](50) NULL,
	[ds_classificacao_venda] [varchar](100) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [mis_ods]
GO

/****** Object:  Table [com].[ods_estoque_asm_samsung]    Script Date: 07/08/2014 10:34:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[com].[ods_estoque_asm_samsung]') AND type in (N'U'))
DROP TABLE [com].[ods_estoque_asm_samsung]
GO

USE [mis_ods]
GO

/****** Object:  Table [com].[ods_estoque_asm_samsung]    Script Date: 07/08/2014 10:34:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [com].[ods_estoque_asm_samsung](
	[nr_ean13] [bigint] NOT NULL,
	[nr_data] [int] NOT NULL,
	[ds_cnpj_distribuidor] [varchar](14) NOT NULL,
	[nr_qtde_estoque] [int] NOT NULL,
	[ds_tipo_estoque] [char](2) NOT NULL,
	[ds_part_number_prod] [varchar](20) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [mis_ods]
GO

/****** Object:  Table [com].[ods_vendas_asm_samsung]    Script Date: 07/08/2014 10:35:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[com].[ods_vendas_asm_samsung]') AND type in (N'U'))
DROP TABLE [com].[ods_vendas_asm_samsung]
GO

USE [mis_ods]
GO

/****** Object:  Table [com].[ods_vendas_asm_samsung]    Script Date: 07/08/2014 10:35:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [com].[ods_vendas_asm_samsung](
	[nr_nota_fiscal] [bigint] NOT NULL,
	[nr_ean13] [bigint] NOT NULL,
	[nr_data_emissao] [int] NOT NULL,
	[ds_cnpj_distribuidor] [varchar](14) NOT NULL,
	[nr_cod_vendedor] [int] NOT NULL,
	[ds_cpf_cliente] [varchar](11) NOT NULL,
	[ds_cnpj_cliente] [varchar](14) NOT NULL,
	[ds_tipo_faturamento] [char](2) NOT NULL,
	[nr_qtde_venda] [int] NOT NULL,
	[nr_vlr_unid] [numeric](15, 2) NOT NULL,
	[nr_vlr_bruto] [numeric](15, 2) NOT NULL,
	[nr_vlr_liquido] [numeric](15, 2) NOT NULL,
	[nr_percentual_icms] [numeric](4, 2) NOT NULL,
	[ds_tipo_movimento] [char](2) NOT NULL,
	[ds_part_number_prod] [varchar](20) NOT NULL,
 CONSTRAINT [PK_ods_vendas_asm_samsung] PRIMARY KEY CLUSTERED 
(
	[nr_nota_fiscal] ASC,
	[nr_ean13] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [mis_ods]
GO

/****** Object:  Table [com].[ods_vendedor_asm_samsung]    Script Date: 07/08/2014 10:35:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[com].[ods_vendedor_asm_samsung]') AND type in (N'U'))
DROP TABLE [com].[ods_vendedor_asm_samsung]
GO

USE [mis_ods]
GO

/****** Object:  Table [com].[ods_vendedor_asm_samsung]    Script Date: 07/08/2014 10:35:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [com].[ods_vendedor_asm_samsung](
	[nr_cod_vendedor] [bigint] NOT NULL,
	[ds_nome_vendedor] [varchar](50) NOT NULL,
	[ds_cnpj_distribuidor] [varchar](14) NOT NULL,
 CONSTRAINT [PK_ods_vendedor_asm_samsung] PRIMARY KEY CLUSTERED 
(
	[nr_cod_vendedor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [mis_ods]
GO

/****** Object:  View [mkt].[mis_vw_arquivo_asm_samsung]    Script Date: 07/08/2014 10:52:00 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[mkt].[mis_vw_arquivo_asm_samsung]'))
DROP VIEW [mkt].[mis_vw_arquivo_asm_samsung]
GO

USE [mis_ods]
GO

/****** Object:  View [mkt].[mis_vw_arquivo_asm_samsung]    Script Date: 07/08/2014 10:52:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE view [mkt].[mis_vw_arquivo_asm_samsung] as

select
 '01' +
 '09358108000397' +
 replace(convert(varchar(10),GETDATE(),102), '.', '') + replace(convert(varchar(5),GETDATE(),14), ':', '') as arquivo
union all
select
 '02' +
 cast(replicate('0', 11 - len(nr_cod_vendedor)) + cast(nr_cod_vendedor as varchar) as char(11)) + 
 cast(ds_nome_vendedor as char(50)) +
 cast(replicate('0', 14 - len(ds_cnpj_distribuidor)) + cast(ds_cnpj_distribuidor as varchar) as char(14)) as arquivo
from
 com.ods_vendedor_asm_samsung
union all
select
 '03' +
  cast(replicate('0', 20 - len(nr_nota_fiscal)) + cast(nr_nota_fiscal as varchar) as char(20)) +
  cast(replicate('0', 13 - len(nr_ean13)) + cast(nr_ean13 as varchar) as char(13)) +
  cast(nr_data_emissao as char(8)) +
  cast(replicate('0', 14 - len(ds_cnpj_distribuidor)) + cast(ds_cnpj_distribuidor as varchar) as char(14)) +
  cast(replicate('0', 11 - len(nr_cod_vendedor)) + cast(nr_cod_vendedor as varchar) as char(11)) +
  cast(replicate('0', 11 - len(ds_cpf_cliente)) + cast(ds_cpf_cliente as varchar) as char(11)) +
  cast(replicate('0', 14 - len(ds_cnpj_cliente)) + cast(ds_cnpj_cliente as varchar) as char(14)) +
  cast(ds_tipo_faturamento as char(2)) +
  cast(replicate('0', 15 - len(nr_qtde_venda)) + cast(nr_qtde_venda as varchar) as char(15)) +
  cast(replicate('0', 15 - len(replace(nr_vlr_unid,'.',''))) + cast(replace(nr_vlr_unid,'.','') as varchar) as char(15)) +
  cast(replicate('0', 15 - len(replace(nr_vlr_bruto,'.',''))) + cast(replace(nr_vlr_bruto,'.','') as varchar) as char(15)) +
  cast(replicate('0', 15 - len(replace(nr_vlr_liquido,'.',''))) + cast(replace(nr_vlr_liquido,'.','') as varchar) as char(15))+
  cast('0' + replace(cast(nr_percentual_icms / 100 as decimal(4,2)), '.','') as char(4))  +
  cast(ds_tipo_movimento as char(2)) +
  cast(ds_part_number_prod as char(20)) as arquivo
from
 com.ods_vendas_asm_samsung
union all
select
 '04' +
  cast(replicate('0', 13 - len(nr_ean13)) + cast(nr_ean13 as varchar) as char(13)) +
  cast(nr_data as char(8)) +
  cast(replicate('0', 14 - len(ds_cnpj_distribuidor)) + cast(ds_cnpj_distribuidor as varchar) as char(14)) +
  cast(replicate('0', 15 - len(nr_qtde_estoque)) + cast(nr_qtde_estoque as varchar) as char(15)) +
  cast(ds_tipo_estoque as char(2)) +
  cast(ds_part_number_prod as char(20)) as arquivo
from  
 com.ods_estoque_asm_samsung
union all
select
 '05' +
  cast(replicate('0', 14 - len(ds_cnpj_cliente)) + cast(ds_cnpj_cliente as varchar) as char(14)) +
  cast(replicate('0', 11 - len(ds_cpf)) + cast(ds_cpf as varchar) as char(11)) +
  cast(nr_ddd as char(2)) +
  cast(replicate('0', 8 - len(nr_telefone)) + cast(nr_telefone as varchar) as char(8)) +
  cast(replicate('0', 8 - len(nr_cep)) + cast(nr_cep as varchar) as char(8)) +
  cast(ds_uf as char(2)) +
  cast(ds_cidade as char(50)) +
  cast(ltrim(rtrim(ds_endereco)) as char(75)) +
  cast(replace(ds_cliente, nchar(9), '') as char(50)) +
  cast(replicate('0', 14 - len(ds_cnpj_distribuidor)) + cast(ds_cnpj_distribuidor as varchar) as char(14)) +
  cast(isnull(ds_email, replicate(' ',50)) as char(50)) +
  cast(isnull(ds_classificacao_venda, replicate(' ',50)) as char(100)) as arquivo
from  
 com.ods_cliente_asm_samsung



GO

--------------------------------------------

alter table MIS_ODS.fin.ods_sige_titulo_receber_movimento
alter column ds_id_modulo varchar(3)


---------------------------------------------

--Verificar se o campo ja existe

alter table fin.ods_sige_titulo_receber_movimento
add nr_sq_movimento int not null

--Se campo existir recriar a constraint

/****** Object:  Index [PK_TituloMovimento]    Script Date: 07/31/2014 18:34:41 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[fin].[ods_sige_titulo_receber_movimento]') AND name = N'PK_TituloMovimento')
ALTER TABLE [fin].[ods_sige_titulo_receber_movimento] DROP CONSTRAINT [PK_TituloMovimento]
GO

USE [MIS_ODS]
GO

/****** Object:  Index [PK_TituloMovimento]    Script Date: 07/31/2014 18:34:42 ******/
ALTER TABLE [fin].[ods_sige_titulo_receber_movimento] ADD  CONSTRAINT [PK_TituloMovimento] PRIMARY KEY NONCLUSTERED 
(
	[nr_id_titulo] ASC,
	[nr_id_movimento] ASC,
	[nr_sq_movimento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [INDEX]
GO

USE [MIS_ODS]
GO

/****** Object:  Table [fin].[ods_sige_bandeira_pagto]    Script Date: 08/11/2014 16:51:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[fin].[ods_sige_bandeira_pagto]') AND type in (N'U'))
DROP TABLE [fin].[ods_sige_bandeira_pagto]
GO

USE [MIS_ODS]
GO

/****** Object:  Table [fin].[ods_sige_bandeira_pagto]    Script Date: 08/11/2014 16:51:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [fin].[ods_sige_bandeira_pagto](
	[CD_BANDEIRA] [int] NULL,
	[DS_BANDEIRA] [varchar](30) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



USE [MIS_ODS]
GO

/****** Object:  Table [com].[aux_relatorio_vpc]    Script Date: 08/21/2014 17:54:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [com].[aux_relatorio_vpc](
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

/*****************************************************/
/*****************************************************/

USE [MIS_ODS]
GO

/****** Object:  Table [com].[ods_relatorio_vpc]    Script Date: 08/21/2014 17:54:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [com].[ods_relatorio_vpc](
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



------------------------------------------------------------------


alter table fin.ods_sige_titulo_receber
add in_ativo bit default 0


--================================================================

--procedure [ln].[pr_parcela_adquirente]

USE [MIS_ODS]
GO
/****** Object:  StoredProcedure [ln].[pr_parcela_adquirente]    Script Date: 10/08/2014 13:31:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [ln].[pr_parcela_adquirente]
as
begin

IF OBJECT_ID('tempdb..#new') IS NOT NULL DROP TABLE #new
IF OBJECT_ID('tempdb..#teste') IS NOT NULL DROP TABLE #teste

CREATE TABLE #new(
	[de] [int] NOT NULL,
	[ate] [int] NOT NULL,
	[CD_ADQUIRENTE_LN] [nvarchar](9) collate Latin1_General_CI_AS NULL,
	[CD_ADQUIRENTE_FRONT] smallint NULL,
	[CD_BANDEIRA] [smallint] NULL,
	[CD_CIA] [smallint] NULL,
	[PARCELAS] [smallint] NULL,
	[dt_ini_vig] datetime NULL,
) 

select a.cd_adquirente_ln as CD_ADQUIRENTE_LN, 
a.cd_adquirente_front as CD_ADQUIRENTE_FRONT, 
a.cd_bandeira as CD_BANDEIRA, 
a.dt_ini_vig as dt_ini_vig,
a.cd_cia CD_CIA, COUNT(1) as qtde into #teste
from mis_ods.ln.ods_cartao_adquirente a
where a.nr_de is null
group by CD_ADQUIRENTE_LN, CD_ADQUIRENTE_FRONT, a.cd_bandeira, CD_CIA,dt_ini_vig


DECLARE @CD_ADQUIRENTE_LN	nvarchar(18)
DECLARE @CD_ADQUIRENTE_FRONT	nvarchar(40)
DECLARE @CD_BANDEIRA	smallint
DECLARE @CD_CIA	smallint
DECLARE @PARCELAS	smallint
DECLARE @qtde int
DECLARE @dt_ini_vig datetime
declare @parcelas_new int

DECLARE db_cursor CURSOR FOR  
select a.CD_ADQUIRENTE_LN, a.CD_ADQUIRENTE_FRONT, a.CD_BANDEIRA, a.CD_CIA, a.nr_parcela as  PARCELAS, a.dt_ini_vig , qtde
from mis_ods.ln.ods_cartao_adquirente a
	inner join #teste b
	on a.CD_ADQUIRENTE_FRONT = b.CD_ADQUIRENTE_FRONT
	and a.CD_ADQUIRENTE_LN = b.CD_ADQUIRENTE_LN
	and a.CD_BANDEIRA = b.CD_BANDEIRA
	and a.CD_CIA = b.CD_CIA
order by CD_ADQUIRENTE_LN, CD_ADQUIRENTE_FRONT, CD_BANDEIRA, CD_CIA,a.dt_ini_vig , a.nr_parcela

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @CD_ADQUIRENTE_LN,   @CD_ADQUIRENTE_FRONT,@CD_BANDEIRA,@CD_CIA,@PARCELAS,@dt_ini_vig,@qtde

WHILE @@FETCH_STATUS = 0   
BEGIN   
	   if @qtde = 1 
	   begin
			insert into #new
			select 1 as de, @PARCELAS as ate , @CD_ADQUIRENTE_LN,@CD_ADQUIRENTE_FRONT,@CD_BANDEIRA,@CD_CIA,@PARCELAS,@dt_ini_vig
	   end
	   else
	   begin
			if @PARCELAS = 1 
			begin
				insert into #new
				select 1 as de, @PARCELAS as ate , @CD_ADQUIRENTE_LN,@CD_ADQUIRENTE_FRONT,@CD_BANDEIRA,@CD_CIA,@PARCELAS,@dt_ini_vig
				set @parcelas_new = 0
			end
			else
			begin
				select @parcelas_new = MAX(ate) from #new 
				where CD_ADQUIRENTE_LN =@CD_ADQUIRENTE_LN
				and   CD_ADQUIRENTE_FRONT=@CD_ADQUIRENTE_FRONT
				and   CD_BANDEIRA= @CD_BANDEIRA
				and   CD_CIA = @CD_CIA
				and   dt_ini_vig = @dt_ini_vig
				
				insert into #new
				select @parcelas_new+1 as de, @PARCELAS as ate , @CD_ADQUIRENTE_LN,@CD_ADQUIRENTE_FRONT,@CD_BANDEIRA,@CD_CIA,@PARCELAS,@dt_ini_vig				
				
			end
	   end
       FETCH NEXT FROM db_cursor INTO  @CD_ADQUIRENTE_LN,   @CD_ADQUIRENTE_FRONT,@CD_BANDEIRA,@CD_CIA,@PARCELAS,@dt_ini_vig,@qtde   
END   

CLOSE db_cursor   
DEALLOCATE db_cursor	

update a
set a.nr_de = b.de,
	a.nr_ate = b.ate
from mis_ods.ln.ods_cartao_adquirente a
	inner join #new b
	on a.cd_adquirente_front = b.CD_ADQUIRENTE_FRONT
	and a.cd_adquirente_ln = b.CD_ADQUIRENTE_LN 
	and a.cd_bandeira = b.CD_BANDEIRA
	and a.cd_cia = b.CD_CIA
	and a.nr_parcela = b.PARCELAS
	and a.dt_ini_vig = b.dt_ini_vig
	
end	

--============================================================
ALTER TABLE ln.ods_car_titulo_remessa
ADD CD_STATUS_ARQUIVO INT NULL,
	CD_STATUS_ENVIO INT NULL,
	NR_CONTA NVARCHAR(40) NULL

ALTER TABLE ln.ods_car_titulo_parcelamento
ADD DT_VENCTO_ORIGINAL datetime NULL,
	VL_RECEBIDO numeric(38,4) NULL,
	VL_SALDO numeric(38,4) NULL

--=============================================================
--conflito de collation na procedure

USE [MIS_ODS]
GO
/****** Object:  StoredProcedure [ln].[pr_parcela_adquirente]    Script Date: 10/09/2014 10:40:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [ln].[pr_parcela_adquirente]
as
begin

IF OBJECT_ID('tempdb..#new') IS NOT NULL DROP TABLE #new
IF OBJECT_ID('tempdb..#teste') IS NOT NULL DROP TABLE #teste

CREATE TABLE #new(
	[de] [int] NOT NULL,
	[ate] [int] NOT NULL,
	[CD_ADQUIRENTE_LN] [nvarchar](9) NULL,
	[CD_ADQUIRENTE_FRONT] smallint NULL,
	[CD_BANDEIRA] [smallint] NULL,
	[CD_CIA] [smallint] NULL,
	[PARCELAS] [smallint] NULL,
	[dt_ini_vig] datetime NULL,
) 

select a.cd_adquirente_ln as CD_ADQUIRENTE_LN, 
a.cd_adquirente_front as CD_ADQUIRENTE_FRONT, 
a.cd_bandeira as CD_BANDEIRA, 
a.dt_ini_vig as dt_ini_vig,
a.cd_cia CD_CIA, COUNT(1) as qtde into #teste
from mis_ods.ln.ods_cartao_adquirente a
where a.nr_de is null
group by CD_ADQUIRENTE_LN, CD_ADQUIRENTE_FRONT, a.cd_bandeira, CD_CIA,dt_ini_vig


DECLARE @CD_ADQUIRENTE_LN	nvarchar(18)
DECLARE @CD_ADQUIRENTE_FRONT	nvarchar(40)
DECLARE @CD_BANDEIRA	smallint
DECLARE @CD_CIA	smallint
DECLARE @PARCELAS	smallint
DECLARE @qtde int
DECLARE @dt_ini_vig datetime
declare @parcelas_new int

DECLARE db_cursor CURSOR FOR  
select a.CD_ADQUIRENTE_LN, a.CD_ADQUIRENTE_FRONT, a.CD_BANDEIRA, a.CD_CIA, a.nr_parcela as  PARCELAS, a.dt_ini_vig , qtde
from mis_ods.ln.ods_cartao_adquirente a
	inner join #teste b 
	on a.CD_ADQUIRENTE_FRONT = b.CD_ADQUIRENTE_FRONT
	and a.CD_ADQUIRENTE_LN = b.CD_ADQUIRENTE_LN 
	and a.CD_BANDEIRA = b.CD_BANDEIRA
	and a.CD_CIA = b.CD_CIA
order by CD_ADQUIRENTE_LN, CD_ADQUIRENTE_FRONT, CD_BANDEIRA, CD_CIA,a.dt_ini_vig , a.nr_parcela

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @CD_ADQUIRENTE_LN,   @CD_ADQUIRENTE_FRONT,@CD_BANDEIRA,@CD_CIA,@PARCELAS,@dt_ini_vig,@qtde

WHILE @@FETCH_STATUS = 0   
BEGIN   
	   if @qtde = 1 
	   begin
			insert into #new
			select 1 as de, @PARCELAS as ate , @CD_ADQUIRENTE_LN,@CD_ADQUIRENTE_FRONT,@CD_BANDEIRA,@CD_CIA,@PARCELAS,@dt_ini_vig
	   end
	   else
	   begin
			if @PARCELAS = 1 
			begin
				insert into #new
				select 1 as de, @PARCELAS as ate , @CD_ADQUIRENTE_LN,@CD_ADQUIRENTE_FRONT,@CD_BANDEIRA,@CD_CIA,@PARCELAS,@dt_ini_vig
				set @parcelas_new = 0
			end
			else
			begin
				select @parcelas_new = MAX(ate) from #new 
				where CD_ADQUIRENTE_LN =@CD_ADQUIRENTE_LN
				and   CD_ADQUIRENTE_FRONT=@CD_ADQUIRENTE_FRONT
				and   CD_BANDEIRA= @CD_BANDEIRA
				and   CD_CIA = @CD_CIA
				and   dt_ini_vig = @dt_ini_vig
				
				insert into #new
				select @parcelas_new+1 as de, @PARCELAS as ate , @CD_ADQUIRENTE_LN,@CD_ADQUIRENTE_FRONT,@CD_BANDEIRA,@CD_CIA,@PARCELAS,@dt_ini_vig				
				
			end
	   end
       FETCH NEXT FROM db_cursor INTO  @CD_ADQUIRENTE_LN,   @CD_ADQUIRENTE_FRONT,@CD_BANDEIRA,@CD_CIA,@PARCELAS,@dt_ini_vig,@qtde   
END   

CLOSE db_cursor   
DEALLOCATE db_cursor	

update a
set a.nr_de = b.de,
	a.nr_ate = b.ate
from mis_ods.ln.ods_cartao_adquirente a
	inner join #new b
	on a.cd_adquirente_front = b.CD_ADQUIRENTE_FRONT
	and a.cd_adquirente_ln = b.CD_ADQUIRENTE_LN collate Latin1_General_CI_AS
	and a.cd_bandeira = b.CD_BANDEIRA
	and a.cd_cia = b.CD_CIA
	and a.nr_parcela = b.PARCELAS
	and a.dt_ini_vig = b.dt_ini_vig
	
end	

--===============================================================

USE [mis_ods]
GO

/****** Object:  Table [ln].[ods_dump_nfv_cab]    Script Date: 10/09/2014 11:13:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ln].[ods_dump_nfv_cab](
	[CD_CIA] [int] NOT NULL,
	[CD_FILIAL] [nvarchar](6) NULL,
	[NR_NF] [int] NULL,
	[NR_SERIE_NF] [nvarchar](8) NULL,
	[CD_NATUREZA_OPERACAO] [nvarchar](10) NULL,
	[SQ_NATUREZA_OPERACAO] [nvarchar](6) NULL,
	[CD_TIPO_NF] [int] NULL,
	[DT_EMISSAO_NF] [datetime] NULL,
	[HR_EMISSAO_NF] [datetime] NULL,
	[CD_CLIENTE_FATURA] [nvarchar](9) NULL,
	[CD_CLIENTE_ENTREGA] [nvarchar](9) NULL,
	[NR_PEDIDO] [nvarchar](20) NULL,
	[NR_ENTREGA] [nvarchar](10) NULL,
	[NR_ORDEM] [nvarchar](9) NULL,
	[VL_ICMS] [numeric](38, 4) NULL,
	[VL_ICMS_ST] [numeric](38, 4) NULL,
	[VL_IPI] [numeric](38, 4) NULL,
	[VL_PRODUTO] [numeric](38, 4) NULL,
	[VL_FRETE] [numeric](38, 4) NULL,
	[VL_SEGURO] [numeric](38, 4) NULL,
	[VL_DESPESA] [numeric](38, 4) NULL,
	[VL_IMPOSTO_IMPORTACAO] [numeric](38, 4) NULL,
	[VL_DESCONTO] [numeric](38, 4) NULL,
	[VL_TOTAL_NF] [numeric](38, 4) NULL,
	[NR_NF_FATURA] [nvarchar](10) NULL,
	[NR_SERIE_NF_FATURA] [nvarchar](10) NULL,
	[NR_NF_REMESSA] [nvarchar](10) NULL,
	[NR_SERIE_NF_REMESSA] [nvarchar](10) NULL,
	[DT_SITUACAO_NF] [datetime] NULL,
	[CD_SITUACAO_NF] [int] NULL,
	[VL_DESPESA_FINANCEIRA] [numeric](38, 4) NULL,
	[VL_PIS] [numeric](38, 4) NULL,
	[VL_COFINS] [numeric](38, 4) NULL,
	[VL_CSLL] [numeric](38, 4) NULL,
	[VL_DESCONTO_INCONDICIONAL] [numeric](38, 4) NULL,
	[VL_DESPESA_ADUANEIRA] [numeric](38, 4) NULL,
	[VL_ADICIONAL_IMPORTACAO] [numeric](38, 4) NULL,
	[VL_PIS_IMPORTACAO] [numeric](38, 4) NULL,
	[VL_COFINS_IMPORTACAO] [numeric](38, 4) NULL,
	[VL_CIF_IMPORTACAO] [numeric](38, 4) NULL,
	[DT_ULT_ATUALIZACAO] [datetime] NULL,
	[CD_UNIDADE_EMPRESARIAL] [nvarchar](10) NULL,
	[CD_UNIDADE_NEGOCIO] [int] NULL,
	[NR_REFERENCIA_FISCAL] [nvarchar](15) NOT NULL,
	[CD_TIPO_DOCUMENTO_FISCAL] [nvarchar](10) NULL,
	[CD_STATUS_SEFAZ] [numeric](5, 0) NULL,
	[CD_TIPO_ORDEM_VENDA] [nvarchar](10) NULL
) ON [PRIMARY]

GO


--===============================================================
--Insert Manual
USE [MIS_ODS]
GO
/****** Object:  Table [ln].[ods_agrupamento_orcamento]    Script Date: 10/23/2014 10:35:11 ******/
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (1, 1, 1)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (2, 1, 19)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (4, 1, 8)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (5, 1, 5)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (6, 1, 15)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (7, 1, 12)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (8, 1, 9)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (9, 1, 17)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (11, 1, 21)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (12, 1, 24)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (13, 1, 26)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (1, 2, 2)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (2, 2, 20)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (4, 2, 7)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (5, 2, 6)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (6, 2, 16)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (7, 2, 13)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (8, 2, 10)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (9, 2, 18)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (11, 2, 22)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (12, 2, 23)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (13, 2, 25)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (14, 1, 28)
INSERT [ln].[ods_agrupamento_orcamento] ([id_unidade_negocio], [id_tipo_orcamento], [id_orcamento]) VALUES (14, 2, 27)


--copiei os dados do criciuma, pois não achei onde essas tabelas são geradas
/*
alter table fin.aux_unineg_documento_titulo
alter column ds_id_documento varchar(3)

alter table fin.aux_unineg_documento_titulo
alter column ds_id_modulo varchar(3)

insert into fin.aux_unineg_documento_titulo
values
('1','RB3','CAR'),
('1','RBN','CAR'),
('1','RPG','CAR'),
('2','RE1','CAR'),
('2','RE4','CAR'),
('2','RWC','CAR'),
('4','RWA','CAR'),
('4','RWG','CAR'),
('5','RVA','CAR'),
('5','RVB','CAR'),
('5','RVF','CAR'),
('5','RVT','CAR'),
('8','RIH','CAR'),
('12','RPA','CAR'),
('18','RCD','CAR'),
('19','RCK','CAR')

insert into fin.ods_unineg_titulo 
values 
('Atacado'),
('B2B'),
('Ressarcimento'),
('Saldão/Avaria'),
('VPC'),
('Outros'),
('Baixa'),
('E-HUB'),
('FIC'),
('Geral'),
('Juros'),
('Partiu Viagens'),
('PDD'),
('PDD Atacado'),
('PDD B2B (E2)'),
('Recebimento Diversos'),
('Reentrada - Diversos'),
('Serviços'),
('Stock Optons')

insert into fin.ods_tipo_valor
values
('1','Principal'),
('2','Imposto'),
('3','Mora e Multa'),
('4','Despesas'),
('5','Pagto.Maior'),
('6','Descontos'),
('7','Encargos'),
('8','Juros')
*/

alter table mis_ods.ln.ods_car_titulo_mvmto
alter column CD_TRANSACAO_TITULO nvarchar(3) collate Latin1_General_CI_AS

alter table mis_ods.ln.ods_car_titulo_mvmto
alter column CD_MODULO nvarchar(3) collate Latin1_General_CI_AS

alter table MIS_ODS.ln.ods_car_titulo
alter column cd_transacao_titulo nvarchar(3) collate latin1_general_ci_as

alter table MIS_ODS.ln.ods_car_titulo
alter column cd_modulo nvarchar(3) collate latin1_general_ci_as

alter table MIS_ODS.ln.ods_car_titulo_parcelamento
alter column cd_modulo nvarchar(3) collate latin1_general_ci_as

--===============================================
--APAGA pk
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'ln.ods_dom_situacao_titulo') AND name = N'PK_ods_dom_situacao_titulo')
ALTER TABLE ln.ods_dom_situacao_titulo DROP CONSTRAINT [PK_ods_dom_situacao_titulo]

alter table ln.ods_dom_situacao_titulo
alter column cd_modulo nvarchar(3) collate latin1_general_ci_as not null 

--RECRIA pk
ALTER TABLE ln.ods_dom_situacao_titulo ADD  CONSTRAINT [PK_ods_dom_situacao_titulo] PRIMARY KEY CLUSTERED 
(
	[CD_SITUACAO_TITULO] ASC,
	[CD_MODULO] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--======================================================

--===============================================
--APAGA pk
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'FIN.ods_transacao') AND name = N'PK_transacao')
ALTER TABLE FIN.ods_transacao DROP CONSTRAINT [PK_transacao]

alter table FIN.ods_transacao
alter column ds_id_modulo varchar(3) not null

--RECRIA pk
ALTER TABLE FIN.ods_transacao ADD  CONSTRAINT [PK_transacao] PRIMARY KEY CLUSTERED 
(
	[ds_id_modulo] ASC,
	[nr_id_transacao] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--======================================================
--alterando collate da ods_nfv_cab
--- apaga a PK
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ln].[ods_nfv_cab]') AND name = N'PK_ods_nfv_cab')
ALTER TABLE [ln].[ods_nfv_cab] DROP CONSTRAINT [PK_ods_nfv_cab]

--corrige o COLLATE
alter table ln.ods_nfv_cab
alter column CD_FILIAL nvarchar(6) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column NR_SERIE_NF nvarchar(8) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column CD_NATUREZA_OPERACAO nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column SQ_NATUREZA_OPERACAO nvarchar(6) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column CD_CLIENTE_FATURA nvarchar(9) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column CD_CLIENTE_ENTREGA nvarchar(9) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column NR_PEDIDO nvarchar(20) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column NR_ENTREGA nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column NR_ORDEM nvarchar(9) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column NR_NF_FATURA nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column NR_SERIE_NF_FATURA nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column NR_NF_REMESSA nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column NR_SERIE_NF_REMESSA nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column CD_UNIDADE_EMPRESARIAL nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column NR_REFERENCIA_FISCAL nvarchar(15) collate Latin1_General_CI_AS not null

alter table ln.ods_nfv_cab
alter column CD_TIPO_DOCUMENTO_FISCAL nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfv_cab
alter column CD_TIPO_ORDEM_VENDA nvarchar(10) collate Latin1_General_CI_AS

--recria a PK
ALTER TABLE [ln].[ods_nfv_cab] ADD  CONSTRAINT [PK_ods_nfv_cab] PRIMARY KEY NONCLUSTERED 
(	[CD_CIA] ASC,
	[NR_REFERENCIA_FISCAL] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--========================================================

--alterando collate da ods_nfr_cab
--- apaga a PK
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ln].[ods_nfr_cab]') AND name = N'PK_ods_nrf_cab')
ALTER TABLE [ln].[ods_nfr_cab] DROP CONSTRAINT [PK_ods_nrf_cab]

--corrige o COLLATE
alter table ln.ods_nfr_cab
alter column CD_FILIAL nvarchar(6) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column NR_NFR nvarchar(9) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column CD_FORNECEDOR nvarchar(9) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column NR_SERIE_NF_RECEBIDA nvarchar(3) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column CD_NATUREZA_OPERACAO nvarchar(6) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column SQ_NATUREZA_OPERACAO nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column IN_MERC_UTILIZADA_CONSUMO nvarchar(40) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column NR_NFR_COMPLEMENTO nvarchar(40) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column CD_CONDICAO_PAGAMENTO nvarchar(3) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column DS_OBSERVACAO_NFR nvarchar(60) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column COD_CAMINHAO nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column DS_MOTIVO_DEVOLUCAO_ATO nvarchar(100) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column CD_TIPO_FRETE nvarchar(1) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column CD_UNIDADE_EMPRESARIAL nvarchar(30) collate Latin1_General_CI_AS

alter table ln.ods_nfr_cab
alter column NR_REFERENCIA_FISCAL nvarchar(30) collate Latin1_General_CI_AS not null

alter table ln.ods_nfr_cab
alter column NR_RECEB_DOCTO_WMS nvarchar(40) collate Latin1_General_CI_AS

--recria a PK
ALTER TABLE [ln].[ods_nfr_cab] ADD  CONSTRAINT [PK_ods_nfr_cab] PRIMARY KEY NONCLUSTERED 
(	[CD_CIA] ASC,
	[NR_REFERENCIA_FISCAL] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--===========================================================

--alterando collate da ods_cap_titulo
--- apaga a PK
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ln].[ods_cap_titulo]') AND name = N'PK_ods_cap_titulo')
ALTER TABLE [ln].[ods_cap_titulo] DROP CONSTRAINT [PK_ods_cap_titulo]

--corrige o COLLATE
alter table ln.ods_cap_titulo
alter column CD_MODULO nvarchar(3) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column CD_FILIAL nvarchar(9) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column CD_TRANSACAO_TITULO nvarchar(3) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column CD_PARCEIRO nvarchar(9) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column NR_SERIE_NF_RECEBIDA nvarchar(3) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column IN_BLOQUEIO_TITULO nvarchar(40) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column CD_BANCO_DESTINO nvarchar(3) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column NR_AGENCIA_DESTINO nvarchar(4) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column NR_DIGITO_AGENCIA_DESTINO nvarchar(2) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column NR_CONTA_CORRENTE_DESTINO nvarchar(34) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column NR_DIG_CONTA_CORRENTE_DESTINO nvarchar(2) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column CD_UNIDADE_EMPRESARIAL nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_cap_titulo
alter column NR_REFERENCIA_FISCAL nvarchar(18) collate Latin1_General_CI_AS 

alter table ln.ods_cap_titulo
alter column CD_CHAVE_PRIMARIA nvarchar(43) collate Latin1_General_CI_AS not null

--recria a PK
ALTER TABLE [ln].[ods_cap_titulo] ADD  CONSTRAINT [PK_ods_cap_titulo] PRIMARY KEY NONCLUSTERED 
(	[CD_CIA] ASC,
	[CD_CHAVE_PRIMARIA] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--============================================================

--alterando collate da ods_nfr_det
--- apaga a PK
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ln].[ods_nfr_det]') AND name = N'PK_ods_nfr_det')
ALTER TABLE [ln].[ods_nfr_det] DROP CONSTRAINT [PK_ods_nfr_det]

--corrige o COLLATE
alter table ln.ods_nfr_det
alter column CD_FILIAL nvarchar(6) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column CD_ITEM nvarchar(47) collate Latin1_General_CI_AS not null

alter table ln.ods_nfr_det
alter column CD_NBM nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column SQ_NBM nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column CD_DEPOSITO nvarchar(6) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column NR_NFR_REFERENCIA nvarchar(40) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column NR_ITEM_NFR_REFERENCIA nvarchar(40) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column CD_ITEM_KIT nvarchar(47) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column CD_NATUREZA_OPERACAO nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column SQ_NATUREZA_OPERACAO nvarchar(6) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column NR_PEDIDO_COMPRA nvarchar(9) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column CD_UNIDADE_EMPRESARIAL nvarchar(10) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column NR_REFERENCIA_FISCAL nvarchar(15) collate Latin1_General_CI_AS not null

alter table ln.ods_nfr_det
alter column NR_NFR nvarchar(9) collate Latin1_General_CI_AS

alter table ln.ods_nfr_det
alter column NR_CNPJ_CPF_ENTREGA nvarchar(20) collate Latin1_General_CI_AS

--recria a PK
ALTER TABLE [ln].[ods_nfr_det] ADD  CONSTRAINT [PK_ods_nfr_det] PRIMARY KEY NONCLUSTERED 
(	[CD_CIA] ASC,
	[SQ_ITEM_NF_RECEBIDA] ASC,
	[CD_ITEM] ASC,
	[NR_REFERENCIA_FISCAL] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--==========================================

alter table ln.ods_titulo_cap_ref
alter column ds_id_titulo varchar(50) collate Latin1_General_CI_AS

--==========================================

ALTER TABLE com.ods_hist_alt_ati_can_prod
ALTER COLUMN ds_status VARCHAR(3)

--===========================================

alter table log.ods_fluxo_pedidos_entrada
add nr_qtde_pecas int, nr_vl_m3 numeric(18,6)

alter table log.ods_fluxo_pedidos_saida
add nr_qtde_pecas int, nr_vl_m3 numeric(18,6)

--==============================================
CREATE TABLE [log].[ods_fluxo_pedidos_caixa](
	[nr_dt_emissao] [int] NULL,
	[nr_hora] [int] NULL,
	[ds_filial] [nvarchar](5) NULL,
	[nr_id_planta] [int] NULL,
	[nr_id_filial] [int] NULL,
	[nr_id_unidade_negocio] [int] NULL,
	[nr_id_localidade] [int] NULL,
	[nr_id_departamento] [int] NULL,
	[nr_qtde_pedido] [numeric](18, 0) NULL,
	[nr_qtde_pecas] [int] NULL,
	[nr_vl_m3] [numeric](18, 6) NULL
) ON [PRIMARY]

--===============================================


