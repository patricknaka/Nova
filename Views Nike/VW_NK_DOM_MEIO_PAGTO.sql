select 
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
  a.T$MPGS$C CD_MEIO_PAGAMENTO,
  a.t$desc$c DS_MEIO,
  CAST(13 AS INT) CD_CIA
from baandb.tzncmg007601 a
order by 1