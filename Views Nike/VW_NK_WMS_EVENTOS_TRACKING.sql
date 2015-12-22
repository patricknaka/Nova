select 
-- para a nike os dados estão na filial WMWHSE10
-- quando migrarmos para produção será necessário mudar para WMWHSE9
-- conforme orientação do Humberto - 21/12/2015
  CAST(13 AS INT)                               CD_CIA,
  o.WHSEID                                      CD_ARMAZEM,
  o.ORDERKEY                                    NR_PEDIDO_WMS,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)  DT_REGISTRO,
  'WMS'                                         CD_OCORRENCIA_TERCEIRO,
  'P'                                           CD_SITUACAO,
  ' '                                           ID_GAIOLA
from WMWHSE10.ORDERS o

UNION 

select  
  CAST(13 AS INT)                               CD_CIA,
  cd.WHSEID                                     CD_ARMAZEM, 
  cd.orderid                                    NR_PEDIDO_WMS,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(cd.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)  DT_REGISTRO,
  'GAI'                                         CD_OCORRENCIA_TERCEIRO,
  'P'                                           CD_SITUACAO,
  TO_CHAR(cd.cageid)                            ID_GAIOLA
from WMWHSE10.cageiddetail cd 
GROUP BY cd.orderid, cd.WHSEID, cd.cageid

UNION 

select  
  CAST(13 AS INT)                               CD_CIA,
  o.WHSEID                                      CD_ARMAZEM, 
  o.ORDERKEY                                    NR_PEDIDO_WMS,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(o.actualshipdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)  DT_REGISTRO,
  'SEC'                                         CD_OCORRENCIA_TERCEIRO, 
  'P'                                           CD_SITUACAO,
  ' '                                           ID_GAIOLA
from WMWHSE10.ORDERS o 
WHERE o.actualshipdate IS NOT NULL