SELECT
  DISTINCT
  znsls401.t$entr$c        ENTREGA,
  znfmd630.t$docn$c        NOTA,
  znfmd630.t$seri$c        SERIE,
  znfmd630.t$fili$c        FILIAL,
  znfmd001.T$dsca$c        DESC_FILIAL,
  znfmd630.t$cfrw$c        TRANSPORTADOR,
  tcmcs080.t$dsca          DESC_TRANSP,
 
  CASE WHEN ETR_OCCUR.DT < = to_date('01-01-1980','DD-MM-YYYY')
         THEN NULL
       ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR( ETR_OCCUR.DT,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE)
  END                      DATA_SAIDA,
 
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt,
     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                           DATA_PROMETIDA,
       
  CASE WHEN ULT_OCOR.DT_PROC < = to_date('01-01-1980','DD-MM-YYYY')
         THEN NULL
       ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ULT_OCOR.DT_PROC,
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)
  END                      DATA_PROCESSAMENTO,
       
  ULT_OCOR.PONTO           STATUS,
  znfmd040.t$dotr$c        DESC_STATUS,
 
  CASE WHEN ULT_OCOR.DT < = to_date('01-01-1980','DD-MM-YYYY')
         THEN NULL
       ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ULT_OCOR.DT,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE)
   END                     DATA_STATUS,
  
  CASE WHEN ULT_OCOR.LOGIN_PROC = 'j601ptri'
         THEN 'EDI'
       ELSE   'MANUAL'
  END                      BAIXA_MANUAL_EDI,
  znsls401.t$uneg$c        UNIDADE_NEGOCIO,
  znint002.t$desc$c        DESC_UN_NEGOCIO,
  znsls401.t$orno$c        ORDEM_VENDA,
  znsls401.t$ufen$c        UF,
  znsls401.t$cepe$c        CEP,
  znsls401.t$cide$c        CIDADE,
  znsls401.t$baie$c        REGIAO,
  znsls401.t$itpe$c        TIPO_ENTREGA,
  znsls002.t$dsca$c        DESC_TIPO_ENTREGA,
 
    CASE WHEN znfmd630.t$stat$c = 2
           THEN 'P'                     --PENDENTE
         ELSE   'F'                     --FINALIZADO 
    END                      FINALIZADO_PENDENTE,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.T$DTEM$C, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)  
                             DATA_COMPRA,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WMS_ORDERS.SCHEDULEDSHIPDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)  
                             DATA_LIMITE_EXPEDICAO,
                                        
    CASE WHEN WMS_SKU.SUSR2 = '2'
           THEN 'PESADO'
    ELSE 'LEVE' END          TIPO_ENTREGA_TRANSPORTES,
         
    znfmd630.t$fili$c        COD_FILIAL,
         
    ABS(znsls401.t$qtve$c * 
        znsls401.t$vlun$c)   VL_PRODUTO,
         
    znsls401.t$vlfr$c        FRETE_COBRADO_SITE,
    ABS(znsls401.t$qtve$c)   QTD_ITENS,
    usuario.t$name           USUARIO,
    znfmd061.t$dzon$c        CAPITAL_INTERIOR,
    znfmd630.t$vlfc$c        FRETE_TRANSPORTADORA,
    ULT_OCOR.PONTO           ID_OCORRENCIA,          --Ultima ocorrencia da transportadora
    CASE WHEN znfmd630.t$dtco$c < = to_date('01-01-1980','DD-MM-YYYY') 
           THEN NULL
         ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)   
    END                      DATA_CORRIGIDA,
    CASE WHEN tdsls400.t$ddat < = to_date('01-01-1980','DD-MM-YYYY') 
           THEN NULL
         ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)  
    END                      DATA_LIMITE_CD,
    CASE WHEN OCORR_FIM.t$date$c < = to_date('01-01-1980','DD-MM-YYYY') 
           THEN NULL
         ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OCORR_FIM.t$date$c, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)
    END                      DATA_ENTREGA            --Ocorrencia finalizadora
  
FROM      baandb.tznfmd630601 znfmd630

LEFT JOIN baandb.tznsls401601 znsls401
       ON TO_CHAR(znsls401.t$entr$c) = znfmd630.t$pecl$c       --MMF.n

LEFT JOIN baandb.ttdsls400601 tdsls400
       ON tdsls400.t$orno = znsls401.t$orno$c

