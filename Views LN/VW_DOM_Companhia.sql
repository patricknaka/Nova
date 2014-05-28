SELECT  tcemm170.t$comp CD_CIA,
        tcemm170.t$desc NM_CIA,
        tccom000.t$arcc CD_SITUACAO,
        tccom130.t$fovn$l NR_CNPJ_CPF
FROM    ttcemm170201 tcemm170,
        ttccom000201 tccom000,
        ttccom130201 tccom130
WHERE   tccom000.t$ncmp = tcemm170.t$comp
AND     tccom000.t$indt IN (SELECT Max(ttccom000201.t$indt) FROM ttccom000201)
AND     tccom130.t$cadr = tccom000.t$cadr
order by 1

