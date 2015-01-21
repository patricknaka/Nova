SELECT  
  DISTINCT
    PL_DB.DB_ALIAS               DSC_PLANTA,
    ORDERS.ORDERKEY              ID_PEDIDO,
    SLS401.T$ENTR$C              ID_ENTREGA,
    ORDERS.CONSIGNEEKEY          ID_CLIENTE,
    SLS401.t$emae$c              EMAIL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS401.T$DTAP$C, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)              
                                 DT_APROV,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)     
                                 DATA_LIMITE,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)     
                                 DT_PROMETIDA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)               
                                 DT_REC_HOST,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)             
                                 DT_FEC_GAI,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)        
                                 DT_LIQ_SEC,
    SLS400.T$IDLI$C              ID_LISTA_CAS,
    ORDERS.INVOICENUMBER         ID_NF,    
    ORDERS.LANE                  ID_SERIE,
    SLI940.T$CCFO$L              ID_CFO,
    SLI940.T$OPOR$L              SEQ_CFO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)              
                                 DT_EMISSAO_NF,
    ORDERS.CARRIERCODE           ID_TRANSP,
    ORDERS.CARRIERNAME           NOME_TRANSP,
    COM130.T$CCIT                ID_MUNICIPIO,
    ORDERS.C_CITY                MUNICIPIO,
    ORDERS.C_STATE               ESTADO,
    ORDERS.C_VAT                 MEGA_ROTA,
    ORDERS.TYPE                  ID_TIPO,
    TIPO_PEDIDO.                 DSC_TIPO_PEDIDO
	
FROM       WMWHSE5.ORDERS

 LEFT JOIN WMWHSE5.CAGEIDDETAIL 
        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY
 	   
 LEFT JOIN WMWHSE5.CAGEID 
        ON CAGEIDDETAIL.CAGEID = CAGEID.CAGEID 
 	   
 LEFT JOIN BAANDB.TZNSLS401301@PLN01 SLS401 
        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT
 	   
 LEFT JOIN BAANDB.TZNSLS400301@PLN01 SLS400 
        ON SLS401.T$NCIA$C = SLS400.T$NCIA$C
       AND SLS401.T$UNEG$C = SLS400.T$UNEG$C
       AND SLS401.T$PECL$C = SLS400.T$PECL$C
       AND SLS401.T$SQPD$C = SLS400.T$SQPD$C
 	  
 LEFT JOIN BAANDB.TCISLI245301@PLN01 SLI245 
        ON SLI245.T$SLSO   = SLS401.T$ORNO$C
 	   
 LEFT JOIN BAANDB.TCISLI940301@PLN01 SLI940 
        ON SLI940.T$FIRE$L = SLI245.T$FIRE$L
 	   
 LEFT JOIN BAANDB.TTCCOM100301@PLN01 COM100 
        ON COM100.T$BPID   = ORDERS.CONSIGNEEKEY

 LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO, 
                    NVL(trans.description, 
                        clkp.description)  DSC_TIPO_PEDIDO
               from WMWHSE5.codelkup clkp
          left join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
              where clkp.listname = 'ORDERTYPE'
                and Trim(clkp.code) is not null ) TIPO_PEDIDO
        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type
	   
 LEFT JOIN BAANDB.TTCCOM130301@PLN01 COM130 
        ON COM100.T$CADR   = COM130.T$CADR
	   
INNER JOIN WMSADMIN.PL_DB    
        ON UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)
		
WHERE Trunc(ORDERS.SCHEDULEDSHIPDATE) 
      Between :DataLimiteDe 
          And :DataLimiteAte
  AND ORDERS.TYPE IN (:TipoPedido)


