SELECT
		SUBSTR(TFGLD010.T$DIMX,1,3)			CD_BANDEIRA,
		TFGLD010.T$DESC			NM_BANDEIRA
FROM
			BAANDB.TTFGLD010301 TFGLD010

LEFT JOIN	BAANDB.TTFGLD010301	DIMMAE		ON	DIMMAE.T$DTYP = TFGLD010.T$DTYP
											AND	DIMMAE.T$DIMX = TFGLD010.T$PDIX

LEFT JOIN	BAANDB.TTCCOM001301 TCCOM001	ON	TCCOM001.T$EMNO = TFGLD010.T$EMNO

LEFT JOIN
			(SELECT d.t$cnst CD_STATUS,
				   l.t$desc DS_STATUS
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
			(SELECT d.t$cnst CD_TIPO,
				   l.t$desc DS_TIPO
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
															ON TIPODIM.CD_TIPO = TFGLD010.T$ATYP
															
WHERE
			TFGLD010.T$DTYP=5