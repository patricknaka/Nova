/*
tdrec940 = referencia fiscal de recebimento (origem)
cisli940 = referencia  fiscal de devolução (saída)
*/

SELECT
--  tdrec940.t$opfc$l      	NUME_CFOP,
	cisli940.t$ccfo$l		NUME_CFOP,
	cisli940.t$opor$l		SEQ_CFOP,
	tcemm030.t$euca        	NUME_FILIAL,
	cisli940.t$cbrn$c      	RAMO_ATIV, 
	tdrec940.t$fovn$l      	CNPJ_FORN,
	tccom100.t$nama        	NOME_FORNEC, 
	cisli940.t$docn$l      	NUME_NF,
	cisli940.t$seri$l      	SERI_NF,
	tdrec940.t$docn$l		NF_RECEB,
	tdrec940.t$seri$l		SERIE_RECEB,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
	  AT time zone 'America/Sao_Paulo') AS DATE)        
							DATA_EMISS,
	cisli940.t$stat$l      	CODE_STATUS, 
	DESC_DOMAIN_STAT.DESCR	DESCR_STATUS, 
	tdrec947.t$rcno$l      	CODE_RECEB,
	Trim(cisli941.t$item$l)	CODE_ITEM,
	cisli941.t$desc$l      	DESC_ITEM,
	cisli941.t$dqua$l      	QUAN_FAT,
	cisli941.t$pric$l      	PREC_ITEM,
  
  ( SELECT cisli943.t$sbas$l 
      FROM baandb.tcisli943201 cisli943
     WHERE cisli943.t$fire$l=cisli941.t$fire$l
       AND cisli943.t$line$l=cisli941.t$line$l
       AND cisli943.t$brty$l=1) 
                         VALOR_BASE_ICMS,
 
  ( SELECT cisli943.t$amnt$l 
      FROM baandb.tcisli943201 cisli943
     WHERE cisli943.t$fire$l=cisli941.t$fire$l
       AND cisli943.t$line$l=cisli941.t$line$l
       AND cisli943.t$brty$l=3) 
                         VALOR_IPI, 
 
  ( SELECT cisli943.t$amnt$l 
      FROM baandb.tcisli943201 cisli943
     WHERE cisli943.t$fire$l=cisli941.t$fire$l
       AND cisli943.t$line$l=cisli941.t$line$l
       AND cisli943.t$brty$l=2) 
                         VALOR_ICMS_ST, 

  ( SELECT cisli943.t$amnt$l 
      FROM baandb.tcisli943201 cisli943
     WHERE cisli943.t$fire$l=cisli941.t$fire$l
       AND cisli943.t$line$l=cisli941.t$line$l
       AND cisli943.t$brty$l=5) 
                         VALOR_PIS,

  ( SELECT cisli943.t$amnt$l 
      FROM baandb.tcisli943201 cisli943
     WHERE cisli943.t$fire$l=cisli941.t$fire$l
       AND cisli943.t$line$l=cisli941.t$line$l
       AND cisli943.t$brty$l=6) 
                         VALOR_COFINS, 
  
  cisli940.t$amnt$l      VALO_TOTORD,
  cisli941.t$amnt$l      VOLO_TOTITEM,
  tcibd001.t$citg        GRUPO_ITEM,
  tcmcs023.t$dsca        DESC_GRUPO_ITEM

FROM 				baandb.ttdrec940201 tdrec940
		INNER JOIN	baandb.ttdrec941201 tdrec941	ON	tdrec941.t$fire$l	=	tdrec940.t$fire$l
		INNER JOIN 	baandb.tcisli941201	cisli941	ON	cisli941.t$fire$l	=	tdrec941.t$rfdv$c
													AND	cisli941.t$line$l	=	tdrec941.t$lfdv$c
		INNER JOIN 	baandb.tcisli940201	cisli940	ON	cisli940.t$fire$l	=	cisli941.t$fire$l
		LEFT JOIN	baandb.ttdrec947201 tdrec947	ON	tdrec947.t$fire$l	=	tdrec941.t$fire$l
													AND	tdrec947.t$line$l	=	tdrec941.t$line$l													
		INNER JOIN	baandb.ttccom100201 tccom100	ON	tccom100.t$bpid 	= 	tdrec940.t$bpid$l		
		INNER JOIN	baandb.ttcemm124201 tcemm124	ON	tcemm124.t$loco 	= 	201
													AND	tcemm124.t$dtyp		=	2
													AND	tcemm124.t$cwoc		=	tdrec940.t$cofc$l
		INNER JOIN	baandb.ttcemm030201 tcemm030	ON	tcemm030.t$eunt 	= 	tcemm124.t$grid													
		INNER JOIN	baandb.ttcibd001201 tcibd001	ON	tcibd001.t$item		=	cisli941.t$item$l
		INNER JOIN	baandb.ttcmcs023201 tcmcs023	ON	tcmcs023.t$citg		=	tcibd001.t$citg
		
		LEFT JOIN
		 (	SELECT d.t$cnst CODE,
				   l.t$desc DESCR
			FROM baandb.tttadv401000 d,
				 baandb.tttadv140000 l
			WHERE d.t$cpac='ci'
			AND d.t$cdom='sli.stat'
			AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
												 (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
												  from baandb.tttadv401000 l1 
												  where l1.t$cpac=d.t$cpac 
												  AND l1.t$cdom=d.t$cdom)
			AND l.t$clab=d.t$za_clab
			AND l.t$clan='p'
			AND l.t$cpac='ci'
			AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
												(select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
												  from baandb.tttadv140000 l1 
												  where l1.t$clab=l.t$clab 
												  AND l1.t$clan=l.t$clan 
												  AND l1.t$cpac=l.t$cpac)) DESC_DOMAIN_STAT
													ON	DESC_DOMAIN_STAT.CODE	=	cisli940.t$stat$l

WHERE 	tdrec941.t$rfdv$c != ' '

--  AND Trunc( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
--    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--      AT time zone 'America/Sao_Paulo') AS DATE)) between :EmissaoDe AND :EmissaoAte
--  AND tdrec940.t$stat$l = (CASE WHEN :StatusNF = 0 THEN cisli940.t$stat$l ELSE :StatusNF END)
--  AND Trim(tcibd001.t$citg) IN (:GrupoItem)
--  AND ( (Trim(tccom130.t$fovn$l) like '%' || Trim(:CNPJ) || '%') OR (:CNPJ is null) )