--	#FAF.151 - 20-jun-2014,	Fabio Ferreira,	Tratamento para o CNPJ
--************************************************************************************************************************************************************
SELECT
        tcemm112.T$waid PLANTA,
        ' ' COD_TERCEIRO, -- NÃO EXISITE NO WMS/LN
        TCMCS003.T$DSCA NOME_PLANTA,
        TCEMM030.T$EUCA COD_FILIAL,
		
        CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') END CGC_FILIAL,							--#FAF.151.n		
		
--        TCCOM130.T$FOVN$L CGC_FILIAL,																	--#FAF.151.o
        201 COMPANHIA,
        (SELECT C.T$NAMA FROM TTCCOM000201 C 
         WHERE C.T$INDT<TO_DATE('2000-01-01', 'YYYY-DD-MM') AND C.T$NCMP=201) NOME_CIA
FROM
        TTCEMM112201 TCEMM112,
        TTCMCS003201 TCMCS003,
        TTCEMM030201 TCEMM030,
        ttccom130201 TCCOM130
WHERE   
        TCMCS003.T$CWAR=TCEMM112.T$WAID
  AND   TCEMM030.T$EUNT=TCEMM112.T$GRID
  AND   TCCOM130.T$CADR=TCMCS003.T$CADR