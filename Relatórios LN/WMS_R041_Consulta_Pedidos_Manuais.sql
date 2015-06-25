 SELECT 
 
--    WMS_OA_ORDERS_SH.ORDERKEY,
--    WMS_OA_ORDERS_OV.ORDERKEY,
--    WMS_OA_ORDERS_OA.ORDERKEY,
    
    FILIAL.DSC_FILIAL                  FILIAL,
    cisli940.t$docn$l                  NF,
    cisli940.t$seri$l                  SERIE,
    CASE WHEN WMS_OA_ORDERS_SH.ORDERKEY IS NULL THEN
      CASE WHEN WMS_OA_ORDERS_OV.ORDERKEY IS NULL THEN
          WMS_OA_ORDERS_OA.ORDERKEY
      ELSE WMS_OA_ORDERS_OV.ORDERKEY END
    ELSE  WMS_OA_ORDERS_SH.ORDERKEY END 
                                        PEDIDO_WMS,
    CASE WHEN WMS_OA_ORDERS_SH.REFERENCEDOCUMENT IS NULL THEN
      CASE WHEN WMS_OA_ORDERS_OV.REFERENCEDOCUMENT IS NULL THEN
          WMS_OA_ORDERS_OA.REFERENCEDOCUMENT
      ELSE
          WMS_OA_ORDERS_OV.REFERENCEDOCUMENT END
    ELSE  WMS_OA_ORDERS_SH.REFERENCEDOCUMENT END
                                       ORDEM_MOVIMENTACAO,
    CASE WHEN CODELKUP_SH.DESCRIPTION IS NULL THEN
      CASE WHEN CODELKUP_OV.DESCRIPTION IS NULL THEN
          CODELKUP_OA.DESCRIPTION
      ELSE  CODELKUP_OV.DESCRIPTION END
    ELSE  CODELKUP_SH.DESCRIPTION END  DESCRICAO_PEDIDO,
      
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                      DT_EMISSAO,
            
    cisli940.t$ccfo$l                  CFO,
    cisli940.t$opor$l                  SEQ_CFO,    
    tcmcs940.t$dsca$l                  NOME_CFO,
    znsls400.t$idca$c                  CANAL,
    TRIM(cisli941.t$item$l)            ID_ITEM,
    tcibd001.t$dsca                    NOME_ITEM,
    sum(cisli941.t$dqua$l)             QTD_FATURADA,
 
    CASE WHEN cisli941.t$iprt$l = 0 
           THEN round(tdsls401.t$pric,2) 
         ELSE   round(cisli941.t$pric$l,2)
     END                               VL_PRODUTO,
  
    CASE WHEN sum(cisli941.t$amnt$l) = 0 
           THEN sum(tdsls401.t$oamt) 
         ELSE   sum(cisli941.t$amnt$l)
     END                               VL_TOTAL_ITEM,
  
    CASE WHEN cisli941.t$gamt$l = 0 
           THEN round(tdsls401.t$pric,2) 
         ELSE   round(cisli941.t$gamt$l,2)
     END                               VL_MERCADORIA,
  
    CASE WHEN sum(cisli941.t$fght$l) = 0 
           THEN sum(nvl(znsls401.t$vlfr$c,0)) 
         ELSE   sum(cisli941.t$fght$l)
     END                               VL_FRETE,
 
    CASE WHEN sum(cisli941.t$ldam$l) = 0 
           THEN sum(nvl(znsls401.t$vlde$c,0)) 
         ELSE   sum(cisli941.t$ldam$l) 
     END                               VL_DESC_INC,
    
    sum( NVL(( select sum(cisli943.t$amnt$l) 
                 from baandb.tcisli943301 cisli943
                where cisli943.t$fire$l = cisli941.t$fire$l
                  and cisli943.t$LINE$l = cisli941.t$LINE$l
                  and cisli943.t$brty$l = 1 ), 0) )
                                       VL_ICMS,
    
    sum( NVL(( select sum(cisli943.t$amnt$l) 
                 from baandb.tcisli943301 cisli943
                where cisli943.t$fire$l = cisli941.t$fire$l
                  and cisli943.t$line$l = cisli941.t$line$l
                  and cisli943.t$brty$l = 5 ), 0) )
                                       VL_PIS,
    
    sum( NVL(( select sum(cisli943.t$amnt$l) 
                 from baandb.tcisli943301 cisli943
                where cisli943.t$fire$l = cisli941.t$fire$l
                  and cisli943.t$line$l = cisli941.t$line$l
                  and cisli943.t$brty$l = 6 ), 0) )
                                       VL_COFINS,
       
    cisli940.t$itbp$l                  ID_CLIENTE,
    cisli940.t$itbn$l                  NOME_CLIENTE,
    tccom130.t$namc                    ENDERECO,
    tccom130.t$dist$l                  BAIRRO,
    tccom130.t$pstc                    CEP,
    tccom130.t$dsca                    MUNICIPIO,
    tccom130.t$cste                    UF,
    tccom130.t$telp                    TEL1,
    tccom130.t$telx                    TEL2,
    tccom130.t$enfs$l                  EMAIL,
    cisli940.t$fdtc$l                  ID_TIPO_DOC_FIS,
    tcmcs966.t$dsca$l                  DESCR_TIPO_DOC_FIS,
    FGET.DESC_TIPO_DOCTO               DESC_TIPO_DOCTO,
    tccom130f.t$fovn$l                 CNPJ_FABRICANTE,
    tcmcs060.t$dsca                    NOME_FABRICANTE
                             
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
    
 LEFT JOIN baandb.ttdsls401301 tdsls401 
        ON tdsls401.t$orno = cisli245.t$slso 
       AND tdsls401.t$pono = cisli245.t$pono 
        
 LEFT JOIN baandb.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
  
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr  = cisli940.t$itoa$l
  
INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item  = cisli941.t$item$l
  
 LEFT JOIN baandb.ttcmcs060301 tcmcs060
        ON tcmcs060.t$cmnf  = tcibd001.t$cmnf

 LEFT JOIN baandb.ttccom130301 tccom130f
        ON tccom130f.t$cadr  = tcmcs060.t$cadr  
  
 LEFT JOIN baandb.ttcmcs966301 tcmcs966
        ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l
  
 LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOCTO
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'ci' 
                AND d.t$cdom = 'sli.tdff.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) FGET
        ON cisli940.t$fdty$l = FGET.CNST

     
 LEFT JOIN WMWHSE5.ORDERS@DL_LN_WMS WMS_OA_ORDERS_SH
        ON SUBSTR(WMS_OA_ORDERS_SH.EXTERNORDERKEY,5,9) = CISLI245.T$SHPM
               
 LEFT JOIN ( select MAX(a.ORDERKEY) ORDERKEY,
                    MAX(a.TYPE) TYPE,
                    a.REFERENCEDOCUMENT
             from   WMWHSE5.ORDERS@DL_LN_WMS a 
             GROUP BY a.REFERENCEDOCUMENT ) WMS_OA_ORDERS_OA
        ON SUBSTR(WMS_OA_ORDERS_OA.REFERENCEDOCUMENT,4,9) = CISLI245.T$SLSO       
        
  LEFT JOIN ( select MAX(a.ORDERKEY) ORDERKEY,
                     MAX(a.TYPE) TYPE,
                     a.REFERENCEDOCUMENT
              from   WMWHSE5.ORDERS@DL_LN_WMS a
              GROUP BY a.REFERENCEDOCUMENT ) WMS_OA_ORDERS_OV
         ON WMS_OA_ORDERS_OV.REFERENCEDOCUMENT = CISLI245.T$SLSO
        
 LEFT JOIN WMWHSE5.CODELKUP@DL_LN_WMS CODELKUP_SH
        ON CODELKUP_SH.LISTNAME = 'ORDERTYPE'
       AND CODELKUP_SH.CODE = WMS_OA_ORDERS_SH.TYPE
       
 LEFT JOIN WMWHSE5.CODELKUP@DL_LN_WMS CODELKUP_OA
        ON CODELKUP_OA.LISTNAME = 'ORDERTYPE'
       AND CODELKUP_OA.CODE = WMS_OA_ORDERS_OA.TYPE

 LEFT JOIN WMWHSE5.CODELKUP@DL_LN_WMS CODELKUP_OV
        ON CODELKUP_OV.LISTNAME = 'ORDERTYPE'
       AND CODELKUP_OV.CODE = WMS_OA_ORDERS_OV.TYPE
       
 LEFT JOIN baandb.tznsls000301 znsls000
        ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
                 
