SELECT d.t$cnst COD_STATUS_SEFAZ,
       l.t$desc DESC_STATUS_SEFAZ
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='ci'
AND d.t$cdom='sli.nfes.l'
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