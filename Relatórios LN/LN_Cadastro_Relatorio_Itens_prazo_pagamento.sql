select trim(tcibd001.t$item)       ITEM,
          tcibd001.t$dscb$c           DESCRICAO,
          tccom130.t$fovn$l           CNPJ,
          tccom130.t$nama             DESCR_FORNECEDOR,
          tcmcs023.t$citg             GRUPO_ITEM,
          tcmcs023.t$dsca             DESCR_GRUPO_ITEM,
          znmcs030.t$seto$c           SETOR,
          znmcs030.t$dsca$c           DESCR_SETOR,
          znmcs031.t$fami$c           FAMILIA,
          znmcs031.t$dsca$c           DESCR_FAMILIA,
          znmcs032.t$subf$c           SUBFAMILIA,
          znmcs032.t$dsca$c           DESCR_SUBFAMILIA,
          znpur008.t$cpay$c           COD_COND_PGTO,
          tcmcs013.t$dsca             DESCR_COND_PGTO

     from ( select a.t$item,
                   Trim(a.t$citg) t$citg,
                   a.t$cmnf,
                   a.t$dscb$c,
                   a.t$seto$c,
                   a.t$fami$c,
                   a.t$subf$c
              from baandb.ttcibd001301 a
             where trim(a.t$citg) = '37'              -- Esporte/Lazer
                or trim(a.t$citg) = '977'             -- Brinquedos
                or trim(a.t$citg) = '983' ) tcibd001  -- Bebês
     
left join baandb.ttcmcs023301 tcmcs023
       on tcmcs023.t$citg = tcibd001.t$citg

left join baandb.tznmcs030301 znmcs030
       on znmcs030.t$citg$c = tcibd001.t$citg
      and znmcs030.t$seto$c = tcibd001.t$seto$c

left join baandb.tznmcs031301 znmcs031
       on znmcs031.t$citg$c = tcibd001.t$citg
      and znmcs031.t$seto$c = tcibd001.t$seto$c
      and znmcs031.t$fami$c = tcibd001.t$fami$c

left join baandb.tznmcs032301 znmcs032  
       on znmcs032.t$citg$c = tcibd001.t$citg
      and znmcs032.t$seto$c = tcibd001.t$seto$c
      and znmcs032.t$fami$c = tcibd001.t$fami$c
      and znmcs032.t$subf$c = tcibd001.t$subf$c

left join baandb.ttcmcs060301 tcmcs060
       on tcmcs060.t$cmnf = tcibd001.t$cmnf

left join baandb.ttccom130301 tccom130
       on tccom130.t$cadr = tcmcs060.t$cadr

left join ( select a.t$citg$c,
                   a.t$ftyp$c,
                   a.t$fovn$c,
                   a.t$cpay$c
              from baandb.tznpur008301 a
          group by a.t$citg$c,
                   a.t$ftyp$c,
                   a.t$fovn$c,
                   a.t$cpay$c ) znpur008
       on znpur008.t$citg$c = tcibd001.t$citg
      and znpur008.t$ftyp$c = tccom130.t$ftyp$l
      and znpur008.t$fovn$c = tccom130.t$fovn$l

left join baandb.ttcmcs013301 tcmcs013 
       on tcmcs013.t$cpay  = znpur008.t$cpay$c
       
    where tcibd001.t$citg in (:GrupoItem)

 order by GRUPO_ITEM, SETOR, FAMILIA, SUBFAMILIA