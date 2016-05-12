SELECT
  DISTINCT
   tcemm030.t$euca        NUME_FILIAL,
   tdrec940.t$docn$l      NUME_NOTA,
   tdrec940.t$seri$l      NUME_SERIE,
   whinh300.t$recd$c      NR_SUMARIZADO,
   tdrec940.t$fire$l      REF_FISCAL,
   tdrec940.t$stat$l      ID_STATUS_NF,
   SITUACAO_NF.DESCR_NF   DESCR_STATUS_NF,
   tdrec940.t$cpay$l      CONDICAO_PAGTO_NR,
   tcmcs013r.t$dsca       DESC_CONDICAO_PAGTO_NR,  
   tdrec940.t$fovn$l      CNPJ_FORNECEDOR,
   tdrec940.t$fids$l      NOME_FORNECEDOR,
   
   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                          DATA_FISCAL,
        
   tdrec940.t$opfc$l      NUME_CFOP,
   Trim(tdpur401.t$item)  NUME_ITEM,
   tcibd001.t$dsca        DESC_ITEM,  
   tcibd001.t$citg        NUME_GRUPO_ITEM,
   tcmcs023.t$dsca        DESC_GRUPO_ITEM,
   tdpur401.t$orno        NUME_ORDEM,
   tdpur401.t$cpay        CONDICAO_PAGTO_PEDIDO,
   tcmcs013p.t$dsca       DESC_CONDICAO_PAGTO_PEDIDO,    
   tdpur401.t$cdec        CONDICAO_ENTREGA_NR,
   
   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                          DATA_ORDEM,   
        
   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$ddta, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                          DATA_PLANEJADA,
        
   tcibd001.t$csig        SINALIZACAO_ITEM,
   tdrec941.t$qnty$l      QTDE_RECEBIDA,
   tdpur401.t$qoor        QTDE_ORDENADA,
   tdrec941.t$pric$l      PRECO_UNITARIO,
   tdrec941.t$tamt$l      VALOR_TOTAL_LINHA,
   tdrec941.t$iprt$l      PRECO_TOTAL_ITEM,
   
   tdrec940.t$fdtc$l      COD_TIPO_DOCFISCAL,
   tcmcs966.t$dsca$l      DSC_TIPO_DOCFISCAL,
   tdrec940.t$rfdt$l      COD_TIPO_DOC_RECFISCAL,
   TP_Doc_RecFiscal.DESCR DSC_TIPO_DOC_RECFISCAL,
   
   tdrec940.t$cnfe$l      CHAVE_ACESSO,                    
   
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
                          VALOR_IPI
   
FROM       baandb.ttdrec941301 tdrec941

INNER JOIN baandb.ttdrec940301 tdrec940  
        ON tdrec940.t$fire$l = tdrec941.t$fire$l

 LEFT JOIN baandb.ttdrec947301 tdrec947
        ON tdrec947.t$fire$l = tdrec941.t$fire$l
       AND tdrec947.t$line$l = tdrec941.t$line$l
  
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tdrec940.t$sfra$l

 LEFT JOIN baandb.twhinh300301 whinh300  
        ON whinh300.t$fire$c = tdrec940.t$fire$l

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


WHERE tcemm124.t$dtyp = 2

  AND Trunc(tdrec940.t$date$l) 
      Between :DtFiscalDe 
          And :DtFiscalAte
  AND Trim(tcibd001.t$citg) IN (:GrupoItem)
  AND tdrec940.t$stat$l IN (:Status)
  AND nvl(Trim(tdrec940.t$fdtc$l), '0') in (:TipoDocFiscal)
  AND tdrec940.t$rfdt$l in (:TipoDocRecFiscal)
  AND ((:CNPJ Is Null) OR (tdrec940.t$fovn$l like '%' || Trim(:CNPJ) || '%'))

  
  
=

