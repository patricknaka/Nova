SELECT
		IT.SKU											ID,
		SK.DESCR										PRODUTO,
		CASE WHEN IT.STORERKEY=301 THEN 'P'
		ELSE 'T' END									TIPO_PROP,
		IT.QTY											QTD,
		IT.QTY*NVL(maucLN.MAUC,0)						VALOR,
		CASE WHEN IT.QTY<0 THEN 'S'
		ELSE 'E' END									ENT_SAI,
		CASE WHEN IT.QTY<0 THEN 301
		ELSE 302 END									LOGICA,		
		IT.EDITWHO										USUARIO,
		CASE WHEN IT.SOURCETYPE='ntrAdjustmentDetailAdd'
			THEN 'AJUSTE'
		ELSE TO_CHAR(CT.DESCRIPTION)	END				TIPO_MOVIMENTO,
		IT.EDITDATE										MOES_DT_MOVIMENTO,
		SK.SKUGROUP										DEP

FROM
		WMWHSE5.ITRN IT
		INNER JOIN	WMWHSE5.SKU	SK		ON	SK.SKU		=	IT.SKU

		LEFT JOIN ENTERPRISE.CODELKUP CL
										ON UPPER(cl.UDF1) = IT.WHSEID
										AND CL.LISTNAME = 'SCHEMA'		
		
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
										ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         
										AND maucLN.item = IT.SKU 
		LEFT JOIN 	WMWHSE5.CC CC		ON	CC.CCKEY	=	IT.SOURCEKEY
		LEFT JOIN	WMWHSE5.CODELKUP CT	ON	CT.CODE		=	CC.CCADJREASON
WHERE	IT.SOURCETYPE!='ntrAdjustmentDetailUnreceive'	
AND 	IT.TRANTYPE='AJ'	