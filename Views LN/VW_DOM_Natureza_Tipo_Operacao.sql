--	FAF.182 - 27-jun-2014, Fabio Ferreira, 	Correção descrição dominio
--	FAF.183 - 30-jun-2014, Fabio Ferreira, 	Inclusão do campo máodulo e descrições de dominio para NF
--*******************************************************************************************************************************************
SELECT 	DISTINCT			
	  tcmcs940.t$ofso$l CD_NATUREZA_OPERACAO,
	  tcmcs940.t$opor$l SQ_NATUREZA_OPERACAO,
    CASE WHEN tcmcs947.t$tror$l=1 THEN tcmcs947.t$rfdt$l 
    ELSE tcmcs947.t$ifdt$l END CD_TIPO_OPERACAO,
	  CASE WHEN tcmcs947.t$tror$l=1 THEN
      (SELECT
           l.t$desc DESCR							
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
      AND l.t$cust='glo1'
      AND d.t$cnst=tcmcs947.t$rfdt$l)    
    ELSE
      (SELECT 
           l.t$desc
      FROM tttadv401000 d,
         tttadv140000 l
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
      AND l.t$cust='glo1'
      AND d.t$cnst=tcmcs947.t$ifdt$l)
      END DS_TIPO_OPERACAO,
	  CASE WHEN tcmcs947.t$tror$l=1 THEN 'NR'
	  ELSE 'NF' END CD_MODULO
FROM  ttcmcs940201 tcmcs940,
      ttcmcs947201 tcmcs947
WHERE	tcmcs947.t$cfoc$l=tcmcs940.t$ofso$l
order by 1,2,3