=
" SELECT  " &
"   DISTINCT  " &
"     wmsCODE.UDF1                         FILIAL,  " &
"     wmsCODE.UDF2                         DSC_PLANTA,  " &
"     TDSLS400.T$ORNO                      PEDIDO_LN,  " &
"     ZNSLS004.T$PECL$C                    PEDIDO_SITE,  " &
"     OWMS.ORDERKEY                        ORDEM_WMS,  " &
"     TDSLS400.T$CBRN                      ID_UNEG,  " &
"     TCMCS031.T$DSCA                      DESCR_UNEG,  " &
"     NVL(TDSLS420.T$HREA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL )  " &
"                THEN 'NEN'  " &
"              ELSE NULL  " &
"          END)                            ID_ULT_PONTO,  " &
"     NVL(TDSLS090.T$DSCA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL)  " &
"                THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"              ELSE NULL  " &
"          END)                            DESCR_ULT_PONTO,  " &
"     TRIM(ZNSLS004.T$ITEM$C)              ITEM,  " &
"     SYSDATE -  " &
"     ( SELECT MAX(A.T$DTBL)  " &
"         FROM BAANDB.TTDSLS421" + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602") + " A  " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO  " &
"          AND A.T$PONO = TDSLS420.T$PONO  " &
"          AND A.T$SQNB = TDSLS420.T$SQNB  " &
"          AND A.T$CSQN = TDSLS420.T$CSQN  " &
"          AND A.T$HREA = TDSLS420.T$HREA )  TEMPO_STAUS  " &
"  " &
" FROM       BAANDB.TTDSLS400" + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602") + " TDSLS400  " &
"  " &
" INNER JOIN BAANDB.TTDSLS401" + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602") + " TDSLS401  " &
"         ON TDSLS401.T$ORNO = TDSLS400.T$ORNO  " &
"  " &
" INNER JOIN BAANDB.TTDSLS094" + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602") + " TDSLS094  " &
"         ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
"  " &
"  LEFT JOIN ( select A.T$NCIA$C,  " &
"                     A.T$UNEG$C,  " &
"                     A.T$PECL$C,  " &
"                     A.T$SQPD$C,  " &
"                     A.T$ENTR$C,  " &
"                     A.T$ORNO$C,  " &
"                     B.T$ITEM$C,  " &
"                     B.T$CWRL$C,  " &
"                     MIN(B.T$DTAP$C) T$DTAP$C  " &
"                from BAANDB.TZNSLS004" + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602") + " A  " &
"          inner join BAANDB.TZNSLS401" + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602") + " B  " &
"                  on B.T$NCIA$C = A.T$NCIA$C  " &
"                 and B.T$UNEG$C = A.T$UNEG$C  " &
"                 and B.T$PECL$C = A.T$PECL$C  " &
"                 and B.T$SQPD$C = A.T$SQPD$C  " &
"                 and B.T$ENTR$C = A.T$ENTR$C  " &
"                 and B.T$SEQU$C = A.T$SEQU$C  " &
"            group by A.T$NCIA$C,  " &
"                     A.T$UNEG$C,  " &
"                     A.T$PECL$C,  " &
"                     A.T$SQPD$C,  " &
"                     A.T$ENTR$C,  " &
"                     A.T$ORNO$C,  " &
"                     B.T$ITEM$C,  " &
"                     B.T$CWRL$C ) ZNSLS004  " &
"         ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO  " &
"  " &
"  LEFT JOIN BAANDB.TTCMCS031301 TCMCS031  " &
"         ON TCMCS031.T$CBRN = TDSLS400.T$CBRN  " &
"  " &
"  LEFT JOIN BAANDB.TTDSLS420" + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602") + " TDSLS420  " &
"         ON TDSLS420.T$ORNO = TDSLS401.T$ORNO  " &
"  " &
"  LEFT JOIN BAANDB.TTDSLS090301 TDSLS090  " &
"         ON TDSLS090.T$HREA = TDSLS420.T$HREA  " &
"  " &
" INNER JOIN ( select A.LONG_VALUE,  " &
"                     UPPER(A.UDF1) UDF1,  " &
"                     A.UDF2  " &
"                from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"               where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"         ON wmsCODE.UDF1 = '" + Parameters!Armazem.Value + "'  " &
"  " &
"  LEFT JOIN ( select MAX(B.ORDERKEY) ORDERKEY,  " &
"                     B.REFERENCEDOCUMENT  " &
"                from " + Parameters!Armazem.Value + ".ORDERS@DL_LN_WMS B  " &
"            group by B.REFERENCEDOCUMENT ) OWMS  " &
"         ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO  " &
"  " &
"  LEFT JOIN BAANDB.TCISLI245" + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602") + " CISLI245  " &
"         ON CISLI245.T$SLCP = " + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602")  &
"        AND CISLI245.T$ORTP = 1  " &
"        AND CISLI245.T$KOOR = 3  " &
"        AND CISLI245.T$SLSO = TDSLS401.T$ORNO  " &
"        AND CISLI245.T$PONO = TDSLS401.T$PONO  " &
"        AND CISLI245.T$SQNB = TDSLS401.T$SQNB  " &
"        AND CISLI245.T$FIRE$L != ' '  " &
"  " &
" WHERE (   TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')  " &
"        OR CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)  " &
"                  THEN 'NEN'  " &
"                ELSE   NULL  " &
"            END = 'NEN' )  " &
"   AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"   AND TDSLS094.T$RETO = 2  " &
"   AND TDSLS401.T$CLYN = 2  " &
"  " &
" UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     wmsCODE.UDF1                             FILIAL,  " &
"     wmsCODE.UDF2                             DSC_PLANTA,  " &
"     WHINH200.T$ORNO                          PEDIDO_LN,  " &
"     NULL                                     PEDIDO_SITE,  " &
"     NULL                                     ORDEM_WMS,  " &
"     NULL                                     ID_UNEG,  " &
"     NULL                                     DESCR_UNEG,  " &
"     'NEN'                                    ID_ULT_PONTO,  " &
"     'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  DESCR_ULT_PONTO,  " &
"     TRIM(WHINH220.T$ITEM)                    ITEM,  " &
"     SYSDATE -  " &
"     WHINH200.T$ODAT                          TEMPO_STAUS  " &
"  " &
" FROM  BAANDB.TWHINH200" + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602") + " WHINH200  " &
"  " &
" INNER JOIN BAANDB.TWHINH220" + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602") + " WHINH220  " &
"         ON WHINH220.T$OORG = WHINH200.T$OORG  " &
"        AND WHINH220.T$ORNO = WHINH200.T$ORNO  " &
"  " &
" INNER JOIN ( select A.LONG_VALUE,  " &
"                     UPPER(A.UDF1) UDF1,  " &
"                     A.UDF2  " &
"                from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"               where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"         ON wmsCODE.UDF1 = '" + Parameters!Armazem.Value + "'  " &
"  " &
"  " &
"  LEFT JOIN(       Select  3 koor,  1 oorg From DUAL  " &
"             Union Select  7 koor,  2 oorg From DUAL  " &
"             Union Select 34 koor,  3 oorg From DUAL  " &
"             Union Select  2 koor, 80 oorg From DUAL  " &
"             Union Select  6 koor, 81 oorg From DUAL  " &
"             Union Select 33 koor, 82 oorg From DUAL  " &
"             Union Select 17 koor, 11 oorg From DUAL  " &
"             Union Select 35 koor, 12 oorg From DUAL  " &
"             Union Select 37 koor, 31 oorg From DUAL  " &
"             Union Select 39 koor, 32 oorg From DUAL  " &
"             Union Select 38 koor, 33 oorg From DUAL  " &
"             Union Select 42 koor, 34 oorg From DUAL  " &
"             Union Select  1 koor, 50 oorg From DUAL  " &
"             Union Select 32 koor, 51 oorg From DUAL  " &
"             Union Select 56 koor, 53 oorg From DUAL  " &
"             Union Select  9 koor, 55 oorg From DUAL  " &
"             Union Select 46 koor, 56 oorg From DUAL  " &
"             Union Select 57 koor, 58 oorg From DUAL  " &
"             Union Select 22 koor, 71 oorg From DUAL  " &
"             Union Select 36 koor, 72 oorg From DUAL  " &
"             Union Select 58 koor, 75 oorg From DUAL  " &
"             Union Select 59 koor, 76 oorg From DUAL  " &
"             Union Select 60 koor, 90 oorg From DUAL  " &
"             Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG  " &
"         ON KOOR2OORG.OORG = WHINH200.T$OORG  " &
"  " &
"  LEFT JOIN BAANDB.TCISLI245" + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602") + " CISLI245  " &
"         ON CISLI245.T$SLCP = " + IIF(Parameters!Armazem.Value = "WMWHSE9", "601", "602")  &
"        AND CISLI245.T$ORTP = 2  " &
"        AND CISLI245.T$KOOR = KOOR2OORG.KOOR  " &
"        AND CISLI245.T$SLSO = WHINH220.T$ORNO  " &
"        AND CISLI245.T$OSET = WHINH200.T$OSET  " &
"        AND CISLI245.T$PONO = WHINH220.T$PONO  " &
"  " &
"  WHERE WHINH220.T$WMSS = 10  " &
"    AND CISLI245.T$FIRE$L  IS NULL  " &
"    AND WHINH200.T$OORG != 1  " &
"    AND WHINH220.T$CNCL != 1  "
