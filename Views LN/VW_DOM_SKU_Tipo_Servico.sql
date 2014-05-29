SELECT  znmcs030.t$seto$c CD_TIPO_SERVICO,
        znmcs030.t$dsca$c DS_TIPO_SERVICO
FROM    tznmcs030201 znmcs030
WHERE   znmcs030.t$citg$c='55'
order by 1