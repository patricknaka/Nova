SELECT 
  DISTINCT
    FILIAL.DSC_FILIAL        FILIAL,
    cisli940.t$docn$l        NF,
    cisli940.t$seri$l        SERIE,
    WMS_OA_ORDERS.ORDERKEY   PEDIDO_WMS,
    CODELKUP_OA.DESCRIPTION  DESCRICAO_PEDIDO,
      
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                             DT_EMISSAO,
    
    cisli940.t$ccfo$l        CFO,
    cisli940.t$opor$l        SEQ_CFO,    
    tcmcs940.t$dsca$l        NOME_CFO,
    znsls400.t$idca$c        CANAL,
    TRIM(cisli941.t$item$l)  ID_ITEM,
    tcibd001.t$dsca          NOME_ITEM,
    cisli941.t$dqua$l        QTD_FATURADA,
    CASE WHEN cisli941.t$iprt$l=0 THEN
		tdsls401.t$pric ELSE
		cisli941.t$iprt$l
		END	 				 VL_PRODUTO,
    CASE WHEN cisli941.t$amnt$l=0 THEN
		tdsls401.t$oamt ELSE
		cisli941.t$amnt$l
		END	    			 VL_TOTAL_ITEM,
    CASE WHEN cisli941.t$gamt$l=0 THEN
		tdsls401.t$pric ELSE
		cisli941.t$gamt$l
		END					 VL_MERCADORIA,
    CASE WHEN cisli941.t$fght$l=0 THEN
			znsls401.t$vlfr$c ELSE
			cisli941.t$fght$l
		END					 VL_FRETE,
	
    CASE WHEN cisli941.t$ldam$l=0 THEN
			znsls401.t$vlde$c ELSE 
			cisli941.t$ldam$l 
	END 					 VL_DESC_INC,
    
    NVL(( select cisli943.t$amnt$l 
            from baandb.tcisli943301 cisli943
           where cisli943.t$fire$l = cisli941.t$fire$l
             and cisli943.t$line$l = cisli941.t$line$l
             and cisli943.t$brty$l = 1 ), 0)
                             VL_ICMS,
    
    NVL(( select cisli943.t$amnt$l 
            from baandb.tcisli943301 cisli943
           where cisli943.t$fire$l = cisli941.t$fire$l
             and cisli943.t$line$l = cisli941.t$line$l
             and cisli943.t$brty$l = 5 ), 0)
                             VL_PIS,
    
    NVL(( select cisli943.t$amnt$l 
            from baandb.tcisli943301 cisli943
           where cisli943.t$fire$l = cisli941.t$fire$l
             and cisli943.t$line$l = cisli941.t$line$l
             and cisli943.t$brty$l = 6 ), 0)
                             VL_COFINS,
       
    cisli940.t$itbp$l        ID_CLIENTE,
    cisli940.t$itbn$l        NOME_CLIENTE,
    tccom130.t$namc          ENDERECO,
    tccom130.t$dist$l        BAIRRO,
    tccom130.t$pstc          CEP,
    tccom130.t$ln03          MUNICIPIO,
    tccom130.t$cste          UF,
    tccom130.t$telp          TEL1,
    tccom130.t$telx          TEL2,
    tccom130.t$enfs$l        EMAIL,
    cisli940.t$fdtc$l        ID_TIPO_DOC_FIS,
    tcmcs966.t$dsca$l        DESCR_TIPO_DOC_FIS,
                             DESC_TIPO_DOCTO
                             
FROM       baandb.tcisli940301 cisli940

INNER JOIN ( select tcemm030.t$eunt CHAVE_FILIAL,
                    tcemm030.t$dsca DSC_FILIAL,
                    tcemm124.t$cwoc
               from baandb.ttcemm124301 tcemm124, 
                    baandb.ttcemm030301 tcemm030
              where tcemm030.t$eunt = tcemm124.t$grid
                and tcemm124.t$loco = 301 ) FILIAL
        ON FILIAL.t$cwoc = cisli940.t$cofc$l 

 LEFT JOIN baandb.ttcmcs940301 tcmcs940 
        ON tcmcs940.T$OFSO$L = cisli940.t$ccfo$l

INNER JOIN baandb.tcisli941301 cisli941
        ON cisli941.t$fire$l = cisli940.t$fire$l
  
INNER JOIN baandb.tcisli245301 cisli245
        ON cisli245.t$fire$l = cisli941.t$fire$l
       AND cisli245.t$line$l = cisli941.t$line$l

 LEFT JOIN baandb.tznsls401301 znsls401
        ON znsls401.t$orno$c = cisli245.t$slso
       AND znsls401.t$pono$c = cisli245.t$pono
	   
 LEFT JOIN baandb.ttdsls401301 tdsls401 
        ON tdsls401.t$orno = cisli245.t$slso 

 LEFT JOIN baandb.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
  
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr   = cisli940.t$itoa$l
  
INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item   = cisli941.t$item$l
  
 LEFT JOIN baandb.ttcmcs966301 tcmcs966
        ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l
  
 LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOCTO
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'ci' 
                AND d.t$cdom = 'sli.tdff.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) FGET
        ON cisli940.t$fdty$l = FGET.CNST

     
INNER JOIN WMWHSE5.ORDERS@DL_LN_WMS WMS_OA_ORDERS
        ON SUBSTR(WMS_OA_ORDERS.EXTERNORDERKEY,5,9) = CISLI245.T$SHPM
             
 LEFT JOIN WMWHSE5.CODELKUP@DL_LN_WMS CODELKUP_OA
        ON CODELKUP_OA.LISTNAME = 'ORDERTYPE'
       AND CODELKUP_OA.CODE = WMS_OA_ORDERS.TYPE
        
WHERE cisli940.t$fdty$l != 11
  AND cisli940.t$docn$l != 0
  AND cisli940.t$stat$l NOT IN (2,101)

  -- AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                -- 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  -- AT time zone sessiontimezone) AS DATE)) 
        -- Between :EmissaoDe
            -- And :EmissaoAte

ORDER BY FILIAL, 
         DT_EMISSAO, 
         NF

