﻿select 
-- O campo CD_CIA foi incluido para diferenciar NIKE(2) E BUNZL(3)
--**********************************************************************************************************************************************************
  a.T$BAND$C CD_BANDEIRA,
  a.t$desc$c DS_BANDEIRA,
  a.t$bnds$c CD_BANDEIRA_SITE,
  cast(3 as int) CD_CIA
from baandb.tzncmg009201 a
order by 1