--NUMERIC(3) para NUMERIC(2)
alter table mis_ln..stg_est_estoque 
alter column cd_cia int

--=====================================
--criando tabela stg_cap_titulo_lancamento
USE [MIS_LN]
GO

/****** Object:  Table [dbo].[stg_cap_titulo_lancamento]    Script Date: 10/07/2014 13:29:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_cap_titulo_lancamento](
	[CD_CIA] [int] NULL,
	[CD_CHAVE_PRIMARIA] [nvarchar](43) NULL,
	[DS_TIPO_LANCAMENTO] [nvarchar](70) NULL,
	[IN_DEBITO_CREDITO] [nvarchar](70) NULL,
	[VL_LANCAMENTO] [numeric](38, 4) NULL,
	[CD_CONTA_CONTABIL] [nvarchar](12) NULL,
	[DS_CONTA_CONTABIL] [nvarchar](30) NULL,
	[NR_LINHA] [int] NULL,
	[DS_TIPO_IMPOSTO] [nvarchar](70) NULL
) ON [PRIMARY]

GO

--============================================================

--criando tabela stg_trp_analitico_atualiza

USE [MIS_LN]
GO

/****** Object:  Table [dbo].[stg_trp_analitico_atualiza]    Script Date: 10/08/2014 09:18:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_trp_analitico_atualiza](
	[NR_ENTREGA] [nvarchar](30) NULL,
	[DT_ENTREGA_REALIZADA] [datetime] NULL,
	[NM_TIPO_ESTAGIO] [nvarchar](30) NULL,
	[CD_OCORRENCIA_INTERNA] [nvarchar](30) NULL,
	[DS_OCORRENCIA_INTERNA] [nvarchar](30) NULL,
	[DT_OCORRENCIA] [datetime] NULL
) ON [PRIMARY]

GO



--=====================================
--inserindo colunas na tabela stg_car_titulo_parcelamento

alter table dbo.stg_car_titulo_parcelamento
add DT_VENCTO_ORIGINAL datetime null,
	VL_RECEBIDO NUMERIC(38,4) null,
	VL_SALDO NUMERIC(38,4) null

--=====================================
--inserindo colunas na tabela stg_car_titulo_remessa

alter table dbo.stg_car_titulo_remessa
add CD_STATUS_ARQUIVO int null,
	CD_STATUS_ENVIO int null,
	NR_CONTA NVARCHAR(40) null

--=====================================

--inserindo coluna na tabela stg_nfv_cab
alter table stg_nfv_cab
add NR_REFERENCIA_FISCAL_FATURA nvarchar(15) null


----------------------------------------------------------------------------------------------


ALTER TABLE dbo.stg_sku_cmv
ALTER COLUMN CD_ITEM NVARCHAR(47)
COLLATE Latin1_General_CI_AS NULL

ALTER TABLE dbo.stg_sku_cmv
ALTER COLUMN CD_FILIAL NVARCHAR(6)
COLLATE Latin1_General_CI_AS NULL


ALTER TABLE dbo.stg_sku_cmv
ALTER COLUMN CD_UNIDADE_EMPRESARIAL NVARCHAR(10)
COLLATE Latin1_General_CI_AS NULL


--corrige o COLLATE
alter table stg_est_referencia
alter column CD_FILIAL nvarchar(6) collate Latin1_General_CI_AS

alter table stg_est_referencia
alter column CD_DEPOSITO nvarchar(6) collate Latin1_General_CI_AS

alter table stg_est_referencia
alter column CD_ITEM nvarchar(47) collate Latin1_General_CI_AS

alter table stg_est_referencia
alter column NR_NFR nvarchar(9) collate Latin1_General_CI_AS

alter table stg_est_referencia
alter column CD_UNIDADE_EMPRESARIAL nvarchar(10) collate Latin1_General_CI_AS

alter table stg_est_referencia
alter column NR_REFERENCIA_FISCAL nvarchar(10) collate Latin1_General_CI_AS

alter table stg_dev_devolucao
add NR_REFERENCIA_FISCAL_FATURA nvarchar(9) 

