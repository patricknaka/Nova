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

-------------------------------------------------------------------------------

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
---------------------------------------------------------------------------------


ALTER proc [dbo].[pr_relatorio_orders_parceiro](@dt_inicio int,@dt_fim int)
as
begin
IF OBJECT_ID('tempdb..#report') IS NOT NULL DROP TABLE #report

CREATE TABLE #report(
	[nr_item_sku] [bigint] NULL,
	[qty_item] [int] NULL,
	[vl_com_desconto] [money] NULL,
	[vl_cmv] [decimal](20, 2) NULL,
	[vl_impostos] [decimal](20, 2) NULL,
	[vl_margem] [decimal](24, 4) NULL,
	[vl_margem_percent] [decimal](38, 14) NULL,
	[vl_cmd] [decimal](20, 2) NULL,
	[estoque_sige] [numeric](38, 0) NOT NULL,
	[cobertura] [decimal](20, 2) NULL,
	[ds_parceiro] [varchar](100) NULL,
	[Rank] [bigint] NULL,
	[ds_product] [varchar](150) NULL,
	[ds_depto] [varchar](100) NULL,
	[ds_sector] [varchar](130) NULL,
	[contador] [bigint] NULL,
	[ordem] [smallint] null
)

DECLARE	@nr_parceiro     int
DECLARE @vl_com_desconto money
DECLARE @contador smallint

set @contador= 0

DECLARE c_report CURSOR FAST_FORWARD FOR 
	
select top 10 nr_parceiro,vl_com_desconto
from (
		select nr_parceiro, SUM(vl_com_desconto) as vl_com_desconto
		from [rpt_indicador_orders_parceiro] (nolock)
		where dt_orders between convert(varchar,@dt_inicio,112) and convert(varchar,@dt_fim,112)		
		group by nr_parceiro) a
order by vl_com_desconto desc	
	
OPEN c_report

	FETCH NEXT 
	FROM c_report 
	INTO
	  @nr_parceiro,
	  @vl_com_desconto
    
    WHILE @@FETCH_STATUS = 0
	BEGIN	
		set @contador = @contador + 1
	    insert into #report
		select top 10 b.*, c.ds_product, c.ds_depto, c.ds_sector,
		ROW_NUMBER() OVER(ORDER BY b.vl_com_desconto DESC) as contador,  @contador as ordem
		from (
		select 
		aa.nr_item_sku,
		aa.qty_item,
		aa.vl_com_desconto,
		aa.vl_cmv,
		aa.vl_impostos,
		aa.vl_com_desconto - (aa.vl_cmv+aa.vl_impostos) as vl_margem,
		((aa.vl_com_desconto - (aa.vl_cmv+aa.vl_impostos))/aa.vl_com_desconto) as vl_margem_percent,
		aa.vl_cmd,
		aa.estoque_sige,
		aa.cobertura,
		aa.ds_parceiro,
		DENSE_RANK() OVER (ORDER BY aa.vl_com_desconto - (aa.vl_cmv+aa.vl_impostos) desc) AS 'Rank'
		from (
		select 
		a.nr_item_sku,
		sum(a.qty_item) as qty_item,
		sum(a.vl_com_desconto) as vl_com_desconto,
		cast(sum(a.qty_item) * isnull(cm.vl_cmv,0) as decimal(20,2)) as vl_cmv, 
		case when imp.vl_percent_imposto = null then 
		cast(sum(a.vl_com_desconto) * 0.2725 as decimal(20,2))
		else
		cast(sum(a.vl_com_desconto) * imp.vl_percent_imposto as decimal(20,2)) end as vl_impostos, 
		cast(e.vl_cmd as decimal(20,2)) as vl_cmd,
		isnull(f.qt_saldo,0) as estoque_sige,
		case when vl_cmd = 0 then 0 else cast((isnull(f.qt_saldo,0) / e.vl_cmd) as decimal(20,2)) end as cobertura,
		pa.ds_parceiro
		from rpt_indicador_orders_parceiro a  (nolock)
			inner join mis_dw..dim_parceiro pa  (nolock)
				on pa.nr_id_parceiro = a.nr_parceiro
			left join mis_dw..stg_sige_estoque_cmd e  (nolock)
				on e.nr_item_sku = a.nr_item_sku
				and e.nr_product_sku = a.nr_product_sku
			left join (select es.nr_item_sku,SUM(es.qt_saldo) as qt_saldo
						from MIS_DW..vw_fact_estoque_sige es  (nolock)
							left join MIS_DW..dim_estoque_tipo_bloqueio ed  (nolock)
							on es.id_tipo_bloqueio = ed.id_tipo_bloqueio
						where ed.ds_tipo_bloqueio = 'WN'
						and es.id_filial <> 3
						group by es.nr_item_sku) f
				on f.nr_item_sku = a.nr_item_sku
			left join mis_dw..stg_cl_cmv cm  (nolock)
				on a.nr_item_sku = cm.nr_item
			left join aux_indicador_orders_imposto imp  (nolock)
				on imp.nr_item_sku = a.nr_item_sku
				and imp.nr_product_sku = a.nr_product_sku
		where a.dt_orders between convert(varchar,@dt_inicio,112) and convert(varchar,@dt_fim,112)		
		and a.nr_parceiro = @nr_parceiro
		group by a.nr_item_sku,
		e.vl_cmd,f.qt_saldo, cm.vl_cmv, imp.vl_percent_imposto,pa.ds_parceiro
		)aa
		)b
		inner join MIS_DW..ods_product c
			on b.nr_item_sku = c.nr_item_sku
			and c.ds_item = 'Produto'
		order by b.vl_com_desconto desc

	FETCH NEXT 
	FROM c_report 
	INTO
	  @nr_parceiro,
	  @vl_com_desconto
	END
	