LEFT JOIN baandb.tznsls400601 znsls400 --DTEM 
       ON znsls400.T$NCIA$C = znsls401.T$NCIA$C
      AND znsls400.T$UNEG$C = znsls401.T$UNEG$C
      AND znsls400.T$PECL$C = znsls401.T$PECL$C
      AND znsls400.T$SQPD$C = znsls401.T$SQPD$C
    
LEFT JOIN ( SELECT znfmd640d.t$coci$c  PONTO,
                   znfmd640d.t$date$c  DT,
                   znfmd640d.t$udat$c  DT_PROC,
                   znfmd640d.t$ulog$c  LOGIN_PROC,
                   znfmd640d.t$fili$c,
                   znfmd640d.t$etiq$c
              FROM BAANDB.tznfmd640601 znfmd640d
             WHERE znfmd640d.t$coci$c = ( select max(znfmd640x.t$coci$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640x.t$date$c,  znfmd640x.t$udat$c)
                                            from BAANDB.tznfmd640601 znfmd640x
                                           where znfmd640x.t$fili$c = znfmd640d.t$fili$c                                  
                                             and   znfmd640x.t$etiq$c = znfmd640d.t$etiq$c ) ) ULT_OCOR
       ON ULT_OCOR.t$fili$c = znfmd630.t$fili$c
      AND ULT_OCOR.t$etiq$c = znfmd630.t$etiq$c

LEFT JOIN baandb.tznfmd040601 znfmd040
       ON znfmd040.t$cfrw$c = znfmd630.t$cfrw$c
      AND znfmd040.t$ocin$c = ULT_OCOR.PONTO
              
LEFT JOIN ( SELECT znfmd640d.t$date$c  DT,
                   znfmd640d.t$fili$c,
                   znfmd640d.t$etiq$c
              FROM BAANDB.tznfmd640601 znfmd640d
             WHERE znfmd640d.t$date$c = ( select max(znfmd640x.t$date$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640x.t$date$c,  znfmd640x.t$udat$c)
                                            from BAANDB.tznfmd640601 znfmd640x
                                           where znfmd640x.t$fili$c = znfmd640d.t$fili$c         
                                             and znfmd640x.t$etiq$c = znfmd640d.t$etiq$c
                                             and znfmd640x.t$coci$c = 'ETR' ) )   ETR_OCCUR
       ON ETR_OCCUR.t$fili$c = znfmd630.t$fili$c
      AND ETR_OCCUR.t$etiq$c = znfmd630.t$etiq$c

LEFT JOIN baandb.ttcmcs080601  tcmcs080
       ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c
  
LEFT JOIN baandb.tznfmd001601  znfmd001
       ON znfmd001.t$fili$c = znfmd630.t$fili$c

LEFT JOIN baandb.tznsls002601  znsls002
       ON znsls002.t$tpen$c = znsls401.t$itpe$c
  
LEFT JOIN baandb.tznint002601  znint002
       ON znint002.t$ncia$c = znsls401.t$ncia$c
      AND znint002.t$uneg$c = znsls401.t$uneg$c

LEFT JOIN WMWHSE9.ORDERS@DL_LN_WMS WMS_ORDERS
       ON WMS_ORDERS.REFERENCEDOCUMENT = znsls401.t$orno$c
     
LEFT JOIN WMWHSE9.SKU@DL_LN_WMS  WMS_SKU
       ON TRIM(WMS_SKU.SKU) = TRIM(ZNSLS401.T$ITEM$C)
   
LEFT JOIN ( select ttaad200.t$user,
                   ttaad200.t$name
              from baandb.tttaad200000 ttaad200 ) usuario
       ON usuario.t$user = ULT_OCOR.LOGIN_PROC
  
LEFT JOIN ( select znfmd062.t$creg$c,
                   znfmd062.t$cfrw$c,
                   znfmd062.t$cono$c,
                   znfmd062.t$cepd$c,
                   znfmd062.t$cepa$c
              from baandb.tznfmd062601 znfmd062 ) znfmd062
       ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c
      AND znfmd062.t$cono$c = znfmd630.t$cono$c
      AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c
      AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c
        
LEFT JOIN baandb.tznfmd061601 znfmd061
       ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c
      AND znfmd061.t$cono$c = znfmd630.t$cono$c
      AND znfmd061.t$creg$c = znfmd062.t$creg$c
      
