SELECT  201 CD_CIA,
        tcemm030.t$euca CD_FILIAL,
        whina112.t$cwar CD_DEPOSITO,
        ltrim(rtrim(whina112.t$item)) CD_ITEM,
        tcmcs003.t$tpar$l CD_MODALIDADE,
        sum(whina112.t$qstk) QT_FISICA,
		tdrec947.t$rcno$l NR_NFR,
		(SELECT 
		 case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
		 else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
		 end mauc
		 FROM baandb.twhwmd217201 whwmd217, baandb.twhwmd215201 whwmd215
		 WHERE 	whwmd217.t$item=whina112.t$item
		 AND   	whwmd217.t$cwar=whina112.t$cwar
		 AND whwmd215.t$cwar=whwmd217.t$cwar
		 AND whwmd215.t$item=whwmd217.t$item
		 group by  whwmd217.t$item) VL_CMV,
        tcemm112.t$grid CD_UNIDADE_EMPRESARIAL,
		tdrec940.t$fire$l NR_REFERENCIA_FISCAL
FROM    baandb.twhina112201 whina112,
        baandb.ttcemm112201 tcemm112,
        baandb.ttcemm030201 tcemm030,
        baandb.ttcmcs003201 tcmcs003,
        baandb.twhwmd200201 whwmd200,
        baandb.ttdrec947201 tdrec947,
        baandb.ttdrec940201 tdrec940
WHERE   tcemm112.t$loco = 201
AND     tcemm112.t$waid = whina112.t$cwar
AND 	tcemm030.t$eunt = tcemm112.t$grid
AND		whwmd200.t$cwar = tcmcs003.t$cwar
AND     tcmcs003.t$cwar = whina112.t$cwar
AND		tdrec947.t$orno$l=whina112.t$orno
AND		tdrec947.t$pono$l=whina112.t$pono
AND		tdrec947.t$seqn$l=whina112.t$srnb
AND		tdrec940.t$fire$l=tdrec947.t$fire$l
AND		(tdrec940.t$stat$l=4 OR tdrec940.t$stat$l=5)
AND		tdrec940.t$rfdt$l not in (3,5,8,13,16,22,33)
GROUP BY tcemm030.t$euca, 
         whina112.t$cwar, 
         whina112.t$item, 
         tcmcs003.t$tpar$l,
         tdrec940.t$fire$l,
         whwmd200.t$wvgr,
         tcemm112.t$grid,
         tdrec947.t$rcno$l