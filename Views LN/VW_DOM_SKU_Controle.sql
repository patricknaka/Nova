SELECT d.t$cnst CD_CONTROLE,
       l.t$desc DS_CONTROLE
FROM tttadv401000 d,
     tttadv140000 l
WHERE d.t$cpac='zn'
AND d.t$cdom='ibd.espe.c'
AND d.t$vers='B61U'
AND d.t$rele='a7'
AND d.t$cust='npt0'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='zn'
AND l.t$vers='B61U'
AND l.t$rele='a7'
AND l.t$cust='npt0'
UNION SELECT  10 CD_CONTROLE,
              'BRINDE' DS_CONTROLE
FROM DUAL
UNION SELECT  20 CD_CONTROLE,
              'AMOSTRA GRATIS' DS_CONTROLE
FROM DUAL
order by 1