SELECT DISTINCT
    znfmd630.t$cfrw$c             CODI_TRANS,
    Trim(tcmcs080.t$dsca)         DESC_TRANS,
    znfmd630.t$cfrw$c ||
    ' - '             ||
    Trim(tcmcs080.t$dsca)         COD_DESC_TRANS,
    COUNT(znfmd630.t$cfrw$c)      QTDE_ENTREGAS,
    SUM(znfmd630.t$vlfC$c)        FRETE_APAGAR,
    CASE WHEN cisli940.t$fdty$l=14 THEN
      'NFE'
    ELSE  'NFS' END               TIPO_NF,
    znfmd630.t$fili$c             FILIAL

FROM       BAANDB.tznfmd630301  znfmd630

INNER JOIN BAANDB.tcisli940301  cisli940
        ON znfmd630.t$fire$c = cisli940.t$fire$l

INNER JOIN baandb.ttcmcs080301  tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c

WHERE cisli940.t$fdty$l IN (1,14,15)

  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone sessiontimezone) AS DATE)) 
      BETWEEN :DataDe 
          AND :DataAte

GROUP BY znfmd630.t$cfrw$c,
         Trim(tcmcs080.t$dsca),
         znfmd630.t$cfrw$c,
         Trim(tcmcs080.t$dsca),
         CASE WHEN cisli940.t$fdty$l=14 
          THEN 'NFE'
          ELSE 'NFS' END,
         znfmd630.t$fili$c
  
ORDER BY 7,3,6
