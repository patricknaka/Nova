-- #FAF.054 - 26-mai-2014, Fabio Ferreira, 	Incluída a descrição da contabilidade						
--*************************************************************************************************************************************************************
SELECT  tcemm030.t$euca COD_FILIAL,
        tcemm030.T$EUNT UNID_EMPRESARIAL,
        tcemm030.t$lcmp COD_CIA,
        tcemm030.t$dsca NOME_FILIAL,
        tccom130.t$fovn$l CNPJ_FILIAL,
        tfgld010.t$desc DESC_FILIAL
FROM    ttcemm030201 tcemm030
        LEFT JOIN ttcemm122201 tcemm122
        ON      tcemm122.t$grid=tcemm030.t$eunt
        AND     tcemm122.t$loco=tcemm030.t$lcmp        
        LEFT JOIN ttccom100201 tccom100
        ON      tccom100.t$bpid=tcemm122.t$bupa        
        LEFT JOIN ttccom130201 tccom130
        ON      tccom130.t$cadr=tccom100.t$cadr
        LEFT JOIN ttfgld010201 tfgld010
        ON     tfgld010.t$dimx=tcemm030.t$euca
        AND    tfgld010.t$dtyp=2
ORDER BY 2
