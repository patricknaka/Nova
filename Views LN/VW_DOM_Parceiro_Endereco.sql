-- 06-mai-2014, Fabio Ferreira, Corre��o timezone
--								Inclus�o do c�digo do endere�o
-- FAF.003 - 12-mai-2014, Fabio Ferreira, Exclus�o dos campos UF e Pais e altera��o do alias COD_CIDADE
--****************************************************************************************************************************************************************
SELECT adbp.t$bpid CODIGO,
	   adbp.t$cadr CODIGO_ENDERECO,	
       addr.t$namc ENDERECO,
       addr.t$dist$l BAIRRO,
       addr.t$hono NUMERO,
--       addr.t$ccit COD_CIDADE,																			--#FAF.003.O
       addr.t$ccit COD_MUNICIO,																				--#FAF.003.n
--       addr.t$cste COD_UF,																				--#FAF.003.O
--       addr.t$ccty COD_PAIS,																				--#FAF.003.O
       addr.t$pstc CEP,
       addr.t$namd COMPLEMENTO, 
		CAST((FROM_TZ(CAST(TO_CHAR(addr.t$crdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
				AT time zone sessiontimezone) AS DATE) DT_CADASTRO,	   
		CAST((FROM_TZ(CAST(TO_CHAR(addr.t$dtlm, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
				AT time zone sessiontimezone) AS DATE)	DT_ATUALIZACAO
FROM ttccom133201 adbp,
     ttccom130201 addr
WHERE addr.t$cadr = adbp.t$cadr
