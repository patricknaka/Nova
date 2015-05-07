SELECT 
  WSOR.WHSEID                  ID_FILIAL,
  wmsCODE.UDF2                 NOME_FILIAL,
  WSOR.REFERENCEDOCUMENT       PEDIDO_LN,
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
   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LNRF.t$DATE$L, 
     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
       AT time zone 'America/Sao_Paulo') AS DATE)
                                DATA_FATURAMENTO,
  WSOR.INVOICENUMBER           NF,
  WSOR.LANE                    NF_SERIE,
  LNRF.T$DSCA$L      	DESCR_TP_DOC_FISCAL,													
  TIPO_PEDIDO.DSC_TIPO_PEDIDO  	NOME_OPERADOR,																	
  TRIM(WSOD.SKU)        		ITEM,	
  TCIBD001.T$DSCA              DESCRICAO,																		
  TCMCS023.T$DSCA              DEPARTAMENTO,
  LNCF.T$FOVN$L                CNPJ_FABRICANTE,
  LNFB.T$DSCA                  NOME_FABRICANTE,
  NVL(LNCC.T$FOVN$L, 
	  SUBSTR(WSOR.C_COMPANY,0, INSTR(WSOR.C_COMPANY,' ')))                CNPJ_CLIENTE,
  CASE WHEN WSOR.CONSIGNEEKEY=' '
	THEN SUBSTR(WSOR.C_COMPANY, INSTR(WSOR.C_COMPANY,' ')+1,20)
	ELSE WSOR.C_COMPANY END		NOME_CLIENTE,               
  WSKU.STDCUBE					M3_UNITARIO,																
  WSOD.ORIGINALQTY   		QTD_PEDIDO,																		
  WSOD.ORIGINALQTY    		QTD_CANCELADA,     -- Será sempre o mesmo que a quantidade do pedido pois no Ln não temos entrega parcial
  NVL(LNRF.T$DQUA$L,0)	QTD_FATURADA,
  ABS(LNRF.T$PRIC$L)  	VALOR_NF_UNITARIO,
  ABS(LNRF.T$AMNT$L)  	VALOR_NF_TOTAL,
  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,
  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO

FROM 		WMWHSE5.ORDERS   	WSOR

INNER JOIN 	( SELECT A.ORDERKEY,
                     A.SKU,
                     SUM(A.ORIGINALQTY) ORIGINALQTY
              FROM WMWHSE5.ORDERDETAIL A
              GROUP BY  A.ORDERKEY,
                        A.SKU)  WSOD
		ON	WSOD.ORDERKEY	=	WSOR.ORDERKEY

INNER JOIN 	WMWHSE5.SKU WSKU
		ON	WSKU.SKU = WSOD.SKU
		
INNER JOIN ( select A.LONG_VALUE,
                    UPPER(A.UDF1) UDF1,
                    A.UDF2
               from ENTERPRISE.CODELKUP A
              where A.LISTNAME = 'SCHEMA') wmsCODE
        ON wmsCODE.UDF1 = WSOR.WHSEID
  
INNER JOIN WMWHSE5.ORDERSTATUSSETUP WOSS
        ON WOSS.CODE = WSOR.STATUS

LEFT JOIN ( select clkp.code          COD_TIPO_PEDIDO, 
                    NVL(trans.description, 
                    clkp.description)  DSC_TIPO_PEDIDO
               from WMWHSE5.codelkup clkp
          left join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
              where clkp.listname = 'ORDERTYPE'
                and Trim(clkp.code) is not null  ) TIPO_PEDIDO
        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = WSOR.type

INNER JOIN BAANDB.TTCIBD001301@PLN01  TCIBD001
        ON TRIM(TCIBD001.T$ITEM) = WSOD.SKU

 LEFT JOIN BAANDB.TTCMCS023301@PLN01  TCMCS023
        ON TCMCS023.T$CITG = TCIBD001.T$CITG
     
 LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB 
        ON LNFB.T$CMNF = TCIBD001.T$CMNF
    
 LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF
        ON LNCF.T$CADR = LNFB.T$CADR

 LEFT JOIN	BAANDB.TTCCOM100301@PLN01	LNCP
		ON	LNCP.T$BPID	=	TRIM(WSOR.CONSIGNEEKEY)
		
 LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC
        ON LNCC.T$CADR = LNCP.T$CADR
        
 LEFT JOIN WMWHSE5.codelkup DIVS
        ON DIVS.CODE = WSOR.INVOICESTATUS
       AND DIVS.LISTNAME = 'INVSTATUS'

LEFT JOIN ( SELECT  A.T$CNFE$L,
                    B.T$ITEM$L,
                    A.t$DATE$L,
                    C.T$DSCA$L,
                    SUM(B.T$DQUA$L) T$DQUA$L,
                    MAX(B.T$PRIC$L) T$PRIC$L,
                    SUM(B.T$AMNT$L) T$AMNT$L
            FROM  BAANDB.TCISLI940301@PLN01 A
            INNER JOIN BAANDB.TCISLI941301@PLN01 B ON B.T$FIRE$L = A.T$FIRE$L
            INNER JOIN BAANDB.TTCMCS966301@PLN01 C ON C.T$FDTC$L = A.T$FDTC$L
            WHERE A.T$CNFE$L != ' '
            GROUP BY  A.T$CNFE$L,
                      B.T$ITEM$L,
                      A.t$DATE$L,
                      C.T$DSCA$L) LNRF
          ON  LNRF.T$CNFE$L = WSOR.LOCATOR
          AND TRIM(LNRF.T$ITEM$L) = WSOD.SKU


WHERE WSOR.STATUS = '100'
  AND ( select count(x.orderkey)
          from WMWHSE5.orders x
         where x.referencedocument = WSOR.referencedocument
           and x.adddate > WSOR.adddate ) = 0
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataRegistroDe
          And :DataRegistroAte
 AND ((:PedidoTodos = 1)OR(WHINH200.T$ORNO IN (:Pedido) AND :PedidoTodos = 0))


