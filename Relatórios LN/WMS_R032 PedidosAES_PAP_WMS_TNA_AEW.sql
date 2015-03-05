SELECT DISTINCT
       wmsCODE.UDF1                         FILIAL,
       wmsCODE.UDF2                         DSC_PLANTA,
       TDSLS400.T$ORNO                      PEDIDO_LN,
       ZNSLS004.T$PECL$C                    PEDIDO_SITE,
       OWMS.ORDERKEY                        ORDEM_WMS,
       TDSLS400.T$CBRN                      ID_UNEG,
       TCMCS031.T$DSCA                      DESCR_UNEG,
       NVL(TDSLS420.T$HREA,
           CASE WHEN (    CISLI245.T$FIRE$L IS NULL 
                      AND OWMS.ORDERKEY IS NULL ) 
                  THEN 'NEN' 
                ELSE NULL 
            END)                            ID_ULT_PONTO,
       NVL(TDSLS090.T$DSCA,
           CASE WHEN (    CISLI245.T$FIRE$L IS NULL 
                      AND OWMS.ORDERKEY IS NULL) 
                  THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA' 
                ELSE NULL 
            END)                            DESCR_ULT_PONTO,
       TRIM(ZNSLS004.T$ITEM$C)              ITEM, 
       SYSDATE -
     ( SELECT MAX(A.T$DTBL)
         FROM BAANDB.TTDSLS421301 A
        WHERE A.T$ORNO = TDSLS420.T$ORNO
          AND A.T$PONO = TDSLS420.T$PONO
          AND A.T$SQNB = TDSLS420.T$SQNB
          AND A.T$CSQN = TDSLS420.T$CSQN
          AND A.T$HREA = TDSLS420.T$HREA )  TEMPO_STAUS
     
FROM       BAANDB.TTDSLS400301 TDSLS400

INNER JOIN BAANDB.TTDSLS401301 TDSLS401
        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO
  
INNER JOIN BAANDB.TTDSLS094301 TDSLS094
        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  


 LEFT JOIN ( select A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$ORNO$C,
                    B.T$ITEM$C,
                    B.T$CWRL$C,
                    MIN(B.T$DTAP$C) T$DTAP$C
               from BAANDB.TZNSLS004301 A
         inner join BAANDB.TZNSLS401301 B 
                 on B.T$NCIA$C = A.T$NCIA$C
                and B.T$UNEG$C = A.T$UNEG$C
                and B.T$PECL$C = A.T$PECL$C
                and B.T$SQPD$C = A.T$SQPD$C
                and B.T$ENTR$C = A.T$ENTR$C
                and B.T$SEQU$C = A.T$SEQU$C
           group by A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$ORNO$C,
                    B.T$ITEM$C,
                    B.T$CWRL$C ) ZNSLS004
        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO
    
 LEFT JOIN BAANDB.TTCMCS031301 TCMCS031
        ON TCMCS031.T$CBRN = TDSLS400.T$CBRN
    
 LEFT JOIN BAANDB.TTDSLS420301 TDSLS420
        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO
    
 LEFT JOIN BAANDB.TTDSLS090301 TDSLS090
        ON TDSLS090.T$HREA = TDSLS420.T$HREA
 
INNER JOIN BAANDB.TTCEMM300301 TCEMM300
        ON TCEMM300.T$COMP = 301
       AND TCEMM300.T$TYPE = 20
       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)
 
INNER JOIN ( SELECT A.LONG_VALUE,
                    UPPER(A.UDF1) UDF1,
                    A.UDF2
               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A
              WHERE A.LISTNAME = 'SCHEMA') wmsCODE
        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN
 
 LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,
                    B.REFERENCEDOCUMENT
               FROM WMWHSE5.ORDERS@DL_LN_WMS B
           GROUP BY B.REFERENCEDOCUMENT ) OWMS 
        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO
  
 LEFT JOIN BAANDB.TCISLI245301 CISLI245
        ON CISLI245.T$SLCP = 301
       AND CISLI245.T$ORTP = 1
       AND CISLI245.T$KOOR = 3
       AND CISLI245.T$SLSO = TDSLS401.T$ORNO
       AND CISLI245.T$PONO = TDSLS401.T$PONO
       AND CISLI245.T$SQNB = TDSLS401.T$SQNB
       AND CISLI245.T$FIRE$L != ' '    

  
 WHERE (   TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW') 
        OR CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL) 
                  THEN 'NEN' 
                ELSE   NULL 
            END = 'NEN' )
   AND TDSLS400.T$HDST NOT IN (30, 35)
   AND TDSLS094.T$RETO = 2
   AND TDSLS401.T$CLYN = 2
--   AND wmsCODE.UDF1 :Table


