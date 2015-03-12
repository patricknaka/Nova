SELECT 
  DISTINCT
    wmsCODE.UDF1           FILIAL,
    wmsCODE.UDF2           DSC_PLANTA,
    tcemm030.t$euca        NUME_FILIAL, 
    ZNSLS004.T$PECL$C      PEDIDO_SITE,
    TDSLS400.T$ORNO        PEDIDO_LN,
    OWMS.ORDERKEY          ORDEM_WMS,
    TRIM(TCIBD001.T$ITEM)  ITEM,     
    TCIBD001.T$DSCA        DESCR_ITEM,
    TCIBD001.T$CITG        ID_DEPTO,
    TCMCS023.T$DSCA        DESCR_DEPTO,
    TCIBD001.T$SETO$C      ID_SETOR,
    WHWMD400.T$HGHT *
    WHWMD400.T$WDTH *
    WHWMD400.T$DPTH        M3_UNI,
    WHWMD400.T$HGHT *
    WHWMD400.T$WDTH *
    WHWMD400.T$DPTH *  
    TDSLS401.T$QOOR        M3_TOTAL,
	TDSLS401.T$QOOR        QTDE,
    MAUC.MAUC              CMV_UNIT,
    MAUC.MAUC*
    TDSLS401.T$QOOR        CMV_TOTAL,
    TCCOM130.T$FOVN$L      CNPJ,
    TCCOM130.T$NAMA        CLIENTE,
    TCMCS966.T$DSCA$L      TIPO_OPER,
    NVL(TDSLS420.T$HREA,
      CASE WHEN (CISLI245.T$FIRE$L IS NULL 
                  AND OWMS.ORDERKEY IS NULL ) 
             THEN 'NEN' 
           ELSE NULL END)  ID_ULT_PONTO,
    NVL(TDSLS090.T$DSCA,
      CASE WHEN (CISLI245.T$FIRE$L IS NULL 
                  AND OWMS.ORDERKEY IS NULL) 
             THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA' 
           ELSE NULL END)  DESCR_ULT_PONTO
FROM       BAANDB.TTDSLS400301 TDSLS400
INNER JOIN BAANDB.TTDSLS401301 TDSLS401
        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO        
INNER JOIN BAANDB.TWHWMD400301 WHWMD400
        ON WHWMD400.T$ITEM = TDSLS401.T$ITEM        
INNER JOIN BAANDB.TTCIBD001301 TCIBD001
        ON TCIBD001.T$ITEM = TDSLS401.T$ITEM
 LEFT JOIN BAANDB.TTCMCS023301 TCMCS023
        ON TCMCS023.T$CITG = TCIBD001.T$CITG  
 LEFT JOIN BAANDB.TZNMCS030301 ZNMCS030
        ON ZNMCS030.T$CITG$C = TCIBD001.T$CITG
       AND ZNMCS030.T$SETO$C = TCIBD001.T$SETO$C
 LEFT JOIN BAANDB.TTCCOM130301 TCCOM130
        ON TCCOM130.T$CADR = TDSLS400.T$OFAD
 LEFT JOIN BAANDB.TTDSLS094301 TDSLS094
        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP 
 LEFT JOIN BAANDB.TTCMCS966301 TCMCS966
        ON TCMCS966.T$FDTC$L = TDSLS094.T$FDTC$L
 LEFT JOIN ( select whwmd217.t$item item,                             
                    whwmd217.t$cwar cwar,                                   
                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0                             
                           then sum(whwmd217.t$ftpa$1)                                              
                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
                    end mauc                                                
               from baandb.twhwmd217301 whwmd217                      
          left join baandb.twhinr140301 a                             
                 on a.t$cwar = whwmd217.t$cwar                              
                and a.t$item = whwmd217.t$item                              
           group by whwmd217.t$item,                                        
                    whwmd217.t$cwar ) mauc                                
        ON mauc.cwar = TDSLS401.T$CWAR                         
       AND mauc.item = TDSLS401.T$ITEM  
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
 LEFT JOIN BAANDB.TTDSLS420301 TDSLS420
        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO
 LEFT JOIN BAANDB.TTDSLS090301 TDSLS090
        ON TDSLS090.T$HREA = TDSLS420.T$HREA
INNER JOIN BAANDB.TTCEMM124301 TCEMM124
        ON TCEMM124.T$CWOC = TDSLS400.T$COFC
INNER JOIN BAANDB.TTCEMM030301 TCEMM030
        ON TCEMM030.T$EUNT = TCEMM124.T$GRID  
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
WHERE (TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW') 
   OR (TDSLS420.T$HREA IS NULL AND
      (CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL) 
             THEN 'NEN' ELSE   NULL END = 'NEN' )))
  AND TDSLS400.T$HDST NOT IN (30, 35)
  AND TDSLS094.T$RETO = 2
  AND TDSLS401.T$CLYN = 2
  AND wmsCODE.UDF1 = 'WMWHSE5'
ORDER BY NUME_FILIAL, PEDIDO_SITE 


