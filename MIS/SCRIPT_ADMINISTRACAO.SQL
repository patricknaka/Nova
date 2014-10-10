--===============================
--CONEXÕES
--===============================

--MIS_LN
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('MIS_MIGRACAO', 
'Data Source=JUVENTUS-SQL\HSQLBI01;User ID=user_bi_hlg;PWD=biprd)(*123;Initial Catalog=MIS_LN;Provider=SQLNCLI10.1;Persist Security Info=True;Packet Size=8096;',
'\Package.Connections[MIS_MIGRACAO].Properties[ConnectionString]',
'String')

--LN
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('LN', 
'Data Source=DLN01;User ID=own_mis;PWD=ZLZNLAL#0013;Persist Security Info=False;Unicode=True;',
'\Package.Connections[LN].Properties[ConnectionString]',
'String')

--LN WMS
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('LN WMS', 
'Data Source=SCTST;PWD=ZLZNLAL#0013;User ID=INTEGRA_MIS;Unicode=True;',
'\Package.Connections[LN_WMS].Properties[ConnectionString]',
'String')

--loja corp hom
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('loja corp hom', 
'Data Source=10.128.132.18,1145;User ID=us_webstore_bi;PWD=intwebbi!@#;Initial Catalog=DB_HOM_CORP_NPC;Provider=SQLNCLI10.1;Auto Translate=False;',
'\Package.Connections[loja_corp_hom].Properties[ConnectionString]',
'String')

--MIS RELATORIO
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('mis relatorio', 
'Data Source=JUVENTUS-SQL\HSQLBI01;User ID=user_bi_hlg;PWD=biprd)(*123;Initial Catalog=mis_relatorio;Provider=SQLNCLI10.1;Auto Translate=False;',
'\Package.Connections[mis_relatorio].Properties[ConnectionString]',
'String')

--loja ata hom
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('loja ata hom', 
'Data Source=10.128.132.18,1145;User ID=us_webstore_bi;PWD=intwebbi!@#;Initial Catalog=DB_HOM_ATACADO_NPC;Provider=SQLNCLI10.1;Auto Translate=False;',
'\Package.Connections[loja_ata_hom].Properties[ConnectionString]',
'String')

--FILE_SHARED_DIM
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('FILE_SHARED_DIM', 
'W:\Operacional\SharedDimensionStaging_LN\SharedDimensionStaging_LN\',
'\Package.Variables[User::gstrFolderSD].Properties[Value]',
'String')

--FILE_STG_LN
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('FILE_STG_LN', 
'W:\Operacional\Processo de Carga LN\Processo de Carga LN\',
'\Package.Variables[User::gstrFolderLn].Properties[Value]',
'String')

--FILE_ADQUIRENTE
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('FILE_ADQUIRENTE', 
'W:\Operacional\Processo Adquirente\SSIS_ADQUIRENTE\',
'\Package.Variables[User::gstrFolderAdq].Properties[Value]',
'String')

--FILE_CAP_DEPTO
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('FILE_CAP_DEPTO', 
'W:\Operacional\CAP Departamento_LN\',
'\Package.Variables[User::gstrFolderCapDepto].Properties[Value]',
'String')

--FILE_LOJA
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('FILE_LOJA', 
'W:\Operacional\Processo de Carga LN\Processo de Carga LN\',
'\Package.Variables[User::gstrFolderLoja].Properties[Value]',
'String')

--FILE_CAP_LN
INSERT INTO [ADMINISTRACAO].[adm].[ssis_conexoes]
VALUES ('FILE_CAP_LN', 
'W:\Operacional\Contas a Pagar_LN\Contas a Pagar_LN\',
'\Package.Variables[User::gstrFolderCapLn].Properties[Value]',
'String')

--FILE_COCKORC
insert into adm.ssis_conexoes
values ('FILE_COCKORC',
'W:\Operacional\Cockpit Orçamento_LN\Cockpit Orçamento_LN\',
'\Package.Variables[User::gstrFolderCockOrc].Properties[Value]',
'String')

