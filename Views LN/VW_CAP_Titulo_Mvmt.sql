-- FAF.001 - 08-mai-2014, Fabio Ferreira, Quando título com link de agupamento estava duplicando
-- FAF.002 - 09-mai-2014, Fabio Ferreira, 	Correção campo COD_TRANSAÇAO
--											CORREÇÃO TÍTULO REALCIONADO PARA MOTRAR O TITULO DE AGUPAMENTO QUANDO AGRUPADO
-- FAF.003 - 12-mai-2014, Fabio Ferreira, 	Correção DT_HR_ATUALIZACAO para não fazer a conversão de timezone quando data=0
--****************************************************************************************************************************************************************

SELECT 
  tfacp200.t$ttyp || tfacp200.t$ninv CHAVE,
  tfacp200.t$ttyp TIPO_TRANSAC,
	tfacP200.t$lino NUM_MOVIMENTO,
	tfacp200.t$ninv NUM_TITULO,
	'CP' COD_MODULO,																		
	tfacp200.t$docn SEQ_DOCUMENTO,
--	tfacp200.t$ttyp COD_TRANSACAO,																		--#FAF.002.o
	tfacp200.t$tdoc COD_TRANSACAO,																		--#FAF.002.n
	tfacp200.t$tpay COD_TIPO_DOCUMENTO,
	tfacp200.t$docd DATA_TRANSACAO,
	CASE WHEN tfacp200.t$amth$1<0 THEN '-'
  ELSE '+'
  END SINAL,
	'CP' COD_MODULO_TITULO_REFER, 
--	r.t$ttyp || r.t$ninv TITULO_REFER,																	--#FAF.002.o
	nvl((select znacp004.t$ttyp$c || znacp004.t$ninv$c from BAANDB.tznacp004201 znacp004				--#FAF.002.sn
		 where znacp004.t$tty1$c=tfacp200.t$ttyp and znacp004.t$nin1$c=tfacp200.t$ninv
		 and rownum=1), r.t$ttyp || r.t$ninv) TITULO_REFER,												--#FAF.002.en
	(select t.t$stap from ttfacp200201 t 
   where t.t$ttyp=tfacp200.t$ttyp and t.t$ninv=tfacp200.t$ninv and t.t$docn=0) SITUACAO_MOVIMENTO,
	(select CAST((FROM_TZ(CAST(TO_CHAR(max(s.t$sdat), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE)
	 from ttfacp600201 s 
  where s.t$payt=tfacp200.t$tdoc and s.t$payd=tfacp200.t$docn) DATA_SITUACAO_MOVIMENTO,
	tfacp200.t$amth$1 VALOR_TRANSACAO,
	
	CASE WHEN tfacp200.t$rcd_utc<TO_DATE('1990-01-01', 'YYYY-MM-DD') THEN tfacp200.t$rcd_utc					--#FAF.003.en
	ELSE	CAST((FROM_TZ(CAST(TO_CHAR(tfacp200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	
				AT time zone sessiontimezone) AS DATE) 
	END DT_HR_ATUALIZACAO																						--#FAF.003.en  
  
--  CAST((FROM_TZ(CAST(TO_CHAR(tfacp200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.003.so
--        AT time zone sessiontimezone) AS DATE) DT_HR_ATUALIZACAO										--#FAF.003.eo
FROM
	ttfacp200201 tfacp200
  LEFT JOIN (select distinct rs.t$ttyp, rs.t$ninv, rs.t$tdoc, rs.t$docn from ttfacp200201 rs) r
  ON r.t$tdoc=tfacp200.t$tdoc 
  and r.t$docn=tfacp200.t$docn
  and r.t$ttyp!=tfacp200.t$ttyp
  and r.t$ninv!=tfacp200.t$ninv
WHERE tfacp200.t$docn>0