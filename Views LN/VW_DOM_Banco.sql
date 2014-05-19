select  distinct a.t$baoc$l Cod_Banco,
        ( select b.t$bnam from ttfcmg011101 b
          where b.t$baoc$l=a.t$baoc$l
          and rownum=1) Ds_Banco
from ttfcmg011201 a