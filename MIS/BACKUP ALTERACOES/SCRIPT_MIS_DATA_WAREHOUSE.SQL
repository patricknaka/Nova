
--não achei rotina de carga e copiei os mesmos dados do COSMOS

alter table fin.dim_titulo_modulo
alter column ds_id_modulo varchar(3) not null

insert into fin.dim_titulo_modulo
values ('CAP','Contas a Pagar'), ('CAR','Contas a Receber')

--============================================
alter TABLE log.fact_fluxo_pedidos_entrada
add nr_qtde_pecas int NULL, nr_vl_m3 numeric(18, 6) NULL


alter table log.fact_fluxo_pedidos_saida
add nr_qtde_pecas int null, nr_vl_m3 numeric(18,6) null

--============================================

CREATE TABLE [log].[fact_fluxo_pedidos_caixa](
	[nr_dt_emissao] [int] NULL,
	[nr_hora] [int] NULL,
	[nr_id_planta] [int] NULL,
	[nr_id_unidade_negocio] [int] NULL,
	[nr_id_localidade] [int] NULL,
	[nr_id_departamento] [int] NULL,
	[nr_qtde_pedido] [numeric](18, 0) NULL,
	[nr_qtde_pecas] [int] NULL,
	[nr_vl_m3] [numeric](18, 6) NULL
) ON [PRIMARY]
