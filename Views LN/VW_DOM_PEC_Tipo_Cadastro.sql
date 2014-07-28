SELECT cast(d.t$cnst as int) CD_TIPO_CADASTRO,
       l.t$desc DS_TIPO_CADASTRO
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
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