SELECT
  tdrec940.t$fire$l,
  tdrec940.t$fdtc$l,
  
  znfmd001.t$fili$c         FILIAL,
  znfmd001.t$dsca$c         NOME_FILIAL,
  znsls004.t$pecl$c         PEDIDO,
  cisli940.t$docn$l         NOTA_ORIGINAL,
  cisli940.t$seri$l         SERIE_ORIGINAL,
  tdrec940.t$docn$l         NOTA_ENTRADA,
  tdrec940.t$seri$l         SERIE_ENTRADA,
  tdrec940.t$date$l         DATA_FISCAL,
  tdrec941.t$item$l         ITEM,
  tcibd001.t$dscb$c         DESCRICAO,
  znmcs030.t$dsca$c         SETOR,
  znmcs031.t$dsca$c         FAMILIA,
  znsls401.t$lmot$c         MOTIVO_DEVOLUCAO,
  tdrec941.t$qnty$l         QTDE,
  CMV.mauc_unit             CMV_UNITARIO,
  CMV.mauc_tot              CMV_TOTAL
                            
FROM baandb.ttdrec941301 tdrec941

INNER JOIN baandb.ttdrec940301 tdrec940
        ON tdrec940.t$fire$l = tdrec941.t$fire$l
        
INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item = tdrec941.t$item$l
        
LEFT JOIN baandb.tznmcs030301 znmcs030
       ON znmcs030.t$citg$c = tcibd001.t$citg
      AND znmcs030.t$seto$c = tcibd001.t$seto$c
      
LEFT JOIN baandb.tznmcs031301 znmcs031
       ON znmcs031.t$citg$c = tcibd001.t$citg
      AND znmcs031.t$seto$c = tcibd001.t$seto$c
      AND znmcs031.t$fami$c = tcibd001.t$fami$c
      
LEFT JOIN baandb.tcisli940301 cisli940
       ON cisli940.t$docn$l = tdrec940.t$docn$l
      AND cisli940.t$seri$l = tdrec940.t$seri$l
      
INNER JOIN ( select a.t$fire$l,
                    a.t$line$l,
                    a.t$orno$l,
                    a.t$pono$l
             from   baandb.ttdrec947301 a
             group by a.t$fire$l,
                      a.t$line$l,
                      a.t$orno$l,
                      a.t$pono$l ) tdrec947
        ON tdrec947.t$fire$l = tdrec941.t$fire$l
       AND tdrec947.t$line$l = tdrec941.t$line$l

LEFT JOIN ( select  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$sequ$c,
                    a.t$orno$c,
                    a.t$pono$c 
            from baandb.tznsls004301 a
            group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$sequ$c,
                    a.t$orno$c,
                    a.t$pono$c ) znsls004
      ON znsls004.t$orno$c = tdrec947.t$orno$l
     AND znsls004.t$pono$c = tdrec947.t$pono$l
                          
LEFT JOIN baandb.tznsls401301 znsls401
       ON znsls401.t$ncia$c = znsls004.t$ncia$c
      AND znsls401.t$uneg$c = znsls004.t$uneg$c
      AND znsls401.t$pecl$c = znsls004.t$pecl$c
      AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
      AND znsls401.t$entr$c = znsls004.t$entr$c
      AND znsls401.t$sequ$c = znsls004.t$sequ$c

LEFT JOIN  ( select case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)) = 0 
                    then 0
                    else   round(sum(a.t$mauc$1) /(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
                    end mauc_unit,
                    case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)) = 0 
                    then 0
                    else   round(sum(a.t$mauc$1),4) 
                    end mauc_tot,
                    a.t$item
            from baandb.twhwmd217301 a
                inner join baandb.ttcemm112301 tcemm112
                        on tcemm112.t$waid = a.t$cwar
                inner join baandb.twhwmd215301 whwmd215
                        on whwmd215.t$cwar = a.t$cwar
                       and whwmd215.t$item = a.t$item
            group by a.t$item ) CMV
    ON CMV.t$item = tdrec941.t$item$l

INNER JOIN baandb.ttcmcs065301 tcmcs065
        ON tcmcs065.t$cwoc = tdrec940.t$cofc$l
        
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tcmcs065.t$cadr
        
INNER JOIN baandb.tznfmd001301 znfmd001
        ON znfmd001.t$fovn$c = tccom130.t$fovn$l
        
where tdrec940.t$rfdt$l = 10    --retorno de mercadoria
