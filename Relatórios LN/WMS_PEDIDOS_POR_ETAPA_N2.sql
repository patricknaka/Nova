﻿SELECT
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS               FILIAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)                  
                                          DATA_LIMITE,
    ORDERS.ORDERKEY                       PEDIDO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)                  
                                          DATA_REGISTRO,
    ORDERSTATUSSETUP2.DESCRIPTION         EVENTO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)                  
                                          DATA_ULT_EVENTO,
    ORDERSTATUSHISTORY.ADDWHO             OPERADOR,
    ORDERDETAIL.SKU                       ITEM,
    SKU.DESCR                             NOME_ITEM,
    SLS400.T$IDCA$C                       CANAL,
    ORDERS.C_VAT                          MEGA_ROTA,
    CASE WHEN CAGEID.STATUS = '5' THEN 'Inclusão na Doca / Gaiolas pendente de Expedição'
         WHEN CAGEID.STATUS = '3' THEN 'Fechamento De Gaiola'
         WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'Inclusão De Volume Em Carga'
         WHEN ORDERS.INVOICESTATUS = '4' THEN 'Final De Conferencia'
         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Aprovada'
         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Solicitada'
         WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'Inclusao No Programa De Coleta'
         ELSE TO_CHAR(ORDERSTATUSSETUP.DESCRIPTION) 
     END                                  SITUACAO,
    TASKDETAIL.TASKDETAILKEY              PROGRAMA,
    WAVEDETAIL.WAVEKEY                    ONDA,
    ORDERS.CARRIERCODE                    ID_TRANSPORTADORA,
    ORDERS.CARRIERNAME                    TRANSPORTADORA,
    SLS002.T$TPEN$C                       TIPO_ENTREGA,
    ORDERS.SUSR1                          NOME_TP_ENT,
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
    ORDERDETAIL.ORIGINALQTY               QUANTIDADE
    
FROM       WMWHSE5.ORDERS

INNER JOIN WMWHSE5.ORDERDETAIL 
        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY
        
INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = ORDERDETAIL.SKU 
        
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
       
 LEFT JOIN ( select distinct 
                    q.T$IDCA$C, 
                    ZNSLS004.T$ORNO$C
               from BAANDB.TZNSLS004301@pln01 ZNSLS004, 
                    BAANDB.TZNSLS400301@pln01 q
              where ZNSLS004.T$NCIA$C = q.T$NCIA$C
                and ZNSLS004.T$UNEG$C = q.T$UNEG$C
                and ZNSLS004.T$PECL$C = q.T$PECL$C
                and ZNSLS004.T$SQPD$C = q.T$SQPD$C ) SLS400
        ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT
    
WHERE SLS002.T$TPEN$C IN (:TipoEntrega)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataUltEventoDe 
  AND :DataUltEventoAte
  AND ORDERSTATUSSETUP.CODE IN (:ClasseEventos)
  AND ORDERS.C_VAT IN (:MegaRota)
  AND  CASE WHEN CAGEID.STATUS = '5' THEN 'N1'
            WHEN CAGEID.STATUS = '3' THEN 'N2'
            WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'N3'
            WHEN ORDERS.INVOICESTATUS = '4' THEN 'N4'
            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N5'
            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N6'
            WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'N7'
            ELSE TO_CHAR(ORDERSTATUSSETUP.DESCRIPTION) 
        END IN (:Situacao)

--****************************************************************************************************   
--                   Lista de status para filtro:
--****************************************************************************************************
/* 

SELECT TO_CHAR(CODE), TO_CHAR(DESCRIPTION) FROM ORDERSTATUSSETUP
UNION SELECT 'N1', 'Inclusão na Doca / Gaiolas pendente de Expedição' FROM Dual
UNION SELECT 'N2', 'Fechamento De Gaiola' FROM Dual
UNION SELECT 'N3', 'Inclusão De Volume Em Carga' FROM Dual
UNION SELECT 'N4', 'Final De Conferencia' FROM Dual
UNION SELECT 'N5', 'Danfe Aprovada' FROM Dual
UNION SELECT 'N6', 'Danfe Solicitada' FROM Dual
UNION SELECT 'N7', 'Inclusao No Programa De Coleta' FROM Dual
 */
 

