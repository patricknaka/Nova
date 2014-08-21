--Banco MIS_ODS
-------------------------------------------------------------------------------------------------------------------------
--Script Alteração Data Type

--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE MIS_ODS.fin.ods_sige_titulo_receber_movimento
ALTER COLUMN nr_id_transacao numeric(3)


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

