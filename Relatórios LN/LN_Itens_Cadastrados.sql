SELECT
  DISTINCT
    Trim(tcibd001.t$item)     NUM_ITEM,
    tcibd001.t$dscb$c         DESC_ITEM,
    tdipu001.t$prip           PRECO_COMPRA,
    tcibd001.t$citg           NUM_GRUPO_ITEM,
    tcmcs023.t$dsca           DESC_GRUPO_ITEM,
    tcibd001.t$seto$c         NUM_SETOR,
    znmcs030.t$dsca$c         DESC_SETOR,
    tcibd001.t$fami$c         NUM_FAMILIA,
    znmcs031.t$dsca$c         NOME_FAMILIA,
    tcibd001.t$subf$c         NUM_SUB_FAMILIA,
    znmcs032.t$dsca$c         NOME_SUB_FAMILIA,
    tcibd936.t$frat$l         NUM_NBM,
    whwmd400.t$hght           ITEM_ALTURA,
    whwmd400.t$wdth           ITEM_LARGURA,
    whwmd400.t$dpth           ITEM_COMPRIMENTO,
    tcibd001.t$wght           ITEM_PESO,
    tcibd001.t$tptr$C         TIPO_TRANSPORTE,
    tcibd004.t$aitc           ITEM_ALTERNATIVO,
    znibd001.t$eanc$c         NUM_EAN,
    tcibd001.t$csig           SINALIZACAO_ITEM,
    tccom130a.t$fovn$l        CNPJ_FORNECEDOR,
    tccom130a.t$nama          NOME_FORNECEDOR,
    tcibd001.t$obse$c         ITEM_OBSERVACAO,
    tccom130b.t$fovn$l        CNPJ_FABRICANTE,
    tccom130b.t$nama          NOME_FABRICANTE,
    whwmd400.t$abcc           NUM_ABC,
    tdipu001.t$nrpe$c         PRAZO_GARANTIA,
    tcibd001.t$ceat$l         NUM_EAN_GTIN,
    tcibd200.t$mioq           QTDE_MIN_ORDEM,
    whwmd400.t$npsl           PRAZO_VALIDADE,
    whwmd400.t$pavl$c         PRAZO_ALARME,
    whwmd400.t$pmrc$c         PRAZO_RECEBIMENTO,
    whwmd400.t$pmex$c         PRAZO_EXPEDICAO,
    tcibd001.t$nwgt$l         PESO_LIQUIDO,
    tcibd001.t$kitm           TIPO_ITEM, 
    ( SELECT l.t$desc DESC_KITM
        FROM baandb.tttadv401000 d, 
             baandb.tttadv140000 l 
       WHERE d.t$cpac = 'tc' 
         AND d.t$cdom = 'kitm'
         AND l.t$clan = 'p'
         AND l.t$cpac = 'tc'
         AND l.t$clab = d.t$za_clab
         AND d.t$cnst = tcibd001.t$kitm
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
                                     and l1.t$cpac = l.t$cpac)) 
                              DESC_KITM,
    tcibd001.t$mdfb$c         MODELO_FABRICANTE,
    tcibd001.t$mont$c         POSSUI_MONTAGEM,
    tcibd001.t$uatc$c         UTILIZA_ATACADO,
    tcibd001.t$auth$c         NOME_AUTOR,
    tcibd001.t$clor$c         COR_PRODUTO,
    tcibd001.t$size$c         TAMANHO_PRODUTO,
    tcibd001.t$npcl$c         CLASSE_PRODUTO,

    CASE WHEN ( Trim(znisa002.t$dsca$c) = '' OR Trim(znisa002.t$dsca$c) IS NULL ) 
           THEN 'Produto'
         ELSE Trim(znisa002.t$dsca$c)
     END                      DESCR_CLASSE_PRODUTO,

    tdipu001.t$suti           TEMPO_FORNECIMENTO,
    tcibd200.t$cwar           ARMAZEM,
    tdipu001.t$ixdn$c         TIPO_XD_NOVA,
 
    ( SELECT l.t$desc DESCR_TIPO_XD_NOVA
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac = 'zn'
         AND d.t$cdom = 'ipu.ixdn.c'
         AND l.t$clan = 'p'
         AND l.t$cpac = 'zn'
         AND l.t$clab = d.t$za_clab
         AND d.t$cnst = tdipu001.t$ixdn$c
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
                                     and l1.t$cpac = l.t$cpac ) ) 
                              DESCR_TIPO_XD_NOVA,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$dtcr$c, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                              DATA_INCLUSAO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$lmdt, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                              DATA_ALTRERACAO,
      
    tcibd001.t$seab           CHAVE_DE_BUSCA_II,
    tcibd936.t$sour$l         ORIGEM,
 
    ( SELECT l.t$desc DESCR_ORIGEM
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac = 'tc'
         AND d.t$cdom = 'sour.l'
         AND l.t$clan = 'p'
         AND l.t$cpac = 'tc'
         AND l.t$clab = d.t$za_clab
         AND d.t$cnst = tcibd936.t$sour$l
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
                                     and l1.t$cpac = l.t$cpac ) ) 
                              DESCR_ORIGEM,
    
    tcibd200.t$osys           SISTEMA_DA_ORDEM,
 
    ( SELECT l.t$desc DESCR_SISTEMA_DA_ORDEM
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac = 'tc'
         AND d.t$cdom = 'osys'
         AND l.t$clan = 'p'
         AND l.t$cpac = 'tc'
         AND l.t$clab = d.t$za_clab
         AND d.t$cnst = tcibd200.t$osys
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
                                     and l1.t$cpac = l.t$cpac ) ) 
                              DESCR_SISTEMA_DA_ORDEM,
    
    tcibd001.t$espe$c         ITEM_ESPECIAL,
 
    ( SELECT l.t$desc DESC_ITEM_ESPECIAL
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac = 'zn'
         AND d.t$cdom = 'ibd.espe.c'
         AND l.t$clan = 'p'
         AND l.t$cpac = 'zn'
         AND l.t$clab = d.t$za_clab
         AND d.t$cnst = tcibd001.t$espe$c
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
                                     and l1.t$cpac = l.t$cpac ) ) 
                              DESC_ITEM_ESPECIAL,   
         
    tcibd001.t$okfi$c         OK_FISCAL,
    
    CASE WHEN tcibd001.t$okfi$c = 1 THEN 'Sim'
         ELSE 'Não'
     END                      DESC_OK_FISCAL