=IIF(Parameters!Table.Value <> "AAA",
"  SELECT  "&
"  WSOR.WHSEID                  ID_FILIAL,  "&
"  wmsCODE.UDF2                 NOME_FILIAL,  "&
"  WSOR.REFERENCEDOCUMENT       PEDIDO_LN,  "&
"  WSOR.ORDERKEY                PEDIDO_WMS,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE)DATA_REGISTRO,  "&
"  WOSS.DESCRIPTION             EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LNRF.t$DATE$L,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_FATURAMENTO,  "&
"  WSOR.INVOICENUMBER           NF,  "&
"  WSOR.LANE                    NF_SERIE,  "&
"  LNRF.T$DSCA$L        DESCR_TP_DOC_FISCAL,  "&  
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO    NOME_OPERADOR,  "&            
"  TRIM(WSOD.SKU)            ITEM,  "&
"  TCIBD001.T$DSCA              DESCRICAO,  "&          
"  TCMCS023.T$DSCA              DEPARTAMENTO,  "&
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  "&
"  LNFB.T$DSCA                  NOME_FABRICANTE,  "&
"  NVL(LNCC.T$FOVN$L,  "&
"    SUBSTR(WSOR.C_COMPANY,0, INSTR(WSOR.C_COMPANY,' ')))  CNPJ_CLIENTE,  "&
"  CASE WHEN WSOR.CONSIGNEEKEY=' '  "&
"    THEN SUBSTR(WSOR.C_COMPANY, INSTR(WSOR.C_COMPANY,' ')+1,20)  "&
"    ELSE WSOR.C_COMPANY END    NOME_CLIENTE,  "&
"  WSKU.STDCUBE          M3_UNITARIO,  "&          
"  WSOD.ORIGINALQTY       QTD_PEDIDO,  "&        
"  WSOD.ORIGINALQTY        QTD_CANCELADA,  "&
"  NVL(LNRF.T$DQUA$L,0)  QTD_FATURADA,  "&
"  ABS(LNRF.T$PRIC$L)    VALOR_NF_UNITARIO,  "&
"  ABS(LNRF.T$AMNT$L)    VALOR_NF_TOTAL,  "&
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  "&
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  "&
"  FROM     " + Parameters!Table.Value + ".ORDERS     WSOR  "&
"  INNER JOIN   ( SELECT A.ORDERKEY, A.SKU, SUM(A.ORIGINALQTY) ORIGINALQTY  "&
"        FROM " + Parameters!Table.Value + ".ORDERDETAIL A  "&
"        GROUP BY  A.ORDERKEY, A.SKU)  WSOD  "&
"      ON  WSOD.ORDERKEY  =  WSOR.ORDERKEY  "&
"  INNER JOIN   " + Parameters!Table.Value + ".SKU WSKU  "&
"      ON  WSKU.SKU = WSOD.SKU  "&
"  INNER JOIN ( select A.LONG_VALUE, UPPER(A.UDF1) UDF1, A.UDF2  "&
"        from ENTERPRISE.CODELKUP A  "&
"        where A.LISTNAME = 'SCHEMA') wmsCODE  "&
"      ON wmsCODE.UDF1 = WSOR.WHSEID  "&
"  INNER JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP WOSS  "&
"      ON WOSS.CODE = WSOR.STATUS  "&
"  LEFT JOIN ( select clkp.code COD_TIPO_PEDIDO, NVL(trans.description,  "&
"            clkp.description)  DSC_TIPO_PEDIDO  "&
"        from " + Parameters!Table.Value + ".codelkup clkp  "&
"      left join " + Parameters!Table.Value + ".translationlist trans  "&
"          on trans.code = clkp.code  "&
"          and trans.joinkey1 = clkp.listname  "&
"          and trans.locale = 'pt'  "&
"          and trans.tblname = 'CODELKUP'  "&
"        where clkp.listname = 'ORDERTYPE'  "&
"          and Trim(clkp.code) is not null  ) TIPO_PEDIDO  "&
"      ON TIPO_PEDIDO.COD_TIPO_PEDIDO = WSOR.type  "&
"  INNER JOIN BAANDB.TTCIBD001301@PLN01  TCIBD001  "&
"      ON TRIM(TCIBD001.T$ITEM) = WSOD.SKU  "&
"  LEFT JOIN BAANDB.TTCMCS023301@PLN01  TCMCS023  "&
"      ON TCMCS023.T$CITG = TCIBD001.T$CITG  "&
"  LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  "&
"      ON LNFB.T$CMNF = TCIBD001.T$CMNF  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  "&
"      ON LNCF.T$CADR = LNFB.T$CADR  "&
"  LEFT JOIN  BAANDB.TTCCOM100301@PLN01  LNCP  "&
"      ON  LNCP.T$BPID  =  TRIM(WSOR.CONSIGNEEKEY)  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  "&
"      ON LNCC.T$CADR = LNCP.T$CADR  "&
"  LEFT JOIN " + Parameters!Table.Value + ".codelkup DIVS  "&
"      ON DIVS.CODE = WSOR.INVOICESTATUS  "&
"    AND DIVS.LISTNAME = 'INVSTATUS'  "&
"  LEFT JOIN ( SELECT  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L, C.T$DSCA$L,  "&
"            SUM(B.T$DQUA$L) T$DQUA$L, MAX(B.T$PRIC$L) T$PRIC$L,  "&
"            SUM(B.T$AMNT$L) T$AMNT$L  "&
"        FROM  BAANDB.TCISLI940301@PLN01 A  "&
"        INNER JOIN BAANDB.TCISLI941301@PLN01 B ON B.T$FIRE$L = A.T$FIRE$L  "&
"        INNER JOIN BAANDB.TTCMCS966301@PLN01 C ON C.T$FDTC$L = A.T$FDTC$L  "&
"        WHERE A.T$CNFE$L != ' '  "&
"        GROUP BY  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L, C.T$DSCA$L) LNRF  "&
"      ON  LNRF.T$CNFE$L = WSOR.LOCATOR  "&
"      AND TRIM(LNRF.T$ITEM$L) = WSOD.SKU  "&
"  WHERE WSOR.STATUS = '100'  "&
"  AND ( select count(x.orderkey)  "&
"      from " + Parameters!Table.Value + ".orders x  "&
"      where x.referencedocument = WSOR.referencedocument  "&
"      and x.adddate > WSOR.adddate ) = 0  "&
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"        AT time zone 'America/Sao_Paulo') AS DATE))  "&
"    Between '" + Parameters!DataRegistroDe.Value + "'  "&                              
"      And '" + Parameters!DataRegistroAte.Value + "'  "&                              
"  AND ( (UPPER(Trim(WSOR.REFERENCEDOCUMENT)) IN  "&
"( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ";", "','") + "'")  + " )  "&
"  AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"  OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  "
,
"  SELECT  "&
"  WSOR.WHSEID                  ID_FILIAL,  "&
"  wmsCODE.UDF2                 NOME_FILIAL,  "&
"  WSOR.REFERENCEDOCUMENT       PEDIDO_LN,  "&
"  WSOR.ORDERKEY                PEDIDO_WMS,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_REGISTRO,  "&
"  WOSS.DESCRIPTION             EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LNRF.t$DATE$L,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_FATURAMENTO,  "&
"  WSOR.INVOICENUMBER           NF,  "&
"  WSOR.LANE                    NF_SERIE,  "&
"  LNRF.T$DSCA$L        DESCR_TP_DOC_FISCAL,  "&  
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO    NOME_OPERADOR,  "&            
"  TRIM(WSOD.SKU)            ITEM,  "&
"  TCIBD001.T$DSCA              DESCRICAO,  "&          
"  TCMCS023.T$DSCA              DEPARTAMENTO,  "&
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  "&
"  LNFB.T$DSCA                  NOME_FABRICANTE,  "&
"  NVL(LNCC.T$FOVN$L, SUBSTR(WSOR.C_COMPANY,0, INSTR(WSOR.C_COMPANY,' '))) CNPJ_CLIENTE,  "&
"  CASE WHEN WSOR.CONSIGNEEKEY=' '  "&
"    THEN SUBSTR(WSOR.C_COMPANY, INSTR(WSOR.C_COMPANY,' ')+1,20)  "&
"    ELSE WSOR.C_COMPANY END    NOME_CLIENTE,  "&
"  WSKU.STDCUBE          M3_UNITARIO,  "&          
"  WSOD.ORIGINALQTY       QTD_PEDIDO,  "&        
"  WSOD.ORIGINALQTY        QTD_CANCELADA,  "&
"  NVL(LNRF.T$DQUA$L,0)  QTD_FATURADA,  "&
"  ABS(LNRF.T$PRIC$L)    VALOR_NF_UNITARIO,  "&
"  ABS(LNRF.T$AMNT$L)    VALOR_NF_TOTAL,  "&
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  "&
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  "&
"  FROM     WMWHSE1.ORDERS     WSOR  "&
"  INNER JOIN   ( SELECT A.ORDERKEY, A.SKU,  "&
"            SUM(A.ORIGINALQTY) ORIGINALQTY  "&
"        FROM WMWHSE1.ORDERDETAIL A  "&
"        GROUP BY  A.ORDERKEY, A.SKU)  WSOD  "&
"      ON  WSOD.ORDERKEY  =  WSOR.ORDERKEY  "&
"  INNER JOIN   WMWHSE1.SKU WSKU  "&
"      ON  WSKU.SKU = WSOD.SKU  "&
"  INNER JOIN ( select A.LONG_VALUE, UPPER(A.UDF1) UDF1, A.UDF2  "&
"        from ENTERPRISE.CODELKUP A  "&
"        where A.LISTNAME = 'SCHEMA') wmsCODE  "&
"      ON wmsCODE.UDF1 = WSOR.WHSEID  "&
"  INNER JOIN WMWHSE1.ORDERSTATUSSETUP WOSS  "&
"      ON WOSS.CODE = WSOR.STATUS  "&
"  LEFT JOIN ( select clkp.code  COD_TIPO_PEDIDO, NVL(trans.description,  "&
"            clkp.description)  DSC_TIPO_PEDIDO  "&
"        from WMWHSE1.codelkup clkp  "&
"      left join WMWHSE1.translationlist trans  "&
"          on trans.code = clkp.code  "&
"          and trans.joinkey1 = clkp.listname  "&
"          and trans.locale = 'pt'  "&
"          and trans.tblname = 'CODELKUP'  "&
"        where clkp.listname = 'ORDERTYPE'  "&
"          and Trim(clkp.code) is not null  ) TIPO_PEDIDO  "&
"      ON TIPO_PEDIDO.COD_TIPO_PEDIDO = WSOR.type  "&
"  INNER JOIN BAANDB.TTCIBD001301@PLN01  TCIBD001  "&
"      ON TRIM(TCIBD001.T$ITEM) = WSOD.SKU  "&
"  LEFT JOIN BAANDB.TTCMCS023301@PLN01  TCMCS023  "&
"      ON TCMCS023.T$CITG = TCIBD001.T$CITG  "&
"  LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  "&
"      ON LNFB.T$CMNF = TCIBD001.T$CMNF  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  "&
"      ON LNCF.T$CADR = LNFB.T$CADR  "&
"  LEFT JOIN  BAANDB.TTCCOM100301@PLN01  LNCP  "&
"      ON  LNCP.T$BPID  =  TRIM(WSOR.CONSIGNEEKEY)  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  "&
"      ON LNCC.T$CADR = LNCP.T$CADR  "&
"  LEFT JOIN WMWHSE1.codelkup DIVS  "&
"      ON DIVS.CODE = WSOR.INVOICESTATUS  "&
"    AND DIVS.LISTNAME = 'INVSTATUS'  "&
"  LEFT JOIN ( SELECT  A.T$CNFE$L, B.T$ITEM$L,  "&
"            A.t$DATE$L, C.T$DSCA$L,  "&
"            SUM(B.T$DQUA$L) T$DQUA$L,  "&
"            MAX(B.T$PRIC$L) T$PRIC$L,  "&
"            SUM(B.T$AMNT$L) T$AMNT$L  "&
"        FROM  BAANDB.TCISLI940301@PLN01 A  "&
"        INNER JOIN BAANDB.TCISLI941301@PLN01 B ON B.T$FIRE$L = A.T$FIRE$L  "&
"        INNER JOIN BAANDB.TTCMCS966301@PLN01 C ON C.T$FDTC$L = A.T$FDTC$L  "&
"        WHERE A.T$CNFE$L != ' '  "&
"        GROUP BY  A.T$CNFE$L, B.T$ITEM$L,  "&
"            A.t$DATE$L, C.T$DSCA$L) LNRF  "&
"      ON  LNRF.T$CNFE$L = WSOR.LOCATOR  "&
"      AND TRIM(LNRF.T$ITEM$L) = WSOD.SKU  "&
"  WHERE WSOR.STATUS = '100'  "&
"  AND ( select count(x.orderkey)  "&
"      from WMWHSE1.orders x  "&
"      where x.referencedocument = WSOR.referencedocument  "&
"      and x.adddate > WSOR.adddate ) = 0  "&
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"        AT time zone 'America/Sao_Paulo') AS DATE))  "&
"    Between '" + Parameters!DataRegistroDe.Value + "'  "&                              
"      And '" + Parameters!DataRegistroAte.Value + "'  "&                              
"  AND ( (UPPER(Trim(WSOR.REFERENCEDOCUMENT)) IN  "&
"( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ";", "','") + "'")  + " )  "&
"  AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"  OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  "&
"  SELECT  "&
"  WSOR.WHSEID                  ID_FILIAL,  "&
"  wmsCODE.UDF2                 NOME_FILIAL,  "&
"  WSOR.REFERENCEDOCUMENT       PEDIDO_LN,  "&
"  WSOR.ORDERKEY                PEDIDO_WMS,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_REGISTRO,  "&
"  WOSS.DESCRIPTION             EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LNRF.t$DATE$L,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_FATURAMENTO,  "&
"  WSOR.INVOICENUMBER           NF,  "&
"  WSOR.LANE                    NF_SERIE,  "&
"  LNRF.T$DSCA$L        DESCR_TP_DOC_FISCAL,  "&  
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO    NOME_OPERADOR,  "&            
"  TRIM(WSOD.SKU)            ITEM,  "&
"  TCIBD001.T$DSCA              DESCRICAO,  "&          
"  TCMCS023.T$DSCA              DEPARTAMENTO,  "&
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  "&
"  LNFB.T$DSCA                  NOME_FABRICANTE,  "&
"  NVL(LNCC.T$FOVN$L,  "&
"    SUBSTR(WSOR.C_COMPANY,0, INSTR(WSOR.C_COMPANY,' ')))   CNPJ_CLIENTE,  "&
"  CASE WHEN WSOR.CONSIGNEEKEY=' '  "&
"    THEN SUBSTR(WSOR.C_COMPANY, INSTR(WSOR.C_COMPANY,' ')+1,20)  "&
"    ELSE WSOR.C_COMPANY END    NOME_CLIENTE,  "&
"  WSKU.STDCUBE          M3_UNITARIO,  "&          
"  WSOD.ORIGINALQTY       QTD_PEDIDO,  "&        
"  WSOD.ORIGINALQTY        QTD_CANCELADA,  "&
"  NVL(LNRF.T$DQUA$L,0)  QTD_FATURADA,  "&
"  ABS(LNRF.T$PRIC$L)    VALOR_NF_UNITARIO,  "&
"  ABS(LNRF.T$AMNT$L)    VALOR_NF_TOTAL,  "&
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  "&
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  "&
"  FROM     WMWHSE2.ORDERS     WSOR  "&
"  INNER JOIN   ( SELECT A.ORDERKEY, A.SKU,  "&
"            SUM(A.ORIGINALQTY) ORIGINALQTY  "&
"        FROM WMWHSE2.ORDERDETAIL A  "&
"        GROUP BY  A.ORDERKEY,A.SKU)  WSOD  "&
"      ON  WSOD.ORDERKEY  =  WSOR.ORDERKEY  "&
"  INNER JOIN   WMWHSE2.SKU WSKU  "&
"      ON  WSKU.SKU = WSOD.SKU  "&
"  INNER JOIN ( select A.LONG_VALUE, UPPER(A.UDF1) UDF1, A.UDF2  "&
"        from ENTERPRISE.CODELKUP A  "&
"        where A.LISTNAME = 'SCHEMA') wmsCODE  "&
"      ON wmsCODE.UDF1 = WSOR.WHSEID  "&
"  INNER JOIN WMWHSE2.ORDERSTATUSSETUP WOSS  "&
"      ON WOSS.CODE = WSOR.STATUS  "&
"  LEFT JOIN ( select clkp.code   COD_TIPO_PEDIDO, NVL(trans.description,  "&
"        clkp.description)  DSC_TIPO_PEDIDO  "&
"        from WMWHSE2.codelkup clkp  "&
"      left join WMWHSE2.translationlist trans  "&
"          on trans.code = clkp.code  "&
"          and trans.joinkey1 = clkp.listname  "&
"          and trans.locale = 'pt'  "&
"          and trans.tblname = 'CODELKUP'  "&
"        where clkp.listname = 'ORDERTYPE'  "&
"          and Trim(clkp.code) is not null  ) TIPO_PEDIDO  "&
"      ON TIPO_PEDIDO.COD_TIPO_PEDIDO = WSOR.type  "&
"  INNER JOIN BAANDB.TTCIBD001301@PLN01  TCIBD001  "&
"      ON TRIM(TCIBD001.T$ITEM) = WSOD.SKU  "&
"  LEFT JOIN BAANDB.TTCMCS023301@PLN01  TCMCS023  "&
"      ON TCMCS023.T$CITG = TCIBD001.T$CITG  "&
"  LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  "&
"      ON LNFB.T$CMNF = TCIBD001.T$CMNF  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  "&
"      ON LNCF.T$CADR = LNFB.T$CADR  "&
"  LEFT JOIN  BAANDB.TTCCOM100301@PLN01  LNCP  "&
"      ON  LNCP.T$BPID  =  TRIM(WSOR.CONSIGNEEKEY)  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  "&
"      ON LNCC.T$CADR = LNCP.T$CADR  "&
"  LEFT JOIN WMWHSE2.codelkup DIVS  "&
"      ON DIVS.CODE = WSOR.INVOICESTATUS  "&
"    AND DIVS.LISTNAME = 'INVSTATUS'  "&
"  LEFT JOIN ( SELECT  A.T$CNFE$L, B.T$ITEM$L,  "&
"            A.t$DATE$L, C.T$DSCA$L,  "&
"            SUM(B.T$DQUA$L) T$DQUA$L,  "&
"            MAX(B.T$PRIC$L) T$PRIC$L,  "&
"            SUM(B.T$AMNT$L) T$AMNT$L  "&
"        FROM  BAANDB.TCISLI940301@PLN01 A  "&
"        INNER JOIN BAANDB.TCISLI941301@PLN01 B ON B.T$FIRE$L = A.T$FIRE$L  "&
"        INNER JOIN BAANDB.TTCMCS966301@PLN01 C ON C.T$FDTC$L = A.T$FDTC$L  "&
"        WHERE A.T$CNFE$L != ' '  "&
"        GROUP BY  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L,  "&
"            C.T$DSCA$L) LNRF  "&
"      ON  LNRF.T$CNFE$L = WSOR.LOCATOR  "&
"      AND TRIM(LNRF.T$ITEM$L) = WSOD.SKU  "&
"  WHERE WSOR.STATUS = '100'  "&
"  AND ( select count(x.orderkey)  "&
"      from WMWHSE2.orders x  "&
"      where x.referencedocument = WSOR.referencedocument  "&
"      and x.adddate > WSOR.adddate ) = 0  "&
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"        AT time zone 'America/Sao_Paulo') AS DATE))  "&
"    Between '" + Parameters!DataRegistroDe.Value + "'  "&                              
"      And '" + Parameters!DataRegistroAte.Value + "'  "&                              
"  AND ( (UPPER(Trim(WSOR.REFERENCEDOCUMENT)) IN  "&
"( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ";", "','") + "'")  + " )  "&
"  AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"  OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  "&
"  SELECT  "&
"  WSOR.WHSEID                  ID_FILIAL,  "&
"  wmsCODE.UDF2                 NOME_FILIAL,  "&
"  WSOR.REFERENCEDOCUMENT       PEDIDO_LN,  "&
"  WSOR.ORDERKEY                PEDIDO_WMS,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE)   DATA_REGISTRO,  "&
"  WOSS.DESCRIPTION             EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LNRF.t$DATE$L,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_FATURAMENTO,  "&
"  WSOR.INVOICENUMBER           NF,  "&
"  WSOR.LANE                    NF_SERIE,  "&
"  LNRF.T$DSCA$L        DESCR_TP_DOC_FISCAL,  "&  
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO    NOME_OPERADOR,  "&            
"  TRIM(WSOD.SKU)            ITEM,  "&
"  TCIBD001.T$DSCA              DESCRICAO,  "&          
"  TCMCS023.T$DSCA              DEPARTAMENTO,  "&
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  "&
"  LNFB.T$DSCA                  NOME_FABRICANTE,  "&
"  NVL(LNCC.T$FOVN$L, SUBSTR(WSOR.C_COMPANY,0, INSTR(WSOR.C_COMPANY,' '))) CNPJ_CLIENTE,  "&
"  CASE WHEN WSOR.CONSIGNEEKEY=' '  "&
"    THEN SUBSTR(WSOR.C_COMPANY, INSTR(WSOR.C_COMPANY,' ')+1,20)  "&
"    ELSE WSOR.C_COMPANY END    NOME_CLIENTE,  "&
"  WSKU.STDCUBE          M3_UNITARIO,  "&          
"  WSOD.ORIGINALQTY       QTD_PEDIDO,  "&        
"  WSOD.ORIGINALQTY        QTD_CANCELADA,  "&
"  NVL(LNRF.T$DQUA$L,0)  QTD_FATURADA,  "&
"  ABS(LNRF.T$PRIC$L)    VALOR_NF_UNITARIO,  "&
"  ABS(LNRF.T$AMNT$L)    VALOR_NF_TOTAL,  "&
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  "&
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  "&
"  FROM     WMWHSE3.ORDERS     WSOR  "&
"  INNER JOIN   ( SELECT A.ORDERKEY, A.SKU,  "&
"            SUM(A.ORIGINALQTY) ORIGINALQTY  "&
"        FROM WMWHSE3.ORDERDETAIL A  "&
"        GROUP BY  A.ORDERKEY, A.SKU)  WSOD  "&
"      ON  WSOD.ORDERKEY  =  WSOR.ORDERKEY  "&
"  INNER JOIN   WMWHSE3.SKU WSKU  "&
"      ON  WSKU.SKU = WSOD.SKU  "&
"  INNER JOIN ( select A.LONG_VALUE, UPPER(A.UDF1) UDF1, A.UDF2  "&
"        from ENTERPRISE.CODELKUP A  "&
"        where A.LISTNAME = 'SCHEMA') wmsCODE  "&
"      ON wmsCODE.UDF1 = WSOR.WHSEID  "&
"  INNER JOIN WMWHSE3.ORDERSTATUSSETUP WOSS  "&
"      ON WOSS.CODE = WSOR.STATUS  "&
"  LEFT JOIN ( select clkp.code COD_TIPO_PEDIDO,  "&
"            NVL(trans.description,  "&
"            clkp.description)  DSC_TIPO_PEDIDO  "&
"        from WMWHSE3.codelkup clkp  "&
"      left join WMWHSE3.translationlist trans  "&
"          on trans.code = clkp.code  "&
"          and trans.joinkey1 = clkp.listname  "&
"          and trans.locale = 'pt'  "&
"          and trans.tblname = 'CODELKUP'  "&
"        where clkp.listname = 'ORDERTYPE'  "&
"          and Trim(clkp.code) is not null  ) TIPO_PEDIDO  "&
"      ON TIPO_PEDIDO.COD_TIPO_PEDIDO = WSOR.type  "&
"  INNER JOIN BAANDB.TTCIBD001301@PLN01  TCIBD001  "&
"      ON TRIM(TCIBD001.T$ITEM) = WSOD.SKU  "&
"  LEFT JOIN BAANDB.TTCMCS023301@PLN01  TCMCS023  "&
"      ON TCMCS023.T$CITG = TCIBD001.T$CITG  "&
"  LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  "&
"      ON LNFB.T$CMNF = TCIBD001.T$CMNF  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  "&
"      ON LNCF.T$CADR = LNFB.T$CADR  "&
"  LEFT JOIN  BAANDB.TTCCOM100301@PLN01  LNCP  "&
"      ON  LNCP.T$BPID  =  TRIM(WSOR.CONSIGNEEKEY)  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  "&
"      ON LNCC.T$CADR = LNCP.T$CADR  "&
"  LEFT JOIN WMWHSE3.codelkup DIVS  "&
"      ON DIVS.CODE = WSOR.INVOICESTATUS  "&
"    AND DIVS.LISTNAME = 'INVSTATUS'  "&
"  LEFT JOIN ( SELECT  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L, C.T$DSCA$L,  "&
"            SUM(B.T$DQUA$L) T$DQUA$L,  "&
"            MAX(B.T$PRIC$L) T$PRIC$L,  "&
"            SUM(B.T$AMNT$L) T$AMNT$L  "&
"        FROM  BAANDB.TCISLI940301@PLN01 A  "&
"        INNER JOIN BAANDB.TCISLI941301@PLN01 B ON B.T$FIRE$L = A.T$FIRE$L  "&
"        INNER JOIN BAANDB.TTCMCS966301@PLN01 C ON C.T$FDTC$L = A.T$FDTC$L  "&
"        WHERE A.T$CNFE$L != ' '  "&
"        GROUP BY  A.T$CNFE$L, B.T$ITEM$L,  "&
"            A.t$DATE$L, C.T$DSCA$L) LNRF  "&
"      ON  LNRF.T$CNFE$L = WSOR.LOCATOR  "&
"      AND TRIM(LNRF.T$ITEM$L) = WSOD.SKU  "&
"  WHERE WSOR.STATUS = '100'  "&
"  AND ( select count(x.orderkey)  "&
"      from WMWHSE3.orders x  "&
"      where x.referencedocument = WSOR.referencedocument  "&
"      and x.adddate > WSOR.adddate ) = 0  "&
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"        AT time zone 'America/Sao_Paulo') AS DATE))  "&
"    Between '" + Parameters!DataRegistroDe.Value + "'  "&                              
"      And '" + Parameters!DataRegistroAte.Value + "'  "&                              
"  AND ( (UPPER(Trim(WSOR.REFERENCEDOCUMENT)) IN  "&
"( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ";", "','") + "'")  + " )  "&
"  AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"  OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  "&
"  SELECT  "&
"  WSOR.WHSEID                  ID_FILIAL,  "&
"  wmsCODE.UDF2                 NOME_FILIAL,  "&
"  WSOR.REFERENCEDOCUMENT       PEDIDO_LN,  "&
"  WSOR.ORDERKEY                PEDIDO_WMS,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_REGISTRO,  "&
"  WOSS.DESCRIPTION             EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE)  DATA_EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LNRF.t$DATE$L,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_FATURAMENTO,  "&
"  WSOR.INVOICENUMBER           NF,  "&
"  WSOR.LANE                    NF_SERIE,  "&
"  LNRF.T$DSCA$L        DESCR_TP_DOC_FISCAL,  "&  
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO    NOME_OPERADOR,  "&            
"  TRIM(WSOD.SKU)            ITEM,  "&
"  TCIBD001.T$DSCA              DESCRICAO,  "&          
"  TCMCS023.T$DSCA              DEPARTAMENTO,  "&
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  "&
"  LNFB.T$DSCA                  NOME_FABRICANTE,  "&
"  NVL(LNCC.T$FOVN$L,  "&
"    SUBSTR(WSOR.C_COMPANY,0, INSTR(WSOR.C_COMPANY,' ')))  CNPJ_CLIENTE,  "&
"  CASE WHEN WSOR.CONSIGNEEKEY=' '  "&
"    THEN SUBSTR(WSOR.C_COMPANY, INSTR(WSOR.C_COMPANY,' ')+1,20)  "&
"    ELSE WSOR.C_COMPANY END    NOME_CLIENTE,  "&
"  WSKU.STDCUBE          M3_UNITARIO,  "&          
"  WSOD.ORIGINALQTY       QTD_PEDIDO,  "&        
"  WSOD.ORIGINALQTY        QTD_CANCELADA,  "&
"  NVL(LNRF.T$DQUA$L,0)  QTD_FATURADA,  "&
"  ABS(LNRF.T$PRIC$L)    VALOR_NF_UNITARIO,  "&
"  ABS(LNRF.T$AMNT$L)    VALOR_NF_TOTAL,  "&
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  "&
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  "&
"  FROM     WMWHSE4.ORDERS     WSOR  "&
"  INNER JOIN   ( SELECT A.ORDERKEY, A.SKU, SUM(A.ORIGINALQTY) ORIGINALQTY  "&
"        FROM WMWHSE4.ORDERDETAIL A  "&
"        GROUP BY  A.ORDERKEY, A.SKU)  WSOD  "&
"      ON  WSOD.ORDERKEY  =  WSOR.ORDERKEY  "&
"  INNER JOIN   WMWHSE4.SKU WSKU  "&
"      ON  WSKU.SKU = WSOD.SKU  "&
"  INNER JOIN ( select A.LONG_VALUE, UPPER(A.UDF1) UDF1, A.UDF2  "&
"        from ENTERPRISE.CODELKUP A  "&
"        where A.LISTNAME = 'SCHEMA') wmsCODE  "&
"      ON wmsCODE.UDF1 = WSOR.WHSEID  "&
"  INNER JOIN WMWHSE4.ORDERSTATUSSETUP WOSS  "&
"      ON WOSS.CODE = WSOR.STATUS  "&
"  LEFT JOIN ( select clkp.code COD_TIPO_PEDIDO, NVL(trans.description,  "&
"            clkp.description)  DSC_TIPO_PEDIDO  "&
"        from WMWHSE4.codelkup clkp  "&
"      left join WMWHSE4.translationlist trans  "&
"          on trans.code = clkp.code  "&
"          and trans.joinkey1 = clkp.listname  "&
"          and trans.locale = 'pt'  "&
"          and trans.tblname = 'CODELKUP'  "&
"        where clkp.listname = 'ORDERTYPE'  "&
"          and Trim(clkp.code) is not null  ) TIPO_PEDIDO  "&
"      ON TIPO_PEDIDO.COD_TIPO_PEDIDO = WSOR.type  "&
"  INNER JOIN BAANDB.TTCIBD001301@PLN01  TCIBD001  "&
"      ON TRIM(TCIBD001.T$ITEM) = WSOD.SKU  "&
"  LEFT JOIN BAANDB.TTCMCS023301@PLN01  TCMCS023  "&
"      ON TCMCS023.T$CITG = TCIBD001.T$CITG  "&
"  LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  "&
"      ON LNFB.T$CMNF = TCIBD001.T$CMNF  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  "&
"      ON LNCF.T$CADR = LNFB.T$CADR  "&
"  LEFT JOIN  BAANDB.TTCCOM100301@PLN01  LNCP  "&
"      ON  LNCP.T$BPID  =  TRIM(WSOR.CONSIGNEEKEY)  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  "&
"      ON LNCC.T$CADR = LNCP.T$CADR  "&
"  LEFT JOIN WMWHSE4.codelkup DIVS  "&
"      ON DIVS.CODE = WSOR.INVOICESTATUS  "&
"    AND DIVS.LISTNAME = 'INVSTATUS'  "&
"  LEFT JOIN ( SELECT  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L, C.T$DSCA$L,  "&
"            SUM(B.T$DQUA$L) T$DQUA$L, MAX(B.T$PRIC$L) T$PRIC$L,  "&
"            SUM(B.T$AMNT$L) T$AMNT$L  "&
"        FROM  BAANDB.TCISLI940301@PLN01 A  "&
"        INNER JOIN BAANDB.TCISLI941301@PLN01 B ON B.T$FIRE$L = A.T$FIRE$L  "&
"        INNER JOIN BAANDB.TTCMCS966301@PLN01 C ON C.T$FDTC$L = A.T$FDTC$L  "&
"        WHERE A.T$CNFE$L != ' '  "&
"        GROUP BY  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L, C.T$DSCA$L) LNRF  "&
"      ON  LNRF.T$CNFE$L = WSOR.LOCATOR  "&
"      AND TRIM(LNRF.T$ITEM$L) = WSOD.SKU  "&
"  WHERE WSOR.STATUS = '100'  "&
"  AND ( select count(x.orderkey)  "&
"      from WMWHSE4.orders x  "&
"      where x.referencedocument = WSOR.referencedocument  "&
"      and x.adddate > WSOR.adddate ) = 0  "&
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"        AT time zone 'America/Sao_Paulo') AS DATE))  "&
"    Between '" + Parameters!DataRegistroDe.Value + "'  "&                              
"      And '" + Parameters!DataRegistroAte.Value + "'  "&                              
"  AND ( (UPPER(Trim(WSOR.REFERENCEDOCUMENT)) IN  "&
"( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ";", "','") + "'")  + " )  "&
"  AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"  OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  "&
"  SELECT  "&
"  WSOR.WHSEID                  ID_FILIAL,  "&
"  wmsCODE.UDF2                 NOME_FILIAL,  "&
"  WSOR.REFERENCEDOCUMENT       PEDIDO_LN,  "&
"  WSOR.ORDERKEY                PEDIDO_WMS,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_REGISTRO,  "&
"  WOSS.DESCRIPTION             EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LNRF.t$DATE$L,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_FATURAMENTO,  "&
"  WSOR.INVOICENUMBER           NF,  "&
"  WSOR.LANE                    NF_SERIE,  "&
"  LNRF.T$DSCA$L        DESCR_TP_DOC_FISCAL,  "&  
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO    NOME_OPERADOR,  "&            
"  TRIM(WSOD.SKU)            ITEM,  "&
"  TCIBD001.T$DSCA              DESCRICAO,  "&          
"  TCMCS023.T$DSCA              DEPARTAMENTO,  "&
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  "&
"  LNFB.T$DSCA                  NOME_FABRICANTE,  "&
"  NVL(LNCC.T$FOVN$L, SUBSTR(WSOR.C_COMPANY,0, INSTR(WSOR.C_COMPANY,' '))) CNPJ_CLIENTE,  "&
"  CASE WHEN WSOR.CONSIGNEEKEY=' '  "&
"    THEN SUBSTR(WSOR.C_COMPANY, INSTR(WSOR.C_COMPANY,' ')+1,20)  "&
"    ELSE WSOR.C_COMPANY END    NOME_CLIENTE,  "&
"  WSKU.STDCUBE          M3_UNITARIO,  "&          
"  WSOD.ORIGINALQTY       QTD_PEDIDO,  "&        
"  WSOD.ORIGINALQTY        QTD_CANCELADA,  "&
"  NVL(LNRF.T$DQUA$L,0)  QTD_FATURADA,  "&
"  ABS(LNRF.T$PRIC$L)    VALOR_NF_UNITARIO,  "&
"  ABS(LNRF.T$AMNT$L)    VALOR_NF_TOTAL,  "&
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  "&
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  "&
"  FROM     WMWHSE5.ORDERS     WSOR  "&
"  INNER JOIN   ( SELECT A.ORDERKEY, A.SKU, SUM(A.ORIGINALQTY) ORIGINALQTY  "&
"        FROM WMWHSE5.ORDERDETAIL A  "&
"        GROUP BY  A.ORDERKEY, A.SKU)  WSOD  "&
"      ON  WSOD.ORDERKEY  =  WSOR.ORDERKEY  "&
"  INNER JOIN   WMWHSE5.SKU WSKU  "&
"      ON  WSKU.SKU = WSOD.SKU  "&
"  INNER JOIN ( select A.LONG_VALUE, UPPER(A.UDF1) UDF1, A.UDF2  "&
"        from ENTERPRISE.CODELKUP A  "&
"        where A.LISTNAME = 'SCHEMA') wmsCODE  "&
"      ON wmsCODE.UDF1 = WSOR.WHSEID  "&
"  INNER JOIN WMWHSE5.ORDERSTATUSSETUP WOSS  "&
"      ON WOSS.CODE = WSOR.STATUS  "&
"  LEFT JOIN ( select clkp.code COD_TIPO_PEDIDO, NVL(trans.description,  "&
"            clkp.description)  DSC_TIPO_PEDIDO  "&
"        from WMWHSE5.codelkup clkp  "&
"      left join WMWHSE5.translationlist trans  "&
"          on trans.code = clkp.code  "&
"          and trans.joinkey1 = clkp.listname  "&
"          and trans.locale = 'pt'  "&
"          and trans.tblname = 'CODELKUP'  "&
"        where clkp.listname = 'ORDERTYPE'  "&
"          and Trim(clkp.code) is not null  ) TIPO_PEDIDO  "&
"      ON TIPO_PEDIDO.COD_TIPO_PEDIDO = WSOR.type  "&
"  INNER JOIN BAANDB.TTCIBD001301@PLN01  TCIBD001  "&
"      ON TRIM(TCIBD001.T$ITEM) = WSOD.SKU  "&
"  LEFT JOIN BAANDB.TTCMCS023301@PLN01  TCMCS023  "&
"      ON TCMCS023.T$CITG = TCIBD001.T$CITG  "&
"  LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  "&
"      ON LNFB.T$CMNF = TCIBD001.T$CMNF  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  "&
"      ON LNCF.T$CADR = LNFB.T$CADR  "&
"  LEFT JOIN  BAANDB.TTCCOM100301@PLN01  LNCP  "&
"      ON  LNCP.T$BPID  =  TRIM(WSOR.CONSIGNEEKEY)  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  "&
"      ON LNCC.T$CADR = LNCP.T$CADR  "&
"  LEFT JOIN WMWHSE5.codelkup DIVS  "&
"      ON DIVS.CODE = WSOR.INVOICESTATUS  "&
"    AND DIVS.LISTNAME = 'INVSTATUS'  "&
"  LEFT JOIN ( SELECT  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L, C.T$DSCA$L,  "&
"            SUM(B.T$DQUA$L) T$DQUA$L, MAX(B.T$PRIC$L) T$PRIC$L,  "&
"            SUM(B.T$AMNT$L) T$AMNT$L  "&
"        FROM  BAANDB.TCISLI940301@PLN01 A  "&
"        INNER JOIN BAANDB.TCISLI941301@PLN01 B ON B.T$FIRE$L = A.T$FIRE$L  "&
"        INNER JOIN BAANDB.TTCMCS966301@PLN01 C ON C.T$FDTC$L = A.T$FDTC$L  "&
"        WHERE A.T$CNFE$L != ' '  "&
"        GROUP BY  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L, C.T$DSCA$L) LNRF  "&
"      ON  LNRF.T$CNFE$L = WSOR.LOCATOR  "&
"      AND TRIM(LNRF.T$ITEM$L) = WSOD.SKU  "&
"  WHERE WSOR.STATUS = '100'  "&
"  AND ( select count(x.orderkey)  "&
"      from WMWHSE5.orders x  "&
"      where x.referencedocument = WSOR.referencedocument  "&
"      and x.adddate > WSOR.adddate ) = 0  "&
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"        AT time zone 'America/Sao_Paulo') AS DATE))  "&
"    Between '" + Parameters!DataRegistroDe.Value + "'  "&                              
"      And '" + Parameters!DataRegistroAte.Value + "'  "&                              
"  AND ( (UPPER(Trim(WSOR.REFERENCEDOCUMENT)) IN  "&
"( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ";", "','") + "'")  + " )  "&
"  AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"  OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  "&
"  SELECT  "&
"  WSOR.WHSEID                  ID_FILIAL,  "&
"  wmsCODE.UDF2                 NOME_FILIAL,  "&
"  WSOR.REFERENCEDOCUMENT       PEDIDO_LN,  "&
"  WSOR.ORDERKEY                PEDIDO_WMS,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_REGISTRO,  "&
"  WOSS.DESCRIPTION             EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE)DATA_EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LNRF.t$DATE$L,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE) DATA_FATURAMENTO,  "&
"  WSOR.INVOICENUMBER           NF,  "&
"  WSOR.LANE                    NF_SERIE,  "&
"  LNRF.T$DSCA$L        DESCR_TP_DOC_FISCAL,  "&  
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO    NOME_OPERADOR,  "&            
"  TRIM(WSOD.SKU)            ITEM,  "&
"  TCIBD001.T$DSCA              DESCRICAO,  "&          
"  TCMCS023.T$DSCA              DEPARTAMENTO,  "&
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  "&
"  LNFB.T$DSCA                  NOME_FABRICANTE,  "&
"  NVL(LNCC.T$FOVN$L,  "&
"    SUBSTR(WSOR.C_COMPANY,0, INSTR(WSOR.C_COMPANY,' ')))                CNPJ_CLIENTE,  "&
"  CASE WHEN WSOR.CONSIGNEEKEY=' '  "&
"    THEN SUBSTR(WSOR.C_COMPANY, INSTR(WSOR.C_COMPANY,' ')+1,20)  "&
"    ELSE WSOR.C_COMPANY END    NOME_CLIENTE,  "&
"  WSKU.STDCUBE          M3_UNITARIO,  "&
"  WSOD.ORIGINALQTY       QTD_PEDIDO,  "&        
"  WSOD.ORIGINALQTY        QTD_CANCELADA,  "&
"  NVL(LNRF.T$DQUA$L,0)  QTD_FATURADA,  "&
"  ABS(LNRF.T$PRIC$L)    VALOR_NF_UNITARIO,  "&
"  ABS(LNRF.T$AMNT$L)    VALOR_NF_TOTAL,  "&
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  "&
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  "&
"  FROM     WMWHSE6.ORDERS     WSOR  "&
"  INNER JOIN   ( SELECT A.ORDERKEY, A.SKU, SUM(A.ORIGINALQTY) ORIGINALQTY  "&
"        FROM WMWHSE6.ORDERDETAIL A  "&
"        GROUP BY  A.ORDERKEY, A.SKU)  WSOD  "&
"      ON  WSOD.ORDERKEY  =  WSOR.ORDERKEY  "&
"  INNER JOIN   WMWHSE6.SKU WSKU  "&
"      ON  WSKU.SKU = WSOD.SKU  "&
"  INNER JOIN ( select A.LONG_VALUE, UPPER(A.UDF1) UDF1, A.UDF2  "&
"        from ENTERPRISE.CODELKUP A  "&
"        where A.LISTNAME = 'SCHEMA') wmsCODE  "&
"      ON wmsCODE.UDF1 = WSOR.WHSEID  "&
"  INNER JOIN WMWHSE6.ORDERSTATUSSETUP WOSS  "&
"      ON WOSS.CODE = WSOR.STATUS  "&
"  LEFT JOIN ( select clkp.code  COD_TIPO_PEDIDO, NVL(trans.description,  "&
"            clkp.description)  DSC_TIPO_PEDIDO  "&
"        from WMWHSE6.codelkup clkp  "&
"      left join WMWHSE6.translationlist trans  "&
"          on trans.code = clkp.code  "&
"          and trans.joinkey1 = clkp.listname  "&
"          and trans.locale = 'pt'  "&
"          and trans.tblname = 'CODELKUP'  "&
"        where clkp.listname = 'ORDERTYPE'  "&
"          and Trim(clkp.code) is not null  ) TIPO_PEDIDO  "&
"      ON TIPO_PEDIDO.COD_TIPO_PEDIDO = WSOR.type  "&
"  INNER JOIN BAANDB.TTCIBD001301@PLN01  TCIBD001  "&
"      ON TRIM(TCIBD001.T$ITEM) = WSOD.SKU  "&
"  LEFT JOIN BAANDB.TTCMCS023301@PLN01  TCMCS023  "&
"      ON TCMCS023.T$CITG = TCIBD001.T$CITG  "&
"  LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  "&
"      ON LNFB.T$CMNF = TCIBD001.T$CMNF  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  "&
"      ON LNCF.T$CADR = LNFB.T$CADR  "&
"  LEFT JOIN  BAANDB.TTCCOM100301@PLN01  LNCP  "&
"      ON  LNCP.T$BPID  =  TRIM(WSOR.CONSIGNEEKEY)  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  "&
"      ON LNCC.T$CADR = LNCP.T$CADR  "&
"  LEFT JOIN WMWHSE6.codelkup DIVS  "&
"      ON DIVS.CODE = WSOR.INVOICESTATUS  "&
"    AND DIVS.LISTNAME = 'INVSTATUS'  "&
"  LEFT JOIN ( SELECT  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L, C.T$DSCA$L,  "&
"            SUM(B.T$DQUA$L) T$DQUA$L, MAX(B.T$PRIC$L) T$PRIC$L,  "&
"            SUM(B.T$AMNT$L) T$AMNT$L  "&
"        FROM  BAANDB.TCISLI940301@PLN01 A  "&
"        INNER JOIN BAANDB.TCISLI941301@PLN01 B ON B.T$FIRE$L = A.T$FIRE$L  "&
"        INNER JOIN BAANDB.TTCMCS966301@PLN01 C ON C.T$FDTC$L = A.T$FDTC$L  "&
"        WHERE A.T$CNFE$L != ' '  "&
"        GROUP BY  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L, C.T$DSCA$L) LNRF  "&
"      ON  LNRF.T$CNFE$L = WSOR.LOCATOR  "&
"      AND TRIM(LNRF.T$ITEM$L) = WSOD.SKU  "&
"  WHERE WSOR.STATUS = '100'  "&
"  AND ( select count(x.orderkey)  "&
"      from WMWHSE6.orders x  "&
"      where x.referencedocument = WSOR.referencedocument  "&
"      and x.adddate > WSOR.adddate ) = 0  "&
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"        AT time zone 'America/Sao_Paulo') AS DATE))  "&
"    Between '" + Parameters!DataRegistroDe.Value + "'  "&                              
"      And '" + Parameters!DataRegistroAte.Value + "'  "&                              
"  AND ( (UPPER(Trim(WSOR.REFERENCEDOCUMENT)) IN  "&
"( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ";", "','") + "'")  + " )  "&
"  AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"  OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " &
"UNION  "&
"  SELECT  "&
"  WSOR.WHSEID                  ID_FILIAL,  "&
"  wmsCODE.UDF2                 NOME_FILIAL,  "&
"  WSOR.REFERENCEDOCUMENT       PEDIDO_LN,  "&
"  WSOR.ORDERKEY                PEDIDO_WMS,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE)DATA_REGISTRO,  "&
"  WOSS.DESCRIPTION             EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.EDITDATE,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE)  DATA_EVENTO,  "&
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(LNRF.t$DATE$L,  "&
"    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"    AT time zone 'America/Sao_Paulo') AS DATE)  DATA_FATURAMENTO,  "&
"  WSOR.INVOICENUMBER           NF,  "&
"  WSOR.LANE                    NF_SERIE,  "&
"  LNRF.T$DSCA$L        DESCR_TP_DOC_FISCAL,  "&  
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO    NOME_OPERADOR,  "&            
"  TRIM(WSOD.SKU)            ITEM,  "&
"  TCIBD001.T$DSCA              DESCRICAO,  "&          
"  TCMCS023.T$DSCA              DEPARTAMENTO,  "&
"  LNCF.T$FOVN$L                CNPJ_FABRICANTE,  "&
"  LNFB.T$DSCA                  NOME_FABRICANTE,  "&
"  NVL(LNCC.T$FOVN$L,  "&
"    SUBSTR(WSOR.C_COMPANY,0, INSTR(WSOR.C_COMPANY,' ')))                CNPJ_CLIENTE,  "&
"  CASE WHEN WSOR.CONSIGNEEKEY=' '  "&
"    THEN SUBSTR(WSOR.C_COMPANY, INSTR(WSOR.C_COMPANY,' ')+1,20)  "&
"    ELSE WSOR.C_COMPANY END    NOME_CLIENTE,  "&
"  WSKU.STDCUBE          M3_UNITARIO,  "&          
"  WSOD.ORIGINALQTY       QTD_PEDIDO,  "&        
"  WSOD.ORIGINALQTY        QTD_CANCELADA,  "&
"  NVL(LNRF.T$DQUA$L,0)  QTD_FATURADA,  "&
"  ABS(LNRF.T$PRIC$L)    VALOR_NF_UNITARIO,  "&
"  ABS(LNRF.T$AMNT$L)    VALOR_NF_TOTAL,  "&
"  WSOR.EDITWHO                 USUARIO_CANCELAMENTO,  "&
"  DIVS.DESCRIPTION             SITUACAO_FATUTAMENTO  "&
"  FROM     WMWHSE7.ORDERS     WSOR  "&
"  INNER JOIN   ( SELECT A.ORDERKEY,  A.SKU,  "&
"            SUM(A.ORIGINALQTY) ORIGINALQTY  "&
"        FROM WMWHSE7.ORDERDETAIL A  "&
"        GROUP BY  A.ORDERKEY, A.SKU)  WSOD  "&
"      ON  WSOD.ORDERKEY  =  WSOR.ORDERKEY  "&
"  INNER JOIN   WMWHSE7.SKU WSKU  "&
"      ON  WSKU.SKU = WSOD.SKU  "&
"  INNER JOIN ( select A.LONG_VALUE, UPPER(A.UDF1) UDF1, A.UDF2  "&
"        from ENTERPRISE.CODELKUP A  "&
"        where A.LISTNAME = 'SCHEMA') wmsCODE  "&
"      ON wmsCODE.UDF1 = WSOR.WHSEID  "&
"  INNER JOIN WMWHSE7.ORDERSTATUSSETUP WOSS  "&
"      ON WOSS.CODE = WSOR.STATUS  "&
"  LEFT JOIN ( select clkp.code COD_TIPO_PEDIDO,  "&
"            NVL(trans.description, clkp.description)  DSC_TIPO_PEDIDO  "&
"        from WMWHSE7.codelkup clkp  "&
"      left join WMWHSE7.translationlist trans  "&
"          on trans.code = clkp.code  "&
"          and trans.joinkey1 = clkp.listname  "&
"          and trans.locale = 'pt'  "&
"          and trans.tblname = 'CODELKUP'  "&
"        where clkp.listname = 'ORDERTYPE'  "&
"          and Trim(clkp.code) is not null  ) TIPO_PEDIDO  "&
"      ON TIPO_PEDIDO.COD_TIPO_PEDIDO = WSOR.type  "&
"  INNER JOIN BAANDB.TTCIBD001301@PLN01  TCIBD001  "&
"      ON TRIM(TCIBD001.T$ITEM) = WSOD.SKU  "&
"  LEFT JOIN BAANDB.TTCMCS023301@PLN01  TCMCS023  "&
"      ON TCMCS023.T$CITG = TCIBD001.T$CITG  "&
"  LEFT JOIN BAANDB.TTCMCS060301@PLN01  LNFB  "&
"      ON LNFB.T$CMNF = TCIBD001.T$CMNF  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCF  "&
"      ON LNCF.T$CADR = LNFB.T$CADR  "&
"  LEFT JOIN  BAANDB.TTCCOM100301@PLN01  LNCP  "&
"      ON  LNCP.T$BPID  =  TRIM(WSOR.CONSIGNEEKEY)  "&
"  LEFT JOIN BAANDB.TTCCOM130301@PLN01  LNCC  "&
"      ON LNCC.T$CADR = LNCP.T$CADR  "&
"  LEFT JOIN WMWHSE7.codelkup DIVS  "&
"      ON DIVS.CODE = WSOR.INVOICESTATUS  "&
"    AND DIVS.LISTNAME = 'INVSTATUS'  "&
"  LEFT JOIN ( SELECT  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L, C.T$DSCA$L,  "&
"            SUM(B.T$DQUA$L) T$DQUA$L, MAX(B.T$PRIC$L) T$PRIC$L,  "&
"            SUM(B.T$AMNT$L) T$AMNT$L  "&
"        FROM  BAANDB.TCISLI940301@PLN01 A  "&
"        INNER JOIN BAANDB.TCISLI941301@PLN01 B ON B.T$FIRE$L = A.T$FIRE$L  "&
"        INNER JOIN BAANDB.TTCMCS966301@PLN01 C ON C.T$FDTC$L = A.T$FDTC$L  "&
"        WHERE A.T$CNFE$L != ' '  "&
"        GROUP BY  A.T$CNFE$L, B.T$ITEM$L, A.t$DATE$L, C.T$DSCA$L) LNRF  "&
"      ON  LNRF.T$CNFE$L = WSOR.LOCATOR  "&
"      AND TRIM(LNRF.T$ITEM$L) = WSOD.SKU  "&
"  WHERE WSOR.STATUS = '100'  "&
"  AND ( select count(x.orderkey)  "&
"      from WMWHSE7.orders x  "&
"      where x.referencedocument = WSOR.referencedocument  "&
"      and x.adddate > WSOR.adddate ) = 0  "&
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WSOR.ADDDATE,  "&
"        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  "&
"        AT time zone 'America/Sao_Paulo') AS DATE))  "&
"    Between '" + Parameters!DataRegistroDe.Value + "'  "&                              
"      And '" + Parameters!DataRegistroAte.Value + "'  "&                              
"  AND ( (UPPER(Trim(WSOR.REFERENCEDOCUMENT)) IN  "&
"( " + IIF(Trim(Parameters!Pedido.Value) = "", "''", "'" + Replace(Replace(UCASE(Parameters!Pedido.Value), " ", ""), ";", "','") + "'")  + " )  "&
"  AND (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 0))  " &
"  OR (" + IIF(Parameters!Pedido.Value Is Nothing, "1", "0") + " = 1) )  " 
)