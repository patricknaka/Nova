select  
-- O campo CD_CIA foi incluido para diferenciar NIKE(601) E BUNZL(602)
--**********************************************************************************************************************************************************
  A.T$TPEN$C CD_TIPO_ENTREGA,
  A.T$DSCA$C DS_TIPO_ENTREGA,
  CAST(601 AS INT) CD_CIA
FROM baandb.tznsls002601 a
order by 1