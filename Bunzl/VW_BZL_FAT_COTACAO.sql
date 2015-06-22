SELECT  
-- O campo CD_CIA foi incluido para diferenciar NIKE(601) E BUNZL(602)
--**********************************************************************************************************************************************************
  tcmcs008.t$rtyp COD_COTACAO,
  tcmcs008.t$ccur CD_MOEDA,
  tcmcs008.t$rate VL_COTACAO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcmcs008.t$stdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
  AT time zone 'America/Sao_Paulo') AS DATE) DT_COTACAO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcmcs008.t$apdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
  AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ATUALIZACAO,
  CASE WHEN (select MAX(b.t$stdt) From baandb.ttcmcs008602 b
    where b.t$rtyp=tcmcs008.t$rtyp
    and   b.t$ccur=tcmcs008.t$ccur)=tcmcs008.t$stdt THEN 1 ELSE 2 END IN_EFETIVA,
  CAST(602 AS INT) AS CD_CIA
FROM    baandb.ttcmcs008602 tcmcs008
WHERE	tcmcs008.t$bcur='BRL'
AND		tcmcs008.t$rapr=1