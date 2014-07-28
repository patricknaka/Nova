SELECT  znmcs030.t$seto$c CD_SETOR,
        znmcs030.t$citg$c CD_DEPARTAMENTO,
        znmcs030.t$dsca$c DS_SETOR
FROM    baandb.tznmcs030201 znmcs030, baandb.ttcmcs023201 tcmcs023
WHERE   tcmcs023.T$CITG=znmcs030.T$CITG$C
AND     tcmcs023.T$tpit$c=1
order by 1,2