select  
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
  A.T$TPEN$C CD_TIPO_ENTREGA,
  A.T$DSCA$C DS_TIPO_ENTREGA,
  CAST(13 AS INT) CD_CIA
FROM baandb.tznsls002201 a
order by 1