SELECT
  CASE WHEN regexp_replace(e.T$FOVN$L, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
  WHEN LENGTH(regexp_replace(e.T$FOVN$L, '[^0-9]', ''))<11
    THEN '00000000000000'
  ELSE regexp_replace(e.T$FOVN$L, '[^0-9]', '') 
  END         ID_TRANSPORTADORA,

  t.T$DSCA    DS_TRANSPORTADORA,
  t.T$SEAK    DS_APELIDO,

  CASE WHEN regexp_replace(e.T$FOVN$L, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
  WHEN LENGTH(regexp_replace(e.T$FOVN$L, '[^0-9]', ''))<11
    THEN '00000000000000'
  ELSE regexp_replace(e.T$FOVN$L, '[^0-9]', '') 
  END         ID_GRUPO_TRANSPORTADORA

FROM  baandb.ttcmcs080201 t,
      baandb.ttccom100201 p,
      baandb.ttccom130201 e

WHERE t.t$suno!=' '
  AND p.T$BPID=t.T$SUNO
  AND e.T$CADR=p.T$CADR