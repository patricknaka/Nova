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

=IIF(Parameters!Table.Value <> "AAA",

"SELECT DISTINCT                                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS                       PLANTA,                            " &
"  TI.EDITWHO                                    USUARIO,                           " &
"  subStr( tu.usr_name,4,                                                           " &
"          inStr(tu.usr_name, ',')-4 )           NOME_USUARIO,                      " &
"  count(distinct SUBSTR(TI.RECEIPTKEY,0,10))    NU_RECBTOS,                        " &
"  count(distinct RECEIPT.SUPPLIERCODE)          NU_FORNECS,                        " &
"  count(distinct TI.SKU)                        NU_ITENS,                          " &
"  sum(TI.QTY)           QTDE,                                                      " &
"  CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                     " &
"    ELSE 'NÃO'                                                                     " &
"  END                                           IN_MINUCIOSO,                      " &
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO                   TP_NOTA                            " &
"                                                                                   " &
"FROM      " + Parameters!Table.Value + ".ITRN TI                                   " &
"                                                                                   " &
"LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu                        " &
"       ON tu.userkey=TI.EDITWHO,                                                   " &
"                                                                                   " &
"          WMSADMIN.PL_DB,                                                          " &
"          " + Parameters!Table.Value + ".RECEIPT                                   " &
"                                                                                   " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,                        " &
"                    NVL(trans.description,                                         " &
"                        clkp.description)  DSC_TIPO_PEDIDO                         " &
"               from " + Parameters!Table.Value + ".codelkup clkp                   " &
"          left join " + Parameters!Table.Value + ".translationlist trans           " &
"                 on trans.code = clkp.code                                         " &
"                and trans.joinkey1 = clkp.listname                                 " &
"                and trans.locale = 'pt'                                            " &
"                and trans.tblname = 'CODELKUP'                                     " &
"              where clkp.listname = 'RECEIPTYPE'                                   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO                      " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = RECEIPT.TYPE,                             " &
"                                                                                   " &
"           " + Parameters!Table.Value + ".SKU                                      " &
"                                                                                   " &
"WHERE TI.TRANTYPE = 'DP'                                                           " &
"  AND TI.SOURCETYPE =  'ntrReceiptDetailAdd'                                       " &
"  AND RECEIPT.RECEIPTKEY = TI.RECEIPTKEY                                           " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TI.WHSEID                                   " &
"  AND SKU.SKU = TI.SKU                                                             " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &  
"                                 AND '" + Parameters!DataRectoAte.Value + "'       " &
"GROUP BY TI.EDITWHO,                                                               " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         TIPO_PEDIDO.DSC_TIPO_PEDIDO,                                              " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"ORDER BY USUARIO                                                                   "
                                                                                     
,                                                                                   
                                                                                    
"SELECT DISTINCT                                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS                       PLANTA,                            " &
"  TI.EDITWHO                                    USUARIO,                           " &
"  subStr( tu.usr_name,4,                                                           " &
"          inStr(tu.usr_name, ',')-4 )           NOME_USUARIO,                      " &
"  count(distinct SUBSTR(TI.RECEIPTKEY,0,10))    NU_RECBTOS,                        " &
"  count(distinct RECEIPT.SUPPLIERCODE)          NU_FORNECS,                        " &
"  count(distinct TI.SKU)                        NU_ITENS,                          " &
"  sum(TI.QTY)           QTDE,                                                      " &
"  CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                     " &
"    ELSE 'NÃO'                                                                     " &
"  END                                           IN_MINUCIOSO,                      " &
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO                   TP_NOTA                            " &
"                                                                                   " &
"FROM      WMWHSE1.ITRN TI                                                          " &
"                                                                                   " &
"LEFT JOIN WMWHSE1.taskmanageruser tu                                               " &
"       ON tu.userkey=TI.EDITWHO,                                                   " &
"                                                                                   " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE1.RECEIPT                                                          " &
"                                                                                   " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,                        " &
"                    NVL(trans.description,                                         " &
"                        clkp.description)  DSC_TIPO_PEDIDO                         " &
"               from WMWHSE1.codelkup clkp                                          " &
"          left join WMWHSE1.translationlist trans                                  " &
"                 on trans.code = clkp.code                                         " &
"                and trans.joinkey1 = clkp.listname                                 " &
"                and trans.locale = 'pt'                                            " &
"                and trans.tblname = 'CODELKUP'                                     " &
"              where clkp.listname = 'RECEIPTYPE'                                   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO                      " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = RECEIPT.TYPE,                             " &
"                                                                                   " &
"           WMWHSE1.SKU                                                             " &
"                                                                                   " &
"WHERE TI.TRANTYPE = 'DP'                                                           " &
"  AND TI.SOURCETYPE =  'ntrReceiptDetailAdd'                                       " &
"  AND RECEIPT.RECEIPTKEY = TI.RECEIPTKEY                                           " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TI.WHSEID                                   " &
"  AND SKU.SKU = TI.SKU                                                             " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"                                 AND '" + Parameters!DataRectoAte.Value + "'       " &
"GROUP BY TI.EDITWHO,                                                               " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         TIPO_PEDIDO.DSC_TIPO_PEDIDO,                                              " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"		                                                                            " &
"UNION                                                                              " &
"                                                                                   " &
"SELECT DISTINCT                                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS                       PLANTA,                            " &
"  TI.EDITWHO                                    USUARIO,                           " &
"  subStr( tu.usr_name,4,                                                           " &
"          inStr(tu.usr_name, ',')-4 )           NOME_USUARIO,                      " &
"  count(distinct SUBSTR(TI.RECEIPTKEY,0,10))    NU_RECBTOS,                        " &
"  count(distinct RECEIPT.SUPPLIERCODE)          NU_FORNECS,                        " &
"  count(distinct TI.SKU)                        NU_ITENS,                          " &
"  sum(TI.QTY)           QTDE,                                                      " &
"  CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                     " &
"    ELSE 'NÃO'                                                                     " &
"  END                                           IN_MINUCIOSO,                      " &
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO                   TP_NOTA                            " &
"                                                                                   " &
"FROM      WMWHSE2.ITRN TI                                                          " &
"                                                                                   " &
"LEFT JOIN WMWHSE2.taskmanageruser tu                                               " &
"       ON tu.userkey=TI.EDITWHO,                                                   " &
"                                                                                   " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE2.RECEIPT                                                          " &
"                                                                                   " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,                        " &
"                    NVL(trans.description,                                         " &
"                        clkp.description)  DSC_TIPO_PEDIDO                         " &
"               from WMWHSE2.codelkup clkp                                          " &
"          left join WMWHSE2.translationlist trans                                  " &
"                 on trans.code = clkp.code                                         " &
"                and trans.joinkey1 = clkp.listname                                 " &
"                and trans.locale = 'pt'                                            " &
"                and trans.tblname = 'CODELKUP'                                     " &
"              where clkp.listname = 'RECEIPTYPE'                                   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO                      " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = RECEIPT.TYPE,                             " &
"                                                                                   " &
"           WMWHSE2.SKU                                                             " &
"                                                                                   " &
"WHERE TI.TRANTYPE = 'DP'                                                           " &
"  AND TI.SOURCETYPE =  'ntrReceiptDetailAdd'                                       " &
"  AND RECEIPT.RECEIPTKEY = TI.RECEIPTKEY                                           " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TI.WHSEID                                   " &
"  AND SKU.SKU = TI.SKU                                                             " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"                                 AND '" + Parameters!DataRectoAte.Value + "'       " &
"GROUP BY TI.EDITWHO,                                                               " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         TIPO_PEDIDO.DSC_TIPO_PEDIDO,                                              " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"		                                                                            " &
"UNION                                                                              " &
"                                                                                   " &
"SELECT DISTINCT                                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS                       PLANTA,                            " &
"  TI.EDITWHO                                    USUARIO,                           " &
"  subStr( tu.usr_name,4,                                                           " &
"          inStr(tu.usr_name, ',')-4 )           NOME_USUARIO,                      " &
"  count(distinct SUBSTR(TI.RECEIPTKEY,0,10))    NU_RECBTOS,                        " &
"  count(distinct RECEIPT.SUPPLIERCODE)          NU_FORNECS,                        " &
"  count(distinct TI.SKU)                        NU_ITENS,                          " &
"  sum(TI.QTY)           QTDE,                                                      " &
"  CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                     " &
"    ELSE 'NÃO'                                                                     " &
"  END                                           IN_MINUCIOSO,                      " &
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO                   TP_NOTA                            " &
"                                                                                   " &
"FROM      WMWHSE3.ITRN TI                                                          " &
"                                                                                   " &
"LEFT JOIN WMWHSE3.taskmanageruser tu                                               " &
"       ON tu.userkey=TI.EDITWHO,                                                   " &
"                                                                                   " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE3.RECEIPT                                                          " &
"                                                                                   " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,                        " &
"                    NVL(trans.description,                                         " &
"                        clkp.description)  DSC_TIPO_PEDIDO                         " &
"               from WMWHSE3.codelkup clkp                                          " &
"          left join WMWHSE3.translationlist trans                                  " &
"                 on trans.code = clkp.code                                         " &
"                and trans.joinkey1 = clkp.listname                                 " &
"                and trans.locale = 'pt'                                            " &
"                and trans.tblname = 'CODELKUP'                                     " &
"              where clkp.listname = 'RECEIPTYPE'                                   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO                      " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = RECEIPT.TYPE,                             " &
"                                                                                   " &
"           WMWHSE3.SKU                                                             " &
"                                                                                   " &
"WHERE TI.TRANTYPE = 'DP'                                                           " &
"  AND TI.SOURCETYPE =  'ntrReceiptDetailAdd'                                       " &
"  AND RECEIPT.RECEIPTKEY = TI.RECEIPTKEY                                           " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TI.WHSEID                                   " &
"  AND SKU.SKU = TI.SKU                                                             " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"                                 AND '" + Parameters!DataRectoAte.Value + "'       " &
"GROUP BY TI.EDITWHO,                                                               " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         TIPO_PEDIDO.DSC_TIPO_PEDIDO,                                              " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"		                                                                            " &
"UNION                                                                              " &
"                                                                                   " &
"SELECT DISTINCT                                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS                       PLANTA,                            " &
"  TI.EDITWHO                                    USUARIO,                           " &
"  subStr( tu.usr_name,4,                                                           " &
"          inStr(tu.usr_name, ',')-4 )           NOME_USUARIO,                      " &
"  count(distinct SUBSTR(TI.RECEIPTKEY,0,10))    NU_RECBTOS,                        " &
"  count(distinct RECEIPT.SUPPLIERCODE)          NU_FORNECS,                        " &
"  count(distinct TI.SKU)                        NU_ITENS,                          " &
"  sum(TI.QTY)           QTDE,                                                      " &
"  CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                     " &
"    ELSE 'NÃO'                                                                     " &
"  END                                           IN_MINUCIOSO,                      " &
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO                   TP_NOTA                            " &
"                                                                                   " &
"FROM      WMWHSE4.ITRN TI                                                          " &
"                                                                                   " &
"LEFT JOIN WMWHSE4.taskmanageruser tu                                               " &
"       ON tu.userkey=TI.EDITWHO,                                                   " &
"                                                                                   " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE4.RECEIPT                                                          " &
"                                                                                   " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,                        " &
"                    NVL(trans.description,                                         " &
"                        clkp.description)  DSC_TIPO_PEDIDO                         " &
"               from WMWHSE4.codelkup clkp                                          " &
"          left join WMWHSE4.translationlist trans                                  " &
"                 on trans.code = clkp.code                                         " &
"                and trans.joinkey1 = clkp.listname                                 " &
"                and trans.locale = 'pt'                                            " &
"                and trans.tblname = 'CODELKUP'                                     " &
"              where clkp.listname = 'RECEIPTYPE'                                   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO                      " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = RECEIPT.TYPE,                             " &
"                                                                                   " &
"           WMWHSE4.SKU                                                             " &
"                                                                                   " &
"WHERE TI.TRANTYPE = 'DP'                                                           " &
"  AND TI.SOURCETYPE =  'ntrReceiptDetailAdd'                                       " &
"  AND RECEIPT.RECEIPTKEY = TI.RECEIPTKEY                                           " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TI.WHSEID                                   " &
"  AND SKU.SKU = TI.SKU                                                             " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"                                 AND '" + Parameters!DataRectoAte.Value + "'       " &
"GROUP BY TI.EDITWHO,                                                               " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         TIPO_PEDIDO.DSC_TIPO_PEDIDO,                                              " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"		                                                                            " &
"UNION                                                                              " &
"                                                                                   " &
"SELECT DISTINCT                                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS                       PLANTA,                            " &
"  TI.EDITWHO                                    USUARIO,                           " &
"  subStr( tu.usr_name,4,                                                           " &
"          inStr(tu.usr_name, ',')-4 )           NOME_USUARIO,                      " &
"  count(distinct SUBSTR(TI.RECEIPTKEY,0,10))    NU_RECBTOS,                        " &
"  count(distinct RECEIPT.SUPPLIERCODE)          NU_FORNECS,                        " &
"  count(distinct TI.SKU)                        NU_ITENS,                          " &
"  sum(TI.QTY)           QTDE,                                                      " &
"  CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                     " &
"    ELSE 'NÃO'                                                                     " &
"  END                                           IN_MINUCIOSO,                      " &
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO                   TP_NOTA                            " &
"                                                                                   " &
"FROM      WMWHSE5.ITRN TI                                                          " &
"                                                                                   " &
"LEFT JOIN WMWHSE5.taskmanageruser tu                                               " &
"       ON tu.userkey=TI.EDITWHO,                                                   " &
"                                                                                   " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE5.RECEIPT                                                          " &
"                                                                                   " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,                        " &
"                    NVL(trans.description,                                         " &
"                        clkp.description)  DSC_TIPO_PEDIDO                         " &
"               from WMWHSE5.codelkup clkp                                          " &
"          left join WMWHSE5.translationlist trans                                  " &
"                 on trans.code = clkp.code                                         " &
"                and trans.joinkey1 = clkp.listname                                 " &
"                and trans.locale = 'pt'                                            " &
"                and trans.tblname = 'CODELKUP'                                     " &
"              where clkp.listname = 'RECEIPTYPE'                                   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO                      " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = RECEIPT.TYPE,                             " &
"                                                                                   " &
"           WMWHSE5.SKU                                                             " &
"                                                                                   " &
"WHERE TI.TRANTYPE = 'DP'                                                           " &
"  AND TI.SOURCETYPE =  'ntrReceiptDetailAdd'                                       " &
"  AND RECEIPT.RECEIPTKEY = TI.RECEIPTKEY                                           " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TI.WHSEID                                   " &
"  AND SKU.SKU = TI.SKU                                                             " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"                                 AND '" + Parameters!DataRectoAte.Value + "'       " &
"GROUP BY TI.EDITWHO,                                                               " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         TIPO_PEDIDO.DSC_TIPO_PEDIDO,                                              " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"		                                                                            " &
"UNION                                                                              " &
"                                                                                   " &
"SELECT DISTINCT                                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS                       PLANTA,                            " &
"  TI.EDITWHO                                    USUARIO,                           " &
"  subStr( tu.usr_name,4,                                                           " &
"          inStr(tu.usr_name, ',')-4 )           NOME_USUARIO,                      " &
"  count(distinct SUBSTR(TI.RECEIPTKEY,0,10))    NU_RECBTOS,                        " &
"  count(distinct RECEIPT.SUPPLIERCODE)          NU_FORNECS,                        " &
"  count(distinct TI.SKU)                        NU_ITENS,                          " &
"  sum(TI.QTY)           QTDE,                                                      " &
"  CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                     " &
"    ELSE 'NÃO'                                                                     " &
"  END                                           IN_MINUCIOSO,                      " &
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO                   TP_NOTA                            " &
"                                                                                   " &
"FROM      WMWHSE6.ITRN TI                                                          " &
"                                                                                   " &
"LEFT JOIN WMWHSE6.taskmanageruser tu                                               " &
"       ON tu.userkey=TI.EDITWHO,                                                   " &
"                                                                                   " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE6.RECEIPT                                                          " &
"                                                                                   " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,                        " &
"                    NVL(trans.description,                                         " &
"                        clkp.description)  DSC_TIPO_PEDIDO                         " &
"               from WMWHSE6.codelkup clkp                                          " &
"          left join WMWHSE6.translationlist trans                                  " &
"                 on trans.code = clkp.code                                         " &
"                and trans.joinkey1 = clkp.listname                                 " &
"                and trans.locale = 'pt'                                            " &
"                and trans.tblname = 'CODELKUP'                                     " &
"              where clkp.listname = 'RECEIPTYPE'                                   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO                      " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = RECEIPT.TYPE,                             " &
"                                                                                   " &
"           WMWHSE6.SKU                                                             " &
"                                                                                   " &
"WHERE TI.TRANTYPE = 'DP'                                                           " &
"  AND TI.SOURCETYPE =  'ntrReceiptDetailAdd'                                       " &
"  AND RECEIPT.RECEIPTKEY = TI.RECEIPTKEY                                           " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TI.WHSEID                                   " &
"  AND SKU.SKU = TI.SKU                                                             " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"                                 AND '" + Parameters!DataRectoAte.Value + "'       " &
"GROUP BY TI.EDITWHO,                                                               " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         TIPO_PEDIDO.DSC_TIPO_PEDIDO,                                              " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"		                                                                            " &
"UNION                                                                              " &
"                                                                                   " &
"SELECT DISTINCT                                                                    " &
"  WMSADMIN.PL_DB.DB_ALIAS                       PLANTA,                            " &
"  TI.EDITWHO                                    USUARIO,                           " &
"  subStr( tu.usr_name,4,                                                           " &
"          inStr(tu.usr_name, ',')-4 )           NOME_USUARIO,                      " &
"  count(distinct SUBSTR(TI.RECEIPTKEY,0,10))    NU_RECBTOS,                        " &
"  count(distinct RECEIPT.SUPPLIERCODE)          NU_FORNECS,                        " &
"  count(distinct TI.SKU)                        NU_ITENS,                          " &
"  sum(TI.QTY)           QTDE,                                                      " &
"  CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                                     " &
"    ELSE 'NÃO'                                                                     " &
"  END                                           IN_MINUCIOSO,                      " &
"  TIPO_PEDIDO.DSC_TIPO_PEDIDO                   TP_NOTA                            " &
"                                                                                   " &
"FROM      WMWHSE7.ITRN TI                                                          " &
"                                                                                   " &
"LEFT JOIN WMWHSE7.taskmanageruser tu                                               " &
"       ON tu.userkey=TI.EDITWHO,                                                   " &
"                                                                                   " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE7.RECEIPT                                                          " &
"                                                                                   " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,                        " &
"                    NVL(trans.description,                                         " &
"                        clkp.description)  DSC_TIPO_PEDIDO                         " &
"               from WMWHSE7.codelkup clkp                                          " &
"          left join WMWHSE7.translationlist trans                                  " &
"                 on trans.code = clkp.code                                         " &
"                and trans.joinkey1 = clkp.listname                                 " &
"                and trans.locale = 'pt'                                            " &
"                and trans.tblname = 'CODELKUP'                                     " &
"              where clkp.listname = 'RECEIPTYPE'                                   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO                      " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = RECEIPT.TYPE,                             " &
"                                                                                   " &
"           WMWHSE7.SKU                                                             " &
"                                                                                   " &
"WHERE TI.TRANTYPE = 'DP'                                                           " &
"  AND TI.SOURCETYPE =  'ntrReceiptDetailAdd'                                       " &
"  AND RECEIPT.RECEIPTKEY = TI.RECEIPTKEY                                           " &
"  AND UPPER(WMSADMIN.PL_DB.DB_LOGID) = TI.WHSEID                                   " &
"  AND SKU.SKU = TI.SKU                                                             " &
"  AND Trunc(RECEIPT.RECEIPTDATE) Between '" + Parameters!DataRectoDe.Value + "'    " &
"                                 AND '" + Parameters!DataRectoAte.Value + "'       " &
"GROUP BY TI.EDITWHO,                                                               " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         TIPO_PEDIDO.DSC_TIPO_PEDIDO,                                              " &
"         WMSADMIN.PL_DB.DB_ALIAS,                                                  " &
"         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' THEN 'SIM'                              " &
"              ELSE 'NÃO'                                                           " &
"          END                                                                      " &
"ORDER BY USUARIO                                                                   " 
)