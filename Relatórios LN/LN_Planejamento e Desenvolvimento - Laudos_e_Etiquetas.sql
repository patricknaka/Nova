SELECT                     
  znsls401.t$orno$c,                 
  znsls401.t$pono$c,                 
   
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 'DD-MON-YYYY HH24:MI:SS'), 
  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                     DATA_OCORRENCIA,
          
  znsls401.t$lcat$c                  PROCESSO,
  znsls401.t$lmot$c                  MOTIVO,
  Trim(znsls401.t$loge$c)            ENDERECO,
  znsls401.t$nume$c                  NUMERO,
  znsls401.t$cepe$c                  CEP,
  znsls401.t$baie$c                  BAIRRO,
  znsls401.t$cide$c                  CIDADE,
  znsls401.t$ufen$c                  UF,                      
  znsls401.t$cdat$c                  NUME_INSTANCIA,
  znsls401.t$entr$c                  NUME_ENTREGA,
  cisli940.t$docn$l                  NUME_NOTA,
  cisli940.t$seri$l                  NUME_SERIE,   
  znsls401.t$trre$c                  NOME_TRANSPORTADORA,
  znsls401.t$nome$c                  NOME_CLIENTE,
  znsls401.t$refe$c                  OBSERVACAO,
    
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 
  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                     DATA_NF_ENTRADA,
  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtre$c, 'DD-MON-YYYY HH24:MI:SS'), 
  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                     COLETA_PREVISTA,
   
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 
  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                     RETORNO_PREVISTO,

  Trim(znsls401.t$itml$c)            NUME_ITEM,
  tcibd001.t$dsca                    DESC_ITEM,
  znsls401.t$qtve$c                  QTDE_ITEM,
  whwmd400.t$hght                    ALTURA,
  whwmd400.t$wdth                    LARGURA,
  whwmd400.t$dpth                    COMPRIMENTO,
  whwmd400.t$hght * whwmd400.t$wdth  M3,
  cisli940.t$cnfe$l                  CHAVES_ACESSO,
  cisli245.t$shpm                    NUME_EXPEDICAO

FROM       baandb.tznfmd630301 znfmd630
           
INNER JOIN baandb.tznsls401301 znsls401
        ON TO_CHAR(znsls401.t$entr$c) = znfmd630.t$pecl$c
       AND znsls401.t$orno$c = znfmd630.T$ORNO$C
    
 LEFT JOIN baandb.ttcibd001301 tcibd001 
        ON tcibd001.t$item = znsls401.t$itml$c
 
 LEFT JOIN baandb.tcisli245301 cisli245  
        ON cisli245.t$slso = znsls401.t$orno$c
       AND cisli245.t$pono = znsls401.t$pono$c
       AND cisli245.t$item = znsls401.t$itml$c
  
 LEFT JOIN baandb.twhwmd400301 whwmd400
        ON whwmd400.t$item = znsls401.t$itml$c
              
 LEFT JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = znfmd630.t$fire$c 
       AND cisli940.t$docn$l = znfmd630.t$docn$c 
       AND cisli940.t$seri$l = znfmd630.t$seri$c         
  
 LEFT JOIN (SELECT MAX(a.t$date$c) t$date$c,
                   a.t$fili$c,
                   a.t$etiq$c
              FROM BAANDB.tznfmd640301 a
          GROUP BY a.t$fili$c, a.t$etiq$c) znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c 
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
    
WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 'DD-MON-YYYY HH24:MI:SS'), 
            'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE))
      BETWEEN :DataOcorrenciaDe
          AND :DataOcorrenciaAte