select Q1.* from (

SELECT 
    znsls410.t$pecl$c                          PEDIDO,
    znsls410.t$entr$c                          NO_ENTREGA,
    MAX(znsls410.T$DOCN$C) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C) NF,
    MAX(znsls410.T$SERI$C) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  SERIE,
    MAX(znsls410.T$POCO$C) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C, znsls410.T$SEQN$C) CODIGO_OCORRENCIA,
        
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znsls410.T$DTOC$C) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C, znsls410.T$SEQN$C),
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) DATA_HORA,
                
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znsls410.T$DATE$C) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) DATA_PROCESSAMENTO,
                                                                    
    CASE WHEN (MAX(znsls410.T$DTEM$C) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)) < =    to_date('01-01-1980','DD-MM-YYYY') 
    THEN  NULL
    ELSE
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znsls410.T$DTEM$C) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C),
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone sessiontimezone) AS DATE) END 
                                               DATA_SAIDA,

    CASE WHEN (MAX(znsls410.T$DTEP$C) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)) < =    to_date('01-01-1980','DD-MM-YYYY') 
    THEN  NULL
    ELSE
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znsls410.T$DTEP$C) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) END    
                                               DATA_PROMETIDA,
        
    
    MAX(znfmd630.t$cfrw$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  COD_TRANSPORTADORA,
    
    MAX(tcmcs080.t$dsca) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  NOME_TRANSPORTADORA,
    
    MAX(znfmd630.t$cono$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  CONTRATO,
    
    MAX(znfmd060.t$cdes$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  DESC_CONTRATO,
    
    MAX(tdsls401.t$oamt) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  VALOR_ENTREGA,
    
    MAX(tcemm030.t$euca) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  FILIAL,
    MAX(tcemm030.t$dsca) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  NOME_FILIAL,
    
    MAX(znsls400.t$cepf$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  CEP,
    
    MAX(znsls400.t$cidf$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  CIDADE,
    
    MAX(znsls400.t$emaf$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  EMAIL_CLIENTE,
    
    MAX(znsls400.t$telf$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  TELEFONE_1,
    
    MAX(znsls400.t$te1f$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, znsls410.T$SEQN$C)  TELEFONE_2
    
FROM       baandb.tznsls410301 znsls410

INNER JOIN baandb.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls410.t$ncia$c
       AND znsls400.t$uneg$c = znsls410.t$uneg$c
       AND znsls400.t$pecl$c = znsls410.t$pecl$c
       AND znsls400.t$sqpd$c = znsls410.t$sqpd$c
       
 LEFT JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$orno$c = znsls410.t$orno$c
 
 LEFT JOIN baandb.ttcmcs080301 tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c
 
 LEFT JOIN baandb.tznfmd060301 znfmd060
        ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd060.t$cono$c = znfmd630.t$cono$c
       
 LEFT JOIN baandb.tznsls401301 znsls401
        ON znsls401.t$ncia$c = znsls410.t$ncia$c
       AND znsls401.t$uneg$c = znsls410.t$uneg$c
       AND znsls401.t$pecl$c = znsls410.t$pecl$c
       AND znsls401.t$sqpd$c = znsls410.t$sqpd$c
       AND znsls401.t$entr$c = znsls410.t$entr$c
        
 LEFT JOIN baandb.ttdsls401301 tdsls401
        ON tdsls401.t$orno = znsls401.t$orno$c
       AND tdsls401.t$pono = znsls401.t$pono$c
    
 LEFT JOIN baandb.ttcemm124301  tcemm124
        ON tcemm124.t$cwoc=znsls401.t$cwoc$c
 
 LEFT JOIN baandb.ttcemm030301 tcemm030
        ON tcemm030.t$eunt=tcemm124.t$grid

GROUP BY  znsls410.t$pecl$c,
          znsls410.t$entr$c 

 ORDER BY DATA_HORA, PEDIDO ) Q1
 
where ((NO_ENTREGA in (:NumEntrega) and :Todos = 1  ) or :Todos = 0 )
  and trunc(DATA_HORA)   
      between nvl(:DataOcorrenciaDe,DATA_HORA)
          and nvl(:DataOcorrenciaAte,DATA_HORA)