SELECT

      znsls400dev.t$idca$c                                  CANAL,
      case when trunc(znsls409.t$fdat$c) < TO_DATE('01-01-1980','DD-MM-YYYY') then
          null
      else
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls409.t$fdat$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)   end  DATA_FORCADO,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400dev.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) 
                                                            DATA_OCORRENCIA,
      znsls002.t$dsca$c                                     DEVOLUCAO,  
      znsls401dev.t$lmot$c                                  MOTIVO_ABERTURA_NOVA, 
      znmcs002_TIPO.t$desc$c                                TIPO_DA_ORDEM_DE_VENDA,      
      ORDEM_COLETA.STATUS                                   STATUS_DA_ORDEM_DE_COLETA,
      tdsls420dev.t$hrea                                    MOTIVO_STATUS_ORDEM_DE_COLETA,
      replace(replace(tccom130_orig.t$fovn$l,'-'),'/')      TRANSP_VENDA_CNPJ,    
      tcmcs080_orig.t$dsca                                  TRANSP_VENDA_NOME,
      replace(replace(tccom130_dev.t$fovn$l,'-'),'/')       TRANSP_COLETA_CNPJ,
      tcmcs080_dev.t$dsca                                   TRANSP_COLETA_NOME,
      znsls401dev.t$orno$c                                  NUM_COLETA,
      znsls401dev.t$pecl$c                                  PEDIDO_CLIENTE,
      CASE WHEN znsls400dev.t$sige$c = 1 THEN
          'Sim' ELSE 'Nao' END                              PEDIDO_SIGE,
      CASE WHEN znsls400dev.t$sige$c = 1 THEN
          znmcs096dev.t$sige$c
      ELSE znsls401orig.t$entr$c END                        ENTREGA_VENDA,
      znsls401dev.t$entr$c                                  ENTREGA_DEVOLUCAO,
      CASE WHEN znsls400dev.t$sige$c = 1 THEN 
            znmcs096dev.t$docn$c
      ELSE NVL(cisli940orig.t$docn$l, SLI940_orig.t$docn$l) END 
                                                            NF_ORIGINAL,
      CASE WHEN znsls400dev.t$sige$c = 1 THEN 
          znmcs096dev.t$seri$c
      ELSE NVL(cisli940orig.t$seri$l, SLI940_orig.t$seri$l) END                   
                                                            SERIE_ORIGINAL,
      CASE WHEN znsls400dev.t$sige$c = 1 THEN
          znfmd001dev.t$fili$c
      ELSE 
          znfmd630_orig.t$fili$c
      END                                                    FILIAL_DE_ORIGEM,
      tcibd001dev.t$item                                     SKU_ITEM,
      tcibd001dev.t$dscb$c                                   DESCRICAO_ITEM,
      (SELECT znfmd001.t$fili$c FROM BAANDB.tznfmd001301 znfmd001, baandb.ttccom130301 tccom130
       WHERE tccom130.t$cadr = tdrec940rec.t$sfra$l
       AND znfmd001.t$fovn$c = tccom130.t$fovn$l )           FILIAL_NFE,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940orig.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)          
                                                             DT_EMISSAO_NF_VENDA,    
      tdrec940rec.t$docn$l                                   NFE,
      tdrec940rec.t$seri$l                                   SERIE_NFE,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)         DATA_REFERENCIA_FISCAL,
      tdrec940rec.t$fire$l                                   NR,
      cisli940dev.t$docn$l                                   NFS,
      cisli940dev.t$seri$l                                   SERIE_NFS,
      cisli941dev.t$gamt$l                                   VALOR_TOTAL_DO_ITEM,
      cisli941dev.t$fght$l                                   VALOR_TOTAL_DO_FRETE,
      cisli941dev.t$gamt$l + cisli941dev.t$fght$l            VALOR_TOTAL,
      cisli940dev.t$amnt$l                                   VALOR_NFS,
      znfmd630dev.t$etiq$c                                   ETIQUETA_DEVOLUCAO,
      znfmd630_orig.t$etiq$c                                 ETIQUETA_VENDA,
      'Sim'                                                  FORCADA,
      znsls410.t$poco$c                                      ULT_PONTO_ENTREGA,
      znmcs002.t$desc$c                                      DESCRICAO_ULT_PONTO_ENTREGA,
      ttaad200.t$name                                        USUARIO,
      ''                                                     USUARIO_QUE_FORCOU_PEDIDO,   --NAO TEM NO LN
      znsls401dev.t$cepe$c                                   CEP_DESTINATARIO,
      znsls401dev.t$cide$c                                   CIDADE,
      znsls401dev.t$ufen$c                                   ESTADO,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940dev.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                                                             DT_NF_COLETA,
      znint002.t$desc$c                                      BANDEIRA,
      CASE WHEN znsls402_dev.t$vlmr$c IS NULL THEN
          'REENVIO'
      ELSE  'REEMBOLSO' END                                  FORMA_DE_ATENDIMENTO
              
  FROM  BAANDB.tznsls401301 znsls401dev
  
  INNER JOIN BAANDB.tznsls400301 znsls400dev
          ON znsls400dev.t$ncia$c = znsls401dev.t$ncia$c
         AND znsls400dev.t$uneg$c = znsls401dev.t$uneg$c
         AND znsls400dev.t$pecl$c = znsls401dev.t$pecl$c
         AND znsls400dev.t$sqpd$c = znsls401dev.t$sqpd$c
         
  INNER JOIN BAANDB.ttdsls401301 tdsls401dev
          ON tdsls401dev.t$orno = znsls401dev.t$orno$c
         AND tdsls401dev.t$pono = znsls401dev.t$pono$c
  
  INNER JOIN BAANDB.ttcibd001301 tcibd001dev
          ON tcibd001dev.t$item = znsls401dev.t$itml$c
          
  INNER JOIN BAANDB.ttdsls400301 tdsls400dev                 -- Ordem de venda devolução  
          ON tdsls400dev.t$orno = tdsls401dev.t$orno

  LEFT JOIN ( select  l.t$desc STATUS,
                      d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'td'
                and d.t$cdom = 'sls.hdst'
                and l.t$clan = 'p'
                and l.t$cpac = 'td'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) ORDEM_COLETA
        ON ORDEM_COLETA.t$cnst = tdsls400dev.t$hdst
  
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
         AND  tdrec947rec.t$pono$l = tdsls401dev.t$pono
         AND  tdrec947rec.t$oorg$l = 1
         
   LEFT JOIN  BAANDB.ttdrec940301 tdrec940rec  
          ON  tdrec940rec.t$fire$l = tdrec947rec.t$fire$l
          
  INNER JOIN BAANDB.ttcibd001301 tcibd001
          ON tcibd001.t$item = tdsls401dev.t$item

   LEFT JOIN BAANDB.ttcmcs080301 tcmcs080_dev
          ON tcmcs080_dev.t$cfrw = cisli940dev.t$cfrw$l
            
   LEFT JOIN BAANDB.ttccom130301 tccom130_dev
          ON tccom130_dev.t$cadr = tcmcs080_dev.t$cadr$l
             
    LEFT JOIN ( select a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c,
                       max(a.t$vlmr$c) t$vlmr$c
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
       
  LEFT JOIN ( select a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$entr$c,
                     a.t$orno$c
              from BAANDB.tznsls401301 a
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$entr$c,
                        a.t$orno$c )znsls401orig                      -- Pedido integrado origem
          ON znsls401orig.t$ncia$c = znsls401dev.t$ncia$c
         AND znsls401orig.t$uneg$c = znsls401dev.t$uneg$c
         AND znsls401orig.t$pecl$c = znsls401dev.t$pvdt$c
         AND znsls401orig.t$sqpd$c = znsls401dev.t$sedt$c
         AND znsls401orig.t$entr$c = znsls401dev.t$endt$c
        
   LEFT JOIN BAANDB.ttdsls400301 tdsls400orig                      -- ordem de venda origem
           ON tdsls400orig.t$orno = znsls401orig.t$orno$c          
        
    LEFT JOIN  (select a.t$slso,
                       a.t$fire$l
                from BAANDB.tcisli245301 a 
                where a.t$ortp = 1
                  and a.t$koor = 3 
                group by a.t$slso,
                         a.t$fire$l ) cisli245orig
           ON  cisli245orig.t$slso = tdsls400orig.t$orno
        
    LEFT JOIN  BAANDB.tcisli940301 cisli940orig 
           ON  cisli940orig.t$fire$l = cisli245orig.t$fire$l

    LEFT JOIN BAANDB.ttcmcs080301 tcmcs080_orig
           ON tcmcs080_orig.t$cfrw = tdsls400orig.t$cfrw

    LEFT JOIN BAANDB.ttccom130301 tccom130_orig
           ON tccom130_orig.t$cadr = tcmcs080_orig.t$cadr$l 

    LEFT JOIN ( select  a.t$pecl$c,
                        a.t$orno$c,
                        a.t$etiq$c,
                        a.t$fili$c
                from baandb.tznfmd630301 a 
                group by a.t$pecl$c,
                         a.t$orno$c,
                         a.t$etiq$c,
                         a.t$fili$c ) znfmd630_orig       --JOIN PARA ENCONTRAR OVs NOVAS QUE SUBSTITUIRAM AS OVs CANCELADAS NO PEDIDO DO SITE
           ON TO_CHAR(znfmd630_orig.t$pecl$c) = TO_CHAR(znsls401orig.t$entr$c)    --tem que usar a entrega, pois a OV não foi atualizada, está cancelada
           
    LEFT JOIN ( select a.t$fire$l,
                       a.t$slso
                from baandb.tcisli245301 a
                group by a.t$fire$l,
                         a.t$slso ) SLI245_orig
          ON SLI245_orig.t$slso = znfmd630_orig.t$orno$c    --Nova Ordem de Venda, que subistituiu a cancelada
          
    LEFT JOIN baandb.tcisli940301 SLI940_orig
           ON SLI940_orig.t$fire$l = SLI245_orig.t$fire$l   --Nova nota fiscal   
           
           
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
--       AND znfmd630dev.t$fire$c = cisli940dev.t$fire$l
        
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
 
 LEFT JOIN (select a.t$orno,
                   a.t$hrea
            from baandb.ttdsls420301 a
            where a.t$sqnb = 0
            group by a.t$orno,
                     a.t$sqnb,
                     a.t$hrea ) tdsls420dev
        ON tdsls420dev.t$orno = znsls401dev.t$orno$c
  
 LEFT JOIN ( select a.t$hrea,
                    a.t$dsca
             from   baandb.ttdsls090301 a ) tdsls090dev
        ON tdsls090dev.t$hrea = tdsls420dev.t$hrea

LEFT JOIN ( select a.t$ncmp$c,
                   a.t$cref$c,
                   a.t$cfoc$c,
                   a.t$docn$c,
                   a.t$seri$c,
                   a.t$doty$c,
                   a.t$trdt$c,
                   a.t$creg$c,
                   a.t$cfov$c,
                   a.t$orno$c,
                   a.t$pono$c,
                   a.t$sige$c
            from baandb.tznmcs096301 a 
            group by a.t$ncmp$c,
                     a.t$cref$c,
                     a.t$cfoc$c,
                     a.t$docn$c,
                     a.t$seri$c,
                     a.t$doty$c,
                     a.t$trdt$c,
                     a.t$creg$c,
                     a.t$cfov$c,
                     a.t$orno$c,
                     a.t$pono$c,
                     a.t$sige$c ) znmcs096dev
        ON znmcs096dev.t$orno$c = cisli245dev.t$slso
       AND znmcs096dev.t$pono$c = cisli245dev.t$pono
       AND znmcs096dev.t$ncmp$c = 2    --Faturamento       

  LEFT JOIN baandb.tznfmd001301 znfmd001dev
         ON znfmd001dev.t$fovn$c = znmcs096dev.t$cfoc$c
         
  WHERE znsls401dev.t$idor$c = 'TD'
    AND znsls401dev.t$qtve$c < 0
    AND znsls409.t$lbrd$c = 1        --Forcado = Sim
   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400dev.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 
              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataOcorrenciaDe 
          And :DataOcorrenciaAte
  AND NVL(tcmcs080_dev.t$cfrw,'-1') IN (:Transportadora)
