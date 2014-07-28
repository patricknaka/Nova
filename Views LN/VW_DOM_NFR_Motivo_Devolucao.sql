SELECT
  tcmcs005.t$cdis CD_MOTIVO_DEVOLUCAO,
  tcmcs005.t$dsca DS_MOTIVO_DEVOLUCAO
FROM baandb.ttcmcs005201 tcmcs005
WHERE tcmcs005.T$rstp=11
order by 1