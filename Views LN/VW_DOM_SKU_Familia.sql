SELECT  znmcs031.t$fami$c COD_FAMILIA,
        znmcs031.t$seto$c COD_SETOR,
        znmcs031.t$citg$c COD_DEPARTAMENTO,
        znmcs031.t$dsca$c DESCRICAO
FROM    tznmcs031201 znmcs031, ttcmcs023201 tcmcs023
WHERE   tcmcs023.T$CITG=znmcs031.T$CITG$C
AND     tcmcs023.T$tpit$c=1
