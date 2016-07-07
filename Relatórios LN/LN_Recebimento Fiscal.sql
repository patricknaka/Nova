    SELECT tcemm030.t$euca           NUME_FILIAL,
           tdrec940.t$docn$l         NUME_NOTA,
           tdrec940.t$seri$l         NUME_SERIE,
           whinh300.t$recd$c         NR_SUMARIZADO,
           brnfe940.t$fire$l         REF_FISCAL,
           brnfe940.t$frec$l         FISCAL_RECEIPT,
           tdrec940.t$stat$l         ID_STATUS_NF,
           SITUACAO_NF.DESCR_NF      DESCR_STATUS_NF,
           tdrec940.t$cpay$l         CONDICAO_PAGTO_NR,
           tcmcs013r.t$dsca          DESC_CONDICAO_PAGTO_NR,
           tdrec940.t$fovn$l         CNPJ_FORNECEDOR,
           tdrec940.t$fids$l         NOME_FORNECEDOR,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'),
             'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                     DATA_RECEB_FISCAL,
           tdrec940.t$opfc$l         NUME_CFOP,
           Trim(tdpur401.t$item)     NUME_ITEM,
           tcibd001.t$dsca           DESC_ITEM,
           Trim(tcibd001.t$citg)     GRUPO_DO_ITEM,
           tcmcs023.t$dsca           DESCR_GRUPO_DO_ITEM,
           tdpur401.t$orno           NUME_ORDEM,
           tdpur401.t$cpay           CONDICAO_PAGTO_PEDIDO,
           tcmcs013p.t$dsca          DESC_CONDICAO_PAGTO_PEDIDO,
           tdpur401.t$cdec           CONDICAO_ENTREGA_NR,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$odat, 'DD-MON-YYYY HH24:MI:SS'),
             'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                     DATA_GERACAO_PEDIDO,
           CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$ddat, 'DD-MON-YYYY HH24:MI:SS'),
             'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                     DATA_PLANEJ_RECEBIMENTO,
           CASE WHEN tcibd001.t$csig = 'SUS' THEN 'SUSPENSO'
                WHEN tcibd001.t$csig = 'CAN' THEN 'CANCELADO'
                WHEN tcibd001.t$csig = '001' THEN 'VERIFICAÇÃO FISCAL'
                ELSE                              'ATIVO'
           END                       SINALIZACAO_ITEM,
           tdrec941.t$qnty$l         QTDE_RECEBIDA,
           tdpur401.t$qoor           QTDE_ORDENADA,
           WMS_REC_DETAIL.QTDE       QTDE_RECEBIDA_WMS,
           WMS_RECEIPT.WHSEID        ARMAZEM,
           tdrec941.t$pric$l         PRECO_UNITARIO,
           tdrec941.t$tamt$l         VALOR_TOTAL_LINHA,
           tdrec941.t$iprt$l         PRECO_TOTAL_ITEM,
           tdrec940.t$fdtc$l         COD_TIPO_DOCFISCAL,
           tcmcs966.t$dsca$l         DSC_TIPO_DOCFISCAL,
           tdrec940.t$rfdt$l         COD_TIPO_DOC_RECFISCAL,
           TP_Doc_RecFiscal.DESCR    DSC_TIPO_DOC_RECFISCAL,
           CASE WHEN Trim(tdrec941.t$rfdv$c) is null
                  THEN tdrec940.t$cnfe$l
                ELSE   cisli940.t$cnfe$l 
           END                       CHAVE_ACESSO,
           cisli940.t$docn$l         NF_DEVOLUCAO,
           cisli940.t$seri$l         SERIE_NF_DEVOLUCAO,
           ( SELECT tdrec942.t$amnt$l
               FROM baandb.ttdrec942301  tdrec942
              WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
                AND tdrec942.t$line$l = tdrec941.t$line$l
                AND tdrec942.t$brty$l = 1 )
                                     VALOR_ICMS,
           ( SELECT tdrec942.t$amnt$l
               FROM baandb.ttdrec942301  tdrec942
              WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
                AND tdrec942.t$line$l = tdrec941.t$line$l
                AND tdrec942.t$brty$l = 5 )
                                     VALOR_PIS,
           ( SELECT tdrec942.t$amnt$l
               FROM baandb.ttdrec942301  tdrec942
              WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
                AND tdrec942.t$line$l = tdrec941.t$line$l
                AND tdrec942.t$brty$l = 6 )
                                     VALOR_COFINS,
           ( SELECT tdrec942.t$amnt$l
               FROM baandb.ttdrec942301  tdrec942
              WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
                AND tdrec942.t$line$l = tdrec941.t$line$l
                AND tdrec942.t$brty$l = 3 )
                                     VALOR_IPI,
           tcibd001.t$seab           CHAVE_BUSCA_II,
           tcibd001.t$cean           EAN,
           tdpur400.t$cotp           TIPO_ORDEM_COMPRA,
           tdpur094.t$dsca           DESCRICAO_TIPO_ORDEM_DE_COMPRA,
           tdpur450.t$logn           LOGIN_GEROU_OC,
           login.t$name              DSC_LOGIN_GEROU_OC,
           twhinh312.t$exrr          NUM_ASN,
           tdrec940.t$lipl$l         PLACA_VEICULO

      FROM baandb.ttdrec941301 tdrec941

 LEFT JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = tdrec941.t$rfdv$c

