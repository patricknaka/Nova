SELECT CASE WHEN znsls400dev.t$sige$c = 1 
                  THEN znmcs096dev.t$sige$c
                ELSE   znsls401orig.t$entr$c 
           END                                                      ENTREGA_ORIGINAL,
           znsls401dev.t$entr$c                                     SEQUENCIAL_FORCADO,
           Trim(tcibd001dev.t$item)                                 SKU_ITEM,
           tcibd001dev.t$dscb$c                                     DESCRICAO_ITEM,
           znsls401dev.t$orno$c                                     NUM_COLETA,
           NVL(CASE WHEN znsls400dev.t$sige$c = 1
                      THEN znmcs096dev.t$docn$c
                    ELSE SLI940_orig.t$docn$l 
               END, znfmd630_orig.t$docn$c)                         NF_ORIGINAL,

           NVL(CASE WHEN znsls400dev.t$sige$c = 1 
                      THEN znmcs096dev.t$seri$c
                    ELSE   SLI940_orig.t$seri$l 
               END, znfmd630_orig.t$seri$c)                         SERIE_ORIGINAL,
           tdrec940rec.t$docn$l                                     NFE,
           tdrec940rec.t$seri$l                                     SERIE_NFE,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$date$l, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)           DATA_RECEBIMENTO,

           NVL(regexp_replace(tccom130_dev.t$fovn$l, '[^0-9]', ''),
			     tcmcs080_COLETA.t$fovn$l)                          TRANSP_COLETA_CNPJ,

           NVL(tcmcs080_dev.t$dsca, 
               tcmcs080_COLETA.t$dsca)                              TRANSP_COLETA_NOME

FROM       BAANDB.tznsls400301 znsls400dev

INNER JOIN ( select znsls401.t$ncia$c,
                    znsls401.t$uneg$c,
                    znsls401.t$pecl$c,
                    znsls401.t$sqpd$c,
                    znsls401.t$entr$c,
                    znsls401.t$pvdt$c,
                    znsls401.t$sedt$c,
                    znsls401.t$endt$c,
                    znsls401.t$itpe$c,
                    znsls401.t$lmot$c,
                    znsls401.t$lass$c,
                    znsls401.t$orno$c,
                    MIN(znsls401.t$pono$c) t$pono$c,
                    SUM(znsls401.t$qtve$c) t$qtve$c,
                    SUM(znsls401.t$vlfr$c) t$vlfr$c,
                    znsls401.t$vlun$c,
                    znsls401.t$cepe$c,
                    znsls401.t$cide$c,
                    znsls401.t$ufen$c,
                    znsls401.t$itml$c,
                    znsls401.t$idor$c,
                    znsls401.t$iitm$c
               from BAANDB.tznsls401301 znsls401
              where znsls401.t$idor$c = 'TD'
                and znsls401.t$qtve$c < 0
                and znsls401.t$iitm$c = 'P'
           group by znsls401.t$ncia$c,
                    znsls401.t$uneg$c,
                    znsls401.t$pecl$c,
                    znsls401.t$sqpd$c,
                    znsls401.t$entr$c,
                    znsls401.t$pvdt$c,
                    znsls401.t$sedt$c,
                    znsls401.t$endt$c,
                    znsls401.t$itpe$c,
                    znsls401.t$lmot$c,
                    znsls401.t$lass$c,
                    znsls401.t$orno$c,
                    znsls401.t$vlun$c,
                    znsls401.t$cepe$c,
                    znsls401.t$cide$c,
                    znsls401.t$ufen$c,
                    znsls401.t$itml$c,
                    znsls401.t$idor$c,
                    znsls401.t$iitm$c ) znsls401dev
        ON znsls400dev.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls400dev.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls400dev.t$pecl$c = znsls401dev.t$pecl$c
       AND znsls400dev.t$sqpd$c = znsls401dev.t$sqpd$c

INNER JOIN BAANDB.ttcibd001301 tcibd001dev
        ON tcibd001dev.t$item = znsls401dev.t$itml$c
        
