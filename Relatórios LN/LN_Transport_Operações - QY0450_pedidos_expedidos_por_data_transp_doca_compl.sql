SELECT 
  DISTINCT
    znfmd630.t$fili$c         PLANTA,
    znfmd001.t$dsca$c         DESC_PLANTA,
    znsls401.t$dtep$c -       
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
    znfmd170.t$dten$c         DT_FECHA_GAIOLA,
    znfmd170.t$dtsa$c         DT_LIQ,
    znfmd170.t$fovn$c         CNPJ_TRANSP,
    tcmcs080.t$dsca           TRANSP_NOME,
    whwmd400.t$hght           ALTURA,
    whwmd400.t$wdth           LARGURA,
    whwmd400.t$dpth           COMPRIMENTO,  
    znsls401.t$qtve$c          QTDE,  
    znsls401.t$vlun$c *       
    znsls401.t$qtve$c         VALOR,
    znfmd630.t$ncar$c         CARGA,  
    whwmd400.t$hght *         
    whwmd400.t$wdth *         
    whwmd400.t$dpth           CUBO
  
FROM      baandb.tznfmd630201 znfmd630

LEFT JOIN baandb.tznfmd001201 znfmd001
       ON znfmd001.t$fili$c = znfmd630.t$fili$c

LEFT JOIN baandb.ttcmcs080201  tcmcs080
       ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c,
	   
          baandb.tznfmd170201 znfmd170,
          baandb.tznfmd171201 znfmd171,  
          baandb.tznsls400201 znsls400,
          baandb.tznsls401201 znsls401
  
LEFT JOIN baandb.twhwmd400201 whwmd400
       ON whwmd400.t$item = znsls401.t$itml$c,
	   
          baandb.ttcibd001201  tcibd001      

LEFT JOIN baandb.ttcmcs023201 tcmcs023
       ON tcmcs023.t$citg = tcibd001.t$citg
	   
WHERE znsls401.t$orno$c = znfmd630.t$orno$c
  AND znfmd171.t$cfrw$c = znfmd630.t$cfrw$c 
  AND znfmd171.t$fili$c = znfmd630.t$fili$c 
  AND znfmd171.t$ncar$c = znfmd630.t$ncar$c   
  AND znfmd171.t$cfrw$c = znfmd170.t$cfrw$c 
  AND znfmd171.t$nent$c = znfmd170.t$nent$c 
  AND znfmd171.t$fili$c = znfmd170.t$fili$c 
  AND tcibd001.t$item = znsls401.t$itml$c
  
  AND znfmd630.t$fili$c = :Planta
  AND Trunc(znfmd170.t$dtsa$c) BETWEEN :DataLiqDe AND :DataLiqAte
  AND znsls401.t$mgrt$c in (:MegaRota)
  AND tcmcs080.t$cfrw in (:Transp)
  
ORDER BY znfmd630.t$pecl$c,
         tcmcs023.t$dsca,
         tcibd001.t$dsca