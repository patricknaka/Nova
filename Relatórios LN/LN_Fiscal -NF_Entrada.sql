-- Entrada
select Q1.* 
  from  ( SELECT
            301                                 CIA,
            tcemm030.t$euca                     NUME_FILIAL,
            tcemm030.T$EUNT                     CHAVE_FILIAL,
            tdrec940.t$docn$l                   NUME_NF,
            tdrec940.t$seri$l                   SERI_NF,   
            tdrec940.t$cnfe$l                   ID_CHAVE,     
            tdrec940.t$fire$l                   REFE_FISCAL,  
            tdrec941.t$opfc$l                   NUME_CFOP,
            tcmcs940.T$DSCA$L                   NOME_CFOP,
            tccom110.t$cbtp                     COD_TIPO,
            tdrec940.t$stpn$l                   INS_EsT,
            tccom130.t$ccit                     ID_MUNIC,
            CASE tdrec940.t$sfad$l WHEN tdrec940.t$ifad$l THEN 'Fatura' 
                                   ELSE 'Entrega' 
             END                                TIPO_ENDER, 
            tdrec940.t$sfad$l                   SEQ_ENDER,
            tccom130.t$dist$l                   END_BAIRRO,
            tccom130.t$hono                     END_NUMERO,
            tccom130.t$namd                     END_COMPL,
            tccom130.t$cste                     UF,
            tdrec940.t$adat$l                   DATA_RECEBIMENTO,
            tdrec940.t$idat$l                   DT_EMISSAO,
            tdrec941.t$line$l                   LINE_ITEM,
            tcibd001.t$citg                     ID_DEPTO,
            tcmcs023.t$dsca                     DESCR_DEPTO,
            tcibd001.t$item                     ID_ITEM,
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
            (SELECT tdrec942.t$fbtx$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=1)        BASE_ICMS,
          
            (SELECT tdrec942.t$amnt$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=1)        VL_ICMS,
          
            (SELECT tdrec942.t$fbam$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=1)        VL_ICMS_DEST,
          
            (SELECT tdrec942.t$sbas$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=2)        BASE_ICMS_ST,
          
            (SELECT tdrec942.t$amnt$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=2)        VL_ICMS_ST,
          
            (SELECT tdrec942.t$fbam$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=2)        VL_ICMS_ST_DEST,        
          
            (SELECT tdrec942.t$amnt$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=5)        VL_PIS,
          
            (SELECT tdrec942.t$amnt$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=6)        VL_COFINS,
          
            (SELECT tdrec942.t$fbam$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=2)        VL_IPI_DEST,
            
            (SELECT tdrec942.t$sbas$l 
               FROM baandb.ttdrec942301 tdrec942, 
                    baandb.ttdrec949301 tdrec949
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l 
                AND tdrec949.t$fire$l=tdrec941.t$fire$l
                AND tdrec949.t$brty$l=2
                AND tdrec949.t$isco$c=1
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=2)        BASE_ICMS_ST_SCONV,
          
            (SELECT tdrec942.t$rate$l 
               FROM baandb.ttdrec942301 tdrec942, 
                    baandb.ttdrec949301 tdrec949
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l 
                AND tdrec949.t$fire$l=tdrec941.t$fire$l
                AND tdrec949.t$brty$l=2
                AND tdrec949.t$isco$c=1
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=2)        PERC_ICMS_ST_SCONV,
              
            tdrec941.t$tamt$l                   VALO_TOTAL,
            tdrec940.t$fovn$l                   CNPJ_FORN,
            tccom130.t$namc                     DESC_RUA,
            tdrec941.t$gamt$l                   VL_MERC,
          
            (SELECT tdrec942.t$rate$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=1)        PERC_ICMS,
          
            (SELECT tdrec942.t$amnt$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=3)        VL_IPI,
          
            tdrec940.t$rfdt$l                   TIPO_DOCFIS,
            iTIPO_DOCFIS.DESCR                  DESCR_TIPO_DOCFIS,
            tdrec940.t$fids$l                   RAZAO_SOCIAL,
          
            (SELECT tdrec942.t$txsc$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=5)        CST_PIS,
          
            (SELECT tdrec942.t$txsc$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=6)        CST_COFINS,
          
            (SELECT tdrec942.t$txsc$l 
               FROM baandb.ttdrec942301 tdrec942
              WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
                AND tdrec942.t$line$l=tdrec941.t$line$l
                AND tdrec942.t$brty$l=1)        CST_ICMS
          
          FROM baandb.ttdrec940301              tdrec940 
           
          LEFT JOIN   baandb.ttccom110301       tccom110
                 ON   tccom110.T$ofbp = tdrec940.t$bpid$l,
                 
                      baandb.ttdrec941301       tdrec941
                      
          LEFT JOIN   baandb.ttcmcs940301       tcmcs940
                 ON   tcmcs940.T$OFSO$L= tdrec941.t$opfc$l
                 
          LEFT JOIN   baandb.ttdrec947301       tdrec947
                 ON   tdrec941.t$fire$l = tdrec947.t$fire$l 
                AND   tdrec941.t$line$l = tdrec947.T$LINE$L,
                
                      baandb.ttcibd001301       tcibd001
                      
          LEFT JOIN   baandb.ttcibd936301       tcibd936
                 ON   tcibd936.t$ifgc$l = tcibd001.t$ifgc$l
          
          LEFT JOIN   baandb.ttdipu001301       tdipu001
                 ON   tdipu001.t$item = tcibd001.t$item,
          
                      baandb.tznmcs030301       znmcs030,            
                      baandb.ttccom100301       tccom100,      
                      baandb.ttccom130301       tccom130,
                      baandb.ttcemm124301       tcemm124,
                      baandb.ttcemm030301       tcemm030,
                      
          ( SELECT d.t$cnst CODE,
                   l.t$desc DESCR
              FROM baandb.tttadv401000 d,
                   baandb.tttadv140000 l
             WHERE d.t$cpac='td'                          
               AND d.t$cdom='rec.trfd.l'                      
               AND l.t$clan='p'
               AND l.t$cpac='td'                
               AND l.t$clab=d.t$za_clab
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
                                           and l1.t$cpac = l.t$cpac ) ) iTIPO_DOCFIS,
          
                      baandb.ttcmcs023301 tcmcs023,
                      baandb.tznmcs031301 znmcs031,
                      baandb.tznmcs032301 znmcs032
          
          WHERE tdrec940.t$fire$l = tdrec941.t$fire$l
            AND tcibd001.t$item = tdrec941.t$item$l
            AND znmcs030.t$citg$c = tcibd001.t$citg
            AND znmcs030.t$seto$c = tcibd001.t$seto$c
            AND tccom100.t$bpid = tdrec940.t$bpid$l 
            AND tccom130.t$cadr = tdrec940.t$sfra$l
            AND tcemm124.t$cwoc = tdrec940.t$cofc$l 
            AND tcemm124.t$dtyp = 2 
            AND tcemm030.t$eunt = tcemm124.t$grid
            AND iTIPO_DOCFIS.CODE = tdrec940.t$rfdt$l
            AND tcmcs023.t$citg = tcibd001.t$citg
            AND znmcs031.t$citg$c = tcibd001.t$citg
            AND znmcs031.t$seto$c = tcibd001.t$seto$c
            AND znmcs031.t$fami$c = tcibd001.t$fami$c
            AND znmcs032.t$citg$c = tcibd001.t$citg
            AND znmcs032.t$seto$c = tcibd001.t$seto$c
            AND znmcs032.t$fami$c = tcibd001.t$fami$c
            AND znmcs032.t$subf$c = tcibd001.t$subf$c
            AND tdrec940.t$stat$l IN (4,5,6) ) Q1

 WHERE Q1.CHAVE_FILIAL IN (:Filial)
   AND ( (Q1.ID_DEPTO IN (:Depto)) OR (:Depto = '000'))
   AND ( (Q1.COD_SETOR IN (:Setor)) OR (:Setor = '000'))
   AND ( (Q1.CATEGORIA IN (:Categoria)) OR (:Categoria = '000'))
   AND Q1.UF IN (:UF)
   AND Q1.NUME_CFOP IN (:CFOP)
   AND ( (Q1.NBM in (:NBM) and :TodosNBM = 1  ) or (:TodosNBM = 0) )
   AND ( (Q1.PERC_ICMS  = :Aliquota) OR (:Aliquota is null) )