--MIS_OLAP
insert into adm.ssis_conexoes
values ('MIS_OLAP',
'Data Source=CRICIUMA01\DOLAPBI01;Initial Catalog=MIS_OLAP;Provider=MSOLAP.4;Integrated Security=SSPI;Impersonation Level=Impersonate;',
'\Package.Connections[MIS_OLAP].Properties[ConnectionString]',
'String')

--MIS
insert into adm.ssis_conexoes
values ('MIS',
'Data Source=CRICIUMA01\DOLAPBI01;Initial Catalog=MIS;Provider=MSOLAP.4;Integrated Security=SSPI;Impersonation Level=Impersonate;',
'\Package.Connections[MIS].Properties[ConnectionString]',
'String')

--FILE_INVSUPL
insert into adm.ssis_conexoes
values ('FILE_INVSUPL',
'W:\Operacional\Inventory Supplier_LN\Inventory Supplier_LN\',
'\Package.Variables[User::gstrFolderInvSupl].Properties[Value]',
'String')

--B2B_INTERNO
insert into adm.ssis_conexoes
values ('B2B_INTERNO',
'Data Source=10.128.132.18,1145;User ID=us_webstore_bi;PWD=intwebbi!@#;Initial Catalog=db_hom_pontofrio_b2b_interno;Provider=SQLNCLI10.1;Auto Translate=False;',
'\Package.Connections[db_hom_pontofrio_b2b_interno].Properties[ConnectionString]',
'String')

--FILE_PLANILHAO
insert into adm.ssis_conexoes
values ('FILE_PLANILHAO',
'W:\Operacional\Planilhao_LN\Planilhao_LN\',
'\Package.Variables[User::gstrFolderPlanilhao].Properties[Value]',
'String')

--=================================================
--inserção de colunas
--=================================================

alter table ADMINISTRACAO.adm.tb_ssis_modulo_processamento
add cd_modulo_pai int


insert ADMINISTRACAO.adm.tb_ssis_modulo_processamento
values (49,'stg_est_estoque_ln','2014-10-01','2014-10-01','2014-10-01','2014-01-01',1,null,8),
    (50,'stg_estoque_ln','2014-10-01','2014-10-01','2014-10-01','2014-01-01',1,null,8),
    (51,'stg_estoque_sige','2014-10-01','2014-10-01','2014-10-01','2014-01-01',1,null,8),
    (52,'stg_estabelecimento','2014-10-01','2014-10-01','2014-10-01','2014-01-01',1,null,8),
    (53,'ods_estoque_sige','2014-10-01','2014-10-01','2014-10-01','2014-01-01',1,null,8),
    (54,'dw_estoque_sige','2014-10-01','2014-10-01','2014-10-01','2014-01-01',1,null,8),
    (55,'ods_estoque_rateio_custo_logistico','2014-10-01','2014-10-01','2014-10-01','2014-01-01',1,null,8),
    (56,'olap_estoque_sige','2014-10-01','2014-10-01','2014-10-01','2014-01-01',1,null,8),
    (57,'olap-1_estoque_sige','2014-10-01','2014-10-01','2014-10-01','2014-01-01',1,null,8)

--===============================
--PROCEDURES
--===============================

