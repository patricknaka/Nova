
---ALTERAÇÕES NA BASE DE DADOS MIS_DW/MIS_DW_MIGRACAO

---------------------------------------------------------------------------------------------------------------------------------------------
--ALTERAÇÕES DE DATA TYPE

--DE NUMERIC(2) PARA INT
ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_DESPESA
ALTER COLUMN ID_CIA INT

--DE NUMERIC(2) PARA INT
ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_DESPESA_LANCAMENTO
ALTER COLUMN LANC_ID_CIA INT

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_DESPESA
ALTER COLUMN ID_CONTA NUMERIC(24)

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_DESPESA_LANCAMENTO
ALTER COLUMN LANC_ID_CONTA NUMERIC(24)

--DE NUMERIC(2) PARA INT
ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_SIGE_PURCHASE_FULL
ALTER COLUMN NR_CIA INT

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_DESPESA_CONTAS
ALTER COLUMN CONT_ID_CONTA NUMERIC(24)

--DE NUMERIC(7) PARA NUMERIC(24)
ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_DESPESA_CONTAS
ALTER COLUMN CONT_ID_CONTAPAI NUMERIC(24)


--DE NUMERIC(2) para NUMERIC(4)
ALTER TABLE MIS_DW_MIGRACAO.DBO.stg_estoque_sige
ALTER COLUMN ID_CIA NUMERIC(4)

--DE VARCHAR(30) PARA VARCHAR(35)
ALTER TABLE MIS_DW_MIGRACAO.DBO.stg_estoque_sige
ALTER COLUMN DS_MODALIDADE VARCHAR(35)

--DE VARCHAR(30) PARA VARCHAR(40)
ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_ESTOQUE_SIGE_MODALIDADE
ALTER COLUMN DS_MODALIDADE VARCHAR(40)

--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_DW_MIGRACAO.dbo.ods_product
alter column ds_ean numeric(15)

--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_DW_MIGRACAO.dbo.dim_product
alter column ds_ean numeric(15)


--DE VARCHAR(30) para VARCHAR(40)
ALTER TABLE MIS_DW_MIGRACAO.dbo.ods_estoque_modalidade
ALTER COLUMN ds_modalidade VARCHAR(40)

--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_DW_MIGRACAO.dbo.aux_produto_dw
alter column ds_ean numeric(15)

--DE NUMERIC(7) para NUMERIC(9) --ESTA ALTERAÇÃO DEVERÁ FALHAR DEVIDO A USO DE CONSTRAINT
ALTER TABLE MIS_DW_MIGRACAO.DBO.ODS_DESPESA_CONTAS
ALTER COLUMN ID_CONTA NUMERIC(9)

ALTER TABLE MIS_DW_MIGRACAO.DBO.ODS_DESPESA
ALTER COLUMN ID_CONTA NUMERIC(9)


--DE NUMERIC (2) para NUMERIC(3)
ALTER TABLE MIS_DW_MIGRACAO.dbo.ODS_DESPESA
ALTER COLUMN id_cia NUMERIC(3)


--DE NUMERIC (2) para NUMERIC(3)
ALTER TABLE MIS_DW_MIGRACAO.dbo.AUX_ODS_DESPESA_LANCAMENTO
ALTER COLUMN id_cia NUMERIC(3)

--DE NUMERIC (2) para NUMERIC(3) --PROBLEMAS COM INDICE NA TABELA
ALTER TABLE MIS_DW_MIGRACAO.dbo.ODS_DESPESA_LANCAMENTO
ALTER COLUMN id_cia NUMERIC(3)

--DE NUMERIC(7) para NUMERIC(9)
ALTER TABLE MIS_DW_MIGRACAO.dbo.aux_ods_despesa_contas
ALTER COLUMN id_conta NUMERIC(9)

--DE NUMERIC(24) para NUMERIC(9) --DEVIDO A FALHA NO LOOKUP
ALTER TABLE MIS_DW_MIGRACAO.STG_DESPESA_CONTAS
ALTER COLUMN CONT_ID_CONTA NUMERIC(9)

