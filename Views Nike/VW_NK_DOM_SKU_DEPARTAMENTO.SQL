SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
  tcmcs023.t$citg CD_DEPARTAMENTO,
  tcmcs023.t$dsca DS_DEPARTAMENTO,
  cast(13 as int) CD_CIA
FROM    baandb.ttcmcs023601 tcmcs023
WHERE   tcmcs023.T$tpit$c=1
order by 1