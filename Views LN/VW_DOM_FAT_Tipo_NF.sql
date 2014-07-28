-- #FAF.005, 14-mai-2014, Fabio Ferreira,	Alteração Alias
--							
--**********************************************************************************************************************************************************
SELECT d.t$cnst CD_TIPO_NF,
       l.t$desc DS_TIPO_NF
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
WHERE d.t$cpac='ci'
AND d.t$cdom='sli.tdff.l'
AND d.t$vers='B61U'
AND d.t$rele='a7'
AND d.t$cust='glo1'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='ci'
AND l.t$vers='B61U'
AND l.t$rele='a7'
AND l.t$cust='glo1'
order by 1
