select 
-- O campo CD_CIA foi incluido para diferenciar NIKE(601) E BUNZL(602)
--**********************************************************************************************************************************************************
        a.t$cdis CD_TIPO_BLOQUEIO,
        a.t$dsca DS_TIPO_BLOQUEIO,
        cast(601 as int) CD_CIA
from    baandb.ttcmcs005601 a
WHERE   a.t$rstp=65
UNION
SELECT  'WN' CDOE,
        'Normal' DESCR,
        cast(601 as int) CIA
FROM Dual
order by 1