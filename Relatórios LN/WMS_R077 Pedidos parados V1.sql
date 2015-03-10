SELECT wmsCODE.UDF1                        FILIAL,     -- *** FOI INCLUIDO PARA FILTRO
       wmsCODE.UDF2                        DSC_PLANTA, -- *** FOI INCLUIDO PARA FILTRO
       ZNSLS004.T$PECL$C                   PEDC_ID_PEDIDO,
       TDSLS400.T$ORNO                     PEDIDO_LN,
       TDSLS400.T$OFBP                     PEDC_ID_CLIENTE,
       TDSLS400.T$ODAT                     PEDC_DT_EMISSAO,
       ZNSLS004.T$SQPD$C                   PEDC_SEQ,
       TRIM(TDSLS401.T$ITEM)               PEDD_ID_ITEM,
     ( SELECT MAX(A.T$DTBL)
         FROM BAANDB.TTDSLS421301 A
        WHERE A.T$ORNO = TDSLS420.T$ORNO
          AND A.T$PONO = TDSLS420.T$PONO
          AND A.T$SQNB = TDSLS420.T$SQNB
          AND A.T$CSQN = TDSLS420.T$CSQN
          AND A.T$HREA = TDSLS420.T$HREA ) DT_SITUACAO,
       TDSLS420.T$HREA                     SITUACAO,
       TDSLS401.T$QOOR                     QTDE
	   
FROM       BAANDB.TTDSLS400301 TDSLS400

INNER JOIN BAANDB.TTDSLS401301 TDSLS401 
        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO
		
 LEFT JOIN BAANDB.TZNSLS004301 ZNSLS004 
        ON ZNSLS004.T$ORNO$C = TDSLS401.T$ORNO
       AND ZNSLS004.T$PONO$C = TDSLS401.T$PONO
	   
 LEFT JOIN BAANDB.TTDSLS420301  TDSLS420 
        ON TDSLS420.T$ORNO = TDSLS400.T$ORNO
  
INNER JOIN BAANDB.TTCEMM300301 TCEMM300 
        ON TCEMM300.T$COMP = 301
       AND TCEMM300.T$TYPE = 20
       AND TRIM(TCEMM300.T$CODE) = TRIM(TDSLS401.T$CWAR)
 
INNER JOIN ( SELECT A.LONG_VALUE,
                    UPPER(A.UDF1) UDF1,
                    A.UDF2
               FROM ENTERPRISE.CODELKUP@DL_LN_WMS A
              WHERE A.LISTNAME = 'SCHEMA' )  wmsCODE  
        ON wmsCODE.LONG_VALUE = TCEMM300.T$LCTN
  
WHERE TDSLS420.T$HREA IN ('AES', 'PRD')
  AND ((:Filial = 'AAA') OR (wmsCODE.UDF1 = :Filial))
