SELECT  znmcs030.t$seto$c COD_SETOR,
        znmcs030.t$citg$c COD_DEPARTAMENTO,
        znmcs030.t$dsca$c DESCRICAO_SETOR
FROM    tznmcs030201 znmcs030, ttcmcs023201 tcmcs023
WHERE   tcmcs023.T$CITG=znmcs030.T$CITG$C
AND     tcmcs023.T$tpit$c=1