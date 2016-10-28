    SELECT znsls400dev.t$idca$c                                     CANAL,
           CASE WHEN znsls409.t$fdat$c < to_date('01-01-1980', 'dd-mm-yyyy') 
                  THEN NULL
                ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls409.t$fdat$c, 
                         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                           AT time zone 'America/Sao_Paulo') AS DATE)   
           END                                                      DATA_FORCADO,
                           
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400dev.t$odat, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)           DATA_OCORRENCIA,
           znsls401dev.t$dsca$c                                     TIPO_DE_ENTREGA,  
           CASE WHEN znsls401dev.t$lmot$c = 'Selecione'
                  THEN znsls401dev.t$lass$c
                ELSE   znsls401dev.t$lmot$c
           END                                                      MOTIVO_ABERTURA, 
           znmcs002_TIPO.t$desc$c                                   TIPO_DA_ORDEM_DE_VENDA,
           ORDEM_COLETA.STATUS                                      STATUS_DA_ORDEM_DE_COLETA,

           tdsls420dev.t$hrea                                       MOTIVO_STATUS_ORDEM_DE_COLETA,

           CASE WHEN znsls400dev.t$sige$c = 1 
                  THEN replace(replace(znmcs092dev.t$fovt$c,'-'),'/')
                ELSE   replace(replace(tccom130_orig.t$fovn$l,'-'),'/')      
           END                                                      TRANSP_VENDA_CNPJ,
           CASE WHEN znsls400dev.t$sige$c = 1 
                  THEN tcmcs080sige.t$dsca
                ELSE   tccom130_orig.t$dsca 
           END                                                      TRANSP_VENDA_NOME,
           
           NVL(regexp_replace(tccom130_dev.t$fovn$l, '[^0-9]', ''),
                 tcmcs080_COLETA.t$fovn$l)                                TRANSP_COLETA_CNPJ,

           NVL(tccom130_dev.t$dsca, 
               tcmcs080_COLETA.t$dsca)                              TRANSP_COLETA_NOME,

           znsls401dev.t$orno$c                                     NUM_COLETA,
           znsls401dev.t$pecl$c                                     PEDIDO_CLIENTE,
           CASE WHEN znsls400dev.t$sige$c = 1 
                  THEN 'Sim' 
                ELSE   'Nao' 
           END                                                      PEDIDO_SIGE,

           CASE WHEN znsls400dev.t$sige$c = 1 
                  THEN znmcs096dev.t$sige$c
                ELSE   znsls401orig.t$entr$c 
           END                                                      ENTREGA_ORIGINAL,
           znsls401dev.t$entr$c                                     SEQUENCIAL_FORCADO,

           NVL(CASE WHEN znsls400dev.t$sige$c = 1
                      THEN znmcs096dev.t$docn$c
                    ELSE SLI940_orig.t$docn$l 
               END, znfmd630_orig.t$docn$c)                         NF_ORIGINAL,

           NVL(CASE WHEN znsls400dev.t$sige$c = 1 
                      THEN znmcs096dev.t$seri$c
                    ELSE   SLI940_orig.t$seri$l 
               END, znfmd630_orig.t$seri$c)                         SERIE_ORIGINAL,

           CASE WHEN znsls400dev.t$sige$c = 1 
                      THEN znfmd001dev.t$fili$c
                    ELSE   NVL(znfmd630_orig.t$fili$c, 
                               tcmcs080_FILIAL_ORI.t$fili$c)
           END                                                      FILIAL_DE_ORIGEM,
               
           Trim(tcibd001dev.t$item)                                 SKU_ITEM,
           tcibd001dev.t$dscb$c                                     DESCRICAO_ITEM,
           
           ( select znfmd001.t$fili$c 
               from baandb.tznfmd001301 znfmd001
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$fovn$l = znfmd001.t$fovn$c
              where tccom130.t$ftyp$l = 'PJ'
                and tccom130.t$cadr = tdrec940rec.t$sfra$l )         FILIAL_NFE,

           CASE WHEN znsls400dev.t$sige$c = 1 
                  THEN znmcs096dev.t$trdt$c
                ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940_orig.t$date$l, 
                         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                           AT time zone 'America/Sao_Paulo') AS DATE) 
           END                                                      DT_EMISSAO_NF_VENDA,    
           tdrec940rec.t$docn$l                                     NFE,
           tdrec940rec.t$seri$l                                     SERIE_NFE,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$date$l, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)           DATA_REFERENCIA_FISCAL,
           tdrec940rec.t$fire$l                                     NR,
           cisli940dev.t$docn$l                                     NFS,
           cisli940dev.t$seri$l                                     SERIE_NFS,
           ABS(znsls401dev.t$qtve$c)                                QTDE_ITEM_DEVOLVIDO,
           ABS(znsls401dev.t$qtve$c) * znsls401dev.t$vlun$c - 
           znsls401dev.t$vldi$c                                     VALOR_TOTAL_DO_ITEM,
           znsls401dev.t$vlfr$c                                     VALOR_TOTAL_DO_FRETE,
           (ABS(znsls401dev.t$qtve$c) * znsls401dev.t$vlun$c) -
           znsls401dev.t$vldi$c +
           znsls401dev.t$vlfr$c                                     VALOR_TOTAL,

           cisli940dev.t$amnt$l                                     VALOR_NFS,
           znfmd630dev.t$etiq$c                                     ETIQUETA_DEVOLUCAO,
           znfmd630dev.nr_etiq                                      QTDE_ETIQUETAS,
           znfmd630_orig.t$etiq$c                                   ETIQUETA_VENDA,
           'Sim'                                                    FORCADA,
           znsls410.t$poco$c                                        ULT_PONTO_ENTREGA,
           znmcs002.t$desc$c                                        DESCRICAO_ULT_PONTO_ENTREGA,
           
           ttaad200.t$name                                          USUARIO_DA_BAIXA_DO_PONTO,
           znint407.t$idus$c                                        USUARIO_QUE_FORCOU_PEDIDO,
           znint407.t$motv$c                                        MOTIVO_FORCOU_PEDIDO,
           znsls401dev.t$cepe$c                                     CEP_DESTINATARIO,
           znsls401dev.t$cide$c                                     CIDADE,
           znsls401dev.t$ufen$c                                     ESTADO,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940dev.t$date$l, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)           DT_NF_COLETA,
           znsls401dev.t$desc$c                                     BANDEIRA,
           CASE WHEN znsls402_dev.t$vlmr$c IS NULL 
                  THEN 'REENVIO'
                ELSE   'REEMBOLSO' 
           END                                                      FORMA_DE_ATENDIMENTO,
           
           CASE WHEN  znsls409.t$inut$c = 1 
                  THEN 'SIM' 
                ELSE   'NAO'
           END                                                      ALTERACAO_SUBSTITUICAO,
           CASE WHEN znsls409.t$dtin$c = '01/01/1970' 
                  THEN NULL 
                ELSE znsls409.t$dtin$c
           END                                                      DATA_ALTERACAO