USE [ADMINISTRACAO]
GO
/****** Object:  StoredProcedure [dbo].[SPU_EXECUTION_PACKAGE_CANCEL]    Script Date: 10/07/2014 11:20:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPU_EXECUTION_PACKAGE_CANCEL]
@EXECUTIONINSTANCE NVARCHAR(100),
@CDMODULO INT = null

AS
BEGIN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
--  cod_status = 0: Processando (Incompleto)  
--  cod_status = 1: Completo  
--  cod_status = 2: Falhou  
--  cod_status = 3: Tarefa cancelada pelo usuário  

--Valida se Processo entrou Auditoria Cancelamento
begin
		update adm.ssis_log
		set dt_end = GETDATE(),
			in_sucesso = 3
		where ds_guid = @EXECUTIONINSTANCE
	end
	begin	
		UPDATE adm.tb_ssis_modulo_processamento
		SET dt_fim_processamento = GETDATE(),
		in_sucesso = 3
		WHERE cd_modulo = @CDMODULO
		end
END

--===============================================================

USE [ADMINISTRACAO]
GO
/****** Object:  StoredProcedure [dbo].[SPU_EXECUTION_PACKAGE]    Script Date: 10/07/2014 11:23:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPU_EXECUTION_PACKAGE]
@EXECUTIONINSTANCE NVARCHAR(100),
@CDMODULO INT = null,
@ONLINE BIT = NULL,
@GBLNPROCESSAR bit = null
AS
BEGIN
--  cod_status = 0: Processando (Incompleto)  
--  cod_status = 1: Completo  
--  cod_status = 2: Falhou  
--  cod_status = 3: Tarefa cancelada pelo usuário  

--Valida se Processo entrou Auditoria Cancelamento

IF @GBLNPROCESSAR = 0
BEGIN

	
		update adm.ssis_log
		set dt_end = GETDATE(),
			in_sucesso = 3
		where ds_guid = @EXECUTIONINSTANCE
	
	
		UPDATE adm.tb_ssis_modulo_processamento
		SET dt_fim_processamento = GETDATE(),
		in_sucesso = 3
		WHERE cd_modulo = @CDMODULO
	
end

--ATUALIZA FIM PROCESSAMENTO

		update adm.ssis_log
		set dt_end = GETDATE(),
			in_sucesso = 1
		where ds_guid = @EXECUTIONINSTANCE


--Valida se Online esta ativO

IF @ONLINE = 1
	BEGIN
		update adm.tb_ssis_modulo_processamento
		set dt_fim_processamento = getdate(),
			dt_ultimo_processamento = getdate(),
			in_sucesso = 1,
			in_ativo = 0
		where cd_modulo = @CDMODULO
		
	END

END

--===============================================================

USE [ADMINISTRACAO]
GO
/****** Object:  StoredProcedure [dbo].[sp_atualizacao_ods_date]    Script Date: 10/07/2014 11:25:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_atualizacao_ods_date] (@dataInicio VARCHAR(10), @dataFim VARCHAR(10))

AS

/*Parâmetros

1)Data de Início que deseja popular. Ex: '2014-01-01'
2)Data de Início que deseja popular. Ex: '2014-12-31'

*/

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

WITH data AS (
	SELECT CAST(@dataInicio AS DATE) as dt
	UNION ALL
	SELECT DATEADD(dd,1,dt) FROM data WHERE dt < @dataFim
)

--insert into dbo.ods_date
SELECT  CONVERT(varchar(8), dt, 112) as nr_date,
		DATEPART(YEAR,dt) as nr_year,
		DATEPART(QQ,dt) as nr_quarter,
		'Quarter ' + CAST(DATEPART(qq,dt) as varchar(1))  as ds_quarter,
		MONTH(dt) as nr_month,
		DATENAME(MONTH, dt) as ds_month,
		DATEPART(DW,dt) as nr_dia_semana,
		CASE WHEN DATEPART(DW,dt) = 1 THEN 'Domingo'
			 WHEN DATEPART(DW,dt) = 2 THEN 'Segunda-feira'
			 WHEN DATEPART(DW,dt) = 3 THEN 'Terça-feira'
			 WHEN DATEPART(DW,dt) = 4 THEN 'Quarta-feira'
			 WHEN DATEPART(DW,dt) = 5 THEN 'Quinta-feira'
			 WHEN DATEPART(DW,dt) = 6 THEN 'Sexta-feira'
			 WHEN DATEPART(DW,dt) = 7 THEN 'Sábado' ELSE NULL END AS ds_dia_semana,
		DATEPART(DAYOFYEAR,dt) as nr_day,
		CONVERT(VARCHAR(10),dt,105) as dt_date
FROM data
OPTION (MAXRECURSION 0)

--===============================================================

