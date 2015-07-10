select  
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
        a.t$city CD_MUNICIPIO,
        a.t$dsca DS_MUNICIPIO,
        a.t$ccty CD_PAIS,
        p.t$dsca DS_PAIS,
        a.t$cste CD_ESTADO,
        e.t$dsca DS_ESTADO,
        CAST(13 AS INT) CD_CIA
from  baandb.ttccom139601 a,
      baandb.ttcmcs143601 e,
      baandb.ttcmcs010601 p
where e.t$cste=a.t$cste
and   p.t$ccty=a.t$ccty
order by 1,3,4