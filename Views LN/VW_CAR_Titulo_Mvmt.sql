-- 06-mai-2014, Fabio Ferreira, Correção timezone
-- #FAF.001 - 08-mai-2014, Fabio Ferreira, 	Retirar tratamento de data/hora	
-- #FAF.002 - 09-mai-2014, Fabio Ferreira, 	Correção titulo referencia	
-- #FAF.005 - 14-mai-2014, Fabio Ferreira, 	Incluido campo módulo do título de referência (sempre 'CR')	
-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Correção tpitulo de referência agrupado	
-- #FAF.079 - 26-mai-2014, Fabio Ferreira, 	Alterado o campo SITUACAO_MOVIMENTO para usar o valor da programação de pagamento
-- #FAF.102 - 04-jun-2014, Fabio Ferreira, 	Correçãp campo COD_DOCUMENTO e alteração de alias		
-- #FAF.148 - 18-jun-2014, Fabio Ferreira, 	Alteração campo NR_MOVIMENTO
-- #FAF.186 - 30-jun-2014, Fabio Ferreira, 	Correção alias e inclusão do número da programação
-- #FAF.186.1 - 01-jul-2014, Fabio Ferreira, 	Padronização de alias CAR CAP e inclusão das datas da agenda
-- #FAF.186.2 - 02-jul-2014, Fabio Ferreira, 	Correção campo CD_TRANSACAO_DOCUMENTO								
--****************************************************************************************************************************************************************
SELECT DISTINCT
	201 CD_CIA,
	CASE WHEN nvl((	select c.t$styp from tcisli205201 c
					where c.t$styp='BL ATC'
					AND c.T$ITYP=tfacr200.t$ttyp
					AND c.t$idoc=tfacr200.t$ninv
					AND rownum=1),0)=0 THEN 2 ELSE 3 END CD_FILIAL,
--	tfacr200.t$docn NR_MOVIMENTO,																			--#FAF.186.o
	tfacr200.t$docn NR_MOVIMENTO,																			--#FAF.186.n
--	tfacr200.t$lino NR_MOVIMENTO,
	nvl(r.t$lino, tfacr200.t$lino) SQ_MOVIMENTO,															--#FAF.186.1.n
	tfacr200.t$schn NR_PROGRAMACAO,																			--#FAF.186.n
--	CONCAT(tfacr200.t$ttyp, TO_CHAR(tfacr200.t$ninv)) NR_TITULO,											--#FAF.186.1.o
	CONCAT(tfacr200.t$ttyp, TO_CHAR(tfacr200.t$ninv)) CD_CHAVE_PRIMARIA,									--#FAF.186.1.sn
	'CR' CD_MODULO,
--	tfacr200.t$doct$l COD_DOCUMENTO,																		--#FAF.102.o
	tfacr200.t$tdoc CD_TRANSACAO_DOCUMENTO,																	--#FAF.186.1.n
	t.t$doct$l CD_TIPO_NF,																					--#FAF.102.n
	tfacr200.t$ttyp CD_TRANSACAO_TITULO,																	--#FAF.186.1.en
	tfacr200.t$trec CD_TIPO_DOCUMENTO,
	CASE WHEN tfacr200.t$amnt<0 THEN '-' ELSE '+' END IN_ENTRADA_SAIDA,
	tfacr200.t$docd DT_TRANSACAO,
