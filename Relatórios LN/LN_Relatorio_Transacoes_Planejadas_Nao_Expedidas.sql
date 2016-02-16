select distinct 
decode ( whinp100.t$koor, 3,'venda', 36, 'transferencia manual', 34, 'venda manual',whinp100.t$koor) tipo, 
whinp100.t$orno ordem,
whinp100.t$date data, 
whinp100.t$bpid PN
FROM  baandb.twhinp100301 whinp100
where  whinp100.t$kotr = 2 
and    substr(whinp100.t$orno,1,2) <> '01'
order by whinp100.t$date