select  
-- O campo CD_CIA foi incluido para diferenciar NIKE(601) E BUNZL(602)
--**********************************************************************************************************************************************************
	znint002.t$uneg$c CD_UNIDADE_NEGOCIO,
	CAST(602 AS INT) IN_SITE_CIA,
	znint002.t$desc$c NM_UNIDADE_NEGOCIO,
	CASE WHEN InStr(znint002.t$desc$c, 'B2B', 1, 1)>0 THEN 'B2B'
      WHEN InStr(znint002.t$desc$c, 'B2C', 1, 1)>0 THEN 'B2C'
	ELSE ' '
	END NM_TIPO_VENDA,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znint002.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO
FROM baandb.tznint002602 znint002