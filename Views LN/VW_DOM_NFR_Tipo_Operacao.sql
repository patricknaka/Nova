--	FAF.003 - 12-mai-2014, Fabio Ferreira, 	Icluido os tipos de operação de saida
--	FAF.008 - 21-jun-2014, Fabio Ferreira, 	Correção os registros do módulo NR estavam mostrando os registros de NF
--*******************************************************************************************************************************************
SELECT d.t$cnst COD_CONTROLE,
       l.t$desc DESCR,
	   'NR' MODULO													--#FAF.003.n
FROM tttadv401000 d,
     tttadv140000 l
--WHERE d.t$cpac='ci'												--#FAF.008.o
WHERE d.t$cpac='td'													--#FAF.008.n
--AND d.t$cdom='sli.tdff.l'											--#FAF.008.o
AND d.t$cdom='rec.trfd.l'											--#FAF.008.n
AND d.t$vers='B61U'
AND d.t$rele='a7'
AND d.t$cust='glo1'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
--AND l.t$cpac='tf'													--#FAF.008.o
AND l.t$cpac='td'													--#FAF.008.n
AND l.t$vers='B61U'
AND l.t$rele='a7'
AND l.t$cust='glo1'
UNION																--#FAF.003.sn
SELECT d.t$cnst COD_CONTROLE,
       l.t$desc DESCR,
	   'NF' MODULO
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
AND l.t$cust='glo1'													--#FAF.003.en