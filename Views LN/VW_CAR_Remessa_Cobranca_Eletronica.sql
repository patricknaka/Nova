--	#FAF.224 - 14-jul-2014,	Fabio Ferreira,	Correção de duplicidade
--	#MAR.271 - 20-ago-2014,	Marcia A. Torres,	Correção DT_ATUALIZACAO
--	21/08/2014    Atualização do timezone
--****************************************************************************************************************************************************************
SELECT DISTINCT																							--#FAF.224.o
	tfcmg948.t$bank$l CD_BANCO,
	tfcmg948.t$btno$l NR_REMESSA,
	tfcmg948.t$occ2$l CD_COMANDO,
	CONCAT(tfcmg948.t$ttyp$l, TO_CHAR(tfcmg948.t$ninv$l)) CD_CHAVE_PRIMARIA,
	'CAR' CD_MODULO,
	tfcmg948.t$stat$l CD_SITUACAO_PAGAMENTO,
  GREATEST(                                                                               --#MAT.271.sn      
	nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfcmg948.t$lach$l, 'DD-MON-YYYY HH24:MI:SS'), 
      'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE), 
      TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),
	nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfcmg948.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 
      'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE), 
      TO_DATE('01-JAN-1970', 'DD-MON-YYYY')) ) DT_ULT_ATUALIZACAO  --#MAT.271.en
FROM
	baandb.ttfcmg948201 tfcmg948