select  
-- O campo CD_CIA foi incluido para diferenciar NIKE(601) E BUNZL(602)
--**********************************************************************************************************************************************************
    adbp.t$bpid CD_PARCEIRO,
    adbp.t$cadr CD_ENDERECO,
    CASE WHEN regexp_replace(addr.t$fovn$l, '[^0-9]', '') IS NULL
      THEN '00000000000000' 
      WHEN LENGTH(regexp_replace(addr.t$fovn$l, '[^0-9]', ''))<11
      THEN '00000000000000'
      ELSE regexp_replace(addr.t$fovn$l, '[^0-9]', '') END NR_CNPJ_CPF,                    
    addr.t$namc NM_ENDERECO_PRINCIPAL,
    addr.t$dist$l NM_BAIRRO,
    addr.t$hono NR_NUMERO,
    addr.t$ccit CD_MUNICIPIO,                                      
    addr.t$pstc CD_CEP,
    addr.t$bldg DS_COMPLEMENTO, 										
    addr.t$telp NR_TELEFONE_PRINCIPAL,                                  
    addr.t$telx NR_TELEFONE_SECUNDARIO,                                  
    addr.t$tefx NR_FAX,                                          
    CASE WHEN adbp.t$cadr=tccom100.t$cadr THEN 'MATRIZ' ELSE 'FILIAL' END NM_MATRIZ_FILIAL,
    tccom100.t$prst CD_STATUS,                                          
    CASE WHEN addr.t$info = ' ' THEN NULL ELSE addr.t$info END  DS_EMAIL,  
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(addr.t$crdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) DT_CADASTRO,     
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(addr.t$dtlm, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)  DT_ATUALIZACAO,
    cast(601 as int) CD_CIA
      
FROM  baandb.ttccom133601 adbp,
      baandb.ttccom100601 tccom100,                                        
      baandb.ttccom130601 addr

WHERE  addr.t$cadr = adbp.t$cadr
and    tccom100.t$bpid=adbp.t$bpid