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
--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE MIS_STAGING.FIN.STG_SIGE_TITULO_PAGAMENTO
ALTER COLUMN TIPA_ID_TRANSACAO NUMERIC(3)

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