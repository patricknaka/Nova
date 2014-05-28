-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Retirado campo data de atualização		
--**********************************************************************************************************************************************************
SELECT  201 CD_CIA,
        tcemm030.t$euca CD_FILIAL,
        tcmcs003.t$cwar CD_DEPOSITO,
        tcmcs003.t$dsca DS_DEPOSITO,
	tcemm112.t$grid CD_UNIDADE_EMPRESARIAL
--        SYSDATE DATA_ATUALIZAÇÂO -- *** PRECISA SER ATIVADO NA TABELA tmcs003
FROM    ttcmcs003201 tcmcs003,
        ttcemm112201 tcemm112,
		ttcemm030201 tcemm030
WHERE   tcemm112.t$loco = 201
AND     tcemm112.t$waid = tcmcs003.t$cwar
AND 	tcemm030.t$eunt=tcemm112.t$grid
