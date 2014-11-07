SELECT
  znrec002.t$date$c              DATA_CORTE,
  tcemm030.t$euca                NUME_FILIAL,
  tccom130.t$fovn$l              CNPJ_FORN,
  tccom100.t$nama                NOME_FORN,
  cisli941.t$item$l              CODE_ITEM,
  cisli941.t$desc$l              DESC_ITEM,
  tcibd001.t$ceat$l              NUME_EAN,
  tdrec940.t$docn$l || '-' || 
  tdrec940.t$seri$l              NF_REMESSA,
  tdrec940.t$odat$l              DATA_REMESSA,
  tdrec941.t$qnty$l              QUAN_REMESSA,
  tdrec941.t$tamt$l              VALO_REMESSA,
  cisli940.t$docn$l || '-' || 
  cisli940.t$seri$l              NF_SIMBOLICA,
  cisli941.t$pric$l              PREC_SIMBILICA,
  cisli941.t$iprt$l              TOTA_SIMBO_SIMP,
  cisli941.t$dqua$l              QUAN_SIMBOLICA  

FROM       baandb.ttdrec940301 tdrec940

INNER JOIN baandb.ttdrec941301 tdrec941
        ON tdrec941.t$fire$l = tdrec940.t$fire$l 
  
INNER JOIN baandb.tcisli941301 cisli941
        ON cisli941.t$refr$l = tdrec941.t$fire$l 
       AND cisli941.t$rfdl$l = tdrec941.t$line$l
  
INNER JOIN baandb.tznrec002301 znrec002
        ON cisli941.t$fire$l = znrec002.t$fire$c 
       AND cisli941.t$line$l = znrec002.t$line$c 
  
INNER JOIN baandb.tcisli940301 cisli940
        ON cisli941.t$fire$l = cisli940.t$fire$l
  
INNER JOIN baandb.ttccom100301 tccom100             
        ON tccom100.t$bpid   = cisli940.t$itbp$l 

INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr   = cisli940.t$itoa$l

INNER JOIN baandb.ttcemm124301 tcemm124
        ON tcemm124.t$cwoc   = cisli940.t$cofc$l

INNER JOIN baandb.ttcemm030301 tcemm030
        ON tcemm030.t$eunt   = tcemm124.t$grid

INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item   = tdrec941.t$item$l

WHERE tcemm124.t$dtyp = 2