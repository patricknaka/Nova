SELECT
  FILIAL_WMS.UDF2                   FILIAL,
  TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE), 'DD')    
                                    DT_EMISSAO,
  COUNT(DISTINCT tdsls401.t$orno)   QTD_PEDIDOS,
  tcibd001.t$citg                   ID_DEPTO,
  tcmcs023.t$dsca                   DEPARTAMENTO,
  sum(tdsls401.t$oamt)              VALOR_TOTAL

FROM baandb.ttdsls400201     tdsls400,
     baandb.ttdsls401201     tdsls401,
     baandb.ttcemm124201     tcemm124,

   ( SELECT DISTINCT 
            a.UDF1, 
            a.UDF2,
            c.t$grid 
       FROM ENTERPRISE.CODELKUP@DL_LN_WMS a, 
            baandb.ttcemm300201 b, 
            baandb.ttcemm112201 c
      WHERE a.LISTNAME = 'SCHEMA'
        AND b.t$lctn = a.description
        AND c.t$waid = b.t$code
        AND b.t$type = 20 )  FILIAL_WMS,
 
     baandb.ttcibd001201     tcibd001,
     baandb.ttcmcs023201     tcmcs023,
     baandb.tcisli940201     cisli940,
     baandb.tcisli245201     cisli245

WHERE tdsls400.t$orno   = tdsls401.t$orno 
  AND tcemm124.t$cwoc   = tdsls400.t$cofc 
  AND FILIAL_WMS.t$grid = tcemm124.t$grid 
  AND tcibd001.t$item   = tdsls401.t$item 
  AND tcibd001.t$citg   = tcmcs023.t$citg 
  AND cisli245.t$slso   = tdsls401.t$orno 
  AND cisli245.t$pono   = tdsls401.t$pono 
  AND cisli245.t$ortp   = 1  
  AND cisli245.t$koor   = 3  
  AND cisli940.t$fire$l = cisli245.t$fire$l 
  AND ( cisli940.t$fdty$l = 1 OR cisli940.t$fdty$l = 15 )
 
  AND ( (FILIAL_WMS.UDF1 = :Filial) OR (:Filial = 'AAA') )
  AND Trunc(cisli940.t$dats$l) Between :DataFaturamentoDe
  AND :DataFaturamentoAte
  
GROUP BY FILIAL_WMS.UDF2,
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'), 
         tcibd001.t$citg, 
         tcmcs023.t$dsca

ORDER BY FILIAL_WMS.UDF2,
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE), 'DD'),
         tcmcs023.t$dsca
         

----------------------------------------------------------------------------------------
--Armazem-------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

 select To_nchar('AAA')            COD, 
        To_nchar('Todos')          NOME
   from Dual
   
Union All

 Select Q1.* from ( SELECT DISTINCT 
                           a.UDF1  COD, 
                           a.UDF2  NOME
                      FROM ENTERPRISE.CODELKUP@DL_LN_WMS a, baandb.ttcemm300201 b
                     WHERE a.LISTNAME = 'SCHEMA'
                       AND b.t$lctn = a.description
                  ORDER BY a.UDF2 ) Q1