SELECT  201 CD_CIA,
        SubStr(tdsta200.t$ATVS, 7, 3) CD_CANAL_VENDAS,
        SubStr(tdsta200.t$ATVS, 1, 6) CD_DEPARTAMENTO,
        tcccp070.t$stdt DT_ORCAMENTO,
        tdsta200.t$sbam$1 VL_ORCAMENTO,
        tdsta200.t$csor CD_TIPO_ORCAMENTO,
        SYSDATE DT_ATUALIZACAO --*** ATIVAR DATA DE ATUALIZAÇÃO ****
FROM  ttdsta200201 tdsta200,
      ttcccp070201 tcccp070
WHERE tcccp070.t$yrno = tdsta200.t$yrno
AND   tcccp070.t$peri = tdsta200.t$peri
