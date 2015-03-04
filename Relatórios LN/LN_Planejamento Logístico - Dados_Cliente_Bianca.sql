SELECT
  DISTINCT
    znsls401.t$ncia$c FILIAL,
    znsls401.t$uneg$c BANDEIRA,
    znsls401.t$entr$c ENTREGA,
    tcibd001.t$citg	  NUM_DEPARTAMENTO,
    tcmcs023.t$dsca	  DEPARTAMENTO_DESC,
    znsls401.t$itml$c	NUM_ITEM,
    tcibd001.t$dsca	  ITEM_DESC,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)  
                      DATA_PROMETIDA,
    znsls401.t$ufen$c	UF,
    znsls401.t$nome$c	NOME_CLIENTE,
    znsls401.t$emae$c	E_MAIL,
    znsls401.t$te1e$c	TELEFONE_1,
    znsls401.t$te2e$c	TELEFONE_2
    
FROM  
     baandb.tznsls401201  znsls401,  
     baandb.ttcibd001201  tcibd001,
     baandb.ttcmcs023201  tcmcs023              
        
WHERE
  znsls401.t$itml$c = tcibd001.t$item
AND
  tcmcs023.t$citg = tcibd001.t$citg  