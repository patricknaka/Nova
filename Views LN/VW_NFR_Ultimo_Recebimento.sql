--	#FAF.257 - 11-aug-2014,	Fabio Ferreira,	Correção duplicidade
--**********************************************************************************************************************************************************
SELECT
    LTRIM(RTRIM(whina112.t$item))     CD_ITEM,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whina112.t$trdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ULTIMO_RECEBIMENTO,

    sum(whina113.t$mauc$1)   VL_CMV,
    whinr110.t$qstk     QT_ULTIMO_RECEBIMENTO,
    tcemm030.t$euca     CD_FILIAL,
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
    tcemm112.t$waid = whina112.t$cwar AND
    whina112.t$trdt >= sysdate-120 AND
	whinr110.t$qstk > 0
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
                          tcemm112a.t$grid = tcemm112.t$grid) AND

    whina113.t$seqn=( SELECT												--#FAF.257.sn
                          max(whina112a.t$seqn)
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
                          tcemm112a.t$grid = tcemm112.t$grid  AND
						  whina112a.t$trdt = whina113.t$trdt) 				--#FAF.257.en
						  
						  
GROUP BY
    whina112.t$item, whinr110.t$qstk, whina112.t$trdt, tcemm030.t$euca, tcemm112.t$grid
