SELECT Q1.TP_TRANSACAO            TP_TRANSACAO
     , Q1.DATA                    DATA
     , Q1.ID_UNEG                 ID_UNEG
     , Q1.NOME_UNEG               NOME_UNEG
     , Q1.COD_VENDEDOR            COD_VENDEDOR
     , Q1.PEDIDO                  PEDIDO
     , Q1.ENTREGA                 ENTREGA
     , Q1.CODE_ATIVACAO           CODE_ATIVACAO
     , Q1.ID_CLIENTE              ID_CLIENTE
     , Q1.NOME_CLIENTE            NOME_CLIENTE
     , Q1.EMAIL_CLIENTE           EMAIL_CLIENTE
     , Q1.TELEFONE_CLIENTE        TELEFONE_CLIENTE
     , Q1.CEP_CLIENTE             CEP_CLIENTE
     , Q1.ENDERECO_CLIENTE        ENDERECO_CLIENTE
     , Q1.COMPLEMENTO             COMPLEMENTO
     , Q1.MUNICIPIO               MUNICIPIO
     , Q1.ESTADO                  ESTADO
     , Q1.BAIRRO                  BAIRRO
     , Q1.ITEM                    ITEM
     , Q1.DESCR_ITEM              DESCR_ITEM
     , Q1.QTDE_ITEM
     , SUM(Q1.VALOR_VENDA)        VALOR_VENDA
     , SUM(Q1.CUSTO_UNI *         
       ABS(Q1.QUANT))             CUSTO
     , SUM(Q1.VALOR_VENDA) -      
       SUM(Q1.CUSTO_UNI *         
       ABS(Q1.QUANT))             VL_REPASSE  
     , Q1.ID_CANAL                ID_CANAL
     , Q1.DESCR_CANAL             DESCR_CANAL
     , Q1.COD_TIPO_NAO_PRODUTO    COD_TIPO_NAO_PRODUTO
     , Q1.DSC_TIPO_NAO_PRODUTO    DSC_TIPO_NAO_PRODUTO

