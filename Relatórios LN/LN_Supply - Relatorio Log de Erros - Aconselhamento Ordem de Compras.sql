  SELECT DISTINCT
  whina310.t$orno                        REQUISICAO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whina310.t$ordt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                                         DATA_REQ,
  whina310.t$item                        ITEM,
  whina310.t$oqan                        QUANT_ORDEM,
  whina310.t$cwar                        ARMAZEM,
  whina310.t$suno                        PARC_NEG_FORNEC,
  tccom100.t$nama                        RAZAO_SOCIAL,
  whina310.t$rorn                        ORDEM_VENDA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whina310.t$ordt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                                         DATA_HORA_ORDEM,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whina310.t$dldt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                                          DATA_ENTREGA,
  znpur001.t$erro$c                       ERRO
                          
  FROM baandb.twhina310301 whina310
  
  LEFT JOIN baandb.tznpur001301 znpur001
         ON znpur001.t$acxd$c = whina310.t$orno
  
  LEFT JOIN baandb.ttccom100301 tccom100
         ON tccom100.t$bpid = whina310.t$suno
  
WHERE   trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whina310.t$ordt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE))
between :data_ini and :data_fim
  