INNER JOIN baandb.ttdrec940301 tdrec940
        ON tdrec940.t$fire$l = tdrec941.t$fire$l

INNER JOIN baandb.tbrnfe940301 brnfe940
        ON brnfe940.t$docn$l = tdrec940.t$docn$l
       AND brnfe940.t$seri$l = tdrec940.t$seri$l
       AND brnfe940.t$fovn$l = tdrec940.t$fovn$l
        
 LEFT JOIN ( select tdrec947.t$fire$l,
                    tdrec947.t$line$l,
                    tdrec947.t$orno$l,
                    tdrec947.t$pono$l,
                    tdrec947.t$seqn$l,
                    MIN(tdrec947.t$rcno$l) t$rcno$l,
                    MIN(tdrec947.t$rcln$l) t$rcln$l
               from baandb.ttdrec947301 tdrec947
           group by tdrec947.t$fire$l,
                    tdrec947.t$line$l,
                    tdrec947.t$orno$l,
                    tdrec947.t$pono$l,
                    tdrec947.t$seqn$l ) tdrec947
        ON tdrec947.t$fire$l = tdrec941.t$fire$l
       AND tdrec947.t$line$l = tdrec941.t$line$l

INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tdrec940.t$sfra$l

 LEFT JOIN baandb.twhinh300301 whinh300
        ON whinh300.t$fire$c = tdrec940.t$fire$l

 LEFT JOIN (       select a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID from  WMWHSE1.RECEIPT@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID
             Union select a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID from  WMWHSE2.RECEIPT@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID
             Union select a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID from  WMWHSE3.RECEIPT@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID
             Union select a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID from  WMWHSE4.RECEIPT@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID
             Union select a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID from  WMWHSE5.RECEIPT@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID
             Union select a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID from  WMWHSE6.RECEIPT@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID
             Union select a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID from  WMWHSE7.RECEIPT@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID
             Union select a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID from  WMWHSE8.RECEIPT@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID
             Union select a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID from WMWHSE11.RECEIPT@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID
             Union select a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID from WMWHSE12.RECEIPT@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.CLOSEDDATE, a.STATUS, a.TYPE, a.WHSEID
           ) WMS_RECEIPT
        ON SUBSTR(WMS_RECEIPT.EXTERNRECEIPTKEY, 3,9) = TRIM(whinh300.t$sfbp)
       AND SUBSTR(WMS_RECEIPT.EXTERNRECEIPTKEY,13,9) = TRIM(whinh300.t$shid)
       
 LEFT JOIN (       select a.RECEIPTKEY, a.SKU, sum(a.QTYRECEIVED) QTDE from  WMWHSE1.RECEIPTDETAIL@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.SKU 
             Union select a.RECEIPTKEY, a.SKU, sum(a.QTYRECEIVED) QTDE from  WMWHSE2.RECEIPTDETAIL@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.SKU 
             Union select a.RECEIPTKEY, a.SKU, sum(a.QTYRECEIVED) QTDE from  WMWHSE3.RECEIPTDETAIL@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.SKU 
             Union select a.RECEIPTKEY, a.SKU, sum(a.QTYRECEIVED) QTDE from  WMWHSE4.RECEIPTDETAIL@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.SKU 
             Union select a.RECEIPTKEY, a.SKU, sum(a.QTYRECEIVED) QTDE from  WMWHSE5.RECEIPTDETAIL@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.SKU 
             Union select a.RECEIPTKEY, a.SKU, sum(a.QTYRECEIVED) QTDE from  WMWHSE6.RECEIPTDETAIL@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.SKU 
             Union select a.RECEIPTKEY, a.SKU, sum(a.QTYRECEIVED) QTDE from  WMWHSE7.RECEIPTDETAIL@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.SKU 
             Union select a.RECEIPTKEY, a.SKU, sum(a.QTYRECEIVED) QTDE from  WMWHSE8.RECEIPTDETAIL@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.SKU 
             Union select a.RECEIPTKEY, a.SKU, sum(a.QTYRECEIVED) QTDE from WMWHSE11.RECEIPTDETAIL@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.SKU 
             Union select a.RECEIPTKEY, a.SKU, sum(a.QTYRECEIVED) QTDE from WMWHSE12.RECEIPTDETAIL@DL_LN_WMS a group by a.RECEIPTKEY, a.EXTERNRECEIPTKEY, a.SKU 
           ) WMS_REC_DETAIL 
        ON WMS_REC_DETAIL.RECEIPTKEY = WMS_RECEIPT.RECEIPTKEY 
       AND TRIM(WMS_REC_DETAIL.SKU)  = TRIM(tdrec941.t$item$l)

