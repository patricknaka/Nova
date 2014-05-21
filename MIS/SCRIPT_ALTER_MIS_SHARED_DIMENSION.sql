
-- Banco MIS_SHARED_DIMENSION
-------------------------------------------------------------------------------------------------------------------
--Alteração Data Type
--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_SHARED_DIMENSION.dim.ods_produto
ALTER COLUMN ds_ean NUMERIC(15)


--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_SHARED_DIMENSION.aux.aux_ods_produto_embalagem
ALTER COLUMN DS_EAN NUMERIC(15)


--DE NUMERIC(13) para NUMERIC(15)
ALTER TABLE MIS_SHARED_DIMENSION.aux.aux_ods_produto_sige
alter column ds_ean numeric(15)