CLOSE c_report
DEALLOCATE c_report

select * from #report order by [ordem], [contador]
end
-------------------------------------------------------------------------------------


ALTER proc [dbo].[pr_relatorio_orders_unineg_parceiro](@dt_inicio int,@dt_fim int, @unineg varchar(30))
as
begin
IF OBJECT_ID('tempdb..#report') IS NOT NULL DROP TABLE #report

CREATE TABLE #report(
	[nr_item_sku] [bigint] NULL,
	[qty_item] [int] NULL,
	[vl_com_desconto] [money] NULL,
	[vl_cmv] [decimal](20, 2) NULL,
	[vl_impostos] [decimal](20, 2) NULL,
	[vl_margem] [decimal](24, 4) NULL,
	[vl_margem_percent] [decimal](38, 14) NULL,
	[vl_cmd] [decimal](20, 2) NULL,
	[estoque_sige] [numeric](38, 0) NOT NULL,
	[cobertura] [decimal](20, 2) NULL,
	[ds_parceiro] [varchar](100) NULL,
	[Rank] [bigint] NULL,
	[ds_product] [varchar](150) NULL,
	[ds_depto] [varchar](100) NULL,
	[ds_sector] [varchar](130) NULL,
	[contador] [bigint] NULL,
	[ordem] [smallint] null
)

IF OBJECT_ID('tempdb..#unineg') IS NOT NULL DROP TABLE #unineg

SELECT cast(items as int) as unineg into #unineg
FROM MIS_DW..Split(@unineg,';')

DECLARE	@nr_parceiro     int
DECLARE @vl_com_desconto money
DECLARE @contador smallint

set @contador= 0

DECLARE c_report CURSOR FAST_FORWARD FOR 
	
