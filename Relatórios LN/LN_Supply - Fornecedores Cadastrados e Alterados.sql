SELECT 
  DISTINCT
    tccom130.t$ftyp$l  TIPO_ENTIDADE,
    tccom130.t$fovn$l  ENTIDADE_FISCAL,
    tccom130.t$nama    RAZAO_SOCIAL,
    tccom966.t$stin$d  INSC_ESTADUAL,
    tccom966.t$ctin$d  INSC_MUNICIPAL,
    tccom130.t$enfe$l  EMAIL_NFE,
    tccom130.t$telp    TELEFONE,
    tccom130.t$ccty    PAIS,
    tccom130.t$cste    ESTADO,
    tccom130.t$dsca    CIDADE,
    tccom130.t$pstc    CEP,
    tccom130.t$user    CRIADO_POR,
        
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$crdt, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE)
                       CRIADO_EM,
					   
    tccom130.t$lmus    ALTERADO_POR,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$dtlm, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE)
                       ALTERADO_EM,
					   
	tccom120.t$cbtp		ID_TP_PARC_FORNC,
	tcmcs029f.t$dsca	DESCR_TP_PARC_FORN,
	tccom110.t$cbtp		ID_TP_PARC_CLIEN,
	tcmcs029c.t$dsca	DESCR_TP_PARC_CLIEN,
	tccom122.t$cpay		ID_PZ_PGTO_FORN,
	tcmcs013f.t$dsca	DESCR_PZ_PGTO_FORN,
	tccom112.t$cpay		ID_PZ_PGTO_CLIEN,
	tcmcs013c.t$dsca	DESCR_PZ_PGTO_CLIEN
  
FROM       baandb.ttccom100301 tccom100
      
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr   = tccom100.t$cadr

LEFT JOIN baandb.ttccom966301 tccom966
        ON tccom966.t$comp$d = tccom130.t$fovn$l
		
LEFT JOIN	baandb.ttccom120301 tccom120
		ON	tccom120.t$otbp	=	tccom100.t$bpid
		
LEFT JOIN	baandb.ttccom110301 tccom110
		ON	tccom110.t$ofbp	=	tccom100.t$bpid
		
LEFT JOIN	baandb.ttcmcs029301 tcmcs029f
		ON	tcmcs029f.t$cbtp =	tccom120.t$cbtp
		
LEFT JOIN	baandb.ttcmcs029301 tcmcs029c
		ON	tcmcs029c.t$cbtp =	tccom110.t$cbtp		

LEFT JOIN	baandb.ttccom122301 tccom122
		ON	tccom122.t$ifbp	=	tccom100.t$bpid
    AND tccom122.t$cofc = ' '
		
LEFT JOIN	baandb.ttccom112301	tccom112
		ON	tccom112.t$itbp	=	tccom100.t$bpid
    AND tccom112.t$cofc = ' '
		
LEFT JOIN	baandb.ttcmcs013301 tcmcs013f
		ON	tcmcs013f.t$cpay	=	tccom122.t$cpay
		
LEFT JOIN	baandb.ttcmcs013301 tcmcs013c
		ON	tcmcs013c.t$cpay	=	tccom112.t$cpay		
  
WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$crdt, 'DD-MON-YYYY HH24:MI:SS'),  
             'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE)) 
      BETWEEN NVL(:DtCadDe,  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$crdt, 'DD-MON-YYYY HH24:MI:SS'), 
                              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE))	  
	  AND NVL(:DtCadAte, CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$crdt, 'DD-MON-YYYY HH24:MI:SS'), 
		                      'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE)) 
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$dtlm, 'DD-MON-YYYY HH24:MI:SS'), 
             'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE))  
      BETWEEN NVL(:DtAltDe,  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$dtlm, 'DD-MON-YYYY HH24:MI:SS'), 
	                          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE)) 
	  AND NVL(:DtAltAte, CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom130.t$dtlm, 'DD-MON-YYYY HH24:MI:SS'), 
		                      'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE))