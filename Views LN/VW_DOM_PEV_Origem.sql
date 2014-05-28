-- #FAF.075 - 22-mai-2014, Fabio Ferreira, 	Adicionados os códigos do banco do site
--**********************************************************************************************************************************************************
SELECT d.t$cnst CD_ORIGEM_PEDIDO,
       l.t$desc DS_ORIGEM_PEDIDO
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='zn'
AND d.t$cdom='sls.orig.c'
AND d.t$vers='B61U'
AND d.t$rele='a7'
AND d.t$cust='npt0'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='zn'
AND l.t$vers=(select max(l1.t$vers) from tttadv140000 l1 where l1.t$clab=l.t$clab AND l1.t$clan=l.t$clan AND l1.t$cpac=l.t$cpac)	--#FAF.075.sn
AND l.T$ZC_CONT=3																													--#FAF.075.en
--AND l.t$vers='B61U'																												--#FAF.075.so
--AND l.t$rele='a7'
--AND l.t$cust='npt0'	
order by 1																											--#FAF.075.eo