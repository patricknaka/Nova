SELECT
DISTINCT
  brnfe940.t$fovn$l	NUME_CNPJ,
  201               NUME_CIA,
  tcemm030.t$euca	  NUME_FILIAL,
  znnfe007.t$orno$c	ORDEM_VENDA,
  brnfe940.t$docn$l	NF_NUM,
  brnfe940.t$seri$l	NF_SERIE,
  CAST((FROM_TZ(CAST(TO_CHAR(brnfe940.t$idat$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') AT time zone sessiontimezone) AS DATE) 
                    DATA_EMISSAO,
  znnfe007.t$fire$c	NUM_PREREC,
  brnfe940.t$stpr$c CODE_SITU
FROM BAANDB.tznnfe007201  znnfe007,
  tbrnfe940201 	brnfe940,  
	tbrnfe941201 	brnfe941,
  ttdpur094201	tdpur094,   
  ttdpur400201	tdpur400,
  ttdpur401201	tdpur401,
  ttcemm030201 	tcemm030,
  ttcemm124201  tcemm124
  
WHERE
 brnfe940.t$fire$l = brnfe941.t$fire$l  
AND   
 brnfe941.t$fire$L = znnfe007.t$fire$C AND brnfe941.t$line$L = znnfe007.t$line$c
AND 
  brnfe941.t$fire$L = znnfe007.t$fire$C AND brnfe941.t$line$L = znnfe007.t$line$c
AND
 znnfe007.t$oorg$c = 80
AND 
 tdpur401.t$pono = znnfe007.t$pono$c AND tdpur401.t$sqnb = znnfe007.t$seqn$c AND znnfe007.t$seqn$C = tdpur401.t$sqnb
AND  
  tdpur400.t$orno = znnfe007.t$orno$c AND tdpur400.t$orno = tdpur401.t$orno 
AND   
 tdpur094.t$potp = tdpur400.t$cotp AND tdpur094.t$rfdt$l = 33 
AND
 tcemm124.t$cwoc = tdpur400.t$cofc AND tcemm124.t$dtyp = 2 AND tcemm030.t$eunt = tcemm124.t$grid
