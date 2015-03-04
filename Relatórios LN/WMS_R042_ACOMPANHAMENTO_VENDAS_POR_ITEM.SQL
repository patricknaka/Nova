SELECT  
  wmsCODE.UDF2                   FILIAL,
  Trim(tdsls401.t$item)          ITEM,
  tcibd001.t$dsca                DESCR_ITEM,
  CASE WHEN NVL(SITUA.STAT,0) = 0 
         THEN 'Aberto' 
       ELSE   'Liquidado' 
   END                           SITUACAO,
  SUM(tdsls401.t$qoor)           QTD,
  SUM(tdsls401.t$oamt)           VALOR_MERC
  
FROM       baandb.ttdsls401301 tdsls401

 LEFT JOIN ( select cisli245.t$slso, 
                    cisli245.t$pono, 
                    count(cisli245.t$slso) STAT 
               from baandb.tcisli245301 cisli245
              where cisli245.t$ortp = 1
                and cisli245.t$koor = 3
           group by cisli245.t$slso, 
                    cisli245.t$pono ) SITUA
        ON SITUA.t$slso = tdsls401.t$orno
       AND SITUA.t$pono = tdsls401.t$pono
   
INNER JOIN BAANDB.ttdsls400301 tdsls400
        ON tdsls400.t$orno = tdsls401.t$orno

INNER JOIN BAANDB.ttdsls094301 tdsls094
        ON tdsls094.t$sotp = tdsls400.t$sotp

INNER JOIN BAANDB.ttcibd001301 tcibd001
        ON tcibd001.t$item = tdsls401.t$item

INNER JOIN BAANDB.ttcemm300301 tcemm300
        ON tcemm300.t$code = tdsls401.t$cwar

INNER JOIN ENTERPRISE.CODELKUP@DL_LN_WMS wmsCode
        ON UPPER(TRIM(wmsCode.DESCRIPTION)) = tcemm300.t$lctn
  
WHERE tdsls401.t$dltp = 15
  AND tcemm300.t$type = 20
  AND tdsls094.t$reto = 2
  AND tdsls401.t$qoor > 0

  AND Trunc(  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) ) 
      Between :DataDe 
          And :DataAte
  AND ( (:Filial = 'AAA') OR (UPPER(wmsCODE.UDF1) = :Filial) )
  
GROUP BY  wmsCODE.UDF2,
          tdsls401.t$item,
          tcibd001.t$dsca,
          SITUA.STAT