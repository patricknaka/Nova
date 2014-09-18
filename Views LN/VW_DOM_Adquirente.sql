select 
a.t$adqu$c as cod_adquirente_ln,
b.t$adqs$c as cod_adquirente_front,
a.t$band$c as cod_bandeira,
a.t$cias$c as cod_cia,
a.t$prct$c as parcelas,
a.t$trbd$c as vl_tarifa,
a.t$cobr$c as ds_detalhe,
a.t$txjr$c as vl_tarifacjuros,
a.t$dtin$c as dt_ini_vig,
c.t$bnds$c as cd_bandeira_front
from baandb.TZNCMG010201 a
       inner join baandb.TZNCMG008201 b
       on a.t$adqu$c = b.t$adqu$c
       inner join baandb.tzncmg009201 c
       on c.t$band$c = a.t$band$c
       and c.t$cias$c = a.t$cias$c
where a.t$dtat$c >=trunc(sysdate-200)