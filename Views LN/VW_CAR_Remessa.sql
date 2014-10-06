--21/08/2014  Atualização do timezone
-- 	#FAF.300 - 25-aug-2014, Fabio Ferreira, 	Inclusão dos campos do LN que fazem parte da chave da tabela tfcmg948
-- 	#MAR.332 - 06-out-2014, Marcia A. R. Torres, Buscar a agência da tabela tfcmg948.
--====================================================================================================================
SELECT DISTINCT
	tfcmg948.t$bank$l CD_BANCO,
	tfcmg948.t$btno$l NR_REMESSA,
	tfcmg948.t$docd$l DT_REMESSA,
--	tfcmg011.t$agcd$l NR_AGENCIA,         --#MAR.332.o
	tfcmg948.t$baof$l NR_AGENCIA,           --#MAR.332.n
	tfcmg948.t$acco$l NR_CONTA,
    201 CD_CIA,
	tfcmg948.t$stat$l CD_STATUS_ARQUIVO,
	tfcmg948.t$send$l CD_STATUS_ENVIO,
	  	GREATEST(
	nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfcmg948.t$lach$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    		AT time zone sessiontimezone) AS DATE), TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),
	nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfcmg948.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    		AT time zone sessiontimezone) AS DATE), TO_DATE('01-JAN-1970', 'DD-MON-YYYY')) ) DT_ULT_ATUALIZACAO,
  	tfcmg948.t$banu$l NR_BANCO,
  	tfcmg948.t$ptyp$l CD_TRANSACAO_MOVIMENTO,								--#FAF.300.sn
	tfcmg948.t$DOCN$L NR_DOC_MOVIMENTO,			
	tfcmg948.t$ttyp$l CD_TRANSACAO_TITULO, 
	tfcmg948.t$ninv$l NR_TITULO,		
	tfcmg948.t$sern$l NR_SERIE,										--#FAF.300.en
  CONCAT(tfcmg948.t$ttyp$l, TO_CHAR(tfcmg948.t$ninv$l)) CD_CHAVE_PRIMARIA
FROM
	baandb.ttfcmg948201 tfcmg948
--	LEFT JOIN baandb.ttfcmg001201 tfcmg001      --#MAR.332.so
--	ON  tfcmg001.t$bank=tfcmg948.t$bank$l
--	LEFT JOIN baandb.ttfcmg011201 tfcmg011
--	ON  tfcmg011.t$bank=tfcmg001.t$brch         --#MAR.332.eo
