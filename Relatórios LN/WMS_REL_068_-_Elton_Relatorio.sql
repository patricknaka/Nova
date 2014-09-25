SELECT  
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,
    ORDERS.SCHEDULEDSHIPDATE      DT_LIMITE,
    ORDERS.ORDERKEY               PEDIDO,
    ZNSLS401.T$UNEG$C             UNINEG,
    ORDERS.SUSR4                  DSC_UNINEG,
    ORDERS.ADDDATE                DT_REGISTRO,    
    ( select A.STATUS
        from WMWHSE4.ORDERSTATUSHISTORY  A
       where A.ADDDATE = ( select max(A1.ADDDATE) 
                             from WMWHSE4.ORDERSTATUSHISTORY  A1
                            where A1.ORDERKEY = A.ORDERKEY )
                              and A.ORDERKEY = ORDERS.ORDERKEY
                              and rownum = 1 )
                                  ULT_EVENTO,
    ( select B.DESCRIPTION
        from WMWHSE4.ORDERSTATUSHISTORY  A,
             WMWHSE4.ORDERSTATUSSETUP    B
      where  A.ADDDATE = ( select max(A1.ADDDATE) 
                             from WMWHSE4.ORDERSTATUSHISTORY  A1
                            where A1.ORDERKEY = A.ORDERKEY )
                              and A.ORDERKEY = ORDERS.ORDERKEY
                              and B.CODE = A.STATUS
                              and rownum = 1 )
                                  EVENTO_NOME,
    ( select A.ADDDATE
        from WMWHSE4.ORDERSTATUSHISTORY  A
       where A.ADDDATE = ( select max(A1.ADDDATE) 
                             from WMWHSE4.ORDERSTATUSHISTORY  A1
                            where A1.ORDERKEY = A.ORDERKEY )
                              and A.ORDERKEY = ORDERS.ORDERKEY
                              and rownum = 1 )
                                  DT_ULT_EVENTO,
    ( select A.ADDWHO
        from WMWHSE4.ORDERSTATUSHISTORY  A
       where A.ADDDATE = ( select max(A1.ADDDATE) 
                             from WMWHSE4.ORDERSTATUSHISTORY  A1
                            where A1.ORDERKEY = A.ORDERKEY )
                              and A.ORDERKEY = ORDERS.ORDERKEY
                              and rownum = 1 )
                                  OPERADOR,
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

FROM WMWHSE4.ORDERS, 
     WMWHSE4.ORDERDETAIL, 
     WMWHSE4.ORDERSTATUSHISTORY, 
     WMWHSE4.ORDERSTATUSSETUP,
     WMWHSE4.ORDERSTATUSSETUP ORDERSTATUSSETUP2, 
     WMWHSE4.SKU, 
     WMWHSE4.TASKDETAIL,
     WMWHSE4.WAVEDETAIL,
     WMWHSE4.CAGEIDDETAIL,
     WMSADMIN.PL_DB,
     BAANDB.TZNSLS400201@dln01 znsls400,
     BAANDB.TZNSLS401201@dln01 znsls401,
     BAANDB.TZNSLS002201@dln01 znsls002,
     BAANDB.TWHWMD400201@dln01 whwmd400
     
WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY 
  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY 
  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER 
  AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS 
  AND ORDERSTATUSSETUP.CODE = ORDERS.STATUS
  AND ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS  
  AND SKU.SKU = ORDERDETAIL.SKU 
  AND TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY 
  AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER 
  AND WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY 
  AND CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY 
  AND ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT 
  AND ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C 
  AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C 
  AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C 
  AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C 
  AND UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  
  AND RTRIM(LTRIM(whwmd400.t$item)) = RTRIM(LTRIM(SKU.SKU)) 
  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID
  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between :DataLimiteDe
  AND :DataLimiteAte

ORDER BY ORDERS.ORDERKEY


