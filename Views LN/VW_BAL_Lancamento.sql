-- #FAF.005, 14-mai-2014, Fabio Ferreira,	Aterado o campo Natureza do lançamento para relacionar com a cat. Transação
--							
--**********************************************************************************************************************************************************
SELECT
 tfgld106.t$ocmp || tfgld106.t$leac || tfgld106.t$fyer || tfgld106.t$fprd || tfgld106.t$dim1 || 
 tfgld106.t$dim2 || tfgld106.t$dim3 || tfgld106.t$dim4 || tfgld106.t$dim5 CD_CHAVE_PRIMARIA,
 tfgld106.t$dcdt DT_LANCAMENTO,
 tfgld106.t$leac CD_CONTA_CONTABIL,
 tfgld106.t$dim1 CD_CENTRO_CUSTO,
 tfgld106.t$dim2 CD_FILIAL,
 (Select u.t$eunt From ttcemm030201 u where u.t$euca!=' '
  AND TO_NUMBER(u.t$euca)=CASE WHEN tfgld106.t$dim2=' ' then 999
   WHEN tfgld106.t$dim2<=to_char(0) then 999 else TO_NUMBER(tfgld106.t$dim2) END and rownum = 1) CD_UNIDADE_EMPRESARIA,
 tfgld106.t$ocmp CD_CIA,
 tfgld106.t$desc$l DS_LANCAMENTO,
 tfgld106.t$dbcr IN_DEBITO_CREDITO,
 tfgld106.t$amnt VL_LANCAMENTO,
-- tfgld106.t$tcsh CD_NATUREZA_LANCAMENTO,																			--#FAF.005.o
 tfgld011.T$CATG NATUREZA_LANCAMENTO,                                                                          	--#FAF.005.n
 tfgld106.t$obat NR_LOTE,
 tfgld106.t$trun SQ_LOTE
FROM ttfgld106201 tfgld106,
ttfgld011201 tfgld011                                                                                           --#FAF.005.n
WHERE tfgld106.t$dim1!=' '
AND   tfgld011.t$ttyp=tfgld106.T$OTYP                                                                           --#FAF.005.n