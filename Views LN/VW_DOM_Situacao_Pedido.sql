SELECT d.t$cnst COD_SITUACAO_PEDIDO,
       l.t$desc DESC_SITUACAO_PEDIDO,
       'PEC' COD_MODULO
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='td'
AND d.t$cdom='pur.hdst'
AND d.t$vers='B61U'
AND d.t$rele='a'
AND d.t$cust='stnd'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='td'
AND l.t$vers=(select max(l1.t$vers) from tttadv140000 l1 where l1.t$clab=l.t$clab AND l1.t$clan=l.t$clan AND l1.t$cpac=l.t$cpac)
UNION
SELECT d.t$cnst COD_SITUACAO_PEDIDO,
       l.t$desc DESC_SITUACAO_PEDIDO,
       'PEV' COD_MODULO
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='td'
AND d.t$cdom='sls.hdst'
AND d.t$vers='B61U'
AND d.t$rele='a'
AND d.t$cust='stnd'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='td'
AND l.t$vers=(select max(l1.t$vers) from tttadv140000 l1 where l1.t$clab=l.t$clab AND l1.t$clan=l.t$clan AND l1.t$cpac=l.t$cpac)
order by 1