--	#FAF.167 - 20-jun-2014,	Fabio Ferreira,	Filtrar somente números
--*********************************************************************************************************************************************************
SELECT znibd001.t$eanc$c CD_EAN,
       ltrim(rtrim(znibd001.t$item$c)) CD_ITEM
FROM   tznibd001201 znibd001
WHERE REGEXP_INSTR (znibd001.t$eanc$c, '[^[:digit:]]')=0
order by 1