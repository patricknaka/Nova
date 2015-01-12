SELECT  
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone sessiontimezone) AS DATE)
                                  DT_LIMITE,
    ORDERS.ORDERKEY               PEDIDO,
    ZNSLS401.T$UNEG$C             UNINEG,
    ORDERS.SUSR4                  DSC_UNINEG,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone sessiontimezone) AS DATE)
                                  DT_REGISTRO,
  
    HISTORY.ULT_EVENTO,
    HISTORY.EVENTO_NOME,
    HISTORY.DT_ULT_EVENTO,
    HISTORY.OPERADOR,
                  
    ORDERDETAIL.SKU               ID_ITEM,
    SKU.DESCR                     NOME,
    ZNSLS400.T$IDCA$C             CANAL,
    ORDERS.C_VAT                  MEGA_ROTA,  
    ORDERS.STATUS                 SITUACAO,
    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,
    WAVEDETAIL.WAVEKEY            PROGRAMA,
    TASKDETAIL.TASKDETAILKEY      ONDA,
    ORDERS.CARRIERCODE            ID_TRANSP,  
    ORDERS.CARRIERNAME            NOME_TRANSP,    
    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,
    ORDERS.SUSR1                  NOME_TP_ENTREGA,
    ORDERS.INVOICENUMBER          NOTA,
    ORDERS.LANE                   SERIE,
    CAGEIDDETAIL.CAGEID           CARGA,
    CASE WHEN SKU.SUSR2 = 2 
           THEN 'PESADO' 
         ELSE   'LEVE' 
     END                          TP_TRANSPORTE,
    ORDERS.C_ZIP                  CEP

FROM       WMWHSE5.ORDERS

INNER JOIN WMWHSE5.ORDERDETAIL
        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY
    
INNER JOIN WMWHSE5.ORDERSTATUSSETUP
        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS
    
INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = ORDERDETAIL.SKU
    
INNER JOIN WMWHSE5.TASKDETAIL
        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY 
       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER
    
INNER JOIN WMWHSE5.WAVEDETAIL
        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY
    
INNER JOIN WMWHSE5.CAGEIDDETAIL
        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY
    
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID

INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401
        ON ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT 
    
INNER JOIN BAANDB.TZNSLS400301@pln01 znsls400
        ON ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C 
       AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C 
       AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C 
       AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C 

INNER JOIN BAANDB.TZNSLS002301@pln01 znsls002
        ON UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  

INNER JOIN ( select A.ORDERKEY,
                    A.STATUS        ULT_EVENTO,
                    B.DESCRIPTION   EVENTO_NOME,
                    A.ADDDATE       DT_ULT_EVENTO,
                    A.ADDWHO        OPERADOR
               from WMWHSE5.ORDERSTATUSHISTORY  A,
                    WMWHSE5.ORDERSTATUSSETUP    B
              where A.ADDDATE = ( select max(A1.ADDDATE) 
                                    from WMWHSE5.ORDERSTATUSHISTORY  A1
                                   where A1.ORDERKEY = A.ORDERKEY )
                and B.CODE = A.STATUS ) HISTORY
        ON HISTORY.ORDERKEY = ORDERS.ORDERKEY
    
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone sessiontimezone) AS DATE))
  Between :DataLimiteDe
      AND :DataLimiteAte

ORDER BY ORDERS.ORDERKEY


