SELECT  
    ORDERS.WHSEID                                        				ID_PLANTA,
    cl.UDF2                                       				      	DSC_PLANTA,
    ORDERS.ORDERKEY                                      				PEDIDO,
    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE))           				DATA,
    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE), 'HH24')    				HORA,
    CAGE.ADDWHO                            								ID_USUARIO,
    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   				NOME_USUARIO,
    sum(ORDERDETAIL.ORIGINALQTY)                          				QUANT,			-- Quantidade
    ORDERS.CARRIERCODE                                   				ID_TRANSP,
    ORDERS.CARRIERNAME                                   				TRANSP_NOME,
    ORDERS.DISCHARGEPLACE                                				ID_CONTRATO,
    CASE WHEN max(TO_CHAR(SKU.SUSR2)) = '2' 
           THEN 'PESADO' 
         ELSE   'LEVE' 
     END                                                 				TP_TRANSP_ITEM ,
	max(WAVEDETAIL.WAVEKEY)												ONDA,
	ORDERS.INVOICENUMBER												NF,
	ORDERS.LANE															SERIE,
	TRUNC(CAGE.ADDDATE)													INCL_GAIOLA,
--	CAGE.CLOSEDATE														FECHA_GAIOLA,	-- Campo retirado pois o campo DATA já é a data de fechamento da gaiola
	CAGE.CAGEID															CARGA,			-- Mesmo que gaiola		
	max(CAGE.QT_VOL)													NFCA_QT_VOLUMES,	-- Volumes na gaiola
	SUM(NVL(CISLI940.T$AMNT$L, TDSLS400.T$OAMT))						VALOR													

FROM      			WMWHSE5.ORDERS
		INNER JOIN	WMWHSE5.ORDERDETAIL			ON 	ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY
		INNER JOIN	ENTERPRISE.CODELKUP	CL 		ON	UPPER(CL.UDF1) = ORDERS.WHSEID
		INNER JOIN	WMWHSE5.SKU					ON	SKU.SKU = ORDERDETAIL.SKU
		-- INNER JOIN	WMWHSE5.ORDERSTATUSHISTORY	ON 	ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY
		                                        -- AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' ' 
		                                        -- AND ORDERSTATUSHISTORY.STATUS = 95
		INNER JOIN (select 	cg.cageid,
							cd.orderid,
							cg.closedate,
							cg.addwho,
							max(cd.adddate) adddate,
							count(cd.volumeid) qt_vol
					from	wmwhse5.cageid cg
					inner join wmwhse5.cageiddetail cd on cd.cageid = cg.cageid
          where cg.status in (3,4,5,6) 
					group by	cg.cageid,
					            cd.orderid,
					            cg.closedate,
								cg.addwho) CAGE	ON CAGE.ORDERID = ORDERS.ORDERKEY
							
		LEFT JOIN	BAANDB.TCISLI940301@PLN01 CISLI940 	ON	CISLI940.T$DOCN$L	=	ORDERS.INVOICENUMBER
														AND	CISLI940.T$SERI$L	=	ORDERS.LANE
		LEFT JOIN	BAANDB.TTDSLS400301@PLN01 TDSLS400	ON	TDSLS400.T$ORNO		=	ORDERS.REFERENCEDOCUMENT
								
		LEFT JOIN 	WMWHSE5.taskmanageruser tu 	ON 	tu.userkey = CAGE.ADDWHO
		LEFT JOIN	WMWHSE5.WAVEDETAIL			ON	WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY



  
--where  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
--      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--        AT time zone 'America/Sao_Paulo') AS DATE) BETWEEN 

  
GROUP BY 	ORDERS.WHSEID,                                        				
            CL.UDF2,                                     				
            ORDERS.ORDERKEY,                                      				
--            CAGE.CLOSEDATE,      

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
			
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      " + Parameters!Table.Value + ".ORDERS,                                   " &
"          WMSADMIN.PL_DB,                                                          " &
"          " + Parameters!Table.Value + ".ORDERDETAIL,                              " &
"          " + Parameters!Table.Value + ".ORDERSTATUSHISTORY                        " &
"                                                                                   " &
"LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu                        " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          " + Parameters!Table.Value + ".SKU                                       " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     "

