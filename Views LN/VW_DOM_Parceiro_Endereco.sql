-- 06-mai-2014, Fabio Ferreira, Corre��o timezone
--								Inclus�o do c�digo do endere�o
-- FAF.003 - 12-mai-2014, Fabio Ferreira, Exclus�o dos campos UF e Pais e altera��o do alias COD_CIDADE
--	#FAF.091 - 29-mai-2014,	Fabio Ferreira,	Corre��es para incluir os dados da query de telefone
--****************************************************************************************************************************************************************
SELECT 	adbp.t$bpid CD_PARCEIRO,
		adbp.t$cadr CD_ENDERECO,
		addr.t$fovn$l NR_CNPJ_CPF,																				--#FAF.091.n
		addr.t$namc NM_ENDERECO_PRINCIPAL,
		addr.t$dist$l NM_BAIRRO,
		addr.t$hono NR_NUMERO,
--       addr.t$ccit COD_CIDADE,																			--#FAF.003.O
		addr.t$ccit CD_MUNICIPIO,																			--#FAF.003.n
--       addr.t$cste COD_UF,																				--#FAF.003.O
--       addr.t$ccty COD_PAIS,																				--#FAF.003.O
		addr.t$pstc CD_CEP,
		addr.t$namd DS_COMPLEMENTO, 
		addr.t$telp NR_TELEFONE_PRINCIPAL,																	--#FAF.091.sn
		addr.t$telx NR_TELEFONE_SECUNDARIO,																	
		addr.t$tefx NR_FAX,																					
		CASE WHEN adbp.t$cadr=tccom100.t$cadr THEN 'MATRIZ' ELSE 'FILIAL' END NM_MATRIZ_FILIAL,
		tccom100.t$prst CD_STATUS,																				--#FAF.091.en		
		CAST((FROM_TZ(CAST(TO_CHAR(addr.t$crdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
				AT time zone sessiontimezone) AS DATE) DT_CADASTRO,	   
		CAST((FROM_TZ(CAST(TO_CHAR(addr.t$dtlm, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
				AT time zone sessiontimezone) AS DATE)	DT_ATUALIZACAO
FROM 	ttccom133201 adbp,
		ttccom100201 tccom100,																				--#FAF.091.n
		ttccom130201 addr
WHERE 	addr.t$cadr = adbp.t$cadr
and		tccom100.t$bpid=adbp.t$cadr
order by 1,2