"SELECT                                                                                         " &
"  DISTINCT                                                                                     " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                                                      " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                             " &
"         AT time zone sessiontimezone) AS DATE)                                                " &
"                                  DT_LIMITE,                                                   " &
"    ORDERS.ORDERKEY               PEDIDO,                                                      " &
"    ZNSLS401.T$UNEG$C             UNINEG,                                                      " &
"    ORDERS.SUSR4                  DSC_UNINEG,                                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                                         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                             " &
"         AT time zone sessiontimezone) AS DATE)                                                " &
"                                  DT_REGISTRO,                                                 " &
"                                                                                               " &
"    HISTORY.ULT_EVENTO,                                                                        " &
"    HISTORY.EVENTO_NOME,                                                                       " &
"    HISTORY.DT_ULT_EVENTO,                                                                     " &
"    HISTORY.OPERADOR,                                                                          " &
"                                                                                               " &
"    ORDERDETAIL.SKU               ID_ITEM,                                                     " &
"    SKU.DESCR                     NOME,                                                        " &
"    ZNSLS400.T$IDCA$C             CANAL,                                                       " &
"    ORDERS.C_VAT                  MEGA_ROTA,                                                   " &
"    ORDERS.STATUS                 SITUACAO,                                                    " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                                              " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                                                    " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                                                        " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                                                   " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                                                 " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                                               " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                                             " &
"    ORDERS.INVOICENUMBER          NOTA,                                                        " &
"    ORDERS.LANE                   SERIE,                                                       " &
"    CAGEIDDETAIL.CAGEID           CARGA,                                                       " &
"    CASE WHEN SKU.SUSR2 = 2                                                                    " &
"           THEN 'PESADO'                                                                       " &
"         ELSE   'LEVE'                                                                         " &
"     END                          TP_TRANSPORTE,                                               " &
"    ORDERS.C_ZIP                  CEP                                                          " &
"                                                                                               " &
"FROM       " + Parameters!Table.Value + ".ORDERS                                               " &
"                                                                                               " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERDETAIL                                          " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                              " &
"                                                                                               " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP                                     " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                               " &
"                                                                                               " &
"INNER JOIN " + Parameters!Table.Value + ".SKU                                                  " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                                           " &
"                                                                                               " &
"INNER JOIN " + Parameters!Table.Value + ".TASKDETAIL                                           " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                            " &
"                                                                                               " &
"INNER JOIN " + Parameters!Table.Value + ".WAVEDETAIL                                           " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"                                                                                               " &
"INNER JOIN " + Parameters!Table.Value + ".CAGEIDDETAIL                                         " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                              " &
"                                                                                               " &
"INNER JOIN WMSADMIN.PL_DB                                                                      " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                      " &
"                                                                                               " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401                                                  " &
"        ON ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                        " &
"                                                                                               " &
"INNER JOIN BAANDB.TZNSLS400301@pln01 znsls400                                                  " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                                               " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                                               " &
"       AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                                               " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                                               " &
"                                                                                               " &
"INNER JOIN BAANDB.TZNSLS002301@pln01 znsls002                                                  " &
"        ON UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))                          " &
"                                                                                               " &
"INNER JOIN ( select A.ORDERKEY,                                                                " &
"                    A.STATUS        ULT_EVENTO,                                                " &
"                    B.DESCRIPTION   EVENTO_NOME,                                               " &
"                    A.ADDDATE       DT_ULT_EVENTO,                                             " &
"                    A.ADDWHO        OPERADOR                                                   " &
"               from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A,                      " &
"                    " + Parameters!Table.Value + ".ORDERSTATUSSETUP    B                       " &
"              where A.ADDDATE = ( select max(A1.ADDDATE)                                       " &
"                                    from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1 " &
"                                   where A1.ORDERKEY = A.ORDERKEY )                            " &
"                and B.CODE = A.STATUS ) HISTORY                                                " &
"        ON HISTORY.ORDERKEY = ORDERS.ORDERKEY                                                  " &
"                                                                                               " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,                       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                             " &
"         AT time zone sessiontimezone) AS DATE))                                               " &
"  Between '" + Parameters!DataLimiteDe.Value + "'                                              " &
"      AND '" + Parameters!DataLimiteAte.Value + "'                                             " &
"                                                                                               " &
"ORDER BY ORDERS.ORDERKEY                                                                       "

-- Query com UNION ********************************************************************************