USE [ADMINISTRACAO]
GO
/****** Object:  StoredProcedure [dbo].[sp_periodo_particao_pricing]    Script Date: 10/07/2014 11:26:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_periodo_particao_pricing] @periodo  varchar(50), @particao varchar(50)
as begin
 if(@periodo = 'Mensal')
 begin
  select
   min(nr_date) inicio,
   max(nr_date) fim,
   @particao + ' ' + cast(year(getdate()) as varchar) + ' M' + cast(datepart(mm, getdate()) as varchar)
  from
   mis_dw..dim_date
  where
  nr_month = datepart(mm, getdate())
   and nr_year = year(getdate())
 end
 if(@periodo = 'Trimestral')
 begin
  select
   min(nr_date) inicio,
   max(nr_date) fim,
   @particao + ' ' + cast(year(getdate()) as varchar) + ' Q' + cast(datepart(qq, getdate()) as varchar)
  from
   mis_dw..dim_date
  where
   nr_quarter = datepart(qq, getdate())
   and nr_year = year(getdate())
 end
 if(@periodo = 'Anual')
 begin
  select
   min(nr_date) inicio,
   max(nr_date) fim,
   @particao + ' Y' + cast(year(getdate()) as varchar)
  from
   mis_dw..dim_date
  where
   nr_year = year(getdate())
 end
end

--===============================================================

USE [ADMINISTRACAO]
GO
/****** Object:  StoredProcedure [dbo].[SPI_EXECUTION_PACKAGE]    Script Date: 10/07/2014 11:28:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPI_EXECUTION_PACKAGE]
@MACHINENAME VARCHAR(100),
@PACKAGENAME VARCHAR(100),
@EXECUTIONINSTANCE NVARCHAR(100),
@CODMODULO INT,
@EXEC bit = NULL output 
AS
BEGIN

--Insere Log Transacional de Execução dos Pacotes
INSERT ADM.ssis_log(cd_modulo,nm_server,nm_package,ds_guid,in_sucesso)
SELECT @CODMODULO,@MACHINENAME,@PACKAGENAME,@EXECUTIONINSTANCE,0


IF exists (SELECT 1 FROM (SELECT @CODMODULO AS MODULO,@PACKAGENAME AS PACK) T 
			INNER JOIN ADM.tb_ssis_modulo_processamento Y (nolock)
			ON T.MODULO = Y.cd_modulo)

BEGIN
set @EXEC = (select cast(in_ativo as bit) from ADMINISTRACAO.adm.tb_ssis_modulo_processamento (nolock) where cd_modulo = @CODMODULO)
END

--Valida se é controlador
IF EXISTS (select 1 from (select @PACKAGENAME as package)t where t.package like '%controlador%')

	begin
	--Atualiza dados de Processamento Controladores
	update adm.tb_ssis_modulo_processamento
	set dt_inicio_processamento = GETDATE(),
		in_sucesso = 0
	where cd_modulo = @CODMODULO

	--Retorna Pacote Ativo para Processamento
	--set @EXEC = (select cast(in_ativo as bit) from ADMINISTRACAO.adm.tb_ssis_modulo_processamento where cd_modulo = @CODMODULO)
	end

else

--Valida Stage Individual LN
IF EXISTS (select 1 from (select @CODMODULO as modulo)t where (t.modulo between 13 and 31 or t.modulo between 34 and 39 or t.modulo between 46 and 48 ))	

	begin
	--Atualiza dados de Processamento Stage Individual
	update adm.tb_ssis_modulo_processamento
	set dt_inicio_processamento = GETDATE(),
		in_sucesso = 0
	where cd_modulo = @CODMODULO

	--Retorna Pacote Ativo para Processamento
	--set @EXEC = (select cast(in_ativo as bit) from ADMINISTRACAO.adm.tb_ssis_modulo_processamento where cd_modulo = @CODMODULO)

	end

end

--===============================================================

USE [ADMINISTRACAO]
GO
/****** Object:  StoredProcedure [dbo].[SPS_RETORNA_DATA]    Script Date: 10/07/2014 11:29:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPS_RETORNA_DATA]
@CD_MODULO INT,
@DATA VARCHAR(20) output
AS
select 
@DATA =  CONVERT(DATETIME2(0),dt_base_processamento)
from adm.tb_ssis_modulo_processamento
where cd_modulo = @CD_MODULO

--===============================================================

USE [ADMINISTRACAO]
GO
/****** Object:  StoredProcedure [dbo].[SPU_DATA_BASE]    Script Date: 10/07/2014 11:30:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPU_DATA_BASE]
AS

UPDATE A
SET A.DT_BASE_PROCESSAMENTO = CASE WHEN B.IN_RECORRENCIA = 0 --D+1
									AND DT_ULTIMO_PROCESSAMENTO IS NOT NULL --ULTIMO PROCESSAMENTO EXECUTADO COM SUCESSO
									AND CONVERT(DATE,A.DT_BASE_PROCESSAMENTO) < CONVERT(DATE,GETDATE())	 --DATA BASE MENOR QUE DATA ATUAL
									
									THEN DATEADD(DAY,1,A.DT_BASE_PROCESSAMENTO) --INCREMENTA DATA
									
									ELSE
									(CASE WHEN B.IN_RECORRENCIA = 1 --D+0
										  AND B.DS_TIPO_RECORRENCIA = 'H' --RECORRENCIA HORA
										  AND A.DT_ULTIMO_PROCESSAMENTO IS NOT NULL --ULTIMO PROCESSAMENTO EXECUTADO COM SUCESSO
										  AND A.DT_ULTIMO_PROCESSAMENTO < A.DT_BASE_PROCESSAMENTO --DATA ULTIMO PROCESSAMENTO SEJA MENOR QUE DATA BASE
										  
										  THEN DATEADD(HOUR,B.NR_RECORRENCIA,A.DT_BASE_PROCESSAMENTO) --ATUALIZA INCREMENTANDO A HORA
										  
										  ELSE (CASE WHEN B.in_recorrencia = 1 --D+0
													 AND B.DS_TIPO_RECORRENCIA = 'M' -- RECORRENCIA MINUTO
													 AND A.DT_ULTIMO_PROCESSAMENTO IS NOT NULL -- ULTIMO PROCESSAMENTO EXECUTADO COM SUCESSO
													 AND A.DT_ULTIMO_PROCESSAMENTO < A.DT_BASE_PROCESSAMENTO --DATA ULTIMO PROCESSAMENTO SEJA MENOR QUE DATA BASE
													 
													 THEN DATEADD(M,B.NR_RECORRENCIA,A.DT_BASE_PROCESSAMENTO)--ATUALIZA INCREMENTANDO O MINUTO
													 
												ELSE A.DT_BASE_PROCESSAMENTO END)END)END
FROM ADM.TB_SSIS_MODULO_PROCESSAMENTO A
INNER JOIN ADM.TB_SSIS_EXEC_PROCESSAMENTO B
ON A.CD_MODULO = B.CD_MODULO

--===============================================================

USE [ADMINISTRACAO]
GO
/****** Object:  StoredProcedure [dbo].[SPU_FAILURE_EXECUTION]    Script Date: 10/07/2014 11:31:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPU_FAILURE_EXECUTION]
@EXECUTIONINSTANCE NVARCHAR(100),
@ERROR_DESCRIPTION VARCHAR(MAX),
@CDMODULO INT = null
AS
BEGIN
/*	Descrição Status Sucesso
  cod_status = 0: Processando (Incompleto)  
  cod_status = 1: Completo  
  cod_status = 2: Falhou  
  cod_status = 3: Tarefa cancelada pelo usuário  
*/

