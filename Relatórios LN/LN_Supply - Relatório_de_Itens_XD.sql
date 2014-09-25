SELECT  
  DISTINCT
    tcibd001.t$item    NUM_ITEM,
    tcibd001.t$dsca    DESC_ITEM,
    tdipu001.t$prip    PRECO_COMPRA,
    tcibd001.t$citg    NUM_GRUPO_ITEM,
    tcmcs023.t$dsca    DESC_GRUPO_ITEM,
    tdipu001.t$otbp    NUM_FORNECEDOR,
    tccom100.t$nama    DESC_FORNECEDOR,
    tcibd001.t$cean    NUM_EAN,
    tcibd001.t$csig    SITUACAO_ITEM,
    tccom130.t$fovn$l  CNPJ_FORNECEDOR,
    tccom130.t$nama    NOME_FORNECEDOR,
    tcibd001.t$ceat$l  NUM_EAN_GTIN,
    tcibd200.t$mioq    QTDE_MIN_ORDEM,
    tcibd001.t$espe$c  TIPO_ITEM,
    tcibd001.t$mdfb$c  MODELO_FABRICANTE,
    tdipu001.t$suti    TEMPO_FORNECIMENTO,
    whwmd210.t$cwar    ARMAZEM,
    CASE WHEN tdipu001.t$ixdn$c <> 3 THEN 1 
         ELSE 2 
     END               ITEM_XD_NOVA,
    tdipu001.t$ixdn$c  TIPO_XD_NOVA,
    iTIPOXD.DESCR DECR_TIPO_XD_NOVA,
    whwmd210.t$rcd_utc DT_ALTERCAO,
    znwmd200.t$rcd_utc DT_ARQ,
    znwmd200.T$qtdf$c  QT_ARQUIVO,
    znwmd200.T$prit$c  TEMPO_REPOS_ARQ,
    tcemm030.t$euca    ESTABELEC

FROM       baandb.ttcibd001201  tcibd001
  
 LEFT JOIN baandb.ttcmcs023201  tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
  
 LEFT JOIN baandb.ttdipu001201  tdipu001 
        ON tdipu001.t$item = tcibd001.t$item
  
 LEFT JOIN baandb.ttccom100201  tccom100
        ON tccom100.t$bpid = tdipu001.t$otbp
  
 LEFT JOIN baandb.ttccom130201  tccom130
        ON tccom130.t$cadr = tccom100.t$cadr 
  
INNER JOIN baandb.ttcibd200201 tcibd200
        ON tcibd200.t$item = tcibd001.t$item       
  
INNER JOIN baandb.twhwmd210201 whwmd210
        ON whwmd210.t$item = tcibd001.t$item
  
 LEFT JOIN baandb.tznwmd200201 znwmd200
        ON znwmd200.t$cwar$c=whwmd210.t$cwar
       AND znwmd200.t$item$c=whwmd210.t$item
       AND znwmd200.t$supl$c=tccom100.t$bpid
    
 LEFT JOIN baandb.ttcemm112201  tcemm112  
        ON tcemm112.t$waid=whwmd210.t$cwar       
 
 LEFT JOIN baandb.ttcemm030201  tcemm030  
        ON tcemm030.t$eunt=tcemm112.t$grid, 
 
  ( SELECT d.t$cnst CODE_STAT, l.t$desc DESC_TIPO_ITEM
      FROM baandb.tttadv401000 d, 
           baandb.tttadv140000 l 
     WHERE d.t$cpac= 'zn' 
       AND d.t$cdom= 'ibd.espe.c'
       AND d.t$vers= 'B61U'
       AND d.t$rele= 'a7'
       AND l.t$clab= d.t$za_clab
       AND l.t$clan= 'p'
       AND l.t$cpac= 'zn'
       AND l.t$vers=( SELECT max(l1.t$vers) 
                        from baandb.tttadv140000 l1 
                       WHERE l1.t$clab=l.t$clab 
                         AND l1.t$clan=l.t$clan 
                         AND l1.t$cpac=l.t$cpac ) ) iTABLE,
       
  ( SELECT d.t$cnst CODE,
           l.t$desc DESCR
      FROM baandb.tttadv401000 d,
           baandb.tttadv140000 l
     WHERE d.t$cpac='zn'
       AND d.t$cdom='ipu.ixdn.c'
       AND d.t$vers='B61U'
       AND d.t$rele='a7'
       AND d.t$cust='npt0'
       AND l.t$clab=d.t$za_clab
       AND l.t$clan='p'
       AND l.t$cpac='zn'
       AND l.t$vers=( select max(l1.t$vers)
                        from baandb.tttadv140000 l1 
                       where l1.t$clab=l.t$clab 
                         AND l1.t$clan=l.t$clan 
                         AND l1.t$cpac=l.t$cpac ) ) iTIPOXD

WHERE tcibd001.t$espe$c = iTABLE.CODE_STAT
  AND iTIPOXD.CODE = tdipu001.t$ixdn$c
  AND ( (tdipu001.t$ixdn$c = :XD) or (:XD = 0 and tdipu001.t$ixdn$c != 3) )
  AND tcibd001.t$citg IN (:Depto)  
  AND ( (tccom130.t$fovn$l like '%' || Trim(:CNPJ) || '%') OR (:CNPJ is null) )