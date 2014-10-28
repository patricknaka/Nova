  select Q1.* 
  from  ( SELECT 301                                  CIA,                     -- 1
                 tcemm030.T$EUNT                      FILIAL,                  -- 2
                 tcemm030.t$dsca                      DESC_FILIAL,             -- 3
                 tdrec940.t$docn$l                    NUME_NF,                 -- 4
                 tdrec940.t$seri$l                    SERI_NF,                 -- 5
                 tdrec940.t$fire$l                    NR,                      -- 6
                 regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') 
                                                      CNPJ_FORN,               -- 7
                 tdrec940.t$bpid$l                    COD_PART,                -- 8
                 tdrec940.t$ftyp$l                    COD_TIPO,                -- 9
                 tdrec940.t$stpn$l                    INS_EST,                 -- 10
                 tccom100.t$nama                      NOME_FORN,               -- 11
                 tccom139.t$ibge$l                    COD_IBGE,                -- 12
                 tccom130.t$ccit                      ID_MUNIC,                -- 13
                 CASE tdrec940.t$sfad$l WHEN tdrec940.t$ifad$l
                                          THEN 'Fatura' 
                                        ELSE   'Entrega' 
                  END                                 TIPO_ENDER,              -- 14
                 tdrec940.t$sfad$l                    SEQ_ENDER,               -- 15
                 tccom130.t$namc                      END_RUA,                 -- 16
                 tccom130.t$dist$l                    END_BAIRRO,              -- 17
                 tccom130.t$hono                      END_NUMERO,              -- 18
                 tccom130.t$namd                      END_COMPL,               -- 19
                 tccom130.t$cste                      UF,                      -- 20
                 
                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone sessiontimezone) AS DATE)  
                                                      DATA_REFFISCAL,          -- 21
                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone sessiontimezone) AS DATE)  
                                                      DT_EMISSAO,              -- 22
                 tdrec940.t$opfc$l                    CFO,                     -- 23
                 tdrec941.t$line$l                    LINE_ITEM,               -- 24
                 tcibd001.t$citg                      ID_DEPTO,                -- 25
                 tcmcs023.t$dsca                      DESCR_DEPTO,             -- 26
                 Trim(tcibd001.t$item)                ID_ITEM,                 -- 27
                 tcibd001.t$dsca                      DESC_ITEM,               -- 28
                 brmcs958.t$scod$l                    COD_SERV,                -- 29
                 tcibd936.t$sour$l                    ID_PROC,                 -- 30
                 tcibd001.t$ceat$l                    COD_EAN,                 -- 31
                 znmcs030.t$seto$c                    SETOR_ITEM,              -- 32
                 znmcs030.t$dsca$c                    DESCR_SETOR,             -- 33
                 tcibd001.t$fami$c                    FAMILIA_ITEM,            -- 34
                 znmcs031.t$dsca$c                    DESCR_FAMILIA,           -- 35
                 tcibd001.t$subf$c                    SUB_FAMILIA,             -- 36
                 znmcs032.t$dsca$c                    DESCR_SUB_FAMILIA,       -- 37
                 tdrec941.t$tamt$l                    VL_TOTAL,                -- 38
                 nvl(tdrec941.t$addc$l, 0)            VL_DESCONTO,             -- 49
                 nvl(IMPOSTO_11.VL_PIS_RETIDO, 0)     VL_PIS_RETIDO,           -- 40
                 nvl(IMPOSTO_12.VL_COFINS_RETIDO, 0)  VL_COFINS_RETIDO,        -- 41
                 tfacp200.t$leac                      COD_CTA,                 -- 42
                 tfacp200.t$dim1                      COD_CCUSTO,              -- 43
                 CASE WHEN tfacp200.t$dim1 = ' ' 
                        THEN ' '
                      ELSE   tfgld010.t$desc 
                  END                                 NOME_CCUSTO,             -- 44
                 0.00                                 VL_REDUTOR_BASE,         -- 45
                                                                                   
                  CASE WHEN tfacp200.t$balh$1 = 0 
                         THEN ( select max(p.t$docd) 
                                  from baandb.ttfacp200301 p 
                                 where p.t$ttyp = tfacp200.t$ttyp
                                   and p.t$ninv = tfacp200.t$ninv )
                       ELSE NULL
                   END                                DT_LIQUIDACAO_TITULO,    -- 46
       
                 CONCAT(tdrec940.t$ttyp$l,
                        tdrec940.t$invn$l)            TITULO,                  -- 47
                 nvl(IMPOSTO_7.VL_ISS, 0)             VL_ISS,                  -- 48
                 nvl(IMPOSTO_14.VL_ISS_RETIDO, 0)     VL_ISS_RETIDO,           -- 49
                 nvl(IMPOSTO_9.VL_IRRF_PJ, 0)         VL_IRRF_PJ,              -- 50
                 nvl(IMPOSTO_10.VL_IRRF_PF, 0)        VL_IRRF_PF,              -- 51
                 nvl(IMPOSTO_8.VL_INSS, 0)            VL_INSS,                 -- 52
                 nvl(IMPOSTO_15.VL_INSS_RET_PJ, 0)    VL_INSS_RET_PJ,          -- 53
                 nvl(IMPOSTO_17.VL_INSS_RET_PF, 0)    VL_INSS_RET_PF,          -- 54
                 nvl(IMPOSTO_5.VL_PIS, 0)             VL_PIS,                  -- 55
                 nvl(IMPOSTO_6.VL_COFINS, 0)          VL_COFINS,               -- 56
                 nvl(IMPOSTO_13.VL_CSLL_RETIDO, 0)    VL_CSLL_RETIDO           -- 57

            FROM baandb.ttdrec940301       tdrec940 
       
       LEFT JOIN baandb.ttccom110301       tccom110
              ON tccom110.T$ofbp = tdrec940.t$bpid$l
              
      INNER JOIN baandb.ttdrec941301       tdrec941
              ON tdrec940.t$fire$l = tdrec941.t$fire$l
                 
       LEFT JOIN baandb.tbrmcs958301   brmcs958
              ON brmcs958.t$tror$l = 1
             AND brmcs958.t$item$l = tdrec941.t$item$l
            
       LEFT JOIN baandb.ttcmcs940301       tcmcs940
              ON tcmcs940.T$OFSO$L = tdrec941.t$opfc$l
              
       LEFT JOIN baandb.ttdrec947301       tdrec947
              ON tdrec941.t$fire$l = tdrec947.t$fire$l 
             AND tdrec941.t$line$l = tdrec947.T$LINE$L
            
      INNER JOIN baandb.ttcibd001301       tcibd001
              ON tcibd001.t$item = tdrec941.t$item$l
         
      INNER JOIN baandb.ttcibd001301       tcibd001
              ON tcibd001.t$item = tdrec941.t$item$l

      INNER JOIN baandb.ttcmcs023301  tcmcs023
              ON tcmcs023.t$citg = tcibd001.t$citg
            
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

       LEFT JOIN baandb.ttfacp200301 tfacp200
              ON tfacp200.t$ttyp = tdrec940.t$ttyp$l
             AND tfacp200.t$ninv = tdrec940.t$invn$l
             AND tfacp200.t$leac !=  ' '
  
       LEFT JOIN baandb.ttfgld010301 tfgld010
              ON tfgld010.t$dimx = tfacp200.t$dim1
            
       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_PIS,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 5 ) IMPOSTO_5
              ON IMPOSTO_5.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_5.t$line$l = tdrec941.t$line$l
  
       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_COFINS,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 6 ) IMPOSTO_6
              ON IMPOSTO_6.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_6.t$line$l = tdrec941.t$line$l
 
       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_ISS,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 7 ) IMPOSTO_7
              ON IMPOSTO_7.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_7.t$line$l = tdrec941.t$line$l
             
       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_INSS,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 8 ) IMPOSTO_8
              ON IMPOSTO_8.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_8.t$line$l = tdrec941.t$line$l
           
       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_IRRF_PJ,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 9 ) IMPOSTO_9
              ON IMPOSTO_9.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_9.t$line$l = tdrec941.t$line$l

       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_IRRF_PF,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 10 ) IMPOSTO_10
              ON IMPOSTO_10.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_10.t$line$l = tdrec941.t$line$l
   
       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_PIS_RETIDO,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 11 ) IMPOSTO_11
              ON IMPOSTO_11.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_11.t$line$l = tdrec941.t$line$l

       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_COFINS_RETIDO,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 12 ) IMPOSTO_12
              ON IMPOSTO_12.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_12.t$line$l = tdrec941.t$line$l

       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_CSLL_RETIDO,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 13 ) IMPOSTO_13
              ON IMPOSTO_13.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_13.t$line$l = tdrec941.t$line$l

       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_ISS_RETIDO,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 14 ) IMPOSTO_14
              ON IMPOSTO_14.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_14.t$line$l = tdrec941.t$line$l

       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_INSS_RET_PJ,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 15 ) IMPOSTO_15
              ON IMPOSTO_15.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_15.t$line$l = tdrec941.t$line$l
             
       LEFT JOIN ( SELECT tdrec942.t$amnt$l   VL_INSS_RET_PF,
                          tdrec942.t$fire$l,
                          tdrec942.t$line$l
                     FROM baandb.ttdrec942301 tdrec942
                    WHERE tdrec942.t$brty$l = 17 ) IMPOSTO_17
              ON IMPOSTO_17.t$fire$l = tdrec941.t$fire$l
             AND IMPOSTO_17.t$line$l = tdrec941.t$line$l
             
WHERE tdrec940.t$stat$l IN (4,5,6)
  AND tdrec940.t$rfdt$l IN (3)
  AND tfgld010.t$dtyp = 1
ORDER BY 2,6,21,28,24 ) Q1

 WHERE Q1.FILIAL IN (:Filial)
   AND Trunc(Q1.DATA_REFFISCAL)
       Between :DataFiscalDe
           And :DataFiscalAte
