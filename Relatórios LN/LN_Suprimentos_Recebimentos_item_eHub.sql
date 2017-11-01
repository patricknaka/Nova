 
=
"select REC947.OC                     ORDEM_COMPRA,  " &
"       tdrec940.t$fire$l             REF_FISCAL,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$adat$l,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"         AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_APROVACAO_FISCAL,  " &
"       Trim(whinh301.t$item)         ITEM,  " &
"       tcibd001.t$dscb$c             DESC_ITEM,  " &
"       whinh301.t$rqua               RECEB_FISICO_ITEM,  " &
"       REC941.QTDE                   TOTAL_RECEB_FISCAL,  " &
"       WHINH300.T$ASNR               NOTA_FISCAL,  " &
"       WMS_RECEIPT.RECEIPTKEY        ASN,  " &
"       Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whinh300.t$crdt,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                  AT time zone 'America/Sao_Paulo') AS DATE))  " &
"                                     DATA_ASN,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WMS_RECEIPT.CLOSEDDATE,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"         AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_WMS_COCKPIT,  " &
"       INH301.QTDE                   TOTAL_RECEB_FISICO_REF_FISCAL,  " &
"  " &
"       WMS_REC_DETAIL.QTDE           QTDE_ARMAZENADA_ITEM,  " &
"       WMS_REC_DETAIL.DATERECEIVED   DATA_ARMAZENAGEM_WMS,  " &
"  " &
"       tcibd001.t$mdfb$c             MOD_FAB_ITEM  " &
"  " &
"FROM baandb.ttdrec940" + Parameters!Compania.Value + "  tdrec940  " &
"  " &
"left JOIN ( select a.t$fire$l,  " &
"                   sum(a.t$qnty$l) QTDE  " &
"              from baandb.ttdrec941" + Parameters!Compania.Value + "  a  " &
"          group by a.t$fire$l ) REC941  " &
"      ON REC941.t$fire$l = tdrec940.t$fire$l  " &
"  " &
"LEFT JOIN ( select a.t$fire$l,  " &
"                 a.t$orno$l OC  " &
"            from baandb.ttdrec947" + Parameters!Compania.Value + "  a  " &
"        group by a.t$fire$l,  " &
"                 a.t$orno$l ) REC947  " &
"     ON REC947.t$fire$l = tdrec940.t$fire$l  " &
"  " &
"LEFT JOIN baandb.twhinh300" + Parameters!Compania.Value + "  whinh300  " &
"     ON whinh300.t$fire$c = tdrec940.t$fire$l  " &
"  " &
"LEFT JOIN (select  whinh301.t$shid,  " &
"                   whinh301.t$sfbp,  " &
"                   whinh301.t$item,  " &
"                   sum(whinh301.t$rqua) t$rqua  " &
"            from baandb.twhinh301" + Parameters!Compania.Value + "  whinh301  " &
"            group by whinh301.t$shid,  " &
"                     whinh301.t$sfbp,  " &
"                     whinh301.t$item) whinh301  " &
"       ON whinh301.t$sfbp = whinh300.t$sfbp  " &
"      AND whinh301.t$shid = whinh300.t$shid  " &
"  " &
"LEFT JOIN ( select a.t$sfbp,  " &
"                     a.t$shid,  " &
"                     sum(t$rqua) QTDE  " &
"                from baandb.twhinh301" + Parameters!Compania.Value + "  a  " &
"            group by a.t$sfbp,  " &
"                     a.t$shid ) INH301  " &
"         ON INH301.t$sfbp = whinh300.t$sfbp  " &
"        AND INH301.t$shid = whinh300.t$shid  " &
"  " &
"INNER JOIN BAANDB.TTCIBD001" + Parameters!Compania.Value + "  TCIBD001  " &
"       ON TCIBD001.T$ITEM  = WHINH301.T$ITEM  " &
"  " &
"LEFT JOIN ( select a.RECEIPTKEY,  " &
"                   a.EXTERNRECEIPTKEY,  " &
"                   a.CLOSEDDATE,  " &
"                   a.STATUS,  " &
"                   a.TYPE  " &
"              from " + IIF(Parameters!Compania.Value = 601, "WMWHSE9", "WMWHSE10") + ".RECEIPT@DL_LN_WMS  a  " &
"            group by a.RECEIPTKEY,  " &
"                     a.EXTERNRECEIPTKEY,  " &
"                     a.CLOSEDDATE,  " &
"                     a.STATUS,  " &
"                     a.TYPE ) WMS_RECEIPT  " &
"       ON WMS_RECEIPT.EXTERNRECEIPTKEY = '0' || '_' || TRIM(whinh300.t$sfbp) || '_' || TRIM(whinh300.t$shid) || '_' || TRIM(whinh300.t$cwar)  " &
"  " &
"LEFT JOIN ( select a.RECEIPTKEY,  " &
"                     a.SKU,  " &
"                     max(a.DATERECEIVED) DATERECEIVED,  " &
"                     sum(a.QTYRECEIVED) QTDE  " &
"                from " + IIF(Parameters!Compania.Value = 601, "WMWHSE9", "WMWHSE10") + ".RECEIPTDETAIL@DL_LN_WMS  a  " &
"            group by a.RECEIPTKEY,  " &
"                     a.EXTERNRECEIPTKEY,  " &
"                     a.SKU ) WMS_REC_DETAIL  " &
"         ON WMS_REC_DETAIL.RECEIPTKEY = WMS_RECEIPT.RECEIPTKEY  " &
"        AND TRIM(WMS_REC_DETAIL.SKU) = TRIM(whinh301.t$item)  " &
"  " &
"where tdrec940.t$stat$l IN (4, 5)  " &
"   AND Trim(tdrec940.t$cnfe$l) is not null  " &
"   AND tdrec940.t$rfdt$l = 1  " &
"   AND whinh301.t$rqua != 0  " &
"   AND WMS_RECEIPT.STATUS> = 11  " &
"   AND WMS_RECEIPT.TYPE != 8  " &
"  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whinh300.t$crdt,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                  AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between '" + Parameters!DataASNDe.Value + "'  " &
"           And '" + Parameters!DataASNAte.Value + "'  " &
 "  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WMS_REC_DETAIL.DATERECEIVED,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                  AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between nvl('" + Parameters!DataARMDe.Value + "',Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WMS_REC_DETAIL.DATERECEIVED,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                  AT time zone 'America/Sao_Paulo') AS DATE)))  " &
"           And nvl('" + Parameters!DataARMAte.Value + "',Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(WMS_REC_DETAIL.DATERECEIVED,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                  AT time zone 'America/Sao_Paulo') AS DATE)))  " &
"  " &
"   AND (    (" + IIF(Parameters!Item.Value Is Nothing, "1", "0") + " = 1)  " &
"          OR(    (Trim(whinh301.t$item) IN  " &
"                 ( " + IIF(Trim(Parameters!Item.Value) = "", "''", "'" + Replace(Replace(Parameters!Item.Value, " ", ""), ",", "','") + "'")  + " )  " &
"             AND (" + IIF(Parameters!Item.Value Is Nothing, "1", "0") + " = 0))))  "
