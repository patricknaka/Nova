select  a.t$city CD_MUNICIPIO,
        a.t$dsca DS_MUNICIPIO,
        a.t$ccty CD_PAIS,
        p.t$dsca DS_PAIS,
        a.t$cste CD_ESTADO,
        e.t$dsca DS_ESTADO        
from  baandb.ttccom139201 a,
      baandb.ttcmcs143201 e,
      baandb.ttcmcs010201 p
where e.t$cste=a.t$cste
and   p.t$ccty=a.t$ccty
order by 1,3,4