"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_LIMITE,                             " &
"    ORDERS.ORDERKEY               PEDIDO,                                " &
"    ZNSLS401.T$UNEG$C             UNINEG,                                " &
"    ORDERS.SUSR4                  DSC_UNINEG,                            " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_REGISTRO,                           " &
"                                                                         " &
"    HISTORY.ULT_EVENTO,                                                  " &
"    HISTORY.EVENTO_NOME,                                                 " &
"    HISTORY.DT_ULT_EVENTO,                                               " &
"    HISTORY.OPERADOR,                                                    " &
"                                                                         " &
"    ORDERDETAIL.SKU               ID_ITEM,                               " &
"    SKU.DESCR                     NOME,                                  " &
"    ZNSLS400.T$IDCA$C             CANAL,                                 " &
"    ORDERS.C_VAT                  MEGA_ROTA,                             " &
"    ORDERS.STATUS                 SITUACAO,                              " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                        " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                              " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                                  " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                             " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                           " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                         " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                       " &
"    ORDERS.INVOICENUMBER          NOTA,                                  " &
"    ORDERS.LANE                   SERIE,                                 " &
"    CAGEIDDETAIL.CAGEID           CARGA,                                 " &
"    CASE WHEN SKU.SUSR2 = 2                                              " &
"           THEN 'PESADO'                                                 " &
"         ELSE   'LEVE'                                                   " &
"     END                          TP_TRANSPORTE,                         " &
"    ORDERS.C_ZIP                  CEP                                    " &
"                                                                         " &
"FROM       WMWHSE1.ORDERS                                                " &
"                                                                         " &
"INNER JOIN WMWHSE1.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMWHSE1.ORDERSTATUSSETUP                                      " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                         " &
"                                                                         " &
"INNER JOIN WMWHSE1.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMWHSE1.TASKDETAIL                                            " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"                                                                         " &
"INNER JOIN WMWHSE1.WAVEDETAIL                                            " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"                                                                         " &
"INNER JOIN WMWHSE1.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401                            " &
"        ON ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS400301@pln01 znsls400                            " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                         " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                         " &
"       AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                         " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                         " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS002301@pln01 znsls002                            " &
"        ON UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
"                                                                         " &
"INNER JOIN ( select A.ORDERKEY,                                          " &
"                    A.STATUS        ULT_EVENTO,                          " &
"                    B.DESCRIPTION   EVENTO_NOME,                         " &
"                    A.ADDDATE       DT_ULT_EVENTO,                       " &
"                    A.ADDWHO        OPERADOR                             " &
"               from WMWHSE1.ORDERSTATUSHISTORY  A,                       " &
"                    WMWHSE1.ORDERSTATUSSETUP    B                        " &
"              where A.ADDDATE = ( select max(A1.ADDDATE)                 " &
"                                    from WMWHSE1.ORDERSTATUSHISTORY  A1  " &
"                                   where A1.ORDERKEY = A.ORDERKEY )      " &
"                and B.CODE = A.STATUS ) HISTORY                          " &
"        ON HISTORY.ORDERKEY = ORDERS.ORDERKEY                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE))                         " &
"  Between '" + Parameters!DataLimiteDe.Value + "'                        " &
"      AND '" + Parameters!DataLimiteAte.Value + "'                       " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_LIMITE,                             " &
"    ORDERS.ORDERKEY               PEDIDO,                                " &
"    ZNSLS401.T$UNEG$C             UNINEG,                                " &
"    ORDERS.SUSR4                  DSC_UNINEG,                            " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_REGISTRO,                           " &
"                                                                         " &
"    HISTORY.ULT_EVENTO,                                                  " &
"    HISTORY.EVENTO_NOME,                                                 " &
"    HISTORY.DT_ULT_EVENTO,                                               " &
"    HISTORY.OPERADOR,                                                    " &
"                                                                         " &
"    ORDERDETAIL.SKU               ID_ITEM,                               " &
"    SKU.DESCR                     NOME,                                  " &
"    ZNSLS400.T$IDCA$C             CANAL,                                 " &
"    ORDERS.C_VAT                  MEGA_ROTA,                             " &
"    ORDERS.STATUS                 SITUACAO,                              " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                        " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                              " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                                  " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                             " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                           " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                         " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                       " &
"    ORDERS.INVOICENUMBER          NOTA,                                  " &
"    ORDERS.LANE                   SERIE,                                 " &
"    CAGEIDDETAIL.CAGEID           CARGA,                                 " &
"    CASE WHEN SKU.SUSR2 = 2                                              " &
"           THEN 'PESADO'                                                 " &
"         ELSE   'LEVE'                                                   " &
"     END                          TP_TRANSPORTE,                         " &
"    ORDERS.C_ZIP                  CEP                                    " &
"                                                                         " &
"FROM       WMWHSE2.ORDERS                                                " &
"                                                                         " &
"INNER JOIN WMWHSE2.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMWHSE2.ORDERSTATUSSETUP                                      " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                         " &
"                                                                         " &
"INNER JOIN WMWHSE2.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMWHSE2.TASKDETAIL                                            " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"                                                                         " &
"INNER JOIN WMWHSE2.WAVEDETAIL                                            " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"                                                                         " &
"INNER JOIN WMWHSE2.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401                            " &
"        ON ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS400301@pln01 znsls400                            " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                         " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                         " &
"       AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                         " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                         " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS002301@pln01 znsls002                            " &
"        ON UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
"                                                                         " &
"INNER JOIN ( select A.ORDERKEY,                                          " &
"                    A.STATUS        ULT_EVENTO,                          " &
"                    B.DESCRIPTION   EVENTO_NOME,                         " &
"                    A.ADDDATE       DT_ULT_EVENTO,                       " &
"                    A.ADDWHO        OPERADOR                             " &
"               from WMWHSE2.ORDERSTATUSHISTORY  A,                       " &
"                    WMWHSE2.ORDERSTATUSSETUP    B                        " &
"              where A.ADDDATE = ( select max(A1.ADDDATE)                 " &
"                                    from WMWHSE2.ORDERSTATUSHISTORY  A1  " &
"                                   where A1.ORDERKEY = A.ORDERKEY )      " &
"                and B.CODE = A.STATUS ) HISTORY                          " &
"        ON HISTORY.ORDERKEY = ORDERS.ORDERKEY                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE))                         " &
"  Between '" + Parameters!DataLimiteDe.Value + "'                        " &
"      AND '" + Parameters!DataLimiteAte.Value + "'                       " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_LIMITE,                             " &
"    ORDERS.ORDERKEY               PEDIDO,                                " &
"    ZNSLS401.T$UNEG$C             UNINEG,                                " &
"    ORDERS.SUSR4                  DSC_UNINEG,                            " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_REGISTRO,                           " &
"                                                                         " &
"    HISTORY.ULT_EVENTO,                                                  " &
"    HISTORY.EVENTO_NOME,                                                 " &
"    HISTORY.DT_ULT_EVENTO,                                               " &
"    HISTORY.OPERADOR,                                                    " &
"                                                                         " &
"    ORDERDETAIL.SKU               ID_ITEM,                               " &
"    SKU.DESCR                     NOME,                                  " &
"    ZNSLS400.T$IDCA$C             CANAL,                                 " &
"    ORDERS.C_VAT                  MEGA_ROTA,                             " &
"    ORDERS.STATUS                 SITUACAO,                              " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                        " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                              " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                                  " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                             " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                           " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                         " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                       " &
"    ORDERS.INVOICENUMBER          NOTA,                                  " &
"    ORDERS.LANE                   SERIE,                                 " &
"    CAGEIDDETAIL.CAGEID           CARGA,                                 " &
"    CASE WHEN SKU.SUSR2 = 2                                              " &
"           THEN 'PESADO'                                                 " &
"         ELSE   'LEVE'                                                   " &
"     END                          TP_TRANSPORTE,                         " &
"    ORDERS.C_ZIP                  CEP                                    " &
"                                                                         " &
"FROM       WMWHSE3.ORDERS                                                " &
"                                                                         " &
"INNER JOIN WMWHSE3.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMWHSE3.ORDERSTATUSSETUP                                      " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                         " &
"                                                                         " &
"INNER JOIN WMWHSE3.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMWHSE3.TASKDETAIL                                            " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"                                                                         " &
"INNER JOIN WMWHSE3.WAVEDETAIL                                            " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"                                                                         " &
"INNER JOIN WMWHSE3.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401                            " &
"        ON ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS400301@pln01 znsls400                            " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                         " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                         " &
"       AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                         " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                         " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS002301@pln01 znsls002                            " &
"        ON UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
"                                                                         " &
"INNER JOIN ( select A.ORDERKEY,                                          " &
"                    A.STATUS        ULT_EVENTO,                          " &
"                    B.DESCRIPTION   EVENTO_NOME,                         " &
"                    A.ADDDATE       DT_ULT_EVENTO,                       " &
"                    A.ADDWHO        OPERADOR                             " &
"               from WMWHSE3.ORDERSTATUSHISTORY  A,                       " &
"                    WMWHSE3.ORDERSTATUSSETUP    B                        " &
"              where A.ADDDATE = ( select max(A1.ADDDATE)                 " &
"                                    from WMWHSE3.ORDERSTATUSHISTORY  A1  " &
"                                   where A1.ORDERKEY = A.ORDERKEY )      " &
"                and B.CODE = A.STATUS ) HISTORY                          " &
"        ON HISTORY.ORDERKEY = ORDERS.ORDERKEY                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE))                         " &
"  Between '" + Parameters!DataLimiteDe.Value + "'                        " &
"      AND '" + Parameters!DataLimiteAte.Value + "'                       " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_LIMITE,                             " &
"    ORDERS.ORDERKEY               PEDIDO,                                " &
"    ZNSLS401.T$UNEG$C             UNINEG,                                " &
"    ORDERS.SUSR4                  DSC_UNINEG,                            " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_REGISTRO,                           " &
"                                                                         " &
"    HISTORY.ULT_EVENTO,                                                  " &
"    HISTORY.EVENTO_NOME,                                                 " &
"    HISTORY.DT_ULT_EVENTO,                                               " &
"    HISTORY.OPERADOR,                                                    " &
"                                                                         " &
"    ORDERDETAIL.SKU               ID_ITEM,                               " &
"    SKU.DESCR                     NOME,                                  " &
"    ZNSLS400.T$IDCA$C             CANAL,                                 " &
"    ORDERS.C_VAT                  MEGA_ROTA,                             " &
"    ORDERS.STATUS                 SITUACAO,                              " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                        " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                              " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                                  " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                             " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                           " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                         " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                       " &
"    ORDERS.INVOICENUMBER          NOTA,                                  " &
"    ORDERS.LANE                   SERIE,                                 " &
"    CAGEIDDETAIL.CAGEID           CARGA,                                 " &
"    CASE WHEN SKU.SUSR2 = 2                                              " &
"           THEN 'PESADO'                                                 " &
"         ELSE   'LEVE'                                                   " &
"     END                          TP_TRANSPORTE,                         " &
"    ORDERS.C_ZIP                  CEP                                    " &
"                                                                         " &
"FROM       WMWHSE4.ORDERS                                                " &
"                                                                         " &
"INNER JOIN WMWHSE4.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMWHSE4.ORDERSTATUSSETUP                                      " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                         " &
"                                                                         " &
"INNER JOIN WMWHSE4.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMWHSE4.TASKDETAIL                                            " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"                                                                         " &
"INNER JOIN WMWHSE4.WAVEDETAIL                                            " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"                                                                         " &
"INNER JOIN WMWHSE4.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401                            " &
"        ON ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS400301@pln01 znsls400                            " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                         " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                         " &
"       AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                         " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                         " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS002301@pln01 znsls002                            " &
"        ON UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
"                                                                         " &
"INNER JOIN ( select A.ORDERKEY,                                          " &
"                    A.STATUS        ULT_EVENTO,                          " &
"                    B.DESCRIPTION   EVENTO_NOME,                         " &
"                    A.ADDDATE       DT_ULT_EVENTO,                       " &
"                    A.ADDWHO        OPERADOR                             " &
"               from WMWHSE4.ORDERSTATUSHISTORY  A,                       " &
"                    WMWHSE4.ORDERSTATUSSETUP    B                        " &
"              where A.ADDDATE = ( select max(A1.ADDDATE)                 " &
"                                    from WMWHSE4.ORDERSTATUSHISTORY  A1  " &
"                                   where A1.ORDERKEY = A.ORDERKEY )      " &
"                and B.CODE = A.STATUS ) HISTORY                          " &
"        ON HISTORY.ORDERKEY = ORDERS.ORDERKEY                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE))                         " &
"  Between '" + Parameters!DataLimiteDe.Value + "'                        " &
"      AND '" + Parameters!DataLimiteAte.Value + "'                       " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_LIMITE,                             " &
"    ORDERS.ORDERKEY               PEDIDO,                                " &
"    ZNSLS401.T$UNEG$C             UNINEG,                                " &
"    ORDERS.SUSR4                  DSC_UNINEG,                            " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_REGISTRO,                           " &
"                                                                         " &
"    HISTORY.ULT_EVENTO,                                                  " &
"    HISTORY.EVENTO_NOME,                                                 " &
"    HISTORY.DT_ULT_EVENTO,                                               " &
"    HISTORY.OPERADOR,                                                    " &
"                                                                         " &
"    ORDERDETAIL.SKU               ID_ITEM,                               " &
"    SKU.DESCR                     NOME,                                  " &
"    ZNSLS400.T$IDCA$C             CANAL,                                 " &
"    ORDERS.C_VAT                  MEGA_ROTA,                             " &
"    ORDERS.STATUS                 SITUACAO,                              " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                        " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                              " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                                  " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                             " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                           " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                         " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                       " &
"    ORDERS.INVOICENUMBER          NOTA,                                  " &
"    ORDERS.LANE                   SERIE,                                 " &
"    CAGEIDDETAIL.CAGEID           CARGA,                                 " &
"    CASE WHEN SKU.SUSR2 = 2                                              " &
"           THEN 'PESADO'                                                 " &
"         ELSE   'LEVE'                                                   " &
"     END                          TP_TRANSPORTE,                         " &
"    ORDERS.C_ZIP                  CEP                                    " &
"                                                                         " &
"FROM       WMWHSE5.ORDERS                                                " &
"                                                                         " &
"INNER JOIN WMWHSE5.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMWHSE5.ORDERSTATUSSETUP                                      " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                         " &
"                                                                         " &
"INNER JOIN WMWHSE5.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMWHSE5.TASKDETAIL                                            " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"                                                                         " &
"INNER JOIN WMWHSE5.WAVEDETAIL                                            " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"                                                                         " &
"INNER JOIN WMWHSE5.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401                            " &
"        ON ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS400301@pln01 znsls400                            " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                         " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                         " &
"       AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                         " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                         " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS002301@pln01 znsls002                            " &
"        ON UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
"                                                                         " &
"INNER JOIN ( select A.ORDERKEY,                                          " &
"                    A.STATUS        ULT_EVENTO,                          " &
"                    B.DESCRIPTION   EVENTO_NOME,                         " &
"                    A.ADDDATE       DT_ULT_EVENTO,                       " &
"                    A.ADDWHO        OPERADOR                             " &
"               from WMWHSE5.ORDERSTATUSHISTORY  A,                       " &
"                    WMWHSE5.ORDERSTATUSSETUP    B                        " &
"              where A.ADDDATE = ( select max(A1.ADDDATE)                 " &
"                                    from WMWHSE5.ORDERSTATUSHISTORY  A1  " &
"                                   where A1.ORDERKEY = A.ORDERKEY )      " &
"                and B.CODE = A.STATUS ) HISTORY                          " &
"        ON HISTORY.ORDERKEY = ORDERS.ORDERKEY                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE))                         " &
"  Between '" + Parameters!DataLimiteDe.Value + "'                        " &
"      AND '" + Parameters!DataLimiteAte.Value + "'                       " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_LIMITE,                             " &
"    ORDERS.ORDERKEY               PEDIDO,                                " &
"    ZNSLS401.T$UNEG$C             UNINEG,                                " &
"    ORDERS.SUSR4                  DSC_UNINEG,                            " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_REGISTRO,                           " &
"                                                                         " &
"    HISTORY.ULT_EVENTO,                                                  " &
"    HISTORY.EVENTO_NOME,                                                 " &
"    HISTORY.DT_ULT_EVENTO,                                               " &
"    HISTORY.OPERADOR,                                                    " &
"                                                                         " &
"    ORDERDETAIL.SKU               ID_ITEM,                               " &
"    SKU.DESCR                     NOME,                                  " &
"    ZNSLS400.T$IDCA$C             CANAL,                                 " &
"    ORDERS.C_VAT                  MEGA_ROTA,                             " &
"    ORDERS.STATUS                 SITUACAO,                              " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                        " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                              " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                                  " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                             " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                           " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                         " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                       " &
"    ORDERS.INVOICENUMBER          NOTA,                                  " &
"    ORDERS.LANE                   SERIE,                                 " &
"    CAGEIDDETAIL.CAGEID           CARGA,                                 " &
"    CASE WHEN SKU.SUSR2 = 2                                              " &
"           THEN 'PESADO'                                                 " &
"         ELSE   'LEVE'                                                   " &
"     END                          TP_TRANSPORTE,                         " &
"    ORDERS.C_ZIP                  CEP                                    " &
"                                                                         " &
"FROM       WMWHSE6.ORDERS                                                " &
"                                                                         " &
"INNER JOIN WMWHSE6.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMWHSE6.ORDERSTATUSSETUP                                      " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                         " &
"                                                                         " &
"INNER JOIN WMWHSE6.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMWHSE6.TASKDETAIL                                            " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"                                                                         " &
"INNER JOIN WMWHSE6.WAVEDETAIL                                            " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"                                                                         " &
"INNER JOIN WMWHSE6.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401                            " &
"        ON ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS400301@pln01 znsls400                            " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                         " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                         " &
"       AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                         " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                         " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS002301@pln01 znsls002                            " &
"        ON UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
"                                                                         " &
"INNER JOIN ( select A.ORDERKEY,                                          " &
"                    A.STATUS        ULT_EVENTO,                          " &
"                    B.DESCRIPTION   EVENTO_NOME,                         " &
"                    A.ADDDATE       DT_ULT_EVENTO,                       " &
"                    A.ADDWHO        OPERADOR                             " &
"               from WMWHSE6.ORDERSTATUSHISTORY  A,                       " &
"                    WMWHSE6.ORDERSTATUSSETUP    B                        " &
"              where A.ADDDATE = ( select max(A1.ADDDATE)                 " &
"                                    from WMWHSE6.ORDERSTATUSHISTORY  A1  " &
"                                   where A1.ORDERKEY = A.ORDERKEY )      " &
"                and B.CODE = A.STATUS ) HISTORY                          " &
"        ON HISTORY.ORDERKEY = ORDERS.ORDERKEY                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE))                         " &
"  Between '" + Parameters!DataLimiteDe.Value + "'                        " &
"      AND '" + Parameters!DataLimiteAte.Value + "'                       " &
"                                                                         " &
"Union                                                                    " &
"                                                                         " &
"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_LIMITE,                             " &
"    ORDERS.ORDERKEY               PEDIDO,                                " &
"    ZNSLS401.T$UNEG$C             UNINEG,                                " &
"    ORDERS.SUSR4                  DSC_UNINEG,                            " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE)                          " &
"                                  DT_REGISTRO,                           " &
"                                                                         " &
"    HISTORY.ULT_EVENTO,                                                  " &
"    HISTORY.EVENTO_NOME,                                                 " &
"    HISTORY.DT_ULT_EVENTO,                                               " &
"    HISTORY.OPERADOR,                                                    " &
"                                                                         " &
"    ORDERDETAIL.SKU               ID_ITEM,                               " &
"    SKU.DESCR                     NOME,                                  " &
"    ZNSLS400.T$IDCA$C             CANAL,                                 " &
"    ORDERS.C_VAT                  MEGA_ROTA,                             " &
"    ORDERS.STATUS                 SITUACAO,                              " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                        " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                              " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                                  " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                             " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                           " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                         " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                       " &
"    ORDERS.INVOICENUMBER          NOTA,                                  " &
"    ORDERS.LANE                   SERIE,                                 " &
"    CAGEIDDETAIL.CAGEID           CARGA,                                 " &
"    CASE WHEN SKU.SUSR2 = 2                                              " &
"           THEN 'PESADO'                                                 " &
"         ELSE   'LEVE'                                                   " &
"     END                          TP_TRANSPORTE,                         " &
"    ORDERS.C_ZIP                  CEP                                    " &
"                                                                         " &
"FROM       WMWHSE7.ORDERS                                                " &
"                                                                         " &
"INNER JOIN WMWHSE7.ORDERDETAIL                                           " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMWHSE7.ORDERSTATUSSETUP                                      " &
"        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS                         " &
"                                                                         " &
"INNER JOIN WMWHSE7.SKU                                                   " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                     " &
"                                                                         " &
"INNER JOIN WMWHSE7.TASKDETAIL                                            " &
"        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER      " &
"                                                                         " &
"INNER JOIN WMWHSE7.WAVEDETAIL                                            " &
"        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                    " &
"                                                                         " &
"INNER JOIN WMWHSE7.CAGEIDDETAIL                                          " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
"                                                                         " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS401301@pln01 znsls401                            " &
"        ON ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS400301@pln01 znsls400                            " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                         " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                         " &
"       AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                         " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                         " &
"                                                                         " &
"INNER JOIN BAANDB.TZNSLS002301@pln01 znsls002                            " &
"        ON UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))    " &
"                                                                         " &
"INNER JOIN ( select A.ORDERKEY,                                          " &
"                    A.STATUS        ULT_EVENTO,                          " &
"                    B.DESCRIPTION   EVENTO_NOME,                         " &
"                    A.ADDDATE       DT_ULT_EVENTO,                       " &
"                    A.ADDWHO        OPERADOR                             " &
"               from WMWHSE7.ORDERSTATUSHISTORY  A,                       " &
"                    WMWHSE7.ORDERSTATUSSETUP    B                        " &
"              where A.ADDDATE = ( select max(A1.ADDDATE)                 " &
"                                    from WMWHSE7.ORDERSTATUSHISTORY  A1  " &
"                                   where A1.ORDERKEY = A.ORDERKEY )      " &
"                and B.CODE = A.STATUS ) HISTORY                          " &
"        ON HISTORY.ORDERKEY = ORDERS.ORDERKEY                            " &
"                                                                         " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"         AT time zone sessiontimezone) AS DATE))                         " &
"  Between '" + Parameters!DataLimiteDe.Value + "'                        " &
"      AND '" + Parameters!DataLimiteAte.Value + "'                       " &
"                                                                         " &
"ORDER BY FILIAL, PEDIDO                                                  "