--Atualiza Log do Pacote que houve Falha
begin
UPDATE adm.ssis_log
SET in_sucesso = 2,
	nm_error = @ERROR_DESCRIPTION
WHERE ds_guid = @EXECUTIONINSTANCE
END


begin
--Atualiza Módulo Controlador que houve Falha
update adm.tb_ssis_modulo_processamento
set dt_ultimo_processamento = null,
	in_sucesso = 2,
	dt_fim_processamento = GETDATE()
where cd_modulo = @CDMODULO
end

end

--===============================
--TABELAS
--===============================

USE [ADMINISTRACAO]
GO

/****** Object:  Table [adm].[ssis_log]    Script Date: 10/07/2014 11:32:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [adm].[ssis_log](
	[nr_execucao] [bigint] IDENTITY(1,1) NOT NULL,
	[cd_modulo] [int] NULL,
	[nm_server] [varchar](100) NULL,
	[nm_package] [varchar](100) NULL,
	[ds_guid] [nvarchar](100) NULL,
	[dt_start] [datetime] NULL,
	[dt_end] [datetime] NULL,
	[in_sucesso] [int] NULL,
	[nm_error] [varchar](max) NULL,
	[nr_gr_execucao] [bigint] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [adm].[ssis_log] ADD  DEFAULT (getdate()) FOR [dt_start]
GO

--===============================================================

USE [ADMINISTRACAO]
GO

/****** Object:  Table [adm].[tb_ssis_modulo_processamento]    Script Date: 10/07/2014 11:35:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [adm].[tb_ssis_modulo_processamento](
	[cd_modulo] [int] NULL,
	[ds_pacote] [varchar](100) NULL,
	[dt_inicio_processamento] [datetime] NULL,
	[dt_fim_processamento] [datetime] NULL,
	[dt_ultimo_processamento] [datetime] NULL,
	[dt_base_processamento] [datetime] NULL,
	[in_ativo] [bit] NULL,
	[in_sucesso] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--===============================================================

USE [ADMINISTRACAO]
GO

/****** Object:  Table [adm].[tb_ssis_modulo]    Script Date: 10/07/2014 11:36:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [adm].[tb_ssis_modulo](
	[cd_modulo] [int] IDENTITY(1,1) NOT NULL,
	[ds_modulo] [varchar](50) NULL,
	[in_ativo] [bit] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [adm].[tb_ssis_modulo] ADD  DEFAULT ((0)) FOR [in_ativo]
GO

--===============================================================

USE [ADMINISTRACAO]
GO

/****** Object:  Table [adm].[tb_ssis_exec_processamento]    Script Date: 10/07/2014 11:39:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [adm].[tb_ssis_exec_processamento](
	[cd_modulo] [int] NULL,
	[in_recorrencia] [bit] NULL,
	[ds_tipo_recorrencia] [char](1) NULL,
	[nr_recorrencia] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--===============================================================

USE [ADMINISTRACAO]
GO

/****** Object:  Table [adm].[tbp_function]    Script Date: 10/07/2014 11:41:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [adm].[tbp_function](
	[id_function] [int] IDENTITY(1,1) NOT NULL,
	[ds_function] [varchar](100) NULL,
	[id_tabela] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--===============================================================

USE [ADMINISTRACAO]
GO

/****** Object:  Table [adm].[tbp_scheme]    Script Date: 10/07/2014 11:42:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [adm].[tbp_scheme](
	[id_scheme] [int] IDENTITY(1,1) NOT NULL,
	[ds_scheme] [varchar](100) NULL,
	[id_function] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--===============================================================

USE [ADMINISTRACAO]
GO

/****** Object:  Table [adm].[tbp_tabela]    Script Date: 10/07/2014 11:43:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [adm].[tbp_tabela](
	[id_tabela] [int] IDENTITY(1,1) NOT NULL,
	[ds_tabela] [varchar](100) NULL,
	[nr_ultima_particao] [int] NULL,
	[nr_range_ultima_particao] [varchar](20) NULL,
	[in_compressao] [bit] NULL,
	[in_tipo_particao] [char](1) NULL,
	[ds_database] [varchar](20) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [adm].[tbp_tabela] ADD  DEFAULT ((0)) FOR [in_compressao]
GO

--===============================================================

USE [ADMINISTRACAO]
GO

/****** Object:  Table [adm].[tbp_tabela_aux]    Script Date: 10/07/2014 11:44:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [adm].[tbp_tabela_aux](
	[id_tabela] [int] IDENTITY(1,1) NOT NULL,
	[ds_tabela] [varchar](100) NULL,
	[nr_ultima_particao] [int] NULL,
	[id_tabela_switch] [int] NULL,
	[ds_coluna_filtro] [varchar](100) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO











