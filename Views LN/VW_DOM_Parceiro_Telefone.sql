-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Icluido campo data de atualização e status
--****************************************************************************************************************************************************************
SELECT 
       bspt.t$bpid codigo,
       addr.t$telp TEL1,
       addr.t$telx TEL2,
       addr.t$tefx FAX,
       CASE WHEN addp.t$cadr=addr.t$cadr THEN 'MATRIZ' ELSE 'FILIAL' END MATRIZ_FILIAL,
	   		CAST((FROM_TZ(CAST(TO_CHAR(bspt.t$lmdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 			--#FAF.007.n
		AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,													--#FAF.007.n
	   bspt.t$prst status																						--#FAF.007.n
FROM ttccom100201 bspt
LEFT JOIN ttccom130201 addp ON addp.t$cadr = bspt.t$cadr
LEFT JOIN ttccom133201 adbp ON adbp.t$bpid = bspt.t$bpid
LEFT JOIN ttccom130201 addr ON addr.t$cadr = adbp.t$cadr
