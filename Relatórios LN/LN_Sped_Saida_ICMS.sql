--Saída
select Q1.* 
  from ( SELECT DISTINCT
                301                                   CIA,
                tcemm030.T$EUNT                       FILIAL,
                ' '                                   ID_NFE,
                cisli940.t$docn$l                     NF,
                cisli940.t$seri$l                     SERIE,
                cisli940.t$cnfe$l                     ID_CHAVE,
                
                CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone sessiontimezone) AS DATE)
                                                      DATA_EMISSAO,
                     
                CASE WHEN cisli940.t$stat$l = 2 THEN 'CANCELADA'
                      ELSE 'ATIVA' 
                 END                                  SITUACAO,
                ' '                                   ID_MOTIVO,
                tccom130.t$cste                       UF,
                cisli941.t$ccfo$l                     CFO,
                ' '                                   SEQ_CFO,
                tcmcs940.t$dsca$l                     NOME_CFO,                 
                ' '                                   MODULO_BASE_GER,
                cisli940.t$bpid$l                     COD_PART,          
                tccom110.t$cbtp                       COD_TIPO,
                ' '                                   ID_CLIENTE,
                tccom966.t$stin$d                     IE_CLIENTE,
                tccom100.t$nama                       NOME_CLIENTE,
                tccom130.t$ccit                       ID_MUNIC,
                CASE WHEN cisli940.t$itoa$l = cisli940.t$stoa$l 
                       THEN 'Fatura' 
                     ELSE   'Entrega' 
                 END                                  TIPO_ENDER, 
                cisli940.t$stoa$l                     SEQ_ENDER,
                tccom130.t$namc                       END_RUA,
                tccom130.t$dist$l                     END_BAIRRO,
                tccom130.t$hono                       END_NUMERO,
                tccom130.t$namd                       END_COMPL,
                cisli941.t$line$l                     LINE_ITEM,
                tcibd001.t$citg                       ID_DEPTO,
                Trim(tcibd001.t$item)                 ID_ITEM,
                tcibd936.t$sour$l                     ID_PROC,
                tcibd936.t$frat$l                     NBM,
                ' '                                   SEQ_NBM,
                tcibd001.t$dsca                       NOME_ITEM,
                tcibd001.t$ceat$l                     COD_EAN,
                tcibd001.t$fami$c                     CATEGORIA,
                tcibd001.t$subf$c                     SUBCATEGORIA,
                tcmcs060.t$dsca                       MARCA,
                cisli941.t$pric$l                     PR_UNITARIO,
                cisli941.t$dqua$l                     QTD_FATURADA,
                cisli941.t$gamt$l                     VL_MERCADORIA,
                cisli941.t$fght$l                     VL_FRETE,
                cisli941.t$insr$l                     VL_SEGURO,
                DESPESA.TOTAL                         VL_DESPESA,          
                JUROS.TOTAL                           VL_DESPESA_FINANC,
                cisli941.t$ldam$l                     VL_DESCONTO,                        
                NULL                                  VL_DESC_INC,
                NULL                                  VL_DESC_COND,
                IMPOSTO_1.                            BASE_ICMS,
                IMPOSTO_1.                            PERC_ICMS,
                IMPOSTO_1.                            VL_ICMS,
                IMPOSTO_2.                            BASE_ICMS_ST,
                IMPOSTO_2.                            VL_ICMS_ST,
                IMPOSTO_2.                            VL_ICMS_ST_DESTAQUE,      
                IMPOSTO_3.                            VL_IPI_DESTAQUE,
                IMPOSTO_5.                            VL_PIS, 
                IMPOSTO_6.                            VL_COFINS,
                cisli941.t$amnt$l                     VL_TOTAL_ITEM,
                COD_SEFAZ.DESCR                       STATUS_SEFAZ,
                ' '                                   STATUS_SEFAZ_CANC,
                TO_NUMBER(CONCAT(IMPOSTO_1.ORIG_CST_ICMS, 
                       IMPOSTO_1.TRIBUT_CST_ICMS))     CST_ICMS,
                TO_NUMBER(CONCAT(IMPOSTO_5.ORIG_CST_PIS, 
                       IMPOSTO_5.TRIBUT_CST_PIS))      CST_PIS,
                TO_NUMBER(CONCAT(IMPOSTO_6.ORIG_CST_COFINS,      
                       IMPOSTO_6.TRIBUT_CST_COFINS))   CST_COFINS,                
                ' '                                    CONS_IE,
                ' '                                    MODELO
                
            FROM baandb.tcisli940301  cisli940  
    
       LEFT JOIN baandb.ttccom110301  tccom110 
              ON tccom110.T$ofbp = cisli940.t$bpid$l
       
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
                 
      INNER JOIN baandb.tcisli941301  cisli941
              ON cisli940.t$fire$l = cisli941.t$fire$l
              
       LEFT JOIN baandb.ttcmcs940301  tcmcs940
              ON tcmcs940.T$OFSO$L = cisli941.t$ccfo$l

      INNER JOIN baandb.ttcibd001301  tcibd001
              ON tcibd001.t$item = cisli941.t$item$l  
            
       LEFT JOIN baandb.ttcibd936301  tcibd936
              ON tcibd936.t$ifgc$l = tcibd001.t$ifgc$l
            
       LEFT JOIN baandb.ttcmcs060301  tcmcs060
              ON tcmcs060.t$cmnf = tcibd001.t$cmnf

       LEFT JOIN baandb.ttdipu001301  tdipu001
              ON tdipu001.t$item = tcibd001.t$item
              
      INNER JOIN baandb.ttccom100301  tccom100 
              ON tccom100.t$bpid = cisli940.t$bpid$l   

      INNER JOIN baandb.ttccom130301  tccom130
              ON tccom130.t$cadr   = cisli940.t$stoa$l
            
       LEFT JOIN baandb.ttccom966301  tccom966
              ON baandb.tccom966.t$comp$d = tccom130.t$fovn$l
             
      INNER JOIN baandb.ttcemm124301  tcemm124
              ON tcemm124.t$cwoc  = cisli940.t$cofc$l 

      INNER JOIN baandb.ttcemm030301  tcemm030
              ON tcemm030.t$eunt = tcemm124.t$grid
             
       LEFT JOIN ( SELECT d.t$cnst COD,
                          l.t$desc DESCR
                     FROM baandb.tttadv401000 d,
                          baandb.tttadv140000 l
                    WHERE d.t$cpac = 'br'
                      AND d.t$cdom = 'nfe.tsta.l'
                      AND l.t$clan = 'p'
                      AND l.t$cpac = 'br'
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
                                                  and l1.t$cpac = l.t$cpac ) ) COD_SEFAZ
              ON COD_SEFAZ.COD = cisli940.t$tsta$l
                
       LEFT JOIN ( select cisli943.t$fbtx$l    BASE_ICMS,
                          cisli943.t$amnt$l    VL_ICMS,
                          cisli943.t$rate$l    PERC_ICMS,
                          tcmcs938.t$gdog$l    ORIG_CST_ICMS,      
                          tcmcs938.t$icmd$l    TRIBUT_CST_ICMS,
                          cisli943.t$fire$l,
                          cisli943.t$line$l
                     from baandb.ttcmcs938301 tcmcs938
               inner join baandb.tcisli943301 cisli943
                       on tcmcs938.t$txsc$l = cisli943.t$txsc$l
                    where cisli943.t$brty$l = 1 ) IMPOSTO_1
              ON IMPOSTO_1.t$fire$l = cisli941.t$fire$l
             AND IMPOSTO_1.t$line$l = cisli941.t$line$l

       LEFT JOIN ( select cisli943.t$sbas$l BASE_ICMS_ST,
                          cisli943.t$amnt$l VL_ICMS_ST,
                          cisli943.t$fbam$l VL_ICMS_ST_DESTAQUE,
                          cisli943.t$fire$l,
                          cisli943.t$line$l
                     from baandb.tcisli943301 cisli943
                    where cisli943.t$brty$l = 2 ) IMPOSTO_2
              ON IMPOSTO_2.t$fire$l = cisli941.t$fire$l
             AND IMPOSTO_2.t$line$l = cisli941.t$line$l

       LEFT JOIN ( select cisli943.t$fbam$l VL_IPI_DESTAQUE,
                          cisli943.t$amnt$l VL_IPI,
                          cisli943.t$fire$l,
                          cisli943.t$line$l
                     from baandb.tcisli943301 cisli943
                    where cisli943.t$brty$l = 3) IMPOSTO_3
              ON IMPOSTO_3.t$fire$l = cisli941.t$fire$l
             AND IMPOSTO_3.t$line$l = cisli941.t$line$l

       LEFT JOIN ( select cisli943.t$amnt$l VL_PIS,
                          tcmcs938.t$gdog$l ORIG_CST_PIS,      
                          tcmcs938.t$icmd$l TRIBUT_CST_PIS,
                          cisli943.t$fire$l,
                          cisli943.t$line$l
                    from baandb.ttcmcs938301 tcmcs938
               inner join baandb.tcisli943301 cisli943
                       on tcmcs938.t$txsc$l = cisli943.t$txsc$l
                    where cisli943.t$brty$l = 5 ) IMPOSTO_5
               ON IMPOSTO_5.t$fire$l = cisli941.t$fire$l
              AND IMPOSTO_5.t$line$l = cisli941.t$line$l

       LEFT JOIN ( select cisli943.t$amnt$l VL_COFINS,
                          tcmcs938.t$gdog$l ORIG_CST_COFINS,      
                          tcmcs938.t$icmd$l TRIBUT_CST_COFINS,
                          cisli943.t$fire$l,
                          cisli943.t$line$l
                     from baandb.ttcmcs938301 tcmcs938
               inner join baandb.tcisli943301 cisli943
                       on tcmcs938.t$txsc$l = cisli943.t$txsc$l
                    where cisli943.t$brty$l = 6 ) IMPOSTO_6
              ON IMPOSTO_6.t$fire$l = cisli941.t$fire$l
             AND IMPOSTO_6.t$line$l = cisli941.t$line$l
 
       LEFT JOIN ( Select znsls000.t$indt$c,
                          znsls000.t$itmf$c IT_FRETE,
                          znsls000.t$itmd$c IT_DESP,
                          znsls000.t$itjl$c IT_JUROS
                     from baandb.tznsls000301   znsls000
                    where rownum = 1 )    PARAM
              ON PARAM.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
              
       LEFT JOIN ( SELECT cisli941.t$fire$l,
                          cisli941.t$item$l,
                          cisli941.t$amnt$l TOTAL
                     FROM baandb.tcisli941301   cisli941 ) DESPESA
              ON DESPESA.t$fire$l = cisli940.t$fire$l
             AND TRIM(DESPESA.t$item$l) = TRIM(PARAM.IT_DESP)
        
       LEFT JOIN ( SELECT cisli941.t$fire$l,
                          cisli941.t$item$l,
                          cisli941.t$amnt$l TOTAL
                     FROM baandb.tcisli941301   cisli941 ) JUROS
              ON JUROS.t$fire$l = cisli940.t$fire$l
             AND TRIM(JUROS.t$item$l) = TRIM(PARAM.IT_JUROS) 
              
        WHERE cisli940.t$stat$l = 6
          AND tcemm124.t$dtyp = 1 
          AND TRIM(cisli941.t$item$l) !=  TRIM(PARAM.IT_FRETE)
          AND TRIM(cisli941.t$item$l) !=  TRIM(PARAM.IT_DESP)
          AND TRIM(cisli941.t$item$l) !=  TRIM(PARAM.IT_JUROS) ) Q1

 WHERE Trunc(DATA_EMISSAO) BETWEEN (:DataEmissaoDe) AND (:DataEmissaoAte)
   AND Q1.FILIAL IN (:Filial)
