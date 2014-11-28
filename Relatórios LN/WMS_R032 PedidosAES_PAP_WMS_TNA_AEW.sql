    SELECT wmsCODE.FILIAL            FILIAL,     
           wmsCODE.ID_FILIAL         DSC_PLANTA,
           TDSLS400.T$ORNO           PEDIDO_LN,
           ZNSLS004.T$PECL$C         PEDIDO_SITE,
		   OWMS.ORDERKEY			 ORDEM_WMS,
           ZNSLS004.T$UNEG$C         ID_UNEG,
           ZNINT002.T$DESC$C         DESCR_UNEG,
           ZNSLS410.T$POCO$C         ID_ULT_PONTO,
           ZNMCS002.T$DESC$C         DESCR_ULT_PONTO,
           TRIM(ZNSLS004.T$ITEM$C)     ITEM
		   
  
FROM BAANDB.TTDSLS400301@PLN01 TDSLS400

 LEFT JOIN ( select A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ORNO$C,
                    --A.T$PONO$C,
					B.T$ITEM$C,
          B.T$CWRL$C,
                    MIN(B.T$DTAP$C) T$DTAP$C
               from BAANDB.TZNSLS004301@PLN01 A
         inner join BAANDB.TZNSLS401301@PLN01 B 
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
                    A.T$ORNO$C,
                    --A.T$PONO$C,
                    B.T$ITEM$C,
                    B.T$CWRL$C) ZNSLS004
        ON ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO
       --AND ZNSLS004.T$PONO$C = TDSLS401.T$PONO
    
 LEFT JOIN BAANDB.TZNINT002301@pln01 ZNINT002
        ON ZNINT002.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNINT002.T$UNEG$C = ZNSLS004.T$UNEG$C
    
 LEFT JOIN ( select MAX(C.T$POCO$C) KEEP (DENSE_RANK LAST ORDER BY C.T$DTOC$C,  C.T$SEQN$C) T$POCO$C,
                    C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C
               from BAANDB.TZNSLS410301@pln01 C
           group by C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C ) ZNSLS410 
        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C
    
 LEFT JOIN BAANDB.TZNMCS002301@pln01 ZNMCS002
        ON ZNMCS002.T$POCO$C = ZNSLS410.T$POCO$C


  
 INNER JOIN ( select upper(wmsCODE.UDF1) Filial,
                    wmsCODE.UDF2 ID_FILIAL,
                    a.t$code cwar
               from baandb.ttcemm300301@PLN01 a
          left join ENTERPRISE.CODELKUP wmsCode
                 on UPPER(TRIM(wmsCode.DESCRIPTION)) = a.t$lctn
                and wmsCode.LISTNAME = 'SCHEMA'  
              where a.t$type = 20
			  and wmsCODE.UDF1 is not null
           group by upper(wmsCODE.UDF1),
                    wmsCODE.UDF2,
					a.t$code)  wmsCODE 
        ON wmsCODE.CWAR = ZNSLS004.T$CWRL$C
		
 LEFT JOIN WMWHSE5.ORDERS OWMS ON OWMS.REFERENCEDOCUMENT = TDSLS400.T$ORNO