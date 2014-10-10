--Saída
select Q1.* 
  from  ( SELECT DISTINCT
                 301                        CIA,
                 tcemm030.t$euca            NUME_FILIAL,  
                 tcemm030.T$EUNT            CHAVE_FILIAL,
                 cisli940.t$docn$l          NUME_NF,
                 cisli940.t$seri$l          SERI_NF,   
                 cisli940.t$cnfe$l          ID_CHAVE,     
                 cisli940.t$fire$l          REFE_FISCAL,  
                 cisli941.t$ccfo$l          NUME_CFOP,
                 tcmcs940.t$dsca$l          CFOP_DESC,
                 tccom110.t$cbtp            COD_TIPO,
                 tccom966.t$stin$d          INSC_ESTADUAL,
                 tccom966.t$ctin$d          INSC_MUNICIPAL,
                 CASE  WHEN cisli940.t$itoa$l = cisli940.t$stoa$l THEN 'Fatura' 
                     ELSE 'Entrega' 
                 END                        TIPO_ENDER, 
                 cisli940.t$stoa$l          SEQ_ENDER,
                 tccom130.t$dist$l          END_BAIRRO,
                 tccom130.t$hono            END_NUMERO,
                 tccom130.t$namd            END_COMPL,
                 tccom130.t$cste            UF,
                 tccom139.t$ibge$l          COD_IBGE,
     
                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$dats$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone sessiontimezone) AS DATE)  
                                            DATA_FATURAMENTO,
           
                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone sessiontimezone) AS DATE)  
                                            DATA_EMISSAO,
                 cisli941.t$line$l          LINE_ITEM,
                 tcibd001.t$citg            ID_DEPTO,
                 tcmcs023.t$dsca            DESCR_DEPTO,
                 Trim(tcibd001.t$item)      ID_ITEM,
                 tcibd001.t$dsca            DESC_ITEM,
                 tcibd936.t$sour$l          ID_PROC,
                 tcibd001.t$ceat$l          COD_EAN,
                 znmcs030.t$seto$c          COD_SETOR,
                 znmcs030.t$dsca$c          DSC_SETOR,
                 tcibd001.t$fami$c          CATEGORIA,
                 znmcs031.t$dsca$c          DESCR_CATEGORIA,
                 znmcs032.t$dsca$c          DESCR_SUBCATEGORIA,
                 tcibd001.t$subf$c          SUBCATEGORIA,
                 tdipu001.t$manu$c          MARCA,
                 tcibd936.t$frat$l          NBM,
                 cisli941.t$pric$l          PRECO_UNITARIO,
                 cisli941.t$dqua$l          QTD_FATURADA,
                 cisli941.t$insr$l          VL_SEGURO,
                 cisli941.t$gexp$l          VL_DESPESA,
                 cisli941.t$ldam$l          VL_DESCONTO,
                 cisli941.t$fght$l          VL_FRETE,
     
                 IMPOSTO_1.                 BASE_ICMS,
                 IMPOSTO_1.                 VL_ICMS,
                 IMPOSTO_1.                 VL_ICMS_DEST,
                 IMPOSTO_1.                 PERC_ICMS,
                 IMPOSTO_1.                 CST_ICMS,
                 IMPOSTO_1.                 ORIG_CST_ICMS,      
                 IMPOSTO_1.                 TRIBUT_CST_ICMS,

                 IMPOSTO_2.                 BASE_ICMS_ST,
                 IMPOSTO_2.                 VL_ICMS_ST,
                 IMPOSTO_2.                 VL_ICMS_ST_DEST,      
             
                 IMPOSTO_5.                 BASE_PIS,
                 IMPOSTO_5.                 PERC_PIS,
                 IMPOSTO_5.                 VL_PIS,
                 IMPOSTO_5.                 CST_PIS,
                 IMPOSTO_5.                 ORIG_CST_PIS,
                 IMPOSTO_5.                 TRIBUT_CST_PIS,
                   
                 IMPOSTO_6.                 BASE_COFINS,
                 IMPOSTO_6.                 PERC_COFINS,
                 IMPOSTO_6.                 VL_COFINS,
                 IMPOSTO_6.                 CST_COFINS,
                 IMPOSTO_6.                 ORIG_CST_COFINS,      
                 IMPOSTO_6.                 TRIBUT_CST_COFINS,
                   
                 IMPOSTO_3.                 VL_IPI_DEST,
                 IMPOSTO_3.                 VL_IPI,
             
                 IMPOSTO_ICMS_ST_SCONV.     BASE_ICMS_ST_SCONV,
                 IMPOSTO_ICMS_ST_SCONV.     PERC_ICMS_ST_SCONV,
                          
                 cisli941.t$amnt$l          VL_TOTAL,
                 tccom130.t$fovn$l          CNPJ_CLIENTE,
                 tccom130.t$namc            DESC_RUA,
                 cisli941.t$gamt$l          VL_MERC,
                                            
                 cisli940.t$fdty$l          TIPO_DOCTO, 
                                            DESC_TIPO_DOCTO,
                 cisli940.t$fids$l          RAZAO_SOCIAL,
             
                 CASE WHEN cisli940.t$stat$l = 2 THEN 'CANCELADA'
                      ELSE 'ATIVA' 
                  END                       SITUACAO,
                                            
                 cisli940.t$nfes$l          COD_STATUS_SEFAZ,
                 COD_SEFAZ.DESCR            DESC_SEFAZ,
                 RECEITA.                   CODE_RECEITA
           
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
            
       LEFT JOIN baandb.ttdipu001301  tdipu001
              ON tdipu001.t$item = tcibd001.t$item
       
      INNER JOIN baandb.tznmcs030301  znmcs030
              ON znmcs030.t$citg$c = tcibd001.t$citg
             AND znmcs030.t$seto$c = tcibd001.t$seto$c
 
      INNER JOIN baandb.ttccom100301  tccom100 
              ON tccom100.t$bpid = cisli940.t$bpid$l   

      INNER JOIN baandb.ttccom130301  tccom130
              ON tccom130.t$cadr   = cisli940.t$stoa$l
            
       LEFT JOIN baandb.ttccom966301  tccom966
              ON baandb.tccom966.t$comp$d = tccom130.t$fovn$l
                 
       LEFT JOIN baandb.ttccom139301 tccom139
              ON tccom139.t$ccty = tccom130.t$ccty
             AND tccom139.t$cste = tccom130.t$cste
             AND tccom139.t$city = tccom130.t$ccit
             
      INNER JOIN baandb.ttcemm124301  tcemm124
              ON tcemm124.t$cwoc  = cisli940.t$cofc$l 

      INNER JOIN baandb.ttcemm030301  tcemm030
              ON tcemm030.t$eunt = tcemm124.t$grid
  
      INNER JOIN baandb.ttcmcs023301  tcmcs023
              ON tcmcs023.t$citg = tcibd001.t$citg
  
      INNER JOIN baandb.tznmcs031301  znmcs031
              ON znmcs031.t$citg$c = tcibd001.t$citg 
             AND znmcs031.t$seto$c = tcibd001.t$seto$c 
             AND znmcs031.t$fami$c = tcibd001.t$fami$c
 
      INNER JOIN baandb.tznmcs032301  znmcs032
              ON znmcs032.t$citg$c = tcibd001.t$citg 
             AND znmcs032.t$seto$c = tcibd001.t$seto$c 
             AND znmcs032.t$fami$c = tcibd001.t$fami$c
             AND znmcs032.t$subf$c = tcibd001.t$subf$c
             
       LEFT JOIN ( SELECT d.t$cnst COD,
                          l.t$desc DESCR
                     FROM baandb.tttadv401000 d,
                          baandb.tttadv140000 l
                    WHERE d.t$cpac = 'ci'
                      AND d.t$cdom = 'sli.nfes.l'
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
                                                  and l1.t$cpac = l.t$cpac ) ) COD_SEFAZ
              ON COD_SEFAZ.COD = cisli940.t$nfes$l
  
       LEFT JOIN ( select cisli943.t$fbtx$l    BASE_ICMS,
                          cisli943.t$amnt$l    VL_ICMS,
                          cisli943.t$fbam$l    VL_ICMS_DEST,
                          cisli943.t$rate$l    PERC_ICMS,
                          cisli943.t$txsc$l    CST_ICMS,
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
                          cisli943.t$fbam$l VL_ICMS_ST_DEST,
                          cisli943.t$fire$l,
                          cisli943.t$line$l
                     from baandb.tcisli943301 cisli943
                    where cisli943.t$brty$l = 2 ) IMPOSTO_2
              ON IMPOSTO_2.t$fire$l = cisli941.t$fire$l
             AND IMPOSTO_2.t$line$l = cisli941.t$line$l

       LEFT JOIN ( select cisli943.t$fbam$l VL_IPI_DEST,
                          cisli943.t$amnt$l VL_IPI,
                          cisli943.t$fire$l,
                          cisli943.t$line$l
                     from baandb.tcisli943301 cisli943
                    where cisli943.t$brty$l = 3) IMPOSTO_3
              ON IMPOSTO_3.t$fire$l = cisli941.t$fire$l
             AND IMPOSTO_3.t$line$l = cisli941.t$line$l

       LEFT JOIN ( select cisli943.t$fbtx$l BASE_PIS,
                          cisli943.t$rate$l PERC_PIS,
                          cisli943.t$amnt$l VL_PIS,
                          cisli943.t$txsc$l CST_PIS,
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

       LEFT JOIN ( select cisli943.t$fbtx$l BASE_COFINS,
                          cisli943.t$rate$l PERC_COFINS,
                          cisli943.t$amnt$l VL_COFINS,
                          cisli943.t$txsc$l CST_COFINS,
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
  
       LEFT JOIN ( select cisli943.t$sbas$l BASE_ICMS_ST_SCONV,
                          cisli943.t$rate$l PERC_ICMS_ST_SCONV,
                          cisli943.t$fire$l,
                          cisli943.t$line$l
                     from baandb.tcisli943301 cisli943 
               inner join baandb.ttdrec949301 tdrec949
                       on tdrec949.t$fire$l = cisli943.t$fire$l 
                    where tdrec949.t$isco$c = 1
                      and tdrec949.t$brty$l = 2
                      and cisli943.t$brty$l = 2 ) IMPOSTO_ICMS_ST_SCONV
              ON IMPOSTO_ICMS_ST_SCONV.t$fire$l = cisli941.t$fire$l
             AND IMPOSTO_ICMS_ST_SCONV.t$line$l = cisli941.t$line$l

       LEFT JOIN ( select cisli943.t$cnre$l CODE_RECEITA,
                          cisli943.t$fire$l,
                          cisli943.t$line$l
                     from baandb.tcisli943301 cisli943
                    where cisli943.t$cnre$l != ' ' ) RECEITA
              ON RECEITA.t$fire$l = cisli941.t$fire$l
             AND RECEITA.t$line$l = cisli941.t$line$l
	
           WHERE cisli940.t$stat$l = 6
             AND tcemm124.t$dtyp = 1 
			 
        ORDER BY cisli940.t$fire$l ) Q1
			
where Q1.CHAVE_FILIAL IN (:Filial)
  and ( (Q1.ID_DEPTO IN (:Depto)) OR (:Depto = '000'))
  and ( (Q1.COD_SETOR IN (:Setor)) OR (:Setor = '000'))
  and ( (Q1.CATEGORIA IN (:Categoria)) OR (:Categoria = '000'))
  and Q1.UF IN (:UF)
  and Q1.NUME_CFOP IN (:CFOP)
  and ( (Q1.NBM in (:NBM) and :TodosNBM = 1  ) or (:TodosNBM = 0) )
  and ( (Q1.PERC_ICMS  = :Aliquota) OR (:Aliquota is null) )
