SELECT 
       Q1.* 

FROM ( SELECT DISTINCT
              Trim(tcibd001.t$item) NUM_ITEM,
              tcibd001.t$dsca       DESC_ITEM,
              tcibd001.t$csig       SINALIZACAO_ITEM,  
              tcibd001.t$citg       NUM_GRUPO_ITEM,
              tcmcs023.t$dsca       DESC_GRUPO_ITEM,
              tcibd001.t$seto$c     NUM_SETOR,
              znmcs030.t$dsca$c     DESC_SETOR,
              tcibd001.t$fami$c     NUM_FAMILIA,
              znmcs031.t$dsca$c     NOME_FAMILIA,
              tcibd001.t$subf$c     NUM_SUB_FAMILIA,
              znmcs032.t$dsca$c     NOME_SUB_FAMILIA,
              whwmd215.t$cwar       FILIAL,
              whwmd630.t$qbls       COD_INVENTARIO,
              'WN'                  STATUS_INVENTARIO,  
              whwmd215.t$qhnd       QTDE_DISPONIVEL,
              whwmd215.t$qall       QTDE_ALOCADA,
              whwmd215.t$qcom       QTDE_RESERVADA,
              (  select tdpur401a.t$orno 
                   from baandb.ttdpur401201  tdpur401a 
                  where tdpur401a.t$item = whwmd215.t$item 
                    and tdpur401a.t$ddta < current_date
                    and tdpur401a.t$ddta = ( select max(tdpur401b.t$ddta)  
                                               from baandb.ttdpur401201  tdpur401b 
                                              where tdpur401b.t$orno = tdpur401a.t$orno) and rownum=1)  
                                     ORDEM_REPOSICAO,
              tdipu001.t$prip        PRECO_COMPRA,
              tccom130a.t$fovn$l     CNPJ_FORNECEDOR,
              tccom100.t$nama       NOME_FORNECEDOR
              
         FROM baandb.ttcibd001201  tcibd001
    LEFT JOIN baandb.ttcmcs023201  tcmcs023
           ON tcmcs023.t$citg = tcibd001.t$citg    
           
    LEFT JOIN baandb.ttdipu001201  tdipu001 
           ON tdipu001.t$item = tcibd001.t$item

    LEFT JOIN baandb.ttccom100201  tccom100
           ON tccom100.t$bpid = tdipu001.t$otbp             

    LEFT JOIN baandb.ttccom130201  tccom130a
           ON tccom130a.t$cadr = tccom100.t$cadr 

    LEFT JOIN baandb.ttccom100201  tccom100
           ON tccom100.t$bpid = tdipu001.t$otbp             

    LEFT JOIN baandb.tznmcs030201  znmcs030 
           ON znmcs030.t$seto$c = tcibd001.t$seto$c
          AND znmcs030.t$citg$c = tcibd001.t$citg

    LEFT JOIN baandb.tznmcs031201  znmcs031  
           ON znmcs031.t$seto$c = tcibd001.t$seto$c
          AND znmcs031.t$citg$c = tcibd001.t$citg
          AND znmcs031.t$fami$c = tcibd001.t$fami$c 

    LEFT JOIN baandb.tznmcs032201  znmcs032  
           ON znmcs032.t$seto$c = tcibd001.t$seto$c
          AND znmcs032.t$citg$c = tcibd001.t$citg
          AND znmcs032.t$fami$c = tcibd001.t$fami$c 
          AND znmcs032.t$subf$c = tcibd001.t$subf$c              

    LEFT JOIN baandb.twhwmd215201  whwmd215            
           ON whwmd215.t$item = tcibd001.t$item   
          AND whwmd215.t$cwar = tdipu001.t$cwar
          
    LEFT JOIN baandb.twhwmd630201 whwmd630
           ON whwmd630.t$item = tcibd001.t$item   
          AND whwmd630.t$cwar = tdipu001.t$cwar
         
        WHERE whwmd215.t$item = tcibd001.t$item

    
UNION


       SELECT DISTINCT
              Trim(tcibd001.t$item)  NUM_ITEM,
              tcibd001.t$dsca        DESC_ITEM,
              tcibd001.t$csig        SINALIZACAO_ITEM,  
              tcibd001.t$citg        NUM_GRUPO_ITEM,
              tcmcs023.t$dsca        DESC_GRUPO_ITEM,
              tcibd001.t$seto$c      NUM_SETOR,
              znmcs030.t$dsca$c      DESC_SETOR,
              tcibd001.t$fami$c      NUM_FAMILIA,
              znmcs031.t$dsca$c      NOME_FAMILIA,
              tcibd001.t$subf$c      NUM_SUB_FAMILIA,
              znmcs032.t$dsca$c      NOME_SUB_FAMILIA,
              whwmd215.t$cwar        FILIAL,
              whwmd630.t$qbls        COD_INVENTARIO,
              
              CASE WHEN whwmd630.t$qbls <> 0 THEN 'WN' 
                    END              STATUS_INVENTARIO,  
              
              0                      QTDE_DISPONIVEL,
              0                      QTDE_ALOCADA,
              0                      QTDE_RESERVADA,
              ( select tdpur401a.t$orno 
                  from baandb.ttdpur401201  tdpur401a 
                 where tdpur401a.t$item = whwmd215.t$item 
                   and tdpur401a.t$ddta < current_date
                   and tdpur401a.t$ddta = ( select max(tdpur401b.t$ddta)  
                                              from baandb.ttdpur401201  tdpur401b 
                                             where tdpur401b.t$orno = tdpur401a.t$orno) and rownum=1 )
                                     ORDEM_REPOSICAO,
              tdipu001.t$prip        PRECO_COMPRA,
              tccom130a.t$fovn$l     CNPJ_FORNECEDOR,
              tccom100.t$nama       NOME_FORNECEDOR
              
         FROM baandb.twhwmd630201  whwmd630,
              baandb.ttcibd001201  tcibd001
              
    LEFT JOIN baandb.ttcmcs023201  tcmcs023
           ON tcmcs023.t$citg = tcibd001.t$citg    
 
    LEFT JOIN baandb.ttdipu001201  tdipu001 
           ON tdipu001.t$item = tcibd001.t$item

    LEFT JOIN baandb.ttccom100201  tccom100
           ON tccom100.t$bpid = tdipu001.t$otbp
            
    LEFT JOIN baandb.ttccom130201  tccom130a
           ON tccom130a.t$cadr = tccom100.t$cadr 
  
    LEFT JOIN baandb.ttccom100201  tccom100
           ON tccom100.t$bpid = tdipu001.t$otbp             

    LEFT JOIN baandb.tznmcs030201  znmcs030 
           ON znmcs030.t$seto$c = tcibd001.t$seto$c
          AND znmcs030.t$citg$c = tcibd001.t$citg

    LEFT JOIN baandb.tznmcs031201  znmcs031  
           ON znmcs031.t$seto$c = tcibd001.t$seto$c
          AND znmcs031.t$citg$c = tcibd001.t$citg
          AND znmcs031.t$fami$c = tcibd001.t$fami$c 

    LEFT JOIN baandb.tznmcs032201  znmcs032  
           ON znmcs032.t$seto$c = tcibd001.t$seto$c
          AND znmcs032.t$citg$c = tcibd001.t$citg
          AND znmcs032.t$fami$c = tcibd001.t$fami$c 
          AND znmcs032.t$subf$c = tcibd001.t$subf$c 
          
    LEFT JOIN baandb.twhwmd215201  whwmd215            
           ON whwmd215.t$item = tcibd001.t$item  
          AND whwmd215.t$cwar = tdipu001.t$cwar 
              
        WHERE whwmd630.t$item = tcibd001.t$item ) Q1

WHERE ((FILIAL = '') OR (UPPER(Trim(Q1.FILIAL)) LIKE '%' || :FILIAL || '%'))
  AND UPPER(Trim(Q1.STATUS_INVENTARIO)) IN(:STATUS_INVENTARIO)
  AND Trim(Q1.NUM_GRUPO_ITEM) IN (:GrupoItem)
