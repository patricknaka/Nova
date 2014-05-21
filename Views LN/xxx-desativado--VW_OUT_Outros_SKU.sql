SELECT  ltrim(rtrim(tcibd001.t$item)) SKU,
        tcibd001.t$dsca NOME_SKU,
        tcibd001.t$citg DEPARTAMENTO,
        tccom100.t$bpid COD_FORNECEDOR,
        tccom100.t$nama NOME_FORNECEDOR,
        tccom130.t$fovn$l CNPJ_FORNCEDOR,
        tcibd001.t$dtcr$c DATA_INCLUSÂO
FROM    ttcibd001201 tcibd001
LEFT JOIN ttdipu001201 tdipu001 ON tdipu001.t$item=tcibd001.t$item
LEFT JOIN ttccom100201 tccom100 ON tccom100.t$bpid=tdipu001.t$otbp
LEFT JOIN ttccom130201 tccom130 ON tccom130.t$cadr=tccom100.t$cadr
WHERE tcibd001.t$kitm = 1 OR tcibd001.t$kitm = 2
