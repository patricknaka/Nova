-- #FAF.064 - 22-mai-2014, Fabio Ferreira, 	Adicionados os códigos do banco do site
--**********************************************************************************************************************************************************
Select distinct * from																--#FAF.064.n 
(select a.t$baoc$l CD_Banco,
        ( select b.t$bnam from ttfcmg011201 b
          where b.t$baoc$l=a.t$baoc$l
          and rownum=1) DS_Banco
from ttfcmg011201 a
UNION select TO_CHAR(c.t$idbc$c) Cod_Banco,											--#FAF.064.sn
		(select d.t$desc$c from BAANDB.tzncmg020201 d
		 where d.t$idbc$c=c.t$idbc$c
		 and rownum=1) Ds_Banco
from BAANDB.tzncmg020201 c)
UNION Select '0' CD_Banco,  'Não Associado' DS_Banco from dual						--#FAF.064.en
order by 1