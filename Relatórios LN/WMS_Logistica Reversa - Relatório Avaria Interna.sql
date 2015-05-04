SELECT
		ITRN.ITRNKEY							ID_MOVIMENTO,  --ITRN.TRANTYPE,
		ITRN.ADDDATE							DT_MOVIMENTO,
		ITRN.WHSEID								FILIAL,
		ITRN.SKU								ITEM,
	  ( SELECT asku.altsku  		
		FROM WMWHSE5.altsku asku 		
		WHERE asku.sku = ITRN.sku 		
		AND ROWNUM = 1 )						EAN,
		SKU.DESCR								DESCR_SKU,
		STORER.COMPANY							FORNECEDOR,
		DEPARTSECTORSKU.DEPART_NAME				DEPARTAMENTO,
		NVL(maucLN.mauc, 0) * ITRN.QTY			CMV_TOTAL,
		ITRN.QTY								QTD,
		CASE WHEN 		
			NVL(FHLD.STATUS, 'WN')='WN'		
			THEN 'ENTRADA'		
			ELSE 'SAIDA' END					SENTIDO,
		ITRN.ADDWHO								USUARIO,
		
--		ITRN.FROMLOC,		
		NVL(FHLD.STATUS, 'WN')					NOME_DEPOSITO,  	-- RESTRICAO_FROM,			
		NVL(FIHC.DESCRIPTION, 'Deposito WN')	TIPO_DEPOSITO,
		
		ITRN.ITRNKEY							ID_MOVIMENTO_PARA,	--	SERÁ O MESMO QUE O ID DO MOVIMENTO POIS NÃO EXISTE NO WMS INFOR
		TLOC.WHSEID								FILIAL_PARA,
--		NVL(THLD.STATUS, 'WN')					RESTRICAO_TO			
		NVL(TIHC.DESCRIPTION, 'Deposito WN')	DEPOSITO_PAR
		
		
FROM
			WMWHSE5.ITRN				ITRN

INNER JOIN	WMWHSE5.SKU					SKU
				ON	SKU.SKU		=	ITRN.SKU
				
INNER JOIN	WMWHSE5.LOC					TLOC
				ON	TLOC.LOC	=	ITRN.TOLOC
		
LEFT JOIN (	SELECT 	A.LOC,
					A.status 
			FROM INVENTORYHOLD A 
			where hold = 1 
			and loc <> ' ' )  			FHLD
				ON	FHLD.LOC	=	ITRN.FROMLOC
				
LEFT JOIN	WMWHSE5.INVENTORYHOLDCODE	FIHC
				ON	FIHC.CODE	=	FHLD.STATUS
				
LEFT JOIN (	SELECT 	A.LOC,
					A.status 
			FROM INVENTORYHOLD A 
			where hold = 1 
			and loc <> ' ' )  			THLD
				ON	THLD.LOC	=	ITRN.TOLOC

LEFT JOIN	WMWHSE5.INVENTORYHOLDCODE	TIHC
				ON	TIHC.CODE	=	THLD.STATUS

LEFT JOIN 	WMWHSE5.STORER 				STORER
				ON 	STORER.STORERKEY = sku.SUSR5 
				AND STORER.WHSEID = sku.WHSEID 
				AND STORER.TYPE = 5
				
LEFT JOIN 	ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU
				ON 	TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)
				AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)

LEFT JOIN	ENTERPRISE.BILLOFMATERIAL	BOM
				ON	BOM.COMPONENTSKU	=	ITRN.SKU

				
LEFT JOIN ENTERPRISE.CODELKUP  			cl 
				ON 	UPPER(cl.UDF1) = ITRN.WHSEID
				AND cl.LISTNAME = 'SCHEMA'
    
LEFT JOIN ( select trim(whwmd217.t$item) item,                             
                    whwmd217.t$cwar cwar,                                   
                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0                             
                           then sum(whwmd217.t$ftpa$1)                                              
                         else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
                    end mauc                                                
               from baandb.twhwmd217301@pln01 whwmd217                      
			left join baandb.twhinr140301@pln01 a                             
                 on a.t$cwar = whwmd217.t$cwar                              
                and a.t$item = whwmd217.t$item                              
			group by whwmd217.t$item,                                        
                    whwmd217.t$cwar ) 	maucLN                                
				ON 	maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         
				AND maucLN.item = CASE WHEN SKU.BOMITEMTYPE IN (3,4)
									THEN NVL(BOM.SKU, ITRN.SKU)
									ELSE ITRN.sku END
				
