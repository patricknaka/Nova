SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(2) E BUNZL(3)
        CAST(3 AS INT) CD_CIA,
        case when tcemm030.t$euca = ' ' then null else tcemm030.t$euca end CD_FILIAL,
        tcmcs003.t$cwar CD_DEPOSITO,
        tcmcs003.t$dsca DS_DEPOSITO,
        tcemm112.t$grid CD_UNIDADE_EMPRESARIAL
FROM    baandb.ttcmcs003201 tcmcs003,
        baandb.ttcemm112201 tcemm112,
        baandb.ttcemm030201 tcemm030
WHERE   tcemm112.t$loco = 201
AND     tcemm112.t$waid = tcmcs003.t$cwar
AND 	  tcemm030.t$eunt=tcemm112.t$grid