--DE NUMERIC(7) PARA NUMERIC(9) --PROBLEMA NO ALTER DEVIDO A DEPENDENCIA DE INDICE
ALTER TABLE MIS_DW_MIGRACAO.dbo.ods_despesa_lancamento
ALTER COLUMN ID_CONTA NUMERIC(9)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE MIS_DW_MIGRACAO.dbo.stg_sige_titulo_movimento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE MIS_DW_MIGRACAO.DBO.stg_sige_titulo
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE MIS_DW_MIGRACAO.DBO.stg_sige_titulo
ALTER COLUMN ID_CIA NUMERIC(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE MIS_DW_MIGRACAO.DBO.stg_sige_titulo_documento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)

ALTER TABLE MIS_DW_MIGRACAO.DBO.stg_sige_titulo_transacao
ALTER COLUMN ID_MODULO VARCHAR(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE MIS_DW_MIGRACAO.DBO.ods_sige_titulo_documento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)
ALTER TABLE MIS_DW_MIGRACAO.DBO.ods_sige_titulo_transacao
ALTER COLUMN ID_MODULO VARCHAR(3)

--------------------------------------------------------------------
--DE VARCHAR(2) para VARCHAR(3)
ALTER TABLE MIS_DW_MIGRACAO.DBO.ods_sige_titulo_movimento
ALTER COLUMN ID_DOCUMENTO varchar(3)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3)  --PROBLEMAS DE CONVERSÃO DEVIDO FALHA DE PK
ALTER TABLE MIS_DW_MIGRACAO.DBO.DIM_CONDICAO_PAGAMENTO
ALTER COLUMN NR_CIA NUMERIC (3)


--------------------------------------------------------------------
--DE VARCHAR(30) para VARCHAR(40)

ALTER TABLE MIS_DW_MIGRACAO.DBO.DIM_ESTOQUE_MODALIDADE
ALTER COLUMN DS_MODALIDADE VARCHAR(40)

--------------------------------------------------------------------
--DE NUMERIC(2) para NUMERIC(3) --PROBLEMAS COM PK (DROPAR INDICE E PK)
ALTER TABLE MIS_DW_MIGRACAO.DBO.ods_purchase_full
ALTER COLUMN NR_CIA NUMERIC(3) not null

--------------------------------------------------------------------
--DE NUMERIC(12) PARA NUMERIC(40)
ALTER TABLE MIS_DW_MIGRACAO.DBO.ODS_SIGE_CMV_HIST
ALTER COLUMN ID_ITEM NUMERIC(32)


--------------------------------------------------------------------
--DE NUMERIC(12) PARA NUMERIC(40)
ALTER TABLE MIS_DW_MIGRACAO.DBO.aux_ods_sige_cmv_hist
ALTER COLUMN ID_ITEM NUMERIC(32)

--------------------------------------------------------------------

--DE nvarchar (100) para varchar(100)
ALTER TABLE MIS_DW_MIGRACAO.dbo.ods_vendedor
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
ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_SIGE_ESTABELECIMENTO
ADD FILI_ID_CIA_LN NUMERIC(3)

--INCLUSAO DE COLUNA DE FILIAL DO LN
ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_SIGE_ESTABELECIMENTO
ADD FILI_ID_FILIAL_LN NUMERIC(3)

--ODS
ALTER TABLE MIS_DW_MIGRACAO.DBO.ODS_ESTABELECIMENTO
ADD nr_id_cia_ln NUMERIC(3)

ALTER TABLE MIS_DW_MIGRACAO.DBO.ODS_ESTABELECIMENTO
ADD nr_id_filial_ln NUMERIC(3)


--------------------------------------------------------------------
--INCLUSÃO DE ATRIBUTO PARA ADAPTAÇÃO AS REGRAS DO LN
ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_SIGE_METAS_ORCAMENTO
ADD nr_id_unidade_negocio int


--------------------------------------------------------------------
--INCLUSÃO DE ATRIBUTO DE REFERENCIA FISCAL

ALTER TABLE MIS_DW_MIGRACAO.DBO.STG_SIGE_TITULO
ADD ID_REF_FISCAL varchar(40)

--------------------------------------------------------------------
--DE NUMERIC(12) PARA NUMERIC(40)
ALTER TABLE MIS_DW_MIGRACAO.DBO.stg_sige_cmv_hist
ALTER COLUMN ID_ITEM NUMERIC(32)

