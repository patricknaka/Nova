SELECT pl.UDF2                             	PLANTA, 
	STORER.COMPANY			FORNECEDOR,
	DEPARTSECTORSKU.DEPART_NAME  DEPARTAMENTO,
	DEPARTSECTORSKU.SECTOR_NAME   SETOR,
	min(rd.DATERECEIVED)                	REDO_DT_ENTRADA,
	rd.RECEIPTKEY                       	ASN,
	CASE WHEN SKU.SUSR8 = 'MINUCIOSO' 
              THEN 'SIM' 
            ELSE   'NÃO' 
        END                                		IN_MINUCIOSO,
	tpnt.DESCRIPTION                    	TP_NOTA,
	stnt.DESCRIPTION                    	SITUACAO,
	rc.TRAILERKEY                       	ID_CAMINHAO,
	rc.TRAILERNUMBER                    	PLACA_VEICULO,
	rc.DOOR                             		LOCAL_DESCR,
	COUNT(DISTINCT rd.SUSR1)           NUM_NFS,
	SUM(rd.QTYEXPECTED-rd.QTYRECEIVED)  QT_A_REC,
	SUM(rd.QTYRECEIVED)                 QT_REC
	   
FROM       WMWHSE5.RECEIPTDETAIL rd

INNER JOIN WMWHSE5.SKU sku
        ON sku.SKU = rd.SKU

 LEFT JOIN WMWHSE5.STORER 
        ON STORER.STORERKEY = sku.SUSR5 
       AND STORER.WHSEID = sku.WHSEID 
       AND STORER.TYPE = 5
       
 LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPARTSECTORSKU
        ON TO_CHAR(DEPARTSECTORSKU.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)
       AND TO_CHAR(DEPARTSECTORSKU.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)

INNER JOIN WMWHSE5.RECEIPT rc
        ON rc.RECEIPTKEY = rd.RECEIPTKEY
		
 LEFT JOIN ( select clkp.code         COD, 
                    trans.description
               from WMWHSE5.codelkup clkp
         inner join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
              where clkp.listname = 'RECEIPTYPE'
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
                and Trim(clkp.code) is not null ) tpnt
        ON TO_CHAR(tpnt.COD) = TO_CHAR(rc.TYPE)
		
 LEFT JOIN ( select clkp.code         COD, 
                    trans.description
               from WMWHSE5.codelkup clkp
         inner join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
              where clkp.listname = 'RECSTATUS'
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
                and Trim(clkp.code) is not null ) stnt 
        ON TO_CHAR(stnt.COD) = TO_CHAR(rc.STATUS)

INNER JOIN ENTERPRISE.CODELKUP pl 
        ON UPPER(pl.UDF1) = rd.WHSEID
       AND pl.LISTNAME = 'SCHEMA'
	   
WHERE TO_NUMBER(rc.STATUS) < 9 

GROUP BY pl.UDF2,
	STORER.COMPANY,
	DEPARTSECTORSKU.DEPART_NAME,
	DEPARTSECTORSKU.SECTOR_NAME,
         rd.RECEIPTKEY,
         CASE WHEN SKU.SUSR8 = 'MINUCIOSO' 
                THEN 'SIM' 
              ELSE 'NÃO' 
          END,     
         tpnt.DESCRIPTION,     
         stnt.DESCRIPTION,     
         rc.TRAILERNUMBER,     
         rc.TRAILERKEY,      
         rc.DOOR   
