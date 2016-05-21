SELECT 
  DISTINCT
    CASE WHEN znsls401.t$itpe$c = 15   --REVERSA
           THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SOLIC_COLETA.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
         WHEN znsls401.t$itpe$c = 9    --POSTAGEM
           THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(POSTAGEM.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
         ELSE NULL 
    END                                       DATA_SOL_COLETA_POSTAGEM,
                              
    znsls401.t$pecl$c                         PEDIDO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_PEDIDO,
    CASE WHEN PAP_TD.DATA_OCORR IS NULL THEN
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
    ELSE
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(PAP_TD.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) END
                                              DATA_APROVACAO_PEDIDO,
             
    znfmd001.t$fili$c                         Estabelecimento,
    tccom130cnova.t$fovn$l                    CNPJ_NOVA,
    znint002.t$desc$c                         UNIDADE_NEGOCIO,
    znsls401.t$orno$c                         ORDEM_DEVOLUCAO,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400_2.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_ORDEM_DEVOLUCAO,
             
    znsls401.t$entr$c                         ENTREGA,
    znsls002.t$dsca$c                         TIPO_ENTREGA,
    znsls401.t$lass$c                         ASSUNTO,
    znsls401.t$lmot$c                         Motivo_da_Coleta,


    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CANC_PED.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_CANC_PEDIDO,
    CASE WHEN znsls409.t$lbrd$c = 1 
           THEN 'Sim' -- FORÇADO
         ELSE   'Não' -- NÃO FORÇADO
     END                                      IN_FORCADO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(EXPEDICAO.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_EXPEDICAO_PEDIDO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SOLIC_COLETA.DATA_DTPR, 'DD-MON-YYYY HH24:MI:SS'), 
      'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_COLETA_PROMETIDA,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SOLIC_COLETA.DATA_DTCD, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_RETORNO_PROMETIDA,
    CASE WHEN EXPEDICAO.NOME_TRANSP IS NULL 
           THEN VENDA_TRANSP.t$dsca
         ELSE   EXPEDICAO.NOME_TRANSP 
    END                                       NOME_TRANSP_ENTREGA,
      
    CASE WHEN tcmcs080.t$dsca IS NULL 
           THEN NVL( cisli940.t$cfrn$l, ( select Trim(A.T$NTRA$C)
                                            from BAANDB.TZNSLS410201 A
                                           where A.T$NCIA$C = ZNSLS401.T$NCIA$C
                                             and A.T$UNEG$C = ZNSLS401.T$UNEG$C
                                             and A.T$PECL$C = ZNSLS401.T$PECL$C
                                             and A.T$SQPD$C = ZNSLS401.T$SQPD$C
                                             and A.T$ENTR$C = ZNSLS401.T$ENTR$C
                                             and A.T$NTRA$C != ' '
                                             and ROWNUM = 1 ) )                   
         ELSE tcmcs080.t$dsca 
    END                                       Nome_Transportadora_Coleta,
    Trim(tcmcs080.t$seak)                     APELIDO_TRANSP_COLETA,
    NVL( tccom130transp.t$fovn$l, 
         ( select Trim(A.T$FOVT$C)
             from BAANDB.TZNSLS410201 A
            where A.T$NCIA$C = ZNSLS401.T$NCIA$C
              and A.T$UNEG$C = ZNSLS401.T$UNEG$C
              and A.T$PECL$C = ZNSLS401.T$PECL$C
              and A.T$SQPD$C = ZNSLS401.T$SQPD$C
              and A.T$ENTR$C = ZNSLS401.T$ENTR$C
              and A.T$NTRA$C != ' '
              and ROWNUM = 1 ) )              CNPJ_TRANSP_COLETA,
											  
    Trim(znsls401.t$nome$c)                   Nome_Cliente_Coleta,       
    znsls401.t$fovn$c                         CPF_Cliente,
    znsls401.t$cepe$c                         CEP,
    Trim(znsls401.t$loge$c)                   ENDERECO,
    znsls401.t$nume$c                         NUMERO,
    Trim(znsls401.t$come$c)                   COMPLEMENTO,
    Trim(znsls401.t$baie$c)                   BAIRRO,
    Trim(znsls401.t$refe$c)                   REFERENCIA,
    znsls401.t$cide$c                         CIDADE,
    znsls401.t$ufen$c                         UF,
    znsls401.t$tele$c                         TEL,
    znsls401.t$te1e$c                         TEL_1,
    znsls401.t$te2e$c                         TEL_2,
    Trim(tcibd001.t$item)                     Item,
    CASE WHEN TRIM(cisli941.t$item$l) =  TRIM(PARAM.IT_FRETE) 
           THEN 'FRETE'
         ELSE CASE WHEN TRIM(cisli941.t$item$l) =  TRIM(PARAM.IT_DESP) 
                     THEN 'DESPESAS'
                   ELSE CASE WHEN TRIM(cisli941.t$item$l) = TRIM(PARAM.IT_JUROS) 
                               THEN 'JUROS'
                             ELSE tcibd001.t$dscb$c 
                         END          
               END 
    END                                       Descricao_do_Item,
    Trim(tcmcs023.t$dsca)                     DEPARTAMENTO,
    Trim(znmcs030.t$dsca$c)                   SETOR,
    Trim(tcmcs060.t$dsca)                     FABRICANTE,
    tdipu001.t$manu$c                         MARCA,
    NVL(cisli941.t$dqua$l, 
        ABS(znsls401.t$qtve$c) )              QTDE_ITEM,
    NVL(cisli941.t$dqua$l, ABS(znsls401.t$qtve$c))*
        tcibd001.t$wght                       PESO_KG,
    CUBAGEM.TOT                               CUBAGEM,
    CASE WHEN cisli940.t$docn$l = 0 
           THEN NULL
         ELSE cisli940.t$docn$l 
    END                                       Nota,
    CASE WHEN cisli940.t$docn$l = 0 
           THEN NULL
         ELSE cisli940.t$seri$l 
    END                                       Serie,
    CASE WHEN NVL(cisli940.t$date$l, to_date('01-01-1980','DD-MM-YYYY')) > to_date('01-01-1980','DD-MM-YYYY') 
           THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                    AT time zone 'America/Sao_Paulo') AS DATE)
           ELSE NULL
     END                                      DATA_EMISSAO_NF,
    cisli941.t$pric$l                         VALOR_PRODUTO,
    NVL(cisli941.t$amnt$l,0) + 
    NVL(znsls401.t$vlfr$c,0)                  VL_TOTAL_NF,
    znsls401.t$vlfr$c                         VL_FRETE_SITE,
    cisli941.t$amnt$l                         VL_TOTAL_ITEM,
    znmcs002.t$desc$c                         OCORRENCIA,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
             'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_DA_OCORRENCIA,
    znmcs002.t$desc$c                         STATUS,
    znsls401.t$lcat$c                         CATEGORIA,
    CASE WHEN tdrec947.t$fire$l IS NULL 
           THEN 'Sim'
         ELSE   'Não' 
    END                                       PENDENTE_DEVOLUCAO,
    CASE WHEN znfmd630.t$stat$c = 2
           THEN 'Não'
         ELSE   'Sim'  
    END                                       PENDENTE_COLETA,
 
    tdsls400_2.t$sotp,
    tdsls094.t$dsca			                  TIPO_ORDEM_DE_FRETE,
    ORIGEM_O_FRETE.DESCR                      ORIGEM_ORDEM_DE_FRETE,
    ZNSLS401.T$ORNO$C,
    cisli940.t$fire$l                         REF_FISCAL,
	
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CANC_COLETA.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_CANC_COLETA,
    REC_COLETA.DATA_OCORR                     RETORNO_RDV,
    cisli940.t$cnfe$l                         CHAVE_DANFE
  
