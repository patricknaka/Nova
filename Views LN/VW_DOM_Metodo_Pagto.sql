SELECT
  a.t$paym       CD_METODO_PAGAMENTO,
  a.t$desc       DS_METODO_PAGAMENTO,
  CASE WHEN a.t$repa=1 
    THEN 'CAR' 
  ELSE 'CAP' END CD_MODULO

FROM baandb.ttfcmg003201 a

order by 1