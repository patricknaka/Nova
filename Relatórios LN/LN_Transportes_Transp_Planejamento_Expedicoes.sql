SELECT /*+ use_concat no_cpu_costing */ 
       znfmd640_ETR.t$fili$c              FILIAL,          
       znfmd640_ETR.DATA_OCORRENCIA       DATA_EXPEDICAO,
       cisli940.t$fdty$l                  NUME_TIPO_DOCUMENTO, 
       znfmd640_ETR.t$pecl$c              NUME_ENTREGA,  
       znfmd640_ETR.t$itpe$c              NUME_TIPO_ENTREGA,
       znsls002.t$dsca$c                  DESC_TIPO_ENTREGA_NOME,  
       znfmd640_ETR.t$wght$c              PESO,  
       znfmd610.t$cube$c                  ITEM_CUBAGEM,  
       znfmd640_ETR.t$vlfc$c              FRETE_GTE, 
       cisli940.t$amnt$l                  VLR_TOTAL_NF,  
       tccom130t.t$dsca                   TRANSP_NOME, 
       znfmd640_ETR.t$cepe$c              CEP, 
       znfmd640_ETR.t$cide$c              CIDADE,  
       znfmd640_ETR.t$ufen$c              UF,  
       ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640_ENT.t$date$c,
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
           from BAANDB.tznfmd640301 znfmd640_ENT
          where znfmd640_ENT.t$fili$c = znfmd640_ETR.t$fili$c
            and znfmd640_ENT.t$etiq$c = znfmd640_ETR.t$etiq$c
            and znfmd640_ENT.t$coci$c = 'ENT'
            and ROWNUM = 1 )              DATA_ENTREGA,  

       znfmd067.t$fate$c                  FILIAL_TRANSPORTADORA,
       CASE WHEN regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '') IS NULL
              THEN '00000000000000'
            WHEN LENGTH(regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')) < 11
              THEN '00000000000000'
            ELSE regexp_replace(tccom130t.t$fovn$l, '[^0-9]', '')
       END                                CNPJ_TRANSPORTADORA, 
       tdsls401.t$prdt                    DATA_PROMETIDA,  
       znfmd640.t$coci$c                  ULTIMA_OCORRENCIA, 
       znfmd640.t$desc$c                  OCORRENCIA,  
       znfmd640.t$date$c                  DATA_OCORRENCIA,
       znfmd640_ETR.t$cono$c              COD_CONTRATO,  
       znfmd060.t$refe$c                  ID_EXT_CONTRATO, 
       CASE WHEN TRUNC(znfmd640_ETR.t$dtpe$c) = '01/01/1970'
              THEN NULL
            ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640_ETR.t$dtpe$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
       END                                DATA_PREVISTA_ENTREGA,                            
      ( select sum((a.t$qtve$c * tcibd001.t$wght)) peso
        from baandb.tznsls401301 a
        left join baandb.ttcibd001301 tcibd001
               on tcibd001.t$item = a.t$itml$c
        where a.t$ncia$c = znfmd640_ETR.t$ncia$c
          and a.t$uneg$c = znfmd640_ETR.t$uneg$c
          and a.t$pecl$c = znfmd640_ETR.t$pecl$c
          and a.t$sqpd$c = znfmd640_ETR.t$sqpd$c
          and a.t$entr$c = znfmd640_ETR.t$entr$c)            
                                          PESO_REAL  

FROM       ( select  
                    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640.t$udat$c),
                     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') AS DATE)                            DATA_OCORRENCIA,
                    Max(znfmd640.t$etiq$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640.t$udat$c ) t$etiq$c,
                    znfmd630.t$cfrw$c,
                    znfmd630.t$cono$c,
                    znfmd630.t$orno$c,
                    znfmd630.t$fire$c,
                    znfmd630.t$ngai$c,
                    znfmd630.t$wght$c,
                    znfmd630.t$vlfc$c,
                    znfmd630.t$dtpe$c,
                    znfmd640.t$fili$c,
                    znsls401.t$ncia$c,
                    znsls401.t$uneg$c,
                    znsls401.t$pecl$c,
                    znsls401.t$sqpd$c,
                    znsls401.t$entr$c,
                    znsls401.t$itpe$c,
                    znsls401.t$cepe$c,
                    znsls401.t$cide$c,
                    znsls401.t$ufen$c,
                    tdsls400.t$stad
                    
              from BAANDB.tznfmd640301 znfmd640
               
              inner join baandb.tznfmd630301 znfmd630
                      on znfmd630.t$fili$c = znfmd640.t$fili$c
                     and znfmd630.t$etiq$c = znfmd640.t$etiq$c
                 
              inner join baandb.tznsls004301 znsls004
                      on znsls004.t$orno$c = znfmd630.t$orno$c
                       
              inner join baandb.tznsls401301 znsls401
                      on znsls401.t$ncia$c = znsls004.t$ncia$c
                     and znsls401.t$uneg$c = znsls004.t$uneg$c
                     and znsls401.t$pecl$c = znsls004.t$pecl$c
                     and znsls401.t$sqpd$c = znsls004.t$sqpd$c
                     and znsls401.t$entr$c = znsls004.t$entr$c
                     and znsls401.t$sequ$c = znsls004.t$sequ$c
                     
              left join baandb.ttdsls400301  tdsls400
                     on tdsls400.t$orno = znfmd630.t$orno$c
              
               where znfmd640.t$coct$c = 'ETR'
                 and znfmd640.T$TORG$C = 1
                 and znsls401.t$iitm$c = 'P'
                 and znfmd640.t$udat$c
                     between TRUNC(TO_DATE(:DtExpIni,'DD-MM-YYYY'))
                         and TRUNC(TO_DATE(:DtExpFim,'DD-MM-YYYY'))+1.99999  --DATE+23:59:59
           group by 
                    znfmd630.t$cfrw$c,
                    znfmd630.t$cono$c,
                    znfmd630.t$orno$c,
                    znfmd630.t$fire$c,
                    znfmd630.t$ngai$c,
                    znfmd630.t$wght$c,
                    znfmd630.t$vlfc$c,
                    znfmd630.t$dtpe$c,
                    znfmd640.t$fili$c,
                    znsls401.t$ncia$c,
                    znsls401.t$uneg$c,
                    znsls401.t$pecl$c,
                    znsls401.t$sqpd$c,
                    znsls401.t$entr$c,
                    znsls401.t$itpe$c,
                    znsls401.t$cepe$c,
                    znsls401.t$cide$c,
                    znsls401.t$ufen$c,
                    tdsls400.t$stad) znfmd640_ETR

 LEFT JOIN ( select CASE WHEN Trunc(Max(tdsls401.t$prdt)) <= TO_DATE('01/01/1970','DD/MM/YYYY')
                           THEN NULL
                         ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(tdsls401.t$prdt), 'DD-MON-YYYY HH24:MI:SS'),
                                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                    END                                                t$prdt,
                    
                    CASE WHEN Trunc(Max(tdsls401.t$ddta)) <= TO_DATE('01/01/1970','DD/MM/YYYY')
                           THEN NULL
                         ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(tdsls401.t$ddta), 'DD-MON-YYYY HH24:MI:SS'),
                                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                    END                                                t$ddta,
                    
                    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(tdsls401.t$odat),
                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                            AT time zone 'America/Sao_Paulo') AS DATE) t$odat,
                    tdsls401.t$orno
              from baandb.ttdsls401301  tdsls401
              group by tdsls401.t$orno ) tdsls401
      ON tdsls401.t$orno = znfmd640_ETR.t$orno$c

 LEFT JOIN baandb.ttccom130301  tccom130
          ON tccom130.t$cadr = znfmd640_ETR.t$stad

 LEFT JOIN baandb.tznsls002301 znsls002
        ON znsls002.t$tpen$c = NVL(znfmd640_ETR.t$itpe$c, 16)

 LEFT JOIN baandb.tznfmd067301  znfmd067
        ON znfmd067.t$cfrw$c = znfmd640_ETR.t$cfrw$c
       AND znfmd067.t$cono$c = znfmd640_ETR.t$cono$c
       AND znfmd067.t$fili$c = znfmd640_ETR.t$fili$c

 LEFT JOIN ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                    tcmcs080.t$dsca,
                    tcmcs080.t$cfrw
               from baandb.ttcmcs080301 tcmcs080
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$cadr = tcmcs080.t$cadr$l
              where tccom130.t$ftyp$l = 'PJ' ) tccom130t
        ON tccom130t.t$cfrw = znfmd640_ETR.t$cfrw$c

 LEFT JOIN baandb.tcisli940301  cisli940
        ON cisli940.t$fire$l = znfmd640_ETR.t$fire$c
		
 LEFT JOIN ( select znfmd640.t$fili$c,
                    znfmd640.t$etiq$c,
                    znmcs002.t$desc$c,
                    max(znfmd640.t$coci$c) t$coci$c,
                    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640.t$date$c),
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') AS DATE)  t$date$c
               from baandb.tznfmd640301 znfmd640
         inner join baandb.tznmcs002301 znmcs002
                 on znmcs002.t$poco$c = znfmd640.t$coci$c
              where (znfmd640.t$date$c, znfmd640.t$udat$c) = ( select max(oc.t$date$c) t$date$c, 
                                                                      max(oc.t$udat$c)  KEEP (DENSE_RANK LAST ORDER BY oc.t$date$c ) t$udat$c
                                                                 from baandb.tznfmd640301 oc
                                                                where oc.t$fili$c = znfmd640.t$fili$c
                                                                  and oc.t$etiq$c = znfmd640.t$etiq$c )
           group by znfmd640.t$fili$c,
                    znfmd640.t$etiq$c,
                    znmcs002.t$desc$c ) znfmd640 
        ON znfmd640.t$fili$c = znfmd640_ETR.t$fili$c
       AND znfmd640.t$etiq$c = znfmd640_ETR.t$etiq$c

 LEFT JOIN baandb.tznfmd610301  znfmd610
        ON znfmd610.t$fili$c = znfmd640_ETR.t$fili$c
       AND znfmd610.t$cfrw$c = znfmd640_ETR.t$cfrw$c
       AND znfmd610.t$ngai$c = znfmd640_ETR.t$ngai$c
       AND znfmd610.t$etiq$c = znfmd640_ETR.t$etiq$c

 LEFT JOIN BAANDB.tznfmd060301 znfmd060
        ON znfmd060.t$cfrw$c = znfmd640_ETR.t$cfrw$c
       AND znfmd060.t$cono$c = znfmd640_ETR.t$cono$c
       
  WHERE cisli940.t$fdty$l != 14
--    AND NVL(znfmd640_ETR.t$itpe$c, 16) IN (:TipoEntrega)
--    AND ((:Transportadora = 'T') or (znfmd640_ETR.t$cfrw$c = :Transportadora))
    AND znfmd640_ETR.DATA_OCORRENCIA
        BETWEEN TRUNC(TO_DATE(:DtExpIni,'DD-MM-YYYY'))
            AND TRUNC(TO_DATE(:DtExpFim,'DD-MM-YYYY'))+0.99999  --DATE+23:59
       
ORDER BY FILIAL, NUME_ENTREGA
