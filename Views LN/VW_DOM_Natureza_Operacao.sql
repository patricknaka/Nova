-- 06-mai-2014, Fabio Ferreira, Alteração campo tipo de operação
--	FAF.003 - 12-mai-2014, Fabio Ferreira, 	Altrada para corrigir registro duplicados devido ao relacionamento com o tipo de operação		
--	FAF.005 - 14-mai-2014, Fabio Ferreira,	Retirado campo Data/hora atualiz		
--	FAF.006 - 15-mai-2014, Fabio Ferreira,	Reirado campo tipo operação
--	FAF.007 - 15-mai-2014, Fabio Ferreira,	Inclusão dos campos DESCR_NATUREZA_OPER	 e DESCR_SEQ_NATUREZA_OPER
--	FAF.127 - 10-mai-2014, Fabio Ferreira,	Correção de filtro
-- 	FAF.159 - 20-jun-2014, Fabio Ferreira,	Correção para sequencia do CFOP
-- 	FAF.187 - 30-jun-2014, Fabio Ferreira,	Correção para sequencia do SEQ CFOP
--****************************************************************************************************************************************************************

-- SELECT 																										--#FAF.003.o
SELECT 	DISTINCT																								--#FAF.003.n
--  tcmcs940.t$ofso$l CD_NATUREZA_OPERACAO,																		--#FAF.159.o
  tcmcs940.t$ocfo$l CD_NATUREZA_OPERACAO,																		--#FAF.159.n
  tcmcs940.t$dsca$l DS_NATUREZA_OPERACAO,																		--#FAF.007.n
--  tcmcs940.t$opor$l SQ_NATUREZA_OPERACAO,																		--#FAF.159.o
--  substr(tcmcs940.t$ofso$l,instr(tcmcs940.t$ofso$l,'-')+1,9) SQ_NATUREZA_OPERACAO,							--#FAF.159.n	--#FAF.187.o

  CASE WHEN instr(tcmcs940.t$ofso$l,'-')=0 THEN tcmcs940.t$opor$l
  ELSE regexp_replace(substr(tcmcs940.t$ofso$l,instr(tcmcs940.t$ofso$l,'-')+1,3), '[^0-9]', '') 
  END SQ_NATUREZA_OPERACAO,								
  tcmcs964.t$desc$d DS_SEQUENCIA_NATUREZA_OPERACAO,																--#FAF.187.n
--  tcmcs947.t$rfdt$l COD_TIPO_OPER,																			--#FAF.005.o
  ' ' DS_OBJETIVO_NATUREZA_OPERACAO   
--	CAST((FROM_TZ(CAST(TO_CHAR(tcmcs940.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 			--#FAF.005.o
--		AT time zone 'America/Sao_Paulo') AS DATE) DT_HR_ATUALIZACAO           										--#FAF.005.o
FROM  baandb.ttcmcs940201 tcmcs940,
--      ttcmcs947201 tcmcs947,																					--#FAF.127.o
      baandb.ttcmcs964201 tcmcs964
WHERE 	tcmcs964.T$OPOR$D=tcmcs940.T$OPOR$L
--AND		  tcmcs947.t$cfoc$l=tcmcs940.t$ofso$l																--#FAF.127.o
--AND		  tcmcs947.t$tror$l=1																				--#FAF.127.o
order by 1