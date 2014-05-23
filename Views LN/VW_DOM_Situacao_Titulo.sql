SELECT d.t$cnst COD_SITUACAO_TITULO,
       l.t$desc DESC_SITUACAO_TITULO
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
order by 1