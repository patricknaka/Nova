SELECT DISTINCT
       d.WHSEID                      ARMAZEM,                                --01
       cl.UDF2                       DESC_ARMAZEM,                           --02        
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.ADDDATE), 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE)  
                                     DATA_LANCTO,                            --03
       d.RECEIPTKEY                  ASN,                                    --04
       d.EXTERNLINENO                LINHA_ASN,                              --05
       CASE WHEN MAX(h.ADDWHO) IS NULL 
              THEN MAX(d.ADDWHO)
            ELSE MAX(h.ADDWHO) 
        END        OPERADOR,                                                 --06
       d.SKU                         ITEM,                                   --07
       SKU.DESCR                     DESCRICAO,                              --08
     ( select ALTSKU.ALTSKU
         from WMWHSE5.ALTSKU ALTSKU  
        where ALTSKU.SKU = d.SKU
          and rownum = 1 )           EAN,                                    --09
       SKU.SKUGROUP                  DEPART,                                 --10
       DEPTO.DEPART_NAME             NOME_DEPART,                            --11
       SKU.SKUGROUP2                 SETOR,                                  --12
       DEPTO.SECTOR_NAME             NOME_SETOR,                             --13
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.DATERECEIVED), 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE)
                                     DATA_RECBTO,                            --14   
       SUM(d.QTYEXPECTED)            QTDE_PCS_LANC,                          --15
       SUM(d.QTYRECEIVED)            QTDE_PCS_RECEBIDAS,                     --16
       tdrec941.t$fire$l             REF_FISCAL,                             --17
       tdrec941.t$line$l             LINHA_REF_FISCAL,                       --18
       TIPO_REC.DSC                  TIPO_ORDEM,                             --19
       tdrec940.t$fovn$l             CNPJ,                                   --20
       tdrec940.t$fids$l             FORNECEDOR,                             --21
       tccom130.t$cste               ESTADO,                                 --22
       tdrec940.t$docn$l             NOTA_FISCAL,                            --23
       tdrec940.t$seri$l             SERIE_NF,                               --24
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE)  
                                     DT_EMISSAO_ENT,                         --25
       tdrec941.t$opfc$l             CFOP,                                   --26
       MAX(tdrec941.t$qnty$l)        QTDE,                                   --27
       MAX(tdrec941.t$pric$l)        VALOR_UNITARIO,                         --28
       cisli940.t$docn$l             NF_SAIDA,                               --29
       cisli940.t$seri$l             SERIE_NF_SAIDA,                         --30
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE)  
                                     DT_EMISSAO_SAIDA,                       --31
       cisli940.t$cfrw$l             TRANSP_COLETA,                          --32
       tcmcs080.t$dsca               DESCR_TRANSP,                           --33
       MAX(j.ADDWHO)                 OPERADOR_FISCAL                         --34                 
        
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
       AND h.STATUS = 9                  --RECEBIDO (OPERADOR FÍSICO)
         
 LEFT JOIN WMWHSE5.RECEIPTSTATUSHISTORY j
        ON j.RECEIPTKEY = d.RECEIPTKEY 
       AND j.STATUS = 11                  --FECHADO (OPERADOR FISCAL)
                        
     WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(d.DATERECEIVED,  
                         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                         AT time zone 'America/Sao_Paulo') AS DATE))
           Between :DataRectoDe
               And :DataRectoAte
       AND r.type IN (:TipoOrdem) 
       AND ((:ASN_Todos = 0) OR (d.RECEIPTKEY IN (:ASN) AND :ASN_Todos = 1)) 
       AND ((:Qtde_Pecas is null) OR (tdrec941.t$qnty$l = :Qtde_Pecas)) 
   
  GROUP BY d.WHSEID,
           cl.UDF2, 
           d.RECEIPTKEY,
           d.EXTERNLINENO,
           d.SKU,
           SKU.DESCR,
           SKU.SKUGROUP,
           DEPTO.DEPART_NAME,
           SKU.SKUGROUP2,
           DEPTO.SECTOR_NAME,
           tdrec941.t$fire$l,
           tdrec941.t$line$l,
           TIPO_REC.DSC,
           tdrec940.t$fovn$l,
           tdrec940.t$fids$l,
           tccom130.t$cste,
           tdrec940.t$docn$l,
           tdrec940.t$seri$l,
           tdrec940.t$idat$l,
           tdrec941.t$opfc$l,
           cisli940.t$docn$l,
           cisli940.t$seri$l,
           cisli940.t$date$l,
           cisli940.t$cfrw$l,
           tcmcs080.t$dsca
        
  ORDER BY ASN, LINHA_ASN 

  
