select
	wmsCODE.FILIAL                                            FILIAL,     
	wmsCODE.ID_FILIAL                                         DSC_PLANTA,
  trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$datg$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE), 'DD')     DT_EMISSAO,  
  trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$datg$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')    HR,
  sli940.t$seri$l                                           SERIE,
  
  
    count(distinct sli245.t$slso)         QTD_PEDIDO,
    count(distinct sli940.t$docn$l)    QTD_NOTA,
    count(sli941.t$item$l)                  QTD_ITENS,
    sum(sli941.t$dqua$l)             QTD_PECAS,
	sum(sli941.t$amnt$l)			VALOR


from
    baandb.tcisli245301 sli245
    INNER JOIN baandb.tcisli940301 sli940 	ON 	sli940.t$fire$l=sli245.t$fire$l
    INNER JOIN baandb.tcisli941301 sli941 	ON	sli941.t$fire$l=sli245.t$fire$l
                                            and sli941.t$line$l=sli245.t$line$l
	
	
	
	
    INNER JOIN baandb.ttdsls400301 sls400	  ON	sls400.t$orno=sli245.t$slso
    LEFT JOIN baandb.ttcemm124301 tcemm124 ON  tcemm124.t$cwoc = sls400.t$cofc
    
    LEFT JOIN (select   upper(wmsCODE.UDF1) Filial,
                        wmsCODE.UDF2 ID_FILIAL,
                        b.t$grid
            from        baandb.ttcemm300301 a
            inner join  baandb.ttcemm112301 b ON b.t$waid = a.t$code
            LEFT JOIN   ENTERPRISE.CODELKUP@DL_LN_WMS wmsCode
                          ON  UPPER(TRIM(wmsCode.DESCRIPTION)) = a.t$lctn
                          AND wmsCode.LISTNAME='SCHEMA'  
            where a.t$type=20
            group by  upper(wmsCODE.UDF1),
                      wmsCODE.UDF2,
                      b.t$grid)  wmsCODE ON wmsCODE.t$grid = tcemm124.t$grid
where 

     sli940.t$stat$l IN (5,6) and sli940.t$nfes$l IN (1,2,5)
--		and   trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$datg$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--          AT time zone 'America/Sao_Paulo') AS DATE), 'DD')  BETWEEN :DataDe AND :DataAte

    and sli941.t$item$l not in
          ( select a.t$itjl$c
            from baandb.tznsls000301 a
            where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000301 b)
            UNION ALL
            select a.t$itmd$c
            from baandb.tznsls000301 a
            where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000301 b)
            UNION ALL
            select a.t$itmf$c
            from baandb.tznsls000301 a
            where a.t$indt$c=(select min(b.t$indt$c) from baandb.tznsls000301 b))

group by

	wmsCODE.FILIAL,
	wmsCODE.ID_FILIAL,
  trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$datg$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),  
  trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(sli940.t$datg$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),
  sli940.t$seri$l

