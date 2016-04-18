SELECT DISTINCT
--**********************************************************************************************************************************************************
-- dados B2C
  znfmd001.t$dsca$c     CD_PLANTA,
  CASE WHEN regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
  WHEN LENGTH(regexp_replace(znfmd001.t$fovn$c, '[^0-9]', ''))<11
    THEN '00000000000000'
  ELSE regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') 
  END                   CD_TERCEIRO, 
  znfmd001.t$dsca$c     NM_PLANTA,
  CAST(znfmd001.t$fili$c as int)    CD_FILIAL,
  WMSWHS.WHSEID         CD_ARMAZEM,
  CASE WHEN regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
  WHEN LENGTH(regexp_replace(znfmd001.t$fovn$c, '[^0-9]', ''))<11
    THEN '00000000000000'
  ELSE regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') 
  END                   NR_CNPJ_FILIAL, 
  1                     CD_CIA,
  (SELECT C.T$NAMA 
    FROM baandb.TTCCOM000201 C --compartilhada
      WHERE C.T$INDT<TO_DATE('2000-01-01', 'YYYY-DD-MM') 
      AND C.T$NCMP=201) NM_CIA

FROM baandb.tznfmd001201 znfmd001

inner join baandb.TTCEMM030201 TCEMM030 -- só não é compartilhada com a Nike
on znfmd001.T$COFC$C=TCEMM030.t$dfpo

inner join baandb.TTCEMM112201 TCEMM112
on TCEMM030.T$EUNT=TCEMM112.T$GRID

inner join baandb.TTCMCS003201 TCMCS003
on TCMCS003.T$CWAR=TCEMM112.T$WAID

inner join baandb.ttccom130201 TCCOM130
on TCCOM130.T$CADR=TCMCS003.T$CADR

inner join baandb.ttcemm300201 TCEMM300 -- só não é compartilhada com a Nike
 on TCEMM300.t$code=TCEMM112.T$WAID
and tcemm300.t$code = TCMCS003.T$CWAR

inner join (SELECT DISTINCT w.DESCRIPTION lctn, UPPER(w.UDF1)WHSEID
            FROM ENTERPRISE.CODELKUP@DL_LN_WMS w 
            WHERE w.LISTNAME = 'SCHEMA'
            and udf3 in (201)) WMSWHS
on WMSWHS.lctn=TCEMM300.T$LCTN

inner join baandb.TTFGLD010201 TFGLD010 --compartilhada
 on TFGLD010.T$DIMX=tcemm030.t$euca
AND TFGLD010.T$DTYP=2

union all

SELECT DISTINCT
--**********************************************************************************************************************************************************
-- dados NIKE
  znfmd001.t$dsca$c     CD_PLANTA,
  CASE WHEN regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
  WHEN LENGTH(regexp_replace(znfmd001.t$fovn$c, '[^0-9]', ''))<11
    THEN '00000000000000'
  ELSE regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') 
  END                   CD_TERCEIRO, 
  znfmd001.t$dsca$c     NM_PLANTA,
  znfmd001.t$fili$c     CD_FILIAL,
  WMSWHS.WHSEID         CD_ARMAZEM,
  CASE WHEN regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
  WHEN LENGTH(regexp_replace(znfmd001.t$fovn$c, '[^0-9]', ''))<11
    THEN '00000000000000'
  ELSE regexp_replace(znfmd001.t$fovn$c, '[^0-9]', '') 
  END                   NR_CNPJ_FILIAL, 
  13                    CD_CIA,
  (SELECT C.T$NAMA 
    FROM baandb.TTCCOM000201 C --compartilhada
      WHERE C.T$INDT<TO_DATE('2000-01-01', 'YYYY-DD-MM') 
      AND C.T$NCMP=601) NM_CIA

FROM baandb.tznfmd001601 znfmd001

inner join baandb.TTCEMM030601 TCEMM030 -- só não é compartilhada com a Nike
on znfmd001.T$COFC$C=TCEMM030.t$dfpo

inner join baandb.TTCEMM112601 TCEMM112
on TCEMM030.T$EUNT=TCEMM112.T$GRID

inner join baandb.TTCMCS003601 TCMCS003
on TCMCS003.T$CWAR=TCEMM112.T$WAID

inner join baandb.ttccom130601 TCCOM130
on TCCOM130.T$CADR=TCMCS003.T$CADR

inner join baandb.ttcemm300601 TCEMM300 -- só não é compartilhada com a Nike
 on TCEMM300.t$code=TCEMM112.T$WAID
and tcemm300.t$code = TCMCS003.T$CWAR

inner join (SELECT DISTINCT w.DESCRIPTION lctn, UPPER(w.UDF1)WHSEID -- UPPER(w.LONG_VALUE) WHSEID 
             FROM ENTERPRISE.CODELKUP@DL_LN_WMS w 
             WHERE w.LISTNAME = 'SCHEMA'
             and udf3 = 601) WMSWHS
on WMSWHS.lctn=TCEMM300.T$LCTN

inner join baandb.TTFGLD010201 TFGLD010 --compartilhada
  on  TFGLD010.T$DIMX=tcemm030.t$euca
  AND TFGLD010.T$DTYP=2
