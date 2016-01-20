SELECT  
    ORDERS.WHSEID                                            ID_PLANTA,
    cl.UDF2                                                  DSC_PLANTA,
    ORDERS.ORDERKEY                                          PEDIDO,
    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE))          DATA,
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  HORA,
    CAGE.ADDWHO                                              ID_USUARIO,
    subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )     NOME_USUARIO,
    sum(ORDERDETAIL.ORIGINALQTY)                             QUANT,
    ORDERS.CARRIERCODE                                       ID_TRANSP,
    ORDERS.CARRIERNAME                                       TRANSP_NOME,
    ORDERS.DISCHARGEPLACE                                    ID_CONTRATO,
    CASE WHEN MAX(TO_CHAR(SKU.SUSR2)) = '2' 
           THEN 'PESADO' 
         ELSE   'LEVE' 
     END                                                     TP_TRANSP_ITEM ,
    MAX(WAVEDETAIL.WAVEKEY)                                  ONDA,
    ORDERS.INVOICENUMBER                                     NF,
    ORDERS.LANE                                              SERIE,
    TRUNC(CAGE.ADDDATE)                                      INCL_GAIOLA,
    CAGE.CAGEID                                              CARGA,
    MAX(CAGE.QT_VOL)                                         NFCA_QT_VOLUMES,
    SUM(NVL(CISLI940.T$AMNT$L, TDSLS400.T$OAMT))             VALOR             

FROM       WMWHSE5.ORDERS

INNER JOIN WMWHSE5.ORDERDETAIL
        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY

INNER JOIN ENTERPRISE.CODELKUP CL
        ON UPPER(CL.UDF1) = ORDERS.WHSEID

INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = ORDERDETAIL.SKU

INNER JOIN ( select cg.cageid,
                    cd.orderid,
                    cg.closedate,
                    cg.addwho,
                    max(cd.adddate) adddate,
                    count(cd.volumeid) qt_vol
               from wmwhse5.cageid cg
         inner join wmwhse5.cageiddetail cd 
                 on cd.cageid = cg.cageid
              where cg.status in (3,4,5,6) 
           group by cg.cageid,
                    cd.orderid,
                    cg.closedate,
                    cg.addwho ) CAGE 
        ON CAGE.ORDERID = ORDERS.ORDERKEY
       
 LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940 
        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER
       AND CISLI940.T$SERI$L = ORDERS.LANE

 LEFT JOIN BAANDB.TTDSLS400301@PLN01 TDSLS400 
        ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT
        
 LEFT JOIN WMWHSE5.taskmanageruser tu 
        ON tu.userkey = CAGE.ADDWHO

 LEFT JOIN WMWHSE5.WAVEDETAIL
        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY
  
where TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataDe
          And :DataAte
  
GROUP BY ORDERS.WHSEID,                                            
         CL.UDF2,                                         
         ORDERS.ORDERKEY,                                          
         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE)),
         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),
         CAGE.ADDWHO,                                
         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                                   
         ORDERS.CARRIERCODE,                                       
         ORDERS.CARRIERNAME,                                       
         ORDERS.DISCHARGEPLACE,                                                                                                      
         ORDERS.INVOICENUMBER,            
         ORDERS.LANE,               
         TRUNC(CAGE.ADDDATE),                            
         CAGE.CAGEID
		 
ORDER BY ORDERS.ORDERKEY               



