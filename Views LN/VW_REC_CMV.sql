SELECT
    whina112.t$item     CD_ITEM,
    sum(whina113.t$mauc$1)   VL_CMV,
    whinr110.t$qstk     QTDE_REC,
    whina112.t$trdt     DATA_REC,
    tcemm030.t$euca     FILIAL,
    tcemm112.t$grid     CD_UNIDADE_EMPRESARIAL
FROM
    baandb.twhina112201 whina112,
    baandb.twhina113201 whina113,
    baandb.twhinr110201 whinr110,
    baandb.ttcemm030201 tcemm030,
    baandb.ttcemm112201 tcemm112
WHERE 
    whina113.t$item = whina112.t$item AND
    whina113.t$cwar = whina112.t$cwar AND
    whina113.t$trdt = whina112.t$trdt AND
    whina113.t$seqn = whina112.t$seqn AND
    whinr110.t$itid = whina112.t$itid AND
    tcemm030.t$eunt = tcemm112.t$grid AND
    tcemm112.t$waid = whina112.t$cwar
    AND
    whina113.t$trdt=( SELECT
                          max(whina112a.t$trdt)
                      FROM
                          baandb.twhina112201 whina112a,
                          baandb.twhina113201 whina113a,
                          baandb.twhinr110201 whinr110a,
                          baandb.ttcemm030201 tcemm030a,
                          baandb.ttcemm112201 tcemm112a
                      WHERE 
                          whina113a.t$item = whina112a.t$item AND
                          whina113a.t$cwar = whina112a.t$cwar AND
                          whina113a.t$trdt = whina112a.t$trdt AND
                          whina113a.t$seqn = whina112a.t$seqn AND
                          whinr110a.t$itid = whina112a.t$itid AND
                          tcemm030a.t$eunt = tcemm112a.t$grid AND
                          tcemm112a.t$waid = whina112a.t$cwar AND
                          whina112a.t$item = whina112.t$item  AND
                          tcemm030a.t$euca = tcemm030.t$euca  AND
                          tcemm112a.t$grid = tcemm112.t$grid)
GROUP BY
    whina112.t$item, whinr110.t$qstk, whina112.t$trdt, tcemm030.t$euca, tcemm112.t$grid
