    SELECT znsls400dev.t$idca$c                                           CANAL,
           CASE WHEN znsls409.t$fdat$c < to_date('01-01-1980', 'dd-mm-yyyy') 
                  THEN NULL
                ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls409.t$fdat$c, 
                         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                           AT time zone 'America/Sao_Paulo') AS DATE)   
           END                                                            DATA_FORCADO,
                           
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400dev.t$odat, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)                 DATA_OCORRENCIA,
           znsls401dev.t$dsca$c                                           TIPO_DE_ENTREGA,  
           regexp_replace(CASE WHEN znsls401dev.t$lmot$c = 'Selecione'
                                 THEN znsls401dev.t$lass$c
                               ELSE   znsls401dev.t$lmot$c

                          END, '( *[[:punct:]])', null)                   MOTIVO_ABERTURA, 
           znmcs002_TIPO.t$desc$c                                         TIPO_DA_ORDEM_DE_VENDA,
           ORDEM_COLETA.STATUS                                            STATUS_DA_ORDEM_DE_COLETA,

           tdsls420dev.t$hrea                                             MOTIVO_STATUS_ORDEM_DE_COLETA,
      
           NVL(regexp_replace(tccom130_orig.t$fovn$l, '[^0-9]', ''), 
               regexp_replace(znmcs092dev.t$fovt$c,   '[^0-9]', ''))      TRANSP_VENDA_CNPJ,
           NVL(tccom130_orig.t$dsca, tcmcs080sige.t$dsca)                 TRANSP_VENDA_NOME,
           NVL(regexp_replace(tccom130_dev.t$fovn$l,    '[^0-9]', ''),
               regexp_replace(tcmcs080_COLETA.t$fovn$l, '[^0-9]', ''))    TRANSP_COLETA_CNPJ,

           NVL(tccom130_dev.t$dsca, 
               tcmcs080_COLETA.t$dsca)                                    TRANSP_COLETA_NOME,

           znsls401dev.t$orno$c                                           NUM_COLETA,
           znsls401dev.t$pecl$c                                           PEDIDO_CLIENTE,
           CASE WHEN znsls400dev.t$sige$c = 1 
                  THEN 'Sim' 
                ELSE   'Nao' 
           END                                                            PEDIDO_SIGE,

           NVL(NOTA_VENDA.t$entr$c, znmcs096dev.t$sige$c)                 ENTREGA_ORIGINAL,
           znsls409.t$entr$c                                              SEQUENCIAL_FORCADO,

           NVL(NOTA_VENDA.t$docn$l, znmcs096dev.t$docn$c)                 NF_ORIGINAL,
           NVL(NOTA_VENDA.t$seri$l, znmcs096dev.t$seri$c)                 SERIE_ORIGINAL,

           NVL(tcmcs080_FILIAL_ORI.t$fili$c, znfmd001dev.t$fili$c)        FILIAL_DE_ORIGEM,

           Trim(tcibd001dev.t$item)                                       SKU_ITEM,
           tcibd001dev.t$dscb$c                                           DESCRICAO_ITEM,
           
           ( select znfmd001.t$fili$c 
               from baandb.tznfmd001301 znfmd001
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$fovn$l = znfmd001.t$fovn$c
              where tccom130.t$ftyp$l = 'PJ'
                and tccom130.t$cadr = tdrec940rec.t$sfra$l )              FILIAL_NFE,

           NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(NOTA_VENDA.t$date$l, 
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') AS DATE),
               znmcs096dev.t$trdt$c)                                      DT_EMISSAO_NF_VENDA,
               
           tdrec940rec.t$docn$l                                           NFE,
           tdrec940rec.t$seri$l                                           SERIE_NFE,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940rec.t$date$l, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)                 DATA_REFERENCIA_FISCAL,
           tdrec940rec.t$fire$l                                           NR,
           cisli940dev.t$docn$l                                           NFS,
           cisli940dev.t$seri$l                                           SERIE_NFS,
           ABS(znsls401dev.t$qtve$c)                                      QTDE_ITEM_DEVOLVIDO,

           ROUND(ABS(znsls401dev.t$qtve$c) * 
                     znsls401dev.t$vlun$c  - 
                 znsls401dev.t$vldi$c, 2)                                 VALOR_TOTAL_DO_ITEM,
           ROUND(znsls401dev.t$vlfr$c, 2)                                 VALOR_TOTAL_DO_FRETE,
           ROUND((ABS(znsls401dev.t$qtve$c) * 
                      znsls401dev.t$vlun$c) -
                 znsls401dev.t$vldi$c        +
                 znsls401dev.t$vlfr$c, 2)                                 VALOR_TOTAL,
           ROUND(cisli940dev.t$amnt$l, 2)                                 VALOR_NFS,

           regexp_replace(znfmd630dev.t$etiq$c, '( *[[:punct:]])', null)  ETIQUETA_DEVOLUCAO,
           znfmd630dev.nr_etiq                                            QTDE_ETIQUETAS,
           regexp_replace(znfmd630_venda.t$etiq$c,'( *[[:punct:]])', null)ETIQUETA_VENDA,
           'Sim'                                                          FORCADA,
           znsls410.t$poco$c                                              ULT_PONTO_ENTREGA,
           znmcs002.t$desc$c                                              DESCRICAO_ULT_PONTO_ENTREGA,
           
           ttaad200.t$name                                                USUARIO_DA_BAIXA_DO_PONTO,
           znint407.t$idus$c                                              USUARIO_QUE_FORCOU_PEDIDO,
           regexp_replace(znint407.t$motv$c, '( *[[:punct:]])', null)     MOTIVO_FORCOU_PEDIDO,
           znsls401dev.t$cepe$c                                           CEP_DESTINATARIO,
           znsls401dev.t$cide$c                                           CIDADE,
           znsls401dev.t$ufen$c                                           ESTADO,
           CASE WHEN Trunc(cisli940dev.t$date$l) = To_Date('01-01-1970', 'dd-mm-yyyy') 
                  THEN NULL 
                ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940dev.t$date$l, 
                         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                           AT time zone 'America/Sao_Paulo') AS DATE)
           END                                                            DT_NF_COLETA,

           znsls401dev.t$desc$c                                           BANDEIRA,
           CASE WHEN znsls402_dev.t$vlmr$c IS NULL 
                  THEN 'REENVIO'
                ELSE   'REEMBOLSO' 
           END                                                            FORMA_DE_ATENDIMENTO,
           
           CASE WHEN  znsls409.t$inut$c = 1 
                  THEN 'SIM' 
                ELSE   'NAO'
           END                                                            ALTERACAO_SUBSTITUICAO,
           CASE WHEN znsls409.t$dtin$c = To_Date('01-01-1970', 'dd-mm-yyyy') 
                  THEN NULL 
                ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls409.t$dtin$c, 
                       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                         AT time zone 'America/Sao_Paulo') AS DATE)

           END                                                            DATA_ALTERACAO

