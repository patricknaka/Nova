SELECT  ltrim(rtrim(a.t$item)) ITEM, 
        d.t$cwar ARMAZEM, 
        c.t$grid UNID_EMPRESARIAL, 
        cast(sum(a.t$mauc$1) as numeric(15,5)) CMV, 
        cast(sum(d.t$qhnd-d.t$qblk) as numeric(15,0)) ESTOQUE_LIVRE,
        cast(sum(d.t$qhnd)as numeric(15,0)) ESTOQUE_TOTAL
FROM    twhina113201 a, 
        twhina112201 b, 
        ttcemm112201 c, 
        twhwmd215201 d
WHERE   a.t$item=b.t$item
      AND   a.t$cwar=b.t$cwar
      AND   a.t$trdt=b.t$trdt
      AND   a.t$seqn=b.t$seqn
      AND   a.t$inwp=b.t$inwp
      AND   c.t$waid=a.t$cwar
      AND   d.t$item=b.t$item
      AND   d.t$cwar=b.t$cwar
      AND   a.t$trdt = (select max(a1.t$trdt) from twhina113201 a1
                        where            a1.t$cwar=a.t$cwar
                  AND   a1.t$item=a.t$item
                  AND   a1.t$inwp=a.t$inwp)
    AND  a.t$seqn=(select max(a2.t$seqn) from twhina113201 a2
            where   a2.t$cwar=a.t$cwar
            AND     a2.t$item=a.t$item
            AND     a2.t$inwp=a.t$inwp
            AND   a2.t$trdt=a.t$trdt)
GROUP BY a.t$item, c.t$grid, d.t$cwar