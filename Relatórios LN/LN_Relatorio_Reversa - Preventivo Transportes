SELECT
  DISTINCT
    znsls401.t$pecl$c                         Pedido,
    znsls401.t$entr$c                         Entrega,
    tcibd001.t$dscb$c                         Descricao_do_Item,
    cisli940.t$docn$l                         Nota,
    cisli940.t$seri$l                         Serie,
    cisli940.t$stbn$l                         Nome_Cliente_Coleta,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE)
                                              Data_Coleta_Prometida,
 
   ( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 
      'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE) 
    + znsls401.t$pztr$c )                     Data_Retorno_Prometida,
 
    znfmd001.t$fili$c                         Estabelecimento,
    znsls401.t$lmot$c                         Motivo_da_Coleta,
    cisli940.t$cfrn$l                         Nome_Transportadora_Coleta,
    NVL(znfmd030.t$dsci$c,znmcs002.t$desc$c)  Ocorrencia,
 
    NVL( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE),
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE) )
                                              Data_da_Ocorrencia,
                                           
    NULL                                      Status
        
FROM       baandb.tznsls401201 znsls401

 LEFT JOIN (select r.t$date$c,
                   r.t$ncia$c, 
                   r.t$uneg$c,
                   r.t$pecl$c,
                   r.t$sqpd$c,
                   r.t$entr$c,
                   r.t$sequ$c,
                   r.t$orno$c,
                   r.t$pono$c
              from baandb.tznsls004201 r ) znsls004
     ON znsls004.t$ncia$c = znsls401.t$ncia$c
    AND znsls004.t$uneg$c = znsls401.t$uneg$c
    AND znsls004.t$pecl$c = znsls401.t$pecl$c
    AND znsls004.t$sqpd$c = znsls401.t$sqpd$c
    AND znsls004.t$entr$c = znsls401.t$entr$c
    AND znsls004.t$sequ$c = znsls401.t$sequ$c
    AND ROWNUM = 1
                        
 LEFT JOIN baandb.tcisli245201 cisli245
        ON cisli245.t$slso = znsls004.t$orno$c
       AND cisli245.t$pono = znsls004.t$pono$c

 LEFT JOIN baandb.tcisli940201 cisli940
        ON cisli940.t$fire$l = cisli245.t$fire$l
                  
 LEFT JOIN baandb.tcisli941201 cisli941
        ON cisli941.t$fire$l = cisli940.t$fire$l
    
 LEFT JOIN baandb.ttdsls400201 tdsls400
        ON tdsls400.t$orno = cisli245.t$slso
    
 LEFT JOIN baandb.ttcmcs065201 tcmcs065
        ON tcmcs065.t$cwoc = tdsls400.t$cofc
    
 LEFT JOIN baandb.ttccom130201 tccom130
        ON tccom130.t$cadr = tcmcs065.t$cadr
    
 LEFT JOIN baandb.tznfmd001201 znfmd001
        ON znfmd001.t$fovn$c = tccom130.t$fovn$l
    
 LEFT JOIN baandb.tznfmd630201 znfmd630
        ON znfmd630.t$orno$c = cisli245.t$slso
    
 LEFT JOIN ( Select znfmd640.t$fili$c,
                    znfmd640.t$etiq$c,
                    max(znfmd640.t$coci$c) OCORR,
                    max(znfmd640.t$date$c) DATA_OCORR
               from baandb.tznfmd640201 znfmd640
           group by znfmd640.t$fili$c,
                    znfmd640.t$etiq$c ) znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c

 LEFT JOIN baandb.tznfmd030201 znfmd030
        ON znfmd030.t$ocin$c = znfmd640.OCORR

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    max(znsls410.t$dtoc$c) DATA_OCORR,
                    max(znsls410.t$poco$c) PT_CONTR
               from baandb.tznsls410201 znsls410
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
    
 LEFT JOIN baandb.tznmcs002201 znmcs002
        ON znmcs002.t$poco$c = znsls410.PT_CONTR
    
 LEFT JOIN ( select znsls000.t$indt$c,
                    znsls000.t$itmf$c IT_FRETE,
                    znsls000.t$itmd$c IT_DESP,
                    znsls000.t$itjl$c IT_JUROS
                from baandb.tznsls000201 znsls000
                where rownum = 1 ) PARAM
        ON PARAM.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
              
 LEFT JOIN ( select cisli941.t$fire$l,
                    cisli941.t$item$l,
                    cisli941.t$amnt$l TOTAL
               from baandb.tcisli941201 cisli941 ) DESPESA
        ON DESPESA.t$fire$l = cisli940.t$fire$l
       AND TRIM(DESPESA.t$item$l) = TRIM(PARAM.IT_DESP)
     
 LEFT JOIN ( select cisli941.t$fire$l,
                    cisli941.t$item$l,
                    cisli941.t$amnt$l TOTAL
               from baandb.tcisli941201 cisli941 ) JUROS
        ON JUROS.t$fire$l = cisli940.t$fire$l
       AND TRIM(JUROS.t$item$l) = TRIM(PARAM.IT_JUROS)
    
 LEFT JOIN baandb.ttcibd001201 tcibd001
        ON tcibd001.t$item = cisli941.t$item$l
  
WHERE znsls401.t$idor$c = 'TD'
  AND TRIM(cisli941.t$item$l) !=  TRIM(PARAM.IT_FRETE)
  AND TRIM(cisli941.t$item$l) !=  TRIM(PARAM.IT_DESP)
  AND TRIM(cisli941.t$item$l) !=  TRIM(PARAM.IT_JUROS)
        
ORDER BY Data_da_Ocorrencia, Pedido