SELECT 
  WSOR.WHSEID                  ID_FILIAL,
  wmsCODE.UDF2                 NOME_FILIAL,
  WHINH200.T$ORNO              PEDIDO_LN,
  WSOR.ORDERKEY                PEDIDO_WMS,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                               DATA_REGISTRO,
  WOSS.DESCRIPTION             EVENTO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                               DATA_EVENTO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$DATE$L, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                               DATA_FATURAMENTO,
  WSOR.INVOICENUMBER           NF,
  WSOR.LANE                    NF_SERIE,
  NVL(TCMCS966.T$DSCA$L,
      TCMCS966x.T$DSCA$L)      DESCR_TP_DOC_FISCAL,
  WHINH010.T$DSCA              NOME_OPERADOR,
  TRIM(WHINH220.T$ITEM)        ITEM,
  TCIBD001.T$DSCA              DESCRICAO,
  TCMCS023.T$DSCA              DEPARTAMENTO,
  LNCF.T$FOVN$L                CNPJ_FABRICANTE,
  LNFB.T$DSCA                  NOME_FABRICANTE,
  LNCC.T$FOVN$L                CNPJ_CLIENTE,
  LNCC.T$NAMA                  NOME_CLIENTE,
  WHWMD400.T$HGHT * 
  WHWMD400.T$WDTH * 
  WHWMD400.T$DPTH              M3_UNITARIO,
  WHINH220.T$QORO              QTD_PEDIDO,
  WHINH220.T$QORO              QTD_CANCELADA,     -- Será sempre o mesmo que a quantidade do pedido pois no Ln não temos entrega parcial
  NVL(CISLI941.T$DQUA$L,0)     QTD_FATURADA,
  ABS(CISLI941.T$PRIC$L)       VALOR_NF_UNITARIO,
  ABS(CISLI941.T$AMNT$L)       VALOR_NF_TOTAL,
  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,
  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO

FROM       BAANDB.TWHINH200301     WHINH200

INNER JOIN WMWHSE5.ORDERS@DL_LN_WMS   WSOR
        ON CASE WHEN INSTR(WSOR.REFERENCEDOCUMENT, '_') = 0
                  THEN WSOR.REFERENCEDOCUMENT
                ELSE   SUBSTR(WSOR.REFERENCEDOCUMENT, 4, 9)
            END  = WHINH200.T$ORNO

INNER JOIN ( select A.LONG_VALUE,
                    UPPER(A.UDF1) UDF1,
                    A.UDF2
               from ENTERPRISE.CODELKUP@DL_LN_WMS A
              where A.LISTNAME = 'SCHEMA') wmsCODE
        ON wmsCODE.UDF1 = WSOR.WHSEID
  
INNER JOIN WMWHSE5.ORDERSTATUSSETUP@DL_LN_WMS WOSS
        ON WOSS.CODE = WSOR.STATUS

INNER JOIN BAANDB.TWHINH010301  WHINH010
        ON WHINH010.T$OTYP = WHINH200.T$OTYP
    
INNER JOIN BAANDB.TWHINH220301  WHINH220
        ON WHINH220.T$OORG = WHINH200.T$OORG
       AND WHINH220.T$ORNO = WHINH200.T$ORNO
       AND WHINH220.T$SEQN = WHINH200.T$OSET  

