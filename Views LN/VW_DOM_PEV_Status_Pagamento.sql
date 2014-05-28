SELECT d.t$cnst COD_STATUS_PAGAMENTO,
       l.t$desc DESC_STATUS
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='zn'
AND d.t$cdom='sls.stat.c'
AND d.t$vers='B61U'
AND d.t$rele='a7'
AND d.t$cust='npt0'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='zn'
AND l.t$vers=(select max(l1.t$vers) from tttadv140000 l1 where l1.t$clab=l.t$clab AND l1.t$clan=l.t$clan AND l1.t$cpac=l.t$cpac)
ORDER BY d.t$cnst