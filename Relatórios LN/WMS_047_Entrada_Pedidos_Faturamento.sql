SELECT unid_empr.FILIAL                              FILIAL,
       sysdate                                       DATA_CONSULTA,
       unid_empr.DESC_FILIAL                         DESC_FILIAL,
       tcibd001.t$citg                               ID_DP,
       tcmcs023.t$dsca                               NOME,
       SUM(tdsls401.t$oamt)                          PR_FINAL,
       SUM(tdsls401.t$qoor)                          QTD_PEDIDO
      
FROM      baandb.ttdsls400301   tdsls400

LEFT JOIN baandb.ttdsls401301  tdsls401
       ON tdsls401.t$orno = tdsls400.t$orno
      
LEFT JOIN ( SELECT tcemm030.t$dsca  DESC_FILIAL,
                   tcemm030.t$euca  FILIAL,
                   tcemm030.T$EUNT  CHAVE_FILIAL,
                   tcemm124.t$cwoc
              FROM baandb.ttcemm124301 tcemm124, 
                   baandb.ttcemm030301 tcemm030
             WHERE tcemm030.t$eunt = tcemm124.t$grid
               AND tcemm124.t$loco = 301 ) unid_empr
       ON unid_empr.t$cwoc = tdsls400.t$cofc
     
LEFT JOIN baandb.ttcibd001301   tcibd001
       ON tcibd001.t$item = tdsls401.t$item
      
LEFT JOIN baandb.ttcmcs023301 tcmcs023
       ON tcmcs023.t$citg = tcibd001.t$citg
      
LEFT JOIN baandb.tcisli245301  cisli245
       ON cisli245.t$slso = tdsls401.t$orno
      AND cisli245.t$pono = tdsls401.t$pono
      
LEFT JOIN baandb.tcisli940301 cisli940
       ON cisli940.t$fire$l = cisli245.t$fire$l

LEFT JOIN ( select a.t$orno$c,
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
      
WHERE cisli245.t$koor = 3
  AND (cisli940.t$stat$l = 5 OR cisli940.t$stat$l = 6)
  AND tdsls400.t$fdty$l !=  14

  AND unid_empr.CHAVE_FILIAL IN (:Filial)

GROUP BY unid_empr.FILIAL,
         sysdate,
         unid_empr.DESC_FILIAL, 
         unid_empr.CHAVE_FILIAL, 
         tcibd001.t$citg,
         tcmcs023.t$dsca 
          
ORDER BY unid_empr.CHAVE_FILIAL, 
         LPAD(tcibd001.t$citg, 6, 0)