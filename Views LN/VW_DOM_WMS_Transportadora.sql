SELECT
          CASE WHEN regexp_replace(e.T$FOVN$L, '[^0-9]', '') IS NULL
          THEN '00000000000000' 
          WHEN LENGTH(regexp_replace(e.T$FOVN$L, '[^0-9]', ''))<11
          THEN '00000000000000'
          ELSE regexp_replace(e.T$FOVN$L, '[^0-9]', '') END NR_CNPJ_TRANSPORTADORA,
          t.T$DSCA NM_TRANSPORTADORA,
          t.T$SEAK NM_APELIDO_TRANSPORTADORA,
          t.T$CFRW CD_TRANSPORTADORA
FROM
          ttcmcs080201 t,
          ttccom100201 p,
          ttccom130201 e
WHERE     t.t$suno!=' '
AND       p.T$BPID=t.T$SUNO
AND       e.T$CADR=p.T$CADR