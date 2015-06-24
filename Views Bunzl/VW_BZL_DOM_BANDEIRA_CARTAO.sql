select 
-- O campo CD_CIA foi incluido para diferenciar NIKE(601) E BUNZL(602)
--**********************************************************************************************************************************************************
  a.T$BAND$C CD_BANDEIRA,
  a.t$desc$c DS_BANDEIRA,
  a.t$bnds$c CD_BANDEIRA_SITE,
  cast(602 as int) CD_CIA
from baandb.tzncmg009602 a
order by 1