SELECT 
  DISTINCT
    znsls401.t$itpe$c,
    CASE WHEN znsls401.t$itpe$c = 15 THEN   --REVERSA
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SOLIC_COLETA.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
    WHEN  znsls401.t$itpe$c = 9 THEN        --POSTAGEM
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(POSTAGEM.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
    ELSE NULL END                             DATA_SOL_COLETA_POSTAGEM,
                              
    znsls401.t$pecl$c                         PEDIDO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_PEDIDO,
											  
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
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


    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CANC_PEDIDO.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_CANC_PEDIDO,
    CASE WHEN znsls409.t$lbrd$c = 1 
           THEN 'Sim' -- FORÇADO
         ELSE   'Não' -- NÃO FORÇADO
     END                                      IN_FORCADO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(EXPEDICAO.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_EXPEDICAO_PEDIDO,
--    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400_2.t$ddat, 'DD-MON-YYYY HH24:MI:SS'), 
--        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SOLIC_COLETA.DATA_DTPR, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_COLETA_PROMETIDA,
--    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400_2.t$prdt, 'DD-MON-YYYY HH24:MI:SS'), 
--        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SOLIC_COLETA.DATA_DTCD, 'DD-MON-YYYY HH24:MI:SS'), 
        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                              DATA_RETORNO_PROMETIDA,
    EXPEDICAO.NOME_TRANSP                     NOME_TRANSP_ENTREGA,
    NVL(cisli940.t$cfrn$l,
    ( SELECT Trim(A.T$NTRA$C)
        FROM BAANDB.TZNSLS410301 A
       WHERE A.T$NCIA$C = ZNSLS401.T$NCIA$C
         AND A.T$UNEG$C = ZNSLS401.T$UNEG$C
         AND A.T$PECL$C = ZNSLS401.T$PECL$C
         AND A.T$SQPD$C = ZNSLS401.T$SQPD$C
         AND A.T$ENTR$C = ZNSLS401.T$ENTR$C
         AND A.T$NTRA$C != ' '
         AND ROWNUM = 1 ) )                   Nome_Transportadora_Coleta,
--    tcmcs080.t$dsca                           Nome_Transportadora_Coleta,
    Trim(tcmcs080.t$seak)                     APELIDO_TRANSP_COLETA,
    NVL(tccom130transp.t$fovn$l,                   
          ( SELECT Trim(A.T$FOVT$C)
        FROM BAANDB.TZNSLS410301 A
       WHERE A.T$NCIA$C = ZNSLS401.T$NCIA$C
         AND A.T$UNEG$C = ZNSLS401.T$UNEG$C
         AND A.T$PECL$C = ZNSLS401.T$PECL$C
         AND A.T$SQPD$C = ZNSLS401.T$SQPD$C
         AND A.T$ENTR$C = ZNSLS401.T$ENTR$C
         AND A.T$NTRA$C != ' '
         AND ROWNUM = 1 ) )                   CNPJ_TRANSP_COLETA,
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
    NVL(znfmd030.t$dsci$c,znmcs002.t$desc$c)  OCORRENCIA,
	
    NVL( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE),
         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.DATA_OCORR, 'DD-MON-YYYY HH24:MI:SS'), 
             'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) )
                                              DATA_DA_OCORRENCIA,
--    NULL                                      Status,
    znmcs002.t$desc$c                         STATUS,
    znsls401.t$lcat$c                         CATEGORIA,
    CASE WHEN tdrec947.t$fire$l IS NULL 
           THEN 'Sim'
         ELSE   'Não' 
    END                                       PENDENTE_DEVOLUCAO,
    CASE WHEN znfmd630.t$stat$c = 'F' OR tdrec947.t$fire$l IS NOT NULL 
           THEN 'Nao'
         ELSE   'Sim'  
    END                                       PENDENTE_COLETA,
 
    tdsls400_2.t$sotp,
    tdsls094.t$dsca,
    ZNSLS401.T$ORNO$C,
    cisli940.t$fire$l                         REF_FISCAL,
    CANC_COLETA.DATA_OCORR                    DATA_CANC_COLETA,
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
  
FROM       baandb.tznsls401301 znsls401