"SELECT                                                                                    " &
"  DISTINCT                                                                                " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                                                 " &
"    ORDERS.SCHEDULEDSHIPDATE      DT_LIMITE,                                              " &
"    ORDERS.ORDERKEY               PEDIDO,                                                 " &
"    ZNSLS401.T$UNEG$C             UNINEG,                                                 " &
"    ORDERS.SUSR4                  DSC_UNINEG,                                             " &
"    ORDERS.ADDDATE                DT_REGISTRO,                                            " &
"    ( select A.STATUS                                                                     " &
"        from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                                         " &
"                             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )                              " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY                            " &
"                              and rownum = 1 )                                            " &
"                                  ULT_EVENTO,                                             " &
"    ( select B.DESCRIPTION                                                                " &
"        from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A,                        " &
"             " + Parameters!Table.Value + ".ORDERSTATUSSETUP    B                         " &
"      where  A.ADDDATE = ( select max(A1.ADDDATE)                                         " &
"                             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )                              " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY                            " &
"                              and B.CODE = A.STATUS                                       " &
"                              and rownum = 1 )                                            " &
"                                  EVENTO_NOME,                                            " &
"    ( select A.ADDDATE                                                                    " &
"        from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                                         " &
"                             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )                              " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY                            " &
"                              and rownum = 1 )                                            " &
"                                  DT_ULT_EVENTO,                                          " &
"    ( select A.ADDWHO                                                                     " &
"        from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                                         " &
"                             from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )                              " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY                            " &
"                              and rownum = 1 )                                            " &
"                                  OPERADOR,                                               " &
"    ORDERDETAIL.SKU               ID_ITEM,                                                " &
"    SKU.DESCR                     NOME,                                                   " &
"    ZNSLS400.T$IDCA$C             CANAL,                                                  " &
"    ORDERS.C_VAT                  MEGA_ROTA,                                              " &
"    ORDERS.STATUS                 SITUACAO,                                               " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                                         " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                                               " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                                                   " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                                              " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                                            " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                                          " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                                        " &
"    ORDERS.INVOICENUMBER          NOTA,                                                   " &
"    ORDERS.LANE                   SERIE,                                                  " &
"    CAGEIDDETAIL.CAGEID           CARGA,                                                  " &
"    CASE WHEN SKU.SUSR2 = 2                                                               " &
"           THEN 'PESADO'                                                                  " &
"         ELSE   'LEVE'                                                                    " &
"     END                          TP_TRANSPORTE,                                          " &
"    ORDERS.C_ZIP                  CEP                                                     " &
"                                                                                          " &
"FROM " + Parameters!Table.Value + ".ORDERS,                                               " &
"     " + Parameters!Table.Value + ".ORDERDETAIL,                                          " &
"     " + Parameters!Table.Value + ".ORDERSTATUSHISTORY,                                   " &
"     " + Parameters!Table.Value + ".ORDERSTATUSSETUP,                                     " &
"     " + Parameters!Table.Value + ".ORDERSTATUSSETUP ORDERSTATUSSETUP2,                   " &
"     " + Parameters!Table.Value + ".SKU,                                                  " &
"     " + Parameters!Table.Value + ".TASKDETAIL,                                           " &
"     " + Parameters!Table.Value + ".WAVEDETAIL,                                           " &
"     " + Parameters!Table.Value + ".CAGEIDDETAIL,                                         " &
"     WMSADMIN.PL_DB,                                                                      " &
"     BAANDB.TZNSLS400201@dln01 znsls400,                                                  " &
"     BAANDB.TZNSLS401201@dln01 znsls401,                                                  " &
"     BAANDB.TZNSLS002201@dln01 znsls002,                                                  " &
"     BAANDB.TWHWMD400201@dln01 whwmd400                                                   " &
"                                                                                          " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                              " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                  " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                    " &
"  AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS                                      " &
"  AND ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                               " &
"  AND ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS                                  " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                           " &
"  AND TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                            " &
"  AND WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                              " &
"  AND ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                        " &
"  AND ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                                               " &
"  AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                                               " &
"  AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                                               " &
"  AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                                               " &
"  AND UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))                          " &
"  AND RTRIM(LTRIM(whwmd400.t$item)) = RTRIM(LTRIM(SKU.SKU))                               " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                      " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'     " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                            " &
"                                                                                          " &
"ORDER BY ORDERS.ORDERKEY                                                                  "

-- Query com UNION ***************************************************************************