WHERE 	NVL(FHLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')
AND		NVL(THLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')
AND ITRN.TRANTYPE='MV'
AND NVL(FHLD.STATUS, 'WN')!=NVL(THLD.STATUS, 'WN')



=IIF(Parameters!Table.Value <> "AAA", 

"	SELECT																	  							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO, 							"& 

"			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) DT_MOVIMENTO,  "&
"			ITRN.WHSEID								            FILIAL,       							"&
"    		FilialA.UDF2              							NOME_FILIAL,							"&
"    		FilialB.UDF2              							NOME_FILIAL_PARA,						"&
"			ITRN.SKU								              ITEM,       							"&
"		  ( SELECT asku.altsku  		                                      							"&
"		  FROM " + Parameters!Table.Value + ".altsku asku 		              							"&
"		  WHERE asku.sku = ITRN.sku 		                                  							"&
"		  AND ROWNUM = 1 )						        		EAN,          							"&
"			SKU.DESCR								            DESCR_SKU,    							"&
"			STORER.COMPANY							          	FORNECEDOR,   							"&
"			DEPARTSECTORSKU.DEPART_NAME		        			DEPARTAMENTO, 							"&
"			NVL(maucLN.mauc, 0) * ITRN.QTY			  			CMV_TOTAL,    							"&
"			ITRN.QTY								            QTD,          							"&
"			CASE WHEN 		                                                  							"&
"				NVL(FHLD.STATUS, 'WN')='WN'		                              							"&
"				THEN 'ENTRADA'		                                          							"&
"				ELSE 'SAIDA' END					          	SENTIDO,      							"&
"			ITRN.ADDWHO								            USUARIO,      							"&
"			NVL(FHLD.STATUS, 'WN')				        		NOME_DEPOSITO,							"&
"			NVL(FIHC.DESCRIPTION, 'Deposito WN')				TIPO_DEPOSITO,							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO_PARA, 						"&
"			TLOC.WHSEID								            FILIAL_PARA,							"&	
"			NVL(TIHC.DESCRIPTION, 'Deposito WN')	DEPOSITO_PAR										"&	
"	FROM " + Parameters!Table.Value + ".ITRN				        ITRN								"&
"	INNER JOIN " + Parameters!Table.Value + ".SKU				  SKU									"&
"					ON	SKU.SKU		=	ITRN.SKU														"&
"	INNER JOIN " + Parameters!Table.Value + ".LOC					TLOC								"&
"					ON	TLOC.LOC	=	ITRN.TOLOC														"&	
"	LEFT JOIN (	SELECT 	A.LOC, A.status																	"& 
"				FROM " + Parameters!Table.Value + ".INVENTORYHOLD A										"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )   FHLD																	"&
"					ON	FHLD.LOC	=	ITRN.FROMLOC													"&
"	LEFT JOIN " + Parameters!Table.Value + ".INVENTORYHOLDCODE	FIHC									"&
"					ON	FIHC.CODE	=	FHLD.STATUS														"&
"	LEFT JOIN (	SELECT 	A.LOC, A.status 																"&
"				FROM " + Parameters!Table.Value + ".INVENTORYHOLD A										"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )  			THLD														"&
"					ON	THLD.LOC	=	ITRN.TOLOC														"&
"	LEFT JOIN " + Parameters!Table.Value + ".INVENTORYHOLDCODE	TIHC									"&
"					ON	TIHC.CODE	=	THLD.STATUS														"&
"	LEFT JOIN " + Parameters!Table.Value + ".STORER 				STORER								"&
"					ON 	STORER.STORERKEY = sku.SUSR5													"& 
"					AND STORER.WHSEID = sku.WHSEID 														"&
"					AND STORER.TYPE = 5																	"&
"	LEFT JOIN 	ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU												"&
"					ON 	TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)						"&
"					AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)						"&
"	LEFT JOIN	ENTERPRISE.BILLOFMATERIAL	BOM															"&
"					ON	BOM.COMPONENTSKU	=	ITRN.SKU												"&
"	LEFT JOIN ENTERPRISE.CODELKUP  			cl 															"&
"					ON 	UPPER(cl.UDF1) = ITRN.WHSEID													"&
"					AND cl.LISTNAME = 'SCHEMA'															"&
"	LEFT JOIN ( SELECT  trim(whwmd217.t$item) item, whwmd217.t$cwar cwar,								"& 
"						CASE  WHEN SUM(NVL(whwmd217.t$mauc$1,0)) = 0     								"& 
"							  THEN SUM(whwmd217.t$ftpa$1)                								"& 
"						ELSE   ROUND(SUM(whwmd217.t$mauc$1) / SUM(a.t$qhnd), 4)							"& 
"						END mauc                                         								"&
"				FROM  baandb.twhwmd217301@pln01 whwmd217                 								"& 
"				LEFT JOIN baandb.twhinr140301@pln01 a                    								"& 
"					 ON a.t$cwar = whwmd217.t$cwar                       								"& 
"					AND a.t$item = whwmd217.t$item                       								"& 
"				GROUP BY whwmd217.t$item, whwmd217.t$cwar, trim(whwmd217.t$item) ) 	maucLN				"&
"					ON 	maucLN.cwar = subStr(CL.DESCRIPTION,3,6)         								"& 
"					AND maucLN.item = CASE WHEN SKU.BOMITEMTYPE IN (3,4) 								"&
"								   THEN NVL(BOM.SKU, ITRN.SKU)											"&
"							  ELSE ITRN.sku END															"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialA													"&
"		 ON FilialA.UDF1 = ITRN.WHSEID																	"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialB													"&
"		 ON FilialB.UDF1 = TLOC.WHSEID																	"&

"	WHERE NVL(FHLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')													"&
"		  AND		NVL(THLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')										"&
"		  AND ITRN.TRANTYPE='MV'																		"&
"		  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) 				"&
"       BETWEEN '"+ Parameters!DataDe.Value + "'                                           				"&
"           AND '"+ Parameters!DataAte.Value + "'										   				"&

"		  AND NVL(FHLD.STATUS, 'WN')!=NVL(THLD.STATUS, 'WN') "

,

"	SELECT																	  							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO, 							"& 
"			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) DT_MOVIMENTO,  "&
"			ITRN.WHSEID								            FILIAL,       							"&
"    		FilialA.UDF2              							NOME_FILIAL,							"&
"    		FilialB.UDF2              							NOME_FILIAL_PARA,						"&
"			ITRN.SKU								              ITEM,       							"&
"		  ( SELECT asku.altsku  		                                      							"&
"		  FROM WMWHSE4.altsku asku 		                                      							"&
"		  WHERE asku.sku = ITRN.sku 		                                  							"&
"		  AND ROWNUM = 1 )						        		EAN,          							"&
"			SKU.DESCR								            DESCR_SKU,    							"&
"			STORER.COMPANY							          	FORNECEDOR,   							"&
"			DEPARTSECTORSKU.DEPART_NAME		        			DEPARTAMENTO, 							"&
"			NVL(maucLN.mauc, 0) * ITRN.QTY			  			CMV_TOTAL,    							"&
"			ITRN.QTY								            QTD,          							"&
"			CASE WHEN 		                                                  							"&
"				NVL(FHLD.STATUS, 'WN')='WN'		                              							"&
"				THEN 'ENTRADA'		                                          							"&
"				ELSE 'SAIDA' END					          	SENTIDO,      							"&
"			ITRN.ADDWHO								            USUARIO,      							"&
"			NVL(FHLD.STATUS, 'WN')				        		NOME_DEPOSITO,							"&
"			NVL(FIHC.DESCRIPTION, 'Deposito WN')				TIPO_DEPOSITO,							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO_PARA, 						"&
"			TLOC.WHSEID								            FILIAL_PARA,							"&	
"			NVL(TIHC.DESCRIPTION, 'Deposito WN')	DEPOSITO_PAR										"&	
"	FROM WMWHSE1.ITRN				        ITRN														"&
"	INNER JOIN WMWHSE1.SKU				  SKU															"&
"					ON	SKU.SKU		=	ITRN.SKU														"&
"	INNER JOIN WMWHSE1.LOC					TLOC														"&
"					ON	TLOC.LOC	=	ITRN.TOLOC														"&	
"	LEFT JOIN (	SELECT 	A.LOC, A.status																	"& 
"				FROM WMWHSE1.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )   FHLD																	"&
"					ON	FHLD.LOC	=	ITRN.FROMLOC													"&
"	LEFT JOIN WMWHSE1.INVENTORYHOLDCODE	FIHC															"&
"					ON	FIHC.CODE	=	FHLD.STATUS														"&
"	LEFT JOIN (	SELECT 	A.LOC, A.status 																"&
"				FROM WMWHSE1.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )  			THLD														"&
"					ON	THLD.LOC	=	ITRN.TOLOC														"&
"	LEFT JOIN WMWHSE1.INVENTORYHOLDCODE	TIHC															"&
"					ON	TIHC.CODE	=	THLD.STATUS														"&
"	LEFT JOIN WMWHSE1.STORER 				STORER														"&
"					ON 	STORER.STORERKEY = sku.SUSR5													"& 
"					AND STORER.WHSEID = sku.WHSEID 														"&
"					AND STORER.TYPE = 5																	"&
"	LEFT JOIN 	ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU												"&
"					ON 	TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)						"&
"					AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)						"&
"	LEFT JOIN	ENTERPRISE.BILLOFMATERIAL	BOM															"&
"					ON	BOM.COMPONENTSKU	=	ITRN.SKU												"&
"	LEFT JOIN ENTERPRISE.CODELKUP  			cl 															"&
"					ON 	UPPER(cl.UDF1) = ITRN.WHSEID													"&
"					AND cl.LISTNAME = 'SCHEMA'															"&
"	LEFT JOIN ( SELECT  trim(whwmd217.t$item) item, whwmd217.t$cwar cwar,								"& 
"						CASE  WHEN SUM(NVL(whwmd217.t$mauc$1,0)) = 0     								"& 
"							  THEN SUM(whwmd217.t$ftpa$1)                								"& 
"						ELSE   ROUND(SUM(whwmd217.t$mauc$1) / SUM(a.t$qhnd), 4)							"& 
"						END mauc                                         								"&
"				FROM  baandb.twhwmd217301@pln01 whwmd217                 								"& 
"				LEFT JOIN baandb.twhinr140301@pln01 a                    								"& 
"					 ON a.t$cwar = whwmd217.t$cwar                       								"& 
"					AND a.t$item = whwmd217.t$item                       								"& 
"				GROUP BY whwmd217.t$item, whwmd217.t$cwar, trim(whwmd217.t$item) ) 	maucLN				"&
"					ON 	maucLN.cwar = subStr(CL.DESCRIPTION,3,6)         								"& 
"					AND maucLN.item = CASE WHEN SKU.BOMITEMTYPE IN (3,4) 								"&
"								   THEN NVL(BOM.SKU, ITRN.SKU)											"&
"							  ELSE ITRN.sku END															"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialA													"&
"		 ON FilialA.UDF1 = ITRN.WHSEID																	"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialB													"&
"		 ON FilialB.UDF1 = TLOC.WHSEID																	"&
"	WHERE NVL(FHLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')													"&
"		  AND		NVL(THLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')										"&
"		  AND ITRN.TRANTYPE='MV'																		"&
"		  AND NVL(FHLD.STATUS, 'WN')!=NVL(THLD.STATUS, 'WN') 											"&
"		  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) 				"&
"       BETWEEN '"+ Parameters!DataDe.Value + "'                                           				"&
"           AND '"+ Parameters!DataAte.Value + "'										   				"&
"UNION																									"&
"	SELECT																	  							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO, 							"& 
"			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) DT_MOVIMENTO,  "&
"			ITRN.WHSEID								            FILIAL,       							"&
"    		FilialA.UDF2              							NOME_FILIAL,							"&
"    		FilialB.UDF2              							NOME_FILIAL_PARA,						"&
"			ITRN.SKU								              ITEM,       							"&
"		  ( SELECT asku.altsku  		                                      							"&
"		  FROM WMWHSE4.altsku asku 		                                      							"&
"		  WHERE asku.sku = ITRN.sku 		                                  							"&
"		  AND ROWNUM = 1 )						        		EAN,          							"&
"			SKU.DESCR								            DESCR_SKU,    							"&
"			STORER.COMPANY							          	FORNECEDOR,   							"&
"			DEPARTSECTORSKU.DEPART_NAME		        			DEPARTAMENTO, 							"&
"			NVL(maucLN.mauc, 0) * ITRN.QTY			  			CMV_TOTAL,    							"&
"			ITRN.QTY								            QTD,          							"&
"			CASE WHEN 		                                                  							"&
"				NVL(FHLD.STATUS, 'WN')='WN'		                              							"&
"				THEN 'ENTRADA'		                                          							"&
"				ELSE 'SAIDA' END					          	SENTIDO,      							"&
"			ITRN.ADDWHO								            USUARIO,      							"&
"			NVL(FHLD.STATUS, 'WN')				        		NOME_DEPOSITO,							"&
"			NVL(FIHC.DESCRIPTION, 'Deposito WN')				TIPO_DEPOSITO,							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO_PARA, 						"&
"			TLOC.WHSEID								            FILIAL_PARA,							"&	
"			NVL(TIHC.DESCRIPTION, 'Deposito WN')	DEPOSITO_PAR										"&	
"	FROM WMWHSE2.ITRN				        ITRN														"&
"	INNER JOIN WMWHSE2.SKU				  SKU															"&
"					ON	SKU.SKU		=	ITRN.SKU														"&
"	INNER JOIN WMWHSE2.LOC					TLOC														"&
"					ON	TLOC.LOC	=	ITRN.TOLOC														"&	
"	LEFT JOIN (	SELECT 	A.LOC, A.status																	"& 
"				FROM WMWHSE2.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )   FHLD																	"&
"					ON	FHLD.LOC	=	ITRN.FROMLOC													"&
"	LEFT JOIN WMWHSE2.INVENTORYHOLDCODE	FIHC															"&
"					ON	FIHC.CODE	=	FHLD.STATUS														"&
"	LEFT JOIN (	SELECT 	A.LOC, A.status 																"&
"				FROM WMWHSE2.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )  			THLD														"&
"					ON	THLD.LOC	=	ITRN.TOLOC														"&
"	LEFT JOIN WMWHSE2.INVENTORYHOLDCODE	TIHC															"&
"					ON	TIHC.CODE	=	THLD.STATUS														"&
"	LEFT JOIN WMWHSE2.STORER 				STORER														"&
"					ON 	STORER.STORERKEY = sku.SUSR5													"& 
"					AND STORER.WHSEID = sku.WHSEID 														"&
"					AND STORER.TYPE = 5																	"&
"	LEFT JOIN 	ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU												"&
"					ON 	TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)						"&
"					AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)						"&
"	LEFT JOIN	ENTERPRISE.BILLOFMATERIAL	BOM															"&
"					ON	BOM.COMPONENTSKU	=	ITRN.SKU												"&
"	LEFT JOIN ENTERPRISE.CODELKUP  			cl 															"&
"					ON 	UPPER(cl.UDF1) = ITRN.WHSEID													"&
"					AND cl.LISTNAME = 'SCHEMA'															"&
"	LEFT JOIN ( SELECT  trim(whwmd217.t$item) item, whwmd217.t$cwar cwar,								"& 
"						CASE  WHEN SUM(NVL(whwmd217.t$mauc$1,0)) = 0     								"& 
"							  THEN SUM(whwmd217.t$ftpa$1)                								"& 
"						ELSE   ROUND(SUM(whwmd217.t$mauc$1) / SUM(a.t$qhnd), 4)							"& 
"						END mauc                                         								"&
"				FROM  baandb.twhwmd217301@pln01 whwmd217                 								"& 
"				LEFT JOIN baandb.twhinr140301@pln01 a                    								"& 
"					 ON a.t$cwar = whwmd217.t$cwar                       								"& 
"					AND a.t$item = whwmd217.t$item                       								"& 
"				GROUP BY whwmd217.t$item, whwmd217.t$cwar, trim(whwmd217.t$item) ) 	maucLN				"&
"					ON 	maucLN.cwar = subStr(CL.DESCRIPTION,3,6)         								"& 
"					AND maucLN.item = CASE WHEN SKU.BOMITEMTYPE IN (3,4) 								"&
"								   THEN NVL(BOM.SKU, ITRN.SKU)											"&
"							  ELSE ITRN.sku END															"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialA													"&
"		 ON FilialA.UDF1 = ITRN.WHSEID																	"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialB													"&
"		 ON FilialB.UDF1 = TLOC.WHSEID																	"&
"	WHERE NVL(FHLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')													"&
"		  AND		NVL(THLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')										"&
"		  AND ITRN.TRANTYPE='MV'																		"&
"		  AND NVL(FHLD.STATUS, 'WN')!=NVL(THLD.STATUS, 'WN') 											"&
"		  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) 				"&
"       BETWEEN '"+ Parameters!DataDe.Value + "'                                           				"&
"           AND '"+ Parameters!DataAte.Value + "'										   				"&
"UNION																									"&
"	SELECT																	  							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO, 							"& 
"			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) DT_MOVIMENTO,  "&
"			ITRN.WHSEID								            FILIAL,       							"&
"    		FilialA.UDF2              							NOME_FILIAL,							"&
"    		FilialB.UDF2              							NOME_FILIAL_PARA,						"&
"			ITRN.SKU								              ITEM,       							"&
"		  ( SELECT asku.altsku  		                                      							"&
"		  FROM WMWHSE4.altsku asku 		                                      							"&
"		  WHERE asku.sku = ITRN.sku 		                                  							"&
"		  AND ROWNUM = 1 )						        		EAN,          							"&
"			SKU.DESCR								            DESCR_SKU,    							"&
"			STORER.COMPANY							          	FORNECEDOR,   							"&
"			DEPARTSECTORSKU.DEPART_NAME		        			DEPARTAMENTO, 							"&
"			NVL(maucLN.mauc, 0) * ITRN.QTY			  			CMV_TOTAL,    							"&
"			ITRN.QTY								            QTD,          							"&
"			CASE WHEN 		                                                  							"&
"				NVL(FHLD.STATUS, 'WN')='WN'		                              							"&
"				THEN 'ENTRADA'		                                          							"&
"				ELSE 'SAIDA' END					          	SENTIDO,      							"&
"			ITRN.ADDWHO								            USUARIO,      							"&
"			NVL(FHLD.STATUS, 'WN')				        		NOME_DEPOSITO,							"&
"			NVL(FIHC.DESCRIPTION, 'Deposito WN')				TIPO_DEPOSITO,							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO_PARA, 						"&
"			TLOC.WHSEID								            FILIAL_PARA,							"&	
"			NVL(TIHC.DESCRIPTION, 'Deposito WN')	DEPOSITO_PAR										"&	
"	FROM WMWHSE3.ITRN				        ITRN														"&
"	INNER JOIN WMWHSE3.SKU				  SKU															"&
"					ON	SKU.SKU		=	ITRN.SKU														"&
"	INNER JOIN WMWHSE3.LOC					TLOC														"&
"					ON	TLOC.LOC	=	ITRN.TOLOC														"&	
"	LEFT JOIN (	SELECT 	A.LOC, A.status																	"& 
"				FROM WMWHSE3.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )   FHLD																	"&
"					ON	FHLD.LOC	=	ITRN.FROMLOC													"&
"	LEFT JOIN WMWHSE3.INVENTORYHOLDCODE	FIHC															"&
"					ON	FIHC.CODE	=	FHLD.STATUS														"&
"	LEFT JOIN (	SELECT 	A.LOC, A.status 																"&
"				FROM WMWHSE3.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )  			THLD														"&
"					ON	THLD.LOC	=	ITRN.TOLOC														"&
"	LEFT JOIN WMWHSE3.INVENTORYHOLDCODE	TIHC															"&
"					ON	TIHC.CODE	=	THLD.STATUS														"&
"	LEFT JOIN WMWHSE3.STORER 				STORER														"&
"					ON 	STORER.STORERKEY = sku.SUSR5													"& 
"					AND STORER.WHSEID = sku.WHSEID 														"&
"					AND STORER.TYPE = 5																	"&
"	LEFT JOIN 	ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU												"&
"					ON 	TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)						"&
"					AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)						"&
"	LEFT JOIN	ENTERPRISE.BILLOFMATERIAL	BOM															"&
"					ON	BOM.COMPONENTSKU	=	ITRN.SKU												"&
"	LEFT JOIN ENTERPRISE.CODELKUP  			cl 															"&
"					ON 	UPPER(cl.UDF1) = ITRN.WHSEID													"&
"					AND cl.LISTNAME = 'SCHEMA'															"&
"	LEFT JOIN ( SELECT  trim(whwmd217.t$item) item, whwmd217.t$cwar cwar,								"& 
"						CASE  WHEN SUM(NVL(whwmd217.t$mauc$1,0)) = 0     								"& 
"							  THEN SUM(whwmd217.t$ftpa$1)                								"& 
"						ELSE   ROUND(SUM(whwmd217.t$mauc$1) / SUM(a.t$qhnd), 4)							"& 
"						END mauc                                         								"&
"				FROM  baandb.twhwmd217301@pln01 whwmd217                 								"& 
"				LEFT JOIN baandb.twhinr140301@pln01 a                    								"& 
"					 ON a.t$cwar = whwmd217.t$cwar                       								"& 
"					AND a.t$item = whwmd217.t$item                       								"& 
"				GROUP BY whwmd217.t$item, whwmd217.t$cwar, trim(whwmd217.t$item) ) 	maucLN				"&
"					ON 	maucLN.cwar = subStr(CL.DESCRIPTION,3,6)         								"& 
"					AND maucLN.item = CASE WHEN SKU.BOMITEMTYPE IN (3,4) 								"&
"								   THEN NVL(BOM.SKU, ITRN.SKU)											"&
"							  ELSE ITRN.sku END															"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialA													"&
"		 ON FilialA.UDF1 = ITRN.WHSEID																	"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialB													"&
"		 ON FilialB.UDF1 = TLOC.WHSEID																	"&
"	WHERE NVL(FHLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')													"&
"		  AND		NVL(THLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')										"&
"		  AND ITRN.TRANTYPE='MV'																		"&
"		  AND NVL(FHLD.STATUS, 'WN')!=NVL(THLD.STATUS, 'WN') 											"&
"		  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) 				"&
"       BETWEEN '"+ Parameters!DataDe.Value + "'                                           				"&
"           AND '"+ Parameters!DataAte.Value + "'										   				"&
"UNION																									"&
"	SELECT																	  							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO, 							"& 
"			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) DT_MOVIMENTO,  "&
"			ITRN.WHSEID								            FILIAL,       							"&
"    		FilialA.UDF2              							NOME_FILIAL,							"&
"    		FilialB.UDF2              							NOME_FILIAL_PARA,						"&
"			ITRN.SKU								              ITEM,       							"&
"		  ( SELECT asku.altsku  		                                      							"&
"		  FROM WMWHSE4.altsku asku 		                                      							"&
"		  WHERE asku.sku = ITRN.sku 		                                  							"&
"		  AND ROWNUM = 1 )						        		EAN,          							"&
"			SKU.DESCR								            DESCR_SKU,    							"&
"			STORER.COMPANY							          	FORNECEDOR,   							"&
"			DEPARTSECTORSKU.DEPART_NAME		        			DEPARTAMENTO, 							"&
"			NVL(maucLN.mauc, 0) * ITRN.QTY			  			CMV_TOTAL,    							"&
"			ITRN.QTY								            QTD,          							"&
"			CASE WHEN 		                                                  							"&
"				NVL(FHLD.STATUS, 'WN')='WN'		                              							"&
"				THEN 'ENTRADA'		                                          							"&
"				ELSE 'SAIDA' END					          	SENTIDO,      							"&
"			ITRN.ADDWHO								            USUARIO,      							"&
"			NVL(FHLD.STATUS, 'WN')				        		NOME_DEPOSITO,							"&
"			NVL(FIHC.DESCRIPTION, 'Deposito WN')				TIPO_DEPOSITO,							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO_PARA, 						"&
"			TLOC.WHSEID								            FILIAL_PARA,							"&	
"			NVL(TIHC.DESCRIPTION, 'Deposito WN')	DEPOSITO_PAR										"&	
"	FROM WMWHSE4.ITRN				        ITRN														"&
"	INNER JOIN WMWHSE4.SKU				  SKU															"&
"					ON	SKU.SKU		=	ITRN.SKU														"&
"	INNER JOIN WMWHSE4.LOC					TLOC														"&
"					ON	TLOC.LOC	=	ITRN.TOLOC														"&	
"	LEFT JOIN (	SELECT 	A.LOC, A.status																	"& 
"				FROM WMWHSE4.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )   FHLD																	"&
"					ON	FHLD.LOC	=	ITRN.FROMLOC													"&
"	LEFT JOIN WMWHSE4.INVENTORYHOLDCODE	FIHC															"&
"					ON	FIHC.CODE	=	FHLD.STATUS														"&
"	LEFT JOIN (	SELECT 	A.LOC, A.status 																"&
"				FROM WMWHSE4.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )  			THLD														"&
"					ON	THLD.LOC	=	ITRN.TOLOC														"&
"	LEFT JOIN WMWHSE4.INVENTORYHOLDCODE	TIHC															"&
"					ON	TIHC.CODE	=	THLD.STATUS														"&
"	LEFT JOIN WMWHSE4.STORER 				STORER														"&
"					ON 	STORER.STORERKEY = sku.SUSR5													"& 
"					AND STORER.WHSEID = sku.WHSEID 														"&
"					AND STORER.TYPE = 5																	"&
"	LEFT JOIN 	ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU												"&
"					ON 	TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)						"&
"					AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)						"&
"	LEFT JOIN	ENTERPRISE.BILLOFMATERIAL	BOM															"&
"					ON	BOM.COMPONENTSKU	=	ITRN.SKU												"&
"	LEFT JOIN ENTERPRISE.CODELKUP  			cl 															"&
"					ON 	UPPER(cl.UDF1) = ITRN.WHSEID													"&
"					AND cl.LISTNAME = 'SCHEMA'															"&
"	LEFT JOIN ( SELECT  trim(whwmd217.t$item) item, whwmd217.t$cwar cwar,								"& 
"						CASE  WHEN SUM(NVL(whwmd217.t$mauc$1,0)) = 0     								"& 
"							  THEN SUM(whwmd217.t$ftpa$1)                								"& 
"						ELSE   ROUND(SUM(whwmd217.t$mauc$1) / SUM(a.t$qhnd), 4)							"& 
"						END mauc                                         								"&
"				FROM  baandb.twhwmd217301@pln01 whwmd217                 								"& 
"				LEFT JOIN baandb.twhinr140301@pln01 a                    								"& 
"					 ON a.t$cwar = whwmd217.t$cwar                       								"& 
"					AND a.t$item = whwmd217.t$item                       								"& 
"				GROUP BY whwmd217.t$item, whwmd217.t$cwar, trim(whwmd217.t$item) ) 	maucLN				"&
"					ON 	maucLN.cwar = subStr(CL.DESCRIPTION,3,6)         								"& 
"					AND maucLN.item = CASE WHEN SKU.BOMITEMTYPE IN (3,4) 								"&
"								   THEN NVL(BOM.SKU, ITRN.SKU)											"&
"							  ELSE ITRN.sku END															"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialA													"&
"		 ON FilialA.UDF1 = ITRN.WHSEID																	"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialB													"&
"		 ON FilialB.UDF1 = TLOC.WHSEID																	"&
"	WHERE NVL(FHLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')													"&
"		  AND		NVL(THLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')										"&
"		  AND ITRN.TRANTYPE='MV'																		"&
"		  AND NVL(FHLD.STATUS, 'WN')!=NVL(THLD.STATUS, 'WN') 											"&
"		  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) 				"&
"       BETWEEN '"+ Parameters!DataDe.Value + "'                                           				"&
"           AND '"+ Parameters!DataAte.Value + "'										   				"&
"UNION																									"&
"	SELECT																	  							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO, 							"& 
"			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) DT_MOVIMENTO,  "&
"			ITRN.WHSEID								            FILIAL,       							"&
"    		FilialA.UDF2              							NOME_FILIAL,							"&
"    		FilialB.UDF2              							NOME_FILIAL_PARA,						"&
"			ITRN.SKU								              ITEM,       							"&
"		  ( SELECT asku.altsku  		                                      							"&
"		  FROM WMWHSE4.altsku asku 		                                      							"&
"		  WHERE asku.sku = ITRN.sku 		                                  							"&
"		  AND ROWNUM = 1 )						        		EAN,          							"&
"			SKU.DESCR								            DESCR_SKU,    							"&
"			STORER.COMPANY							          	FORNECEDOR,   							"&
"			DEPARTSECTORSKU.DEPART_NAME		        			DEPARTAMENTO, 							"&
"			NVL(maucLN.mauc, 0) * ITRN.QTY			  			CMV_TOTAL,    							"&
"			ITRN.QTY								            QTD,          							"&
"			CASE WHEN 		                                                  							"&
"				NVL(FHLD.STATUS, 'WN')='WN'		                              							"&
"				THEN 'ENTRADA'		                                          							"&
"				ELSE 'SAIDA' END					          	SENTIDO,      							"&
"			ITRN.ADDWHO								            USUARIO,      							"&
"			NVL(FHLD.STATUS, 'WN')				        		NOME_DEPOSITO,							"&
"			NVL(FIHC.DESCRIPTION, 'Deposito WN')				TIPO_DEPOSITO,							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO_PARA, 						"&
"			TLOC.WHSEID								            FILIAL_PARA,							"&	
"			NVL(TIHC.DESCRIPTION, 'Deposito WN')	DEPOSITO_PAR										"&	
"	FROM WMWHSE5.ITRN				        ITRN														"&
"	INNER JOIN WMWHSE5.SKU				  SKU															"&
"					ON	SKU.SKU		=	ITRN.SKU														"&
"	INNER JOIN WMWHSE5.LOC					TLOC														"&
"					ON	TLOC.LOC	=	ITRN.TOLOC														"&	
"	LEFT JOIN (	SELECT 	A.LOC, A.status																	"& 
"				FROM WMWHSE5.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )   FHLD																	"&
"					ON	FHLD.LOC	=	ITRN.FROMLOC													"&
"	LEFT JOIN WMWHSE5.INVENTORYHOLDCODE	FIHC															"&
"					ON	FIHC.CODE	=	FHLD.STATUS														"&
"	LEFT JOIN (	SELECT 	A.LOC, A.status 																"&
"				FROM WMWHSE5.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )  			THLD														"&
"					ON	THLD.LOC	=	ITRN.TOLOC														"&
"	LEFT JOIN WMWHSE5.INVENTORYHOLDCODE	TIHC															"&
"					ON	TIHC.CODE	=	THLD.STATUS														"&
"	LEFT JOIN WMWHSE5.STORER 				STORER														"&
"					ON 	STORER.STORERKEY = sku.SUSR5													"& 
"					AND STORER.WHSEID = sku.WHSEID 														"&
"					AND STORER.TYPE = 5																	"&
"	LEFT JOIN 	ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU												"&
"					ON 	TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)						"&
"					AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)						"&
"	LEFT JOIN	ENTERPRISE.BILLOFMATERIAL	BOM															"&
"					ON	BOM.COMPONENTSKU	=	ITRN.SKU												"&
"	LEFT JOIN ENTERPRISE.CODELKUP  			cl 															"&
"					ON 	UPPER(cl.UDF1) = ITRN.WHSEID													"&
"					AND cl.LISTNAME = 'SCHEMA'															"&
"	LEFT JOIN ( SELECT  trim(whwmd217.t$item) item, whwmd217.t$cwar cwar,								"& 
"						CASE  WHEN SUM(NVL(whwmd217.t$mauc$1,0)) = 0     								"& 
"							  THEN SUM(whwmd217.t$ftpa$1)                								"& 
"						ELSE   ROUND(SUM(whwmd217.t$mauc$1) / SUM(a.t$qhnd), 4)							"& 
"						END mauc                                         								"&
"				FROM  baandb.twhwmd217301@pln01 whwmd217                 								"& 
"				LEFT JOIN baandb.twhinr140301@pln01 a                    								"& 
"					 ON a.t$cwar = whwmd217.t$cwar                       								"& 
"					AND a.t$item = whwmd217.t$item                       								"& 
"				GROUP BY whwmd217.t$item, whwmd217.t$cwar, trim(whwmd217.t$item) ) 	maucLN				"&
"					ON 	maucLN.cwar = subStr(CL.DESCRIPTION,3,6)        								"& 
"					AND maucLN.item = CASE WHEN SKU.BOMITEMTYPE IN (3,4)								"&
"								   THEN NVL(BOM.SKU, ITRN.SKU)											"&
"							  ELSE ITRN.sku END															"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialA													"&
"		 ON FilialA.UDF1 = ITRN.WHSEID																	"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialB													"&
"		 ON FilialB.UDF1 = TLOC.WHSEID																	"&
"	WHERE NVL(FHLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')													"&
"		  AND		NVL(THLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')										"&
"		  AND ITRN.TRANTYPE='MV'																		"&
"		  AND NVL(FHLD.STATUS, 'WN')!=NVL(THLD.STATUS, 'WN') 											"&
"		  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) 				"&
"       BETWEEN '"+ Parameters!DataDe.Value + "'                                           				"&
"           AND '"+ Parameters!DataAte.Value + "'										   				"&
"UNION																									"&
"	SELECT																	  							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO, 							"& 
"			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) DT_MOVIMENTO,  "&
"			ITRN.WHSEID								            FILIAL,       							"&
"    		FilialA.UDF2              							NOME_FILIAL,							"&
"    		FilialB.UDF2              							NOME_FILIAL_PARA,						"&
"			ITRN.SKU								              ITEM,       							"&
"		  ( SELECT asku.altsku  		                                      							"&
"		  FROM WMWHSE4.altsku asku 		                                      							"&
"		  WHERE asku.sku = ITRN.sku 		                                  							"&
"		  AND ROWNUM = 1 )						        		EAN,          							"&
"			SKU.DESCR								            DESCR_SKU,    							"&
"			STORER.COMPANY							          	FORNECEDOR,   							"&
"			DEPARTSECTORSKU.DEPART_NAME		        			DEPARTAMENTO, 							"&
"			NVL(maucLN.mauc, 0) * ITRN.QTY			  			CMV_TOTAL,    							"&
"			ITRN.QTY								            QTD,          							"&
"			CASE WHEN 		                                                  							"&
"				NVL(FHLD.STATUS, 'WN')='WN'		                              							"&
"				THEN 'ENTRADA'		                                          							"&
"				ELSE 'SAIDA' END					          	SENTIDO,      							"&
"			ITRN.ADDWHO								            USUARIO,      							"&
"			NVL(FHLD.STATUS, 'WN')				        		NOME_DEPOSITO,							"&
"			NVL(FIHC.DESCRIPTION, 'Deposito WN')				TIPO_DEPOSITO,							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO_PARA, 						"&
"			TLOC.WHSEID								            FILIAL_PARA,							"&	
"			NVL(TIHC.DESCRIPTION, 'Deposito WN')	DEPOSITO_PAR										"&	
"	FROM WMWHSE6.ITRN				        ITRN														"&
"	INNER JOIN WMWHSE6.SKU				  SKU															"&
"					ON	SKU.SKU		=	ITRN.SKU														"&
"	INNER JOIN WMWHSE6.LOC					TLOC														"&
"					ON	TLOC.LOC	=	ITRN.TOLOC														"&	
"	LEFT JOIN (	SELECT 	A.LOC, A.status																	"& 
"				FROM WMWHSE6.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )   FHLD																	"&
"					ON	FHLD.LOC	=	ITRN.FROMLOC													"&
"	LEFT JOIN WMWHSE6.INVENTORYHOLDCODE	FIHC															"&
"					ON	FIHC.CODE	=	FHLD.STATUS														"&
"	LEFT JOIN (	SELECT 	A.LOC, A.status 																"&
"				FROM WMWHSE6.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )  			THLD														"&
"					ON	THLD.LOC	=	ITRN.TOLOC														"&
"	LEFT JOIN WMWHSE6.INVENTORYHOLDCODE	TIHC															"&
"					ON	TIHC.CODE	=	THLD.STATUS														"&
"	LEFT JOIN WMWHSE6.STORER 				STORER														"&
"					ON 	STORER.STORERKEY = sku.SUSR5													"& 
"					AND STORER.WHSEID = sku.WHSEID 														"&
"					AND STORER.TYPE = 5																	"&
"	LEFT JOIN 	ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU												"&
"					ON 	TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)						"&
"					AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)						"&
"	LEFT JOIN	ENTERPRISE.BILLOFMATERIAL	BOM															"&
"					ON	BOM.COMPONENTSKU	=	ITRN.SKU												"&
"	LEFT JOIN ENTERPRISE.CODELKUP  			cl 															"&
"					ON 	UPPER(cl.UDF1) = ITRN.WHSEID													"&
"					AND cl.LISTNAME = 'SCHEMA'															"&
"	LEFT JOIN ( SELECT  trim(whwmd217.t$item) item, whwmd217.t$cwar cwar,								"& 
"						CASE  WHEN SUM(NVL(whwmd217.t$mauc$1,0)) = 0     								"& 
"							  THEN SUM(whwmd217.t$ftpa$1)                								"& 
"						ELSE   ROUND(SUM(whwmd217.t$mauc$1) / SUM(a.t$qhnd), 4)							"& 
"						END mauc                                        								"&
"				FROM  baandb.twhwmd217301@pln01 whwmd217                								"& 
"				LEFT JOIN baandb.twhinr140301@pln01 a                   								"& 
"					 ON a.t$cwar = whwmd217.t$cwar                      								"& 
"					AND a.t$item = whwmd217.t$item                      								"& 
"				GROUP BY whwmd217.t$item, whwmd217.t$cwar, trim(whwmd217.t$item) ) 	maucLN				"&
"					ON 	maucLN.cwar = subStr(CL.DESCRIPTION,3,6)         								"& 
"					AND maucLN.item = CASE WHEN SKU.BOMITEMTYPE IN (3,4) 								"&
"								   THEN NVL(BOM.SKU, ITRN.SKU)											"&
"							  ELSE ITRN.sku END															"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialA													"&
"		 ON FilialA.UDF1 = ITRN.WHSEID																	"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialB													"&
"		 ON FilialB.UDF1 = TLOC.WHSEID																	"&
"	WHERE NVL(FHLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')													"&
"		  AND		NVL(THLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')										"&
"		  AND ITRN.TRANTYPE='MV'																		"&
"		  AND NVL(FHLD.STATUS, 'WN')!=NVL(THLD.STATUS, 'WN') 											"&
"		  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) 				"&
"       BETWEEN '"+ Parameters!DataDe.Value + "'                                           				"&
"           AND '"+ Parameters!DataAte.Value + "'										   				"&
"UNION																									"&
"	SELECT																	  							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO, 							"& 
"			CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) DT_MOVIMENTO,  "&
"			ITRN.WHSEID								            FILIAL,       							"&
"    		FilialA.UDF2              							NOME_FILIAL,							"&
"    		FilialB.UDF2              							NOME_FILIAL_PARA,						"&
"			ITRN.SKU								              ITEM,       							"&
"		  ( SELECT asku.altsku  		                                      							"&
"		  FROM WMWHSE4.altsku asku 		                                      							"&
"		  WHERE asku.sku = ITRN.sku 		                                  							"&
"		  AND ROWNUM = 1 )						        		EAN,          							"&
"			SKU.DESCR								            DESCR_SKU,    							"&
"			STORER.COMPANY							          	FORNECEDOR,   							"&
"			DEPARTSECTORSKU.DEPART_NAME		        			DEPARTAMENTO, 							"&
"			NVL(maucLN.mauc, 0) * ITRN.QTY			  			CMV_TOTAL,    							"&
"			ITRN.QTY								            QTD,          							"&
"			CASE WHEN 		                                                  							"&
"				NVL(FHLD.STATUS, 'WN')='WN'		                              							"&
"				THEN 'ENTRADA'		                                          							"&
"				ELSE 'SAIDA' END					          	SENTIDO,      							"&
"			ITRN.ADDWHO								            USUARIO,      							"&
"			NVL(FHLD.STATUS, 'WN')				        		NOME_DEPOSITO,							"&
"			NVL(FIHC.DESCRIPTION, 'Deposito WN')				TIPO_DEPOSITO,							"&
"			ITRN.ITRNKEY							            ID_MOVIMENTO_PARA, 						"&
"			TLOC.WHSEID								            FILIAL_PARA,							"&	
"			NVL(TIHC.DESCRIPTION, 'Deposito WN')	DEPOSITO_PAR										"&	
"	FROM WMWHSE7.ITRN				        ITRN														"&
"	INNER JOIN WMWHSE7.SKU				  SKU															"&
"					ON	SKU.SKU		=	ITRN.SKU														"&
"	INNER JOIN WMWHSE7.LOC					TLOC														"&
"					ON	TLOC.LOC	=	ITRN.TOLOC														"&	
"	LEFT JOIN (	SELECT 	A.LOC, A.status																	"& 
"				FROM WMWHSE7.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )   FHLD																	"&
"					ON	FHLD.LOC	=	ITRN.FROMLOC													"&
"	LEFT JOIN WMWHSE7.INVENTORYHOLDCODE	FIHC															"&
"					ON	FIHC.CODE	=	FHLD.STATUS														"&
"	LEFT JOIN (	SELECT 	A.LOC, A.status 																"&
"				FROM WMWHSE7.INVENTORYHOLD A															"& 
"				WHERE hold = 1																			"& 
"				AND loc <> ' ' )  			THLD														"&
"					ON	THLD.LOC	=	ITRN.TOLOC														"&
"	LEFT JOIN WMWHSE7.INVENTORYHOLDCODE	TIHC															"&
"					ON	TIHC.CODE	=	THLD.STATUS														"&
"	LEFT JOIN WMWHSE7.STORER 				STORER														"&
"					ON 	STORER.STORERKEY = sku.SUSR5													"& 
"					AND STORER.WHSEID = sku.WHSEID 														"&
"					AND STORER.TYPE = 5																	"&
"	LEFT JOIN 	ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU												"&
"					ON 	TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)						"&
"					AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)						"&
"	LEFT JOIN	ENTERPRISE.BILLOFMATERIAL	BOM															"&
"					ON	BOM.COMPONENTSKU	=	ITRN.SKU												"&
"	LEFT JOIN ENTERPRISE.CODELKUP  			cl 															"&
"					ON 	UPPER(cl.UDF1) = ITRN.WHSEID													"&
"					AND cl.LISTNAME = 'SCHEMA'															"&
"	LEFT JOIN ( SELECT  trim(whwmd217.t$item) item, whwmd217.t$cwar cwar,								"& 
"						CASE  WHEN SUM(NVL(whwmd217.t$mauc$1,0)) = 0     								"& 
"							  THEN SUM(whwmd217.t$ftpa$1)                								"& 
"						ELSE   ROUND(SUM(whwmd217.t$mauc$1) / SUM(a.t$qhnd), 4)							"& 
"						END mauc                                         								"&
"				FROM  baandb.twhwmd217301@pln01 whwmd217                 								"& 
"				LEFT JOIN baandb.twhinr140301@pln01 a                    								"& 
"					 ON a.t$cwar = whwmd217.t$cwar                       								"& 
"					AND a.t$item = whwmd217.t$item                       								"& 
"				GROUP BY whwmd217.t$item, whwmd217.t$cwar, trim(whwmd217.t$item) ) 	maucLN				"&
"					ON 	maucLN.cwar = subStr(CL.DESCRIPTION,3,6)         								"& 
"					AND maucLN.item = CASE WHEN SKU.BOMITEMTYPE IN (3,4) 								"&
"								   THEN NVL(BOM.SKU, ITRN.SKU)											"&
"							  ELSE ITRN.sku END															"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialA													"&
"		 ON FilialA.UDF1 = ITRN.WHSEID																	"&
"	INNER JOIN ( select A.LONG_VALUE,																	"&
"				  UPPER(A.UDF1) UDF1,																	"&
"				  A.UDF2																				"&
"				from ENTERPRISE.CODELKUP A																"&
"				where A.LISTNAME = 'SCHEMA') FilialB													"&
"		 ON FilialB.UDF1 = TLOC.WHSEID																	"&
"	WHERE NVL(FHLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')													"&
"		  AND		NVL(THLD.STATUS, 'WN') IN ('WN', 'WA', 'WR')										"&
"		  AND ITRN.TRANTYPE='MV'																		"&
"		  AND NVL(FHLD.STATUS, 'WN')!=NVL(THLD.STATUS, 'WN') 											"&
"		  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ITRN.ADDDATE, 'DD-MON-YYYY HH24:MI:SS'),  				"&
"    		  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) 				"&
"       BETWEEN '"+ Parameters!DataDe.Value + "'                                           				"&
"           AND '"+ Parameters!DataAte.Value + "'										  	 			"
)