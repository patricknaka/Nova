-- 06-mai-2014, Fabio Ferreira, Inclusão do numero do pedido
-- #FAF.001 - 06-mai-2014, Fabio Ferreira, 	Tratamento da data de vencimento	
-- #FAF.002 - 09-mai-2014, Fabio Ferreira, 	Correção dos campos referente a situação do título				
-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Adicionado campo método de pagamento/recebimento
-- #FAF.008 - 21-mai-2014, Fabio Ferreira, 	Alterado alias campo método de pagamento/recebimento	
-- #FAF.108 - 05-jun-2014, Fabio Ferreira, 	Inclusão da situação da remessa
-- #FAF.141 - 16-jun-2014, Fabio Ferreira, 	Problema mais de um registro na subquery
-- #FAF.146 - 17-jun-2014, Fabio Ferreira, 	Correção DT_LIQUIDACAO_TITULO
-- #FAF.146.1 - 27-jun-2014, Fabio Ferreira, 	Correção VL_DESCONTO
-- #FAF.193 - 27-jun-2014, Fabio Ferreira, 	Padronização de alias
-- #FAF.203 - 03-jul-2014, Fabio Ferreira, 	Retirados campos da remessa
-- #MAR.273 - 11-ago-2014, Marcia A R Torres, Correção DT_ATUALIZACAO e CD_METODO_RECEBIMENTO.
-- #FAF.282 - 14-ago-2014, Fabio Ferreira, 	Retirados campo  método de pagamento
--****************************************************************************************************************************************************************
--ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH:MI:SS AM';

SELECT DISTINCT	
--  CONCAT(tfacr200.t$ttyp, TO_CHAR(tfacr200.t$ninv)) NR_TITULO,												--#FAF.193.o
  CONCAT(tfacr200.t$ttyp, TO_CHAR(tfacr200.t$ninv)) CD_CHAVE_PRIMARIA,											--#FAF.193.n
--  tfacr200.t$ttyp CD_TIPO_TRANSACAO,																			--#FAF.193.o
	tfacr200.t$ttyp CD_TRANSACAO_TITULO,																		--#FAF.193.o
    201 CD_CIA,
	CASE WHEN nvl((	select c.t$styp from baandb.tcisli205201 c
					where c.t$styp='BL ATC'
					AND c.T$ITYP=tfacr200.t$ttyp
					AND c.t$idoc=tfacr200.t$ninv
					AND rownum=1),0)=0 
	THEN 2
	ELSE 3
	END CD_FILIAL,	
	'CAR' CD_MODULO,
	tfacr200.t$doct$l SQ_DOCUMENTO,
	tfacr200.t$itbp CD_PARCEIRO,
	tfacr200.t$docn$l NR_NF,
	tfacr200.t$seri$l NR_SERIE_NF,
	tfacr200.t$docd DT_EMISSAO_TITULO,
	TO_DATE(REGEXP_REPLACE(tfacr200.T$LIQD,',''[[:punct:]]',''), 'DD-MM-YY HH:MI:SS AM') DT_VENCIMENTO,			--#FAF.001.n
	CASE WHEN tfacr200.t$balc=0 THEN																--#FAF.146.n														 													
	(select max(p.t$docd) 
		from baandb.ttfacr200201 p
		where p.t$ttyp=tfacr200.t$ttyp
		and p.t$ninv=tfacr200.t$ninv) 
	ELSE NULL END DT_LIQUIDACAO_TITULO,																			--#FAF.146.n
	tfacr200.t$amnt VL_TITULO,
	tfcmg011.t$baoc$l CD_BANCO,
	tfcmg011.t$agcd$l NR_AGENCIA,
	tfcmg001.t$bano NR_CONTA_CORRENTE,
	tfacr200.t$dim1 CD_CENTRO_CUSTO,
--	tfcmg401.t$btno NR_REMESSA,																						--#FAF.203.o
--	tfcmg409.t$date DT_REMESSA,																						--#FAF.203.o
--#FAF.002.o
	nvl((select min(a.t$rpst$l) from baandb.ttfacr201201 a																	--#FAF.002.sn
	 where a.t$ttyp=tfacr200.t$ttyp
	 and a.t$ninv=tfacr200.t$ninv),1) CD_SITUACAO_TITULO,
	(select min(a.t$docd) from baandb.ttfacr200201 a
	 where a.t$ttyp=tfacr200.t$ttyp 
	 and a.t$ninv=tfacr200.t$ninv
	 and a.t$docn!=0) DT_SITUACAO_TITULO,																			--#FAF.002.en
	TO_DATE(REGEXP_REPLACE(tfacr200.t$dued,',''[[:punct:]]',''), 'DD-MM-YY HH:MI:SS AM') DT_VENCIMENTO_ORIGINAL,		--#FAF.001.n
	tfacr200.t$bank NR_BANCARIO,
	tfacr200.t$balc VL_SALDO,
