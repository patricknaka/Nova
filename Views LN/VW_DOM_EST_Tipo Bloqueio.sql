select  a.t$cdis CODE,
        a.t$dsca DESCR
from    ttcmcs005201 a
WHERE   a.t$rstp=65
UNION
SELECT  'WN' CDOE,
        'Normal' DESCR
FROM Dual