SELECT
  wmsCODE.FILIAL                     FILIAL,     
  wmsCODE.ID_FILIAL                  DSC_PLANTA,
  Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$date$l, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE), 'DD')     
                                     DT_EMISSAO,  
  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$date$l, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')    
                                     HR_ANT,
  TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$date$l, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')
                                     HR,
  sli940.t$seri$l                    SERIE,
       sli940.t$fire$l,
  count(distinct sli245.t$slso)      QTD_PEDIDO,
  count(distinct sli940.t$docn$l)    QTD_NOTA,
  count(sli941.t$item$l)             QTD_ITENS,
  sum(sli941.t$dqua$l)               QTD_PECAS,
  sum(sli941.t$amnt$l)               VALOR

FROM       baandb.tcisli245301 sli245

INNER JOIN baandb.tcisli940301 sli940  
        ON sli940.t$fire$l = sli245.t$fire$l

INNER JOIN baandb.tcisli941301 sli941  
        ON sli941.t$fire$l = sli245.t$fire$l
       AND sli941.t$line$l = sli245.t$line$l
 
 LEFT JOIN (       Select  3 koor,  1 oorg From DUAL
             Union Select  7 koor,  2 oorg From DUAL
             Union Select 34 koor,  3 oorg From DUAL
             Union Select  2 koor, 80 oorg From DUAL
             Union Select  6 koor, 81 oorg From DUAL
             Union Select 33 koor, 82 oorg From DUAL
             Union Select 17 koor, 11 oorg From DUAL
             Union Select 35 koor, 12 oorg From DUAL
             Union Select 37 koor, 31 oorg From DUAL
             Union Select 39 koor, 32 oorg From DUAL
             Union Select 38 koor, 33 oorg From DUAL
             Union Select 42 koor, 34 oorg From DUAL
             Union Select  1 koor, 50 oorg From DUAL
             Union Select 32 koor, 51 oorg From DUAL
             Union Select 56 koor, 53 oorg From DUAL
             Union Select  9 koor, 55 oorg From DUAL
             Union Select 46 koor, 56 oorg From DUAL
             Union Select 57 koor, 58 oorg From DUAL
             Union Select 22 koor, 71 oorg From DUAL
             Union Select 36 koor, 72 oorg From DUAL
             Union Select 58 koor, 75 oorg From DUAL
             Union Select 59 koor, 76 oorg From DUAL
             Union Select 60 koor, 90 oorg From DUAL
             Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG
        ON KOOR2OORG.koor = sli245.T$koor 
  
INNER JOIN baandb.twhinh200301 whinh200
        ON whinh200.t$oorg = KOOR2OORG.oorg
       AND whinh200.t$orno = sli245.t$slso
  
 LEFT JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$cadr = whinh200.t$sfad
  
 LEFT JOIN baandb.ttcemm122301 tcemm122 
        ON tcemm122.t$loco = 301  
       AND tcemm122.t$bupa = tccom100.t$bpid
    
 LEFT JOIN ( select upper(wmsCODE.UDF1) Filial,
                    wmsCODE.UDF2 ID_FILIAL,
                    b.t$grid
               from baandb.ttcemm300301 a
         inner join baandb.ttcemm112301 b 
                 on b.t$waid = a.t$code
          left join ENTERPRISE.CODELKUP@DL_LN_WMS wmsCode
                 on upper(TRIM(wmsCode.DESCRIPTION)) = a.t$lctn
                and wmsCode.LISTNAME = 'SCHEMA'  
              where a.t$type = 20
                and wmsCode.UDF3 = 301 
           group by upper(wmsCODE.UDF1),
                    wmsCODE.UDF2,
                    b.t$grid )  wmsCODE 
        ON wmsCODE.t$grid = tcemm122.t$grid

WHERE sli940.t$stat$l IN (5,6) 
  AND sli940.t$nfes$l IN (1,2,5)
  AND sli941.t$item$l not in ( select a.t$itjl$c
                                 from baandb.tznsls000301 a
                                where a.t$indt$c = ( select min(b.t$indt$c) from baandb.tznsls000301 b )
                            UNION ALL
                               select a.t$itmd$c
                                 from baandb.tznsls000301 a
                                where a.t$indt$c = ( select min(b.t$indt$c) from baandb.tznsls000301 b)
                            UNION ALL
                               select a.t$itmf$c
                                 from baandb.tznsls000301 a
                                where a.t$indt$c = ( select min(b.t$indt$c) from baandb.tznsls000301 b ) )

  AND ( (:Filial = 'AAA') OR (wmsCODE.FILIAL = :Filial) )
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$date$l, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE), 'DD')     
      Between :DataDe 
          And :DataAte

GROUP BY wmsCODE.FILIAL,
         wmsCODE.ID_FILIAL,
         Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$date$l, 
                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                   AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),  
         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$date$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),
         sli940.t$seri$l
