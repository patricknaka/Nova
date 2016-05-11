 SELECT 
  DISTINCT
    znsls400.t$idcp$c            CAMPANHA,
    znsls400.t$idco$c            CONTRATO,
    tccom130.t$fovn$l            CNPJ,
    tccom130.t$nama              NOME,
    tccom130.t$namc   || ' ' ||
    tccom130.t$hono              ENDERECO,
    cisli940.t$docn$l            NF_FATURA,
    cisli940.t$seri$l            SERIE,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                  DT_EMISSAO,
    znsls401.t$entr$c             ENTREGA,
    znsls401.t$pecl$c             PEDIDO,
    tccom130.t$fovn$l            CPF_PREMIADO,
    cisli940.t$fids$l            NOME_PREMIADO,
    Trim(cisli941.t$item$l)      ITEM,
    cisli941.t$desc$l            DESCRICAO_ITEM,
    cisli941.t$dqua$l            QTD,
    cisli941.t$pric$l            PRECO_UNIT,
    cisli941.t$gamt$l            PRECO_TOTAL,
    cisli941.t$ldam$l            VL_DESC_ITEM,
    cisli941.t$fght$l            VL_FRETE_ITEM,
    cisli941.t$amnt$l            VL_TOTAL_ITEM,
    cisli940.t$cnfe$l            CHAVE_DE_ACESSO,
    tccom130.t$ccit              MUNICIPIO_ENTREGA,
    tccom139.t$dscb$c            DESC_MUNICIPIO_ENTR,
    tccom130.t$cste              UF_ENTREGA,
    tcibd936.t$frat$l             NCM_SH,
    tcibd936.t$dsca$l             DESC_NCM,
    ICMS.PERC                     PERC_ICMS,
    IPI.PERC                      PERC_IPI,
    ICMSST.PERC                   PERC_ICMS_ST,
    CASE WHEN ICMS.PERC = 0.00 
           THEN 0.00
         ELSE   ICMS.BASE 
     END                          VL_BASE_ICMS,
    CASE WHEN IPI.PERC = 0.00 
           THEN 0.00
         ELSE   IPI.BASE 
     END                          VL_BASE_IPI,
    CASE WHEN ICMSST.PERC = 0.00 
           THEN 0.00
         ELSE   ICMSST.BASE 
     END                          VL_BASE_ICMS_ST, 
    ICMS.VL                       VL_ICMS,
    IPI.VL                        VL_IPI,
    ICMSST.VL                     VL_ICMS_ST,
    PIS.PERC                      PERC_PIS,
    COFINS.PERC                   PERC_COFINS,
    CSLL.PERC                     PERC_CSLL,
    PIS.VL                        VL_PIS,
    COFINS.VL                     VL_COFINS,
    CSLL.VL                       VL_CSLL
  
FROM baandb.tcisli941301 cisli941     

INNER JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = cisli941.t$fire$l
        
LEFT JOIN baandb.tcisli245301 cisli245
       ON cisli245.t$fire$l = cisli941.t$fire$l
      AND cisli245.t$line$l = cisli941.t$line$l
      
LEFT JOIN baandb.tznsls401301  znsls401
       ON znsls401.t$orno$c = cisli245.t$slso
      AND znsls401.t$pono$c = cisli245.t$pono

INNER JOIN baandb.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
        
LEFT JOIN baandb.ttccom130301 tccom130              --endereço entrega
        ON tccom130.t$cadr = cisli940.t$stoa$l
        
INNER JOIN baandb.ttccom139301 tccom139
        ON tccom139.t$ccty = tccom130.t$ccty
       AND tccom139.t$cste = tccom130.t$cste
       AND tccom139.t$city = tccom130.t$ccit
        
INNER JOIN baandb.ttcibd001301  tcibd001
        ON tcibd001.t$item = cisli941.t$item$l
        
INNER JOIN baandb.ttcibd936301  tcibd936
        ON tcibd936.t$ifgc$l = tcibd001.t$ifgc$l
 
 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943301 a
              where a.t$brty$l = 1 ) ICMS
        ON ICMS.FIRE = cisli941.t$fire$l
       AND ICMS.LINE = cisli941.t$line$l
     
 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943301 a
              where a.t$brty$l = 3 ) IPI
        ON IPI.FIRE = cisli941.t$fire$l
       AND IPI.LINE = cisli941.t$line$l
       
 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943301 a
              where a.t$brty$l = 2 ) ICMSST
        ON ICMSST.FIRE = cisli941.t$fire$l
       AND ICMSST.LINE = cisli941.t$line$l
   
 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943301 a
              where a.t$brty$l = 5 ) PIS
        ON PIS.FIRE = cisli941.t$fire$l
       AND PIS.LINE = cisli941.t$line$l
     
 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943301 a
              where a.t$brty$l = 5 ) COFINS
        ON COFINS.FIRE = cisli941.t$fire$l
       AND COFINS.LINE = cisli941.t$line$l

 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943301 a
              where a.t$brty$l = 13 ) CSLL
        ON CSLL.FIRE = cisli941.t$fire$l
       AND CSLL.LINE = cisli941.t$line$l

WHERE cisli940.t$stat$l in (5, 6)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataEmissaoDe
          And :DataEmissaoAte
