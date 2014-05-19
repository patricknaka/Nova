--***************************************************************************************************************
SELECT
	tfgld010.t$dimx FILIAL,
	tfgld010.t$desc	DESCR,
	tfgld010.t$pdix DIM_MAE
FROM ttfgld010201 tfgld010
WHERE tfgld010.t$dtyp=2