FROM      baandb.ttcibd001301 tcibd001

LEFT JOIN baandb.tznisa002301 znisa002
       ON znisa002.t$npcl$c = tcibd001.t$npcl$c  

LEFT JOIN baandb.ttcmcs023301 tcmcs023
       ON tcmcs023.t$citg   = tcibd001.t$citg    

LEFT JOIN baandb.ttdipu001301 tdipu001 
       ON tdipu001.t$item   = tcibd001.t$item

LEFT JOIN baandb.ttccom100301 tccom100
       ON tccom100.t$bpid   = tdipu001.t$otbp             
  
LEFT JOIN baandb.ttccom130301 tccom130a
       ON tccom130a.t$cadr  = tccom100.t$cadr 
  
LEFT JOIN baandb.ttccom100301 tccom100
       ON tccom100.t$bpid   = tdipu001.t$otbp
    
LEFT JOIN baandb.ttcibd004301 tcibd004  
       ON tcibd004.t$item   = tcibd001.t$item 
      AND tcibd004.t$bpid   = tdipu001.t$otbp
      AND tcibd004.t$citt   = '000'
  
LEFT JOIN baandb.ttcibd936301 tcibd936            
       ON tcibd936.t$ifgc$l = tcibd001.t$ifgc$l
  
LEFT JOIN baandb.ttcmcs060301 tcmcs060
       ON tcmcs060.t$cmnf   = tcibd001.t$cmnf
  
LEFT JOIN baandb.ttccom130301 tccom130b
       ON tccom130b.t$cadr  = tcmcs060.t$cadr             
  
LEFT JOIN baandb.ttcibd200301 tcibd200
       ON tcibd200.t$item   = tcibd001.t$item
  
LEFT JOIN baandb.tznibd001301 znibd001
       ON znibd001.t$item$c = tcibd001.t$item
  
LEFT JOIN baandb.tznmcs030301 znmcs030 
       ON znmcs030.t$seto$c = tcibd001.t$seto$c
      AND znmcs030.t$citg$c = tcibd001.t$citg
  
LEFT JOIN baandb.tznmcs031301 znmcs031 
       ON znmcs031.t$seto$c = tcibd001.t$seto$c
      AND znmcs031.t$citg$c = tcibd001.t$citg
      AND znmcs031.t$fami$c = tcibd001.t$fami$c 
  
LEFT JOIN baandb.tznmcs032301 znmcs032 
       ON znmcs032.t$seto$c = tcibd001.t$seto$c
      AND znmcs032.t$citg$c = tcibd001.t$citg
      AND znmcs032.t$fami$c = tcibd001.t$fami$c 
      AND znmcs032.t$subf$c = tcibd001.t$subf$c              

LEFT JOIN baandb.twhwmd400301 whwmd400
       ON whwmd400.t$item   = tcibd001.t$item                      
  
LEFT JOIN baandb.twhwmd220301 whwmd210
       ON whwmd210.t$item   = tcibd001.t$item
        
WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$dtcr$c, 'DD-MON-YYYY HH24:MI:SS'), 
             'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) 
                   BETWEEN NVL(:DataInclusaoDe, CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$dtcr$c, 'DD-MON-YYYY HH24:MI:SS'), 
                                                 'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) 
                       AND NVL(:DataInclusaoAte, CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$dtcr$c, 'DD-MON-YYYY HH24:MI:SS'), 
                                                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE))
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$lmdt, 'DD-MON-YYYY HH24:MI:SS'), 
            'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) 
                   BETWEEN NVL(:DataAlteracaoDe, CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$lmdt, 'DD-MON-YYYY HH24:MI:SS'), 
                                                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) 
                       AND NVL(:DataAlteracaoAte,     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tcibd001.t$lmdt, 'DD-MON-YYYY HH24:MI:SS'), 
                                                   'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE))
  AND tcibd001.t$npcl$c IN (:TipoClasse)
  AND tcibd001.t$csig   IN (:Situacao)
  AND tdipu001.t$ixdn$c IN (:TipoXD)
  AND ( (Trim(tccom130a.t$fovn$l) Like '%' || :CNPJ || '%') OR (:CNPJ is null) )