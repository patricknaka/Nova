SELECT  znmcs031.t$fami$c CD_FAMILIA,
        znmcs031.t$seto$c CD_SETOR,
        znmcs031.t$citg$c CD_DEPARTAMENTO,
        znmcs031.t$dsca$c DS_FAMILIA
FROM    tznmcs031201 znmcs031, ttcmcs023201 tcmcs023
WHERE   tcmcs023.T$CITG=znmcs031.T$CITG$C
AND     tcmcs023.T$tpit$c=1
order by 1,2,3