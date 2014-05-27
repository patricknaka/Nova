SELECT d.t$cnst COD_SITUACAO_NOTA,
       l.t$desc DESC_SITUACAO_NOTA,
       'NFV' COD_MODULO
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='ci'
AND d.t$cdom='sli.stat'
AND d.t$vers='B61U'
AND d.t$rele='a7'
AND d.t$cust='glo1'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='ci'
AND l.t$vers=(select max(l1.t$vers) from tttadv140000 l1 where l1.t$clab=l.t$clab AND l1.t$clan=l.t$clan AND l1.t$cpac=l.t$cpac)
UNION
SELECT d.t$cnst COD_SITUACAO_NOTA,
       l.t$desc DESC_SITUACAO_NOTA,
       'NFR' COD_MODULO
FROM tttadv401000 d,
     tttadv140000 l
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
order by 1