" SELECT  " &
"   DISTINCT  " &
"    tcemm030.t$euca        NUME_FILIAL,  " &
"    tdrec940.t$docn$l      NUME_NOTA,  " &
"    tdrec940.t$seri$l      NUME_SERIE,  " &
"    whinh300.t$recd$c      NR_SUMARIZADO,  " &
"    tdrec940.t$fire$l      REF_FISCAL,  " &
"    tdrec940.t$stat$l      ID_STATUS_NF,  " &
"    SITUACAO_NF.DESCR_NF   DESCR_STATUS_NF,  " &
"    tdrec940.t$cpay$l      CONDICAO_PAGTO_NR,  " &
"    tcmcs013r.t$dsca       DESC_CONDICAO_PAGTO_NR,    " &
"    tdrec940.t$fovn$l      CNPJ_FORNECEDOR,  " &
"    tdrec940.t$fids$l      NOME_FORNECEDOR,  " &
"      " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'),   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DATA_FISCAL,  " &
"           " &
"    tdrec940.t$opfc$l      NUME_CFOP,  " &
"    Trim(tdpur401.t$item)  NUME_ITEM,  " &
"    tcibd001.t$dsca        DESC_ITEM,    " &
"    tcibd001.t$citg        NUME_GRUPO_ITEM,  " &
"    tcmcs023.t$dsca        DESC_GRUPO_ITEM,  " &
"    tdpur401.t$orno        NUME_ORDEM,  " &
"    tdpur401.t$cpay        CONDICAO_PAGTO_PEDIDO,  " &
"    tcmcs013p.t$dsca       DESC_CONDICAO_PAGTO_PEDIDO,      " &
"    tdpur401.t$cdec        CONDICAO_ENTREGA_NR,  " &
"      " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$odat, 'DD-MON-YYYY HH24:MI:SS'),   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DATA_ORDEM,     " &
"           " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur401.t$ddta, 'DD-MON-YYYY HH24:MI:SS'),   " &
"      'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DATA_PLANEJADA,  " &
"           " &
"    tcibd001.t$csig        SINALIZACAO_ITEM,  " &
"    tdrec941.t$qnty$l      QTDE_RECEBIDA,  " &
"    tdpur401.t$qoor        QTDE_ORDENADA,  " &
"    tdrec941.t$pric$l      PRECO_UNITARIO,  " &
"    tdrec941.t$tamt$l      VALOR_TOTAL_LINHA,  " &
"    tdrec941.t$iprt$l      PRECO_TOTAL_ITEM,  " &
"      " &
"    tdrec940.t$fdtc$l      COD_TIPO_DOCFISCAL,  " &
"    tcmcs966.t$dsca$l      DSC_TIPO_DOCFISCAL,  " &
"    tdrec940.t$rfdt$l      COD_TIPO_DOC_RECFISCAL,  " &
"    TP_Doc_RecFiscal.DESCR DSC_TIPO_DOC_RECFISCAL,  " &
"      " &
"    tdrec940.t$cnfe$l      CHAVE_ACESSO,                      " &
"      " &
"    ( SELECT tdrec942.t$amnt$l   " &
"        FROM baandb.ttdrec942" + Parameters!Compania.Value +  "  tdrec942   " &
"       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l   " &
"         AND tdrec942.t$line$l = tdrec941.t$line$l   " &
"         AND tdrec942.t$brty$l = 1 )  " &
"                           VALOR_ICMS,  " &
"           " &
"    ( SELECT tdrec942.t$amnt$l   " &
"        FROM baandb.ttdrec942" + Parameters!Compania.Value +  "  tdrec942   " &
"       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l   " &
"         AND tdrec942.t$line$l = tdrec941.t$line$l   " &
"         AND tdrec942.t$brty$l = 5 )  " &
"                           VALOR_PIS,  " &
"           " &
"    ( SELECT tdrec942.t$amnt$l   " &
"        FROM baandb.ttdrec942" + Parameters!Compania.Value +  "  tdrec942   " &
"       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l   " &
"         AND tdrec942.t$line$l = tdrec941.t$line$l   " &
"         AND tdrec942.t$brty$l = 6 )  " &
"                           VALOR_COFINS,  " &
"           " &
"    ( SELECT tdrec942.t$amnt$l   " &
"        FROM baandb.ttdrec942" + Parameters!Compania.Value +  "  tdrec942   " &
"       WHERE tdrec942.t$fire$l = tdrec941.t$fire$l   " &
"         AND tdrec942.t$line$l = tdrec941.t$line$l   " &
"         AND tdrec942.t$brty$l = 3 )  " &
"                           VALOR_IPI  " &
"      " &
" FROM       baandb.ttdrec941" + Parameters!Compania.Value +  " tdrec941  " &
"   " &
" INNER JOIN baandb.ttdrec940" + Parameters!Compania.Value +  " tdrec940    " &
"         ON tdrec940.t$fire$l = tdrec941.t$fire$l  " &
"   " &
"  LEFT JOIN baandb.ttdrec947" + Parameters!Compania.Value +  " tdrec947  " &
"         ON tdrec947.t$fire$l = tdrec941.t$fire$l  " &
"        AND tdrec947.t$line$l = tdrec941.t$line$l  " &
"     " &
" INNER JOIN baandb.ttccom130" + Parameters!Compania.Value +  " tccom130  " &
"         ON tccom130.t$cadr = tdrec940.t$sfra$l  " &
"   " &
"  LEFT JOIN baandb.twhinh300" + Parameters!Compania.Value +  " whinh300    " &
"         ON whinh300.t$fire$c = tdrec940.t$fire$l  " &
"   " &
" INNER JOIN baandb.ttdpur401" + Parameters!Compania.Value +  " tdpur401    " &
"         ON tdpur401.t$orno = tdrec947.t$orno$l  " &
"        AND tdpur401.t$pono = tdrec947.t$pono$l  " &
"        AND tdpur401.t$sqnb = tdrec947.t$seqn$l  " &
"   " &
" INNER JOIN baandb.ttdpur400" + Parameters!Compania.Value +  " tdpur400    " &
"         ON tdpur400.t$orno = tdpur401.t$orno  " &
"   " &
" INNER JOIN baandb.ttcemm124" + Parameters!Compania.Value +  " tcemm124     " &
"         ON tcemm124.t$cwoc = tdpur400.t$cofc  " &
"           " &
" INNER JOIN baandb.ttcemm030" + Parameters!Compania.Value +  " tcemm030  " &
"         ON tcemm030.t$eunt = tcemm124.t$grid  " &
"                                         " &
"  LEFT JOIN baandb.ttcmcs013201 tcmcs013p   " &
"         ON tcmcs013p.t$cpay = tdpur401.t$cpay  " &
"           " &
"  LEFT JOIN baandb.ttcibd001" + Parameters!Compania.Value +  " tcibd001    " &
"         ON  tcibd001.t$item   = tdpur401.t$item  " &
"           " &
"  LEFT JOIN baandb.ttcmcs023" + Parameters!Compania.Value +  " tcmcs023    " &
"         ON tcmcs023.t$citg   = tcibd001.t$citg  " &
"           " &
"  LEFT JOIN baandb.ttcmcs013201 tcmcs013r   " &
"         ON tcmcs013r.t$cpay  = tdrec940.t$cpay$l  " &
"   " &
"  LEFT JOIN baandb.ttcmcs966" + Parameters!Compania.Value +  " tcmcs966   " &
"         ON tcmcs966.t$fdtc$l  = tdrec940.t$fdtc$l  " &
"   " &
"  LEFT JOIN ( select l.t$desc DESCR_NF,  " &
"                     d.t$cnst  " &
"                from baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               where d.t$cpac = 'td'  " &
"                 and d.t$cdom = 'rec.stat.l'  " &
"                 and l.t$clan = 'p'  " &
"                 and l.t$cpac = 'td'  " &
"                 and l.t$clab = d.t$za_clab  " &
"                 and rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4) )  " &
"                                            FROM baandb.tttadv401000 l1  " &
"                                           WHERE l1.t$cpac = d.t$cpac  " &
"                                             AND l1.t$cdom = d.t$cdom )  " &
"                 and rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4) )  " &
"                                            FROM baandb.tttadv140000 l1  " &
"                                           WHERE l1.t$clab = l.t$clab  " &
"                                             AND l1.t$clan = l.t$clan  " &
"                                             AND l1.t$cpac = l.t$cpac ) ) SITUACAO_NF  " &
"         ON SITUACAO_NF.t$cnst = tdrec940.t$stat$l  " &
"           " &
"           " &
"  LEFT JOIN ( select l.t$desc DESCR,  " &
"                     d.t$cnst  " &
"                from baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               where d.t$cpac = 'td'  " &
"                 and d.t$cdom = 'rec.trfd.l'  " &
"                 and l.t$clan = 'p'  " &
"                 and l.t$cpac = 'td'  " &
"                 and l.t$clab = d.t$za_clab  " &
"                 and rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4) )  " &
"                                            FROM baandb.tttadv401000 l1  " &
"                                           WHERE l1.t$cpac = d.t$cpac  " &
"                                             AND l1.t$cdom = d.t$cdom )  " &
"                 and rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4) )  " &
"                                            FROM baandb.tttadv140000 l1  " &
"                                           WHERE l1.t$clab = l.t$clab  " &
"                                             AND l1.t$clan = l.t$clan  " &
"                                             AND l1.t$cpac = l.t$cpac ) ) TP_Doc_RecFiscal  " &
"         ON TP_Doc_RecFiscal.t$cnst = tdrec940.t$rfdt$l  " &
"   " &
"   " &
" WHERE tcemm124.t$dtyp = 2  " &
"   " &
"   AND Trunc(tdpur401.t$odat)   " &
"       Between :DtOrdemDe   " &
"           And :DtOrdemAte  " &
"   AND Trim(tcibd001.t$citg) IN (:GrupoItem)  " &
"   AND tdrec940.t$stat$l IN (:Status)  " &
"   AND nvl(Trim(tdrec940.t$fdtc$l), '0') in (:TipoDocFiscal)  " &
"   AND tdrec940.t$rfdt$l in (:TipoDocRecFiscal)  " &
"   AND ((:CNPJ Is Null) OR (tdrec940.t$fovn$l like '%' || Trim(:CNPJ) || '%')) "