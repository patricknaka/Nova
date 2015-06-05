Select 
-- O campo CD_CIA foi incluido para diferenciar NIKE(2) E BUNZL(3)
--**********************************************************************************************************************************************************
distinct "CD_BANCO","DS_BANCO","CD_CIA" from																
(select cast(a.t$baoc$l as varchar(3)) CD_Banco,
        ( select b.t$bnam from  baandb.ttfcmg011201 b
          where b.t$baoc$l=a.t$baoc$l
          and rownum=1) DS_Banco,
          CAST(2 AS INT) AS CD_CIA
from baandb.ttfcmg011201 a
UNION select cast(TO_CHAR(c.t$idbc$c) as varchar(3)) Cod_Banco,											
		(select d.t$desc$c from BAANDB.tzncmg020201 d
		 where d.t$idbc$c=c.t$idbc$c
		 and rownum=1) Ds_Banco,
     CAST(2 AS INT) AS CD_CIA
from BAANDB.tzncmg020201 c)
UNION Select '0' CD_Banco,  'Não Associado' DS_Banco, CAST(2 AS INT) CD_CIA from dual						
order by 1