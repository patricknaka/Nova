select
    REC947.OC                     ORDEM_COMPRA,
    tdrec940.t$fire$l             REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)    
                                  DATA_APROVACAO_FISCAL,
    Trim(whinh301.t$item)         ITEM,
    tcibd001.t$dscb$c             DESC_ITEM,
    whinh301.t$rqua               RECEB_FISICO_ITEM,
    REC941.QTDE                   TOTAL_RECEB_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whinh300.t$crdt, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)    
                                  DATA_RECEB_FISICO_LN,
    INH301.QTDE                   TOTAL_RECEB_FISICO_REF_FISCAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WMS_RECEIPT.CLOSEDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                  DATA_ASN_WMS,
    WMS_ITRN.EFFECTIVEDATE        DATA_ARMAZENAGEM_WMS
    
FROM  baandb.ttdrec940601 tdrec940

 LEFT JOIN ( select a.t$fire$l,
                    sum(a.t$qnty$l) QTDE
               from baandb.ttdrec941601 a
           group by a.t$fire$l ) REC941
       ON REC941.t$fire$l = tdrec940.t$fire$l
         
 LEFT JOIN baandb.twhinh300601 whinh300
        ON whinh300.t$fire$c = tdrec940.t$fire$l
        
 LEFT JOIN baandb.twhinh301601 whinh301
        ON whinh301.t$sfbp = whinh300.t$sfbp
       AND whinh301.t$shid = whinh300.t$shid

INNER JOIN BAANDB.TTCIBD001601 TCIBD001 
        ON TCIBD001.T$ITEM  = WHINH301.T$ITEM     
        
 LEFT JOIN ( select a.t$sfbp,
                    a.t$shid,
                    sum(t$rqua) QTDE
               from baandb.twhinh301601 a
           group by a.t$sfbp,
                    a.t$shid ) INH301
        ON INH301.t$sfbp = whinh300.t$sfbp
       AND INH301.t$shid = whinh300.t$shid

 LEFT JOIN ( select a.t$fire$l,
                    a.t$orno$l OC
               from baandb.ttdrec947601 a
           group by a.t$fire$l, 
                    a.t$orno$l ) REC947
        ON REC947.t$fire$l = tdrec940.t$fire$l

LEFT JOIN ( select a.RECEIPTKEY,
                   a.EXTERNRECEIPTKEY,
		   a.CLOSEDDATE
            from  WMWHSE9.RECEIPT@DL_LN_WMS  a
            group by a.RECEIPTKEY,
                     a.EXTERNRECEIPTKEY,
		     a.CLOSEDDATE) WMS_RECEIPT
       ON WMS_RECEIPT.EXTERNRECEIPTKEY='0'||'_'||TRIM(whinh300.t$sfbp)||'_'||TRIM(whinh300.t$shid)||'_'||TRIM(whinh300.t$cwar)
      
LEFT JOIN ( select a.RECEIPTKEY,
                   a.SKU,
                   a.ID,
                   a.DATERECEIVED,
                   sum(a.QTYRECEIVED) QTDE       
            from  WMWHSE9.RECEIPTDETAIL@DL_LN_WMS  a
            group by a.RECEIPTKEY,
                     a.EXTERNRECEIPTKEY,
                     a.SKU,
                     a.ID,
                     a.DATERECEIVED) WMS_REC_DETAIL
       ON WMS_REC_DETAIL.RECEIPTKEY = WMS_RECEIPT.RECEIPTKEY
      AND TRIM(WMS_REC_DETAIL.SKU) = TRIM(whinh301.t$item)
 
LEFT JOIN ( select a.SKU,
                   a.FROMID,
                   a.FROMLOC,
                   a.TRANTYPE,
                   a.EFFECTIVEDATE
            from  WMWHSE9.ITRN@DL_LN_WMS a ) WMS_ITRN
      ON WMS_ITRN.SKU = WMS_REC_DETAIL.SKU
     AND WMS_ITRN.FROMID = WMS_REC_DETAIL.ID
     AND WMS_ITRN.TRANTYPE = 'MV'
     AND WMS_ITRN.FROMLOC = 'STAGE'

WHERE tdrec940.t$stat$l IN (4, 5)  --aprovada-4, aprovada com problemas-5
  AND Trim(tdrec940.t$cnfe$l) is not null
--  AND tdrec940.t$rfdt$l = 1       --compra com pedido
  AND whinh301.t$rqua != 0
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataAprovacaoDe
          And :DataAprovacaoAte
  AND Trim(whinh301.t$item) in (:Item)

ORDER BY REF_FISCAL, ITEM


