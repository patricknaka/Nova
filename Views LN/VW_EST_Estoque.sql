SELECT  201 COMPANHIA,
        tcemm030.t$euca COD_FILIAL,
        tcemm112.t$grid UNID_EMPRESARIAL,
        whwmd215.t$cwar DEPOSITO,
        ltrim(rtrim(whwmd215.t$item)) ITEM,
        tcmcs003.t$tpar$l MODALIDADE,
        whwmd215.t$qhnd - whwmd215.t$qblk QTD_FISICA,
        whwmd215.t$qlal QTD_ROMANEADA,
        whwmd215.t$qhnd - whwmd215.t$qall - whwmd215.t$qblk QTD_SALDO,
        whwmd215.t$qall-whwmd215.t$qlal QTD_RESERVADA,
        q1.mauc VALOR_CMV,
        'WN' TIPO
FROM    twhwmd215201 whwmd215
        LEFT JOIN ( SELECT 
					 whwmd217.t$item,
					 whwmd217.t$cwar,
					 case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
					 else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
					 end mauc
					 FROM twhwmd217201 whwmd217, twhwmd215201 whwmd215
					 WHERE whwmd215.t$cwar=whwmd217.t$cwar
					 AND whwmd215.t$item=whwmd217.t$item
					 group by  whwmd217.t$item, whwmd217.t$cwar) q1 
        ON q1.t$item = whwmd215.t$item AND q1.t$cwar = whwmd215.t$cwar,
        ttcemm112201 tcemm112,
		ttcemm030201 tcemm030,
        ttcmcs003201 tcmcs003
WHERE   tcemm112.t$loco = 201
AND     tcemm112.t$waid = whwmd215.t$cwar
AND 	tcemm030.t$eunt=tcemm112.t$grid
AND     tcmcs003.t$cwar = whwmd215.t$cwar
AND     (whwmd215.t$qhnd>0 or whwmd215.t$qall>0)
UNION
SELECT  201 COMPANHIA,
        tcemm030.t$euca COD_FILIAL,
        tcemm112.t$grid UNID_EMPRESARIAL,
        whwmd630.t$cwar DEPOSITO,
        ltrim(rtrim(whwmd630.t$item)) ITEM,
        tcmcs003.t$tpar$l MODALIDADE,
        whwmd630.t$qbls QTD_FISICA,
        0 QTD_ROMANEADA,
        0 QTD_SALDO,
        0 QTD_RESERVADA,
        q1.mauc VALOR_CMV,
        whwmd630.t$bloc TIPO
FROM    twhwmd630201 whwmd630
        LEFT JOIN ( SELECT 
					 whwmd217.t$item,
					 whwmd217.t$cwar,
					 case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
					 else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
					 end mauc
					 FROM twhwmd217201 whwmd217, twhwmd215201 whwmd215
					 WHERE whwmd215.t$cwar=whwmd217.t$cwar
					 AND whwmd215.t$item=whwmd217.t$item
					 group by  whwmd217.t$item, whwmd217.t$cwar) q1 
        ON q1.t$item = whwmd630.t$item AND q1.t$cwar = whwmd630.t$cwar,
        ttcemm112201 tcemm112,
		ttcemm030201 tcemm030,
        ttcmcs003201 tcmcs003
WHERE   tcemm112.t$loco = 201
AND     tcemm112.t$waid = whwmd630.t$cwar
AND 	tcemm030.t$eunt=tcemm112.t$grid
AND     tcmcs003.t$cwar = whwmd630.t$cwar
