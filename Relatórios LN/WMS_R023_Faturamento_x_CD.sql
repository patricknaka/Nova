SELECT wmsCODE.FILIAL                                                 WHSEID,
       wmsCODE.ID_FILIAL                                              FILIAL,
       Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$datg$l, 
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') AS DATE), 'DD')        DAT,
       Count(Distinct sli245.t$slso)                                  PEDIDOS,
       Count(sli245.t$item)                                           ITENS,
       Round(Count(sli245.t$item) /
       Count(distinct sli245.t$slso),4)                               ITENS_PED,
       Round(Sum(sli941.t$amnt$l-sli941.t$fght$l), 4)                 VALOR_MERC,
       Round(Sum(sli941.t$amnt$l-sli941.t$fght$l-sli941.t$ldam$l), 4) VALOR_SEM_DESCONTO,
       Round(Sum(sli941.t$fght$l), 4)                                 VALOR_FRETE,
       Round(Sum(sli941.t$amnt$l-sli941.t$fght$l) /
       Count(Distinct sli245.t$slso), 4)                              TKT_MEDIO

      FROM baandb.tcisli245301 sli245
    
INNER JOIN baandb.tcisli940301 sli940
        ON sli940.t$fire$l = sli245.t$fire$l
  
INNER JOIN baandb.tcisli941301 sli941 
        ON sli941.t$fire$l = sli245.t$fire$l
       AND sli941.t$line$l = sli245.t$line$l
 
INNER JOIN baandb.ttdsls400301 sls400
        ON sls400.t$orno = sli245.t$slso
  
 LEFT JOIN baandb.ttcemm124301 tcemm124 
        ON tcemm124.t$cwoc = sls400.t$cofc
    
 LEFT JOIN ( select upper(wmsCODE.UDF1) Filial,
                    wmsCODE.UDF2 ID_FILIAL,
                    b.t$grid
               from baandb.ttcemm300301 a
         inner join baandb.ttcemm112301 b 
                 on b.t$waid = a.t$code
          left join ENTERPRISE.CODELKUP@DL_LN_WMS wmsCode
                 on UPPER(TRIM(wmsCode.DESCRIPTION)) = a.t$lctn
                and wmsCode.LISTNAME = 'SCHEMA'  
              where a.t$type = 20
           group by upper(wmsCODE.UDF1),
                    wmsCODE.UDF2,
                    b.t$grid )  wmsCODE 
        ON wmsCODE.t$grid = tcemm124.t$grid
  
     WHERE sli941.t$item$l not in ( select a.t$itjl$c
                                      from baandb.tznsls000301 a
                                     where a.t$indt$c = ( select min(b.t$indt$c) 
                                                            from baandb.tznsls000301 b )
                                 UNION ALL
                                    select a.t$itmd$c
                                      from baandb.tznsls000301 a
                                     where a.t$indt$c = ( select min(b.t$indt$c) 
                                                            from baandb.tznsls000301 b )
                                 UNION ALL
                                    select a.t$itmf$c
                                      from baandb.tznsls000301 a
                                     where a.t$indt$c = ( select min(b.t$indt$c) 
                                                            from baandb.tznsls000301 b ) )

       AND ( (:Filial = 'AAA') OR (wmsCODE.FILIAL = :Filial) )
       AND trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$datg$l, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE), 'DD')
           Between :DataDe
               And :DataAte
     
  GROUP BY trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$datg$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),
           wmsCODE.FILIAL,     
           wmsCODE.ID_FILIAL