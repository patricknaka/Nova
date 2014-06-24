SELECT
          t.T$DSCA NOME_TRANSPORTADORA,
          CASE WHEN regexp_replace(e.T$FOVN$L, '[^0-9]', '') IS NULL
          THEN '00000000000000' 
          WHEN LENGTH(regexp_replace(e.T$FOVN$L, '[^0-9]', ''))<11
          THEN '00000000000000'
          ELSE regexp_replace(e.T$FOVN$L, '[^0-9]', '') END CD_TRANSPORTADORA,
          t.T$SEAK APELIDO_TRANSPORTADORA,
          t.T$CFRW CD_TRANSPORTADORA_WMS
FROM
          ttcmcs080201 t,
          ttccom100201 p,
          ttccom130201 e
WHERE     t.t$suno!=' '
AND       p.T$BPID=t.T$SUNO
AND       e.T$CADR=p.T$CADR