-- Entrada
select Q1.* 
  from  ( SELECT 301                                 CIA,
                 tcemm030.t$euca                     NUME_FILIAL,
                 tcemm030.T$EUNT                     CHAVE_FILIAL,
                 tdrec940.t$docn$l                   NUME_NF,
                 tdrec940.t$seri$l                   SERI_NF,   
                 tdrec940.t$cnfe$l                   ID_CHAVE,     
                 tdrec940.t$fire$l                   REFE_FISCAL,  
                 tdrec941.t$opfc$l                   NUME_CFOP,
                 tcmcs940.T$DSCA$L                   NOME_CFOP,
                 tccom120.t$cbtp                     COD_TIPO,
                 tdrec940.t$stpn$l                   INS_EsT,
                 CASE WHEN tdrec940.t$sfad$l = ' ' THEN
                      tccom130_ret.t$ccit
                 ELSE tccom130.t$ccit END            ID_MUNIC,
                 CASE tdrec940.t$sfad$l WHEN tdrec940.t$ifad$l THEN 'Fatura' 
                                        ELSE 'Entrega' 
                  END                                TIPO_ENDER, 
                 tdrec940.t$sfad$l                   SEQ_ENDER,
                 CASE WHEN tdrec940.t$sfad$l = ' ' THEN
                      tccom130_ret.t$dist$l
                 ELSE tccom130.t$dist$l END          END_BAIRRO,
                 CASE WHEN tdrec940.t$sfad$l = ' ' THEN
                      tccom130_ret.t$hono
                 ELSE tccom130.t$hono END            END_NUMERO,
                 CASE WHEN tdrec940.t$sfad$l = ' ' THEN
                      tccom130_ret.t$namd
                 ELSE tccom130.t$namd END           END_COMPL,
                 CASE WHEN tdrec940.t$sfad$l = ' ' THEN
                      tccom130_ret.t$cste
                 ELSE tccom130.t$cste END           UF,
                 tccom139.t$ibge$l                   COD_IBGE,
                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone sessiontimezone) AS DATE)  
                                                     DATA_RECEBIMENTO,
                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone sessiontimezone) AS DATE)  
                                                     DT_EMISSAO,
                 tdrec941.t$line$l                   LINE_ITEM,
                 tcibd001.t$citg                     ID_DEPTO,
                 tcmcs023.t$dsca                     DESCR_DEPTO,
                 Trim(tcibd001.t$item)               ID_ITEM,
                 tcibd001.t$dsca                     DESC_ITEM,
                 tcibd936.t$sour$l                   ID_PROC,
                 tcibd001.t$ceat$l                   COD_EAN,
                 znmcs030.t$seto$c                   COD_SETOR,
                 znmcs030.t$dsca$c                   DSC_SETOR,
                 tcibd001.t$fami$c                   CATEGORIA,
                 znmcs031.t$dsca$c                   DESCR_CATEGORIA,
                 tcibd001.t$subf$c                   SUBCATEGORIA,
                 znmcs032.t$dsca$c                   DESCR_SUBCATEGORIA,
                 tdipu001.t$manu$c                   MARCA,
                 tcibd936.t$frat$l                   NBM,
                 tdrec941.t$pric$l                   PRECO_UNITARIO,
                 tdrec941.t$qnty$l                   QTD_RECEBIDA,
                 tdrec941.t$insr$l                   VL_SEGURO,
                 tdrec941.t$gexp$l                   VL_DESPESA,
                 tdrec941.t$addc$l                   VL_DESCONTO,
                 tdrec941.t$fght$l                   VL_FRETE,
                 CASE WHEN IMPOSTO_1.PERC_ICMS = 0.00 THEN
                      0.00
                 ELSE IMPOSTO_1.BASE_ICMS END        BASE_ICMS,
                 IMPOSTO_1.                          PERC_ICMS,
                 IMPOSTO_1.                          VL_ICMS,
                 IMPOSTO_1.                          CST_ICMS,
                 IMPOSTO_1.                          ORIG_CST_ICMS,      
                 IMPOSTO_1.                          TRIBUT_CST_ICMS,
                 IMPOSTO_1.                          VL_ICMS_DEST, 
                 IMPOSTO_1.ORIG_CST_ICMS ||
                 IMPOSTO_1.TRIBUT_CST_ICMS           ORIGEM_TRIBUTARIO_CST_ICMS,
                 
                 IMPOSTO_2.                          BASE_ICMS_ST,
                 IMPOSTO_2.                          VL_ICMS_ST,
                 IMPOSTO_2.                          VL_ICMS_ST_DEST,      
                 CASE WHEN IMPOSTO_5.PERC_PIS=0.00 THEN
                      0.00
                 ELSE IMPOSTO_5.BASE_PIS END         BASE_PIS,
                 IMPOSTO_5.                          PERC_PIS,
                 IMPOSTO_5.                          VL_PIS,
                 IMPOSTO_5.                          CST_PIS,
                 IMPOSTO_5.                          ORIG_CST_PIS,      
                 IMPOSTO_5.                          TRIBUT_CST_PIS,
                 CASE WHEN PERC_COFINS=0.00 THEN
                      0.00
                 ELSE IMPOSTO_6.BASE_COFINS END      BASE_COFINS,
                 IMPOSTO_6.                          PERC_COFINS,
                 IMPOSTO_6.                          VL_COFINS,
                 IMPOSTO_6.                          CST_COFINS,
                 IMPOSTO_6.                          ORIG_CST_COFINS,      
                 IMPOSTO_6.                          TRIBUT_CST_COFINS,                      
                 
                 IMPOSTO_3.                          VL_IPI_DEST,
                 
                 IMPOSTO_ST_SCONV.                   BASE_ICMS_ST_SCONV,
                 IMPOSTO_ST_SCONV.                   PERC_ICMS_ST_SCONV,
                 IMPOSTO_ST_SCONV.                   VL_ICMS_ST_SCONV,
                   
                 tdrec941.t$tamt$l                   VALO_TOTAL,
                 tdrec940.t$fovn$l                   CNPJ_FORN,

                 CASE WHEN tdrec940.t$sfad$l = ' ' 
                        THEN Trim(REPLACE(tccom130_ret.t$namc, ';', ' '))
                      ELSE   Trim(REPLACE(tccom130.t$namc, ';', ' ')) 
                  END                                DESC_RUA,
                 tdrec941.t$gamt$l                   VL_MERC,
                 
                 IMPOSTO_3.                          VL_IPI,
                 
                 tdrec940.t$rfdt$l                   TIPO_DOCFIS,
                 iTIPO_DOCFIS.DESCR                  DESCR_TIPO_DOCFIS,
                 tdrec940.t$fids$l                   RAZAO_SOCIAL
          
            FROM baandb.ttdrec940301       tdrec940 
       
      LEFT JOIN baandb.ttccom120301       tccom120
              ON tccom120.T$otbp = tdrec940.t$bpid$l
              
      INNER JOIN baandb.ttdrec941301       tdrec941      
              ON tdrec940.t$fire$l = tdrec941.t$fire$l
                 
       LEFT JOIN baandb.ttcmcs940301       tcmcs940
              ON tcmcs940.T$OFSO$L = tdrec941.t$opfc$l
              
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

       LEFT JOIN baandb.ttccom130301       tccom130
              ON tccom130.t$cadr = tdrec940.t$sfad$l
      
       LEFT JOIN baandb.ttccom130301       tccom130_ret
              ON tccom130_ret.t$cadr = tdrec940.t$stoa$l
             
       LEFT JOIN baandb.ttccom139301       tccom139
              ON tccom139.t$ccty = tccom130.t$ccty
             AND tccom139.t$cste = tccom130.t$cste
             AND tccom139.t$city = tccom130.t$ccit
            
      INNER JOIN baandb.ttcemm124301       tcemm124
              ON tcemm124.t$cwoc = tdrec940.t$cofc$l 
 
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
--                          tdrec942.t$fbtx$l         BASE_ICMS,
                          tdrec942.t$base$l         BASE_ICMS,
                          tdrec942.t$rate$l         PERC_ICMS,
                          tdrec942.t$amnt$l         VL_ICMS,
                          tdrec942.t$txsc$l         CST_ICMS,
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

       LEFT JOIN ( SELECT --tdrec942.t$fbtx$l         BASE_PIS,
                          tdrec942.t$base$l         BASE_PIS,
                          tdrec942.t$rate$l         PERC_PIS, 
                          tdrec942.t$amnt$l         VL_PIS, 
                          tdrec942.t$txsc$l         CST_PIS,
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
  
       LEFT JOIN ( SELECT --tdrec942.t$fbtx$l         BASE_COFINS,
                          tdrec942.t$base$l         BASE_COFINS,
                          tdrec942.t$rate$l         PERC_COFINS,
                          tdrec942.t$amnt$l         VL_COFINS, 
                          tdrec942.t$txsc$l         CST_COFINS,
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
 
           WHERE tdrec940.t$stat$l IN (4, 5)
             AND tdrec940.t$rfdt$l != 13
        ORDER BY tdrec940.t$fire$l ) Q1

 WHERE Trunc(DT_EMISSAO) BETWEEN NVL(:DataEmissaoDe, DT_EMISSAO) AND NVL(:DataEmissaoAte, DT_EMISSAO)
   AND Trunc(DATA_RECEBIMENTO) BETWEEN NVL(:DataRecebimentoDe, DATA_RECEBIMENTO) AND NVL(:DataRecebimentoAte, DATA_RECEBIMENTO)
   AND Q1.CHAVE_FILIAL IN (:Filial)
   AND ( (Q1.ID_DEPTO IN (:Depto)) OR (:Depto = '000'))
   AND ( (Q1.COD_SETOR IN (:Setor)) OR (:Setor = '000'))
   AND ( (Q1.CATEGORIA IN (:Categoria)) OR (:Categoria = '000'))
   AND Q1.UF IN (:UF)
   AND Q1.NUME_CFOP IN (:CFOP)
   AND ( (Q1.NBM in (:NBM) and :TodosNBM = 1  ) or (:TodosNBM = 0) )
   AND ( (Q1.PERC_ICMS  = :Aliquota) OR (:Aliquota is null) )
