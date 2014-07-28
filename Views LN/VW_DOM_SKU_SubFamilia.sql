SELECT  znmcs032.t$subf$c CD_SUB_FAMILIA,
        znmcs032.t$fami$c CD_FAMILIA,
        znmcs032.t$seto$c CD_SETOR,
        znmcs032.t$citg$c CD_DEPARTAMENTO,
        znmcs032.t$dsca$c DS_SUB_FAMILIA
FROM    baandb.tznmcs032201 znmcs032, baandb.ttcmcs023201 tcmcs023
WHERE   tcmcs023.T$CITG=znmcs032.T$CITG$C
AND     tcmcs023.T$tpit$c=1
order by 1,2,3,4