QUERY COM UNION ***********************************************************************

"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE1.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE1.ORDERDETAIL,                                                     " &
"          WMWHSE1.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE1.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE1.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    min(ORDERSTATUSHISTORY.ADDDATE )                     DATA,                     " &
"    TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH')                 HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE2.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE2.ORDERDETAIL,                                                     " &
"          WMWHSE2.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE2.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE2.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE3.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE3.ORDERDETAIL,                                                     " &
"          WMWHSE3.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE3.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE3.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE4.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE4.ORDERDETAIL,                                                     " &
"          WMWHSE4.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE4.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE4.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE5.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE5.ORDERDETAIL,                                                     " &
"          WMWHSE5.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE5.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE5.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE6.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE6.ORDERDETAIL,                                                     " &
"          WMWHSE6.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE6.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE6.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"Union                                                                              " &
"                                                                                   " &
"SELECT                                                                             " &
"  DISTINCT                                                                         " &
"    ORDERS.WHSEID                                        ID_PLANTA,                " &
"    PL_DB.DB_ALIAS                                       DSC_PLANTA,               " &
"    ORDERS.ORDERKEY                                      PEDIDO,                   " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),            " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE)           DATA,                     " &
"    TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE,              " & 
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE), 'HH')    HORA,                     " &
"    ORDERSTATUSHISTORY.ADDWHO                            ID_USUARIO,               " &
"    subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 )   NOME_USUARIO,             " &
"    sum(ORDERDETAIL.SHIPPEDQTY)                          NFCA_QT_VOLUMES,          " &
"    ORDERS.CARRIERCODE                                   ID_TRANSP,                " &
"    ORDERS.CARRIERNAME                                   TRANSP_NOME,              " &
"    ORDERS.DISCHARGEPLACE                                ID_CONTRATO,              " &
"    CASE WHEN max(SKU.SUSR2) = 2                                                   " &
"           THEN 'PESADO'                                                           " &
"         ELSE   'LEVE'                                                             " &
"     END                                                 TP_TRANSP_ITEM            " &
"                                                                                   " &
"FROM      WMWHSE7.ORDERS,                                                          " &
"          WMSADMIN.PL_DB,                                                          " &
"          WMWHSE7.ORDERDETAIL,                                                     " &
"          WMWHSE7.ORDERSTATUSHISTORY                                               " &
"                                                                                   " &
"LEFT JOIN WMWHSE7.taskmanageruser tu                                               " &
"       ON tu.userkey = ORDERSTATUSHISTORY.ADDWHO,                                  " &
"                                                                                   " &
"          WMWHSE7.SKU                                                              " &
"                                                                                   " &
"WHERE ORDERS.STATUS >= 95                                                          " &
"  AND ORDERS.ORDERKEY = ORDERDETAIL.ORDERKEY                                       " &
"  AND ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY                           " &
"  AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ' '                                     " &
"  AND ORDERSTATUSHISTORY.STATUS = 95                                               " &
"  AND SKU.SKU=ORDERDETAIL.SKU                                                      " &
"                                                                                   " &
"  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ORDERSTATUSHISTORY.ADDDATE),    " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')                 " &
"        AT time zone 'America/Sao_Paulo') AS DATE))                                    " &
"  BETWEEN '" + Parameters!DataDe.Value + "'  " &                                   " &
"  AND '" + Parameters!DataAte.Value + "'                                           " &
"                                                                                   " &
"GROUP BY ORDERS.WHSEID,                                                            " &
"         PL_DB.DB_ALIAS,                                                           " &
"         ORDERS.ORDERKEY ,                                                         " &
"         TO_CHAR(ORDERS.ACTUALSHIPDATE, 'HH'),                                     " &
"         ORDERSTATUSHISTORY.ADDWHO,                                                " &
"         subStr( tu.usr_name,4, inStr(tu.usr_name, ',')-4 ),                       " &
"         ORDERS.CARRIERCODE,                                                       " &
"         ORDERS.CARRIERNAME,                                                       " &
"         ORDERS.DISCHARGEPLACE                                                     " &
"                                                                                   " &
"                                                                                   " &
" ORDER BY DSC_PLANTA                                                               "