INNER JOIN baandb.tznsls400301 znsls400
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
               from baandb.tznsls004301 r ) znsls004
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
               from BAANDB.TZNSLS409301 F
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
    
 LEFT JOIN baandb.tcisli245301 cisli245
        ON cisli245.t$slso = znsls004.t$orno$c
       AND cisli245.t$pono = znsls004.t$pono$c
       
 LEFT JOIN baandb.ttdsls401301  tdsls401
        ON tdsls401.t$orno = cisli245.t$slso
       AND tdsls401.t$pono = cisli245.t$pono 

 LEFT JOIN baandb.ttdrec947301  tdrec947
        ON tdrec947.t$orno$l = tdsls401.t$orno
       AND tdrec947.t$pono$l = tdsls401.t$pono
       AND tdrec947.t$oorg$l = 1
       
 LEFT JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = cisli245.t$fire$l
                  
 LEFT JOIN baandb.tcisli941301 cisli941
        ON cisli941.t$fire$l = cisli245.t$fire$l
       AND cisli941.t$line$l = cisli245.t$line$l
      
 LEFT JOIN baandb.ttdsls400301 tdsls400
        ON tdsls400.t$orno = NVL(znsls004.t$orno$c, znsls401.t$orno$c)
        
 LEFT JOIN baandb.ttdsls400301 tdsls400_2
        ON tdsls400_2.t$orno = znsls401.t$orno$c
        
 LEFT JOIN baandb.ttdsls094301 tdsls094
        ON tdsls094.t$sotp = tdsls400_2.t$sotp
    
 LEFT JOIN baandb.ttcmcs065301 tcmcs065
        ON tcmcs065.t$cwoc = tdsls400.t$cofc

 LEFT JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tcmcs065.t$cadr
    
 LEFT JOIN baandb.tznfmd001301 znfmd001
        ON znfmd001.t$fovn$c = tccom130.t$fovn$l
    
 LEFT JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$orno$c = znsls401.t$orno$c
    
 LEFT JOIN ( Select znfmd640.t$fili$c,
                    znfmd640.t$etiq$c,
                    MAX(znfmd640.t$coci$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640.T$DATE$C) OCORR,
                    max(znfmd640.t$date$c) DATA_OCORR
               from baandb.tznfmd640301 znfmd640
           group by znfmd640.t$fili$c,
                    znfmd640.t$etiq$c ) znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c

 LEFT JOIN baandb.tznfmd030301 znfmd030
        ON znfmd030.t$ocin$c = znfmd640.OCORR

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    max(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) PT_CONTR
               from baandb.tznsls410301 znsls410
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
    
 LEFT JOIN baandb.tznmcs002301 znmcs002
        ON znmcs002.t$poco$c = znsls410.PT_CONTR
    
 LEFT JOIN ( select znsls000.t$indt$c,
                    znsls000.t$itmf$c IT_FRETE,
                    znsls000.t$itmd$c IT_DESP,
                    znsls000.t$itjl$c IT_JUROS
                from baandb.tznsls000301 znsls000
                where rownum = 1 ) PARAM
        ON PARAM.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
              
 LEFT JOIN ( select cisli941.t$fire$l,
                    cisli941.t$item$l,
                    cisli941.t$amnt$l TOTAL
               from baandb.tcisli941301 cisli941 ) DESPESA
        ON DESPESA.t$fire$l = cisli940.t$fire$l
       AND TRIM(DESPESA.t$item$l) = TRIM(PARAM.IT_DESP)
     
 LEFT JOIN ( select cisli941.t$fire$l,
                    cisli941.t$item$l,
                    cisli941.t$amnt$l TOTAL
               from baandb.tcisli941301 cisli941 ) JUROS
        ON JUROS.t$fire$l = cisli940.t$fire$l
       AND TRIM(JUROS.t$item$l) = TRIM(PARAM.IT_JUROS)
    
 LEFT JOIN baandb.ttcibd001301 tcibd001
        ON TRIM(tcibd001.t$item) = TRIM(znsls401.t$item$c)

 LEFT JOIN baandb.tznsls002301 znsls002
        ON znsls002.t$tpen$c = znsls401.t$itpe$c
   
 LEFT JOIN ( select sum( wmd.t$hght   * 
                         wmd.t$wdth   * 
                         wmd.t$dpth   * 
                         sli.t$dqua$l * 
                         znmcs.t$cuba$c ) TOT,
                    sli.t$fire$l,
                    znmcs.t$cfrw$c
               from baandb.tcisli941301 sli,
                    baandb.twhwmd400301 wmd,
                    baandb.tznmcs080301 znmcs 
              where wmd.t$item = sli.t$item$l     
           group by sli.t$fire$l, znmcs.t$cfrw$c ) CUBAGEM
        ON CUBAGEM.t$fire$l = cisli940.t$fire$l
       AND CUBAGEM.t$cfrw$c = cisli940.t$cfrw$l

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
--                    znsls410.t$entr$c
--                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$dtpr$c) DATA_DTPR,
                    MAX(znsls410.t$dtcd$c) DATA_DTCD
               from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'COS'
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c ) SOLIC_COLETA
--                    znsls410.t$entr$c,
--                    znsls410.t$sqpd$c ) SOLIC_COLETA
        ON SOLIC_COLETA.t$ncia$c = znsls401.t$ncia$c
       AND SOLIC_COLETA.t$uneg$c = znsls401.t$uneg$c
       AND SOLIC_COLETA.t$pecl$c = znsls401.t$pecl$c
--       AND SOLIC_COLETA.t$entr$c = znsls401.t$entr$c
--       AND SOLIC_COLETA.t$sqpd$c = znsls401.t$sqpd$c

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
--                    znsls410.t$entr$c,
--                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR
               from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'POS'
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c ) POSTAGEM
--                    znsls410.t$entr$c,
--                    znsls410.t$sqpd$c ) POSTAGEM
        ON POSTAGEM.t$ncia$c = znsls401.t$ncia$c
       AND POSTAGEM.t$uneg$c = znsls401.t$uneg$c
       AND POSTAGEM.t$pecl$c = znsls401.t$pecl$c