=IIF(Parameters!Table.Value <> "AAA",                         

"SELECT DISTINCT " &
"    FILIAL.DSC_FILIAL        FILIAL, " &
"    cisli940.t$docn$l        NF, " &
"    cisli940.t$seri$l        SERIE, " &
"    WMS_OA_ORDERS.ORDERKEY   PEDIDO_WMS, " &
"    CODELKUP_OA.DESCRIPTION  DESCRICAO_PEDIDO, " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE) " &
"                             DT_EMISSAO, " &
"    cisli940.t$ccfo$l        CFO, " &
"    cisli940.t$opor$l        SEQ_CFO, " &
"    tcmcs940.t$dsca$l        NOME_CFO, " &
"    znsls400.t$idca$c        CANAL, " &
"    TRIM(cisli941.t$item$l)  ID_ITEM, " &
"    tcibd001.t$dsca          NOME_ITEM, " &
"    cisli941.t$dqua$l        QTD_FATURADA, " &
"    cisli941.t$amnt$l        VL_PRODUTO, " &
"    cisli941.t$iprt$l        VL_TOTAL_ITEM, " &
"    cisli941.t$gamt$l        VL_MERCADORIA, " &
"    cisli941.t$fght$l        VL_FRETE, " &
"    cisli941.t$ldam$l        VL_DESC_INC, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 1 ), 0) " &
"                             VL_ICMS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 5 ), 0) " &
"                             VL_PIS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 6 ), 0) " &
"                             VL_COFINS, " &
"    cisli940.t$itbp$l        ID_CLIENTE, " &
"    cisli940.t$itbn$l        NOME_CLIENTE, " &
"    tccom130.t$namc          ENDERECO, " &
"    tccom130.t$dist$l        BAIRRO, " &
"    tccom130.t$pstc          CEP, " &
"    tccom130.t$ln03          MUNICIPIO, " &
"    tccom130.t$cste          UF, " &
"    tccom130.t$telp          TEL1, " &
"    tccom130.t$telx          TEL2, " &
"    tccom130.t$enfs$l        EMAIL, " &
"    cisli940.t$fdtc$l        ID_TIPO_DOC_FIS, " &
"    tcmcs966.t$dsca$l        DESCR_TIPO_DOC_FIS, " &
"    FGET.DESC_TIPO_DOCTO     DESC_TIPO_DOCTO " &
"FROM       baandb.tcisli940301 cisli940 " &
"INNER JOIN ( select tcemm030.t$eunt CHAVE_FILIAL, " &
"                    tcemm030.t$dsca DSC_FILIAL, " &
"                    tcemm124.t$cwoc " &
"               from baandb.ttcemm124301 tcemm124, " &
"                    baandb.ttcemm030301 tcemm030 " &
"              where tcemm030.t$eunt = tcemm124.t$grid " &
"                and tcemm124.t$loco = 301 ) FILIAL " &
"        ON FILIAL.t$cwoc = cisli940.t$cofc$l " &
" LEFT JOIN baandb.ttcmcs940301 tcmcs940 " &
"        ON tcmcs940.T$OFSO$L = cisli940.t$ccfo$l " &
"INNER JOIN baandb.tcisli941301 cisli941 " &
"        ON cisli941.t$fire$l = cisli940.t$fire$l " &
"INNER JOIN baandb.tcisli245301 cisli245 " &
"        ON cisli245.t$fire$l = cisli941.t$fire$l " &
"       AND cisli245.t$line$l = cisli941.t$line$l " &
" LEFT JOIN baandb.tznsls401301 znsls401 " &
"        ON znsls401.t$orno$c = cisli245.t$slso " &
"       AND znsls401.t$pono$c = cisli245.t$pono " &
" LEFT JOIN baandb.tznsls400301 znsls400 " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c " &
"INNER JOIN baandb.ttccom130301 tccom130 " &
"        ON tccom130.t$cadr   = cisli940.t$itoa$l " &
"INNER JOIN baandb.ttcibd001301 tcibd001 " &
"        ON tcibd001.t$item   = cisli941.t$item$l " &
" LEFT JOIN baandb.ttcmcs966301 tcmcs966 " &
"        ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l " &
" LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOCTO" &
"               FROM baandb.tttadv401000 d, " &
"                    baandb.tttadv140000 l " &
"              WHERE d.t$cpac = 'ci' " &
"                AND d.t$cdom = 'sli.tdff.l' " &
"                AND l.t$clan = 'p' " &
"                AND l.t$cpac = 'ci' " &
"                AND l.t$clab = d.t$za_clab " &
"                AND rpad(d.t$vers,4) || " &
"                    rpad(d.t$rele,2) || " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv401000 l1 " &
"                                          where l1.t$cpac = d.t$cpac " &
"                                            and l1.t$cdom = d.t$cdom ) " &
"                AND rpad(l.t$vers,4) || " &
"                    rpad(l.t$rele,2) || " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv140000 l1 " &
"                                          where l1.t$clab = l.t$clab " &
"                                            and l1.t$clan = l.t$clan " &
"                                            and l1.t$cpac = l.t$cpac ) ) FGET " &
"        ON cisli940.t$fdty$l = FGET.CNST " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERS@DL_LN_WMS WMS_OA_ORDERS " &
"        ON SUBSTR(WMS_OA_ORDERS.EXTERNORDERKEY,5,9) = CISLI245.T$SHPM " &
" LEFT JOIN " + Parameters!Table.Value + ".CODELKUP@DL_LN_WMS CODELKUP_OA " &
"        ON CODELKUP_OA.LISTNAME = 'ORDERTYPE' " &
"       AND CODELKUP_OA.CODE = WMS_OA_ORDERS.TYPE " &
"WHERE cisli940.t$fdty$l != 11 " &
"  AND cisli940.t$docn$l != 0 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                  AT time zone sessiontimezone) AS DATE)) " &
"      BETWEEN '" + Parameters!EmissaoDe.Value + "' " &
"          AND '" + Parameters!EmissaoAte.Value + "' " &
"ORDER BY DT_EMISSAO, NF "

,                                                          

