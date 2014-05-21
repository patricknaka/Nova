<<<<<< HEAD
-- #FAF.005, 14-mai-2014, Fabio Ferreira,	Retirado conversão de timezone do campo data de atualização.
=======
-- #FAF.005, 14-mai-2014, Fabio Ferreira,	Retirado conversï¿½o de timezone do campo data de atualizaï¿½ï¿½o
>>>>>>> 0223431cce3f25843741f42904e5d6704785afcc
--							
--**********************************************************************************************************************************************************
--
SELECT
	tfgld205.t$cono || 
	tfgld205.t$leac || 
	tfgld205.t$year || 
	tfgld205.t$prno || 
	tfgld205.t$dim1 || 
	tfgld205.t$dim2 ||
	tfgld205.t$dim3 ||
	tfgld205.t$dim4 ||
	tfgld205.t$dim5  CHAVE,
	tfgld205.t$ptyp COD_BALANCETE_GERENCIAL,
	tfgld205.t$dim2 COD_FILIAL,
	(Select u.t$eunt From ttcemm030201 u where u.t$euca!=' '
		AND TO_NUMBER(u.t$euca)=CASE WHEN tfgld205.t$dim2=' ' then 999
		WHEN tfgld205.t$dim2<=to_char(0) then 999 else TO_NUMBER(tfgld205.t$dim2) END and rownum = 1) UNID_EMPRESARIAL,	
	tfgld205.t$cono COD_CIA,
	tfgld205.t$year, tfgld205.t$prno DATA_BALANCETE,
	tfgld205.t$leac COD_CONTA,
	tfgld205.t$dim1 COD_CENTRO_CUSTO,
	nvl(tfgld212.t$ftob,0)+nvl((SELECT (SUM(s.t$fcam)-SUM(s.t$fdam))
					FROM ttfgld205201 s
					WHERE s.t$cono=tfgld205.t$cono
					AND   s.t$ptyp=tfgld205.t$ptyp
					AND   s.t$year=tfgld205.t$year
					AND   s.t$prno<tfgld205.t$prno
					AND   s.t$dim1=tfgld205.t$dim1
					AND   s.t$dim2=tfgld205.t$dim2
					AND   s.t$dim3=tfgld205.t$dim3
					AND   s.t$dim4=tfgld205.t$dim4
					AND   s.t$dim5=tfgld205.t$dim5
					AND   s.t$dims=tfgld205.t$dims
					AND   s.t$leac=tfgld205.t$leac
					AND   s.t$ccur=tfgld205.t$ccur
					AND   s.t$duac=tfgld205.t$duac
					AND   s.t$bpid=tfgld205.t$bpid),0)	VALOR_SALDO_ANTERIOR,
	tfgld205.t$fdam VALOR_DEBITOS,
	tfgld205.t$fcam VALOR_CREDITOS,
	(SELECT 
--	CAST((FROM_TZ(CAST(TO_CHAR(MAX(tfgld100.t$trdt), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 		--#FAF.005.o
--			AT time zone sessiontimezone) AS DATE)															--#FAF.005.o
	MAX(tfgld100.t$trdt)																					--#FAF.005.n
	FROM ttfgld100201 tfgld100
	WHERE tfgld100.t$year=tfgld205.t$year
	AND   tfgld100.t$fprd=tfgld205.t$prno
	AND   tfgld100.t$stat=6) DATA_E_HORA_ATUALIZACAO
FROM 
	ttfgld205201 tfgld205
	LEFT JOIN ttfgld212201 tfgld212
ON	tfgld212.t$cono=tfgld205.t$cono
AND	tfgld212.t$year=tfgld205.t$year
AND	tfgld212.t$dim1=tfgld205.t$dim1
AND	tfgld212.t$dim2=tfgld205.t$dim2
AND	tfgld212.t$dim3=tfgld205.t$dim3
AND	tfgld212.t$dim4=tfgld205.t$dim4
AND	tfgld212.t$dim5=tfgld205.t$dim5
AND	tfgld212.t$dims=tfgld205.t$dims
AND	tfgld212.t$leac=tfgld205.t$leac
AND	tfgld212.t$ccur=tfgld205.t$ccur
WHERE tfgld205.t$dim1!=' '
AND tfgld205.t$ptyp=1
