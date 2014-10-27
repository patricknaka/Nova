SELECT CL.UDF2                           FILIAL,
       PEDIDO.T$PECL$C                   ID_PEDIDO, 
       ORDERS.ORDERKEY                   ORDEM_WMS,
       ORDERS.REFERENCEDOCUMENT          ORDEM_LN,
       PEDIDO.T$ENTR$C                   ID_ENTREGA,
       ORDERS.CONSIGNEEKEY               ID_CLIENTE,
       ORDERS.C_COMPANY                  NOME_CLIENTE,
       COM130.T$INFO                     EMAIL,
       PEDIDO.T$DTIN$C                   DT_APROV,
       PEDIDO.t$UNEG$C                   ID_UNIDNEG,
       ORDERS.SUSR4                      NOME_UNIDNEG,
       
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone sessiontimezone) AS DATE)              
                                         DT_LIMITE,
       
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
    
       dtETR.dateETR                     DT_LIQ_SEC,
       PEDIDO.T$IDLI$C                   ID_LISTA_CAS,
       ORDERS.INVOICENUMBER              ID_NF,
       ORDERS.LANE                       ID_SERIE,
       SLI940.T$CCFO$L                   ID_CFO,
       SLI940.T$OPOR$L                   SEQ_CFO,
    
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone sessiontimezone) AS DATE)
                                         DT_EMISSAO_NF,
       
       ORDERS.CARRIERCODE                ID_TRANSP,
       ORDERS.CARRIERNAME                NOME_TRANSP,
       COM130.T$CCIT                     ID_MUNICIPIO,
       ORDERS.C_ADDRESS3                 MUNICIPIO,
       ORDERS.C_STATE                    ESTADO,
       ORDERS.C_VAT                      MEGA_ROTA
    
FROM       WMWHSE5.ORDERS

INNER JOIN WMWHSE5.CODELKUP CL 
        ON UPPER(CL.UDF1)=ORDERS.WHSEID
        
 LEFT JOIN ( select CAGEIDDETAIL.ORDERID, 
                    MIN(CG.CLOSEDATE) CLOSEDATE
               from WMWHSE5.CAGEIDDETAIL    
          left join WMWHSE5.CAGEID CG 
                 on CG.CAGEID = CAGEIDDETAIL.CAGEID
           group by CAGEIDDETAIL.ORDERID ) CAGEID 
        ON CAGEID.ORDERID = ORDERS.ORDERKEY 
   
 LEFT JOIN ( select A.T$ORNO$C, 
                    A.T$PECL$C, 
                    A.T$ENTR$C, 
                    A.T$UNEG$C,
                    B.T$DTIN$C, 
                    B.T$IDLI$C
               from BAANDB.TZNSLS004301@pln01 A 
         inner join BAANDB.TZNSLS400301@pln01 B
                 on B.T$NCIA$C = A.T$NCIA$C
                and B.T$UNEG$C = A.T$UNEG$C
                and B.T$PECL$C = A.T$PECL$C
                and B.T$SQPD$C = A.T$SQPD$C
           group by A.T$ORNO$C, 
                    A.T$PECL$C, 
                    A.T$ENTR$C, 
                    A.T$UNEG$C,
                    B.T$DTIN$C, 
                    B.T$IDLI$C ) PEDIDO
        ON PEDIDO.T$ORNO$C = ORDERS.REFERENCEDOCUMENT
             
 LEFT JOIN BAANDB.TTCCOM100301@pln01 COM100 
        ON COM100.T$BPID = ORDERS.CONSIGNEEKEY

 LEFT JOIN BAANDB.TTCCOM130301@pln01 COM130 
        ON COM100.T$CADR = COM130.T$CADR

 LEFT JOIN ( select SLI245.T$SLSO, 
                    R.T$CCFO$L, 
                    R.T$OPOR$L, 
                    R.T$DATE$L
               from BAANDB.TCISLI245301@pln01 SLI245 
         inner join BAANDB.TCISLI940301@pln01 R 
                 on R.T$FIRE$L = SLI245.T$FIRE$L
           Group by SLI245.T$SLSO, 
                    R.T$CCFO$L, 
                    R.T$OPOR$L,
                    R.T$DATE$L ) SLI940
        ON SLI940.T$SLSO = PEDIDO.T$ORNO$C

 LEFT JOIN ( select a.t$orno$c, 
                    min(e.t$date$c) dateETR
               from BAANDB.Tznfmd630301@pln01 a
         inner join BAANDB.Tznfmd640301@pln01 e
                 on e.t$fili$c = a.t$fili$c
                and  e.t$etiq$c = a.t$etiq$c
              where e.t$coct$c = 'ETR'
           group by a.t$orno$c ) dtETR 
        ON dtETR.t$orno$c = ORDERS.REFERENCEDOCUMENT
  
WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone sessiontimezone) AS DATE), 'DAY') < TRUNC (SYSDATE,'DAY')

		  
" SELECT CL.UDF2                           FILIAL,                        " &
"        PEDIDO.T$PECL$C                   ID_PEDIDO,                     " &
"        ORDERS.ORDERKEY                   ORDEM_WMS,                     " &
"        ORDERS.REFERENCEDOCUMENT          ORDEM_LN,                      " &
"        PEDIDO.T$ENTR$C                   ID_ENTREGA,                    " &
"        ORDERS.CONSIGNEEKEY               ID_CLIENTE,                    " &
"        ORDERS.C_COMPANY                  NOME_CLIENTE,                  " &
"        COM130.T$INFO                     EMAIL,                         " &
"        PEDIDO.T$DTIN$C                   DT_APROV,                      " &
"        PEDIDO.t$UNEG$C                   ID_UNIDNEG,                    " &
"        ORDERS.SUSR4                      NOME_UNIDNEG,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_LIMITE,                     " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_PROMETIDA,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_REC_HOST,                   " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,             " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_FEC_GAI,                    " &
"        dtETR.dateETR                     DT_LIQ_SEC,                    " &
"        PEDIDO.T$IDLI$C                   ID_LISTA_CAS,                  " &
"        ORDERS.INVOICENUMBER              ID_NF,                         " &
"        ORDERS.LANE                       ID_SERIE,                      " &
"        SLI940.T$CCFO$L                   ID_CFO,                        " &
"        SLI940.T$OPOR$L                   SEQ_CFO,                       " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,              " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_EMISSAO_NF,                 " &
"        ORDERS.CARRIERCODE                ID_TRANSP,                     " &
"        ORDERS.CARRIERNAME                NOME_TRANSP,                   " &
"        COM130.T$CCIT                     ID_MUNICIPIO,                  " &
"        ORDERS.C_ADDRESS3                 MUNICIPIO,                     " &
"        ORDERS.C_STATE                    ESTADO,                        " &
"        ORDERS.C_VAT                      MEGA_ROTA                      " &
" FROM       " + Parameters!Table.Value + ".ORDERS                        " &
" INNER JOIN " + Parameters!Table.Value + ".CODELKUP CL                   " &
"         ON UPPER(CL.UDF1)=ORDERS.WHSEID                                 " &
"  LEFT JOIN ( select CAGEIDDETAIL.ORDERID,                               " &
"                     MIN(CG.CLOSEDATE) CLOSEDATE                         " &
"                from " + Parameters!Table.Value + ".CAGEIDDETAIL         " &
"           left join " + Parameters!Table.Value + ".CAGEID CG            " &
"                  on CG.CAGEID = CAGEIDDETAIL.CAGEID                     " &
"            group by CAGEIDDETAIL.ORDERID ) CAGEID                       " &
"         ON CAGEID.ORDERID = ORDERS.ORDERKEY                             " &
"  LEFT JOIN ( select A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C                                          " &
"                from BAANDB.TZNSLS004301@pln01 A                         " &
"          inner join BAANDB.TZNSLS400301@pln01 B                         " &
"                  on B.T$NCIA$C = A.T$NCIA$C                             " &
"                 and B.T$UNEG$C = A.T$UNEG$C                             " &
"                 and B.T$PECL$C = A.T$PECL$C                             " &
"                 and B.T$SQPD$C = A.T$SQPD$C                             " &
"            group by A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C ) PEDIDO                                 " &
"         ON PEDIDO.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                   " &
"  LEFT JOIN BAANDB.TTCCOM100301@pln01 COM100                             " &
"         ON COM100.T$BPID = ORDERS.CONSIGNEEKEY                          " &
"  LEFT JOIN BAANDB.TTCCOM130301@pln01 COM130                             " &
"         ON COM100.T$CADR = COM130.T$CADR                                " &
"  LEFT JOIN ( select SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L                                          " &
"                from BAANDB.TCISLI245301@pln01 SLI245                    " &
"          inner join BAANDB.TCISLI940301@pln01 R                         " &
"                  on R.T$FIRE$L = SLI245.T$FIRE$L                        " &
"            Group by SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L ) SLI940                                 " &
"         ON SLI940.T$SLSO = PEDIDO.T$ORNO$C                              " &
"  LEFT JOIN ( select a.t$orno$c,                                         " &
"                     min(e.t$date$c) dateETR                             " &
"                from BAANDB.Tznfmd630301@pln01 a                         " &
"          inner join BAANDB.Tznfmd640301@pln01 e                         " &
"                  on e.t$fili$c = a.t$fili$c                             " &
"                 and  e.t$etiq$c = a.t$etiq$c                            " &
"               where e.t$coct$c = 'ETR'                                  " &
"            group by a.t$orno$c ) dtETR                                  " &
"         ON dtETR.t$orno$c = ORDERS.REFERENCEDOCUMENT                    " &
" WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,            " & 
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                " &
"           AT time zone sessiontimezone) AS DATE), 'DAY') < TRUNC (SYSDATE,'DAY')    "
		  
-- Query com UNION **********************************************************************
		  
