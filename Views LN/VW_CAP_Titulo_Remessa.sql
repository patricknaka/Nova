SELECT    tfcmg401.t$ttyp || tfcmg401.t$ninv CD_CHAVE_PRIMARIA,
          tfcmg401.t$btno NR_REMESSA,
          tfcmg409.t$date DT_REMESSA,
          tfcmg401.t$schn NR_PROGRAMACAO,
          tfacr201.t$liqd DT_PREV_REC,
          tfcmg401.t$paym CD_METODO_REC,
          tfacr201.t$rpst$l CD_STAT_REC

FROM        ttfcmg401201 tfcmg401
INNER JOIN  ttfcmg409201 tfcmg409 ON  tfcmg409.t$btno=tfcmg401.t$btno
INNER JOIN  ttfacr201201 tfacr201 ON  tfacr201.t$ttyp=tfcmg401.t$ttyp 
                                  AND tfacr201.t$ninv=tfcmg401.t$ninv
                                  AND tfacr201.t$schn=tfcmg401.t$schn
ORDER BY 2