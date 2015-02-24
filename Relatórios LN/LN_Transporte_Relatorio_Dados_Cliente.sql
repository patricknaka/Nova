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
	znsls401.t$pztr$c		 TransitTime_CClinente
    
FROM       baandb.tznsls401301 znsls401

INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item = znsls401.t$itml$c
     
INNER JOIN baandb.ttcmcs023301 tcmcs023              
        ON tcmcs023.t$citg = tcibd001.t$citg
  
WHERE ((znsls401.t$entr$c IN (:NumEntrega) AND :Todos = 1  )  OR :Todos = 0 )