"SELECT DISTINCT " &
"    FILIAL.DSC_FILIAL        FILIAL, " &
"    cisli940.t$docn$l        NF, " &
"    cisli940.t$seri$l        SERIE, " &
"    WMS_OA_ORDERS.ORDERKEY   PEDIDO_WMS, " &
"    CODELKUP_OA.DESCRIPTION  DESCRICAO_PEDIDO, " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE) " &
"                             DT_EMISSAO, " &
"    cisli940.t$ccfo$l        CFO, " &
"    cisli940.t$opor$l        SEQ_CFO, " &
"    tcmcs940.t$dsca$l        NOME_CFO, " &
"    znsls400.t$idca$c        CANAL, " &
"    TRIM(cisli941.t$item$l)  ID_ITEM, " &
"    tcibd001.t$dsca          NOME_ITEM, " &
"    cisli941.t$dqua$l        QTD_FATURADA, " &
"    cisli941.t$amnt$l        VL_PRODUTO, " &
"    cisli941.t$iprt$l        VL_TOTAL_ITEM, " &
"    cisli941.t$gamt$l        VL_MERCADORIA, " &
"    cisli941.t$fght$l        VL_FRETE, " &
"    cisli941.t$ldam$l        VL_DESC_INC, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 1 ), 0) " &
"                             VL_ICMS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 5 ), 0) " &
"                             VL_PIS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 6 ), 0) " &
"                             VL_COFINS, " &
"    cisli940.t$itbp$l        ID_CLIENTE, " &
"    cisli940.t$itbn$l        NOME_CLIENTE, " &
"    tccom130.t$namc          ENDERECO, " &
"    tccom130.t$dist$l        BAIRRO, " &
"    tccom130.t$pstc          CEP, " &
"    tccom130.t$ln03          MUNICIPIO, " &
"    tccom130.t$cste          UF, " &
"    tccom130.t$telp          TEL1, " &
"    tccom130.t$telx          TEL2, " &
"    tccom130.t$enfs$l        EMAIL, " &
"    cisli940.t$fdtc$l        ID_TIPO_DOC_FIS, " &
"    tcmcs966.t$dsca$l        DESCR_TIPO_DOC_FIS, " &
"    FGET.DESC_TIPO_DOCTO     DESC_TIPO_DOCTO " &
"FROM       baandb.tcisli940301 cisli940 " &
"INNER JOIN ( select tcemm030.t$eunt CHAVE_FILIAL, " &
"                    tcemm030.t$dsca DSC_FILIAL, " &
"                    tcemm124.t$cwoc " &
"               from baandb.ttcemm124301 tcemm124, " &
"                    baandb.ttcemm030301 tcemm030 " &
"              where tcemm030.t$eunt = tcemm124.t$grid " &
"                and tcemm124.t$loco = 301 ) FILIAL " &
"        ON FILIAL.t$cwoc = cisli940.t$cofc$l " &
" LEFT JOIN baandb.ttcmcs940301 tcmcs940 " &
"        ON tcmcs940.T$OFSO$L = cisli940.t$ccfo$l " &
"INNER JOIN baandb.tcisli941301 cisli941 " &
"        ON cisli941.t$fire$l = cisli940.t$fire$l " &
"INNER JOIN baandb.tcisli245301 cisli245 " &
"        ON cisli245.t$fire$l = cisli941.t$fire$l " &
"       AND cisli245.t$line$l = cisli941.t$line$l " &
" LEFT JOIN baandb.tznsls401301 znsls401 " &
"        ON znsls401.t$orno$c = cisli245.t$slso " &
"       AND znsls401.t$pono$c = cisli245.t$pono " &
" LEFT JOIN baandb.tznsls400301 znsls400 " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c " &
"INNER JOIN baandb.ttccom130301 tccom130 " &
"        ON tccom130.t$cadr   = cisli940.t$itoa$l " &
"INNER JOIN baandb.ttcibd001301 tcibd001 " &
"        ON tcibd001.t$item   = cisli941.t$item$l " &
" LEFT JOIN baandb.ttcmcs966301 tcmcs966 " &
"        ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l " &
" LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOCTO" &
"               FROM baandb.tttadv401000 d, " &
"                    baandb.tttadv140000 l " &
"              WHERE d.t$cpac = 'ci' " &
"                AND d.t$cdom = 'sli.tdff.l' " &
"                AND l.t$clan = 'p' " &
"                AND l.t$cpac = 'ci' " &
"                AND l.t$clab = d.t$za_clab " &
"                AND rpad(d.t$vers,4) || " &
"                    rpad(d.t$rele,2) || " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv401000 l1 " &
"                                          where l1.t$cpac = d.t$cpac " &
"                                            and l1.t$cdom = d.t$cdom ) " &
"                AND rpad(l.t$vers,4) || " &
"                    rpad(l.t$rele,2) || " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv140000 l1 " &
"                                          where l1.t$clab = l.t$clab " &
"                                            and l1.t$clan = l.t$clan " &
"                                            and l1.t$cpac = l.t$cpac ) ) FGET " &
"        ON cisli940.t$fdty$l = FGET.CNST " &
"INNER JOIN WMWHSE1.ORDERS@DL_LN_WMS WMS_OA_ORDERS " &
"        ON SUBSTR(WMS_OA_ORDERS.EXTERNORDERKEY,5,9) = CISLI245.T$SHPM " &
" LEFT JOIN WMWHSE1.CODELKUP@DL_LN_WMS CODELKUP_OA " &
"        ON CODELKUP_OA.LISTNAME = 'ORDERTYPE' " &
"       AND CODELKUP_OA.CODE = WMS_OA_ORDERS.TYPE " &
"WHERE cisli940.t$fdty$l != 11 " &
"  AND cisli940.t$docn$l != 0 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                  AT time zone sessiontimezone) AS DATE)) " &
"      BETWEEN '" + Parameters!EmissaoDe.Value + "' " &
"          AND '" + Parameters!EmissaoAte.Value + "' " &
"UNION                    " &
"SELECT DISTINCT " &
"    FILIAL.DSC_FILIAL        FILIAL, " &
"    cisli940.t$docn$l        NF, " &
"    cisli940.t$seri$l        SERIE, " &
"    WMS_OA_ORDERS.ORDERKEY   PEDIDO_WMS, " &
"    CODELKUP_OA.DESCRIPTION  DESCRICAO_PEDIDO, " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE) " &
"                             DT_EMISSAO, " &
"    cisli940.t$ccfo$l        CFO, " &
"    cisli940.t$opor$l        SEQ_CFO, " &
"    tcmcs940.t$dsca$l        NOME_CFO, " &
"    znsls400.t$idca$c        CANAL, " &
"    TRIM(cisli941.t$item$l)  ID_ITEM, " &
"    tcibd001.t$dsca          NOME_ITEM, " &
"    cisli941.t$dqua$l        QTD_FATURADA, " &
"    cisli941.t$amnt$l        VL_PRODUTO, " &
"    cisli941.t$iprt$l        VL_TOTAL_ITEM, " &
"    cisli941.t$gamt$l        VL_MERCADORIA, " &
"    cisli941.t$fght$l        VL_FRETE, " &
"    cisli941.t$ldam$l        VL_DESC_INC, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 1 ), 0) " &
"                             VL_ICMS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 5 ), 0) " &
"                             VL_PIS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 6 ), 0) " &
"                             VL_COFINS, " &
"    cisli940.t$itbp$l        ID_CLIENTE, " &
"    cisli940.t$itbn$l        NOME_CLIENTE, " &
"    tccom130.t$namc          ENDERECO, " &
"    tccom130.t$dist$l        BAIRRO, " &
"    tccom130.t$pstc          CEP, " &
"    tccom130.t$ln03          MUNICIPIO, " &
"    tccom130.t$cste          UF, " &
"    tccom130.t$telp          TEL1, " &
"    tccom130.t$telx          TEL2, " &
"    tccom130.t$enfs$l        EMAIL, " &
"    cisli940.t$fdtc$l        ID_TIPO_DOC_FIS, " &
"    tcmcs966.t$dsca$l        DESCR_TIPO_DOC_FIS, " &
"    FGET.DESC_TIPO_DOCTO     DESC_TIPO_DOCTO " &
"FROM       baandb.tcisli940301 cisli940 " &
"INNER JOIN ( select tcemm030.t$eunt CHAVE_FILIAL, " &
"                    tcemm030.t$dsca DSC_FILIAL, " &
"                    tcemm124.t$cwoc " &
"               from baandb.ttcemm124301 tcemm124, " &
"                    baandb.ttcemm030301 tcemm030 " &
"              where tcemm030.t$eunt = tcemm124.t$grid " &
"                and tcemm124.t$loco = 301 ) FILIAL " &
"        ON FILIAL.t$cwoc = cisli940.t$cofc$l " &
" LEFT JOIN baandb.ttcmcs940301 tcmcs940 " &
"        ON tcmcs940.T$OFSO$L = cisli940.t$ccfo$l " &
"INNER JOIN baandb.tcisli941301 cisli941 " &
"        ON cisli941.t$fire$l = cisli940.t$fire$l " &
"INNER JOIN baandb.tcisli245301 cisli245 " &
"        ON cisli245.t$fire$l = cisli941.t$fire$l " &
"       AND cisli245.t$line$l = cisli941.t$line$l " &
" LEFT JOIN baandb.tznsls401301 znsls401 " &
"        ON znsls401.t$orno$c = cisli245.t$slso " &
"       AND znsls401.t$pono$c = cisli245.t$pono " &
" LEFT JOIN baandb.tznsls400301 znsls400 " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c " &
"INNER JOIN baandb.ttccom130301 tccom130 " &
"        ON tccom130.t$cadr   = cisli940.t$itoa$l " &
"INNER JOIN baandb.ttcibd001301 tcibd001 " &
"        ON tcibd001.t$item   = cisli941.t$item$l " &
" LEFT JOIN baandb.ttcmcs966301 tcmcs966 " &
"        ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l " &
" LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOCTO" &
"               FROM baandb.tttadv401000 d, " &
"                    baandb.tttadv140000 l " &
"              WHERE d.t$cpac = 'ci' " &
"                AND d.t$cdom = 'sli.tdff.l' " &
"                AND l.t$clan = 'p' " &
"                AND l.t$cpac = 'ci' " &
"                AND l.t$clab = d.t$za_clab " &
"                AND rpad(d.t$vers,4) || " &
"                    rpad(d.t$rele,2) || " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv401000 l1 " &
"                                          where l1.t$cpac = d.t$cpac " &
"                                            and l1.t$cdom = d.t$cdom ) " &
"                AND rpad(l.t$vers,4) || " &
"                    rpad(l.t$rele,2) || " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv140000 l1 " &
"                                          where l1.t$clab = l.t$clab " &
"                                            and l1.t$clan = l.t$clan " &
"                                            and l1.t$cpac = l.t$cpac ) ) FGET " &
"        ON cisli940.t$fdty$l = FGET.CNST " &
"INNER JOIN WMWHSE2.ORDERS@DL_LN_WMS WMS_OA_ORDERS " &
"        ON SUBSTR(WMS_OA_ORDERS.EXTERNORDERKEY,5,9) = CISLI245.T$SHPM " &
" LEFT JOIN WMWHSE2.CODELKUP@DL_LN_WMS CODELKUP_OA " &
"        ON CODELKUP_OA.LISTNAME = 'ORDERTYPE' " &
"       AND CODELKUP_OA.CODE = WMS_OA_ORDERS.TYPE " &
"WHERE cisli940.t$fdty$l != 11 " &
"  AND cisli940.t$docn$l != 0 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                  AT time zone sessiontimezone) AS DATE)) " &
"      BETWEEN '" + Parameters!EmissaoDe.Value + "' " &
"          AND '" + Parameters!EmissaoAte.Value + "' " &
"UNION                    " &
"SELECT DISTINCT " &
"    FILIAL.DSC_FILIAL        FILIAL, " &
"    cisli940.t$docn$l        NF, " &
"    cisli940.t$seri$l        SERIE, " &
"    WMS_OA_ORDERS.ORDERKEY   PEDIDO_WMS, " &
"    CODELKUP_OA.DESCRIPTION  DESCRICAO_PEDIDO, " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE) " &
"                             DT_EMISSAO, " &
"    cisli940.t$ccfo$l        CFO, " &
"    cisli940.t$opor$l        SEQ_CFO, " &
"    tcmcs940.t$dsca$l        NOME_CFO, " &
"    znsls400.t$idca$c        CANAL, " &
"    TRIM(cisli941.t$item$l)  ID_ITEM, " &
"    tcibd001.t$dsca          NOME_ITEM, " &
"    cisli941.t$dqua$l        QTD_FATURADA, " &
"    cisli941.t$amnt$l        VL_PRODUTO, " &
"    cisli941.t$iprt$l        VL_TOTAL_ITEM, " &
"    cisli941.t$gamt$l        VL_MERCADORIA, " &
"    cisli941.t$fght$l        VL_FRETE, " &
"    cisli941.t$ldam$l        VL_DESC_INC, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 1 ), 0) " &
"                             VL_ICMS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 5 ), 0) " &
"                             VL_PIS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 6 ), 0) " &
"                             VL_COFINS, " &
"    cisli940.t$itbp$l        ID_CLIENTE, " &
"    cisli940.t$itbn$l        NOME_CLIENTE, " &
"    tccom130.t$namc          ENDERECO, " &
"    tccom130.t$dist$l        BAIRRO, " &
"    tccom130.t$pstc          CEP, " &
"    tccom130.t$ln03          MUNICIPIO, " &
"    tccom130.t$cste          UF, " &
"    tccom130.t$telp          TEL1, " &
"    tccom130.t$telx          TEL2, " &
"    tccom130.t$enfs$l        EMAIL, " &
"    cisli940.t$fdtc$l        ID_TIPO_DOC_FIS, " &
"    tcmcs966.t$dsca$l        DESCR_TIPO_DOC_FIS, " &
"    FGET.DESC_TIPO_DOCTO     DESC_TIPO_DOCTO " &
"FROM       baandb.tcisli940301 cisli940 " &
"INNER JOIN ( select tcemm030.t$eunt CHAVE_FILIAL, " &
"                    tcemm030.t$dsca DSC_FILIAL, " &
"                    tcemm124.t$cwoc " &
"               from baandb.ttcemm124301 tcemm124, " &
"                    baandb.ttcemm030301 tcemm030 " &
"              where tcemm030.t$eunt = tcemm124.t$grid " &
"                and tcemm124.t$loco = 301 ) FILIAL " &
"        ON FILIAL.t$cwoc = cisli940.t$cofc$l " &
" LEFT JOIN baandb.ttcmcs940301 tcmcs940 " &
"        ON tcmcs940.T$OFSO$L = cisli940.t$ccfo$l " &
"INNER JOIN baandb.tcisli941301 cisli941 " &
"        ON cisli941.t$fire$l = cisli940.t$fire$l " &
"INNER JOIN baandb.tcisli245301 cisli245 " &
"        ON cisli245.t$fire$l = cisli941.t$fire$l " &
"       AND cisli245.t$line$l = cisli941.t$line$l " &
" LEFT JOIN baandb.tznsls401301 znsls401 " &
"        ON znsls401.t$orno$c = cisli245.t$slso " &
"       AND znsls401.t$pono$c = cisli245.t$pono " &
" LEFT JOIN baandb.tznsls400301 znsls400 " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c " &
"INNER JOIN baandb.ttccom130301 tccom130 " &
"        ON tccom130.t$cadr   = cisli940.t$itoa$l " &
"INNER JOIN baandb.ttcibd001301 tcibd001 " &
"        ON tcibd001.t$item   = cisli941.t$item$l " &
" LEFT JOIN baandb.ttcmcs966301 tcmcs966 " &
"        ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l " &
" LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOCTO" &
"               FROM baandb.tttadv401000 d, " &
"                    baandb.tttadv140000 l " &
"              WHERE d.t$cpac = 'ci' " &
"                AND d.t$cdom = 'sli.tdff.l' " &
"                AND l.t$clan = 'p' " &
"                AND l.t$cpac = 'ci' " &
"                AND l.t$clab = d.t$za_clab " &
"                AND rpad(d.t$vers,4) || " &
"                    rpad(d.t$rele,2) || " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv401000 l1 " &
"                                          where l1.t$cpac = d.t$cpac " &
"                                            and l1.t$cdom = d.t$cdom ) " &
"                AND rpad(l.t$vers,4) || " &
"                    rpad(l.t$rele,2) || " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv140000 l1 " &
"                                          where l1.t$clab = l.t$clab " &
"                                            and l1.t$clan = l.t$clan " &
"                                            and l1.t$cpac = l.t$cpac ) ) FGET " &
"        ON cisli940.t$fdty$l = FGET.CNST " &
"INNER JOIN WMWHSE3.ORDERS@DL_LN_WMS WMS_OA_ORDERS " &
"        ON SUBSTR(WMS_OA_ORDERS.EXTERNORDERKEY,5,9) = CISLI245.T$SHPM " &
" LEFT JOIN WMWHSE3.CODELKUP@DL_LN_WMS CODELKUP_OA " &
"        ON CODELKUP_OA.LISTNAME = 'ORDERTYPE' " &
"       AND CODELKUP_OA.CODE = WMS_OA_ORDERS.TYPE " &
"WHERE cisli940.t$fdty$l != 11 " &
"  AND cisli940.t$docn$l != 0 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                  AT time zone sessiontimezone) AS DATE)) " &
"      BETWEEN '" + Parameters!EmissaoDe.Value + "' " &
"          AND '" + Parameters!EmissaoAte.Value + "' " &
"UNION                    " &
"SELECT DISTINCT " &
"    FILIAL.DSC_FILIAL        FILIAL, " &
"    cisli940.t$docn$l        NF, " &
"    cisli940.t$seri$l        SERIE, " &
"    WMS_OA_ORDERS.ORDERKEY   PEDIDO_WMS, " &
"    CODELKUP_OA.DESCRIPTION  DESCRICAO_PEDIDO, " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE) " &
"                             DT_EMISSAO, " &
"    cisli940.t$ccfo$l        CFO, " &
"    cisli940.t$opor$l        SEQ_CFO, " &
"    tcmcs940.t$dsca$l        NOME_CFO, " &
"    znsls400.t$idca$c        CANAL, " &
"    TRIM(cisli941.t$item$l)  ID_ITEM, " &
"    tcibd001.t$dsca          NOME_ITEM, " &
"    cisli941.t$dqua$l        QTD_FATURADA, " &
"    cisli941.t$amnt$l        VL_PRODUTO, " &
"    cisli941.t$iprt$l        VL_TOTAL_ITEM, " &
"    cisli941.t$gamt$l        VL_MERCADORIA, " &
"    cisli941.t$fght$l        VL_FRETE, " &
"    cisli941.t$ldam$l        VL_DESC_INC, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 1 ), 0) " &
"                             VL_ICMS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 5 ), 0) " &
"                             VL_PIS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 6 ), 0) " &
"                             VL_COFINS, " &
"    cisli940.t$itbp$l        ID_CLIENTE, " &
"    cisli940.t$itbn$l        NOME_CLIENTE, " &
"    tccom130.t$namc          ENDERECO, " &
"    tccom130.t$dist$l        BAIRRO, " &
"    tccom130.t$pstc          CEP, " &
"    tccom130.t$ln03          MUNICIPIO, " &
"    tccom130.t$cste          UF, " &
"    tccom130.t$telp          TEL1, " &
"    tccom130.t$telx          TEL2, " &
"    tccom130.t$enfs$l        EMAIL, " &
"    cisli940.t$fdtc$l        ID_TIPO_DOC_FIS, " &
"    tcmcs966.t$dsca$l        DESCR_TIPO_DOC_FIS, " &
"    FGET.DESC_TIPO_DOCTO     DESC_TIPO_DOCTO " &
"FROM       baandb.tcisli940301 cisli940 " &
"INNER JOIN ( select tcemm030.t$eunt CHAVE_FILIAL, " &
"                    tcemm030.t$dsca DSC_FILIAL, " &
"                    tcemm124.t$cwoc " &
"               from baandb.ttcemm124301 tcemm124, " &
"                    baandb.ttcemm030301 tcemm030 " &
"              where tcemm030.t$eunt = tcemm124.t$grid " &
"                and tcemm124.t$loco = 301 ) FILIAL " &
"        ON FILIAL.t$cwoc = cisli940.t$cofc$l " &
" LEFT JOIN baandb.ttcmcs940301 tcmcs940 " &
"        ON tcmcs940.T$OFSO$L = cisli940.t$ccfo$l " &
"INNER JOIN baandb.tcisli941301 cisli941 " &
"        ON cisli941.t$fire$l = cisli940.t$fire$l " &
"INNER JOIN baandb.tcisli245301 cisli245 " &
"        ON cisli245.t$fire$l = cisli941.t$fire$l " &
"       AND cisli245.t$line$l = cisli941.t$line$l " &
" LEFT JOIN baandb.tznsls401301 znsls401 " &
"        ON znsls401.t$orno$c = cisli245.t$slso " &
"       AND znsls401.t$pono$c = cisli245.t$pono " &
" LEFT JOIN baandb.tznsls400301 znsls400 " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c " &
"INNER JOIN baandb.ttccom130301 tccom130 " &
"        ON tccom130.t$cadr   = cisli940.t$itoa$l " &
"INNER JOIN baandb.ttcibd001301 tcibd001 " &
"        ON tcibd001.t$item   = cisli941.t$item$l " &
" LEFT JOIN baandb.ttcmcs966301 tcmcs966 " &
"        ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l " &
" LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOCTO" &
"               FROM baandb.tttadv401000 d, " &
"                    baandb.tttadv140000 l " &
"              WHERE d.t$cpac = 'ci' " &
"                AND d.t$cdom = 'sli.tdff.l' " &
"                AND l.t$clan = 'p' " &
"                AND l.t$cpac = 'ci' " &
"                AND l.t$clab = d.t$za_clab " &
"                AND rpad(d.t$vers,4) || " &
"                    rpad(d.t$rele,2) || " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv401000 l1 " &
"                                          where l1.t$cpac = d.t$cpac " &
"                                            and l1.t$cdom = d.t$cdom ) " &
"                AND rpad(l.t$vers,4) || " &
"                    rpad(l.t$rele,2) || " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv140000 l1 " &
"                                          where l1.t$clab = l.t$clab " &
"                                            and l1.t$clan = l.t$clan " &
"                                            and l1.t$cpac = l.t$cpac ) ) FGET " &
"        ON cisli940.t$fdty$l = FGET.CNST " &
"INNER JOIN WMWHSE4.ORDERS@DL_LN_WMS WMS_OA_ORDERS " &
"        ON SUBSTR(WMS_OA_ORDERS.EXTERNORDERKEY,5,9) = CISLI245.T$SHPM " &
" LEFT JOIN WMWHSE4.CODELKUP@DL_LN_WMS CODELKUP_OA " &
"        ON CODELKUP_OA.LISTNAME = 'ORDERTYPE' " &
"       AND CODELKUP_OA.CODE = WMS_OA_ORDERS.TYPE " &
"WHERE cisli940.t$fdty$l != 11 " &
"  AND cisli940.t$docn$l != 0 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                  AT time zone sessiontimezone) AS DATE)) " &
"      BETWEEN '" + Parameters!EmissaoDe.Value + "' " &
"          AND '" + Parameters!EmissaoAte.Value + "' " &
"UNION                    " &
"SELECT DISTINCT " &
"    FILIAL.DSC_FILIAL        FILIAL, " &
"    cisli940.t$docn$l        NF, " &
"    cisli940.t$seri$l        SERIE, " &
"    WMS_OA_ORDERS.ORDERKEY   PEDIDO_WMS, " &
"    CODELKUP_OA.DESCRIPTION  DESCRICAO_PEDIDO, " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE) " &
"                             DT_EMISSAO, " &
"    cisli940.t$ccfo$l        CFO, " &
"    cisli940.t$opor$l        SEQ_CFO, " &
"    tcmcs940.t$dsca$l        NOME_CFO, " &
"    znsls400.t$idca$c        CANAL, " &
"    TRIM(cisli941.t$item$l)  ID_ITEM, " &
"    tcibd001.t$dsca          NOME_ITEM, " &
"    cisli941.t$dqua$l        QTD_FATURADA, " &
"    cisli941.t$amnt$l        VL_PRODUTO, " &
"    cisli941.t$iprt$l        VL_TOTAL_ITEM, " &
"    cisli941.t$gamt$l        VL_MERCADORIA, " &
"    cisli941.t$fght$l        VL_FRETE, " &
"    cisli941.t$ldam$l        VL_DESC_INC, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 1 ), 0) " &
"                             VL_ICMS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 5 ), 0) " &
"                             VL_PIS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 6 ), 0) " &
"                             VL_COFINS, " &
"    cisli940.t$itbp$l        ID_CLIENTE, " &
"    cisli940.t$itbn$l        NOME_CLIENTE, " &
"    tccom130.t$namc          ENDERECO, " &
"    tccom130.t$dist$l        BAIRRO, " &
"    tccom130.t$pstc          CEP, " &
"    tccom130.t$ln03          MUNICIPIO, " &
"    tccom130.t$cste          UF, " &
"    tccom130.t$telp          TEL1, " &
"    tccom130.t$telx          TEL2, " &
"    tccom130.t$enfs$l        EMAIL, " &
"    cisli940.t$fdtc$l        ID_TIPO_DOC_FIS, " &
"    tcmcs966.t$dsca$l        DESCR_TIPO_DOC_FIS, " &
"    FGET.DESC_TIPO_DOCTO     DESC_TIPO_DOCTO " &
"FROM       baandb.tcisli940301 cisli940 " &
"INNER JOIN ( select tcemm030.t$eunt CHAVE_FILIAL, " &
"                    tcemm030.t$dsca DSC_FILIAL, " &
"                    tcemm124.t$cwoc " &
"               from baandb.ttcemm124301 tcemm124, " &
"                    baandb.ttcemm030301 tcemm030 " &
"              where tcemm030.t$eunt = tcemm124.t$grid " &
"                and tcemm124.t$loco = 301 ) FILIAL " &
"        ON FILIAL.t$cwoc = cisli940.t$cofc$l " &
" LEFT JOIN baandb.ttcmcs940301 tcmcs940 " &
"        ON tcmcs940.T$OFSO$L = cisli940.t$ccfo$l " &
"INNER JOIN baandb.tcisli941301 cisli941 " &
"        ON cisli941.t$fire$l = cisli940.t$fire$l " &
"INNER JOIN baandb.tcisli245301 cisli245 " &
"        ON cisli245.t$fire$l = cisli941.t$fire$l " &
"       AND cisli245.t$line$l = cisli941.t$line$l " &
" LEFT JOIN baandb.tznsls401301 znsls401 " &
"        ON znsls401.t$orno$c = cisli245.t$slso " &
"       AND znsls401.t$pono$c = cisli245.t$pono " &
" LEFT JOIN baandb.tznsls400301 znsls400 " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c " &
"INNER JOIN baandb.ttccom130301 tccom130 " &
"        ON tccom130.t$cadr   = cisli940.t$itoa$l " &
"INNER JOIN baandb.ttcibd001301 tcibd001 " &
"        ON tcibd001.t$item   = cisli941.t$item$l " &
" LEFT JOIN baandb.ttcmcs966301 tcmcs966 " &
"        ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l " &
" LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOCTO" &
"               FROM baandb.tttadv401000 d, " &
"                    baandb.tttadv140000 l " &
"              WHERE d.t$cpac = 'ci' " &
"                AND d.t$cdom = 'sli.tdff.l' " &
"                AND l.t$clan = 'p' " &
"                AND l.t$cpac = 'ci' " &
"                AND l.t$clab = d.t$za_clab " &
"                AND rpad(d.t$vers,4) || " &
"                    rpad(d.t$rele,2) || " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv401000 l1 " &
"                                          where l1.t$cpac = d.t$cpac " &
"                                            and l1.t$cdom = d.t$cdom ) " &
"                AND rpad(l.t$vers,4) || " &
"                    rpad(l.t$rele,2) || " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv140000 l1 " &
"                                          where l1.t$clab = l.t$clab " &
"                                            and l1.t$clan = l.t$clan " &
"                                            and l1.t$cpac = l.t$cpac ) ) FGET " &
"        ON cisli940.t$fdty$l = FGET.CNST " &
"INNER JOIN WMWHSE5.ORDERS@DL_LN_WMS WMS_OA_ORDERS " &
"        ON SUBSTR(WMS_OA_ORDERS.EXTERNORDERKEY,5,9) = CISLI245.T$SHPM " &
" LEFT JOIN WMWHSE5.CODELKUP@DL_LN_WMS CODELKUP_OA " &
"        ON CODELKUP_OA.LISTNAME = 'ORDERTYPE' " &
"       AND CODELKUP_OA.CODE = WMS_OA_ORDERS.TYPE " &
"WHERE cisli940.t$fdty$l != 11 " &
"  AND cisli940.t$docn$l != 0 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                  AT time zone sessiontimezone) AS DATE)) " &
"      BETWEEN '" + Parameters!EmissaoDe.Value + "' " &
"          AND '" + Parameters!EmissaoAte.Value + "' " &
"UNION                    " &
"SELECT DISTINCT " &
"    FILIAL.DSC_FILIAL        FILIAL, " &
"    cisli940.t$docn$l        NF, " &
"    cisli940.t$seri$l        SERIE, " &
"    WMS_OA_ORDERS.ORDERKEY   PEDIDO_WMS, " &
"    CODELKUP_OA.DESCRIPTION  DESCRICAO_PEDIDO, " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')" &
"        AT time zone sessiontimezone) AS DATE) " &
"                             DT_EMISSAO, " &
"    cisli940.t$ccfo$l        CFO, " &
"    cisli940.t$opor$l        SEQ_CFO, " &
"    tcmcs940.t$dsca$l        NOME_CFO, " &
"    znsls400.t$idca$c        CANAL, " &
"    TRIM(cisli941.t$item$l)  ID_ITEM, " &
"    tcibd001.t$dsca          NOME_ITEM, " &
"    cisli941.t$dqua$l        QTD_FATURADA, " &
"    cisli941.t$amnt$l        VL_PRODUTO, " &
"    cisli941.t$iprt$l        VL_TOTAL_ITEM, " &
"    cisli941.t$gamt$l        VL_MERCADORIA, " &
"    cisli941.t$fght$l        VL_FRETE, " &
"    cisli941.t$ldam$l        VL_DESC_INC, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 1 ), 0) " &
"                             VL_ICMS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 5 ), 0) " &
"                             VL_PIS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 6 ), 0) " &
"                             VL_COFINS, " &
"    cisli940.t$itbp$l        ID_CLIENTE, " &
"    cisli940.t$itbn$l        NOME_CLIENTE, " &
"    tccom130.t$namc          ENDERECO, " &
"    tccom130.t$dist$l        BAIRRO, " &
"    tccom130.t$pstc          CEP, " &
"    tccom130.t$ln03          MUNICIPIO, " &
"    tccom130.t$cste          UF, " &
"    tccom130.t$telp          TEL1, " &
"    tccom130.t$telx          TEL2, " &
"    tccom130.t$enfs$l        EMAIL, " &
"    cisli940.t$fdtc$l        ID_TIPO_DOC_FIS, " &
"    tcmcs966.t$dsca$l        DESCR_TIPO_DOC_FIS, " &
"    FGET.DESC_TIPO_DOCTO     DESC_TIPO_DOCTO " &
"FROM       baandb.tcisli940301 cisli940 " &
"INNER JOIN ( select tcemm030.t$eunt CHAVE_FILIAL, " &
"                    tcemm030.t$dsca DSC_FILIAL, " &
"                    tcemm124.t$cwoc " &
"               from baandb.ttcemm124301 tcemm124, " &
"                    baandb.ttcemm030301 tcemm030 " &
"              where tcemm030.t$eunt = tcemm124.t$grid " &
"                and tcemm124.t$loco = 301 ) FILIAL " &
"        ON FILIAL.t$cwoc = cisli940.t$cofc$l " &
" LEFT JOIN baandb.ttcmcs940301 tcmcs940 " &
"        ON tcmcs940.T$OFSO$L = cisli940.t$ccfo$l " &
"INNER JOIN baandb.tcisli941301 cisli941 " &
"        ON cisli941.t$fire$l = cisli940.t$fire$l " &
"INNER JOIN baandb.tcisli245301 cisli245 " &
"        ON cisli245.t$fire$l = cisli941.t$fire$l " &
"       AND cisli245.t$line$l = cisli941.t$line$l " &
" LEFT JOIN baandb.tznsls401301 znsls401 " &
"        ON znsls401.t$orno$c = cisli245.t$slso " &
"       AND znsls401.t$pono$c = cisli245.t$pono " &
" LEFT JOIN baandb.tznsls400301 znsls400 " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c " &
"INNER JOIN baandb.ttccom130301 tccom130 " &
"        ON tccom130.t$cadr   = cisli940.t$itoa$l " &
"INNER JOIN baandb.ttcibd001301 tcibd001 " &
"        ON tcibd001.t$item   = cisli941.t$item$l " &
" LEFT JOIN baandb.ttcmcs966301 tcmcs966 " &
"        ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l " &
" LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOCTO" &
"               FROM baandb.tttadv401000 d, " &
"                    baandb.tttadv140000 l " &
"              WHERE d.t$cpac = 'ci' " &
"                AND d.t$cdom = 'sli.tdff.l' " &
"                AND l.t$clan = 'p' " &
"                AND l.t$cpac = 'ci' " &
"                AND l.t$clab = d.t$za_clab " &
"                AND rpad(d.t$vers,4) || " &
"                    rpad(d.t$rele,2) || " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv401000 l1 " &
"                                          where l1.t$cpac = d.t$cpac " &
"                                            and l1.t$cdom = d.t$cdom ) " &
"                AND rpad(l.t$vers,4) || " &
"                    rpad(l.t$rele,2) || " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv140000 l1 " &
"                                          where l1.t$clab = l.t$clab " &
"                                            and l1.t$clan = l.t$clan " &
"                                            and l1.t$cpac = l.t$cpac ) ) FGET " &
"        ON cisli940.t$fdty$l = FGET.CNST " &
"INNER JOIN WMWHSE6.ORDERS@DL_LN_WMS WMS_OA_ORDERS " &
"        ON SUBSTR(WMS_OA_ORDERS.EXTERNORDERKEY,5,9) = CISLI245.T$SHPM " &
" LEFT JOIN WMWHSE6.CODELKUP@DL_LN_WMS CODELKUP_OA " &
"        ON CODELKUP_OA.LISTNAME = 'ORDERTYPE' " &
"       AND CODELKUP_OA.CODE = WMS_OA_ORDERS.TYPE " &
"WHERE cisli940.t$fdty$l != 11 " &
"  AND cisli940.t$docn$l != 0 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                  AT time zone sessiontimezone) AS DATE)) " &
"      BETWEEN '" + Parameters!EmissaoDe.Value + "' " &
"          AND '" + Parameters!EmissaoAte.Value + "' " &
"UNION                    " &
"SELECT DISTINCT " &
"    FILIAL.DSC_FILIAL        FILIAL, " &
"    cisli940.t$docn$l        NF, " &
"    cisli940.t$seri$l        SERIE, " &
"    WMS_OA_ORDERS.ORDERKEY   PEDIDO_WMS, " &
"    CODELKUP_OA.DESCRIPTION  DESCRICAO_PEDIDO, " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"        AT time zone sessiontimezone) AS DATE) " &
"                             DT_EMISSAO, " &
"    cisli940.t$ccfo$l        CFO, " &
"    cisli940.t$opor$l        SEQ_CFO, " &
"    tcmcs940.t$dsca$l        NOME_CFO, " &
"    znsls400.t$idca$c        CANAL, " &
"    TRIM(cisli941.t$item$l)  ID_ITEM, " &
"    tcibd001.t$dsca          NOME_ITEM, " &
"    cisli941.t$dqua$l        QTD_FATURADA, " &
"    cisli941.t$amnt$l        VL_PRODUTO, " &
"    cisli941.t$iprt$l        VL_TOTAL_ITEM, " &
"    cisli941.t$gamt$l        VL_MERCADORIA, " &
"    cisli941.t$fght$l        VL_FRETE, " &
"    cisli941.t$ldam$l        VL_DESC_INC, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 1 ), 0) " &
"                             VL_ICMS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 5 ), 0) " &
"                             VL_PIS, " &
"    NVL(( select cisli943.t$amnt$l " &
"            from baandb.tcisli943301 cisli943 " &
"           where cisli943.t$fire$l = cisli941.t$fire$l " &
"             and cisli943.t$line$l = cisli941.t$line$l " &
"             and cisli943.t$brty$l = 6 ), 0) " &
"                             VL_COFINS, " &
"    cisli940.t$itbp$l        ID_CLIENTE, " &
"    cisli940.t$itbn$l        NOME_CLIENTE, " &
"    tccom130.t$namc          ENDERECO, " &
"    tccom130.t$dist$l        BAIRRO, " &
"    tccom130.t$pstc          CEP, " &
"    tccom130.t$ln03          MUNICIPIO, " &
"    tccom130.t$cste          UF, " &
"    tccom130.t$telp          TEL1, " &
"    tccom130.t$telx          TEL2, " &
"    tccom130.t$enfs$l        EMAIL, " &
"    cisli940.t$fdtc$l        ID_TIPO_DOC_FIS, " &
"    tcmcs966.t$dsca$l        DESCR_TIPO_DOC_FIS, " &
"    FGET.DESC_TIPO_DOCTO     DESC_TIPO_DOCTO " &
"FROM       baandb.tcisli940301 cisli940 " &
"INNER JOIN ( select tcemm030.t$eunt CHAVE_FILIAL, " &
"                    tcemm030.t$dsca DSC_FILIAL, " &
"                    tcemm124.t$cwoc " &
"               from baandb.ttcemm124301 tcemm124, " &
"                    baandb.ttcemm030301 tcemm030 " &
"              where tcemm030.t$eunt = tcemm124.t$grid " &
"                and tcemm124.t$loco = 301 ) FILIAL " &
"        ON FILIAL.t$cwoc = cisli940.t$cofc$l " &
" LEFT JOIN baandb.ttcmcs940301 tcmcs940 " &
"        ON tcmcs940.T$OFSO$L = cisli940.t$ccfo$l " &
"INNER JOIN baandb.tcisli941301 cisli941 " &
"        ON cisli941.t$fire$l = cisli940.t$fire$l " &
"INNER JOIN baandb.tcisli245301 cisli245 " &
"        ON cisli245.t$fire$l = cisli941.t$fire$l " &
"       AND cisli245.t$line$l = cisli941.t$line$l " &
" LEFT JOIN baandb.tznsls401301 znsls401 " &
"        ON znsls401.t$orno$c = cisli245.t$slso " &
"       AND znsls401.t$pono$c = cisli245.t$pono " &
" LEFT JOIN baandb.tznsls400301 znsls400 " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c " &
"INNER JOIN baandb.ttccom130301 tccom130 " &
"        ON tccom130.t$cadr   = cisli940.t$itoa$l " &
"INNER JOIN baandb.ttcibd001301 tcibd001 " &
"        ON tcibd001.t$item   = cisli941.t$item$l " &
" LEFT JOIN baandb.ttcmcs966301 tcmcs966 " &
"        ON tcmcs966.t$fdtc$l = cisli940.t$fdtc$l " &
" LEFT JOIN ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOCTO" &
"               FROM baandb.tttadv401000 d, " &
"                    baandb.tttadv140000 l " &
"              WHERE d.t$cpac = 'ci' " &
"                AND d.t$cdom = 'sli.tdff.l' " &
"                AND l.t$clan = 'p' " &
"                AND l.t$cpac = 'ci' " &
"                AND l.t$clab = d.t$za_clab " &
"                AND rpad(d.t$vers,4) || " &
"                    rpad(d.t$rele,2) || " &
"                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv401000 l1 " &
"                                          where l1.t$cpac = d.t$cpac " &
"                                            and l1.t$cdom = d.t$cdom ) " &
"                AND rpad(l.t$vers,4) || " &
"                    rpad(l.t$rele,2) || " &
"                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || " &
"                                                    rpad(l1.t$rele,2) || " &
"                                                    rpad(l1.t$cust,4)) " &
"                                           from baandb.tttadv140000 l1 " &
"                                          where l1.t$clab = l.t$clab " &
"                                            and l1.t$clan = l.t$clan " &
"                                            and l1.t$cpac = l.t$cpac ) ) FGET " &
"        ON cisli940.t$fdty$l = FGET.CNST " &
"INNER JOIN WMWHSE7.ORDERS@DL_LN_WMS WMS_OA_ORDERS " &
"        ON SUBSTR(WMS_OA_ORDERS.EXTERNORDERKEY,5,9) = CISLI245.T$SHPM " &
" LEFT JOIN WMWHSE7.CODELKUP@DL_LN_WMS CODELKUP_OA " &
"        ON CODELKUP_OA.LISTNAME = 'ORDERTYPE' " &
"       AND CODELKUP_OA.CODE = WMS_OA_ORDERS.TYPE " &
"WHERE cisli940.t$fdty$l != 11 " &
"  AND cisli940.t$docn$l != 0 " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') " &
"                  AT time zone sessiontimezone) AS DATE)) " &
"      BETWEEN '" + Parameters!EmissaoDe.Value + "' " &
"          AND '" + Parameters!EmissaoAte.Value + "' " &
"ORDER BY FILIAL, DT_EMISSAO, NF "

)