=IIF(Parameters!Table.Value <> "AAA",

"SELECT                                                                        " &
"    ORDERS.WHSEID                                            ID_PLANTA,       " &
"    cl.UDF2                                                  DSC_PLANTA,      " &
"    ORDERS.ORDERKEY                                          PEDIDO,          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))          DATA,            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  HORA,            " &
"    CAGE.ADDWHO                                              ID_USUARIO,      " &
"    subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )     NOME_USUARIO,    " &
"    sum(ORDERDETAIL.ORIGINALQTY)                             QUANT,           " &
"    ORDERS.CARRIERCODE                                       ID_TRANSP,       " &
"    ORDERS.CARRIERNAME                                       TRANSP_NOME,     " &
"    ORDERS.DISCHARGEPLACE                                    ID_CONTRATO,     " &
"    CASE WHEN MAX(TO_CHAR(SKU.SUSR2)) = '2'                                   " &
"           THEN 'PESADO'                                                      " &
"         ELSE   'LEVE'                                                        " &
"     END                                                     TP_TRANSP_ITEM , " &
"    MAX(WAVEDETAIL.WAVEKEY)                                  ONDA,            " &
"    ORDERS.INVOICENUMBER                                     NF,              " &
"    ORDERS.LANE                                              SERIE,           " &
"    TRUNC(CAGE.ADDDATE)                                      INCL_GAIOLA,     " &
"    CAGE.CAGEID                                              CARGA,           " &
"    MAX(CAGE.QT_VOL)                                         NFCA_QT_VOLUMES, " &
"    SUM(NVL(CISLI940.T$AMNT$L, TDSLS400.T$OAMT))             VALOR            " &
"FROM       " + Parameters!Table.Value + ".ORDERS                              " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERDETAIL                         " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                             " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                             " &
"        ON UPPER(CL.UDF1) = ORDERS.WHSEID                                     " &
"INNER JOIN " + Parameters!Table.Value + ".SKU                                 " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                          " &
"INNER JOIN ( select cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho,                                                " &
"                    max(cd.adddate) adddate,                                  " &
"                    count(cd.volumeid) qt_vol                                 " &
"               from " + Parameters!Table.Value + ".cageid cg                  " &
"         inner join " + Parameters!Table.Value + ".cageiddetail cd            " &
"                 on cd.cageid = cg.cageid                                     " &
"              where cg.status in (3,4,5,6)                                    " &
"           group by cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho ) CAGE                                          " &
"        ON CAGE.ORDERID = ORDERS.ORDERKEY                                     " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940                                 " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                           " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                                    " &
" LEFT JOIN BAANDB.TTDSLS400301@PLN01 TDSLS400                                 " &
"        ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT                         " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu                  " &
"        ON tu.userkey = CAGE.ADDWHO                                           " &
" LEFT JOIN " + Parameters!Table.Value + ".WAVEDETAIL                          " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY                              " &
"where TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                           " &
"      Between '" + Parameters!DataDe.Value + "'                               " &
"          And '" + Parameters!DataAte.Value + "'                              " &
"GROUP BY ORDERS.WHSEID,                                                       " &
"         CL.UDF2,                                                             " &
"         ORDERS.ORDERKEY,                                                     " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,             " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE)),                     " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,           " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),             " &
"         CAGE.ADDWHO,                                                         " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         ORDERS.CARRIERCODE,                                                  " &
"         ORDERS.CARRIERNAME,                                                  " &
"         ORDERS.DISCHARGEPLACE,                                               " &
"         ORDERS.INVOICENUMBER,                                                " &
"         ORDERS.LANE,                                                         " &
"         TRUNC(CAGE.ADDDATE),                                                 " &
"         CAGE.CAGEID                                                          " &
"                                                                              " &
" ORDER BY DSC_PLANTA, PEDIDO                                                  "

,

"SELECT                                                                        " &
"    ORDERS.WHSEID                                            ID_PLANTA,       " &
"    cl.UDF2                                                  DSC_PLANTA,      " &
"    ORDERS.ORDERKEY                                          PEDIDO,          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))          DATA,            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  HORA,            " &
"    CAGE.ADDWHO                                              ID_USUARIO,      " &
"    subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )     NOME_USUARIO,    " &
"    sum(ORDERDETAIL.ORIGINALQTY)                             QUANT,           " &
"    ORDERS.CARRIERCODE                                       ID_TRANSP,       " &
"    ORDERS.CARRIERNAME                                       TRANSP_NOME,     " &
"    ORDERS.DISCHARGEPLACE                                    ID_CONTRATO,     " &
"    CASE WHEN MAX(TO_CHAR(SKU.SUSR2)) = '2'                                   " &
"           THEN 'PESADO'                                                      " &
"         ELSE   'LEVE'                                                        " &
"     END                                                     TP_TRANSP_ITEM , " &
"    MAX(WAVEDETAIL.WAVEKEY)                                  ONDA,            " &
"    ORDERS.INVOICENUMBER                                     NF,              " &
"    ORDERS.LANE                                              SERIE,           " &
"    TRUNC(CAGE.ADDDATE)                                      INCL_GAIOLA,     " &
"    CAGE.CAGEID                                              CARGA,           " &
"    MAX(CAGE.QT_VOL)                                         NFCA_QT_VOLUMES, " &
"    SUM(NVL(CISLI940.T$AMNT$L, TDSLS400.T$OAMT))             VALOR            " &
"FROM       WMWHSE1.ORDERS                                                     " &
"INNER JOIN WMWHSE1.ORDERDETAIL                                                " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                             " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                             " &
"        ON UPPER(CL.UDF1) = ORDERS.WHSEID                                     " &
"INNER JOIN WMWHSE1.SKU                                                        " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                          " &
"INNER JOIN ( select cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho,                                                " &
"                    max(cd.adddate) adddate,                                  " &
"                    count(cd.volumeid) qt_vol                                 " &
"               from WMWHSE1.cageid cg                                         " &
"         inner join WMWHSE1.cageiddetail cd                                   " &
"                 on cd.cageid = cg.cageid                                     " &
"              where cg.status in (3,4,5,6)                                    " &
"           group by cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho ) CAGE                                          " &
"        ON CAGE.ORDERID = ORDERS.ORDERKEY                                     " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940                                 " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                           " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                                    " &
" LEFT JOIN BAANDB.TTDSLS400301@PLN01 TDSLS400                                 " &
"        ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT                         " &
" LEFT JOIN WMWHSE1.taskmanageruser tu                                         " &
"        ON tu.userkey = CAGE.ADDWHO                                           " &
" LEFT JOIN WMWHSE1.WAVEDETAIL                                                 " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY                              " &
"where TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                           " &
"      Between '" + Parameters!DataDe.Value + "'                               " &
"          And '" + Parameters!DataAte.Value + "'                              " &
"GROUP BY ORDERS.WHSEID,                                                       " &
"         CL.UDF2,                                                             " &
"         ORDERS.ORDERKEY,                                                     " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,             " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE)),                     " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,           " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),             " &
"         CAGE.ADDWHO,                                                         " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         ORDERS.CARRIERCODE,                                                  " &
"         ORDERS.CARRIERNAME,                                                  " &
"         ORDERS.DISCHARGEPLACE,                                               " &
"         ORDERS.INVOICENUMBER,                                                " &
"         ORDERS.LANE,                                                         " &
"         TRUNC(CAGE.ADDDATE),                                                 " &
"         CAGE.CAGEID                                                          " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"    ORDERS.WHSEID                                            ID_PLANTA,       " &
"    cl.UDF2                                                  DSC_PLANTA,      " &
"    ORDERS.ORDERKEY                                          PEDIDO,          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))          DATA,            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  HORA,            " &
"    CAGE.ADDWHO                                              ID_USUARIO,      " &
"    subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )     NOME_USUARIO,    " &
"    sum(ORDERDETAIL.ORIGINALQTY)                             QUANT,           " &
"    ORDERS.CARRIERCODE                                       ID_TRANSP,       " &
"    ORDERS.CARRIERNAME                                       TRANSP_NOME,     " &
"    ORDERS.DISCHARGEPLACE                                    ID_CONTRATO,     " &
"    CASE WHEN MAX(TO_CHAR(SKU.SUSR2)) = '2'                                   " &
"           THEN 'PESADO'                                                      " &
"         ELSE   'LEVE'                                                        " &
"     END                                                     TP_TRANSP_ITEM , " &
"    MAX(WAVEDETAIL.WAVEKEY)                                  ONDA,            " &
"    ORDERS.INVOICENUMBER                                     NF,              " &
"    ORDERS.LANE                                              SERIE,           " &
"    TRUNC(CAGE.ADDDATE)                                      INCL_GAIOLA,     " &
"    CAGE.CAGEID                                              CARGA,           " &
"    MAX(CAGE.QT_VOL)                                         NFCA_QT_VOLUMES, " &
"    SUM(NVL(CISLI940.T$AMNT$L, TDSLS400.T$OAMT))             VALOR            " &
"FROM       WMWHSE2.ORDERS                                                     " &
"INNER JOIN WMWHSE2.ORDERDETAIL                                                " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                             " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                             " &
"        ON UPPER(CL.UDF1) = ORDERS.WHSEID                                     " &
"INNER JOIN WMWHSE2.SKU                                                        " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                          " &
"INNER JOIN ( select cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho,                                                " &
"                    max(cd.adddate) adddate,                                  " &
"                    count(cd.volumeid) qt_vol                                 " &
"               from WMWHSE2.cageid cg                                         " &
"         inner join WMWHSE2.cageiddetail cd                                   " &
"                 on cd.cageid = cg.cageid                                     " &
"              where cg.status in (3,4,5,6)                                    " &
"           group by cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho ) CAGE                                          " &
"        ON CAGE.ORDERID = ORDERS.ORDERKEY                                     " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940                                 " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                           " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                                    " &
" LEFT JOIN BAANDB.TTDSLS400301@PLN01 TDSLS400                                 " &
"        ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT                         " &
" LEFT JOIN WMWHSE2.taskmanageruser tu                                         " &
"        ON tu.userkey = CAGE.ADDWHO                                           " &
" LEFT JOIN WMWHSE2.WAVEDETAIL                                                 " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY                              " &
"where TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                           " &
"      Between '" + Parameters!DataDe.Value + "'                               " &
"          And '" + Parameters!DataAte.Value + "'                              " &
"GROUP BY ORDERS.WHSEID,                                                       " &
"         CL.UDF2,                                                             " &
"         ORDERS.ORDERKEY,                                                     " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,             " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE)),                     " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,           " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),             " &
"         CAGE.ADDWHO,                                                         " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         ORDERS.CARRIERCODE,                                                  " &
"         ORDERS.CARRIERNAME,                                                  " &
"         ORDERS.DISCHARGEPLACE,                                               " &
"         ORDERS.INVOICENUMBER,                                                " &
"         ORDERS.LANE,                                                         " &
"         TRUNC(CAGE.ADDDATE),                                                 " &
"         CAGE.CAGEID                                                          " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"    ORDERS.WHSEID                                            ID_PLANTA,       " &
"    cl.UDF2                                                  DSC_PLANTA,      " &
"    ORDERS.ORDERKEY                                          PEDIDO,          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))          DATA,            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  HORA,            " &
"    CAGE.ADDWHO                                              ID_USUARIO,      " &
"    subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )     NOME_USUARIO,    " &
"    sum(ORDERDETAIL.ORIGINALQTY)                             QUANT,           " &
"    ORDERS.CARRIERCODE                                       ID_TRANSP,       " &
"    ORDERS.CARRIERNAME                                       TRANSP_NOME,     " &
"    ORDERS.DISCHARGEPLACE                                    ID_CONTRATO,     " &
"    CASE WHEN MAX(TO_CHAR(SKU.SUSR2)) = '2'                                   " &
"           THEN 'PESADO'                                                      " &
"         ELSE   'LEVE'                                                        " &
"     END                                                     TP_TRANSP_ITEM , " &
"    MAX(WAVEDETAIL.WAVEKEY)                                  ONDA,            " &
"    ORDERS.INVOICENUMBER                                     NF,              " &
"    ORDERS.LANE                                              SERIE,           " &
"    TRUNC(CAGE.ADDDATE)                                      INCL_GAIOLA,     " &
"    CAGE.CAGEID                                              CARGA,           " &
"    MAX(CAGE.QT_VOL)                                         NFCA_QT_VOLUMES, " &
"    SUM(NVL(CISLI940.T$AMNT$L, TDSLS400.T$OAMT))             VALOR            " &
"FROM       WMWHSE3.ORDERS                                                     " &
"INNER JOIN WMWHSE3.ORDERDETAIL                                                " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                             " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                             " &
"        ON UPPER(CL.UDF1) = ORDERS.WHSEID                                     " &
"INNER JOIN WMWHSE3.SKU                                                        " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                          " &
"INNER JOIN ( select cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho,                                                " &
"                    max(cd.adddate) adddate,                                  " &
"                    count(cd.volumeid) qt_vol                                 " &
"               from WMWHSE3.cageid cg                                         " &
"         inner join WMWHSE3.cageiddetail cd                                   " &
"                 on cd.cageid = cg.cageid                                     " &
"              where cg.status in (3,4,5,6)                                    " &
"           group by cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho ) CAGE                                          " &
"        ON CAGE.ORDERID = ORDERS.ORDERKEY                                     " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940                                 " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                           " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                                    " &
" LEFT JOIN BAANDB.TTDSLS400301@PLN01 TDSLS400                                 " &
"        ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT                         " &
" LEFT JOIN WMWHSE3.taskmanageruser tu                                         " &
"        ON tu.userkey = CAGE.ADDWHO                                           " &
" LEFT JOIN WMWHSE3.WAVEDETAIL                                                 " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY                              " &
"where TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                           " &
"      Between '" + Parameters!DataDe.Value + "'                               " &
"          And '" + Parameters!DataAte.Value + "'                              " &
"GROUP BY ORDERS.WHSEID,                                                       " &
"         CL.UDF2,                                                             " &
"         ORDERS.ORDERKEY,                                                     " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,             " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE)),                     " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,           " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),             " &
"         CAGE.ADDWHO,                                                         " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         ORDERS.CARRIERCODE,                                                  " &
"         ORDERS.CARRIERNAME,                                                  " &
"         ORDERS.DISCHARGEPLACE,                                               " &
"         ORDERS.INVOICENUMBER,                                                " &
"         ORDERS.LANE,                                                         " &
"         TRUNC(CAGE.ADDDATE),                                                 " &
"         CAGE.CAGEID                                                          " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"    ORDERS.WHSEID                                            ID_PLANTA,       " &
"    cl.UDF2                                                  DSC_PLANTA,      " &
"    ORDERS.ORDERKEY                                          PEDIDO,          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))          DATA,            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  HORA,            " &
"    CAGE.ADDWHO                                              ID_USUARIO,      " &
"    subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )     NOME_USUARIO,    " &
"    sum(ORDERDETAIL.ORIGINALQTY)                             QUANT,           " &
"    ORDERS.CARRIERCODE                                       ID_TRANSP,       " &
"    ORDERS.CARRIERNAME                                       TRANSP_NOME,     " &
"    ORDERS.DISCHARGEPLACE                                    ID_CONTRATO,     " &
"    CASE WHEN MAX(TO_CHAR(SKU.SUSR2)) = '2'                                   " &
"           THEN 'PESADO'                                                      " &
"         ELSE   'LEVE'                                                        " &
"     END                                                     TP_TRANSP_ITEM , " &
"    MAX(WAVEDETAIL.WAVEKEY)                                  ONDA,            " &
"    ORDERS.INVOICENUMBER                                     NF,              " &
"    ORDERS.LANE                                              SERIE,           " &
"    TRUNC(CAGE.ADDDATE)                                      INCL_GAIOLA,     " &
"    CAGE.CAGEID                                              CARGA,           " &
"    MAX(CAGE.QT_VOL)                                         NFCA_QT_VOLUMES, " &
"    SUM(NVL(CISLI940.T$AMNT$L, TDSLS400.T$OAMT))             VALOR            " &
"FROM       WMWHSE4.ORDERS                                                     " &
"INNER JOIN WMWHSE4.ORDERDETAIL                                                " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                             " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                             " &
"        ON UPPER(CL.UDF1) = ORDERS.WHSEID                                     " &
"INNER JOIN WMWHSE4.SKU                                                        " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                          " &
"INNER JOIN ( select cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho,                                                " &
"                    max(cd.adddate) adddate,                                  " &
"                    count(cd.volumeid) qt_vol                                 " &
"               from WMWHSE4.cageid cg                                         " &
"         inner join WMWHSE4.cageiddetail cd                                   " &
"                 on cd.cageid = cg.cageid                                     " &
"              where cg.status in (3,4,5,6)                                    " &
"           group by cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho ) CAGE                                          " &
"        ON CAGE.ORDERID = ORDERS.ORDERKEY                                     " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940                                 " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                           " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                                    " &
" LEFT JOIN BAANDB.TTDSLS400301@PLN01 TDSLS400                                 " &
"        ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT                         " &
" LEFT JOIN WMWHSE4.taskmanageruser tu                                         " &
"        ON tu.userkey = CAGE.ADDWHO                                           " &
" LEFT JOIN WMWHSE4.WAVEDETAIL                                                 " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY                              " &
"where TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                           " &
"      Between '" + Parameters!DataDe.Value + "'                               " &
"          And '" + Parameters!DataAte.Value + "'                              " &
"GROUP BY ORDERS.WHSEID,                                                       " &
"         CL.UDF2,                                                             " &
"         ORDERS.ORDERKEY,                                                     " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,             " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE)),                     " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,           " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),             " &
"         CAGE.ADDWHO,                                                         " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         ORDERS.CARRIERCODE,                                                  " &
"         ORDERS.CARRIERNAME,                                                  " &
"         ORDERS.DISCHARGEPLACE,                                               " &
"         ORDERS.INVOICENUMBER,                                                " &
"         ORDERS.LANE,                                                         " &
"         TRUNC(CAGE.ADDDATE),                                                 " &
"         CAGE.CAGEID                                                          " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"    ORDERS.WHSEID                                            ID_PLANTA,       " &
"    cl.UDF2                                                  DSC_PLANTA,      " &
"    ORDERS.ORDERKEY                                          PEDIDO,          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))          DATA,            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  HORA,            " &
"    CAGE.ADDWHO                                              ID_USUARIO,      " &
"    subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )     NOME_USUARIO,    " &
"    sum(ORDERDETAIL.ORIGINALQTY)                             QUANT,           " &
"    ORDERS.CARRIERCODE                                       ID_TRANSP,       " &
"    ORDERS.CARRIERNAME                                       TRANSP_NOME,     " &
"    ORDERS.DISCHARGEPLACE                                    ID_CONTRATO,     " &
"    CASE WHEN MAX(TO_CHAR(SKU.SUSR2)) = '2'                                   " &
"           THEN 'PESADO'                                                      " &
"         ELSE   'LEVE'                                                        " &
"     END                                                     TP_TRANSP_ITEM , " &
"    MAX(WAVEDETAIL.WAVEKEY)                                  ONDA,            " &
"    ORDERS.INVOICENUMBER                                     NF,              " &
"    ORDERS.LANE                                              SERIE,           " &
"    TRUNC(CAGE.ADDDATE)                                      INCL_GAIOLA,     " &
"    CAGE.CAGEID                                              CARGA,           " &
"    MAX(CAGE.QT_VOL)                                         NFCA_QT_VOLUMES, " &
"    SUM(NVL(CISLI940.T$AMNT$L, TDSLS400.T$OAMT))             VALOR            " &
"FROM       WMWHSE5.ORDERS                                                     " &
"INNER JOIN WMWHSE5.ORDERDETAIL                                                " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                             " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                             " &
"        ON UPPER(CL.UDF1) = ORDERS.WHSEID                                     " &
"INNER JOIN WMWHSE5.SKU                                                        " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                          " &
"INNER JOIN ( select cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho,                                                " &
"                    max(cd.adddate) adddate,                                  " &
"                    count(cd.volumeid) qt_vol                                 " &
"               from WMWHSE5.cageid cg                                         " &
"         inner join WMWHSE5.cageiddetail cd                                   " &
"                 on cd.cageid = cg.cageid                                     " &
"              where cg.status in (3,4,5,6)                                    " &
"           group by cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho ) CAGE                                          " &
"        ON CAGE.ORDERID = ORDERS.ORDERKEY                                     " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940                                 " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                           " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                                    " &
" LEFT JOIN BAANDB.TTDSLS400301@PLN01 TDSLS400                                 " &
"        ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT                         " &
" LEFT JOIN WMWHSE5.taskmanageruser tu                                         " &
"        ON tu.userkey = CAGE.ADDWHO                                           " &
" LEFT JOIN WMWHSE5.WAVEDETAIL                                                 " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY                              " &
"where TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                           " &
"      Between '" + Parameters!DataDe.Value + "'                               " &
"          And '" + Parameters!DataAte.Value + "'                              " &
"GROUP BY ORDERS.WHSEID,                                                       " &
"         CL.UDF2,                                                             " &
"         ORDERS.ORDERKEY,                                                     " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,             " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE)),                     " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,           " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),             " &
"         CAGE.ADDWHO,                                                         " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         ORDERS.CARRIERCODE,                                                  " &
"         ORDERS.CARRIERNAME,                                                  " &
"         ORDERS.DISCHARGEPLACE,                                               " &
"         ORDERS.INVOICENUMBER,                                                " &
"         ORDERS.LANE,                                                         " &
"         TRUNC(CAGE.ADDDATE),                                                 " &
"         CAGE.CAGEID                                                          " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"    ORDERS.WHSEID                                            ID_PLANTA,       " &
"    cl.UDF2                                                  DSC_PLANTA,      " &
"    ORDERS.ORDERKEY                                          PEDIDO,          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))          DATA,            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  HORA,            " &
"    CAGE.ADDWHO                                              ID_USUARIO,      " &
"    subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )     NOME_USUARIO,    " &
"    sum(ORDERDETAIL.ORIGINALQTY)                             QUANT,           " &
"    ORDERS.CARRIERCODE                                       ID_TRANSP,       " &
"    ORDERS.CARRIERNAME                                       TRANSP_NOME,     " &
"    ORDERS.DISCHARGEPLACE                                    ID_CONTRATO,     " &
"    CASE WHEN MAX(TO_CHAR(SKU.SUSR2)) = '2'                                   " &
"           THEN 'PESADO'                                                      " &
"         ELSE   'LEVE'                                                        " &
"     END                                                     TP_TRANSP_ITEM , " &
"    MAX(WAVEDETAIL.WAVEKEY)                                  ONDA,            " &
"    ORDERS.INVOICENUMBER                                     NF,              " &
"    ORDERS.LANE                                              SERIE,           " &
"    TRUNC(CAGE.ADDDATE)                                      INCL_GAIOLA,     " &
"    CAGE.CAGEID                                              CARGA,           " &
"    MAX(CAGE.QT_VOL)                                         NFCA_QT_VOLUMES, " &
"    SUM(NVL(CISLI940.T$AMNT$L, TDSLS400.T$OAMT))             VALOR            " &
"FROM       WMWHSE6.ORDERS                                                     " &
"INNER JOIN WMWHSE6.ORDERDETAIL                                                " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                             " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                             " &
"        ON UPPER(CL.UDF1) = ORDERS.WHSEID                                     " &
"INNER JOIN WMWHSE6.SKU                                                        " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                          " &
"INNER JOIN ( select cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho,                                                " &
"                    max(cd.adddate) adddate,                                  " &
"                    count(cd.volumeid) qt_vol                                 " &
"               from WMWHSE6.cageid cg                                         " &
"         inner join WMWHSE6.cageiddetail cd                                   " &
"                 on cd.cageid = cg.cageid                                     " &
"              where cg.status in (3,4,5,6)                                    " &
"           group by cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho ) CAGE                                          " &
"        ON CAGE.ORDERID = ORDERS.ORDERKEY                                     " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940                                 " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                           " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                                    " &
" LEFT JOIN BAANDB.TTDSLS400301@PLN01 TDSLS400                                 " &
"        ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT                         " &
" LEFT JOIN WMWHSE6.taskmanageruser tu                                         " &
"        ON tu.userkey = CAGE.ADDWHO                                           " &
" LEFT JOIN WMWHSE6.WAVEDETAIL                                                 " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY                              " &
"where TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                           " &
"      Between '" + Parameters!DataDe.Value + "'                               " &
"          And '" + Parameters!DataAte.Value + "'                              " &
"GROUP BY ORDERS.WHSEID,                                                       " &
"         CL.UDF2,                                                             " &
"         ORDERS.ORDERKEY,                                                     " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,             " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE)),                     " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,           " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),             " &
"         CAGE.ADDWHO,                                                         " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         ORDERS.CARRIERCODE,                                                  " &
"         ORDERS.CARRIERNAME,                                                  " &
"         ORDERS.DISCHARGEPLACE,                                               " &
"         ORDERS.INVOICENUMBER,                                                " &
"         ORDERS.LANE,                                                         " &
"         TRUNC(CAGE.ADDDATE),                                                 " &
"         CAGE.CAGEID                                                          " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT                                                                        " &
"    ORDERS.WHSEID                                            ID_PLANTA,       " &
"    cl.UDF2                                                  DSC_PLANTA,      " &
"    ORDERS.ORDERKEY                                          PEDIDO,          " &
"    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))          DATA,            " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')  HORA,            " &
"    CAGE.ADDWHO                                              ID_USUARIO,      " &
"    subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )     NOME_USUARIO,    " &
"    sum(ORDERDETAIL.ORIGINALQTY)                             QUANT,           " &
"    ORDERS.CARRIERCODE                                       ID_TRANSP,       " &
"    ORDERS.CARRIERNAME                                       TRANSP_NOME,     " &
"    ORDERS.DISCHARGEPLACE                                    ID_CONTRATO,     " &
"    CASE WHEN MAX(TO_CHAR(SKU.SUSR2)) = '2'                                   " &
"           THEN 'PESADO'                                                      " &
"         ELSE   'LEVE'                                                        " &
"     END                                                     TP_TRANSP_ITEM , " &
"    MAX(WAVEDETAIL.WAVEKEY)                                  ONDA,            " &
"    ORDERS.INVOICENUMBER                                     NF,              " &
"    ORDERS.LANE                                              SERIE,           " &
"    TRUNC(CAGE.ADDDATE)                                      INCL_GAIOLA,     " &
"    CAGE.CAGEID                                              CARGA,           " &
"    MAX(CAGE.QT_VOL)                                         NFCA_QT_VOLUMES, " &
"    SUM(NVL(CISLI940.T$AMNT$L, TDSLS400.T$OAMT))             VALOR            " &
"FROM       WMWHSE7.ORDERS                                                     " &
"INNER JOIN WMWHSE7.ORDERDETAIL                                                " &
"        ON ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                             " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                             " &
"        ON UPPER(CL.UDF1) = ORDERS.WHSEID                                     " &
"INNER JOIN WMWHSE7.SKU                                                        " &
"        ON SKU.SKU = ORDERDETAIL.SKU                                          " &
"INNER JOIN ( select cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho,                                                " &
"                    max(cd.adddate) adddate,                                  " &
"                    count(cd.volumeid) qt_vol                                 " &
"               from WMWHSE7.cageid cg                                         " &
"         inner join WMWHSE7.cageiddetail cd                                   " &
"                 on cd.cageid = cg.cageid                                     " &
"              where cg.status in (3,4,5,6)                                    " &
"           group by cg.cageid,                                                " &
"                    cd.orderid,                                               " &
"                    cg.closedate,                                             " &
"                    cg.addwho ) CAGE                                          " &
"        ON CAGE.ORDERID = ORDERS.ORDERKEY                                     " &
" LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940                                 " &
"        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER                           " &
"       AND CISLI940.T$SERI$L = ORDERS.LANE                                    " &
" LEFT JOIN BAANDB.TTDSLS400301@PLN01 TDSLS400                                 " &
"        ON TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT                         " &
" LEFT JOIN WMWHSE7.taskmanageruser tu                                         " &
"        ON tu.userkey = CAGE.ADDWHO                                           " &
" LEFT JOIN WMWHSE7.WAVEDETAIL                                                 " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY                              " &
"where TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,                " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')            " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                           " &
"      Between '" + Parameters!DataDe.Value + "'                               " &
"          And '" + Parameters!DataAte.Value + "'                              " &
"GROUP BY ORDERS.WHSEID,                                                       " &
"         CL.UDF2,                                                             " &
"         ORDERS.ORDERKEY,                                                     " &
"         TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,             " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE)),                     " &
"         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE,           " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')       " &
"             AT time zone 'America/Sao_Paulo') AS DATE), 'HH24'),             " &
"         CAGE.ADDWHO,                                                         " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                  " &
"         ORDERS.CARRIERCODE,                                                  " &
"         ORDERS.CARRIERNAME,                                                  " &
"         ORDERS.DISCHARGEPLACE,                                               " &
"         ORDERS.INVOICENUMBER,                                                " &
"         ORDERS.LANE,                                                         " &
"         TRUNC(CAGE.ADDDATE),                                                 " &
"         CAGE.CAGEID                                                          " &
"                                                                              " &
" ORDER BY DSC_PLANTA, PEDIDO                                                  "

)