SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
-- A tabela tcmcs939 é compartilhada com a 201
--**********************************************************************************************************************************************************
       bptp.t$ftyp$l CD_TIPO_CLIENTE,
       bptp.t$dsca$l DS_TIPO_CLIENTE,
       15 as CD_CIA
FROM baandb.ttcmcs939201 bptp
order by 1