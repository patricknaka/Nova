SELECT  201 COMPANHIA,
        tcemm030.t$euca COD_FILIAL,
		tcemm112.t$grid UNID_EMPRESARIAL,
        ltrim(rtrim(znwmd200.t$item$c)) COD_ITEM,
        znwmd200.t$qtdf$c - znwmd200.t$sald$c QTD_RESERVADO,
        znwmd200.t$qtdf$c QTD_ARQUIVO,
        znwmd200.t$sald$c QTD_SALDO,
		CAST((FROM_TZ(CAST(TO_CHAR(znwmd200.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
				AT time zone sessiontimezone) AS DATE) DATA_ATUALIZAÇÂO 
FROM    tznwmd200201 znwmd200,
        ttcemm112201 tcemm112,
		ttcemm030201 tcemm030
WHERE   tcemm112.t$waid = znwmd200.t$cwar$c
AND 	tcemm030.t$eunt=tcemm112.t$grid