FROM       ( select znsls409.t$ncia$c,
                    znsls409.t$uneg$c,
                    znsls409.t$pecl$c,
                    znsls409.t$sqpd$c,
                    znsls409.t$entr$c,
                    znsls409.t$inut$c,
                    znsls409.t$lbrd$c,
                    znsls409.t$orno$c,
                    znsls409.t$dorn$c,
                    znsls409.t$fdat$c,
                    znsls409.t$dtin$c t$dtin$c
               from baandb.tznsls409301 znsls409 
              where znsls409.t$lbrd$c = 1
                and (znsls409.t$orno$c, znsls409.t$fdat$c) = ( select min(znsls409a.t$orno$c) KEEP (DENSE_RANK FIRST ORDER BY znsls409a.t$fdat$c) t$orno$c,
                                                                      min(znsls409a.t$fdat$c) t$fdat$c
                                                                 from baandb.tznsls409301 znsls409a 
                                                                where znsls409a.t$lbrd$c = 1
                                                                  and Trunc(znsls409a.t$fdat$c) != To_Date('01-01-1970', 'dd-mm-yyyy')
                                                                  and znsls409.t$ncia$c = znsls409a.t$ncia$c
                                                                  and znsls409.t$uneg$c = znsls409a.t$uneg$c
                                                                  and znsls409.t$pecl$c = znsls409a.t$pecl$c
                                                                  and znsls409.t$sqpd$c = znsls409a.t$sqpd$c
                                                                  and znsls409.t$entr$c = znsls409a.t$entr$c ) ) znsls409

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
                    znsls401.t$iitm$c,
                    tdsls420.t$hrea
               from BAANDB.tznsls401301 znsls401
          left join baandb.tznint002301 znint002                                /*+ index(baandb.tznint002301 TZNINT002301$IDX1)*/
                 on znint002.t$ncia$c = znsls401.t$ncia$c
                and znint002.t$uneg$c = znsls401.t$uneg$c
          left join baandb.tznsls002301 znsls002                                /*+ index(baandb.tznsls002301 TZNSLS002301$IDX1)*/
                 on znsls002.t$tpen$c = znsls401.t$itpe$c
          left join baandb.ttdsls420301 tdsls420          --Consulta se tem bloqueio na OV
                 on tdsls420.t$orno = znsls401.t$orno$c
                and tdsls420.t$pono = znsls401.t$pono$c
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
                    znsls401.t$iitm$c,
                    tdsls420.t$hrea ) znsls401dev
        ON znsls409.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls409.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls409.t$pecl$c = znsls401dev.t$pecl$c
       AND znsls409.t$sqpd$c = znsls401dev.t$sqpd$c
       AND znsls409.t$entr$c = znsls401dev.t$entr$c
       AND znsls409.t$dorn$c = znsls401dev.t$orno$c

