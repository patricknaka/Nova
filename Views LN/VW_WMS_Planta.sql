--	#FAF.151 - 20-jun-2014,	Fabio Ferreira,	Tratamento para o CNPJ
--	#FAF.150 - 24-jun-2014,	Fabio Ferreira,	COD_FILIAL alterado para mostrar o código do armazem do WMS
--************************************************************************************************************************************************************
SELECT
        tcemm112.T$waid PLANTA,
        ' ' COD_TERCEIRO, -- NÃO EXISITE NO WMS/LN
        TCMCS003.T$DSCA NOME_PLANTA,
        WMSWHS.WHSEID COD_FILIAL,
		tcemm030.t$euca NUM_FIALIAL,
        CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') END CGC_FILIAL,							--#FAF.151.n		
		
--        TCCOM130.T$FOVN$L CGC_FILIAL,																	--#FAF.151.o
        201 COMPANHIA,
        (SELECT C.T$NAMA FROM baandb.TTCCOM000201 C 
         WHERE C.T$INDT<TO_DATE('2000-01-01', 'YYYY-DD-MM') AND C.T$NCMP=201) NOME_CIA
FROM
        baandb.TTCEMM112201 TCEMM112,
        baandb.TTCMCS003201 TCMCS003,
        baandb.TTCEMM030201 TCEMM030,
        baandb.ttccom130201 TCCOM130,
        baandb.ttcemm300201 TCEMM300,
        (SELECT DISTINCT w.DESCRIPTION lctn, UPPER(w.LONG_VALUE) WHSEID 
         FROM ENTERPRISE.CODELKUP@DL_LN_WMS w 
         WHERE w.LISTNAME = 'SCHEMA') WMSWHS
WHERE   
        TCMCS003.T$CWAR=TCEMM112.T$WAID
  AND   TCEMM030.T$EUNT=TCEMM112.T$GRID
  AND   TCCOM130.T$CADR=TCMCS003.T$CADR
  AND   TCEMM300.t$code=TCEMM112.T$WAID
  AND   WMSWHS.lctn=TCEMM300.T$LCTN