=IIF(Parameters!Table.Value <> "AAA",                         

"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1           FILIAL,  " &
"    wmsCODE.UDF2           DSC_PLANTA,  " &  
"    tcemm030.t$euca        NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C      PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO        PEDIDO_LN,  " &
"    OWMS.ORDERKEY          ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)  ITEM,  " &
"    TCIBD001.T$DSCA        DESCR_ITEM,  " &
"    TCIBD001.T$CITG        ID_DEPTO,  " &
"    TCMCS023.T$DSCA        DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C      ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH        M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR        M3_TOTAL,  " &
"    TDSLS401.T$QOOR        QTDE,  " &
"    MAUC.MAUC              CMV_UNIT,  " &
"    MAUC.MAUC*  " &
"    TDSLS401.T$QOOR        CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L      CNPJ,  " &
"    TCCOM130.T$NAMA        CLIENTE,  " &
"    TCMCS966.T$DSCA$L      TIPO_OPER,  " &
"    NVL(TDSLS420.T$HREA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL )  " &
"             THEN 'NEN'  " &
"           ELSE NULL END)  ID_ULT_PONTO,  " &
"    NVL(TDSLS090.T$DSCA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL)  " &
"      THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"           ELSE NULL END)  DESCR_ULT_PONTO  " &
"FROM       BAANDB.TTDSLS400301 TDSLS400  " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401  " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO  " &
"INNER JOIN BAANDB.TWHWMD400301 WHWMD400  " &
"        ON WHWMD400.T$ITEM = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001  " &
"        ON TCIBD001.T$ITEM = TDSLS401.T$ITEM  " &
" LEFT JOIN BAANDB.TTCMCS023301 TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TZNMCS030301 ZNMCS030  " &
"        ON ZNMCS030.T$CITG$C = TCIBD001.T$CITG  " &
"       AND ZNMCS030.T$SETO$C = TCIBD001.T$SETO$C  " &
" LEFT JOIN BAANDB.TTCCOM130301 TCCOM130  " &
"        ON TCCOM130.T$CADR = TDSLS400.T$OFAD  " &
" LEFT JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = TDSLS094.T$FDTC$L  " &
" LEFT JOIN ( select whwmd217.t$item item,  " &              
"             whwmd217.t$cwar cwar,  " &             
"             case when sum(nvl(whwmd217.t$mauc$1,0))=0  " &
"                    then sum(whwmd217.t$ftpa$1)  " &                                     
"  else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd),4)  " &
"                    end mauc  " &                    
"               from baandb.twhwmd217301 whwmd217  " &              
"          left join baandb.twhinr140301 a  " &              
"                 on a.t$cwar = whwmd217.t$cwar  " &                    
"                and a.t$item = whwmd217.t$item  " &                    
"           group by whwmd217.t$item,  " &                    
"                    whwmd217.t$cwar ) mauc  " &                  
"        ON mauc.cwar = TDSLS401.T$CWAR  " &       
"       AND mauc.item = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C,  " &
"                    MIN(B.T$DTAP$C) T$DTAP$C  " &
"               from BAANDB.TZNSLS004301 A  " &
"         inner join BAANDB.TZNSLS401301 B  " &
"                 on B.T$NCIA$C = A.T$NCIA$C  " &
"                and B.T$UNEG$C = A.T$UNEG$C  " &
"                and B.T$PECL$C = A.T$PECL$C  " &
"                and B.T$SQPD$C = A.T$SQPD$C  " &
"                and B.T$ENTR$C = A.T$ENTR$C  " &
"                and B.T$SEQU$C = A.T$SEQU$C  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C ) ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420  " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090  " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA  " &
"INNER JOIN BAANDB.TTCEMM124301 TCEMM124  " &
"        ON TCEMM124.T$CWOC = TDSLS400.T$COFC  " &
"INNER JOIN BAANDB.TTCEMM030301 TCEMM030  " &
"        ON TCEMM030.T$EUNT = TCEMM124.T$GRID  " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300  " &
"        ON TCEMM300.T$COMP = 301  " &
"       AND TCEMM300.T$TYPE = 20  " &
"       AND TRIM(TCEMM300.T$CODE)=TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( SELECT A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"FROM " + Parameters!Table.Value + ".ORDERS@DL_LN_WMS B  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = 1  " &
"       AND CISLI245.T$KOOR = 3  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO  " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO  " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB  " &
"       AND CISLI245.T$FIRE$L != ' '  " &
"WHERE (TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')  " & 
"   OR (TDSLS420.T$HREA IS NULL AND  " &
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"	  AND OWMS.ORDERKEY IS NULL)  " &
"             THEN 'NEN' ELSE   NULL END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = '" + Parameters!Table.Value + "'  " &
"ORDER BY NUME_FILIAL, PEDIDO_SITE                       " 
                                                         
