SELECT DISTINCT
	ltrim(rtrim(q1.item)) CD_ITEM,
	1 CD_CIA,
	tcemm030.t$euca CD_FILIAL,
	q1.mauc VL_CMV,
	q1.grid CD_UNIDADE_EMPRESARIAL
FROM
	baandb.ttcemm030201 tcemm030,	
	(select a.t$item item,
    tcemm112.t$grid grid,
    case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
    else round(sum(a.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
    end mauc
    from  baandb.twhwmd217201 a,
          baandb.ttcemm112201 tcemm112,
          baandb.twhwmd215201 whwmd215
    where tcemm112.t$waid=a.t$cwar
    AND tcemm112.t$loco=201
    AND whwmd215.t$cwar=a.t$cwar
    AND whwmd215.t$item=a.t$item
    group by  a.t$item,
    tcemm112.t$grid) q1
WHERE   tcemm030.t$eunt=q1.grid