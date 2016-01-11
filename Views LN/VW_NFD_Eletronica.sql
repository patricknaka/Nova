SELECT
  1                                                       CD_CIA,

  CASE WHEN tcemm030.t$euca = ' ' 
    THEN substr(tcemm124.t$grid,-2,2) 
    ELSE tcemm030.t$euca END AS                           CD_FILIAL,

  cisli940.t$docn$l                                       NF_NFE,
  cisli940.t$seri$l                                       NR_SERIE_NFE,
  cisli940.t$nfes$l                                       CD_STATUS_SEFAZ,
  cisli940.t$prot$l                                       NR_PROTOCOLO,
  cisli940.t$cnfe$l                                       NR_CHAVE_ACESSO_NFE,
  
  nvl((SELECT
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(brnfe020.t$date$l), 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
      FROM baandb.tbrnfe020201 brnfe020
      WHERE brnfe020.t$refi$l=cisli940.t$fire$l
      AND   brnfe020.t$ncmp$l=201
      AND   brnfe020.T$STAT$L=cisli940.t$tsta$l),
  (SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(brnfe020.t$date$l), 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)
    FROM baandb.tbrnfe020201 brnfe020
    WHERE brnfe020.t$refi$l=cisli940.t$fire$l
    AND    brnfe020.t$ncmp$l=201)) DT_STATUS,
  (SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(brnfe020.t$date$l), 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)
    FROM baandb.tbrnfe020201 brnfe020
    WHERE brnfe020.t$refi$l=cisli940.t$fire$l
    AND   brnfe020.t$ncmp$l=201
    AND   brnfe020.T$STAT$L=4)                            DT_CANCELAMENTO,

  cisli940.t$rscd$l                                       CD_MOTIVO_CANCELAMENTO,
  tcemm124.t$grid                                         CD_UNIDADE_EMPRESARIAL,
  cisli940.t$fire$l                                       NR_REFERENCIA_FISCAL, 
 
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)            DT_ULT_ATUALIZACAO 
    
FROM baandb.tcisli940201 cisli940

INNER JOIN baandb.ttcemm124201 tcemm124
      ON  tcemm124.t$loco=201
      AND tcemm124.t$dtyp=2
      AND tcemm124.t$cwoc=cisli940.t$cofc$l

INNER JOIN baandb.ttcemm030201 tcemm030
      ON  tcemm030.t$eunt=tcemm124.t$grid

WHERE cisli940.t$nfel$l=1 