LEFT JOIN ( SELECT MAX(a.t$date$c) t$date$c,
                   a.t$fili$c,
                   a.t$etiq$c
              FROM BAANDB.tznfmd640601 a
             WHERE a.t$coci$c IN ('ENT', 'EXT', 'ROU', 'AVA', 'DEV', 'EXF', 'RIE', 'RTD') 
          GROUP BY a.t$fili$c, 
                   a.t$etiq$c ) OCORR_FIM
       ON OCORR_FIM.t$fili$c = znfmd630.t$fili$c
      AND OCORR_FIM.t$etiq$c = znfmd630.t$etiq$c 
 
 WHERE ( select znfmd640.t$coci$c
           from baandb.tznfmd640601 znfmd640
          where znfmd640.t$fili$c = znfmd630.t$fili$c
            and znfmd640.t$etiq$c = znfmd630.t$etiq$c
            and znfmd640.t$coci$c = 'ETR'
            and rownum = 1 ) IS NOT NULL
    
   AND NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ULT_OCOR.DT_PROC,       
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   
           AT time zone 'America/Sao_Paulo') AS DATE), :DataProcessamentoDe)
       Between :DataProcessamentoDe
           And :DataProcessamentoAte
   AND znfmd630.t$stat$c IN (:FinalizadoPendente)
   
=

