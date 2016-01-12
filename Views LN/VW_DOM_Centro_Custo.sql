SELECT
  tfgld010.t$dimx CD_CENTRO_CUSTO,
  tfgld010.t$desc DS_CENTRO_CUSTO,
  tfgld010.t$pdix CD_CENTRO_CUSTO_PAI

FROM baandb.ttfgld010201 tfgld010

WHERE tfgld010.t$dtyp=1