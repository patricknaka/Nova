SELECT
  DISTINCT
    tcmcs080.t$dsca    DESC_TRANSP, 
    znfmd060.t$cdes$c  DESC_CONTRATO,
    znsls401.t$entr$c  NUME_ENTREGA,
    znfmd630.t$etiq$c  NUME_ETIQUETA,
    znfmd630.t$fili$c  NUME_FILIAL, 
    cisli940.t$docn$l  NUME_NOTA,  
    cisli940.t$seri$l  NUME_SERIE,     
    cisli940.t$fdty$l  TIPO_ORDEM, 
    FGET.              DESC_TIPO_ORDEM,    
    cisli940.t$gamt$l  VL_MERCADORIA,
    znsls401.t$uneg$c  UNINEG,
    
    ( SELECT  znfmd640.t$coct$c 
      FROM    BAANDB.tznfmd640301 znfmd640
      WHERE   znfmd640.t$coct$c = ( select  max(znfmd640.t$coct$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640.t$date$C,  znfmd640.t$udat$C)
                                    from    BAANDB.tznfmd640301 znfmd640
                                    where   znfmd640.t$fili$c = znfmd630.t$fili$c
                                      and   znfmd640.t$etiq$c = znfmd630.t$etiq$c )
         AND ROWNUM = 1
         AND znfmd640.t$coct$c NOT IN ('ENT', 'EXT', 'ROU', 'AVA', 'DEV', 'EXF', 'RIE', 'RTD')
         AND znfmd640.t$fili$c = znfmd630.t$fili$c
         AND znfmd640.t$etiq$c = znfmd630.t$etiq$c )
                       OCORRENCIA,

    ( SELECT znfmd040d.t$dotr$c
        FROM BAANDB.tznfmd640301 znfmd640d,
             BAANDB.tznfmd040301 znfmd040d
       WHERE znfmd640d.t$coct$c = ( select max(znfmd640x.t$coct$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640x.t$date$C,  znfmd640x.t$udat$C)
                                      from BAANDB.tznfmd640301 znfmd640x
                                     where znfmd640x.t$fili$c = znfmd630.t$fili$c                                        
                                       and znfmd640x.t$etiq$c = znfmd630.t$etiq$c
                                       and znfmd040d.t$cfrw$c = znfmd630.t$cfrw$c
                                       and znfmd040d.t$octr$c = znfmd640d.t$coct$c )
         AND ROWNUM = 1  
         AND znfmd640d.t$fili$c = znfmd630.t$fili$c
         AND znfmd640d.t$etiq$c = znfmd630.t$etiq$c )
                       DESCRICAO,
        
    ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 'DD-MON-YYYY HH24:MI:SS'), 
          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
        FROM BAANDB.tznfmd640301 znfmd640
       WHERE znfmd640.t$date$c = ( select max(znfmd640.t$date$c)
                                     from BAANDB.tznfmd640301 znfmd640
                                    where znfmd640.t$fili$c = znfmd630.t$fili$c
                                      and znfmd640.t$etiq$c = znfmd630.t$etiq$c ) 
         AND ROWNUM = 1
         AND znfmd640.t$fili$c = znfmd630.t$fili$c
         AND znfmd640.t$etiq$c = znfmd630.t$etiq$c )
                       DATA_OCORRENCIA, 
        
    znfmd630.t$stat$c  SITUACAO,
    znsls401.t$cide$c  CIDADE,
    znsls401.t$cepe$c  CEP,  
    znsls401.t$ufen$c  UF,                      
    znsls401.t$nome$c  DESTINATARIO,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) 
                       DATA_PROMETIDA,
        
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$dats$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)  
                       DATA_EXPEDICAO,                      
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$dats$l-znsls401.t$pzcd$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                       DATA_PREVISTA,
    
    cisli940.t$amnt$l  VALOR,
 
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
      and rownum = 1 ) REGIAO,
    znsls401.t$itpe$c  ID_TIPO_ENTREGA,
    znsls002.t$dsca$c  DESCR_TIPO_ENTREGA,
    znfmd630.t$orno$c  ORDEM_VENDA,
    znint002.t$uneg$c  UNIDADE_NEG,
    znint002.t$desc$c  DESCR_UNIDADE_NEG
 
