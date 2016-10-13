    SELECT Q_ENTREGA.t$UNEG$C                                    CD_UNIDADE_NEGOCIO,      
           Q_ENTREGA.t$PECL$C                                    NR_PEDIDO,               
           Q_ENTREGA.t$ENTR$C                                    NR_ENTREGA,              
           tdsls400.t$ORNO                                       NR_ORDEM,   
           tdsls401.t$ddta                                       DT_LIMITE_EXP,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(DATA_OCORR,         
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
               AT time zone 'America/Sao_Paulo') AS DATE)        DT_INTEG_WMS,    
           
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,         
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
               AT time zone 'America/Sao_Paulo') AS DATE)        DT_EMISSAO,     
           
           cast(znfmd001.t$fili$c as int)                        CD_FILIAL,     
           znfmd001.t$dsca$c                                     DS_FILIAL,              
           cast(Q_ENTREGA.VL_TOTAL as numeric(15,2))             VL_TOTAL,  
           cast(Q_ENTREGA.QUANTIDADE as int)                     QT_VENDIDA,    
           ltrim(rtrim(Q_ENTREGA.t$itml$c))                      CD_ITEM,       
           cast( (whwmd400.t$hght *                           
                  whwmd400.t$wdth *                                 
                  whwmd400.t$dpth *                                 
                  Q_ENTREGA.QUANTIDADE) as numeric(15,4) )       VL_VOLUME_M3, 
           tcibd001.t$citg                                       CD_DEPARTAMENTO,        
           tcmcs023.t$dsca                                       DS_DEPARTAMENTO,
           NVL(tcmcs080_TRANS.t$cfrw, 
               TRANSP.CODE)                                      COD_TRANSPORTDORA,
           NVL(tcmcs080_TRANS.t$fovn$l,                          
               regexp_replace(TRANSP.CNPJ, '[^0-9]', ''))        CNPJ_TRANSPORTADORA
     
      FROM ( select znsls401.T$NCIA$C,                           
                    znsls401.T$UNEG$C,                   
                    znsls401.T$PECL$C,                   
                    znsls401.T$SQPD$C,                   
                    znsls401.T$ENTR$C,                   
                    znsls401.t$itml$c,                           
                    SUM(znsls401.t$vlun$c * znsls401.t$qtve$c) +    
                        SUM(znsls401.t$vlfr$c) -                     
                        SUM(znsls401.t$vldi$c)   VL_TOTAL,           
                    SUM(znsls401.t$qtve$c)       QUANTIDADE      
               from baandb.tznsls401301  znsls401
             having SUM(znsls401.t$qtve$c) > 0
           group by znsls401.T$NCIA$C,  
                    znsls401.T$UNEG$C,   
                    znsls401.T$PECL$C,   
                    znsls401.T$SQPD$C,   
                    znsls401.T$ENTR$C,   
                    znsls401.t$itml$c ) Q_ENTREGA 
  
INNER JOIN baandb.tznsls400301  znsls400
        ON znsls400.T$NCIA$C = Q_ENTREGA.T$NCIA$C         
       AND znsls400.T$UNEG$C = Q_ENTREGA.T$UNEG$C                                      
       AND znsls400.T$PECL$C = Q_ENTREGA.T$PECL$C                                      
       AND znsls400.T$SQPD$C = Q_ENTREGA.T$SQPD$C                                      
  
  
 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.t$entr$c,  znsls410.T$SEQN$C) PT_CONTR
               from baandb.tznsls410301 znsls410
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = Q_ENTREGA.t$ncia$c
       AND znsls410.t$uneg$c = Q_ENTREGA.t$uneg$c
       AND znsls410.t$pecl$c = Q_ENTREGA.t$pecl$c
       AND znsls410.t$entr$c = Q_ENTREGA.t$entr$c
       AND znsls410.t$sqpd$c = Q_ENTREGA.t$sqpd$c
  
 /* 
INNER JOIN ( SELECT znsls410.T$NCIA$C,      
                    znsls410.T$UNEG$C,      
                    znsls410.T$PECL$C,      
                    znsls410.T$SQPD$C,      
                    znsls410.T$ENTR$C,      
                    znsls410.t$dtoc$c,                         
                    znsls410.T$POCO$C ,         
                    ROW_NUMBER() OVER (PARTITION BY znsls410.T$NCIA$C,      
                                                    znsls410.T$UNEG$C,      
                                                    znsls410.T$PECL$C,      
                                                    znsls410.T$SQPD$C,      
                                                    znsls410.T$ENTR$C       
                                      ORDER BY znsls410.T$DTOC$C DESC, znsls410.T$SEQN$C DESC) RN                                     
              FROM baandb.tznsls410301  znsls410 
             WHERE znsls410.T$POCO$C = 'WMS' ) Q_UPONTO
        ON znsls410T$NCIA$C = Q_ENTREGA.T$NCIA$C  
       AND znsls410T$UNEG$C = Q_ENTREGA.T$UNEG$C  
       AND znsls410T$PECL$C = Q_ENTREGA.T$PECL$C  
       AND znsls410T$SQPD$C = Q_ENTREGA.T$SQPD$C  
       AND znsls410T$ENTR$C = Q_ENTREGA.T$ENTR$C  
*/

