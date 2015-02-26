SELECT DISTINCT
       d.WHSEID                      ARMAZEM,                                --01
       cl.UDF2                       DESC_ARMAZEM,                           --02        
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.ADDDATE, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone sessiontimezone) AS DATE)  
                                     DATA_LANCTO,                            --03
       d.RECEIPTKEY                  ASN,                                    --04
       d.RECEIPTLINENUMBER           LINHA_ASN,
       CASE WHEN h.ADDWHO IS NULL THEN
         d.ADDWHO
       ELSE h.ADDWHO END             OPERADOR,                               --05
       d.SKU                         ITEM,                                   --06
       SKU.DESCR                     DESCRICAO,                              --07
       ( select ALTSKU.ALTSKU
           from WMWHSE5.ALTSKU ALTSKU  
          where ALTSKU.SKU = d.SKU
            and rownum = 1 )         EAN,                                    --08
       SKU.SKUGROUP                  DEPART,                                 --09
       DEPTO.DEPART_NAME             NOME_DEPART,                            --10
       SKU.SKUGROUP2                 SETOR,                                  --11
       DEPTO.SECTOR_NAME             NOME_SETOR,                             --12
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone sessiontimezone) AS DATE)  
                                     DATA_RECBTO,                            --13   
       d.QTYEXPECTED                 QTDE_PCS_LANC,                          --14
       d.QTYRECEIVED                 QTDE_PCS_RECEBIDAS,                     --15
       tdrec941.t$fire$l             REF_FISCAL,                             --16
       tdrec941.t$line$l             LINHA_REF_FISCAL,                       --17
       TIPO_REC.DSC                  TIPO_ORDEM,                             --18
       tdrec940.t$fovn$l             CNPJ,                                   --19
       tdrec940.t$fids$l             FORNECEDOR,                             --20
       tccom130.t$cste               ESTADO,                                 --21
       tdrec940.t$docn$l             NOTA_FISCAL,                            --22
       tdrec940.t$seri$l             SERIE_NF,                               --23
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone sessiontimezone) AS DATE)  
                                     DT_EMISSAO_ENT,                         --24
       tdrec941.t$opfc$l             CFOP,                                   --25
       tdrec941.t$qnty$l             QTDE,                                   --26
       tdrec941.t$pric$l             VALOR_UNITARIO,                         --27
       cisli940.t$docn$l             NF_SAIDA,                               --28
       cisli940.t$seri$l             SERIE_NF_SAIDA,                         --29
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone sessiontimezone) AS DATE)  
                                     DT_EMISSAO_SAIDA,                       --30
       cisli940.t$cfrw$l             TRANSP_COLETA,                          --31
       tcmcs080.t$dsca               DESCR_TRANSP                            --32
        
FROM       WMWHSE5.RECEIPTDETAIL  d

INNER JOIN WMWHSE5.RECEIPT  r
        ON r.RECEIPTKEY = d.RECEIPTKEY

