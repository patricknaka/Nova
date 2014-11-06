-- FAF.001 - 08-mai-2014, Fabio Ferreira, Quando título com link de agupamento estava duplicando
-- FAF.002 - 09-mai-2014, Fabio Ferreira, 	Correção campo COD_TRANSAÇAO
--											CORREÇÃO TÍTULO REALCIONADO PARA MOTRAR O TITULO DE AGUPAMENTO QUANDO AGRUPADO
-- FAF.003 - 12-mai-2014, Fabio Ferreira, 	Correção DT_HR_ATUALIZACAO para não fazer a conversão de timezone quando data=0
-- #FAF.115 - 	07-jun-2014, Fabio Ferreira, 	Inclusão do campo CIA
-- #FAF.111 - 	09-jun-2014, Fabio Ferreira, 	Campo CD_TIPO_MOVIMENTO
-- #FAF.168 - 	24-jun-2014, Fabio Ferreira, 	Correção registros duplicados
-- #FAF.188 - 	30-jun-2014, Fabio Ferreira, 	Correção alias e inclusão do número da programação
-- #FAF.192 - 	02-jul-2014, Fabio Ferreira, 	Correção duplicidade devido a referência com pagamento previsto
-- #FAF.186.2 - 02-jul-2014, Fabio Ferreira, 	Correção duplicidade
-- #FAF.211 - 	07-jul-2014, Fabio Ferreira, 	Correção relacionamento titulo agrupado
-- #FAF.212 - 	07-jul-2014, Fabio Ferreira, 	Alteração campo CD_TIPO_MOVIMENTO
-- #FAF.215 - 	08-jul-2014, Fabio Ferreira, 	Correção campo NR_TITULO_REFERENCIA
-- #FAF.212.1 - 10-jul-2014, Fabio Ferreira, 	Correção campo CD_TIPO_MOVIMENTO
-- 21/08/2014 - Atualização do timezone
--****************************************************************************************************************************************************************

SELECT DISTINCT
	1 CD_CIA,																									--#FAF.113.n
--	nvl(r.t$lino, tfacP200.t$lino) NR_MOVIMENTO,																--#FAF.188.o
--	nvl(r.t$lino, tfacP200.t$lino) SQ_MOVIMENTO,																--#FAF.188.n	--#FAF.186.2.o
	tfacP200.t$lino SQ_MOVIMENTO,																				--#FAF.186.2.n
	tfacp200.t$ninv NR_TITULO,
    tfacp200.t$ttyp CD_TRANSACAO_TITULO,
	'CAP' CD_MODULO,																		
--	tfacp200.t$docn SQ_DOCUMENTO,																				--#FAF.188.o
	tfacp200.t$docn NR_MOVIMENTO,																				--#FAF.188.n
	tfacp200.t$schn NR_PROGRAMACAO,																				--#FAF.188.n	
	tfacp200.t$tdoc CD_TRANSACAO_DOCUMENTO,																		--#FAF.002.n
	tfacp200.t$tpay CD_TIPO_PAGAMENTO,
	tfacp200.t$docd DT_TRANSACAO,
	CASE WHEN tfacp200.t$amth$1<0 THEN '-' ELSE '+' END IN_ENTRADA_SAIDA,
	'CAP' CD_MODULO_REFERENCIA, 
	nvl((select znacp004.t$ttyp$c || znacp004.t$ninv$c from BAANDB.tznacp004201 znacp004						--#FAF.002.sn
		 where znacp004.t$tty1$c=tfacp200.t$ttyp and znacp004.t$nin1$c=tfacp200.t$ninv
		 and znacp004.t$tty2$c=tfacp200.t$tdoc and znacp004.t$nin2$c=tfacp200.t$docn							--#FAF.211.o
		 and rownum=1), 
		(select  rs.t$ttyp || rs.t$ninv from baandb.ttfacp200201 rs
		 where rs.t$tdoc=tfacp200.t$tdoc
		 and rs.t$docn=tfacp200.t$docn
		 and rs.t$ttyp || rs.t$ninv!=tfacp200.t$ttyp || tfacp200.t$ninv											--#FAF.215.n
--		 and rs.t$ttyp!=tfacp200.t$ttyp																			--#FAF.215.o
--		 and rs.t$ninv!=tfacp200.t$ninv																			--#FAF.215.o
		 and rs.t$tpay!=8	
		 and rs.t$amnt=tfacp200.t$amnt*-1
		 and rownum=1)
--		 r.t$ttyp || r.t$ninv																					--#FAF.186.2.o
											) NR_TITULO_REFERENCIA,												--#FAF.002.en

	(select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(s.t$sdat), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone sessiontimezone) AS DATE) from baandb.ttfacp600201 s 
		where s.t$payt=tfacp200.t$tdoc and s.t$payd=tfacp200.t$docn) DT_SITUACAO,
		
--	nvl(r.t$amth$1, tfacp200.t$amth$1) VL_TRANSACAO,															--#FAF.186.2.o
	tfacp200.t$amth$1 VL_TRANSACAO,																				--#FAF.186.2.n

	CASE WHEN tfacp200.t$rcd_utc<TO_DATE('1990-01-01', 'YYYY-MM-DD') THEN tfacp200.t$rcd_utc					--#FAF.003.en
	ELSE	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacp200.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) END DT_ULT_ATUALIZACAO,

	tfacp200.t$ttyp || tfacp200.t$ninv CD_CHAVE_PRIMARIA,
	CASE WHEN tfacp200.t$tdoc='ENC' THEN 5																							--#FAF.212.1.n
	  WHEN (select a.t$catg from baandb.ttfgld011201 a where a.t$ttyp=tfacp200.t$tdoc)=10 THEN 3
	  WHEN tfacp200.t$tdoc='PLG' THEN 1
	  WHEN tfacp200.t$tdoc='LKF' THEN 2
	--  WHEN tfacp200.t$tdoc='PKF' THEN 2																			--#FAF.212.o
--	  WHEN tfacp200.t$tdoc='ENC' THEN 5																				--#FAF.212.n	--#FAF.212.1.o
	  WHEN tfacp200.t$tdoc='RKF' THEN 4
  
  ELSE 0 END
  CD_TIPO_MOVIMENTO
--  CAST((FROM_TZ(CAST(TO_CHAR(tfacp200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.003.so
--        AT time zone sessiontimezone) AS DATE) DT_HR_ATUALIZACAO										--#FAF.003.eo
FROM
	baandb.ttfacp200201 tfacp200
																																--#FAF.186.2.so
--  LEFT JOIN (select distinct rs.t$ttyp, rs.t$ninv, rs.t$tdoc, rs.t$docn, rs.t$lino, rs.t$amth$1, rs.t$tpay from ttfacp200201 rs) r
--  ON r.t$tdoc=tfacp200.t$tdoc 
--  and r.t$docn=tfacp200.t$docn
--  and r.t$ttyp!=tfacp200.t$ttyp
--  and r.t$ninv!=tfacp200.t$ninv
--  and r.t$tpay!=8																								--#FAF.192.n	--#FAF.186.2.eo
WHERE tfacp200.t$docn>0
--AND tfacp200.t$ttyp || tfacp200.t$ninv='PNG6'