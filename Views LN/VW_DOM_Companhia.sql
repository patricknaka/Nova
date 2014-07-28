--	#FAF.151 - 20-jun-2014,	Fabio Ferreira,	Tratamento para o CNPJ
--************************************************************************************************************************************************************
SELECT  tcemm170.t$comp CD_CIA,
        tcemm170.t$desc NM_CIA,
        tccom000.t$arcc CD_SITUACAO,
        CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') END NR_CNPJ_CPF
FROM    baandb.ttcemm170201 tcemm170,
        baandb.ttccom000201 tccom000,
        baandb.ttccom130201 tccom130
WHERE   tccom000.t$ncmp = tcemm170.t$comp
AND     tccom000.t$indt IN (SELECT Max(ttccom000201.t$indt) FROM baandb.ttccom000201)
AND     tccom130.t$cadr = tccom000.t$cadr
order by 1

