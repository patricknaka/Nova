SELECT  
  tdpur400.t$odat          DATA_ORDEM,
  tcemm030.t$euca          NUME_FILIAL,
  tdpur400.t$orno          CODE_ORDEM,
  tdpur400.t$ddat          DATA_PLREC,  
  tccom130.t$fovn$l        CNPJ_FORN,
  tccom100.t$nama          DESC_FORN,  
  tcibd001.t$citg          GRUP_ITEM,    
  tcmcs023.t$dsca          DESC_GRUPO,
  tcibd001.t$item          CODE_ITEM,    
  tcibd001.t$dsca          DESC_ITEM, 
  whwmd400.t$abcc          CODE_ABC,
  tdpur401.t$qoor *
  tdpur401.t$pric          VALO_OR, 
  tdpur400.t$cotp          TIPO_OC,
  tdrec940.t$stat$l        STAT_RECFIS,  
  tdrec940.t$docn$l || 
  tdrec940.t$seri$l        NUME_NFSR, 
  brnfe940.t$fire$l        NUME_PREREC, 
  brnfe940.t$stpr$c        CODE_SITU,
  CASE brnfe940.t$stpr$c 
    WHEN 1 THEN 'Não aplicável' 
    WHEN 2 THEN 'Aberto' 
    WHEN 3 THEN 'NF com erro' 
    WHEN 4 THEN 'A agendar' 
    WHEN 5 THEN 'Agendado' 
   END                     DESC_SITU,
   
  ' '                      SINA_CANLIB, -- *** AGUARDANDO DUVIDA 3 **** 
  brnfe941.t$qnty$l        QUAN_PREREC,
  brnfe940.t$idat$l        DATA_PREREC
  
FROM      baandb.tbrnfe940201  brnfe940,  
          baandb.tbrnfe941201  brnfe941,  
          baandb.ttdpur400201  tdpur400,
          baandb.ttdpur401201  tdpur401

LEFT JOIN baandb.ttdrec947201   tdrec947
       ON tdrec947.t$oorg$l = 80 
      AND tdpur401.t$orno = tdrec947.t$orno$l 
      AND tdpur401.t$pono = tdrec947.t$pono$l 
      AND tdpur401.t$sqnb = tdrec947.t$seqn$l
      
LEFT JOIN baandb.ttdrec941201  tdrec941 
       ON tdrec941.t$fire$l = tdrec947.t$fire$l 
      AND tdrec941.t$line$l = tdrec947.T$LINE$L
      
LEFT JOIN baandb.ttdrec940201   tdrec940
       ON tdrec940.T$FIRE$L=tdrec941.T$FIRE$L,

          baandb.tznnfe007201  znnfe007,
          baandb.ttccom100201  tccom100,         
          baandb.ttccom130201  tccom130,        
          baandb.ttcibd001201  tcibd001,  
          baandb.ttcmcs023201  tcmcs023,    
          baandb.ttcemm030201  tcemm030,
          baandb.ttcemm124201  tcemm124,
          baandb.twhwmd400201  whwmd400
WHERE znnfe007.T$ORNO$C=tdpur401.t$orno

  AND znnfe007.T$PONO$C=tdpur401.t$pono
  AND znnfe007.T$SEQN$C=tdpur401.T$SQNB
  AND znnfe007.T$OORG$C=80
  AND brnfe941.T$FIRE$L=znnfe007.T$FIRE$C
  AND brnfe941.T$LINE$L=znnfe007.t$line$c
  AND tdpur401.t$orno = tdpur400.t$orno 
  AND tcemm124.t$cwoc = tdpur400.t$cofc 
  AND tcemm124.t$dtyp = 2 
  AND tcemm030.t$eunt = tcemm124.t$grid
  AND whwmd400.t$item = tdpur401.t$item
  AND tcibd001.t$item = tdpur401.t$item  
  AND tcibd001.t$citg = tcmcs023.t$citg
  AND tccom100.t$bpid = tdpur400.t$otbp 
  AND tccom130.t$cadr   = tdpur400.t$otad
  AND brnfe941.t$fire$l = brnfe940.t$fire$l
  
  AND Trunc(tdpur400.t$ddat) BETWEEN :PreRecebimentoDe AND :PreRecebimentoAte
  AND ( (Trim(tccom130.t$fovn$l) like '%' || Trim(:CNPJ) || '%') OR (Trim(:CNPJ) is null) )
  AND Trim(tcibd001.t$citg) IN (:GrupoItem)