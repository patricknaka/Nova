select distinct
       znfmd630.t$fili$c                     FILIAL,
       znfmd640_ETR.DATA_OCORRENCIA          DT_HR_EXPEDICAO, 
       znfmd630.t$docn$c                     NUME_NOTA,
       znfmd630.t$seri$c                     NUME_SERIE,  
       znsls401.t$entr$c                     NUME_ENTREGA,
       znsls002.t$dsca$c                     DESC_TIPO_ENTREGA_NOME,
       znfmd630.t$wght$c                     PESO,
       znfmd630.t$qvol$c                     VOLUME,
       
       tcibd001.T$ITEM                       SKU,
       tcibd001.T$DSCA                       DESCRICAO_ITEM,
       tcibd001.t$seto$c                     COD_SETOR, 
       tcibd001.t$dsca$c                     SETOR,
       
       znsls401.t$vlun$c                     VL_SEM_FRETE,
       znfmd630.t$vlfc$c                     FRETE_GTE,
       cisli940.t$amnt$l                     VLR_TOTAL_NF,
       znsls400.t$cepf$c                     CEP,
       znsls400.t$cidf$c                     CIDADE, 
       NVL(REGIAO.DSC,'BR')                  ID_REGIAO,
       NVL(ZNFMD061.T$DZON$C, 'BRASIL')		  REGIAO,
       znsls400.t$uffa$c                     UF,  
       znfmd067.t$fate$c                     ID_ESTAB,
       tcmcs080.t$cfrw                       ID_TRANSP,
       
       tcmcs080.t$cfrw   ||    
       ' - '             ||    
       Trim(tcmcs080.t$dsca)                 COD_DESC_TRANSPORTADOR,
       
       tcmcs080.t$seak                       APELID_TRAN,
       znfmd630.t$cono$c                     CONTRATO,
       znfmd060.t$cdes$c                     NOME_CONTRATO,
       znfmd630.t$etiq$c                     ETIQUETA  
  
FROM       ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640_ETR.t$udat$c),
                     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') AS DATE)                                    DATA_OCORRENCIA,
                    Max(znfmd640_ETR.t$etiq$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640_ETR.t$udat$c ) t$etiq$c,
                    znfmd630.t$pecl$c,
                    znfmd640_ETR.t$fili$c
               from BAANDB.tznfmd640301 znfmd640_ETR
         inner join baandb.tznfmd630301 znfmd630
                 on znfmd640_ETR.t$fili$c = znfmd630.t$fili$c
                and znfmd640_ETR.t$etiq$c = znfmd630.t$etiq$c
              where znfmd640_ETR.t$coct$c = 'ETR'
                and znfmd640_ETR.T$TORG$C = 1
                
             having Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640_ETR.t$udat$c),
                     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') AS DATE) ) --BETWEEN '07/11/2016' AND '07/11/2016'
                    Between :DtExpIni
                        And :DtExpFim

           group by znfmd630.t$pecl$c,
                    znfmd640_ETR.t$fili$c ) znfmd640_ETR

INNER JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$fili$c = znfmd640_ETR.t$fili$c
       AND znfmd630.t$etiq$c = znfmd640_ETR.t$etiq$c
       AND znfmd630.t$pecl$c = znfmd640_ETR.t$pecl$c

INNER JOIN baandb.ttcmcs080301 tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c 

