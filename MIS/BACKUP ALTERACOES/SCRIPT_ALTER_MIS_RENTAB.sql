/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_ods_orders_profitable
	(
	VL_PROD money NOT NULL,
	VL_FRETE money NOT NULL,
	VL_CUSTO_FRETE money NOT NULL,
	VL_DESCONTO money NOT NULL,
	VL_DESC_INC money NOT NULL,
	VL_DESC_COND money NOT NULL,
	VL_NOTA money NOT NULL,
	VL_CMV money NOT NULL,
	VL_ICMS money NOT NULL,
	VL_PIS money NOT NULL,
	VL_CSLL money NOT NULL,
	VL_COFINS money NOT NULL,
	VL_ICMS_PROD money NOT NULL,
	VL_PIS_PROD money NOT NULL,
	VL_CSLL_PROD money NOT NULL,
	VL_COFINS_PROD money NOT NULL,
	VL_AVP money NULL,
	ID_DATA_FAT int NOT NULL,
	ID_DATA_PED int NOT NULL,
	ID_UNINEG int NOT NULL,
	ID_ITEM numeric(18, 0) NOT NULL,
	ID_REGIAO int NOT NULL,
	ID_TRANSP int NOT NULL,
	TIPO_ENTREGA varchar(50) NOT NULL,
	TIPO_TRANSP varchar(50) NOT NULL,
	ID_CANAL int NOT NULL,
	ID_PAGTO int NOT NULL,
	VL_TARIFA_CC money NOT NULL,
	VL_COTACAO money NOT NULL,
	VL_PARCELACALC money NOT NULL,
	VL_TARIFA money NOT NULL,
	ID_CAMPANHA int NOT NULL,
	VL_PESO_REAL money NOT NULL,
	VL_PESO_CUBADO money NOT NULL,
	VL_CUBAGEM money NOT NULL,
	QTD_ITENS int NOT NULL,
	VL_ICMS_FRETE money NOT NULL,
	VL_PIS_FRETE money NOT NULL,
	VL_COFINS_FRETE money NOT NULL,
	VL_CSLL_FRETE money NOT NULL,
	ID_PED_SIGE numeric(12, 0) NOT NULL,
	ID_FORN int NOT NULL,
	ID_LC bit NOT NULL,
	ID_FRETE_GRATIS bit NOT NULL,
	ID_ORIGEM int NOT NULL,
	ID_FILIAL int NULL,
	filegroup_nr_mes tinyint NULL,
	VL_REC_LIQ_PROD money NULL,
	VL_ICMS_OTHERS money NULL,
	VL_PIS_OTHERS money NULL,
	VL_COFINS_OTHERS money NULL,
	VL_CSLL_OTHERS money NULL,
	VL_ICMS_ST money NULL,
	VL_JUROS_EMISSOR money NULL,
	VL_JUROS_ESTAB money NULL,
	ID_VENDEDOR int NULL,
	ID_JUROS smallint NULL,
	ID_TIPO_CLIENTE smallint NULL,
	ID_CLIENTE_CORP int NULL,
	YN_MARGEM_NEGATIVA bit NULL,
	NR_ID_CONTRATO_B2B int NULL,
	NR_ID_CAMPANHA_B2B int NULL,
	ID_CLIENTE_FAT_B2B numeric(14, 0) NULL,
	NR_ID_PARCEIRO_MKT int NULL,
	VL_CRED_PRESUMIDO numeric(15, 4) NULL,
	UF_ENTREGA varchar(2) NULL,
	CFOP_ITEM numeric(5, 0) NULL,
	VL_CMV_ORIGINAL money NULL,
	VL_DESPREZO_CRED money NULL,
	ID_PARCEIRO_B2B int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ods_orders_profitable SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ods_orders_profitable)
	 EXEC('INSERT INTO dbo.Tmp_ods_orders_profitable (VL_PROD, VL_FRETE, VL_CUSTO_FRETE, VL_DESCONTO, VL_DESC_INC, VL_DESC_COND, VL_NOTA, VL_CMV, VL_ICMS, VL_PIS, VL_CSLL, VL_COFINS, VL_ICMS_PROD, VL_PIS_PROD, VL_CSLL_PROD, VL_COFINS_PROD, VL_AVP, ID_DATA_FAT, ID_DATA_PED, ID_UNINEG, ID_ITEM, ID_REGIAO, ID_TRANSP, TIPO_ENTREGA, TIPO_TRANSP, ID_CANAL, ID_PAGTO, VL_TARIFA_CC, VL_COTACAO, VL_PARCELACALC, VL_TARIFA, ID_CAMPANHA, VL_PESO_REAL, VL_PESO_CUBADO, VL_CUBAGEM, QTD_ITENS, VL_ICMS_FRETE, VL_PIS_FRETE, VL_COFINS_FRETE, VL_CSLL_FRETE, ID_PED_SIGE, ID_FORN, ID_LC, ID_FRETE_GRATIS, ID_ORIGEM, ID_FILIAL, filegroup_nr_mes, VL_REC_LIQ_PROD, VL_ICMS_OTHERS, VL_PIS_OTHERS, VL_COFINS_OTHERS, VL_CSLL_OTHERS, VL_ICMS_ST, VL_JUROS_EMISSOR, VL_JUROS_ESTAB, ID_VENDEDOR, ID_JUROS, ID_TIPO_CLIENTE, ID_CLIENTE_CORP, YN_MARGEM_NEGATIVA, NR_ID_CONTRATO_B2B, NR_ID_CAMPANHA_B2B, ID_CLIENTE_FAT_B2B, NR_ID_PARCEIRO_MKT, VL_CRED_PRESUMIDO, UF_ENTREGA, CFOP_ITEM, VL_CMV_ORIGINAL, VL_DESPREZO_CRED, ID_PARCEIRO_B2B)
		SELECT CONVERT(money, VL_PROD), CONVERT(money, VL_FRETE), CONVERT(money, VL_CUSTO_FRETE), CONVERT(money, VL_DESCONTO), CONVERT(money, VL_DESC_INC), CONVERT(money, VL_DESC_COND), CONVERT(money, VL_NOTA), CONVERT(money, VL_CMV), CONVERT(money, VL_ICMS), CONVERT(money, VL_PIS), CONVERT(money, VL_CSLL), CONVERT(money, VL_COFINS), CONVERT(money, VL_ICMS_PROD), CONVERT(money, VL_PIS_PROD), CONVERT(money, VL_CSLL_PROD), CONVERT(money, VL_COFINS_PROD), CONVERT(money, VL_AVP), ID_DATA_FAT, ID_DATA_PED, ID_UNINEG, ID_ITEM, ID_REGIAO, ID_TRANSP, TIPO_ENTREGA, TIPO_TRANSP, ID_CANAL, ID_PAGTO, CONVERT(money, VL_TARIFA_CC), CONVERT(money, VL_COTACAO), CONVERT(money, VL_PARCELACALC), CONVERT(money, VL_TARIFA), ID_CAMPANHA, CONVERT(money, VL_PESO_REAL), CONVERT(money, VL_PESO_CUBADO), CONVERT(money, VL_CUBAGEM), CONVERT(int, QTD_ITENS), CONVERT(money, VL_ICMS_FRETE), CONVERT(money, VL_PIS_FRETE), CONVERT(money, VL_COFINS_FRETE), CONVERT(money, VL_CSLL_FRETE), ID_PED_SIGE, ID_FORN, ID_LC, ID_FRETE_GRATIS, ID_ORIGEM, ID_FILIAL, filegroup_nr_mes, CONVERT(money, VL_REC_LIQ_PROD), CONVERT(money, VL_ICMS_OTHERS), CONVERT(money, VL_PIS_OTHERS), CONVERT(money, VL_COFINS_OTHERS), CONVERT(money, VL_CSLL_OTHERS), CONVERT(money, VL_ICMS_ST), CONVERT(money, VL_JUROS_EMISSOR), CONVERT(money, VL_JUROS_ESTAB), ID_VENDEDOR, ID_JUROS, ID_TIPO_CLIENTE, ID_CLIENTE_CORP, YN_MARGEM_NEGATIVA, CONVERT(int, NR_ID_CONTRATO_B2B), CONVERT(int, NR_ID_CAMPANHA_B2B), ID_CLIENTE_FAT_B2B, NR_ID_PARCEIRO_MKT, VL_CRED_PRESUMIDO, UF_ENTREGA, CFOP_ITEM, CONVERT(money, VL_CMV_ORIGINAL), CONVERT(money, VL_DESPREZO_CRED), ID_PARCEIRO_B2B FROM dbo.ods_orders_profitable WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ods_orders_profitable
GO
EXECUTE sp_rename N'dbo.Tmp_ods_orders_profitable', N'ods_orders_profitable', 'OBJECT' 
GO
COMMIT