INNER JOIN ( select A.T$NCIA$C,                                          
                    A.T$UNEG$C,                          
                    A.T$PECL$C,                          
                    A.T$SQPD$C,                          
                    A.T$ENTR$C,                          
                    MAX(A.T$ORNO$C) T$ORNO$C,
                    MAX(A.T$PONO$C) T$PONO$C
               from BAANDB.TZNSLS004301  A          
              where A.T$DATE$C = ( SELECT MAX(B.T$DATE$C)            
                                     FROM BAANDB.TZNSLS004301  B          
                                    WHERE B.T$NCIA$C = A.T$NCIA$C                          
                                      AND B.T$UNEG$C = A.T$UNEG$C                          
                                      AND B.T$PECL$C = A.T$PECL$C                          
                                      AND B.T$SQPD$C = A.T$SQPD$C                          
                                      AND B.T$ENTR$C = A.T$ENTR$C )                         
           group by A.T$NCIA$C,                                 
                    A.T$UNEG$C,                              
                    A.T$PECL$C,                              
                    A.T$SQPD$C,                              
                    A.T$ENTR$C ) ZNSLS004
        ON ZNSLS004.T$NCIA$C = znsls410.T$NCIA$C             
       AND ZNSLS004.T$UNEG$C = znsls410.T$UNEG$C            
       AND ZNSLS004.T$PECL$C = znsls410.T$PECL$C            
       AND ZNSLS004.T$SQPD$C = znsls410.T$SQPD$C    
       AND ZNSLS004.T$ENTR$C = znsls410.T$ENTR$C     
  
INNER JOIN baandb.ttdsls400301  tdsls400  
        ON tdsls400.t$orno = ZNSLS004.t$ORNO$C

INNER JOIN ( select CASE WHEN Trunc(Max(tdsls401.t$ddta)) <= TO_DATE('01/01/1970','DD/MM/YYYY')
                           THEN NULL
                         ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(tdsls401.t$ddta), 'DD-MON-YYYY HH24:MI:SS'),
                                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                    END                                                t$ddta,
                    tdsls401.t$orno
               from baandb.ttdsls401301  tdsls401
           group by tdsls401.t$orno ) tdsls401
        ON tdsls401.t$orno = tdsls400.t$orno

INNER JOIN baandb.ttcmcs065301  tcmcs065  
        ON tcmcs065.t$cwoc = tdsls400.t$cofc
        
INNER JOIN baandb.ttccom130301  tccom130
        ON tccom130.t$cadr = tcmcs065.t$cadr
        
INNER JOIN baandb.tznfmd001301  znfmd001
        ON znfmd001.t$fovn$c = tccom130.t$fovn$l 
        
INNER JOIN baandb.twhwmd400301  whwmd400
        ON whwmd400.t$item = Q_ENTREGA.t$itml$c

INNER JOIN baandb.ttcibd001301  tcibd001
        ON  tcibd001.t$item = Q_ENTREGA.t$itml$c
        
INNER JOIN baandb.ttcmcs023301  tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg    
        
 LEFT JOIN ( select regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') t$fovn$l,
                    tcmcs080.t$dsca,
                    tcmcs080.t$cfrw
               from baandb.ttcmcs080301 tcmcs080
         inner join baandb.ttccom130301 tccom130
                 on tccom130.t$cadr = tcmcs080.t$cadr$l
              where tccom130.t$ftyp$l = 'PJ' ) tcmcs080_TRANS
        ON tcmcs080_TRANS.t$cfrw = tdsls400.t$cfrw

 LEFT JOIN ( select cisli940.t$cfrw$l  CODE,
                    tcmcs080.t$fovn$l  CNPJ,
                    cisli245.t$slso,
                    cisli245.t$pono
               from BAANDB.tcisli245301 cisli245
          left join BAANDB.tcisli941301 cisli941  
                 on cisli941.t$fire$l = cisli245.t$fire$l
                and cisli941.t$line$l = cisli245.t$line$l
          left join BAANDB.tcisli940301 cisli940 
                 on cisli940.t$fire$l = cisli941.t$fire$l
          left join ( SELECT tcmcs080.t$cfrw,
                             tccom130.t$fovn$l
                        FROM baandb.ttcmcs080301  tcmcs080
                  INNER JOIN baandb.ttccom130301 tccom130
                          ON tccom130.t$cadr = tcmcs080.t$cadr$l
                       WHERE tccom130.t$ftyp$l = 'PJ' ) tcmcs080
                 on tcmcs080.t$cfrw = cisli940.t$cfrw$l
              where cisli245.t$ortp = 1
                and cisli245.t$koor = 3  ) TRANSP
        ON TRANSP.t$slso = ZNSLS004.t$orno$c
       AND TRANSP.t$pono = ZNSLS004.t$pono$c

     WHERE znsls410.PT_CONTR = 'WMS'
       AND tdsls400.t$hdst != 35
