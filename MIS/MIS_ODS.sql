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
