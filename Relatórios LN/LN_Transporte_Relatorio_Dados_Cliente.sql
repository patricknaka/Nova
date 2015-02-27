SELECT
  DISTINCT
    znsls401.t$ncia$c        FILIAL,
    znsls401.t$uneg$c        BANDEIRA,
    znsls401.t$entr$c        ENTREGA,
    tcibd001.t$citg          NUM_DEPARTAMENTO,
    tcmcs023.t$dsca          DEPARTAMENTO_DESC,
    Trim(znsls401.t$itml$c)  NUM_ITEM,
    tcibd001.t$dsca          ITEM_DESC,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE)
                             DATA_PROMETIDA,
        
    znsls401.t$ufen$c        UF,
    znsls401.t$nome$c        NOME_CLIENTE,
    znsls401.t$emae$c        E_MAIL,
    znsls401.t$te1e$c        TELEFONE_1,
    znsls401.t$te2e$c        TELEFONE_2,
    cisli940.t$docn$l        NOTA_FISCAL,
    cisli940.t$seri$l        SERIE,
    znsls410.PT_CONTR        STATUS_ATUAL,
    znmcs002.t$desc$c        DESC_STATUS,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE)
                             DATA_STATUS,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.DATA_PROC, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE)
                             DATA_PROC
    
FROM       baandb.tznsls401301 znsls401

INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item = znsls401.t$itml$c
     
INNER JOIN baandb.ttcmcs023301 tcmcs023              
        ON tcmcs023.t$citg = tcibd001.t$citg
  
LEFT JOIN baandb.tcisli245301 cisli245
       ON cisli245.t$slcp=301
      AND cisli245.t$ortp=1
      AND cisli245.t$koor=3
      AND cisli245.t$slso=znsls401.t$orno$c
      AND cisli245.t$pono=znsls401.t$pono$c
      
LEFT JOIN baandb.tcisli940301 cisli940
       ON cisli940.t$fire$l=cisli245.t$fire$l
       
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    max(znsls410.t$dtoc$c) DATA_OCORR,
                    max(znsls410.t$date$c) DATA_PROC,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) PT_CONTR
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
        
WHERE ((znsls401.t$entr$c IN (:NumEntrega) AND :Todos = 1  )  OR :Todos = 0 ) 
