SELECT
		LLID.LOC							ID_LOCAL,
		PTWZ.DESCR							DESCR_LOCAL,			
		SUM(LLID.QTY)						ESTO_QT,		
		LOCA.STATUS							ESTO_SIT,
		LLID.SKU							ID_ITEM,
		STOR.COMPANY                       	FORNECEDOR,
		SKUT.DESCR							DESCR_ITEM,
		TSKD.ASSIGNMENTNUMBER				PROGRAMA,
		TSKD.WAVEKEY						ONDA,
		SUM(ORDT.ORIGINALQTY)					QTY_ROMANEADA,
		SUM(LLID.QTY - LLID.QTYPICKED)		QTY_CANCELA
		

FROM
		WMWHSE5.LOTXLOCXID	LLID
		LEFT JOIN (	select a.LOT,	
		                   a.SKU,    
		                   a.TOLOC, 
		                   a.TOID,	
		                   a.SOURCEKEY
					from WMWHSE5.ITRN a
					WHERE a.TRANTYPE	=	'MV'	
					and   a.SOURCETYPE  =	'PICKING'
					and   a.SERIALKEY	=	(select max(b.SERIALKEY)
											 from WMWHSE5.ITRN b
											 where b.LOT		= a.LOT		
											 and   b.SKU        = a.SKU       
											 and   b.TOLOC      = a.TOLOC     
											 and   b.TOID       = a.TOID      
											 and   b.TRANTYPE   = a.TRANTYPE  
											 and   b.SOURCETYPE	= a.SOURCETYPE)) ITRN
												ON	ITRN.LOT				=	LLID.LOT
												AND ITRN.SKU                =	LLID.SKU
												AND ITRN.TOLOC              =	LLID.LOC
												AND	ITRN.TOID		        = 	LLID.ID

		
		LEFT JOIN	WMWHSE5.TASKDETAIL	TSKD	ON	TSKD.SOURCEKEY			=	ITRN.SOURCEKEY
												AND TSKD.SOURCETYPE			= 	'PICKDETAIL'
												AND	TSKD.STATUS				=	'9'
												AND	TSKD.TASKTYPE			=	'PK'
												AND	TSKD.TOLOC				=	ITRN.TOLOC
		
		
		LEFT JOIN	WMWHSE5.LOC			LOCA	ON	LOCA.LOC				=	LLID.LOC
		LEFT JOIN	WMWHSE5.SKU			SKUT	ON	SKUT.SKU				=	LLID.SKU
		LEFT JOIN	WMWHSE5.ORDERDETAIL	ORDT	ON	ORDT.ORDERKEY			=	TSKD.ORDERKEY
												AND	ORDT.ORDERLINENUMBER	=	TSKD.ORDERLINENUMBER
		LEFT JOIN	WMWHSE5.PUTAWAYZONE PTWZ	ON	PTWZ.PUTAWAYZONE		=	LOCA.PUTAWAYZONE
		LEFT JOIN	WMWHSE5.STORER		STOR	ON	STOR.STORERKEY			=	SKUT.SUSR5
												AND	STOR.WHSEID				=	SKUT.WHSEID
												AND STOR.TYPE 				= 	5
										
WHERE
			LLID.QTY>0
		AND	LLID.QTYPICKED<LLID.QTY
		AND LLID.LOC = 'PICKTO'
GROUP BY

        LLID.LOC,						
        PTWZ.DESCR,										
        LOCA.STATUS,				
        LLID.SKU,						
        STOR.COMPANY,                  
        SKUT.DESCR,						
        TSKD.ASSIGNMENTNUMBER,			
        TSKD.WAVEKEY	
order by 5