-- FAF.002 - 09-mai-2014, Fabio Ferreira, Correção do relacinamento para o banco destino
-- FAF.003 - 12-mai-2014, Fabio Ferreira, Inclusão do campo COD_PARCEIRO
-- FAF.005 - 14-mai-2014, Fabio Ferreira, Retirada conversão de timezone do campo DT_HR_DE_ATUALIZACAO
--****************************************************************************************************************************************************************
SELECT
	tfacp200.t$ttyp || tfacp200.t$ninv CHAVE,
	tfacp200.t$ninv NUM_TITULO,
	tfcmg011.t$baoc$l COD_BANCO,
	tfcmg011.t$agcd$l NUM_DA_AGENCIA,
	tfcmg001.t$bano NUM_DA_CONTA,
	tfcmg103.T$MOPA$D COD_MODALIDADE_DE_PGTO, -- tfcmg103.mopa.d
	tfacp200.t$docn SEQ_DOCUMENTO,
  CAST((FROM_TZ(CAST(TO_CHAR(tfacp600.t$sdat, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
    AT time zone sessiontimezone) AS DATE) DATA_PAGAMENTO,
	ABS(tfacp200.t$amti + tfacp200.t$ramn$l) VALOR_PAGAMENTO,
	tfacP200.t$lino NUM_MOVIMENTO,
	CASE WHEN tflcb230.t$revs$d=1 then TO_CHAR(tflcb230.t$lach$d)
	ELSE ' '
	END DATA_ESTORNO,
	tflcb230.t$send$d COD_SITUACAO_PAGAMENTO_ELETR,
	nvl(tfcmg109.t$stpp,0) COD_SITUACAO_PAGAMENTO,
--  CAST((FROM_TZ(CAST(TO_CHAR(tfacp600.t$ddat, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 					--#FAF.005.o
--        AT time zone sessiontimezone) AS DATE) DT_HR_DE_ATUALIZACAO,												--#FAF.005.o
	tfacp600.t$ddat DT_HR_DE_ATUALIZACAO,																			--#FAF.005.n
	CASE WHEN tfacp200.t$balc=0 then
	(select max(d.t$docd) from ttfacp200201 d
	where d.t$ttyp=tfacp200.t$ttyp
	and d.t$ninv=tfacp200.t$ninv) 
	ELSE to_date('1970-01-01', 'YYYY-MM-DD')
	END DATA_DE_LIQUID_TITULO,
	tfacp600.t$payt COD_TIPO_TRANSACAO,
	tfcmg011f.t$baoc$l COD_BANCO_DEST,
	tfcmg011f.t$agcd$l NUM_DA_AGENCIA_DEST,
	tccom125.t$bano NUM_DA_CONTA_DEST,
	tfacp200.t$paym METODO_PAGAMENTO,
	tfacp600.t$ptbp COD_PARCEIRO																	--#FAF.003.n	
FROM
	ttfacp600201 tfacp600
  LEFT JOIN ttfcmg109201 tfcmg109
  ON tfcmg109.t$btno=tfacp600.t$pbtn
  LEFT JOIN ttfcmg103201 tfcmg103
  ON tfcmg103.T$BTNO=tfcmg109.T$BTNO
	LEFT JOIN ttfcmg001201 tfcmg001
	ON tfcmg001.t$bank=tfacp600.t$bank
--	LEFT JOIN ttfcmg001201 tfcmg001f										--#FAF.002.o
--	ON tfcmg001f.t$bank=tfacp600.t$basu										--#FAF.002.o
	LEFT JOIN ttccom125201 tccom125											--#FAF.002.sn										
	ON tccom125.t$cban=tfacp600.t$basu										
	AND tccom125.t$ptbp=tfacp600.t$ptbp										--#FAF.002.en
	LEFT JOIN ttfcmg011201 tfcmg011
	ON tfcmg011.t$bank=tfcmg001.t$brch
	LEFT JOIN ttfcmg011201 tfcmg011f
--	ON tfcmg011f.t$bank=tfcmg001f.t$brch,									--#FAF.002.o
	ON tfcmg011f.t$bank=tccom125.t$brch,									--#FAF.002.n
	ttfacp200201 tfacp200
	LEFT JOIN ttflcb230201 tflcb230 
	ON tflcb230.t$docn$d=tfacp200.t$docn
	AND tflcb230.t$ttyp$d=tfacp200.t$tdoc
	AND tflcb230.t$ninv$d=tfacp200.t$ninv
WHERE
      tfacp200.t$tdoc=tfacp600.t$payt
  AND	tfacp200.t$docn=tfacp600.t$payd
  AND tfacp200.t$lino=tfacp600.t$payl