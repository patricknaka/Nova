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
CREATE TABLE ln.ods_dom_tipo_movimento
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