" SELECT  " &
"   DISTINCT  " &
"   znsls401.t$entr$c        ENTREGA,  " &
"   znfmd630.t$docn$c        NOTA,  " &
"   znfmd630.t$seri$c        SERIE,  " &
"   znfmd630.t$fili$c        FILIAL,  " &
"   znfmd001.T$dsca$c        DESC_FILIAL,  " &
"   znfmd630.t$cfrw$c        TRANSPORTADOR,  " &
"   tcmcs080.t$dsca          DESC_TRANSP,  " &
"  " &
"   CASE WHEN ETR_OCCUR.DT < = to_date('01-01-1980','DD-MM-YYYY')  " &
"          THEN NULL  " &
"        ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR( ETR_OCCUR.DT,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE)  " &
"   END                      DATA_SAIDA,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"         AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                            DATA_PROMETIDA,  " &
"  " &
"   CASE WHEN ULT_OCOR.DT_PROC < = to_date('01-01-1980','DD-MM-YYYY')  " &
"          THEN NULL  " &
"        ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ULT_OCOR.DT_PROC,  " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"   END                      DATA_PROCESSAMENTO,  " &
"  " &
"   ULT_OCOR.PONTO           STATUS,  " &
"   znfmd040.t$dotr$c        DESC_STATUS,  " &
"  " &
"   CASE WHEN ULT_OCOR.DT < = to_date('01-01-1980','DD-MM-YYYY')  " &
"          THEN NULL  " &
"        ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ULT_OCOR.DT,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE)  " &
"    END                     DATA_STATUS,  " &
"  " &
"   CASE WHEN ULT_OCOR.LOGIN_PROC = 'j601ptri'  " &
"          THEN 'EDI'  " &
"        ELSE   'MANUAL'  " &
"   END                      BAIXA_MANUAL_EDI,  " &
"   znsls401.t$uneg$c        UNIDADE_NEGOCIO,  " &
"   znint002.t$desc$c        DESC_UN_NEGOCIO,  " &
"   znsls401.t$orno$c        ORDEM_VENDA,  " &
"   znsls401.t$ufen$c        UF,  " &
"   znsls401.t$cepe$c        CEP,  " &
"   znsls401.t$cide$c        CIDADE,  " &
"   znsls401.t$baie$c        REGIAO,  " &
"   znsls401.t$itpe$c        TIPO_ENTREGA,  " &
"   znsls002.t$dsca$c        DESC_TIPO_ENTREGA,  " &
"  " &
"     CASE WHEN znfmd630.t$stat$c = 2  " &
"            THEN 'P'  " &
"          ELSE   'F'  " &
"     END                      FINALIZADO_PENDENTE,  " &
"  " &
"     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.T$DTEM$C,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"         AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                              DATA_COMPRA,  " &
"  " &
"     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WMS_ORDERS.SCHEDULEDSHIPDATE,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"         AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                              DATA_LIMITE_EXPEDICAO,  " &
"  " &
"     CASE WHEN WMS_SKU.SUSR2 = '2'  " &
"            THEN 'PESADO'  " &
"     ELSE 'LEVE' END          TIPO_ENTREGA_TRANSPORTES,  " &
"  " &
"     znfmd630.t$fili$c        COD_FILIAL,  " &
"  " &
"     ABS(znsls401.t$qtve$c *  " &
"         znsls401.t$vlun$c)   VL_PRODUTO,  " &
"  " &
"     znsls401.t$vlfr$c        FRETE_COBRADO_SITE,  " &
"     ABS(znsls401.t$qtve$c)   QTD_ITENS,  " &
"     usuario.t$name           USUARIO,  " &
"     znfmd061.t$dzon$c        CAPITAL_INTERIOR,  " &
"     znfmd630.t$vlfc$c        FRETE_TRANSPORTADORA,  " &
"     ULT_OCOR.PONTO           ID_OCORRENCIA,  " &
"     CASE WHEN znfmd630.t$dtco$c < = to_date('01-01-1980','DD-MM-YYYY')  " &
"            THEN NULL  " &
"          ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c,  " &
"                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                   AT time zone 'America/Sao_Paulo') AS DATE)  " &
"     END                      DATA_CORRIGIDA,  " &
"     CASE WHEN tdsls400.t$ddat < = to_date('01-01-1980','DD-MM-YYYY')  " &
"            THEN NULL  " &
"          ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat,  " &
"                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                   AT time zone 'America/Sao_Paulo') AS DATE)  " &
"     END                      DATA_LIMITE_CD,  " &
"     CASE WHEN OCORR_FIM.t$date$c < = to_date('01-01-1980','DD-MM-YYYY')  " &
"            THEN NULL  " &
"          ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OCORR_FIM.t$date$c,  " &
"                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                   AT time zone 'America/Sao_Paulo') AS DATE)  " &
"     END                      DATA_ENTREGA  " &
"  " &
" FROM      baandb.tznfmd630" + Parameters!Compania.Value + " znfmd630  " &
"  " &
" LEFT JOIN baandb.tznsls401" + Parameters!Compania.Value + " znsls401  " &
"        ON TO_CHAR(znsls401.t$entr$c) = znfmd630.t$pecl$c  " &
"  " &
" LEFT JOIN baandb.ttdsls400" + Parameters!Compania.Value + " tdsls400  " &
"        ON tdsls400.t$orno = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN baandb.tznsls400" + Parameters!Compania.Value + " znsls400  " &
"        ON znsls400.T$NCIA$C = znsls401.T$NCIA$C  " &
"       AND znsls400.T$UNEG$C = znsls401.T$UNEG$C  " &
"       AND znsls400.T$PECL$C = znsls401.T$PECL$C  " &
"       AND znsls400.T$SQPD$C = znsls401.T$SQPD$C  " &
"  " &
" LEFT JOIN ( SELECT znfmd640d.t$coci$c  PONTO,  " &
"                    znfmd640d.t$date$c  DT,  " &
"                    znfmd640d.t$udat$c  DT_PROC,  " &
"                    znfmd640d.t$ulog$c  LOGIN_PROC,  " &
"                    znfmd640d.t$fili$c,  " &
"                    znfmd640d.t$etiq$c  " &
"               FROM BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640d  " &
"              WHERE znfmd640d.t$coci$c = ( select max(znfmd640x.t$coci$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640x.t$date$c,  znfmd640x.t$udat$c)  " &
"                                             from BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640x  " &
"                                            where znfmd640x.t$fili$c = znfmd640d.t$fili$c  " &
"                                              and   znfmd640x.t$etiq$c = znfmd640d.t$etiq$c ) ) ULT_OCOR  " &
"        ON ULT_OCOR.t$fili$c = znfmd630.t$fili$c  " &
"       AND ULT_OCOR.t$etiq$c = znfmd630.t$etiq$c  " &
"  " &
" LEFT JOIN baandb.tznfmd040" + Parameters!Compania.Value + " znfmd040  " &
"        ON znfmd040.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd040.t$ocin$c = ULT_OCOR.PONTO  " &
"  " &
" LEFT JOIN ( SELECT znfmd640d.t$date$c  DT,  " &
"                    znfmd640d.t$fili$c,  " &
"                    znfmd640d.t$etiq$c  " &
"               FROM BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640d  " &
"              WHERE znfmd640d.t$date$c = ( select max(znfmd640x.t$date$c) KEEP (DENSE_RANK LAST ORDER BY znfmd640x.t$date$c,  znfmd640x.t$udat$c)  " &
"                                             from BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640x  " &
"                                            where znfmd640x.t$fili$c = znfmd640d.t$fili$c  " &
"                                              and znfmd640x.t$etiq$c = znfmd640d.t$etiq$c  " &
"                                              and znfmd640x.t$coci$c = 'ETR' ) )   ETR_OCCUR  " &
"        ON ETR_OCCUR.t$fili$c = znfmd630.t$fili$c  " &
"       AND ETR_OCCUR.t$etiq$c = znfmd630.t$etiq$c  " &
"  " &
" LEFT JOIN baandb.ttcmcs080" + Parameters!Compania.Value + "  tcmcs080  " &
"        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c  " &
"  " &
" LEFT JOIN baandb.tznfmd001" + Parameters!Compania.Value + "  znfmd001  " &
"        ON znfmd001.t$fili$c = znfmd630.t$fili$c  " &
"  " &
" LEFT JOIN baandb.tznsls002" + Parameters!Compania.Value + "  znsls002  " &
"        ON znsls002.t$tpen$c = znsls401.t$itpe$c  " &
"  " &
" LEFT JOIN baandb.tznint002" + Parameters!Compania.Value + "  znint002  " &
"        ON znint002.t$ncia$c = znsls401.t$ncia$c  " &
"       AND znint002.t$uneg$c = znsls401.t$uneg$c  " &
"  " &
" LEFT JOIN " + IIF(Parameters!Compania.Value = "601", "WMWHSE10", "WMWHSE9") + ".ORDERS@DL_LN_WMS WMS_ORDERS  " &
"        ON WMS_ORDERS.REFERENCEDOCUMENT = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN " + IIF(Parameters!Compania.Value = "601", "WMWHSE10", "WMWHSE9") + ".SKU@DL_LN_WMS  WMS_SKU  " &
"        ON TRIM(WMS_SKU.SKU) = TRIM(ZNSLS401.T$ITEM$C)  " &
"  " &
" LEFT JOIN ( select ttaad200.t$user,  " &
"                    ttaad200.t$name  " &
"               from baandb.tttaad200000 ttaad200 ) usuario  " &
"        ON usuario.t$user = ULT_OCOR.LOGIN_PROC  " &
"  " &
" LEFT JOIN ( select znfmd062.t$creg$c,  " &
"                    znfmd062.t$cfrw$c,  " &
"                    znfmd062.t$cono$c,  " &
"                    znfmd062.t$cepd$c,  " &
"                    znfmd062.t$cepa$c  " &
"               from baandb.tznfmd062" + Parameters!Compania.Value + " znfmd062 ) znfmd062  " &
"        ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c  " &
"       AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c  " &
"  " &
" LEFT JOIN baandb.tznfmd061" + Parameters!Compania.Value + " znfmd061  " &
"        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd061.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"  " &
" LEFT JOIN ( SELECT MAX(a.t$date$c) t$date$c,  " &
"                    a.t$fili$c,  " &
"                    a.t$etiq$c  " &
"               FROM BAANDB.tznfmd640" + Parameters!Compania.Value + " a  " &
"              WHERE a.t$coci$c IN ('ENT', 'EXT', 'ROU', 'AVA', 'DEV', 'EXF', 'RIE', 'RTD')  " &
"           GROUP BY a.t$fili$c,  " &
"                    a.t$etiq$c ) OCORR_FIM  " &
"        ON OCORR_FIM.t$fili$c = znfmd630.t$fili$c  " &
"       AND OCORR_FIM.t$etiq$c = znfmd630.t$etiq$c  " &
"  " &
"  WHERE ( select znfmd640.t$coci$c  " &
"            from baandb.tznfmd640" + Parameters!Compania.Value + " znfmd640  " &
"           where znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"             and znfmd640.t$etiq$c = znfmd630.t$etiq$c  " &
"             and znfmd640.t$coci$c = 'ETR'  " &
"             and rownum = 1 ) IS NOT NULL  " &
"    AND NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ULT_OCOR.DT_PROC,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), :DataProcessamentoDe)  " &
"        Between :DataProcessamentoDe  " &
"            And :DataProcessamentoAte  " &
"    AND znfmd630.t$stat$c IN (" + JOIN(Parameters!FinalizadoPendente.Value, ", ") + ") "