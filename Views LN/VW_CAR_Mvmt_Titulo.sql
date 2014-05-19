-- 06-mai-2014, Fabio Ferreira, Correção timezone
-- #FAF.001 - 08-mai-2014, Fabio Ferreira, 	Retirar tratamento de data/hora	
-- #FAF.002 - 09-mai-2014, Fabio Ferreira, 	Correção titulo referencia	
-- #FAF.005 - 14-mai-2014, Fabio Ferreira, 	Incluido campo módulo do título de referência (sempre 'CR')	
-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Correção tpitulo de referência agrupado					
--****************************************************************************************************************************************************************
SELECT
    201 COMPANHIA,
	CASE WHEN nvl((	select c.t$styp from tcisli205201 c
					where c.t$styp='BL ATC'
					AND c.T$ITYP=tfacr200.t$ttyp
					AND c.t$idoc=tfacr200.t$ninv
					AND rownum=1),0)=0 
	THEN 2
	ELSE 3
	END COD_FILIAL,
	(Select u.t$eunt From ttcemm030201 u
	 where u.t$euca!=' '
   AND TO_NUMBER(u.t$euca)=CASE WHEN tfacr200.t$dim2=' ' then 999
   WHEN tfacr200.t$dim2<=to_char(0) then 999 
   else TO_NUMBER(tfacr200.t$dim2) END
   and rownum = 1
   ) UNID_EMPRESARIAL,
	tfacr200.t$lino NUM_MOVIMENTO,
	CONCAT(tfacr200.t$ttyp, TO_CHAR(tfacr200.t$ninv)) NUM_TITULO,
	'CR' COD_MODULO,
	tfacr200.t$doct$l COD_DOCUMENTO,
	tfacr200.t$tdoc COD_TRANSACAO,
	tfacr200.t$trec COD_TIPO_DE_VALOR,
	CASE WHEN tfacr200.t$amnt<0 THEN '-' ELSE '+' END SINAL,
	tfacr200.t$docd DATA_TRANSACAO,
	tfacr200.t$amnt VALOR_TRANSACAO,
	tfcmg409.t$stdd SITUACAO_MOVIMENTO,
	CAST((FROM_TZ(CAST(TO_CHAR(tfcmg409.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
		AT time zone sessiontimezone) AS DATE) DATA_SITUACAO_MOVIMENTO,		
	nvl((select znacr005.t$ttyp$c || znacr005.t$ninv$c from BAANDB.tznacr005201 znacr005				--#FAF.002.sn
		 where znacr005.t$tty1$c=tfacr200.t$ttyp and znacr005.t$nin1$c=tfacr200.t$ninv
		 and znacr005.T$FLAG$C=1																		--#FAF.007.n
		 and rownum=1), r.t$ttyp || r.t$ninv) TITULO_REFER,												--#FAF.002.en
	'CR' ID_MODULO_TITULO_REFERENCIA,																	--#FAF.005.n
	tfcmg011.t$baoc$l COD_BANCO,
	tfcmg011.t$agcd$l NUM_AGENCIA,
	tfcmg001.t$bano NUM_CONTA,																			--#FAF.001.n
	--tfacr200.t$dim1 NUM_CONTA,																		--#FAF.001.o
	CAST((FROM_TZ(CAST(TO_CHAR(tfacr200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DATA_E_HORA_DE_ATUALIZACAO
FROM
	ttfacr200201 tfacr200
	
	LEFT JOIN (select distinct rs.t$ttyp, rs.t$ninv, rs.t$tdoc, rs.t$docn from ttfacr200201 rs) r			--#FAF.002.sn		
	ON r.t$tdoc=tfacr200.t$tdoc 
	and r.t$docn=tfacr200.t$docn
	and r.t$ttyp!=tfacr200.t$ttyp
	and r.t$ninv!=tfacr200.t$ninv																			--#FAF.002.en
	
	LEFT JOIN (select a.t$ttyp, a.t$ninv, a.t$brel FROM ttfacr201201 a									--#FAF.001.sn
	where a.t$brel!=' '
	and a.t$schn=(select min(b.t$schn) from ttfacr201201 b
              where a.t$ttyp=b.t$ttyp
              and   a.t$ninv=b.t$ninv
              and   b.t$brel!=' ')) q1 on q1.t$ttyp=tfacr200.t$ttyp and q1.t$ninv=tfacr200.t$ninv		--#FAF.001.en
	
	LEFT JOIN ttfcmg001201 tfcmg001
	ON  tfcmg001.t$bank=q1.t$brel
	LEFT JOIN ttfcmg011201 tfcmg011
	ON  tfcmg011.t$bank=tfcmg001.t$brch
	LEFT JOIN ttfcmg409201 tfcmg409
	ON  tfcmg409.t$btno=tfacr200.t$btno
WHERE
  tfacr200.t$docn!=0
