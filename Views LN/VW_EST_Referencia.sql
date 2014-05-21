SELECT  201 COMPANHIA,
        tcemm030.t$euca COD_FILIAL,
        tcemm112.t$grid UNID_EMPRESARIAL,
        whina112.t$cwar COD_DEPOSITO,
        ltrim(rtrim(whina112.t$item)) COD_ITEM,
        tcmcs003.t$tpar$l MODALIDADE,
        sum(whina112.t$qstk) QTD_FISICA,
		tdrec947.t$rcno$l RECEBIMENTO,
		tdrec940.t$fire$l fire,
		(SELECT 
		 case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
		 else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
		 end mauc
		 FROM twhwmd217201 whwmd217, twhwmd215201 whwmd215
		 WHERE 	whwmd217.t$item=whina112.t$item
		 AND   	whwmd217.t$cwar=whina112.t$cwar
		 AND whwmd215.t$cwar=whwmd217.t$cwar
		 AND whwmd215.t$item=whwmd217.t$item
		 group by  whwmd217.t$item) VALOR_CMV
FROM    twhina112201 whina112,
        ttcemm112201 tcemm112,
		ttcemm030201 tcemm030,
        ttcmcs003201 tcmcs003,
		twhwmd200201 whwmd200,
		ttdrec947201 tdrec947,
		ttdrec940201 tdrec940
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