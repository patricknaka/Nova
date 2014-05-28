SELECT  znmcs030.t$seto$c COD_TIPO_SERVICO,
        znmcs030.t$dsca$c DESCR
FROM    tznmcs030201 znmcs030
WHERE   znmcs030.t$citg$c='55'
order by 1