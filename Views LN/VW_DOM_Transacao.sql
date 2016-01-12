SELECT
  CASE WHEN zngld001.t$tror$c=1 
    THEN 'CAP' 
  WHEN zngld001.t$tror$c=2 
    THEN 'CAR' 
  ELSE null END                 CD_MODULO,
  tfgld011.t$catg               CD_TIPO_TRANSACAO,
  tfgld011.t$ttyp               CD_TRANSACAO,  
  REGEXP_REPLACE(tfgld011.t$desc,
      '[^[:alnum:]'' '']', '')  DS_TRANSACAO

FROM baandb.ttfgld011201 tfgld011

LEFT JOIN (select distinct a.t$ttyp$c, a.t$tror$c 
            from baandb.tzngld001201 a) zngld001
ON zngld001.t$ttyp$c=tfgld011.t$ttyp

order by 1