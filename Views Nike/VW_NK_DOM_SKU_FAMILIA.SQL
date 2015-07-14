SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
    znmcs031.t$fami$c CD_FAMILIA,
    znmcs031.t$seto$c CD_SETOR,
    znmcs031.t$citg$c CD_DEPARTAMENTO,
    znmcs031.t$dsca$c DS_FAMILIA,
    CAST(13 AS INT) AS CD_CIA
FROM    baandb.tznmcs031601 znmcs031, baandb.ttcmcs023601 tcmcs023
WHERE   tcmcs023.T$CITG=znmcs031.T$CITG$C
AND     tcmcs023.T$tpit$c=1
order by 1,2,3