--	tfacr200.t$amti VL_DESCONTO,																						--#FAF.146.1.o
	tfacr200.t$dc1h$1 + tfacr200.t$dc2h$1 +tfacr200.t$dc3h$1 VL_DESCONTO,														--#FAF.146.1.n
--	tfacr200.t$ninv NR_DOCUMENTO,																						--#FAF.193.o
	tfacr200.t$ninv NR_TITULO,																							--#FAF.193.n
    nvl((select t.t$text from baandb.ttttxt010201 t 
	where t$clan='p'
	AND t.t$ctxt=tfacr200.t$text
	and rownum=1),' ') DS_OBSERVACAO_TITULO,
	tfgld100.t$user DS_USUARIO_GERACAO_TITULO,
--	CAST((FROM_TZ(CAST(TO_CHAR(tfacr200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') --#MAR.273.so
--		AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,                                        --#MAR.273.eo
  GREATEST(                                                                                         --#MAR.273.sn
    nvl(CAST((FROM_TZ(CAST(TO_CHAR(tfacr200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
      AT time zone sessiontimezone) AS DATE), TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),
--    nvl(CAST((FROM_TZ(CAST(TO_CHAR(tfacr201.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 								--#FAF.282.o
    nvl(CAST((FROM_TZ(CAST(TO_CHAR(																										--#FAF.282.sn
	(select max(a.t$rcd_utc) from baandb.ttfacr201201 a
	 where a.t$ttyp=tfacr200.t$ttyp
	 and a.t$ninv=tfacr200.t$ninv)	, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 													--#FAF.282.en
      AT time zone sessiontimezone) AS DATE), TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),
    nvl(CAST((FROM_TZ(CAST(TO_CHAR(tfcmg001.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
      AT time zone sessiontimezone) AS DATE), TO_DATE('01-JAN-1970', 'DD-MON-YYYY')))
                                              DT_ATUALIZACAO,                                     --#MAR.273.en
	(Select u.t$eunt From baandb.ttcemm030201 u
		where u.t$euca!=' '
		AND TO_NUMBER(u.t$euca)=CASE WHEN tfacr200.t$dim2=' ' then 999
			WHEN tfacr200.t$dim2>to_char(0) then 999 
			else TO_NUMBER(tfacr200.t$dim2) END
			and rownum = 1) CD_UNIDADE_EMPRESARIAL,
	(select znsls401.t$pecl$c from baandb.tznsls401201 znsls401, baandb.tcisli940201 rf, baandb.tcisli245201 ro
	 where rf.t$ityp$l=tfacr200.t$ttyp
	 and rf.t$idoc$l=tfacr200.t$ninv
	 and ro.t$fire$l=rf.t$fire$l
	 and znsls401.t$orno$c=ro.t$slso
	 and znsls401.t$pono$c=ro.t$pono
	 and rownum=1) NR_PEDIDO,
--	 tfacr200.t$paym CD_METODO_RECEBIMENTO,	--#FAF.008.n  --#MAR.273.o
--	 tfacr201.t$paym CD_METODO_RECEBIMENTO,	--#MAR.273.n	--#FAF.282.o
	(select a.t$send$l from baandb.ttfcmg948201 a
	 where a.t$ttyp$l=tfacr200.t$ttyp
	 and a.t$ninv$l=tfacr200.t$ninv
	 and rownum=1																						--#FAF.141.n
	 and a.t$lach$l = (select max(b.t$lach$l) from baandb.ttfcmg948201 b
					 where b.t$ttyp$l=a.t$ttyp$l
					 and a.t$ninv$l=b.t$ninv$l)) CD_SITUACAO_PAGAMENTO									--#FAF.108.n
FROM
--	baandb.ttfacr201201 tfacr201,             --#MAR.273.n	--#FAF.282.o
	baandb.ttfacr200201 tfacr200
	LEFT JOIN baandb.ttfcmg001201 tfcmg001
	ON  tfcmg001.t$bank=tfacr200.t$bank
	LEFT JOIN baandb.ttfcmg011201 tfcmg011
	ON  tfcmg011.t$bank=tfcmg001.t$brch
	LEFT JOIN baandb.ttfcmg401201 tfcmg401
	ON tfcmg401.t$ttyp=tfacr200.t$ttyp
	AND tfcmg401.t$ninv=tfacr200.t$ninv
	AND tfcmg401.t$ttyp=tfacr200.t$ttyp
	LEFT JOIN baandb.ttfcmg409201 tfcmg409
	ON  tfcmg409.t$btno=tfcmg401.t$btno,
  baandb.ttfgld100201 tfgld100
WHERE tfgld100.t$btno=tfacr200.t$btno
AND tfgld100.t$year=tfacr200.t$year
AND tfacr200.t$docn=0
--AND tfacr201.t$ttyp = tfacr200.t$ttyp               --#MAR.273.sn		--#FAF.282.o
--AND tfacr201.t$ninv = tfacr200.t$ninv               --#MAR.273.en		--#FAF.282.o