FROM       ( select znsls409.t$ncia$c,
                    znsls409.t$uneg$c,
                    znsls409.t$pecl$c,
                    znsls409.t$sqpd$c,
                    znsls409.t$entr$c,
                    znsls409.t$inut$c,
                    znsls409.t$lbrd$c,
                    min(znsls409.t$orno$c) KEEP (DENSE_RANK FIRST ORDER BY znsls409.t$fdat$c) t$orno$c,
                    min(znsls409.t$fdat$c) t$fdat$c,
                    min(znsls409.t$dtin$c) t$dtin$c
               from baandb.tznsls409301 znsls409 
              where znsls409.t$lbrd$c = 1
           group by znsls409.t$ncia$c,
                    znsls409.t$uneg$c,
                    znsls409.t$pecl$c,
                    znsls409.t$sqpd$c,
                    znsls409.t$entr$c,
                    znsls409.t$inut$c,
                    znsls409.t$lbrd$c ) znsls409

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
                    znint002.t$desc$c,
                    znsls002.t$dsca$c,
                    MIN(znsls401.t$pono$c) t$pono$c,
                    SUM(znsls401.t$qtve$c) t$qtve$c,
                    SUM(znsls401.t$vlfr$c) t$vlfr$c,
                    SUM(znsls401.t$vldi$c) t$vldi$c,
                    znsls401.t$vlun$c,
                    znsls401.t$cepe$c,
                    znsls401.t$cide$c,
                    znsls401.t$ufen$c,
                    znsls401.t$itml$c,
                    znsls401.t$idor$c,
                    znsls401.t$iitm$c
               from BAANDB.tznsls401301 znsls401
          left join baandb.tznint002301 znint002
                 on znint002.t$ncia$c = znsls401.t$ncia$c
                and znint002.t$uneg$c = znsls401.t$uneg$c
          left join baandb.tznsls002301 znsls002 --88*
                 on znsls002.t$tpen$c = znsls401.t$itpe$c
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
                    znint002.t$desc$c,
                    znsls002.t$dsca$c,
                    znsls401.t$vlun$c,
                    znsls401.t$cepe$c,
                    znsls401.t$cide$c,
                    znsls401.t$ufen$c,
                    znsls401.t$itml$c,
                    znsls401.t$idor$c,
                    znsls401.t$iitm$c ) znsls401dev
        ON znsls409.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls409.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls409.t$pecl$c = znsls401dev.t$pecl$c
       AND znsls409.t$sqpd$c = znsls401dev.t$sqpd$c
       AND znsls409.t$entr$c = znsls401dev.t$entr$c

INNER JOIN BAANDB.tznsls400301 znsls400dev
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

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    max(a.t$dtoc$c) t$dtoc$c,
                    max(a.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C,  a.T$SEQN$C) t$poco$c
               from baandb.tznsls410301 a
         inner join baandb.tznsls409301 b
                 on b.t$ncia$c = a.t$ncia$c
                and b.t$uneg$c = a.t$uneg$c
                and b.t$pecl$c = a.t$pecl$c
                and b.t$sqpd$c = a.t$sqpd$c
                and b.t$entr$c = a.t$entr$c
              where a.t$poco$c != ' '
                and a.t$dtoc$c < case when b.t$fdat$c < to_date('01-01-1980', 'DD-MM-YYYY') 
                                        then SYSDATE 
                                      else   b.t$fdat$c 
                                 end
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c ) znsls410
        ON znsls410.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls410.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls410.t$pecl$c = znsls401dev.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401dev.t$sqpd$c
       AND znsls410.t$entr$c = znsls401dev.t$entr$c

 LEFT JOIN BAANDB.tcisli245301 cisli245dev
        ON cisli245dev.t$slso = znsls401dev.t$orno$c
       AND cisli245dev.t$pono = znsls401dev.t$pono$c
       AND cisli245dev.t$ortp = 1
       AND cisli245dev.t$koor = 3

 LEFT JOIN BAANDB.tcisli940301 cisli940dev  
        ON cisli940dev.t$fire$l = cisli245dev.t$fire$l
             
 LEFT JOIN ( select tdrec947.t$orno$l,
                    tdrec947.t$pono$l,
                    tdrec947.t$fire$l,
                    tdrec940.t$docn$l,
                    tdrec940.t$seri$l,
                    tdrec940.t$date$l,
                    tdrec940.t$sfra$l
               from baandb.ttdrec947301 tdrec947
         inner join BAANDB.ttdrec940301 tdrec940
                 on tdrec940.t$fire$l = tdrec947.t$fire$l
                and tdrec940.t$stat$l in (4,5)
                and tdrec940.t$rfdt$l = 10
              where tdrec947.t$oorg$l = 1
                and Trim(tdrec947.t$rcno$l) is not null
           group by tdrec947.t$orno$l,
                    tdrec947.t$pono$l,
                    tdrec947.t$fire$l,
                    tdrec940.t$docn$l,
                    tdrec940.t$seri$l,
                    tdrec940.t$date$l,
                    tdrec940.t$sfra$l ) tdrec940rec
        ON tdrec940rec.t$orno$l = znsls401dev.t$orno$c
       AND tdrec940rec.t$pono$l = znsls401dev.t$pono$c
        
 LEFT JOIN ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                    tcmcs080.t$dsca,
                    tcmcs080.t$cfrw
               from baandb.ttcmcs080301 tcmcs080
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$cadr = tcmcs080.t$cadr$l
              where tccom130.t$ftyp$l = 'PJ' ) tccom130_dev
        ON tccom130_dev.t$cfrw = cisli940dev.t$cfrw$l

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    max(a.t$vlmr$c) t$vlmr$c
               from BAANDB.tznsls402301 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c ) znsls402_dev
        ON znsls402_dev.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls402_dev.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls402_dev.t$pecl$c = znsls401dev.t$pvdt$c
       AND znsls402_dev.t$sqpd$c = znsls401dev.t$sqpd$c

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
                    a.t$entr$c ) znsls004dev
        ON znsls004dev.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls004dev.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls004dev.t$pecl$c = znsls401dev.t$pecl$c
       AND znsls004dev.t$entr$c = znsls401dev.t$entr$c

 LEFT JOIN BAANDB.ttdsls400301 tdsls400orig  -- ordem de venda origem
        ON tdsls400orig.t$orno = znsls401orig.t$orno$c          
        
 LEFT JOIN ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                    tcmcs080.t$dsca,
                    tcmcs080.t$cfrw
               from baandb.ttcmcs080301 tcmcs080
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$cadr = tcmcs080.t$cadr$l
              where tccom130.t$ftyp$l = 'PJ' ) tccom130_orig
        ON tccom130_orig.t$cfrw = tdsls400orig.t$cfrw
        
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

 LEFT JOIN ( select znfmd001.t$fili$c,
                    tccom130.t$cadr
               from baandb.tznfmd001301 znfmd001
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$fovn$l = znfmd001.t$fovn$c
              where tccom130.t$ftyp$l = 'PJ' ) tcmcs080_FILIAL_ORI
        ON tcmcs080_FILIAL_ORI.t$cadr = SLI940_orig.t$sfra$l

 LEFT JOIN baandb.tznmcs002301 znmcs002
        ON znmcs002.t$poco$c = znsls410.t$poco$c

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    znsls410.t$entr$c,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) t$poco$c,
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
                    znsls410.t$entr$c ) TIPO_INST
        ON TIPO_INST.t$ncia$c = znsls401dev.t$ncia$c
       AND TIPO_INST.t$uneg$c = znsls401dev.t$uneg$c
       AND TIPO_INST.t$pecl$c = znsls401dev.t$pecl$c
       AND TIPO_INST.t$sqpd$c = znsls401dev.t$sqpd$c
       AND TIPO_INST.t$entr$c = znsls401dev.t$entr$c

 LEFT JOIN baandb.tznmcs002301 znmcs002_TIPO
        ON znmcs002_TIPO.t$poco$c = TIPO_INST.t$poco$c
       
 LEFT JOIN ( select a.t$pecl$c,
                    a.t$orno$c,
                    a.t$fili$c,
                    a.t$fire$c,
                    min(a.t$etiq$c) t$etiq$c,
                    count(a.t$etiq$c) nr_etiq
               from baandb.tznfmd630301 a
         inner join baandb.tcisli940301 b
                 on b.t$fire$l = a.t$fire$c
              where b.t$stat$l IN (5,6)      --5-Impressa, 6-Lancada
           group by a.t$pecl$c,
                    a.t$orno$c,
                    a.t$fili$c,
                    a.t$fire$c,
                    a.t$docn$c,
                    a.t$seri$c ) znfmd630dev
        ON TO_CHAR(znfmd630dev.t$pecl$c) = TO_CHAR(znsls401dev.t$entr$c)    --tem que usar a entrega, pois a OV pode estar cancelada
       AND znfmd630dev.t$fire$c = cisli245dev.t$fire$l
       AND znfmd630dev.t$orno$c = znsls004dev.t$orno$c

 LEFT JOIN ( Select a.t$fili$c,
                    a.t$etiq$c,
                    a.t$coci$c,
                    MAX(a.t$ulog$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DATE$C) t$ulog$c
               from baandb.tznfmd640301 a
           group by a.t$fili$c,
                    a.t$etiq$c,
                    a.t$coci$c) znfmd640
        ON znfmd640.t$fili$c = znfmd630dev.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630dev.t$etiq$c
       AND znfmd640.t$coci$c = znsls410.t$poco$c

 LEFT JOIN ( select a.t$user,
                    a.t$name
               from baandb.tttaad200000 a ) ttaad200
        ON ttaad200.t$user = znfmd640.t$ulog$c
         
 LEFT JOIN ( select a.t$orno, a.t$pono,
                    a.t$hrea
               from baandb.ttdsls420301 a
              where a.t$sqnb = 0
           group by a.t$orno, a.t$pono,
                    a.t$sqnb,
                    a.t$hrea ) tdsls420dev
        ON tdsls420dev.t$orno = znsls401dev.t$orno$c
       AND tdsls420dev.t$pono = znsls401dev.t$pono$c

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

 LEFT JOIN baandb.tznmcs092301 znmcs092dev
        ON znmcs092dev.t$ncmp$c = znmcs096dev.t$ncmp$c
       AND znmcs092dev.t$cref$c = znmcs096dev.t$cref$c
       AND znmcs092dev.t$cfoc$c = znmcs096dev.t$cfoc$c
       AND znmcs092dev.t$docn$c = znmcs096dev.t$docn$c
       AND znmcs092dev.t$seri$c = znmcs096dev.t$seri$c
       AND znmcs092dev.t$doty$c = znmcs096dev.t$doty$c
       AND znmcs092dev.t$trdt$c = znmcs096dev.t$trdt$c
       AND znmcs092dev.t$creg$c = znmcs096dev.t$creg$c
       AND znmcs092dev.t$cfov$c = znmcs096dev.t$cfov$c

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

 LEFT JOIN baandb.ttccom130301 tccom130sige
        ON tccom130sige.t$ftyp$l = znmcs092dev.t$crgt$c
       AND tccom130sige.t$fovn$l = znmcs092dev.t$fovt$c
       
 LEFT JOIN baandb.ttcmcs080301 tcmcs080sige
        ON tcmcs080sige.t$cadr$l = tccom130sige.t$cadr
 
 LEFT JOIN baandb.tznfmd001301 znfmd001dev
        ON znfmd001dev.t$fovn$c = znmcs096dev.t$cfoc$c
 
 LEFT JOIN baandb.tznisa002301 znisa002
        ON znisa002.t$npcl$c = tcibd001dev.t$npcl$c

 LEFT JOIN ( select znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c,
                    znsls004.t$orno$c,
                    znint407.t$idus$c,
                    znint407.t$motv$c 
               from baandb.tznsls004301 znsls004
         inner join baandb.tznint407301 znint407
                 on znint407.t$ncia$c = znsls004.t$ncia$c
                and znint407.t$uneg$c = znsls004.t$uneg$c
                and znint407.t$pecl$c = znsls004.t$pecl$c
                and znint407.t$sqpd$c = znsls004.t$sqpd$c
                and znint407.t$entr$c = znsls004.t$entr$c
           group by znsls004.t$ncia$c,
                    znsls004.t$uneg$c,
                    znsls004.t$pecl$c,
                    znsls004.t$sqpd$c,
                    znsls004.t$entr$c,
                    znsls004.t$orno$c,
                    znint407.t$idus$c,
                    znint407.t$motv$c ) znint407
        ON znint407.t$orno$c = znsls409.t$orno$c

 LEFT JOIN ( select l.t$desc STATUS,
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

     WHERE 
--znsls409.t$lbrd$c = 1        --Forcado = Sim
--AND 
--NVL(NVL(Trim(tcmcs080_dev.t$cfrw), Trim(tdsls400dev.t$cfrw)), -1) IN (:Transportadora)
NVL(Trim(tdsls400dev.t$cfrw), -1) IN (:Transportadora)