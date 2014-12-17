SELECT
		CC.CCKEY							ID_INVENTARIO,
		CD.LOC								ID_LOCAL,
		LC.PUTAWAYZONE						ENDERECO,
		CD.SKU								ITEM_WMS,
		TCIBD001.T$ITEM						ITEM_LN,
		SK.DESCR							NOME_ITEM,
		( select asku.altsku 	
		  from WMWHSE5.altsku asku	
		  where asku.sku = cd.sku	
		  and rownum = 1 )           		EAN,		  
		CD.SYSQTY							QT_LOGICA,
		CD.SYSQTY+CD.ADJQTY					QT_FISICA,
		CD.ADJQTY							VAR_QTDE,
		CD.SYSQTY*maucLN.mauc				VL_LOGICO,
		(CD.SYSQTY+CD.ADJQTY)*maucLN.mauc	VL_FISICO,
		CD.ADJQTY*maucLN.mauc				VL_DIVERGENCIA,
		' '									SIMULACAO,										--PENDENTE DE CUSTOMIZAÇÃO
		CC.WHSEID							ID_PLANTA,
		CL.UDF2								NOME_PLANTA		
FROM
					WMWHSE5.CC			CC
		INNER JOIN	WMWHSE5.CCDETAIL	CD	ON	CD.CCKEY		=	CC.CCKEY
		INNER JOIN 	ENTERPRISE.CODELKUP CL 	ON 	UPPER(CL.UDF1) 	= 	CC.WHSEID
											AND CL.LISTNAME 	= 	'SCHEMA'		
		INNER JOIN	WMWHSE5.LOC			LC	ON	LC.LOC			=	CD.LOC
		INNER JOIN	WMWHSE5.SKU			SK	ON	SK.SKU			=	CD.SKU
		INNER JOIN	BAANDB.TTCIBD001301@PLN01 TCIBD001 ON TRIM(TCIBD001.T$ITEM) = CD.SKU
		LEFT JOIN ( select trim(whwmd217.t$item) item,                             
							whwmd217.t$cwar cwar,                                   
							case when sum(a.t$qhnd) = 0                             
							 then 0                                                 
							 else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)    
							end mauc                                                
					   from baandb.twhwmd217301@pln01 whwmd217                      
				 inner join baandb.twhinr140301@pln01 a                             
						 on a.t$cwar = whwmd217.t$cwar                              
						and a.t$item = whwmd217.t$item                              
					  where whwmd217.t$mauc$1 != 0                                  
				   group by whwmd217.t$item,                                        
							whwmd217.t$cwar ) maucLN                                 
											ON 	maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         
											AND maucLN.item = CD.SKU
WHERE
		CC.STATUS<9
		
UNION

SELECT
		' '							ID_INVENTARIO,
		CD.LOC								ID_LOCAL,
		LC.PUTAWAYZONE						ENDERECO,
		CD.SKU								ITEM_WMS,
		TCIBD001.T$ITEM						ITEM_LN,
		SK.DESCR							NOME_ITEM,
		( select asku.altsku 	
		  from WMWHSE4.altsku asku	
		  where asku.sku = cd.sku	
		  and rownum = 1 )           		EAN,		  
		  LL.QTY							QT_LOGICA,
      CD.QTY					      QT_FISICA,
      CD.QTY - LL.QTY							VAR_QTDE,
		  LL.QTY*maucLN.mauc				VL_LOGICO,
      CD.QTY*maucLN.mauc	        VL_FISICO,
      (CD.QTY - LL.QTY)*maucLN.mauc				VL_DIVERGENCIA,
		' '									SIMULACAO,										--PENDENTE DE CUSTOMIZAÇÃO
		CD.WHSEID							ID_PLANTA,
		CL.UDF2								NOME_PLANTA		
FROM
					WMWHSE4.PHYSICAL	CD
		INNER JOIN 	ENTERPRISE.CODELKUP CL 	ON 	UPPER(CL.UDF1) 	= 	CD.WHSEID
											AND CL.LISTNAME 	= 	'SCHEMA'		
		INNER JOIN	WMWHSE4.LOC			LC	ON	LC.LOC			=	CD.LOC
		INNER JOIN	WMWHSE4.SKU			SK	ON	SK.SKU			=	CD.SKU
		INNER JOIN	BAANDB.TTCIBD001201@DLN01 TCIBD001 ON TRIM(TCIBD001.T$ITEM) = CD.SKU
    LEFT JOIN   WMWHSE4.LOTXLOCXID LL ON  LL.LOT = CD.LOT
                                      AND LL.LOC = CD.LOC
                                      AND LL.ID = CD.ID
                                      AND LL.SKU = CD.SKU
    
    
		LEFT JOIN ( select trim(whwmd217.t$item) item,                             
							whwmd217.t$cwar cwar,                                   
							case when sum(a.t$qhnd) = 0                             
							 then 0                                                 
							 else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)    
							end mauc                                                
					   from baandb.twhwmd217201@DLN01 whwmd217                      
				 inner join baandb.twhinr140201@DLN01 a                             
						 on a.t$cwar = whwmd217.t$cwar                              
						and a.t$item = whwmd217.t$item                              
					  where whwmd217.t$mauc$1 != 0                                  
				   group by whwmd217.t$item,                                        
							whwmd217.t$cwar ) maucLN                                 
											ON 	maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         
											AND maucLN.item = CD.SKU