"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS               FILIAL,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &    
"                                          DATA_LIMITE,               " &
"    ORDERS.ORDERKEY                       PEDIDO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_REGISTRO,             " &
"    ORDERSTATUSSETUP2.DESCRIPTION         EVENTO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_ULT_EVENTO,           " &
"    ORDERSTATUSHISTORY.ADDWHO             OPERADOR,        " &
"    ORDERDETAIL.SKU                       ITEM,            " &
"    SKU.DESCR                             NOME_ITEM,       " &
"    SLS400.T$IDCA$C                       CANAL,           " &
"    ORDERS.C_VAT                          MEGA_ROTA,       " &
"    CASE WHEN CAGEID.STATUS = '5' THEN 'Inclusão na Doca / Gaiolas pendente de Expedição'  " &
"         WHEN CAGEID.STATUS = '3' THEN 'Fechamento De Gaiola'                              " &
"         WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'Inclusão De Volume Em Carga'           " &
"         WHEN ORDERS.INVOICESTATUS = '4' THEN 'Final De Conferencia'                       " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Aprovada'                             " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Solicitada'                           " &
"         WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'Inclusao No Programa De Coleta'         " &
"         ELSE TO_CHAR(ORDERSTATUSSETUP.DESCRIPTION)          " &
"     END                                  SITUACAO,          " &
"    TASKDETAIL.TASKDETAILKEY              PROGRAMA,          " &
"    WAVEDETAIL.WAVEKEY                    ONDA,              " &
"    ORDERS.CARRIERCODE                    ID_TRANSPORTADORA, " &
"    ORDERS.CARRIERNAME                    TRANSPORTADORA,    " &
"    SLS002.T$TPEN$C                       TIPO_ENTREGA,      " &
"    ORDERS.SUSR1                          NOME_TP_ENT,       " &
"    ORDERS.INVOICENUMBER                  NOTA,              " &
"    ORDERS.LANE                           SERIE,             " &
"    CAGEIDDETAIL.CAGEID                   CARGA,             " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                    " &
"         ELSE 'LEVE'                                         " &
"     END                                  TP_TRANSPORTE,     " &
"    ORDERS.C_ZIP                          CEP,               " &
"    whwmd400.t$hght                       ALTURA,            " &
"    whwmd400.t$wdth                       LARGURA,           " &
"    whwmd400.t$dpth                       COMPRIMENTO,       " &
"    SKU.STDNETWGT                         PESO_UNITARIO,     " &
"    SKU.STDGROSSWGT                       PESO_BRUTO,        " &
"    ORDERS.C_CITY                         MUNICIPIO,         " &
"    ORDERS.C_STATE                        ESTADO,            " &
"    ORDERDETAIL.SHIPPEDQTY                QUANTIDADE         " &
"                                                             " &
"FROM       " + Parameters!Table.Value + ".ORDERS             " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERDETAIL        " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY            " &
"INNER JOIN " + Parameters!Table.Value + ".SKU                " &
"        ON SKU.SKU = ORDERDETAIL.SKU                         " &
" LEFT JOIN " + Parameters!Table.Value + ".WAVEDETAIL         " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY        " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEIDDETAIL       " &
"        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY       " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEID             " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID               " &
"INNER JOIN WMSADMIN.PL_DB                                    " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID    " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002                  " &
"        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1)) " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400                       " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)                    " &
" LEFT JOIN ( SELECT a.ORDERKEY,                                     " &
"                    a.ORDERLINENUMBER ,                             " &
"                    max(a.STATUS) STATUS,                           " &
"                    max(a.ADDDATE) ADDDATE,                         " &
"                    max(a.ADDWHO) ADDWHO                            " &
"               FROM " + Parameters!Table.Value + ".ORDERSTATUSHISTORY a " &
"              WHERE a.ADDDATE = ( select max(b.adddate)                 " &
"                                    from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY                 " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"           GROUP BY a.ORDERKEY,                                                  " &
"                    a.ORDERLINENUMBER ) ORDERSTATUSHISTORY                       " &
"        ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"       AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS                        " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP                       " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                 " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP ORDERSTATUSSETUP2     " &
"        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS         " &
" LEFT JOIN " + Parameters!Table.Value + ".TASKDETAIL                  " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                 " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
" LEFT JOIN ( select distinct                                          " &
"                    q.T$IDCA$C,                                       " &
"                    ZNSLS004.T$ORNO$C                                 " &
"               from BAANDB.TZNSLS004301@pln01 ZNSLS004,               " &
"                    BAANDB.TZNSLS400301@pln01 q                       " &
"              where ZNSLS004.T$NCIA$C = q.T$NCIA$C                    " &
"                and ZNSLS004.T$UNEG$C = q.T$UNEG$C                    " &
"                and ZNSLS004.T$PECL$C = q.T$PECL$C                    " &
"                and ZNSLS004.T$SQPD$C = q.T$SQPD$C ) SLS400           " &
"        ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                 " &
"                                                                      " &
"WHERE SLS002.T$TPEN$C IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ")                           " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,    " &       
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataUltEventoDe.Value + "'            " &
"  AND '" + Parameters!DataUltEventoAte.Value + "'                                                     " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ")                   " &
"  AND ORDERS.C_VAT IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"  AND  CASE WHEN CAGEID.STATUS = '5' THEN 'N1'                 " &
"            WHEN CAGEID.STATUS = '3' THEN 'N2'                 " &
"            WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'N3'     " &
"            WHEN ORDERS.INVOICESTATUS = '4' THEN 'N4'          " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N5'          " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N6'          " &
"            WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'N7'      " &
"            ELSE TO_CHAR(ORDERSTATUSSETUP.CODE)                " &
"        END IN (" + Replace(("'" + JOIN(Parameters!Situacao.Value, "',") + "'"),",",",'") + ")        " &
"ORDER BY ORDERS.ORDERKEY " 

-- Query com UNION ***************************************************************************************

