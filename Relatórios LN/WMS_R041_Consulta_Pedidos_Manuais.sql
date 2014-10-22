SELECT 
  DISTINCT
    FILIAL.DSC_FILIAL        FILIAL,
    cisli940.t$docn$l        NF,
    cisli940.t$seri$l        SERIE,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE) 
                             DT_EMISSAO,
    
    cisli940.t$ccfo$l        CFO,
    cisli940.t$opor$l        SEQ_CFO,    
    tcmcs940.t$dsca$l        NOME_CFO,
    znsls400.t$idca$c        CANAL,
    TRIM(cisli941.t$item$l)  ID_ITEM,
    tcibd001.t$dsca          NOME_ITEM,
    cisli941.t$dqua$l        QTD_FATURADA,
    cisli941.t$amnt$l        VL_PRODUTO,
    cisli941.t$iprt$l        VL_TOTAL_ITEM,
    cisli941.t$gamt$l        VL_MERCADORIA,
    cisli941.t$fght$l        VL_FRETE,
    cisli941.t$ldam$l        VL_DESC_INC,
    
    NVL(( select cisli943.t$amnt$l 
            from baandb.tcisli943301 cisli943
           where cisli943.t$fire$l = cisli941.t$fire$l
             and cisli943.t$line$l = cisli941.t$line$l
             and cisli943.t$brty$l = 1 ), 0)
                             VL_ICMS,
    
    NVL(( select cisli943.t$amnt$l 
            from baandb.tcisli943301 cisli943
           where cisli943.t$fire$l = cisli941.t$fire$l
             and cisli943.t$line$l = cisli941.t$line$l
             and cisli943.t$brty$l = 5 ), 0)
                             VL_PIS,
    
    NVL(( select cisli943.t$amnt$l 
            from baandb.tcisli943301 cisli943
           where cisli943.t$fire$l = cisli941.t$fire$l
             and cisli943.t$line$l = cisli941.t$line$l
             and cisli943.t$brty$l = 6 ), 0)
                             VL_COFINS,
       
    cisli940.t$itbp$l        ID_CLIENTE,
    cisli940.t$itbn$l        NOME_CLIENTE,
    tccom130.t$namc          ENDERECO,
    tccom130.t$dist$l        BAIRRO,
    tccom130.t$pstc          CEP,
    tccom130.t$ln03          MUNICIPIO,
    tccom130.t$cste          UF,
    tccom130.t$telp          TEL1,
    tccom130.t$telx          TEL2,
    tccom130.t$enfs$l        EMAIL,
	cisli940.t$fdtc$l		 ID_TIPO_DOC_FIS,
	(select a.t$dsca$l from baandb.ttcmcs966301 a
	 where a.t$fdtc$l=cisli940.t$fdtc$l)	DESCR_TIPO_DOC_FIS
    
FROM       baandb.tcisli940301 cisli940

INNER JOIN ( select tcemm030.t$eunt CHAVE_FILIAL,
                    tcemm030.t$dsca DSC_FILIAL,
                    tcemm124.t$cwoc
               from baandb.ttcemm124301 tcemm124, 
                    baandb.ttcemm030301 tcemm030
              where tcemm030.t$eunt = tcemm124.t$grid
                and tcemm124.t$loco = 301 ) FILIAL
        ON FILIAL.t$cwoc = cisli940.t$cofc$l 

 LEFT JOIN baandb.ttcmcs940301 tcmcs940 
        ON tcmcs940.T$OFSO$L = cisli940.t$ccfo$l

INNER JOIN baandb.tcisli941301 cisli941
        ON cisli941.t$fire$l = cisli940.t$fire$l
  
INNER JOIN baandb.tcisli245301 cisli245
        ON cisli245.t$fire$l = cisli941.t$fire$l
       AND cisli245.t$line$l = cisli941.t$line$l

 LEFT JOIN baandb.tznsls401301 znsls401
        ON znsls401.t$orno$c = cisli245.t$slso
       AND znsls401.t$pono$c = cisli245.t$pono

 LEFT JOIN baandb.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
  
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr   = cisli940.t$itbp$l
  
INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item   = cisli941.t$item$l
  
WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone sessiontimezone) AS DATE)) 
      Between :EmissaoDe
          And :EmissaoAte

  AND FILIAL.CHAVE_FILIAL IN (:FILIAL)

ORDER BY FILIAL, 
         DT_EMISSAO, 
         NF