=IIF(Parameters!Table.Value <> "AAA",
  
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.ADDDATE),  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.EXTERNLINENO                LINHA_ASN,  " &
"       CASE WHEN MAX(h.ADDWHO) IS NULL   " &
"              THEN MAX(d.ADDWHO)   " &
"            ELSE MAX(h.ADDWHO)   " &
"        END        OPERADOR,   " &
"       d.SKU                         ITEM,   " &
"       SKU.DESCR                     DESCRICAO,  " &
"     ( select ALTSKU.ALTSKU  " &
"         from " + Parameters!Table.Value + ".ALTSKU ALTSKU  " &
"        where ALTSKU.SKU = d.SKU   " &
"          and rownum = 1 )           EAN,  " &
"       SKU.SKUGROUP                  DEPART,   " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.DATERECEIVED),   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       SUM(d.QTYEXPECTED)            QTDE_PCS_LANC,  " &
"       SUM(d.QTYRECEIVED)            QTDE_PCS_RECEBIDAS,   " &
"       tdrec941.t$fire$l             REF_FISCAL,   " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,   " &
"       TIPO_REC.DSC                  TIPO_ORDEM,   " &
"       tdrec940.t$fovn$l             CNPJ,   " &
"       tdrec940.t$fids$l             FORNECEDOR,   " &
"       tccom130.t$cste               ESTADO,   " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_ENT,   " &
"       tdrec941.t$opfc$l             CFOP,   " &
"       MAX(tdrec941.t$qnty$l)        QTDE,   " &
"       MAX(tdrec941.t$pric$l)        VALOR_UNITARIO,   " &
"       cisli940.t$docn$l             NF_SAIDA,   " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,   " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP,   " &
"       MAX(j.ADDWHO)                 OPERADOR_FISCAL   " &   
"FROM       " + Parameters!Table.Value + ".RECEIPTDETAIL  d  " &
"   " &
"INNER JOIN " + Parameters!Table.Value + ".RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY   " &
"   " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU   " &
"   " &
" LEFT JOIN " + Parameters!Table.Value + ".DEPARTSECTORSKU DEPTO   " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)   " &
"   " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,   " &
"                    clkp.description)  DSC   " &
"               from " + Parameters!Table.Value + ".codelkup clkp  " &
"          left join " + Parameters!Table.Value + ".translationlist trans  " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'   " &
"              where clkp.listname = 'RECEIPTYPE'   " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE   " &
"   " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
"   " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301   " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)   " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
"   " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947   " &
"        ON tdrec947.t$ncmp$l = 301   " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg   " &
"       AND tdrec947.t$orno$l = whinh301.t$worn   " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon   " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn   " &
"   " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941   " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l   " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l   " &
"   " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940   " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l   " &
"   " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c   " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c   " &
"   " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l   " &
"   " &
" LEFT JOIN " + Parameters!Table.Value + ".RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND h.STATUS = 9  " &
"   " &
" LEFT JOIN " + Parameters!Table.Value + ".RECEIPTSTATUSHISTORY j  " &
"        ON j.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND j.STATUS = 11   " &
"   " &
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
"   " &
"  GROUP BY d.WHSEID,   " &
"           cl.UDF2,  " &
"           d.RECEIPTKEY,   " &
"           d.EXTERNLINENO,   " &
"           d.SKU,  " &
"           SKU.DESCR,  " &
"           SKU.SKUGROUP,   " &
"           DEPTO.DEPART_NAME,  " &
"           SKU.SKUGROUP2,  " &
"           DEPTO.SECTOR_NAME,  " &
"           tdrec941.t$fire$l,  " &
"           tdrec941.t$line$l,  " &
"           TIPO_REC.DSC,   " &
"           tdrec940.t$fovn$l,  " &
"           tdrec940.t$fids$l,  " &
"           tccom130.t$cste,  " &
"           tdrec940.t$docn$l,  " &
"           tdrec940.t$seri$l,  " &
"           tdrec940.t$idat$l,  " &
"           tdrec941.t$opfc$l,  " &
"           cisli940.t$docn$l,  " &
"           cisli940.t$seri$l,  " &
"           cisli940.t$date$l,  " &
"           cisli940.t$cfrw$l,  " &
"           tcmcs080.t$dsca   " &
"   " &
"ORDER BY DATA_LANCTO, ASN, ITEM "  
  
,

