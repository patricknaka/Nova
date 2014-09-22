SELECT  201 CD_CIA,
        SubStr(tdsta200.t$ATVS, 7, 3) CD_CANAL_VENDAS,
        SubStr(tdsta200.t$ATVS, 1, 6) CD_DEPARTAMENTO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcccp070.t$stdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_ORCAMENTO,
        tdsta200.t$sbam$1 VL_ORCAMENTO,
        tdsta200.t$csor CD_ORCAMENTO,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsta200.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO
FROM  baandb.ttdsta200201 tdsta200,
      baandb.ttcccp070201 tcccp070
WHERE tcccp070.t$yrno = tdsta200.t$yrno
AND   tcccp070.t$peri = tdsta200.t$peri