WHERE cisli940.t$fdty$l != 11
  AND cisli940.t$docn$l != 0
  AND cisli940.t$stat$l NOT IN (2, 101)
  AND cisli941.t$item$l != znsls000.t$itmd$c
  AND cisli941.t$item$l != znsls000.t$itmf$c
  AND cisli941.t$item$l != znsls000.t$itjl$c
  AND cisli940.t$fdty$l != 14
--  AND cisli940.t$fire$l IN ('000056306', '000056317')

   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                   AT time zone 'America/Sao_Paulo') AS DATE)) 
         Between :EmissaoDe
             And :EmissaoAte

GROUP BY FILIAL.DSC_FILIAL,
--                                WMS_OA_ORDERS_SH.ORDERKEY,
--                                WMS_OA_ORDERS_OV.ORDERKEY,
--                                WMS_OA_ORDERS_OA.ORDERKEY,
         cisli940.t$docn$l,                  
         cisli940.t$seri$l,                  
         CASE WHEN WMS_OA_ORDERS_SH.ORDERKEY IS NULL THEN
              CASE WHEN WMS_OA_ORDERS_OV.ORDERKEY IS NULL THEN
                WMS_OA_ORDERS_OA.ORDERKEY
              ELSE WMS_OA_ORDERS_OV.ORDERKEY END
         ELSE WMS_OA_ORDERS_SH.ORDERKEY END,
         CASE WHEN WMS_OA_ORDERS_SH.REFERENCEDOCUMENT IS NULL THEN
            CASE WHEN WMS_OA_ORDERS_OV.REFERENCEDOCUMENT IS NULL THEN
                  WMS_OA_ORDERS_OA.REFERENCEDOCUMENT
            ELSE  WMS_OA_ORDERS_OV.REFERENCEDOCUMENT END
         ELSE WMS_OA_ORDERS_SH.REFERENCEDOCUMENT END,
         CASE WHEN CODELKUP_SH.DESCRIPTION IS NULL THEN
            CASE WHEN CODELKUP_OV.DESCRIPTION IS NULL THEN
              CODELKUP_OA.DESCRIPTION
            ELSE CODELKUP_OV.DESCRIPTION END 
         ELSE CODELKUP_SH.DESCRIPTION END,            
         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE), 
         cisli940.t$ccfo$l,                  
         cisli940.t$opor$l,                  
         tcmcs940.t$dsca$l,                  
         znsls400.t$idca$c,                  
         TRIM(cisli941.t$item$l),            
         tcibd001.t$dsca ,                   
         CASE WHEN cisli941.t$iprt$l = 0 
                THEN round(tdsls401.t$pric,2) 
              ELSE   round(cisli941.t$pric$l,2)
          END,                               
         CASE WHEN cisli941.t$gamt$l = 0 
                THEN round(tdsls401.t$pric,2) 
              ELSE   round(cisli941.t$gamt$l,2)
          END,                               
         cisli940.t$itbp$l,                    
         cisli940.t$itbn$l,                    
         tccom130.t$namc,                      
         tccom130.t$dist$l,                    
         tccom130.t$pstc,                      
         tccom130.t$dsca,                      
         tccom130.t$cste,                      
         tccom130.t$telp,                      
         tccom130.t$telx,                      
         tccom130.t$enfs$l,                    
         cisli940.t$fdtc$l,                    
         tcmcs966.t$dsca$l,                    
         FGET.DESC_TIPO_DOCTO,                 
         tccom130f.t$fovn$l,               
         tcmcs060.t$dsca
   
 ORDER BY FILIAL, 
          DT_EMISSAO, 
          NF
