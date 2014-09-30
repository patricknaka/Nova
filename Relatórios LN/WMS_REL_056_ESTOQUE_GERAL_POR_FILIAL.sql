SELECT  DISTINCT
    SKUXLOC.SKU                             ID_ITEM,
    SKU.DESCR                               NOME,
    SKU.ACTIVE                              ITEG_SITUACAO,
    ENT_SKU.ID_DEPART                       COD_DEPTO,
    ENT_SKU.DEPART_NAME                     DEPTO,
    ENT_SKU.ID_SECTOR                       COD_SETOR,
    ENT_SKU.SECTOR_NAME                     SETOR,
    LN_ITEM.T$FAMI$C                        COD_FAMILIA,
    LN_ITEM.DS_FAMI                         FAMILIA,
    LN_ITEM.T$SUBF$C                        COD_SUB,
    LN_ITEM.DS_SUBF                         SUB,
    cl.UDF2                 				ID_FILIAL,
    SUM(SKUXLOC.QTY)                        QT_FISICA,
    nvl((	SELECT SUM(OD.QTYALLOCATED) 
			FROM WMWHSE5.orderdetail OD
			WHERE OD.SKU=SKUXLOC.SKU
			AND OD.STATUS>='29' 
			AND OD.STATUS<='94'),0) 			QT_ROMANEADA,
    SUM(SKUXLOC.QTYALLOCATED)               QT_RESERVADA,
    SUM(SKUXLOC.QTY - SKUXLOC.QTYALLOCATED) QT_SALDO,
	nvl(max(maucLN.mauc),0)					VL_UNITARIO,
    SKU.SUSR5                               ID_FORNECEDOR,
    STORER.COMPANY                          FORN_NOME
FROM 
	WMWHSE5.SKU 								
	INNER JOIN ENTERPRISE.CODELKUP cl 					ON  UPPER(cl.UDF1)=sku.WHSEID
														AND cl.LISTNAME = 'SCHEMA'
	INNER JOIN	WMWHSE5.SKUXLOC							ON 	SKUXLOC.SKU=SKU.SKU
														AND	SKUXLOC.WHSEID=SKU.WHSEID
	LEFT JOIN									  
	(SELECT IBD001.T$ITEM, IBD001.T$FAMI$C, IBD001.T$SUBF$C, MCS031.T$DSCA$C DS_FAMI, MCS032.T$DSCA$C DS_SUBF													
	 FROM BAANDB.TTCIBD001301@pln01 IBD001			--ON 	RTRIM(LTRIM(IBD001.T$ITEM)) = SKUXLOC.SKU
  	 LEFT JOIN BAANDB.TZNMCS031301@pln01 MCS031 		ON  MCS031.T$FAMI$C = IBD001.T$FAMI$C
														AND	MCS031.T$CITG$C = IBD001.T$CITG
														AND	MCS031.T$SETO$C = IBD001.T$SETO$C
  	 LEFT JOIN BAANDB.TZNMCS032301@pln01 MCS032   		ON  MCS032.T$SUBF$C = IBD001.T$SUBF$C
														AND	MCS032.T$CITG$C = IBD001.T$CITG
														AND	MCS032.T$SETO$C = IBD001.T$SETO$C
														AND MCS032.T$FAMI$C = IBD001.T$FAMI$C) LN_ITEM
														ON	TRIM(LN_ITEM.T$ITEM)=SKU.SKU

	LEFT JOIN                                  
	  (select    trim(whina113.t$item) item,
				whina113.t$cwar cwar,
				sum(whina113.t$mauc$1) mauc
	  from      BAANDB.Twhina113301@pln01 whina113
	  where (whina113.t$trdt, whina113.t$seqn)=(select max(b.t$trdt), max(b.t$seqn) 
										from BAANDB.Twhina113301@pln01 b
										where b.t$item=whina113.t$item
										and   b.t$cwar=whina113.t$cwar
										and   b.t$trdt=(select max(c.t$trdt) from BAANDB.Twhina113301@pln01 c
														where c.t$item=b.t$item
														and   c.t$cwar=b.t$cwar))                                    
	group by  whina113.t$item,
			  whina113.t$cwar) maucLN   ON  maucLN.cwar=subStr(cl.DESCRIPTION,3,6)
										AND maucLN.item=sku.sku


														
														AND SKU.WHSEID=SKUXLOC.WHSEID	
	LEFT JOIN ENTERPRISE.DEPARTSECTORSKU ENT_SKU 		ON 	TO_CHAR(ENT_SKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)
														AND TO_CHAR(ENT_SKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)




    LEFT JOIN WMWHSE5.STORER 	ON	STORER.STORERKEY = SKU.SUSR5
								AND STORER.WHSEID=SKU.WHSEID AND STORER.TYPE=5
	--where sku.sku BETWEEN '242000' AND '243999'

GROUP BY
			SKUXLOC.SKU,         
            SKU.DESCR,          
            SKU.ACTIVE,          
            ENT_SKU.ID_DEPART,   
            ENT_SKU.DEPART_NAME,
            ENT_SKU.ID_SECTOR,   
            ENT_SKU.SECTOR_NAME, 
            LN_ITEM.T$FAMI$C,    
            LN_ITEM.DS_FAMI,     
            LN_ITEM.T$SUBF$C,    
            LN_ITEM.DS_SUBF,
			cl.UDF2,
			SKU.SUSR5,
			STORER.COMPANY
--ORDER BY 1
