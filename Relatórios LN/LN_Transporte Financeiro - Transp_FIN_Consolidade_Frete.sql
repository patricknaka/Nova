SELECT 
    znfmd630.t$cfrw$c           CODI_TRANS,
    Trim(tcmcs080.t$dsca)       DESC_TRANS,
    znfmd630.t$cfrw$c ||
    ' - '             ||
    Trim(tcmcs080.t$dsca)       COD_DESC_TRANS,
    COUNT(znfmd630.t$cfrw$c)    QTDE_ENTREGAS,
    SUM(znfmd630.t$vlfC$c)      FRETE_APAGAR,
    cisli940.t$doty$l           TIPO_DOCTO, 
    FGET.                       DESC_TIPO_DOCTO,
    znfmd630.t$fili$c           FILIAL,
	
    Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone sessiontimezone) AS DATE))
                                DATA

FROM       BAANDB.tznfmd630301  znfmd630

INNER JOIN BAANDB.tcisli940301  cisli940
        ON znfmd630.t$fire$c = cisli940.t$fire$l

 LEFT JOIN ( SELECT d.t$cnst CNST,
                    l.t$desc DESC_TIPO_DOCTO
               FROM BAANDB. tttadv401000 d,
                    BAANDB. tttadv140000 l
              WHERE d.t$cpac = 'tc'
                AND d.t$cdom = 'doty.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tc'
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
        ON cisli940.t$doty$l = FGET.CNST
		  
INNER JOIN baandb.ttcmcs080301  tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c
		
WHERE cisli940.t$doty$l IN (:TipoDocto)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone sessiontimezone) AS DATE)) 
      BETWEEN :DataDe 
          AND :DataAte

GROUP BY znfmd630.t$cfrw$c,
         Trim(tcmcs080.t$dsca),
         cisli940.t$doty$l,
         FGET.DESC_TIPO_DOCTO,
         znfmd630.t$fili$c,
         Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c, 
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone sessiontimezone) AS DATE))
  
ORDER BY 9, 8, 2