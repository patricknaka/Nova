SELECT
 DISTINCT
  tcemm030.t$euca        NUME_FILIAL,
  tdrec940.t$docn$l      NUME_NOTA,
  tdrec940.t$seri$l      NUME_SERIE,
  whinh300.t$recd$c      NR_SUMARIZADO,
  tdrec940.t$fire$l      REF_FISCAL,
  tdrec940.t$cpay$l      CONDICAO_PAGTO_NR,
  tcmcs013r.t$dsca       DESC_CONDICAO_PAGTO_NR,  
  tdrec940.t$fovn$l      CNPJ_FORNECEDOR,
  tdrec940.t$fids$l      NOME_FORNECEDOR,
  tdrec940.t$date$l      DATA_FISCAL, 
  tdrec940.t$opfc$l      NUME_CFOP,
  Trim(tdpur401.t$item)  NUME_ITEM,
  tcibd001.t$dsca        DESC_ITEM,  
  tcibd001.t$citg        NUME_GRUPO_ITEM,
  tcmcs023.t$dsca        DESC_GRUPO_ITEM,
  tdpur406.t$orno        NUME_ORDEM,
  tdpur401.t$cpay        CONDICAO_PAGTO_PEDIDO,
  tcmcs013p.t$dsca       DESC_CONDICAO_PAGTO_PEDIDO,    
  tdpur401.t$cdec        CONDICAO_ENTREGA_NR,
  tdpur401.t$odat        DATA_ORDEM,   
  tdpur401.t$ddta        DATA_PLANEJADA, 
  tcibd001.t$csig        SINALIZACAO_ITEM,
  tdpur401.t$qidl        QTDE_RECEBIDA,
  tdpur401.t$qoor        QTDE_ORDENADA,
  tdrec941.t$pric$l      PRECO_UNITARIO,
  tdrec941.t$tamt$l      VALOR_TOTAL_LINHA,
  tdrec941.t$iprt$l      PRECO_TOTAL_ITEM,
  ( SELECT  tdrec942.t$amnt$l 
    FROM    ttdrec942201  tdrec942 
    WHERE   tdrec942.t$fire$l = tdrec941.t$fire$l 
    AND     tdrec942.t$line$l = tdrec941.t$line$l 
    AND     tdrec942.t$brty$l = 1)
                         VALOR_ICMS,
  ( SELECT  tdrec942.t$amnt$l 
    FROM    ttdrec942201  tdrec942 
    WHERE   tdrec942.t$fire$l = tdrec941.t$fire$l 
    AND     tdrec942.t$line$l = tdrec941.t$line$l 
    AND     tdrec942.t$brty$l = 5)
                         VALOR_PIS,
  ( SELECT  tdrec942.t$amnt$l 
    FROM    ttdrec942201  tdrec942 
    WHERE   tdrec942.t$fire$l = tdrec941.t$fire$l 
    AND     tdrec942.t$line$l = tdrec941.t$line$l 
    AND     tdrec942.t$brty$l = 6)
                         VALOR_COFINS,
  ( SELECT  tdrec942.t$amnt$l 
    FROM    ttdrec942201  tdrec942 
    WHERE   tdrec942.t$fire$l = tdrec941.t$fire$l 
    AND     tdrec942.t$line$l = tdrec941.t$line$l 
    AND     tdrec942.t$brty$l = 3)
                         VALOR_IPI
  
FROM       baandb.ttdpur406201  tdpur406
INNER JOIN baandb.twhinh312201  whinh312  
        ON whinh312.t$rcno=tdpur406.t$rcno
       AND whinh312.t$rcln=tdpur406.t$rseq

 LEFT JOIN baandb.ttdrec947201  tdrec947  
        ON tdrec947.t$oorg$l = whinh312.t$oorg
       AND tdrec947.t$orno$l = tdpur406.t$orno
       AND tdrec947.t$pono$l = tdpur406.t$pono
       AND tdrec947.t$seqn$l = tdpur406.t$sqnb  
                                      
 LEFT JOIN baandb.ttdrec941201  tdrec941  
        ON tdrec941.t$fire$l = tdrec947.t$fire$l
       AND tdrec941.t$line$l = tdrec947.t$line$l
       
 LEFT JOIN baandb.ttdrec940201  tdrec940  
        ON tdrec940.t$fire$l = tdrec941.t$fire$l

 LEFT JOIN baandb.twhinh300201  whinh300  
        ON whinh300.t$fire$c = tdrec940.t$fire$l

INNER JOIN baandb.ttdpur401201  tdpur401  
        ON tdpur401.t$orno   = tdpur406.t$orno
       AND tdpur401.t$pono   = tdpur406.t$pono
       AND tdpur401.t$sqnb   = tdpur406.t$sqnb

INNER JOIN baandb.ttdpur400201  tdpur400  
        ON tdpur400.t$orno=tdpur406.t$orno
                                      
 LEFT JOIN baandb.ttcmcs013201  tcmcs013p 
        ON tcmcs013p.t$cpay  = tdpur401.t$cpay
        
 LEFT JOIN baandb.ttcibd001201  tcibd001  
        ON  tcibd001.t$item   = tdpur401.t$item
        
 LEFT JOIN baandb.ttcmcs023201  tcmcs023  
        ON tcmcs023.t$citg   = tcibd001.t$citg
        
 LEFT JOIN baandb.ttcmcs013201  tcmcs013r 
        ON tcmcs013r.t$cpay  = tdrec940.t$cpay$l,
           
           ttccom130201  tccom130,
           ttcemm030201  tcemm030,
           ttcemm124201  tcemm124     

WHERE tccom130.t$cadr = tdrec940.t$sfra$l 
  AND tcemm124.t$cwoc = tdpur400.t$cofc 
  AND tcemm124.t$dtyp = 2
  AND tcemm030.t$eunt = tcemm124.t$grid
  
  AND ((:CNPJ Is Null) OR (tdrec940.t$fovn$l like '%' || Trim(:CNPJ) || '%'))
  AND Trunc(tdpur401.t$odat) BETWEEN :DtOrdemDe AND :DtOrdemAte
  AND Trim(tcibd001.t$citg) IN (:GrupoItem)