"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.ADDDATE),  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.EXTERNLINENO                LINHA_ASN,  " &
"       CASE WHEN MAX(h.ADDWHO) IS NULL   " &
"              THEN MAX(d.ADDWHO)   " &
"            ELSE MAX(h.ADDWHO)   " &
"        END        OPERADOR,   " &
"       d.SKU                         ITEM,   " &
"       SKU.DESCR                     DESCRICAO,  " &
"     ( select ALTSKU.ALTSKU  " &
"         from WMWHSE1.ALTSKU ALTSKU  " &
"        where ALTSKU.SKU = d.SKU   " &
"          and rownum = 1 )           EAN,  " &
"       SKU.SKUGROUP                  DEPART,   " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.DATERECEIVED),   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       SUM(d.QTYEXPECTED)            QTDE_PCS_LANC,  " &
"       SUM(d.QTYRECEIVED)            QTDE_PCS_RECEBIDAS,   " &
"       tdrec941.t$fire$l             REF_FISCAL,   " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,   " &
"       TIPO_REC.DSC                  TIPO_ORDEM,   " &
"       tdrec940.t$fovn$l             CNPJ,   " &
"       tdrec940.t$fids$l             FORNECEDOR,   " &
"       tccom130.t$cste               ESTADO,   " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_ENT,   " &
"       tdrec941.t$opfc$l             CFOP,   " &
"       MAX(tdrec941.t$qnty$l)        QTDE,   " &
"       MAX(tdrec941.t$pric$l)        VALOR_UNITARIO,   " &
"       cisli940.t$docn$l             NF_SAIDA,   " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,   " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP,   " &
"       MAX(j.ADDWHO)                 OPERADOR_FISCAL   " &   
"FROM       WMWHSE1.RECEIPTDETAIL  d  " &
"   " &
"INNER JOIN WMWHSE1.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY   " &
"   " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU   " &
"   " &
" LEFT JOIN WMWHSE1.DEPARTSECTORSKU DEPTO   " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)   " &
"   " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,   " &
"                    clkp.description)  DSC   " &
"               from WMWHSE1.codelkup clkp  " &
"          left join WMWHSE1.translationlist trans  " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'   " &
"              where clkp.listname = 'RECEIPTYPE'   " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE   " &
"   " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
"   " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301   " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)   " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
"   " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947   " &
"        ON tdrec947.t$ncmp$l = 301   " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg   " &
"       AND tdrec947.t$orno$l = whinh301.t$worn   " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon   " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn   " &
"   " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941   " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l   " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l   " &
"   " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940   " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l   " &
"   " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c   " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c   " &
"   " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l   " &
"   " &
" LEFT JOIN WMWHSE1.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND h.STATUS = 9  " &
"   " &
" LEFT JOIN WMWHSE1.RECEIPTSTATUSHISTORY j  " &
"        ON j.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND j.STATUS = 11   " &
"   " &
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
"   " &
"  GROUP BY d.WHSEID,   " &
"           cl.UDF2,  " &
"           d.RECEIPTKEY,   " &
"           d.EXTERNLINENO,   " &
"           d.SKU,  " &
"           SKU.DESCR,  " &
"           SKU.SKUGROUP,   " &
"           DEPTO.DEPART_NAME,  " &
"           SKU.SKUGROUP2,  " &
"           DEPTO.SECTOR_NAME,  " &
"           tdrec941.t$fire$l,  " &
"           tdrec941.t$line$l,  " &
"           TIPO_REC.DSC,   " &
"           tdrec940.t$fovn$l,  " &
"           tdrec940.t$fids$l,  " &
"           tccom130.t$cste,  " &
"           tdrec940.t$docn$l,  " &
"           tdrec940.t$seri$l,  " &
"           tdrec940.t$idat$l,  " &
"           tdrec941.t$opfc$l,  " &
"           cisli940.t$docn$l,  " &
"           cisli940.t$seri$l,  " &
"           cisli940.t$date$l,  " &
"           cisli940.t$cfrw$l,  " &
"           tcmcs080.t$dsca   " &
"   " &
"Union  " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.ADDDATE),  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.EXTERNLINENO                LINHA_ASN,  " &
"       CASE WHEN MAX(h.ADDWHO) IS NULL   " &
"              THEN MAX(d.ADDWHO)   " &
"            ELSE MAX(h.ADDWHO)   " &
"        END        OPERADOR,   " &
"       d.SKU                         ITEM,   " &
"       SKU.DESCR                     DESCRICAO,  " &
"     ( select ALTSKU.ALTSKU  " &
"         from WMWHSE2.ALTSKU ALTSKU  " &
"        where ALTSKU.SKU = d.SKU   " &
"          and rownum = 1 )           EAN,  " &
"       SKU.SKUGROUP                  DEPART,   " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.DATERECEIVED),   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       SUM(d.QTYEXPECTED)            QTDE_PCS_LANC,  " &
"       SUM(d.QTYRECEIVED)            QTDE_PCS_RECEBIDAS,   " &
"       tdrec941.t$fire$l             REF_FISCAL,   " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,   " &
"       TIPO_REC.DSC                  TIPO_ORDEM,   " &
"       tdrec940.t$fovn$l             CNPJ,   " &
"       tdrec940.t$fids$l             FORNECEDOR,   " &
"       tccom130.t$cste               ESTADO,   " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_ENT,   " &
"       tdrec941.t$opfc$l             CFOP,   " &
"       MAX(tdrec941.t$qnty$l)        QTDE,   " &
"       MAX(tdrec941.t$pric$l)        VALOR_UNITARIO,   " &
"       cisli940.t$docn$l             NF_SAIDA,   " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,   " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP,   " &
"       MAX(j.ADDWHO)                 OPERADOR_FISCAL   " &   
"FROM       WMWHSE2.RECEIPTDETAIL  d  " &
"   " &
"INNER JOIN WMWHSE2.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY   " &
"   " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU   " &
"   " &
" LEFT JOIN WMWHSE2.DEPARTSECTORSKU DEPTO   " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)   " &
"   " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,   " &
"                    clkp.description)  DSC   " &
"               from WMWHSE2.codelkup clkp  " &
"          left join WMWHSE2.translationlist trans  " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'   " &
"              where clkp.listname = 'RECEIPTYPE'   " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE   " &
"   " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
"   " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301   " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)   " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
"   " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947   " &
"        ON tdrec947.t$ncmp$l = 301   " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg   " &
"       AND tdrec947.t$orno$l = whinh301.t$worn   " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon   " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn   " &
"   " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941   " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l   " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l   " &
"   " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940   " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l   " &
"   " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c   " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c   " &
"   " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l   " &
"   " &
" LEFT JOIN WMWHSE2.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND h.STATUS = 9  " &
"   " &
" LEFT JOIN WMWHSE2.RECEIPTSTATUSHISTORY j  " &
"        ON j.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND j.STATUS = 11   " &
"   " &
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
"   " &
"  GROUP BY d.WHSEID,   " &
"           cl.UDF2,  " &
"           d.RECEIPTKEY,   " &
"           d.EXTERNLINENO,   " &
"           d.SKU,  " &
"           SKU.DESCR,  " &
"           SKU.SKUGROUP,   " &
"           DEPTO.DEPART_NAME,  " &
"           SKU.SKUGROUP2,  " &
"           DEPTO.SECTOR_NAME,  " &
"           tdrec941.t$fire$l,  " &
"           tdrec941.t$line$l,  " &
"           TIPO_REC.DSC,   " &
"           tdrec940.t$fovn$l,  " &
"           tdrec940.t$fids$l,  " &
"           tccom130.t$cste,  " &
"           tdrec940.t$docn$l,  " &
"           tdrec940.t$seri$l,  " &
"           tdrec940.t$idat$l,  " &
"           tdrec941.t$opfc$l,  " &
"           cisli940.t$docn$l,  " &
"           cisli940.t$seri$l,  " &
"           cisli940.t$date$l,  " &
"           cisli940.t$cfrw$l,  " &
"           tcmcs080.t$dsca   " &
"   " &
"Union  " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.ADDDATE),  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.EXTERNLINENO                LINHA_ASN,  " &
"       CASE WHEN MAX(h.ADDWHO) IS NULL   " &
"              THEN MAX(d.ADDWHO)   " &
"            ELSE MAX(h.ADDWHO)   " &
"        END        OPERADOR,   " &
"       d.SKU                         ITEM,   " &
"       SKU.DESCR                     DESCRICAO,  " &
"     ( select ALTSKU.ALTSKU  " &
"         from WMWHSE3.ALTSKU ALTSKU  " &
"        where ALTSKU.SKU = d.SKU   " &
"          and rownum = 1 )           EAN,  " &
"       SKU.SKUGROUP                  DEPART,   " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.DATERECEIVED),   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       SUM(d.QTYEXPECTED)            QTDE_PCS_LANC,  " &
"       SUM(d.QTYRECEIVED)            QTDE_PCS_RECEBIDAS,   " &
"       tdrec941.t$fire$l             REF_FISCAL,   " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,   " &
"       TIPO_REC.DSC                  TIPO_ORDEM,   " &
"       tdrec940.t$fovn$l             CNPJ,   " &
"       tdrec940.t$fids$l             FORNECEDOR,   " &
"       tccom130.t$cste               ESTADO,   " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_ENT,   " &
"       tdrec941.t$opfc$l             CFOP,   " &
"       MAX(tdrec941.t$qnty$l)        QTDE,   " &
"       MAX(tdrec941.t$pric$l)        VALOR_UNITARIO,   " &
"       cisli940.t$docn$l             NF_SAIDA,   " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,   " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP,   " &
"       MAX(j.ADDWHO)                 OPERADOR_FISCAL   " &   
"FROM       WMWHSE3.RECEIPTDETAIL  d  " &
"   " &
"INNER JOIN WMWHSE3.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY   " &
"   " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU   " &
"   " &
" LEFT JOIN WMWHSE3.DEPARTSECTORSKU DEPTO   " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)   " &
"   " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,   " &
"                    clkp.description)  DSC   " &
"               from WMWHSE3.codelkup clkp  " &
"          left join WMWHSE3.translationlist trans  " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'   " &
"              where clkp.listname = 'RECEIPTYPE'   " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE   " &
"   " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
"   " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301   " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)   " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
"   " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947   " &
"        ON tdrec947.t$ncmp$l = 301   " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg   " &
"       AND tdrec947.t$orno$l = whinh301.t$worn   " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon   " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn   " &
"   " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941   " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l   " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l   " &
"   " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940   " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l   " &
"   " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c   " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c   " &
"   " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l   " &
"   " &
" LEFT JOIN WMWHSE3.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND h.STATUS = 9  " &
"   " &
" LEFT JOIN WMWHSE3.RECEIPTSTATUSHISTORY j  " &
"        ON j.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND j.STATUS = 11   " &
"   " &
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
"   " &
"  GROUP BY d.WHSEID,   " &
"           cl.UDF2,  " &
"           d.RECEIPTKEY,   " &
"           d.EXTERNLINENO,   " &
"           d.SKU,  " &
"           SKU.DESCR,  " &
"           SKU.SKUGROUP,   " &
"           DEPTO.DEPART_NAME,  " &
"           SKU.SKUGROUP2,  " &
"           DEPTO.SECTOR_NAME,  " &
"           tdrec941.t$fire$l,  " &
"           tdrec941.t$line$l,  " &
"           TIPO_REC.DSC,   " &
"           tdrec940.t$fovn$l,  " &
"           tdrec940.t$fids$l,  " &
"           tccom130.t$cste,  " &
"           tdrec940.t$docn$l,  " &
"           tdrec940.t$seri$l,  " &
"           tdrec940.t$idat$l,  " &
"           tdrec941.t$opfc$l,  " &
"           cisli940.t$docn$l,  " &
"           cisli940.t$seri$l,  " &
"           cisli940.t$date$l,  " &
"           cisli940.t$cfrw$l,  " &
"           tcmcs080.t$dsca   " &
"   " &
"Union  " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.ADDDATE),  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.EXTERNLINENO                LINHA_ASN,  " &
"       CASE WHEN MAX(h.ADDWHO) IS NULL   " &
"              THEN MAX(d.ADDWHO)   " &
"            ELSE MAX(h.ADDWHO)   " &
"        END        OPERADOR,   " &
"       d.SKU                         ITEM,   " &
"       SKU.DESCR                     DESCRICAO,  " &
"     ( select ALTSKU.ALTSKU  " &
"         from WMWHSE4.ALTSKU ALTSKU  " &
"        where ALTSKU.SKU = d.SKU   " &
"          and rownum = 1 )           EAN,  " &
"       SKU.SKUGROUP                  DEPART,   " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.DATERECEIVED),   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       SUM(d.QTYEXPECTED)            QTDE_PCS_LANC,  " &
"       SUM(d.QTYRECEIVED)            QTDE_PCS_RECEBIDAS,   " &
"       tdrec941.t$fire$l             REF_FISCAL,   " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,   " &
"       TIPO_REC.DSC                  TIPO_ORDEM,   " &
"       tdrec940.t$fovn$l             CNPJ,   " &
"       tdrec940.t$fids$l             FORNECEDOR,   " &
"       tccom130.t$cste               ESTADO,   " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_ENT,   " &
"       tdrec941.t$opfc$l             CFOP,   " &
"       MAX(tdrec941.t$qnty$l)        QTDE,   " &
"       MAX(tdrec941.t$pric$l)        VALOR_UNITARIO,   " &
"       cisli940.t$docn$l             NF_SAIDA,   " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,   " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP,   " &
"       MAX(j.ADDWHO)                 OPERADOR_FISCAL   " &   
"FROM       WMWHSE4.RECEIPTDETAIL  d  " &
"   " &
"INNER JOIN WMWHSE4.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY   " &
"   " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU   " &
"   " &
" LEFT JOIN WMWHSE4.DEPARTSECTORSKU DEPTO   " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)   " &
"   " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,   " &
"                    clkp.description)  DSC   " &
"               from WMWHSE4.codelkup clkp  " &
"          left join WMWHSE4.translationlist trans  " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'   " &
"              where clkp.listname = 'RECEIPTYPE'   " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE   " &
"   " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
"   " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301   " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)   " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
"   " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947   " &
"        ON tdrec947.t$ncmp$l = 301   " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg   " &
"       AND tdrec947.t$orno$l = whinh301.t$worn   " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon   " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn   " &
"   " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941   " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l   " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l   " &
"   " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940   " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l   " &
"   " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c   " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c   " &
"   " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l   " &
"   " &
" LEFT JOIN WMWHSE4.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND h.STATUS = 9  " &
"   " &
" LEFT JOIN WMWHSE4.RECEIPTSTATUSHISTORY j  " &
"        ON j.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND j.STATUS = 11   " &
"   " &
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
"   " &
"  GROUP BY d.WHSEID,   " &
"           cl.UDF2,  " &
"           d.RECEIPTKEY,   " &
"           d.EXTERNLINENO,   " &
"           d.SKU,  " &
"           SKU.DESCR,  " &
"           SKU.SKUGROUP,   " &
"           DEPTO.DEPART_NAME,  " &
"           SKU.SKUGROUP2,  " &
"           DEPTO.SECTOR_NAME,  " &
"           tdrec941.t$fire$l,  " &
"           tdrec941.t$line$l,  " &
"           TIPO_REC.DSC,   " &
"           tdrec940.t$fovn$l,  " &
"           tdrec940.t$fids$l,  " &
"           tccom130.t$cste,  " &
"           tdrec940.t$docn$l,  " &
"           tdrec940.t$seri$l,  " &
"           tdrec940.t$idat$l,  " &
"           tdrec941.t$opfc$l,  " &
"           cisli940.t$docn$l,  " &
"           cisli940.t$seri$l,  " &
"           cisli940.t$date$l,  " &
"           cisli940.t$cfrw$l,  " &
"           tcmcs080.t$dsca   " &
"   " &
"Union  " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.ADDDATE),  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.EXTERNLINENO                LINHA_ASN,  " &
"       CASE WHEN MAX(h.ADDWHO) IS NULL   " &
"              THEN MAX(d.ADDWHO)   " &
"            ELSE MAX(h.ADDWHO)   " &
"        END        OPERADOR,   " &
"       d.SKU                         ITEM,   " &
"       SKU.DESCR                     DESCRICAO,  " &
"     ( select ALTSKU.ALTSKU  " &
"         from WMWHSE5.ALTSKU ALTSKU  " &
"        where ALTSKU.SKU = d.SKU   " &
"          and rownum = 1 )           EAN,  " &
"       SKU.SKUGROUP                  DEPART,   " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.DATERECEIVED),   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       SUM(d.QTYEXPECTED)            QTDE_PCS_LANC,  " &
"       SUM(d.QTYRECEIVED)            QTDE_PCS_RECEBIDAS,   " &
"       tdrec941.t$fire$l             REF_FISCAL,   " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,   " &
"       TIPO_REC.DSC                  TIPO_ORDEM,   " &
"       tdrec940.t$fovn$l             CNPJ,   " &
"       tdrec940.t$fids$l             FORNECEDOR,   " &
"       tccom130.t$cste               ESTADO,   " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_ENT,   " &
"       tdrec941.t$opfc$l             CFOP,   " &
"       MAX(tdrec941.t$qnty$l)        QTDE,   " &
"       MAX(tdrec941.t$pric$l)        VALOR_UNITARIO,   " &
"       cisli940.t$docn$l             NF_SAIDA,   " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,   " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP,   " &
"       MAX(j.ADDWHO)                 OPERADOR_FISCAL   " &   
"FROM       WMWHSE5.RECEIPTDETAIL  d  " &
"   " &
"INNER JOIN WMWHSE5.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY   " &
"   " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU   " &
"   " &
" LEFT JOIN WMWHSE5.DEPARTSECTORSKU DEPTO   " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)   " &
"   " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,   " &
"                    clkp.description)  DSC   " &
"               from WMWHSE5.codelkup clkp  " &
"          left join WMWHSE5.translationlist trans  " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'   " &
"              where clkp.listname = 'RECEIPTYPE'   " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE   " &
"   " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
"   " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301   " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)   " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
"   " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947   " &
"        ON tdrec947.t$ncmp$l = 301   " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg   " &
"       AND tdrec947.t$orno$l = whinh301.t$worn   " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon   " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn   " &
"   " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941   " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l   " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l   " &
"   " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940   " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l   " &
"   " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c   " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c   " &
"   " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l   " &
"   " &
" LEFT JOIN WMWHSE5.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND h.STATUS = 9  " &
"   " &
" LEFT JOIN WMWHSE5.RECEIPTSTATUSHISTORY j  " &
"        ON j.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND j.STATUS = 11   " &
"   " &
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
"   " &
"  GROUP BY d.WHSEID,   " &
"           cl.UDF2,  " &
"           d.RECEIPTKEY,   " &
"           d.EXTERNLINENO,   " &
"           d.SKU,  " &
"           SKU.DESCR,  " &
"           SKU.SKUGROUP,   " &
"           DEPTO.DEPART_NAME,  " &
"           SKU.SKUGROUP2,  " &
"           DEPTO.SECTOR_NAME,  " &
"           tdrec941.t$fire$l,  " &
"           tdrec941.t$line$l,  " &
"           TIPO_REC.DSC,   " &
"           tdrec940.t$fovn$l,  " &
"           tdrec940.t$fids$l,  " &
"           tccom130.t$cste,  " &
"           tdrec940.t$docn$l,  " &
"           tdrec940.t$seri$l,  " &
"           tdrec940.t$idat$l,  " &
"           tdrec941.t$opfc$l,  " &
"           cisli940.t$docn$l,  " &
"           cisli940.t$seri$l,  " &
"           cisli940.t$date$l,  " &
"           cisli940.t$cfrw$l,  " &
"           tcmcs080.t$dsca   " &
"   " &
"Union  " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.ADDDATE),  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.EXTERNLINENO                LINHA_ASN,  " &
"       CASE WHEN MAX(h.ADDWHO) IS NULL   " &
"              THEN MAX(d.ADDWHO)   " &
"            ELSE MAX(h.ADDWHO)   " &
"        END        OPERADOR,   " &
"       d.SKU                         ITEM,   " &
"       SKU.DESCR                     DESCRICAO,  " &
"     ( select ALTSKU.ALTSKU  " &
"         from WMWHSE6.ALTSKU ALTSKU  " &
"        where ALTSKU.SKU = d.SKU   " &
"          and rownum = 1 )           EAN,  " &
"       SKU.SKUGROUP                  DEPART,   " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.DATERECEIVED),   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       SUM(d.QTYEXPECTED)            QTDE_PCS_LANC,  " &
"       SUM(d.QTYRECEIVED)            QTDE_PCS_RECEBIDAS,   " &
"       tdrec941.t$fire$l             REF_FISCAL,   " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,   " &
"       TIPO_REC.DSC                  TIPO_ORDEM,   " &
"       tdrec940.t$fovn$l             CNPJ,   " &
"       tdrec940.t$fids$l             FORNECEDOR,   " &
"       tccom130.t$cste               ESTADO,   " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_ENT,   " &
"       tdrec941.t$opfc$l             CFOP,   " &
"       MAX(tdrec941.t$qnty$l)        QTDE,   " &
"       MAX(tdrec941.t$pric$l)        VALOR_UNITARIO,   " &
"       cisli940.t$docn$l             NF_SAIDA,   " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,   " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP,   " &
"       MAX(j.ADDWHO)                 OPERADOR_FISCAL   " &   
"FROM       WMWHSE6.RECEIPTDETAIL  d  " &
"   " &
"INNER JOIN WMWHSE6.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY   " &
"   " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU   " &
"   " &
" LEFT JOIN WMWHSE6.DEPARTSECTORSKU DEPTO   " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)   " &
"   " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,   " &
"                    clkp.description)  DSC   " &
"               from WMWHSE6.codelkup clkp  " &
"          left join WMWHSE6.translationlist trans  " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'   " &
"              where clkp.listname = 'RECEIPTYPE'   " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE   " &
"   " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
"   " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301   " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)   " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
"   " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947   " &
"        ON tdrec947.t$ncmp$l = 301   " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg   " &
"       AND tdrec947.t$orno$l = whinh301.t$worn   " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon   " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn   " &
"   " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941   " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l   " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l   " &
"   " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940   " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l   " &
"   " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c   " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c   " &
"   " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l   " &
"   " &
" LEFT JOIN WMWHSE6.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND h.STATUS = 9  " &
"   " &
" LEFT JOIN WMWHSE6.RECEIPTSTATUSHISTORY j  " &
"        ON j.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND j.STATUS = 11   " &
"   " &
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
"   " &
"  GROUP BY d.WHSEID,   " &
"           cl.UDF2,  " &
"           d.RECEIPTKEY,   " &
"           d.EXTERNLINENO,   " &
"           d.SKU,  " &
"           SKU.DESCR,  " &
"           SKU.SKUGROUP,   " &
"           DEPTO.DEPART_NAME,  " &
"           SKU.SKUGROUP2,  " &
"           DEPTO.SECTOR_NAME,  " &
"           tdrec941.t$fire$l,  " &
"           tdrec941.t$line$l,  " &
"           TIPO_REC.DSC,   " &
"           tdrec940.t$fovn$l,  " &
"           tdrec940.t$fids$l,  " &
"           tccom130.t$cste,  " &
"           tdrec940.t$docn$l,  " &
"           tdrec940.t$seri$l,  " &
"           tdrec940.t$idat$l,  " &
"           tdrec941.t$opfc$l,  " &
"           cisli940.t$docn$l,  " &
"           cisli940.t$seri$l,  " &
"           cisli940.t$date$l,  " &
"           cisli940.t$cfrw$l,  " &
"           tcmcs080.t$dsca   " &
"   " &
"Union  " &
"SELECT DISTINCT  " &
"       d.WHSEID                      ARMAZEM,  " &
"       cl.UDF2                       DESC_ARMAZEM,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.ADDDATE),  " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_LANCTO,  " &
"       d.RECEIPTKEY                  ASN,  " &
"       d.EXTERNLINENO                LINHA_ASN,  " &
"       CASE WHEN MAX(h.ADDWHO) IS NULL   " &
"              THEN MAX(d.ADDWHO)   " &
"            ELSE MAX(h.ADDWHO)   " &
"        END        OPERADOR,   " &
"       d.SKU                         ITEM,   " &
"       SKU.DESCR                     DESCRICAO,  " &
"     ( select ALTSKU.ALTSKU  " &
"         from WMWHSE7.ALTSKU ALTSKU  " &
"        where ALTSKU.SKU = d.SKU   " &
"          and rownum = 1 )           EAN,  " &
"       SKU.SKUGROUP                  DEPART,   " &
"       DEPTO.DEPART_NAME             NOME_DEPART,  " &
"       SKU.SKUGROUP2                 SETOR,  " &
"       DEPTO.SECTOR_NAME             NOME_SETOR,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(d.DATERECEIVED),   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DATA_RECBTO,  " &
"       SUM(d.QTYEXPECTED)            QTDE_PCS_LANC,  " &
"       SUM(d.QTYRECEIVED)            QTDE_PCS_RECEBIDAS,   " &
"       tdrec941.t$fire$l             REF_FISCAL,   " &
"       tdrec941.t$line$l             LINHA_REF_FISCAL,   " &
"       TIPO_REC.DSC                  TIPO_ORDEM,   " &
"       tdrec940.t$fovn$l             CNPJ,   " &
"       tdrec940.t$fids$l             FORNECEDOR,   " &
"       tccom130.t$cste               ESTADO,   " &
"       tdrec940.t$docn$l             NOTA_FISCAL,  " &
"       tdrec940.t$seri$l             SERIE_NF,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_ENT,   " &
"       tdrec941.t$opfc$l             CFOP,   " &
"       MAX(tdrec941.t$qnty$l)        QTDE,   " &
"       MAX(tdrec941.t$pric$l)        VALOR_UNITARIO,   " &
"       cisli940.t$docn$l             NF_SAIDA,   " &
"       cisli940.t$seri$l             SERIE_NF_SAIDA,   " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,   " &
"             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                     DT_EMISSAO_SAIDA,   " &
"       cisli940.t$cfrw$l             TRANSP_COLETA,  " &
"       tcmcs080.t$dsca               DESCR_TRANSP,   " &
"       MAX(j.ADDWHO)                 OPERADOR_FISCAL   " &   
"FROM       WMWHSE7.RECEIPTDETAIL  d  " &
"   " &
"INNER JOIN WMWHSE7.RECEIPT  r  " &
"        ON r.RECEIPTKEY = d.RECEIPTKEY   " &
"   " &
"INNER JOIN ENTERPRISE.SKU SKU  " &
"        ON SKU.SKU = d.SKU   " &
"   " &
" LEFT JOIN WMWHSE7.DEPARTSECTORSKU DEPTO   " &
"        ON TO_CHAR(DEPTO.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"       AND TO_CHAR(DEPTO.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)   " &
"   " &
" LEFT JOIN ( select clkp.code          COD,  " &
"                    NVL(trans.description,   " &
"                    clkp.description)  DSC   " &
"               from WMWHSE7.codelkup clkp  " &
"          left join WMWHSE7.translationlist trans  " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"                and trans.locale = 'pt'  " &
"                and trans.tblname = 'CODELKUP'   " &
"              where clkp.listname = 'RECEIPTYPE'   " &
"                and Trim(clkp.code) is not null  ) TIPO_REC  " &
"        ON TIPO_REC.COD = r.TYPE   " &
"   " &
" LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"        ON UPPER(cl.UDF1) = UPPER(r.WHSEID)  " &
"   " &
" LEFT JOIN baandb.twhinh301301@pln01  whinh301   " &
"        ON whinh301.t$sfbp = SUBSTR(d.EXTERNRECEIPTKEY,3,9)  " &
"       AND whinh301.t$shid = SUBSTR(d.EXTERNRECEIPTKEY,13,9)   " &
"       AND TO_CHAR(whinh301.t$shsq) = TO_CHAR(d.EXTERNLINENO)  " &
"   " &
" LEFT JOIN baandb.ttdrec947301@pln01  tdrec947   " &
"        ON tdrec947.t$ncmp$l = 301   " &
"       AND tdrec947.t$oorg$l = whinh301.t$oorg   " &
"       AND tdrec947.t$orno$l = whinh301.t$worn   " &
"       AND tdrec947.t$pono$l = whinh301.t$wpon   " &
"       AND tdrec947.t$seqn$l = whinh301.t$wsqn   " &
"   " &
" LEFT JOIN baandb.ttdrec941301@pln01  tdrec941   " &
"        ON tdrec941.t$fire$l = tdrec947.t$fire$l   " &
"       AND tdrec941.t$line$l = tdrec947.t$line$l   " &
"   " &
" LEFT JOIN baandb.ttdrec940301@pln01  tdrec940   " &
"        ON tdrec940.t$fire$l = tdrec941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttcmcs080301@pln01 tcmcs080  " &
"        ON tcmcs080.t$cfrw = tdrec940.t$cfrw$l   " &
"   " &
" LEFT JOIN baandb.tcisli941301@pln01 cisli941  " &
"        ON cisli941.t$fire$l = tdrec941.t$dvrf$c   " &
"       AND cisli941.t$line$l = tdrec941.t$dvln$c   " &
"   " &
" LEFT JOIN baandb.tcisli940301@pln01 cisli940  " &
"        ON cisli940.t$fire$l = cisli941.t$fire$l   " &
"   " &
" LEFT JOIN baandb.ttccom130301@pln01 tccom130  " &
"        ON tccom130.t$cadr = tdrec940.t$sfad$l   " &
"   " &
" LEFT JOIN WMWHSE7.RECEIPTSTATUSHISTORY h  " &
"        ON h.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND h.STATUS = 9  " &
"   " &
" LEFT JOIN WMWHSE7.RECEIPTSTATUSHISTORY j  " &
"        ON j.RECEIPTKEY = d.RECEIPTKEY   " &
"       AND j.STATUS = 11   " &
"   " &
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
"   " &
"  GROUP BY d.WHSEID,   " &
"           cl.UDF2,  " &
"           d.RECEIPTKEY,   " &
"           d.EXTERNLINENO,   " &
"           d.SKU,  " &
"           SKU.DESCR,  " &
"           SKU.SKUGROUP,   " &
"           DEPTO.DEPART_NAME,  " &
"           SKU.SKUGROUP2,  " &
"           DEPTO.SECTOR_NAME,  " &
"           tdrec941.t$fire$l,  " &
"           tdrec941.t$line$l,  " &
"           TIPO_REC.DSC,   " &
"           tdrec940.t$fovn$l,  " &
"           tdrec940.t$fids$l,  " &
"           tccom130.t$cste,  " &
"           tdrec940.t$docn$l,  " &
"           tdrec940.t$seri$l,  " &
"           tdrec940.t$idat$l,  " &
"           tdrec941.t$opfc$l,  " &
"           cisli940.t$docn$l,  " &
"           cisli940.t$seri$l,  " &
"           cisli940.t$date$l,  " &
"           cisli940.t$cfrw$l,  " &
"           tcmcs080.t$dsca   " &
"   " &
"ORDER BY DESC_ARMAZEM, DATA_LANCTO, ASN, ITEM "

)