INNER JOIN baandb.ttdpur401301 tdpur401
        ON tdpur401.t$orno = tdrec947.t$orno$l
       AND tdpur401.t$pono = tdrec947.t$pono$l
       AND tdpur401.t$sqnb = tdrec947.t$seqn$l

INNER JOIN baandb.ttdpur400301 tdpur400
        ON tdpur400.t$orno = tdpur401.t$orno

INNER JOIN baandb.ttcemm124301 tcemm124
        ON tcemm124.t$cwoc = tdpur400.t$cofc

INNER JOIN baandb.ttcemm030301 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid

 LEFT JOIN baandb.ttcmcs013301 tcmcs013p
        ON tcmcs013p.t$cpay = tdpur401.t$cpay

 LEFT JOIN baandb.ttcibd001301 tcibd001
        ON  tcibd001.t$item   = tdpur401.t$item

 LEFT JOIN baandb.ttcmcs023301 tcmcs023
        ON tcmcs023.t$citg   = tcibd001.t$citg

 LEFT JOIN baandb.ttcmcs013301 tcmcs013r
        ON tcmcs013r.t$cpay  = tdrec940.t$cpay$l

 LEFT JOIN baandb.ttcmcs966301 tcmcs966
        ON tcmcs966.t$fdtc$l  = tdrec940.t$fdtc$l

 LEFT JOIN ( select l.t$desc DESCR_NF,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'td'
                and d.t$cdom = 'rec.stat.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'td'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4) )
                                           FROM baandb.tttadv401000 l1
                                          WHERE l1.t$cpac = d.t$cpac
                                            AND l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4) )
                                           FROM baandb.tttadv140000 l1
                                          WHERE l1.t$clab = l.t$clab
                                            AND l1.t$clan = l.t$clan
                                            AND l1.t$cpac = l.t$cpac ) ) SITUACAO_NF
        ON SITUACAO_NF.t$cnst = tdrec940.t$stat$l

 LEFT JOIN ( select l.t$desc DESCR,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'td'
                and d.t$cdom = 'rec.trfd.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'td'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4) )
                                           FROM baandb.tttadv401000 l1
                                          WHERE l1.t$cpac = d.t$cpac
                                            AND l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4) )
                                           FROM baandb.tttadv140000 l1
                                          WHERE l1.t$clab = l.t$clab
                                            AND l1.t$clan = l.t$clan
                                            AND l1.t$cpac = l.t$cpac ) ) TP_Doc_RecFiscal
        ON TP_Doc_RecFiscal.t$cnst = tdrec940.t$rfdt$l

INNER JOIN baandb.ttdpur094301 tdpur094
        ON tdpur094.t$potp = tdpur400.t$cotp

INNER JOIN ( select a.t$orno,
                    a.t$logn,
                    a.t$trdt
               from baandb.ttdpur450301 a
              where a.t$trdt  = ( select min(b.t$trdt)
                                    from baandb.ttdpur450301 b
                                   where b.t$orno = a.t$orno
                                     and rownum = 1 ) ) tdpur450
        ON tdpur450.t$orno = tdpur400.t$orno

 LEFT JOIN ( select a.t$user,
                    a.t$name
               from baandb.tttaad200000 a ) login
        ON login.t$user = tdpur450.t$logn

 LEFT JOIN baandb.twhinh312301 twhinh312
        ON twhinh312.t$rcno = tdrec947.t$rcno$l
       AND twhinh312.t$rcln = tdrec947.t$rcln$l

     WHERE tcemm124.t$dtyp = 2
     
       AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'),
                   'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) 
           Between :DtFiscalDe 
               And :DtFiscalAte
       AND Trim(tcibd001.t$citg) IN (:GrupoItem)
       AND tdrec940.t$stat$l IN (:Status)
       AND NVL(Trim(tdrec940.t$fdtc$l), '0') in (:TipoDocFiscal)
       AND tdrec940.t$rfdt$l in (:TipoDocRecFiscal)
       AND ((:CNPJ Is Null) OR (regexp_replace(tdrec940.t$fovn$l, '[^0-9]', '') like '%' || Trim(:CNPJ) || '%'))
   
ORDER BY NUME_FILIAL, 
         REF_FISCAL, 
         NUME_NOTA, 
         NUME_ITEM