select  a.t$cdis COD_TIPO_BLOQUEIO,
        a.t$dsca DESC_TIPO_BLOQUEIO
from    ttcmcs005201 a
WHERE   a.t$rstp=65
UNION
SELECT  'WN' CDOE,
        'Normal' DESCR
FROM Dual
order by 1