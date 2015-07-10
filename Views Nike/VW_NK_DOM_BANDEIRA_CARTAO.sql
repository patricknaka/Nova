select 
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
  a.T$BAND$C CD_BANDEIRA,
  a.t$desc$c DS_BANDEIRA,
  a.t$bnds$c CD_BANDEIRA_SITE,
  cast(13 as int) CD_CIA
from baandb.tzncmg009601 a
order by 1