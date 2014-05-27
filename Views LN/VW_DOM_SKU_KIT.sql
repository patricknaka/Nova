SELECT  ltrim(rtrim(tibom010.t$mitm)) ITEM_KIT,
        ltrim(rtrim(tibom010.t$sitm)) COD_COMPONENTE
FROM    ttibom010201 tibom010
order by 1