INNER JOIN BAANDB.ttdsls400301 tdsls400dev                 -- Ordem de venda devolução  
        ON tdsls400dev.t$orno = znsls401dev.t$orno$c

 LEFT JOIN ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                    tcmcs080.t$dsca,
                    tcmcs080.t$cfrw
               from baandb.ttcmcs080301 tcmcs080
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$cadr = tcmcs080.t$cadr$l
              where tccom130.t$ftyp$l = 'PJ' ) tcmcs080_COLETA
        ON tcmcs080_COLETA.t$cfrw = tdsls400dev.t$cfrw
        
 LEFT JOIN BAANDB.tcisli245301 cisli245dev
        ON cisli245dev.t$slso = znsls401dev.t$orno$c
       AND cisli245dev.t$pono = znsls401dev.t$pono$c
       AND cisli245dev.t$ortp = 1
       AND cisli245dev.t$koor = 3

 LEFT JOIN BAANDB.tcisli941301 cisli941dev  
        ON cisli941dev.t$fire$l = cisli245dev.t$fire$l
       AND cisli941dev.t$line$l = cisli245dev.t$line$l
                                                                                                  
 LEFT JOIN  BAANDB.tcisli940301 cisli940dev  
        ON  cisli940dev.t$fire$l = cisli941dev.t$fire$l
             
 LEFT JOIN  ( select a.t$orno$l,
                     a.t$pono$l,
                     a.t$fire$l
                from baandb.ttdrec947301 a
               where a.t$oorg$l = 1
            group by a.t$orno$l,
                     a.t$pono$l,
                     a.t$fire$l ) tdrec947rec
        ON tdrec947rec.t$orno$l = znsls401dev.t$orno$c
       AND tdrec947rec.t$pono$l = znsls401dev.t$pono$c

 LEFT JOIN  BAANDB.ttdrec940301 tdrec940rec  
        ON  tdrec940rec.t$fire$l = tdrec947rec.t$fire$l
          
 LEFT JOIN BAANDB.ttcmcs080301 tcmcs080_dev
        ON tcmcs080_dev.t$cfrw = cisli940dev.t$cfrw$l
          
 LEFT JOIN BAANDB.ttccom130301 tccom130_dev
        ON tccom130_dev.t$cadr = tcmcs080_dev.t$cadr$l

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$orno$c,
                    min(a.t$pono$c) t$pono$c
               from BAANDB.tznsls401301 a --where a.t$entr$c = '10032017602'
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$orno$c ) znsls401orig                    -- Pedido integrado origem
        ON znsls401orig.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls401orig.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls401orig.t$pecl$c = znsls401dev.t$pvdt$c
       AND znsls401orig.t$sqpd$c = znsls401dev.t$sedt$c
       AND znsls401orig.t$entr$c = znsls401dev.t$endt$c

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    max(a.t$orno$c) KEEP (DENSE_RANK LAST ORDER BY a.t$date$c) t$orno$c
               from baandb.tznsls004301 a
              where a.t$orig$c != 3  --insucesso de entrega
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c ) znsls004orig
        ON znsls004orig.t$ncia$c = znsls401orig.t$ncia$c
       AND znsls004orig.t$uneg$c = znsls401orig.t$uneg$c
       AND znsls004orig.t$pecl$c = znsls401orig.t$pecl$c
       AND znsls004orig.t$entr$c = znsls401orig.t$entr$c

 LEFT JOIN ( select cisli245.t$fire$l, 
                    cisli245.t$slso,
                    min(cisli245.t$pono)t$pono
               from baandb.tcisli245301 cisli245
         inner join baandb.tcisli940301 cisli940
                 on cisli940.t$fire$l = cisli245.t$fire$l
              where cisli940.t$doty$l = 1
                and cisli245.t$ortp = 1
                and cisli245.t$koor = 3
           group by cisli245.t$fire$l, 
                    cisli245.t$slso,
                    cisli245.t$pono ) cisli245orig
        ON cisli245orig.t$slso = znsls401orig.t$orno$c
       AND cisli245orig.t$pono = znsls401orig.t$pono$c

 LEFT JOIN baandb.tcisli940301 SLI940_orig
        ON SLI940_orig.t$fire$l = cisli245orig.t$fire$l

 LEFT JOIN ( select a.t$ncmp$c,
                    a.t$orno$c,
                    a.t$pono$c,
                    a.t$fire$c,
                    min(a.t$cref$c) t$cref$c,
                    min(a.t$cfoc$c) t$cfoc$c,
                    min(a.t$docn$c) t$docn$c,
                    min(a.t$seri$c) t$seri$c,
                    min(a.t$doty$c) t$doty$c,
                    min(a.t$trdt$c) t$trdt$c,
                    min(a.t$creg$c) t$creg$c,
                    min(a.t$cfov$c) t$cfov$c,
                    min(a.t$sige$c) t$sige$c
               from baandb.tznmcs096301 a 
           group by a.t$ncmp$c,
                    a.t$orno$c,
                    a.t$pono$c,
                    a.t$fire$c ) znmcs096dev
        ON znmcs096dev.t$orno$c = znsls401dev.t$orno$c
       AND znmcs096dev.t$pono$c = znsls401dev.t$pono$c
       AND znmcs096dev.t$ncmp$c = 2    --Faturamento       

 LEFT JOIN ( select a.t$pecl$c,
                    a.t$orno$c,
                    a.t$docn$c,
                    a.t$seri$c,
                    min(a.t$etiq$c) t$etiq$c,
                    a.t$fili$c,
                    a.t$fire$c
               from baandb.tznfmd630301 a
         inner join baandb.tcisli940301 b
                 on a.t$fire$c = b.t$fire$l
              where b.t$stat$l IN (5,6)         --5-Impresso, 6-Lancado
           group by a.t$pecl$c,
                    a.t$orno$c,
                    a.t$docn$c,
                    a.t$seri$c,
                    a.t$fili$c,
                    a.t$fire$c ) znfmd630_orig  --etiqueta venda
        ON TO_CHAR(znfmd630_orig.t$pecl$c) = TO_CHAR(CASE WHEN znsls400dev.t$sige$c = 1 
                                                            THEN znmcs096dev.t$sige$c
                                                          ELSE   znsls401orig.t$entr$c 
                                                     END)
       AND znfmd630_orig.t$fire$c = CASE WHEN  znsls400dev.t$sige$c = 1 
                                           THEN znmcs096dev.t$fire$c
                                         ELSE   cisli245orig.t$fire$l
                                    END
       AND znfmd630_orig.t$orno$c = znsls004orig.t$orno$c


     WHERE znsls400dev.t$sige$c = 1
       and znsls400dev.t$idpo$c = 'TD'
       and not exists ( select 1
                          from baandb.tznsls409301 znsls409
                         where znsls409.t$ncia$c = znsls401dev.t$ncia$c
                           and znsls409.t$uneg$c = znsls401dev.t$uneg$c
                           and znsls409.t$pecl$c = znsls401dev.t$pecl$c
                           and znsls409.t$sqpd$c = znsls401dev.t$sqpd$c
                           and znsls409.t$entr$c = znsls401dev.t$entr$c	 
                           and znsls409.t$lbrd$c = 1  )  --Forcado = Sim
                           
       and (    (tdrec940rec.t$fire$l is null and :Situacao = 0)          --Pendente

             OR (    (tdrec940rec.t$fire$l is not null and :Situacao = 1) --Devolvido
                  and (          (:ValData = 0) 
                        OR (   ( (:ValData = 1) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$date$l, 
                                                              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                                                AT time zone 'America/Sao_Paulo') AS DATE)) = :DtEmissaoDe ) )
                            OR ( (:ValData = 2) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$date$l, 
                                                              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                                                AT time zone 'America/Sao_Paulo') AS DATE)) = :DtEmissaoAte ) )
                            OR ( (:ValData = 3) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$date$l, 
                                                              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                                                AT time zone 'America/Sao_Paulo') AS DATE)) Between :DtEmissaoDe And :DtEmissaoAte ) ) 
                           ) 
                      )
                )
       	  
             OR (:Situacao = 2) ) --Todos

ORDER BY 1