INNER JOIN BAANDB.tznsls400301 znsls400dev                                      /*+ index(baandb.tznsls400301 TZNSLS400301$IDX1)*/
        ON znsls400dev.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls400dev.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls400dev.t$pecl$c = znsls401dev.t$pecl$c
       AND znsls400dev.t$sqpd$c = znsls401dev.t$sqpd$c

INNER JOIN BAANDB.ttcibd001301 tcibd001dev                                      /*+ index(baandb.ttcibd001301 TTCIBD001301$IDX1)*/
        ON tcibd001dev.t$item = znsls401dev.t$itml$c

INNER JOIN BAANDB.ttdsls400301 tdsls400dev                                      /*+ index(baandb.ttdsls400301 TTDSLS400301$IDX1)*/
        ON tdsls400dev.t$orno = znsls401dev.t$orno$c  -- Ordem de venda devolução  

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
                    max(a.t$vlmr$c) t$vlmr$c
               from BAANDB.tznsls402301 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c ) znsls402_dev           /*+ index(baandb.tznsls402301 TZNSLS402301$IDX1)*/
        ON znsls402_dev.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls402_dev.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls402_dev.t$pecl$c = znsls401dev.t$pvdt$c
       AND znsls402_dev.t$sqpd$c = znsls401dev.t$sqpd$c

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
                    a.t$entr$c ) znsls004dev                                    /*+ index(baandb.tznsls004301 TZNSLS004301$IDX1)*/
        ON znsls004dev.t$ncia$c = znsls401dev.t$ncia$c
       AND znsls004dev.t$uneg$c = znsls401dev.t$uneg$c
       AND znsls004dev.t$pecl$c = znsls401dev.t$pecl$c
       AND znsls004dev.t$sqpd$c = znsls401dev.t$sqpd$c
       AND znsls004dev.t$entr$c = znsls401dev.t$entr$c

 LEFT JOIN ( select a.t$ncmp$c,
                    a.t$orno$c,
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
                    a.t$fire$c ) znmcs096dev
        ON znmcs096dev.t$orno$c = znsls409.t$dorn$c
       AND znmcs096dev.t$ncmp$c = 2    --Faturamento

 LEFT JOIN ( select cisli245dev.t$slso, 
                    cisli245dev.t$pono, 
                    cisli245dev.t$fire$l, 
                    cisli940dev.t$cfrw$l, 
                    cisli940dev.t$date$l, 
                    cisli940dev.t$amnt$l, 
                    cisli940dev.t$docn$l, 
                    cisli940dev.t$seri$l
               from BAANDB.tcisli245301 cisli245dev
         inner join BAANDB.tcisli940301 cisli940dev                             /*+ index(baandb.tcisli940301 TCISLI940301$IDX1)*/
                 on cisli940dev.t$fire$l = cisli245dev.t$fire$l
              where cisli245dev.t$ortp = 1
                and cisli245dev.t$koor = 3 ) cisli940dev
        ON cisli940dev.t$slso = znsls401dev.t$orno$c
       AND cisli940dev.t$pono = znsls401dev.t$pono$c

 LEFT JOIN ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                    tcmcs080.t$dsca,
                    tcmcs080.t$cfrw
               from baandb.ttcmcs080301 tcmcs080
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$cadr = tcmcs080.t$cadr$l
              where tccom130.t$ftyp$l = 'PJ' ) tccom130_dev
        ON tccom130_dev.t$cfrw = cisli940dev.t$cfrw$l

 LEFT JOIN ( select tdrec947.t$orno$l,
                    tdrec947.t$pono$l,
                    tdrec947.t$fire$l,
                    tdrec940.t$docn$l,
                    tdrec940.t$seri$l,
                    tdrec940.t$date$l,
                    tdrec940.t$sfra$l
               from baandb.ttdrec947301 tdrec947
         inner join BAANDB.ttdrec940301 tdrec940                                /*+ index(baandb.ttdrec940301 TTDREC940301$IDX1)*/
                 on tdrec940.t$fire$l = tdrec947.t$fire$l
              where tdrec947.t$oorg$l = 1
                and Trim(tdrec947.t$rcno$l) is not null
                and tdrec940.t$stat$l in (4,5)
                and tdrec940.t$rfdt$l = 10
           group by tdrec947.t$orno$l,
                    tdrec947.t$pono$l,
                    tdrec947.t$fire$l,
                    tdrec940.t$docn$l,
                    tdrec940.t$seri$l,
                    tdrec940.t$date$l,
                    tdrec940.t$sfra$l ) tdrec940rec
        ON tdrec940rec.t$orno$l = znsls401dev.t$orno$c
       AND tdrec940rec.t$pono$l = znsls401dev.t$pono$c

 LEFT JOIN ( select tdsls401_dev.t$orno, 
                    tdsls401_dev.t$pono, 
                    tdsls401_dev.t$fire$l,                         --nota de venda
                    tdsls401_dev.t$line$l                          --nota de venda
               from BAANDB.ttdsls401301 tdsls401_dev               --Troca/Devolucao
         inner join baandb.ttcibd001301  tcibd001
                 on tcibd001.t$item = tdsls401_dev.t$item
              where Trim(tdsls401_dev.t$fire$l) is not null
                and tcibd001.t$kitm = 1
           group by tdsls401_dev.t$orno, 
                    tdsls401_dev.t$pono, 
                    tdsls401_dev.t$fire$l,
                    tdsls401_dev.t$line$l ) tdsls401_dev
        ON tdsls401_dev.t$orno = znsls409.t$dorn$c
       AND tdsls401_dev.t$pono = znsls401dev.t$pono$c

 LEFT JOIN ( select cisli245_ven.t$fire$l,
                    cisli245_ven.t$line$l, 
                    cisli245_ven.t$slso, 
                    znsls004_ven.t$entr$c, 
                    znsls004_ven.t$orno$c, 
                    cisli940_ven.t$docn$l, 
                    cisli940_ven.t$seri$l, 
                    cisli940_ven.t$date$l, 
                    cisli940_ven.t$sfra$l
               from baandb.tcisli245301 cisli245_ven              --nota de venda
          left join baandb.tznsls004301 znsls004_ven              --Pedido de venda
                 on znsls004_ven.t$orno$c = cisli245_ven.t$slso
          left join baandb.tcisli940301 cisli940_ven
                 on cisli940_ven.t$fire$l = cisli245_ven.t$fire$l
              where cisli245_ven.t$ortp = 1
                and cisli245_ven.t$koor = 3
           group by cisli245_ven.t$fire$l,
                    cisli245_ven.t$line$l, 
                    cisli245_ven.t$slso, 
                    znsls004_ven.t$entr$c, 
                    znsls004_ven.t$orno$c, 
                    cisli940_ven.t$docn$l, 
                    cisli940_ven.t$seri$l, 
                    cisli940_ven.t$date$l, 
                    cisli940_ven.t$sfra$l ) NOTA_VENDA
        ON NOTA_VENDA.t$fire$l = tdsls401_dev.t$fire$l --nota de venda
       AND NOTA_VENDA.t$line$l = tdsls401_dev.t$line$l

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
                    a.t$fire$c ) znfmd630_venda  --etiqueta venda
        ON TO_CHAR(znfmd630_venda.t$pecl$c) = NVL(NOTA_VENDA.t$entr$c, znmcs096dev.t$sige$c)
       AND znfmd630_venda.t$fire$c          = NVL(NOTA_VENDA.t$fire$l, znmcs096dev.t$fire$c)
       AND znfmd630_venda.t$orno$c          = NOTA_VENDA.t$orno$c

 LEFT JOIN BAANDB.ttdsls400301 tdsls400orig          -- ordem de venda origem
        ON tdsls400orig.t$orno = NOTA_VENDA.t$orno$c 

 LEFT JOIN ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                    tcmcs080.t$dsca,
                    tcmcs080.t$cfrw
               from baandb.ttcmcs080301 tcmcs080
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$cadr = tcmcs080.t$cadr$l
              where tccom130.t$ftyp$l = 'PJ' ) tccom130_orig
        ON tccom130_orig.t$cfrw = tdsls400orig.t$cfrw


 LEFT JOIN ( select znfmd001.t$fili$c,
                    tccom130.t$cadr
               from baandb.tznfmd001301 znfmd001
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$fovn$l = znfmd001.t$fovn$c
              where tccom130.t$ftyp$l = 'PJ' ) tcmcs080_FILIAL_ORI
        ON tcmcs080_FILIAL_ORI.t$cadr = NOTA_VENDA.t$sfra$l

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
       
 LEFT JOIN baandb.tznmcs002301 znmcs002
        ON znmcs002.t$poco$c = znsls410.t$poco$c

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
        ON TO_CHAR(znfmd630dev.t$pecl$c) = TO_CHAR(znsls401dev.t$entr$c)
       AND znfmd630dev.t$fire$c = cisli940dev.t$fire$l
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

 LEFT JOIN baandb.ttccom130301 tccom130sige
        ON tccom130sige.t$ftyp$l = znmcs092dev.t$crgt$c
       AND tccom130sige.t$fovn$l = znmcs092dev.t$fovt$c
       
 LEFT JOIN baandb.ttcmcs080301 tcmcs080sige
        ON tcmcs080sige.t$cadr$l = tccom130sige.t$cadr
 
 LEFT JOIN baandb.tznfmd001301 znfmd001dev
        ON znfmd001dev.t$fovn$c = znmcs096dev.t$cfoc$c
 
 LEFT JOIN baandb.tznisa002301 znisa002
        ON znisa002.t$npcl$c = tcibd001dev.t$npcl$c
 
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
                    a.t$entr$c ) znsls004
        ON znsls004.t$orno$c = znsls409.t$orno$c

 LEFT JOIN ( select a.t$orno, a.t$pono,
                    a.t$hrea
               from baandb.ttdsls420301 a
              where a.t$sqnb = 0
           group by a.t$orno, a.t$pono,
                    a.t$hrea ) tdsls420dev
        ON tdsls420dev.t$orno = znsls401dev.t$orno$c
       AND tdsls420dev.t$pono = znsls401dev.t$pono$c

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

 LEFT JOIN ( select znint407.t$ncia$c,
                    znint407.t$uneg$c,
                    znint407.t$pecl$c,
                    znint407.t$sqpd$c,
                    znint407.t$entr$c,
                    znint407.t$idus$c,
                    znint407.t$motv$c 
               from baandb.tznint407301 znint407
           group by znint407.t$ncia$c,
                    znint407.t$uneg$c,
                    znint407.t$pecl$c,
                    znint407.t$sqpd$c,
                    znint407.t$entr$c,
                    znint407.t$idus$c,
                    znint407.t$motv$c ) znint407
        ON znint407.t$ncia$c = znsls004.t$ncia$c
       AND znint407.t$uneg$c = znsls004.t$uneg$c
       AND znint407.t$pecl$c = znsls004.t$pecl$c
       AND znint407.t$sqpd$c = znsls004.t$sqpd$c
       AND znint407.t$entr$c = znsls004.t$entr$c

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

WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls409.t$fdat$c, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataForcadoDe
          And :DataForcadoAte

ORDER BY DATA_FORCADO, SEQUENCIAL_FORCADO