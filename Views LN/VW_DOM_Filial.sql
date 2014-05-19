SELECT  tcemm030.t$euca COD_FILIAL,
		tcemm122.t$grid UNID_EMPRESARIAL,
        tcemm030.t$lcmp COD_CIA,
        tcemm030.t$dsca NOME_FILIAL,
        tccom130.t$fovn$l CNPJ_FILIAL
FROM    ttcemm030201 tcemm030,
        ttcemm122201 tcemm122,
        ttccom100201 tccom100,
        ttccom130201 tccom130
WHERE   tcemm122.t$grid=tcemm030.t$eunt
AND     tcemm122.t$loco=tcemm030.t$lcmp
AND     tccom100.t$bpid=tcemm122.t$bupa
AND     tccom130.t$cadr=tccom100.t$cadr