INNER JOIN BAANDB.TTCIBD001301  TCIBD001
        ON TCIBD001.T$ITEM = WHINH220.T$ITEM

 LEFT JOIN BAANDB.TWHWMD400301  WHWMD400
        ON WHWMD400.T$ITEM = Trim(WHINH220.T$ITEM)
    
 LEFT JOIN (       Select  3 koor,  1 oorg From DUAL
             Union Select  7 koor,  2 oorg From DUAL
             Union Select 34 koor,  3 oorg From DUAL
             Union Select  2 koor, 80 oorg From DUAL
             Union Select  6 koor, 81 oorg From DUAL
             Union Select 33 koor, 82 oorg From DUAL
             Union Select 17 koor, 11 oorg From DUAL
             Union Select 35 koor, 12 oorg From DUAL
             Union Select 37 koor, 31 oorg From DUAL
             Union Select 39 koor, 32 oorg From DUAL
             Union Select 38 koor, 33 oorg From DUAL
             Union Select 42 koor, 34 oorg From DUAL
             Union Select  1 koor, 50 oorg From DUAL
             Union Select 32 koor, 51 oorg From DUAL
             Union Select 56 koor, 53 oorg From DUAL
             Union Select  9 koor, 55 oorg From DUAL
             Union Select 46 koor, 56 oorg From DUAL
             Union Select 57 koor, 58 oorg From DUAL
             Union Select 22 koor, 71 oorg From DUAL
             Union Select 36 koor, 72 oorg From DUAL
             Union Select 58 koor, 75 oorg From DUAL
             Union Select 59 koor, 76 oorg From DUAL
             Union Select 60 koor, 90 oorg From DUAL
             Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG
        ON KOOR2OORG.OORG = WHINH220.T$OORG    

 LEFT JOIN BAANDB.TCISLI245301  CISLI245 
        ON CISLI245.T$SLCP = 301       
       AND CISLI245.T$ORTP = CASE WHEN WHINH220.T$OORG=1
                                    THEN 1
                                  ELSE 2 
                              END
       AND CISLI245.T$KOOR = KOOR2OORG.KOOR       
       AND CISLI245.T$SLSO = WHINH220.T$ORNO       
       AND CISLI245.T$OSET = WHINH200.T$OSET                  
       AND CISLI245.T$PONO = WHINH220.T$PONO
     
 LEFT JOIN BAANDB.TCISLI941301 CISLI941 
        ON CISLI941.T$FIRE$L = CISLI245.T$FIRE$L
       AND CISLI941.T$LINE$L = CISLI245.T$LINE$L
     
 LEFT JOIN BAANDB.TCISLI940301 CISLI940 
        ON CISLI940.T$FIRE$L = CISLI941.T$FIRE$L
 
 LEFT JOIN BAANDB.TTCMCS966301 TCMCS966
        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L  

 LEFT JOIN ( select A.T$FIRE$L,
                    A.T$DOCN$L,
                    A.T$SERI$L,
                    A.T$FDTC$L
               from BAANDB.TCISLI940301 A
              where A.T$DATG$L = ( SELECT MIN(B.T$DATG$L) 
                                     FROM BAANDB.TCISLI940301 B
                                    WHERE B.T$DOCN$L = A.T$DOCN$L
                                      AND B.T$SERI$L = A.T$SERI$L ) ) CISLI940x 
        ON CISLI940x.T$DOCN$L = WSOR.INVOICENUMBER
       AND CISLI940x.T$SERI$L = WSOR.LANE

 LEFT JOIN BAANDB.TTCMCS966301 TCMCS966x
        ON TCMCS966x.T$FDTC$L = CISLI940x.T$FDTC$L
      
 LEFT JOIN BAANDB.TTCMCS023301  TCMCS023
        ON TCMCS023.T$CITG = TCIBD001.T$CITG
     
 LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB 
        ON LNFB.T$CMNF = TCIBD001.T$CMNF
    
 LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF
        ON LNCF.T$CADR = LNFB.T$CADR

 LEFT JOIN BAANDB.TTDSLS400301  TDSLS400
        ON TDSLS400.T$ORNO = WHINH200.T$ORNO
    
 LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC
        ON LNCC.T$CADR = NVL(TDSLS400.T$OFAD, WHINH200.T$STAD)

 LEFT JOIN WMWHSE5.codelkup@DL_LN_WMS DIVS
        ON DIVS.CODE = WSOR.INVOICESTATUS
       AND DIVS.LISTNAME = 'INVSTATUS'
  
WHERE WSOR.STATUS = '100'
  AND ( select count(x.orderkey)
          from WMWHSE5.orders@DL_LN_WMS x
         where x.referencedocument = WSOR.referencedocument
           and x.adddate > WSOR.adddate ) = 0  
          
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataRegistroDe
          And :DataRegistroAte
  AND ((:PedidoTodos = 1)OR(WHINH200.T$ORNO IN (:Pedido) AND :PedidoTodos = 0))
  
ORDER BY PEDIDO_WMS, DATA_REGISTRO



=IIF(Parameters!Table.Value <> "AAA",

"SELECT  " &
"  WSOR.WHSEID                  ID_FILIAL,  " &
"  wmsCODE.UDF2                 NOME_FILIAL,  " &
"  WHINH200.T$ORNO              PEDIDO_LN,  " &
"  WSOR.ORDERKEY                PEDIDO_WMS,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_REGISTRO,  " &
"  WOSS.DESCRIPTION             EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$DATE$L,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_FATURAMENTO,  " &
"  WSOR.INVOICENUMBER           NF,  " &
"  WSOR.LANE                    NF_SERIE,  " &
"  NVL(TCMCS966.T$DSCA$L,  " &
"      TCMCS966x.T$DSCA$L)      DESCR_TP_DOC_FISCAL,  " &
"  WHINH010.T$DSCA              NOME_OPERADOR,  " &
"  TRIM(WHINH220.T$ITEM)        ITEM,  " &
"  TCIBD001.T$DSCA              DESCRICAO,  " &
"  TCMCS023.T$DSCA              DEPARTAMENTO,  " &
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  " &
"  LNFB.T$DSCA                  NOME_FABRICANTE,  " &
"  LNCC.T$FOVN$L                CNPJ_CLIENTE,  " &
"  LNCC.T$NAMA                  NOME_CLIENTE,  " &
"  WHWMD400.T$HGHT *  " &
"  WHWMD400.T$WDTH *  " &
"  WHWMD400.T$DPTH              M3_UNITARIO,  " &
"  WHINH220.T$QORO              QTD_PEDIDO,  " &
"  WHINH220.T$QORO              QTD_CANCELADA,  " &
"  NVL(CISLI941.T$DQUA$L,0)     QTD_FATURADA,  " &
"  ABS(CISLI941.T$PRIC$L)       VALOR_NF_UNITARIO,  " &
"  ABS(CISLI941.T$AMNT$L)       VALOR_NF_TOTAL,  " &
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  " &
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  " &
"FROM       BAANDB.TWHINH200301     WHINH200  " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERS@DL_LN_WMS   WSOR  " &
"        ON CASE WHEN INSTR(WSOR.REFERENCEDOCUMENT, '_') = 0  " &
"                  THEN WSOR.REFERENCEDOCUMENT  " &
"                ELSE   SUBSTR(WSOR.REFERENCEDOCUMENT, 4, 9)  " &
"            END  = WHINH200.T$ORNO  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.UDF1 = WSOR.WHSEID  " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP@DL_LN_WMS WOSS  " &
"        ON WOSS.CODE = WSOR.STATUS  " &
"INNER JOIN BAANDB.TWHINH010301  WHINH010  " &
"        ON WHINH010.T$OTYP = WHINH200.T$OTYP  " &
"INNER JOIN BAANDB.TWHINH220301  WHINH220  " &
"        ON WHINH220.T$OORG = WHINH200.T$OORG  " &
"       AND WHINH220.T$ORNO = WHINH200.T$ORNO  " &
"       AND WHINH220.T$SEQN = WHINH200.T$OSET  " &
"INNER JOIN BAANDB.TTCIBD001301  TCIBD001  " &
"        ON TCIBD001.T$ITEM = WHINH220.T$ITEM  " &
" LEFT JOIN BAANDB.TWHWMD400301  WHWMD400  " &
"        ON WHWMD400.T$ITEM = Trim(WHINH220.T$ITEM)  " &
" LEFT JOIN (       Select  3 koor,  1 oorg From DUAL  " &
"             Union Select  7 koor,  2 oorg From DUAL  " &
"             Union Select 34 koor,  3 oorg From DUAL  " &
"             Union Select  2 koor, 80 oorg From DUAL  " &
"             Union Select  6 koor, 81 oorg From DUAL  " &
"             Union Select 33 koor, 82 oorg From DUAL  " &
"             Union Select 17 koor, 11 oorg From DUAL  " &
"             Union Select 35 koor, 12 oorg From DUAL  " &
"             Union Select 37 koor, 31 oorg From DUAL  " &
"             Union Select 39 koor, 32 oorg From DUAL  " &
"             Union Select 38 koor, 33 oorg From DUAL  " &
"             Union Select 42 koor, 34 oorg From DUAL  " &
"             Union Select  1 koor, 50 oorg From DUAL  " &
"             Union Select 32 koor, 51 oorg From DUAL  " &
"             Union Select 56 koor, 53 oorg From DUAL  " &
"             Union Select  9 koor, 55 oorg From DUAL  " &
"             Union Select 46 koor, 56 oorg From DUAL  " &
"             Union Select 57 koor, 58 oorg From DUAL  " &
"             Union Select 22 koor, 71 oorg From DUAL  " &
"             Union Select 36 koor, 72 oorg From DUAL  " &
"             Union Select 58 koor, 75 oorg From DUAL  " &
"             Union Select 59 koor, 76 oorg From DUAL  " &
"             Union Select 60 koor, 90 oorg From DUAL  " &
"             Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG  " &
"        ON KOOR2OORG.OORG = WHINH220.T$OORG  " &
" LEFT JOIN BAANDB.TCISLI245301  CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = CASE WHEN WHINH220.T$OORG=1  " &
"                                    THEN 1  " &
"                                  ELSE 2  " &
"                              END  " &
"       AND CISLI245.T$KOOR = KOOR2OORG.KOOR  " &
"       AND CISLI245.T$SLSO = WHINH220.T$ORNO  " &
"       AND CISLI245.T$OSET = WHINH200.T$OSET  " &
"       AND CISLI245.T$PONO = WHINH220.T$PONO  " &
" LEFT JOIN BAANDB.TCISLI941301 CISLI941  " &
"        ON CISLI941.T$FIRE$L = CISLI245.T$FIRE$L  " &
"       AND CISLI941.T$LINE$L = CISLI245.T$LINE$L  " &
" LEFT JOIN BAANDB.TCISLI940301 CISLI940  " &
"        ON CISLI940.T$FIRE$L = CISLI941.T$FIRE$L  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L  " &
" LEFT JOIN ( select A.T$FIRE$L,  " &
"                    A.T$DOCN$L,  " &
"                    A.T$SERI$L,  " &
"                    A.T$FDTC$L  " &
"               from BAANDB.TCISLI940301 A  " &
"              where A.T$DATG$L = ( SELECT MIN(B.T$DATG$L)  " &
"                                     FROM BAANDB.TCISLI940301 B  " &
"                                    WHERE B.T$DOCN$L = A.T$DOCN$L  " &
"                                      AND B.T$SERI$L = A.T$SERI$L ) ) CISLI940x " &
"        ON CISLI940x.T$DOCN$L = WSOR.INVOICENUMBER  " &
"       AND CISLI940x.T$SERI$L = WSOR.LANE  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966x  " &
"        ON TCMCS966x.T$FDTC$L = CISLI940x.T$FDTC$L  " &
" LEFT JOIN BAANDB.TTCMCS023301  TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  " &
"        ON LNFB.T$CMNF = TCIBD001.T$CMNF  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  " &
"        ON LNCF.T$CADR = LNFB.T$CADR  " &
" LEFT JOIN BAANDB.TTDSLS400301  TDSLS400  " &
"        ON TDSLS400.T$ORNO = WHINH200.T$ORNO  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  " &
"        ON LNCC.T$CADR = NVL(TDSLS400.T$OFAD, WHINH200.T$STAD)  " &
" LEFT JOIN " + Parameters!Table.Value + ".codelkup@DL_LN_WMS DIVS  " &
"        ON DIVS.CODE = WSOR.INVOICESTATUS  " &
"       AND DIVS.LISTNAME = 'INVSTATUS'  " &
"WHERE WSOR.STATUS = '100'  " &
"  AND ( select count(x.orderkey)  " &
"          from " + Parameters!Table.Value + ".orders@DL_LN_WMS x  " &
"         where x.referencedocument = WSOR.referencedocument  " &
"           and x.adddate > WSOR.adddate ) = 0  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND (    (UPPER(Trim(WHINH200.T$ORNO)) IN ( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ",", "','") + "'")  + " )  " &
"        AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"         OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"ORDER BY NOME_FILIAL, PEDIDO_WMS, DATA_REGISTRO  "

,

"SELECT  " &
"  WSOR.WHSEID                  ID_FILIAL,  " &
"  wmsCODE.UDF2                 NOME_FILIAL,  " &
"  WHINH200.T$ORNO              PEDIDO_LN,  " &
"  WSOR.ORDERKEY                PEDIDO_WMS,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_REGISTRO,  " &
"  WOSS.DESCRIPTION             EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$DATE$L,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_FATURAMENTO,  " &
"  WSOR.INVOICENUMBER           NF,  " &
"  WSOR.LANE                    NF_SERIE,  " &
"  NVL(TCMCS966.T$DSCA$L,  " &
"      TCMCS966x.T$DSCA$L)      DESCR_TP_DOC_FISCAL,  " &
"  WHINH010.T$DSCA              NOME_OPERADOR,  " &
"  TRIM(WHINH220.T$ITEM)        ITEM,  " &
"  TCIBD001.T$DSCA              DESCRICAO,  " &
"  TCMCS023.T$DSCA              DEPARTAMENTO,  " &
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  " &
"  LNFB.T$DSCA                  NOME_FABRICANTE,  " &
"  LNCC.T$FOVN$L                CNPJ_CLIENTE,  " &
"  LNCC.T$NAMA                  NOME_CLIENTE,  " &
"  WHWMD400.T$HGHT *  " &
"  WHWMD400.T$WDTH *  " &
"  WHWMD400.T$DPTH              M3_UNITARIO,  " &
"  WHINH220.T$QORO              QTD_PEDIDO,  " &
"  WHINH220.T$QORO              QTD_CANCELADA,  " &
"  NVL(CISLI941.T$DQUA$L,0)     QTD_FATURADA,  " &
"  ABS(CISLI941.T$PRIC$L)       VALOR_NF_UNITARIO,  " &
"  ABS(CISLI941.T$AMNT$L)       VALOR_NF_TOTAL,  " &
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  " &
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  " &
"FROM       BAANDB.TWHINH200301     WHINH200  " &
"INNER JOIN WMWHSE1.ORDERS@DL_LN_WMS   WSOR  " &
"        ON CASE WHEN INSTR(WSOR.REFERENCEDOCUMENT, '_') = 0  " &
"                  THEN WSOR.REFERENCEDOCUMENT  " &
"                ELSE   SUBSTR(WSOR.REFERENCEDOCUMENT, 4, 9)  " &
"            END  = WHINH200.T$ORNO  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.UDF1 = WSOR.WHSEID  " &
"INNER JOIN WMWHSE1.ORDERSTATUSSETUP@DL_LN_WMS WOSS  " &
"        ON WOSS.CODE = WSOR.STATUS  " &
"INNER JOIN BAANDB.TWHINH010301  WHINH010  " &
"        ON WHINH010.T$OTYP = WHINH200.T$OTYP  " &
"INNER JOIN BAANDB.TWHINH220301  WHINH220  " &
"        ON WHINH220.T$OORG = WHINH200.T$OORG  " &
"       AND WHINH220.T$ORNO = WHINH200.T$ORNO  " &
"       AND WHINH220.T$SEQN = WHINH200.T$OSET  " &
"INNER JOIN BAANDB.TTCIBD001301  TCIBD001  " &
"        ON TCIBD001.T$ITEM = WHINH220.T$ITEM  " &
" LEFT JOIN BAANDB.TWHWMD400301  WHWMD400  " &
"        ON WHWMD400.T$ITEM = Trim(WHINH220.T$ITEM)  " &
" LEFT JOIN (       Select  3 koor,  1 oorg From DUAL  " &
"             Union Select  7 koor,  2 oorg From DUAL  " &
"             Union Select 34 koor,  3 oorg From DUAL  " &
"             Union Select  2 koor, 80 oorg From DUAL  " &
"             Union Select  6 koor, 81 oorg From DUAL  " &
"             Union Select 33 koor, 82 oorg From DUAL  " &
"             Union Select 17 koor, 11 oorg From DUAL  " &
"             Union Select 35 koor, 12 oorg From DUAL  " &
"             Union Select 37 koor, 31 oorg From DUAL  " &
"             Union Select 39 koor, 32 oorg From DUAL  " &
"             Union Select 38 koor, 33 oorg From DUAL  " &
"             Union Select 42 koor, 34 oorg From DUAL  " &
"             Union Select  1 koor, 50 oorg From DUAL  " &
"             Union Select 32 koor, 51 oorg From DUAL  " &
"             Union Select 56 koor, 53 oorg From DUAL  " &
"             Union Select  9 koor, 55 oorg From DUAL  " &
"             Union Select 46 koor, 56 oorg From DUAL  " &
"             Union Select 57 koor, 58 oorg From DUAL  " &
"             Union Select 22 koor, 71 oorg From DUAL  " &
"             Union Select 36 koor, 72 oorg From DUAL  " &
"             Union Select 58 koor, 75 oorg From DUAL  " &
"             Union Select 59 koor, 76 oorg From DUAL  " &
"             Union Select 60 koor, 90 oorg From DUAL  " &
"             Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG  " &
"        ON KOOR2OORG.OORG = WHINH220.T$OORG  " &
" LEFT JOIN BAANDB.TCISLI245301  CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = CASE WHEN WHINH220.T$OORG=1  " &
"                                    THEN 1  " &
"                                  ELSE 2  " &
"                              END  " &
"       AND CISLI245.T$KOOR = KOOR2OORG.KOOR  " &
"       AND CISLI245.T$SLSO = WHINH220.T$ORNO  " &
"       AND CISLI245.T$OSET = WHINH200.T$OSET  " &
"       AND CISLI245.T$PONO = WHINH220.T$PONO  " &
" LEFT JOIN BAANDB.TCISLI941301 CISLI941  " &
"        ON CISLI941.T$FIRE$L = CISLI245.T$FIRE$L  " &
"       AND CISLI941.T$LINE$L = CISLI245.T$LINE$L  " &
" LEFT JOIN BAANDB.TCISLI940301 CISLI940  " &
"        ON CISLI940.T$FIRE$L = CISLI941.T$FIRE$L  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L  " &
" LEFT JOIN ( select A.T$FIRE$L,  " &
"                    A.T$DOCN$L,  " &
"                    A.T$SERI$L,  " &
"                    A.T$FDTC$L  " &
"               from BAANDB.TCISLI940301 A  " &
"              where A.T$DATG$L = ( SELECT MIN(B.T$DATG$L)  " &
"                                     FROM BAANDB.TCISLI940301 B  " &
"                                    WHERE B.T$DOCN$L = A.T$DOCN$L  " &
"                                      AND B.T$SERI$L = A.T$SERI$L ) ) CISLI940x " &
"        ON CISLI940x.T$DOCN$L = WSOR.INVOICENUMBER  " &
"       AND CISLI940x.T$SERI$L = WSOR.LANE  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966x  " &
"        ON TCMCS966x.T$FDTC$L = CISLI940x.T$FDTC$L  " &
" LEFT JOIN BAANDB.TTCMCS023301  TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  " &
"        ON LNFB.T$CMNF = TCIBD001.T$CMNF  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  " &
"        ON LNCF.T$CADR = LNFB.T$CADR  " &
" LEFT JOIN BAANDB.TTDSLS400301  TDSLS400  " &
"        ON TDSLS400.T$ORNO = WHINH200.T$ORNO  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  " &
"        ON LNCC.T$CADR = NVL(TDSLS400.T$OFAD, WHINH200.T$STAD)  " &
" LEFT JOIN WMWHSE1.codelkup@DL_LN_WMS DIVS  " &
"        ON DIVS.CODE = WSOR.INVOICESTATUS  " &
"       AND DIVS.LISTNAME = 'INVSTATUS'  " &
"WHERE WSOR.STATUS = '100'  " &
"  AND ( select count(x.orderkey)  " &
"          from WMWHSE1.orders@DL_LN_WMS x  " &
"         where x.referencedocument = WSOR.referencedocument  " &
"           and x.adddate > WSOR.adddate ) = 0  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND (    (UPPER(Trim(WHINH200.T$ORNO)) IN ( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ",", "','") + "'")  + " )  " &
"        AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"         OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  " &
"SELECT  " &
"  WSOR.WHSEID                  ID_FILIAL,  " &
"  wmsCODE.UDF2                 NOME_FILIAL,  " &
"  WHINH200.T$ORNO              PEDIDO_LN,  " &
"  WSOR.ORDERKEY                PEDIDO_WMS,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_REGISTRO,  " &
"  WOSS.DESCRIPTION             EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$DATE$L,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_FATURAMENTO,  " &
"  WSOR.INVOICENUMBER           NF,  " &
"  WSOR.LANE                    NF_SERIE,  " &
"  NVL(TCMCS966.T$DSCA$L,  " &
"      TCMCS966x.T$DSCA$L)      DESCR_TP_DOC_FISCAL,  " &
"  WHINH010.T$DSCA              NOME_OPERADOR,  " &
"  TRIM(WHINH220.T$ITEM)        ITEM,  " &
"  TCIBD001.T$DSCA              DESCRICAO,  " &
"  TCMCS023.T$DSCA              DEPARTAMENTO,  " &
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  " &
"  LNFB.T$DSCA                  NOME_FABRICANTE,  " &
"  LNCC.T$FOVN$L                CNPJ_CLIENTE,  " &
"  LNCC.T$NAMA                  NOME_CLIENTE,  " &
"  WHWMD400.T$HGHT *  " &
"  WHWMD400.T$WDTH *  " &
"  WHWMD400.T$DPTH              M3_UNITARIO,  " &
"  WHINH220.T$QORO              QTD_PEDIDO,  " &
"  WHINH220.T$QORO              QTD_CANCELADA,  " &
"  NVL(CISLI941.T$DQUA$L,0)     QTD_FATURADA,  " &
"  ABS(CISLI941.T$PRIC$L)       VALOR_NF_UNITARIO,  " &
"  ABS(CISLI941.T$AMNT$L)       VALOR_NF_TOTAL,  " &
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  " &
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  " &
"FROM       BAANDB.TWHINH200301     WHINH200  " &
"INNER JOIN WMWHSE2.ORDERS@DL_LN_WMS   WSOR  " &
"        ON CASE WHEN INSTR(WSOR.REFERENCEDOCUMENT, '_') = 0  " &
"                  THEN WSOR.REFERENCEDOCUMENT  " &
"                ELSE   SUBSTR(WSOR.REFERENCEDOCUMENT, 4, 9)  " &
"            END  = WHINH200.T$ORNO  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.UDF1 = WSOR.WHSEID  " &
"INNER JOIN WMWHSE2.ORDERSTATUSSETUP@DL_LN_WMS WOSS  " &
"        ON WOSS.CODE = WSOR.STATUS  " &
"INNER JOIN BAANDB.TWHINH010301  WHINH010  " &
"        ON WHINH010.T$OTYP = WHINH200.T$OTYP  " &
"INNER JOIN BAANDB.TWHINH220301  WHINH220  " &
"        ON WHINH220.T$OORG = WHINH200.T$OORG  " &
"       AND WHINH220.T$ORNO = WHINH200.T$ORNO  " &
"       AND WHINH220.T$SEQN = WHINH200.T$OSET  " &
"INNER JOIN BAANDB.TTCIBD001301  TCIBD001  " &
"        ON TCIBD001.T$ITEM = WHINH220.T$ITEM  " &
" LEFT JOIN BAANDB.TWHWMD400301  WHWMD400  " &
"        ON WHWMD400.T$ITEM = Trim(WHINH220.T$ITEM)  " &
" LEFT JOIN (       Select  3 koor,  1 oorg From DUAL  " &
"             Union Select  7 koor,  2 oorg From DUAL  " &
"             Union Select 34 koor,  3 oorg From DUAL  " &
"             Union Select  2 koor, 80 oorg From DUAL  " &
"             Union Select  6 koor, 81 oorg From DUAL  " &
"             Union Select 33 koor, 82 oorg From DUAL  " &
"             Union Select 17 koor, 11 oorg From DUAL  " &
"             Union Select 35 koor, 12 oorg From DUAL  " &
"             Union Select 37 koor, 31 oorg From DUAL  " &
"             Union Select 39 koor, 32 oorg From DUAL  " &
"             Union Select 38 koor, 33 oorg From DUAL  " &
"             Union Select 42 koor, 34 oorg From DUAL  " &
"             Union Select  1 koor, 50 oorg From DUAL  " &
"             Union Select 32 koor, 51 oorg From DUAL  " &
"             Union Select 56 koor, 53 oorg From DUAL  " &
"             Union Select  9 koor, 55 oorg From DUAL  " &
"             Union Select 46 koor, 56 oorg From DUAL  " &
"             Union Select 57 koor, 58 oorg From DUAL  " &
"             Union Select 22 koor, 71 oorg From DUAL  " &
"             Union Select 36 koor, 72 oorg From DUAL  " &
"             Union Select 58 koor, 75 oorg From DUAL  " &
"             Union Select 59 koor, 76 oorg From DUAL  " &
"             Union Select 60 koor, 90 oorg From DUAL  " &
"             Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG  " &
"        ON KOOR2OORG.OORG = WHINH220.T$OORG  " &
" LEFT JOIN BAANDB.TCISLI245301  CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = CASE WHEN WHINH220.T$OORG=1  " &
"                                    THEN 1  " &
"                                  ELSE 2  " &
"                              END  " &
"       AND CISLI245.T$KOOR = KOOR2OORG.KOOR  " &
"       AND CISLI245.T$SLSO = WHINH220.T$ORNO  " &
"       AND CISLI245.T$OSET = WHINH200.T$OSET  " &
"       AND CISLI245.T$PONO = WHINH220.T$PONO  " &
" LEFT JOIN BAANDB.TCISLI941301 CISLI941  " &
"        ON CISLI941.T$FIRE$L = CISLI245.T$FIRE$L  " &
"       AND CISLI941.T$LINE$L = CISLI245.T$LINE$L  " &
" LEFT JOIN BAANDB.TCISLI940301 CISLI940  " &
"        ON CISLI940.T$FIRE$L = CISLI941.T$FIRE$L  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L  " &
" LEFT JOIN ( select A.T$FIRE$L,  " &
"                    A.T$DOCN$L,  " &
"                    A.T$SERI$L,  " &
"                    A.T$FDTC$L  " &
"               from BAANDB.TCISLI940301 A  " &
"              where A.T$DATG$L = ( SELECT MIN(B.T$DATG$L)  " &
"                                     FROM BAANDB.TCISLI940301 B  " &
"                                    WHERE B.T$DOCN$L = A.T$DOCN$L  " &
"                                      AND B.T$SERI$L = A.T$SERI$L ) ) CISLI940x " &
"        ON CISLI940x.T$DOCN$L = WSOR.INVOICENUMBER  " &
"       AND CISLI940x.T$SERI$L = WSOR.LANE  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966x  " &
"        ON TCMCS966x.T$FDTC$L = CISLI940x.T$FDTC$L  " &
" LEFT JOIN BAANDB.TTCMCS023301  TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  " &
"        ON LNFB.T$CMNF = TCIBD001.T$CMNF  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  " &
"        ON LNCF.T$CADR = LNFB.T$CADR  " &
" LEFT JOIN BAANDB.TTDSLS400301  TDSLS400  " &
"        ON TDSLS400.T$ORNO = WHINH200.T$ORNO  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  " &
"        ON LNCC.T$CADR = NVL(TDSLS400.T$OFAD, WHINH200.T$STAD)  " &
" LEFT JOIN WMWHSE2.codelkup@DL_LN_WMS DIVS  " &
"        ON DIVS.CODE = WSOR.INVOICESTATUS  " &
"       AND DIVS.LISTNAME = 'INVSTATUS'  " &
"WHERE WSOR.STATUS = '100'  " &
"  AND ( select count(x.orderkey)  " &
"          from WMWHSE2.orders@DL_LN_WMS x  " &
"         where x.referencedocument = WSOR.referencedocument  " &
"           and x.adddate > WSOR.adddate ) = 0  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND (    (UPPER(Trim(WHINH200.T$ORNO)) IN ( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ",", "','") + "'")  + " )  " &
"        AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"         OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  " &
"SELECT  " &
"  WSOR.WHSEID                  ID_FILIAL,  " &
"  wmsCODE.UDF2                 NOME_FILIAL,  " &
"  WHINH200.T$ORNO              PEDIDO_LN,  " &
"  WSOR.ORDERKEY                PEDIDO_WMS,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_REGISTRO,  " &
"  WOSS.DESCRIPTION             EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$DATE$L,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_FATURAMENTO,  " &
"  WSOR.INVOICENUMBER           NF,  " &
"  WSOR.LANE                    NF_SERIE,  " &
"  NVL(TCMCS966.T$DSCA$L,  " &
"      TCMCS966x.T$DSCA$L)      DESCR_TP_DOC_FISCAL,  " &
"  WHINH010.T$DSCA              NOME_OPERADOR,  " &
"  TRIM(WHINH220.T$ITEM)        ITEM,  " &
"  TCIBD001.T$DSCA              DESCRICAO,  " &
"  TCMCS023.T$DSCA              DEPARTAMENTO,  " &
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  " &
"  LNFB.T$DSCA                  NOME_FABRICANTE,  " &
"  LNCC.T$FOVN$L                CNPJ_CLIENTE,  " &
"  LNCC.T$NAMA                  NOME_CLIENTE,  " &
"  WHWMD400.T$HGHT *  " &
"  WHWMD400.T$WDTH *  " &
"  WHWMD400.T$DPTH              M3_UNITARIO,  " &
"  WHINH220.T$QORO              QTD_PEDIDO,  " &
"  WHINH220.T$QORO              QTD_CANCELADA,  " &
"  NVL(CISLI941.T$DQUA$L,0)     QTD_FATURADA,  " &
"  ABS(CISLI941.T$PRIC$L)       VALOR_NF_UNITARIO,  " &
"  ABS(CISLI941.T$AMNT$L)       VALOR_NF_TOTAL,  " &
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  " &
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  " &
"FROM       BAANDB.TWHINH200301     WHINH200  " &
"INNER JOIN WMWHSE3.ORDERS@DL_LN_WMS   WSOR  " &
"        ON CASE WHEN INSTR(WSOR.REFERENCEDOCUMENT, '_') = 0  " &
"                  THEN WSOR.REFERENCEDOCUMENT  " &
"                ELSE   SUBSTR(WSOR.REFERENCEDOCUMENT, 4, 9)  " &
"            END  = WHINH200.T$ORNO  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.UDF1 = WSOR.WHSEID  " &
"INNER JOIN WMWHSE3.ORDERSTATUSSETUP@DL_LN_WMS WOSS  " &
"        ON WOSS.CODE = WSOR.STATUS  " &
"INNER JOIN BAANDB.TWHINH010301  WHINH010  " &
"        ON WHINH010.T$OTYP = WHINH200.T$OTYP  " &
"INNER JOIN BAANDB.TWHINH220301  WHINH220  " &
"        ON WHINH220.T$OORG = WHINH200.T$OORG  " &
"       AND WHINH220.T$ORNO = WHINH200.T$ORNO  " &
"       AND WHINH220.T$SEQN = WHINH200.T$OSET  " &
"INNER JOIN BAANDB.TTCIBD001301  TCIBD001  " &
"        ON TCIBD001.T$ITEM = WHINH220.T$ITEM  " &
" LEFT JOIN BAANDB.TWHWMD400301  WHWMD400  " &
"        ON WHWMD400.T$ITEM = Trim(WHINH220.T$ITEM)  " &
" LEFT JOIN (       Select  3 koor,  1 oorg From DUAL  " &
"             Union Select  7 koor,  2 oorg From DUAL  " &
"             Union Select 34 koor,  3 oorg From DUAL  " &
"             Union Select  2 koor, 80 oorg From DUAL  " &
"             Union Select  6 koor, 81 oorg From DUAL  " &
"             Union Select 33 koor, 82 oorg From DUAL  " &
"             Union Select 17 koor, 11 oorg From DUAL  " &
"             Union Select 35 koor, 12 oorg From DUAL  " &
"             Union Select 37 koor, 31 oorg From DUAL  " &
"             Union Select 39 koor, 32 oorg From DUAL  " &
"             Union Select 38 koor, 33 oorg From DUAL  " &
"             Union Select 42 koor, 34 oorg From DUAL  " &
"             Union Select  1 koor, 50 oorg From DUAL  " &
"             Union Select 32 koor, 51 oorg From DUAL  " &
"             Union Select 56 koor, 53 oorg From DUAL  " &
"             Union Select  9 koor, 55 oorg From DUAL  " &
"             Union Select 46 koor, 56 oorg From DUAL  " &
"             Union Select 57 koor, 58 oorg From DUAL  " &
"             Union Select 22 koor, 71 oorg From DUAL  " &
"             Union Select 36 koor, 72 oorg From DUAL  " &
"             Union Select 58 koor, 75 oorg From DUAL  " &
"             Union Select 59 koor, 76 oorg From DUAL  " &
"             Union Select 60 koor, 90 oorg From DUAL  " &
"             Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG  " &
"        ON KOOR2OORG.OORG = WHINH220.T$OORG  " &
" LEFT JOIN BAANDB.TCISLI245301  CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = CASE WHEN WHINH220.T$OORG=1  " &
"                                    THEN 1  " &
"                                  ELSE 2  " &
"                              END  " &
"       AND CISLI245.T$KOOR = KOOR2OORG.KOOR  " &
"       AND CISLI245.T$SLSO = WHINH220.T$ORNO  " &
"       AND CISLI245.T$OSET = WHINH200.T$OSET  " &
"       AND CISLI245.T$PONO = WHINH220.T$PONO  " &
" LEFT JOIN BAANDB.TCISLI941301 CISLI941  " &
"        ON CISLI941.T$FIRE$L = CISLI245.T$FIRE$L  " &
"       AND CISLI941.T$LINE$L = CISLI245.T$LINE$L  " &
" LEFT JOIN BAANDB.TCISLI940301 CISLI940  " &
"        ON CISLI940.T$FIRE$L = CISLI941.T$FIRE$L  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L  " &
" LEFT JOIN ( select A.T$FIRE$L,  " &
"                    A.T$DOCN$L,  " &
"                    A.T$SERI$L,  " &
"                    A.T$FDTC$L  " &
"               from BAANDB.TCISLI940301 A  " &
"              where A.T$DATG$L = ( SELECT MIN(B.T$DATG$L)  " &
"                                     FROM BAANDB.TCISLI940301 B  " &
"                                    WHERE B.T$DOCN$L = A.T$DOCN$L  " &
"                                      AND B.T$SERI$L = A.T$SERI$L ) ) CISLI940x " &
"        ON CISLI940x.T$DOCN$L = WSOR.INVOICENUMBER  " &
"       AND CISLI940x.T$SERI$L = WSOR.LANE  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966x  " &
"        ON TCMCS966x.T$FDTC$L = CISLI940x.T$FDTC$L  " &
" LEFT JOIN BAANDB.TTCMCS023301  TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  " &
"        ON LNFB.T$CMNF = TCIBD001.T$CMNF  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  " &
"        ON LNCF.T$CADR = LNFB.T$CADR  " &
" LEFT JOIN BAANDB.TTDSLS400301  TDSLS400  " &
"        ON TDSLS400.T$ORNO = WHINH200.T$ORNO  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  " &
"        ON LNCC.T$CADR = NVL(TDSLS400.T$OFAD, WHINH200.T$STAD)  " &
" LEFT JOIN WMWHSE3.codelkup@DL_LN_WMS DIVS  " &
"        ON DIVS.CODE = WSOR.INVOICESTATUS  " &
"       AND DIVS.LISTNAME = 'INVSTATUS'  " &
"WHERE WSOR.STATUS = '100'  " &
"  AND ( select count(x.orderkey)  " &
"          from WMWHSE3.orders@DL_LN_WMS x  " &
"         where x.referencedocument = WSOR.referencedocument  " &
"           and x.adddate > WSOR.adddate ) = 0  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND (    (UPPER(Trim(WHINH200.T$ORNO)) IN ( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ",", "','") + "'")  + " )  " &
"        AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"         OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  " &
"SELECT  " &
"  WSOR.WHSEID                  ID_FILIAL,  " &
"  wmsCODE.UDF2                 NOME_FILIAL,  " &
"  WHINH200.T$ORNO              PEDIDO_LN,  " &
"  WSOR.ORDERKEY                PEDIDO_WMS,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_REGISTRO,  " &
"  WOSS.DESCRIPTION             EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$DATE$L,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_FATURAMENTO,  " &
"  WSOR.INVOICENUMBER           NF,  " &
"  WSOR.LANE                    NF_SERIE,  " &
"  NVL(TCMCS966.T$DSCA$L,  " &
"      TCMCS966x.T$DSCA$L)      DESCR_TP_DOC_FISCAL,  " &
"  WHINH010.T$DSCA              NOME_OPERADOR,  " &
"  TRIM(WHINH220.T$ITEM)        ITEM,  " &
"  TCIBD001.T$DSCA              DESCRICAO,  " &
"  TCMCS023.T$DSCA              DEPARTAMENTO,  " &
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  " &
"  LNFB.T$DSCA                  NOME_FABRICANTE,  " &
"  LNCC.T$FOVN$L                CNPJ_CLIENTE,  " &
"  LNCC.T$NAMA                  NOME_CLIENTE,  " &
"  WHWMD400.T$HGHT *  " &
"  WHWMD400.T$WDTH *  " &
"  WHWMD400.T$DPTH              M3_UNITARIO,  " &
"  WHINH220.T$QORO              QTD_PEDIDO,  " &
"  WHINH220.T$QORO              QTD_CANCELADA,  " &
"  NVL(CISLI941.T$DQUA$L,0)     QTD_FATURADA,  " &
"  ABS(CISLI941.T$PRIC$L)       VALOR_NF_UNITARIO,  " &
"  ABS(CISLI941.T$AMNT$L)       VALOR_NF_TOTAL,  " &
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  " &
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  " &
"FROM       BAANDB.TWHINH200301     WHINH200  " &
"INNER JOIN WMWHSE4.ORDERS@DL_LN_WMS   WSOR  " &
"        ON CASE WHEN INSTR(WSOR.REFERENCEDOCUMENT, '_') = 0  " &
"                  THEN WSOR.REFERENCEDOCUMENT  " &
"                ELSE   SUBSTR(WSOR.REFERENCEDOCUMENT, 4, 9)  " &
"            END  = WHINH200.T$ORNO  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.UDF1 = WSOR.WHSEID  " &
"INNER JOIN WMWHSE4.ORDERSTATUSSETUP@DL_LN_WMS WOSS  " &
"        ON WOSS.CODE = WSOR.STATUS  " &
"INNER JOIN BAANDB.TWHINH010301  WHINH010  " &
"        ON WHINH010.T$OTYP = WHINH200.T$OTYP  " &
"INNER JOIN BAANDB.TWHINH220301  WHINH220  " &
"        ON WHINH220.T$OORG = WHINH200.T$OORG  " &
"       AND WHINH220.T$ORNO = WHINH200.T$ORNO  " &
"       AND WHINH220.T$SEQN = WHINH200.T$OSET  " &
"INNER JOIN BAANDB.TTCIBD001301  TCIBD001  " &
"        ON TCIBD001.T$ITEM = WHINH220.T$ITEM  " &
" LEFT JOIN BAANDB.TWHWMD400301  WHWMD400  " &
"        ON WHWMD400.T$ITEM = Trim(WHINH220.T$ITEM)  " &
" LEFT JOIN (       Select  3 koor,  1 oorg From DUAL  " &
"             Union Select  7 koor,  2 oorg From DUAL  " &
"             Union Select 34 koor,  3 oorg From DUAL  " &
"             Union Select  2 koor, 80 oorg From DUAL  " &
"             Union Select  6 koor, 81 oorg From DUAL  " &
"             Union Select 33 koor, 82 oorg From DUAL  " &
"             Union Select 17 koor, 11 oorg From DUAL  " &
"             Union Select 35 koor, 12 oorg From DUAL  " &
"             Union Select 37 koor, 31 oorg From DUAL  " &
"             Union Select 39 koor, 32 oorg From DUAL  " &
"             Union Select 38 koor, 33 oorg From DUAL  " &
"             Union Select 42 koor, 34 oorg From DUAL  " &
"             Union Select  1 koor, 50 oorg From DUAL  " &
"             Union Select 32 koor, 51 oorg From DUAL  " &
"             Union Select 56 koor, 53 oorg From DUAL  " &
"             Union Select  9 koor, 55 oorg From DUAL  " &
"             Union Select 46 koor, 56 oorg From DUAL  " &
"             Union Select 57 koor, 58 oorg From DUAL  " &
"             Union Select 22 koor, 71 oorg From DUAL  " &
"             Union Select 36 koor, 72 oorg From DUAL  " &
"             Union Select 58 koor, 75 oorg From DUAL  " &
"             Union Select 59 koor, 76 oorg From DUAL  " &
"             Union Select 60 koor, 90 oorg From DUAL  " &
"             Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG  " &
"        ON KOOR2OORG.OORG = WHINH220.T$OORG  " &
" LEFT JOIN BAANDB.TCISLI245301  CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = CASE WHEN WHINH220.T$OORG=1  " &
"                                    THEN 1  " &
"                                  ELSE 2  " &
"                              END  " &
"       AND CISLI245.T$KOOR = KOOR2OORG.KOOR  " &
"       AND CISLI245.T$SLSO = WHINH220.T$ORNO  " &
"       AND CISLI245.T$OSET = WHINH200.T$OSET  " &
"       AND CISLI245.T$PONO = WHINH220.T$PONO  " &
" LEFT JOIN BAANDB.TCISLI941301 CISLI941  " &
"        ON CISLI941.T$FIRE$L = CISLI245.T$FIRE$L  " &
"       AND CISLI941.T$LINE$L = CISLI245.T$LINE$L  " &
" LEFT JOIN BAANDB.TCISLI940301 CISLI940  " &
"        ON CISLI940.T$FIRE$L = CISLI941.T$FIRE$L  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L  " &
" LEFT JOIN ( select A.T$FIRE$L,  " &
"                    A.T$DOCN$L,  " &
"                    A.T$SERI$L,  " &
"                    A.T$FDTC$L  " &
"               from BAANDB.TCISLI940301 A  " &
"              where A.T$DATG$L = ( SELECT MIN(B.T$DATG$L)  " &
"                                     FROM BAANDB.TCISLI940301 B  " &
"                                    WHERE B.T$DOCN$L = A.T$DOCN$L  " &
"                                      AND B.T$SERI$L = A.T$SERI$L ) ) CISLI940x " &
"        ON CISLI940x.T$DOCN$L = WSOR.INVOICENUMBER  " &
"       AND CISLI940x.T$SERI$L = WSOR.LANE  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966x  " &
"        ON TCMCS966x.T$FDTC$L = CISLI940x.T$FDTC$L  " &
" LEFT JOIN BAANDB.TTCMCS023301  TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  " &
"        ON LNFB.T$CMNF = TCIBD001.T$CMNF  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  " &
"        ON LNCF.T$CADR = LNFB.T$CADR  " &
" LEFT JOIN BAANDB.TTDSLS400301  TDSLS400  " &
"        ON TDSLS400.T$ORNO = WHINH200.T$ORNO  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  " &
"        ON LNCC.T$CADR = NVL(TDSLS400.T$OFAD, WHINH200.T$STAD)  " &
" LEFT JOIN WMWHSE4.codelkup@DL_LN_WMS DIVS  " &
"        ON DIVS.CODE = WSOR.INVOICESTATUS  " &
"       AND DIVS.LISTNAME = 'INVSTATUS'  " &
"WHERE WSOR.STATUS = '100'  " &
"  AND ( select count(x.orderkey)  " &
"          from WMWHSE4.orders@DL_LN_WMS x  " &
"         where x.referencedocument = WSOR.referencedocument  " &
"           and x.adddate > WSOR.adddate ) = 0  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND (    (UPPER(Trim(WHINH200.T$ORNO)) IN ( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ",", "','") + "'")  + " )  " &
"        AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"         OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  " &
"SELECT  " &
"  WSOR.WHSEID                  ID_FILIAL,  " &
"  wmsCODE.UDF2                 NOME_FILIAL,  " &
"  WHINH200.T$ORNO              PEDIDO_LN,  " &
"  WSOR.ORDERKEY                PEDIDO_WMS,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_REGISTRO,  " &
"  WOSS.DESCRIPTION             EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$DATE$L,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_FATURAMENTO,  " &
"  WSOR.INVOICENUMBER           NF,  " &
"  WSOR.LANE                    NF_SERIE,  " &
"  NVL(TCMCS966.T$DSCA$L,  " &
"      TCMCS966x.T$DSCA$L)      DESCR_TP_DOC_FISCAL,  " &
"  WHINH010.T$DSCA              NOME_OPERADOR,  " &
"  TRIM(WHINH220.T$ITEM)        ITEM,  " &
"  TCIBD001.T$DSCA              DESCRICAO,  " &
"  TCMCS023.T$DSCA              DEPARTAMENTO,  " &
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  " &
"  LNFB.T$DSCA                  NOME_FABRICANTE,  " &
"  LNCC.T$FOVN$L                CNPJ_CLIENTE,  " &
"  LNCC.T$NAMA                  NOME_CLIENTE,  " &
"  WHWMD400.T$HGHT *  " &
"  WHWMD400.T$WDTH *  " &
"  WHWMD400.T$DPTH              M3_UNITARIO,  " &
"  WHINH220.T$QORO              QTD_PEDIDO,  " &
"  WHINH220.T$QORO              QTD_CANCELADA,  " &
"  NVL(CISLI941.T$DQUA$L,0)     QTD_FATURADA,  " &
"  ABS(CISLI941.T$PRIC$L)       VALOR_NF_UNITARIO,  " &
"  ABS(CISLI941.T$AMNT$L)       VALOR_NF_TOTAL,  " &
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  " &
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  " &
"FROM       BAANDB.TWHINH200301     WHINH200  " &
"INNER JOIN WMWHSE5.ORDERS@DL_LN_WMS   WSOR  " &
"        ON CASE WHEN INSTR(WSOR.REFERENCEDOCUMENT, '_') = 0  " &
"                  THEN WSOR.REFERENCEDOCUMENT  " &
"                ELSE   SUBSTR(WSOR.REFERENCEDOCUMENT, 4, 9)  " &
"            END  = WHINH200.T$ORNO  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.UDF1 = WSOR.WHSEID  " &
"INNER JOIN WMWHSE5.ORDERSTATUSSETUP@DL_LN_WMS WOSS  " &
"        ON WOSS.CODE = WSOR.STATUS  " &
"INNER JOIN BAANDB.TWHINH010301  WHINH010  " &
"        ON WHINH010.T$OTYP = WHINH200.T$OTYP  " &
"INNER JOIN BAANDB.TWHINH220301  WHINH220  " &
"        ON WHINH220.T$OORG = WHINH200.T$OORG  " &
"       AND WHINH220.T$ORNO = WHINH200.T$ORNO  " &
"       AND WHINH220.T$SEQN = WHINH200.T$OSET  " &
"INNER JOIN BAANDB.TTCIBD001301  TCIBD001  " &
"        ON TCIBD001.T$ITEM = WHINH220.T$ITEM  " &
" LEFT JOIN BAANDB.TWHWMD400301  WHWMD400  " &
"        ON WHWMD400.T$ITEM = Trim(WHINH220.T$ITEM)  " &
" LEFT JOIN (       Select  3 koor,  1 oorg From DUAL  " &
"             Union Select  7 koor,  2 oorg From DUAL  " &
"             Union Select 34 koor,  3 oorg From DUAL  " &
"             Union Select  2 koor, 80 oorg From DUAL  " &
"             Union Select  6 koor, 81 oorg From DUAL  " &
"             Union Select 33 koor, 82 oorg From DUAL  " &
"             Union Select 17 koor, 11 oorg From DUAL  " &
"             Union Select 35 koor, 12 oorg From DUAL  " &
"             Union Select 37 koor, 31 oorg From DUAL  " &
"             Union Select 39 koor, 32 oorg From DUAL  " &
"             Union Select 38 koor, 33 oorg From DUAL  " &
"             Union Select 42 koor, 34 oorg From DUAL  " &
"             Union Select  1 koor, 50 oorg From DUAL  " &
"             Union Select 32 koor, 51 oorg From DUAL  " &
"             Union Select 56 koor, 53 oorg From DUAL  " &
"             Union Select  9 koor, 55 oorg From DUAL  " &
"             Union Select 46 koor, 56 oorg From DUAL  " &
"             Union Select 57 koor, 58 oorg From DUAL  " &
"             Union Select 22 koor, 71 oorg From DUAL  " &
"             Union Select 36 koor, 72 oorg From DUAL  " &
"             Union Select 58 koor, 75 oorg From DUAL  " &
"             Union Select 59 koor, 76 oorg From DUAL  " &
"             Union Select 60 koor, 90 oorg From DUAL  " &
"             Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG  " &
"        ON KOOR2OORG.OORG = WHINH220.T$OORG  " &
" LEFT JOIN BAANDB.TCISLI245301  CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = CASE WHEN WHINH220.T$OORG=1  " &
"                                    THEN 1  " &
"                                  ELSE 2  " &
"                              END  " &
"       AND CISLI245.T$KOOR = KOOR2OORG.KOOR  " &
"       AND CISLI245.T$SLSO = WHINH220.T$ORNO  " &
"       AND CISLI245.T$OSET = WHINH200.T$OSET  " &
"       AND CISLI245.T$PONO = WHINH220.T$PONO  " &
" LEFT JOIN BAANDB.TCISLI941301 CISLI941  " &
"        ON CISLI941.T$FIRE$L = CISLI245.T$FIRE$L  " &
"       AND CISLI941.T$LINE$L = CISLI245.T$LINE$L  " &
" LEFT JOIN BAANDB.TCISLI940301 CISLI940  " &
"        ON CISLI940.T$FIRE$L = CISLI941.T$FIRE$L  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L  " &
" LEFT JOIN ( select A.T$FIRE$L,  " &
"                    A.T$DOCN$L,  " &
"                    A.T$SERI$L,  " &
"                    A.T$FDTC$L  " &
"               from BAANDB.TCISLI940301 A  " &
"              where A.T$DATG$L = ( SELECT MIN(B.T$DATG$L)  " &
"                                     FROM BAANDB.TCISLI940301 B  " &
"                                    WHERE B.T$DOCN$L = A.T$DOCN$L  " &
"                                      AND B.T$SERI$L = A.T$SERI$L ) ) CISLI940x " &
"        ON CISLI940x.T$DOCN$L = WSOR.INVOICENUMBER  " &
"       AND CISLI940x.T$SERI$L = WSOR.LANE  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966x  " &
"        ON TCMCS966x.T$FDTC$L = CISLI940x.T$FDTC$L  " &
" LEFT JOIN BAANDB.TTCMCS023301  TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  " &
"        ON LNFB.T$CMNF = TCIBD001.T$CMNF  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  " &
"        ON LNCF.T$CADR = LNFB.T$CADR  " &
" LEFT JOIN BAANDB.TTDSLS400301  TDSLS400  " &
"        ON TDSLS400.T$ORNO = WHINH200.T$ORNO  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  " &
"        ON LNCC.T$CADR = NVL(TDSLS400.T$OFAD, WHINH200.T$STAD)  " &
" LEFT JOIN WMWHSE5.codelkup@DL_LN_WMS DIVS  " &
"        ON DIVS.CODE = WSOR.INVOICESTATUS  " &
"       AND DIVS.LISTNAME = 'INVSTATUS'  " &
"WHERE WSOR.STATUS = '100'  " &
"  AND ( select count(x.orderkey)  " &
"          from WMWHSE5.orders@DL_LN_WMS x  " &
"         where x.referencedocument = WSOR.referencedocument  " &
"           and x.adddate > WSOR.adddate ) = 0  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND (    (UPPER(Trim(WHINH200.T$ORNO)) IN ( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ",", "','") + "'")  + " )  " &
"        AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"         OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  " &
"SELECT  " &
"  WSOR.WHSEID                  ID_FILIAL,  " &
"  wmsCODE.UDF2                 NOME_FILIAL,  " &
"  WHINH200.T$ORNO              PEDIDO_LN,  " &
"  WSOR.ORDERKEY                PEDIDO_WMS,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_REGISTRO,  " &
"  WOSS.DESCRIPTION             EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$DATE$L,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_FATURAMENTO,  " &
"  WSOR.INVOICENUMBER           NF,  " &
"  WSOR.LANE                    NF_SERIE,  " &
"  NVL(TCMCS966.T$DSCA$L,  " &
"      TCMCS966x.T$DSCA$L)      DESCR_TP_DOC_FISCAL,  " &
"  WHINH010.T$DSCA              NOME_OPERADOR,  " &
"  TRIM(WHINH220.T$ITEM)        ITEM,  " &
"  TCIBD001.T$DSCA              DESCRICAO,  " &
"  TCMCS023.T$DSCA              DEPARTAMENTO,  " &
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  " &
"  LNFB.T$DSCA                  NOME_FABRICANTE,  " &
"  LNCC.T$FOVN$L                CNPJ_CLIENTE,  " &
"  LNCC.T$NAMA                  NOME_CLIENTE,  " &
"  WHWMD400.T$HGHT *  " &
"  WHWMD400.T$WDTH *  " &
"  WHWMD400.T$DPTH              M3_UNITARIO,  " &
"  WHINH220.T$QORO              QTD_PEDIDO,  " &
"  WHINH220.T$QORO              QTD_CANCELADA,  " &
"  NVL(CISLI941.T$DQUA$L,0)     QTD_FATURADA,  " &
"  ABS(CISLI941.T$PRIC$L)       VALOR_NF_UNITARIO,  " &
"  ABS(CISLI941.T$AMNT$L)       VALOR_NF_TOTAL,  " &
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  " &
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  " &
"FROM       BAANDB.TWHINH200301     WHINH200  " &
"INNER JOIN WMWHSE6.ORDERS@DL_LN_WMS   WSOR  " &
"        ON CASE WHEN INSTR(WSOR.REFERENCEDOCUMENT, '_') = 0  " &
"                  THEN WSOR.REFERENCEDOCUMENT  " &
"                ELSE   SUBSTR(WSOR.REFERENCEDOCUMENT, 4, 9)  " &
"            END  = WHINH200.T$ORNO  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.UDF1 = WSOR.WHSEID  " &
"INNER JOIN WMWHSE6.ORDERSTATUSSETUP@DL_LN_WMS WOSS  " &
"        ON WOSS.CODE = WSOR.STATUS  " &
"INNER JOIN BAANDB.TWHINH010301  WHINH010  " &
"        ON WHINH010.T$OTYP = WHINH200.T$OTYP  " &
"INNER JOIN BAANDB.TWHINH220301  WHINH220  " &
"        ON WHINH220.T$OORG = WHINH200.T$OORG  " &
"       AND WHINH220.T$ORNO = WHINH200.T$ORNO  " &
"       AND WHINH220.T$SEQN = WHINH200.T$OSET  " &
"INNER JOIN BAANDB.TTCIBD001301  TCIBD001  " &
"        ON TCIBD001.T$ITEM = WHINH220.T$ITEM  " &
" LEFT JOIN BAANDB.TWHWMD400301  WHWMD400  " &
"        ON WHWMD400.T$ITEM = Trim(WHINH220.T$ITEM)  " &
" LEFT JOIN (       Select  3 koor,  1 oorg From DUAL  " &
"             Union Select  7 koor,  2 oorg From DUAL  " &
"             Union Select 34 koor,  3 oorg From DUAL  " &
"             Union Select  2 koor, 80 oorg From DUAL  " &
"             Union Select  6 koor, 81 oorg From DUAL  " &
"             Union Select 33 koor, 82 oorg From DUAL  " &
"             Union Select 17 koor, 11 oorg From DUAL  " &
"             Union Select 35 koor, 12 oorg From DUAL  " &
"             Union Select 37 koor, 31 oorg From DUAL  " &
"             Union Select 39 koor, 32 oorg From DUAL  " &
"             Union Select 38 koor, 33 oorg From DUAL  " &
"             Union Select 42 koor, 34 oorg From DUAL  " &
"             Union Select  1 koor, 50 oorg From DUAL  " &
"             Union Select 32 koor, 51 oorg From DUAL  " &
"             Union Select 56 koor, 53 oorg From DUAL  " &
"             Union Select  9 koor, 55 oorg From DUAL  " &
"             Union Select 46 koor, 56 oorg From DUAL  " &
"             Union Select 57 koor, 58 oorg From DUAL  " &
"             Union Select 22 koor, 71 oorg From DUAL  " &
"             Union Select 36 koor, 72 oorg From DUAL  " &
"             Union Select 58 koor, 75 oorg From DUAL  " &
"             Union Select 59 koor, 76 oorg From DUAL  " &
"             Union Select 60 koor, 90 oorg From DUAL  " &
"             Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG  " &
"        ON KOOR2OORG.OORG = WHINH220.T$OORG  " &
" LEFT JOIN BAANDB.TCISLI245301  CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = CASE WHEN WHINH220.T$OORG=1  " &
"                                    THEN 1  " &
"                                  ELSE 2  " &
"                              END  " &
"       AND CISLI245.T$KOOR = KOOR2OORG.KOOR  " &
"       AND CISLI245.T$SLSO = WHINH220.T$ORNO  " &
"       AND CISLI245.T$OSET = WHINH200.T$OSET  " &
"       AND CISLI245.T$PONO = WHINH220.T$PONO  " &
" LEFT JOIN BAANDB.TCISLI941301 CISLI941  " &
"        ON CISLI941.T$FIRE$L = CISLI245.T$FIRE$L  " &
"       AND CISLI941.T$LINE$L = CISLI245.T$LINE$L  " &
" LEFT JOIN BAANDB.TCISLI940301 CISLI940  " &
"        ON CISLI940.T$FIRE$L = CISLI941.T$FIRE$L  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L  " &
" LEFT JOIN ( select A.T$FIRE$L,  " &
"                    A.T$DOCN$L,  " &
"                    A.T$SERI$L,  " &
"                    A.T$FDTC$L  " &
"               from BAANDB.TCISLI940301 A  " &
"              where A.T$DATG$L = ( SELECT MIN(B.T$DATG$L)  " &
"                                     FROM BAANDB.TCISLI940301 B  " &
"                                    WHERE B.T$DOCN$L = A.T$DOCN$L  " &
"                                      AND B.T$SERI$L = A.T$SERI$L ) ) CISLI940x " &
"        ON CISLI940x.T$DOCN$L = WSOR.INVOICENUMBER  " &
"       AND CISLI940x.T$SERI$L = WSOR.LANE  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966x  " &
"        ON TCMCS966x.T$FDTC$L = CISLI940x.T$FDTC$L  " &
" LEFT JOIN BAANDB.TTCMCS023301  TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  " &
"        ON LNFB.T$CMNF = TCIBD001.T$CMNF  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  " &
"        ON LNCF.T$CADR = LNFB.T$CADR  " &
" LEFT JOIN BAANDB.TTDSLS400301  TDSLS400  " &
"        ON TDSLS400.T$ORNO = WHINH200.T$ORNO  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  " &
"        ON LNCC.T$CADR = NVL(TDSLS400.T$OFAD, WHINH200.T$STAD)  " &
" LEFT JOIN WMWHSE6.codelkup@DL_LN_WMS DIVS  " &
"        ON DIVS.CODE = WSOR.INVOICESTATUS  " &
"       AND DIVS.LISTNAME = 'INVSTATUS'  " &
"WHERE WSOR.STATUS = '100'  " &
"  AND ( select count(x.orderkey)  " &
"          from WMWHSE6.orders@DL_LN_WMS x  " &
"         where x.referencedocument = WSOR.referencedocument  " &
"           and x.adddate > WSOR.adddate ) = 0  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND (    (UPPER(Trim(WHINH200.T$ORNO)) IN ( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ",", "','") + "'")  + " )  " &
"        AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"         OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  " &
"SELECT  " &
"  WSOR.WHSEID                  ID_FILIAL,  " &
"  wmsCODE.UDF2                 NOME_FILIAL,  " &
"  WHINH200.T$ORNO              PEDIDO_LN,  " &
"  WSOR.ORDERKEY                PEDIDO_WMS,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_REGISTRO,  " &
"  WOSS.DESCRIPTION             EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_EVENTO,  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$DATE$L,  " &
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"      AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                               DATA_FATURAMENTO,  " &
"  WSOR.INVOICENUMBER           NF,  " &
"  WSOR.LANE                    NF_SERIE,  " &
"  NVL(TCMCS966.T$DSCA$L,  " &
"      TCMCS966x.T$DSCA$L)      DESCR_TP_DOC_FISCAL,  " &
"  WHINH010.T$DSCA              NOME_OPERADOR,  " &
"  TRIM(WHINH220.T$ITEM)        ITEM,  " &
"  TCIBD001.T$DSCA              DESCRICAO,  " &
"  TCMCS023.T$DSCA              DEPARTAMENTO,  " &
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  " &
"  LNFB.T$DSCA                  NOME_FABRICANTE,  " &
"  LNCC.T$FOVN$L                CNPJ_CLIENTE,  " &
"  LNCC.T$NAMA                  NOME_CLIENTE,  " &
"  WHWMD400.T$HGHT *  " &
"  WHWMD400.T$WDTH *  " &
"  WHWMD400.T$DPTH              M3_UNITARIO,  " &
"  WHINH220.T$QORO              QTD_PEDIDO,  " &
"  WHINH220.T$QORO              QTD_CANCELADA,  " &
"  NVL(CISLI941.T$DQUA$L,0)     QTD_FATURADA,  " &
"  ABS(CISLI941.T$PRIC$L)       VALOR_NF_UNITARIO,  " &
"  ABS(CISLI941.T$AMNT$L)       VALOR_NF_TOTAL,  " &
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  " &
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  " &
"FROM       BAANDB.TWHINH200301     WHINH200  " &
"INNER JOIN WMWHSE7.ORDERS@DL_LN_WMS   WSOR  " &
"        ON CASE WHEN INSTR(WSOR.REFERENCEDOCUMENT, '_') = 0  " &
"                  THEN WSOR.REFERENCEDOCUMENT  " &
"                ELSE   SUBSTR(WSOR.REFERENCEDOCUMENT, 4, 9)  " &
"            END  = WHINH200.T$ORNO  " &
"INNER JOIN ( select A.LONG_VALUE,  " &
"                    UPPER(A.UDF1) UDF1,  " &
"                    A.UDF2  " &
"               from ENTERPRISE.CODELKUP@DL_LN_WMS A  " &
"              where A.LISTNAME = 'SCHEMA') wmsCODE  " &
"        ON wmsCODE.UDF1 = WSOR.WHSEID  " &
"INNER JOIN WMWHSE7.ORDERSTATUSSETUP@DL_LN_WMS WOSS  " &
"        ON WOSS.CODE = WSOR.STATUS  " &
"INNER JOIN BAANDB.TWHINH010301  WHINH010  " &
"        ON WHINH010.T$OTYP = WHINH200.T$OTYP  " &
"INNER JOIN BAANDB.TWHINH220301  WHINH220  " &
"        ON WHINH220.T$OORG = WHINH200.T$OORG  " &
"       AND WHINH220.T$ORNO = WHINH200.T$ORNO  " &
"       AND WHINH220.T$SEQN = WHINH200.T$OSET  " &
"INNER JOIN BAANDB.TTCIBD001301  TCIBD001  " &
"        ON TCIBD001.T$ITEM = WHINH220.T$ITEM  " &
" LEFT JOIN BAANDB.TWHWMD400301  WHWMD400  " &
"        ON WHWMD400.T$ITEM = Trim(WHINH220.T$ITEM)  " &
" LEFT JOIN (       Select  3 koor,  1 oorg From DUAL  " &
"             Union Select  7 koor,  2 oorg From DUAL  " &
"             Union Select 34 koor,  3 oorg From DUAL  " &
"             Union Select  2 koor, 80 oorg From DUAL  " &
"             Union Select  6 koor, 81 oorg From DUAL  " &
"             Union Select 33 koor, 82 oorg From DUAL  " &
"             Union Select 17 koor, 11 oorg From DUAL  " &
"             Union Select 35 koor, 12 oorg From DUAL  " &
"             Union Select 37 koor, 31 oorg From DUAL  " &
"             Union Select 39 koor, 32 oorg From DUAL  " &
"             Union Select 38 koor, 33 oorg From DUAL  " &
"             Union Select 42 koor, 34 oorg From DUAL  " &
"             Union Select  1 koor, 50 oorg From DUAL  " &
"             Union Select 32 koor, 51 oorg From DUAL  " &
"             Union Select 56 koor, 53 oorg From DUAL  " &
"             Union Select  9 koor, 55 oorg From DUAL  " &
"             Union Select 46 koor, 56 oorg From DUAL  " &
"             Union Select 57 koor, 58 oorg From DUAL  " &
"             Union Select 22 koor, 71 oorg From DUAL  " &
"             Union Select 36 koor, 72 oorg From DUAL  " &
"             Union Select 58 koor, 75 oorg From DUAL  " &
"             Union Select 59 koor, 76 oorg From DUAL  " &
"             Union Select 60 koor, 90 oorg From DUAL  " &
"             Union Select 21 koor, 61 oorg From DUAL ) KOOR2OORG  " &
"        ON KOOR2OORG.OORG = WHINH220.T$OORG  " &
" LEFT JOIN BAANDB.TCISLI245301  CISLI245  " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = CASE WHEN WHINH220.T$OORG=1  " &
"                                    THEN 1  " &
"                                  ELSE 2  " &
"                              END  " &
"       AND CISLI245.T$KOOR = KOOR2OORG.KOOR  " &
"       AND CISLI245.T$SLSO = WHINH220.T$ORNO  " &
"       AND CISLI245.T$OSET = WHINH200.T$OSET  " &
"       AND CISLI245.T$PONO = WHINH220.T$PONO  " &
" LEFT JOIN BAANDB.TCISLI941301 CISLI941  " &
"        ON CISLI941.T$FIRE$L = CISLI245.T$FIRE$L  " &
"       AND CISLI941.T$LINE$L = CISLI245.T$LINE$L  " &
" LEFT JOIN BAANDB.TCISLI940301 CISLI940  " &
"        ON CISLI940.T$FIRE$L = CISLI941.T$FIRE$L  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966  " &
"        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L  " &
" LEFT JOIN ( select A.T$FIRE$L,  " &
"                    A.T$DOCN$L,  " &
"                    A.T$SERI$L,  " &
"                    A.T$FDTC$L  " &
"               from BAANDB.TCISLI940301 A  " &
"              where A.T$DATG$L = ( SELECT MIN(B.T$DATG$L)  " &
"                                     FROM BAANDB.TCISLI940301 B  " &
"                                    WHERE B.T$DOCN$L = A.T$DOCN$L  " &
"                                      AND B.T$SERI$L = A.T$SERI$L ) ) CISLI940x " &
"        ON CISLI940x.T$DOCN$L = WSOR.INVOICENUMBER  " &
"       AND CISLI940x.T$SERI$L = WSOR.LANE  " &
" LEFT JOIN BAANDB.TTCMCS966301 TCMCS966x  " &
"        ON TCMCS966x.T$FDTC$L = CISLI940x.T$FDTC$L  " &
" LEFT JOIN BAANDB.TTCMCS023301  TCMCS023  " &
"        ON TCMCS023.T$CITG = TCIBD001.T$CITG  " &
" LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  " &
"        ON LNFB.T$CMNF = TCIBD001.T$CMNF  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  " &
"        ON LNCF.T$CADR = LNFB.T$CADR  " &
" LEFT JOIN BAANDB.TTDSLS400301  TDSLS400  " &
"        ON TDSLS400.T$ORNO = WHINH200.T$ORNO  " &
" LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  " &
"        ON LNCC.T$CADR = NVL(TDSLS400.T$OFAD, WHINH200.T$STAD)  " &
" LEFT JOIN WMWHSE7.codelkup@DL_LN_WMS DIVS  " &
"        ON DIVS.CODE = WSOR.INVOICESTATUS  " &
"       AND DIVS.LISTNAME = 'INVSTATUS'  " &
"WHERE WSOR.STATUS = '100'  " &
"  AND ( select count(x.orderkey)  " &
"          from WMWHSE7.orders@DL_LN_WMS x  " &
"         where x.referencedocument = WSOR.referencedocument  " &
"           and x.adddate > WSOR.adddate ) = 0  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataRegistroDe.Value + "'  " &
"          And '" + Parameters!DataRegistroAte.Value + "'  " &
"  AND (    (UPPER(Trim(WHINH200.T$ORNO)) IN ( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ",", "','") + "'")  + " )  " &
"        AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"         OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"ORDER BY NOME_FILIAL, PEDIDO_WMS, DATA_REGISTRO  "

)