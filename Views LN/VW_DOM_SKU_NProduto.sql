select  a.t$npcl$c CLASSE_NPRODUTO,
        a.t$dsca$c DESCR,
        a.t$nptp$c TIPO_NAO_PROD,
        b.t$dsca$c DESCR_TIPO_NAO_PROD
from tznisa002201 a, tznisa001201 b
where b.t$nptp$c=a.t$nptp$c