SELECT DISTINCT

znsls410.t$pecl$c                     PEDIDO,
znsls410.t$entr$c                     NO_ENTREGA,
LAST_OCCUR.t$docn$c                   NF,
LAST_OCCUR.t$seri$c                   SERIE,
LAST_OCCUR.t$poco$c                   CODIGO_OCORRENCIA,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LAST_OCCUR.t$dtoc$c,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) DATA_HORA,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LAST_OCCUR.t$date$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) DATA_PROCESSAMENTO,
                
    CASE WHEN LAST_OCCUR.t$dtem$c <=   to_date('01-01-1980','DD-MM-YYYY') 
    THEN  NULL
    ELSE
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LAST_OCCUR.t$dtem$c,
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone sessiontimezone) AS DATE) END DATA_SAIDA,

    CASE WHEN LAST_OCCUR.t$dtep$c <=   to_date('01-01-1980','DD-MM-YYYY') 
    THEN  NULL
    ELSE
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LAST_OCCUR.t$dtep$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) END    DATA_PROMETIDA,
        
znfmd630.t$cfrw$c                     COD_TRANSPORTADORA,
tcmcs080.t$dsca                       NOME_TRANSPORTADORA,
znfmd630.t$cono$c                     CONTRATO,
znfmd060.t$cdes$c                     DESC_CONTRATO,
tdsls401.t$oamt                       VALOR_ENTREGA,
znfmd630.t$fili$c                     FILIAL,
znsls400.t$cepf$c                     CEP,
znsls400.t$cidf$c                     CIDADE,
znsls400.t$emaf$c                     EMAIL_CLIENTE,
znsls400.t$telf$c                     TELEFONE_1,
znsls400.t$te1f$c                     TELEFONE_2

FROM  baandb.tznsls410301   znsls410

INNER JOIN baandb.tznsls400301  znsls400
        ON znsls400.t$ncia$c=znsls410.t$ncia$c
       AND znsls400.t$uneg$c=znsls410.t$uneg$c
       AND znsls400.t$pecl$c=znsls410.t$pecl$c
       AND znsls400.t$sqpd$c=znsls410.t$sqpd$c
       
LEFT JOIN baandb.tznfmd630301 znfmd630
       ON znfmd630.t$orno$c=znsls410.t$orno$c

LEFT JOIN baandb.ttcmcs080301 tcmcs080
       ON tcmcs080.t$cfrw=znfmd630.t$cfrw$c

LEFT JOIN baandb.tznfmd060301 znfmd060
       ON znfmd060.t$cfrw$c=znfmd630.t$cfrw$c
      AND znfmd060.t$cono$c=znfmd630.t$cono$c
      
LEFT JOIN baandb.tznsls401301 znsls401
       ON znsls401.t$ncia$c=znsls410.t$ncia$c
      AND znsls401.t$uneg$c=znsls410.t$uneg$c
      AND znsls401.t$pecl$c=znsls410.t$pecl$c
      AND znsls401.t$sqpd$c=znsls410.t$sqpd$c
      AND znsls401.t$entr$c=znsls410.t$entr$c
       
LEFT JOIN baandb.ttdsls401301 tdsls401
       ON tdsls401.t$orno=znsls401.t$orno$c
      AND tdsls401.t$pono=znsls401.t$pono$c

LEFT JOIN ( select MAX(C.T$POCO$C) KEEP (DENSE_RANK LAST ORDER BY C.T$DTOC$C,  C.T$SEQN$C) T$POCO$C,
                   MAX(C.T$DTOC$C) KEEP (DENSE_RANK LAST ORDER BY C.T$DTOC$C,  C.T$SEQN$C) T$DTOC$C,
                   MAX(C.T$DATE$C) KEEP (DENSE_RANK LAST ORDER BY C.T$DATE$C,  C.T$SEQN$C) T$DATE$C,
                   MAX(C.T$DTEM$C) KEEP (DENSE_RANK LAST ORDER BY C.T$DATE$C,  C.T$SEQN$C) T$DTEM$C,
                   MAX(C.T$DTEP$C) KEEP (DENSE_RANK LAST ORDER BY C.T$DATE$C,  C.T$SEQN$C) T$DTEP$C,
                   MAX(C.T$DOCN$C) KEEP (DENSE_RANK LAST ORDER BY C.T$DATE$C,  C.T$SEQN$C) T$DOCN$C,
                   MAX(C.T$SERI$C) KEEP (DENSE_RANK LAST ORDER BY C.T$DATE$C,  C.T$SEQN$C) T$SERI$C,
                    C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
                    C.T$ENTR$C
               from BAANDB.TZNSLS410301 C
           group by C.T$NCIA$C,
                    C.T$UNEG$C,
                    C.T$PECL$C,
                    C.T$SQPD$C,
                    C.T$ENTR$C) LAST_OCCUR 
        ON LAST_OCCUR.T$NCIA$C = ZNSLS410.T$NCIA$C
       AND LAST_OCCUR.T$UNEG$C = ZNSLS410.T$UNEG$C
       AND LAST_OCCUR.T$PECL$C = ZNSLS410.T$PECL$C
       AND LAST_OCCUR.T$SQPD$C = ZNSLS410.T$SQPD$C
       AND LAST_OCCUR.T$ENTR$C = ZNSLS410.T$ENTR$C
       
