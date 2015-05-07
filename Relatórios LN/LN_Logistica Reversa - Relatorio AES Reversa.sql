SELECT 
  DISTINCT
    wmsCODE.UDF1                            FILIAL,
    wmsCODE.UDF2                            DSC_PLANTA,
    tcemm030.t$euca                         NUME_FILIAL, 
    ZNSLS004.T$PECL$C                       PEDIDO_SITE,
    TDSLS400.T$ORNO                         PEDIDO_LN,
    OWMS.ORDERKEY                           ORDEM_WMS,
    TRIM(TCIBD001.T$ITEM)                   ITEM,     
    TCIBD001.T$DSCA                         DESCR_ITEM,
    TCIBD001.T$CITG                         ID_DEPTO,
    TCMCS023.T$DSCA                         DESCR_DEPTO,
    TCIBD001.T$SETO$C                       ID_SETOR,
    WHWMD400.T$HGHT *
    WHWMD400.T$WDTH *
    WHWMD400.T$DPTH                         M3_UNI,
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
           ELSE NULL END)  DESCR_ULT_PONTO,
     NVL((SELECT 
			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(A.T$DTBL), 
			'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE)
		 FROM BAANDB.TTDSLS421301 A
		 WHERE A.T$ORNO = TDSLS420.T$ORNO
          AND A.T$PONO = TDSLS420.T$PONO
          AND A.T$SQNB = TDSLS420.T$SQNB
          AND A.T$CSQN = TDSLS420.T$CSQN
          AND A.T$HREA = TDSLS420.T$HREA ), TDSLS400.T$ODAT)	DATA_ULTIMO_PONTO

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
	   
INNER JOIN ( select A.LONG_VALUE,
                    UPPER(A.UDF1) UDF1,
                    A.UDF2
               from ENTERPRISE.CODELKUP@DL_LN_WMS A
              where A.LISTNAME = 'SCHEMA') wmsCODE
        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN
		
 LEFT JOIN ( select MAX(B.ORDERKEY) ORDERKEY,
                    B.REFERENCEDOCUMENT
               from WMWHSE5.ORDERS@DL_LN_WMS B
           group by B.REFERENCEDOCUMENT ) OWMS 
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
              THEN 'NEN' ELSE
            NULL 
        END = 'NEN' )))
  AND TDSLS400.T$HDST NOT IN (30, 35)
  AND TDSLS094.T$RETO = 2
  AND TDSLS401.T$CLYN = 2
  AND wmsCODE.UDF1 = 'WMWHSE5'
  
--ORDER BY NUME_FILIAL, PEDIDO_SITE 

------------------------------------------------------------------------------------------------------------------
--		ORDENS DE ARMAZEM
------------------------------------------------------------------------------------------------------------------

UNION
SELECT DISTINCT
		wmsCODE.UDF1							FILIAL,
		wmsCODE.UDF2							DSC_PLANTA,
		tcemm030.t$euca                         NUME_FILIAL,		
		NULL                    				PEDIDO_SITE,
		WHINH200.T$ORNO							PEDIDO_LN,
		NULL                        			ORDEM_WMS,
		TRIM(WHINH220.T$ITEM)              		ITEM, 
		TCIBD001.T$DSCA                         DESCR_ITEM,		
		TCIBD001.T$CITG                         ID_DEPTO,
		TCMCS023.T$DSCA                         DESCR_DEPTO,
		TCIBD001.T$SETO$C                       ID_SETOR,
		WHWMD400.T$HGHT *
		WHWMD400.T$WDTH *
		WHWMD400.T$DPTH                         M3_UNI,	
		WHWMD400.T$HGHT *
		WHWMD400.T$WDTH *
		WHWMD400.T$DPTH *  
		WHINH220.T$QORD       	 				M3_TOTAL,
		WHINH220.T$QORD							QTDE,
		MAUC.MAUC              					CMV_UNIT,
		MAUC.MAUC*
		WHINH220.T$QORD	        				CMV_TOTAL,	
		TCCOM130.T$FOVN$L      					CNPJ,
		TCCOM130.T$NAMA        					CLIENTE,
		TCMCS966.T$DSCA$L      					TIPO_OPER,
		'NEN' 									ID_ULT_PONTO,
		'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA' DESCR_ULT_PONTO,

		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WHINH200.T$ODAT, 
			'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE)		
												DATA_ULTIMO_PONTO
		
