select DISTINCT 
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
  tcmcs940.t$ocfo$l CD_NATUREZA_OPERACAO,																		
  tcmcs940.t$dsca$l DS_NATUREZA_OPERACAO,																		
  CASE WHEN instr(tcmcs940.t$ofso$l,'-')=0 THEN tcmcs940.t$opor$l
  ELSE regexp_replace(substr(tcmcs940.t$ofso$l,instr(tcmcs940.t$ofso$l,'-')+1,3), '[^0-9]', '') 
  END SQ_NATUREZA_OPERACAO,								
  tcmcs964.t$desc$d DS_SEQUENCIA_NATUREZA_OPERACAO,																
  ' ' DS_OBJETIVO_NATUREZA_OPERACAO,
  CAST(13 AS INT) CD_CIA
FROM  baandb.ttcmcs940601 tcmcs940,
      baandb.ttcmcs964601 tcmcs964
WHERE 	tcmcs964.T$OPOR$D=tcmcs940.T$OPOR$L
order by 1