"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS               FILIAL,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &    
"                                          DATA_LIMITE,               " &
"    ORDERS.ORDERKEY                       PEDIDO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_REGISTRO,             " &
"    ORDERSTATUSSETUP2.DESCRIPTION         EVENTO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_ULT_EVENTO,           " &
"    ORDERSTATUSHISTORY.ADDWHO             OPERADOR,        " &
"    ORDERDETAIL.SKU                       ITEM,            " &
"    SKU.DESCR                             NOME_ITEM,       " &
"    SLS400.T$IDCA$C                       CANAL,           " &
"    ORDERS.C_VAT                          MEGA_ROTA,       " &
"    CASE WHEN CAGEID.STATUS = '5' THEN 'Inclusão na Doca / Gaiolas pendente de Expedição'  " &
"         WHEN CAGEID.STATUS = '3' THEN 'Fechamento De Gaiola'                              " &
"         WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'Inclusão De Volume Em Carga'           " &
"         WHEN ORDERS.INVOICESTATUS = '4' THEN 'Final De Conferencia'                       " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Aprovada'                             " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Solicitada'                           " &
"         WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'Inclusao No Programa De Coleta'         " &
"         ELSE TO_CHAR(ORDERSTATUSSETUP.DESCRIPTION)          " &
"     END                                  SITUACAO,          " &
"    TASKDETAIL.TASKDETAILKEY              PROGRAMA,          " &
"    WAVEDETAIL.WAVEKEY                    ONDA,              " &
"    ORDERS.CARRIERCODE                    ID_TRANSPORTADORA, " &
"    ORDERS.CARRIERNAME                    TRANSPORTADORA,    " &
"    SLS002.T$TPEN$C                       TIPO_ENTREGA,      " &
"    ORDERS.SUSR1                          NOME_TP_ENT,       " &
"    ORDERS.INVOICENUMBER                  NOTA,              " &
"    ORDERS.LANE                           SERIE,             " &
"    CAGEIDDETAIL.CAGEID                   CARGA,             " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                    " &
"         ELSE 'LEVE'                                         " &
"     END                                  TP_TRANSPORTE,     " &
"    ORDERS.C_ZIP                          CEP,               " &
"    whwmd400.t$hght                       ALTURA,            " &
"    whwmd400.t$wdth                       LARGURA,           " &
"    whwmd400.t$dpth                       COMPRIMENTO,       " &
"    SKU.STDNETWGT                         PESO_UNITARIO,     " &
"    SKU.STDGROSSWGT                       PESO_BRUTO,        " &
"    ORDERS.C_CITY                         MUNICIPIO,         " &
"    ORDERS.C_STATE                        ESTADO,            " &
"    ORDERDETAIL.SHIPPEDQTY                QUANTIDADE         " &
"                                                             " &
"FROM       WMWHSE1.ORDERS                                    " &
"INNER JOIN WMWHSE1.ORDERDETAIL                               " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY            " &
"INNER JOIN WMWHSE1.SKU                                       " &
"        ON SKU.SKU = ORDERDETAIL.SKU                         " &
" LEFT JOIN WMWHSE1.WAVEDETAIL                                " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY        " &
" LEFT JOIN WMWHSE1.CAGEIDDETAIL                              " &
"        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY       " &
" LEFT JOIN WMWHSE1.CAGEID                                    " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID               " &
"INNER JOIN WMSADMIN.PL_DB                                    " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID    " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002                  " &
"        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400           " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)        " &
" LEFT JOIN ( SELECT a.ORDERKEY,                         " &
"                    a.ORDERLINENUMBER ,                 " &
"                    max(a.STATUS) STATUS,               " &
"                    max(a.ADDDATE) ADDDATE,             " &
"                    max(a.ADDWHO) ADDWHO                " &
"               FROM WMWHSE1.ORDERSTATUSHISTORY a        " &
"              WHERE a.ADDDATE = ( select max(b.adddate)                " &
"                                    from WMWHSE1.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY                 " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"           GROUP BY a.ORDERKEY,                                                  " &
"                    a.ORDERLINENUMBER ) ORDERSTATUSHISTORY                       " &
"        ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"       AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS            " &
" LEFT JOIN WMWHSE1.ORDERSTATUSSETUP                                  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                     " &
" LEFT JOIN WMWHSE1.ORDERSTATUSSETUP ORDERSTATUSSETUP2                " &
"        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS        " &
" LEFT JOIN WMWHSE1.TASKDETAIL                                        " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER  " &
" LEFT JOIN ( select distinct                                         " &
"                    q.T$IDCA$C,                                      " &
"                    ZNSLS004.T$ORNO$C                                " &
"               from BAANDB.TZNSLS004301@pln01 ZNSLS004,              " &
"                    BAANDB.TZNSLS400301@pln01 q                      " &
"              where ZNSLS004.T$NCIA$C = q.T$NCIA$C                   " &
"                and ZNSLS004.T$UNEG$C = q.T$UNEG$C                   " &
"                and ZNSLS004.T$PECL$C = q.T$PECL$C                   " &
"                and ZNSLS004.T$SQPD$C = q.T$SQPD$C ) SLS400          " &
"        ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                " &
"                                                                     " &
"WHERE SLS002.T$TPEN$C IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ")                           " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,    " &       
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataUltEventoDe.Value + "'            " &
"  AND '" + Parameters!DataUltEventoAte.Value + "'                                                     " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ")                   " &
"  AND ORDERS.C_VAT IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"  AND  CASE WHEN CAGEID.STATUS = '5' THEN 'N1'                 " &
"            WHEN CAGEID.STATUS = '3' THEN 'N2'                 " &
"            WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'N3'     " &
"            WHEN ORDERS.INVOICESTATUS = '4' THEN 'N4'          " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N5'          " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N6'          " &
"            WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'N7'      " &
"            ELSE TO_CHAR(ORDERSTATUSSETUP.CODE)                " &
"        END IN (" + Replace(("'" + JOIN(Parameters!Situacao.Value, "',") + "'"),",",",'") + ")        " &
"                                                                                                      " &
"Union                                                                                                 " &
"                                                                                                      " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS               FILIAL,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &    
"                                          DATA_LIMITE,               " &
"    ORDERS.ORDERKEY                       PEDIDO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_REGISTRO,             " &
"    ORDERSTATUSSETUP2.DESCRIPTION         EVENTO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_ULT_EVENTO,           " &
"    ORDERSTATUSHISTORY.ADDWHO             OPERADOR,        " &
"    ORDERDETAIL.SKU                       ITEM,            " &
"    SKU.DESCR                             NOME_ITEM,       " &
"    SLS400.T$IDCA$C                       CANAL,           " &
"    ORDERS.C_VAT                          MEGA_ROTA,       " &
"    CASE WHEN CAGEID.STATUS = '5' THEN 'Inclusão na Doca / Gaiolas pendente de Expedição'  " &
"         WHEN CAGEID.STATUS = '3' THEN 'Fechamento De Gaiola'                              " &
"         WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'Inclusão De Volume Em Carga'           " &
"         WHEN ORDERS.INVOICESTATUS = '4' THEN 'Final De Conferencia'                       " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Aprovada'                             " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Solicitada'                           " &
"         WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'Inclusao No Programa De Coleta'         " &
"         ELSE TO_CHAR(ORDERSTATUSSETUP.DESCRIPTION)          " &
"     END                                  SITUACAO,          " &
"    TASKDETAIL.TASKDETAILKEY              PROGRAMA,          " &
"    WAVEDETAIL.WAVEKEY                    ONDA,              " &
"    ORDERS.CARRIERCODE                    ID_TRANSPORTADORA, " &
"    ORDERS.CARRIERNAME                    TRANSPORTADORA,    " &
"    SLS002.T$TPEN$C                       TIPO_ENTREGA,      " &
"    ORDERS.SUSR1                          NOME_TP_ENT,       " &
"    ORDERS.INVOICENUMBER                  NOTA,              " &
"    ORDERS.LANE                           SERIE,             " &
"    CAGEIDDETAIL.CAGEID                   CARGA,             " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                    " &
"         ELSE 'LEVE'                                         " &
"     END                                  TP_TRANSPORTE,     " &
"    ORDERS.C_ZIP                          CEP,               " &
"    whwmd400.t$hght                       ALTURA,            " &
"    whwmd400.t$wdth                       LARGURA,           " &
"    whwmd400.t$dpth                       COMPRIMENTO,       " &
"    SKU.STDNETWGT                         PESO_UNITARIO,     " &
"    SKU.STDGROSSWGT                       PESO_BRUTO,        " &
"    ORDERS.C_CITY                         MUNICIPIO,         " &
"    ORDERS.C_STATE                        ESTADO,            " &
"    ORDERDETAIL.SHIPPEDQTY                QUANTIDADE         " &
"                                                             " &
"FROM       WMWHSE2.ORDERS                                    " &
"INNER JOIN WMWHSE2.ORDERDETAIL                               " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY            " &
"INNER JOIN WMWHSE2.SKU                                       " &
"        ON SKU.SKU = ORDERDETAIL.SKU                         " &
" LEFT JOIN WMWHSE2.WAVEDETAIL                                " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY        " &
" LEFT JOIN WMWHSE2.CAGEIDDETAIL                              " &
"        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY       " &
" LEFT JOIN WMWHSE2.CAGEID                                    " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID               " &
"INNER JOIN WMSADMIN.PL_DB                                    " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID    " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002                  " &
"        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400       " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)    " &
" LEFT JOIN ( SELECT a.ORDERKEY,                     " &
"                    a.ORDERLINENUMBER ,             " &
"                    max(a.STATUS) STATUS,           " &
"                    max(a.ADDDATE) ADDDATE,         " &
"                    max(a.ADDWHO) ADDWHO            " &
"               FROM WMWHSE2.ORDERSTATUSHISTORY a    " &
"              WHERE a.ADDDATE = ( select max(b.adddate)                " &
"                                    from WMWHSE2.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY                 " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"           GROUP BY a.ORDERKEY,                                                  " &
"                    a.ORDERLINENUMBER ) ORDERSTATUSHISTORY                       " &
"        ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"       AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS             " &
" LEFT JOIN WMWHSE2.ORDERSTATUSSETUP                                   " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                      " &
" LEFT JOIN WMWHSE2.ORDERSTATUSSETUP ORDERSTATUSSETUP2                 " &
"        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS         " &
" LEFT JOIN WMWHSE2.TASKDETAIL                                         " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                 " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
" LEFT JOIN ( select distinct                                          " &
"                    q.T$IDCA$C,                                       " &
"                    ZNSLS004.T$ORNO$C                                 " &
"               from BAANDB.TZNSLS004301@pln01 ZNSLS004,               " &
"                    BAANDB.TZNSLS400301@pln01 q                       " &
"              where ZNSLS004.T$NCIA$C = q.T$NCIA$C                    " &
"                and ZNSLS004.T$UNEG$C = q.T$UNEG$C                    " &
"                and ZNSLS004.T$PECL$C = q.T$PECL$C                    " &
"                and ZNSLS004.T$SQPD$C = q.T$SQPD$C ) SLS400           " &
"        ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                 " &
"                                                                      " &
"WHERE SLS002.T$TPEN$C IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ")                           " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,    " &       
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataUltEventoDe.Value + "'            " &
"  AND '" + Parameters!DataUltEventoAte.Value + "'                                                     " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ")                   " &
"  AND ORDERS.C_VAT IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"  AND  CASE WHEN CAGEID.STATUS = '5' THEN 'N1'               " &
"            WHEN CAGEID.STATUS = '3' THEN 'N2'               " &
"            WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'N3'   " &
"            WHEN ORDERS.INVOICESTATUS = '4' THEN 'N4'        " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N5'        " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N6'        " &
"            WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'N7'    " &
"            ELSE TO_CHAR(ORDERSTATUSSETUP.CODE)              " &
"        END IN (" + Replace(("'" + JOIN(Parameters!Situacao.Value, "',") + "'"),",",",'") + ")        " &
"                                                                                                      " &
"Union                                                                                                 " &
"                                                                                                      " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS               FILIAL,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &    
"                                          DATA_LIMITE,               " &
"    ORDERS.ORDERKEY                       PEDIDO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_REGISTRO,             " &
"    ORDERSTATUSSETUP2.DESCRIPTION         EVENTO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_ULT_EVENTO,           " &
"    ORDERSTATUSHISTORY.ADDWHO             OPERADOR,        " &
"    ORDERDETAIL.SKU                       ITEM,            " &
"    SKU.DESCR                             NOME_ITEM,       " &
"    SLS400.T$IDCA$C                       CANAL,           " &
"    ORDERS.C_VAT                          MEGA_ROTA,       " &
"    CASE WHEN CAGEID.STATUS = '5' THEN 'Inclusão na Doca / Gaiolas pendente de Expedição'  " &
"         WHEN CAGEID.STATUS = '3' THEN 'Fechamento De Gaiola'                              " &
"         WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'Inclusão De Volume Em Carga'           " &
"         WHEN ORDERS.INVOICESTATUS = '4' THEN 'Final De Conferencia'                       " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Aprovada'                             " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Solicitada'                           " &
"         WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'Inclusao No Programa De Coleta'         " &
"         ELSE TO_CHAR(ORDERSTATUSSETUP.DESCRIPTION)          " &
"     END                                  SITUACAO,          " &
"    TASKDETAIL.TASKDETAILKEY              PROGRAMA,          " &
"    WAVEDETAIL.WAVEKEY                    ONDA,              " &
"    ORDERS.CARRIERCODE                    ID_TRANSPORTADORA, " &
"    ORDERS.CARRIERNAME                    TRANSPORTADORA,    " &
"    SLS002.T$TPEN$C                       TIPO_ENTREGA,      " &
"    ORDERS.SUSR1                          NOME_TP_ENT,       " &
"    ORDERS.INVOICENUMBER                  NOTA,              " &
"    ORDERS.LANE                           SERIE,             " &
"    CAGEIDDETAIL.CAGEID                   CARGA,             " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                    " &
"         ELSE 'LEVE'                                         " &
"     END                                  TP_TRANSPORTE,     " &
"    ORDERS.C_ZIP                          CEP,               " &
"    whwmd400.t$hght                       ALTURA,            " &
"    whwmd400.t$wdth                       LARGURA,           " &
"    whwmd400.t$dpth                       COMPRIMENTO,       " &
"    SKU.STDNETWGT                         PESO_UNITARIO,     " &
"    SKU.STDGROSSWGT                       PESO_BRUTO,        " &
"    ORDERS.C_CITY                         MUNICIPIO,         " &
"    ORDERS.C_STATE                        ESTADO,            " &
"    ORDERDETAIL.SHIPPEDQTY                QUANTIDADE         " &
"                                                             " &
"FROM       WMWHSE3.ORDERS                                    " &
"INNER JOIN WMWHSE3.ORDERDETAIL                               " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY            " &
"INNER JOIN WMWHSE3.SKU                                       " &
"        ON SKU.SKU = ORDERDETAIL.SKU                         " &
" LEFT JOIN WMWHSE3.WAVEDETAIL                                " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY        " &
" LEFT JOIN WMWHSE3.CAGEIDDETAIL                              " &
"        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY       " &
" LEFT JOIN WMWHSE3.CAGEID                                    " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID               " &
"INNER JOIN WMSADMIN.PL_DB                                    " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID    " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002                  " &
"        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400        " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)     " &
" LEFT JOIN ( SELECT a.ORDERKEY,                      " &
"                    a.ORDERLINENUMBER ,              " &
"                    max(a.STATUS) STATUS,            " &
"                    max(a.ADDDATE) ADDDATE,          " &
"                    max(a.ADDWHO) ADDWHO             " &
"               FROM WMWHSE3.ORDERSTATUSHISTORY a     " &
"              WHERE a.ADDDATE = ( select max(b.adddate)                " &
"                                    from WMWHSE3.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY                 " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"           GROUP BY a.ORDERKEY,                                                  " &
"                    a.ORDERLINENUMBER ) ORDERSTATUSHISTORY                       " &
"        ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"       AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS            " &
" LEFT JOIN WMWHSE3.ORDERSTATUSSETUP                                  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                     " &
" LEFT JOIN WMWHSE3.ORDERSTATUSSETUP ORDERSTATUSSETUP2                " &
"        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS        " &
" LEFT JOIN WMWHSE3.TASKDETAIL                                        " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER  " &
" LEFT JOIN ( select distinct                                         " &
"                    q.T$IDCA$C,                                      " &
"                    ZNSLS004.T$ORNO$C                                " &
"               from BAANDB.TZNSLS004301@pln01 ZNSLS004,              " &
"                    BAANDB.TZNSLS400301@pln01 q                      " &
"              where ZNSLS004.T$NCIA$C = q.T$NCIA$C                   " &
"                and ZNSLS004.T$UNEG$C = q.T$UNEG$C                   " &
"                and ZNSLS004.T$PECL$C = q.T$PECL$C                   " &
"                and ZNSLS004.T$SQPD$C = q.T$SQPD$C ) SLS400          " &
"        ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                " &
"                                                                     " &
"WHERE SLS002.T$TPEN$C IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ")                           " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,    " &       
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataUltEventoDe.Value + "'            " &
"  AND '" + Parameters!DataUltEventoAte.Value + "'                                                     " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ")                   " &
"  AND ORDERS.C_VAT IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"  AND  CASE WHEN CAGEID.STATUS = '5' THEN 'N1'               " &
"            WHEN CAGEID.STATUS = '3' THEN 'N2'               " &
"            WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'N3'   " &
"            WHEN ORDERS.INVOICESTATUS = '4' THEN 'N4'        " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N5'        " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N6'        " &
"            WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'N7'    " &
"            ELSE TO_CHAR(ORDERSTATUSSETUP.CODE)              " &
"        END IN (" + Replace(("'" + JOIN(Parameters!Situacao.Value, "',") + "'"),",",",'") + ")        " &
"                                                           " &
"Union                                                      " &
"                                                           " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS               FILIAL,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &    
"                                          DATA_LIMITE,               " &
"    ORDERS.ORDERKEY                       PEDIDO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_REGISTRO,             " &
"    ORDERSTATUSSETUP2.DESCRIPTION         EVENTO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_ULT_EVENTO,           " &
"    ORDERSTATUSHISTORY.ADDWHO             OPERADOR,        " &
"    ORDERDETAIL.SKU                       ITEM,            " &
"    SKU.DESCR                             NOME_ITEM,       " &
"    SLS400.T$IDCA$C                       CANAL,           " &
"    ORDERS.C_VAT                          MEGA_ROTA,       " &
"    CASE WHEN CAGEID.STATUS = '5' THEN 'Inclusão na Doca / Gaiolas pendente de Expedição'  " &
"         WHEN CAGEID.STATUS = '3' THEN 'Fechamento De Gaiola'                              " &
"         WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'Inclusão De Volume Em Carga'           " &
"         WHEN ORDERS.INVOICESTATUS = '4' THEN 'Final De Conferencia'                       " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Aprovada'                             " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Solicitada'                           " &
"         WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'Inclusao No Programa De Coleta'         " &
"         ELSE TO_CHAR(ORDERSTATUSSETUP.DESCRIPTION)          " &
"     END                                  SITUACAO,          " &
"    TASKDETAIL.TASKDETAILKEY              PROGRAMA,          " &
"    WAVEDETAIL.WAVEKEY                    ONDA,              " &
"    ORDERS.CARRIERCODE                    ID_TRANSPORTADORA, " &
"    ORDERS.CARRIERNAME                    TRANSPORTADORA,    " &
"    SLS002.T$TPEN$C                       TIPO_ENTREGA,      " &
"    ORDERS.SUSR1                          NOME_TP_ENT,       " &
"    ORDERS.INVOICENUMBER                  NOTA,              " &
"    ORDERS.LANE                           SERIE,             " &
"    CAGEIDDETAIL.CAGEID                   CARGA,             " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                    " &
"         ELSE 'LEVE'                                         " &
"     END                                  TP_TRANSPORTE,     " &
"    ORDERS.C_ZIP                          CEP,               " &
"    whwmd400.t$hght                       ALTURA,            " &
"    whwmd400.t$wdth                       LARGURA,           " &
"    whwmd400.t$dpth                       COMPRIMENTO,       " &
"    SKU.STDNETWGT                         PESO_UNITARIO,     " &
"    SKU.STDGROSSWGT                       PESO_BRUTO,        " &
"    ORDERS.C_CITY                         MUNICIPIO,         " &
"    ORDERS.C_STATE                        ESTADO,            " &
"    ORDERDETAIL.SHIPPEDQTY                QUANTIDADE         " &
"                                                             " &
"FROM       WMWHSE4.ORDERS                                    " &
"INNER JOIN WMWHSE4.ORDERDETAIL                               " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY            " &
"INNER JOIN WMWHSE4.SKU                                       " &
"        ON SKU.SKU = ORDERDETAIL.SKU                         " &
" LEFT JOIN WMWHSE4.WAVEDETAIL                                " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY        " &
" LEFT JOIN WMWHSE4.CAGEIDDETAIL                              " &
"        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY       " &
" LEFT JOIN WMWHSE4.CAGEID                                    " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID               " &
"INNER JOIN WMSADMIN.PL_DB                                    " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID    " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002                  " &
"        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400          " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)       " &
" LEFT JOIN ( SELECT a.ORDERKEY,                        " &
"                    a.ORDERLINENUMBER ,                " &
"                    max(a.STATUS) STATUS,              " &
"                    max(a.ADDDATE) ADDDATE,            " &
"                    max(a.ADDWHO) ADDWHO               " &
"               FROM WMWHSE4.ORDERSTATUSHISTORY a       " &
"              WHERE a.ADDDATE = ( select max(b.adddate)                " &
"                                    from WMWHSE4.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY                 " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"           GROUP BY a.ORDERKEY,                                                  " &
"                    a.ORDERLINENUMBER ) ORDERSTATUSHISTORY                       " &
"        ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"       AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS            " &
" LEFT JOIN WMWHSE4.ORDERSTATUSSETUP                                  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                     " &
" LEFT JOIN WMWHSE4.ORDERSTATUSSETUP ORDERSTATUSSETUP2                " &
"        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS        " &
" LEFT JOIN WMWHSE4.TASKDETAIL                                        " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER  " &
" LEFT JOIN ( select distinct                                         " &
"                    q.T$IDCA$C,                                      " &
"                    ZNSLS004.T$ORNO$C                                " &
"               from BAANDB.TZNSLS004301@pln01 ZNSLS004,              " &
"                    BAANDB.TZNSLS400301@pln01 q                      " &
"              where ZNSLS004.T$NCIA$C = q.T$NCIA$C                   " &
"                and ZNSLS004.T$UNEG$C = q.T$UNEG$C                   " &
"                and ZNSLS004.T$PECL$C = q.T$PECL$C                   " &
"                and ZNSLS004.T$SQPD$C = q.T$SQPD$C ) SLS400          " &
"        ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                " &
"                                                                     " &
"WHERE SLS002.T$TPEN$C IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ")                           " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,    " &       
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataUltEventoDe.Value + "'            " &
"  AND '" + Parameters!DataUltEventoAte.Value + "'                                                     " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ")                   " &
"  AND ORDERS.C_VAT IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"  AND  CASE WHEN CAGEID.STATUS = '5' THEN 'N1'                 " &
"            WHEN CAGEID.STATUS = '3' THEN 'N2'                 " &
"            WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'N3'     " &
"            WHEN ORDERS.INVOICESTATUS = '4' THEN 'N4'          " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N5'          " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N6'          " &
"            WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'N7'      " &
"            ELSE TO_CHAR(ORDERSTATUSSETUP.CODE)                " &
"        END IN (" + Replace(("'" + JOIN(Parameters!Situacao.Value, "',") + "'"),",",",'") + ")        " &
"                                                           " &
"Union                                                      " &
"                                                           " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS               FILIAL,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &    
"                                          DATA_LIMITE,               " &
"    ORDERS.ORDERKEY                       PEDIDO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_REGISTRO,             " &
"    ORDERSTATUSSETUP2.DESCRIPTION         EVENTO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_ULT_EVENTO,           " &
"    ORDERSTATUSHISTORY.ADDWHO             OPERADOR,        " &
"    ORDERDETAIL.SKU                       ITEM,            " &
"    SKU.DESCR                             NOME_ITEM,       " &
"    SLS400.T$IDCA$C                       CANAL,           " &
"    ORDERS.C_VAT                          MEGA_ROTA,       " &
"    CASE WHEN CAGEID.STATUS = '5' THEN 'Inclusão na Doca / Gaiolas pendente de Expedição'  " &
"         WHEN CAGEID.STATUS = '3' THEN 'Fechamento De Gaiola'                              " &
"         WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'Inclusão De Volume Em Carga'           " &
"         WHEN ORDERS.INVOICESTATUS = '4' THEN 'Final De Conferencia'                       " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Aprovada'                             " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Solicitada'                           " &
"         WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'Inclusao No Programa De Coleta'         " &
"         ELSE TO_CHAR(ORDERSTATUSSETUP.DESCRIPTION)          " &
"     END                                  SITUACAO,          " &
"    TASKDETAIL.TASKDETAILKEY              PROGRAMA,          " &
"    WAVEDETAIL.WAVEKEY                    ONDA,              " &
"    ORDERS.CARRIERCODE                    ID_TRANSPORTADORA, " &
"    ORDERS.CARRIERNAME                    TRANSPORTADORA,    " &
"    SLS002.T$TPEN$C                       TIPO_ENTREGA,      " &
"    ORDERS.SUSR1                          NOME_TP_ENT,       " &
"    ORDERS.INVOICENUMBER                  NOTA,              " &
"    ORDERS.LANE                           SERIE,             " &
"    CAGEIDDETAIL.CAGEID                   CARGA,             " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                    " &
"         ELSE 'LEVE'                                         " &
"     END                                  TP_TRANSPORTE,     " &
"    ORDERS.C_ZIP                          CEP,               " &
"    whwmd400.t$hght                       ALTURA,            " &
"    whwmd400.t$wdth                       LARGURA,           " &
"    whwmd400.t$dpth                       COMPRIMENTO,       " &
"    SKU.STDNETWGT                         PESO_UNITARIO,     " &
"    SKU.STDGROSSWGT                       PESO_BRUTO,        " &
"    ORDERS.C_CITY                         MUNICIPIO,         " &
"    ORDERS.C_STATE                        ESTADO,            " &
"    ORDERDETAIL.SHIPPEDQTY                QUANTIDADE         " &
"                                                             " &
"FROM       WMWHSE5.ORDERS                                    " &
"INNER JOIN WMWHSE5.ORDERDETAIL                               " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY            " &
"INNER JOIN WMWHSE5.SKU                                       " &
"        ON SKU.SKU = ORDERDETAIL.SKU                         " &
" LEFT JOIN WMWHSE5.WAVEDETAIL                                " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY        " &
" LEFT JOIN WMWHSE5.CAGEIDDETAIL                              " &
"        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY       " &
" LEFT JOIN WMWHSE5.CAGEID                                    " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID               " &
"INNER JOIN WMSADMIN.PL_DB                                    " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID    " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002                  " &
"        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400           " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)        " &
" LEFT JOIN ( SELECT a.ORDERKEY,                         " &
"                    a.ORDERLINENUMBER ,                 " &
"                    max(a.STATUS) STATUS,               " &
"                    max(a.ADDDATE) ADDDATE,             " &
"                    max(a.ADDWHO) ADDWHO                " &
"               FROM WMWHSE5.ORDERSTATUSHISTORY a        " &
"              WHERE a.ADDDATE = ( select max(b.adddate) " &
"                                    from WMWHSE5.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY                 " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"           GROUP BY a.ORDERKEY,                                                  " &
"                    a.ORDERLINENUMBER ) ORDERSTATUSHISTORY                       " &
"        ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"       AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS            " &
" LEFT JOIN WMWHSE5.ORDERSTATUSSETUP                                  " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                     " &
" LEFT JOIN WMWHSE5.ORDERSTATUSSETUP ORDERSTATUSSETUP2                " &
"        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS        " &
" LEFT JOIN WMWHSE5.TASKDETAIL                                        " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER  " &
" LEFT JOIN ( select distinct                                         " &
"                    q.T$IDCA$C,                                      " &
"                    ZNSLS004.T$ORNO$C                                " &
"               from BAANDB.TZNSLS004301@pln01 ZNSLS004,              " &
"                    BAANDB.TZNSLS400301@pln01 q                      " &
"              where ZNSLS004.T$NCIA$C = q.T$NCIA$C                   " &
"                and ZNSLS004.T$UNEG$C = q.T$UNEG$C                   " &
"                and ZNSLS004.T$PECL$C = q.T$PECL$C                   " &
"                and ZNSLS004.T$SQPD$C = q.T$SQPD$C ) SLS400          " &
"        ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                " &
"                                                                     " &
"WHERE SLS002.T$TPEN$C IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ")                           " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,    " &       
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataUltEventoDe.Value + "'            " &
"  AND '" + Parameters!DataUltEventoAte.Value + "'                                                     " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ")                   " &
"  AND ORDERS.C_VAT IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"  AND  CASE WHEN CAGEID.STATUS = '5' THEN 'N1'               " &
"            WHEN CAGEID.STATUS = '3' THEN 'N2'               " &
"            WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'N3'   " &
"            WHEN ORDERS.INVOICESTATUS = '4' THEN 'N4'        " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N5'        " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N6'        " &
"            WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'N7'    " &
"            ELSE TO_CHAR(ORDERSTATUSSETUP.CODE)              " &
"        END IN (" + Replace(("'" + JOIN(Parameters!Situacao.Value, "',") + "'"),",",",'") + ")        " &
"                                                           " &
"Union                                                      " &
"                                                           " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS               FILIAL,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &    
"                                          DATA_LIMITE,               " &
"    ORDERS.ORDERKEY                       PEDIDO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_REGISTRO,             " &
"    ORDERSTATUSSETUP2.DESCRIPTION         EVENTO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_ULT_EVENTO,           " &
"    ORDERSTATUSHISTORY.ADDWHO             OPERADOR,        " &
"    ORDERDETAIL.SKU                       ITEM,            " &
"    SKU.DESCR                             NOME_ITEM,       " &
"    SLS400.T$IDCA$C                       CANAL,           " &
"    ORDERS.C_VAT                          MEGA_ROTA,       " &
"    CASE WHEN CAGEID.STATUS = '5' THEN 'Inclusão na Doca / Gaiolas pendente de Expedição'  " &
"         WHEN CAGEID.STATUS = '3' THEN 'Fechamento De Gaiola'                              " &
"         WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'Inclusão De Volume Em Carga'           " &
"         WHEN ORDERS.INVOICESTATUS = '4' THEN 'Final De Conferencia'                       " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Aprovada'                             " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Solicitada'                           " &
"         WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'Inclusao No Programa De Coleta'         " &
"         ELSE TO_CHAR(ORDERSTATUSSETUP.DESCRIPTION)          " &
"     END                                  SITUACAO,          " &
"    TASKDETAIL.TASKDETAILKEY              PROGRAMA,          " &
"    WAVEDETAIL.WAVEKEY                    ONDA,              " &
"    ORDERS.CARRIERCODE                    ID_TRANSPORTADORA, " &
"    ORDERS.CARRIERNAME                    TRANSPORTADORA,    " &
"    SLS002.T$TPEN$C                       TIPO_ENTREGA,      " &
"    ORDERS.SUSR1                          NOME_TP_ENT,       " &
"    ORDERS.INVOICENUMBER                  NOTA,              " &
"    ORDERS.LANE                           SERIE,             " &
"    CAGEIDDETAIL.CAGEID                   CARGA,             " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                    " &
"         ELSE 'LEVE'                                         " &
"     END                                  TP_TRANSPORTE,     " &
"    ORDERS.C_ZIP                          CEP,               " &
"    whwmd400.t$hght                       ALTURA,            " &
"    whwmd400.t$wdth                       LARGURA,           " &
"    whwmd400.t$dpth                       COMPRIMENTO,       " &
"    SKU.STDNETWGT                         PESO_UNITARIO,     " &
"    SKU.STDGROSSWGT                       PESO_BRUTO,        " &
"    ORDERS.C_CITY                         MUNICIPIO,         " &
"    ORDERS.C_STATE                        ESTADO,            " &
"    ORDERDETAIL.SHIPPEDQTY                QUANTIDADE         " &
"                                                             " &
"FROM       WMWHSE6.ORDERS                                    " &
"INNER JOIN WMWHSE6.ORDERDETAIL                               " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY            " &
"INNER JOIN WMWHSE6.SKU                                       " &
"        ON SKU.SKU = ORDERDETAIL.SKU                         " &
" LEFT JOIN WMWHSE6.WAVEDETAIL                                " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY        " &
" LEFT JOIN WMWHSE6.CAGEIDDETAIL                              " &
"        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY       " &
" LEFT JOIN WMWHSE6.CAGEID                                    " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID               " &
"INNER JOIN WMSADMIN.PL_DB                                    " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID    " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002                  " &
"        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400            " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)         " &
" LEFT JOIN ( SELECT a.ORDERKEY,                          " &
"                    a.ORDERLINENUMBER ,                  " &
"                    max(a.STATUS) STATUS,                " &
"                    max(a.ADDDATE) ADDDATE,              " &
"                    max(a.ADDWHO) ADDWHO                 " &
"               FROM WMWHSE6.ORDERSTATUSHISTORY a         " &
"              WHERE a.ADDDATE = ( select max(b.adddate)  " &
"                                    from WMWHSE6.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY                 " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"           GROUP BY a.ORDERKEY,                                                  " &
"                    a.ORDERLINENUMBER ) ORDERSTATUSHISTORY                       " &
"        ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"       AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS           " &
" LEFT JOIN WMWHSE6.ORDERSTATUSSETUP                                 " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                    " &
" LEFT JOIN WMWHSE6.ORDERSTATUSSETUP ORDERSTATUSSETUP2               " &
"        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS       " &
" LEFT JOIN WMWHSE6.TASKDETAIL                                       " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY               " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" LEFT JOIN ( select distinct                                        " &
"                    q.T$IDCA$C,                                     " &
"                    ZNSLS004.T$ORNO$C                               " &
"               from BAANDB.TZNSLS004301@pln01 ZNSLS004,             " &
"                    BAANDB.TZNSLS400301@pln01 q                     " &
"              where ZNSLS004.T$NCIA$C = q.T$NCIA$C                  " &
"                and ZNSLS004.T$UNEG$C = q.T$UNEG$C                  " &
"                and ZNSLS004.T$PECL$C = q.T$PECL$C                  " &
"                and ZNSLS004.T$SQPD$C = q.T$SQPD$C ) SLS400         " &
"        ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT               " &
"                                                                    " &
"WHERE SLS002.T$TPEN$C IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ")                           " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,    " &       
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataUltEventoDe.Value + "'            " &
"  AND '" + Parameters!DataUltEventoAte.Value + "'                                                     " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ")                   " &
"  AND ORDERS.C_VAT IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"  AND  CASE WHEN CAGEID.STATUS = '5' THEN 'N1'                " &
"            WHEN CAGEID.STATUS = '3' THEN 'N2'                " &
"            WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'N3'    " &
"            WHEN ORDERS.INVOICESTATUS = '4' THEN 'N4'         " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N5'         " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N6'         " &
"            WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'N7'     " &
"            ELSE TO_CHAR(ORDERSTATUSSETUP.CODE)               " &
"        END IN (" + Replace(("'" + JOIN(Parameters!Situacao.Value, "',") + "'"),",",",'") + ")        " &
"                                                           " &
"Union                                                      " &
"                                                           " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.PL_DB.DB_ALIAS               FILIAL,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &    
"                                          DATA_LIMITE,               " &
"    ORDERS.ORDERKEY                       PEDIDO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_REGISTRO,             " &
"    ORDERSTATUSSETUP2.DESCRIPTION         EVENTO,          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"        AT time zone 'America/Sao_Paulo') AS DATE)                       " &
"                                          DATA_ULT_EVENTO,           " &
"    ORDERSTATUSHISTORY.ADDWHO             OPERADOR,        " &
"    ORDERDETAIL.SKU                       ITEM,            " &
"    SKU.DESCR                             NOME_ITEM,       " &
"    SLS400.T$IDCA$C                       CANAL,           " &
"    ORDERS.C_VAT                          MEGA_ROTA,       " &
"    CASE WHEN CAGEID.STATUS = '5' THEN 'Inclusão na Doca / Gaiolas pendente de Expedição'  " &
"         WHEN CAGEID.STATUS = '3' THEN 'Fechamento De Gaiola'                              " &
"         WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'Inclusão De Volume Em Carga'           " &
"         WHEN ORDERS.INVOICESTATUS = '4' THEN 'Final De Conferencia'                       " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Aprovada'                             " &
"         WHEN ORDERS.INVOICESTATUS = '3' THEN 'Danfe Solicitada'                           " &
"         WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'Inclusao No Programa De Coleta'         " &
"         ELSE TO_CHAR(ORDERSTATUSSETUP.DESCRIPTION)          " &
"     END                                  SITUACAO,          " &
"    TASKDETAIL.TASKDETAILKEY              PROGRAMA,          " &
"    WAVEDETAIL.WAVEKEY                    ONDA,              " &
"    ORDERS.CARRIERCODE                    ID_TRANSPORTADORA, " &
"    ORDERS.CARRIERNAME                    TRANSPORTADORA,    " &
"    SLS002.T$TPEN$C                       TIPO_ENTREGA,      " &
"    ORDERS.SUSR1                          NOME_TP_ENT,       " &
"    ORDERS.INVOICENUMBER                  NOTA,              " &
"    ORDERS.LANE                           SERIE,             " &
"    CAGEIDDETAIL.CAGEID                   CARGA,             " &
"    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'                    " &
"         ELSE 'LEVE'                                         " &
"     END                                  TP_TRANSPORTE,     " &
"    ORDERS.C_ZIP                          CEP,               " &
"    whwmd400.t$hght                       ALTURA,            " &
"    whwmd400.t$wdth                       LARGURA,           " &
"    whwmd400.t$dpth                       COMPRIMENTO,       " &
"    SKU.STDNETWGT                         PESO_UNITARIO,     " &
"    SKU.STDGROSSWGT                       PESO_BRUTO,        " &
"    ORDERS.C_CITY                         MUNICIPIO,         " &
"    ORDERS.C_STATE                        ESTADO,            " &
"    ORDERDETAIL.SHIPPEDQTY                QUANTIDADE         " &
"                                                             " &
"FROM       WMWHSE7.ORDERS                                    " &
"INNER JOIN WMWHSE7.ORDERDETAIL                               " &
"        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY            " &
"INNER JOIN WMWHSE7.SKU                                       " &
"        ON SKU.SKU = ORDERDETAIL.SKU                         " &
" LEFT JOIN WMWHSE7.WAVEDETAIL                                " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY        " &
" LEFT JOIN WMWHSE7.CAGEIDDETAIL                              " &
"        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY       " &
" LEFT JOIN WMWHSE7.CAGEID                                    " &
"        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID               " &
"INNER JOIN WMSADMIN.PL_DB                                    " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID    " &
" LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002                  " &
"        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
" LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400            " &
"        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)         " &
" LEFT JOIN ( SELECT a.ORDERKEY,                          " &
"                    a.ORDERLINENUMBER ,                  " &
"                    max(a.STATUS) STATUS,                " &
"                    max(a.ADDDATE) ADDDATE,              " &
"                    max(a.ADDWHO) ADDWHO                 " &
"               FROM WMWHSE7.ORDERSTATUSHISTORY a         " &
"              WHERE a.ADDDATE = ( select max(b.adddate)  " &
"                                    from WMWHSE7.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY                 " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"           GROUP BY a.ORDERKEY,                                                  " &
"                    a.ORDERLINENUMBER ) ORDERSTATUSHISTORY                       " &
"        ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"       AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS           " &
" LEFT JOIN WMWHSE7.ORDERSTATUSSETUP                                 " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                    " &
" LEFT JOIN WMWHSE7.ORDERSTATUSSETUP ORDERSTATUSSETUP2               " &
"        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS       " &
" LEFT JOIN WMWHSE7.TASKDETAIL                                       " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY               " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
" LEFT JOIN ( select distinct                                        " &
"                    q.T$IDCA$C,                                     " &
"                    ZNSLS004.T$ORNO$C                               " &
"               from BAANDB.TZNSLS004301@pln01 ZNSLS004,             " &
"                    BAANDB.TZNSLS400301@pln01 q                     " &
"              where ZNSLS004.T$NCIA$C = q.T$NCIA$C                  " &
"                and ZNSLS004.T$UNEG$C = q.T$UNEG$C                  " &
"                and ZNSLS004.T$PECL$C = q.T$PECL$C                  " &
"                and ZNSLS004.T$SQPD$C = q.T$SQPD$C ) SLS400         " &
"        ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT               " &
"                                                                    " &
"WHERE SLS002.T$TPEN$C IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ")                           " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,    " &       
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!DataUltEventoDe.Value + "'            " &
"  AND '" + Parameters!DataUltEventoAte.Value + "'                                                     " &
"  AND ORDERSTATUSSETUP.CODE IN (" + JOIN(Parameters!ClasseEventos.Value, ", ") + ")                   " &
"  AND ORDERS.C_VAT IN (" + Replace(("'" + JOIN(Parameters!MegaRota.Value, "',") + "'"),",",",'") + ") " &
"  AND  CASE WHEN CAGEID.STATUS = '5' THEN 'N1'                " &
"            WHEN CAGEID.STATUS = '3' THEN 'N2'                " &
"            WHEN CAGEIDDETAIL.CAGEID IS NOT NULL THEN 'N3'    " &
"            WHEN ORDERS.INVOICESTATUS = '4' THEN 'N4'         " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N5'         " &
"            WHEN ORDERS.INVOICESTATUS = '3' THEN 'N6'         " &
"            WHEN WAVEDETAIL.WAVEKEY IS NOT NULL THEN 'N7'     " &
"            ELSE TO_CHAR(ORDERSTATUSSETUP.CODE)               " &
"        END IN (" + Replace(("'" + JOIN(Parameters!Situacao.Value, "',") + "'"),",",",'") + ")        " &
"                                                                                                      " &
"ORDER BY FILIAL, PEDIDO " 