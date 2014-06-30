--	FAF.182 - 27-jun-2014, Fabio Ferreira, 	Correção descrição dominio
--*******************************************************************************************************************************************
SELECT 	DISTINCT			
	  tcmcs940.t$ofso$l CD_NATUREZA_OPERACAO,
	  tcmcs940.t$opor$l SQ_NATUREZA_OPERACAO,
	  tcmcs947.t$rfdt$l CD_TIPO_OPERACAO,
	  dominio.DESCR DS_TIPO_OPERACAO
FROM  ttcmcs940201 tcmcs940,
      ttcmcs947201 tcmcs947,      
      (SELECT d.t$cnst cod,
       l.t$desc DESCR,
	   'NR' CD_MODULO											
		FROM tttadv401000 d,
			 tttadv140000 l
		WHERE d.t$cpac='td'										
		AND d.t$cdom='rec.trfd.l'					
		AND d.t$vers='B61U'
		AND d.t$rele='a7'
		AND d.t$cust='glo1'
		AND l.t$clab=d.t$za_clab
		AND l.t$clan='p'
		AND l.t$cpac='td'												
		AND l.t$vers='B61U'
		AND l.t$rele='a7'
		AND l.t$cust='glo1') dominio
WHERE	tcmcs947.t$cfoc$l=tcmcs940.t$ofso$l
AND    	dominio.COD=tcmcs947.t$rfdt$l
order by 1,2,3