select  RTRIM(LTRIM(ipu001.t$item)) ITEM, 
        ipu001.t$prip PRC_COMPRA
    from    ttdipu001201 ipu001, --DADOS DE COMPRA DO ITEM
            ttcibd001201 ibd001, --DADOS GERAIS DO ITEM
            tznisa002201 isa002 --DADOS DE VENDA DO ITEM
        where   ipu001.t$item   = ibd001.t$item
            and ibd001.t$npcl$c = isa002.t$npcl$c 
            and ibd001.t$kitm   in (4,5)
            and isa002.t$nptp$c in ('G','F','D','E')