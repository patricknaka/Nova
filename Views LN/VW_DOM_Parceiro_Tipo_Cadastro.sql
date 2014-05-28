SELECT d.t$cnst CD_TIPO_CADASTRO,
       l.t$desc DS_TIPO_CADASTRO
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='tc'
AND d.t$cdom='bprl'
AND d.t$vers='B61U'
AND d.t$rele='a'
AND d.t$cust='stnd'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='tc'
AND l.t$vers='B61U'
AND l.t$rele='a'
AND l.t$cust='stnd'
UNION SELECT 10, 'Transportador' FROM Dual
UNION SELECT 11, 'Fabricante' FROM Dual
order by 1