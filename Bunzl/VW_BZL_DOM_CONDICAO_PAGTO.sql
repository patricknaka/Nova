SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(2) E BUNZL(3)
--**********************************************************************************************************************************************************
  CAST(3 AS INT) AS CD_CIA,
  tcmcs013.t$cpay CD_CONDICAO_PAGAMENTO,
  tcmcs013.t$dsca DS_CONDICAO_PAGAMENTO,
  CASE WHEN tcmcs220.t$ptyp=1 THEN 'DIAS' ELSE 'MESES' END CD_TIPO_PERIODO,				
  tcmcs221.t$nods NR_PERIODO															
FROM baandb.ttcmcs013201 tcmcs013,
		baandb.ttcmcs220201 tcmcs220,														
		(select a.t$pash, a.t$nods from baandb.ttcmcs221201 a
		where a.t$seqn = (	select max(b.t$seqn) from baandb.ttcmcs221201 b
							where b.t$pash=a.t$pash						)) tcmcs221
WHERE
		tcmcs220.t$pash = tcmcs013.t$pash
AND		tcmcs221.t$pash = tcmcs220.t$pash											
order by 1,2