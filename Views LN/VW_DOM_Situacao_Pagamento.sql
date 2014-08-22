SELECT d.t$cnst CD_SITUACAO_PAGAMENTO,
       l.t$desc DS_SITUACAO_PAGAMENTO,
       'CAP' CD_MODULO
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
WHERE d.t$cpac='tf'
AND d.t$cdom='cmg.stpp'
AND d.t$vers || d.t$rele || d.t$cust=(select max(l1.t$vers || l1.t$rele || l1.t$cust ) 
                                      from baandb.tttadv401000 l1 
                                      where l1.t$cpac=d.t$cpac 
                                      AND l1.t$cdom=d.t$cdom)

AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='tf'
AND l.t$vers || l.t$rele || l.t$cust=(select max(l1.t$vers || l1.t$rele || l1.t$cust ) 
                                      from baandb.tttadv140000 l1 
                                      where l1.t$clab=l.t$clab 
                                      AND l1.t$clan=l.t$clan 
                                      AND l1.t$cpac=l.t$cpac)
UNION
SELECT d.t$cnst CD_SITUACAO_PAGAMENTO,
       l.t$desc DS_SITUACAO_PAGAMENTO,
        'CAR' CD_MODULO
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
WHERE d.t$cpac='tf'
AND d.t$cdom='cmg.stat.l'
AND d.t$vers || d.t$rele || d.t$cust=(select max(l1.t$vers || l1.t$rele || l1.t$cust ) 
                                      from baandb.tttadv401000 l1 
                                      where l1.t$cpac=d.t$cpac 
                                      AND l1.t$cdom=d.t$cdom)
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='tf'
AND l.t$vers || l.t$rele || l.t$cust=(select max(l1.t$vers || l1.t$rele || l1.t$cust ) 
                                      from baandb.tttadv140000 l1 
                                      where l1.t$clab=l.t$clab 
                                      AND l1.t$clan=l.t$clan 
                                      AND l1.t$cpac=l.t$cpac)
order by 1