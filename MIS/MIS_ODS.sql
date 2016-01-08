--Adaptação LN

alter table mis_ods.ln.ods_gar_estendida
alter column NR_PEDIDO nvarchar(10)

alter table mis_ln.dbo.stg_gar_estendida
alter column NR_PEDIDO nvarchar(10)

alter table mis_ods.log.ods_volumetria_detalhe
alter column nr_deposito nvarchar(9) null

alter table mis_ods.log.ods_volumetria
alter column nr_id_deposito nvarchar(9) null

--11/12/2015 - Rosana
alter table mis_ods.ln.ods_pec_cab
add DS_ORDEM_PN_FORNEC varchar(150)

--29/12/2015
alter table MIS_ODS.LN.ods_pev_cliente
add DS_EMAIL VARCHAR(100) NULL
	DS_NOME_CLIENTE VARCHAR(70) null,
	NR_CNPJ_CPF varchar(20) null

alter table mis_ods.ln.ods_pev_det
add CD_LOJISTA_MKP int null

--07/01/2016
CREATE TABLE [ln].[ods_wms_tracking_pedido_hist](
	[CD_TRACKING] [int] NOT NULL,
	[NR_PEDIDO_WMS] [varchar](15) NOT NULL,
	[CD_PLANTA] [varchar](30) NOT NULL,
	[CD_OCORRENCIA] [varchar](3) NULL,
	[CD_SISTEMA_HOST] [varchar](3) NULL,
	[DT_INCLUSAO_TRACKING] [datetime] NULL,
	[CD_ARMAZEM] [varchar](10) NULL,
 CONSTRAINT [PK_ods_wms_tracking_pedido_hist] PRIMARY KEY CLUSTERED 
(
	[CD_TRACKING] ASC,
	[NR_PEDIDO_WMS] ASC,
	[CD_PLANTA] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GO

--08/01/2016
ALTER TABLE ln.ods_pev_cab
ADD DT_PROMETIDA_ENTREGA datetime null