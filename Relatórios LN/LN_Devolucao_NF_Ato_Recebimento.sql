SELECT
  tdrec940.t$opfc$l      NUME_CFOP,
  tcemm030.t$euca        NUME_FILIAL,
  tdpur400.t$cbrn        RAMO_ATIV, 
  tdrec940.t$fovn$l      CNPJ_FORN,
  tccom100.t$nama        NOME_FORNEC, 
  tdrec940.t$docn$l      NUME_NF,
  tdrec940.t$seri$l      SERI_NF, 
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)        
                         DATA_EMISS,
  tdrec940.t$stat$l      CODE_STATUS, 
                         DESC_DOMAIN_STAT.DESCR, 
  tdrec947.t$rcno$l      CODE_RECEB,
  Trim(tdrec941.t$item$l)CODE_ITEM,
  tdrec941.t$dsca$l      DESC_ITEM,
  tdrec941.t$qnty$l      QUAN_FAT,
  tdrec941.t$pric$l      PREC_ITEM,
  
  ( SELECT tdrec942.t$sbas$l 
      FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
       AND tdrec942.t$line$l=tdrec941.t$line$l
       AND tdrec942.t$brty$l=1) 
                         VALOR_BASE_ICMS,
 
  ( SELECT tdrec942.t$amnt$l 
      FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
       AND tdrec942.t$line$l=tdrec941.t$line$l
       AND tdrec942.t$brty$l=3) 
                         VALOR_IPI, 
 
  ( SELECT tdrec942.t$amnt$l 
      FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
       AND tdrec942.t$line$l=tdrec941.t$line$l
       AND tdrec942.t$brty$l=2) 
                         VALOR_ICMS_ST, 

  ( SELECT tdrec942.t$amnt$l 
      FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
       AND tdrec942.t$line$l=tdrec941.t$line$l
       AND tdrec942.t$brty$l=5) 
                         VALOR_PIS,

  ( SELECT tdrec942.t$amnt$l 
      FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
       AND tdrec942.t$line$l=tdrec941.t$line$l
       AND tdrec942.t$brty$l=6) 
                         VALOR_COFINS, 
  
  tdrec940.t$tfda$l      VALO_TOTORD,
  tdrec941.t$tamt$l      VOLO_TOTITEM,
  tcibd001.t$citg        GRUPO_ITEM,
  tcmcs023.t$dsca        DESC_GRUPO_ITEM

FROM 	baandb.ttdrec940301 tdrec940
		INNER JOIN	baandb.ttdrec940301 tdrec940d	ON	tdrec940d.t$fire$l	=	tdrec940.t$rref$l
		INNER JOIN	baandb.ttdrec941301 tdrec941	ON	tdrec941.t$fire$l	=	tdrec940.t$fire$l
		INNER JOIN	baandb.ttdrec947301 tdrec947	ON	tdrec947.t$fire$l	=	tdrec941.t$fire$l
													AND	tdrec947.t$line$l	=	tdrec941.t$line$l
		LEFT JOIN	baandb.ttdpur400301 tdpur400	ON	tdpur400.t$orno		=	tdrec947.t$orno$l
		INNER JOIN	baandb.ttccom100301 tccom100	ON	tccom100.t$bpid 	= 	tdrec940.t$bpid$l
		INNER JOIN	baandb.ttcemm124301 tcemm124	ON	tcemm124.t$loco 	= 	301
													AND	tcemm124.t$dtyp		=	2
													AND	tcemm124.t$cwoc		=	tdrec940.t$cofc$l
		INNER JOIN	baandb.ttcemm030301 tcemm030	ON	tcemm030.t$eunt 	= 	tcemm124.t$grid
		INNER JOIN	baandb.ttcibd001301 tcibd001	ON	tcibd001.t$item		=	tdrec941.t$item$l
		INNER JOIN	baandb.ttcmcs023301 tcmcs023	ON	tcmcs023.t$citg		=	tcibd001.t$citg
		
		LEFT JOIN
		 ( SELECT d.t$cnst CODE,
       l.t$desc DESCR
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
WHERE d.t$cpac='td'
AND d.t$cdom='rec.stat.l'
AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                                     (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                                      from baandb.tttadv401000 l1 
                                      where l1.t$cpac=d.t$cpac 
                                      AND l1.t$cdom=d.t$cdom)
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='td'
AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                                    (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                                      from baandb.tttadv140000 l1 
                                      where l1.t$clab=l.t$clab 
                                      AND l1.t$clan=l.t$clan 
                                      AND l1.t$cpac=l.t$cpac) ) DESC_DOMAIN_STAT
													ON	DESC_DOMAIN_STAT.CODE	=	tdrec940.t$stat$l 

WHERE tdrec940.t$rfdt$l = 13 
  AND tdrec940d.t$rfdt$l = 1 


--  AND Trunc( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
--    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--      AT time zone 'America/Sao_Paulo') AS DATE)) between :EmissaoDe AND :EmissaoAte
--  AND tdrec940.t$stat$l = (CASE WHEN :StatusNF = 0 THEN tdrec940.t$stat$l ELSE :StatusNF END)
--  AND Trim(tcibd001.t$citg) IN (:GrupoItem)
--  AND ( (Trim(tccom130.t$fovn$l) like '%' || Trim(:CNPJ) || '%') OR (:CNPJ is null) )