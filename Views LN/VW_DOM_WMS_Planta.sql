select DISTINCT
  znfmd001.t$dsca$c CD_PLANTA,
  CASE WHEN regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
      WHEN LENGTH(regexp_replace(znfmd001.t$fovn$c, '[^0-9]', ''))<11
        THEN '00000000000000'
          ELSE regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') END CD_TERCEIRO,
  znfmd001.t$dsca$c NM_PLANTA,
  znfmd001.t$fili$c CD_FILIAL,
  CASE WHEN regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
      WHEN LENGTH(regexp_replace(znfmd001.t$fovn$c, '[^0-9]', ''))<11
        THEN '00000000000000'
          ELSE regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') END NR_CNPJ_FILIAL,
  WMSWHS.WHSEID CD_ARMAZEM,
  1 AS CD_CIA,
  (SELECT C.T$NAMA FROM baandb.TTCCOM000201 C 
         WHERE C.T$INDT<TO_DATE('2000-01-01', 'YYYY-DD-MM') AND C.T$NCMP=201) NM_CIA

from baandb.tznfmd001201 znfmd001,
      baandb.TTCEMM112201 TCEMM112, 
      baandb.ttcemm300201 TCEMM300    

left JOIN (SELECT DISTINCT w.DESCRIPTION lctn, UPPER(w.LONG_VALUE) WHSEID 
         FROM ENTERPRISE.CODELKUP@DL_LN_WMS w 
         WHERE w.LISTNAME = 'SCHEMA') WMSWHS
ON WMSWHS.lctn=TCEMM300.T$LCTN

WHERE znfmd001.T$COFC$C = TCEMM112.T$GRID  
AND   TCEMM112.T$WAID = TCEMM300.t$code
