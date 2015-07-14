SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
    znmcs030.t$seto$c CD_SETOR,
    znmcs030.t$citg$c CD_DEPARTAMENTO,
    znmcs030.t$dsca$c DS_SETOR,
    CAST(13 AS INT) AS CD_CIA
FROM    baandb.tznmcs030601 znmcs030, baandb.ttcmcs023601 tcmcs023
WHERE   tcmcs023.T$CITG=znmcs030.T$CITG$C
AND     tcmcs023.T$tpit$c=1
order by 1,2