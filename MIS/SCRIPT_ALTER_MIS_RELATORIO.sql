USE MIS_RELATORIO_
GO

ALTER TABLE fin.aux_ods_cap_reembolso
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

ALTER TABLE fin.ods_cap_reembolso
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)


------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[fin].[ods_cap_reembolso]') AND name = N'PK_id_titulo')
ALTER TABLE [fin].[ods_cap_reembolso] DROP CONSTRAINT [PK_id_titulo]
GO

ALTER TABLE fin.ODS_CAP_REEMBOLSO
ALTER COLUMN id_documento varchar(3) not null
GO

/****** Object:  Index [PK_id_titulo]    Script Date: 06/10/2014 14:09:00 ******/
ALTER TABLE [fin].[ods_cap_reembolso] ADD  CONSTRAINT [PK_id_titulo] PRIMARY KEY NONCLUSTERED 
(
	[id_titulo] ASC,
	[id_filial] ASC,
	[id_documento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

---------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE stg_sige_extranet_fornecedores_liquidado
ALTER COLUMN ID_DOCUMENTO VARCHAR(3)

---------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE stg_tb_planilhao
ALTER COLUMN EAN numeric(15)

ALTER TABLE stg_tb_planilhao
ADD ds_cor varchar(25)

ALTER TABLE stg_tb_planilhao
ADD ds_tamanho varchar(60)

alter table stg_sige_preco_tabela
alter column ITEM_NR_ITEM numeric(15)

alter table ods_tb_planilhao
alter column Ean numeric(15,0)

USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[stg_comp_ods_product]    Script Date: 08/04/2014 10:50:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stg_comp_ods_product]') AND type in (N'U'))
DROP TABLE [dbo].[stg_comp_ods_product]
GO

USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[stg_comp_ods_product]    Script Date: 08/04/2014 10:50:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_comp_ods_product](
	[ITEG_ID] [numeric](9, 0) NULL,
	[NPIT_ID_ITEM] [numeric](14, 0) NULL,
	[SUFA_NOME] [nvarchar](80) NULL,
	[SUFA_ID_SUB] [numeric](9, 0) NULL,
	[NBM_DESCRICAO] [nvarchar](30) NULL,
	[ITEG_OBSERVACAO] [nvarchar](1000) NULL,
	[ITEG_DT_INCLUSAO] [nvarchar](16) NULL,
	[ITEG_DATAHORA] [nvarchar](16) NULL,
	[ITEG_USUARIO] [nvarchar](30) NULL,
	[TAPF_DT_VALIDADE] [nvarchar](10) NULL,
	[NPIT_PZ_GARANTIA] [numeric](2, 0) NULL,
	[ITEG_TP_LOTE_SERIE] [nvarchar](3) NULL,
	[ITEG_IN_FABRIC_VALID] [nvarchar](10) NULL,
	[ITEG_PZ_VALIDADE] [numeric](6, 0) NULL,
	[ITEG_PZ_ALARME_VALID] [numeric](6, 0) NULL,
	[ITEG_PZ_MIN_RECEBTO] [numeric](6, 0) NULL,
	[ITEG_PZ_MIN_EXPED] [numeric](6, 0) NULL,
	[ITEG_ID_CONITE] [numeric](3, 0) NULL,
	[ITEG_FABRICANTE_MODELO] [nvarchar](50) NULL,
	[ID_EAN] [nvarchar](40) NULL,
	[CONI_NOME] [nvarchar](30) NULL,
	[ITTK_ID_ITEM_TIK] [numeric](9, 0) NULL,
	[ITTK_IN_INTERFACE] [nvarchar](1) NULL,
	[FILI_ID_FILIAL] [numeric](6, 0) NULL,
	[ITEM_DT_ULT_ALT] [datetime] NULL
) ON [PRIMARY]

GO


USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[ods_product_complemento]    Script Date: 08/04/2014 11:22:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ods_product_complemento]') AND type in (N'U'))
DROP TABLE [dbo].[ods_product_complemento]
GO

USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[ods_product_complemento]    Script Date: 08/04/2014 11:22:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ods_product_complemento](
	[nr_product_sku] [bigint] NOT NULL,
	[nr_item_sku] [bigint] NOT NULL,
	[ds_sufa_nome] [varchar](80) NULL,
	[nr_sufa] [int] NULL,
	[ds_nbm_desc] [varchar](50) NULL,
	[ds_observacao] [varchar](1000) NULL,
	[dt_inclusao_item] [datetime] NULL,
	[dt_datahora_item] [datetime] NULL,
	[ds_usuario] [varchar](50) NULL,
	[dt_validade] [varchar](50) NULL,
	[nr_pz_garantia] [int] NULL,
	[ds_tp_lote_serie] [varchar](50) NULL,
	[ds_in_fabric_valid] [varchar](50) NULL,
	[nr_pz_validade] [int] NULL,
	[nr_pz_alarme_valid] [int] NULL,
	[nr_pz_min_recebto] [int] NULL,
	[nr_pz_min_exped] [int] NULL,
	[nr_id_conite] [int] NULL,
	[ds_modelo_fabricante] [varchar](50) NULL,
	[nr_ean] [varchar](50) NULL,
	[ds_coni_nome] [varchar](50) NULL,
	[nr_id_item_tik] [bigint] NULL,
	[ds_in_interface] [char](1) NULL,
	[id_filial] [int] NULL,
	[dt_ult_alt] [datetime] NULL,
 CONSTRAINT [PK_ods_product_complemento] PRIMARY KEY CLUSTERED 
(
	[nr_product_sku] ASC,
	[nr_item_sku] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[aux_ods_product_compl]    Script Date: 08/04/2014 11:22:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aux_ods_product_compl]') AND type in (N'U'))
DROP TABLE [dbo].[aux_ods_product_compl]
GO

USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[aux_ods_product_compl]    Script Date: 08/04/2014 11:22:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[aux_ods_product_compl](
	[nr_product_sku] [bigint] NOT NULL,
	[nr_item_sku] [bigint] NOT NULL,
	[ds_sufa_nome] [varchar](80) NULL,
	[nr_sufa] [int] NULL,
	[ds_nbm_desc] [varchar](50) NULL,
	[ds_observacao] [varchar](1000) NULL,
	[dt_inclusao_item] [datetime] NULL,
	[dt_datahora_item] [datetime] NULL,
	[ds_usuario] [varchar](50) NULL,
	[dt_validade] [varchar](50) NULL,
	[nr_pz_garantia] [int] NULL,
	[ds_tp_lote_serie] [varchar](50) NULL,
	[ds_in_fabric_valid] [varchar](50) NULL,
	[nr_pz_validade] [int] NULL,
	[nr_pz_alarme_valid] [int] NULL,
	[nr_pz_min_recebto] [int] NULL,
	[nr_pz_min_exped] [int] NULL,
	[nr_id_conite] [int] NULL,
	[ds_modelo_fabricante] [varchar](50) NULL,
	[nr_ean] [varchar](50) NULL,
	[ds_coni_nome] [varchar](50) NULL,
	[nr_id_item_tik] [bigint] NULL,
	[ds_in_interface] [char](1) NULL,
	[id_filial] [int] NULL,
	[dt_ult_alt] [datetime] NULL,
 CONSTRAINT [PK_aux_product_complemento] PRIMARY KEY CLUSTERED 
(
	[nr_product_sku] ASC,
	[nr_item_sku] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

------------------------------------------------------------------

use MIS_RELATORIO
alter table dbo.stg_planilhao_ruptura
add vl_cmv_ponderado numeric(26,5), dt_pri_recebimento int



------------------------------------------------------------------


ALTER proc [dbo].[pr_relatorio_orders_depto](@dt_inicio int,@dt_fim int)
as
begin


IF OBJECT_ID('tempdb..#auxiliar') IS NOT NULL DROP TABLE #auxiliar
	select *,
		ROW_NUMBER() OVER(ORDER BY b.vl_com_desconto DESC) as contador into #auxiliar
	from (	select 
			aa.nr_item_sku,
			aa.ds_product,
			aa.qty_item,
			aa.vl_com_desconto,
			aa.vl_cmv,
			aa.vl_impostos,
			aa.vl_com_desconto - (aa.vl_cmv+aa.vl_impostos) as vl_margem,
			((aa.vl_com_desconto - (aa.vl_cmv+aa.vl_impostos))/aa.vl_com_desconto) as vl_margem_percent,
			aa.vl_cmd,
			aa.estoque_sige,
			aa.cobertura,
			aa.ds_depto,
			aa.ds_sector,
			aa.nr_depto,
			DENSE_RANK() OVER (ORDER BY aa.vl_com_desconto - (aa.vl_cmv+aa.vl_impostos) desc) AS 'Rank'
		from (select 
				a.nr_item_sku,
				b.ds_product,
				sum(a.qty_item) as qty_item,
				sum(a.vl_com_desconto) as vl_com_desconto,
				cast(sum(a.qty_item) * isnull(cm.vl_cmv,0) as decimal(20,2)) as vl_cmv, 
				case when imp.vl_percent_imposto = null then 
					cast(sum(a.vl_com_desconto) * 0.2725 as decimal(20,2))
				else
					cast(sum(a.vl_com_desconto) * imp.vl_percent_imposto as decimal(20,2)) 
				end as vl_impostos, 
				cast(e.vl_cmd as decimal(20,2)) as vl_cmd,
				isnull(f.qt_saldo,0) as estoque_sige,
				case when vl_cmd = 0 then 
					0 
				else 
					cast((isnull(f.qt_saldo,0) / e.vl_cmd) as decimal(20,2)) 
				end as cobertura,
				b.ds_depto, b.ds_sector, b.nr_depto
			from rpt_indicador_orders a (nolock)
			inner join MIS_DW..ods_product b (nolock)
				on a.nr_item_sku = b.nr_item_sku
				and a.nr_product_sku = b.nr_product_sku
				and b.ds_item = 'Produto'
			left join mis_dw..stg_sige_estoque_cmd e (nolock)
				on e.nr_item_sku = a.nr_item_sku
				and e.nr_product_sku = a.nr_product_sku
			left join (select es.nr_item_sku,SUM(es.qt_saldo) as qt_saldo
						from MIS_DW..vw_fact_estoque_sige es (nolock)
							left join MIS_DW..dim_estoque_tipo_bloqueio ed (nolock)
							on es.id_tipo_bloqueio = ed.id_tipo_bloqueio
						where ed.ds_tipo_bloqueio = 'WN'
						and es.id_filial <> 3
						group by es.nr_item_sku) f
				on f.nr_item_sku = a.nr_item_sku
			left join mis_dw..stg_cl_cmv cm (nolock)
				on a.nr_item_sku = cm.nr_item
			left join aux_indicador_orders_imposto imp (nolock)
				on imp.nr_item_sku = a.nr_item_sku
				and imp.nr_product_sku = a.nr_product_sku
		where a.dt_orders between convert(varchar,@dt_inicio,112) and convert(varchar,@dt_fim,112)		
		group by a.nr_item_sku,
		b.ds_product,b.ds_depto, b.ds_sector,e.vl_cmd,f.qt_saldo, cm.vl_cmv, imp.vl_percent_imposto,b.nr_depto
		)aa
		)b
		order by b.vl_com_desconto desc

IF OBJECT_ID('tempdb..#report') IS NOT NULL DROP TABLE #report

CREATE TABLE #report(
	[nr_item_sku] [bigint] NULL,
	[ds_product] [varchar](150) NULL,
	[qty_item] [int] NULL,
	[vl_com_desconto] [money] NULL,
	[vl_cmv] [decimal](20, 2) NULL,
	[vl_impostos] [decimal](20, 2) NULL,
	[vl_margem] [decimal](24, 4) NULL,
	[vl_margem_percent] [decimal](38, 14) NULL,
	[vl_cmd] [decimal](20, 2) NULL,
	[estoque_sige] [numeric](38, 0) NOT NULL,
	[cobertura] [decimal](20, 2) NULL,
	[ds_depto] [varchar](100) NULL,
	[ds_sector] [varchar](130) NULL,
	[Rank] [bigint] NULL,
	[contador] [bigint] NULL
)

DECLARE	@nr_depto     int

DECLARE c_report CURSOR FAST_FORWARD FOR 
	
select distinct b.nr_depto	
from rpt_indicador_orders a (nolock)
	inner join MIS_DW..ods_product b (nolock)
		on a.nr_item_sku = b.nr_item_sku
		and a.nr_product_sku = b.nr_product_sku
		and b.ds_item = 'Produto'
where a.dt_orders between convert(varchar,@dt_inicio,112) and convert(varchar,@dt_fim,112)		
	
OPEN c_report

	FETCH NEXT 
	FROM c_report 
	INTO
	  @nr_depto
    
    WHILE @@FETCH_STATUS = 0
	BEGIN	
		insert into #report
		select top 10 [nr_item_sku],[ds_product],[qty_item],[vl_com_desconto],[vl_cmv],
			[vl_impostos],[vl_margem],[vl_margem_percent],[vl_cmd],	[estoque_sige],
			[cobertura],[ds_depto],[ds_sector],[Rank],
		ROW_NUMBER() OVER(ORDER BY [vl_com_desconto] DESC) as contador 
		from #auxiliar
		where nr_depto = @nr_depto
		order by vl_com_desconto desc

	FETCH NEXT 
	FROM c_report 
	INTO
	  @nr_depto
	END
	
CLOSE c_report
DEALLOCATE c_report


select * from #report order by [ds_depto], [contador]

end


USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[stg_paway]    Script Date: 08/05/2014 20:11:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stg_paway]') AND type in (N'U'))
DROP TABLE [dbo].[stg_paway]
GO

USE [MIS_RELATORIO]
GO

/****** Object:  Table [dbo].[stg_paway]    Script Date: 08/05/2014 20:11:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[stg_paway](
	[ds_bloco] [varchar](10) NULL,
	[ds_marca] [varchar](10) NULL,
	[num_nfs] [numeric](38, 0) NULL,
	[vl_faturamento] [numeric](15, 2) NULL,
	[vl_meta] [numeric](15, 2) NULL,
	[vl_atingimento] [numeric](15, 2) NULL,
	[crescimento] [numeric](15, 2) NULL,
	[vl_faturamento_anterior] [numeric](15, 2) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

