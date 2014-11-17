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
                                           
    NULL                                      Status,
    cisli941.t$amnt$l                         VL_TOTAL_ITEM,
    znsls401.t$ufen$c                         UF,
    znsls401.t$cide$c                         CIDADE,
    znsls401.t$tele$c                         TEL,
    znsls401.t$te1e$c                         TEL_1,
    znsls401.t$te2e$c                         TEL_2,
    znsls401.t$loge$c                         ENDERECO,
    znsls401.t$nume$c                         NUMERO,
    znsls401.t$come$c                         COMPL,
    znsls401.t$baie$c                         BAIRRO,
    znsls401.t$cepe$c                         CEP,
    znsls401.t$refe$c                         REFERENCIA,
    znsls401.t$fovn$c                         CPF,
    znsls002.t$dsca$c                         TIPO_ENTREGA,
    znsls401.t$lcat$c                         CATEGORIA,
    znsls401.t$lass$c                         ASSUNTO,
  
    CASE WHEN NVL(cisli940.t$date$l, to_date('01-01-1980','DD-MM-YYYY')) > to_date('01-01-1980','DD-MM-YYYY') 
           THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone sessiontimezone) AS DATE)
           ELSE NULL
     END                                              DATA_EMISSAO_NF,


    CUBAGEM.TOT                               CUBAGEM,
    cisli941.t$dqua$l*tcibd001.t$wght         PESO_KG,
    cisli941.t$pric$l                         VALOR_PRODUTO,
    znsls401.t$orno$c                         ORDEM_DEVOLUCAO,
    CASE WHEN znfmd630.t$stat$c='F' OR tdrec947.t$fire$l is not NULL THEN
            'Nao'
      ELSE  
            'Sim'  END                        PENDENTE_COLETA,
    CASE WHEN tdrec947.t$fire$l is NULL THEN
            'Sim'
    ELSE    'Não' END                         PENDENTE_DEVOLUCAO
    
FROM       baandb.tznsls401301 znsls401

 LEFT JOIN (select r.t$date$c,
                   r.t$ncia$c, 
                   r.t$uneg$c,
                   r.t$pecl$c,
                   r.t$sqpd$c,
                   r.t$entr$c,
                   r.t$sequ$c,
                   r.t$orno$c,
                   r.t$pono$c
              from baandb.tznsls004301 r ) znsls004
     ON znsls004.t$ncia$c = znsls401.t$ncia$c
    AND znsls004.t$uneg$c = znsls401.t$uneg$c
    AND znsls004.t$pecl$c = znsls401.t$pecl$c
    AND znsls004.t$sqpd$c = znsls401.t$sqpd$c
    AND znsls004.t$entr$c = znsls401.t$entr$c
    AND znsls004.t$sequ$c = znsls401.t$sequ$c
    AND ROWNUM = 1
                        
 LEFT JOIN baandb.tcisli245301 cisli245
        ON cisli245.t$slso = znsls004.t$orno$c
       AND cisli245.t$pono = znsls004.t$pono$c

 LEFT JOIN baandb.ttdsls401301  tdsls401
        ON tdsls401.t$orno=cisli245.t$slso
       AND tdsls401.t$pono=cisli245.t$pono 
       
LEFT JOIN baandb.ttdrec947301  tdrec947
        ON tdrec947.t$orno$l = tdsls401.t$orno
       AND tdrec947.t$pono$l = tdsls401.t$pono
       AND tdrec947.t$oorg$l = 1
       
 LEFT JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = cisli245.t$fire$l
                  
 LEFT JOIN baandb.tcisli941301 cisli941
        ON cisli941.t$fire$l = cisli245.t$fire$l
      AND  cisli941.t$line$l = cisli245.t$line$l
      
 LEFT JOIN baandb.ttdsls400301 tdsls400
        ON tdsls400.t$orno = cisli245.t$slso
    
 LEFT JOIN baandb.ttcmcs065301 tcmcs065
        ON tcmcs065.t$cwoc = tdsls400.t$cofc
    
 LEFT JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tcmcs065.t$cadr
    
 LEFT JOIN baandb.tznfmd001301 znfmd001
        ON znfmd001.t$fovn$c = tccom130.t$fovn$l
    
 LEFT JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$pecl$c=TO_CHAR(znsls401.t$entr$c)
    
 LEFT JOIN ( Select znfmd640.t$fili$c,
                    znfmd640.t$etiq$c,
                    max(znfmd640.t$coci$c) OCORR,
                    max(znfmd640.t$date$c) DATA_OCORR
               from baandb.tznfmd640301 znfmd640
           group by znfmd640.t$fili$c,
                    znfmd640.t$etiq$c ) znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c

 LEFT JOIN baandb.tznfmd030301 znfmd030
        ON znfmd030.t$ocin$c = znfmd640.OCORR

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    max(znsls410.t$dtoc$c) DATA_OCORR,
                    max(znsls410.t$poco$c) PT_CONTR
               from baandb.tznsls410301 znsls410
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
    
 LEFT JOIN baandb.tznmcs002301 znmcs002
        ON znmcs002.t$poco$c = znsls410.PT_CONTR
    
 LEFT JOIN ( select znsls000.t$indt$c,
                    znsls000.t$itmf$c IT_FRETE,
                    znsls000.t$itmd$c IT_DESP,
                    znsls000.t$itjl$c IT_JUROS
                from baandb.tznsls000301 znsls000
                where rownum = 1 ) PARAM
        ON PARAM.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
              
 LEFT JOIN ( select cisli941.t$fire$l,
                    cisli941.t$item$l,
                    cisli941.t$amnt$l TOTAL
               from baandb.tcisli941301 cisli941 ) DESPESA
        ON DESPESA.t$fire$l = cisli940.t$fire$l
       AND TRIM(DESPESA.t$item$l) = TRIM(PARAM.IT_DESP)
     
 LEFT JOIN ( select cisli941.t$fire$l,
                    cisli941.t$item$l,
                    cisli941.t$amnt$l TOTAL
               from baandb.tcisli941301 cisli941 ) JUROS
        ON JUROS.t$fire$l = cisli940.t$fire$l
       AND TRIM(JUROS.t$item$l) = TRIM(PARAM.IT_JUROS)
    
 LEFT JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item = cisli941.t$item$l

 LEFT  JOIN  baandb.tznsls002301 znsls002
         ON  znsls002.t$tpen$c=znsls401.t$itpe$c
   
 LEFT JOIN  ( select sum( wmd.t$hght       * 
                              wmd.t$wdth   * 
                              wmd.t$dpth   * 
                              sli.t$dqua$l * 
                            znmcs.t$cuba$c) TOT,
                  sli.t$fire$l,
                  znmcs.t$cfrw$c
             from baandb.tcisli941301 sli,
                  baandb.twhwmd400301 wmd,
                  baandb.tznmcs080301 znmcs 
             where wmd.t$item = sli.t$item$l     
             group by sli.t$fire$l, znmcs.t$cfrw$c ) CUBAGEM
        ON  CUBAGEM.t$fire$l = cisli940.t$fire$l
        AND CUBAGEM.t$cfrw$c = cisli940.t$cfrw$l

 
WHERE znsls401.t$idor$c = 'TD'
  AND TRIM(cisli941.t$item$l) !=  TRIM(PARAM.IT_FRETE)
  AND TRIM(cisli941.t$item$l) !=  TRIM(PARAM.IT_DESP)
  AND TRIM(cisli941.t$item$l) !=  TRIM(PARAM.IT_JUROS)
  
ORDER BY Data_da_Ocorrencia, Pedido
