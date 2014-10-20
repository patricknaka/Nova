SELECT  
  DISTINCT 
    WMSADMIN.PL_DB.DB_ALIAS               DSC_PLANTA,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)
                                          DATA_LIMITE,
            
    ORDERS.ORDERKEY                       PEDIDO,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                          DATA_REGISTRO,
            
    ORDERSTATUSSETUP2.DESCRIPTION         EVENTO,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                          DATA_ULT_EVENTO,
            
    ORDERSTATUSHISTORY.ADDWHO             OPERADOR,
    ORDERDETAIL.SKU                       ITEM,
    SKU.DESCR                             NOME_ITEM,
    SLS400.T$IDCA$C                       CANAL,
    NVL(ORDERS.C_VAT, 'N/A')              MEGA_ROTA,
    ORDERSTATUSSETUP.DESCRIPTION          SITUACAO,
    TASKDETAIL.TASKDETAILKEY              PROGRAMA,
    WAVEDETAIL.WAVEKEY                    ONDA,
    ORDERS.CARRIERCODE                    ID_TRANSPORTADORA,
    ORDERS.CARRIERNAME                    TRANSPORTADORA,
    SLS002.T$TPEN$C                       TIPO_ENTREGA,
    NVL(ORDERS.SUSR1, 'Não aplicável')    NOME_TP_ENT,
    ORDERS.INVOICENUMBER                  NOTA,
    ORDERS.LANE                           SERIE,
    CAGEIDDETAIL.CAGEID                   CARGA,
    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' 
         ELSE 'LEVE' 
     END                                  TP_TRANSPORTE,
    ORDERS.C_ZIP                          CEP,
    whwmd400.t$hght                       ALTURA,
    whwmd400.t$wdth                       LARGURA,
    whwmd400.t$dpth                       COMPRIMENTO,
    SKU.STDNETWGT                         PESO_UNITARIO,
    SKU.STDGROSSWGT                       PESO_BRUTO,
    ORDERS.C_CITY                         MUNICIPIO,
    ORDERS.C_STATE                        ESTADO,
    ORDERDETAIL.SHIPPEDQTY                QUANTIDADE,
    sls400.                               VALOR,
 
    REDESPACHO.description                REDESPACHO,
   
    CASE WHEN sls400.t$tpes$c = 'X' THEN 'Crossdocking'
         WHEN sls400.t$tpes$c = 'F' THEN 'Fingido'
         WHEN sls400.t$tpes$c = 'P' THEN 'Pré-Venda'
         ELSE 'NORMAL' 
     END                                  TIPO_ESTOQ,
   
    CASE WHEN TO_CHAR(LL.HOLDREASON) = ' '
           THEN 'OK'
         ELSE nvl(TO_CHAR(LL.HOLDREASON), 'OK') 
     END                                  RESTRICAO,
   
    maucLN.mauc                           VALOR_CUSTO_CMV,
    ORDERS.C_ADDRESS1                     DESTINATARIO
 
FROM       WMWHSE5.ORDERS

INNER JOIN WMWHSE5.ORDERDETAIL 
        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY
        
INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = ORDERDETAIL.SKU 
        
 LEFT JOIN ENTERPRISE.CODELKUP cl  
        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)
       AND cl.listname = 'SCHEMA'
      
 LEFT JOIN ( select trim(whina113.t$item) item,
                    whina113.t$cwar cwar,
                    sum(whina113.t$mauc$1) mauc
               from BAANDB.Twhina113301@pln01 whina113
              where (whina113.t$trdt, whina113.t$seqn) = ( select max(b.t$trdt), max(b.t$seqn) 
                                                             from BAANDB.Twhina113301@pln01 b
                                                            where b.t$item = whina113.t$item
                                                              and b.t$cwar = whina113.t$cwar
                                                              and b.t$trdt = ( select max(c.t$trdt) 
                                                                                 from BAANDB.Twhina113301@pln01 c
                                                                                where c.t$item = b.t$item
                                                                                  and c.t$cwar = b.t$cwar ) )                                    
           group by whina113.t$item, whina113.t$cwar ) maucLN   
        ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6)
       AND maucLN.item = sku.sku
  
 LEFT JOIN WMWHSE5.WAVEDETAIL
        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  
        
 LEFT JOIN WMWHSE5.CAGEIDDETAIL
        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY 
        
 LEFT JOIN WMWHSE5.CAGEID
        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID
        
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID 
        
 LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002
        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1)) 
        
 LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 
        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)
        
 LEFT JOIN ( SELECT a.ORDERKEY, 
                    a.ORDERLINENUMBER , 
                    max(a.STATUS) STATUS, 
                    max(a.ADDDATE) ADDDATE, 
                    max(a.ADDWHO) ADDWHO 
               FROM WMWHSE5.ORDERSTATUSHISTORY a
              WHERE a.ADDDATE = ( select max(b.adddate) 
                                    from WMWHSE5.ORDERSTATUSHISTORY b
                                   where b.ORDERKEY = a.ORDERKEY
                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER )
           GROUP BY a.ORDERKEY, 
                    a.ORDERLINENUMBER ) ORDERSTATUSHISTORY
        ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY 
       AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER 
       AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS  
       
 LEFT JOIN WMWHSE5.ORDERSTATUSSETUP
        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS
        
 LEFT JOIN WMWHSE5.ORDERSTATUSSETUP ORDERSTATUSSETUP2
        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS
        
 LEFT JOIN WMWHSE5.TASKDETAIL
        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY 
       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER  
    
 LEFT JOIN WMWHSE5.LOTXLOC LL 
        ON LL.LOT = TASKDETAIL.LOT
       AND LL.LOC = TASKDETAIL.FROMLOC
       AND LL.SKU = TASKDETAIL.SKU
               
 LEFT JOIN ( select q.T$IDCA$C, 
                    ZNSLS004.T$ORNO$C,
                    znsls401.t$item$c,
                    znsls401.t$tpes$c,
                    sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) - 
                          znsls401.t$vldi$c +
                          znsls401.t$vlfr$c + 
                          znsls401.t$vlde$c ) VALOR
               from BAANDB.TZNSLS004301@pln01 ZNSLS004
         inner join BAANDB.TZNSLS400301@pln01 q
                 on ZNSLS004.T$NCIA$C = q.T$NCIA$C
                and ZNSLS004.T$UNEG$C = q.T$UNEG$C
                and ZNSLS004.T$PECL$C = q.T$PECL$C
                and ZNSLS004.T$SQPD$C = q.T$SQPD$C
         inner join BAANDB.TZNSLS401301@pln01 ZNSLS401
                 on znsls401.T$NCIA$C = znsls004.T$NCIA$C
                and znsls401.T$UNEG$C = znsls004.T$UNEG$C
                and znsls401.T$PECL$C = znsls004.T$PECL$C
                and znsls401.T$SQPD$C = znsls004.T$SQPD$C
                and znsls401.t$entr$c = znsls004.t$entr$c
                and znsls401.t$sequ$c = znsls004.t$sequ$c
           group by q.T$IDCA$C, 
                    ZNSLS004.T$ORNO$C,
                    znsls401.t$item$c,
                    znsls401.t$tpes$c ) SLS400
        ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT
       AND SLS400.t$item$c = ORDERDETAIL.SKU

 LEFT JOIN ( select clkp.description,
                    clkp.code
               from WMWHSE5.codelkup clkp
              where clkp.listname = 'INCOTERMS' ) REDESPACHO
        ON REDESPACHO.code = orders.INCOTERM

    
WHERE NVL(SLS002.T$TPEN$C, 0) IN (:TipoEntrega)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone sessiontimezone) AS DATE)) 
      Between :DataUltEventoDe 
          And :DataUltEventoAte
  AND ORDERSTATUSSETUP.CODE IN (:ClasseEventos)
  AND NVL(ORDERS.C_VAT, 'N/A') IN (:MegaRota)
  
ORDER BY ORDERS.ORDERKEY