=IIF(Parameters!Table.Value <> "AAA", 

"SELECT                                                                   " &
"  DISTINCT                                                               " &
"    PL_DB.DB_ALIAS               DSC_PLANTA,                             " &
"    ORDERS.ORDERKEY              ID_PEDIDO,                              " &
"    SLS401.T$ENTR$C              ID_ENTREGA,                             " &
"    ORDERS.CONSIGNEEKEY          ID_CLIENTE,                             " &
"    SLS401.t$emae$c              EMAIL,                                  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS401.T$DTAP$C,                  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                                 DT_APROV,                               " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                                 DATA_LIMITE,                            " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,         " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                                 DT_PROMETIDA,                           " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                                 DT_REC_HOST,                            " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                                 DT_FEC_GAI,                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                                 DT_LIQ_SEC,                             " &
"    SLS400.T$IDLI$C              ID_LISTA_CAS,                           " &
"    ORDERS.INVOICENUMBER         ID_NF,                                  " &
"    ORDERS.LANE                  ID_SERIE,                               " &
"    SLI940.T$CCFO$L              ID_CFO,                                 " &
"    SLI940.T$OPOR$L              SEQ_CFO,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,                  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"        AT time zone sessiontimezone) AS DATE)                           " &
"                                 DT_EMISSAO_NF,                          " &
"    ORDERS.CARRIERCODE           ID_TRANSP,                              " &
"    ORDERS.CARRIERNAME           NOME_TRANSP,                            " &
"    COM130.T$CCIT                ID_MUNICIPIO,                           " &
"    ORDERS.C_CITY                MUNICIPIO,                              " &
"    ORDERS.C_STATE               ESTADO,                                 " &
"    ORDERS.C_VAT                 MEGA_ROTA,                              " &
"    ORDERS.TYPE                  ID_TIPO,                                " &
"    TIPO_PEDIDO.                 DSC_TIPO_PEDIDO                         " &
"	                                                                      " &
"FROM       " + Parameters!Table.Value + ".ORDERS                         " &
"                                                                         " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEIDDETAIL                   " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                        " &
" 	                                                                      " &
" LEFT JOIN " + Parameters!Table.Value + ".CAGEID                         " &
"        ON CAGEIDDETAIL.CAGEID = CAGEID.CAGEID                           " &
" 	                                                                      " &
" LEFT JOIN BAANDB.TZNSLS401301@PLN01 SLS401                              " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                    " &
" 	                                                                      " &
" LEFT JOIN BAANDB.TZNSLS400301@PLN01 SLS400                              " &
"        ON SLS401.T$NCIA$C = SLS400.T$NCIA$C                             " &
"       AND SLS401.T$UNEG$C = SLS400.T$UNEG$C                             " &
"       AND SLS401.T$PECL$C = SLS400.T$PECL$C                             " &
"       AND SLS401.T$SQPD$C = SLS400.T$SQPD$C                             " &
" 	                                                                      " &
" LEFT JOIN BAANDB.TCISLI245301@PLN01 SLI245                              " &
"        ON SLI245.T$SLSO   = SLS401.T$ORNO$C                             " &
" 	                                                                      " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 SLI940                              " &
"        ON SLI940.T$FIRE$L = SLI245.T$FIRE$L                             " &
" 	                                                                      " &
" LEFT JOIN BAANDB.TTCCOM100301@PLN01 COM100                              " &
"        ON COM100.T$BPID   = ORDERS.CONSIGNEEKEY                         " &
"                                                                         " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,              " &
"                    NVL(trans.description,                               " &
"                        clkp.description)  DSC_TIPO_PEDIDO               " &
"               from " + Parameters!Table.Value + ".codelkup clkp         " &
"          left join " + Parameters!Table.Value + ".translationlist trans " &
"                 on trans.code = clkp.code                               " &
"                and trans.joinkey1 = clkp.listname                       " &
"                and trans.locale = 'pt'                                  " &
"                and trans.tblname = 'CODELKUP'                           " &
"              where clkp.listname = 'ORDERTYPE'                          " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO            " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type                     " &
"	                                                                      " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01 COM130                              " &
"        ON COM100.T$CADR   = COM130.T$CADR                               " &
"	                                                                      " &
"INNER JOIN WMSADMIN.PL_DB                                                " &
"        ON UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                  " &
"		                                                                  " &
"WHERE Trunc(ORDERS.SCHEDULEDSHIPDATE)                                    " &
"      Between '" + Parameters!DataLimiteDe.Value + "'                    " &
"          And '" + Parameters!DataLimiteAte.Value + "'                   " &
"  AND ORDERS.TYPE IN (" + JOIN(Parameters!TipoPedido.Value, ", ") + ")   " &
"                                                                         " &
"ORDER BY ORDERS.ORDERKEY                                                 "

,

