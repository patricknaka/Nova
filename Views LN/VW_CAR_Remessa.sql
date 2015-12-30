SELECT DISTINCT
  tfcmg948.t$bank$l                               CD_BANCO,
  tfcmg948.t$btno$l                               NR_REMESSA,
  tfcmg948.t$docd$l                               DT_REMESSA,
  tfcmg948.t$baof$l                               NR_AGENCIA, 
  tfcmg948.t$acco$l                               NR_CONTA,
  1                                               CD_CIA,
  tfcmg948.t$stat$l                               CD_STATUS_ARQUIVO,
  tfcmg948.t$send$l                               CD_STATUS_ENVIO,
  GREATEST(
  nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfcmg948.t$lach$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 
        TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),
  nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfcmg948.t$rcd_utc, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 
        TO_DATE('01-JAN-1970', 'DD-MON-YYYY')) )  DT_ULT_ATUALIZACAO,
  tfcmg948.t$banu$l                               NR_BANCO,
  tfcmg948.t$ptyp$l                               CD_TRANSACAO_MOVIMENTO,
  tfcmg948.t$DOCN$L                               NR_DOC_MOVIMENTO,			
  tfcmg948.t$ttyp$l                               CD_TRANSACAO_TITULO, 
  tfcmg948.t$ninv$l                               NR_TITULO,		
  tfcmg948.t$sern$l                               NR_SERIE,	
  CONCAT(tfcmg948.t$ttyp$l, 
    TO_CHAR(tfcmg948.t$ninv$l))                   CD_CHAVE_PRIMARIA

FROM
	baandb.ttfcmg948201 tfcmg948
