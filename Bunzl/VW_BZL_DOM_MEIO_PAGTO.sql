select 
-- O campo CD_CIA foi incluido para diferenciar NIKE(601) E BUNZL(602)
--**********************************************************************************************************************************************************
  a.T$MPGS$C CD_MEIO_PAGAMENTO,
  a.t$desc$c DS_MEIO,
  CAST(602 AS INT) CD_CIA
from baandb.tzncmg007602 a
order by 1