select top 10 nr_parceiro,vl_com_desconto
from (
		select nr_parceiro, SUM(vl_com_desconto) as vl_com_desconto
		from rpt_indicador_orders_unineg_parceiro (nolock)
		where dt_orders between convert(varchar,@dt_inicio,112) and convert(varchar,@dt_fim,112)	
		and nr_id_unidade_negocio in(select unineg from #unineg)	
		group by nr_parceiro) a
order by vl_com_desconto desc	
	
OPEN c_report

	FETCH NEXT 
	FROM c_report 
	INTO
	  @nr_parceiro,
	  @vl_com_desconto
    
    WHILE @@FETCH_STATUS = 0
	BEGIN	
		set @contador = @contador + 1
	    insert into #report
		select top 20 b.*, c.ds_product, c.ds_depto, c.ds_sector,
		ROW_NUMBER() OVER(ORDER BY b.vl_com_desconto DESC) as contador,  @contador as ordem
		from (
		select 
		aa.nr_item_sku,
		aa.qty_item,
		aa.vl_com_desconto,
		aa.vl_cmv,
		aa.vl_impostos,
		aa.vl_com_desconto - (aa.vl_cmv+aa.vl_impostos) as vl_margem,
		((aa.vl_com_desconto - (aa.vl_cmv+aa.vl_impostos))/aa.vl_com_desconto) as vl_margem_percent,
		aa.vl_cmd,
		aa.estoque_sige,
		aa.cobertura,
		aa.ds_parceiro,
		DENSE_RANK() OVER (ORDER BY aa.vl_com_desconto - (aa.vl_cmv+aa.vl_impostos) desc) AS 'Rank'
		from (
		select 
		a.nr_item_sku,
		sum(a.qty_item) as qty_item,
		sum(a.vl_com_desconto) as vl_com_desconto,
		cast(sum(a.qty_item) * isnull(cm.vl_cmv,0) as decimal(20,2)) as vl_cmv, 
		case when imp.vl_percent_imposto = null then 
		cast(sum(a.vl_com_desconto) * 0.2725 as decimal(20,2))
		else
		cast(sum(a.vl_com_desconto) * imp.vl_percent_imposto as decimal(20,2)) end as vl_impostos, 
		cast(e.vl_cmd as decimal(20,2)) as vl_cmd,
		isnull(f.qt_saldo,0) as estoque_sige,
		case when vl_cmd = 0 then 0 else cast((isnull(f.qt_saldo,0) / e.vl_cmd) as decimal(20,2)) end as cobertura,
		pa.ds_parceiro
		from rpt_indicador_orders_unineg_parceiro a  (nolock)
			inner join mis_dw..dim_parceiro pa  (nolock)
				on pa.nr_id_parceiro = a.nr_parceiro
			left join mis_dw..stg_sige_estoque_cmd e  (nolock)
				on e.nr_item_sku = a.nr_item_sku
				and e.nr_product_sku = a.nr_product_sku
			left join (select es.nr_item_sku,SUM(es.qt_saldo) as qt_saldo
						from MIS_DW..vw_fact_estoque_sige es  (nolock)
							left join MIS_DW..dim_estoque_tipo_bloqueio ed  (nolock)
							on es.id_tipo_bloqueio = ed.id_tipo_bloqueio
						where ed.ds_tipo_bloqueio = 'WN'
						and es.id_filial <> 3
						group by es.nr_item_sku) f
				on f.nr_item_sku = a.nr_item_sku
			left join mis_dw..stg_cl_cmv cm  (nolock)
				on a.nr_item_sku = cm.nr_item
			left join aux_indicador_orders_imposto imp  (nolock)
				on imp.nr_item_sku = a.nr_item_sku
				and imp.nr_product_sku = a.nr_product_sku
		where a.dt_orders between convert(varchar,@dt_inicio,112) and convert(varchar,@dt_fim,112)		
		and a.nr_parceiro = @nr_parceiro
		and nr_id_unidade_negocio in(select unineg from #unineg)	
		group by a.nr_item_sku,
		e.vl_cmd,f.qt_saldo, cm.vl_cmv, imp.vl_percent_imposto,pa.ds_parceiro
		)aa
		)b
		inner join MIS_DW..ods_product c
			on b.nr_item_sku = c.nr_item_sku
			and c.ds_item = 'Produto'
		order by b.vl_com_desconto desc

	FETCH NEXT 
	FROM c_report 
	INTO
	  @nr_parceiro,
	  @vl_com_desconto
	END
	
CLOSE c_report
DEALLOCATE c_report

select * from #report order by [ordem], [contador]
end
----------------------------------------------------------------------------------

ALTER proc [dbo].[pr_relatorio_faturamento_depto](@dt_inicio int,@dt_fim int)
as
begin

IF OBJECT_ID('tempdb..#auxiliar') IS NOT NULL DROP TABLE #auxiliar
select * ,
	ROW_NUMBER() OVER(ORDER BY A.VL_NOTA DESC) as contador into #auxiliar
	from 
	(
	select t.ID_ITEM, 
	d.DS_ITEM,
	SUM(t.VL_NOTA) as VL_NOTA,
	SUM(t.VL_REC_LIQ_PROD) as VL_REC_LIQ_PROD,
	SUM(t.VL_CMV) as VL_CMV,
	SUM(t.QTD_ITENS) as QTD_ITENS,
	SUM(t.VL_REC_LIQ_PROD) - SUM(t.VL_CMV) as vl_rec_liq,
	case when SUM(t.VL_REC_LIQ_PROD) =0 then 0 else
	((SUM(t.VL_REC_LIQ_PROD) - SUM(t.VL_CMV))/SUM(t.VL_REC_LIQ_PROD)) end as vl_rec_liq_percent,
	cast(e.vl_cmd as decimal(20,2)) as vl_cmd,
	isnull(f.qt_saldo,0) as estoque_sige,
	case when vl_cmd = 0 then 0 else cast((isnull(f.qt_saldo,0) / e.vl_cmd) as decimal(20,2)) end as cobertura,
	d.DS_DEPTO,
	d.DS_SETOR,
	DENSE_RANK() OVER (ORDER BY SUM(t.VL_REC_LIQ_PROD) - SUM(t.VL_CMV) desc) AS 'Rank'
	from MIS_RELATORIO..rpt_indicador_rentabilidade t (nolock)
		inner join MIS_RENTAB..dim_item d (nolock)
		on d.ID_ITEM = t.ID_ITEM
		left join MIS_RELATORIO..ods_relatorio_cmd e (nolock)
		on e.nr_item_sku = t.ID_ITEM
		left join (select es.nr_item_sku,SUM(es.qt_saldo) as qt_saldo
					from MIS_DW..vw_fact_estoque_sige es
						left join MIS_DW..dim_estoque_tipo_bloqueio ed
						on es.id_tipo_bloqueio = ed.id_tipo_bloqueio
					where ed.ds_tipo_bloqueio = 'WN'
					and es.id_filial <> 3
					group by es.nr_item_sku) f
		on f.nr_item_sku = t.ID_ITEM
	where t.dt_fat between convert(varchar,@dt_inicio,112) and convert(varchar,@dt_fim,112)
	group by t.ID_ITEM,d.DS_ITEM,d.DS_DEPTO,e.vl_cmd,f.qt_saldo,d.DS_SETOR
	) A
	order by A.VL_NOTA desc


IF OBJECT_ID('tempdb..#report') IS NOT NULL DROP TABLE #report

CREATE TABLE #report(
	[ID_ITEM] [numeric](18, 0) NOT NULL,
	[DS_ITEM] [varchar](50) NOT NULL,
	[VL_NOTA] [numeric](38, 2) NULL,
	[VL_REC_LIQ_PROD] [numeric](38, 2) NULL,
	[VL_CMV] [numeric](38, 2) NULL,
	[QTD_ITENS] [numeric](38, 0) NULL,
	[vl_rec_liq] [numeric](38, 2) NULL,
	[vl_rec_liq_percent] [numeric](38, 6) NULL,
	[vl_cmd] [decimal](20, 2) NULL,
	[estoque_sige] [numeric](38, 0) NOT NULL,
	[cobertura] [decimal](20, 2) NULL,
	[DS_DEPTO] [varchar](50) NOT NULL,
	[DS_SETOR] [varchar](50) NOT NULL,
	[Rank] [bigint] NULL,
	[contador] [bigint] NULL
)

DECLARE	@nr_depto  varchar(50)

DECLARE c_report CURSOR FAST_FORWARD FOR 
	
select distinct d.DS_DEPTO
from MIS_RELATORIO..rpt_indicador_rentabilidade t (nolock)
	inner join MIS_RENTAB..dim_item d (nolock)
	on d.ID_ITEM = t.ID_ITEM
where t.dt_fat between convert(varchar,@dt_inicio,112) and convert(varchar,@dt_fim,112)	
	
OPEN c_report

	FETCH NEXT 
	FROM c_report 
	INTO
	  @nr_depto
    
    WHILE @@FETCH_STATUS = 0
	BEGIN	
	
	insert into #report
	select top 50 [ID_ITEM],[DS_ITEM],[VL_NOTA],[VL_REC_LIQ_PROD],[VL_CMV],[QTD_ITENS],[vl_rec_liq],[vl_rec_liq_percent],
	[vl_cmd],[estoque_sige],[cobertura],[DS_DEPTO],[DS_SETOR],[Rank],
	ROW_NUMBER() OVER(ORDER BY VL_NOTA DESC) as contador 
	from #auxiliar
	where [DS_DEPTO] = @nr_depto
	order by VL_NOTA desc


	FETCH NEXT 
	FROM c_report 
	INTO
	  @nr_depto
	END
	
CLOSE c_report
DEALLOCATE c_report


select * from #report order by [DS_DEPTO], [contador]

end
------------------------------------------------------------------------------------


ALTER proc [dbo].[pr_relatorio_faturamento_depto_unineg](@dt_inicio int,@dt_fim int, @ds_unineg varchar(50))
as
begin


IF OBJECT_ID('tempdb..#auxiliar') IS NOT NULL DROP TABLE #auxiliar
select * ,
	ROW_NUMBER() OVER(ORDER BY A.VL_NOTA DESC) as contador into #auxiliar
	from 
	(
	select t.ID_ITEM, 
	d.DS_ITEM,
	SUM(t.VL_NOTA) as VL_NOTA,
	SUM(t.VL_REC_LIQ_PROD) as VL_REC_LIQ_PROD,
	SUM(t.VL_CMV) as VL_CMV,
	SUM(t.QTD_ITENS) as QTD_ITENS,
	SUM(t.VL_REC_LIQ_PROD) - SUM(t.VL_CMV) as vl_rec_liq,
	case when SUM(t.VL_REC_LIQ_PROD) =0 then 0 else
	((SUM(t.VL_REC_LIQ_PROD) - SUM(t.VL_CMV))/SUM(t.VL_REC_LIQ_PROD)) end as vl_rec_liq_percent,
	cast(e.vl_cmd as decimal(20,2)) as vl_cmd,
	isnull(f.qt_saldo,0) as estoque_sige,
	case when vl_cmd = 0 then 0 else cast((isnull(f.qt_saldo,0) / e.vl_cmd) as decimal(20,2)) end as cobertura,
	d.DS_DEPTO,
	d.DS_SETOR,
	DENSE_RANK() OVER (ORDER BY SUM(t.VL_REC_LIQ_PROD) - SUM(t.VL_CMV) desc) AS 'Rank',
    un.DS_UNINEG
	from MIS_RELATORIO..rpt_indicador_rentabilidade t (nolock)
		inner join MIS_RENTAB..dim_item d (nolock)
		on d.ID_ITEM = t.ID_ITEM
		inner join MIS_RENTAB..dim_unineg un (nolock)
		on un.ID_UNINEG = t.ID_UNINEG
		left join MIS_RELATORIO..ods_relatorio_cmd e (nolock)
		on e.nr_item_sku = t.ID_ITEM
		left join (select es.nr_item_sku,SUM(es.qt_saldo) as qt_saldo
					from MIS_DW..vw_fact_estoque_sige es
						left join MIS_DW..dim_estoque_tipo_bloqueio ed
						on es.id_tipo_bloqueio = ed.id_tipo_bloqueio
					where ed.ds_tipo_bloqueio = 'WN'
					and es.id_filial <> 3
					group by es.nr_item_sku) f
		on f.nr_item_sku = t.ID_ITEM
	where t.dt_fat between convert(varchar,@dt_inicio,112) and convert(varchar,@dt_fim,112)
	and un.DS_UNINEG = @ds_unineg
	group by t.ID_ITEM,d.DS_ITEM,d.DS_DEPTO,e.vl_cmd,f.qt_saldo,d.DS_SETOR,un.DS_UNINEG
	) A
	order by A.VL_NOTA desc
	
IF OBJECT_ID('tempdb..#report') IS NOT NULL DROP TABLE #report

CREATE TABLE #report(
	[ID_ITEM] [numeric](18, 0) NOT NULL,
	[DS_ITEM] [varchar](50) NOT NULL,
	[VL_NOTA] [numeric](38, 2) NULL,
	[VL_REC_LIQ_PROD] [numeric](38, 2) NULL,
	[VL_CMV] [numeric](38, 2) NULL,
	[QTD_ITENS] [numeric](38, 0) NULL,
	[vl_rec_liq] [numeric](38, 2) NULL,
	[vl_rec_liq_percent] [numeric](38, 6) NULL,
	[vl_cmd] [decimal](20, 2) NULL,
	[estoque_sige] [numeric](38, 0) NOT NULL,
	[cobertura] [decimal](20, 2) NULL,
	[DS_DEPTO] [varchar](50) NOT NULL,
	[DS_SETOR] [varchar](50) NOT NULL,
	[Rank] [bigint] NULL,
	[contador] [bigint] NULL,
	DS_UNINEG [varchar](50)
)

