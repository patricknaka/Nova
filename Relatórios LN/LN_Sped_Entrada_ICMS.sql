-- Entrada
select Q1.* 
  from  ( SELECT 301                                CIA,
                tcemm030.T$EUNT                     FILIAL,
                tdrec940.t$docn$l                   NF_FORN,
                tdrec940.t$seri$l                   SERIE,   
                tdrec940.t$cnfe$l                   ID_CHAVE,
                ' '                                 ID_CHAVE_CL,
                ' '                                 ID_CHAVE_NV,
                tdrec940.t$fire$l                   NR,
                tdrec940.t$fovn$l                   CNPJ_FORN,
                tdrec940.t$bpid$l                   COD_PART,
                tccom110.t$cbtp                     COD_TIPO,
                tdrec940.t$stpn$l                   INS_EST,
                tccom100.t$nama                     NOME_FORN,
                tccom130.t$ccit                     ID_MUNIC,
                CASE tdrec940.t$sfad$l WHEN tdrec940.t$ifad$l 
                                         THEN 'Fatura' 
                                       ELSE   'Entrega' 
                 END                                TIPO_ENDER, 
                tdrec940.t$sfad$l                   SEQ_ENDER,
                tccom130.t$namc                     END_RUA,
                tccom130.t$dist$l                   END_BAIRRO,
                tccom130.t$hono                     END_NUMERO,
                tccom130.t$namd                     END_COMPL,
                tccom130.t$cste                     UF,
                CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone sessiontimezone) AS DATE)  
                                                    DATA_RECEBIMENTO,
                CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone sessiontimezone) AS DATE)  
                                                    DT_EMISSAO,
                
                tdrec941.t$opfc$l                    CFO,
                ' '                                  SEQ_CFO,
                tcmcs940.T$DSCA$L                    NOME_CFO,
                ' '                                  MODULO,
                tdrec941.t$line$l                    NUM_ITEM,
                tcibd001.t$citg                      ID_DEPTO,
                Trim(tcibd001.t$item)                ID_ITEM,
                tcibd936.t$sour$l                    ID_PROC,
                tcibd001.t$ceat$l                    COD_EAN,
                ' '                                  DESCRICAO,
                tcibd001.t$fami$c                    CATEGORIA,
                tcibd001.t$subf$c                    SUBCATEGORIA,
                tdipu001.t$manu$c                    MARCA,
                tcibd936.t$frat$l                    NBM,
                ' '                                  SEQ_NBM,
                tdrec941.t$pric$l                    PRECO_UNITARIO,
                tdrec941.t$qnty$l                    QTD_RECEBIDA,
                tdrec941.t$gamt$l                    VL_MERC,
                tdrec941.t$insr$l                    VL_SEGURO,
                tdrec941.t$gexp$l                    VL_DESPESA,
                tdrec941.t$addc$l                    VL_DESCONTO,
                0.00                                 VL_DESC_COND,
                0.00                                 VL_DESC_INC,
                tdrec941.t$fght$l                    VL_FRETE,
                IMPOSTO_1.                           BASE_ICMS,
                IMPOSTO_1.                           PERC_ICMS,
                IMPOSTO_1.                           VL_ICMS,
                IMPOSTO_1.                           VL_ICMS_DEST, 
                IMPOSTO_2.                           BASE_ICMS_ST,
                IMPOSTO_2.                           VL_ICMS_ST,
                IMPOSTO_2.                           VL_ICMS_ST_DEST,      
                IMPOSTO_5.                           VL_PIS,
                IMPOSTO_6.                           VL_COFINS,
                IMPOSTO_3.                           VL_IPI,
                IMPOSTO_3.                           VL_IPI_DEST,
                IMPOSTO_ST_SCONV.                    BASE_ICMS_ST_SCONV,
                IMPOSTO_ST_SCONV.                    PERC_ICMS_ST_SCONV,
                IMPOSTO_ST_SCONV.                    VL_ICMS_ST_SCONV, 
                tdrec941.t$tamt$l                    VALO_TOTAL,
                ' '                                  CONS_IE,
                CONCAT(IMPOSTO_5.ORIG_CST_PIS, 
                       IMPOSTO_5.TRIBUT_CST_PIS)     NODE_CST_PIS,
                CONCAT(IMPOSTO_6.ORIG_CST_COFINS, 
                       IMPOSTO_6.TRIBUT_CST_COFINS)  NODE_CST_COFINS
        
            FROM baandb.ttdrec940301       tdrec940 
       
       LEFT JOIN baandb.ttccom110301       tccom110
              ON tccom110.T$ofbp = tdrec940.t$bpid$l
              
      INNER JOIN baandb.ttdrec941301       tdrec941
              ON tdrec940.t$fire$l = tdrec941.t$fire$l
                 
       LEFT JOIN baandb.ttcmcs940301       tcmcs940
              ON tcmcs940.T$OFSO$L = tdrec941.t$opfc$l
              
       LEFT JOIN baandb.ttdrec947301       tdrec947
              ON tdrec941.t$fire$l = tdrec947.t$fire$l 
             AND tdrec941.t$line$l = tdrec947.T$LINE$L
            
      INNER JOIN baandb.ttcibd001301       tcibd001
              ON tcibd001.t$item = tdrec941.t$item$l
                  
       LEFT JOIN baandb.ttcibd936301       tcibd936
              ON tcibd936.t$ifgc$l = tcibd001.t$ifgc$l
             
       LEFT JOIN baandb.ttdipu001301       tdipu001
              ON tdipu001.t$item = tcibd001.t$item
      
      INNER JOIN baandb.tznmcs030301       znmcs030
              ON znmcs030.t$citg$c = tcibd001.t$citg
             AND znmcs030.t$seto$c = tcibd001.t$seto$c
 
      INNER JOIN baandb.ttccom100301       tccom100
              ON tccom100.t$bpid = tdrec940.t$bpid$l
  
      INNER JOIN baandb.ttccom130301       tccom130
              ON tccom130.t$cadr = tdrec940.t$sfad$l
                  
       LEFT JOIN baandb.ttccom139301       tccom139
              ON tccom139.t$ccty = tccom130.t$ccty
             AND tccom139.t$cste = tccom130.t$cste
             AND tccom139.t$city = tccom130.t$ccit
            
      INNER JOIN baandb.ttcemm124301       tcemm124
              ON tcemm124.t$cwoc = tdrec940.t$cofc$l 
             AND tcemm124.t$dtyp = 2
 
      INNER JOIN baandb.ttcemm030301       tcemm030
              ON tcemm030.t$eunt = tcemm124.t$grid
            
       LEFT JOIN ( SELECT d.t$cnst CODE,
                          l.t$desc DESCR
                     FROM baandb.tttadv401000 d,
                          baandb.tttadv140000 l
                    WHERE d.t$cpac = 'td'                          
                      AND d.t$cdom = 'rec.trfd.l'                      
                      AND l.t$clan = 'p'
                      AND l.t$cpac = 'td'                
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
                                                  and l1.t$cpac = l.t$cpac ) ) iTIPO_DOCFIS
              ON iTIPO_DOCFIS.CODE = tdrec940.t$rfdt$l
      
      INNER JOIN baandb.ttcmcs023301 tcmcs023
              ON tcmcs023.t$citg = tcibd001.t$citg
  
      INNER JOIN baandb.tznmcs031301 znmcs031
              ON znmcs031.t$citg$c = tcibd001.t$citg
             AND znmcs031.t$seto$c = tcibd001.t$seto$c
             AND znmcs031.t$fami$c = tcibd001.t$fami$c
  
      INNER JOIN baandb.tznmcs032301 znmcs032
              ON znmcs032.t$citg$c = tcibd001.t$citg
             AND znmcs032.t$seto$c = tcibd001.t$seto$c
             AND znmcs032.t$fami$c = tcibd001.t$fami$c
             AND znmcs032.t$subf$c = tcibd001.t$subf$c
 
       LEFT JOIN ( SELECT tdrec942.t$fire$l,
                          tdrec942.t$line$l,
                          tdrec942.t$fbtx$l         BASE_ICMS,
                          tdrec942.t$rate$l         PERC_ICMS,
                          tdrec942.t$amnt$l         VL_ICMS,
                          tcmcs938.t$gdog$l         ORIG_CST_ICMS,      
                          tcmcs938.t$icmd$l         TRIBUT_CST_ICMS,
                          tdrec942.t$fbam$l         VL_ICMS_DEST
                     FROM baandb.ttcmcs938301 tcmcs938
               INNER JOIN baandb.ttdrec942301 tdrec942
                       ON tcmcs938.t$txsc$l = tdrec942.t$txsc$l
                    WHERE tdrec942.t$brty$l = 1 ) IMPOSTO_1
              ON IMPOSTO_1.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_1.t$line$l = tdrec941.t$line$l
 
       LEFT JOIN ( SELECT tdrec942.t$sbas$l         BASE_ICMS_ST,
                          tdrec942.t$amnt$l         VL_ICMS_ST,
                          tdrec942.t$fbam$l         VL_ICMS_ST_DEST,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 2) IMPOSTO_2
              ON IMPOSTO_2.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_2.t$line$l = tdrec941.t$line$l
 
       LEFT JOIN ( SELECT tdrec942.t$fbam$l         VL_IPI_DEST,
                          tdrec942.t$amnt$l         VL_IPI,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 3 ) IMPOSTO_3
              ON IMPOSTO_3.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_3.t$line$l = tdrec941.t$line$l

       LEFT JOIN ( SELECT tdrec942.t$amnt$l         VL_PIS,
                          tcmcs938.t$gdog$l         ORIG_CST_PIS,      
                          tcmcs938.t$icmd$l         TRIBUT_CST_PIS,                          
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttcmcs938301 tcmcs938
               INNER JOIN baandb.ttdrec942301 tdrec942
                       ON tcmcs938.t$txsc$l = tdrec942.t$txsc$l
                    WHERE tdrec942.t$brty$l = 5 ) IMPOSTO_5
              ON IMPOSTO_5.t$fire$l=tdrec941.t$fire$l
             AND IMPOSTO_5.t$line$l=tdrec941.t$line$l
  
       LEFT JOIN ( SELECT tdrec942.t$rate$l         PERC_COFINS,
                          tdrec942.t$amnt$l         VL_COFINS,
                          tcmcs938.t$gdog$l         ORIG_CST_COFINS,      
                          tcmcs938.t$icmd$l         TRIBUT_CST_COFINS,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttcmcs938301 tcmcs938
               INNER JOIN baandb.ttdrec942301 tdrec942
                       ON tcmcs938.t$txsc$l = tdrec942.t$txsc$l
                    WHERE tdrec942.t$brty$l = 6 ) IMPOSTO_6
              ON IMPOSTO_6.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_6.t$line$l = tdrec941.t$line$l

       LEFT JOIN ( SELECT tdrec942.t$sbas$l         BASE_ICMS_ST_SCONV,
                          tdrec942.t$rate$l         PERC_ICMS_ST_SCONV,
                          tdrec942.t$amnt$l         VL_ICMS_ST_SCONV,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
               INNER JOIN baandb.ttdrec949301 tdrec949
                       ON tdrec942.t$fire$l = tdrec949.t$fire$l
                    WHERE tdrec942.t$brty$l = 2
                      AND tdrec949.t$brty$l = 2
                      AND tdrec949.t$isco$c = 1 ) IMPOSTO_ST_SCONV
              ON IMPOSTO_ST_SCONV.t$fire$l = tdrec941.t$fire$l 
             AND IMPOSTO_ST_SCONV.t$line$l = tdrec941.t$line$l
 
           WHERE tdrec940.t$stat$l IN (4)
           
        ORDER BY tdrec940.t$fire$l ) Q1

 WHERE Trunc(DT_EMISSAO) BETWEEN (:DataEmissaoDe) AND (:DataEmissaoAte)
   AND Q1.FILIAL IN (:Filial)