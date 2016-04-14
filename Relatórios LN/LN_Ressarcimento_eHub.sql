SELECT

      znsls400dev.t$idca$c                                  CANAL,

      znsls002.t$dsca$c                                     DEVOLUCAO,
      
      znsls401dev.t$lmot$c                                  MOTIVO_ABERTURA_NOME,
      
      znmcs002_TIPO.t$desc$c                                TIPO_INSTANCIA,
      
      znsls401dev.t$orno$c                                  NUMERO_COLETA,
      replace(replace(tccom130_dev.t$fovn$l,'-'),'/')       TRANSP_COLETA_CNPJ,
      tcmcs080_dev.t$dsca                                   TRANSP_COLETA_NOME,                  
      replace(replace(tccom130_orig.t$fovn$l,'-'),'/')      TRANSP_VENDA_CNPJ,    
      tcmcs080_orig.t$dsca                                  TRANSP_VENDA_NOME,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400dev.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) 
                                                            OCORRENCIA_DATA,  
      replace(replace(znsls401dev.t$fovn$c,'-'),'/')        CLIENTE_CPF_CNPJ,
      znsls401dev.t$nome$c                                  CLIENTE_NOME,
      znsls401dev.t$emae$c                                  CLIENTE_EMAIL,
      znsls401dev.t$pecl$c                                  PEDIDO_CLIENTE,
      znsls401dev.t$entr$c                                  ENTREGA_DEVOLUCAO,
      znsls401orig.t$entr$c                                 ENTREGA_VENDA,
      cisli940orig.t$docn$l                                 NF_ORIGINAL,
      cisli940orig.t$seri$l                                 SERIE_ORIGINAL, 
      (SELECT tcemm030.t$euca FROM BAANDB.ttcemm124301 tcemm124, BAANDB.ttcemm030301 tcemm030
        WHERE tcemm124.t$cwoc = tdrec940rec.t$cofc$l
          AND tcemm030.t$eunt = tcemm124.t$grid
          AND tcemm124.t$loco = 301
          AND rownum = 1)                                    FILIAL_NFE,
      tdrec940rec.t$docn$l                                   NFE,
      tdrec940rec.t$seri$l                                   SERIE_NFE,
      tdrec940rec.t$fire$l                                   NR,
      cisli940dev.t$docn$l                                   NFS,           --campo complementar    
      cisli940dev.t$seri$l                                   SERIE_NFS,     --campo complementar
      cisli940dev.t$amnt$l                                   VALOR_NFS,
      tdrec940rec.t$tfda$l                                   VALOR_NFE,
      'Sim'                                                  FORCADA,
      znsls410.t$poco$c                                      ULT_PTO_ENTREGA,
      znmcs002.t$desc$c                                      DESC_ULT_PT_ENTREGA,
      znsls410.t$dtoc$c                                      ULT_ALTERACAO_DATA,
      ttaad200.t$name                                        USUARIO,
      znsls401dev.t$cepe$c                                   CEP_DESTINATARIO,
      znsls401dev.t$cide$c                                   CIDADE,
      znsls401dev.t$ufen$c                                   ESTADO,      
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)         EMISSAO_NF_ENTRADA,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940dev.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)         EMISSAO_NF_SAIDA,      
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(APRV_COLETA.DATA_DTPR, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)         DATA_PROMETIDA_COLETA,            
      cisli940orig.t$date$l                                  DT_EMISSAO_NF_VENDA,
      cisli940dev.t$date$l                                   DT_NF_COLETA,
      znint002.t$desc$c                                      BANDEIRA,
      case when trunc(znsls409.t$fdat$c) < TO_DATE('01-01-1980','DD-MM-YYYY') then
          null
      else
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls409.t$fdat$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)   end   DATA_FORCADO
              
  FROM  BAANDB.tznsls401301 znsls401dev
  
  INNER JOIN BAANDB.tznsls400301 znsls400dev
          ON znsls400dev.t$ncia$c = znsls401dev.t$ncia$c
         AND znsls400dev.t$uneg$c = znsls401dev.t$uneg$c
         AND znsls400dev.t$pecl$c = znsls401dev.t$pecl$c
         AND znsls400dev.t$sqpd$c = znsls401dev.t$sqpd$c
         
  INNER JOIN BAANDB.ttdsls401301 tdsls401dev
          ON tdsls401dev.t$orno = znsls401dev.t$orno$c
         AND tdsls401dev.t$pono = znsls401dev.t$pono$c
        
  INNER JOIN BAANDB.ttdsls400301 tdsls400dev                 -- Ordem de venda devolução  
          ON tdsls400dev.t$orno = tdsls401dev.t$orno
  
   LEFT JOIN BAANDB.tcisli245301 cisli245dev  
          ON cisli245dev.t$slso = tdsls401dev.t$orno
         AND cisli245dev.t$pono = tdsls401dev.t$pono
         AND cisli245dev.t$ortp = 1
         AND cisli245dev.t$koor = 3
                                                    
   LEFT JOIN  BAANDB.tcisli941301 cisli941dev  
          ON  cisli941dev.t$fire$l = cisli245dev.t$fire$l
         AND cisli941dev.t$line$l = cisli245dev.t$line$l
                                                                                                    
   LEFT JOIN  BAANDB.tcisli940301 cisli940dev  
          ON  cisli940dev.t$fire$l = cisli941dev.t$fire$l
               
   LEFT JOIN  BAANDB.ttdrec947301 tdrec947rec  
          ON  tdrec947rec.t$orno$l = tdsls401dev.t$orno
         AND tdrec947rec.t$pono$l = tdsls401dev.t$pono
         AND tdrec947rec.t$oorg$l = 1
         
   LEFT JOIN  BAANDB.ttdrec940301 tdrec940rec  
          ON  tdrec940rec.t$fire$l = tdrec947rec.t$fire$l
          
  INNER JOIN BAANDB.ttcibd001301 tcibd001
          ON tcibd001.t$item = tdsls401dev.t$item

   LEFT JOIN BAANDB.ttcmcs080301 tcmcs080_dev
          ON tcmcs080_dev.t$cfrw = tdsls400dev.t$cfrw
            
   LEFT JOIN BAANDB.ttccom130301 tccom130_dev
          ON tccom130_dev.t$cadr = tcmcs080_dev.t$cadr$l
             
  INNER JOIN BAANDB.tznsls401301 znsls401orig                      -- Pedido integrado origem
          ON znsls401orig.t$ncia$c = znsls401dev.t$ncia$c
         AND znsls401orig.t$uneg$c = znsls401dev.t$uneg$c
         AND znsls401orig.t$pecl$c = znsls401dev.t$pvdt$c
         AND znsls401orig.t$sqpd$c < znsls401dev.t$sqpd$c
         AND znsls401orig.t$entr$c = znsls401dev.t$endt$c
         AND znsls401orig.t$sequ$c = znsls401dev.t$sedt$c        
        
   INNER JOIN BAANDB.ttdsls400301 tdsls400orig                      -- ordem de venda origem
           ON tdsls400orig.t$orno = znsls401orig.t$orno$c          
        
   INNER JOIN BAANDB.ttdsls401301 tdsls401orig
           ON tdsls401orig.t$orno = znsls401orig.t$orno$c
          AND tdsls401orig.t$pono = znsls401orig.t$pono$c
        
    LEFT JOIN  BAANDB.tcisli245301 cisli245orig 
           ON  cisli245orig.t$slso = tdsls401orig.t$orno
          AND  cisli245orig.t$pono = tdsls401orig.t$pono
          AND  cisli245orig.t$ortp = 1
          AND  cisli245orig.t$koor = 3
                                                    
    LEFT JOIN  BAANDB.tcisli941301 cisli941orig 
           ON  cisli941orig.t$fire$l = cisli245orig.t$fire$l
          AND  cisli941orig.t$line$l = cisli245orig.t$line$l
        
    LEFT JOIN  BAANDB.tcisli940301 cisli940orig 
           ON  cisli940orig.t$fire$l = cisli941orig.t$fire$l

    LEFT JOIN BAANDB.ttcmcs080301 tcmcs080_orig
           ON tcmcs080_orig.t$cfrw = tdsls400orig.t$cfrw

    LEFT JOIN BAANDB.ttccom130301 tccom130_orig
           ON tccom130_orig.t$cadr = tcmcs080_orig.t$cadr$l 
    
    LEFT JOIN ( select a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c
                from BAANDB.tznsls402301 a
                group by a.t$ncia$c,
                         a.t$uneg$c,
                         a.t$pecl$c,
                         a.t$sqpd$c )znsls402_dev
           ON znsls402_dev.t$ncia$c = znsls401dev.t$ncia$c
          AND znsls402_dev.t$uneg$c = znsls401dev.t$uneg$c
          AND znsls402_dev.t$pecl$c = znsls401dev.t$pvdt$c
          AND znsls402_dev.t$sqpd$c = znsls401dev.t$sqpd$c

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    max(a.t$dtoc$c) t$dtoc$c,
                    max(a.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C,  a.T$SEQN$C) t$poco$c
               from baandb.tznsls410301 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls410.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls410.t$pecl$c = znsls401dev.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401dev.t$sqpd$c

