SELECT  
    WMSADMIN.PL_DB.DB_ALIAS                PLANTA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)
                                           DT_LIMITE,

    ORDERS.ORDERKEY                        PEDIDO, ORDERDETAIL.ORDERLINENUMBER ,
    ORDERS.SUSR4                           UNINEG,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                           DT_REGISTRO,
             
    nvl(ORDERSTATUSSETUP2.DESCRIPTION,
        ORDERSTATUSSETUP.DESCRIPTION )     EVENTO,
 
    nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE),
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE))        
                                           DT_ULT_EVENTO,

    nvl(ORDERSTATUSHISTORY.ADDWHO,
        ORDERS.EDITWHO)                    OPERADOR,
    ORDERDETAIL.SKU                        ITEM,
    SKU.ACTIVE                             ST_ITEM,
    SKU.DESCR                              NOME_ST_ITEM,
    DEPART.DEPART_NAME                     DEPARTAMENTO,
    DEPART.SECTOR_NAME                     SETOR,
 
    ORDERDETAIL.PRODUCT_CUBE *
    ORDERDETAIL.ORIGINALQTY                M3,
 
    TCCOM130.T$FOVN$L                      CNPJF,
    TCMCS060.T$DSCA                        FABRICANTE,
    SLS400.T$IDCA$C                        CANAL,
    ORDERS.C_VAT                           MEGA_ROTA,
    ORDERSTATUSSETUP.DESCRIPTION           SITUACAO,
    TASKDETAIL.TASKDETAILKEY               PROGRAMA,
    WAVEDETAIL.WAVEKEY                     ONDA,
    ORDERS.CARRIERCODE                     ID_TRANSPORTADORA,
    ORDERS.CARRIERNAME                     NOME_TRANSP,
    SLS002.T$TPEN$C                        TIPO_ENTREGA,
    ORDERS.SUSR1                           NOME_TP_ENT,
    ORDERS.INVOICENUMBER                   NOTA,
    ORDERS.LANE                            SERIE,
    CAGEIDDETAIL.CAGEID                    CARGA,
    CISLI940.T$CCFO$L                      CFOP,
    CISLI940.T$OPOR$L                      CFOP_SR,
  
    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' 
         ELSE 'LEVE' 
     END                                   TP_TRANSPORTE,
  
    ORDERS.C_ZIP                           CEP,
    SLS400.t$fovn$c                        CNPJ,       
    ORDERS.C_COMPANY                       NOME,
    ORDERDETAIL.ORIGINALQTY                QTDE_TOTAL,
    sls400.VALOR                           VL,
    ORDERS.type                            COD_TIPO_PEDIDO,
    TIPO_PEDIDO.                           DSC_TIPO_PEDIDO

 
FROM       WMWHSE5.ORDERS

INNER JOIN WMWHSE5.ORDERDETAIL 
        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY
        
INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = ORDERDETAIL.SKU 

 LEFT JOIN WMWHSE5.STORER 
        ON STORER.STORERKEY = sku.SUSR5 
       AND STORER.WHSEID = sku.WHSEID 

 LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART
        ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  
       AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2) 
        
 LEFT JOIN ENTERPRISE.CODELKUP cl  
        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)
      
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
       
 LEFT JOIN WMWHSE5.ORDERSTATUSSETUP
        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS
        
 LEFT JOIN WMWHSE5.ORDERSTATUSSETUP ORDERSTATUSSETUP2
        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS
        
 LEFT JOIN WMWHSE5.TASKDETAIL
        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY 
       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER  
               
 LEFT JOIN ( select q.T$IDCA$C, 
                    ZNSLS004.T$ORNO$C,
                    znsls401.t$item$c,
                    znsls401.t$tpes$c,
                    q.t$fovn$c,
                    sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) - 
                          znsls401.t$vldi$c +
                          znsls401.t$vlfr$c + 
                          znsls401.t$vlde$c ) VALOR
               from BAANDB.TZNSLS004301@pln01 ZNSLS004, 
                    BAANDB.TZNSLS400301@pln01 q,
                    BAANDB.TZNSLS401301@pln01 ZNSLS401
              where ZNSLS004.T$NCIA$C = q.T$NCIA$C
                and ZNSLS004.T$UNEG$C = q.T$UNEG$C
                and ZNSLS004.T$PECL$C = q.T$PECL$C
                and ZNSLS004.T$SQPD$C = q.T$SQPD$C
                and znsls401.T$NCIA$C = znsls004.T$NCIA$C
                and znsls401.T$UNEG$C = znsls004.T$UNEG$C
                and znsls401.T$PECL$C = znsls004.T$PECL$C
                and znsls401.T$SQPD$C = znsls004.T$SQPD$C
                and znsls401.t$entr$c = znsls004.t$entr$c
                and znsls401.t$sequ$c = znsls004.t$sequ$c
           group by q.T$IDCA$C, 
                    ZNSLS004.T$ORNO$C,
                    znsls401.t$item$c,
                    znsls401.t$tpes$c,
                    q.t$fovn$c ) SLS400
        ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT
       AND SLS400.t$item$c = ORDERDETAIL.SKU

 LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940 
        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER
       AND CISLI940.T$SERI$L = ORDERS.LANE
       AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY
    
 LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001 
        ON TRIM(TCIBD001.T$ITEM) = SKU.SKU
  
 LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060 
        ON TCMCS060.T$CMNF = TCIBD001.T$CMNF
  
 LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100 
        ON TCCOM100.T$BPID = STORER.STORERKEY
  
 LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130 
        ON TCCOM130.t$CADR = TCCOM100.T$CADR

 LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO, 
                    trans.description DSC_TIPO_PEDIDO
               from WMWHSE5.codelkup clkp
         inner join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
              where clkp.listname = 'ORDERTYPE'
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
                and Trim(clkp.code) is not null ) TIPO_PEDIDO
        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type  

WHERE cl.listname = 'SCHEMA'
  AND STORER.TYPE = 5

  AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone sessiontimezone) AS DATE),
                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone sessiontimezone) AS DATE))) 
      Between :DataUltimoEventoDe
          And :DataUltimoEventoAte
		  
= IIF(Parameters!Table.Value <> "AAA",

" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  "+ Parameters!Table.Value + ".ORDERS  " &
" INNER JOIN "+ Parameters!Table.Value + ".ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN "+ Parameters!Table.Value + ".SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN "+ Parameters!Table.Value + ".STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN "+ Parameters!Table.Value + ".WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN "+ Parameters!Table.Value + ".CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN "+ Parameters!Table.Value + ".CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM "+ Parameters!Table.Value + ".ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from "+ Parameters!Table.Value + ".ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN "+ Parameters!Table.Value + ".ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN "+ Parameters!Table.Value + ".ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN "+ Parameters!Table.Value + ".TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"ORDER BY PLANTA, PEDIDO, DT_REGISTRO "
  
,
  
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE1.ORDERS  " &
" INNER JOIN WMWHSE1.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE1.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE1.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE1.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE1.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE1.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE1.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE1.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE1.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE1.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE1.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE2.ORDERS  " &
" INNER JOIN WMWHSE2.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE2.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE2.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE2.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE2.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE2.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE2.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE2.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE2.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE2.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE2.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE3.ORDERS  " &
" INNER JOIN WMWHSE3.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE3.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE3.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE3.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE3.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE3.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE3.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE3.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE3.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE3.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE3.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE4.ORDERS  " &
" INNER JOIN WMWHSE4.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE4.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE4.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE4.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE4.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE4.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE4.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE4.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE4.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE4.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE4.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE5.ORDERS  " &
" INNER JOIN WMWHSE5.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE5.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE5.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE5.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE5.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE5.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE5.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE5.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE5.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE5.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE5.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE6.ORDERS  " &
" INNER JOIN WMWHSE6.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE6.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE6.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE6.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE6.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE6.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE6.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE6.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE6.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE6.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE6.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE7.ORDERS  " &
" INNER JOIN WMWHSE7.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE7.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE7.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE7.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE7.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE7.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE7.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE7.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE7.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE7.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE7.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"ORDER BY PLANTA, PEDIDO, DT_REGISTRO "

)