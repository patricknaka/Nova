SELECT
  CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '
         THEN 'INT'
       ELSE TDSLS400.T$CREG
  END                                                        CANAL,
  ORDERS.whseid                                              ID_FILIAL,
  CODELKUP.UDF2                                              DESCR_FILIAL,
  Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE),'DD')  DATA_LIMITE,
  ORDERS.SUSR4                                               UNEG,
  nvl(OH.STATUS, ORDERS.STATUS)                              ULT_EVENTO,
  OS.DESCRIPTION                                             ULT_EVENTO_DESCR,
  COUNT(DISTINCT ORDERS.ORDERKEY)                            PEDIDOS,
  CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE
         THEN 'ATRASO TERCEIRO'
       WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE
         THEN 'ATRASO OP'
       ELSE   ' '
  END                                                        DIF_ATRASO_TERCEIRO,
  ORDERS.ADDDATE                                             DATA_REGISTRO

FROM      WMWHSE5.ORDERS

INNER JOIN baandb.tznsls401301@pln01 znsls401
        ON znsls401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT

 LEFT JOIN BAANDB.TTDSLS400301@pln01 TDSLS400
        ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT

 LEFT JOIN ( select a.orderkey,
                    a.status from WMWHSE5.orderstatushistory a
              where a.serialkey = ( SELECT MAX(b.serialkey)
                                      FROM WMWHSE5.orderstatushistory b
                                     WHERE b.orderkey = a.orderkey ) ) OH
        ON OH.ORDERKEY = ORDERS.ORDERKEY

 LEFT JOIN ( select to_char(a.code) code,
                    to_char(a.description) description
               from WMWHSE5.ORDERSTATUSSETUP a
             union
             select '-5',
                    'Nota fiscal Inutilizada'
               from dual ) OS
        ON OS.CODE = nvl(OH.STATUS, ORDERS.STATUS)

 LEFT JOIN WMWHSE5.CODELKUP
        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)
       AND CODELKUP.LISTNAME = 'SCHEMA'

WHERE ORDERS.STATUS not in ('95', '96', '97', '98', '99', '100')
  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE),'DD')
      Between NVL(:DataLimiteDe, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,
                                         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                           AT time zone 'America/Sao_Paulo') AS DATE),'DD'))
          And NVL(:DataLimiteAte, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,
                                         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                           AT time zone 'America/Sao_Paulo') AS DATE),'DD'))

GROUP BY CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '
                THEN 'INT'
              ELSE TDSLS400.T$CREG
         END,
         ORDERS.whseid,
         CODELKUP.UDF2,
         Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,
                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                   AT time zone 'America/Sao_Paulo') AS DATE),'DD'),
         ORDERS.SUSR4,
         NVL(OH.STATUS, ORDERS.STATUS),
         OS.DESCRIPTION,
         CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE
                THEN 'ATRASO TERCEIRO'
              WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,
                     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                       AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE
                THEN 'ATRASO OP'
              ELSE   ' '
         END,
         ORDERS.ADDDATE



