select 
-- O campo CD_CIA foi incluido para diferenciar NIKE(2) E BUNZL(3)
--**********************************************************************************************************************************************************
  a.T$MPGS$C CD_MEIO_PAGAMENTO,
  a.t$desc$c DS_MEIO,
  CAST(3 AS INT) CD_CIA
from baandb.tzncmg007201 a
order by 1