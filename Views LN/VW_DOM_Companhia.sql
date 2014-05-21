SELECT  tcemm170.t$comp COD_CIA,
        tcemm170.t$desc NOME_CIA,
        tccom000.t$arcc SITUACAO_CIA,
        tccom130.t$fovn$l
FROM    ttcemm170201 tcemm170,
        ttccom000201 tccom000,
        ttccom130201 tccom130
WHERE   tccom000.t$ncmp = tcemm170.t$comp
AND     tccom000.t$indt IN (SELECT Max(ttccom000201.t$indt) FROM ttccom000201)
AND     tccom130.t$cadr = tccom000.t$cadr

