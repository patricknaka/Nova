SELECT  DISTINCT

  'NIKE.COM'                    FILIAL,                   --02
  TO_CHAR(tdrec940.t$docn$l,'000000000')           
                                NF_NUMERO,                --03
  tdrec940.t$seri$l             SERI_NF,                  --04
  tdrec942.t$line$l             ITEM_IMPRESSAO,           --05
  '1'                           SUB_ITEM_TAMANHO,         --06
  tdrec942.t$brty$l             ID_IMPOSTO,               --07      --OBS: CÓDIGOS DIFERENTES DA NIKE
  tdrec942.t$rate$l             TAXA_IMPOSTO,             --08
  '??????'                      INCIDENCIA,               --09
  tdrec942.t$amnt$l             VALOR_IMPOSTO,            --10
  CASE WHEN tdrec942.t$amnt$l = 0 THEN
    0
  ELSE tdrec942.t$base$l END    BASE_IMPOSTO,             --11
  ' '                           AGREGA_APOS_ENCARGO,      --12
  ' '                           AGREGA_APOS_DESCONTO,     --13
  ' '                           CTB_LANCAMENTO_FINANCEIRO,--14
  ' '                           CTB_ITEM_FINANCEIRO,      --15
  ' '                           EMPRESA
  
FROM  baandb.ttdrec942301   tdrec942

  LEFT JOIN baandb.ttdrec940301 tdrec940
         ON tdrec940.t$fire$l = tdrec942.t$fire$l

WHERE tdrec940.t$stat$l IN (4,5,6)

UNION

SELECT  DISTINCT

  'NIKE.COM'                    FILIAL,                   --02
  TO_CHAR(cisli940.t$docn$l,'000000000')           
                                NF_NUMERO,                --03
  cisli940.t$seri$l             SERI_NF,                  --04
  cisli943.t$line$l             ITEM_IMPRESSAO,           --05
  '1'                           SUB_ITEM_TAMANHO,         --06
  cisli943.t$brty$l             ID_IMPOSTO,               --07      --OBS: CÓDIGOS DIFERENTES DA NIKE
  cisli943.t$rate$l             TAXA_IMPOSTO,             --08
  '??????'                      INCIDENCIA,               --09
  cisli943.t$amnt$l             VALOR_IMPOSTO,            --10
  CASE WHEN cisli943.t$amnt$l = 0 THEN
    0
  ELSE cisli943.t$base$l END    BASE_IMPOSTO,             --11
  ' '                           AGREGA_APOS_ENCARGO,      --12
  ' '                           AGREGA_APOS_DESCONTO,     --13
  ' '                           CTB_LANCAMENTO_FINANCEIRO,--14
  ' '                           CTB_ITEM_FINANCEIRO,      --15
  ' '                           EMPRESA
  
FROM  baandb.tcisli943301   cisli943

  LEFT JOIN baandb.tcisli940301 cisli940
         ON cisli940.t$fire$l = cisli943.t$fire$l
         
 WHERE cisli940.t$stat$l IN (5,6,101)