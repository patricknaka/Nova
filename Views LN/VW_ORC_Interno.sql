SELECT  201 COMPANHIA,
        tdsta200.t$csor COD_UNID_NEGOCIO,
        SubStr(tdsta200.t$ATVS, 7, 3) COD_CANAL_VENDA,
        SubStr(tdsta200.t$ATVS, 1, 6) COD_DEPARTAMENTO,
        tcccp070.t$stdt DATA_ORÇAMENTO,
        tdsta200.t$sbam$1 VALOR_ORCAMENTO,
        1 TIPO_ORCAMENTO,
        SYSDATE DATA_ATUALIZACAO --*** ATIVAR DATA DE ATUALIZAÇÃO ****
FROM  ttdsta200201 tdsta200,
      ttcccp070201 tcccp070
WHERE tcccp070.t$yrno = tdsta200.t$yrno
AND   tcccp070.t$peri = tdsta200.t$peri
UNION
SELECT  ( SELECT tccom000.t$ncmp
          FROM ttccom000201 tccom000
          WHERE tccom000.t$indt
          IN (SELECT Max(ttccom000201.t$indt) FROM ttccom000201)) COMPANHIA,
        tdsta200.t$csor COD_UNID_NEGOCIO,
        SubStr(tdsta200.t$ATVS, 7, 3) COD_CANAL_VENDA,
        SubStr(tdsta200.t$ATVS, 1, 6) COD_DEPARTAMENTO,
        tcccp070.t$stdt DATA_ORÇAMENTO,
        tdsta200.t$sbqi VALOR_ORCAMENTO,
        2 TIPO_ORCAMENTO,
        SYSDATE DATA_ATUALIZACAO --*** ATIVAR DATA DE ATUALIZAÇÃO ****
FROM  ttdsta200201 tdsta200,
      ttcccp070201 tcccp070
WHERE tcccp070.t$yrno = tdsta200.t$yrno
AND   tcccp070.t$peri = tdsta200.t$peri
