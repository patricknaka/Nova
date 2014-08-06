-- FAF.005 - 14-mai-2014, Fabio Ferreira, 	Incluida informação do módulo com base na tabela zngld001 (zngldc101m000)
-- FAF.269 - 06-ago-2014, Fabio Ferreira, 	Ajuste para retirar caracteres especiais
--************************************************************************************************************************************************************
SELECT
--  tfgld011.t$catg COD_MODULO,                                --#FAF.005.o
  CASE WHEN zngld001.t$tror$c=1 THEN 'CAP' 
  WHEN zngld001.t$tror$c=2 THEN 'CAR' ELSE null END CD_MODULO,               --#FAF.005.n
  tfgld011.t$catg CD_TIPO_TRANSACAO,        --#FAF.005.n
  tfgld011.t$ttyp CD_TRANSACAO,  
--  tfgld011.t$desc DS_TRANSACAO 															--#FAF.269.o
  REGEXP_REPLACE(tfgld011.t$desc,'[^[:alnum:]'' '']', '') DS_TRANSACAO						--#FAF.269.n
FROM baandb.ttfgld011201 tfgld011
LEFT JOIN ( select distinct a.t$ttyp$c, a.t$tror$c from baandb.tzngld001201 a) zngld001      --#FAF.005.n
ON zngld001.t$ttyp$c=tfgld011.t$ttyp                            --#FAF.005.n
order by 1