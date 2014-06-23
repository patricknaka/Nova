SELECT  201 CD_CIA,
        tcemm030.t$euca CD_FILIAL,
        whwmd215.t$cwar CD_DEPOSITO,
        ltrim(rtrim(whwmd215.t$item)) CD_ITEM,
        tcmcs003.t$tpar$l CD_MODALIDADE,
        whwmd215.t$qhnd - whwmd215.t$qblk QT_FISICA,
        whwmd215.t$qlal QT_ROMANEADA,
        whwmd215.t$qhnd - whwmd215.t$qall - whwmd215.t$qblk QT_SALDO,
        whwmd215.t$qall-whwmd215.t$qlal QT_RESERVADA,
        q1.mauc VL_CMV,
        'WN' CD_TIPO_BLOQUEIO,
        tcemm112.t$grid CD_UNIDADE_EMPRESARIAL
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
SELECT  201 CD_CIA,
        tcemm030.t$euca CD_FILIAL,
        whwmd630.t$cwar CD_DEPOSITO,
        ltrim(rtrim(whwmd630.t$item)) CD_ITEM,
        tcmcs003.t$tpar$l CD_MODALIDADE,
        whwmd630.t$qbls QT_FISICA,
        0 QT_ROMANEADA,
        0 QT_SALDO,
        0 QT_RESERVADA,
        q1.mauc VL_CMV,
        whwmd630.t$bloc CD_TIPO_BLOQUEIO,
        tcemm112.t$grid CD_UNIDADE_EMPRESARIAL
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