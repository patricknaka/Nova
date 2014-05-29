-- 06-jan-2014, Fabio Ferreira, Correção de conversão de timezone
-- #FAF.042 - 29-mai-2014, Fabio Ferreira, 	Correções timezone					
--****************************************************************************************************************************************************************
SELECT
    201 CD_CIA,
    tcemm030.t$euca CD_FILIAL,
	tcemm124.t$grid CD_UNIDADE_EMPRESARIAL,
    cisli940.t$docn$l NF_NFE,
    cisli940.t$seri$l NR_SERIE_NFE,
    cisli940.t$nfes$l CD_STATUS_SEFAZ,
    cisli940.t$prot$l NR_CHAVE_ACESSO_NFE,
    nvl((SELECT 
	CAST((FROM_TZ(CAST(TO_CHAR(MIN(brnfe020.t$date$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
		AT time zone sessiontimezone) AS DATE)	
    FROM tbrnfe020201 brnfe020
    WHERE brnfe020.t$refi$l=cisli940.t$fire$l
	  AND	  brnfe020.t$ncmp$l=201 	
    AND   brnfe020.T$STAT$L=cisli940.t$tsta$l),
    (SELECT 
	CAST((FROM_TZ(CAST(TO_CHAR(MAX(brnfe020.t$date$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
		AT time zone sessiontimezone) AS DATE)
    FROM tbrnfe020201 brnfe020
    WHERE brnfe020.t$refi$l=cisli940.t$fire$l
	  AND	  brnfe020.t$ncmp$l=201)) DT_STATUS,
    (SELECT 
	CAST((FROM_TZ(CAST(TO_CHAR(MIN(brnfe020.t$date$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
		AT time zone sessiontimezone) AS DATE)
    FROM tbrnfe020201 brnfe020
    WHERE brnfe020.t$refi$l=cisli940.t$fire$l
    AND brnfe020.T$STAT$L=4) DT_CANCELAMENTO,
    cisli940.t$rscd$l CD_MOTIVO_CANCELAMENTO
FROM
    tcisli940201 cisli940,
    ttcemm124201 tcemm124,
	ttcemm030201 tcemm030,
	(select distinct anfe.t$ncmp$l, anfe.t$refi$l from tbrnfe020201 anfe) nfe
WHERE tcemm124.t$loco=201
	AND tcemm124.t$dtyp=1
	AND tcemm124.t$cwoc=cisli940.t$cofc$l
	AND tcemm030.t$eunt=tcemm124.t$grid
	AND nfe.t$refi$l=cisli940.t$fire$l
	AND	nfe.t$ncmp$l=201 
