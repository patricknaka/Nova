SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
-- a tabela ttcmcs066 é compartilhada com a 201

  tcmcs066.t$chan CD_CANAL_VENDA,  
  tcmcs066.t$dsca DS_CANAL_VENDA,
  cast(13 as int) CD_CIA
  
FROM
  baandb.ttcmcs066201 tcmcs066
order by 1