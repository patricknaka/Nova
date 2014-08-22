  -- #FAF.080 - 23-mai-2014, Fabio Ferreira, 	Adcionada sitações do título CAR
  --****************************************************************************************************************************************************
SELECT d.t$cnst CD_SITUACAO_TITULO,
       l.t$desc DS_SITUACAO_TITULO,
      'CAP' CD_MODULO
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
WHERE d.t$cpac='tf'
AND d.t$cdom='acp.stap'
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
SELECT d.t$cnst CD_SITUACAO_TITULO,
       l.t$desc DS_SITUACAO_TITULO,
      'CAR' CD_MODULO
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
WHERE d.t$cpac='tf'
AND d.t$cdom='acr.strp.l'
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
and l.T$ZC_CONT=3
Order By 1
