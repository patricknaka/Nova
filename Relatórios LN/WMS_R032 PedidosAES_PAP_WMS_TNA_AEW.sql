    SELECT wmsCODE.FILIAL            FILIAL,     
           wmsCODE.ID_FILIAL         DSC_PLANTA,
           TDSLS401.T$ORNO           PEDIDO_LN,
           ZNSLS004.T$PECL$C         PEDIDO_SITE,
           ZNSLS004.T$UNEG$C         ID_UNEG,
           ZNINT002.T$DESC$C         DESCR_UNEG,
           ZNSLS410.T$POCO$C         ID_ULT_PONTO,
           ZNMCS002.T$DESC$C         DESCR_ULT_PONTO,
           TRIM(TDSLS401.T$ITEM)     ITEM

      FROM BAANDB.TTDSLS401301 TDSLS401
  
INNER JOIN BAANDB.TTDSLS400301 TDSLS400
        ON TDSLS400.T$ORNO = TDSLS401.T$ORNO

 LEFT JOIN ( select A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ORNO$C,
                    A.T$PONO$C,
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
                    A.T$ORNO$C,
                    A.T$PONO$C ) ZNSLS004
        ON ZNSLS004.T$ORNO$C = TDSLS401.T$ORNO
       AND ZNSLS004.T$PONO$C = TDSLS401.T$PONO
    
 LEFT JOIN BAANDB.TZNINT002301 ZNINT002
        ON ZNINT002.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNINT002.T$UNEG$C = ZNSLS004.T$UNEG$C
    
 LEFT JOIN ( select MAX(C.T$POCO$C) KEEP (DENSE_RANK LAST ORDER BY C.T$DTOC$C,  C.T$SEQN$C) T$POCO$C,
                    C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C
               from BAANDB.TZNSLS410301 C
           group by C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C ) ZNSLS410 
        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C
    
 LEFT JOIN BAANDB.TZNMCS002301 ZNMCS002
        ON ZNMCS002.T$POCO$C = ZNSLS410.T$POCO$C

 LEFT JOIN baandb.ttcemm124301 tcemm124
        ON tcemm124.t$cwoc   = TDSLS400.t$cofc
  
 LEFT JOIN ( select upper(wmsCODE.UDF1) Filial,
                    wmsCODE.UDF2 ID_FILIAL,
                    b.t$grid
               from baandb.ttcemm300301 a
         inner join baandb.ttcemm112301 b
                 on b.t$waid = a.t$code
          left join ENTERPRISE.CODELKUP@DL_LN_WMS wmsCode
                 on UPPER(TRIM(wmsCode.DESCRIPTION)) = a.t$lctn
                and wmsCode.LISTNAME = 'SCHEMA'  
              where a.t$type = 20
           group by upper(wmsCODE.UDF1),
                    wmsCODE.UDF2,
                    b.t$grid )  wmsCODE 
        ON wmsCODE.t$grid = tcemm124.t$grid
  
WHERE TDSLS401.t$item not in ( select a.t$itjl$c
                                 from baandb.tznsls000301 a
                                where a.t$indt$c = ( select min(b.t$indt$c) 
                                                       from baandb.tznsls000301 b )
                            UNION ALL
                               select a.t$itmd$c
                                 from baandb.tznsls000301 a
                                where a.t$indt$c = ( select min(b.t$indt$c) 
                                                       from baandb.tznsls000301 b )
                            UNION ALL
                               select a.t$itmf$c
                                 from baandb.tznsls000301 a
                                where a.t$indt$c = ( select min(b.t$indt$c) 
                                                       from baandb.tznsls000301 b ) )

  AND ( (:Filial = 'AAA') OR (wmsCODE.FILIAL :Filial) )