= IIF(Parameters!Table.Value <> "AAA",

"SELECT " &
"  DISTINCT " &
"  WMSADMIN.PL_DB.DB_ALIAS DSC_PLANTA, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_LIMITE, " &
"  ORDERS.ORDERKEY PEDIDO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_REGISTRO, " &
"  ORDERSTATUSSETUP2.DESCRIPTION EVENTO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_ULT_EVENTO, " &
"  ORDERSTATUSHISTORY.ADDWHO OPERADOR, " &
"  ORDERDETAIL.SKU ITEM, " &
"  SKU.DESCR NOME_ITEM, " &
"  SLS400.T$IDCA$C CANAL, " &
"  NVL(ORDERS.C_VAT, 'N/A') MEGA_ROTA, " &
"  ORDERSTATUSSETUP.DESCRIPTION  SITUACAO, " &
"  TASKDETAIL.TASKDETAILKEY  PROGRAMA, " &
"  WAVEDETAIL.WAVEKEY  ONDA, " &
"  ORDERS.CARRIERCODE  ID_TRANSPORTADORA, " &
"  ORDERS.CARRIERNAME  TRANSPORTADORA, " &
"  SLS002.T$TPEN$C TIPO_ENTREGA, " &
"  NVL(ORDERS.SUSR1, 'Não aplicável') NOME_TP_ENT, " &
"  ORDERS.INVOICENUMBER  NOTA, " &
"  ORDERS.LANE SERIE, " &
"  CAGEIDDETAIL.CAGEID CARGA, " &
"  CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' " &
" ELSE 'LEVE' " &
" END  TP_TRANSPORTE, " &
"  ORDERS.C_ZIP  CEP, " &
"  whwmd400.t$hght ALTURA, " &
"  whwmd400.t$wdth LARGURA, " &
"  whwmd400.t$dpth COMPRIMENTO, " &
"  SKU.STDNETWGT PESO_UNITARIO, " &
"  SKU.STDGROSSWGT PESO_BRUTO, " &
"  ORDERS.C_CITY MUNICIPIO, " &
"  ORDERS.C_STATE  ESTADO, " &
"  ORDERDETAIL.SHIPPEDQTY  QUANTIDADE, " &
"  sls400. VALOR, " &
"  REDESPACHO.description  REDESPACHO, " &
"  CASE WHEN sls400.t$tpes$c = 'X' THEN 'Crossdocking' " &
" WHEN sls400.t$tpes$c = 'F' THEN 'Fingido' " &
" WHEN sls400.t$tpes$c = 'P' THEN 'Pré-Venda' " &
" ELSE 'NORMAL' " &
" END  TIPO_ESTOQ, " &
"  CASE WHEN TO_CHAR(LL.HOLDREASON) = ' ' " &
" THEN 'OK' " &
" ELSE nvl(TO_CHAR(LL.HOLDREASON), 'OK') " &
" END  RESTRICAO, " &
"  maucLN.mauc VALOR_CUSTO_CMV, " &
"  ORDERS.C_ADDRESS1 DESTINATARIO " &
"FROM " + Parameters!Table.Value + ".ORDERS " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERDETAIL " &
"  ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY " &
"INNER JOIN " + Parameters!Table.Value + ".SKU " &
"  ON SKU.SKU = ORDERDETAIL.SKU " &
" LEFT JOIN ENTERPRISE.CODELKUP cl " &
"  ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID) " &
" AND cl.listname = 'SCHEMA' " &
" LEFT JOIN ( select trim(whina113.t$item) item, " &
"  whina113.t$cwar cwar, " &
"  sum(whina113.t$mauc$1) mauc " &
" from BAANDB.Twhina113301@pln01 whina113 " &
"  where (whina113.t$trdt, whina113.t$seqn) = " &
"  ( select max(b.t$trdt), max(b.t$seqn) " &
"  from BAANDB.Twhina113301@pln01 b " &
" where b.t$item = whina113.t$item " &
" and b.t$cwar = whina113.t$cwar " &
" and b.t$trdt = ( select max(c.t$trdt) " &
"  from BAANDB.Twhina113301@pln01 c " &
" where c.t$item = b.t$item " &
" and c.t$cwar = b.t$cwar ) ) " &  
" group by whina113.t$item, whina113.t$cwar ) maucLN " &
"  ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6) " &
" AND maucLN.item = sku.sku " &
" LEFT JOIN " + Parameters!Table.Value + ".WAVEDETAIL " &
"  ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEIDDETAIL " &
"  ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEID " &
"  ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID " &
"INNER JOIN WMSADMIN.PL_DB " &
"  ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002 " &
"  ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1)) " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 " &
"  ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU) " &
" LEFT JOIN ( SELECT a.ORDERKEY, " &
"  a.ORDERLINENUMBER , " &
"  max(a.STATUS) STATUS, " &
"  max(a.ADDDATE) ADDDATE, " &
"  max(a.ADDWHO) ADDWHO " &
" FROM " + Parameters!Table.Value + ".ORDERSTATUSHISTORY a " &
"  WHERE a.ADDDATE = ( select max(b.adddate) " &
"  from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY b " &
" where b.ORDERKEY = a.ORDERKEY " &
" and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
" GROUP BY a.ORDERKEY, " &
"  a.ORDERLINENUMBER ) ORDERSTATUSHISTORY " &
"  ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP " &
"  ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP ORDERSTATUSSETUP2 " &
"  ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS " &
" LEFT JOIN " + Parameters!Table.Value + ".TASKDETAIL " &
"  ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" LEFT JOIN " + Parameters!Table.Value + ".LOTXLOC LL " &
"  ON LL.LOT = TASKDETAIL.LOT " &
" AND LL.LOC = TASKDETAIL.FROMLOC " &
" AND LL.SKU = TASKDETAIL.SKU " &
" LEFT JOIN ( select q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c, " &
"  sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) - " &
"  znsls401.t$vldi$c + " &
"  znsls401.t$vlfr$c + " &
"  znsls401.t$vlde$c ) VALOR " &
"from BAANDB.TZNSLS004301@pln01 ZNSLS004 " &
" inner join BAANDB.TZNSLS400301@pln01 q " &
"   on ZNSLS004.T$NCIA$C = q.T$NCIA$C " &
"  and ZNSLS004.T$UNEG$C = q.T$UNEG$C " &
"  and ZNSLS004.T$PECL$C = q.T$PECL$C " &
"  and ZNSLS004.T$SQPD$C = q.T$SQPD$C " &
" inner join BAANDB.TZNSLS401301@pln01 ZNSLS401 " &
"   on znsls401.T$NCIA$C = znsls004.T$NCIA$C " &
"  and znsls401.T$UNEG$C = znsls004.T$UNEG$C " &
"  and znsls401.T$PECL$C = znsls004.T$PECL$C " &
"  and znsls401.T$SQPD$C = znsls004.T$SQPD$C " &
"  and znsls401.t$entr$c = znsls004.t$entr$c " &
"  and znsls401.t$sequ$c = znsls004.t$sequ$c " &
" group by q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c ) SLS400 " &
"  ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT " &
" AND SLS400.t$item$c = ORDERDETAIL.SKU " &
" LEFT JOIN ( select clkp.description, " &
"  clkp.code " &
" from " + Parameters!Table.Value + ".codelkup clkp " &
"  where clkp.listname = 'INCOTERMS' ) REDESPACHO " &
"  ON REDESPACHO.code = orders.INCOTERM " &
"WHERE NVL(SLS002.T$TPEN$C, 0) IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ") " &
"  AND Trunc(ORDERSTATUSHISTORY.ADDDATE) " &
"  Between '" + Parameters!DataUltEventoDe.Value + "' " &
"  And '" + Parameters!DataUltEventoAte.Value + "' " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ") " &
"  AND NVL(ORDERS.C_VAT, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"ORDER BY ORDERS.ORDERKEY  "

-- Query com Union *****************************************************************************************

