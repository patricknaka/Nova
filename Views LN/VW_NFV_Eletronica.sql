-- 06-mai-2014, Fabio Ferreira, Correção de conversão de timezone
-- #FAF.042 - 29-mai-2014, Fabio Ferreira, 	Correções timezone	
-- #FAF.109 - 07-jun-2014, Fabio Ferreira, 	Inclusão do campo ref.fiscal	
-- #FAF.124 - 10-jun-2014, Fabio Ferreira, 	Correção Chave de acesso
-- #FAF.312 - 29-aug-2014, Fabio Ferreira, 	campo data atualização				
--****************************************************************************************************************************************************************
SELECT
    201 CD_CIA,
    CASE WHEN tcemm030.t$euca = ' ' THEN substr(tcemm124.t$grid,-2,2) ELSE tcemm030.t$euca END AS CD_FILIAL,
    cisli940.t$docn$l NF_NFE,
    cisli940.t$seri$l NR_SERIE_NFE,
    cisli940.t$nfes$l CD_STATUS_SEFAZ,
    cisli940.t$prot$l NR_PROTOCOLO,
    cisli940.t$cnfe$l NR_CHAVE_ACESSO_NFE,
    nvl((SELECT 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(brnfe020.t$date$l), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone sessiontimezone) AS DATE)
    FROM baandb.tbrnfe020201 brnfe020
    WHERE brnfe020.t$refi$l=cisli940.t$fire$l
	  AND	  brnfe020.t$ncmp$l=201 	
    AND   brnfe020.T$STAT$L=cisli940.t$tsta$l),
    (SELECT 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(brnfe020.t$date$l), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone sessiontimezone) AS DATE)
    FROM baandb.tbrnfe020201 brnfe020
    WHERE brnfe020.t$refi$l=cisli940.t$fire$l
	  AND	  brnfe020.t$ncmp$l=201)) DT_STATUS,
    (SELECT 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(brnfe020.t$date$l), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone sessiontimezone) AS DATE)
    FROM baandb.tbrnfe020201 brnfe020
    WHERE brnfe020.t$refi$l=cisli940.t$fire$l
    AND brnfe020.T$STAT$L=4) DT_CANCELAMENTO,
    cisli940.t$rscd$l CD_MOTIVO_CANCELAMENTO,
	tcemm124.t$grid CD_UNIDADE_EMPRESARIAL,
	cisli940.t$fire$l NR_REFERENCIA_FISCAL,																		--#FAF.109.n
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone sessiontimezone) AS DATE)     DT_ULT_ATUALIZACAO											--#FAF.312.n
FROM
    baandb.tcisli940201 cisli940,
    baandb.ttcemm124201 tcemm124,
    baandb.ttcemm030201 tcemm030
--	(select distinct anfe.t$ncmp$l, anfe.t$refi$l from baandb.tbrnfe020201 anfe) nfe							--#FAF.312.o
WHERE tcemm124.t$loco=201
	AND tcemm124.t$dtyp=1
	AND tcemm124.t$cwoc=cisli940.t$cofc$l
	AND tcemm030.t$eunt=tcemm124.t$grid
	AND cisli940.t$nfel$l=1																						--#FAF.312.n
	-- AND nfe.t$refi$l=cisli940.t$fire$l																		--#FAF.312.so
	-- AND	nfe.t$ncmp$l=201 																					--#FAF.312.eo