--ESTADO_ORDEM_DEVOLUCAO                    --RIGHT NOW
--DATA_ENCERRADO                            --RIGHT NOW
--NOME_USUARIO_FORCOU_DEVOLUCAO             --RIGHT NOW
--MOTIVO_ENCERRAMENTO                       --RIGHT NOW
--NUMERO_RASTREAMENTO_POSTAGEM,             --RIGHT NOW
--DATA_REAL_COLETA,                         --SDP 739880
--DATA_REAL_RETORNO,                        --SDP 739880
--NOME_ARQUIVO_EDI                          --SDP 734213
--AREA_ABERTURA_OCORRENCIA                  --RIGHT NOW
--NOME_ATENDENTE_ABERTURA                   --RIGHT NOW
--OBSERVACOES                               --RIGHT NOW
  
FROM       baandb.tznsls401201 znsls401

INNER JOIN baandb.tznsls400201 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
         
 LEFT JOIN ( select r.t$date$c,
                    r.t$ncia$c, 
                    r.t$uneg$c,
                    r.t$pecl$c,
                    r.t$sqpd$c,
                    r.t$entr$c,
                    r.t$sequ$c,
                    r.t$orno$c,
                    r.t$pono$c
               from baandb.tznsls004201 r ) znsls004
        ON znsls004.t$ncia$c = znsls401.t$ncia$c
       AND znsls004.t$uneg$c = znsls401.t$uneg$c
       AND znsls004.t$pecl$c = znsls401.t$pecl$c
       AND znsls004.t$sqpd$c = znsls401.t$sqpd$c
       AND znsls004.t$entr$c = znsls401.t$entr$c
       AND znsls004.t$sequ$c = znsls401.t$sequ$c
       AND ROWNUM = 1
    
 LEFT JOIN ( select F.t$ncia$c,
                    F.t$uneg$c,
                    F.t$pecl$c,
                    F.t$sqpd$c,
                    F.t$entr$c,
                    MAX(F.T$LBRD$C) T$LBRD$C,
                    MAX(F.T$DVED$C) T$DVED$C
               from BAANDB.TZNSLS409201 F
           group by F.t$ncia$c,
                    F.t$uneg$c,
                    F.t$pecl$c,
                    F.t$sqpd$c,
                    F.t$entr$c ) ZNSLS409
        ON ZNSLS409.t$ncia$c = znsls401.t$ncia$c
       AND ZNSLS409.t$uneg$c = znsls401.t$uneg$c
       AND ZNSLS409.t$pecl$c = znsls401.t$pecl$c
       AND ZNSLS409.t$sqpd$c = znsls401.t$sqpd$c
       AND ZNSLS409.t$entr$c = znsls401.t$entr$c
    
 LEFT JOIN baandb.tcisli245201 cisli245
        ON cisli245.t$slso = znsls004.t$orno$c        -- OV de Devolução
       AND cisli245.t$pono = znsls004.t$pono$c
       
 LEFT JOIN baandb.ttdsls401201  tdsls401
        ON tdsls401.t$orno = cisli245.t$slso
       AND tdsls401.t$pono = cisli245.t$pono 

 LEFT JOIN baandb.ttdrec947201  tdrec947
        ON tdrec947.t$orno$l = tdsls401.t$orno
       AND tdrec947.t$pono$l = tdsls401.t$pono
       AND tdrec947.t$oorg$l = 1
       
 LEFT JOIN baandb.tcisli940201 cisli940
        ON cisli940.t$fire$l = cisli245.t$fire$l        --Nota de Retorno de Mercadoria ao Cliente
                  
 LEFT JOIN baandb.tcisli941201 cisli941
        ON cisli941.t$fire$l = cisli245.t$fire$l
       AND cisli941.t$line$l = cisli245.t$line$l
      
 LEFT JOIN baandb.ttdsls400201 tdsls400
        ON tdsls400.t$orno = NVL(znsls004.t$orno$c, znsls401.t$orno$c)
        
 LEFT JOIN baandb.ttdsls400201 tdsls400_2
        ON tdsls400_2.t$orno = znsls401.t$orno$c
        
 LEFT JOIN baandb.ttdsls094201 tdsls094
        ON tdsls094.t$sotp = tdsls400_2.t$sotp
    
 LEFT JOIN baandb.ttcmcs065201 tcmcs065
        ON tcmcs065.t$cwoc = tdsls400.t$cofc

 LEFT JOIN baandb.ttccom130201 tccom130
        ON tccom130.t$cadr = tcmcs065.t$cadr
    
 LEFT JOIN baandb.tznfmd001201 znfmd001
        ON znfmd001.t$fovn$c = tccom130.t$fovn$l
    
 LEFT JOIN baandb.tznfmd630201 znfmd630
        ON znfmd630.t$orno$c = znsls401.t$orno$c
    
 LEFT JOIN ( Select znfmd640.t$fili$c,
                    znfmd640.t$etiq$c,
                    MAX(znfmd640.t$coci$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640.T$DATE$C) OCORR,
                    max(znfmd640.t$date$c) DATA_OCORR
               from baandb.tznfmd640201 znfmd640
           group by znfmd640.t$fili$c,
                    znfmd640.t$etiq$c ) znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c

 LEFT JOIN baandb.tznfmd030201 znfmd030
        ON znfmd030.t$ocin$c = znfmd640.OCORR

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    max(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) PT_CONTR
               from baandb.tznsls410201 znsls410
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$entr$c = znsls401.t$entr$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
    
 LEFT JOIN baandb.tznmcs002201 znmcs002
        ON znmcs002.t$poco$c = znsls410.PT_CONTR
    
 LEFT JOIN ( select znsls000.t$indt$c,
                    znsls000.t$itmf$c IT_FRETE,
                    znsls000.t$itmd$c IT_DESP,
                    znsls000.t$itjl$c IT_JUROS
                from baandb.tznsls000201 znsls000
                where rownum = 1 ) PARAM
        ON PARAM.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
              
 LEFT JOIN ( select cisli941.t$fire$l,
                    cisli941.t$item$l,
                    cisli941.t$amnt$l TOTAL
               from baandb.tcisli941201 cisli941 ) DESPESA
        ON DESPESA.t$fire$l = cisli940.t$fire$l
       AND TRIM(DESPESA.t$item$l) = TRIM(PARAM.IT_DESP)
     
 LEFT JOIN ( select cisli941.t$fire$l,
                    cisli941.t$item$l,
                    cisli941.t$amnt$l TOTAL
               from baandb.tcisli941201 cisli941 ) JUROS
        ON JUROS.t$fire$l = cisli940.t$fire$l
       AND TRIM(JUROS.t$item$l) = TRIM(PARAM.IT_JUROS)
    
 LEFT JOIN baandb.ttcibd001201 tcibd001
        ON TRIM(tcibd001.t$item) = TRIM(znsls401.t$item$c)

 LEFT JOIN baandb.tznsls002201 znsls002
        ON znsls002.t$tpen$c = znsls401.t$itpe$c
   
 LEFT JOIN ( select sum( wmd.t$hght   * 
                         wmd.t$wdth   * 
                         wmd.t$dpth   * 
                         sli.t$dqua$l * 
                         znmcs.t$cuba$c ) TOT,
                    sli.t$fire$l,
                    znmcs.t$cfrw$c
               from baandb.tcisli941201 sli,
                    baandb.twhwmd400201 wmd,
                    baandb.tznmcs080201 znmcs 
              where wmd.t$item = sli.t$item$l     
           group by sli.t$fire$l, znmcs.t$cfrw$c ) CUBAGEM
        ON CUBAGEM.t$fire$l = cisli940.t$fire$l
       AND CUBAGEM.t$cfrw$c = cisli940.t$cfrw$l

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$dpco$c) DATA_DTPR,
                    MAX(znsls410.t$dtpr$c) DATA_DTCD
               from baandb.tznsls410201 znsls410
              where znsls410.t$poco$c = 'APD'
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c ) SOLIC_COLETA
        ON SOLIC_COLETA.t$ncia$c = znsls401.t$ncia$c
       AND SOLIC_COLETA.t$uneg$c = znsls401.t$uneg$c
       AND SOLIC_COLETA.t$pecl$c = znsls401.t$pecl$c

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR
               from baandb.tznsls410201 znsls410
              where znsls410.t$poco$c = 'POS'       --POSTAGEM
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c ) POSTAGEM
        ON POSTAGEM.t$ncia$c = znsls401.t$ncia$c
       AND POSTAGEM.t$uneg$c = znsls401.t$uneg$c
       AND POSTAGEM.t$pecl$c = znsls401.t$pecl$c
       
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR
               from baandb.tznsls410201 znsls410
              where znsls410.t$poco$c = 'CPC'       --Cancelamento da Coleta
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) CANC_COLETA
        ON CANC_COLETA.t$ncia$c = znsls401.t$ncia$c
       AND CANC_COLETA.t$uneg$c = znsls401.t$uneg$c
       AND CANC_COLETA.t$pecl$c = znsls401.t$pecl$c
       AND CANC_COLETA.t$entr$c = znsls401.t$entr$c
       AND CANC_COLETA.t$sqpd$c = znsls401.t$sqpd$c

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR
               from baandb.tznsls410201 znsls410
              where znsls410.t$poco$c = 'RDV'       --Retorno da Mercadoria ao CD
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) REC_COLETA
        ON REC_COLETA.t$ncia$c = znsls401.t$ncia$c
       AND REC_COLETA.t$uneg$c = znsls401.t$uneg$c
       AND REC_COLETA.t$pecl$c = znsls401.t$pecl$c
       AND REC_COLETA.t$entr$c = znsls401.t$entr$c
       AND REC_COLETA.t$sqpd$c = znsls401.t$sqpd$c
       
 LEFT JOIN baandb.ttccom000201  tccom000
        ON tccom000.t$indt < to_date('01-01-1980','DD-MM-YYYY') 
       AND tccom000.t$ncmp = 201
         
 LEFT JOIN baandb.ttccom130201  tccom130cnova
        ON tccom130cnova.t$cadr = tccom000.t$cadr
          
 LEFT JOIN baandb.tznint002201 znint002
        ON znint002.t$ncia$c = znsls401.t$ncia$c
       AND znint002.t$uneg$c = znsls401.t$uneg$c
       
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    MAX(znsls410.t$orno$c)  OV,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$ntra$c) NOME_TRANSP
               from baandb.tznsls410201 znsls410
              where znsls410.t$poco$c = 'ETR'  --ENTREGUE À TRANSPORTADORA
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c ) EXPEDICAO
        ON EXPEDICAO.t$ncia$c = znsls401.t$ncia$c
       AND EXPEDICAO.t$uneg$c = znsls401.t$uneg$c
       AND EXPEDICAO.t$pecl$c = znsls401.t$pecl$c
              
 LEFT JOIN baandb.ttcmcs080201 tcmcs080           --Transportadora da Coleta
        ON tcmcs080.t$cfrw = cisli940.t$cfrw$l
        
 LEFT JOIN baandb.ttccom130201 tccom130transp
        ON tccom130transp.t$cadr = tcmcs080.t$cadr$l
  
 LEFT JOIN baandb.ttcmcs023201 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
 
 LEFT JOIN baandb.tznmcs030201 znmcs030
        ON znmcs030.t$citg$c = tcibd001.t$citg
       AND znmcs030.t$seto$c = tcibd001.t$seto$c
       
 LEFT JOIN baandb.ttcmcs060201 tcmcs060 
        ON tcmcs060.t$cmnf = tcibd001.t$cmnf
     
 LEFT JOIN baandb.ttdipu001201 tdipu001
        ON tdipu001.t$item = tcibd001.t$item
    
 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    min(a.t$sqpd$c) t$sqpd$c,
                    min(a.t$entr$c) t$entr$c
             from   baandb.tznsls401201 a
             where  a.t$idor$c = 'LJ'
             group by a.t$ncia$c, 
                      a.t$uneg$c,
                      a.t$pecl$c ) VENDA_ENTR
        ON  VENDA_ENTR.t$ncia$c = znsls401.t$ncia$c
       AND  VENDA_ENTR.t$uneg$c = znsls401.t$uneg$c
       AND  VENDA_ENTR.t$pecl$c = znsls401.t$pecl$c
 
  LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    min(a.t$orno$c) t$orno$c,
                    min(a.t$pono$c) t$pono$c
             from   baandb.tznsls004201 a
             group by a.t$ncia$c, 
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c ) ORIG_PED
        ON  ORIG_PED.t$ncia$c = znsls401.t$ncia$c
       AND  ORIG_PED.t$uneg$c = znsls401.t$uneg$c
       AND  ORIG_PED.t$pecl$c = znsls401.t$pecl$c
       AND  ORIG_PED.t$sqpd$c = VENDA_ENTR.t$sqpd$c
       AND  ORIG_PED.t$entr$c = VENDA_ENTR.t$entr$c
       
  LEFT JOIN ( select  a.t$slso,
                      a.t$pono,
                      max(a.t$fire$l) t$fire$l
              from    baandb.tcisli245201 a
              group by  a.t$slso, a.t$pono ) SLI245
         ON SLI245.t$slso = ORIG_PED.t$orno$c
        AND SLI245.t$pono = ORIG_PED.t$pono$c
 
  LEFT JOIN baandb.tcisli940201 VENDA_REF
         ON VENDA_REF.t$fire$l = SLI245.t$fire$l
         
  LEFT JOIN baandb.ttcmcs080201  VENDA_TRANSP
         ON VENDA_TRANSP.t$cfrw = VENDA_REF.t$cfrw$l

  LEFT JOIN ( select a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$dtem$c
             from   baandb.tznsls400201 a
             group by a.t$ncia$c, 
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$dtem$c) PED_LJ
        ON  PED_LJ.t$ncia$c = ORIG_PED.t$ncia$c
       AND  PED_LJ.t$uneg$c = ORIG_PED.t$uneg$c
       AND  PED_LJ.t$pecl$c = ORIG_PED.t$pecl$c
       AND  PED_LJ.t$sqpd$c = ORIG_PED.t$sqpd$c

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR
               from baandb.tznsls410201 znsls410
              where znsls410.t$poco$c = 'CAN'      --PEDIDO CANCELADO
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) CANC_PED
        ON CANC_PED.t$ncia$c = ORIG_PED.t$ncia$c
       AND CANC_PED.t$uneg$c = ORIG_PED.t$uneg$c
       AND CANC_PED.t$pecl$c = ORIG_PED.t$pecl$c
       AND CANC_PED.t$entr$c = ORIG_PED.t$entr$c
       AND CANC_PED.t$sqpd$c = ORIG_PED.t$sqpd$c

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    MIN(a.t$dtoc$c) DATA_OCORR
              from baandb.tznsls410201 a
              where a.t$poco$c = 'PAP'      --APROVAÇÃO PAGTO DEVOLUÇÃO
              group by a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c,
                       a.t$entr$c ) PAP_TD      
        ON PAP_TD.t$ncia$c = znsls401.t$ncia$c
       AND PAP_TD.t$uneg$c = znsls401.t$uneg$c
       AND PAP_TD.t$pecl$c = znsls401.t$pecl$c
       AND PAP_TD.t$sqpd$c = znsls401.t$sqpd$c
       AND PAP_TD.t$entr$c = znsls401.t$entr$c
       
 LEFT JOIN ( select l.t$desc DESCR,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'zn'
                and d.t$cdom = 'mcs.trans.c'
                and l.t$clan = 'p'
                and l.t$cpac = 'zn'
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
                                            and l1.t$cpac = l.t$cpac ) ) ORIGEM_O_FRETE
        ON ORIGEM_O_FRETE.t$cnst = znfmd630.t$torg$c

WHERE TRIM(znsls401.t$idor$c) = 'TD'  -- Troca / Devolução
  AND znsls401.t$qtve$c < 0           -- Devolução
  AND tdsls094.t$reto in (1, 3)       -- Ordem Devolução, Ordem Devolução Rejeitada
  AND znsls401.t$itpe$c in (9, 15)    -- Postagem, Reversa

  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 
              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataPedidoDe
          And :DataPedidoAte
  AND znfmd001.t$fili$c IN (:Filial)
  AND tcibd001.t$citg IN (:Depto)
  AND znsls401.t$uneg$c IN (:UnidNegocio)
  AND znsls401.t$itpe$c IN (:TipoEntrega)
  AND CASE WHEN znsls409.t$lbrd$c = 1 
             THEN 1 -- FORÇADO
           ELSE   0 -- NÃO FORÇADO
      END IN (:Forcado)
  
ORDER BY DATA_SOL_COLETA_POSTAGEM, DATA_PEDIDO, PEDIDO
