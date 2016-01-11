Select
  substr(tfgld010.t$dimx,1,3) CD_BANDEIRA,
  tfgld010.t$desc             NM_BANDEIRA

from baandb.ttfgld010301 tfgld010

left join baandb.ttfgld010301	dimmae		
  on	dimmae.t$dtyp = tfgld010.t$dtyp
  and	dimmae.t$dimx = tfgld010.t$pdix

left join baandb.ttccom001301 tccom001	
  on	tccom001.t$emno = tfgld010.t$emno

LEFT JOIN
  (SELECT d.t$cnst CD_STATUS, l.t$desc DS_STATUS
    FROM baandb.tttadv401000 d,
         baandb.tttadv140000 l
    WHERE d.t$cpac='tf'
    AND d.t$cdom='gld.bloc'
    AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                     (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                      from baandb.tttadv401000 l1 
                      where l1.t$cpac=d.t$cpac 
                      AND l1.t$cdom=d.t$cdom)
    AND l.t$clab=d.t$za_clab
    AND l.t$clan='p'
    AND l.t$cpac='tf'
    AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                    (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                      from baandb.tttadv140000 l1 
                      where l1.t$clab=l.t$clab 
                      AND l1.t$clan=l.t$clan 
                      AND l1.t$cpac=l.t$cpac)) STATUSDIM
  ON STATUSDIM.CD_STATUS = TFGLD010.T$BLOC

LEFT JOIN
  (SELECT d.t$cnst CD_TIPO, l.t$desc DS_TIPO
  FROM baandb.tttadv401000 d,
       baandb.tttadv140000 l
  WHERE d.t$cpac='tf'
  AND d.t$cdom='gld.datp'
  AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                     (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                      from baandb.tttadv401000 l1 
                      where l1.t$cpac=d.t$cpac 
                      AND l1.t$cdom=d.t$cdom)
  AND l.t$clab=d.t$za_clab
  AND l.t$clan='p'
  AND l.t$cpac='tf'
  AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                    (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                      from baandb.tttadv140000 l1 
                      where l1.t$clab=l.t$clab 
                      AND l1.t$clan=l.t$clan 
                      AND l1.t$cpac=l.t$cpac)) TIPODIM
  ON TIPODIM.CD_TIPO = tfgld010.t$atyp
															
WHERE tfgld010.t$dtyp=5