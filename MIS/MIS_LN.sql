--11/12/15

alter table mis_ln.dbo.stg_pec_cab
add DS_ORDEM_PN_FORNEC nvarchar(150)

--28/12/2015
alter table dbo.stg_trp_transporte
add DS_CAPITAL_INTERIOR nvarchar(40) null,
	NR_CARGA nvarchar(15) null,
	DT_AJUSTADA datetime null,
	DT_PREVISTA datetime null,
	NR_TELEFONE NVARCHAR(15) NULL,
	NR_TELEFONE1 NVARCHAR(15) NULL,
	NR_TELEFONE2 NVARCHAR(15) NULL,
	NR_PERIODO INT NULL