,                                                        
                                                         
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1           FILIAL,  " &
"    wmsCODE.UDF2           DSC_PLANTA,  " &  
"    tcemm030.t$euca        NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C      PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO        PEDIDO_LN,  " &
"    OWMS.ORDERKEY          ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)  ITEM,  " &
"    TCIBD001.T$DSCA        DESCR_ITEM,  " &
"    TCIBD001.T$CITG        ID_DEPTO,  " &
"    TCMCS023.T$DSCA        DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C      ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH        M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR        M3_TOTAL,  " &
"    TDSLS401.T$QOOR        QTDE,  " &
"    MAUC.MAUC              CMV_UNIT,  " &
"    MAUC.MAUC*  " &
"    TDSLS401.T$QOOR        CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L      CNPJ,  " &
"    TCCOM130.T$NAMA        CLIENTE,  " &
"    TCMCS966.T$DSCA$L      TIPO_OPER,  " &
"    NVL(TDSLS420.T$HREA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL )  " &
"             THEN 'NEN'  " &
"           ELSE NULL END)  ID_ULT_PONTO,  " &
"    NVL(TDSLS090.T$DSCA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL)  " &
"      THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"           ELSE NULL END)  DESCR_ULT_PONTO  " &
"FROM       BAANDB.TTDSLS400301 TDSLS400  " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401  " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO  " &
"INNER JOIN BAANDB.TWHWMD400301 WHWMD400  " &
"        ON WHWMD400.T$ITEM = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001  " &
"        ON TCIBD001.T$ITEM = TDSLS401.T$ITEM  " &
" LEFT JOIN BAANDB.TTCMCS023301 TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TZNMCS030301 ZNMCS030  " &
"        ON ZNMCS030.T$CITG$C = TCIBD001.T$CITG  " &
"       AND ZNMCS030.T$SETO$C = TCIBD001.T$SETO$C  " &
" LEFT JOIN BAANDB.TTCCOM130301 TCCOM130  " &
"        ON TCCOM130.T$CADR = TDSLS400.T$OFAD  " &
" LEFT JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = TDSLS094.T$FDTC$L  " &
" LEFT JOIN ( select whwmd217.t$item item,  " &              
"             whwmd217.t$cwar cwar,  " &             
"             case when sum(nvl(whwmd217.t$mauc$1,0))=0  " &
"                    then sum(whwmd217.t$ftpa$1)  " &                                     
"  else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd),4)  " &
"                    end mauc  " &                    
"               from baandb.twhwmd217301 whwmd217  " &              
"          left join baandb.twhinr140301 a  " &              
"                 on a.t$cwar = whwmd217.t$cwar  " &                    
"                and a.t$item = whwmd217.t$item  " &                    
"           group by whwmd217.t$item,  " &                    
"                    whwmd217.t$cwar ) mauc  " &                  
"        ON mauc.cwar = TDSLS401.T$CWAR  " &       
"       AND mauc.item = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C,  " &
"                    MIN(B.T$DTAP$C) T$DTAP$C  " &
"               from BAANDB.TZNSLS004301 A  " &
"         inner join BAANDB.TZNSLS401301 B  " &
"                 on B.T$NCIA$C = A.T$NCIA$C  " &
"                and B.T$UNEG$C = A.T$UNEG$C  " &
"                and B.T$PECL$C = A.T$PECL$C  " &
"                and B.T$SQPD$C = A.T$SQPD$C  " &
"                and B.T$ENTR$C = A.T$ENTR$C  " &
"                and B.T$SEQU$C = A.T$SEQU$C  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C ) ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420  " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090  " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA  " &
"INNER JOIN BAANDB.TTCEMM124301 TCEMM124  " &
"        ON TCEMM124.T$CWOC = TDSLS400.T$COFC  " &
"INNER JOIN BAANDB.TTCEMM030301 TCEMM030  " &
"        ON TCEMM030.T$EUNT = TCEMM124.T$GRID  " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300  " &
"        ON TCEMM300.T$COMP = 301  " &
"       AND TCEMM300.T$TYPE = 20  " &
"       AND TRIM(TCEMM300.T$CODE)=TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( SELECT A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"FROM WMWHSE1.ORDERS@DL_LN_WMS B  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = 1  " &
"       AND CISLI245.T$KOOR = 3  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO  " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO  " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB  " &
"       AND CISLI245.T$FIRE$L != ' '  " &
"WHERE (TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')  " & 
"   OR (TDSLS420.T$HREA IS NULL AND  " &
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"	  AND OWMS.ORDERKEY IS NULL)  " &
"             THEN 'NEN' ELSE   NULL END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE1'  " &
"  " &
"UNION  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1           FILIAL,  " &
"    wmsCODE.UDF2           DSC_PLANTA,  " &  
"    tcemm030.t$euca        NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C      PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO        PEDIDO_LN,  " &
"    OWMS.ORDERKEY          ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)  ITEM,  " &
"    TCIBD001.T$DSCA        DESCR_ITEM,  " &
"    TCIBD001.T$CITG        ID_DEPTO,  " &
"    TCMCS023.T$DSCA        DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C      ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH        M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR        M3_TOTAL,  " &
"    TDSLS401.T$QOOR        QTDE,  " &
"    MAUC.MAUC              CMV_UNIT,  " &
"    MAUC.MAUC*  " &
"    TDSLS401.T$QOOR        CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L      CNPJ,  " &
"    TCCOM130.T$NAMA        CLIENTE,  " &
"    TCMCS966.T$DSCA$L      TIPO_OPER,  " &
"    NVL(TDSLS420.T$HREA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL )  " &
"             THEN 'NEN'  " &
"           ELSE NULL END)  ID_ULT_PONTO,  " &
"    NVL(TDSLS090.T$DSCA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL)  " &
"      THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"           ELSE NULL END)  DESCR_ULT_PONTO  " &
"FROM       BAANDB.TTDSLS400301 TDSLS400  " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401  " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO  " &
"INNER JOIN BAANDB.TWHWMD400301 WHWMD400  " &
"        ON WHWMD400.T$ITEM = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001  " &
"        ON TCIBD001.T$ITEM = TDSLS401.T$ITEM  " &
" LEFT JOIN BAANDB.TTCMCS023301 TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TZNMCS030301 ZNMCS030  " &
"        ON ZNMCS030.T$CITG$C = TCIBD001.T$CITG  " &
"       AND ZNMCS030.T$SETO$C = TCIBD001.T$SETO$C  " &
" LEFT JOIN BAANDB.TTCCOM130301 TCCOM130  " &
"        ON TCCOM130.T$CADR = TDSLS400.T$OFAD  " &
" LEFT JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = TDSLS094.T$FDTC$L  " &
" LEFT JOIN ( select whwmd217.t$item item,  " &              
"             whwmd217.t$cwar cwar,  " &             
"             case when sum(nvl(whwmd217.t$mauc$1,0))=0  " &
"                    then sum(whwmd217.t$ftpa$1)  " &                                     
"  else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd),4)  " &
"                    end mauc  " &                    
"               from baandb.twhwmd217301 whwmd217  " &              
"          left join baandb.twhinr140301 a  " &              
"                 on a.t$cwar = whwmd217.t$cwar  " &                    
"                and a.t$item = whwmd217.t$item  " &                    
"           group by whwmd217.t$item,  " &                    
"                    whwmd217.t$cwar ) mauc  " &                  
"        ON mauc.cwar = TDSLS401.T$CWAR  " &       
"       AND mauc.item = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C,  " &
"                    MIN(B.T$DTAP$C) T$DTAP$C  " &
"               from BAANDB.TZNSLS004301 A  " &
"         inner join BAANDB.TZNSLS401301 B  " &
"                 on B.T$NCIA$C = A.T$NCIA$C  " &
"                and B.T$UNEG$C = A.T$UNEG$C  " &
"                and B.T$PECL$C = A.T$PECL$C  " &
"                and B.T$SQPD$C = A.T$SQPD$C  " &
"                and B.T$ENTR$C = A.T$ENTR$C  " &
"                and B.T$SEQU$C = A.T$SEQU$C  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C ) ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420  " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090  " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA  " &
"INNER JOIN BAANDB.TTCEMM124301 TCEMM124  " &
"        ON TCEMM124.T$CWOC = TDSLS400.T$COFC  " &
"INNER JOIN BAANDB.TTCEMM030301 TCEMM030  " &
"        ON TCEMM030.T$EUNT = TCEMM124.T$GRID  " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300  " &
"        ON TCEMM300.T$COMP = 301  " &
"       AND TCEMM300.T$TYPE = 20  " &
"       AND TRIM(TCEMM300.T$CODE)=TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( SELECT A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"FROM WMWHSE2.ORDERS@DL_LN_WMS B  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = 1  " &
"       AND CISLI245.T$KOOR = 3  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO  " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO  " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB  " &
"       AND CISLI245.T$FIRE$L != ' '  " &
"WHERE (TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')  " & 
"   OR (TDSLS420.T$HREA IS NULL AND  " &
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"	  AND OWMS.ORDERKEY IS NULL)  " &
"             THEN 'NEN' ELSE   NULL END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE2'  " &
"  " &
"UNION  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1           FILIAL,  " &
"    wmsCODE.UDF2           DSC_PLANTA,  " &  
"    tcemm030.t$euca        NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C      PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO        PEDIDO_LN,  " &
"    OWMS.ORDERKEY          ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)  ITEM,  " &
"    TCIBD001.T$DSCA        DESCR_ITEM,  " &
"    TCIBD001.T$CITG        ID_DEPTO,  " &
"    TCMCS023.T$DSCA        DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C      ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH        M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR        M3_TOTAL,  " &
"    TDSLS401.T$QOOR        QTDE,  " &
"    MAUC.MAUC              CMV_UNIT,  " &
"    MAUC.MAUC*  " &
"    TDSLS401.T$QOOR        CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L      CNPJ,  " &
"    TCCOM130.T$NAMA        CLIENTE,  " &
"    TCMCS966.T$DSCA$L      TIPO_OPER,  " &
"    NVL(TDSLS420.T$HREA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL )  " &
"             THEN 'NEN'  " &
"           ELSE NULL END)  ID_ULT_PONTO,  " &
"    NVL(TDSLS090.T$DSCA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL)  " &
"      THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"           ELSE NULL END)  DESCR_ULT_PONTO  " &
"FROM       BAANDB.TTDSLS400301 TDSLS400  " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401  " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO  " &
"INNER JOIN BAANDB.TWHWMD400301 WHWMD400  " &
"        ON WHWMD400.T$ITEM = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001  " &
"        ON TCIBD001.T$ITEM = TDSLS401.T$ITEM  " &
" LEFT JOIN BAANDB.TTCMCS023301 TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TZNMCS030301 ZNMCS030  " &
"        ON ZNMCS030.T$CITG$C = TCIBD001.T$CITG  " &
"       AND ZNMCS030.T$SETO$C = TCIBD001.T$SETO$C  " &
" LEFT JOIN BAANDB.TTCCOM130301 TCCOM130  " &
"        ON TCCOM130.T$CADR = TDSLS400.T$OFAD  " &
" LEFT JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = TDSLS094.T$FDTC$L  " &
" LEFT JOIN ( select whwmd217.t$item item,  " &              
"             whwmd217.t$cwar cwar,  " &             
"             case when sum(nvl(whwmd217.t$mauc$1,0))=0  " &
"                    then sum(whwmd217.t$ftpa$1)  " &                                     
"  else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd),4)  " &
"                    end mauc  " &                    
"               from baandb.twhwmd217301 whwmd217  " &              
"          left join baandb.twhinr140301 a  " &              
"                 on a.t$cwar = whwmd217.t$cwar  " &                    
"                and a.t$item = whwmd217.t$item  " &                    
"           group by whwmd217.t$item,  " &                    
"                    whwmd217.t$cwar ) mauc  " &                  
"        ON mauc.cwar = TDSLS401.T$CWAR  " &       
"       AND mauc.item = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C,  " &
"                    MIN(B.T$DTAP$C) T$DTAP$C  " &
"               from BAANDB.TZNSLS004301 A  " &
"         inner join BAANDB.TZNSLS401301 B  " &
"                 on B.T$NCIA$C = A.T$NCIA$C  " &
"                and B.T$UNEG$C = A.T$UNEG$C  " &
"                and B.T$PECL$C = A.T$PECL$C  " &
"                and B.T$SQPD$C = A.T$SQPD$C  " &
"                and B.T$ENTR$C = A.T$ENTR$C  " &
"                and B.T$SEQU$C = A.T$SEQU$C  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C ) ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420  " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090  " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA  " &
"INNER JOIN BAANDB.TTCEMM124301 TCEMM124  " &
"        ON TCEMM124.T$CWOC = TDSLS400.T$COFC  " &
"INNER JOIN BAANDB.TTCEMM030301 TCEMM030  " &
"        ON TCEMM030.T$EUNT = TCEMM124.T$GRID  " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300  " &
"        ON TCEMM300.T$COMP = 301  " &
"       AND TCEMM300.T$TYPE = 20  " &
"       AND TRIM(TCEMM300.T$CODE)=TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( SELECT A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"FROM WMWHSE3.ORDERS@DL_LN_WMS B  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = 1  " &
"       AND CISLI245.T$KOOR = 3  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO  " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO  " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB  " &
"       AND CISLI245.T$FIRE$L != ' '  " &
"WHERE (TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')  " & 
"   OR (TDSLS420.T$HREA IS NULL AND  " &
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"	  AND OWMS.ORDERKEY IS NULL)  " &
"             THEN 'NEN' ELSE   NULL END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE3'  " &
"  " &
"UNION  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1           FILIAL,  " &
"    wmsCODE.UDF2           DSC_PLANTA,  " &  
"    tcemm030.t$euca        NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C      PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO        PEDIDO_LN,  " &
"    OWMS.ORDERKEY          ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)  ITEM,  " &
"    TCIBD001.T$DSCA        DESCR_ITEM,  " &
"    TCIBD001.T$CITG        ID_DEPTO,  " &
"    TCMCS023.T$DSCA        DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C      ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH        M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR        M3_TOTAL,  " &
"    TDSLS401.T$QOOR        QTDE,  " &
"    MAUC.MAUC              CMV_UNIT,  " &
"    MAUC.MAUC*  " &
"    TDSLS401.T$QOOR        CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L      CNPJ,  " &
"    TCCOM130.T$NAMA        CLIENTE,  " &
"    TCMCS966.T$DSCA$L      TIPO_OPER,  " &
"    NVL(TDSLS420.T$HREA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL )  " &
"             THEN 'NEN'  " &
"           ELSE NULL END)  ID_ULT_PONTO,  " &
"    NVL(TDSLS090.T$DSCA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL)  " &
"      THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"           ELSE NULL END)  DESCR_ULT_PONTO  " &
"FROM       BAANDB.TTDSLS400301 TDSLS400  " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401  " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO  " &
"INNER JOIN BAANDB.TWHWMD400301 WHWMD400  " &
"        ON WHWMD400.T$ITEM = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001  " &
"        ON TCIBD001.T$ITEM = TDSLS401.T$ITEM  " &
" LEFT JOIN BAANDB.TTCMCS023301 TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TZNMCS030301 ZNMCS030  " &
"        ON ZNMCS030.T$CITG$C = TCIBD001.T$CITG  " &
"       AND ZNMCS030.T$SETO$C = TCIBD001.T$SETO$C  " &
" LEFT JOIN BAANDB.TTCCOM130301 TCCOM130  " &
"        ON TCCOM130.T$CADR = TDSLS400.T$OFAD  " &
" LEFT JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = TDSLS094.T$FDTC$L  " &
" LEFT JOIN ( select whwmd217.t$item item,  " &              
"             whwmd217.t$cwar cwar,  " &             
"             case when sum(nvl(whwmd217.t$mauc$1,0))=0  " &
"                    then sum(whwmd217.t$ftpa$1)  " &                                     
"  else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd),4)  " &
"                    end mauc  " &                    
"               from baandb.twhwmd217301 whwmd217  " &              
"          left join baandb.twhinr140301 a  " &              
"                 on a.t$cwar = whwmd217.t$cwar  " &                    
"                and a.t$item = whwmd217.t$item  " &                    
"           group by whwmd217.t$item,  " &                    
"                    whwmd217.t$cwar ) mauc  " &                  
"        ON mauc.cwar = TDSLS401.T$CWAR  " &       
"       AND mauc.item = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C,  " &
"                    MIN(B.T$DTAP$C) T$DTAP$C  " &
"               from BAANDB.TZNSLS004301 A  " &
"         inner join BAANDB.TZNSLS401301 B  " &
"                 on B.T$NCIA$C = A.T$NCIA$C  " &
"                and B.T$UNEG$C = A.T$UNEG$C  " &
"                and B.T$PECL$C = A.T$PECL$C  " &
"                and B.T$SQPD$C = A.T$SQPD$C  " &
"                and B.T$ENTR$C = A.T$ENTR$C  " &
"                and B.T$SEQU$C = A.T$SEQU$C  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C ) ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420  " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090  " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA  " &
"INNER JOIN BAANDB.TTCEMM124301 TCEMM124  " &
"        ON TCEMM124.T$CWOC = TDSLS400.T$COFC  " &
"INNER JOIN BAANDB.TTCEMM030301 TCEMM030  " &
"        ON TCEMM030.T$EUNT = TCEMM124.T$GRID  " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300  " &
"        ON TCEMM300.T$COMP = 301  " &
"       AND TCEMM300.T$TYPE = 20  " &
"       AND TRIM(TCEMM300.T$CODE)=TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( SELECT A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"FROM WMWHSE4.ORDERS@DL_LN_WMS B  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = 1  " &
"       AND CISLI245.T$KOOR = 3  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO  " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO  " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB  " &
"       AND CISLI245.T$FIRE$L != ' '  " &
"WHERE (TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')  " & 
"   OR (TDSLS420.T$HREA IS NULL AND  " &
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"	  AND OWMS.ORDERKEY IS NULL)  " &
"             THEN 'NEN' ELSE   NULL END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE4'  " &
"  " &
"UNION  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1           FILIAL,  " &
"    wmsCODE.UDF2           DSC_PLANTA,  " &  
"    tcemm030.t$euca        NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C      PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO        PEDIDO_LN,  " &
"    OWMS.ORDERKEY          ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)  ITEM,  " &
"    TCIBD001.T$DSCA        DESCR_ITEM,  " &
"    TCIBD001.T$CITG        ID_DEPTO,  " &
"    TCMCS023.T$DSCA        DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C      ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH        M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR        M3_TOTAL,  " &
"    TDSLS401.T$QOOR        QTDE,  " &
"    MAUC.MAUC              CMV_UNIT,  " &
"    MAUC.MAUC*  " &
"    TDSLS401.T$QOOR        CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L      CNPJ,  " &
"    TCCOM130.T$NAMA        CLIENTE,  " &
"    TCMCS966.T$DSCA$L      TIPO_OPER,  " &
"    NVL(TDSLS420.T$HREA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL )  " &
"             THEN 'NEN'  " &
"           ELSE NULL END)  ID_ULT_PONTO,  " &
"    NVL(TDSLS090.T$DSCA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL)  " &
"      THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"           ELSE NULL END)  DESCR_ULT_PONTO  " &
"FROM       BAANDB.TTDSLS400301 TDSLS400  " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401  " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO  " &
"INNER JOIN BAANDB.TWHWMD400301 WHWMD400  " &
"        ON WHWMD400.T$ITEM = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001  " &
"        ON TCIBD001.T$ITEM = TDSLS401.T$ITEM  " &
" LEFT JOIN BAANDB.TTCMCS023301 TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TZNMCS030301 ZNMCS030  " &
"        ON ZNMCS030.T$CITG$C = TCIBD001.T$CITG  " &
"       AND ZNMCS030.T$SETO$C = TCIBD001.T$SETO$C  " &
" LEFT JOIN BAANDB.TTCCOM130301 TCCOM130  " &
"        ON TCCOM130.T$CADR = TDSLS400.T$OFAD  " &
" LEFT JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = TDSLS094.T$FDTC$L  " &
" LEFT JOIN ( select whwmd217.t$item item,  " &              
"             whwmd217.t$cwar cwar,  " &             
"             case when sum(nvl(whwmd217.t$mauc$1,0))=0  " &
"                    then sum(whwmd217.t$ftpa$1)  " &                                     
"  else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd),4)  " &
"                    end mauc  " &                    
"               from baandb.twhwmd217301 whwmd217  " &              
"          left join baandb.twhinr140301 a  " &              
"                 on a.t$cwar = whwmd217.t$cwar  " &                    
"                and a.t$item = whwmd217.t$item  " &                    
"           group by whwmd217.t$item,  " &                    
"                    whwmd217.t$cwar ) mauc  " &                  
"        ON mauc.cwar = TDSLS401.T$CWAR  " &       
"       AND mauc.item = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C,  " &
"                    MIN(B.T$DTAP$C) T$DTAP$C  " &
"               from BAANDB.TZNSLS004301 A  " &
"         inner join BAANDB.TZNSLS401301 B  " &
"                 on B.T$NCIA$C = A.T$NCIA$C  " &
"                and B.T$UNEG$C = A.T$UNEG$C  " &
"                and B.T$PECL$C = A.T$PECL$C  " &
"                and B.T$SQPD$C = A.T$SQPD$C  " &
"                and B.T$ENTR$C = A.T$ENTR$C  " &
"                and B.T$SEQU$C = A.T$SEQU$C  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C ) ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420  " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090  " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA  " &
"INNER JOIN BAANDB.TTCEMM124301 TCEMM124  " &
"        ON TCEMM124.T$CWOC = TDSLS400.T$COFC  " &
"INNER JOIN BAANDB.TTCEMM030301 TCEMM030  " &
"        ON TCEMM030.T$EUNT = TCEMM124.T$GRID  " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300  " &
"        ON TCEMM300.T$COMP = 301  " &
"       AND TCEMM300.T$TYPE = 20  " &
"       AND TRIM(TCEMM300.T$CODE)=TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( SELECT A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"FROM WMWHSE5.ORDERS@DL_LN_WMS B  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = 1  " &
"       AND CISLI245.T$KOOR = 3  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO  " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO  " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB  " &
"       AND CISLI245.T$FIRE$L != ' '  " &
"WHERE (TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')  " & 
"   OR (TDSLS420.T$HREA IS NULL AND  " &
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"	  AND OWMS.ORDERKEY IS NULL)  " &
"             THEN 'NEN' ELSE   NULL END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE5'  " &
"  " &
"UNION  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1           FILIAL,  " &
"    wmsCODE.UDF2           DSC_PLANTA,  " &  
"    tcemm030.t$euca        NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C      PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO        PEDIDO_LN,  " &
"    OWMS.ORDERKEY          ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)  ITEM,  " &
"    TCIBD001.T$DSCA        DESCR_ITEM,  " &
"    TCIBD001.T$CITG        ID_DEPTO,  " &
"    TCMCS023.T$DSCA        DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C      ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH        M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR        M3_TOTAL,  " &
"    TDSLS401.T$QOOR        QTDE,  " &
"    MAUC.MAUC              CMV_UNIT,  " &
"    MAUC.MAUC*  " &
"    TDSLS401.T$QOOR        CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L      CNPJ,  " &
"    TCCOM130.T$NAMA        CLIENTE,  " &
"    TCMCS966.T$DSCA$L      TIPO_OPER,  " &
"    NVL(TDSLS420.T$HREA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL )  " &
"             THEN 'NEN'  " &
"           ELSE NULL END)  ID_ULT_PONTO,  " &
"    NVL(TDSLS090.T$DSCA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL)  " &
"      THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"           ELSE NULL END)  DESCR_ULT_PONTO  " &
"FROM       BAANDB.TTDSLS400301 TDSLS400  " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401  " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO  " &
"INNER JOIN BAANDB.TWHWMD400301 WHWMD400  " &
"        ON WHWMD400.T$ITEM = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001  " &
"        ON TCIBD001.T$ITEM = TDSLS401.T$ITEM  " &
" LEFT JOIN BAANDB.TTCMCS023301 TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TZNMCS030301 ZNMCS030  " &
"        ON ZNMCS030.T$CITG$C = TCIBD001.T$CITG  " &
"       AND ZNMCS030.T$SETO$C = TCIBD001.T$SETO$C  " &
" LEFT JOIN BAANDB.TTCCOM130301 TCCOM130  " &
"        ON TCCOM130.T$CADR = TDSLS400.T$OFAD  " &
" LEFT JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = TDSLS094.T$FDTC$L  " &
" LEFT JOIN ( select whwmd217.t$item item,  " &              
"             whwmd217.t$cwar cwar,  " &             
"             case when sum(nvl(whwmd217.t$mauc$1,0))=0  " &
"                    then sum(whwmd217.t$ftpa$1)  " &                                     
"  else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd),4)  " &
"                    end mauc  " &                    
"               from baandb.twhwmd217301 whwmd217  " &              
"          left join baandb.twhinr140301 a  " &              
"                 on a.t$cwar = whwmd217.t$cwar  " &                    
"                and a.t$item = whwmd217.t$item  " &                    
"           group by whwmd217.t$item,  " &                    
"                    whwmd217.t$cwar ) mauc  " &                  
"        ON mauc.cwar = TDSLS401.T$CWAR  " &       
"       AND mauc.item = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C,  " &
"                    MIN(B.T$DTAP$C) T$DTAP$C  " &
"               from BAANDB.TZNSLS004301 A  " &
"         inner join BAANDB.TZNSLS401301 B  " &
"                 on B.T$NCIA$C = A.T$NCIA$C  " &
"                and B.T$UNEG$C = A.T$UNEG$C  " &
"                and B.T$PECL$C = A.T$PECL$C  " &
"                and B.T$SQPD$C = A.T$SQPD$C  " &
"                and B.T$ENTR$C = A.T$ENTR$C  " &
"                and B.T$SEQU$C = A.T$SEQU$C  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C ) ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420  " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090  " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA  " &
"INNER JOIN BAANDB.TTCEMM124301 TCEMM124  " &
"        ON TCEMM124.T$CWOC = TDSLS400.T$COFC  " &
"INNER JOIN BAANDB.TTCEMM030301 TCEMM030  " &
"        ON TCEMM030.T$EUNT = TCEMM124.T$GRID  " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300  " &
"        ON TCEMM300.T$COMP = 301  " &
"       AND TCEMM300.T$TYPE = 20  " &
"       AND TRIM(TCEMM300.T$CODE)=TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( SELECT A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"FROM WMWHSE6.ORDERS@DL_LN_WMS B  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = 1  " &
"       AND CISLI245.T$KOOR = 3  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO  " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO  " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB  " &
"       AND CISLI245.T$FIRE$L != ' '  " &
"WHERE (TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')  " & 
"   OR (TDSLS420.T$HREA IS NULL AND  " &
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"	  AND OWMS.ORDERKEY IS NULL)  " &
"             THEN 'NEN' ELSE   NULL END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE6'  " &
"  " &
"UNION  " &
"  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1           FILIAL,  " &
"    wmsCODE.UDF2           DSC_PLANTA,  " &  
"    tcemm030.t$euca        NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C      PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO        PEDIDO_LN,  " &
"    OWMS.ORDERKEY          ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)  ITEM,  " &
"    TCIBD001.T$DSCA        DESCR_ITEM,  " &
"    TCIBD001.T$CITG        ID_DEPTO,  " &
"    TCMCS023.T$DSCA        DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C      ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH        M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR        M3_TOTAL,  " &
"    TDSLS401.T$QOOR        QTDE,  " &
"    MAUC.MAUC              CMV_UNIT,  " &
"    MAUC.MAUC*  " &
"    TDSLS401.T$QOOR        CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L      CNPJ,  " &
"    TCCOM130.T$NAMA        CLIENTE,  " &
"    TCMCS966.T$DSCA$L      TIPO_OPER,  " &
"    NVL(TDSLS420.T$HREA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL )  " &
"             THEN 'NEN'  " &
"           ELSE NULL END)  ID_ULT_PONTO,  " &
"    NVL(TDSLS090.T$DSCA,  " &
"      CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"                  AND OWMS.ORDERKEY IS NULL)  " &
"      THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"           ELSE NULL END)  DESCR_ULT_PONTO  " &
"FROM       BAANDB.TTDSLS400301 TDSLS400  " &
"INNER JOIN BAANDB.TTDSLS401301 TDSLS401  " &
"        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO  " &
"INNER JOIN BAANDB.TWHWMD400301 WHWMD400  " &
"        ON WHWMD400.T$ITEM = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTCIBD001301 TCIBD001  " &
"        ON TCIBD001.T$ITEM = TDSLS401.T$ITEM  " &
" LEFT JOIN BAANDB.TTCMCS023301 TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TZNMCS030301 ZNMCS030  " &
"        ON ZNMCS030.T$CITG$C = TCIBD001.T$CITG  " &
"       AND ZNMCS030.T$SETO$C = TCIBD001.T$SETO$C  " &
" LEFT JOIN BAANDB.TTCCOM130301 TCCOM130  " &
"        ON TCCOM130.T$CADR = TDSLS400.T$OFAD  " &
" LEFT JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = TDSLS094.T$FDTC$L  " &
" LEFT JOIN ( select whwmd217.t$item item,  " &              
"             whwmd217.t$cwar cwar,  " &             
"             case when sum(nvl(whwmd217.t$mauc$1,0))=0  " &
"                    then sum(whwmd217.t$ftpa$1)  " &                                     
"  else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd),4)  " &
"                    end mauc  " &                    
"               from baandb.twhwmd217301 whwmd217  " &              
"          left join baandb.twhinr140301 a  " &              
"                 on a.t$cwar = whwmd217.t$cwar  " &                    
"                and a.t$item = whwmd217.t$item  " &                    
"           group by whwmd217.t$item,  " &                    
"                    whwmd217.t$cwar ) mauc  " &                  
"        ON mauc.cwar = TDSLS401.T$CWAR  " &       
"       AND mauc.item = TDSLS401.T$ITEM  " &
"INNER JOIN BAANDB.TTDSLS094301 TDSLS094  " &
"        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C,  " &
"                    MIN(B.T$DTAP$C) T$DTAP$C  " &
"               from BAANDB.TZNSLS004301 A  " &
"         inner join BAANDB.TZNSLS401301 B  " &
"                 on B.T$NCIA$C = A.T$NCIA$C  " &
"                and B.T$UNEG$C = A.T$UNEG$C  " &
"                and B.T$PECL$C = A.T$PECL$C  " &
"                and B.T$SQPD$C = A.T$SQPD$C  " &
"                and B.T$ENTR$C = A.T$ENTR$C  " &
"                and B.T$SEQU$C = A.T$SEQU$C  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    A.T$ORNO$C,  " &
"                    B.T$ITEM$C,  " &
"                    B.T$CWRL$C ) ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS420301 TDSLS420  " &
"        ON TDSLS420.T$ORNO = TDSLS401.T$ORNO  " &
" LEFT JOIN BAANDB.TTDSLS090301 TDSLS090  " &
"        ON TDSLS090.T$HREA = TDSLS420.T$HREA  " &
"INNER JOIN BAANDB.TTCEMM124301 TCEMM124  " &
"        ON TCEMM124.T$CWOC = TDSLS400.T$COFC  " &
"INNER JOIN BAANDB.TTCEMM030301 TCEMM030  " &
"        ON TCEMM030.T$EUNT = TCEMM124.T$GRID  " &
"INNER JOIN BAANDB.TTCEMM300301 TCEMM300  " &
"        ON TCEMM300.T$COMP = 301  " &
"       AND TCEMM300.T$TYPE = 20  " &
"       AND TRIM(TCEMM300.T$CODE)=TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( SELECT A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              WHERE A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( SELECT MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"FROM WMWHSE7.ORDERS@DL_LN_WMS B  " &
"           GROUP BY B.REFERENCEDOCUMENT ) OWMS  " &
"        ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO  " &
" LEFT JOIN BAANDB.TCISLI245301 CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = 1  " &
"       AND CISLI245.T$KOOR = 3  " &
"       AND CISLI245.T$SLSO = TDSLS401.T$ORNO  " &
"       AND CISLI245.T$PONO = TDSLS401.T$PONO  " &
"       AND CISLI245.T$SQNB = TDSLS401.T$SQNB  " &
"       AND CISLI245.T$FIRE$L != ' '  " &
"WHERE (TDSLS420.T$HREA IN ('AES', 'PRD', 'TNA', 'AEW')  " & 
"   OR (TDSLS420.T$HREA IS NULL AND  " &
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL  " &
"	  AND OWMS.ORDERKEY IS NULL)  " &
"             THEN 'NEN' ELSE   NULL END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE7'  " &
"ORDER BY NUME_FILIAL, PEDIDO_SITE                       "
)