INNER JOIN ( select a1.t$ncia$c,
                    a1.t$uneg$c,
                    a1.t$pecl$c,
                    a1.t$sqpd$c,
                    a1.t$entr$c,
                    a1.t$orno$c
               from baandb.tznsls004301 a1
           group by a1.t$ncia$c,
                    a1.t$uneg$c,
                    a1.t$pecl$c,
                    a1.t$sqpd$c,
                    a1.t$entr$c,
                    a1.t$orno$c ) znsls004
        ON znsls004.t$orno$c = znfmd630.t$orno$c

 LEFT JOIN ( select e.t$ncia$c,
                    e.t$uneg$c,
                    e.t$pecl$c,
                    e.t$sqpd$c,
                    e.t$entr$c,
                    e.t$orno$c,
                    e.t$item$c,
                    e.t$itml$c,
                    e.t$itpe$c,
                    e.t$obet$c,
                    e.t$pztr$c,
                    e.t$pzcd$c,
                    e.t$dtap$c,
                    e.t$cepe$c,
                    e.t$cide$c,
                    e.t$ufen$c,
                    min(e.t$dtep$c) t$dtep$c,
                    sum(e.t$vlun$c) t$vlun$c,
                    sum(e.t$vlfr$c) t$vlfr$c,
                    min(e.t$idpa$c) t$idpa$c,
                    min(e.t$dtre$c) t$dtre$c,
                    min(e.t$pzfo$c) t$pzfo$c,
                    sum(e.t$qtve$c) t$qtve$c
               from baandb.tznsls401301 e
              where e.t$iitm$c = 'P'
           group by e.t$ncia$c,
                    e.t$uneg$c,
                    e.t$pecl$c,
                    e.t$sqpd$c,
                    e.t$entr$c,
                    e.t$orno$c,
                    e.t$item$c,
                    e.t$itml$c,
                    e.t$itpe$c,
                    e.t$obet$c,
                    e.t$pztr$c,
                    e.t$pzcd$c,
                    e.t$dtap$c,
                    e.t$cepe$c,
                    e.t$cide$c,
                    e.t$ufen$c ) znsls401
        ON znsls401.t$ncia$c = znsls004.t$ncia$c
       AND znsls401.t$uneg$c = znsls004.t$uneg$c
       AND znsls401.t$pecl$c = znsls004.t$pecl$c
       AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
       AND znsls401.t$entr$c = znsls004.t$entr$c

 LEFT JOIN ( select tcibd001.T$ITEM,
                    tcibd001.T$DSCA,
                    tcibd001.t$seto$c,
                    znmcs030.t$dsca$c
               from baandb.ttcibd001301  tcibd001
         inner join baandb.tznmcs030301  znmcs030
                 on znmcs030.t$citg$c = tcibd001.t$citg
                and znmcs030.t$seto$c = tcibd001.t$seto$c ) tcibd001
        ON tcibd001.T$ITEM = znsls401.t$itml$c

 LEFT JOIN baandb.tznsls400301  znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.T$UNEG$c
       AND znsls400.t$pecl$c = znsls401.T$pecl$c
       AND znsls400.t$sqpd$c = znsls401.T$sqpd$c

 LEFT JOIN baandb.tznsls002301 znsls002
        ON znsls002.t$tpen$c = NVL(znsls401.t$itpe$c, 16)

 LEFT JOIN baandb.tznfmd067301  znfmd067
        ON znfmd067.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd067.t$cono$c = znfmd630.t$cono$c
       AND znfmd067.t$fili$c = znfmd630.t$fili$c

 LEFT JOIN baandb.tcisli940301  cisli940
        ON cisli940.t$fire$l = znfmd630.t$fire$c
		
 LEFT JOIN baandb.tznfmd640301 znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c

 LEFT JOIN baandb.tznfmd610301  znfmd610
        ON znfmd610.t$fili$c = znfmd630.t$fili$c
       AND znfmd610.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd610.t$ngai$c = znfmd630.t$ngai$c
       AND znfmd610.t$etiq$c = znfmd630.t$etiq$c

 LEFT JOIN BAANDB.tznfmd060301 znfmd060 
        ON znfmd060.t$cfrw$c = znfmd067.t$cfrw$c 
       AND znfmd060.t$cono$c = znfmd067.t$cono$c

 LEFT JOIN ( SELECT znfmd062.t$creg$c DSC,
                    znfmd062.t$cfrw$c,
                    znfmd062.t$cono$c,
                    TO_NUMBER(znfmd062.t$cepd$c) t$fpst$c,
                    TO_NUMBER(znfmd062.t$cepa$c) t$tpst$c
               FROM baandb.tznfmd062301  znfmd062 ) REGIAO
        ON REGIAO.t$fpst$c < = znsls401.t$cepe$c 
       AND REGIAO.t$tpst$c > = znsls401.t$cepe$c
       AND REGIAO.t$cfrw$c = znfmd630.t$cfrw$c
       AND REGIAO.t$cono$c = znfmd630.t$cono$c

 LEFT JOIN BAANDB.TZNFMD061301 ZNFMD061
        ON ZNFMD061.T$CFRW$C = REGIAO.T$CFRW$C
       AND ZNFMD061.T$CONO$C = REGIAO.T$CONO$C
       AND ZNFMD061.T$CREG$C = REGIAO.DSC

WHERE znsls401.t$itpe$c IN (:TipoEntrega)
  AND tcmcs080.t$cfrw = CASE WHEN :Transportadora = 'T' THEN tcmcs080.t$cfrw ELSE :Transportadora END