= IIF(Parameters!Table.Value <> "AAA",

"SELECT DISTINCT                                                 " &
"       wmsCODE.UDF1                         FILIAL,             " &
"       wmsCODE.UDF2                         DSC_PLANTA,         " &
"       TDSLS400.T$ORNO                      PEDIDO_LN,          " &
"       ZNSLS004.T$PECL$C                    PEDIDO_SITE,        " &
"       OWMS.ORDERKEY                        ORDEM_WMS,          " &
"       TDSLS400.T$CBRN                      ID_UNEG,            " &
"       TCMCS031.T$DSCA                      DESCR_UNEG,         " &
"       NVL(TDSLS420.T$HREA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL )               " &
"                  THEN 'NEN'                                    " &
"                ELSE NULL                                       " &
"            END)                            ID_ULT_PONTO,       " &
"       NVL(TDSLS090.T$DSCA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL)                " &
"                  THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"                ELSE NULL                                       " &
"            END)                            DESCR_ULT_PONTO,    " &
"       TRIM(ZNSLS004.T$ITEM$C)              ITEM,               " &
"       SYSDATE -                                                " &
"     ( SELECT MAX(A.T$DTBL)                                     " &
"         FROM BAANDB.TTDSLS421301 A                             " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO                        " &
"          AND A.T$PONO = TDSLS420.T$PONO                        " &
"          AND A.T$SQNB = TDSLS420.T$SQNB                        " &
"          AND A.T$CSQN = TDSLS420.T$CSQN                        " &
"          AND A.T$HREA = TDSLS420.T$HREA )  TEMPO_STAUS         " &
"                                                                " &
"FROM       BAANDB.TTDSLS400301 TDSLS400                         " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401                         " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO                    " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094                         " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP                    " &
"                                                                " &
"                                                                " &
" LEFT JOIN ( select A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C,                                 " &
"                    MIN(B.T$DTAP$C) T$DTAP$C                    " &
"               from BAANDB.TZNSLS004301 A                       " &
"         inner join BAANDB.TZNSLS401301 B                       " &
"                 on B.T$NCIA$C = A.T$NCIA$C                     " &
"                and B.T$UNEG$C = A.T$UNEG$C                     " &
"                and B.T$PECL$C = A.T$PECL$C                     " &
"                and B.T$SQPD$C = A.T$SQPD$C                     " &
"                and B.T$ENTR$C = A.T$ENTR$C                     " &
"                and B.T$SEQU$C = A.T$SEQU$C                     " &
"           group by A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C ) ZNSLS004                       " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO                  " &
"                                                                " &
" LEFT JOIN BAANDB.TTCMCS031301 TCMCS031                         " &
"        ON TCMCS031.T$CBRN = TDSLS400.T$CBRN                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420                         " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090                         " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA                    " &
"                                                                " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300                         " &
"        ON TCEMM300.T$COMP = 301                                " &
"       AND TCEMM300.T$TYPE = 20                                 " &
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)        " &
"                                                                " &
"INNER JOIN ( SELECT A.LONG_VALUE,                               " &
"                    UPPER(A.UDF1) UDF1,                         " &
"                    A.UDF2                                      " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A             " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE              " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN                 " &
"                                                                " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,                   " &
"                    B.REFERENCEDOCUMENT                         " &
"               FROM " + Parameters!Table.Value + ".ORDERS@DL_LN_WMS B     " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS                  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO             " &
"                                                                " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245                         " &
"        ON CISLI245.T$SLCP = 301                                " &
"       AND CISLI245.T$ORTP = 1                                  " &
"       AND CISLI245.T$KOOR = 3                                  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO                    " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO                    " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB                    " &
"       AND CISLI245.T$FIRE$L != ' '                             " &
"                                                                " &
"                                                                " &
" WHERE (   TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')      " &
"        OR CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)" &
"                  THEN 'NEN'                                    " &
"                ELSE   NULL                                     " &
"            END = 'NEN' )                                       " &
"   AND TDSLS400.T$HDST NOT IN (30, 35)                          " &
"   AND TDSLS094.T$RETO = 2                                      " &
"   AND TDSLS401.T$CLYN = 2                                      " &
"   AND wmsCODE.UDF1 = '" + Parameters!Table.Value + "'          " &
"Order by 2,3,4                                                            "

,
   
