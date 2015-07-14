
SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
    znmcs032.t$subf$c CD_SUB_FAMILIA,
    znmcs032.t$fami$c CD_FAMILIA,
    znmcs032.t$seto$c CD_SETOR,
    znmcs032.t$citg$c CD_DEPARTAMENTO,
    znmcs032.t$dsca$c DS_SUB_FAMILIA,
    CAST(13 AS INT) AS CD_CIA
FROM    baandb.tznmcs032601 znmcs032, baandb.ttcmcs023601 tcmcs023
WHERE   tcmcs023.T$CITG=znmcs032.T$CITG$C
AND     tcmcs023.T$tpit$c=1
order by 1,2,3,4