select 
ltrim(rtrim(tdipu001.t$item)) as CD_ITEM,
tdipu001.t$prip as VL_COMPRA
from baandb.ttdipu001201 tdipu001
     inner join baandb.ttcibd001201 tcibd001
     ON tdipu001.t$item=tcibd001.t$item
WHERE tcibd001.t$lmdt>=TRUNC(sysdate-1, 'DAY')