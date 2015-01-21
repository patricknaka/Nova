SELECT 
    DISTINCT
    wmsCODE.FILIAL            PLANTA,
    wmsCODE.ID_FILIAL         DESC_PLANTA,
    znsls401.t$entr$c         PEDIDO,
    cisli940.t$docn$l         NF,
    cisli940.t$seri$l         SR,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)
                              DT_FATURAMENTO,
                              
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd610.t$udat$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)
                              DT_FECHA_GAIOLA,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TRACK.DATA_LIQ, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                              DT_LIQ
  
 FROM  baandb.tznsls401301 znsls401
  
 LEFT JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$orno$c = znsls401.t$orno$c
        
 LEFT JOIN baandb.tznfmd610301 znfmd610
        ON znfmd610.t$fili$c=znfmd630.t$fili$c
       AND znfmd610.t$cfrw$c=znfmd630.t$cfrw$c
       AND znfmd610.t$ngai$c=znfmd630.t$ngai$c
       AND znfmd610.t$etiq$c=znfmd630.t$etiq$c
        
 LEFT JOIN baandb.tznfmd001301 znfmd001
        ON znfmd001.t$fili$c = znfmd630.t$fili$c
         
 LEFT JOIN baandb.ttcmcs080301  tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c

 INNER JOIN baandb.ttdsls400301 tdsls400
        ON tdsls400.t$orno = znsls401.t$orno$c
  
 LEFT JOIN baandb.ttcemm124301 tcemm124 
        ON tcemm124.t$cwoc = tdsls400.t$cofc
 
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
        
 LEFT JOIN ( SELECT l.t$desc STATUS,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'td'
                AND d.t$cdom = 'sls.hdst'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'td'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) ORDEM
        ON ORDEM.t$cnst = tdsls400.t$hdst 

  LEFT JOIN baandb.tcisli245301 cisli245
         ON cisli245.t$slcp=301
        AND cisli245.t$ortp=1
        AND cisli245.t$koor=3
        AND cisli245.t$slso=znsls401.t$orno$c
        AND cisli245.t$pono=znsls401.t$pono$c
        
  LEFT JOIN baandb.tcisli940301 cisli940
         ON cisli940.t$fire$l=cisli245.t$fire$l
         
  LEFT JOIN ( select  max(znsls410.t$dtoc$c) DATA_LIQ,
                      znsls410.t$ncia$c,
                      znsls410.t$uneg$c,
                      znsls410.t$pecl$c,
                      znsls410.t$sqpd$c,
                      znsls410.t$entr$c
              from    baandb.tznsls410301 znsls410
              where   znsls410.t$poco$c='ETR'
              group by znsls410.t$ncia$c,
                       znsls410.t$uneg$c,
                       znsls410.t$pecl$c,
                       znsls410.t$sqpd$c,
                       znsls410.t$entr$c ) TRACK
        ON  TRACK.t$ncia$c=znsls401.t$ncia$c
       AND  TRACK.t$uneg$c=znsls401.t$uneg$c
       AND  TRACK.t$pecl$c=znsls401.t$pecl$c
       AND  TRACK.t$sqpd$c=znsls401.t$sqpd$c
       AND  TRACK.t$entr$c=znsls401.t$entr$c
        
WHERE znsls401.t$idor$c='TD'
AND   tdsls400.t$hdst != 35
AND   cisli940.t$docn$l is not null
AND   cisli940.t$docn$l !=0
