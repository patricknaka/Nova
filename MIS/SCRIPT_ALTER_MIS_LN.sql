--NUMERIC(3) para NUMERIC(2)
alter table mis_ln..stg_est_estoque 
alter column cd_cia numeric(2)

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

