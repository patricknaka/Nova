SELECT 
  DISTINCT
    znfmd630.t$fili$c         PLANTA,
    znfmd001.t$dsca$c         DESC_PLANTA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) -       
    znsls401.t$pzcd$c         DATA_LIMITE,
    znfmd630.t$pecl$c         PEDIDO,
    znfmd630.t$orno$c         ORDEM_VENDA,
    Trim(znsls401.t$itml$c)   ITEM,  
    tcibd001.t$dsca           ITEM_DESCR,     
    tcibd001.t$citg           DEPARTAMENTO,  
    tcmcs023.t$dsca           DEPARTAMENTO_DESCR,   
    znsls401.t$mgrt$c         MEGA_ROTA,  
    znsls401.t$cide$c         CIDADE,
    znsls401.t$ufen$c         ESTADO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd170.t$dten$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                              DT_FECHA_GAIOLA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd170.t$dtsa$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                              DT_LIQ,
    znfmd170.t$fovn$c         CNPJ_TRANSP,
    tcmcs080.t$dsca           TRANSP_NOME,
    whwmd400.t$hght           ALTURA,
    whwmd400.t$wdth           LARGURA,
    whwmd400.t$dpth           COMPRIMENTO,  
    znsls401.t$qtve$c         QTDE,
    znsls401.t$vlun$c *       
    znsls401.t$qtve$c         VALOR,
    znfmd630.t$ncar$c         CARGA,  
    whwmd400.t$hght *         
    whwmd400.t$wdth *         
    whwmd400.t$dpth           CUBO
  
FROM       baandb.tznfmd630301 znfmd630

 LEFT JOIN baandb.tznfmd001301 znfmd001
        ON znfmd001.t$fili$c = znfmd630.t$fili$c
 
 LEFT JOIN baandb.ttcmcs080301  tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c
	   
INNER JOIN baandb.tznfmd171301 znfmd171
        ON znfmd171.t$cfrw$c = znfmd630.t$cfrw$c 
       AND znfmd171.t$fili$c = znfmd630.t$fili$c 
       AND znfmd171.t$ncar$c = znfmd630.t$ncar$c 

INNER JOIN baandb.tznfmd170301 znfmd170
        ON znfmd171.t$cfrw$c = znfmd170.t$cfrw$c 
       AND znfmd171.t$nent$c = znfmd170.t$nent$c 
       AND znfmd171.t$fili$c = znfmd170.t$fili$c
	   
INNER JOIN baandb.tznsls004301 znsls004
        ON znsls004.t$orno$c = znfmd630.t$orno$c		
	   
INNER JOIN baandb.tznsls401301 znsls401
        ON 	znsls401.t$ncia$c = znsls004.t$ncia$c
		AND znsls401.t$uneg$c = znsls004.t$uneg$c
		AND znsls401.t$pecl$c = znsls004.t$pecl$c
		AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
		AND znsls401.t$entr$c = znsls004.t$entr$c
		AND znsls401.t$sequ$c = znsls004.t$sequ$c
  
 LEFT JOIN baandb.twhwmd400301 whwmd400
        ON whwmd400.t$item = znsls401.t$itml$c
	   
INNER JOIN baandb.ttcibd001301  tcibd001
        ON tcibd001.t$item = znsls401.t$itml$c

 LEFT JOIN baandb.ttcmcs023301 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
	   
WHERE znfmd630.t$fili$c = :Planta
  AND Trunc( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd170.t$dtsa$c, 
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone sessiontimezone) AS DATE) ) 
      BETWEEN :DataLiqDe 
          AND :DataLiqAte
		  
  -- AND Trunc( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd170.t$dten$c, 
               -- 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 -- AT time zone sessiontimezone) AS DATE) ) 
      -- BETWEEN :DataLiqDe 
          -- AND :DataLiqAte		  
		  
  AND znsls401.t$mgrt$c in (:MegaRota)
  AND tcmcs080.t$cfrw in (:Transp)
  
ORDER BY znfmd630.t$pecl$c,
         tcmcs023.t$dsca,
         tcibd001.t$dsca