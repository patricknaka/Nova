SELECT d.t$cnst COD,
       l.t$desc DESCR
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
WHERE d.t$cpac='td'
AND d.t$cdom='rec.stat.l'
AND d.t$vers='B61U'
AND d.t$rele='a7'
AND d.t$cust='npt0'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='td'
AND l.t$vers='B61U'
AND l.t$rele='a7'