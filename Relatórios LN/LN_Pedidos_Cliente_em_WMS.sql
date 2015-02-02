select Q1.* 
  from ( SELECT znsls410.t$pecl$c                                        PEDIDO,
                znsls410.t$entr$c                                        NO_ENTREGA,
                tcemm030.T$EUNT                                          CHAVE_FILIAL,
                tcemm030.t$euca                                          FILIAL,
                tcemm030.t$dsca                                          NOME_FILIAL,                         
                znsls401.t$item$c                                        ITEM,      
                tcibd001.t$dsca                                          DESCRICAO,                         
                znsls401.t$qtve$c                                        QT_PEDIDO,
                Trim(tcmcs023.t$citg)                                    ID_DEPARTAMENTO,
                tcmcs023.t$dsca                                          DEPARTAMENTO,
                tcmcs060.t$dsca                                          FORNECEDOR,  
                znsls401.t$vlun$c                                        VL_PRODUTO,
                
                MAX(znsls410.T$POCO$C) 
                  KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C, 
                                                 znsls410.T$SEQN$C)      ID_ULTIMO_PONTO,

                CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znsls410.T$DTOC$C) 
                  KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C, 
                                                 znsls410.T$SEQN$C),
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                      AT time zone sessiontimezone) AS DATE)             DT_ULT_RASTR,
                
                CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znsls400.T$DTEM$C) 
                  KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, 
                                                 znsls410.T$SEQN$C),
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                      AT time zone sessiontimezone) AS DATE)             DT_EMISSAO,
                
                CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znsls401.T$DTEP$C) 
                  KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DATE$C, 
                                                 znsls410.T$SEQN$C),
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                      AT time zone sessiontimezone) AS DATE)             DT_ENTREGA,
                
                znint002.T$desc$C                                        UNID_NEGOC,
                znsls401.T$TPES$C                                        TP_ESTOQUE,
                WMS_ORDERS.ORDERKEY                                      PEDIDO_WMS,
                CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone sessiontimezone) AS DATE)              DT_ORDEM,
                CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone sessiontimezone) AS DATE)              DT_ENTR_PLAN,
                CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone sessiontimezone) AS DATE)              DT_PLAN_REC,
                tccom130.t$fovn$l                                        CNPJ_FORN    
                
           FROM baandb.tznsls410301 znsls410 
     
     INNER JOIN baandb.tznsls400301 znsls400
             ON znsls400.t$ncia$c = znsls410.t$ncia$c
            AND znsls400.t$uneg$c = znsls410.t$uneg$c
            AND znsls400.t$pecl$c = znsls410.t$pecl$c
            AND znsls400.t$sqpd$c = znsls410.t$sqpd$c
     
      LEFT JOIN baandb.tznsls401301 znsls401
             ON znsls401.t$ncia$c = znsls410.t$ncia$c
            AND znsls401.t$uneg$c = znsls410.t$uneg$c
            AND znsls401.t$pecl$c = znsls410.t$pecl$c
            AND znsls401.t$sqpd$c = znsls410.t$sqpd$c
            AND znsls401.t$entr$c = znsls410.t$entr$c
     
      LEFT JOIN baandb.ttcemm124301 tcemm124
             ON tcemm124.t$cwoc = znsls401.t$cwoc$c
      
      LEFT JOIN baandb.ttcemm030301 tcemm030
             ON tcemm030.t$eunt = tcemm124.t$grid
      
      LEFT JOIN baandb.ttcibd001301 tcibd001
             ON Trim(tcibd001.t$item) = TO_CHAR(znsls401.t$item$c)
             
      LEFT JOIN baandb.ttcmcs060301 tcmcs060
             ON tcmcs060.t$cmnf = tcibd001.t$cmnf
             
      LEFT JOIN baandb.tznint002301 znint002
             ON znint002.t$uneg$c = znsls410.T$UNEG$C
            AND znint002.t$ncia$c = znsls410.t$ncia$c
             
      LEFT JOIN baandb.ttcmcs023301 tcmcs023
             ON tcmcs023.t$citg = tcibd001.t$citg
        
      INNER JOIN WMWHSE5.ORDERS@DL_LN_WMS WMS_ORDERS
             ON WMS_ORDERS.REFERENCEDOCUMENT = znsls401.t$orno$c
      
      LEFT JOIN baandb.ttdsls400301 tdsls400
             ON tdsls400.t$orno = znsls401.t$orno$c
      
      LEFT JOIN baandb.ttdipu001301 tdipu001
             ON tdipu001.t$item = tcibd001.t$item
      
      LEFT JOIN baandb.ttccom100301 tccom100
             ON tccom100.t$bpid = tdipu001.t$otbp
      
      LEFT JOIN baandb.ttccom130301 tccom130
             ON tccom130.t$cadr = tccom100.t$cadr
             
          WHERE znsls401.t$idor$c = 'LJ'
      
       GROUP BY znsls410.t$pecl$c,
                --znsls410.t$orno$c,
                WMS_ORDERS.ORDERKEY,
                znsls410.t$entr$c,
                tcemm030.T$EUNT,
                tcemm030.t$euca,
                tcemm030.t$dsca,
                znsls401.t$item$c,
                tcibd001.t$dsca,
                znsls401.t$qtve$c,
                tcmcs023.t$citg,
                tcmcs023.t$dsca,
                tcmcs060.t$dsca,
                znsls401.t$vlun$c,
                znint002.T$desc$C,
                znsls401.T$TPES$C,
                tdsls400.t$odat,
                tdsls400.t$ddat,
                tdsls400.t$prdt,
                tccom130.t$fovn$l
               
       ORDER BY PEDIDO ) Q1
 
 where Q1.ID_ULTIMO_PONTO = 'WMS'
   and exists ( SELECT znsls410.T$ENTR$C 
                  FROM baandb.tznsls410301 znsls410
                 WHERE znsls410.T$PECL$C = Q1.PEDIDO
                   AND znsls410.T$ENTR$C = Q1.NO_ENTREGA
                   AND znsls410.T$POCO$C = 'AES' )
   and Q1.CHAVE_FILIAL IN (:Filial)
   and Q1.ID_DEPARTAMENTO IN (:Depto)