INNER JOIN ENTERPRISE.SKU SKU
        ON SKU.SKU = d.SKU

 LEFT JOIN WMWHSE5.DEPARTSECTORSKU DEPTO
        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)
       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)

 LEFT JOIN ( select clkp.code          COD, 
                    NVL(trans.description, 
                    clkp.description)  DSC
               from WMWHSE5.codelkup clkp
          left join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
              where clkp.listname = 'RECEIPTYPE'
                and Trim(clkp.code) is not null  ) TIPO_REC
        ON TIPO_REC.COD = r.TYPE

 LEFT JOIN ENTERPRISE.CODELKUP cl  
        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)
              
 LEFT JOIN baandb.twhinh301301@pln01  whinh301
        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)
       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)
       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)
       
 LEFT JOIN baandb.ttdrec947301@pln01  tdrec947
        ON tdrec947.t$ncmp$l = 301
       AND tdrec947.t$oorg$l = whinh301.t$oorg
       AND tdrec947.t$orno$l = whinh301.t$worn
       AND tdrec947.t$pono$l = whinh301.t$wpon
       AND tdrec947.t$seqn$l = whinh301.t$wsqn
       
 LEFT JOIN baandb.ttdrec941301@pln01  tdrec941
        ON tdrec941.t$fire$l = tdrec947.t$fire$l
       AND tdrec941.t$line$l = tdrec947.t$line$l
       
 LEFT JOIN baandb.ttdrec940301@pln01  tdrec940
        ON tdrec940.t$fire$l = tdrec941.t$fire$l
        
 LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080
        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l
 
 LEFT JOIN baandb.tcisli941301@pln01 cisli941
        ON cisli941.t$fire$l = tdrec941.t$dvrf$c
       AND cisli941.t$line$l = tdrec941.t$dvln$c
              
 LEFT JOIN baandb.tcisli940301@pln01 cisli940
         ON cisli940.t$fire$l = cisli941.t$fire$l
         
 LEFT JOIN baandb.ttccom130301@pln01 tccom130
        ON tccom130.t$cadr = tdrec940.t$sfad$l
               
 LEFT JOIN WMWHSE5.RECEIPTSTATUSHISTORY h
        ON h.RECEIPTKEY = d.RECEIPTKEY 
       AND h.STATUS = 9                  --RECEBIDO

     WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED, 
                       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                       AT time zone sessiontimezone) AS DATE)) = :DataRecto
       AND r.type IN (:TipoOrdem)
       AND ((:ASN_Todos = 0) OR (d.RECEIPTKEY IN (:ASN) AND :ASN_Todos = 1))
       AND ((:Qtde_Pecas is null) OR (tdrec941.t$qnty$l = :Qtde_Pecas))
	
  ORDER BY ASN, LINHA_ASN

  
  
  
=IIF(Parameters!Table.Value <> "AAA",

"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,  " & 
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.ADDDATE,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.RECEIPTLINENUMBER           LINHA_ASN,  " &
"       CASE WHEN h.ADDWHO IS NULL THEN  " &
"         d.ADDWHO  " &
"       ELSE h.ADDWHO END             OPERADOR,  " &
"       d.SKU                         ITEM,  " &
"       SKU.DESCR                     DESCRICAO,  " &
"       ( select ALTSKU.ALTSKU  " &
"           from "+ Parameters!Table.Value + ".ALTSKU ALTSKU  " &
"          where ALTSKU.SKU = d.SKU  " &
"            and rownum = 1 )         EAN,  " &
"       SKU.SKUGROUP                  DEPART,  " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       d.QTYEXPECTED                 QTDE_PCS_LANC,  " &
"       d.QTYRECEIVED                 QTDE_PCS_RECEBIDAS,  " &
"       tdrec941.t$fire$l             REF_FISCAL,  " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,  " &
"       TIPO_REC.DSC                  TIPO_ORDEM,  " &
"       tdrec940.t$fovn$l             CNPJ,  " &
"       tdrec940.t$fids$l             FORNECEDOR,  " &
"       tccom130.t$cste               ESTADO,  " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_ENT,  " &
"       tdrec941.t$opfc$l             CFOP,  " &
"       tdrec941.t$qnty$l             QTDE,  " &
"       tdrec941.t$pric$l             VALOR_UNITARIO,  " &
"       cisli940.t$docn$l             NF_SAIDA,  " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,  " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP  " &
"FROM       "+ Parameters!Table.Value + ".RECEIPTDETAIL  d  " &
"INNER JOIN "+ Parameters!Table.Value + ".RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY  " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU  " &
" LEFT JOIN "+ Parameters!Table.Value + ".DEPARTSECTORSKU DEPTO  " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,  " &
"                    clkp.description)  DSC  " &
"               from "+ Parameters!Table.Value + ".codelkup clkp  " &
"          left join "+ Parameters!Table.Value + ".translationlist trans  " &
"                 on trans.code = clkp.code  " &
"                and trans.joinkey1 = clkp.listname  " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'  " &
"              where clkp.listname = 'RECEIPTYPE'  " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301  " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)  " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947  " &
"        ON tdrec947.t$ncmp$l = 301  " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg  " &
"       AND tdrec947.t$orno$l = whinh301.t$worn  " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon  " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn  " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941  " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l  " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l  " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940  " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l  " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l  " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c  " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c  " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l  " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l  " &
" LEFT JOIN "+ Parameters!Table.Value + ".RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY  " &
"       AND h.STATUS = 9  " &
"     WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"                     AT time zone sessiontimezone) AS DATE))  " &
"           Between '" + Parameters!DataRectoDe.Value + "'  " &
"               And '" + Parameters!DataRectoAte.Value + "'  " &
"       AND r.type IN (" + Replace(("'" + JOIN(Parameters!TipoOrdem.Value, "',") + "'"),",",",'") + ")  " &
"       AND (    (Trim(d.RECEIPTKEY) IN ( " + IIF(Trim(Parameters!ASN.Value) = "", "''", "'" + Replace(Replace(Parameters!ASN.Value, " ", ""), ",", "','") + "'")  + " )  " &
"            AND (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 1) )  " &
"       AND (    (tdrec941.t$qnty$l = " + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "''", Parameters!Qtde_Pecas.Value)  + "  " &
"            AND (" + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!Qtde_Pecas.Value)  = "", "1", "0") + " = 1) )  " &
"ORDER BY DATA_LANCTO, ASN, ITEM "

