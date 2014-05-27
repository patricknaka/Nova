SELECT 	DISTINCT			
	  tcmcs940.t$ofso$l COD_NATUREZA_OPER,
	  tcmcs940.t$opor$l SEQ_NATUREZA_OPER,
	  tcmcs947.t$rfdt$l COD_TIPO_OPER,
	  dominio.DESCR DESC_TIPO_OPER
FROM  ttcmcs940201 tcmcs940,
      ttcmcs947201 tcmcs947,      
      (SELECT d.t$cnst COD, l.t$desc DESCR,'NR' MODULO FROM tttadv401000 d, tttadv140000 l
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
      AND l.t$cust='glo1') dominio
WHERE	tcmcs947.t$cfoc$l=tcmcs940.t$ofso$l
AND    	dominio.COD=tcmcs947.t$rfdt$l
order by 1,2,3