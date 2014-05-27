SELECT cast(d.t$cnst as int) COD_TIPO_CADASTRO,
       l.t$desc DESC_TIPO_CADASTRO
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='td'
AND d.t$cdom='pur.corg'
AND d.t$vers='B61U'
AND d.t$rele='a'
AND d.t$cust='stnd'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='td'
AND l.t$vers='B61'
AND l.t$rele='a'
AND l.t$cust=' '
order by 1