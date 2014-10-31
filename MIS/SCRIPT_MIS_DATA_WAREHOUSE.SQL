
--não achei rotina de carga e copiei os mesmos dados do COSMOS

alter table fin.dim_titulo_modulo
alter column ds_id_modulo varchar(3) not null

insert into fin.dim_titulo_modulo
values ('CAP','Contas a Pagar'), ('CAR','Contas a Receber')