,

"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,  " & 
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.ADDDATE,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.RECEIPTLINENUMBER           LINHA_ASN,  " &
"       CASE WHEN h.ADDWHO IS NULL THEN  " &
"         d.ADDWHO  " &
"       ELSE h.ADDWHO END             OPERADOR,  " &
"       d.SKU                         ITEM,  " &
"       SKU.DESCR                     DESCRICAO,  " &
"       ( select ALTSKU.ALTSKU  " &
"           from WMWHSE1.ALTSKU ALTSKU  " &
"          where ALTSKU.SKU = d.SKU  " &
"            and rownum = 1 )         EAN,  " &
"       SKU.SKUGROUP                  DEPART,  " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       d.QTYEXPECTED                 QTDE_PCS_LANC,  " &
"       d.QTYRECEIVED                 QTDE_PCS_RECEBIDAS,  " &
"       tdrec941.t$fire$l             REF_FISCAL,  " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,  " &
"       TIPO_REC.DSC                  TIPO_ORDEM,  " &
"       tdrec940.t$fovn$l             CNPJ,  " &
"       tdrec940.t$fids$l             FORNECEDOR,  " &
"       tccom130.t$cste               ESTADO,  " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_ENT,  " &
"       tdrec941.t$opfc$l             CFOP,  " &
"       tdrec941.t$qnty$l             QTDE,  " &
"       tdrec941.t$pric$l             VALOR_UNITARIO,  " &
"       cisli940.t$docn$l             NF_SAIDA,  " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,  " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP  " &
"FROM       WMWHSE1.RECEIPTDETAIL  d  " &
"INNER JOIN WMWHSE1.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY  " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU  " &
" LEFT JOIN WMWHSE1.DEPARTSECTORSKU DEPTO  " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,  " &
"                    clkp.description)  DSC  " &
"               from WMWHSE1.codelkup clkp  " &
"          left join WMWHSE1.translationlist trans  " &
"                 on trans.code = clkp.code  " &
"                and trans.joinkey1 = clkp.listname  " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'  " &
"              where clkp.listname = 'RECEIPTYPE'  " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301  " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)  " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947  " &
"        ON tdrec947.t$ncmp$l = 301  " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg  " &
"       AND tdrec947.t$orno$l = whinh301.t$worn  " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon  " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn  " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941  " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l  " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l  " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940  " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l  " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l  " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c  " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c  " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l  " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l  " &
" LEFT JOIN WMWHSE1.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY  " &
"       AND h.STATUS = 9  " &
"     WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"                     AT time zone sessiontimezone) AS DATE))  " &
"           Between '" + Parameters!DataRectoDe.Value + "'  " &
"               And '" + Parameters!DataRectoAte.Value + "'  " &
"       AND r.type IN (" + Replace(("'" + JOIN(Parameters!TipoOrdem.Value, "',") + "'"),",",",'") + ")  " &
"       AND (    (Trim(d.RECEIPTKEY) IN ( " + IIF(Trim(Parameters!ASN.Value) = "", "''", "'" + Replace(Replace(Parameters!ASN.Value, " ", ""), ",", "','") + "'")  + " )  " &
"            AND (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 1) )  " &
"       AND (    (tdrec941.t$qnty$l = " + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "''", Parameters!Qtde_Pecas.Value)  + "  " &
"            AND (" + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!Qtde_Pecas.Value)  = "", "1", "0") + " = 1) )  " &
"UNION                                                               " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,  " & 
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.ADDDATE,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.RECEIPTLINENUMBER           LINHA_ASN,  " &
"       CASE WHEN h.ADDWHO IS NULL THEN  " &
"         d.ADDWHO  " &
"       ELSE h.ADDWHO END             OPERADOR,  " &
"       d.SKU                         ITEM,  " &
"       SKU.DESCR                     DESCRICAO,  " &
"       ( select ALTSKU.ALTSKU  " &
"           from WMWHSE2.ALTSKU ALTSKU  " &
"          where ALTSKU.SKU = d.SKU  " &
"            and rownum = 1 )         EAN,  " &
"       SKU.SKUGROUP                  DEPART,  " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       d.QTYEXPECTED                 QTDE_PCS_LANC,  " &
"       d.QTYRECEIVED                 QTDE_PCS_RECEBIDAS,  " &
"       tdrec941.t$fire$l             REF_FISCAL,  " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,  " &
"       TIPO_REC.DSC                  TIPO_ORDEM,  " &
"       tdrec940.t$fovn$l             CNPJ,  " &
"       tdrec940.t$fids$l             FORNECEDOR,  " &
"       tccom130.t$cste               ESTADO,  " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_ENT,  " &
"       tdrec941.t$opfc$l             CFOP,  " &
"       tdrec941.t$qnty$l             QTDE,  " &
"       tdrec941.t$pric$l             VALOR_UNITARIO,  " &
"       cisli940.t$docn$l             NF_SAIDA,  " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,  " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP  " &
"FROM       WMWHSE2.RECEIPTDETAIL  d  " &
"INNER JOIN WMWHSE2.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY  " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU  " &
" LEFT JOIN WMWHSE2.DEPARTSECTORSKU DEPTO  " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,  " &
"                    clkp.description)  DSC  " &
"               from WMWHSE2.codelkup clkp  " &
"          left join WMWHSE2.translationlist trans  " &
"                 on trans.code = clkp.code  " &
"                and trans.joinkey1 = clkp.listname  " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'  " &
"              where clkp.listname = 'RECEIPTYPE'  " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301  " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)  " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947  " &
"        ON tdrec947.t$ncmp$l = 301  " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg  " &
"       AND tdrec947.t$orno$l = whinh301.t$worn  " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon  " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn  " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941  " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l  " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l  " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940  " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l  " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l  " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c  " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c  " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l  " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l  " &
" LEFT JOIN WMWHSE2.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY  " &
"       AND h.STATUS = 9  " &
"     WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"                     AT time zone sessiontimezone) AS DATE))  " &
"           Between '" + Parameters!DataRectoDe.Value + "'  " &
"               And '" + Parameters!DataRectoAte.Value + "'  " &
"       AND r.type IN (" + Replace(("'" + JOIN(Parameters!TipoOrdem.Value, "',") + "'"),",",",'") + ")  " &
"       AND (    (Trim(d.RECEIPTKEY) IN ( " + IIF(Trim(Parameters!ASN.Value) = "", "''", "'" + Replace(Replace(Parameters!ASN.Value, " ", ""), ",", "','") + "'")  + " )  " &
"            AND (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 1) )  " &
"       AND (    (tdrec941.t$qnty$l = " + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "''", Parameters!Qtde_Pecas.Value)  + "  " &
"            AND (" + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!Qtde_Pecas.Value)  = "", "1", "0") + " = 1) )  " &
"UNION                                                               " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,  " & 
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.ADDDATE,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.RECEIPTLINENUMBER           LINHA_ASN,  " &
"       CASE WHEN h.ADDWHO IS NULL THEN  " &
"         d.ADDWHO  " &
"       ELSE h.ADDWHO END             OPERADOR,  " &
"       d.SKU                         ITEM,  " &
"       SKU.DESCR                     DESCRICAO,  " &
"       ( select ALTSKU.ALTSKU  " &
"           from WMWHSE3.ALTSKU ALTSKU  " &
"          where ALTSKU.SKU = d.SKU  " &
"            and rownum = 1 )         EAN,  " &
"       SKU.SKUGROUP                  DEPART,  " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       d.QTYEXPECTED                 QTDE_PCS_LANC,  " &
"       d.QTYRECEIVED                 QTDE_PCS_RECEBIDAS,  " &
"       tdrec941.t$fire$l             REF_FISCAL,  " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,  " &
"       TIPO_REC.DSC                  TIPO_ORDEM,  " &
"       tdrec940.t$fovn$l             CNPJ,  " &
"       tdrec940.t$fids$l             FORNECEDOR,  " &
"       tccom130.t$cste               ESTADO,  " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_ENT,  " &
"       tdrec941.t$opfc$l             CFOP,  " &
"       tdrec941.t$qnty$l             QTDE,  " &
"       tdrec941.t$pric$l             VALOR_UNITARIO,  " &
"       cisli940.t$docn$l             NF_SAIDA,  " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,  " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP  " &
"FROM       WMWHSE3.RECEIPTDETAIL  d  " &
"INNER JOIN WMWHSE3.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY  " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU  " &
" LEFT JOIN WMWHSE3.DEPARTSECTORSKU DEPTO  " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,  " &
"                    clkp.description)  DSC  " &
"               from WMWHSE3.codelkup clkp  " &
"          left join WMWHSE3.translationlist trans  " &
"                 on trans.code = clkp.code  " &
"                and trans.joinkey1 = clkp.listname  " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'  " &
"              where clkp.listname = 'RECEIPTYPE'  " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301  " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)  " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947  " &
"        ON tdrec947.t$ncmp$l = 301  " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg  " &
"       AND tdrec947.t$orno$l = whinh301.t$worn  " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon  " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn  " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941  " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l  " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l  " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940  " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l  " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l  " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c  " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c  " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l  " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l  " &
" LEFT JOIN WMWHSE3.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY  " &
"       AND h.STATUS = 9  " &
"     WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"                     AT time zone sessiontimezone) AS DATE))  " &
"           Between '" + Parameters!DataRectoDe.Value + "'  " &
"               And '" + Parameters!DataRectoAte.Value + "'  " &
"       AND r.type IN (" + Replace(("'" + JOIN(Parameters!TipoOrdem.Value, "',") + "'"),",",",'") + ")  " &
"       AND (    (Trim(d.RECEIPTKEY) IN ( " + IIF(Trim(Parameters!ASN.Value) = "", "''", "'" + Replace(Replace(Parameters!ASN.Value, " ", ""), ",", "','") + "'")  + " )  " &
"            AND (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 1) )  " &
"       AND (    (tdrec941.t$qnty$l = " + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "''", Parameters!Qtde_Pecas.Value)  + "  " &
"            AND (" + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!Qtde_Pecas.Value)  = "", "1", "0") + " = 1) )  " &
"UNION                                                               " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,  " & 
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.ADDDATE,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.RECEIPTLINENUMBER           LINHA_ASN,  " &
"       CASE WHEN h.ADDWHO IS NULL THEN  " &
"         d.ADDWHO  " &
"       ELSE h.ADDWHO END             OPERADOR,  " &
"       d.SKU                         ITEM,  " &
"       SKU.DESCR                     DESCRICAO,  " &
"       ( select ALTSKU.ALTSKU  " &
"           from WMWHSE4.ALTSKU ALTSKU  " &
"          where ALTSKU.SKU = d.SKU  " &
"            and rownum = 1 )         EAN,  " &
"       SKU.SKUGROUP                  DEPART,  " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       d.QTYEXPECTED                 QTDE_PCS_LANC,  " &
"       d.QTYRECEIVED                 QTDE_PCS_RECEBIDAS,  " &
"       tdrec941.t$fire$l             REF_FISCAL,  " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,  " &
"       TIPO_REC.DSC                  TIPO_ORDEM,  " &
"       tdrec940.t$fovn$l             CNPJ,  " &
"       tdrec940.t$fids$l             FORNECEDOR,  " &
"       tccom130.t$cste               ESTADO,  " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_ENT,  " &
"       tdrec941.t$opfc$l             CFOP,  " &
"       tdrec941.t$qnty$l             QTDE,  " &
"       tdrec941.t$pric$l             VALOR_UNITARIO,  " &
"       cisli940.t$docn$l             NF_SAIDA,  " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,  " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP  " &
"FROM       WMWHSE4.RECEIPTDETAIL  d  " &
"INNER JOIN WMWHSE4.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY  " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU  " &
" LEFT JOIN WMWHSE4.DEPARTSECTORSKU DEPTO  " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,  " &
"                    clkp.description)  DSC  " &
"               from WMWHSE4.codelkup clkp  " &
"          left join WMWHSE4.translationlist trans  " &
"                 on trans.code = clkp.code  " &
"                and trans.joinkey1 = clkp.listname  " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'  " &
"              where clkp.listname = 'RECEIPTYPE'  " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301  " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)  " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947  " &
"        ON tdrec947.t$ncmp$l = 301  " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg  " &
"       AND tdrec947.t$orno$l = whinh301.t$worn  " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon  " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn  " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941  " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l  " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l  " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940  " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l  " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l  " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c  " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c  " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l  " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l  " &
" LEFT JOIN WMWHSE4.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY  " &
"       AND h.STATUS = 9  " &
"     WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"                     AT time zone sessiontimezone) AS DATE))  " &
"           Between '" + Parameters!DataRectoDe.Value + "'  " &
"               And '" + Parameters!DataRectoAte.Value + "'  " &
"       AND r.type IN (" + Replace(("'" + JOIN(Parameters!TipoOrdem.Value, "',") + "'"),",",",'") + ")  " &
"       AND (    (Trim(d.RECEIPTKEY) IN ( " + IIF(Trim(Parameters!ASN.Value) = "", "''", "'" + Replace(Replace(Parameters!ASN.Value, " ", ""), ",", "','") + "'")  + " )  " &
"            AND (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 1) )  " &
"       AND (    (tdrec941.t$qnty$l = " + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "''", Parameters!Qtde_Pecas.Value)  + "  " &
"            AND (" + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!Qtde_Pecas.Value)  = "", "1", "0") + " = 1) )  " &
"UNION                                                               " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,  " & 
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.ADDDATE,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.RECEIPTLINENUMBER           LINHA_ASN,  " &
"       CASE WHEN h.ADDWHO IS NULL THEN  " &
"         d.ADDWHO  " &
"       ELSE h.ADDWHO END             OPERADOR,  " &
"       d.SKU                         ITEM,  " &
"       SKU.DESCR                     DESCRICAO,  " &
"       ( select ALTSKU.ALTSKU  " &
"           from WMWHSE5.ALTSKU ALTSKU  " &
"          where ALTSKU.SKU = d.SKU  " &
"            and rownum = 1 )         EAN,  " &
"       SKU.SKUGROUP                  DEPART,  " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       d.QTYEXPECTED                 QTDE_PCS_LANC,  " &
"       d.QTYRECEIVED                 QTDE_PCS_RECEBIDAS,  " &
"       tdrec941.t$fire$l             REF_FISCAL,  " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,  " &
"       TIPO_REC.DSC                  TIPO_ORDEM,  " &
"       tdrec940.t$fovn$l             CNPJ,  " &
"       tdrec940.t$fids$l             FORNECEDOR,  " &
"       tccom130.t$cste               ESTADO,  " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_ENT,  " &
"       tdrec941.t$opfc$l             CFOP,  " &
"       tdrec941.t$qnty$l             QTDE,  " &
"       tdrec941.t$pric$l             VALOR_UNITARIO,  " &
"       cisli940.t$docn$l             NF_SAIDA,  " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,  " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP  " &
"FROM       WMWHSE5.RECEIPTDETAIL  d  " &
"INNER JOIN WMWHSE5.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY  " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU  " &
" LEFT JOIN WMWHSE5.DEPARTSECTORSKU DEPTO  " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,  " &
"                    clkp.description)  DSC  " &
"               from WMWHSE5.codelkup clkp  " &
"          left join WMWHSE5.translationlist trans  " &
"                 on trans.code = clkp.code  " &
"                and trans.joinkey1 = clkp.listname  " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'  " &
"              where clkp.listname = 'RECEIPTYPE'  " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301  " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)  " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947  " &
"        ON tdrec947.t$ncmp$l = 301  " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg  " &
"       AND tdrec947.t$orno$l = whinh301.t$worn  " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon  " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn  " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941  " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l  " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l  " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940  " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l  " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l  " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c  " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c  " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l  " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l  " &
" LEFT JOIN WMWHSE5.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY  " &
"       AND h.STATUS = 9  " &
"     WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"                     AT time zone sessiontimezone) AS DATE))  " &
"           Between '" + Parameters!DataRectoDe.Value + "'  " &
"               And '" + Parameters!DataRectoAte.Value + "'  " &
"       AND r.type IN (" + Replace(("'" + JOIN(Parameters!TipoOrdem.Value, "',") + "'"),",",",'") + ")  " &
"       AND (    (Trim(d.RECEIPTKEY) IN ( " + IIF(Trim(Parameters!ASN.Value) = "", "''", "'" + Replace(Replace(Parameters!ASN.Value, " ", ""), ",", "','") + "'")  + " )  " &
"            AND (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 1) )  " &
"       AND (    (tdrec941.t$qnty$l = " + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "''", Parameters!Qtde_Pecas.Value)  + "  " &
"            AND (" + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!Qtde_Pecas.Value)  = "", "1", "0") + " = 1) )  " &
"UNION                                                               " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,  " & 
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.ADDDATE,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.RECEIPTLINENUMBER           LINHA_ASN,  " &
"       CASE WHEN h.ADDWHO IS NULL THEN  " &
"         d.ADDWHO  " &
"       ELSE h.ADDWHO END             OPERADOR,  " &
"       d.SKU                         ITEM,  " &
"       SKU.DESCR                     DESCRICAO,  " &
"       ( select ALTSKU.ALTSKU  " &
"           from WMWHSE6.ALTSKU ALTSKU  " &
"          where ALTSKU.SKU = d.SKU  " &
"            and rownum = 1 )         EAN,  " &
"       SKU.SKUGROUP                  DEPART,  " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       d.QTYEXPECTED                 QTDE_PCS_LANC,  " &
"       d.QTYRECEIVED                 QTDE_PCS_RECEBIDAS,  " &
"       tdrec941.t$fire$l             REF_FISCAL,  " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,  " &
"       TIPO_REC.DSC                  TIPO_ORDEM,  " &
"       tdrec940.t$fovn$l             CNPJ,  " &
"       tdrec940.t$fids$l             FORNECEDOR,  " &
"       tccom130.t$cste               ESTADO,  " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_ENT,  " &
"       tdrec941.t$opfc$l             CFOP,  " &
"       tdrec941.t$qnty$l             QTDE,  " &
"       tdrec941.t$pric$l             VALOR_UNITARIO,  " &
"       cisli940.t$docn$l             NF_SAIDA,  " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,  " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP  " &
"FROM       WMWHSE6.RECEIPTDETAIL  d  " &
"INNER JOIN WMWHSE6.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY  " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU  " &
" LEFT JOIN WMWHSE6.DEPARTSECTORSKU DEPTO  " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,  " &
"                    clkp.description)  DSC  " &
"               from WMWHSE6.codelkup clkp  " &
"          left join WMWHSE6.translationlist trans  " &
"                 on trans.code = clkp.code  " &
"                and trans.joinkey1 = clkp.listname  " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'  " &
"              where clkp.listname = 'RECEIPTYPE'  " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301  " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)  " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947  " &
"        ON tdrec947.t$ncmp$l = 301  " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg  " &
"       AND tdrec947.t$orno$l = whinh301.t$worn  " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon  " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn  " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941  " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l  " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l  " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940  " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l  " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l  " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c  " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c  " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l  " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l  " &
" LEFT JOIN WMWHSE6.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY  " &
"       AND h.STATUS = 9  " &
"     WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"                     AT time zone sessiontimezone) AS DATE))  " &
"           Between '" + Parameters!DataRectoDe.Value + "'  " &
"               And '" + Parameters!DataRectoAte.Value + "'  " &
"       AND r.type IN (" + Replace(("'" + JOIN(Parameters!TipoOrdem.Value, "',") + "'"),",",",'") + ")  " &
"       AND (    (Trim(d.RECEIPTKEY) IN ( " + IIF(Trim(Parameters!ASN.Value) = "", "''", "'" + Replace(Replace(Parameters!ASN.Value, " ", ""), ",", "','") + "'")  + " )  " &
"            AND (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 1) )  " &
"       AND (    (tdrec941.t$qnty$l = " + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "''", Parameters!Qtde_Pecas.Value)  + "  " &
"            AND (" + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!Qtde_Pecas.Value)  = "", "1", "0") + " = 1) )  " &
"UNION                                                               " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,  " & 
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.ADDDATE,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.RECEIPTLINENUMBER           LINHA_ASN,  " &
"       CASE WHEN h.ADDWHO IS NULL THEN  " &
"         d.ADDWHO  " &
"       ELSE h.ADDWHO END             OPERADOR,  " &
"       d.SKU                         ITEM,  " &
"       SKU.DESCR                     DESCRICAO,  " &
"       ( select ALTSKU.ALTSKU  " &
"           from WMWHSE7.ALTSKU ALTSKU  " &
"          where ALTSKU.SKU = d.SKU  " &
"            and rownum = 1 )         EAN,  " &
"       SKU.SKUGROUP                  DEPART,  " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"             AT time zone sessiontimezone) AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       d.QTYEXPECTED                 QTDE_PCS_LANC,  " &
"       d.QTYRECEIVED                 QTDE_PCS_RECEBIDAS,  " &
"       tdrec941.t$fire$l             REF_FISCAL,  " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,  " &
"       TIPO_REC.DSC                  TIPO_ORDEM,  " &
"       tdrec940.t$fovn$l             CNPJ,  " &
"       tdrec940.t$fids$l             FORNECEDOR,  " &
"       tccom130.t$cste               ESTADO,  " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_ENT,  " &
"       tdrec941.t$opfc$l             CFOP,  " &
"       tdrec941.t$qnty$l             QTDE,  " &
"       tdrec941.t$pric$l             VALOR_UNITARIO,  " &
"       cisli940.t$docn$l             NF_SAIDA,  " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,  " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP  " &
"FROM       WMWHSE7.RECEIPTDETAIL  d  " &
"INNER JOIN WMWHSE7.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY  " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU  " &
" LEFT JOIN WMWHSE7.DEPARTSECTORSKU DEPTO  " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,  " &
"                    clkp.description)  DSC  " &
"               from WMWHSE7.codelkup clkp  " &
"          left join WMWHSE7.translationlist trans  " &
"                 on trans.code = clkp.code  " &
"                and trans.joinkey1 = clkp.listname  " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'  " &
"              where clkp.listname = 'RECEIPTYPE'  " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE  " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301  " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)  " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947  " &
"        ON tdrec947.t$ncmp$l = 301  " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg  " &
"       AND tdrec947.t$orno$l = whinh301.t$worn  " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon  " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn  " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941  " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l  " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l  " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940  " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l  " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l  " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c  " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c  " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l  " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l  " &
" LEFT JOIN WMWHSE7.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY  " &
"       AND h.STATUS = 9  " &
"     WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  " &
"                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"                     AT time zone sessiontimezone) AS DATE))  " &
"           Between '" + Parameters!DataRectoDe.Value + "'  " &
"               And '" + Parameters!DataRectoAte.Value + "'  " &
"       AND r.type IN (" + Replace(("'" + JOIN(Parameters!TipoOrdem.Value, "',") + "'"),",",",'") + ")  " &
"       AND (    (Trim(d.RECEIPTKEY) IN ( " + IIF(Trim(Parameters!ASN.Value) = "", "''", "'" + Replace(Replace(Parameters!ASN.Value, " ", ""), ",", "','") + "'")  + " )  " &
"            AND (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!ASN.Value) = "", "1", "0") + " = 1) )  " &
"       AND (    (tdrec941.t$qnty$l = " + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "''", Parameters!Qtde_Pecas.Value)  + "  " &
"            AND (" + IIF(Trim(Parameters!Qtde_Pecas.Value) = "", "1", "0") + " = 0))  " &
"             OR (" + IIF(Trim(Parameters!Qtde_Pecas.Value)  = "", "1", "0") + " = 1) )  " &
"ORDER BY DESC_ARMAZEM, DATA_LANCTO, ASN, ITEM "

)