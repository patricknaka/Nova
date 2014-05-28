-- 06-mai-2014, Fabio Ferreira, Correção timezone
--								Inclusão do código do endereço
-- FAF.003 - 12-mai-2014, Fabio Ferreira, Exclusão dos campos UF e Pais e alteração do alias COD_CIDADE
--****************************************************************************************************************************************************************
SELECT adbp.t$bpid CD_PARCEIRO,
	   adbp.t$cadr CD_ENDERECO,	
       addr.t$namc NM_ENDERECO_PRINCIPAL,
       addr.t$dist$l NM_BAIRRO,
       addr.t$hono NR_NUMERO,
--       addr.t$ccit COD_CIDADE,																			--#FAF.003.O
       addr.t$ccit CD_MUNICIPIO,																				--#FAF.003.n
--       addr.t$cste COD_UF,																				--#FAF.003.O
--       addr.t$ccty COD_PAIS,																				--#FAF.003.O
       addr.t$pstc CD_CEP,
       addr.t$namd DS_COMPLEMENTO, 
		CAST((FROM_TZ(CAST(TO_CHAR(addr.t$crdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
				AT time zone sessiontimezone) AS DATE) DT_CADASTRO,	   
		CAST((FROM_TZ(CAST(TO_CHAR(addr.t$dtlm, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
				AT time zone sessiontimezone) AS DATE)	DT_ATUALIZACAO
FROM ttccom133201 adbp,
     ttccom130201 addr
WHERE addr.t$cadr = adbp.t$cadr
order by 1,2
