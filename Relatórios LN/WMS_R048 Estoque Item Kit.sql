SELECT  LL.WHSEID							ID_PLANTA,
		CL.UDF2								DESCR_PLANTA,
		BM.SKU								TIK_PAI, 
		PS.DESCR							TIK_PAI_DESCR,
        BM.COMPONENTSKU						TIK_FILHO, 
		FS.DESCR							TIK_FILHO_DESCR,
		IH.STATUS							RESTRICAO,
        SUM(LL.QTY)							QTD,
		( select asku.altsku 
		from WMWHSE5.altsku asku
		where asku.sku = BM.SKU
		and rownum = 1 )                	EAN_PAI,
		( select asku.altsku 
		from WMWHSE5.altsku asku
		where asku.sku = BM.COMPONENTSKU
		and rownum = 1 )                	EAN_FILHO,		
		LC.PUTAWAYZONE						CLASSE_LOCAL,
		LC.LOC								LOCAL,
		PZ.DESCR							DESCR_LOCAL,

		nvl(max(maucLN.mauc),0)*
			sum(LL.qty)                 	VALOR,

		
		SUM(FS.STDCUBE*LL.qty)				CUBAGEM
		
FROM 		WMWHSE5.BILLOFMATERIAL 	BM 
INNER JOIN 	WMWHSE5.LOTXLOCXID LL		ON 	LL.SKU			=	BM.COMPONENTSKU
INNER JOIN	WMWHSE5.SKU PS				ON  PS.SKU			=	BM.SKU
INNER JOIN	WMWHSE5.SKU	FS				ON	FS.SKU			=	BM.COMPONENTSKU
INNER JOIN	WMWHSE5.LOC	LC				ON	LC.LOC			=	LL.LOC
LEFT JOIN	WMWHSE5.INVENTORYHOLD IH	ON	IH.LOC			=	LL.LOC
										AND IH.HOLD 		=	1
										AND	IH.LOC			<>	' '
LEFT JOIN	WMWHSE5.PUTAWAYZONE PZ		ON 	PZ.PUTAWAYZONE 	=	LC.PUTAWAYZONE
LEFT JOIN 	ENTERPRISE.CODELKUP CL 		ON 	UPPER(cl.UDF1) 	= 	LL.WHSEID
										AND CL.LISTNAME = 'SCHEMA'
 LEFT JOIN ( select trim(whwmd217.t$item) item, whwmd217.t$cwar cwar, 
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
										AND maucLN.item = PS.SKU
GROUP BY 	LL.WHSEID,
          CL.UDF2,
            BM.SKU, 
            PS.DESCR,
            BM.COMPONENTSKU, 
            FS.DESCR,
            IH.STATUS,               
            LC.PUTAWAYZONE,					
            LC.LOC,							
            PZ.DESCR