FROM ( SELECT CASE WHEN ZNCOM005.T$QUAN$C < 0
                     THEN 'CANCELAMENTO'
                   ELSE   'VENDA' 
               END                         TP_TRANSACAO
            
            , CASE WHEN ZNISA002.T$NPTP$C = 'G' AND ZNCOM005.T$QUAN$C > 0
            
                     THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(PONTO_DNF.DATA_OCORR, 
	                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                              AT time zone sessiontimezone) AS DATE)
                              
                   ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(PONTO_IVE.DATA_OCORR, 
	                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                              AT time zone sessiontimezone) AS DATE)
              END                          DATA

            , ZNCOM005.T$UNEG$C            ID_UNEG
            , ZNINT002.T$DESC$C            NOME_UNEG
            , ZNSLS400.T$CVEN$C            COD_VENDEDOR -- OBS: NÃO TEMOS O NOME NO LN TEMOS SOMENTE O CÓDIGO QUE VEM DO FRONT
            , ZNCOM005.T$PECL$C            PEDIDO
            , ZNCOM005.T$ENTR$C            ENTREGA
            , CASE WHEN ZNISA002.T$NPTP$C = 'G'
                     THEN ZNCOM005.T$CAST$C
                   ELSE   ZNCOM005.T$CDAS$C
              END                          CODE_ATIVACAO
            , ZNSLS400.T$ICLF$C            ID_CLIENTE
            , ZNSLS400.T$NOMF$C            NOME_CLIENTE
            , ZNSLS400.T$EMAF$C            EMAIL_CLIENTE
            , ZNSLS400.T$TELF$C            TELEFONE_CLIENTE
            , ZNSLS400.T$CEPF$C            CEP_CLIENTE
            , ZNSLS400.T$LOGF$C            ENDERECO_CLIENTE
            , ZNSLS400.T$COMF$C            COMPLEMENTO
            , ZNSLS400.T$CIDF$C            MUNICIPIO
            , ZNSLS400.T$UFFA$C            ESTADO
            , ZNSLS400.T$BAIF$C            BAIRRO
            , TRIM(ZNCOM005.T$ITEM$C)      ITEM
            , TCIBD001.T$DSCA              DESCR_ITEM
            , ZNCOM005.T$QUAN$C            QTDE_ITEM
            , ZNCOM005.T$AMTI$C *
              ABS(ZNCOM005.T$QUAN$C)       VALOR_VENDA
			
            , ( SELECT SUM(A.T$AVAT$1) KEEP (DENSE_RANK LAST ORDER BY  A.T$INDT, A.T$SEQN) VALOR
                  FROM BAANDB.TTICPR305301 A 
                 WHERE A.T$ITEM  = ZNCOM005.T$ITEM$C
                   AND A.T$INDT <= ZNCOM005.T$DATE$C )
                                           CUSTO_UNI
									 
            , ZNCOM005.T$QUAN$C            QUANT 
            , ZNSLS400.T$IDCA$C            ID_CANAL
            , TCMCS045.T$DSCA              DESCR_CANAL
            , ZNISA002.T$NPTP$C            COD_TIPO_NAO_PRODUTO
            , ZNISA001.T$DSCA$C            DSC_TIPO_NAO_PRODUTO
  
         FROM BAANDB.TZNCOM005301 ZNCOM005

   INNER JOIN BAANDB.TZNSLS400301 ZNSLS400 
           ON ZNSLS400.T$NCIA$C = ZNCOM005.T$NCIA$C
          AND ZNSLS400.T$UNEG$C = ZNCOM005.T$UNEG$C
          AND ZNSLS400.T$PECL$C = ZNCOM005.T$PECL$C
          AND ZNSLS400.T$SQPD$C = ZNCOM005.T$SQPD$C
   	   
   INNER JOIN BAANDB.TZNINT002301 ZNINT002 
           ON ZNINT002.T$NCIA$C = ZNCOM005.T$NCIA$C
          AND ZNINT002.T$UNEG$C = ZNCOM005.T$UNEG$C
   	   
   INNER JOIN BAANDB.TTCIBD001301 TCIBD001 
           ON TCIBD001.T$ITEM = ZNCOM005.T$ITEM$C
       
    LEFT JOIN ( select a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c,
                       a.t$entr$c,
                       a.t$dtoc$c    DATA_OCORR
                  from baandb.tznsls410301 a
                 where a.t$poco$c = 'IVE' ) PONTO_IVE
           ON PONTO_IVE.t$ncia$c = ZNCOM005.t$ncia$c
          AND PONTO_IVE.t$uneg$c = ZNCOM005.t$uneg$c
          AND PONTO_IVE.t$pecl$c = ZNCOM005.t$pecl$c
          AND PONTO_IVE.t$sqpd$c = ZNCOM005.t$sqpd$c
          AND PONTO_IVE.t$entr$c = ZNCOM005.t$entr$c
          
    LEFT JOIN ( select a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c,
                       a.t$entr$c,
                       min(a.t$dtoc$c)    DATA_OCORR,
                       min(a.t$entr$c)
                  from baandb.tznsls410301 a
                 where a.t$poco$c = 'DNF'
              group by a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c,
                       a.t$entr$c ) PONTO_DNF
           ON PONTO_DNF.t$ncia$c = ZNCOM005.t$ncia$c
          AND PONTO_DNF.t$uneg$c = ZNCOM005.t$uneg$c
          AND PONTO_DNF.t$pecl$c = ZNCOM005.t$pecl$c
          AND PONTO_DNF.t$sqpd$c = ZNCOM005.t$sqpd$c
          AND PONTO_DNF.t$entr$c = ZNCOM005.t$entr$c
       
    LEFT JOIN BAANDB.TTCMCS045301 TCMCS045 
           ON TCMCS045.T$CREG = ZNSLS400.T$IDCA$C
		   
    LEFT JOIN BAANDB.TZNISA002301 ZNISA002
           ON ZNISA002.T$NPCL$C	= TCIBD001.T$NPCL$C

    LEFT JOIN BAANDB.TZNISA001301 ZNISA001
           ON ZNISA001.T$NPTP$C = ZNISA002.T$NPTP$C ) Q1
		   
WHERE Trunc(Q1.DATA) 
      Between :DataDe 
          And :DataAte
  AND Q1.ID_UNEG IN (:UniNegocio)
  AND Q1.ID_CANAL IN (:CanalVendas)
  AND Q1.TP_TRANSACAO IN (:StatusTransacao)
  AND Q1.COD_TIPO_NAO_PRODUTO IN (:Tipo_NProduto)

GROUP BY Q1.TP_TRANSACAO
       , Q1.DATA
       , Q1.ID_UNEG
       , Q1.NOME_UNEG
       , Q1.COD_VENDEDOR
       , Q1.PEDIDO
       , Q1.ENTREGA
       , Q1.CODE_ATIVACAO
       , Q1.ID_CLIENTE
       , Q1.NOME_CLIENTE
       , Q1.EMAIL_CLIENTE
       , Q1.TELEFONE_CLIENTE
       , Q1.CEP_CLIENTE
       , Q1.ENDERECO_CLIENTE
       , Q1.COMPLEMENTO
       , Q1.MUNICIPIO
       , Q1.ESTADO
       , Q1.BAIRRO
       , Q1.ITEM
       , Q1.DESCR_ITEM
       , Q1.QTDE_ITEM
       , Q1.ID_CANAL
       , Q1.DESCR_CANAL
       , Q1.COD_TIPO_NAO_PRODUTO
       , Q1.DSC_TIPO_NAO_PRODUTO
       
ORDER BY Q1.PEDIDO