FROM       BAANDB.tznfmd630301 znfmd630

INNER JOIN BAANDB.tznsls004301 znsls004
        ON znsls004.t$orno$c = znfmd630.t$orno$c
  
INNER JOIN BAANDB.tznsls401301 znsls401
        ON znsls401.t$ncia$c = znsls004.t$ncia$c
       AND znsls401.t$uneg$c = znsls004.t$uneg$c
       AND znsls401.t$pecl$c = znsls004.t$pecl$c
       AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
       AND znsls401.t$entr$c = znsls004.t$entr$c
       AND znsls401.t$sequ$c = znsls004.t$sequ$c

INNER JOIN BAANDB.tznint002301 znint002
        ON znint002.t$ncia$c = znsls401.t$ncia$c
       AND znint002.t$uneg$c = znsls401.t$uneg$c
  
INNER JOIN BAANDB.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls004.t$ncia$c
      AND znsls400.t$uneg$c = znsls004.t$uneg$c
      AND znsls400.t$pecl$c = znsls004.t$pecl$c
      AND znsls400.t$sqpd$c = znsls004.t$sqpd$c

INNER JOIN BAANDB.tznsls002301 znsls002
        ON znsls002.t$tpen$c = znsls401.t$itpe$c
  
 LEFT JOIN BAANDB.tznfmd060301 znfmd060
        ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c 
       AND znfmd060.t$cono$c = znfmd630.t$cono$c

 LEFT JOIN BAANDB.ttcmcs080301 tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c
  
INNER JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = znfmd630.t$fire$c
       AND cisli940.t$docn$l = znfmd630.t$docn$c 
       AND cisli940.t$seri$l = znfmd630.t$seri$c  

LEFT JOIN baandb.ttccom130301 tccom130       
  ON tccom130.t$cadr = cisli940.t$stoa$l
  
INNER JOIN (SELECT d.t$cnst CNST, 
                   l.t$desc DESC_TIPO_ORDEM
              FROM baandb.tttadv401000 d, baandb.tttadv140000 l 
             WHERE d.t$cpac = 'ci' 
               AND d.t$cdom = 'sli.tdff.l'
               AND l.t$clan = 'p'
               AND l.t$cpac = 'ci'
               AND l.t$clab = d.t$za_clab
               AND rpad(d.t$vers,4) ||
                   rpad(d.t$rele,2) ||
                   rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                          from baandb.tttadv401000 l1 
                                         where l1.t$cpac = d.t$cpac 
                                           and l1.t$cdom = d.t$cdom )
               AND rpad(l.t$vers,4) ||
                   rpad(l.t$rele,2) ||
                   rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) || 
                                                   rpad(l1.t$cust,4)) 
                                          from baandb.tttadv140000 l1 
                                         where l1.t$clab = l.t$clab 
                                           and l1.t$clan = l.t$clan 
                                           and l1.t$cpac = l.t$cpac)) FGET
        ON FGET.CNST = cisli940.t$fdty$l
         
WHERE ( SELECT znfmd640.t$coci$c 
          FROM BAANDB.tznfmd640301 znfmd640
         WHERE znfmd640.t$coct$c = 'ETR'          
           AND znfmd640.t$fili$c = znfmd630.t$fili$c
           AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
           AND ROWNUM = 1 ) IS NOT NULL
  
  AND cisli940.t$fdty$l = 1
  
  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE))
      BETWEEN :DataPlanejadaDe
          AND :DataPlanejadaAte
  AND tcmcs080.t$cfrw IN (:Transportadora)
  AND NVL(TRIM(znfmd630.t$stat$c),'P') IN (:Situacao)
