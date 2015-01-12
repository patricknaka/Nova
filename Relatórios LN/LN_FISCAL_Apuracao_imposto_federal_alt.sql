SELECT 
  tdrec940.t$cofc$l                       DEPTO,
  tcemm030.t$euca                         FILIAL,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                          DATA_EMISSAO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                          DATA_FISCAL,
  
  CASE WHEN tfacp200.t$balc = 0 
       THEN ( select max(p.t$docd) 
              from   baandb.ttfacp200301 p
              where  p.t$ttyp = tdrec940.t$ttyp$l
              and    p.t$ninv = tdrec940.t$invn$l )
       ELSE NULL 
  END                                     DATA_LIQUIDACAO,
                   
  tccom130.t$fovn$l                       CNPJ_FORN,
  tccom100.t$nama                         NOME_FORN,
  tdrec940.t$fire$l                       NR,
  tdrec940.t$docn$l                       NF,
  tdrec940.t$seri$l                       SERIE,
  tdrec940.t$ttyp$l || 
  tdrec940.t$invn$l                       TITULO,
  tdrec940.t$tfda$l                       VALOR_TOTAL,
  tcibd001.t$citg                         GRUPO_ITEM,
  tcmcs023.t$dsca                         DESCRICAO,
 
  SUM( ( SELECT SUM(tdrec942.t$amnt$l) 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
         AND tdrec942.t$line$l = tdrec941.t$line$l
         AND tdrec942.t$brty$l = 7))        VALOR_ISS,
    
  SUM( ( SELECT SUM(tdrec942.t$amnt$l)
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
         AND tdrec942.t$line$l = tdrec941.t$line$l
         AND tdrec942.t$brty$l IN (9,10) ))  VALOR_IRRF,
    
  SUM( ( SELECT SUM(tdrec942.t$amnt$l) 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
         AND tdrec942.t$line$l = tdrec941.t$line$l
         AND tdrec942.t$brty$l = 8 ) )       VALOR_INSS,
      
  SUM( ( SELECT SUM(tdrec942.t$amnt$l)
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
         AND tdrec942.t$line$l = tdrec941.t$line$l
         AND tdrec942.t$brty$l = 5 ) )       VALOR_PIS,
      
  SUM( ( SELECT SUM(tdrec942.t$amnt$l) 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
         AND tdrec942.t$line$l = tdrec941.t$line$l
         AND tdrec942.t$brty$l = 6 ) )       VALOR_COFINS,
      
  SUM( ( SELECT SUM(tdrec942.t$amnt$l) 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
         AND tdrec942.t$line$l = tdrec941.t$line$l
         AND tdrec942.t$brty$l = 11 ) )       VALOR_PIS_RETIDO,
      
  SUM( ( SELECT SUM(tdrec942.t$amnt$l) 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
         AND tdrec942.t$line$l = tdrec941.t$line$l
         AND tdrec942.t$brty$l = 12 ) )       VALOR_COFINS_RETIDO,
      
  SUM( ( SELECT SUM(tdrec942.t$amnt$l) 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
         AND tdrec942.t$line$l = tdrec941.t$line$l
         AND tdrec942.t$brty$l = 13 ) )       VALOR_CSLL_RETIDO,
      
  SUM( ( SELECT SUM(tdrec942.t$amnt$l) 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
         AND tdrec942.t$line$l = tdrec941.t$line$l
         AND tdrec942.t$brty$l = 14 ) )       VALOR_ISS_RETIDO,
      
  SUM( ( SELECT SUM(tdrec942.t$amnt$l) 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
         AND tdrec942.t$line$l = tdrec941.t$line$l
         AND tdrec942.t$brty$l = 15 ) )       VALOR_INSS_RETIDO_PJ,
  
  SUM( ( SELECT SUM(tdrec942.t$amnt$l) 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
         AND tdrec942.t$line$l = tdrec941.t$line$l
         AND tdrec942.t$brty$l = 17 ) )       VALOR_INSS_RETIDO_PF,

   tfacp200.t$balc                      SALDO
   

FROM      baandb.ttdrec940301 tdrec940

LEFT JOIN baandb.ttdrec941301 tdrec941 
       ON tdrec940.t$fire$l = tdrec941.t$fire$l

LEFT JOIN baandb.ttcibd001301 tcibd001 
       ON tcibd001.t$item = tdrec941.t$item$l
       
LEFT JOIN baandb.ttcmcs023301 tcmcs023 
       ON tcibd001.t$citg = tcmcs023.t$citg
       
LEFT JOIN baandb.ttccom100301 tccom100 
       ON tccom100.t$bpid   = tdrec940.t$bpid$l
       
LEFT JOIN BAANDB.ttccom130301 tccom130 
       ON tccom130.t$cadr=tccom100.t$cadr
       
LEFT JOIN baandb.ttfacp200301 tfacp200 
       ON tdrec940.t$ttyp$l = tfacp200.t$ttyp
      AND tdrec940.t$invn$l = tfacp200.t$ninv
      AND tfacp200.T$DOCN = 0
      
INNER JOIN baandb.ttcemm124301 tcemm124
        ON tcemm124.t$cwoc = tdrec940.t$cofc$l 
       AND tcemm124.t$dtyp = 2         
    
INNER JOIN baandb.ttcemm030301 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid
    
WHERE Trim(tdrec940.t$opfc$l) in ('1933', '2933', '1300')
  AND Trunc(  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) ) Between :DataFiscalDe AND :DataFiscalAte
		
GROUP BY
  tdrec940.t$cofc$l, tcemm030.t$euca,   tdrec940.t$idat$l, tdrec940.t$date$l, 
  tfacp200.t$balc,   tccom130.t$fovn$l, tccom100.t$nama,   tdrec940.t$fire$l, 
  tdrec940.t$docn$l, tdrec940.t$seri$l, tdrec940.t$ttyp$l, tdrec940.t$invn$l, 
  tdrec940.t$tfda$l, tcibd001.t$citg,   tcmcs023.t$dsca 

ORDER BY tdrec940.t$cofc$l,
         tcemm030.t$euca,
         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                    AT time zone sessiontimezone) AS DATE) 