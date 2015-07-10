SELECT DISTINCT
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
	ltrim(rtrim(q1.item)) CD_ITEM,
	15 CD_CIA,
	case when tcemm030.t$euca = ' ' then '0' --null (coloquei zero pq na tabela ln.ods_sku_cmv o campo filial é not null)
  else tcemm030.t$euca end CD_FILIAL,
	q1.mauc VL_CMV,
	q1.grid CD_UNIDADE_EMPRESARIAL
FROM
	baandb.ttcemm030602 tcemm030,	
	(select a.t$item item,
    tcemm112.t$grid grid,
    case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
    else round(sum(a.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
    end mauc
    from  baandb.twhwmd217602 a,
          baandb.ttcemm112602 tcemm112,
          baandb.twhwmd215602 whwmd215
    where tcemm112.t$waid=a.t$cwar
    AND tcemm112.t$loco=602
    AND whwmd215.t$cwar=a.t$cwar
    AND whwmd215.t$item=a.t$item
    group by  a.t$item,
    tcemm112.t$grid) q1
WHERE   tcemm030.t$eunt=q1.grid