-- 06-mai-2014, Fabio Ferreira, Correção timezone
--								Inclusão do código do endereço
-- FAF.003 - 12-mai-2014, Fabio Ferreira, Exclusão dos campos UF e Pais e alteração do alias COD_CIDADE
--	#FAF.091 - 29-mai-2014,	Fabio Ferreira,	Correções para incluir os dados da query de telefone
--	#FAF.133 - 12-jun-2014,	Fabio Ferreira,	Quando Tipo de ident. fiscal igual 'NA' mostrar CNPJ "00000000000000"
--	#FAF.151 - 20-jun-2014,	Fabio Ferreira,	Tratamento para o CNPJ
--	#FAF.189 - 01-jul-2014,	Fabio Ferreira,	Correção campo Complemento
--	#FAF.255 - 31-jul-2014,	Fabio Ferreira,	Correção relacionamento
--****************************************************************************************************************************************************************
SELECT 	
    adbp.t$bpid                       CD_PARCEIRO,
    adbp.t$cadr                       CD_ENDERECO,
    
    CASE WHEN regexp_replace(addr.t$fovn$l, '[^0-9]', '') IS NULL
      THEN '00000000000000' 
    WHEN LENGTH(regexp_replace(addr.t$fovn$l, '[^0-9]', ''))<11
      THEN '00000000000000'
    ELSE regexp_replace(addr.t$fovn$l, '[^0-9]', '') 
    END                               NR_CNPJ_CPF,
    addr.t$namc                       NM_ENDERECO_PRINCIPAL,
    addr.t$dist$l                     NM_BAIRRO,
    addr.t$hono                       NR_NUMERO,
    addr.t$ccit                       CD_MUNICIPIO,
    addr.t$pstc                       CD_CEP,
    addr.t$bldg                       DS_COMPLEMENTO,

    --addr.t$telp NR_TELEFONE_PRINCIPAL,
    
    CASE WHEN LENGTH(addr.t$telp) < 8 THEN '' 
      ELSE CASE SUBSTR(addr.t$telp,1,1) WHEN '0' 
      THEN SUBSTR(
    CONCAT(SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(addr.t$telp),' ',''),'-',''),'(0',''),')',''),'(',''),'.',''),'_',''),'+',''),1,2),
      SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(addr.t$telp),' ',''),'-',''),'(0',''),')',''),'(',''),'.',''),'_',''),'+',''),3,9)),2,11)
      ELSE 
    CONCAT(SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(addr.t$telp),' ',''),'-',''),'(0',''),')',''),'(',''),'.',''),'_',''),'+',''),1,2),
      SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(addr.t$telp),' ',''),'-',''),'(0',''),')',''),'(',''),'.',''),'_',''),'+',''),3,9)) 
        END end                       NR_TELEFONE_PRINCIPAL,

    --addr.t$telx NR_TELEFONE_SECUNDARIO,                                  

    CASE WHEN LENGTH(addr.t$telx) < 8 THEN '' 
      ELSE CASE SUBSTR(addr.t$telx,1,1) WHEN '0' 
      THEN SUBSTR(
    CONCAT(SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(addr.t$telx),' ',''),'-',''),'(0',''),')',''),'(',''),'.',''),'_',''),'+',''),1,2),
      SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(addr.t$telx),' ',''),'-',''),'(0',''),')',''),'(',''),'.',''),'_',''),'+',''),3,9)),2,11)
      ELSE 
    CONCAT(SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(addr.t$telx),' ',''),'-',''),'(0',''),')',''),'(',''),'.',''),'_',''),'+',''),1,2),
      SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(addr.t$telx),' ',''),'-',''),'(0',''),')',''),'(',''),'.',''),'_',''),'+',''),3,9))
        END end                      NR_TELEFONE_SECUNDARIO,

    addr.t$tefx                      NR_FAX,                                          
    CASE WHEN adbp.t$cadr=tccom100.t$cadr 
      THEN 'MATRIZ' ELSE 'FILIAL' 
      END                           NM_MATRIZ_FILIAL,
    tccom100.t$prst                 CD_STATUS,  
    CASE WHEN addr.t$info = ' ' 
      THEN NULL ELSE addr.t$info 
      END                           DS_EMAIL,  
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(addr.t$crdt, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) 
                                    DT_CADASTRO,      

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(addr.t$dtlm, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)  
                                    DT_ATUALIZACAO
      
FROM  baandb.ttccom133201 adbp,
      baandb.ttccom100201 tccom100,                                        
      baandb.ttccom130201 addr

WHERE  addr.t$cadr = adbp.t$cadr
and    tccom100.t$bpid=adbp.t$bpid									

