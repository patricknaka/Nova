SELECT
  DISTINCT
    brnfe940.t$fovn$l         NUME_CNPJ,
    301                       NUME_CIA,
    tcemm030.t$euca           NUME_FILIAL,
    znnfe007.t$orno$c         ORDEM_VENDA,
    brnfe940.t$docn$l         NF_NUM,
    brnfe940.t$seri$l         NF_SERIE,
    brnfe940.t$idat$l         DATA_EMISSAO,
    znnfe007.t$fire$c         NUM_PREREC,
    brnfe940.t$stpr$c         CODE_SITU

FROM       baandb.tznnfe007301  znnfe007

INNER JOIN baandb.tbrnfe941301  brnfe941
        ON brnfe941.t$fire$L = znnfe007.t$fire$C 
       AND brnfe941.t$line$L = znnfe007.t$line$c
       AND brnfe941.t$fire$L = znnfe007.t$fire$C 
       AND brnfe941.t$line$L = znnfe007.t$line$c

INNER JOIN baandb.tbrnfe940301  brnfe940
        ON brnfe940.t$fire$l = brnfe941.t$fire$l

INNER JOIN baandb.ttdpur401301  tdpur401
        ON tdpur401.t$pono = znnfe007.t$pono$c 
       AND tdpur401.t$sqnb = znnfe007.t$seqn$c 

INNER JOIN baandb.ttdpur400301  tdpur400
        ON tdpur400.t$orno = znnfe007.t$orno$c 
       AND tdpur400.t$orno = tdpur401.t$orno

INNER JOIN baandb.ttdpur094301  tdpur094
        ON tdpur094.t$potp = tdpur400.t$cotp

INNER JOIN baandb.ttcemm124301  tcemm124
        ON tcemm124.t$cwoc = tdpur400.t$cofc 
        
INNER JOIN baandb.ttcemm030301  tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid
  
WHERE znnfe007.t$oorg$c = 80
  AND tdpur094.t$rfdt$l = 33 
  AND tcemm124.t$dtyp = 2 
  AND Trunc(brnfe940.t$idat$l) Between :EmissaoDe And :EmissaoAte