SELECT DISTINCT
    201                               NUM_CIA,
    tcemm030.t$euca                   NUM_FILIAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$dtra$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                      DTA_CRIACAO, 
    znsls401.t$orno$c                 NUM_ORDEM,    
    znsls402.t$cccd$c                 NUM_BANDEIRA,
	
	CASE WHEN znsls402.t$cccd$c = 0 THEN 'N/A'
	     ELSE zncmg009.t$desc$c
     END                              DSC_BANDEIRA,
	 
    znsls402.t$idad$c                 ID_ADQUIRENTE,  
    znsls402.t$idmp$c                 NUM_MEIO_PAGTO,  
    zncmg007.t$desc$c                 DSC_MEIO_PAGTO,  
    Concat(Concat(znsls402.t$idmp$c
  , ' - ')
  , zncmg007.t$desc$c)              NUM_DSC_MEIO_PAGTO,    
    znsls400.t$nomf$c                 NOME_CLIENTE,    
    znsls402.t$cpft$c                 CPF_CLIENTE, 
    znsls402.t$vlmr$c                 VALOR
    
FROM      baandb.ttcemm030201  tcemm030,  
          baandb.ttcemm124201  tcemm124,  
          baandb.tznsls400201  znsls400,
          baandb.tznsls401201  znsls401,  
          baandb.tznsls402201  znsls402
        
LEFT JOIN baandb.tzncmg007201  zncmg007
       ON zncmg007.t$mpgt$c = znsls402.t$idmp$c

LEFT JOIN baandb.tzncmg009201  zncmg009
       ON zncmg009.t$band$c = znsls402.t$cccd$c
        
WHERE znsls402.t$ncia$c = znsls400.t$ncia$c
  AND znsls402.t$uneg$c = znsls400.t$uneg$c
  AND znsls402.t$pecl$c = znsls400.t$pecl$c
  AND znsls402.t$sqpd$c = znsls400.t$sqpd$c
  AND znsls401.t$ncia$c = znsls400.t$ncia$c
  AND znsls401.t$uneg$c = znsls400.t$uneg$c
  AND znsls401.t$pecl$c = znsls400.t$pecl$c
  AND znsls401.t$sqpd$c = znsls400.t$sqpd$c
  AND tcemm124.t$cwoc = znsls401.t$cofc$c
  AND tcemm124.t$dtyp = 1 
  AND tcemm030.t$eunt=tcemm124.t$grid  
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$dtra$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)) BETWEEN :CriacaoDe AND :CriacaoAte
  AND znsls402.t$cccd$c in (:Bandeira)
  AND znsls402.t$idmp$c in (:MeioPagto)
  AND znsls402.t$idad$c = NVL (:Adquirinte, znsls402.t$idad$c)