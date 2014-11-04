SELECT
				min(rd.DATERECEIVED)						REDO_DT_ENTRADA,
				rd.RECEIPTKEY						ASN,
				CASE WHEN SKU.SUSR8 = 'MINUCIOSO' 
					THEN 'SIM' 
					ELSE 'NÃO' END					IN_MINUCIOSO,
				tpnt.DESCRIPTION					TP_NOTA,
				stnt.DESCRIPTION					SITUACAO,
				rc.TRAILERNUMBER					ID_CAMINHAO,
				rc.TRAILERKEY						PLACA_VEICULO,
				rc.DOOR								LOCAL_DESCR,
				COUNT(DISTINCT rd.SUSR1)			NUM_NFS,
				sum(rd.QTYEXPECTED-rd.QTYRECEIVED)	QT_A_REC,
				SUM(rd.QTYRECEIVED)					QT_REC
FROM
					WMWHSE5.RECEIPTDETAIL rd
		INNER JOIN	WMWHSE5.SKU sku			ON 	sku.SKU = rd.SKU
		INNER JOIN	WMWHSE5.RECEIPT rc		ON 	rc.RECEIPTKEY = rd.RECEIPTKEY
		LEFT JOIN	( select clkp.code         COD, 
                    trans.description
                from WMWHSE5.codelkup clkp
                inner join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
                where clkp.listname = 'RECEIPTYPE'
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
                and Trim(clkp.code) is not null ) tpnt	ON 	TO_CHAR(tpnt.COD) = TO_CHAR(rc.TYPE)
		LEFT JOIN	( select clkp.code         COD, 
                    trans.description
                from WMWHSE5.codelkup clkp
                inner join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
                where clkp.listname = 'RECSTATUS'
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
                and Trim(clkp.code) is not null )stnt	ON 	TO_CHAR(stnt.COD) = TO_CHAR(rc.STATUS)

		INNER JOIN	ENTERPRISE.CODELKUP pl	ON	UPPER(pl.UDF1) = rd.WHSEID
											AND	pl.LISTNAME = 'SCHEMA'
WHERE	TO_NUMBER(rc.STATUS) < 9 
GROUP BY
--	rd.DATERECEIVED,							
    rd.RECEIPTKEY,						
    CASE WHEN SKU.SUSR8 = 'MINUCIOSO' 
    	THEN 'SIM' 
    	ELSE 'NÃO' END,					
    tpnt.DESCRIPTION,					
    stnt.DESCRIPTION,					
    rc.TRAILERNUMBER,					
    rc.TRAILERKEY,						
    rc.DOOR			