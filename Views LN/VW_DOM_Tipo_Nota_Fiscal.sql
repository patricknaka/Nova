SELECT d.t$cnst CD_TIPO_NF,
       l.t$desc DS_TIPO_NF
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
WHERE d.t$cpac='tc'
AND d.t$cdom='doty.l'
AND d.t$vers || d.t$rele || d.t$cust=(select max(l1.t$vers || l1.t$rele || l1.t$cust ) 
                                      from baandb.tttadv401000 l1 
                                      where l1.t$cpac=d.t$cpac 
                                      AND l1.t$cdom=d.t$cdom)
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='tc'
AND l.t$vers || l.t$rele || l.t$cust=(select max(l1.t$vers || l1.t$rele || l1.t$cust ) 
                                      from baandb.tttadv140000 l1 
                                      where l1.t$clab=l.t$clab 
                                      AND l1.t$clan=l.t$clan 
                                      AND l1.t$cpac=l.t$cpac)
order by 1
