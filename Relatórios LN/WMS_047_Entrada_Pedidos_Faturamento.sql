SELECT wmsCode.ID_FILIAL                              FILIAL,
       sysdate                                        DATA_CONSULTA,
       WMSCODE.FILIAL                                 DESC_FILIAL,
       LPad(tcibd001.t$citg,10,' ')                   ID_DP,
       tcmcs023.t$dsca                                NOME,
       SUM(tdsls401.t$oamt)                           PR_FINAL,
       SUM(tdsls401.t$qoor)                           QTD_PEDIDO
	   
FROM       baandb.ttdsls401301  tdsls401

INNER JOIN baandb.ttdsls400301 tdsls400
        ON tdsls400.t$orno = tdsls401.t$orno
		
INNER JOIN baandb.ttcemm124301 tcemm124 
        ON tcemm124.t$cwoc = tdsls400.t$cofc
		
INNER JOIN baandb.ttcibd001301   tcibd001
        ON tcibd001.t$item = tdsls401.t$item
		
INNER JOIN baandb.ttcmcs023301 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
		
 LEFT JOIN baandb.tcisli245301  cisli245
        ON cisli245.t$slcp = 301
       AND cisli245.t$ortp = 1
       AND cisli245.t$koor = 3
       AND cisli245.t$oset = 0
       AND cisli245.t$slso = tdsls401.t$orno
       AND cisli245.t$pono = tdsls401.t$pono
       AND cisli245.t$sqnb = tdsls401.t$sqnb
       AND cisli245.t$shpm = tdsls401.t$shpm
	   
 LEFT JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = cisli245.t$fire$l  
		
 LEFT JOIN ( select upper(wmsCODE.UDF1) Filial,
                    wmsCODE.UDF2        ID_FILIAL,
                    b.t$grid
               from baandb.ttcemm300301 a
         inner join baandb.ttcemm112301 b 
                 on b.t$waid = a.t$code
          left join ENTERPRISE.CODELKUP@DL_LN_WMS wmsCode
                 on upper(trim(wmsCode.DESCRIPTION)) = a.t$lctn
                and wmsCode.LISTNAME = 'SCHEMA'  
              where a.t$type = 20
           group by upper(wmsCODE.UDF1),
                    wmsCODE.UDF2,
                    b.t$grid )  wmsCODE 
        ON wmsCODE.t$grid = tcemm124.t$grid

INNER JOIN ( select a.t$orno$c,
                    min(b.t$dtoc$c) dtwms
               from baandb.tznsls004301 a
         inner join baandb.tznsls410301 b 
                 on b.t$ncia$c = a.t$ncia$c
                and b.t$uneg$c = a.t$uneg$c
                and b.t$pecl$c = a.t$pecl$c
                and b.t$sqpd$c = a.t$sqpd$c
                and b.t$entr$c = a.t$entr$c
              where b.t$poco$c = 'WMS'
             having Trunc(min(b.t$dtoc$c)) Between :DataWMS_De And :DataWMS_Ate
           group by a.t$orno$c ) wms 
         ON wms.t$orno$c = tdsls400.t$orno
      
WHERE (cisli940.t$stat$l = 5 OR cisli940.t$stat$l = 6)
  AND tdsls400.t$fdty$l !=  14

  AND ((:Filial = 'AAA') OR (WMSCODE.FILIAL = :Filial) )
		
GROUP BY WMSCODE.FILIAL,
         WMSCODE.ID_FILIAL,
         sysdate,
         tcibd001.t$citg,
         tcmcs023.t$dsca