=IIF(Parameters!Table.Value <> "AAA", 

" SELECT  " &
"   CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"          THEN 'INT'  " &
"        ELSE TDSLS400.T$CREG  " &
"   END                                                        CANAL,  " &
"   ORDERS.whseid                                              ID_FILIAL,  " &
"   CODELKUP.UDF2                                              DESCR_FILIAL,  " &
"   Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE),'DD')  DATA_LIMITE,  " &
"   ORDERS.SUSR4                                               UNEG,  " &
"   nvl(OH.STATUS, ORDERS.STATUS)                              ULT_EVENTO,  " &
"   OS.DESCRIPTION                                             ULT_EVENTO_DESCR,  " &
"   COUNT(DISTINCT ORDERS.ORDERKEY)                            PEDIDOS,  " &
"   CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"          THEN 'ATRASO TERCEIRO'  " &
"        WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"          THEN 'ATRASO OP'  " &
"        ELSE   ' '  " &
"   END                                                        DIF_ATRASO_TERCEIRO,  " &
"   ORDERS.ADDDATE                                             DATA_REGISTRO  " &
"  " &
" FROM      " + Parameters!Table.Value + ".ORDERS  " &
"  " &
" INNER JOIN baandb.tznsls401301@pln01 znsls401  " &
"         ON znsls401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN BAANDB.TTDSLS400301@pln01 TDSLS400  " &
"         ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN ( select a.orderkey,  " &
"                     a.status from " + Parameters!Table.Value + ".orderstatushistory a  " &
"               where a.serialkey = ( SELECT MAX(b.serialkey)  " &
"                                       FROM " + Parameters!Table.Value + ".orderstatushistory b  " &
"                                      WHERE b.orderkey = a.orderkey ) ) OH  " &
"         ON OH.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
"  LEFT JOIN ( select to_char(a.code) code,  " &
"                     to_char(a.description) description  " &
"                from " + Parameters!Table.Value + ".ORDERSTATUSSETUP a  " &
"              union  " &
"              select '-5',  " &
"                     'Nota fiscal Inutilizada'  " &
"                from dual ) OS  " &
"         ON OS.CODE = nvl(OH.STATUS, ORDERS.STATUS)  " &
"  " &
"  LEFT JOIN " + Parameters!Table.Value + ".CODELKUP  " &
"         ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"        AND CODELKUP.LISTNAME = 'SCHEMA'  " &
"  " &
" WHERE ORDERS.STATUS not in ('95', '96', '97', '98', '99', '100')  " &
"   AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE),'DD')  " &
"       Between NVL(:DataLimiteDe, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                            AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &
"           And NVL(:DataLimiteAte, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                             AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &
"  " &
" GROUP BY CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"                 THEN 'INT'  " &
"               ELSE TDSLS400.T$CREG  " &
"          END,  " &
"          ORDERS.whseid,  " &
"          CODELKUP.UDF2,  " &
"          Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                    AT time zone 'America/Sao_Paulo') AS DATE),'DD'),  " &
"          ORDERS.SUSR4,  " &
"          NVL(OH.STATUS, ORDERS.STATUS),  " &
"          OS.DESCRIPTION,  " &
"          CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"                 THEN 'ATRASO TERCEIRO'  " &
"               WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                        AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"                 THEN 'ATRASO OP'  " &
"               ELSE   ' '  " &
"          END,  " &
"          ORDERS.ADDDATE  " &
" ORDER BY ID_FILIAL, DATA_LIMITE  "

,

" SELECT  " &
"   CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"          THEN 'INT'  " &
"        ELSE TDSLS400.T$CREG  " &
"   END                                                        CANAL,  " &
"   ORDERS.whseid                                              ID_FILIAL,  " &
"   CODELKUP.UDF2                                              DESCR_FILIAL,  " &
"   Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE),'DD')  DATA_LIMITE,  " &
"   ORDERS.SUSR4                                               UNEG,  " &
"   nvl(OH.STATUS, ORDERS.STATUS)                              ULT_EVENTO,  " &
"   OS.DESCRIPTION                                             ULT_EVENTO_DESCR,  " &
"   COUNT(DISTINCT ORDERS.ORDERKEY)                            PEDIDOS,  " &
"   CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"          THEN 'ATRASO TERCEIRO'  " &
"        WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"          THEN 'ATRASO OP'  " &
"        ELSE   ' '  " &
"   END                                                        DIF_ATRASO_TERCEIRO,  " &
"   ORDERS.ADDDATE                                             DATA_REGISTRO  " &
"  " &
" FROM      WMWHSE1.ORDERS  " &
"  " &
" INNER JOIN baandb.tznsls401301@pln01 znsls401  " &
"         ON znsls401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN BAANDB.TTDSLS400301@pln01 TDSLS400  " &
"         ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN ( select a.orderkey,  " &
"                     a.status from WMWHSE1.orderstatushistory a  " &
"               where a.serialkey = ( SELECT MAX(b.serialkey)  " &
"                                       FROM WMWHSE1.orderstatushistory b  " &
"                                      WHERE b.orderkey = a.orderkey ) ) OH  " &
"         ON OH.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
"  LEFT JOIN ( select to_char(a.code) code,  " &
"                     to_char(a.description) description  " &
"                from WMWHSE1.ORDERSTATUSSETUP a  " &
"              union  " &
"              select '-5',  " &
"                     'Nota fiscal Inutilizada'  " &
"                from dual ) OS  " &
"         ON OS.CODE = nvl(OH.STATUS, ORDERS.STATUS)  " &
"  " &
"  LEFT JOIN WMWHSE1.CODELKUP  " &
"         ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"        AND CODELKUP.LISTNAME = 'SCHEMA'  " &
"  " &
" WHERE ORDERS.STATUS not in ('95', '96', '97', '98', '99', '100')  " &
"   AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE),'DD')  " &
"       Between NVL(:DataLimiteDe, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                            AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &
"           And NVL(:DataLimiteAte, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                             AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &"  " &
" GROUP BY CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"                 THEN 'INT'  " &
"               ELSE TDSLS400.T$CREG  " &
"          END,  " &
"          ORDERS.whseid,  " &
"          CODELKUP.UDF2,  " &
"          Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                    AT time zone 'America/Sao_Paulo') AS DATE),'DD'),  " &
"          ORDERS.SUSR4,  " &
"          NVL(OH.STATUS, ORDERS.STATUS),  " &
"          OS.DESCRIPTION,  " &
"          CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"                 THEN 'ATRASO TERCEIRO'  " &
"               WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                        AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"                 THEN 'ATRASO OP'  " &
"               ELSE   ' '  " &
"          END,  " &
"          ORDERS.ADDDATE  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"          THEN 'INT'  " &
"        ELSE TDSLS400.T$CREG  " &
"   END                                                        CANAL,  " &
"   ORDERS.whseid                                              ID_FILIAL,  " &
"   CODELKUP.UDF2                                              DESCR_FILIAL,  " &
"   Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE),'DD')  DATA_LIMITE,  " &
"   ORDERS.SUSR4                                               UNEG,  " &
"   nvl(OH.STATUS, ORDERS.STATUS)                              ULT_EVENTO,  " &
"   OS.DESCRIPTION                                             ULT_EVENTO_DESCR,  " &
"   COUNT(DISTINCT ORDERS.ORDERKEY)                            PEDIDOS,  " &
"   CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"          THEN 'ATRASO TERCEIRO'  " &
"        WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"          THEN 'ATRASO OP'  " &
"        ELSE   ' '  " &
"   END                                                        DIF_ATRASO_TERCEIRO,  " &
"   ORDERS.ADDDATE                                             DATA_REGISTRO  " &
"  " &
" FROM      WMWHSE2.ORDERS  " &
"  " &
" INNER JOIN baandb.tznsls401301@pln01 znsls401  " &
"         ON znsls401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN BAANDB.TTDSLS400301@pln01 TDSLS400  " &
"         ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN ( select a.orderkey,  " &
"                     a.status from WMWHSE2.orderstatushistory a  " &
"               where a.serialkey = ( SELECT MAX(b.serialkey)  " &
"                                       FROM WMWHSE2.orderstatushistory b  " &
"                                      WHERE b.orderkey = a.orderkey ) ) OH  " &
"         ON OH.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
"  LEFT JOIN ( select to_char(a.code) code,  " &
"                     to_char(a.description) description  " &
"                from WMWHSE2.ORDERSTATUSSETUP a  " &
"              union  " &
"              select '-5',  " &
"                     'Nota fiscal Inutilizada'  " &
"                from dual ) OS  " &
"         ON OS.CODE = nvl(OH.STATUS, ORDERS.STATUS)  " &
"  " &
"  LEFT JOIN WMWHSE2.CODELKUP  " &
"         ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"        AND CODELKUP.LISTNAME = 'SCHEMA'  " &
"  " &
" WHERE ORDERS.STATUS not in ('95', '96', '97', '98', '99', '100')  " &
"   AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE),'DD')  " &
"       Between NVL(:DataLimiteDe, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                            AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &
"           And NVL(:DataLimiteAte, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                             AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &"  " &
" GROUP BY CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"                 THEN 'INT'  " &
"               ELSE TDSLS400.T$CREG  " &
"          END,  " &
"          ORDERS.whseid,  " &
"          CODELKUP.UDF2,  " &
"          Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                    AT time zone 'America/Sao_Paulo') AS DATE),'DD'),  " &
"          ORDERS.SUSR4,  " &
"          NVL(OH.STATUS, ORDERS.STATUS),  " &
"          OS.DESCRIPTION,  " &
"          CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"                 THEN 'ATRASO TERCEIRO'  " &
"               WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                        AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"                 THEN 'ATRASO OP'  " &
"               ELSE   ' '  " &
"          END,  " &
"          ORDERS.ADDDATE  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"          THEN 'INT'  " &
"        ELSE TDSLS400.T$CREG  " &
"   END                                                        CANAL,  " &
"   ORDERS.whseid                                              ID_FILIAL,  " &
"   CODELKUP.UDF2                                              DESCR_FILIAL,  " &
"   Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE),'DD')  DATA_LIMITE,  " &
"   ORDERS.SUSR4                                               UNEG,  " &
"   nvl(OH.STATUS, ORDERS.STATUS)                              ULT_EVENTO,  " &
"   OS.DESCRIPTION                                             ULT_EVENTO_DESCR,  " &
"   COUNT(DISTINCT ORDERS.ORDERKEY)                            PEDIDOS,  " &
"   CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"          THEN 'ATRASO TERCEIRO'  " &
"        WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"          THEN 'ATRASO OP'  " &
"        ELSE   ' '  " &
"   END                                                        DIF_ATRASO_TERCEIRO,  " &
"   ORDERS.ADDDATE                                             DATA_REGISTRO  " &
"  " &
" FROM      WMWHSE3.ORDERS  " &
"  " &
" INNER JOIN baandb.tznsls401301@pln01 znsls401  " &
"         ON znsls401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN BAANDB.TTDSLS400301@pln01 TDSLS400  " &
"         ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN ( select a.orderkey,  " &
"                     a.status from WMWHSE3.orderstatushistory a  " &
"               where a.serialkey = ( SELECT MAX(b.serialkey)  " &
"                                       FROM WMWHSE3.orderstatushistory b  " &
"                                      WHERE b.orderkey = a.orderkey ) ) OH  " &
"         ON OH.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
"  LEFT JOIN ( select to_char(a.code) code,  " &
"                     to_char(a.description) description  " &
"                from WMWHSE3.ORDERSTATUSSETUP a  " &
"              union  " &
"              select '-5',  " &
"                     'Nota fiscal Inutilizada'  " &
"                from dual ) OS  " &
"         ON OS.CODE = nvl(OH.STATUS, ORDERS.STATUS)  " &
"  " &
"  LEFT JOIN WMWHSE3.CODELKUP  " &
"         ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"        AND CODELKUP.LISTNAME = 'SCHEMA'  " &
"  " &
" WHERE ORDERS.STATUS not in ('95', '96', '97', '98', '99', '100')  " &
"   AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE),'DD')  " &
"       Between NVL(:DataLimiteDe, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                            AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &
"           And NVL(:DataLimiteAte, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                             AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &"  " &
" GROUP BY CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"                 THEN 'INT'  " &
"               ELSE TDSLS400.T$CREG  " &
"          END,  " &
"          ORDERS.whseid,  " &
"          CODELKUP.UDF2,  " &
"          Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                    AT time zone 'America/Sao_Paulo') AS DATE),'DD'),  " &
"          ORDERS.SUSR4,  " &
"          NVL(OH.STATUS, ORDERS.STATUS),  " &
"          OS.DESCRIPTION,  " &
"          CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"                 THEN 'ATRASO TERCEIRO'  " &
"               WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                        AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"                 THEN 'ATRASO OP'  " &
"               ELSE   ' '  " &
"          END,  " &
"          ORDERS.ADDDATE  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"          THEN 'INT'  " &
"        ELSE TDSLS400.T$CREG  " &
"   END                                                        CANAL,  " &
"   ORDERS.whseid                                              ID_FILIAL,  " &
"   CODELKUP.UDF2                                              DESCR_FILIAL,  " &
"   Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE),'DD')  DATA_LIMITE,  " &
"   ORDERS.SUSR4                                               UNEG,  " &
"   nvl(OH.STATUS, ORDERS.STATUS)                              ULT_EVENTO,  " &
"   OS.DESCRIPTION                                             ULT_EVENTO_DESCR,  " &
"   COUNT(DISTINCT ORDERS.ORDERKEY)                            PEDIDOS,  " &
"   CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"          THEN 'ATRASO TERCEIRO'  " &
"        WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"          THEN 'ATRASO OP'  " &
"        ELSE   ' '  " &
"   END                                                        DIF_ATRASO_TERCEIRO,  " &
"   ORDERS.ADDDATE                                             DATA_REGISTRO  " &
"  " &
" FROM      WMWHSE4.ORDERS  " &
"  " &
" INNER JOIN baandb.tznsls401301@pln01 znsls401  " &
"         ON znsls401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN BAANDB.TTDSLS400301@pln01 TDSLS400  " &
"         ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN ( select a.orderkey,  " &
"                     a.status from WMWHSE4.orderstatushistory a  " &
"               where a.serialkey = ( SELECT MAX(b.serialkey)  " &
"                                       FROM WMWHSE4.orderstatushistory b  " &
"                                      WHERE b.orderkey = a.orderkey ) ) OH  " &
"         ON OH.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
"  LEFT JOIN ( select to_char(a.code) code,  " &
"                     to_char(a.description) description  " &
"                from WMWHSE4.ORDERSTATUSSETUP a  " &
"              union  " &
"              select '-5',  " &
"                     'Nota fiscal Inutilizada'  " &
"                from dual ) OS  " &
"         ON OS.CODE = nvl(OH.STATUS, ORDERS.STATUS)  " &
"  " &
"  LEFT JOIN WMWHSE4.CODELKUP  " &
"         ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"        AND CODELKUP.LISTNAME = 'SCHEMA'  " &
"  " &
" WHERE ORDERS.STATUS not in ('95', '96', '97', '98', '99', '100')  " &
"   AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE),'DD')  " &
"       Between NVL(:DataLimiteDe, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                            AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &
"           And NVL(:DataLimiteAte, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                             AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &"  " &
" GROUP BY CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"                 THEN 'INT'  " &
"               ELSE TDSLS400.T$CREG  " &
"          END,  " &
"          ORDERS.whseid,  " &
"          CODELKUP.UDF2,  " &
"          Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                    AT time zone 'America/Sao_Paulo') AS DATE),'DD'),  " &
"          ORDERS.SUSR4,  " &
"          NVL(OH.STATUS, ORDERS.STATUS),  " &
"          OS.DESCRIPTION,  " &
"          CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"                 THEN 'ATRASO TERCEIRO'  " &
"               WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                        AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"                 THEN 'ATRASO OP'  " &
"               ELSE   ' '  " &
"          END,  " &
"          ORDERS.ADDDATE  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"          THEN 'INT'  " &
"        ELSE TDSLS400.T$CREG  " &
"   END                                                        CANAL,  " &
"   ORDERS.whseid                                              ID_FILIAL,  " &
"   CODELKUP.UDF2                                              DESCR_FILIAL,  " &
"   Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE),'DD')  DATA_LIMITE,  " &
"   ORDERS.SUSR4                                               UNEG,  " &
"   nvl(OH.STATUS, ORDERS.STATUS)                              ULT_EVENTO,  " &
"   OS.DESCRIPTION                                             ULT_EVENTO_DESCR,  " &
"   COUNT(DISTINCT ORDERS.ORDERKEY)                            PEDIDOS,  " &
"   CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"          THEN 'ATRASO TERCEIRO'  " &
"        WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"          THEN 'ATRASO OP'  " &
"        ELSE   ' '  " &
"   END                                                        DIF_ATRASO_TERCEIRO,  " &
"   ORDERS.ADDDATE                                             DATA_REGISTRO  " &
"  " &
" FROM      WMWHSE5.ORDERS  " &
"  " &
" INNER JOIN baandb.tznsls401301@pln01 znsls401  " &
"         ON znsls401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN BAANDB.TTDSLS400301@pln01 TDSLS400  " &
"         ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN ( select a.orderkey,  " &
"                     a.status from WMWHSE5.orderstatushistory a  " &
"               where a.serialkey = ( SELECT MAX(b.serialkey)  " &
"                                       FROM WMWHSE5.orderstatushistory b  " &
"                                      WHERE b.orderkey = a.orderkey ) ) OH  " &
"         ON OH.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
"  LEFT JOIN ( select to_char(a.code) code,  " &
"                     to_char(a.description) description  " &
"                from WMWHSE5.ORDERSTATUSSETUP a  " &
"              union  " &
"              select '-5',  " &
"                     'Nota fiscal Inutilizada'  " &
"                from dual ) OS  " &
"         ON OS.CODE = nvl(OH.STATUS, ORDERS.STATUS)  " &
"  " &
"  LEFT JOIN WMWHSE5.CODELKUP  " &
"         ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"        AND CODELKUP.LISTNAME = 'SCHEMA'  " &
"  " &
" WHERE ORDERS.STATUS not in ('95', '96', '97', '98', '99', '100')  " &
"   AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE),'DD')  " &
"       Between NVL(:DataLimiteDe, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                            AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &
"           And NVL(:DataLimiteAte, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                             AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &"  " &
" GROUP BY CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"                 THEN 'INT'  " &
"               ELSE TDSLS400.T$CREG  " &
"          END,  " &
"          ORDERS.whseid,  " &
"          CODELKUP.UDF2,  " &
"          Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                    AT time zone 'America/Sao_Paulo') AS DATE),'DD'),  " &
"          ORDERS.SUSR4,  " &
"          NVL(OH.STATUS, ORDERS.STATUS),  " &
"          OS.DESCRIPTION,  " &
"          CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"                 THEN 'ATRASO TERCEIRO'  " &
"               WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                        AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"                 THEN 'ATRASO OP'  " &
"               ELSE   ' '  " &
"          END,  " &
"          ORDERS.ADDDATE  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"          THEN 'INT'  " &
"        ELSE TDSLS400.T$CREG  " &
"   END                                                        CANAL,  " &
"   ORDERS.whseid                                              ID_FILIAL,  " &
"   CODELKUP.UDF2                                              DESCR_FILIAL,  " &
"   Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE),'DD')  DATA_LIMITE,  " &
"   ORDERS.SUSR4                                               UNEG,  " &
"   nvl(OH.STATUS, ORDERS.STATUS)                              ULT_EVENTO,  " &
"   OS.DESCRIPTION                                             ULT_EVENTO_DESCR,  " &
"   COUNT(DISTINCT ORDERS.ORDERKEY)                            PEDIDOS,  " &
"   CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"          THEN 'ATRASO TERCEIRO'  " &
"        WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"          THEN 'ATRASO OP'  " &
"        ELSE   ' '  " &
"   END                                                        DIF_ATRASO_TERCEIRO,  " &
"   ORDERS.ADDDATE                                             DATA_REGISTRO  " &
"  " &
" FROM      WMWHSE6.ORDERS  " &
"  " &
" INNER JOIN baandb.tznsls401301@pln01 znsls401  " &
"         ON znsls401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN BAANDB.TTDSLS400301@pln01 TDSLS400  " &
"         ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN ( select a.orderkey,  " &
"                     a.status from WMWHSE6.orderstatushistory a  " &
"               where a.serialkey = ( SELECT MAX(b.serialkey)  " &
"                                       FROM WMWHSE6.orderstatushistory b  " &
"                                      WHERE b.orderkey = a.orderkey ) ) OH  " &
"         ON OH.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
"  LEFT JOIN ( select to_char(a.code) code,  " &
"                     to_char(a.description) description  " &
"                from WMWHSE6.ORDERSTATUSSETUP a  " &
"              union  " &
"              select '-5',  " &
"                     'Nota fiscal Inutilizada'  " &
"                from dual ) OS  " &
"         ON OS.CODE = nvl(OH.STATUS, ORDERS.STATUS)  " &
"  " &
"  LEFT JOIN WMWHSE6.CODELKUP  " &
"         ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"        AND CODELKUP.LISTNAME = 'SCHEMA'  " &
"  " &
" WHERE ORDERS.STATUS not in ('95', '96', '97', '98', '99', '100')  " &
"   AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE),'DD')  " &
"       Between NVL(:DataLimiteDe, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                            AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &
"           And NVL(:DataLimiteAte, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                             AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &"  " &
" GROUP BY CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"                 THEN 'INT'  " &
"               ELSE TDSLS400.T$CREG  " &
"          END,  " &
"          ORDERS.whseid,  " &
"          CODELKUP.UDF2,  " &
"          Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                    AT time zone 'America/Sao_Paulo') AS DATE),'DD'),  " &
"          ORDERS.SUSR4,  " &
"          NVL(OH.STATUS, ORDERS.STATUS),  " &
"          OS.DESCRIPTION,  " &
"          CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"                 THEN 'ATRASO TERCEIRO'  " &
"               WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                        AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"                 THEN 'ATRASO OP'  " &
"               ELSE   ' '  " &
"          END,  " &
"          ORDERS.ADDDATE  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"          THEN 'INT'  " &
"        ELSE TDSLS400.T$CREG  " &
"   END                                                        CANAL,  " &
"   ORDERS.whseid                                              ID_FILIAL,  " &
"   CODELKUP.UDF2                                              DESCR_FILIAL,  " &
"   Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE),'DD')  DATA_LIMITE,  " &
"   ORDERS.SUSR4                                               UNEG,  " &
"   nvl(OH.STATUS, ORDERS.STATUS)                              ULT_EVENTO,  " &
"   OS.DESCRIPTION                                             ULT_EVENTO_DESCR,  " &
"   COUNT(DISTINCT ORDERS.ORDERKEY)                            PEDIDOS,  " &
"   CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"          THEN 'ATRASO TERCEIRO'  " &
"        WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"          THEN 'ATRASO OP'  " &
"        ELSE   ' '  " &
"   END                                                        DIF_ATRASO_TERCEIRO,  " &
"   ORDERS.ADDDATE                                             DATA_REGISTRO  " &
"  " &
" FROM      WMWHSE7.ORDERS  " &
"  " &
" INNER JOIN baandb.tznsls401301@pln01 znsls401  " &
"         ON znsls401.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN BAANDB.TTDSLS400301@pln01 TDSLS400  " &
"         ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN ( select a.orderkey,  " &
"                     a.status from WMWHSE7.orderstatushistory a  " &
"               where a.serialkey = ( SELECT MAX(b.serialkey)  " &
"                                       FROM WMWHSE7.orderstatushistory b  " &
"                                      WHERE b.orderkey = a.orderkey ) ) OH  " &
"         ON OH.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
"  LEFT JOIN ( select to_char(a.code) code,  " &
"                     to_char(a.description) description  " &
"                from WMWHSE7.ORDERSTATUSSETUP a  " &
"              union  " &
"              select '-5',  " &
"                     'Nota fiscal Inutilizada'  " &
"                from dual ) OS  " &
"         ON OS.CODE = nvl(OH.STATUS, ORDERS.STATUS)  " &
"  " &
"  LEFT JOIN WMWHSE7.CODELKUP  " &
"         ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"        AND CODELKUP.LISTNAME = 'SCHEMA'  " &
"  " &
" WHERE ORDERS.STATUS not in ('95', '96', '97', '98', '99', '100')  " &
"   AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE),'DD')  " &
"       Between NVL(:DataLimiteDe, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                            AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &
"           And NVL(:DataLimiteAte, TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                                             AT time zone 'America/Sao_Paulo') AS DATE),'DD'))  " &"  " &
" GROUP BY CASE WHEN NVL(TDSLS400.T$CREG,' ') = ' '  " &
"                 THEN 'INT'  " &
"               ELSE TDSLS400.T$CREG  " &
"          END,  " &
"          ORDERS.whseid,  " &
"          CODELKUP.UDF2,  " &
"          Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                    AT time zone 'America/Sao_Paulo') AS DATE),'DD'),  " &
"          ORDERS.SUSR4,  " &
"          NVL(OH.STATUS, ORDERS.STATUS),  " &
"          OS.DESCRIPTION,  " &
"          CASE WHEN ORDERS.SCHEDULEDSHIPDATE < ORDERS.ADDDATE  " &
"                 THEN 'ATRASO TERCEIRO'  " &
"               WHEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                        AT time zone 'America/Sao_Paulo') AS DATE) < SYSDATE  " &
"                 THEN 'ATRASO OP'  " &
"               ELSE   ' '  " &
"          END,  " &
"          ORDERS.ADDDATE  " &
"  " &
" ORDER BY ID_FILIAL, DATA_LIMITE  "

)