" SELECT CL.UDF2                           FILIAL,                        " &
"        PEDIDO.T$PECL$C                   ID_PEDIDO,                     " &
"        ORDERS.ORDERKEY                   ORDEM_WMS,                     " &
"        ORDERS.REFERENCEDOCUMENT          ORDEM_LN,                      " &
"        PEDIDO.T$ENTR$C                   ID_ENTREGA,                    " &
"        ORDERS.CONSIGNEEKEY               ID_CLIENTE,                    " &
"        ORDERS.C_COMPANY                  NOME_CLIENTE,                  " &
"        COM130.T$INFO                     EMAIL,                         " &
"        PEDIDO.T$DTIN$C                   DT_APROV,                      " &
"        PEDIDO.t$UNEG$C                   ID_UNIDNEG,                    " &
"        ORDERS.SUSR4                      NOME_UNIDNEG,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_LIMITE,                     " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_PROMETIDA,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_REC_HOST,                   " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,             " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_FEC_GAI,                    " &
"        dtETR.dateETR                     DT_LIQ_SEC,                    " &
"        PEDIDO.T$IDLI$C                   ID_LISTA_CAS,                  " &
"        ORDERS.INVOICENUMBER              ID_NF,                         " &
"        ORDERS.LANE                       ID_SERIE,                      " &
"        SLI940.T$CCFO$L                   ID_CFO,                        " &
"        SLI940.T$OPOR$L                   SEQ_CFO,                       " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,              " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_EMISSAO_NF,                 " &
"        ORDERS.CARRIERCODE                ID_TRANSP,                     " &
"        ORDERS.CARRIERNAME                NOME_TRANSP,                   " &
"        COM130.T$CCIT                     ID_MUNICIPIO,                  " &
"        ORDERS.C_ADDRESS3                 MUNICIPIO,                     " &
"        ORDERS.C_STATE                    ESTADO,                        " &
"        ORDERS.C_VAT                      MEGA_ROTA                      " &
" FROM       WMWHSE1.ORDERS                                               " &
" INNER JOIN WMWHSE1.CODELKUP CL                                          " &
"         ON UPPER(CL.UDF1)=ORDERS.WHSEID                                 " &
"  LEFT JOIN ( select CAGEIDDETAIL.ORDERID,                               " &
"                     MIN(CG.CLOSEDATE) CLOSEDATE                         " &
"                from WMWHSE1.CAGEIDDETAIL                                " &
"           left join WMWHSE1.CAGEID CG                                   " &
"                  on CG.CAGEID = CAGEIDDETAIL.CAGEID                     " &
"            group by CAGEIDDETAIL.ORDERID ) CAGEID                       " &
"         ON CAGEID.ORDERID = ORDERS.ORDERKEY                             " &
"  LEFT JOIN ( select A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C                                          " &
"                from BAANDB.TZNSLS004301@pln01 A                         " &
"          inner join BAANDB.TZNSLS400301@pln01 B                         " &
"                  on B.T$NCIA$C = A.T$NCIA$C                             " &
"                 and B.T$UNEG$C = A.T$UNEG$C                             " &
"                 and B.T$PECL$C = A.T$PECL$C                             " &
"                 and B.T$SQPD$C = A.T$SQPD$C                             " &
"            group by A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C ) PEDIDO                                 " &
"         ON PEDIDO.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                   " &
"  LEFT JOIN BAANDB.TTCCOM100301@pln01 COM100                             " &
"         ON COM100.T$BPID = ORDERS.CONSIGNEEKEY                          " &
"  LEFT JOIN BAANDB.TTCCOM130301@pln01 COM130                             " &
"         ON COM100.T$CADR = COM130.T$CADR                                " &
"  LEFT JOIN ( select SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L                                          " &
"                from BAANDB.TCISLI245301@pln01 SLI245                    " &
"          inner join BAANDB.TCISLI940301@pln01 R                         " &
"                  on R.T$FIRE$L = SLI245.T$FIRE$L                        " &
"            Group by SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L ) SLI940                                 " &
"         ON SLI940.T$SLSO = PEDIDO.T$ORNO$C                              " &
"  LEFT JOIN ( select a.t$orno$c,                                         " &
"                     min(e.t$date$c) dateETR                             " &
"                from BAANDB.Tznfmd630301@pln01 a                         " &
"          inner join BAANDB.Tznfmd640301@pln01 e                         " &
"                  on e.t$fili$c = a.t$fili$c                             " &
"                 and  e.t$etiq$c = a.t$etiq$c                            " &
"               where e.t$coct$c = 'ETR'                                  " &
"            group by a.t$orno$c ) dtETR                                  " &
"         ON dtETR.t$orno$c = ORDERS.REFERENCEDOCUMENT                    " &
" WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,            " & 
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                " &
"           AT time zone sessiontimezone) AS DATE), 'DAY') < TRUNC (SYSDATE,'DAY')    " &
"Union                                                                                " &
" SELECT CL.UDF2                           FILIAL,                        " &
"        PEDIDO.T$PECL$C                   ID_PEDIDO,                     " &
"        ORDERS.ORDERKEY                   ORDEM_WMS,                     " &
"        ORDERS.REFERENCEDOCUMENT          ORDEM_LN,                      " &
"        PEDIDO.T$ENTR$C                   ID_ENTREGA,                    " &
"        ORDERS.CONSIGNEEKEY               ID_CLIENTE,                    " &
"        ORDERS.C_COMPANY                  NOME_CLIENTE,                  " &
"        COM130.T$INFO                     EMAIL,                         " &
"        PEDIDO.T$DTIN$C                   DT_APROV,                      " &
"        PEDIDO.t$UNEG$C                   ID_UNIDNEG,                    " &
"        ORDERS.SUSR4                      NOME_UNIDNEG,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_LIMITE,                     " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_PROMETIDA,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_REC_HOST,                   " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,             " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_FEC_GAI,                    " &
"        dtETR.dateETR                     DT_LIQ_SEC,                    " &
"        PEDIDO.T$IDLI$C                   ID_LISTA_CAS,                  " &
"        ORDERS.INVOICENUMBER              ID_NF,                         " &
"        ORDERS.LANE                       ID_SERIE,                      " &
"        SLI940.T$CCFO$L                   ID_CFO,                        " &
"        SLI940.T$OPOR$L                   SEQ_CFO,                       " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,              " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_EMISSAO_NF,                 " &
"        ORDERS.CARRIERCODE                ID_TRANSP,                     " &
"        ORDERS.CARRIERNAME                NOME_TRANSP,                   " &
"        COM130.T$CCIT                     ID_MUNICIPIO,                  " &
"        ORDERS.C_ADDRESS3                 MUNICIPIO,                     " &
"        ORDERS.C_STATE                    ESTADO,                        " &
"        ORDERS.C_VAT                      MEGA_ROTA                      " &
" FROM       WMWHSE2.ORDERS                                               " &
" INNER JOIN WMWHSE2.CODELKUP CL                                          " &
"         ON UPPER(CL.UDF1)=ORDERS.WHSEID                                 " &
"  LEFT JOIN ( select CAGEIDDETAIL.ORDERID,                               " &
"                     MIN(CG.CLOSEDATE) CLOSEDATE                         " &
"                from WMWHSE2.CAGEIDDETAIL                                " &
"           left join WMWHSE2.CAGEID CG                                   " &
"                  on CG.CAGEID = CAGEIDDETAIL.CAGEID                     " &
"            group by CAGEIDDETAIL.ORDERID ) CAGEID                       " &
"         ON CAGEID.ORDERID = ORDERS.ORDERKEY                             " &
"  LEFT JOIN ( select A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C                                          " &
"                from BAANDB.TZNSLS004301@pln01 A                         " &
"          inner join BAANDB.TZNSLS400301@pln01 B                         " &
"                  on B.T$NCIA$C = A.T$NCIA$C                             " &
"                 and B.T$UNEG$C = A.T$UNEG$C                             " &
"                 and B.T$PECL$C = A.T$PECL$C                             " &
"                 and B.T$SQPD$C = A.T$SQPD$C                             " &
"            group by A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C ) PEDIDO                                 " &
"         ON PEDIDO.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                   " &
"  LEFT JOIN BAANDB.TTCCOM100301@pln01 COM100                             " &
"         ON COM100.T$BPID = ORDERS.CONSIGNEEKEY                          " &
"  LEFT JOIN BAANDB.TTCCOM130301@pln01 COM130                             " &
"         ON COM100.T$CADR = COM130.T$CADR                                " &
"  LEFT JOIN ( select SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L                                          " &
"                from BAANDB.TCISLI245301@pln01 SLI245                    " &
"          inner join BAANDB.TCISLI940301@pln01 R                         " &
"                  on R.T$FIRE$L = SLI245.T$FIRE$L                        " &
"            Group by SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L ) SLI940                                 " &
"         ON SLI940.T$SLSO = PEDIDO.T$ORNO$C                              " &
"  LEFT JOIN ( select a.t$orno$c,                                         " &
"                     min(e.t$date$c) dateETR                             " &
"                from BAANDB.Tznfmd630301@pln01 a                         " &
"          inner join BAANDB.Tznfmd640301@pln01 e                         " &
"                  on e.t$fili$c = a.t$fili$c                             " &
"                 and  e.t$etiq$c = a.t$etiq$c                            " &
"               where e.t$coct$c = 'ETR'                                  " &
"            group by a.t$orno$c ) dtETR                                  " &
"         ON dtETR.t$orno$c = ORDERS.REFERENCEDOCUMENT                    " &
" WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,            " & 
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                " &
"           AT time zone sessiontimezone) AS DATE), 'DAY') < TRUNC (SYSDATE,'DAY')    " &
"Union                                                                                " &
" SELECT CL.UDF2                           FILIAL,                        " &
"        PEDIDO.T$PECL$C                   ID_PEDIDO,                     " &
"        ORDERS.ORDERKEY                   ORDEM_WMS,                     " &
"        ORDERS.REFERENCEDOCUMENT          ORDEM_LN,                      " &
"        PEDIDO.T$ENTR$C                   ID_ENTREGA,                    " &
"        ORDERS.CONSIGNEEKEY               ID_CLIENTE,                    " &
"        ORDERS.C_COMPANY                  NOME_CLIENTE,                  " &
"        COM130.T$INFO                     EMAIL,                         " &
"        PEDIDO.T$DTIN$C                   DT_APROV,                      " &
"        PEDIDO.t$UNEG$C                   ID_UNIDNEG,                    " &
"        ORDERS.SUSR4                      NOME_UNIDNEG,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_LIMITE,                     " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_PROMETIDA,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_REC_HOST,                   " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,             " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_FEC_GAI,                    " &
"        dtETR.dateETR                     DT_LIQ_SEC,                    " &
"        PEDIDO.T$IDLI$C                   ID_LISTA_CAS,                  " &
"        ORDERS.INVOICENUMBER              ID_NF,                         " &
"        ORDERS.LANE                       ID_SERIE,                      " &
"        SLI940.T$CCFO$L                   ID_CFO,                        " &
"        SLI940.T$OPOR$L                   SEQ_CFO,                       " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,              " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_EMISSAO_NF,                 " &
"        ORDERS.CARRIERCODE                ID_TRANSP,                     " &
"        ORDERS.CARRIERNAME                NOME_TRANSP,                   " &
"        COM130.T$CCIT                     ID_MUNICIPIO,                  " &
"        ORDERS.C_ADDRESS3                 MUNICIPIO,                     " &
"        ORDERS.C_STATE                    ESTADO,                        " &
"        ORDERS.C_VAT                      MEGA_ROTA                      " &
" FROM       WMWHSE3.ORDERS                                               " &
" INNER JOIN WMWHSE3.CODELKUP CL                                          " &
"         ON UPPER(CL.UDF1)=ORDERS.WHSEID                                 " &
"  LEFT JOIN ( select CAGEIDDETAIL.ORDERID,                               " &
"                     MIN(CG.CLOSEDATE) CLOSEDATE                         " &
"                from WMWHSE3.CAGEIDDETAIL                                " &
"           left join WMWHSE3.CAGEID CG                                   " &
"                  on CG.CAGEID = CAGEIDDETAIL.CAGEID                     " &
"            group by CAGEIDDETAIL.ORDERID ) CAGEID                       " &
"         ON CAGEID.ORDERID = ORDERS.ORDERKEY                             " &
"  LEFT JOIN ( select A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C                                          " &
"                from BAANDB.TZNSLS004301@pln01 A                         " &
"          inner join BAANDB.TZNSLS400301@pln01 B                         " &
"                  on B.T$NCIA$C = A.T$NCIA$C                             " &
"                 and B.T$UNEG$C = A.T$UNEG$C                             " &
"                 and B.T$PECL$C = A.T$PECL$C                             " &
"                 and B.T$SQPD$C = A.T$SQPD$C                             " &
"            group by A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C ) PEDIDO                                 " &
"         ON PEDIDO.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                   " &
"  LEFT JOIN BAANDB.TTCCOM100301@pln01 COM100                             " &
"         ON COM100.T$BPID = ORDERS.CONSIGNEEKEY                          " &
"  LEFT JOIN BAANDB.TTCCOM130301@pln01 COM130                             " &
"         ON COM100.T$CADR = COM130.T$CADR                                " &
"  LEFT JOIN ( select SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L                                          " &
"                from BAANDB.TCISLI245301@pln01 SLI245                    " &
"          inner join BAANDB.TCISLI940301@pln01 R                         " &
"                  on R.T$FIRE$L = SLI245.T$FIRE$L                        " &
"            Group by SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L ) SLI940                                 " &
"         ON SLI940.T$SLSO = PEDIDO.T$ORNO$C                              " &
"  LEFT JOIN ( select a.t$orno$c,                                         " &
"                     min(e.t$date$c) dateETR                             " &
"                from BAANDB.Tznfmd630301@pln01 a                         " &
"          inner join BAANDB.Tznfmd640301@pln01 e                         " &
"                  on e.t$fili$c = a.t$fili$c                             " &
"                 and  e.t$etiq$c = a.t$etiq$c                            " &
"               where e.t$coct$c = 'ETR'                                  " &
"            group by a.t$orno$c ) dtETR                                  " &
"         ON dtETR.t$orno$c = ORDERS.REFERENCEDOCUMENT                    " &
" WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,            " & 
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                " &
"           AT time zone sessiontimezone) AS DATE), 'DAY') < TRUNC (SYSDATE,'DAY')    " &
"Union                                                                                " &
" SELECT CL.UDF2                           FILIAL,                        " &
"        PEDIDO.T$PECL$C                   ID_PEDIDO,                     " &
"        ORDERS.ORDERKEY                   ORDEM_WMS,                     " &
"        ORDERS.REFERENCEDOCUMENT          ORDEM_LN,                      " &
"        PEDIDO.T$ENTR$C                   ID_ENTREGA,                    " &
"        ORDERS.CONSIGNEEKEY               ID_CLIENTE,                    " &
"        ORDERS.C_COMPANY                  NOME_CLIENTE,                  " &
"        COM130.T$INFO                     EMAIL,                         " &
"        PEDIDO.T$DTIN$C                   DT_APROV,                      " &
"        PEDIDO.t$UNEG$C                   ID_UNIDNEG,                    " &
"        ORDERS.SUSR4                      NOME_UNIDNEG,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_LIMITE,                     " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_PROMETIDA,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_REC_HOST,                   " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,             " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_FEC_GAI,                    " &
"        dtETR.dateETR                     DT_LIQ_SEC,                    " &
"        PEDIDO.T$IDLI$C                   ID_LISTA_CAS,                  " &
"        ORDERS.INVOICENUMBER              ID_NF,                         " &
"        ORDERS.LANE                       ID_SERIE,                      " &
"        SLI940.T$CCFO$L                   ID_CFO,                        " &
"        SLI940.T$OPOR$L                   SEQ_CFO,                       " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,              " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_EMISSAO_NF,                 " &
"        ORDERS.CARRIERCODE                ID_TRANSP,                     " &
"        ORDERS.CARRIERNAME                NOME_TRANSP,                   " &
"        COM130.T$CCIT                     ID_MUNICIPIO,                  " &
"        ORDERS.C_ADDRESS3                 MUNICIPIO,                     " &
"        ORDERS.C_STATE                    ESTADO,                        " &
"        ORDERS.C_VAT                      MEGA_ROTA                      " &
" FROM       WMWHSE4.ORDERS                                               " &
" INNER JOIN WMWHSE4.CODELKUP CL                                          " &
"         ON UPPER(CL.UDF1)=ORDERS.WHSEID                                 " &
"  LEFT JOIN ( select CAGEIDDETAIL.ORDERID,                               " &
"                     MIN(CG.CLOSEDATE) CLOSEDATE                         " &
"                from WMWHSE4.CAGEIDDETAIL                                " &
"           left join WMWHSE4.CAGEID CG                                   " &
"                  on CG.CAGEID = CAGEIDDETAIL.CAGEID                     " &
"            group by CAGEIDDETAIL.ORDERID ) CAGEID                       " &
"         ON CAGEID.ORDERID = ORDERS.ORDERKEY                             " &
"  LEFT JOIN ( select A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C                                          " &
"                from BAANDB.TZNSLS004301@pln01 A                         " &
"          inner join BAANDB.TZNSLS400301@pln01 B                         " &
"                  on B.T$NCIA$C = A.T$NCIA$C                             " &
"                 and B.T$UNEG$C = A.T$UNEG$C                             " &
"                 and B.T$PECL$C = A.T$PECL$C                             " &
"                 and B.T$SQPD$C = A.T$SQPD$C                             " &
"            group by A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C ) PEDIDO                                 " &
"         ON PEDIDO.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                   " &
"  LEFT JOIN BAANDB.TTCCOM100301@pln01 COM100                             " &
"         ON COM100.T$BPID = ORDERS.CONSIGNEEKEY                          " &
"  LEFT JOIN BAANDB.TTCCOM130301@pln01 COM130                             " &
"         ON COM100.T$CADR = COM130.T$CADR                                " &
"  LEFT JOIN ( select SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L                                          " &
"                from BAANDB.TCISLI245301@pln01 SLI245                    " &
"          inner join BAANDB.TCISLI940301@pln01 R                         " &
"                  on R.T$FIRE$L = SLI245.T$FIRE$L                        " &
"            Group by SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L ) SLI940                                 " &
"         ON SLI940.T$SLSO = PEDIDO.T$ORNO$C                              " &
"  LEFT JOIN ( select a.t$orno$c,                                         " &
"                     min(e.t$date$c) dateETR                             " &
"                from BAANDB.Tznfmd630301@pln01 a                         " &
"          inner join BAANDB.Tznfmd640301@pln01 e                         " &
"                  on e.t$fili$c = a.t$fili$c                             " &
"                 and  e.t$etiq$c = a.t$etiq$c                            " &
"               where e.t$coct$c = 'ETR'                                  " &
"            group by a.t$orno$c ) dtETR                                  " &
"         ON dtETR.t$orno$c = ORDERS.REFERENCEDOCUMENT                    " &
" WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,            " & 
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                " &
"           AT time zone sessiontimezone) AS DATE), 'DAY') < TRUNC (SYSDATE,'DAY')    " &
"Union                                                                                " &
" SELECT CL.UDF2                           FILIAL,                        " &
"        PEDIDO.T$PECL$C                   ID_PEDIDO,                     " &
"        ORDERS.ORDERKEY                   ORDEM_WMS,                     " &
"        ORDERS.REFERENCEDOCUMENT          ORDEM_LN,                      " &
"        PEDIDO.T$ENTR$C                   ID_ENTREGA,                    " &
"        ORDERS.CONSIGNEEKEY               ID_CLIENTE,                    " &
"        ORDERS.C_COMPANY                  NOME_CLIENTE,                  " &
"        COM130.T$INFO                     EMAIL,                         " &
"        PEDIDO.T$DTIN$C                   DT_APROV,                      " &
"        PEDIDO.t$UNEG$C                   ID_UNIDNEG,                    " &
"        ORDERS.SUSR4                      NOME_UNIDNEG,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_LIMITE,                     " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_PROMETIDA,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_REC_HOST,                   " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,             " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_FEC_GAI,                    " &
"        dtETR.dateETR                     DT_LIQ_SEC,                    " &
"        PEDIDO.T$IDLI$C                   ID_LISTA_CAS,                  " &
"        ORDERS.INVOICENUMBER              ID_NF,                         " &
"        ORDERS.LANE                       ID_SERIE,                      " &
"        SLI940.T$CCFO$L                   ID_CFO,                        " &
"        SLI940.T$OPOR$L                   SEQ_CFO,                       " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,              " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_EMISSAO_NF,                 " &
"        ORDERS.CARRIERCODE                ID_TRANSP,                     " &
"        ORDERS.CARRIERNAME                NOME_TRANSP,                   " &
"        COM130.T$CCIT                     ID_MUNICIPIO,                  " &
"        ORDERS.C_ADDRESS3                 MUNICIPIO,                     " &
"        ORDERS.C_STATE                    ESTADO,                        " &
"        ORDERS.C_VAT                      MEGA_ROTA                      " &
" FROM       WMWHSE5.ORDERS                                               " &
" INNER JOIN WMWHSE5.CODELKUP CL                                          " &
"         ON UPPER(CL.UDF1)=ORDERS.WHSEID                                 " &
"  LEFT JOIN ( select CAGEIDDETAIL.ORDERID,                               " &
"                     MIN(CG.CLOSEDATE) CLOSEDATE                         " &
"                from WMWHSE5.CAGEIDDETAIL                                " &
"           left join WMWHSE5.CAGEID CG                                   " &
"                  on CG.CAGEID = CAGEIDDETAIL.CAGEID                     " &
"            group by CAGEIDDETAIL.ORDERID ) CAGEID                       " &
"         ON CAGEID.ORDERID = ORDERS.ORDERKEY                             " &
"  LEFT JOIN ( select A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C                                          " &
"                from BAANDB.TZNSLS004301@pln01 A                         " &
"          inner join BAANDB.TZNSLS400301@pln01 B                         " &
"                  on B.T$NCIA$C = A.T$NCIA$C                             " &
"                 and B.T$UNEG$C = A.T$UNEG$C                             " &
"                 and B.T$PECL$C = A.T$PECL$C                             " &
"                 and B.T$SQPD$C = A.T$SQPD$C                             " &
"            group by A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C ) PEDIDO                                 " &
"         ON PEDIDO.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                   " &
"  LEFT JOIN BAANDB.TTCCOM100301@pln01 COM100                             " &
"         ON COM100.T$BPID = ORDERS.CONSIGNEEKEY                          " &
"  LEFT JOIN BAANDB.TTCCOM130301@pln01 COM130                             " &
"         ON COM100.T$CADR = COM130.T$CADR                                " &
"  LEFT JOIN ( select SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L                                          " &
"                from BAANDB.TCISLI245301@pln01 SLI245                    " &
"          inner join BAANDB.TCISLI940301@pln01 R                         " &
"                  on R.T$FIRE$L = SLI245.T$FIRE$L                        " &
"            Group by SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L ) SLI940                                 " &
"         ON SLI940.T$SLSO = PEDIDO.T$ORNO$C                              " &
"  LEFT JOIN ( select a.t$orno$c,                                         " &
"                     min(e.t$date$c) dateETR                             " &
"                from BAANDB.Tznfmd630301@pln01 a                         " &
"          inner join BAANDB.Tznfmd640301@pln01 e                         " &
"                  on e.t$fili$c = a.t$fili$c                             " &
"                 and  e.t$etiq$c = a.t$etiq$c                            " &
"               where e.t$coct$c = 'ETR'                                  " &
"            group by a.t$orno$c ) dtETR                                  " &
"         ON dtETR.t$orno$c = ORDERS.REFERENCEDOCUMENT                    " &
" WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,            " & 
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                " &
"           AT time zone sessiontimezone) AS DATE), 'DAY') < TRUNC (SYSDATE,'DAY')    " &
"Union                                                                                " &
" SELECT CL.UDF2                           FILIAL,                        " &
"        PEDIDO.T$PECL$C                   ID_PEDIDO,                     " &
"        ORDERS.ORDERKEY                   ORDEM_WMS,                     " &
"        ORDERS.REFERENCEDOCUMENT          ORDEM_LN,                      " &
"        PEDIDO.T$ENTR$C                   ID_ENTREGA,                    " &
"        ORDERS.CONSIGNEEKEY               ID_CLIENTE,                    " &
"        ORDERS.C_COMPANY                  NOME_CLIENTE,                  " &
"        COM130.T$INFO                     EMAIL,                         " &
"        PEDIDO.T$DTIN$C                   DT_APROV,                      " &
"        PEDIDO.t$UNEG$C                   ID_UNIDNEG,                    " &
"        ORDERS.SUSR4                      NOME_UNIDNEG,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_LIMITE,                     " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_PROMETIDA,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_REC_HOST,                   " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,             " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_FEC_GAI,                    " &
"        dtETR.dateETR                     DT_LIQ_SEC,                    " &
"        PEDIDO.T$IDLI$C                   ID_LISTA_CAS,                  " &
"        ORDERS.INVOICENUMBER              ID_NF,                         " &
"        ORDERS.LANE                       ID_SERIE,                      " &
"        SLI940.T$CCFO$L                   ID_CFO,                        " &
"        SLI940.T$OPOR$L                   SEQ_CFO,                       " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,              " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_EMISSAO_NF,                 " &
"        ORDERS.CARRIERCODE                ID_TRANSP,                     " &
"        ORDERS.CARRIERNAME                NOME_TRANSP,                   " &
"        COM130.T$CCIT                     ID_MUNICIPIO,                  " &
"        ORDERS.C_ADDRESS3                 MUNICIPIO,                     " &
"        ORDERS.C_STATE                    ESTADO,                        " &
"        ORDERS.C_VAT                      MEGA_ROTA                      " &
" FROM       WMWHSE6.ORDERS                                               " &
" INNER JOIN WMWHSE6.CODELKUP CL                                          " &
"         ON UPPER(CL.UDF1)=ORDERS.WHSEID                                 " &
"  LEFT JOIN ( select CAGEIDDETAIL.ORDERID,                               " &
"                     MIN(CG.CLOSEDATE) CLOSEDATE                         " &
"                from WMWHSE6.CAGEIDDETAIL                                " &
"           left join WMWHSE6.CAGEID CG                                   " &
"                  on CG.CAGEID = CAGEIDDETAIL.CAGEID                     " &
"            group by CAGEIDDETAIL.ORDERID ) CAGEID                       " &
"         ON CAGEID.ORDERID = ORDERS.ORDERKEY                             " &
"  LEFT JOIN ( select A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C                                          " &
"                from BAANDB.TZNSLS004301@pln01 A                         " &
"          inner join BAANDB.TZNSLS400301@pln01 B                         " &
"                  on B.T$NCIA$C = A.T$NCIA$C                             " &
"                 and B.T$UNEG$C = A.T$UNEG$C                             " &
"                 and B.T$PECL$C = A.T$PECL$C                             " &
"                 and B.T$SQPD$C = A.T$SQPD$C                             " &
"            group by A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C ) PEDIDO                                 " &
"         ON PEDIDO.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                   " &
"  LEFT JOIN BAANDB.TTCCOM100301@pln01 COM100                             " &
"         ON COM100.T$BPID = ORDERS.CONSIGNEEKEY                          " &
"  LEFT JOIN BAANDB.TTCCOM130301@pln01 COM130                             " &
"         ON COM100.T$CADR = COM130.T$CADR                                " &
"  LEFT JOIN ( select SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L                                          " &
"                from BAANDB.TCISLI245301@pln01 SLI245                    " &
"          inner join BAANDB.TCISLI940301@pln01 R                         " &
"                  on R.T$FIRE$L = SLI245.T$FIRE$L                        " &
"            Group by SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L ) SLI940                                 " &
"         ON SLI940.T$SLSO = PEDIDO.T$ORNO$C                              " &
"  LEFT JOIN ( select a.t$orno$c,                                         " &
"                     min(e.t$date$c) dateETR                             " &
"                from BAANDB.Tznfmd630301@pln01 a                         " &
"          inner join BAANDB.Tznfmd640301@pln01 e                         " &
"                  on e.t$fili$c = a.t$fili$c                             " &
"                 and  e.t$etiq$c = a.t$etiq$c                            " &
"               where e.t$coct$c = 'ETR'                                  " &
"            group by a.t$orno$c ) dtETR                                  " &
"         ON dtETR.t$orno$c = ORDERS.REFERENCEDOCUMENT                    " &
" WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,            " & 
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                " &
"           AT time zone sessiontimezone) AS DATE), 'DAY') < TRUNC (SYSDATE,'DAY')    " &
"Union                                                                                " &
" SELECT CL.UDF2                           FILIAL,                        " &
"        PEDIDO.T$PECL$C                   ID_PEDIDO,                     " &
"        ORDERS.ORDERKEY                   ORDEM_WMS,                     " &
"        ORDERS.REFERENCEDOCUMENT          ORDEM_LN,                      " &
"        PEDIDO.T$ENTR$C                   ID_ENTREGA,                    " &
"        ORDERS.CONSIGNEEKEY               ID_CLIENTE,                    " &
"        ORDERS.C_COMPANY                  NOME_CLIENTE,                  " &
"        COM130.T$INFO                     EMAIL,                         " &
"        PEDIDO.T$DTIN$C                   DT_APROV,                      " &
"        PEDIDO.t$UNEG$C                   ID_UNIDNEG,                    " &
"        ORDERS.SUSR4                      NOME_UNIDNEG,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_LIMITE,                     " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE,     " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_PROMETIDA,                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,               " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_REC_HOST,                   " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGEID.CLOSEDATE,             " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_FEC_GAI,                    " &
"        dtETR.dateETR                     DT_LIQ_SEC,                    " &
"        PEDIDO.T$IDLI$C                   ID_LISTA_CAS,                  " &
"        ORDERS.INVOICENUMBER              ID_NF,                         " &
"        ORDERS.LANE                       ID_SERIE,                      " &
"        SLI940.T$CCFO$L                   ID_CFO,                        " &
"        SLI940.T$OPOR$L                   SEQ_CFO,                       " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(SLI940.T$DATE$L,              " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"            AT time zone sessiontimezone) AS DATE)                       " &
"                                          DT_EMISSAO_NF,                 " &
"        ORDERS.CARRIERCODE                ID_TRANSP,                     " &
"        ORDERS.CARRIERNAME                NOME_TRANSP,                   " &
"        COM130.T$CCIT                     ID_MUNICIPIO,                  " &
"        ORDERS.C_ADDRESS3                 MUNICIPIO,                     " &
"        ORDERS.C_STATE                    ESTADO,                        " &
"        ORDERS.C_VAT                      MEGA_ROTA                      " &
" FROM       WMWHSE7.ORDERS                                               " &
" INNER JOIN WMWHSE7.CODELKUP CL                                          " &
"         ON UPPER(CL.UDF1)=ORDERS.WHSEID                                 " &
"  LEFT JOIN ( select CAGEIDDETAIL.ORDERID,                               " &
"                     MIN(CG.CLOSEDATE) CLOSEDATE                         " &
"                from WMWHSE7.CAGEIDDETAIL                                " &
"           left join WMWHSE7.CAGEID CG                                   " &
"                  on CG.CAGEID = CAGEIDDETAIL.CAGEID                     " &
"            group by CAGEIDDETAIL.ORDERID ) CAGEID                       " &
"         ON CAGEID.ORDERID = ORDERS.ORDERKEY                             " &
"  LEFT JOIN ( select A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C                                          " &
"                from BAANDB.TZNSLS004301@pln01 A                         " &
"          inner join BAANDB.TZNSLS400301@pln01 B                         " &
"                  on B.T$NCIA$C = A.T$NCIA$C                             " &
"                 and B.T$UNEG$C = A.T$UNEG$C                             " &
"                 and B.T$PECL$C = A.T$PECL$C                             " &
"                 and B.T$SQPD$C = A.T$SQPD$C                             " &
"            group by A.T$ORNO$C,                                         " &
"                     A.T$PECL$C,                                         " &
"                     A.T$ENTR$C,                                         " &
"                     A.T$UNEG$C,                                         " &
"                     B.T$DTIN$C,                                         " &
"                     B.T$IDLI$C ) PEDIDO                                 " &
"         ON PEDIDO.T$ORNO$C = ORDERS.REFERENCEDOCUMENT                   " &
"  LEFT JOIN BAANDB.TTCCOM100301@pln01 COM100                             " &
"         ON COM100.T$BPID = ORDERS.CONSIGNEEKEY                          " &
"  LEFT JOIN BAANDB.TTCCOM130301@pln01 COM130                             " &
"         ON COM100.T$CADR = COM130.T$CADR                                " &
"  LEFT JOIN ( select SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L                                          " &
"                from BAANDB.TCISLI245301@pln01 SLI245                    " &
"          inner join BAANDB.TCISLI940301@pln01 R                         " &
"                  on R.T$FIRE$L = SLI245.T$FIRE$L                        " &
"            Group by SLI245.T$SLSO,                                      " &
"                     R.T$CCFO$L,                                         " &
"                     R.T$OPOR$L,                                         " &
"                     R.T$DATE$L ) SLI940                                 " &
"         ON SLI940.T$SLSO = PEDIDO.T$ORNO$C                              " &
"  LEFT JOIN ( select a.t$orno$c,                                         " &
"                     min(e.t$date$c) dateETR                             " &
"                from BAANDB.Tznfmd630301@pln01 a                         " &
"          inner join BAANDB.Tznfmd640301@pln01 e                         " &
"                  on e.t$fili$c = a.t$fili$c                             " &
"                 and  e.t$etiq$c = a.t$etiq$c                            " &
"               where e.t$coct$c = 'ETR'                                  " &
"            group by a.t$orno$c ) dtETR                                  " &
"         ON dtETR.t$orno$c = ORDERS.REFERENCEDOCUMENT                    " &
" WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,            " & 
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                " &
"           AT time zone sessiontimezone) AS DATE), 'DAY') < TRUNC (SYSDATE,'DAY')    " &
"ORDER BY FILIAL                                                                      "