--	FAF.182 - 27-jun-2014, Fabio Ferreira, 	Correção descrição dominio
--*******************************************************************************************************************************************
SELECT 	DISTINCT			
	  tcmcs940.t$ofso$l CD_NATUREZA_OPERACAO,
	  tcmcs940.t$opor$l SQ_NATUREZA_OPERACAO,
	  tcmcs947.t$rfdt$l CD_TIPO_OPERACAO,
	  dominio.DESCR DS_TIPO_OPERACAO
FROM  baandb.ttcmcs940201 tcmcs940,
      baandb.ttcmcs947201 tcmcs947,      
      (SELECT d.t$cnst cod,
       l.t$desc DESCR,
	   'NR' CD_MODULO											
		FROM baandb.tttadv401000 d,
			 baandb.tttadv140000 l
		WHERE d.t$cpac='td'										
		AND d.t$cdom='rec.trfd.l'					
    AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                                         (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                                          from baandb.tttadv401000 l1 
                                          where l1.t$cpac=d.t$cpac 
                                          AND l1.t$cdom=d.t$cdom)
		AND l.t$clab=d.t$za_clab
		AND l.t$clan='p'
		AND l.t$cpac='td'												
    AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                                        (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                                          from baandb.tttadv140000 l1 
                                          where l1.t$clab=l.t$clab 
                                          AND l1.t$clan=l.t$clan 
                                          AND l1.t$cpac=l.t$cpac)) dominio
WHERE	tcmcs947.t$cfoc$l=tcmcs940.t$ofso$l
AND    	dominio.COD=tcmcs947.t$rfdt$l
order by 1,2,3