FROM		BAANDB.TWHINH200301	WHINH200
INNER JOIN	BAANDB.TWHINH220301	WHINH220	ON	WHINH220.T$OORG	=	WHINH200.T$OORG
											AND	WHINH220.T$ORNO	=	WHINH200.T$ORNO

INNER JOIN BAANDB.TTCIBD001301 TCIBD001
        ON TCIBD001.T$ITEM = WHINH220.T$ITEM
		
 LEFT JOIN BAANDB.TTCMCS023301 TCMCS023
        ON TCMCS023.T$CITG = TCIBD001.T$CITG  
		
 LEFT JOIN BAANDB.TZNMCS030301 ZNMCS030
        ON ZNMCS030.T$CITG$C = TCIBD001.T$CITG
       AND ZNMCS030.T$SETO$C = TCIBD001.T$SETO$C											
											
INNER JOIN BAANDB.TWHWMD400301 WHWMD400
        ON WHWMD400.T$ITEM = WHINH220.T$ITEM      
											
INNER JOIN BAANDB.TTCEMM300301 TCEMM300
        ON TCEMM300.T$COMP = 301
       AND TCEMM300.T$TYPE = 20
       AND TRIM(TCEMM300.T$CODE) = TRIM(WHINH220.T$CWAR)
 
INNER JOIN ( SELECT A.LONG_VALUE,
                    UPPER(A.UDF1) UDF1,
                    A.UDF2
               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A
              WHERE A.LISTNAME = 'SCHEMA') wmsCODE
        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN

INNER JOIN BAANDB.TTCEMM112301 TCEMM112
		ON	TCEMM112.T$LOCO	=	301
		AND	TCEMM112.T$WAID	=	WHINH220.T$CWAR
		
INNER JOIN BAANDB.TTCEMM030301 TCEMM030
        ON TCEMM030.T$EUNT = TCEMM112.T$GRID  

 LEFT JOIN BAANDB.TTCCOM130301 TCCOM130
        ON TCCOM130.T$CADR = WHINH200.T$STAD
		
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
        ON mauc.cwar = WHINH220.T$CWAR                         
       AND mauc.item = WHINH220.T$ITEM  

 LEFT JOIN BAANDB.TTCMCS966301 TCMCS966
        ON TCMCS966.T$FDTC$L = WHINH200.T$FDTC$L
		
LEFT JOIN
				(	Select 3 koor, 1 oorg From DUAL
					Union Select 7 koor, 2 oorg From DUAL
					Union Select 34 koor, 3 oorg From DUAL
					Union Select 2 koor, 80 oorg From DUAL
					Union Select 6 koor, 81 oorg From DUAL
					Union Select 33 koor, 82 oorg From DUAL
					Union Select 17 koor, 11 oorg From DUAL
					Union Select 35 koor, 12 oorg From DUAL
					Union Select 37 koor, 31 oorg From DUAL
					Union Select 39 koor, 32 oorg From DUAL
					Union Select 38 koor, 33 oorg From DUAL
					Union Select 42 koor, 34 oorg From DUAL
					Union Select 1 koor, 50 oorg From DUAL
					Union Select 32 koor, 51 oorg From DUAL
					Union Select 56 koor, 53 oorg From DUAL
					Union Select 9 koor, 55 oorg From DUAL
					Union Select 46 koor, 56 oorg From DUAL
					Union Select 57 koor, 58 oorg From DUAL
					Union Select 22 koor, 71 oorg From DUAL
					Union Select 36 koor, 72 oorg From DUAL
					Union Select 58 koor, 75 oorg From DUAL
					Union Select 59 koor, 76 oorg From DUAL
					Union Select 60 koor, 90 oorg From DUAL
					Union Select 21 koor, 61 oorg From DUAL) KOOR2OORG
											ON	KOOR2OORG.OORG = WHINH200.T$OORG
                      
