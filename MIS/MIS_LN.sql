--11/12/15

alter table mis_ln.dbo.stg_pec_cab
add DS_ORDEM_PN_FORNEC nvarchar(150)

--30/12/2015
alter table dbo.stg_trp_transporte
add DS_CAPITAL_INTERIOR nvarchar(40) null,
	NR_CARGA nvarchar(15) null,
	DT_AJUSTADA datetime null,
	DT_PREVISTA datetime null,
	NR_TELEFONE NVARCHAR(15) NULL,
	NR_TELEFONE1 NVARCHAR(15) NULL,
	NR_TELEFONE2 NVARCHAR(15) NULL,
	NR_PERIODO INT NULL,
	QT_VOLUME NUMERIC(38,4) NULL,
	NR_CONTRATO NVARCHAR(10) NULL,
	ID_TRANSP NVARCHAR(5) NULL

--29/12/2015
alter table dbo.stg_pev_cliente
add DS_EMAIL NVARCHAR(100) NULL,
	DS_NOME_CLIENTE NVARCHAR(70) null,
	NR_CNPJ_CPF nvarchar(20) null

alter table stg_pev_det
add CD_LOJISTA_MKP int null