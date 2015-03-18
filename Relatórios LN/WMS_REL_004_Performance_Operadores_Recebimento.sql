SELECT
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS                           	PLANTA,
    TI.EDITWHO                                			USUARIO,
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',')-4 )               	NOME_USUARIO,
    count(distinct SUBSTR(TI.RECEIPTKEY,0,10)) 			NU_RECBTOS,
    count(distinct RECEIPT.SUPPLIERCODE)              	NU_FORNECS,
    count(distinct TI.SKU)   		                          	NU_ITENS,
    sum(TI.QTY)											QTDE,
    CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM' 
         ELSE 'NÃO' 
     END                                              	IN_MINUCIOSO,
    TIPO_PEDIDO.DSC_TIPO_PEDIDO                         TP_NOTA
	
FROM      WMWHSE5.ITRN TI

LEFT JOIN WMWHSE5.taskmanageruser tu 
       ON tu.userkey=TI.EDITWHO,
	
          WMSADMIN.PL_DB,
          WMWHSE5.RECEIPT
          
 LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO, 
                    NVL(trans.description, 
                        clkp.description)  DSC_TIPO_PEDIDO
               from WMWHSE5.codelkup clkp
          left join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
              where clkp.listname = 'RECEIPTYPE'
                and Trim(clkp.code) is not null ) TIPO_PEDIDO
        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = RECEIPT.TYPE,
		
          WMWHSE5.SKU
	 
WHERE TI.TRANTYPE 						=	'DP'
  AND TI.SOURCETYPE 					= 	'ntrReceiptDetailAdd'
  AND RECEIPT.RECEIPTKEY				=	TI.RECEIPTKEY
  AND UPPER(WMSADMIN.PL_DB.DB_LOGID)	= 	TI.WHSEID
  AND SKU.SKU							=	TI.SKU


  -- AND Trunc(RECEIPT.RECEIPTDATE) Between :DataRectoDe
  -- AND :DataRectoAte

GROUP BY TI.EDITWHO,
         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ), 
         TIPO_PEDIDO.DSC_TIPO_PEDIDO,
         WMSADMIN.PL_DB.DB_ALIAS,
         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM' 
              ELSE 'NÃO' 
          END
--ORDER BY USUARIO

"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS                           PLANTA,                      " &
"    TASKDETAIL.EDITWHO                                USUARIO,                     " &
"    subStr( tu.usr_name,4,                                                         " &
"            inStr(tu.usr_name, ',')-4 )               NOME_USUARIO,                " &
"    count(distinct SUBSTR(TASKDETAIL.SOURCEKEY,0,10)) NU_RECBTOS,                  " &
"    count(distinct RECEIPT.SUPPLIERCODE)              NU_FORNECS,                  " &
"    count(TASKDETAIL.SKU)                             NU_ITENS,                    " &
"    sum(TASKDETAIL.UOMQTY)                            QTDE,                        " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                   " &
"         ELSE 'NÃO'                                                                " &
"     END                                              IN_MINUCIOSO,                " &
"    CODELKUP.LONG_VALUE                               TP_NOTA                      " &
"	                                                                                " &
"FROM      " + Parameters!Table.Value + ".TASKDETAIL                                " &
"                                                                                   " &
"LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu                        " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                           " &
"	                                                                                " &
"          WMSADMIN.PL_DB,                                                          " &
"          " + Parameters!Table.Value + ".RECEIPT,                                  " &
"          " + Parameters!Table.Value + ".CODELKUP,                                 " &
"          " + Parameters!Table.Value + ".SKU                                       " &
"	                                                                                " &
"WHERE TASKDETAIL.STATUS = '9'                                                      " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                   " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) = RECEIPT.RECEIPTKEY                       " &
"  AND RECEIPT.TYPE = CODELKUP.CODE                                                 " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                             " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                           " &
"  AND SKU.SKU=TASKDETAIL.SKU                                                       " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                      " &
"                                                                                   " &
"GROUP BY TASKDETAIL.STATUS, TASKDETAIL.EDITWHO,                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         CODELKUP.LONG_VALUE,                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"ORDER BY USUARIO                                                                   "

-- Query com UNION ********************************************************************

