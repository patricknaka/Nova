SELECT * FROM
   (SELECT
      ZNSLS410.T$ENTR$C                            ENTREGA,
      
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTEN$C, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
       AT time zone 'America/Sao_Paulo') AS DATE)  DATA_PREVISTA,
      
      ZNSLS410.T$POCO$C                            ID_OCORRENCIA, --ID da ultima ocorrencia
      ZNMCS002.T$DESC$C                            DESCR_OCORRENCIA,
      
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
       AT time zone 'America/Sao_Paulo') AS DATE)  DATA_OCORRENCIA,  -- Data do ultimo ponto
      
      (select max(a.t$dtoc$c)
         from baandb.tznsls410201 a
        where a.t$ncia$c = znsls410.t$ncia$c
          and a.t$uneg$c = znsls410.t$uneg$c 
          and a.t$pecl$c = znsls410.t$pecl$c
          and a.t$sqpd$c = znsls410.t$sqpd$c
          and a.t$entr$c = znsls410.t$entr$c
          and a.t$poco$c = 'ARL')                  DATA_PROCESSAMENTO, --Data ponto ARL
  
      ROW_NUMBER() OVER (PARTITION BY ZNSLS410.T$NCIA$C,
                                      ZNSLS410.T$UNEG$C,
                                      ZNSLS410.T$PECL$C,
                                      ZNSLS410.T$SQPD$C,
                                      ZNSLS410.T$ENTR$C
        ORDER BY ZNSLS410.T$DTOC$C DESC, ZNSLS410.T$SEQN$C DESC)  RN

        FROM BAANDB.TZNSLS410201 ZNSLS410
  
  INNER JOIN BAANDB.TZNMCS002201 ZNMCS002  
          ON ZNMCS002.T$POCO$C = ZNSLS410.T$POCO$C) Q1
  
WHERE Q1.DATA_PROCESSAMENTO IS NOT NULL
  AND RN = 1
  AND ( (Q1.ENTREGA IN (:Entrega) and :EntregaTodos = 1 ) or (:EntregaTodos = 0) )