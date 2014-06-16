-- 06-mai-2014, Fabio Ferreira, Inclusão do numero do pedido
-- #FAF.001 - 06-mai-2014, Fabio Ferreira, 	Tratamento da data de vencimento	
-- #FAF.002 - 09-mai-2014, Fabio Ferreira, 	Correção dos campos referente a situação do título				
-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Adicionado campo método de pagamento/recebimento
-- #FAF.008 - 21-mai-2014, Fabio Ferreira, 	Alterado alias campo método de pagamento/recebimento	
-- #FAF.108 - 05-jun-2014, Fabio Ferreira, 	Inclusão da situação da remessa
-- #FAF.141 - 16-jun-2014, Fabio Ferreira, 	Problema mais de um registro na subquery
--****************************************************************************************************************************************************************
SELECT	
  CONCAT(tfacr200.t$ttyp, TO_CHAR(tfacr200.t$ninv)) NR_TITULO,
  tfacr200.t$ttyp CD_TIPO_TRANSACAO,
    201 CD_CIA,
	CASE WHEN nvl((	select c.t$styp from tcisli205201 c
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
	TO_DATE(REGEXP_REPLACE(tfacr200.T$LIQD,',''[[:punct:]]',''), 'DD-MM-YY HH:MI:SS AM') DT_VENCIMENTO,	--#FAF.001.n
  (select max(p.t$docd) from ttfacr200201 p
  where p.t$ttyp=tfacr200.t$ttyp
  and p.t$ninv=tfacr200.t$ninv
  and p.t$trec=2) DT_LIQUIDACAO_TITULO,
	tfacr200.t$amnt VL_TITULO,
	tfcmg011.t$baoc$l CD_BANCO,
	tfcmg011.t$agcd$l NR_AGENCIA,
	tfcmg001.t$bano NR_CONTA_CORRENTE,
	tfacr200.t$dim1 CD_CENTRO_CUSTO,
	tfcmg401.t$btno NR_REMESSA,
	tfcmg409.t$date DT_REMESSA,
--#FAF.002.o
	nvl((select max(a.t$rpst$l) from ttfacr201201 a																	--#FAF.002.sn
	 where a.t$ttyp=tfacr200.t$ttyp
	 and a.t$ninv=tfacr200.t$ninv),1) CD_SITUACAO_TITULO,
	(select min(a.t$docd) from ttfacr200201 a
	 where a.t$ttyp=tfacr200.t$ttyp 
	 and a.t$ninv=tfacr200.t$ninv
	 and a.t$docn!=0) DT_SITUACAO_TITULO,																			--#FAF.002.en
	TO_DATE(REGEXP_REPLACE(tfacr200.t$dued,',''[[:punct:]]',''), 'DD-MM-YY HH:MI:SS AM') DT_VENCIMENTO_ORIGINAL,		--#FAF.001.n
	tfacr200.t$bank NR_BANCARIO,
	tfacr200.t$balc VL_SALDO,
	tfacr200.t$amti VL_DESCONTO,
	tfacr200.t$ninv NR_DOCUMENTO,
    nvl((select t.t$text from ttttxt010201 t 
	where t$clan='p'
	AND t.t$ctxt=tfacr200.t$text
	and rownum=1),' ') DS_OBSERVACAO_TITULO,
	tfgld100.t$user DS_USUARIO_GERACAO_TITULO,
	CAST((FROM_TZ(CAST(TO_CHAR(tfacr200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
		AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,
	(Select u.t$eunt From ttcemm030201 u
		where u.t$euca!=' '
		AND TO_NUMBER(u.t$euca)=CASE WHEN tfacr200.t$dim2=' ' then 999
			WHEN tfacr200.t$dim2>to_char(0) then 999 
			else TO_NUMBER(tfacr200.t$dim2) END
			and rownum = 1) CD_UNIDADE_EMPRESARIAL,
	(select znsls401.t$pecl$c from tznsls401201 znsls401, tcisli940201 rf, tcisli245201 ro
	 where rf.t$ityp$l=tfacr200.t$ttyp
	 and rf.t$idoc$l=tfacr200.t$ninv
	 and ro.t$fire$l=rf.t$fire$l
	 and znsls401.t$orno$c=ro.t$slso
	 and znsls401.t$pono$c=ro.t$pono
	 and rownum=1) NR_PEDIDO,
	 tfacr200.t$paym CD_METODO_RECEBIMENTO,	--#FAF.008.n
	(select a.t$send$l from ttfcmg948201 a
	 where a.t$ttyp$l=tfacr200.t$ttyp
	 and a.t$ninv$l=tfacr200.t$ninv
	 and rownum=1																						--#FAF.141.n
	 and a.t$lach$l = (select max(b.t$lach$l) from ttfcmg948201 b
					 where b.t$ttyp$l=a.t$ttyp$l
					 and a.t$ninv$l=b.t$ninv$l)) CD_SITUACAO_PAGAMENTO									--#FAF.108.n
FROM
	ttfacr200201 tfacr200
	LEFT JOIN ttfcmg001201 tfcmg001
	ON  tfcmg001.t$bank=tfacr200.t$bank
	LEFT JOIN ttfcmg011201 tfcmg011
	ON  tfcmg011.t$bank=tfcmg001.t$brch
	LEFT JOIN ttfcmg401201 tfcmg401
	ON tfcmg401.t$ttyp=tfacr200.t$ttyp
	AND tfcmg401.t$ninv=tfacr200.t$ninv
	AND tfcmg401.t$ttyp=tfacr200.t$ttyp
	LEFT JOIN ttfcmg409201 tfcmg409
	ON  tfcmg409.t$btno=tfcmg401.t$btno,
  ttfgld100201 tfgld100
WHERE tfgld100.t$btno=tfacr200.t$btno
AND tfgld100.t$year=tfacr200.t$year
AND tfacr200.t$docn=0