SELECT 
  DISTINCT
    znfmd630.t$pecl$c  ENTREGA,
    znfmd640.t$coci$c  PONTO,
      
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE)
                       DATA_PONTO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE)
                       DATA_PROCESSAMENTO

FROM       BAANDB.tznfmd630301 znfmd630
  
INNER JOIN BAANDB.tznfmd640301 znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c 
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
WHERE
      znfmd640.t$coci$c = 'ENT'

      AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE))
      BETWEEN :DataPontoDe
          AND :DataPontoAte
    
     AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE))
      BETWEEN :DataProceDe
          AND :DataProceAte
       
     AND ( (znfmd630.t$pecl$c IN (:Entrega) and :EntregaTodos = 1 ) or (:EntregaTodos = 0) )
     AND ( (Upper(znfmd640.t$coci$c) IN (:Ponto) and :PontoTodos = 1 ) or (:PontoTodos = 0) )