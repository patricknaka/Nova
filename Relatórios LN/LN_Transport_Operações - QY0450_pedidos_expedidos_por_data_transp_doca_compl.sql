SELECT 
  DISTINCT
    znfmd610.t$fili$c         PLANTA,
    znfmd001.t$dsca$c         DESC_PLANTA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) -       
    znsls401.t$pzcd$c         DATA_LIMITE,
    znfmd610.t$pecl$c         PEDIDO,
    znsls401.t$entr$c         ENTREGA,
	  znsls004.t$orno$c         ORDEM_VENDA,
    Trim(znsls401.t$itml$c)   ITEM,  
    tcibd001.t$dsca           ITEM_DESCR,     
    tcibd001.t$citg           DEPARTAMENTO,  
    tcmcs023.t$dsca           DEPARTAMENTO_DESCR,   
    znsls401.t$mgrt$c         MEGA_ROTA,  
    znsls401.t$cide$c         CIDADE,
    znsls401.t$ufen$c         ESTADO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd600.t$dtfe$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                              DT_FECHA_GAIOLA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OCOR_ETR.data_etr, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                              DT_LIQ,
    tccom130.t$fovn$l         CNPJ_TRANSP,
    tcmcs080.t$dsca           TRANSP_NOME,
    whwmd400.t$hght           ALTURA,
    whwmd400.t$wdth           LARGURA,
    whwmd400.t$dpth           COMPRIMENTO,  
    znsls401.t$qtve$c         QTDE,
    znsls401.t$vlun$c *       
    znsls401.t$qtve$c         VALOR,
    znfmd610.t$ngai$c         CARGA,  
    whwmd400.t$hght *         
    whwmd400.t$wdth *         
    whwmd400.t$dpth           CUBO,
    znsls002.t$dsca$c         TIPO_ENTREGA,  
    NVL(tcmcs031.t$dsca,  
           'Pedido Interno')  MARCA,  
    znsls401.t$obet$c         LOJA_RETIRA_FACIL,  
    znsls401.t$cepe$c         CEP,  
    znfmd610.t$wght$c         PESO  
  
FROM       (select znfmd610.t$fili$c,  
                    znfmd610.t$pecl$c,  
                    znfmd610.t$ngai$c,  
                    znfmd610.t$cfrw$c,  
                    znfmd610.t$cnfe$c,  
                    znfmd610.t$wght$c,  
                    max(znfmd610.t$etiq$c) t$etiq$c   
             from baandb.tznfmd610601 znfmd610  
             group by znfmd610.t$fili$c,  
                    znfmd610.t$pecl$c,  
                    znfmd610.t$ngai$c,  
                    znfmd610.t$cfrw$c,  
                    znfmd610.t$cnfe$c,  
                    znfmd610.t$wght$c) znfmd610

INNER JOIN baandb.tznfmd600301 znfmd600
        ON znfmd600.t$fili$c = znfmd610.t$fili$c
       AND znfmd600.t$cfrw$c = znfmd610.t$cfrw$c
       AND znfmd600.t$ngai$c = znfmd610.t$ngai$c
   
LEFT JOIN ( select a.t$fili$c,
                    a.t$etiq$c,
                    max(a.t$date$c) data_etr
               from baandb.tznfmd640301 a
              where a.t$coci$c='ETR'
           group by a.t$fili$c,
                    a.t$etiq$c ) OCOR_ETR
        ON OCOR_ETR.t$fili$c = znfmd610.t$fili$c
       AND OCOR_ETR.t$etiq$c = znfmd610.t$etiq$c

INNER JOIN baandb.ttcmcs080301  tcmcs080
        ON tcmcs080.t$cfrw = znfmd610.t$cfrw$c  

INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tcmcs080.t$cadr$l

 LEFT JOIN baandb.tznfmd001301 znfmd001
        ON znfmd001.t$fili$c = znfmd610.t$fili$c
		
INNER JOIN baandb.tcisli940301 cisli940
		ON	cisli940.t$cnfe$l = znfmd610.t$cnfe$c
		
INNER JOIN baandb.tcisli245301 cisli245
		ON	cisli245.t$fire$l = cisli940.t$fire$l
    
INNER JOIN baandb.tznsls004301 znsls004
        ON 	znsls004.t$orno$c = cisli245.t$slso
		AND	znsls004.t$pono$c = cisli245.t$pono
    
INNER JOIN baandb.tznsls401301 znsls401
        ON znsls401.t$ncia$c = znsls004.t$ncia$c
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

 LEFT JOIN baandb.tznsls002301 znsls002
        ON znsls002.t$tpen$c = znsls401.t$itpe$c

 LEFT JOIN baandb.tznint002601  znint002  
         ON znint002.t$ncia$c = znsls401.t$ncia$c  
        AND znint002.t$uneg$c = znsls401.t$uneg$c  
   
 LEFT JOIN baandb.ttcmcs031301  tcmcs031  
         ON znint002.t$cbrn$c = tcmcs031.t$cbrn
        
WHERE znfmd610.t$fili$c = :Planta
  AND Trunc( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OCOR_ETR.data_etr, 
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') AS DATE) ) 
      Between :DataLiqDe 
          And :DataLiqAte
  AND NVL(Trim(znsls401.t$mgrt$c), 'SMR') in (:MegaRota)
  AND tcmcs080.t$cfrw in (:Transp)
  
where znfmd610.t$ngai$c = '0000022466'
  
ORDER BY znfmd610.t$pecl$c,
         znsls401.t$entr$c,
         tcmcs023.t$dsca,
         tcibd001.t$dsca
