select  

  a.t$cdis CD_TIPO_BLOQUEIO,
  a.t$dsca DS_TIPO_BLOQUEIO

from baandb.ttcmcs005201 a

WHERE a.t$rstp=65

UNION

SELECT  
  'WN'     CDOE,
  'Normal' DESCR
FROM Dual

order by 1