LEFT JOIN baandb.tznmcs002301 znmcs002
       ON znmcs002.t$poco$c = znsls410.t$poco$c
       
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$poco$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$dpco$c) DATA_DTPR,
                    MAX(znsls410.t$dtpr$c) DATA_DTCD
               from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'APD'
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$poco$c ) APRV_COLETA
        ON APRV_COLETA.t$ncia$c = znsls401dev.t$ncia$c
       AND APRV_COLETA.t$uneg$c = znsls401dev.t$uneg$c
       AND APRV_COLETA.t$pecl$c = znsls401dev.t$pecl$c

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    znsls410.t$entr$c,
                    znsls410.t$poco$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR
               from baandb.tznsls410301 znsls410
              where ( znsls410.t$poco$c = 'POS' OR    --Postagem
                      znsls410.t$poco$c = 'COS' OR    --Coleta
                      znsls410.t$poco$c = 'INS' OR    --Insucesso
                      znsls410.t$poco$c = 'ROB' OR    --Roubo
                      znsls410.t$poco$c = 'EXO' )     --Extravio
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    znsls410.t$entr$c,
                    znsls410.t$poco$c ) TIPO_INST
        ON TIPO_INST.t$ncia$c = znsls401dev.t$ncia$c
       AND TIPO_INST.t$uneg$c = znsls401dev.t$uneg$c
       AND TIPO_INST.t$pecl$c = znsls401dev.t$pecl$c
       AND TIPO_INST.t$sqpd$c = znsls401dev.t$sqpd$c
       AND TIPO_INST.t$entr$c = znsls401dev.t$entr$c
       
 LEFT JOIN baandb.tznmcs002301 znmcs002_TIPO
        ON znmcs002_TIPO.t$poco$c = TIPO_INST.t$poco$c
       
 LEFT JOIN baandb.tznint002301 znint002
        ON znint002.t$ncia$c = znsls401dev.t$ncia$c
       AND znint002.t$uneg$c = znsls401dev.t$uneg$c

 LEFT JOIN baandb.tznsls002301 znsls002
        ON znsls002.t$tpen$c = znsls401dev.t$itpe$c

 LEFT JOIN baandb.tznfmd630301 znfmd630dev
        ON znfmd630dev.t$orno$c = znsls401dev.t$orno$c
    
 LEFT JOIN ( Select a.t$fili$c,
                    a.t$etiq$c,
                    MAX(a.t$ulog$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DATE$C) t$ulog$c
               from baandb.tznfmd640301 a
           group by a.t$fili$c,
                    a.t$etiq$c ) znfmd640
        ON znfmd640.t$fili$c = znfmd630dev.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630dev.t$etiq$c

 LEFT JOIN ( select a.t$user,
                    a.t$name
               from baandb.tttaad200000 a ) ttaad200
        ON ttaad200.t$user = znfmd640.t$ulog$c
        
 INNER JOIN ( select a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$entr$c,
                     a.t$lbrd$c,
                     a.t$fdat$c
              from baandb.tznsls409301 a
              group by a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c,
                       a.t$entr$c,
                       a.t$lbrd$c,
                       a.t$fdat$c ) znsls409
         ON znsls409.t$ncia$c = znsls401dev.t$ncia$c
        AND znsls409.t$uneg$c = znsls401dev.t$uneg$c
        AND znsls409.t$pecl$c = znsls401dev.t$pecl$c
        AND znsls409.t$sqpd$c = znsls401dev.t$sqpd$c
        AND znsls409.t$entr$c = znsls401dev.t$entr$c
        
  WHERE znsls401dev.t$idor$c = 'TD'
    AND znsls401dev.t$qtve$c < 0
    AND znsls401orig.t$idor$c = 'LJ'
    AND znsls409.t$lbrd$c = 1        --Forcado = Sim
