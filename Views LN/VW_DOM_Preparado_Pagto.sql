-- #FAF.079 - 26-mai-2014, Fabio Ferreira, 	Incluidas as situações do CAR					
--************************************************************************************************************************************************************
SELECT d.t$cnst COD,
       l.t$desc DESCR,
       'CAP' MODULO
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='tf'
AND d.t$cdom='acp.pyst.l'
AND d.t$vers='B61U'
AND d.t$rele='a7'
AND d.t$cust='glo1'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='tf'
AND l.t$vers='B61U'
AND l.t$rele='a7'
AND l.t$cust='glo1'
UNION 
SELECT d.t$cnst COD,
       l.t$desc DESCR,
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