-- #FAF.075 - 22-mai-2014, Fabio Ferreira, 	Adicionados os códigos do banco do site
--**********************************************************************************************************************************************************
SELECT d.t$cnst CD_ORIGEM_PEDIDO,
       l.t$desc DS_ORIGEM_PEDIDO
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
WHERE d.t$cpac='zn'
AND d.t$cdom='sls.orig.c'
AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                                     (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                                      from baandb.tttadv401000 l1 
                                      where l1.t$cpac=d.t$cpac 
                                      AND l1.t$cdom=d.t$cdom)
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='zn'
AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                                    (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                                      from baandb.tttadv140000 l1 
                                      where l1.t$clab=l.t$clab 
                                      AND l1.t$clan=l.t$clan 
                                      AND l1.t$cpac=l.t$cpac)
AND l.T$ZC_CONT=3																													--#FAF.075.en
--AND l.t$vers='B61U'																												--#FAF.075.so
--AND l.t$rele='a7'
--AND l.t$cust='npt0'	
order by 1																											--#FAF.075.eo
