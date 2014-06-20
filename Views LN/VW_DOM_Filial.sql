-- 	#FAF.054 - 26-mai-2014, Fabio Ferreira, 	Incluída a descrição da contabilidade
--	#FAF.151 - 20-jun-2014,	Fabio Ferreira,	Tratamento para o CNPJ						
--*************************************************************************************************************************************************************
SELECT  tcemm030.t$euca CD_FILIAL,
        tcemm030.t$lcmp CD_CIA,
        tcemm030.t$dsca NM_FILIAL,
		
        CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') END  NR_CNPJ_FILIAL,							--#FAF.151.n
		
--        tccom130.t$fovn$l NR_CNPJ_FILIAL,																	--#FAF.151.o
        tcemm030.T$EUNT CD_UNIDADE_EMPRESARIAL,
        tfgld010.t$desc DS_FILIAL
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
ORDER BY 5,1