  -- #FAF.080 - 23-mai-2014, Fabio Ferreira, 	Adcionada sitações do título CAR
  --****************************************************************************************************************************************************
SELECT d.t$cnst COD_SITUACAO_TITULO,
       l.t$desc DESC_SITUACAO_TITULO,
      'CAP' MODULO
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='tf'
AND d.t$cdom='acp.stap'
AND d.t$vers='B61'
AND d.t$rele='a'
AND d.t$cust=' '
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='tf'
AND l.t$vers='B61'
AND l.t$rele='a'
AND l.t$cust=' '
UNION
SELECT d.t$cnst COD_SITUACAO,
       l.t$desc DESC_SITUACAO_TITULO,
      'CAR' MODULO
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='tf'
AND d.t$cdom='acr.strp.l'
AND d.t$vers='B61U'
AND d.t$rele='a7'
AND d.t$cust='glo1'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='tf'
AND l.t$vers=(select max(l1.t$vers) from tttadv140000 l1 where l1.t$clab=l.t$clab AND l1.t$clan=l.t$clan AND l1.t$cpac=l.t$cpac)
and l.T$ZC_CONT=3
Order By 1