"SELECT                                                                 " &
"  DISTINCT                                                             " &
"    PL_DB.DB_ALIAS               DSC_PLANTA,                           " &
"    ORDERS.ORDERKEY              ID_PEDIDO,                            " &
"    SLS401.T$ENTR$C              ID_ENTREGA,                           " &
"    ORDERS.CONSIGNEEKEY          ID_CLIENTE,                           " &
"    SLS401.t$emae$c              EMAIL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS401.T$DTAP$C,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_APROV,                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DATA_LIMITE,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_PROMETIDA,                         " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_REC_HOST,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_FEC_GAI,                           " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_LIQ_SEC,                           " &
"    SLS400.T$IDLI$C              ID_LISTA_CAS,                         " &
"    ORDERS.INVOICENUMBER         ID_NF,                                " &
"    ORDERS.LANE                  ID_SERIE,                             " &
"    SLI940.T$CCFO$L              ID_CFO,                               " &
"    SLI940.T$OPOR$L              SEQ_CFO,                              " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_EMISSAO_NF,                        " &
"    ORDERS.CARRIERCODE           ID_TRANSP,                            " &
"    ORDERS.CARRIERNAME           NOME_TRANSP,                          " &
"    COM130.T$CCIT                ID_MUNICIPIO,                         " &
"    ORDERS.C_CITY                MUNICIPIO,                            " &
"    ORDERS.C_STATE               ESTADO,                               " &
"    ORDERS.C_VAT                 MEGA_ROTA,                            " &
"    ORDERS.TYPE                  ID_TIPO,                              " &
"    TIPO_PEDIDO.                 DSC_TIPO_PEDIDO                       " &
"	                                                                    " &
"FROM       WMWHSE1.ORDERS                                              " &
"                                                                       " &
" LEFT JOIN WMWHSE1.CAGEIDDETAIL                                        " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                      " &
" 	                                                                    " &
" LEFT JOIN WMWHSE1.CAGEID                                              " &
"        ON CAGEIDDETAIL.CAGEID = CAGEID.CAGEID                         " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS401301@PLN01 SLS401                            " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS400301@PLN01 SLS400                            " &
"        ON SLS401.T$NCIA$C = SLS400.T$NCIA$C                           " &
"       AND SLS401.T$UNEG$C = SLS400.T$UNEG$C                           " &
"       AND SLS401.T$PECL$C = SLS400.T$PECL$C                           " &
"       AND SLS401.T$SQPD$C = SLS400.T$SQPD$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI245301@PLN01 SLI245                            " &
"        ON SLI245.T$SLSO   = SLS401.T$ORNO$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 SLI940                            " &
"        ON SLI940.T$FIRE$L = SLI245.T$FIRE$L                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM100301@PLN01 COM100                            " &
"        ON COM100.T$BPID   = ORDERS.CONSIGNEEKEY                       " &
"                                                                       " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,            " &
"                    NVL(trans.description,                             " &
"                        clkp.description)  DSC_TIPO_PEDIDO             " &
"               from WMWHSE1.codelkup clkp                              " &
"          left join WMWHSE1.translationlist trans                      " &
"                 on trans.code = clkp.code                             " &
"                and trans.joinkey1 = clkp.listname                     " &
"                and trans.locale = 'pt'                                " &
"                and trans.tblname = 'CODELKUP'                         " &
"              where clkp.listname = 'ORDERTYPE'                        " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO          " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type                   " &
"	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01 COM130                            " &
"        ON COM100.T$CADR   = COM130.T$CADR                             " &
"	                                                                    " &
"INNER JOIN WMSADMIN.PL_DB                                              " &
"        ON UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                " &
"		                                                                " &
"WHERE Trunc(ORDERS.SCHEDULEDSHIPDATE)                                  " &
"      Between '" + Parameters!DataLimiteDe.Value + "'                  " &
"          And '" + Parameters!DataLimiteAte.Value + "'                 " &
"  AND ORDERS.TYPE IN (" + JOIN(Parameters!TipoPedido.Value, ", ") + ") " &
"	                                                                    " &
"Union                                                                  " &
"	                                                                    " &
"SELECT                                                                 " &
"  DISTINCT                                                             " &
"    PL_DB.DB_ALIAS               DSC_PLANTA,                           " &
"    ORDERS.ORDERKEY              ID_PEDIDO,                            " &
"    SLS401.T$ENTR$C              ID_ENTREGA,                           " &
"    ORDERS.CONSIGNEEKEY          ID_CLIENTE,                           " &
"    SLS401.t$emae$c              EMAIL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS401.T$DTAP$C,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_APROV,                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DATA_LIMITE,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_PROMETIDA,                         " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_REC_HOST,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_FEC_GAI,                           " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_LIQ_SEC,                           " &
"    SLS400.T$IDLI$C              ID_LISTA_CAS,                         " &
"    ORDERS.INVOICENUMBER         ID_NF,                                " &
"    ORDERS.LANE                  ID_SERIE,                             " &
"    SLI940.T$CCFO$L              ID_CFO,                               " &
"    SLI940.T$OPOR$L              SEQ_CFO,                              " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_EMISSAO_NF,                        " &
"    ORDERS.CARRIERCODE           ID_TRANSP,                            " &
"    ORDERS.CARRIERNAME           NOME_TRANSP,                          " &
"    COM130.T$CCIT                ID_MUNICIPIO,                         " &
"    ORDERS.C_CITY                MUNICIPIO,                            " &
"    ORDERS.C_STATE               ESTADO,                               " &
"    ORDERS.C_VAT                 MEGA_ROTA,                            " &
"    ORDERS.TYPE                  ID_TIPO,                              " &
"    TIPO_PEDIDO.                 DSC_TIPO_PEDIDO                       " &
"	                                                                    " &
"FROM       WMWHSE2.ORDERS                                              " &
"                                                                       " &
" LEFT JOIN WMWHSE2.CAGEIDDETAIL                                        " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                      " &
" 	                                                                    " &
" LEFT JOIN WMWHSE2.CAGEID                                              " &
"        ON CAGEIDDETAIL.CAGEID = CAGEID.CAGEID                         " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS401301@PLN01 SLS401                            " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS400301@PLN01 SLS400                            " &
"        ON SLS401.T$NCIA$C = SLS400.T$NCIA$C                           " &
"       AND SLS401.T$UNEG$C = SLS400.T$UNEG$C                           " &
"       AND SLS401.T$PECL$C = SLS400.T$PECL$C                           " &
"       AND SLS401.T$SQPD$C = SLS400.T$SQPD$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI245301@PLN01 SLI245                            " &
"        ON SLI245.T$SLSO   = SLS401.T$ORNO$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 SLI940                            " &
"        ON SLI940.T$FIRE$L = SLI245.T$FIRE$L                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM100301@PLN01 COM100                            " &
"        ON COM100.T$BPID   = ORDERS.CONSIGNEEKEY                       " &
"                                                                       " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,            " &
"                    NVL(trans.description,                             " &
"                        clkp.description)  DSC_TIPO_PEDIDO             " &
"               from WMWHSE2.codelkup clkp                              " &
"          left join WMWHSE2.translationlist trans                      " &
"                 on trans.code = clkp.code                             " &
"                and trans.joinkey1 = clkp.listname                     " &
"                and trans.locale = 'pt'                                " &
"                and trans.tblname = 'CODELKUP'                         " &
"              where clkp.listname = 'ORDERTYPE'                        " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO          " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type                   " &
"	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01 COM130                            " &
"        ON COM100.T$CADR   = COM130.T$CADR                             " &
"	                                                                    " &
"INNER JOIN WMSADMIN.PL_DB                                              " &
"        ON UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                " &
"		                                                                " &
"WHERE Trunc(ORDERS.SCHEDULEDSHIPDATE)                                  " &
"      Between '" + Parameters!DataLimiteDe.Value + "'                  " &
"          And '" + Parameters!DataLimiteAte.Value + "'                 " &
"  AND ORDERS.TYPE IN (" + JOIN(Parameters!TipoPedido.Value, ", ") + ") " &
"	                                                                    " &
"Union                                                                  " &
"	                                                                    " &
"SELECT                                                                 " &
"  DISTINCT                                                             " &
"    PL_DB.DB_ALIAS               DSC_PLANTA,                           " &
"    ORDERS.ORDERKEY              ID_PEDIDO,                            " &
"    SLS401.T$ENTR$C              ID_ENTREGA,                           " &
"    ORDERS.CONSIGNEEKEY          ID_CLIENTE,                           " &
"    SLS401.t$emae$c              EMAIL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS401.T$DTAP$C,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_APROV,                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DATA_LIMITE,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_PROMETIDA,                         " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_REC_HOST,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_FEC_GAI,                           " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_LIQ_SEC,                           " &
"    SLS400.T$IDLI$C              ID_LISTA_CAS,                         " &
"    ORDERS.INVOICENUMBER         ID_NF,                                " &
"    ORDERS.LANE                  ID_SERIE,                             " &
"    SLI940.T$CCFO$L              ID_CFO,                               " &
"    SLI940.T$OPOR$L              SEQ_CFO,                              " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_EMISSAO_NF,                        " &
"    ORDERS.CARRIERCODE           ID_TRANSP,                            " &
"    ORDERS.CARRIERNAME           NOME_TRANSP,                          " &
"    COM130.T$CCIT                ID_MUNICIPIO,                         " &
"    ORDERS.C_CITY                MUNICIPIO,                            " &
"    ORDERS.C_STATE               ESTADO,                               " &
"    ORDERS.C_VAT                 MEGA_ROTA,                            " &
"    ORDERS.TYPE                  ID_TIPO,                              " &
"    TIPO_PEDIDO.                 DSC_TIPO_PEDIDO                       " &
"	                                                                    " &
"FROM       WMWHSE3.ORDERS                                              " &
"                                                                       " &
" LEFT JOIN WMWHSE3.CAGEIDDETAIL                                        " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                      " &
" 	                                                                    " &
" LEFT JOIN WMWHSE3.CAGEID                                              " &
"        ON CAGEIDDETAIL.CAGEID = CAGEID.CAGEID                         " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS401301@PLN01 SLS401                            " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS400301@PLN01 SLS400                            " &
"        ON SLS401.T$NCIA$C = SLS400.T$NCIA$C                           " &
"       AND SLS401.T$UNEG$C = SLS400.T$UNEG$C                           " &
"       AND SLS401.T$PECL$C = SLS400.T$PECL$C                           " &
"       AND SLS401.T$SQPD$C = SLS400.T$SQPD$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI245301@PLN01 SLI245                            " &
"        ON SLI245.T$SLSO   = SLS401.T$ORNO$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 SLI940                            " &
"        ON SLI940.T$FIRE$L = SLI245.T$FIRE$L                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM100301@PLN01 COM100                            " &
"        ON COM100.T$BPID   = ORDERS.CONSIGNEEKEY                       " &
"                                                                       " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,            " &
"                    NVL(trans.description,                             " &
"                        clkp.description)  DSC_TIPO_PEDIDO             " &
"               from WMWHSE3.codelkup clkp                              " &
"          left join WMWHSE3.translationlist trans                      " &
"                 on trans.code = clkp.code                             " &
"                and trans.joinkey1 = clkp.listname                     " &
"                and trans.locale = 'pt'                                " &
"                and trans.tblname = 'CODELKUP'                         " &
"              where clkp.listname = 'ORDERTYPE'                        " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO          " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type                   " &
"	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01 COM130                            " &
"        ON COM100.T$CADR   = COM130.T$CADR                             " &
"	                                                                    " &
"INNER JOIN WMSADMIN.PL_DB                                              " &
"        ON UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                " &
"		                                                                " &
"WHERE Trunc(ORDERS.SCHEDULEDSHIPDATE)                                  " &
"      Between '" + Parameters!DataLimiteDe.Value + "'                  " &
"          And '" + Parameters!DataLimiteAte.Value + "'                 " &
"  AND ORDERS.TYPE IN (" + JOIN(Parameters!TipoPedido.Value, ", ") + ") " &
"	                                                                    " &
"Union                                                                  " &
"	                                                                    " &
"SELECT                                                                 " &
"  DISTINCT                                                             " &
"    PL_DB.DB_ALIAS               DSC_PLANTA,                           " &
"    ORDERS.ORDERKEY              ID_PEDIDO,                            " &
"    SLS401.T$ENTR$C              ID_ENTREGA,                           " &
"    ORDERS.CONSIGNEEKEY          ID_CLIENTE,                           " &
"    SLS401.t$emae$c              EMAIL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS401.T$DTAP$C,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_APROV,                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DATA_LIMITE,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_PROMETIDA,                         " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_REC_HOST,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_FEC_GAI,                           " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_LIQ_SEC,                           " &
"    SLS400.T$IDLI$C              ID_LISTA_CAS,                         " &
"    ORDERS.INVOICENUMBER         ID_NF,                                " &
"    ORDERS.LANE                  ID_SERIE,                             " &
"    SLI940.T$CCFO$L              ID_CFO,                               " &
"    SLI940.T$OPOR$L              SEQ_CFO,                              " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_EMISSAO_NF,                        " &
"    ORDERS.CARRIERCODE           ID_TRANSP,                            " &
"    ORDERS.CARRIERNAME           NOME_TRANSP,                          " &
"    COM130.T$CCIT                ID_MUNICIPIO,                         " &
"    ORDERS.C_CITY                MUNICIPIO,                            " &
"    ORDERS.C_STATE               ESTADO,                               " &
"    ORDERS.C_VAT                 MEGA_ROTA,                            " &
"    ORDERS.TYPE                  ID_TIPO,                              " &
"    TIPO_PEDIDO.                 DSC_TIPO_PEDIDO                       " &
"	                                                                    " &
"FROM       WMWHSE4.ORDERS                                              " &
"                                                                       " &
" LEFT JOIN WMWHSE4.CAGEIDDETAIL                                        " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                      " &
" 	                                                                    " &
" LEFT JOIN WMWHSE4.CAGEID                                              " &
"        ON CAGEIDDETAIL.CAGEID = CAGEID.CAGEID                         " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS401301@PLN01 SLS401                            " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS400301@PLN01 SLS400                            " &
"        ON SLS401.T$NCIA$C = SLS400.T$NCIA$C                           " &
"       AND SLS401.T$UNEG$C = SLS400.T$UNEG$C                           " &
"       AND SLS401.T$PECL$C = SLS400.T$PECL$C                           " &
"       AND SLS401.T$SQPD$C = SLS400.T$SQPD$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI245301@PLN01 SLI245                            " &
"        ON SLI245.T$SLSO   = SLS401.T$ORNO$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 SLI940                            " &
"        ON SLI940.T$FIRE$L = SLI245.T$FIRE$L                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM100301@PLN01 COM100                            " &
"        ON COM100.T$BPID   = ORDERS.CONSIGNEEKEY                       " &
"                                                                       " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,            " &
"                    NVL(trans.description,                             " &
"                        clkp.description)  DSC_TIPO_PEDIDO             " &
"               from WMWHSE4.codelkup clkp                              " &
"          left join WMWHSE4.translationlist trans                      " &
"                 on trans.code = clkp.code                             " &
"                and trans.joinkey1 = clkp.listname                     " &
"                and trans.locale = 'pt'                                " &
"                and trans.tblname = 'CODELKUP'                         " &
"              where clkp.listname = 'ORDERTYPE'                        " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO          " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type                   " &
"	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01 COM130                            " &
"        ON COM100.T$CADR   = COM130.T$CADR                             " &
"	                                                                    " &
"INNER JOIN WMSADMIN.PL_DB                                              " &
"        ON UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                " &
"		                                                                " &
"WHERE Trunc(ORDERS.SCHEDULEDSHIPDATE)                                  " &
"      Between '" + Parameters!DataLimiteDe.Value + "'                  " &
"          And '" + Parameters!DataLimiteAte.Value + "'                 " &
"  AND ORDERS.TYPE IN (" + JOIN(Parameters!TipoPedido.Value, ", ") + ") " &
"	                                                                    " &
"Union                                                                  " &
"	                                                                    " &
"SELECT                                                                 " &
"  DISTINCT                                                             " &
"    PL_DB.DB_ALIAS               DSC_PLANTA,                           " &
"    ORDERS.ORDERKEY              ID_PEDIDO,                            " &
"    SLS401.T$ENTR$C              ID_ENTREGA,                           " &
"    ORDERS.CONSIGNEEKEY          ID_CLIENTE,                           " &
"    SLS401.t$emae$c              EMAIL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS401.T$DTAP$C,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_APROV,                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DATA_LIMITE,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_PROMETIDA,                         " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_REC_HOST,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_FEC_GAI,                           " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_LIQ_SEC,                           " &
"    SLS400.T$IDLI$C              ID_LISTA_CAS,                         " &
"    ORDERS.INVOICENUMBER         ID_NF,                                " &
"    ORDERS.LANE                  ID_SERIE,                             " &
"    SLI940.T$CCFO$L              ID_CFO,                               " &
"    SLI940.T$OPOR$L              SEQ_CFO,                              " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_EMISSAO_NF,                        " &
"    ORDERS.CARRIERCODE           ID_TRANSP,                            " &
"    ORDERS.CARRIERNAME           NOME_TRANSP,                          " &
"    COM130.T$CCIT                ID_MUNICIPIO,                         " &
"    ORDERS.C_CITY                MUNICIPIO,                            " &
"    ORDERS.C_STATE               ESTADO,                               " &
"    ORDERS.C_VAT                 MEGA_ROTA,                            " &
"    ORDERS.TYPE                  ID_TIPO,                              " &
"    TIPO_PEDIDO.                 DSC_TIPO_PEDIDO                       " &
"	                                                                    " &
"FROM       WMWHSE5.ORDERS                                              " &
"                                                                       " &
" LEFT JOIN WMWHSE5.CAGEIDDETAIL                                        " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                      " &
" 	                                                                    " &
" LEFT JOIN WMWHSE5.CAGEID                                              " &
"        ON CAGEIDDETAIL.CAGEID = CAGEID.CAGEID                         " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS401301@PLN01 SLS401                            " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS400301@PLN01 SLS400                            " &
"        ON SLS401.T$NCIA$C = SLS400.T$NCIA$C                           " &
"       AND SLS401.T$UNEG$C = SLS400.T$UNEG$C                           " &
"       AND SLS401.T$PECL$C = SLS400.T$PECL$C                           " &
"       AND SLS401.T$SQPD$C = SLS400.T$SQPD$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI245301@PLN01 SLI245                            " &
"        ON SLI245.T$SLSO   = SLS401.T$ORNO$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 SLI940                            " &
"        ON SLI940.T$FIRE$L = SLI245.T$FIRE$L                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM100301@PLN01 COM100                            " &
"        ON COM100.T$BPID   = ORDERS.CONSIGNEEKEY                       " &
"                                                                       " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,            " &
"                    NVL(trans.description,                             " &
"                        clkp.description)  DSC_TIPO_PEDIDO             " &
"               from WMWHSE5.codelkup clkp                              " &
"          left join WMWHSE5.translationlist trans                      " &
"                 on trans.code = clkp.code                             " &
"                and trans.joinkey1 = clkp.listname                     " &
"                and trans.locale = 'pt'                                " &
"                and trans.tblname = 'CODELKUP'                         " &
"              where clkp.listname = 'ORDERTYPE'                        " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO          " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type                   " &
"	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01 COM130                            " &
"        ON COM100.T$CADR   = COM130.T$CADR                             " &
"	                                                                    " &
"INNER JOIN WMSADMIN.PL_DB                                              " &
"        ON UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                " &
"		                                                                " &
"WHERE Trunc(ORDERS.SCHEDULEDSHIPDATE)                                  " &
"      Between '" + Parameters!DataLimiteDe.Value + "'                  " &
"          And '" + Parameters!DataLimiteAte.Value + "'                 " &
"  AND ORDERS.TYPE IN (" + JOIN(Parameters!TipoPedido.Value, ", ") + ") " &
"	                                                                    " &
"Union                                                                  " &
"	                                                                    " &
"SELECT                                                                 " &
"  DISTINCT                                                             " &
"    PL_DB.DB_ALIAS               DSC_PLANTA,                           " &
"    ORDERS.ORDERKEY              ID_PEDIDO,                            " &
"    SLS401.T$ENTR$C              ID_ENTREGA,                           " &
"    ORDERS.CONSIGNEEKEY          ID_CLIENTE,                           " &
"    SLS401.t$emae$c              EMAIL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS401.T$DTAP$C,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_APROV,                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DATA_LIMITE,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_PROMETIDA,                         " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_REC_HOST,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_FEC_GAI,                           " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_LIQ_SEC,                           " &
"    SLS400.T$IDLI$C              ID_LISTA_CAS,                         " &
"    ORDERS.INVOICENUMBER         ID_NF,                                " &
"    ORDERS.LANE                  ID_SERIE,                             " &
"    SLI940.T$CCFO$L              ID_CFO,                               " &
"    SLI940.T$OPOR$L              SEQ_CFO,                              " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_EMISSAO_NF,                        " &
"    ORDERS.CARRIERCODE           ID_TRANSP,                            " &
"    ORDERS.CARRIERNAME           NOME_TRANSP,                          " &
"    COM130.T$CCIT                ID_MUNICIPIO,                         " &
"    ORDERS.C_CITY                MUNICIPIO,                            " &
"    ORDERS.C_STATE               ESTADO,                               " &
"    ORDERS.C_VAT                 MEGA_ROTA,                            " &
"    ORDERS.TYPE                  ID_TIPO,                              " &
"    TIPO_PEDIDO.                 DSC_TIPO_PEDIDO                       " &
"	                                                                    " &
"FROM       WMWHSE6.ORDERS                                              " &
"                                                                       " &
" LEFT JOIN WMWHSE6.CAGEIDDETAIL                                        " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                      " &
" 	                                                                    " &
" LEFT JOIN WMWHSE6.CAGEID                                              " &
"        ON CAGEIDDETAIL.CAGEID = CAGEID.CAGEID                         " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS401301@PLN01 SLS401                            " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS400301@PLN01 SLS400                            " &
"        ON SLS401.T$NCIA$C = SLS400.T$NCIA$C                           " &
"       AND SLS401.T$UNEG$C = SLS400.T$UNEG$C                           " &
"       AND SLS401.T$PECL$C = SLS400.T$PECL$C                           " &
"       AND SLS401.T$SQPD$C = SLS400.T$SQPD$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI245301@PLN01 SLI245                            " &
"        ON SLI245.T$SLSO   = SLS401.T$ORNO$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 SLI940                            " &
"        ON SLI940.T$FIRE$L = SLI245.T$FIRE$L                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM100301@PLN01 COM100                            " &
"        ON COM100.T$BPID   = ORDERS.CONSIGNEEKEY                       " &
"                                                                       " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,            " &
"                    NVL(trans.description,                             " &
"                        clkp.description)  DSC_TIPO_PEDIDO             " &
"               from WMWHSE6.codelkup clkp                              " &
"          left join WMWHSE6.translationlist trans                      " &
"                 on trans.code = clkp.code                             " &
"                and trans.joinkey1 = clkp.listname                     " &
"                and trans.locale = 'pt'                                " &
"                and trans.tblname = 'CODELKUP'                         " &
"              where clkp.listname = 'ORDERTYPE'                        " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO          " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type                   " &
"	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01 COM130                            " &
"        ON COM100.T$CADR   = COM130.T$CADR                             " &
"	                                                                    " &
"INNER JOIN WMSADMIN.PL_DB                                              " &
"        ON UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                " &
"		                                                                " &
"WHERE Trunc(ORDERS.SCHEDULEDSHIPDATE)                                  " &
"      Between '" + Parameters!DataLimiteDe.Value + "'                  " &
"          And '" + Parameters!DataLimiteAte.Value + "'                 " &
"  AND ORDERS.TYPE IN (" + JOIN(Parameters!TipoPedido.Value, ", ") + ") " &
"	                                                                    " &
"Union                                                                  " &
"	                                                                    " &
"SELECT                                                                 " &
"  DISTINCT                                                             " &
"    PL_DB.DB_ALIAS               DSC_PLANTA,                           " &
"    ORDERS.ORDERKEY              ID_PEDIDO,                            " &
"    SLS401.T$ENTR$C              ID_ENTREGA,                           " &
"    ORDERS.CONSIGNEEKEY          ID_CLIENTE,                           " &
"    SLS401.t$emae$c              EMAIL,                                " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLS401.T$DTAP$C,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_APROV,                             " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DATA_LIMITE,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,       " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_PROMETIDA,                         " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,                 " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_REC_HOST,                          " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,               " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_FEC_GAI,                           " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,          " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_LIQ_SEC,                           " &
"    SLS400.T$IDLI$C              ID_LISTA_CAS,                         " &
"    ORDERS.INVOICENUMBER         ID_NF,                                " &
"    ORDERS.LANE                  ID_SERIE,                             " &
"    SLI940.T$CCFO$L              ID_CFO,                               " &
"    SLI940.T$OPOR$L              SEQ_CFO,                              " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     " &
"        AT time zone sessiontimezone) AS DATE)                         " &
"                                 DT_EMISSAO_NF,                        " &
"    ORDERS.CARRIERCODE           ID_TRANSP,                            " &
"    ORDERS.CARRIERNAME           NOME_TRANSP,                          " &
"    COM130.T$CCIT                ID_MUNICIPIO,                         " &
"    ORDERS.C_CITY                MUNICIPIO,                            " &
"    ORDERS.C_STATE               ESTADO,                               " &
"    ORDERS.C_VAT                 MEGA_ROTA,                            " &
"    ORDERS.TYPE                  ID_TIPO,                              " &
"    TIPO_PEDIDO.                 DSC_TIPO_PEDIDO                       " &
"	                                                                    " &
"FROM       WMWHSE7.ORDERS                                              " &
"                                                                       " &
" LEFT JOIN WMWHSE7.CAGEIDDETAIL                                        " &
"        ON CAGEIDDETAIL.ORDERID = ORDERS.ORDERKEY                      " &
" 	                                                                    " &
" LEFT JOIN WMWHSE7.CAGEID                                              " &
"        ON CAGEIDDETAIL.CAGEID = CAGEID.CAGEID                         " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS401301@PLN01 SLS401                            " &
"        ON SLS401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                  " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TZNSLS400301@PLN01 SLS400                            " &
"        ON SLS401.T$NCIA$C = SLS400.T$NCIA$C                           " &
"       AND SLS401.T$UNEG$C = SLS400.T$UNEG$C                           " &
"       AND SLS401.T$PECL$C = SLS400.T$PECL$C                           " &
"       AND SLS401.T$SQPD$C = SLS400.T$SQPD$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI245301@PLN01 SLI245                            " &
"        ON SLI245.T$SLSO   = SLS401.T$ORNO$C                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 SLI940                            " &
"        ON SLI940.T$FIRE$L = SLI245.T$FIRE$L                           " &
" 	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM100301@PLN01 COM100                            " &
"        ON COM100.T$BPID   = ORDERS.CONSIGNEEKEY                       " &
"                                                                       " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,            " &
"                    NVL(trans.description,                             " &
"                        clkp.description)  DSC_TIPO_PEDIDO             " &
"               from WMWHSE7.codelkup clkp                              " &
"          left join WMWHSE7.translationlist trans                      " &
"                 on trans.code = clkp.code                             " &
"                and trans.joinkey1 = clkp.listname                     " &
"                and trans.locale = 'pt'                                " &
"                and trans.tblname = 'CODELKUP'                         " &
"              where clkp.listname = 'ORDERTYPE'                        " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO          " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type                   " &
"	                                                                    " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01 COM130                            " &
"        ON COM100.T$CADR   = COM130.T$CADR                             " &
"	                                                                    " &
"INNER JOIN WMSADMIN.PL_DB                                              " &
"        ON UPPER(PL_DB.db_logid) = UPPER(ORDERS.WHSEID)                " &
"		                                                                " &
"WHERE Trunc(ORDERS.SCHEDULEDSHIPDATE)                                  " &
"      Between '" + Parameters!DataLimiteDe.Value + "'                  " &
"          And '" + Parameters!DataLimiteAte.Value + "'                 " &
"  AND ORDERS.TYPE IN (" + JOIN(Parameters!TipoPedido.Value, ", ") + ") " &
"	                                                                    " &
"ORDER BY DSC_PLANTA, ID_PEDIDO                                         "

)