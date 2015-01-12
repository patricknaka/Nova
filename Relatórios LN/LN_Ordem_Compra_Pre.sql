SELECT  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$odat, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)  
                           DATA_ORDEM,
  tcemm030.t$euca          NUME_FILIAL,
  tdpur400.t$orno          CODE_ORDEM,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$ddat, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)  
                           DATA_PLREC,    
  tccom130.t$fovn$l        CNPJ_FORN,
  tccom100.t$nama          DESC_FORN,  
  tcibd001.t$citg          GRUP_ITEM,    
  tcmcs023.t$dsca          DESC_GRUPO,
  Trim(tcibd001.t$item)    CODE_ITEM,    
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
  
FROM       baandb.ttdpur400301 tdpur400

INNER JOIN baandb.ttdpur401301 tdpur401
        ON tdpur401.t$orno = tdpur400.t$orno 

 LEFT JOIN baandb.ttdrec947301 tdrec947
        ON tdrec947.t$orno$l = tdpur401.t$orno
       AND tdrec947.t$pono$l = tdpur401.t$pono
       AND tdrec947.t$seqn$l = tdpur401.t$sqnb
    AND tdrec947.t$oorg$l = 80 

 LEFT JOIN baandb.ttdrec941301 tdrec941 
        ON tdrec941.t$fire$l = tdrec947.t$fire$l 
       AND tdrec941.t$line$l = tdrec947.T$LINE$L
       
 LEFT JOIN baandb.ttdrec940301 tdrec940
        ON tdrec940.T$FIRE$L = tdrec941.T$FIRE$L
 
INNER JOIN baandb.tznnfe007301 znnfe007
        ON znnfe007.T$PONO$C = tdpur401.t$pono
       AND znnfe007.T$SEQN$C = tdpur401.T$SQNB
    AND znnfe007.T$ORNO$C = tdpur401.t$orno

INNER JOIN baandb.tbrnfe941301 brnfe941
        ON brnfe941.T$FIRE$L = znnfe007.T$FIRE$C
       AND brnfe941.T$LINE$L = znnfe007.t$line$c
    
INNER JOIN baandb.tbrnfe940301 brnfe940
        ON brnfe940.t$fire$l = brnfe941.t$fire$l

INNER JOIN baandb.ttccom100301 tccom100  
        ON tccom100.t$bpid = tdpur400.t$otbp        

INNER JOIN baandb.ttccom130301 tccom130  
        ON tccom130.t$cadr = tdpur400.t$otad      

INNER JOIN baandb.ttcibd001301 tcibd001 
        ON tcibd001.t$item = tdpur401.t$item  
  
INNER JOIN baandb.ttcmcs023301 tcmcs023    
        ON tcmcs023.t$citg = tcibd001.t$citg

INNER JOIN baandb.ttcemm124301 tcemm124
        ON tcemm124.t$cwoc = tdpur400.t$cofc 
  
INNER JOIN baandb.ttcemm030301 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid

INNER JOIN baandb.twhwmd400301 whwmd400
        ON whwmd400.t$item = tdpur401.t$item
    
WHERE znnfe007.T$OORG$C = 80
  AND tcemm124.t$dtyp = 2 
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$ddat,'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE) ) 
      BETWEEN :PreRecebimentoDe 
          AND :PreRecebimentoAte
  AND ( (Trim(tccom130.t$fovn$l) like '%' || Trim(:CNPJ) || '%') OR (Trim(:CNPJ) is null) )
  AND Trim(tcibd001.t$citg) IN (:GrupoItem)