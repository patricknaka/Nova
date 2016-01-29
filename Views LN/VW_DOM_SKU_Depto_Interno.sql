SELECT  tcmcs023.t$citg CD_DEPARTAMENTO,
        tcmcs023.t$dsca DS_DEPARTAMENTO
FROM    baandb.ttcmcs023201 tcmcs023
WHERE   SUBSTR(tcmcs023.t$citg,1,2) = 'AT'
order by 1