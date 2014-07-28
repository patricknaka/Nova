-- FAF.003 - 12-mai-2014, Fabio Ferreira, Exclusão dos campos UF e Pais e alteração do alias COD_CIDADE
-- FAF.005 - 12-mai-2014, Fabio Ferreira, 	Conversão de timezone
--											Retirado os campos TEL, FAX, MATRIZ
--	#FAF.091 - 29-mai-2014,	Fabio Ferreira,	Excluir CNPJ_CPF_GRUPO
--	#FAF.130 - 11-jun-2014,	Fabio Ferreira,	Quando Tipo de ident. fiscal igual 'NA' mostrar CNPJ "00000000000000"
--	#FAF.153 - 20-jun-2014,	Fabio Ferreira,	Incluído campo condição de pagamento da sessão parceiro de negócio faturadores
--	#FAF.151 - 20-jun-2014,	Fabio Ferreira,	Tratamento para o CNPJ
--****************************************************************************************************************************************************************
SELECT DISTINCT 
       bspt.t$bpid CD_PARCEIRO,
--	   addr.t$fovn$l NR_CNPJ_CPF,																	--#FAF.130.o
--       CASE WHEN addr.t$ftyp$l='NA' THEN '00000000000000'											
--	   ELSE addr.t$fovn$l END NR_CNPJ_CPF,															--#FAF.130.n	#FAF.151.o

        CASE WHEN regexp_replace(addr.t$fovn$l, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(addr.t$fovn$l, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(addr.t$fovn$l, '[^0-9]', '') END NR_CNPJ_CPF,						--#FAF.151.n

       bspt.t$nama NM_PARCEIRO,
       bspt.t$seak NM_APELIDO,
       addr.t$ftyp$l CD_TIPO_CLIENTE,
       CASE
         WHEN Nvl(trnp.t$cfrw,' ')!=' ' then 10
         WHEN Nvl(fabr.t$cmnf,' ')!=' ' then 11
         ELSE bspt.t$bprl
       END CD_TIPO_CADASTRO,
--       addp.t$fovn$l NR_CNPJ_CPF_GRUPO,															--#FAF.091.o
--       bspt.t$crdt DT_CADASTRO,																	--#FAF.005.o
		CAST((FROM_TZ(CAST(TO_CHAR(bspt.t$crdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.005.n
		AT time zone sessiontimezone) AS DATE) DT_CADASTRO,											--#FAF.005.n
--       bspt.t$lmdt DT_ATUALIZACAO,																--#FAF.005.o
		CAST((FROM_TZ(CAST(TO_CHAR(bspt.t$lmdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.005.n
		AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,										--#FAF.005.n
--       addr.t$telp TEL1,																			--#FAF.005.o
--       addr.t$telx TEL2,																			--#FAF.005.o
--       addr.t$tefx NR_FAX,																			--#FAF.005.o
       bspt.t$okfi$c IN_IDONEO,
--       CASE WHEN addp.t$cadr=addr.t$cadr THEN 'MATRIZ' ELSE 'FILIAL' END NM_MATRIZ_FILIAL,			--#FAF.005.o
	   bspt.t$prst CD_STATUS,
	   (select pf.t$cpay from baandb.ttccom122201 pf 
	    where pf.t$ifbp=bspt.t$bpid and rownum=1) CD_CONDICAO_PAGAMENTO									--#FAF.153.n
FROM baandb.ttccom100201 bspt
--LEFT JOIN ttccom130201 addp ON addp.t$cadr = bspt.t$cadr											--#FAF.091.so
--LEFT JOIN ttccom133201 adbp ON adbp.t$bpid = bspt.t$bpid
--LEFT JOIN ttccom130201 addr ON addr.t$cadr = adbp.t$cadr											--#FAF.091.eo
LEFT JOIN baandb.ttccom130201 addr ON addr.t$cadr = bspt.t$cadr											--#FAF.091.n
LEFT JOIN baandb.ttcmcs080201 trnp ON trnp.t$suno = bspt.t$bpid -- rel com transportadoras
LEFT JOIN baandb.ttcmcs060201 fabr ON fabr.t$otbp = bspt.t$bpid -- rel com fabricantes
order by 1