--	tfacr200.t$amnt VL_TRANSACAO,																			--#FAF.186.o
	nvl(r.t$amnt*-1, tfacr200.t$amnt)  VL_TRANSACAO,															--#FAF.186.n
	--	tfcmg409.t$stdd SITUACAO_MOVIMENTO,																	--#FAF.079.o
	(select p.t$rpst$l from ttfacr201201 p
	 where p.t$ttyp=tfacr200.t$ttyp
	 and p.t$ninv=tfacr200.t$ninv 
	 and p.t$schn=tfacr200.t$schn) CD_PREPARADO_PAGAMENTO,													--#FAF.079.n
	CASE WHEN t.t$balc=t.t$bala															-- Liquidado	--#FAF.079.sn
	THEN (select max(t$docd) from ttfacr200201 m
	 where m.t$ttyp=tfacr200.t$ttyp
	 and m.t$ninv=tfacr200.t$ninv 
	 and m.t$schn=tfacr200.t$schn)
	WHEN t.t$balc=t.t$amnt																-- Nenhum recebimento
	THEN tfacr200.t$docd
	ELSE (select min(t$docd) from ttfacr200201 m										-- Primeiro rec parcial 
	 where m.t$ttyp=tfacr200.t$ttyp
	 and m.t$ninv=tfacr200.t$ninv 
	 and m.t$schn=tfacr200.t$schn)
	END DT_SITUACAO_MOVIMENTO, 																			--#FAF.079.en
	tfcmg011.t$baoc$l CD_BANCO,
	tfcmg011.t$agcd$l NR_AGENCIA,
	tfcmg001.t$bano NR_CONTA_CORRENTE,																			--#FAF.001.n
	CAST((FROM_TZ(CAST(TO_CHAR(tfacr200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,
	(Select u.t$eunt From ttcemm030201 u
	 where u.t$euca!=' '
	AND TO_NUMBER(u.t$euca)=CASE WHEN tfacr200.t$dim2=' ' then 999
	WHEN tfacr200.t$dim2<=to_char(0) then 999 
	else TO_NUMBER(tfacr200.t$dim2) END
	and rownum = 1
	) CD_UNIDADE_EMPRESARIAL,
	nvl((select znacr005.t$ttyp$c || znacr005.t$ninv$c from BAANDB.tznacr005201 znacr005				--#FAF.002.sn
		 where znacr005.t$tty1$c=tfacr200.t$ttyp and znacr005.t$nin1$c=tfacr200.t$ninv
		 and znacr005.T$FLAG$C=1																		--#FAF.007.n
		 and rownum=1), r.t$ttyp || r.t$ninv) NR_TITULO_REFERENCIA,												--#FAF.002.en
	'CR' CD_MODULO_TITULO_REFERENCIA,																	--#FAF.005.n
	tfacr200.t$ninv NR_TITULO,
--	tfacr200.t$doct$l COD_DOCUMENTO,																		--#FAF.102.o	--#FAF.186.1.o
--	tfacr200.t$doct$l CD_TRANSACAO_DOCUMENTO,																--#FAF.186.1.o
--	tfacr200.t$tdoc CD_TRANSACAO_TITULO,
	--tfacr200.t$dim1 NUM_CONTA																			--#FAF.001.o
	tfacr201.t$recd DT_VENCTO_PRORROGADO,																		--#FAF.186.1.sn
	tfacr201.t$dued$l DT_VENCTO_ORIGINAL_PRORROGADO,
	tfacr201.t$liqd DT_LIQUIDEZ_PREVISTA																		--#FAF.186.1.en
	
FROM
	ttfacr200201 tfacr200
	LEFT JOIN (	select distinct rs.t$ttyp, rs.t$ninv, rs.t$tdoc, rs.t$docn,
								rs.t$lino, rs.t$amnt														--#FAF.186.1.n
				from ttfacr200201 rs) r																		--#FAF.002.sn		
	ON r.t$tdoc=tfacr200.t$tdoc 
	and r.t$docn=tfacr200.t$docn
	and r.t$ttyp!=tfacr200.t$ttyp
	and r.t$ninv!=tfacr200.t$ninv																			--#FAF.002.en
	
--	LEFT JOIN (select a.t$ttyp, a.t$ninv, a.t$brel FROM ttfacr201201 a										--#FAF.001.sn	--#FAF.186.1.so
--	where a.t$brel!=' '
--	and a.t$schn=(select min(b.t$schn) from ttfacr201201 b
--              where a.t$ttyp=b.t$ttyp
--              and   a.t$ninv=b.t$ninv
--              and   b.t$brel!=' ')) q1 on q1.t$ttyp=tfacr200.t$ttyp and q1.t$ninv=tfacr200.t$ninv			--#FAF.001.en	--#FAF.186.1.eo
	
	LEFT JOIN ttfacr201201 tfacr201 	ON 	tfacr201.t$ttyp=tfacr200.t$ttyp
										AND tfacr201.t$ninv=tfacr200.t$ninv
										AND tfacr201.t$schn=tfacr200.t$schn

	LEFT JOIN ttfcmg001201 tfcmg001
--	ON  tfcmg001.t$bank=q1.t$brel																			--#FAF.186.1.o
	ON  tfcmg001.t$bank=tfacr201.t$brel																		--#FAF.186.1.n
	LEFT JOIN ttfcmg011201 tfcmg011
	ON  tfcmg011.t$bank=tfcmg001.t$brch
	LEFT JOIN ttfcmg409201 tfcmg409
	ON  tfcmg409.t$btno=tfacr200.t$btno,
	ttfacr200201 t																							--#FAF.079.n
	
WHERE
      tfacr200.t$docn!=0
AND   t.t$ttyp=tfacr200.t$ttyp																				--#FAF.079.sn
AND   t.t$ninv=tfacr200.t$ninv
AND   t.t$docn=0																							--#FAF.079.en