 select 
     DISTINCT 
        WMSADMIN.PL_DB.DB_ALIAS                                            PLANTA, 
        RECEIPTDETAIL.EDITWHO                                              USUARIO,  
        subStr( tu.usr_name,4,  
              inStr(tu.usr_name, ',')-4 )                                  NOME_USUARIO, 
        Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE,  
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                AT time zone 'America/Sao_Paulo') AS DATE)) 		   DATA_RECEBIMENTO, 
        count(distinct SUBSTR(RECEIPTDETAIL.RECEIPTKEY,0,10))              NU_RECBTOS, 
        count(distinct RECEIPT.SUPPLIERCODE)                               NU_FORNECS, 
        count(distinct RECEIPTDETAIL.SKU)                                  NU_ITENS, 
        sum(RECEIPTDETAIL.QTYRECEIVED)                                     QTDE, 
        CASE WHEN SKU.SUSR8 = 'MINUCIOSO'  
             THEN 'SIM'   
           ELSE   'NÃO'   
        END                                                                IN_MINUCIOSO,  
        TIPO_PEDIDO.DSC_TIPO_PEDIDO                                        TP_NOTA 
 
 from WMWHSE8.RECEIPTDETAIL RECEIPTDETAIL 
 
 INNER JOIN WMSADMIN.PL_DB  PL_DB   
          ON UPPER(PL_DB.DB_LOGID) = RECEIPTDETAIL.WHSEID 
 
 LEFT JOIN WMWHSE8.taskmanageruser  tu 
        ON tu.userkey = RECEIPTDETAIL.EDITWHO 
          
 INNER JOIN WMWHSE8.RECEIPT  RECEIPT  
         ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY 
 
 LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO,   
                      NVL(trans.description,   
                          clkp.description)  DSC_TIPO_PEDIDO  
                 from WMWHSE8.codelkup clkp   
            left join WMWHSE8.translationlist trans   
                   on trans.code = clkp.code   
                  and trans.joinkey1 = clkp.listname   
                  and trans.locale   = 'pt'   
                  and trans.tblname  = 'CODELKUP'   
                where clkp.listname  = 'RECEIPTYPE'   
                  and Trim(clkp.code) is not null ) TIPO_PEDIDO   
          ON TIPO_PEDIDO.COD_TIPO_PEDIDO = RECEIPT.TYPE   
 
 INNER JOIN WMWHSE8.SKU  SKU  
         ON SKU.SKU = RECEIPTDETAIL.SKU   
      
 where Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE, 
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
              AT time zone 'America/Sao_Paulo') AS DATE)) 
        Between :DataRectoDe
            And :DataRectoAte
 
 GROUP BY WMSADMIN.PL_DB.DB_ALIAS, 
          RECEIPTDETAIL.EDITWHO, 
          subStr( tu.usr_name,4, 
                inStr(tu.usr_name, ',')-4 ), 
          Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                  AT time zone 'America/Sao_Paulo') AS DATE)), 
          CASE WHEN SKU.SUSR8 = 'MINUCIOSO' 
             THEN 'SIM' 
           ELSE   'NÃO' 
          END, 
          TIPO_PEDIDO.DSC_TIPO_PEDIDO 
 
 ORDER BY USUARIO, DATA_RECEBIMENTO  
		 
		 
=
" select " &
"     DISTINCT " &
"        WMSADMIN.PL_DB.DB_ALIAS                                            PLANTA, " &
"        RECEIPTDETAIL.EDITWHO                                              USUARIO, " & 
"        subStr( tu.usr_name,4, " & 
"              inStr(tu.usr_name, ',')-4 )                                  NOME_USUARIO, " &
"        Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE, " & 
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                AT time zone 'America/Sao_Paulo') AS DATE)) 				DATA_RECEBIMENTO, " &
"        count(distinct SUBSTR(RECEIPTDETAIL.RECEIPTKEY,0,10))              NU_RECBTOS, " &
"        count(distinct RECEIPT.SUPPLIERCODE)                               NU_FORNECS, " &
"        count(distinct RECEIPTDETAIL.SKU)                                  NU_ITENS, " &
"        sum(RECEIPTDETAIL.QTYRECEIVED)                                     QTDE, " &
"        CASE WHEN SKU.SUSR8 = 'MINUCIOSO' " & 
"             THEN 'SIM' " &  
"           ELSE   'NÃO' " &  
"        END                                                                IN_MINUCIOSO, " & 
"        TIPO_PEDIDO.DSC_TIPO_PEDIDO                                        TP_NOTA " &
" " &
" from " + Parameters!Table.Value + ".RECEIPTDETAIL RECEIPTDETAIL " &
" " &
" INNER JOIN WMSADMIN.PL_DB  PL_DB " &  
"          ON UPPER(PL_DB.DB_LOGID) = RECEIPTDETAIL.WHSEID " &
" " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser  tu " &
"        ON tu.userkey = RECEIPTDETAIL.EDITWHO " &
" " &         
" INNER JOIN " + Parameters!Table.Value + ".RECEIPT  RECEIPT " & 
"         ON RECEIPT.RECEIPTKEY = RECEIPTDETAIL.RECEIPTKEY " &
" " &
" LEFT JOIN ( select clkp.code              COD_TIPO_PEDIDO, " &  
"                      NVL(trans.description, " &  
"                          clkp.description)  DSC_TIPO_PEDIDO " & 
"                 from " + Parameters!Table.Value + ".codelkup clkp " &  
"            left join " + Parameters!Table.Value + ".translationlist trans " &  
"                   on trans.code = clkp.code " &  
"                  and trans.joinkey1 = clkp.listname " &  
"                  and trans.locale   = 'pt' " &  
"                  and trans.tblname  = 'CODELKUP' " &  
"                where clkp.listname  = 'RECEIPTYPE' " &  
"                  and Trim(clkp.code) is not null ) TIPO_PEDIDO " &  
"          ON TIPO_PEDIDO.COD_TIPO_PEDIDO = RECEIPT.TYPE " &  
" " &
" INNER JOIN " + Parameters!Table.Value + ".SKU  SKU " & 
"         ON SKU.SKU = RECEIPTDETAIL.SKU " &  
" " &     
" where Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE, " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"              AT time zone 'America/Sao_Paulo') AS DATE)) " &
"        Between '" + Parameters!DataRectoDe.Value + "' " &
"            And '" + Parameters!DataRectoAte.Value + "' " &
" " &
" GROUP BY WMSADMIN.PL_DB.DB_ALIAS, " &
"          RECEIPTDETAIL.EDITWHO, " &
"          subStr( tu.usr_name,4, " &
"                inStr(tu.usr_name, ',')-4 ), " &
"          Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(RECEIPT.RECEIPTDATE, " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                  AT time zone 'America/Sao_Paulo') AS DATE)), " &
"          CASE WHEN SKU.SUSR8 = 'MINUCIOSO' " &
"             THEN 'SIM' " &
"           ELSE   'NÃO' " &
"          END, " &
"          TIPO_PEDIDO.DSC_TIPO_PEDIDO " &
" " &
" ORDER BY USUARIO, DATA_RECEBIMENTO " 
