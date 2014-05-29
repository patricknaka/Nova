select  a.t$npcl$c CD_CLASSE_NPRODUTO,
        a.t$dsca$c DS_ITEM_NPRODUTO,
        a.t$nptp$c NM_TIPO_NPRODUTO,
        b.t$dsca$c DS_TIPO_NPRODUTO
from tznisa002201 a, tznisa001201 b
where b.t$nptp$c=a.t$nptp$c
order by 1