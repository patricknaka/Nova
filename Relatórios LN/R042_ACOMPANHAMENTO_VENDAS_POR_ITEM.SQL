select  
  wmsCODE.UDF2                   FILIAL,
  Trim(tdsls401.t$item)          ITEM,
  tcibd001.t$dsca                DESCR_ITEM,
  CASE WHEN NVL(SITUA.STAT,0) = 0 
         THEN 'ABERTO' 
       ELSE   'FECHADO' 
   END                           SITUACAO,
  SUM(tdsls401.t$qoor)           QTD,
  SUM(tdsls401.t$oamt)           VALOR_MERC
  
FROM      baandb.ttdsls401301 tdsls401

LEFT JOIN ( select cisli245.t$slso, 
                   cisli245.t$pono, 
                   count(cisli245.t$slso) STAT 
              from baandb.tcisli245301 cisli245
             where cisli245.t$ortp = 1
               and cisli245.t$koor = 3
          group by cisli245.t$slso, 
                   cisli245.t$pono ) SITUA
       ON SITUA.t$slso = tdsls401.t$orno
      AND SITUA.t$pono = tdsls401.t$pono,   
   
          BAANDB.ttdsls400301 tdsls400,
          BAANDB.ttcibd001301 tcibd001,
          BAANDB.ttcemm300301 tcemm300,
          ENTERPRISE.CODELKUP@DL_LN_WMS wmsCode
  
WHERE tdsls400.t$orno = tdsls401.t$orno
  AND tcibd001.t$item = tdsls401.t$item
  AND tdsls401.t$dltp = 15
  AND tcemm300.t$code = tdsls401.t$cwar
  AND tcemm300.t$type = 20
  AND UPPER(TRIM(wmsCode.DESCRIPTION)) = tcemm300.t$lctn
  AND Trunc(tdsls400.t$odat) BETWEEN :DataDe AND :DataAte
  AND ( (:Filial = 'AAA') OR (UPPER(wmsCODE.UDF1) = :Filial) )
  
GROUP BY  wmsCODE.UDF2,
          tdsls401.t$item,
          tcibd001.t$dsca,
          SITUA.STAT