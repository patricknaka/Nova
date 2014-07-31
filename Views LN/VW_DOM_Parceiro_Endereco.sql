-- 06-mai-2014, Fabio Ferreira, Correção timezone
--								Inclusão do código do endereço
-- FAF.003 - 12-mai-2014, Fabio Ferreira, Exclusão dos campos UF e Pais e alteração do alias COD_CIDADE
--	#FAF.091 - 29-mai-2014,	Fabio Ferreira,	Correções para incluir os dados da query de telefone
--	#FAF.133 - 12-jun-2014,	Fabio Ferreira,	Quando Tipo de ident. fiscal igual 'NA' mostrar CNPJ "00000000000000"
--	#FAF.151 - 20-jun-2014,	Fabio Ferreira,	Tratamento para o CNPJ
--	#FAF.189 - 01-jul-2014,	Fabio Ferreira,	Correção campo Complemento
--	#FAF.255 - 31-jul-2014,	Fabio Ferreira,	Correção relacionamento
--****************************************************************************************************************************************************************
SELECT 	adbp.t$bpid CD_PARCEIRO,
    adbp.t$cadr CD_ENDERECO,
    
        CASE WHEN regexp_replace(addr.t$fovn$l, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
    WHEN LENGTH(regexp_replace(addr.t$fovn$l, '[^0-9]', ''))<11
    THEN '00000000000000'
    ELSE regexp_replace(addr.t$fovn$l, '[^0-9]', '') END NR_CNPJ_CPF,                    --#FAF.151.n
    
--    CASE WHEN addr.t$ftyp$l='NA' THEN '00000000000000'
--    ELSE addr.t$fovn$l END NR_CNPJ_CPF,                                    --#FAF.133.n  #FAF.151.o
--    addr.t$fovn$l NR_CNPJ_CPF,                                        --#FAF.091.n  #FAF.133.o
    addr.t$namc NM_ENDERECO_PRINCIPAL,
    addr.t$dist$l NM_BAIRRO,
    addr.t$hono NR_NUMERO,
--       addr.t$ccit COD_CIDADE,                                      --#FAF.003.O
    addr.t$ccit CD_MUNICIPIO,                                      --#FAF.003.n
--       addr.t$cste COD_UF,                                        --#FAF.003.O
--       addr.t$ccty COD_PAIS,                                        --#FAF.003.O
    addr.t$pstc CD_CEP,
--    addr.t$namd DS_COMPLEMENTO, 										--#FAF.189.o
    addr.t$bldg DS_COMPLEMENTO, 										--#FAF.189.n
    addr.t$telp NR_TELEFONE_PRINCIPAL,                                  --#FAF.091.sn
    addr.t$telx NR_TELEFONE_SECUNDARIO,                                  
    addr.t$tefx NR_FAX,                                          
    CASE WHEN adbp.t$cadr=tccom100.t$cadr THEN 'MATRIZ' ELSE 'FILIAL' END NM_MATRIZ_FILIAL,
    tccom100.t$prst CD_STATUS,                                        --#FAF.091.en  
    CASE WHEN addr.t$info = ' ' THEN NULL ELSE addr.t$info END  DS_EMAIL,  
    CAST((FROM_TZ(CAST(TO_CHAR(addr.t$crdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
        AT time zone sessiontimezone) AS DATE) DT_CADASTRO,     
    CAST((FROM_TZ(CAST(TO_CHAR(addr.t$dtlm, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
        AT time zone sessiontimezone) AS DATE)  DT_ATUALIZACAO
FROM   baandb.ttccom133201 adbp,
    baandb.ttccom100201 tccom100,                                        --#FAF.091.n
    baandb.ttccom130201 addr
WHERE   addr.t$cadr = adbp.t$cadr
--	and    tccom100.t$bpid=adbp.t$bpid									--#FAF.255.o
and    tccom100.t$bpid=adbp.t$bpid										--#FAF.255.n
order by 1,2