--       AND POSTAGEM.t$entr$c = znsls401.t$entr$c
--       AND POSTAGEM.t$sqpd$c = znsls401.t$sqpd$c
       
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR
               from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'CPC'
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
               from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'RDV'
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
       
 LEFT JOIN baandb.ttccom000301  tccom000
        ON tccom000.t$indt < to_date('01-01-1980','DD-MM-YYYY') 
       AND tccom000.t$ncmp = 301
         
 LEFT JOIN baandb.ttccom130301  tccom130cnova
        ON tccom130cnova.t$cadr = tccom000.t$cadr
          
 LEFT JOIN baandb.tznint002301 znint002
        ON znint002.t$ncia$c = znsls401.t$ncia$c
       AND znint002.t$uneg$c = znsls401.t$uneg$c
        
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR
               from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'CAN'      --PEDIDO CANCELADO
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) CANC_PEDIDO
        ON CANC_PEDIDO.t$ncia$c = znsls401.t$ncia$c
       AND CANC_PEDIDO.t$uneg$c = znsls401.t$uneg$c
       AND CANC_PEDIDO.t$pecl$c = znsls401.t$pecl$c
       AND CANC_PEDIDO.t$entr$c = znsls401.t$entr$c
       AND CANC_PEDIDO.t$sqpd$c = znsls401.t$sqpd$c
       
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    MAX(znsls410.t$orno$c)  OV,
--                    znsls410.t$entr$c,
--                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$ntra$c) NOME_TRANSP
               from baandb.tznsls410301 znsls410
              where znsls410.t$poco$c = 'ETR'  --ENTREGUE À TRANSPORTADORA
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c ) EXPEDICAO
--                    znsls410.t$entr$c,
--                    znsls410.t$sqpd$c ) EXPEDICAO
        ON EXPEDICAO.t$ncia$c = znsls401.t$ncia$c
       AND EXPEDICAO.t$uneg$c = znsls401.t$uneg$c
       AND EXPEDICAO.t$pecl$c = znsls401.t$pecl$c
--       AND EXPEDICAO.t$entr$c = znsls401.t$entr$c
--       AND EXPEDICAO.t$sqpd$c = znsls401.t$sqpd$c
              
 LEFT JOIN baandb.ttcmcs080301 tcmcs080
        ON tcmcs080.t$cfrw = cisli940.t$cfrw$l
        
 LEFT JOIN baandb.ttccom130301 tccom130transp
        ON tccom130transp.t$cadr = tcmcs080.t$cadr$l
  
 LEFT JOIN baandb.ttcmcs023301 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
 
 LEFT JOIN baandb.tznmcs030301 znmcs030
        ON znmcs030.t$citg$c = tcibd001.t$citg
       AND znmcs030.t$seto$c = tcibd001.t$seto$c
       
 LEFT JOIN baandb.ttcmcs060301 tcmcs060 
        ON tcmcs060.t$cmnf = tcibd001.t$cmnf
     
 LEFT JOIN baandb.ttdipu001301 tdipu001
        ON tdipu001.t$item = tcibd001.t$item
              
WHERE TRIM(znsls401.t$idor$c) = 'TD'  -- Troca / Devolução
  AND znsls401.t$qtve$c < 0           -- Devolução
  AND tdsls094.t$reto in (1, 3)       -- Ordem Devolução, Ordem Devolução Rejeitada
  AND znsls401.t$itpe$c in (9, 15)    -- Postagem, Reversa
  
--  and znsls401.t$pecl$c IN ('72931808','71178599')

--and cisli940.t$fire$l IS NULL

--and znsls002.t$tpen$c = 15    -- Reversa
  
--and CANC_PEDIDO.DATA_OCORR IS NOT NULL

--  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SOLIC_COLETA.DATA_OCORR, 
--              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
--                AT time zone 'America/Sao_Paulo') AS DATE))
--      Between :DataColetaDe
--          And :DataColetaAte
--  AND znsls401.t$ccat$c IN (:Categoria)    --BAANDB.TZNSLS010301 RETIRAR DO RELATÓRIO, PRECISA VERIFICAR JUNTO A EQUIPE DE FRONTE
--  AND znsls401.t$cass$c IN (:Assunto)      --BAANDB.TZNSLS011301
--  AND znsls401.t$cmot$c IN (:MotivoColeta) --BAANDB.TZNSLS012301
--  AND CASE WHEN znsls409.t$lbrd$c = 1 
--             THEN 1 -- FORÇADO
--           ELSE   0 -- NÃO FORÇADO
--      END IN (:Forcado)
--  AND znsls401.t$uneg$c IN (:UnidNegocio)
--  AND tcibd001.t$citg IN (:Depto)
-- Estato da Instancia  
--  AND znfmd001.t$fili$c IN (:Filial)
--  AND znsls401.t$itpe$c IN (:TipoEntrega)
  
ORDER BY DATA_SOL_COLETA_POSTAGEM, DATA_PEDIDO, PEDIDO

