   SELECT 
    DISTINCT 
          301                NUM_CIA,
          tccom130.t$fovn$l  CNPJ_FILIAL,
          tdrec940.t$cofc$l  DEPTO_FILIAL,
          tcmcs065.t$dsca    DESR_FILIAL,
          tdrec941.t$fire$l  REF_FIS_ENTR,    
          tdrec940.t$adat$l  DT_APRV,    
          tdrec940.t$docn$l  NR_NF,
          tdrec940.t$seri$l  SERIE_NF,
          tdrec940.t$fovn$l  CNPJ_FORNEC,
          tdrec940.t$sfbn$l  NOME_PARC,
          Trim(cisli941.t$item$l)
                             ITEM,
          cisli941.t$desc$l  DS_Item,
          tdrec941.t$gamt$l  VL_ITEM,
          tdrec941.t$qnty$l  QT_ITEM,
          cisli941.t$dqua$l  QT_DEV,
          cisli940.t$docn$l  NR_NFD,
          cisli940.t$seri$l  SERIE_NFD,
          whinh300.t$recd$c  RECDOC,
          tdrec940.t$lipl$l  PLACA,
          cisli940.t$cnfe$l  CHAVE 
		  
     FROM baandb.ttdrec940301 tdrec940
	 
LEFT JOIN baandb.twhinh300301 whinh300
       ON whinh300.t$fire$c = tdrec940.t$fire$l,
	   
          baandb.ttcmcs065301 tcmcs065,
          baandb.ttdrec941301 tdrec941,
          baandb.tcisli940301 cisli940,
          baandb.tcisli941301 cisli941,
          baandb.ttccom100301 tccom100
		  
LEFT JOIN baandb.ttccom130301 tccom130
       ON tccom130.t$cadr = tccom100.t$cadr
	   
    WHERE tdrec941.t$fire$l = tdrec940.t$fire$l
      AND tdrec940.t$cofc$l = tcmcs065.t$cwoc
      AND cisli941.t$fire$l = tdrec941.t$rfdv$c
      AND cisli941.t$line$l = tdrec941.t$lfdv$c
      AND cisli941.t$fire$l = cisli940.t$fire$l
      AND cisli940.t$fdty$l = 5
      AND tccom100.t$bpid   = tdrec940.t$bpid$l
     
      AND tdrec940.t$cofc$l IN (:Filial)
      AND Trunc(tdrec940.t$adat$l) BETWEEN :DataAprovacaoDe AND :DataAprovacaoAte
      AND ( (Trim(tdrec940.t$fovn$l) Like '%' || :CNPJ_FORN || '%') OR (:CNPJ_FORN IS NULL) )