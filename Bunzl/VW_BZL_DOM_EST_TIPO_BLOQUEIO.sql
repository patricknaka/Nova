select 
-- O campo CD_CIA foi incluido para diferenciar NIKE E BUNZL
--**********************************************************************************************************************************************************
        a.t$cdis CD_TIPO_BLOQUEIO,
        a.t$dsca DS_TIPO_BLOQUEIO,
        cast(3 as int) CD_CIA
from    baandb.ttcmcs005201 a
WHERE   a.t$rstp=65
UNION
SELECT  'WN' CDOE,
        'Normal' DESCR,
        cast(2 as int) CIA
FROM Dual
order by 1