"SELECT DISTINCT                                                 " &
"       wmsCODE.UDF1                         FILIAL,             " &
"       wmsCODE.UDF2                         DSC_PLANTA,         " &
"       TDSLS400.T$ORNO                      PEDIDO_LN,          " &
"       ZNSLS004.T$PECL$C                    PEDIDO_SITE,        " &
"       OWMS.ORDERKEY                        ORDEM_WMS,          " &
"       TDSLS400.T$CBRN                      ID_UNEG,            " &
"       TCMCS031.T$DSCA                      DESCR_UNEG,         " &
"       NVL(TDSLS420.T$HREA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL )               " &
"                  THEN 'NEN'                                    " &
"                ELSE NULL                                       " &
"            END)                            ID_ULT_PONTO,       " &
"       NVL(TDSLS090.T$DSCA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL)                " &
"                  THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"                ELSE NULL                                       " &
"            END)                            DESCR_ULT_PONTO,    " &
"       TRIM(ZNSLS004.T$ITEM$C)              ITEM,               " &
"       SYSDATE -                                                " &
"     ( SELECT MAX(A.T$DTBL)                                     " &
"         FROM BAANDB.TTDSLS421301 A                             " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO                        " &
"          AND A.T$PONO = TDSLS420.T$PONO                        " &
"          AND A.T$SQNB = TDSLS420.T$SQNB                        " &
"          AND A.T$CSQN = TDSLS420.T$CSQN                        " &
"          AND A.T$HREA = TDSLS420.T$HREA )  TEMPO_STAUS         " &
"                                                                " &
"FROM       BAANDB.TTDSLS400301 TDSLS400                         " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401                         " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO                    " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094                         " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP                    " &
"                                                                " &
"                                                                " &
" LEFT JOIN ( select A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C,                                 " &
"                    MIN(B.T$DTAP$C) T$DTAP$C                    " &
"               from BAANDB.TZNSLS004301 A                       " &
"         inner join BAANDB.TZNSLS401301 B                       " &
"                 on B.T$NCIA$C = A.T$NCIA$C                     " &
"                and B.T$UNEG$C = A.T$UNEG$C                     " &
"                and B.T$PECL$C = A.T$PECL$C                     " &
"                and B.T$SQPD$C = A.T$SQPD$C                     " &
"                and B.T$ENTR$C = A.T$ENTR$C                     " &
"                and B.T$SEQU$C = A.T$SEQU$C                     " &
"           group by A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C ) ZNSLS004                       " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO                  " &
"                                                                " &
" LEFT JOIN BAANDB.TTCMCS031301 TCMCS031                         " &
"        ON TCMCS031.T$CBRN = TDSLS400.T$CBRN                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420                         " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090                         " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA                    " &
"                                                                " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300                         " &
"        ON TCEMM300.T$COMP = 301                                " &
"       AND TCEMM300.T$TYPE = 20                                 " &
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)        " &
"                                                                " &
"INNER JOIN ( SELECT A.LONG_VALUE,                               " &
"                    UPPER(A.UDF1) UDF1,                         " &
"                    A.UDF2                                      " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A             " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE              " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN                 " &
"                                                                " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,                   " &
"                    B.REFERENCEDOCUMENT                         " &
"               FROM WMWHSE1.ORDERS@DL_LN_WMS B                  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS                  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO             " &
"                                                                " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245                         " &
"        ON CISLI245.T$SLCP = 301                                " &
"       AND CISLI245.T$ORTP = 1                                  " &
"       AND CISLI245.T$KOOR = 3                                  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO                    " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO                    " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB                    " &
"       AND CISLI245.T$FIRE$L != ' '                             " &
"                                                                " &
"                                                                " &
" WHERE (   TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')      " &
"        OR CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)" &
"                  THEN 'NEN'                                    " &
"                ELSE   NULL                                     " &
"            END = 'NEN' )                                       " &
"   AND TDSLS400.T$HDST NOT IN (30, 35)                          " &
"   AND TDSLS094.T$RETO = 2                                      " &
"   AND TDSLS401.T$CLYN = 2                                      " &
"   AND wmsCODE.UDF1 = 'WMWHSE1'                                 " &
"                                                                " &
"Union                                                           " &
"                                                                " &
"SELECT DISTINCT                                                 " &
"       wmsCODE.UDF1                         FILIAL,             " &
"       wmsCODE.UDF2                         DSC_PLANTA,         " &
"       TDSLS400.T$ORNO                      PEDIDO_LN,          " &
"       ZNSLS004.T$PECL$C                    PEDIDO_SITE,        " &
"       OWMS.ORDERKEY                        ORDEM_WMS,          " &
"       TDSLS400.T$CBRN                      ID_UNEG,            " &
"       TCMCS031.T$DSCA                      DESCR_UNEG,         " &
"       NVL(TDSLS420.T$HREA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL )               " &
"                  THEN 'NEN'                                    " &
"                ELSE NULL                                       " &
"            END)                            ID_ULT_PONTO,       " &
"       NVL(TDSLS090.T$DSCA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL)                " &
"                  THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"                ELSE NULL                                       " &
"            END)                            DESCR_ULT_PONTO,    " &
"       TRIM(ZNSLS004.T$ITEM$C)              ITEM,               " &
"       SYSDATE -                                                " &
"     ( SELECT MAX(A.T$DTBL)                                     " &
"         FROM BAANDB.TTDSLS421301 A                             " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO                        " &
"          AND A.T$PONO = TDSLS420.T$PONO                        " &
"          AND A.T$SQNB = TDSLS420.T$SQNB                        " &
"          AND A.T$CSQN = TDSLS420.T$CSQN                        " &
"          AND A.T$HREA = TDSLS420.T$HREA )  TEMPO_STAUS         " &
"                                                                " &
"FROM       BAANDB.TTDSLS400301 TDSLS400                         " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401                         " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO                    " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094                         " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP                    " &
"                                                                " &
"                                                                " &
" LEFT JOIN ( select A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C,                                 " &
"                    MIN(B.T$DTAP$C) T$DTAP$C                    " &
"               from BAANDB.TZNSLS004301 A                       " &
"         inner join BAANDB.TZNSLS401301 B                       " &
"                 on B.T$NCIA$C = A.T$NCIA$C                     " &
"                and B.T$UNEG$C = A.T$UNEG$C                     " &
"                and B.T$PECL$C = A.T$PECL$C                     " &
"                and B.T$SQPD$C = A.T$SQPD$C                     " &
"                and B.T$ENTR$C = A.T$ENTR$C                     " &
"                and B.T$SEQU$C = A.T$SEQU$C                     " &
"           group by A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C ) ZNSLS004                       " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO                  " &
"                                                                " &
" LEFT JOIN BAANDB.TTCMCS031301 TCMCS031                         " &
"        ON TCMCS031.T$CBRN = TDSLS400.T$CBRN                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420                         " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090                         " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA                    " &
"                                                                " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300                         " &
"        ON TCEMM300.T$COMP = 301                                " &
"       AND TCEMM300.T$TYPE = 20                                 " &
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)        " &
"                                                                " &
"INNER JOIN ( SELECT A.LONG_VALUE,                               " &
"                    UPPER(A.UDF1) UDF1,                         " &
"                    A.UDF2                                      " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A             " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE              " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN                 " &
"                                                                " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,                   " &
"                    B.REFERENCEDOCUMENT                         " &
"               FROM WMWHSE2.ORDERS@DL_LN_WMS B                  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS                  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO             " &
"                                                                " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245                         " &
"        ON CISLI245.T$SLCP = 301                                " &
"       AND CISLI245.T$ORTP = 1                                  " &
"       AND CISLI245.T$KOOR = 3                                  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO                    " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO                    " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB                    " &
"       AND CISLI245.T$FIRE$L != ' '                             " &
"                                                                " &
"                                                                " &
" WHERE (   TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')      " &
"        OR CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)" &
"                  THEN 'NEN'                                    " &
"                ELSE   NULL                                     " &
"            END = 'NEN' )                                       " &
"   AND TDSLS400.T$HDST NOT IN (30, 35)                          " &
"   AND TDSLS094.T$RETO = 2                                      " &
"   AND TDSLS401.T$CLYN = 2                                      " &
"   AND wmsCODE.UDF1 = 'WMWHSE2'                                 " &
"                                                                " &
"Union                                                           " &
"                                                                " &
"SELECT DISTINCT                                                 " &
"       wmsCODE.UDF1                         FILIAL,             " &
"       wmsCODE.UDF2                         DSC_PLANTA,         " &
"       TDSLS400.T$ORNO                      PEDIDO_LN,          " &
"       ZNSLS004.T$PECL$C                    PEDIDO_SITE,        " &
"       OWMS.ORDERKEY                        ORDEM_WMS,          " &
"       TDSLS400.T$CBRN                      ID_UNEG,            " &
"       TCMCS031.T$DSCA                      DESCR_UNEG,         " &
"       NVL(TDSLS420.T$HREA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL )               " &
"                  THEN 'NEN'                                    " &
"                ELSE NULL                                       " &
"            END)                            ID_ULT_PONTO,       " &
"       NVL(TDSLS090.T$DSCA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL)                " &
"                  THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"                ELSE NULL                                       " &
"            END)                            DESCR_ULT_PONTO,    " &
"       TRIM(ZNSLS004.T$ITEM$C)              ITEM,               " &
"       SYSDATE -                                                " &
"     ( SELECT MAX(A.T$DTBL)                                     " &
"         FROM BAANDB.TTDSLS421301 A                             " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO                        " &
"          AND A.T$PONO = TDSLS420.T$PONO                        " &
"          AND A.T$SQNB = TDSLS420.T$SQNB                        " &
"          AND A.T$CSQN = TDSLS420.T$CSQN                        " &
"          AND A.T$HREA = TDSLS420.T$HREA )  TEMPO_STAUS         " &
"                                                                " &
"FROM       BAANDB.TTDSLS400301 TDSLS400                         " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401                         " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO                    " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094                         " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP                    " &
"                                                                " &
"                                                                " &
" LEFT JOIN ( select A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C,                                 " &
"                    MIN(B.T$DTAP$C) T$DTAP$C                    " &
"               from BAANDB.TZNSLS004301 A                       " &
"         inner join BAANDB.TZNSLS401301 B                       " &
"                 on B.T$NCIA$C = A.T$NCIA$C                     " &
"                and B.T$UNEG$C = A.T$UNEG$C                     " &
"                and B.T$PECL$C = A.T$PECL$C                     " &
"                and B.T$SQPD$C = A.T$SQPD$C                     " &
"                and B.T$ENTR$C = A.T$ENTR$C                     " &
"                and B.T$SEQU$C = A.T$SEQU$C                     " &
"           group by A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C ) ZNSLS004                       " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO                  " &
"                                                                " &
" LEFT JOIN BAANDB.TTCMCS031301 TCMCS031                         " &
"        ON TCMCS031.T$CBRN = TDSLS400.T$CBRN                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420                         " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090                         " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA                    " &
"                                                                " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300                         " &
"        ON TCEMM300.T$COMP = 301                                " &
"       AND TCEMM300.T$TYPE = 20                                 " &
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)        " &
"                                                                " &
"INNER JOIN ( SELECT A.LONG_VALUE,                               " &
"                    UPPER(A.UDF1) UDF1,                         " &
"                    A.UDF2                                      " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A             " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE              " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN                 " &
"                                                                " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,                   " &
"                    B.REFERENCEDOCUMENT                         " &
"               FROM WMWHSE3.ORDERS@DL_LN_WMS B                  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS                  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO             " &
"                                                                " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245                         " &
"        ON CISLI245.T$SLCP = 301                                " &
"       AND CISLI245.T$ORTP = 1                                  " &
"       AND CISLI245.T$KOOR = 3                                  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO                    " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO                    " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB                    " &
"       AND CISLI245.T$FIRE$L != ' '                             " &
"                                                                " &
"                                                                " &
" WHERE (   TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')      " &
"        OR CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)" &
"                  THEN 'NEN'                                    " &
"                ELSE   NULL                                     " &
"            END = 'NEN' )                                       " &
"   AND TDSLS400.T$HDST NOT IN (30, 35)                          " &
"   AND TDSLS094.T$RETO = 2                                      " &
"   AND TDSLS401.T$CLYN = 2                                      " &
"   AND wmsCODE.UDF1 = 'WMWHSE3'                                 " &
"                                                                " &
"Union                                                           " &
"                                                                " &
"SELECT DISTINCT                                                 " &
"       wmsCODE.UDF1                         FILIAL,             " &
"       wmsCODE.UDF2                         DSC_PLANTA,         " &
"       TDSLS400.T$ORNO                      PEDIDO_LN,          " &
"       ZNSLS004.T$PECL$C                    PEDIDO_SITE,        " &
"       OWMS.ORDERKEY                        ORDEM_WMS,          " &
"       TDSLS400.T$CBRN                      ID_UNEG,            " &
"       TCMCS031.T$DSCA                      DESCR_UNEG,         " &
"       NVL(TDSLS420.T$HREA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL )               " &
"                  THEN 'NEN'                                    " &
"                ELSE NULL                                       " &
"            END)                            ID_ULT_PONTO,       " &
"       NVL(TDSLS090.T$DSCA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL)                " &
"                  THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"                ELSE NULL                                       " &
"            END)                            DESCR_ULT_PONTO,    " &
"       TRIM(ZNSLS004.T$ITEM$C)              ITEM,               " &
"       SYSDATE -                                                " &
"     ( SELECT MAX(A.T$DTBL)                                     " &
"         FROM BAANDB.TTDSLS421301 A                             " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO                        " &
"          AND A.T$PONO = TDSLS420.T$PONO                        " &
"          AND A.T$SQNB = TDSLS420.T$SQNB                        " &
"          AND A.T$CSQN = TDSLS420.T$CSQN                        " &
"          AND A.T$HREA = TDSLS420.T$HREA )  TEMPO_STAUS         " &
"                                                                " &
"FROM       BAANDB.TTDSLS400301 TDSLS400                         " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401                         " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO                    " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094                         " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP                    " &
"                                                                " &
"                                                                " &
" LEFT JOIN ( select A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C,                                 " &
"                    MIN(B.T$DTAP$C) T$DTAP$C                    " &
"               from BAANDB.TZNSLS004301 A                       " &
"         inner join BAANDB.TZNSLS401301 B                       " &
"                 on B.T$NCIA$C = A.T$NCIA$C                     " &
"                and B.T$UNEG$C = A.T$UNEG$C                     " &
"                and B.T$PECL$C = A.T$PECL$C                     " &
"                and B.T$SQPD$C = A.T$SQPD$C                     " &
"                and B.T$ENTR$C = A.T$ENTR$C                     " &
"                and B.T$SEQU$C = A.T$SEQU$C                     " &
"           group by A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C ) ZNSLS004                       " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO                  " &
"                                                                " &
" LEFT JOIN BAANDB.TTCMCS031301 TCMCS031                         " &
"        ON TCMCS031.T$CBRN = TDSLS400.T$CBRN                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420                         " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090                         " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA                    " &
"                                                                " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300                         " &
"        ON TCEMM300.T$COMP = 301                                " &
"       AND TCEMM300.T$TYPE = 20                                 " &
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)        " &
"                                                                " &
"INNER JOIN ( SELECT A.LONG_VALUE,                               " &
"                    UPPER(A.UDF1) UDF1,                         " &
"                    A.UDF2                                      " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A             " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE              " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN                 " &
"                                                                " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,                   " &
"                    B.REFERENCEDOCUMENT                         " &
"               FROM WMWHSE4.ORDERS@DL_LN_WMS B                  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS                  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO             " &
"                                                                " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245                         " &
"        ON CISLI245.T$SLCP = 301                                " &
"       AND CISLI245.T$ORTP = 1                                  " &
"       AND CISLI245.T$KOOR = 3                                  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO                    " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO                    " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB                    " &
"       AND CISLI245.T$FIRE$L != ' '                             " &
"                                                                " &
"                                                                " &
" WHERE (   TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')      " &
"        OR CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)" &
"                  THEN 'NEN'                                    " &
"                ELSE   NULL                                     " &
"            END = 'NEN' )                                       " &
"   AND TDSLS400.T$HDST NOT IN (30, 35)                          " &
"   AND TDSLS094.T$RETO = 2                                      " &
"   AND TDSLS401.T$CLYN = 2                                      " &
"   AND wmsCODE.UDF1 = 'WMWHSE4'                                 " &
"                                                                " &
"Union                                                           " &
"                                                                " &
"SELECT DISTINCT                                                 " &
"       wmsCODE.UDF1                         FILIAL,             " &
"       wmsCODE.UDF2                         DSC_PLANTA,         " &
"       TDSLS400.T$ORNO                      PEDIDO_LN,          " &
"       ZNSLS004.T$PECL$C                    PEDIDO_SITE,        " &
"       OWMS.ORDERKEY                        ORDEM_WMS,          " &
"       TDSLS400.T$CBRN                      ID_UNEG,            " &
"       TCMCS031.T$DSCA                      DESCR_UNEG,         " &
"       NVL(TDSLS420.T$HREA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL )               " &
"                  THEN 'NEN'                                    " &
"                ELSE NULL                                       " &
"            END)                            ID_ULT_PONTO,       " &
"       NVL(TDSLS090.T$DSCA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL)                " &
"                  THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"                ELSE NULL                                       " &
"            END)                            DESCR_ULT_PONTO,    " &
"       TRIM(ZNSLS004.T$ITEM$C)              ITEM,               " &
"       SYSDATE -                                                " &
"     ( SELECT MAX(A.T$DTBL)                                     " &
"         FROM BAANDB.TTDSLS421301 A                             " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO                        " &
"          AND A.T$PONO = TDSLS420.T$PONO                        " &
"          AND A.T$SQNB = TDSLS420.T$SQNB                        " &
"          AND A.T$CSQN = TDSLS420.T$CSQN                        " &
"          AND A.T$HREA = TDSLS420.T$HREA )  TEMPO_STAUS         " &
"                                                                " &
"FROM       BAANDB.TTDSLS400301 TDSLS400                         " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401                         " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO                    " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094                         " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP                    " &
"                                                                " &
"                                                                " &
" LEFT JOIN ( select A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C,                                 " &
"                    MIN(B.T$DTAP$C) T$DTAP$C                    " &
"               from BAANDB.TZNSLS004301 A                       " &
"         inner join BAANDB.TZNSLS401301 B                       " &
"                 on B.T$NCIA$C = A.T$NCIA$C                     " &
"                and B.T$UNEG$C = A.T$UNEG$C                     " &
"                and B.T$PECL$C = A.T$PECL$C                     " &
"                and B.T$SQPD$C = A.T$SQPD$C                     " &
"                and B.T$ENTR$C = A.T$ENTR$C                     " &
"                and B.T$SEQU$C = A.T$SEQU$C                     " &
"           group by A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C ) ZNSLS004                       " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO                  " &
"                                                                " &
" LEFT JOIN BAANDB.TTCMCS031301 TCMCS031                         " &
"        ON TCMCS031.T$CBRN = TDSLS400.T$CBRN                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420                         " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090                         " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA                    " &
"                                                                " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300                         " &
"        ON TCEMM300.T$COMP = 301                                " &
"       AND TCEMM300.T$TYPE = 20                                 " &
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)        " &
"                                                                " &
"INNER JOIN ( SELECT A.LONG_VALUE,                               " &
"                    UPPER(A.UDF1) UDF1,                         " &
"                    A.UDF2                                      " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A             " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE              " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN                 " &
"                                                                " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,                   " &
"                    B.REFERENCEDOCUMENT                         " &
"               FROM WMWHSE5.ORDERS@DL_LN_WMS B                  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS                  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO             " &
"                                                                " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245                         " &
"        ON CISLI245.T$SLCP = 301                                " &
"       AND CISLI245.T$ORTP = 1                                  " &
"       AND CISLI245.T$KOOR = 3                                  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO                    " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO                    " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB                    " &
"       AND CISLI245.T$FIRE$L != ' '                             " &
"                                                                " &
"                                                                " &
" WHERE (   TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')      " &
"        OR CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)" &
"                  THEN 'NEN'                                    " &
"                ELSE   NULL                                     " &
"            END = 'NEN' )                                       " &
"   AND TDSLS400.T$HDST NOT IN (30, 35)                          " &
"   AND TDSLS094.T$RETO = 2                                      " &
"   AND TDSLS401.T$CLYN = 2                                      " &
"   AND wmsCODE.UDF1 = 'WMWHSE5'                                 " &
"                                                                " &
"Union                                                           " &
"                                                                " &
"SELECT DISTINCT                                                 " &
"       wmsCODE.UDF1                         FILIAL,             " &
"       wmsCODE.UDF2                         DSC_PLANTA,         " &
"       TDSLS400.T$ORNO                      PEDIDO_LN,          " &
"       ZNSLS004.T$PECL$C                    PEDIDO_SITE,        " &
"       OWMS.ORDERKEY                        ORDEM_WMS,          " &
"       TDSLS400.T$CBRN                      ID_UNEG,            " &
"       TCMCS031.T$DSCA                      DESCR_UNEG,         " &
"       NVL(TDSLS420.T$HREA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL )               " &
"                  THEN 'NEN'                                    " &
"                ELSE NULL                                       " &
"            END)                            ID_ULT_PONTO,       " &
"       NVL(TDSLS090.T$DSCA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL)                " &
"                  THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"                ELSE NULL                                       " &
"            END)                            DESCR_ULT_PONTO,    " &
"       TRIM(ZNSLS004.T$ITEM$C)              ITEM,               " &
"       SYSDATE -                                                " &
"     ( SELECT MAX(A.T$DTBL)                                     " &
"         FROM BAANDB.TTDSLS421301 A                             " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO                        " &
"          AND A.T$PONO = TDSLS420.T$PONO                        " &
"          AND A.T$SQNB = TDSLS420.T$SQNB                        " &
"          AND A.T$CSQN = TDSLS420.T$CSQN                        " &
"          AND A.T$HREA = TDSLS420.T$HREA )  TEMPO_STAUS         " &
"                                                                " &
"FROM       BAANDB.TTDSLS400301 TDSLS400                         " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401                         " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO                    " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094                         " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP                    " &
"                                                                " &
"                                                                " &
" LEFT JOIN ( select A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C,                                 " &
"                    MIN(B.T$DTAP$C) T$DTAP$C                    " &
"               from BAANDB.TZNSLS004301 A                       " &
"         inner join BAANDB.TZNSLS401301 B                       " &
"                 on B.T$NCIA$C = A.T$NCIA$C                     " &
"                and B.T$UNEG$C = A.T$UNEG$C                     " &
"                and B.T$PECL$C = A.T$PECL$C                     " &
"                and B.T$SQPD$C = A.T$SQPD$C                     " &
"                and B.T$ENTR$C = A.T$ENTR$C                     " &
"                and B.T$SEQU$C = A.T$SEQU$C                     " &
"           group by A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C ) ZNSLS004                       " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO                  " &
"                                                                " &
" LEFT JOIN BAANDB.TTCMCS031301 TCMCS031                         " &
"        ON TCMCS031.T$CBRN = TDSLS400.T$CBRN                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420                         " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090                         " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA                    " &
"                                                                " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300                         " &
"        ON TCEMM300.T$COMP = 301                                " &
"       AND TCEMM300.T$TYPE = 20                                 " &
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)        " &
"                                                                " &
"INNER JOIN ( SELECT A.LONG_VALUE,                               " &
"                    UPPER(A.UDF1) UDF1,                         " &
"                    A.UDF2                                      " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A             " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE              " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN                 " &
"                                                                " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,                   " &
"                    B.REFERENCEDOCUMENT                         " &
"               FROM WMWHSE6.ORDERS@DL_LN_WMS B                  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS                  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO             " &
"                                                                " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245                         " &
"        ON CISLI245.T$SLCP = 301                                " &
"       AND CISLI245.T$ORTP = 1                                  " &
"       AND CISLI245.T$KOOR = 3                                  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO                    " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO                    " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB                    " &
"       AND CISLI245.T$FIRE$L != ' '                             " &
"                                                                " &
"                                                                " &
" WHERE (   TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')      " &
"        OR CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)" &
"                  THEN 'NEN'                                    " &
"                ELSE   NULL                                     " &
"            END = 'NEN' )                                       " &
"   AND TDSLS400.T$HDST NOT IN (30, 35)                          " &
"   AND TDSLS094.T$RETO = 2                                      " &
"   AND TDSLS401.T$CLYN = 2                                      " &
"   AND wmsCODE.UDF1 = 'WMWHSE6'                                 " &
"                                                                " &
"Union                                                           " &
"                                                                " &
"SELECT DISTINCT                                                 " &
"       wmsCODE.UDF1                         FILIAL,             " &
"       wmsCODE.UDF2                         DSC_PLANTA,         " &
"       TDSLS400.T$ORNO                      PEDIDO_LN,          " &
"       ZNSLS004.T$PECL$C                    PEDIDO_SITE,        " &
"       OWMS.ORDERKEY                        ORDEM_WMS,          " &
"       TDSLS400.T$CBRN                      ID_UNEG,            " &
"       TCMCS031.T$DSCA                      DESCR_UNEG,         " &
"       NVL(TDSLS420.T$HREA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL )               " &
"                  THEN 'NEN'                                    " &
"                ELSE NULL                                       " &
"            END)                            ID_ULT_PONTO,       " &
"       NVL(TDSLS090.T$DSCA,                                     " &
"           CASE WHEN (    CISLI245.T$FIRE$L IS NULL             " &
"                      AND OWMS.ORDERKEY IS NULL)                " &
"                  THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"                ELSE NULL                                       " &
"            END)                            DESCR_ULT_PONTO,    " &
"       TRIM(ZNSLS004.T$ITEM$C)              ITEM,               " &
"       SYSDATE -                                                " &
"     ( SELECT MAX(A.T$DTBL)                                     " &
"         FROM BAANDB.TTDSLS421301 A                             " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO                        " &
"          AND A.T$PONO = TDSLS420.T$PONO                        " &
"          AND A.T$SQNB = TDSLS420.T$SQNB                        " &
"          AND A.T$CSQN = TDSLS420.T$CSQN                        " &
"          AND A.T$HREA = TDSLS420.T$HREA )  TEMPO_STAUS         " &
"                                                                " &
"FROM       BAANDB.TTDSLS400301 TDSLS400                         " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401                         " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO                    " &
"                                                                " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094                         " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP                    " &
"                                                                " &
"                                                                " &
" LEFT JOIN ( select A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C,                                 " &
"                    MIN(B.T$DTAP$C) T$DTAP$C                    " &
"               from BAANDB.TZNSLS004301 A                       " &
"         inner join BAANDB.TZNSLS401301 B                       " &
"                 on B.T$NCIA$C = A.T$NCIA$C                     " &
"                and B.T$UNEG$C = A.T$UNEG$C                     " &
"                and B.T$PECL$C = A.T$PECL$C                     " &
"                and B.T$SQPD$C = A.T$SQPD$C                     " &
"                and B.T$ENTR$C = A.T$ENTR$C                     " &
"                and B.T$SEQU$C = A.T$SEQU$C                     " &
"           group by A.T$NCIA$C,                                 " &
"                    A.T$UNEG$C,                                 " &
"                    A.T$PECL$C,                                 " &
"                    A.T$SQPD$C,                                 " &
"                    A.T$ENTR$C,                                 " &
"                    A.T$ORNO$C,                                 " &
"                    B.T$ITEM$C,                                 " &
"                    B.T$CWRL$C ) ZNSLS004                       " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO                  " &
"                                                                " &
" LEFT JOIN BAANDB.TTCMCS031301 TCMCS031                         " &
"        ON TCMCS031.T$CBRN = TDSLS400.T$CBRN                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420                         " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO                    " &
"                                                                " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090                         " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA                    " &
"                                                                " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300                         " &
"        ON TCEMM300.T$COMP = 301                                " &
"       AND TCEMM300.T$TYPE = 20                                 " &
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)        " &
"                                                                " &
"INNER JOIN ( SELECT A.LONG_VALUE,                               " &
"                    UPPER(A.UDF1) UDF1,                         " &
"                    A.UDF2                                      " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A             " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE              " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN                 " &
"                                                                " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,                   " &
"                    B.REFERENCEDOCUMENT                         " &
"               FROM WMWHSE7.ORDERS@DL_LN_WMS B                  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS                  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO             " &
"                                                                " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245                         " &
"        ON CISLI245.T$SLCP = 301                                " &
"       AND CISLI245.T$ORTP = 1                                  " &
"       AND CISLI245.T$KOOR = 3                                  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO                    " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO                    " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB                    " &
"       AND CISLI245.T$FIRE$L != ' '                             " &
"                                                                " &
"                                                                " &
" WHERE (   TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')      " &
"        OR CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)" &
"                  THEN 'NEN'                                    " &
"                ELSE   NULL                                     " &
"            END = 'NEN' )                                       " &
"   AND TDSLS400.T$HDST NOT IN (30, 35)                          " &
"   AND TDSLS094.T$RETO = 2                                      " &
"   AND TDSLS401.T$CLYN = 2                                      " &
"   AND wmsCODE.UDF1 = 'WMWHSE7'                                 " &
"                                                                " &
"Order by 2,3,4                                                            "

)