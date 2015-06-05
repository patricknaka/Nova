select  
-- O campo CD_CIA foi incluido para diferenciar NIKE(2) E BUNZL(3)
--**********************************************************************************************************************************************************
  A.T$TPEN$C CD_TIPO_ENTREGA,
  A.T$DSCA$C DS_TIPO_ENTREGA,
  CAST(3 AS INT) CD_CIA
FROM baandb.tznsls002201 a
order by 1