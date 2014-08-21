SELECT  201 CD_CIA,
        tcemm030.t$euca CD_FILIAL,
        ltrim(rtrim(znwmd200.t$item$c)) CD_ITEM,
        znwmd200.t$qtdf$c - znwmd200.t$sald$c QT_RESERVADA,
        znwmd200.t$qtdf$c QT_ARQUIVO,
        znwmd200.t$sald$c QT_SALDO,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znwmd200.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,
		tcemm112.t$grid CD_UNIDADE_EMPRESARIAL
FROM    baandb.tznwmd200201 znwmd200,
        baandb.ttcemm112201 tcemm112,
        baandb.ttcemm030201 tcemm030
WHERE   tcemm112.t$waid = znwmd200.t$cwar$c
AND 	tcemm030.t$eunt=tcemm112.t$grid
