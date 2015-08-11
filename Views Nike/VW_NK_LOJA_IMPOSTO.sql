﻿SELECT  DISTINCT

  'NIKE.COM'                    FILIAL,                   --02
  TO_CHAR(tdrec940.t$docn$l,'000000000')           
                                NF_NUMERO,                --03
  tdrec940.t$seri$l             SERI_NF,                  --04
  to_char(tdrec942.t$line$l)    ITEM_IMPRESSAO,           --05
  '1'                           SUB_ITEM_TAMANHO,         --06
  to_char(tdrec942.t$brty$l)    ID_IMPOSTO,               --07      --OBS: CÓDIGOS DIFERENTES DA NIKE
  tdrec942.t$rate$l             TAXA_IMPOSTO,             --08
  
  CASE
	WHEN tdrec942.t$brty$l=1 THEN 3
	WHEN tdrec942.t$brty$l=3 THEN 1
	WHEN tdrec942.t$brty$l=5 THEN 3
	WHEN tdrec942.t$brty$l=6 THEN 3
	WHEN tdrec942.t$brty$l=2 THEN 1
	ELSE 0 END					INCIDENCIA,               --09
  tdrec942.t$amnt$l             VALOR_IMPOSTO,            --10
  CASE WHEN tdrec942.t$amnt$l = 0 THEN
    0
  ELSE tdrec942.t$base$l END    BASE_IMPOSTO,             --11
  ' '                           AGREGA_APOS_ENCARGO,      --12
  ' '                           AGREGA_APOS_DESCONTO,     --13
  ' '                           CTB_LANCAMENTO_FINANCEIRO,--14
  ' '                           CTB_ITEM_FINANCEIRO,      --15
  ' '                           EMPRESA,                  --16
  'E'                           TP_MOVTO,                 --17 Criado para separar na tabela as entradas e saídas
  tdrec940.t$fire$l             REF_FISCAL,               --18
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) 				DT_ULT_ALTERACAO  --19
  
FROM  baandb.ttdrec942601   tdrec942

  LEFT JOIN baandb.ttdrec940601 tdrec940
         ON tdrec940.t$fire$l = tdrec942.t$fire$l

WHERE tdrec940.t$stat$l IN (4,5,6)
AND   tdrec940.t$cnfe$l != ' '

UNION

SELECT  DISTINCT

  'NIKE.COM'                    FILIAL,                   --02
  TO_CHAR(cisli940.t$docn$l,'000000000')           
                                NF_NUMERO,                --03
  cisli940.t$seri$l             SERI_NF,                  --04
  to_char(cisli943.t$line$l)    ITEM_IMPRESSAO,           --05
  '1'                           SUB_ITEM_TAMANHO,         --06
  to_char(cisli943.t$brty$l)    ID_IMPOSTO,               --07      --OBS: CÓDIGOS DIFERENTES DA NIKE
  cisli943.t$rate$l             TAXA_IMPOSTO,             --08
  CASE
	WHEN cisli943.t$brty$l=1 THEN 3
	WHEN cisli943.t$brty$l=3 THEN 1
	WHEN cisli943.t$brty$l=5 THEN 3
	WHEN cisli943.t$brty$l=6 THEN 3
	WHEN cisli943.t$brty$l=2 THEN 1
	ELSE 0 END                  INCIDENCIA,               --09
  cisli943.t$amnt$l             VALOR_IMPOSTO,            --10
  CASE WHEN cisli943.t$amnt$l = 0 THEN
    0
  ELSE cisli943.t$base$l END    BASE_IMPOSTO,             --11
  ' '                           AGREGA_APOS_ENCARGO,      --12
  ' '                           AGREGA_APOS_DESCONTO,     --13
  ' '                           CTB_LANCAMENTO_FINANCEIRO,--14
  ' '                           CTB_ITEM_FINANCEIRO,      --15
  ' '                           EMPRESA,                  --16
  'S'                           TP_MOVTO,                 --17 Criado para separar na tabela as entradas e saídas
  cisli940.t$fire$l             REF_FISCAL,               --18
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE) 				DT_ULT_ALTERACAO  --19

FROM  baandb.tcisli943601   cisli943

  LEFT JOIN baandb.tcisli940601 cisli940
         ON cisli940.t$fire$l = cisli943.t$fire$l
         
    INNER JOIN ( select  MIN(cisli245.t$slso)  OV,
                        cisli245.t$fire$l
                from    baandb.tcisli245601 cisli245
                group by cisli245.t$fire$l )  SLI245
           ON SLI245.t$fire$l = cisli943.t$fire$l
           
 WHERE cisli940.t$stat$l IN (5,6,101)
 AND   cisli940.t$cnfe$l != ' '