LEFT JOIN	BAANDB.TCISLI245301 CISLI245	ON	CISLI245.T$SLCP	=	301
											AND	CISLI245.T$ORTP	=	2
											AND	CISLI245.T$KOOR	=	KOOR2OORG.KOOR
											AND	CISLI245.T$SLSO	=	WHINH220.T$ORNO
											AND	CISLI245.T$OSET	=	WHINH200.T$OSET
											AND	CISLI245.T$PONO =	WHINH220.T$PONO

WHERE		WHINH220.T$WMSS	=	10
		AND	CISLI245.T$FIRE$L 	IS NULL
		AND WHINH200.T$OORG != 	1

=IIF(Parameters!Table.Value <> "AAA",                         

"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1                            FILIAL,  " &
"    wmsCODE.UDF2                            DSC_PLANTA,  " &
"    tcemm030.t$euca                         NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C                       PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO                         PEDIDO_LN,  " &
"    OWMS.ORDERKEY                           ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)                   ITEM,  " &
"    TCIBD001.T$DSCA                         DESCR_ITEM,  " &
"    TCIBD001.T$CITG                         ID_DEPTO,  " &
"    TCMCS023.T$DSCA                         DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C                       ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH                         M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR                         M3_TOTAL,  " &
"    TDSLS401.T$QOOR                         QTDE,  " &
"    MAUC.MAUC                               CMV_UNIT,  " &
"    MAUC.MAUC *  " &
"    TDSLS401.T$QOOR                         CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L                       CNPJ,  " &
"    TCCOM130.T$NAMA                         CLIENTE,  " &
"    TCMCS966.T$DSCA$L                       TIPO_OPER,  " &
"    NVL( TDSLS420.T$HREA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL )  " &
"                THEN 'NEN'  " &
"              ELSE   NULL  " &
"          END )                             ID_ULT_PONTO,  " &
"    NVL( TDSLS090.T$DSCA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL)  " &
"                THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"              ELSE   NULL  " &
"          END )                             DESCR_ULT_PONTO,  " &
"     ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(A.T$DTBL),  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"         FROM BAANDB.TTDSLS421301 A  " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO  " &
"          AND A.T$PONO = TDSLS420.T$PONO  " &
"          AND A.T$SQNB = TDSLS420.T$SQNB  " &
"          AND A.T$CSQN = TDSLS420.T$CSQN  " &
"          AND A.T$HREA = TDSLS420.T$HREA )  DATA_ULTIMO_PONTO  " &
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
"                    whwmd217.t$cwar cwar,  " &
"                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &         
"                           then sum(whwmd217.t$ftpa$1)  " &                 
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
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
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( select MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"               from " + Parameters!Table.Value + ".ORDERS@DL_LN_WMS B  " &
"           group by B.REFERENCEDOCUMENT ) OWMS  " &
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
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)  " &
"              THEN 'NEN' ELSE  " &
"            NULL  " &
"        END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = '" + Parameters!Table.Value + "'  " &
"ORDER BY NUME_FILIAL, PEDIDO_SITE  " 
                                                         
,                                                        
                                                         
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1                            FILIAL,  " &
"    wmsCODE.UDF2                            DSC_PLANTA,  " &
"    tcemm030.t$euca                         NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C                       PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO                         PEDIDO_LN,  " &
"    OWMS.ORDERKEY                           ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)                   ITEM,  " &
"    TCIBD001.T$DSCA                         DESCR_ITEM,  " &
"    TCIBD001.T$CITG                         ID_DEPTO,  " &
"    TCMCS023.T$DSCA                         DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C                       ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH                         M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR                         M3_TOTAL,  " &
"    TDSLS401.T$QOOR                         QTDE,  " &
"    MAUC.MAUC                               CMV_UNIT,  " &
"    MAUC.MAUC *  " &
"    TDSLS401.T$QOOR                         CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L                       CNPJ,  " &
"    TCCOM130.T$NAMA                         CLIENTE,  " &
"    TCMCS966.T$DSCA$L                       TIPO_OPER,  " &
"    NVL( TDSLS420.T$HREA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL )  " &
"                THEN 'NEN'  " &
"              ELSE   NULL  " &
"          END )                             ID_ULT_PONTO,  " &
"    NVL( TDSLS090.T$DSCA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL)  " &
"                THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"              ELSE   NULL  " &
"          END )                             DESCR_ULT_PONTO,  " &
"     ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(A.T$DTBL),  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"         FROM BAANDB.TTDSLS421301 A  " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO  " &
"          AND A.T$PONO = TDSLS420.T$PONO  " &
"          AND A.T$SQNB = TDSLS420.T$SQNB  " &
"          AND A.T$CSQN = TDSLS420.T$CSQN  " &
"          AND A.T$HREA = TDSLS420.T$HREA )  DATA_ULTIMO_PONTO  " &
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
"                    whwmd217.t$cwar cwar,  " &
"                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &         
"                           then sum(whwmd217.t$ftpa$1)  " &                 
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
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
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( select MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"               from WMWHSE1.ORDERS@DL_LN_WMS B  " &
"           group by B.REFERENCEDOCUMENT ) OWMS  " &
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
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)  " &
"              THEN 'NEN' ELSE  " &
"            NULL  " &
"        END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE1'  " &
"Union  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1                            FILIAL,  " &
"    wmsCODE.UDF2                            DSC_PLANTA,  " &
"    tcemm030.t$euca                         NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C                       PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO                         PEDIDO_LN,  " &
"    OWMS.ORDERKEY                           ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)                   ITEM,  " &
"    TCIBD001.T$DSCA                         DESCR_ITEM,  " &
"    TCIBD001.T$CITG                         ID_DEPTO,  " &
"    TCMCS023.T$DSCA                         DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C                       ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH                         M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR                         M3_TOTAL,  " &
"    TDSLS401.T$QOOR                         QTDE,  " &
"    MAUC.MAUC                               CMV_UNIT,  " &
"    MAUC.MAUC *  " &
"    TDSLS401.T$QOOR                         CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L                       CNPJ,  " &
"    TCCOM130.T$NAMA                         CLIENTE,  " &
"    TCMCS966.T$DSCA$L                       TIPO_OPER,  " &
"    NVL( TDSLS420.T$HREA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL )  " &
"                THEN 'NEN'  " &
"              ELSE   NULL  " &
"          END )                             ID_ULT_PONTO,  " &
"    NVL( TDSLS090.T$DSCA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL)  " &
"                THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"              ELSE   NULL  " &
"          END )                             DESCR_ULT_PONTO,  " &
"     ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(A.T$DTBL),  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"         FROM BAANDB.TTDSLS421301 A  " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO  " &
"          AND A.T$PONO = TDSLS420.T$PONO  " &
"          AND A.T$SQNB = TDSLS420.T$SQNB  " &
"          AND A.T$CSQN = TDSLS420.T$CSQN  " &
"          AND A.T$HREA = TDSLS420.T$HREA )  DATA_ULTIMO_PONTO  " &
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
"                    whwmd217.t$cwar cwar,  " &
"                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &         
"                           then sum(whwmd217.t$ftpa$1)  " &                 
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
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
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( select MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"               from WMWHSE2.ORDERS@DL_LN_WMS B  " &
"           group by B.REFERENCEDOCUMENT ) OWMS  " &
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
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)  " &
"              THEN 'NEN' ELSE  " &
"            NULL  " &
"        END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE2'  " &
"Union  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1                            FILIAL,  " &
"    wmsCODE.UDF2                            DSC_PLANTA,  " &
"    tcemm030.t$euca                         NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C                       PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO                         PEDIDO_LN,  " &
"    OWMS.ORDERKEY                           ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)                   ITEM,  " &
"    TCIBD001.T$DSCA                         DESCR_ITEM,  " &
"    TCIBD001.T$CITG                         ID_DEPTO,  " &
"    TCMCS023.T$DSCA                         DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C                       ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH                         M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR                         M3_TOTAL,  " &
"    TDSLS401.T$QOOR                         QTDE,  " &
"    MAUC.MAUC                               CMV_UNIT,  " &
"    MAUC.MAUC *  " &
"    TDSLS401.T$QOOR                         CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L                       CNPJ,  " &
"    TCCOM130.T$NAMA                         CLIENTE,  " &
"    TCMCS966.T$DSCA$L                       TIPO_OPER,  " &
"    NVL( TDSLS420.T$HREA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL )  " &
"                THEN 'NEN'  " &
"              ELSE   NULL  " &
"          END )                             ID_ULT_PONTO,  " &
"    NVL( TDSLS090.T$DSCA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL)  " &
"                THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"              ELSE   NULL  " &
"          END )                             DESCR_ULT_PONTO,  " &
"     ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(A.T$DTBL),  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"         FROM BAANDB.TTDSLS421301 A  " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO  " &
"          AND A.T$PONO = TDSLS420.T$PONO  " &
"          AND A.T$SQNB = TDSLS420.T$SQNB  " &
"          AND A.T$CSQN = TDSLS420.T$CSQN  " &
"          AND A.T$HREA = TDSLS420.T$HREA )  DATA_ULTIMO_PONTO  " &
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
"                    whwmd217.t$cwar cwar,  " &
"                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &         
"                           then sum(whwmd217.t$ftpa$1)  " &                 
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
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
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( select MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"               from WMWHSE3.ORDERS@DL_LN_WMS B  " &
"           group by B.REFERENCEDOCUMENT ) OWMS  " &
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
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)  " &
"              THEN 'NEN' ELSE  " &
"            NULL  " &
"        END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE3'  " &
"Union  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1                            FILIAL,  " &
"    wmsCODE.UDF2                            DSC_PLANTA,  " &
"    tcemm030.t$euca                         NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C                       PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO                         PEDIDO_LN,  " &
"    OWMS.ORDERKEY                           ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)                   ITEM,  " &
"    TCIBD001.T$DSCA                         DESCR_ITEM,  " &
"    TCIBD001.T$CITG                         ID_DEPTO,  " &
"    TCMCS023.T$DSCA                         DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C                       ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH                         M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR                         M3_TOTAL,  " &
"    TDSLS401.T$QOOR                         QTDE,  " &
"    MAUC.MAUC                               CMV_UNIT,  " &
"    MAUC.MAUC *  " &
"    TDSLS401.T$QOOR                         CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L                       CNPJ,  " &
"    TCCOM130.T$NAMA                         CLIENTE,  " &
"    TCMCS966.T$DSCA$L                       TIPO_OPER,  " &
"    NVL( TDSLS420.T$HREA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL )  " &
"                THEN 'NEN'  " &
"              ELSE   NULL  " &
"          END )                             ID_ULT_PONTO,  " &
"    NVL( TDSLS090.T$DSCA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL)  " &
"                THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"              ELSE   NULL  " &
"          END )                             DESCR_ULT_PONTO,  " &
"     ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(A.T$DTBL),  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"         FROM BAANDB.TTDSLS421301 A  " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO  " &
"          AND A.T$PONO = TDSLS420.T$PONO  " &
"          AND A.T$SQNB = TDSLS420.T$SQNB  " &
"          AND A.T$CSQN = TDSLS420.T$CSQN  " &
"          AND A.T$HREA = TDSLS420.T$HREA )  DATA_ULTIMO_PONTO  " &
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
"                    whwmd217.t$cwar cwar,  " &
"                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &         
"                           then sum(whwmd217.t$ftpa$1)  " &                 
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
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
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( select MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"               from WMWHSE4.ORDERS@DL_LN_WMS B  " &
"           group by B.REFERENCEDOCUMENT ) OWMS  " &
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
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)  " &
"              THEN 'NEN' ELSE  " &
"            NULL  " &
"        END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE4'  " &
"Union  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1                            FILIAL,  " &
"    wmsCODE.UDF2                            DSC_PLANTA,  " &
"    tcemm030.t$euca                         NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C                       PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO                         PEDIDO_LN,  " &
"    OWMS.ORDERKEY                           ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)                   ITEM,  " &
"    TCIBD001.T$DSCA                         DESCR_ITEM,  " &
"    TCIBD001.T$CITG                         ID_DEPTO,  " &
"    TCMCS023.T$DSCA                         DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C                       ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH                         M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR                         M3_TOTAL,  " &
"    TDSLS401.T$QOOR                         QTDE,  " &
"    MAUC.MAUC                               CMV_UNIT,  " &
"    MAUC.MAUC *  " &
"    TDSLS401.T$QOOR                         CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L                       CNPJ,  " &
"    TCCOM130.T$NAMA                         CLIENTE,  " &
"    TCMCS966.T$DSCA$L                       TIPO_OPER,  " &
"    NVL( TDSLS420.T$HREA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL )  " &
"                THEN 'NEN'  " &
"              ELSE   NULL  " &
"          END )                             ID_ULT_PONTO,  " &
"    NVL( TDSLS090.T$DSCA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL)  " &
"                THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"              ELSE   NULL  " &
"          END )                             DESCR_ULT_PONTO,  " &
"     ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(A.T$DTBL),  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"         FROM BAANDB.TTDSLS421301 A  " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO  " &
"          AND A.T$PONO = TDSLS420.T$PONO  " &
"          AND A.T$SQNB = TDSLS420.T$SQNB  " &
"          AND A.T$CSQN = TDSLS420.T$CSQN  " &
"          AND A.T$HREA = TDSLS420.T$HREA )  DATA_ULTIMO_PONTO  " &
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
"                    whwmd217.t$cwar cwar,  " &
"                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &         
"                           then sum(whwmd217.t$ftpa$1)  " &                 
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
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
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( select MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"               from WMWHSE5.ORDERS@DL_LN_WMS B  " &
"           group by B.REFERENCEDOCUMENT ) OWMS  " &
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
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)  " &
"              THEN 'NEN' ELSE  " &
"            NULL  " &
"        END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE5'  " &
"Union  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1                            FILIAL,  " &
"    wmsCODE.UDF2                            DSC_PLANTA,  " &
"    tcemm030.t$euca                         NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C                       PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO                         PEDIDO_LN,  " &
"    OWMS.ORDERKEY                           ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)                   ITEM,  " &
"    TCIBD001.T$DSCA                         DESCR_ITEM,  " &
"    TCIBD001.T$CITG                         ID_DEPTO,  " &
"    TCMCS023.T$DSCA                         DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C                       ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH                         M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR                         M3_TOTAL,  " &
"    TDSLS401.T$QOOR                         QTDE,  " &
"    MAUC.MAUC                               CMV_UNIT,  " &
"    MAUC.MAUC *  " &
"    TDSLS401.T$QOOR                         CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L                       CNPJ,  " &
"    TCCOM130.T$NAMA                         CLIENTE,  " &
"    TCMCS966.T$DSCA$L                       TIPO_OPER,  " &
"    NVL( TDSLS420.T$HREA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL )  " &
"                THEN 'NEN'  " &
"              ELSE   NULL  " &
"          END )                             ID_ULT_PONTO,  " &
"    NVL( TDSLS090.T$DSCA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL)  " &
"                THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"              ELSE   NULL  " &
"          END )                             DESCR_ULT_PONTO,  " &
"     ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(A.T$DTBL),  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"         FROM BAANDB.TTDSLS421301 A  " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO  " &
"          AND A.T$PONO = TDSLS420.T$PONO  " &
"          AND A.T$SQNB = TDSLS420.T$SQNB  " &
"          AND A.T$CSQN = TDSLS420.T$CSQN  " &
"          AND A.T$HREA = TDSLS420.T$HREA )  DATA_ULTIMO_PONTO  " &
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
"                    whwmd217.t$cwar cwar,  " &
"                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &         
"                           then sum(whwmd217.t$ftpa$1)  " &                 
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
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
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( select MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"               from WMWHSE6.ORDERS@DL_LN_WMS B  " &
"           group by B.REFERENCEDOCUMENT ) OWMS  " &
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
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)  " &
"              THEN 'NEN' ELSE  " &
"            NULL  " &
"        END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE6'  " &
"Union  " &
"SELECT  " &
"  DISTINCT  " &
"    wmsCODE.UDF1                            FILIAL,  " &
"    wmsCODE.UDF2                            DSC_PLANTA,  " &
"    tcemm030.t$euca                         NUME_FILIAL,  " &
"    ZNSLS004.T$PECL$C                       PEDIDO_SITE,  " &
"    TDSLS400.T$ORNO                         PEDIDO_LN,  " &
"    OWMS.ORDERKEY                           ORDEM_WMS,  " &
"    TRIM(TCIBD001.T$ITEM)                   ITEM,  " &
"    TCIBD001.T$DSCA                         DESCR_ITEM,  " &
"    TCIBD001.T$CITG                         ID_DEPTO,  " &
"    TCMCS023.T$DSCA                         DESCR_DEPTO,  " &
"    TCIBD001.T$SETO$C                       ID_SETOR,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH                         M3_UNI,  " &
"    WHWMD400.T$HGHT *  " &
"    WHWMD400.T$WDTH *  " &
"    WHWMD400.T$DPTH *  " &
"    TDSLS401.T$QOOR                         M3_TOTAL,  " &
"    TDSLS401.T$QOOR                         QTDE,  " &
"    MAUC.MAUC                               CMV_UNIT,  " &
"    MAUC.MAUC *  " &
"    TDSLS401.T$QOOR                         CMV_TOTAL,  " &
"    TCCOM130.T$FOVN$L                       CNPJ,  " &
"    TCCOM130.T$NAMA                         CLIENTE,  " &
"    TCMCS966.T$DSCA$L                       TIPO_OPER,  " &
"    NVL( TDSLS420.T$HREA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL )  " &
"                THEN 'NEN'  " &
"              ELSE   NULL  " &
"          END )                             ID_ULT_PONTO,  " &
"    NVL( TDSLS090.T$DSCA,  " &
"         CASE WHEN (    CISLI245.T$FIRE$L IS NULL  " &
"                    AND OWMS.ORDERKEY IS NULL)  " &
"                THEN 'NÃO ENVIADO PARA WMS E NF NÃO EMITIDA'  " &
"              ELSE   NULL  " &
"          END )                             DESCR_ULT_PONTO,  " &
"     ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(A.T$DTBL),  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"         FROM BAANDB.TTDSLS421301 A  " &
"        WHERE A.T$ORNO = TDSLS420.T$ORNO  " &
"          AND A.T$PONO = TDSLS420.T$PONO  " &
"          AND A.T$SQNB = TDSLS420.T$SQNB  " &
"          AND A.T$CSQN = TDSLS420.T$CSQN  " &
"          AND A.T$HREA = TDSLS420.T$HREA )  DATA_ULTIMO_PONTO  " &
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
"                    whwmd217.t$cwar cwar,  " &
"                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &         
"                           then sum(whwmd217.t$ftpa$1)  " &                 
"                         else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
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
"       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN  " &
" LEFT JOIN ( select MAX(B.ORDERKEY) ORDERKEY,  " &
"                    B.REFERENCEDOCUMENT  " &
"               from WMWHSE7.ORDERS@DL_LN_WMS B  " &
"           group by B.REFERENCEDOCUMENT ) OWMS  " &
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
"      (CASE WHEN (CISLI245.T$FIRE$L IS NULL AND OWMS.ORDERKEY IS NULL)  " &
"              THEN 'NEN' ELSE  " &
"            NULL  " &
"        END = 'NEN' )))  " &
"  AND TDSLS400.T$HDST NOT IN (30, 35)  " &
"  AND TDSLS094.T$RETO = 2  " &
"  AND TDSLS401.T$CLYN = 2  " &
"  AND wmsCODE.UDF1 = 'WMWHSE7'  " &
"ORDER BY NUME_FILIAL, PEDIDO_SITE  "

)