DECLARE	@nr_depto  varchar(50)
DECLARE	@unineg  varchar(50)

DECLARE c_report CURSOR FAST_FORWARD FOR 
	
select distinct d.DS_DEPTO
from MIS_RELATORIO..rpt_indicador_rentabilidade t (nolock)
	inner join MIS_RENTAB..dim_item d (nolock)
	on d.ID_ITEM = t.ID_ITEM
where t.dt_fat between convert(varchar,@dt_inicio,112) and convert(varchar,@dt_fim,112)	
	
OPEN c_report

	FETCH NEXT 
	FROM c_report 
	INTO
	  @nr_depto
    
    WHILE @@FETCH_STATUS = 0
	BEGIN	
	
	insert into #report
	select top 50 [ID_ITEM],[DS_ITEM],[VL_NOTA],[VL_REC_LIQ_PROD],[VL_CMV],[QTD_ITENS],[vl_rec_liq],[vl_rec_liq_percent],
	[vl_cmd],[estoque_sige],[cobertura],[DS_DEPTO],[DS_SETOR],[Rank],
	ROW_NUMBER() OVER(ORDER BY VL_NOTA DESC) as contador,DS_UNINEG
	from #auxiliar
	where [DS_DEPTO] = @nr_depto
	order by VL_NOTA desc


	FETCH NEXT 
	FROM c_report 
	INTO
	  @nr_depto
	END
	
CLOSE c_report
DEALLOCATE c_report


select * from #report order by DS_UNINEG, [DS_DEPTO], [contador]

end


alter table dbo.stg_sige_arquivo_conciliacao
alter column PEAP_NSU_AUTORIZADORA numeric(10,0)