"SELECT " &
"  DISTINCT " &
"  WMSADMIN.PL_DB.DB_ALIAS DSC_PLANTA, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_LIMITE, " &
"  ORDERS.ORDERKEY PEDIDO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_REGISTRO, " &
"  ORDERSTATUSSETUP2.DESCRIPTION EVENTO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_ULT_EVENTO, " &
"  ORDERSTATUSHISTORY.ADDWHO OPERADOR, " &
"  ORDERDETAIL.SKU ITEM, " &
"  SKU.DESCR NOME_ITEM, " &
"  SLS400.T$IDCA$C CANAL, " &
"  NVL(ORDERS.C_VAT, 'N/A') MEGA_ROTA, " &
"  ORDERSTATUSSETUP.DESCRIPTION  SITUACAO, " &
"  TASKDETAIL.TASKDETAILKEY  PROGRAMA, " &
"  WAVEDETAIL.WAVEKEY  ONDA, " &
"  ORDERS.CARRIERCODE  ID_TRANSPORTADORA, " &
"  ORDERS.CARRIERNAME  TRANSPORTADORA, " &
"  SLS002.T$TPEN$C TIPO_ENTREGA, " &
"  NVL(ORDERS.SUSR1, 'Não aplicável') NOME_TP_ENT, " &
"  ORDERS.INVOICENUMBER  NOTA, " &
"  ORDERS.LANE SERIE, " &
"  CAGEIDDETAIL.CAGEID CARGA, " &
"  CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' " &
" ELSE 'LEVE' " &
" END  TP_TRANSPORTE, " &
"  ORDERS.C_ZIP  CEP, " &
"  whwmd400.t$hght ALTURA, " &
"  whwmd400.t$wdth LARGURA, " &
"  whwmd400.t$dpth COMPRIMENTO, " &
"  SKU.STDNETWGT PESO_UNITARIO, " &
"  SKU.STDGROSSWGT PESO_BRUTO, " &
"  ORDERS.C_CITY MUNICIPIO, " &
"  ORDERS.C_STATE  ESTADO, " &
"  ORDERDETAIL.SHIPPEDQTY  QUANTIDADE, " &
"  sls400. VALOR, " &
"  REDESPACHO.description  REDESPACHO, " &
"  CASE WHEN sls400.t$tpes$c = 'X' THEN 'Crossdocking' " &
" WHEN sls400.t$tpes$c = 'F' THEN 'Fingido' " &
" WHEN sls400.t$tpes$c = 'P' THEN 'Pré-Venda' " &
" ELSE 'NORMAL' " &
" END  TIPO_ESTOQ, " &
"  CASE WHEN TO_CHAR(LL.HOLDREASON) = ' ' " &
" THEN 'OK' " &
" ELSE nvl(TO_CHAR(LL.HOLDREASON), 'OK') " &
" END  RESTRICAO, " &
"  maucLN.mauc VALOR_CUSTO_CMV, " &
"  ORDERS.C_ADDRESS1 DESTINATARIO " &
"FROM WMWHSE1.ORDERS " &
"INNER JOIN WMWHSE1.ORDERDETAIL " &
"  ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY " &
"INNER JOIN WMWHSE1.SKU " &
"  ON SKU.SKU = ORDERDETAIL.SKU " &
" LEFT JOIN ENTERPRISE.CODELKUP cl " &
"  ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID) " &
" AND cl.listname = 'SCHEMA' " &
" LEFT JOIN ( select trim(whina113.t$item) item, " &
"  whina113.t$cwar cwar, " &
"  sum(whina113.t$mauc$1) mauc " &
" from BAANDB.Twhina113301@pln01 whina113 " &
"  where (whina113.t$trdt, whina113.t$seqn) = " &
"  ( select max(b.t$trdt), max(b.t$seqn) " &
"  from BAANDB.Twhina113301@pln01 b " &
" where b.t$item = whina113.t$item " &
" and b.t$cwar = whina113.t$cwar " &
" and b.t$trdt = ( select max(c.t$trdt) " &
"  from BAANDB.Twhina113301@pln01 c " &
" where c.t$item = b.t$item " &
" and c.t$cwar = b.t$cwar ) ) " &  
" group by whina113.t$item, whina113.t$cwar ) maucLN " &
"  ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6) " &
" AND maucLN.item = sku.sku " &
" LEFT JOIN WMWHSE1.WAVEDETAIL " &
"  ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE1.CAGEIDDETAIL " &
"  ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE1.CAGEID " &
"  ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID " &
"INNER JOIN WMSADMIN.PL_DB " &
"  ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002 " &
"  ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1)) " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 " &
"  ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU) " &
" LEFT JOIN ( SELECT a.ORDERKEY, " &
"  a.ORDERLINENUMBER , " &
"  max(a.STATUS) STATUS, " &
"  max(a.ADDDATE) ADDDATE, " &
"  max(a.ADDWHO) ADDWHO " &
" FROM WMWHSE1.ORDERSTATUSHISTORY a " &
"  WHERE a.ADDDATE = ( select max(b.adddate) " &
"  from WMWHSE1.ORDERSTATUSHISTORY b " &
" where b.ORDERKEY = a.ORDERKEY " &
" and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
" GROUP BY a.ORDERKEY, " &
"  a.ORDERLINENUMBER ) ORDERSTATUSHISTORY " &
"  ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS " &
" LEFT JOIN WMWHSE1.ORDERSTATUSSETUP " &
"  ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS " &
" LEFT JOIN WMWHSE1.ORDERSTATUSSETUP ORDERSTATUSSETUP2 " &
"  ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS " &
" LEFT JOIN WMWHSE1.TASKDETAIL " &
"  ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" LEFT JOIN WMWHSE1.LOTXLOC LL " &
"  ON LL.LOT = TASKDETAIL.LOT " &
" AND LL.LOC = TASKDETAIL.FROMLOC " &
" AND LL.SKU = TASKDETAIL.SKU " &
" LEFT JOIN ( select q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c, " &
"  sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) - " &
"  znsls401.t$vldi$c + " &
"  znsls401.t$vlfr$c + " &
"  znsls401.t$vlde$c ) VALOR " &
"from BAANDB.TZNSLS004301@pln01 ZNSLS004 " &
" inner join BAANDB.TZNSLS400301@pln01 q " &
"   on ZNSLS004.T$NCIA$C = q.T$NCIA$C " &
"  and ZNSLS004.T$UNEG$C = q.T$UNEG$C " &
"  and ZNSLS004.T$PECL$C = q.T$PECL$C " &
"  and ZNSLS004.T$SQPD$C = q.T$SQPD$C " &
" inner join BAANDB.TZNSLS401301@pln01 ZNSLS401 " &
"   on znsls401.T$NCIA$C = znsls004.T$NCIA$C " &
"  and znsls401.T$UNEG$C = znsls004.T$UNEG$C " &
"  and znsls401.T$PECL$C = znsls004.T$PECL$C " &
"  and znsls401.T$SQPD$C = znsls004.T$SQPD$C " &
"  and znsls401.t$entr$c = znsls004.t$entr$c " &
"  and znsls401.t$sequ$c = znsls004.t$sequ$c " &
" group by q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c ) SLS400 " &
"  ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT " &
" AND SLS400.t$item$c = ORDERDETAIL.SKU " &
" LEFT JOIN ( select clkp.description, " &
"  clkp.code " &
" from WMWHSE1.codelkup clkp " &
"  where clkp.listname = 'INCOTERMS' ) REDESPACHO " &
"  ON REDESPACHO.code = orders.INCOTERM " &
"WHERE NVL(SLS002.T$TPEN$C, 0) IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ") " &
"  AND Trunc(ORDERSTATUSHISTORY.ADDDATE) " &
"  Between '" + Parameters!DataUltEventoDe.Value + "' " &
"  And '" + Parameters!DataUltEventoAte.Value + "' " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ") " &
"  AND NVL(ORDERS.C_VAT, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"Union " &
"SELECT " &
"  DISTINCT " &
"  WMSADMIN.PL_DB.DB_ALIAS DSC_PLANTA, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_LIMITE, " &
"  ORDERS.ORDERKEY PEDIDO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_REGISTRO, " &
"  ORDERSTATUSSETUP2.DESCRIPTION EVENTO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_ULT_EVENTO, " &
"  ORDERSTATUSHISTORY.ADDWHO OPERADOR, " &
"  ORDERDETAIL.SKU ITEM, " &
"  SKU.DESCR NOME_ITEM, " &
"  SLS400.T$IDCA$C CANAL, " &
"  NVL(ORDERS.C_VAT, 'N/A') MEGA_ROTA, " &
"  ORDERSTATUSSETUP.DESCRIPTION  SITUACAO, " &
"  TASKDETAIL.TASKDETAILKEY  PROGRAMA, " &
"  WAVEDETAIL.WAVEKEY  ONDA, " &
"  ORDERS.CARRIERCODE  ID_TRANSPORTADORA, " &
"  ORDERS.CARRIERNAME  TRANSPORTADORA, " &
"  SLS002.T$TPEN$C TIPO_ENTREGA, " &
"  NVL(ORDERS.SUSR1, 'Não aplicável') NOME_TP_ENT, " &
"  ORDERS.INVOICENUMBER  NOTA, " &
"  ORDERS.LANE SERIE, " &
"  CAGEIDDETAIL.CAGEID CARGA, " &
"  CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' " &
" ELSE 'LEVE' " &
" END  TP_TRANSPORTE, " &
"  ORDERS.C_ZIP  CEP, " &
"  whwmd400.t$hght ALTURA, " &
"  whwmd400.t$wdth LARGURA, " &
"  whwmd400.t$dpth COMPRIMENTO, " &
"  SKU.STDNETWGT PESO_UNITARIO, " &
"  SKU.STDGROSSWGT PESO_BRUTO, " &
"  ORDERS.C_CITY MUNICIPIO, " &
"  ORDERS.C_STATE  ESTADO, " &
"  ORDERDETAIL.SHIPPEDQTY  QUANTIDADE, " &
"  sls400. VALOR, " &
"  REDESPACHO.description  REDESPACHO, " &
"  CASE WHEN sls400.t$tpes$c = 'X' THEN 'Crossdocking' " &
" WHEN sls400.t$tpes$c = 'F' THEN 'Fingido' " &
" WHEN sls400.t$tpes$c = 'P' THEN 'Pré-Venda' " &
" ELSE 'NORMAL' " &
" END  TIPO_ESTOQ, " &
"  CASE WHEN TO_CHAR(LL.HOLDREASON) = ' ' " &
" THEN 'OK' " &
" ELSE nvl(TO_CHAR(LL.HOLDREASON), 'OK') " &
" END  RESTRICAO, " &
"  maucLN.mauc VALOR_CUSTO_CMV, " &
"  ORDERS.C_ADDRESS1 DESTINATARIO " &
"FROM WMWHSE2.ORDERS " &
"INNER JOIN WMWHSE2.ORDERDETAIL " &
"  ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY " &
"INNER JOIN WMWHSE2.SKU " &
"  ON SKU.SKU = ORDERDETAIL.SKU " &
" LEFT JOIN ENTERPRISE.CODELKUP cl " &
"  ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID) " &
" AND cl.listname = 'SCHEMA' " &
" LEFT JOIN ( select trim(whina113.t$item) item, " &
"  whina113.t$cwar cwar, " &
"  sum(whina113.t$mauc$1) mauc " &
" from BAANDB.Twhina113301@pln01 whina113 " &
"  where (whina113.t$trdt, whina113.t$seqn) = " &
"  ( select max(b.t$trdt), max(b.t$seqn) " &
"  from BAANDB.Twhina113301@pln01 b " &
" where b.t$item = whina113.t$item " &
" and b.t$cwar = whina113.t$cwar " &
" and b.t$trdt = ( select max(c.t$trdt) " &
"  from BAANDB.Twhina113301@pln01 c " &
" where c.t$item = b.t$item " &
" and c.t$cwar = b.t$cwar ) ) " &  
" group by whina113.t$item, whina113.t$cwar ) maucLN " &
"  ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6) " &
" AND maucLN.item = sku.sku " &
" LEFT JOIN WMWHSE2.WAVEDETAIL " &
"  ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE2.CAGEIDDETAIL " &
"  ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE2.CAGEID " &
"  ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID " &
"INNER JOIN WMSADMIN.PL_DB " &
"  ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002 " &
"  ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1)) " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 " &
"  ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU) " &
" LEFT JOIN ( SELECT a.ORDERKEY, " &
"  a.ORDERLINENUMBER , " &
"  max(a.STATUS) STATUS, " &
"  max(a.ADDDATE) ADDDATE, " &
"  max(a.ADDWHO) ADDWHO " &
" FROM WMWHSE2.ORDERSTATUSHISTORY a " &
"  WHERE a.ADDDATE = ( select max(b.adddate) " &
"  from WMWHSE2.ORDERSTATUSHISTORY b " &
" where b.ORDERKEY = a.ORDERKEY " &
" and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
" GROUP BY a.ORDERKEY, " &
"  a.ORDERLINENUMBER ) ORDERSTATUSHISTORY " &
"  ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS " &
" LEFT JOIN WMWHSE2.ORDERSTATUSSETUP " &
"  ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS " &
" LEFT JOIN WMWHSE2.ORDERSTATUSSETUP ORDERSTATUSSETUP2 " &
"  ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS " &
" LEFT JOIN WMWHSE2.TASKDETAIL " &
"  ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" LEFT JOIN WMWHSE2.LOTXLOC LL " &
"  ON LL.LOT = TASKDETAIL.LOT " &
" AND LL.LOC = TASKDETAIL.FROMLOC " &
" AND LL.SKU = TASKDETAIL.SKU " &
" LEFT JOIN ( select q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c, " &
"  sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) - " &
"  znsls401.t$vldi$c + " &
"  znsls401.t$vlfr$c + " &
"  znsls401.t$vlde$c ) VALOR " &
"from BAANDB.TZNSLS004301@pln01 ZNSLS004 " &
" inner join BAANDB.TZNSLS400301@pln01 q " &
"   on ZNSLS004.T$NCIA$C = q.T$NCIA$C " &
"  and ZNSLS004.T$UNEG$C = q.T$UNEG$C " &
"  and ZNSLS004.T$PECL$C = q.T$PECL$C " &
"  and ZNSLS004.T$SQPD$C = q.T$SQPD$C " &
" inner join BAANDB.TZNSLS401301@pln01 ZNSLS401 " &
"   on znsls401.T$NCIA$C = znsls004.T$NCIA$C " &
"  and znsls401.T$UNEG$C = znsls004.T$UNEG$C " &
"  and znsls401.T$PECL$C = znsls004.T$PECL$C " &
"  and znsls401.T$SQPD$C = znsls004.T$SQPD$C " &
"  and znsls401.t$entr$c = znsls004.t$entr$c " &
"  and znsls401.t$sequ$c = znsls004.t$sequ$c " &
" group by q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c ) SLS400 " &
"  ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT " &
" AND SLS400.t$item$c = ORDERDETAIL.SKU " &
" LEFT JOIN ( select clkp.description, " &
"  clkp.code " &
" from WMWHSE2.codelkup clkp " &
"  where clkp.listname = 'INCOTERMS' ) REDESPACHO " &
"  ON REDESPACHO.code = orders.INCOTERM " &
"WHERE NVL(SLS002.T$TPEN$C, 0) IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ") " &
"  AND Trunc(ORDERSTATUSHISTORY.ADDDATE) " &
"  Between '" + Parameters!DataUltEventoDe.Value + "' " &
"  And '" + Parameters!DataUltEventoAte.Value + "' " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ") " &
"  AND NVL(ORDERS.C_VAT, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"Union " &
"SELECT " &
"  DISTINCT " &
"  WMSADMIN.PL_DB.DB_ALIAS DSC_PLANTA, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_LIMITE, " &
"  ORDERS.ORDERKEY PEDIDO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_REGISTRO, " &
"  ORDERSTATUSSETUP2.DESCRIPTION EVENTO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_ULT_EVENTO, " &
"  ORDERSTATUSHISTORY.ADDWHO OPERADOR, " &
"  ORDERDETAIL.SKU ITEM, " &
"  SKU.DESCR NOME_ITEM, " &
"  SLS400.T$IDCA$C CANAL, " &
"  NVL(ORDERS.C_VAT, 'N/A') MEGA_ROTA, " &
"  ORDERSTATUSSETUP.DESCRIPTION  SITUACAO, " &
"  TASKDETAIL.TASKDETAILKEY  PROGRAMA, " &
"  WAVEDETAIL.WAVEKEY  ONDA, " &
"  ORDERS.CARRIERCODE  ID_TRANSPORTADORA, " &
"  ORDERS.CARRIERNAME  TRANSPORTADORA, " &
"  SLS002.T$TPEN$C TIPO_ENTREGA, " &
"  NVL(ORDERS.SUSR1, 'Não aplicável') NOME_TP_ENT, " &
"  ORDERS.INVOICENUMBER  NOTA, " &
"  ORDERS.LANE SERIE, " &
"  CAGEIDDETAIL.CAGEID CARGA, " &
"  CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' " &
" ELSE 'LEVE' " &
" END  TP_TRANSPORTE, " &
"  ORDERS.C_ZIP  CEP, " &
"  whwmd400.t$hght ALTURA, " &
"  whwmd400.t$wdth LARGURA, " &
"  whwmd400.t$dpth COMPRIMENTO, " &
"  SKU.STDNETWGT PESO_UNITARIO, " &
"  SKU.STDGROSSWGT PESO_BRUTO, " &
"  ORDERS.C_CITY MUNICIPIO, " &
"  ORDERS.C_STATE  ESTADO, " &
"  ORDERDETAIL.SHIPPEDQTY  QUANTIDADE, " &
"  sls400. VALOR, " &
"  REDESPACHO.description  REDESPACHO, " &
"  CASE WHEN sls400.t$tpes$c = 'X' THEN 'Crossdocking' " &
" WHEN sls400.t$tpes$c = 'F' THEN 'Fingido' " &
" WHEN sls400.t$tpes$c = 'P' THEN 'Pré-Venda' " &
" ELSE 'NORMAL' " &
" END  TIPO_ESTOQ, " &
"  CASE WHEN TO_CHAR(LL.HOLDREASON) = ' ' " &
" THEN 'OK' " &
" ELSE nvl(TO_CHAR(LL.HOLDREASON), 'OK') " &
" END  RESTRICAO, " &
"  maucLN.mauc VALOR_CUSTO_CMV, " &
"  ORDERS.C_ADDRESS1 DESTINATARIO " &
"FROM WMWHSE3.ORDERS " &
"INNER JOIN WMWHSE3.ORDERDETAIL " &
"  ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY " &
"INNER JOIN WMWHSE3.SKU " &
"  ON SKU.SKU = ORDERDETAIL.SKU " &
" LEFT JOIN ENTERPRISE.CODELKUP cl " &
"  ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID) " &
" AND cl.listname = 'SCHEMA' " &
" LEFT JOIN ( select trim(whina113.t$item) item, " &
"  whina113.t$cwar cwar, " &
"  sum(whina113.t$mauc$1) mauc " &
" from BAANDB.Twhina113301@pln01 whina113 " &
"  where (whina113.t$trdt, whina113.t$seqn) = " &
"  ( select max(b.t$trdt), max(b.t$seqn) " &
"  from BAANDB.Twhina113301@pln01 b " &
" where b.t$item = whina113.t$item " &
" and b.t$cwar = whina113.t$cwar " &
" and b.t$trdt = ( select max(c.t$trdt) " &
"  from BAANDB.Twhina113301@pln01 c " &
" where c.t$item = b.t$item " &
" and c.t$cwar = b.t$cwar ) ) " &  
" group by whina113.t$item, whina113.t$cwar ) maucLN " &
"  ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6) " &
" AND maucLN.item = sku.sku " &
" LEFT JOIN WMWHSE3.WAVEDETAIL " &
"  ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE3.CAGEIDDETAIL " &
"  ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE3.CAGEID " &
"  ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID " &
"INNER JOIN WMSADMIN.PL_DB " &
"  ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002 " &
"  ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1)) " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 " &
"  ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU) " &
" LEFT JOIN ( SELECT a.ORDERKEY, " &
"  a.ORDERLINENUMBER , " &
"  max(a.STATUS) STATUS, " &
"  max(a.ADDDATE) ADDDATE, " &
"  max(a.ADDWHO) ADDWHO " &
" FROM WMWHSE3.ORDERSTATUSHISTORY a " &
"  WHERE a.ADDDATE = ( select max(b.adddate) " &
"  from WMWHSE3.ORDERSTATUSHISTORY b " &
" where b.ORDERKEY = a.ORDERKEY " &
" and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
" GROUP BY a.ORDERKEY, " &
"  a.ORDERLINENUMBER ) ORDERSTATUSHISTORY " &
"  ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS " &
" LEFT JOIN WMWHSE3.ORDERSTATUSSETUP " &
"  ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS " &
" LEFT JOIN WMWHSE3.ORDERSTATUSSETUP ORDERSTATUSSETUP2 " &
"  ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS " &
" LEFT JOIN WMWHSE3.TASKDETAIL " &
"  ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" LEFT JOIN WMWHSE3.LOTXLOC LL " &
"  ON LL.LOT = TASKDETAIL.LOT " &
" AND LL.LOC = TASKDETAIL.FROMLOC " &
" AND LL.SKU = TASKDETAIL.SKU " &
" LEFT JOIN ( select q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c, " &
"  sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) - " &
"  znsls401.t$vldi$c + " &
"  znsls401.t$vlfr$c + " &
"  znsls401.t$vlde$c ) VALOR " &
"from BAANDB.TZNSLS004301@pln01 ZNSLS004 " &
" inner join BAANDB.TZNSLS400301@pln01 q " &
"   on ZNSLS004.T$NCIA$C = q.T$NCIA$C " &
"  and ZNSLS004.T$UNEG$C = q.T$UNEG$C " &
"  and ZNSLS004.T$PECL$C = q.T$PECL$C " &
"  and ZNSLS004.T$SQPD$C = q.T$SQPD$C " &
" inner join BAANDB.TZNSLS401301@pln01 ZNSLS401 " &
"   on znsls401.T$NCIA$C = znsls004.T$NCIA$C " &
"  and znsls401.T$UNEG$C = znsls004.T$UNEG$C " &
"  and znsls401.T$PECL$C = znsls004.T$PECL$C " &
"  and znsls401.T$SQPD$C = znsls004.T$SQPD$C " &
"  and znsls401.t$entr$c = znsls004.t$entr$c " &
"  and znsls401.t$sequ$c = znsls004.t$sequ$c " &
" group by q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c ) SLS400 " &
"  ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT " &
" AND SLS400.t$item$c = ORDERDETAIL.SKU " &
" LEFT JOIN ( select clkp.description, " &
"  clkp.code " &
" from WMWHSE3.codelkup clkp " &
"  where clkp.listname = 'INCOTERMS' ) REDESPACHO " &
"  ON REDESPACHO.code = orders.INCOTERM " &
"WHERE NVL(SLS002.T$TPEN$C, 0) IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ") " &
"  AND Trunc(ORDERSTATUSHISTORY.ADDDATE) " &
"  Between '" + Parameters!DataUltEventoDe.Value + "' " &
"  And '" + Parameters!DataUltEventoAte.Value + "' " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ") " &
"  AND NVL(ORDERS.C_VAT, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"Union " &
"SELECT " &
"  DISTINCT " &
"  WMSADMIN.PL_DB.DB_ALIAS DSC_PLANTA, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_LIMITE, " &
"  ORDERS.ORDERKEY PEDIDO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_REGISTRO, " &
"  ORDERSTATUSSETUP2.DESCRIPTION EVENTO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_ULT_EVENTO, " &
"  ORDERSTATUSHISTORY.ADDWHO OPERADOR, " &
"  ORDERDETAIL.SKU ITEM, " &
"  SKU.DESCR NOME_ITEM, " &
"  SLS400.T$IDCA$C CANAL, " &
"  NVL(ORDERS.C_VAT, 'N/A') MEGA_ROTA, " &
"  ORDERSTATUSSETUP.DESCRIPTION  SITUACAO, " &
"  TASKDETAIL.TASKDETAILKEY  PROGRAMA, " &
"  WAVEDETAIL.WAVEKEY  ONDA, " &
"  ORDERS.CARRIERCODE  ID_TRANSPORTADORA, " &
"  ORDERS.CARRIERNAME  TRANSPORTADORA, " &
"  SLS002.T$TPEN$C TIPO_ENTREGA, " &
"  NVL(ORDERS.SUSR1, 'Não aplicável') NOME_TP_ENT, " &
"  ORDERS.INVOICENUMBER  NOTA, " &
"  ORDERS.LANE SERIE, " &
"  CAGEIDDETAIL.CAGEID CARGA, " &
"  CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' " &
" ELSE 'LEVE' " &
" END  TP_TRANSPORTE, " &
"  ORDERS.C_ZIP  CEP, " &
"  whwmd400.t$hght ALTURA, " &
"  whwmd400.t$wdth LARGURA, " &
"  whwmd400.t$dpth COMPRIMENTO, " &
"  SKU.STDNETWGT PESO_UNITARIO, " &
"  SKU.STDGROSSWGT PESO_BRUTO, " &
"  ORDERS.C_CITY MUNICIPIO, " &
"  ORDERS.C_STATE  ESTADO, " &
"  ORDERDETAIL.SHIPPEDQTY  QUANTIDADE, " &
"  sls400. VALOR, " &
"  REDESPACHO.description  REDESPACHO, " &
"  CASE WHEN sls400.t$tpes$c = 'X' THEN 'Crossdocking' " &
" WHEN sls400.t$tpes$c = 'F' THEN 'Fingido' " &
" WHEN sls400.t$tpes$c = 'P' THEN 'Pré-Venda' " &
" ELSE 'NORMAL' " &
" END  TIPO_ESTOQ, " &
"  CASE WHEN TO_CHAR(LL.HOLDREASON) = ' ' " &
" THEN 'OK' " &
" ELSE nvl(TO_CHAR(LL.HOLDREASON), 'OK') " &
" END  RESTRICAO, " &
"  maucLN.mauc VALOR_CUSTO_CMV, " &
"  ORDERS.C_ADDRESS1 DESTINATARIO " &
"FROM WMWHSE4.ORDERS " &
"INNER JOIN WMWHSE4.ORDERDETAIL " &
"  ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY " &
"INNER JOIN WMWHSE4.SKU " &
"  ON SKU.SKU = ORDERDETAIL.SKU " &
" LEFT JOIN ENTERPRISE.CODELKUP cl " &
"  ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID) " &
" AND cl.listname = 'SCHEMA' " &
" LEFT JOIN ( select trim(whina113.t$item) item, " &
"  whina113.t$cwar cwar, " &
"  sum(whina113.t$mauc$1) mauc " &
" from BAANDB.Twhina113301@pln01 whina113 " &
"  where (whina113.t$trdt, whina113.t$seqn) = " &
"  ( select max(b.t$trdt), max(b.t$seqn) " &
"  from BAANDB.Twhina113301@pln01 b " &
" where b.t$item = whina113.t$item " &
" and b.t$cwar = whina113.t$cwar " &
" and b.t$trdt = ( select max(c.t$trdt) " &
"  from BAANDB.Twhina113301@pln01 c " &
" where c.t$item = b.t$item " &
" and c.t$cwar = b.t$cwar ) ) " &  
" group by whina113.t$item, whina113.t$cwar ) maucLN " &
"  ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6) " &
" AND maucLN.item = sku.sku " &
" LEFT JOIN WMWHSE4.WAVEDETAIL " &
"  ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE4.CAGEIDDETAIL " &
"  ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE4.CAGEID " &
"  ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID " &
"INNER JOIN WMSADMIN.PL_DB " &
"  ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002 " &
"  ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1)) " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 " &
"  ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU) " &
" LEFT JOIN ( SELECT a.ORDERKEY, " &
"  a.ORDERLINENUMBER , " &
"  max(a.STATUS) STATUS, " &
"  max(a.ADDDATE) ADDDATE, " &
"  max(a.ADDWHO) ADDWHO " &
" FROM WMWHSE4.ORDERSTATUSHISTORY a " &
"  WHERE a.ADDDATE = ( select max(b.adddate) " &
"  from WMWHSE4.ORDERSTATUSHISTORY b " &
" where b.ORDERKEY = a.ORDERKEY " &
" and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
" GROUP BY a.ORDERKEY, " &
"  a.ORDERLINENUMBER ) ORDERSTATUSHISTORY " &
"  ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS " &
" LEFT JOIN WMWHSE4.ORDERSTATUSSETUP " &
"  ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS " &
" LEFT JOIN WMWHSE4.ORDERSTATUSSETUP ORDERSTATUSSETUP2 " &
"  ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS " &
" LEFT JOIN WMWHSE4.TASKDETAIL " &
"  ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" LEFT JOIN WMWHSE4.LOTXLOC LL " &
"  ON LL.LOT = TASKDETAIL.LOT " &
" AND LL.LOC = TASKDETAIL.FROMLOC " &
" AND LL.SKU = TASKDETAIL.SKU " &
" LEFT JOIN ( select q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c, " &
"  sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) - " &
"  znsls401.t$vldi$c + " &
"  znsls401.t$vlfr$c + " &
"  znsls401.t$vlde$c ) VALOR " &
"from BAANDB.TZNSLS004301@pln01 ZNSLS004 " &
" inner join BAANDB.TZNSLS400301@pln01 q " &
"   on ZNSLS004.T$NCIA$C = q.T$NCIA$C " &
"  and ZNSLS004.T$UNEG$C = q.T$UNEG$C " &
"  and ZNSLS004.T$PECL$C = q.T$PECL$C " &
"  and ZNSLS004.T$SQPD$C = q.T$SQPD$C " &
" inner join BAANDB.TZNSLS401301@pln01 ZNSLS401 " &
"   on znsls401.T$NCIA$C = znsls004.T$NCIA$C " &
"  and znsls401.T$UNEG$C = znsls004.T$UNEG$C " &
"  and znsls401.T$PECL$C = znsls004.T$PECL$C " &
"  and znsls401.T$SQPD$C = znsls004.T$SQPD$C " &
"  and znsls401.t$entr$c = znsls004.t$entr$c " &
"  and znsls401.t$sequ$c = znsls004.t$sequ$c " &
" group by q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c ) SLS400 " &
"  ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT " &
" AND SLS400.t$item$c = ORDERDETAIL.SKU " &
" LEFT JOIN ( select clkp.description, " &
"  clkp.code " &
" from WMWHSE4.codelkup clkp " &
"  where clkp.listname = 'INCOTERMS' ) REDESPACHO " &
"  ON REDESPACHO.code = orders.INCOTERM " &
"WHERE NVL(SLS002.T$TPEN$C, 0) IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ") " &
"  AND Trunc(ORDERSTATUSHISTORY.ADDDATE) " &
"  Between '" + Parameters!DataUltEventoDe.Value + "' " &
"  And '" + Parameters!DataUltEventoAte.Value + "' " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ") " &
"  AND NVL(ORDERS.C_VAT, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"Union " &
"SELECT " &
"  DISTINCT " &
"  WMSADMIN.PL_DB.DB_ALIAS DSC_PLANTA, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_LIMITE, " &
"  ORDERS.ORDERKEY PEDIDO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_REGISTRO, " &
"  ORDERSTATUSSETUP2.DESCRIPTION EVENTO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_ULT_EVENTO, " &
"  ORDERSTATUSHISTORY.ADDWHO OPERADOR, " &
"  ORDERDETAIL.SKU ITEM, " &
"  SKU.DESCR NOME_ITEM, " &
"  SLS400.T$IDCA$C CANAL, " &
"  NVL(ORDERS.C_VAT, 'N/A') MEGA_ROTA, " &
"  ORDERSTATUSSETUP.DESCRIPTION  SITUACAO, " &
"  TASKDETAIL.TASKDETAILKEY  PROGRAMA, " &
"  WAVEDETAIL.WAVEKEY  ONDA, " &
"  ORDERS.CARRIERCODE  ID_TRANSPORTADORA, " &
"  ORDERS.CARRIERNAME  TRANSPORTADORA, " &
"  SLS002.T$TPEN$C TIPO_ENTREGA, " &
"  NVL(ORDERS.SUSR1, 'Não aplicável') NOME_TP_ENT, " &
"  ORDERS.INVOICENUMBER  NOTA, " &
"  ORDERS.LANE SERIE, " &
"  CAGEIDDETAIL.CAGEID CARGA, " &
"  CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' " &
" ELSE 'LEVE' " &
" END  TP_TRANSPORTE, " &
"  ORDERS.C_ZIP  CEP, " &
"  whwmd400.t$hght ALTURA, " &
"  whwmd400.t$wdth LARGURA, " &
"  whwmd400.t$dpth COMPRIMENTO, " &
"  SKU.STDNETWGT PESO_UNITARIO, " &
"  SKU.STDGROSSWGT PESO_BRUTO, " &
"  ORDERS.C_CITY MUNICIPIO, " &
"  ORDERS.C_STATE  ESTADO, " &
"  ORDERDETAIL.SHIPPEDQTY  QUANTIDADE, " &
"  sls400. VALOR, " &
"  REDESPACHO.description  REDESPACHO, " &
"  CASE WHEN sls400.t$tpes$c = 'X' THEN 'Crossdocking' " &
" WHEN sls400.t$tpes$c = 'F' THEN 'Fingido' " &
" WHEN sls400.t$tpes$c = 'P' THEN 'Pré-Venda' " &
" ELSE 'NORMAL' " &
" END  TIPO_ESTOQ, " &
"  CASE WHEN TO_CHAR(LL.HOLDREASON) = ' ' " &
" THEN 'OK' " &
" ELSE nvl(TO_CHAR(LL.HOLDREASON), 'OK') " &
" END  RESTRICAO, " &
"  maucLN.mauc VALOR_CUSTO_CMV, " &
"  ORDERS.C_ADDRESS1 DESTINATARIO " &
"FROM WMWHSE5.ORDERS " &
"INNER JOIN WMWHSE5.ORDERDETAIL " &
"  ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY " &
"INNER JOIN WMWHSE5.SKU " &
"  ON SKU.SKU = ORDERDETAIL.SKU " &
" LEFT JOIN ENTERPRISE.CODELKUP cl " &
"  ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID) " &
" AND cl.listname = 'SCHEMA' " &
" LEFT JOIN ( select trim(whina113.t$item) item, " &
"  whina113.t$cwar cwar, " &
"  sum(whina113.t$mauc$1) mauc " &
" from BAANDB.Twhina113301@pln01 whina113 " &
"  where (whina113.t$trdt, whina113.t$seqn) = " &
"  ( select max(b.t$trdt), max(b.t$seqn) " &
"  from BAANDB.Twhina113301@pln01 b " &
" where b.t$item = whina113.t$item " &
" and b.t$cwar = whina113.t$cwar " &
" and b.t$trdt = ( select max(c.t$trdt) " &
"  from BAANDB.Twhina113301@pln01 c " &
" where c.t$item = b.t$item " &
" and c.t$cwar = b.t$cwar ) ) " &  
" group by whina113.t$item, whina113.t$cwar ) maucLN " &
"  ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6) " &
" AND maucLN.item = sku.sku " &
" LEFT JOIN WMWHSE5.WAVEDETAIL " &
"  ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE5.CAGEIDDETAIL " &
"  ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE5.CAGEID " &
"  ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID " &
"INNER JOIN WMSADMIN.PL_DB " &
"  ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002 " &
"  ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1)) " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 " &
"  ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU) " &
" LEFT JOIN ( SELECT a.ORDERKEY, " &
"  a.ORDERLINENUMBER , " &
"  max(a.STATUS) STATUS, " &
"  max(a.ADDDATE) ADDDATE, " &
"  max(a.ADDWHO) ADDWHO " &
" FROM WMWHSE5.ORDERSTATUSHISTORY a " &
"  WHERE a.ADDDATE = ( select max(b.adddate) " &
"  from WMWHSE5.ORDERSTATUSHISTORY b " &
" where b.ORDERKEY = a.ORDERKEY " &
" and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
" GROUP BY a.ORDERKEY, " &
"  a.ORDERLINENUMBER ) ORDERSTATUSHISTORY " &
"  ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS " &
" LEFT JOIN WMWHSE5.ORDERSTATUSSETUP " &
"  ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS " &
" LEFT JOIN WMWHSE5.ORDERSTATUSSETUP ORDERSTATUSSETUP2 " &
"  ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS " &
" LEFT JOIN WMWHSE5.TASKDETAIL " &
"  ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" LEFT JOIN WMWHSE5.LOTXLOC LL " &
"  ON LL.LOT = TASKDETAIL.LOT " &
" AND LL.LOC = TASKDETAIL.FROMLOC " &
" AND LL.SKU = TASKDETAIL.SKU " &
" LEFT JOIN ( select q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c, " &
"  sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) - " &
"  znsls401.t$vldi$c + " &
"  znsls401.t$vlfr$c + " &
"  znsls401.t$vlde$c ) VALOR " &
"from BAANDB.TZNSLS004301@pln01 ZNSLS004 " &
" inner join BAANDB.TZNSLS400301@pln01 q " &
"   on ZNSLS004.T$NCIA$C = q.T$NCIA$C " &
"  and ZNSLS004.T$UNEG$C = q.T$UNEG$C " &
"  and ZNSLS004.T$PECL$C = q.T$PECL$C " &
"  and ZNSLS004.T$SQPD$C = q.T$SQPD$C " &
" inner join BAANDB.TZNSLS401301@pln01 ZNSLS401 " &
"   on znsls401.T$NCIA$C = znsls004.T$NCIA$C " &
"  and znsls401.T$UNEG$C = znsls004.T$UNEG$C " &
"  and znsls401.T$PECL$C = znsls004.T$PECL$C " &
"  and znsls401.T$SQPD$C = znsls004.T$SQPD$C " &
"  and znsls401.t$entr$c = znsls004.t$entr$c " &
"  and znsls401.t$sequ$c = znsls004.t$sequ$c " &
" group by q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c ) SLS400 " &
"  ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT " &
" AND SLS400.t$item$c = ORDERDETAIL.SKU " &
" LEFT JOIN ( select clkp.description, " &
"  clkp.code " &
" from WMWHSE5.codelkup clkp " &
"  where clkp.listname = 'INCOTERMS' ) REDESPACHO " &
"  ON REDESPACHO.code = orders.INCOTERM " &
"WHERE NVL(SLS002.T$TPEN$C, 0) IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ") " &
"  AND Trunc(ORDERSTATUSHISTORY.ADDDATE) " &
"  Between '" + Parameters!DataUltEventoDe.Value + "' " &
"  And '" + Parameters!DataUltEventoAte.Value + "' " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ") " &
"  AND NVL(ORDERS.C_VAT, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"Union " &
"SELECT " &
"  DISTINCT " &
"  WMSADMIN.PL_DB.DB_ALIAS DSC_PLANTA, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_LIMITE, " &
"  ORDERS.ORDERKEY PEDIDO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_REGISTRO, " &
"  ORDERSTATUSSETUP2.DESCRIPTION EVENTO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_ULT_EVENTO, " &
"  ORDERSTATUSHISTORY.ADDWHO OPERADOR, " &
"  ORDERDETAIL.SKU ITEM, " &
"  SKU.DESCR NOME_ITEM, " &
"  SLS400.T$IDCA$C CANAL, " &
"  NVL(ORDERS.C_VAT, 'N/A') MEGA_ROTA, " &
"  ORDERSTATUSSETUP.DESCRIPTION  SITUACAO, " &
"  TASKDETAIL.TASKDETAILKEY  PROGRAMA, " &
"  WAVEDETAIL.WAVEKEY  ONDA, " &
"  ORDERS.CARRIERCODE  ID_TRANSPORTADORA, " &
"  ORDERS.CARRIERNAME  TRANSPORTADORA, " &
"  SLS002.T$TPEN$C TIPO_ENTREGA, " &
"  NVL(ORDERS.SUSR1, 'Não aplicável') NOME_TP_ENT, " &
"  ORDERS.INVOICENUMBER  NOTA, " &
"  ORDERS.LANE SERIE, " &
"  CAGEIDDETAIL.CAGEID CARGA, " &
"  CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' " &
" ELSE 'LEVE' " &
" END  TP_TRANSPORTE, " &
"  ORDERS.C_ZIP  CEP, " &
"  whwmd400.t$hght ALTURA, " &
"  whwmd400.t$wdth LARGURA, " &
"  whwmd400.t$dpth COMPRIMENTO, " &
"  SKU.STDNETWGT PESO_UNITARIO, " &
"  SKU.STDGROSSWGT PESO_BRUTO, " &
"  ORDERS.C_CITY MUNICIPIO, " &
"  ORDERS.C_STATE  ESTADO, " &
"  ORDERDETAIL.SHIPPEDQTY  QUANTIDADE, " &
"  sls400. VALOR, " &
"  REDESPACHO.description  REDESPACHO, " &
"  CASE WHEN sls400.t$tpes$c = 'X' THEN 'Crossdocking' " &
" WHEN sls400.t$tpes$c = 'F' THEN 'Fingido' " &
" WHEN sls400.t$tpes$c = 'P' THEN 'Pré-Venda' " &
" ELSE 'NORMAL' " &
" END  TIPO_ESTOQ, " &
"  CASE WHEN TO_CHAR(LL.HOLDREASON) = ' ' " &
" THEN 'OK' " &
" ELSE nvl(TO_CHAR(LL.HOLDREASON), 'OK') " &
" END  RESTRICAO, " &
"  maucLN.mauc VALOR_CUSTO_CMV, " &
"  ORDERS.C_ADDRESS1 DESTINATARIO " &
"FROM WMWHSE6.ORDERS " &
"INNER JOIN WMWHSE6.ORDERDETAIL " &
"  ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY " &
"INNER JOIN WMWHSE6.SKU " &
"  ON SKU.SKU = ORDERDETAIL.SKU " &
" LEFT JOIN ENTERPRISE.CODELKUP cl " &
"  ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID) " &
" AND cl.listname = 'SCHEMA' " &
" LEFT JOIN ( select trim(whina113.t$item) item, " &
"  whina113.t$cwar cwar, " &
"  sum(whina113.t$mauc$1) mauc " &
" from BAANDB.Twhina113301@pln01 whina113 " &
"  where (whina113.t$trdt, whina113.t$seqn) = " &
"  ( select max(b.t$trdt), max(b.t$seqn) " &
"  from BAANDB.Twhina113301@pln01 b " &
" where b.t$item = whina113.t$item " &
" and b.t$cwar = whina113.t$cwar " &
" and b.t$trdt = ( select max(c.t$trdt) " &
"  from BAANDB.Twhina113301@pln01 c " &
" where c.t$item = b.t$item " &
" and c.t$cwar = b.t$cwar ) ) " &  
" group by whina113.t$item, whina113.t$cwar ) maucLN " &
"  ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6) " &
" AND maucLN.item = sku.sku " &
" LEFT JOIN WMWHSE6.WAVEDETAIL " &
"  ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE6.CAGEIDDETAIL " &
"  ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE6.CAGEID " &
"  ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID " &
"INNER JOIN WMSADMIN.PL_DB " &
"  ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002 " &
"  ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1)) " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 " &
"  ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU) " &
" LEFT JOIN ( SELECT a.ORDERKEY, " &
"  a.ORDERLINENUMBER , " &
"  max(a.STATUS) STATUS, " &
"  max(a.ADDDATE) ADDDATE, " &
"  max(a.ADDWHO) ADDWHO " &
" FROM WMWHSE6.ORDERSTATUSHISTORY a " &
"  WHERE a.ADDDATE = ( select max(b.adddate) " &
"  from WMWHSE6.ORDERSTATUSHISTORY b " &
" where b.ORDERKEY = a.ORDERKEY " &
" and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
" GROUP BY a.ORDERKEY, " &
"  a.ORDERLINENUMBER ) ORDERSTATUSHISTORY " &
"  ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS " &
" LEFT JOIN WMWHSE6.ORDERSTATUSSETUP " &
"  ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS " &
" LEFT JOIN WMWHSE6.ORDERSTATUSSETUP ORDERSTATUSSETUP2 " &
"  ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS " &
" LEFT JOIN WMWHSE6.TASKDETAIL " &
"  ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" LEFT JOIN WMWHSE6.LOTXLOC LL " &
"  ON LL.LOT = TASKDETAIL.LOT " &
" AND LL.LOC = TASKDETAIL.FROMLOC " &
" AND LL.SKU = TASKDETAIL.SKU " &
" LEFT JOIN ( select q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c, " &
"  sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) - " &
"  znsls401.t$vldi$c + " &
"  znsls401.t$vlfr$c + " &
"  znsls401.t$vlde$c ) VALOR " &
"from BAANDB.TZNSLS004301@pln01 ZNSLS004 " &
" inner join BAANDB.TZNSLS400301@pln01 q " &
"   on ZNSLS004.T$NCIA$C = q.T$NCIA$C " &
"  and ZNSLS004.T$UNEG$C = q.T$UNEG$C " &
"  and ZNSLS004.T$PECL$C = q.T$PECL$C " &
"  and ZNSLS004.T$SQPD$C = q.T$SQPD$C " &
" inner join BAANDB.TZNSLS401301@pln01 ZNSLS401 " &
"   on znsls401.T$NCIA$C = znsls004.T$NCIA$C " &
"  and znsls401.T$UNEG$C = znsls004.T$UNEG$C " &
"  and znsls401.T$PECL$C = znsls004.T$PECL$C " &
"  and znsls401.T$SQPD$C = znsls004.T$SQPD$C " &
"  and znsls401.t$entr$c = znsls004.t$entr$c " &
"  and znsls401.t$sequ$c = znsls004.t$sequ$c " &
" group by q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c ) SLS400 " &
"  ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT " &
" AND SLS400.t$item$c = ORDERDETAIL.SKU " &
" LEFT JOIN ( select clkp.description, " &
"  clkp.code " &
" from WMWHSE6.codelkup clkp " &
"  where clkp.listname = 'INCOTERMS' ) REDESPACHO " &
"  ON REDESPACHO.code = orders.INCOTERM " &
"WHERE NVL(SLS002.T$TPEN$C, 0) IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ") " &
"  AND Trunc(ORDERSTATUSHISTORY.ADDDATE) " &
"  Between '" + Parameters!DataUltEventoDe.Value + "' " &
"  And '" + Parameters!DataUltEventoAte.Value + "' " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ") " &
"  AND NVL(ORDERS.C_VAT, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"Union " &
"SELECT " &
"  DISTINCT " &
"  WMSADMIN.PL_DB.DB_ALIAS DSC_PLANTA, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_LIMITE, " &
"  ORDERS.ORDERKEY PEDIDO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_REGISTRO, " &
"  ORDERSTATUSSETUP2.DESCRIPTION EVENTO, " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"  AT time zone sessiontimezone) AS DATE) " &
"  DATA_ULT_EVENTO, " &
"  ORDERSTATUSHISTORY.ADDWHO OPERADOR, " &
"  ORDERDETAIL.SKU ITEM, " &
"  SKU.DESCR NOME_ITEM, " &
"  SLS400.T$IDCA$C CANAL, " &
"  NVL(ORDERS.C_VAT, 'N/A') MEGA_ROTA, " &
"  ORDERSTATUSSETUP.DESCRIPTION  SITUACAO, " &
"  TASKDETAIL.TASKDETAILKEY  PROGRAMA, " &
"  WAVEDETAIL.WAVEKEY  ONDA, " &
"  ORDERS.CARRIERCODE  ID_TRANSPORTADORA, " &
"  ORDERS.CARRIERNAME  TRANSPORTADORA, " &
"  SLS002.T$TPEN$C TIPO_ENTREGA, " &
"  NVL(ORDERS.SUSR1, 'Não aplicável') NOME_TP_ENT, " &
"  ORDERS.INVOICENUMBER  NOTA, " &
"  ORDERS.LANE SERIE, " &
"  CAGEIDDETAIL.CAGEID CARGA, " &
"  CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' " &
" ELSE 'LEVE' " &
" END  TP_TRANSPORTE, " &
"  ORDERS.C_ZIP  CEP, " &
"  whwmd400.t$hght ALTURA, " &
"  whwmd400.t$wdth LARGURA, " &
"  whwmd400.t$dpth COMPRIMENTO, " &
"  SKU.STDNETWGT PESO_UNITARIO, " &
"  SKU.STDGROSSWGT PESO_BRUTO, " &
"  ORDERS.C_CITY MUNICIPIO, " &
"  ORDERS.C_STATE  ESTADO, " &
"  ORDERDETAIL.SHIPPEDQTY  QUANTIDADE, " &
"  sls400. VALOR, " &
"  REDESPACHO.description  REDESPACHO, " &
"  CASE WHEN sls400.t$tpes$c = 'X' THEN 'Crossdocking' " &
" WHEN sls400.t$tpes$c = 'F' THEN 'Fingido' " &
" WHEN sls400.t$tpes$c = 'P' THEN 'Pré-Venda' " &
" ELSE 'NORMAL' " &
" END  TIPO_ESTOQ, " &
"  CASE WHEN TO_CHAR(LL.HOLDREASON) = ' ' " &
" THEN 'OK' " &
" ELSE nvl(TO_CHAR(LL.HOLDREASON), 'OK') " &
" END  RESTRICAO, " &
"  maucLN.mauc VALOR_CUSTO_CMV, " &
"  ORDERS.C_ADDRESS1 DESTINATARIO " &
"FROM WMWHSE7.ORDERS " &
"INNER JOIN WMWHSE7.ORDERDETAIL " &
"  ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY " &
"INNER JOIN WMWHSE7.SKU " &
"  ON SKU.SKU = ORDERDETAIL.SKU " &
" LEFT JOIN ENTERPRISE.CODELKUP cl " &
"  ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID) " &
" AND cl.listname = 'SCHEMA' " &
" LEFT JOIN ( select trim(whina113.t$item) item, " &
"  whina113.t$cwar cwar, " &
"  sum(whina113.t$mauc$1) mauc " &
" from BAANDB.Twhina113301@pln01 whina113 " &
"  where (whina113.t$trdt, whina113.t$seqn) = " &
"  ( select max(b.t$trdt), max(b.t$seqn) " &
"  from BAANDB.Twhina113301@pln01 b " &
" where b.t$item = whina113.t$item " &
" and b.t$cwar = whina113.t$cwar " &
" and b.t$trdt = ( select max(c.t$trdt) " &
"  from BAANDB.Twhina113301@pln01 c " &
" where c.t$item = b.t$item " &
" and c.t$cwar = b.t$cwar ) ) " &  
" group by whina113.t$item, whina113.t$cwar ) maucLN " &
"  ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6) " &
" AND maucLN.item = sku.sku " &
" LEFT JOIN WMWHSE7.WAVEDETAIL " &
"  ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE7.CAGEIDDETAIL " &
"  ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY " &
" LEFT JOIN WMWHSE7.CAGEID " &
"  ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID " &
"INNER JOIN WMSADMIN.PL_DB " &
"  ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002 " &
"  ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1)) " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400 " &
"  ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU) " &
" LEFT JOIN ( SELECT a.ORDERKEY, " &
"  a.ORDERLINENUMBER , " &
"  max(a.STATUS) STATUS, " &
"  max(a.ADDDATE) ADDDATE, " &
"  max(a.ADDWHO) ADDWHO " &
" FROM WMWHSE7.ORDERSTATUSHISTORY a " &
"  WHERE a.ADDDATE = ( select max(b.adddate) " &
"  from WMWHSE7.ORDERSTATUSHISTORY b " &
" where b.ORDERKEY = a.ORDERKEY " &
" and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
" GROUP BY a.ORDERKEY, " &
"  a.ORDERLINENUMBER ) ORDERSTATUSHISTORY " &
"  ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS " &
" LEFT JOIN WMWHSE7.ORDERSTATUSSETUP " &
"  ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS " &
" LEFT JOIN WMWHSE7.ORDERSTATUSSETUP ORDERSTATUSSETUP2 " &
"  ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS " &
" LEFT JOIN WMWHSE7.TASKDETAIL " &
"  ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY " &
" AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" LEFT JOIN WMWHSE7.LOTXLOC LL " &
"  ON LL.LOT = TASKDETAIL.LOT " &
" AND LL.LOC = TASKDETAIL.FROMLOC " &
" AND LL.SKU = TASKDETAIL.SKU " &
" LEFT JOIN ( select q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c, " &
"  sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) - " &
"  znsls401.t$vldi$c + " &
"  znsls401.t$vlfr$c + " &
"  znsls401.t$vlde$c ) VALOR " &
"from BAANDB.TZNSLS004301@pln01 ZNSLS004 " &
" inner join BAANDB.TZNSLS400301@pln01 q " &
"   on ZNSLS004.T$NCIA$C = q.T$NCIA$C " &
"  and ZNSLS004.T$UNEG$C = q.T$UNEG$C " &
"  and ZNSLS004.T$PECL$C = q.T$PECL$C " &
"  and ZNSLS004.T$SQPD$C = q.T$SQPD$C " &
" inner join BAANDB.TZNSLS401301@pln01 ZNSLS401 " &
"   on znsls401.T$NCIA$C = znsls004.T$NCIA$C " &
"  and znsls401.T$UNEG$C = znsls004.T$UNEG$C " &
"  and znsls401.T$PECL$C = znsls004.T$PECL$C " &
"  and znsls401.T$SQPD$C = znsls004.T$SQPD$C " &
"  and znsls401.t$entr$c = znsls004.t$entr$c " &
"  and znsls401.t$sequ$c = znsls004.t$sequ$c " &
" group by q.T$IDCA$C, " &
"  ZNSLS004.T$ORNO$C, " &
"  znsls401.t$item$c, " &
"  znsls401.t$tpes$c ) SLS400 " &
"  ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT " &
" AND SLS400.t$item$c = ORDERDETAIL.SKU " &
" LEFT JOIN ( select clkp.description, " &
"  clkp.code " &
" from WMWHSE7.codelkup clkp " &
"  where clkp.listname = 'INCOTERMS' ) REDESPACHO " &
"  ON REDESPACHO.code = orders.INCOTERM " &
"WHERE NVL(SLS002.T$TPEN$C, 0) IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ") " &
"  AND Trunc(ORDERSTATUSHISTORY.ADDDATE) " &
"  Between '" + Parameters!DataUltEventoDe.Value + "' " &
"  And '" + Parameters!DataUltEventoAte.Value + "' " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ") " &
"  AND NVL(ORDERS.C_VAT, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"ORDER BY DSC_PLANTA, PEDIDO "