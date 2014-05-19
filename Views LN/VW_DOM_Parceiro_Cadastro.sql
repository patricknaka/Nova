-- FAF.003 - 12-mai-2014, Fabio Ferreira, Exclusão dos campos UF e Pais e alteração do alias COD_CIDADE
-- FAF.005 - 12-mai-2014, Fabio Ferreira, 	Conversão de timezone
--											Retirado os campos TEL, FAX, MATRIZ
--****************************************************************************************************************************************************************
SELECT DISTINCT 
       bspt.t$bpid codigo,
       addr.t$fovn$l cnpj_cpf,
       bspt.t$nama nome,
       bspt.t$seak apelido,
       addr.t$ftyp$l tipo_cliente,
       CASE
         WHEN Nvl(trnp.t$cfrw,' ')!=' ' then 10
         WHEN Nvl(fabr.t$cmnf,' ')!=' ' then 11
         ELSE bspt.t$bprl
       END TIPO_CADASTRO,
       addp.t$fovn$l cnpj_cpf_grupo ,
--       bspt.t$crdt DT_CADASTRO,																	--#FAF.005.o
		CAST((FROM_TZ(CAST(TO_CHAR(bspt.t$crdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.005.n
		AT time zone sessiontimezone) AS DATE) DT_CADASTRO,											--#FAF.005.n
--       bspt.t$lmdt DT_ATUALIZACAO,																--#FAF.005.o
		CAST((FROM_TZ(CAST(TO_CHAR(bspt.t$lmdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.005.n
		AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,										--#FAF.005.n
--       addr.t$telp TEL1,																			--#FAF.005.o
--       addr.t$telx TEL2,																			--#FAF.005.o
--       addr.t$tefx FAX,																			--#FAF.005.o
       bspt.t$okfi$c FLAG_IDONEO,
--       CASE WHEN addp.t$cadr=addr.t$cadr THEN 'MATRIZ' ELSE 'FILIAL' END MATRIZ_FILIAL,			--#FAF.005.o
	   bspt.t$prst status
FROM ttccom100201 bspt
LEFT JOIN ttccom130201 addp ON addp.t$cadr = bspt.t$cadr
LEFT JOIN ttccom133201 adbp ON adbp.t$bpid = bspt.t$bpid
LEFT JOIN ttccom130201 addr ON addr.t$cadr = adbp.t$cadr
LEFT JOIN ttcmcs080201 trnp ON trnp.t$suno = bspt.t$bpid -- rel com transportadoras
LEFT JOIN ttcmcs060201 fabr ON fabr.t$otbp = bspt.t$bpid -- rel com fabricantes