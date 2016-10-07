    SELECT znsls400.T$PECL$C                                    NUM_PEDIDO,
           znsls401.T$ITEM$C                                    COD_SKU,      
           tcibd001.T$DSCB$C                                    SKU,
           znsls400.T$EMAF$C                                    EMAIL_CLIENTE,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.T$DTEM$C, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE)      DATA_EMISSAO,
           znint002.T$DESC$C                                    BANDEIRA
           
      FROM baandb.TZNSLS400301 znsls400

INNER JOIN baandb.TZNSLS401301 znsls401
        ON znsls401.T$NCIA$C = znsls400.T$NCIA$C
       AND znsls401.T$UNEG$C = znsls400.T$UNEG$C
       AND znsls401.T$PECL$C = znsls400.T$PECL$C
       AND znsls401.T$SQPD$C = znsls400.T$SQPD$C

INNER JOIN baandb.TCISLI245301 cisli245
        ON cisli245.T$SLSO = znsls401.T$ORNO$C
       AND cisli245.T$PONO = znsls401.T$PONO$C
	   
INNER JOIN baandb.TCISLI940301 cisli940
        ON cisli940.T$FIRE$l = cisli245.T$FIRE$l	   
	   
 LEFT JOIN baandb.TTCIBD001301 tcibd001
        ON TRIM(tcibd001.T$ITEM) = TO_CHAR(znsls401.T$ITEM$C)     

 LEFT JOIN baandb.ttcmcs023301 tcmcs023
        ON tcmcs023.T$CITG = tcibd001.T$CITG

 LEFT JOIN baandb.TZNINT002301 znint002
        ON znint002.T$UNEG$C = znsls400.T$UNEG$C           

     WHERE tcmcs023.T$DSCA = 'Microsoft'
       AND cisli940.T$STAT$L IN('5','6') 
	   
       AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.T$DTEM$C, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE)) between :DATA_EMISSAO_INICIAL AND :DATA_EMISSAO_FINAL