"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS                           PLANTA,                      " &
"    TASKDETAIL.EDITWHO                                USUARIO,                     " &
"    subStr( tu.usr_name,4,                                                         " &
"            inStr(tu.usr_name, ',')-4 )               NOME_USUARIO,                " &
"    count(distinct SUBSTR(TASKDETAIL.SOURCEKEY,0,10)) NU_RECBTOS,                  " &
"    count(distinct RECEIPT.SUPPLIERCODE)              NU_FORNECS,                  " &
"    count(TASKDETAIL.SKU)                             NU_ITENS,                    " &
"    sum(TASKDETAIL.UOMQTY)                            QTDE,                        " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                   " &
"         ELSE 'NÃO'                                                                " &
"     END                                              IN_MINUCIOSO,                " &
"    CODELKUP.LONG_VALUE                               TP_NOTA                      " &
"	                                                                                " &
"FROM      WMWHSE5.TASKDETAIL                                                       " &
"                                                                                   " &
"LEFT JOIN WMWHSE5.taskmanageruser tu                                               " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                           " &
"	                                                                                " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE5.RECEIPT,                                                         " &
"          WMWHSE5.CODELKUP,                                                        " &
"          WMWHSE5.SKU                                                              " &
"	                                                                                " &
"WHERE TASKDETAIL.STATUS = '9'                                                      " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                   " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) = RECEIPT.RECEIPTKEY                       " &
"  AND RECEIPT.TYPE = CODELKUP.CODE                                                 " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                             " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                           " &
"  AND SKU.SKU=TASKDETAIL.SKU                                                       " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                      " &
"                                                                                   " &
"GROUP BY TASKDETAIL.STATUS, TASKDETAIL.EDITWHO,                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         CODELKUP.LONG_VALUE,                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS                           PLANTA,                      " &
"    TASKDETAIL.EDITWHO                                USUARIO,                     " &
"    subStr( tu.usr_name,4,                                                         " &
"            inStr(tu.usr_name, ',')-4 )               NOME_USUARIO,                " &
"    count(distinct SUBSTR(TASKDETAIL.SOURCEKEY,0,10)) NU_RECBTOS,                  " &
"    count(distinct RECEIPT.SUPPLIERCODE)              NU_FORNECS,                  " &
"    count(TASKDETAIL.SKU)                             NU_ITENS,                    " &
"    sum(TASKDETAIL.UOMQTY)                            QTDE,                        " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                   " &
"         ELSE 'NÃO'                                                                " &
"     END                                              IN_MINUCIOSO,                " &
"    CODELKUP.LONG_VALUE                               TP_NOTA                      " &
"	                                                                                " &
"FROM      WMWHSE2.TASKDETAIL                                                       " &
"                                                                                   " &
"LEFT JOIN WMWHSE2.taskmanageruser tu                                               " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                           " &
"	                                                                                " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE2.RECEIPT,                                                         " &
"          WMWHSE2.CODELKUP,                                                        " &
"          WMWHSE2.SKU                                                              " &
"	                                                                                " &
"WHERE TASKDETAIL.STATUS = '9'                                                      " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                   " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) = RECEIPT.RECEIPTKEY                       " &
"  AND RECEIPT.TYPE = CODELKUP.CODE                                                 " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                             " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                           " &
"  AND SKU.SKU=TASKDETAIL.SKU                                                       " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                      " &
"                                                                                   " &
"GROUP BY TASKDETAIL.STATUS, TASKDETAIL.EDITWHO,                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         CODELKUP.LONG_VALUE,                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS                           PLANTA,                      " &
"    TASKDETAIL.EDITWHO                                USUARIO,                     " &
"    subStr( tu.usr_name,4,                                                         " &
"            inStr(tu.usr_name, ',')-4 )               NOME_USUARIO,                " &
"    count(distinct SUBSTR(TASKDETAIL.SOURCEKEY,0,10)) NU_RECBTOS,                  " &
"    count(distinct RECEIPT.SUPPLIERCODE)              NU_FORNECS,                  " &
"    count(TASKDETAIL.SKU)                             NU_ITENS,                    " &
"    sum(TASKDETAIL.UOMQTY)                            QTDE,                        " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                   " &
"         ELSE 'NÃO'                                                                " &
"     END                                              IN_MINUCIOSO,                " &
"    CODELKUP.LONG_VALUE                               TP_NOTA                      " &
"	                                                                                " &
"FROM      WMWHSE3.TASKDETAIL                                                       " &
"                                                                                   " &
"LEFT JOIN WMWHSE3.taskmanageruser tu                                               " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                           " &
"	                                                                                " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE3.RECEIPT,                                                         " &
"          WMWHSE3.CODELKUP,                                                        " &
"          WMWHSE3.SKU                                                              " &
"	                                                                                " &
"WHERE TASKDETAIL.STATUS = '9'                                                      " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                   " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) = RECEIPT.RECEIPTKEY                       " &
"  AND RECEIPT.TYPE = CODELKUP.CODE                                                 " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                             " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                           " &
"  AND SKU.SKU=TASKDETAIL.SKU                                                       " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                      " &
"                                                                                   " &
"GROUP BY TASKDETAIL.STATUS, TASKDETAIL.EDITWHO,                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         CODELKUP.LONG_VALUE,                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS                           PLANTA,                      " &
"    TASKDETAIL.EDITWHO                                USUARIO,                     " &
"    subStr( tu.usr_name,4,                                                         " &
"            inStr(tu.usr_name, ',')-4 )               NOME_USUARIO,                " &
"    count(distinct SUBSTR(TASKDETAIL.SOURCEKEY,0,10)) NU_RECBTOS,                  " &
"    count(distinct RECEIPT.SUPPLIERCODE)              NU_FORNECS,                  " &
"    count(TASKDETAIL.SKU)                             NU_ITENS,                    " &
"    sum(TASKDETAIL.UOMQTY)                            QTDE,                        " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                   " &
"         ELSE 'NÃO'                                                                " &
"     END                                              IN_MINUCIOSO,                " &
"    CODELKUP.LONG_VALUE                               TP_NOTA                      " &
"	                                                                                " &
"FROM      WMWHSE4.TASKDETAIL                                                       " &
"                                                                                   " &
"LEFT JOIN WMWHSE4.taskmanageruser tu                                               " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                           " &
"	                                                                                " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE4.RECEIPT,                                                         " &
"          WMWHSE4.CODELKUP,                                                        " &
"          WMWHSE4.SKU                                                              " &
"	                                                                                " &
"WHERE TASKDETAIL.STATUS = '9'                                                      " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                   " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) = RECEIPT.RECEIPTKEY                       " &
"  AND RECEIPT.TYPE = CODELKUP.CODE                                                 " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                             " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                           " &
"  AND SKU.SKU=TASKDETAIL.SKU                                                       " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                      " &
"                                                                                   " &
"GROUP BY TASKDETAIL.STATUS, TASKDETAIL.EDITWHO,                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         CODELKUP.LONG_VALUE,                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS                           PLANTA,                      " &
"    TASKDETAIL.EDITWHO                                USUARIO,                     " &
"    subStr( tu.usr_name,4,                                                         " &
"            inStr(tu.usr_name, ',')-4 )               NOME_USUARIO,                " &
"    count(distinct SUBSTR(TASKDETAIL.SOURCEKEY,0,10)) NU_RECBTOS,                  " &
"    count(distinct RECEIPT.SUPPLIERCODE)              NU_FORNECS,                  " &
"    count(TASKDETAIL.SKU)                             NU_ITENS,                    " &
"    sum(TASKDETAIL.UOMQTY)                            QTDE,                        " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                   " &
"         ELSE 'NÃO'                                                                " &
"     END                                              IN_MINUCIOSO,                " &
"    CODELKUP.LONG_VALUE                               TP_NOTA                      " &
"	                                                                                " &
"FROM      WMWHSE5.TASKDETAIL                                                       " &
"                                                                                   " &
"LEFT JOIN WMWHSE5.taskmanageruser tu                                               " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                           " &
"	                                                                                " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE5.RECEIPT,                                                         " &
"          WMWHSE5.CODELKUP,                                                        " &
"          WMWHSE5.SKU                                                              " &
"	                                                                                " &
"WHERE TASKDETAIL.STATUS = '9'                                                      " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                   " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) = RECEIPT.RECEIPTKEY                       " &
"  AND RECEIPT.TYPE = CODELKUP.CODE                                                 " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                             " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                           " &
"  AND SKU.SKU=TASKDETAIL.SKU                                                       " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                      " &
"                                                                                   " &
"GROUP BY TASKDETAIL.STATUS, TASKDETAIL.EDITWHO,                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         CODELKUP.LONG_VALUE,                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS                           PLANTA,                      " &
"    TASKDETAIL.EDITWHO                                USUARIO,                     " &
"    subStr( tu.usr_name,4,                                                         " &
"            inStr(tu.usr_name, ',')-4 )               NOME_USUARIO,                " &
"    count(distinct SUBSTR(TASKDETAIL.SOURCEKEY,0,10)) NU_RECBTOS,                  " &
"    count(distinct RECEIPT.SUPPLIERCODE)              NU_FORNECS,                  " &
"    count(TASKDETAIL.SKU)                             NU_ITENS,                    " &
"    sum(TASKDETAIL.UOMQTY)                            QTDE,                        " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                   " &
"         ELSE 'NÃO'                                                                " &
"     END                                              IN_MINUCIOSO,                " &
"    CODELKUP.LONG_VALUE                               TP_NOTA                      " &
"	                                                                                " &
"FROM      WMWHSE6.TASKDETAIL                                                       " &
"                                                                                   " &
"LEFT JOIN WMWHSE6.taskmanageruser tu                                               " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                           " &
"	                                                                                " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE6.RECEIPT,                                                         " &
"          WMWHSE6.CODELKUP,                                                        " &
"          WMWHSE6.SKU                                                              " &
"	                                                                                " &
"WHERE TASKDETAIL.STATUS = '9'                                                      " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                   " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) = RECEIPT.RECEIPTKEY                       " &
"  AND RECEIPT.TYPE = CODELKUP.CODE                                                 " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                             " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                           " &
"  AND SKU.SKU=TASKDETAIL.SKU                                                       " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                      " &
"                                                                                   " &
"GROUP BY TASKDETAIL.STATUS, TASKDETAIL.EDITWHO,                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         CODELKUP.LONG_VALUE,                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    WMSADMIN.PL_DB.DB_ALIAS                           PLANTA,                      " &
"    TASKDETAIL.EDITWHO                                USUARIO,                     " &
"    subStr( tu.usr_name,4,                                                         " &
"            inStr(tu.usr_name, ',')-4 )               NOME_USUARIO,                " &
"    count(distinct SUBSTR(TASKDETAIL.SOURCEKEY,0,10)) NU_RECBTOS,                  " &
"    count(distinct RECEIPT.SUPPLIERCODE)              NU_FORNECS,                  " &
"    count(TASKDETAIL.SKU)                             NU_ITENS,                    " &
"    sum(TASKDETAIL.UOMQTY)                            QTDE,                        " &
"    CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                   " &
"         ELSE 'NÃO'                                                                " &
"     END                                              IN_MINUCIOSO,                " &
"    CODELKUP.LONG_VALUE                               TP_NOTA                      " &
"	                                                                                " &
"FROM      WMWHSE7.TASKDETAIL                                                       " &
"                                                                                   " &
"LEFT JOIN WMWHSE7.taskmanageruser tu                                               " &
"       ON tu.userkey=TASKDETAIL.EDITWHO,                                           " &
"	                                                                                " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE7.RECEIPT,                                                         " &
"          WMWHSE7.CODELKUP,                                                        " &
"          WMWHSE7.SKU                                                              " &
"	                                                                                " &
"WHERE TASKDETAIL.STATUS = '9'                                                      " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                                                   " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) = RECEIPT.RECEIPTKEY                       " &
"  AND RECEIPT.TYPE = CODELKUP.CODE                                                 " &
"  AND CODELKUP.LISTNAME = 'RECEIPTYPE'                                             " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TASKDETAIL.WHSEID                           " &
"  AND SKU.SKU=TASKDETAIL.SKU                                                       " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"  AND '" + Parameters!DataRectoAte.Value + "'                                      " &
"                                                                                   " &
"GROUP BY TASKDETAIL.STATUS, TASKDETAIL.EDITWHO,                                    " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         CODELKUP.LONG_VALUE,                                                      " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"                                                                                   " &
"ORDER BY PLANTA, USUARIO                                                           "
