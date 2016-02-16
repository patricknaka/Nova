
	select q1.REQ, Q1.ITEM, Q1.DESCRICAO,

		SUM(Q1.QTY_CONTADA) 			AS QTY_CONTADA, 
		SUM(Q1.QTY_SISTEMA) 			AS QTY_SISTEMA, 
		
		abs(SUM(nvl(Q1.QTY_SISTEMA,0 )) - 
			SUM(nvl(Q1.QTY_CONTADA, 0)))	AS VAR_QTDE,
		abs(SUM(nvl(Q1.QTY_SISTEMA,0 )) * 
			sum(nvl(maucLN.mauc, 0))) 			AS VL_LOGICO,
		(SUM(nvl(Q1.QTY_SISTEMA,0 )) + SUM(nvl(Q1.QTY_CONTADA, 0))) *
				sum(nvl(maucLN.mauc, 0))		AS VL_FISICO,
		abs(SUM(nvl(Q1.QTY_SISTEMA,0 )) - SUM(nvl(Q1.QTY_CONTADA, 0))) * 
				sum(maucLN.mauc) 			AS VL_DIVERGENCIA, 
		
		SUM(Q1.DIFERENCA) 				AS DIFERENCA
	  from 
		 (select q0.*, 
				 ROW_NUMBER() OVER 
							 ( PARTITION BY q0.LOCAL,
											q0.ITEM
								   ORDER BY q0.local, q0.ITEM, q0.SERIALKEY desc)  RN

			from
				(SELECT DISTINCT  GRD.SERIALKEY, 
						GRD.REQUESTNUMBER AS REQ, 
						TO_CHAR(GRD.SKU) AS ITEM, TO_CHAR(SKU.DESCR) AS DESCRICAO, 
						TO_CHAR(GRD.LOCATION) AS LOCAL, 
						TO_NUMBER(GRD.COUNTQTY) AS QTY_CONTADA, 
						TO_NUMBER(GRD.SYSTEMQTY) AS QTY_SISTEMA,
						TO_NUMBER(GRD.COUNTQTY-GRD.SYSTEMQTY) AS DIFERENCA
				   FROM  WMWHSE5.GLOBALINVREQUESTDETAIL GRD,  WMWHSE5.GLOBALINVCOUNTDETAIL GCD,  WMWHSE5.SKU SKU
				  WHERE GRD.SYSTEMQTY >=0
					AND GRD.SKU = SKU.SKU
					AND GCD.REQUESTNUMBER = GRD.REQUESTNUMBER
					AND GCD.LOCATION = GRD.LOCATION
					AND GCD.STATUS IN ('02','04','05','06','08')
					AND (GRD.SYSTEMQTY > '0' AND GRD.COUNTQTY > '0')
				 ) q0
		  ) q1

	LEFT JOIN	BAANDB.TTCIBD001301@PLN01 TCIBD001 
		ON	TRIM(TCIBD001.T$ITEM) = q1.ITEM
		
	LEFT JOIN ( 	SELECT 	trim(whwmd217.t$item) 	item,                             
						whwmd217.t$cwar      		 cwar,                                   
						case when sum(a.t$qhnd) = 0                             
						then 0                                                 
						else round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)    
						end                  			mauc                                                
				FROM 	baandb.twhwmd217301@PLN01 whwmd217                      
				INNER JOIN baandb.twhinr140301@PLN01 a                             
					ON 	 a.t$cwar = whwmd217.t$cwar                              
					AND 	 a.t$item = whwmd217.t$item                              
				WHERE 	whwmd217.t$mauc$1 != 0                                  
				GROUP BY whwmd217.t$item, 
						whwmd217.t$cwar ) 		maucLN                                          
		ON	maucLN.item = q1.ITEM

	  where q1.RN = '1'

	GROUP BY q1.REQ, Q1.ITEM, Q1.DESCRICAO