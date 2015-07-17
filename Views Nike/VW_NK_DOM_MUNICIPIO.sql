select distinct 
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
        a.t$city CD_MUNICIPIO,
        a.t$dsca DS_MUNICIPIO,
        a.t$ccty CD_PAIS,
        p.t$dsca DS_PAIS,
        a.t$cste CD_ESTADO,
        e.t$dsca DS_ESTADO,
        CAST(13 AS INT) CD_CIA
from  baandb.ttccom139201 a,  --tabela compartilhada
      baandb.ttcmcs143201 e,  --tabela compartilhada
      baandb.ttcmcs010201 p   --tabela compartilhada
where e.t$cste=a.t$cste
and   p.t$ccty=a.t$ccty
order by 1,3,4