"SELECT                                                             " &
"  DISTINCT                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                          " &
"    ORDERS.SCHEDULEDSHIPDATE      DT_LIMITE,                       " &
"    ORDERS.ORDERKEY               PEDIDO,                          " &
"    ZNSLS401.T$UNEG$C             UNINEG,                          " &
"    ORDERS.SUSR4                  DSC_UNINEG,                      " &
"    ORDERS.ADDDATE                DT_REGISTRO,                     " &
"    ( select A.STATUS                                              " &
"        from WMWHSE1.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE1.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  ULT_EVENTO,                      " &
"    ( select B.DESCRIPTION                                         " &
"        from WMWHSE1.ORDERSTATUSHISTORY  A,                        " &
"             WMWHSE1.ORDERSTATUSSETUP    B                         " &
"      where  A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE1.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and B.CODE = A.STATUS                " &
"                              and rownum = 1 )                     " &
"                                  EVENTO_NOME,                     " &
"    ( select A.ADDDATE                                             " &
"        from WMWHSE1.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE1.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  DT_ULT_EVENTO,                   " &
"    ( select A.ADDWHO                                              " &
"        from WMWHSE1.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE1.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  OPERADOR,                        " &
"    ORDERDETAIL.SKU               ID_ITEM,                         " &
"    SKU.DESCR                     NOME,                            " &
"    ZNSLS400.T$IDCA$C             CANAL,                           " &
"    ORDERS.C_VAT                  MEGA_ROTA,                       " &
"    ORDERS.STATUS                 SITUACAO,                        " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                  " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                        " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                            " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                       " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                     " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                   " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                 " &
"    ORDERS.INVOICENUMBER          NOTA,                            " &
"    ORDERS.LANE                   SERIE,                           " &
"    CAGEIDDETAIL.CAGEID           CARGA,                           " &
"    CASE WHEN SKU.SUSR2 = 2                                        " &
"           THEN 'PESADO'                                           " &
"         ELSE   'LEVE'                                             " &
"     END                          TP_TRANSPORTE,                   " &
"    ORDERS.C_ZIP                  CEP                              " &
"                                                                   " &
"FROM WMWHSE1.ORDERS,                                               " &
"     WMWHSE1.ORDERDETAIL,                                          " &
"     WMWHSE1.ORDERSTATUSHISTORY,                                   " &
"     WMWHSE1.ORDERSTATUSSETUP,                                     " &
"     WMWHSE1.ORDERSTATUSSETUP ORDERSTATUSSETUP2,                   " &
"     WMWHSE1.SKU,                                                  " &
"     WMWHSE1.TASKDETAIL,                                           " &
"     WMWHSE1.WAVEDETAIL,                                           " &
"     WMWHSE1.CAGEIDDETAIL,                                         " &
"     WMSADMIN.PL_DB,                                                                      " &
"     BAANDB.TZNSLS400201@dln01 znsls400,                                                  " &
"     BAANDB.TZNSLS401201@dln01 znsls401,                                                  " &
"     BAANDB.TZNSLS002201@dln01 znsls002,                                                  " &
"     BAANDB.TWHWMD400201@dln01 whwmd400                                                   " &
"                                                                                          " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                              " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                  " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                    " &
"  AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS                                      " &
"  AND ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                               " &
"  AND ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS                                  " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                           " &
"  AND TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                            " &
"  AND WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                              " &
"  AND ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                        " &
"  AND ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                                               " &
"  AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                                               " &
"  AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                                               " &
"  AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                                               " &
"  AND UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))                          " &
"  AND RTRIM(LTRIM(whwmd400.t$item)) = RTRIM(LTRIM(SKU.SKU))                               " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                      " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'     " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                            " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                             " &
"  DISTINCT                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                          " &
"    ORDERS.SCHEDULEDSHIPDATE      DT_LIMITE,                       " &
"    ORDERS.ORDERKEY               PEDIDO,                          " &
"    ZNSLS401.T$UNEG$C             UNINEG,                          " &
"    ORDERS.SUSR4                  DSC_UNINEG,                      " &
"    ORDERS.ADDDATE                DT_REGISTRO,                     " &
"    ( select A.STATUS                                              " &
"        from WMWHSE2.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE2.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  ULT_EVENTO,                      " &
"    ( select B.DESCRIPTION                                         " &
"        from WMWHSE2.ORDERSTATUSHISTORY  A,                        " &
"             WMWHSE2.ORDERSTATUSSETUP    B                         " &
"      where  A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE2.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and B.CODE = A.STATUS                " &
"                              and rownum = 1 )                     " &
"                                  EVENTO_NOME,                     " &
"    ( select A.ADDDATE                                             " &
"        from WMWHSE2.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE2.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  DT_ULT_EVENTO,                   " &
"    ( select A.ADDWHO                                              " &
"        from WMWHSE2.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE2.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  OPERADOR,                        " &
"    ORDERDETAIL.SKU               ID_ITEM,                         " &
"    SKU.DESCR                     NOME,                            " &
"    ZNSLS400.T$IDCA$C             CANAL,                           " &
"    ORDERS.C_VAT                  MEGA_ROTA,                       " &
"    ORDERS.STATUS                 SITUACAO,                        " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                  " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                        " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                            " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                       " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                     " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                   " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                 " &
"    ORDERS.INVOICENUMBER          NOTA,                            " &
"    ORDERS.LANE                   SERIE,                           " &
"    CAGEIDDETAIL.CAGEID           CARGA,                           " &
"    CASE WHEN SKU.SUSR2 = 2                                        " &
"           THEN 'PESADO'                                           " &
"         ELSE   'LEVE'                                             " &
"     END                          TP_TRANSPORTE,                   " &
"    ORDERS.C_ZIP                  CEP                              " &
"                                                                   " &
"FROM WMWHSE2.ORDERS,                                               " &
"     WMWHSE2.ORDERDETAIL,                                          " &
"     WMWHSE2.ORDERSTATUSHISTORY,                                   " &
"     WMWHSE2.ORDERSTATUSSETUP,                                     " &
"     WMWHSE2.ORDERSTATUSSETUP ORDERSTATUSSETUP2,                   " &
"     WMWHSE2.SKU,                                                  " &
"     WMWHSE2.TASKDETAIL,                                           " &
"     WMWHSE2.WAVEDETAIL,                                           " &
"     WMWHSE2.CAGEIDDETAIL,                                         " &
"     WMSADMIN.PL_DB,                                                                      " &
"     BAANDB.TZNSLS400201@dln01 znsls400,                                                  " &
"     BAANDB.TZNSLS401201@dln01 znsls401,                                                  " &
"     BAANDB.TZNSLS002201@dln01 znsls002,                                                  " &
"     BAANDB.TWHWMD400201@dln01 whwmd400                                                   " &
"                                                                                          " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                              " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                  " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                    " &
"  AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS                                      " &
"  AND ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                               " &
"  AND ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS                                  " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                           " &
"  AND TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                            " &
"  AND WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                              " &
"  AND ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                        " &
"  AND ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                                               " &
"  AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                                               " &
"  AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                                               " &
"  AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                                               " &
"  AND UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))                          " &
"  AND RTRIM(LTRIM(whwmd400.t$item)) = RTRIM(LTRIM(SKU.SKU))                               " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                      " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'     " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                            " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                             " &
"  DISTINCT                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                          " &
"    ORDERS.SCHEDULEDSHIPDATE      DT_LIMITE,                       " &
"    ORDERS.ORDERKEY               PEDIDO,                          " &
"    ZNSLS401.T$UNEG$C             UNINEG,                          " &
"    ORDERS.SUSR4                  DSC_UNINEG,                      " &
"    ORDERS.ADDDATE                DT_REGISTRO,                     " &
"    ( select A.STATUS                                              " &
"        from WMWHSE3.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE3.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  ULT_EVENTO,                      " &
"    ( select B.DESCRIPTION                                         " &
"        from WMWHSE3.ORDERSTATUSHISTORY  A,                        " &
"             WMWHSE3.ORDERSTATUSSETUP    B                         " &
"      where  A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE3.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and B.CODE = A.STATUS                " &
"                              and rownum = 1 )                     " &
"                                  EVENTO_NOME,                     " &
"    ( select A.ADDDATE                                             " &
"        from WMWHSE3.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE3.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  DT_ULT_EVENTO,                   " &
"    ( select A.ADDWHO                                              " &
"        from WMWHSE3.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE3.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  OPERADOR,                        " &
"    ORDERDETAIL.SKU               ID_ITEM,                         " &
"    SKU.DESCR                     NOME,                            " &
"    ZNSLS400.T$IDCA$C             CANAL,                           " &
"    ORDERS.C_VAT                  MEGA_ROTA,                       " &
"    ORDERS.STATUS                 SITUACAO,                        " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                  " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                        " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                            " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                       " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                     " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                   " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                 " &
"    ORDERS.INVOICENUMBER          NOTA,                            " &
"    ORDERS.LANE                   SERIE,                           " &
"    CAGEIDDETAIL.CAGEID           CARGA,                           " &
"    CASE WHEN SKU.SUSR2 = 2                                        " &
"           THEN 'PESADO'                                           " &
"         ELSE   'LEVE'                                             " &
"     END                          TP_TRANSPORTE,                   " &
"    ORDERS.C_ZIP                  CEP                              " &
"                                                                   " &
"FROM WMWHSE3.ORDERS,                                               " &
"     WMWHSE3.ORDERDETAIL,                                          " &
"     WMWHSE3.ORDERSTATUSHISTORY,                                   " &
"     WMWHSE3.ORDERSTATUSSETUP,                                     " &
"     WMWHSE3.ORDERSTATUSSETUP ORDERSTATUSSETUP2,                   " &
"     WMWHSE3.SKU,                                                  " &
"     WMWHSE3.TASKDETAIL,                                           " &
"     WMWHSE3.WAVEDETAIL,                                           " &
"     WMWHSE3.CAGEIDDETAIL,                                         " &
"     WMSADMIN.PL_DB,                                                                      " &
"     BAANDB.TZNSLS400201@dln01 znsls400,                                                  " &
"     BAANDB.TZNSLS401201@dln01 znsls401,                                                  " &
"     BAANDB.TZNSLS002201@dln01 znsls002,                                                  " &
"     BAANDB.TWHWMD400201@dln01 whwmd400                                                   " &
"                                                                                          " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                              " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                  " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                    " &
"  AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS                                      " &
"  AND ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                               " &
"  AND ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS                                  " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                           " &
"  AND TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                            " &
"  AND WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                              " &
"  AND ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                        " &
"  AND ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                                               " &
"  AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                                               " &
"  AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                                               " &
"  AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                                               " &
"  AND UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))                          " &
"  AND RTRIM(LTRIM(whwmd400.t$item)) = RTRIM(LTRIM(SKU.SKU))                               " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                      " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'     " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                            " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                             " &
"  DISTINCT                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                          " &
"    ORDERS.SCHEDULEDSHIPDATE      DT_LIMITE,                       " &
"    ORDERS.ORDERKEY               PEDIDO,                          " &
"    ZNSLS401.T$UNEG$C             UNINEG,                          " &
"    ORDERS.SUSR4                  DSC_UNINEG,                      " &
"    ORDERS.ADDDATE                DT_REGISTRO,                     " &
"    ( select A.STATUS                                              " &
"        from WMWHSE4.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE4.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  ULT_EVENTO,                      " &
"    ( select B.DESCRIPTION                                         " &
"        from WMWHSE4.ORDERSTATUSHISTORY  A,                        " &
"             WMWHSE4.ORDERSTATUSSETUP    B                         " &
"      where  A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE4.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and B.CODE = A.STATUS                " &
"                              and rownum = 1 )                     " &
"                                  EVENTO_NOME,                     " &
"    ( select A.ADDDATE                                             " &
"        from WMWHSE4.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE4.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  DT_ULT_EVENTO,                   " &
"    ( select A.ADDWHO                                              " &
"        from WMWHSE4.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE4.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  OPERADOR,                        " &
"    ORDERDETAIL.SKU               ID_ITEM,                         " &
"    SKU.DESCR                     NOME,                            " &
"    ZNSLS400.T$IDCA$C             CANAL,                           " &
"    ORDERS.C_VAT                  MEGA_ROTA,                       " &
"    ORDERS.STATUS                 SITUACAO,                        " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                  " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                        " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                            " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                       " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                     " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                   " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                 " &
"    ORDERS.INVOICENUMBER          NOTA,                            " &
"    ORDERS.LANE                   SERIE,                           " &
"    CAGEIDDETAIL.CAGEID           CARGA,                           " &
"    CASE WHEN SKU.SUSR2 = 2                                        " &
"           THEN 'PESADO'                                           " &
"         ELSE   'LEVE'                                             " &
"     END                          TP_TRANSPORTE,                   " &
"    ORDERS.C_ZIP                  CEP                              " &
"                                                                   " &
"FROM WMWHSE4.ORDERS,                                               " &
"     WMWHSE4.ORDERDETAIL,                                          " &
"     WMWHSE4.ORDERSTATUSHISTORY,                                   " &
"     WMWHSE4.ORDERSTATUSSETUP,                                     " &
"     WMWHSE4.ORDERSTATUSSETUP ORDERSTATUSSETUP2,                   " &
"     WMWHSE4.SKU,                                                  " &
"     WMWHSE4.TASKDETAIL,                                           " &
"     WMWHSE4.WAVEDETAIL,                                           " &
"     WMWHSE4.CAGEIDDETAIL,                                         " &
"     WMSADMIN.PL_DB,                                                                      " &
"     BAANDB.TZNSLS400201@dln01 znsls400,                                                  " &
"     BAANDB.TZNSLS401201@dln01 znsls401,                                                  " &
"     BAANDB.TZNSLS002201@dln01 znsls002,                                                  " &
"     BAANDB.TWHWMD400201@dln01 whwmd400                                                   " &
"                                                                                          " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                              " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                  " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                    " &
"  AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS                                      " &
"  AND ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                               " &
"  AND ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS                                  " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                           " &
"  AND TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                            " &
"  AND WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                              " &
"  AND ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                        " &
"  AND ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                                               " &
"  AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                                               " &
"  AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                                               " &
"  AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                                               " &
"  AND UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))                          " &
"  AND RTRIM(LTRIM(whwmd400.t$item)) = RTRIM(LTRIM(SKU.SKU))                               " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                      " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'     " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                            " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                             " &
"  DISTINCT                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                          " &
"    ORDERS.SCHEDULEDSHIPDATE      DT_LIMITE,                       " &
"    ORDERS.ORDERKEY               PEDIDO,                          " &
"    ZNSLS401.T$UNEG$C             UNINEG,                          " &
"    ORDERS.SUSR4                  DSC_UNINEG,                      " &
"    ORDERS.ADDDATE                DT_REGISTRO,                     " &
"    ( select A.STATUS                                              " &
"        from WMWHSE5.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE5.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  ULT_EVENTO,                      " &
"    ( select B.DESCRIPTION                                         " &
"        from WMWHSE5.ORDERSTATUSHISTORY  A,                        " &
"             WMWHSE5.ORDERSTATUSSETUP    B                         " &
"      where  A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE5.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and B.CODE = A.STATUS                " &
"                              and rownum = 1 )                     " &
"                                  EVENTO_NOME,                     " &
"    ( select A.ADDDATE                                             " &
"        from WMWHSE5.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE5.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  DT_ULT_EVENTO,                   " &
"    ( select A.ADDWHO                                              " &
"        from WMWHSE5.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE5.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  OPERADOR,                        " &
"    ORDERDETAIL.SKU               ID_ITEM,                         " &
"    SKU.DESCR                     NOME,                            " &
"    ZNSLS400.T$IDCA$C             CANAL,                           " &
"    ORDERS.C_VAT                  MEGA_ROTA,                       " &
"    ORDERS.STATUS                 SITUACAO,                        " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                  " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                        " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                            " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                       " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                     " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                   " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                 " &
"    ORDERS.INVOICENUMBER          NOTA,                            " &
"    ORDERS.LANE                   SERIE,                           " &
"    CAGEIDDETAIL.CAGEID           CARGA,                           " &
"    CASE WHEN SKU.SUSR2 = 2                                        " &
"           THEN 'PESADO'                                           " &
"         ELSE   'LEVE'                                             " &
"     END                          TP_TRANSPORTE,                   " &
"    ORDERS.C_ZIP                  CEP                              " &
"                                                                   " &
"FROM WMWHSE5.ORDERS,                                               " &
"     WMWHSE5.ORDERDETAIL,                                          " &
"     WMWHSE5.ORDERSTATUSHISTORY,                                   " &
"     WMWHSE5.ORDERSTATUSSETUP,                                     " &
"     WMWHSE5.ORDERSTATUSSETUP ORDERSTATUSSETUP2,                   " &
"     WMWHSE5.SKU,                                                  " &
"     WMWHSE5.TASKDETAIL,                                           " &
"     WMWHSE5.WAVEDETAIL,                                           " &
"     WMWHSE5.CAGEIDDETAIL,                                         " &
"     WMSADMIN.PL_DB,                                                                      " &
"     BAANDB.TZNSLS400201@dln01 znsls400,                                                  " &
"     BAANDB.TZNSLS401201@dln01 znsls401,                                                  " &
"     BAANDB.TZNSLS002201@dln01 znsls002,                                                  " &
"     BAANDB.TWHWMD400201@dln01 whwmd400                                                   " &
"                                                                                          " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                              " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                  " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                    " &
"  AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS                                      " &
"  AND ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                               " &
"  AND ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS                                  " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                           " &
"  AND TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                            " &
"  AND WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                              " &
"  AND ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                        " &
"  AND ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                                               " &
"  AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                                               " &
"  AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                                               " &
"  AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                                               " &
"  AND UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))                          " &
"  AND RTRIM(LTRIM(whwmd400.t$item)) = RTRIM(LTRIM(SKU.SKU))                               " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                      " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'     " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                            " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                             " &
"  DISTINCT                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                          " &
"    ORDERS.SCHEDULEDSHIPDATE      DT_LIMITE,                       " &
"    ORDERS.ORDERKEY               PEDIDO,                          " &
"    ZNSLS401.T$UNEG$C             UNINEG,                          " &
"    ORDERS.SUSR4                  DSC_UNINEG,                      " &
"    ORDERS.ADDDATE                DT_REGISTRO,                     " &
"    ( select A.STATUS                                              " &
"        from WMWHSE6.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE6.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  ULT_EVENTO,                      " &
"    ( select B.DESCRIPTION                                         " &
"        from WMWHSE6.ORDERSTATUSHISTORY  A,                        " &
"             WMWHSE6.ORDERSTATUSSETUP    B                         " &
"      where  A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE6.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and B.CODE = A.STATUS                " &
"                              and rownum = 1 )                     " &
"                                  EVENTO_NOME,                     " &
"    ( select A.ADDDATE                                             " &
"        from WMWHSE6.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE6.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  DT_ULT_EVENTO,                   " &
"    ( select A.ADDWHO                                              " &
"        from WMWHSE6.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE6.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  OPERADOR,                        " &
"    ORDERDETAIL.SKU               ID_ITEM,                         " &
"    SKU.DESCR                     NOME,                            " &
"    ZNSLS400.T$IDCA$C             CANAL,                           " &
"    ORDERS.C_VAT                  MEGA_ROTA,                       " &
"    ORDERS.STATUS                 SITUACAO,                        " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                  " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                        " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                            " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                       " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                     " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                   " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                 " &
"    ORDERS.INVOICENUMBER          NOTA,                            " &
"    ORDERS.LANE                   SERIE,                           " &
"    CAGEIDDETAIL.CAGEID           CARGA,                           " &
"    CASE WHEN SKU.SUSR2 = 2                                        " &
"           THEN 'PESADO'                                           " &
"         ELSE   'LEVE'                                             " &
"     END                          TP_TRANSPORTE,                   " &
"    ORDERS.C_ZIP                  CEP                              " &
"                                                                   " &
"FROM WMWHSE6.ORDERS,                                               " &
"     WMWHSE6.ORDERDETAIL,                                          " &
"     WMWHSE6.ORDERSTATUSHISTORY,                                   " &
"     WMWHSE6.ORDERSTATUSSETUP,                                     " &
"     WMWHSE6.ORDERSTATUSSETUP ORDERSTATUSSETUP2,                   " &
"     WMWHSE6.SKU,                                                  " &
"     WMWHSE6.TASKDETAIL,                                           " &
"     WMWHSE6.WAVEDETAIL,                                           " &
"     WMWHSE6.CAGEIDDETAIL,                                         " &
"     WMSADMIN.PL_DB,                                                                      " &
"     BAANDB.TZNSLS400201@dln01 znsls400,                                                  " &
"     BAANDB.TZNSLS401201@dln01 znsls401,                                                  " &
"     BAANDB.TZNSLS002201@dln01 znsls002,                                                  " &
"     BAANDB.TWHWMD400201@dln01 whwmd400                                                   " &
"                                                                                          " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                              " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                  " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                    " &
"  AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS                                      " &
"  AND ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                               " &
"  AND ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS                                  " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                           " &
"  AND TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                            " &
"  AND WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                              " &
"  AND ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                        " &
"  AND ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                                               " &
"  AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                                               " &
"  AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                                               " &
"  AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                                               " &
"  AND UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))                          " &
"  AND RTRIM(LTRIM(whwmd400.t$item)) = RTRIM(LTRIM(SKU.SKU))                               " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                      " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'     " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                            " &
"                                                                                          " &
"Union                                                                                     " &
"                                                                                          " &
"SELECT                                                             " &
"  DISTINCT                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS       FILIAL,                          " &
"    ORDERS.SCHEDULEDSHIPDATE      DT_LIMITE,                       " &
"    ORDERS.ORDERKEY               PEDIDO,                          " &
"    ZNSLS401.T$UNEG$C             UNINEG,                          " &
"    ORDERS.SUSR4                  DSC_UNINEG,                      " &
"    ORDERS.ADDDATE                DT_REGISTRO,                     " &
"    ( select A.STATUS                                              " &
"        from WMWHSE7.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE7.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  ULT_EVENTO,                      " &
"    ( select B.DESCRIPTION                                         " &
"        from WMWHSE7.ORDERSTATUSHISTORY  A,                        " &
"             WMWHSE7.ORDERSTATUSSETUP    B                         " &
"      where  A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE7.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and B.CODE = A.STATUS                " &
"                              and rownum = 1 )                     " &
"                                  EVENTO_NOME,                     " &
"    ( select A.ADDDATE                                             " &
"        from WMWHSE7.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE7.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  DT_ULT_EVENTO,                   " &
"    ( select A.ADDWHO                                              " &
"        from WMWHSE7.ORDERSTATUSHISTORY  A                         " &
"       where A.ADDDATE = ( select max(A1.ADDDATE)                  " &
"                             from WMWHSE7.ORDERSTATUSHISTORY  A1   " &
"                            where A1.ORDERKEY = A.ORDERKEY )       " &
"                              and A.ORDERKEY = ORDERS.ORDERKEY     " &
"                              and rownum = 1 )                     " &
"                                  OPERADOR,                        " &
"    ORDERDETAIL.SKU               ID_ITEM,                         " &
"    SKU.DESCR                     NOME,                            " &
"    ZNSLS400.T$IDCA$C             CANAL,                           " &
"    ORDERS.C_VAT                  MEGA_ROTA,                       " &
"    ORDERS.STATUS                 SITUACAO,                        " &
"    ORDERSTATUSSETUP.DESCRIPTION  DESCR_SITUACAO,                  " &
"    WAVEDETAIL.WAVEKEY            PROGRAMA,                        " &
"    TASKDETAIL.TASKDETAILKEY      ONDA,                            " &
"    ORDERS.CARRIERCODE            ID_TRANSP,                       " &
"    ORDERS.CARRIERNAME            NOME_TRANSP,                     " &
"    ZNSLS002.T$TPEN$C             ID_TP_ENTREGA,                   " &
"    ORDERS.SUSR1                  NOME_TP_ENTREGA,                 " &
"    ORDERS.INVOICENUMBER          NOTA,                            " &
"    ORDERS.LANE                   SERIE,                           " &
"    CAGEIDDETAIL.CAGEID           CARGA,                           " &
"    CASE WHEN SKU.SUSR2 = 2                                        " &
"           THEN 'PESADO'                                           " &
"         ELSE   'LEVE'                                             " &
"     END                          TP_TRANSPORTE,                   " &
"    ORDERS.C_ZIP                  CEP                              " &
"                                                                   " &
"FROM WMWHSE7.ORDERS,                                               " &
"     WMWHSE7.ORDERDETAIL,                                          " &
"     WMWHSE7.ORDERSTATUSHISTORY,                                   " &
"     WMWHSE7.ORDERSTATUSSETUP,                                     " &
"     WMWHSE7.ORDERSTATUSSETUP ORDERSTATUSSETUP2,                   " &
"     WMWHSE7.SKU,                                                  " &
"     WMWHSE7.TASKDETAIL,                                           " &
"     WMWHSE7.WAVEDETAIL,                                           " &
"     WMWHSE7.CAGEIDDETAIL,                                         " &
"     WMSADMIN.PL_DB,                                                                      " &
"     BAANDB.TZNSLS400201@dln01 znsls400,                                                  " &
"     BAANDB.TZNSLS401201@dln01 znsls401,                                                  " &
"     BAANDB.TZNSLS002201@dln01 znsls002,                                                  " &
"     BAANDB.TWHWMD400201@dln01 whwmd400                                                   " &
"                                                                                          " &
"WHERE ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                              " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                                  " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                    " &
"  AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS                                      " &
"  AND ORDERSTATUSSETUP.CODE = ORDERS.STATUS                                               " &
"  AND ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS                                  " &
"  AND SKU.SKU = ORDERDETAIL.SKU                                                           " &
"  AND TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER                            " &
"  AND WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY                                          " &
"  AND CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                                              " &
"  AND ZNSLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                                        " &
"  AND ZNSLS401.T$NCIA$C = ZNSLS400.T$NCIA$C                                               " &
"  AND ZNSLS401.T$UNEG$C = ZNSLS400.T$UNEG$C                                               " &
"  AND ZNSLS401.T$PECL$C = ZNSLS400.T$PECL$C                                               " &
"  AND ZNSLS401.T$SQPD$C = ZNSLS400.T$SQPD$C                                               " &
"  AND UPPER(TRIM(znsls002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))                          " &
"  AND RTRIM(LTRIM(whwmd400.t$item)) = RTRIM(LTRIM(SKU.SKU))                               " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID                                      " &
"  AND Trunc(ORDERS.SCHEDULEDSHIPDATE) Between '" + Parameters!DataLimiteDe.Value + "'     " &
"  AND '" + Parameters!DataLimiteAte.Value + "'                                            " &
"                                                                                          " &
"ORDER BY FILIAL, PEDIDO                                                                   "