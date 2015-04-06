SELECT
  DISTINCT
    znfmd630.t$pecl$c            ENTREGA,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                 DATA_COMPRA,
    
    ( SELECT znfmd640.t$coci$c
        FROM BAANDB.tznfmd640301 znfmd640
       WHERE znfmd640.t$date$c = ( select max(znfmd640X.t$date$c)  
                                     from BAANDB.tznfmd640301 znfmd640X
                                    where znfmd640X.t$fili$c = znfmd640.t$fili$c
                                      and znfmd640X.t$etiq$c = znfmd640.t$etiq$c)
         AND znfmd640.t$fili$c = znfmd630.t$fili$c
         AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
         AND ROWNUM = 1 )        ULT_PONTO,   
    
    ( SELECT znfmd030d.t$dsci$c
        FROM BAANDB.tznfmd640301 znfmd640d,
             BAANDB.tznfmd030301 znfmd030d
       WHERE znfmd640d.t$date$c = ( select max(znfmd640x.t$date$c) 
                                      from BAANDB.tznfmd640301 znfmd640x
                                     where znfmd640x.t$fili$c = znfmd640d.t$fili$c                                        
                                       and znfmd640x.t$etiq$c = znfmd640d.t$etiq$c)
         AND znfmd640d.t$fili$c = znfmd630.t$fili$c
         AND znfmd640d.t$etiq$c = znfmd630.t$etiq$c 
         AND znfmd030d.t$ocin$c = znfmd640d.t$coci$c
         AND ROWNUM = 1 )        DESCRICAO,
     
    ZNFMD630.T$CFRW$C            ID_TRANSPORTADORA,
    TCMCS080.T$DSCA              DESCR_TRANSPORTADORA,
    ZNFMD630.T$CONO$C            ID_CONTRATO,
    ZNFMD060.T$CDES$C            DESCR_CONTRATO,
    ZNFMD630.T$FILI$C            ID_FILIAL,
    ZNFMD001.T$DSCA$C            DESCR_FILIAL,
    ZNFMD630.T$DOCN$C            NF,
    ZNFMD630.T$SERI$C            SERIE,
    TDSLS400.T$SOTP              ID_TIPO_ORDEM,
    TDSLS094.T$DSCA              DESCR_TIPO_ORDEM,
    ZNSLS400.T$UNEG$C            ID_UNEG,
    ZNINT002.T$DESC$C            DESCR_UNEG,
 
    ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(znfmd640.t$date$c), 
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE) 
        from BAANDB.tznfmd640301 znfmd640
       where znfmd640.t$fili$c = znfmd630.t$fili$c
         and znfmd640.t$etiq$c = znfmd630.t$etiq$c ) 
                                 DATA_OCORRENCIA,
                      
    CASE WHEN ZNFMD630.T$STAT$C = 'F'
           THEN 'FINALIZADO'
         ELSE   'PENDENTE' 
    END                          SITUACAO,
 
    ZNSLS401.T$CIDE$C            CIDADE,
    ZNSLS401.T$CEPE$C            CEP,
    ZNSLS401.T$UFEN$C            UF,
    ZNSLS401.T$NOME$C            DESTINATARIO,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                 DATA_PROMETIDA,

    ZNSLS401.T$IDPA$C            PERIODO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNFMD630.T$DATE$C, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                 DATA_EXPED,
    CISLI940.T$AMNT$L            VALOR,
    ZNSLS401.T$ITPE$C            ID_TIPO_ENTREGA,
    ZNSLS002.T$DSCA$C            DESCR_TIPO_ENTREGA,
 
    ( select znfmd061.t$dzon$c
        from baandb.tznfmd062301 znfmd062, 
             baandb.tznfmd061301 znfmd061
       where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c 
         and znfmd062.t$cono$c = znfmd630.t$cono$c
         and znfmd062.t$cepd$c <= tccom130.t$pstc
         and znfmd062.t$cepa$c >= tccom130.t$pstc
         and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c
         and znfmd061.t$cono$c = znfmd062.t$cono$c
         and znfmd061.t$creg$c = znfmd062.t$creg$c
         and rownum = 1 )        REGIAO, 
		 
    TDSLS400.T$ORNO              ORDEM_VENDA
 
FROM       BAANDB.tznfmd630301 znfmd630

INNER JOIN BAANDB.TTCMCS080301 TCMCS080
        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C
  
INNER JOIN BAANDB.TZNFMD060301 ZNFMD060
        ON ZNFMD060.T$CFRW$C = ZNFMD630.T$CFRW$C
       AND ZNFMD060.T$CONO$C = ZNFMD630.T$CONO$C
  
INNER JOIN BAANDB.TZNFMD001301 ZNFMD001
        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C

INNER JOIN BAANDB.TTDSLS400301 TDSLS400
        ON TDSLS400.T$ORNO  = ZNFMD630.T$ORNO$C
  
INNER JOIN BAANDB.TCISLI940301 CISLI940
        ON CISLI940.T$FIRE$L = ZNFMD630.T$FIRE$C
  
 LEFT JOIN BAANDB.TTCCOM130301 TCCOM130
        ON TCCOM130.T$CADR   =  CISLI940.T$STOA$L

INNER JOIN BAANDB.TTDSLS094301 TDSLS094
        ON TDSLS094.T$SOTP  = TDSLS400.T$SOTP

INNER JOIN ( SELECT A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$ORNO$C
               FROM BAANDB.TZNSLS004301 A
           GROUP BY A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$ORNO$C ) ZNSLS004
        ON ZNSLS004.T$ORNO$C = ZNFMD630.T$ORNO$C
    
INNER JOIN ( SELECT A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$CIDE$C,
                    A.T$CEPE$C,
                    A.T$UFEN$C,
                    A.T$NOME$C,
                    A.T$DTEP$C,
                    A.T$IDPA$C,
                    A.T$ITPE$C
               FROM BAANDB.tznsls401301 A
           GROUP BY A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$CIDE$C,
                    A.T$CEPE$C,
                    A.T$UFEN$C,
                    A.T$NOME$C,
                    A.T$DTEP$C,
                    A.T$IDPA$C,
                    A.T$ITPE$C ) znsls401
        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C    
       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C    
       
INNER JOIN BAANDB.TZNSLS002301 ZNSLS002
        ON ZNSLS002.T$TPEN$C  = ZNSLS401.T$ITPE$C
       
INNER JOIN BAANDB.tznsls400301 znsls400
        ON znsls401.t$ncia$c = znsls400.t$ncia$c
       AND znsls401.t$uneg$c = znsls400.t$uneg$c
       AND znsls401.t$pecl$c = znsls400.t$pecl$c
       AND znsls401.t$sqpd$c = znsls400.t$sqpd$c
    
INNER JOIN BAANDB.TZNINT002301 ZNINT002
        ON ZNINT002.T$NCIA$C = ZNSLS400.T$NCIA$C
       AND ZNINT002.T$UNEG$C = ZNSLS400.T$UNEG$C
  
WHERE znsls401.t$itpe$c = 5 --Agendado
  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      BETWEEN :DataPrometida_De
          AND :DataPrometida_Ate