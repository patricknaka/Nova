--	FAF.289 - 18-aug-2014, Fabio Ferreira, 	Inclusão do código da bandeira no site
--****************************************************************************************************************************************************************
select a.T$BAND$C CD_BANDEIRA,
        a.t$desc$c DS_BANDEIRA,
		a.t$bnds$c CD_BANDEIRA_SITE							--#FAF.289.n
from baandb.tzncmg009201 a
order by 1