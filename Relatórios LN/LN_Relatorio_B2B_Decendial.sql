SELECT 
  DISTINCT
    znsls400.t$idcp$c             CAMPANHA,
    znsls400.t$idco$c             CONTRATO,
    tccom130f.t$fovn$l            CNPJ,
    tccom130f.t$nama              NOME,
    tccom130f.t$namc   || ' ' ||
    tccom130f.t$hono              ENDERECO,
    cisli940f.t$docn$l            NF_FATURA,
    cisli940f.t$seri$l            SERIE,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940f.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                  DT_EMISSAO,
    znsls401.t$entr$c             ENTREGA,
    znsls401.t$pecl$c             PEDIDO,
    tccom130r.t$fovn$l            CPF_PREMIADO,
    cisli940r.t$fids$l            NOME_PREMIADO,
    Trim(cisli941f.t$item$l)      ITEM,
    cisli941f.t$desc$l            DESCRICAO_ITEM,
    cisli941f.t$dqua$l            QTD,
    cisli941f.t$pric$l            PRECO_UNIT,
    cisli941f.t$gamt$l            PRECO_TOTAL,
    cisli941f.t$ldam$l            VL_DESC_ITEM,
    cisli941f.t$fght$l            VL_FRETE_ITEM,
    cisli941f.t$amnt$l            VL_TOTAL_ITEM,
    cisli940f.t$cnfe$l            CHAVE_DE_ACESSO,
    tccom130r.t$ccit              MUNICIPIO_ENTREGA,
    tccom139r.t$dscb$c            DESC_MUNICIPIO_ENTR,
    tccom130r.t$cste              UF_ENTREGA,
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
  
FROM       baandb.tznsls401201  znsls401

INNER JOIN baandb.tznsls400201 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
      
INNER JOIN baandb.tcisli245201 cisli245
        ON cisli245.t$slso = znsls401.t$orno$c
       AND cisli245.t$pono = znsls401.t$pono$c
       
INNER JOIN baandb.tcisli940201 cisli940r            -- capa nota remessa
        ON cisli940r.t$fire$l = cisli245.t$fire$l
    
INNER JOIN baandb.tcisli941201 cisli941r           -- linha nota remessa
        ON cisli941r.t$fire$l = cisli245.t$fire$l
       AND cisli941r.t$line$l = cisli245.t$line$l
       
INNER JOIN baandb.tcisli940201 cisli940f           -- capa nota fatura
        ON cisli940f.t$fire$l = cisli941r.t$refr$l
           
INNER JOIN baandb.tcisli941201 cisli941f           -- linha nota fatura
        ON cisli941f.t$fire$l = cisli941r.t$refr$l
       AND cisli941f.t$line$l = cisli941r.t$line$l
      
INNER JOIN baandb.ttccom130201 tccom130f            -- endereço fatura
        ON tccom130f.t$cadr = cisli940f.t$stoa$l
        
INNER JOIN baandb.ttccom130201 tccom130r            -- endereço remessa
        ON tccom130r.t$cadr = cisli940r.t$stoa$l
        
INNER JOIN baandb.ttccom139201 tccom139r
        ON tccom139r.t$ccty = tccom130r.t$ccty
       AND tccom139r.t$cste = tccom130r.t$cste
       AND tccom139r.t$city = tccom130r.t$ccit
        
INNER JOIN baandb.ttcibd001201  tcibd001
        ON tcibd001.t$item = cisli941f.t$item$l
        
INNER JOIN baandb.ttcibd936201  tcibd936
        ON tcibd936.t$ifgc$l = tcibd001.t$ifgc$l
          
 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943201 a
              where a.t$brty$l = 1 ) ICMS
        ON ICMS.FIRE = cisli941f.t$fire$l
       AND ICMS.LINE = cisli941f.t$line$l
     
 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943201 a
              where a.t$brty$l = 3 ) IPI
        ON IPI.FIRE = cisli941f.t$fire$l
       AND IPI.LINE = cisli941f.t$line$l
      
 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943201 a
              where a.t$brty$l = 2 ) ICMSST
        ON ICMSST.FIRE = cisli941f.t$fire$l
       AND ICMSST.LINE = cisli941f.t$line$l
   
 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943201 a
              where a.t$brty$l = 5 ) PIS
        ON PIS.FIRE = cisli941f.t$fire$l
       AND PIS.LINE = cisli941f.t$line$l
     
 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943201 a
              where a.t$brty$l = 5 ) COFINS
        ON COFINS.FIRE = cisli941f.t$fire$l
       AND COFINS.LINE = cisli941f.t$line$l

 LEFT JOIN ( select a.t$base$l  BASE,
                    a.t$rate$l  PERC,
                    a.t$amnt$l  VL,
                    a.t$fire$l  FIRE,
                    a.t$line$l  LINE
               from baandb.tcisli943201 a
              where a.t$brty$l = 13 ) CSLL
        ON CSLL.FIRE = cisli941f.t$fire$l
       AND CSLL.LINE = cisli941f.t$line$l
       
WHERE znsls400.t$idca$c = 'B2B'
  AND znsls401.t$idor$c = 'LJ'
  AND cisli940f.t$stat$l in (5, 6)

  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940f.t$date$l, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
      Between :DataEmissaoDe
          And :DataEmissaoAte
