﻿SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--*********************************************************************
        CAST(15 AS INT) CD_CIA,
        case when tcemm030.t$euca = ' ' then '1' else tcemm030.t$euca end CD_FILIAL,
        tcmcs003.t$cwar CD_DEPOSITO,
        tcmcs003.t$dsca DS_DEPOSITO,
        tcemm112.t$grid CD_UNIDADE_EMPRESARIAL
FROM    baandb.ttcmcs003602 tcmcs003,
        baandb.ttcemm112602 tcemm112,
        baandb.ttcemm030602 tcemm030
WHERE   tcemm112.t$loco = 602
AND     tcemm112.t$waid = tcmcs003.t$cwar
AND 	  tcemm030.t$eunt=tcemm112.t$grid