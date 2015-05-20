SELECT DISTINCT

    'NIKE.COM'                  FILIAL,                   --02
    ' '                         CODIGO_BARRA,             --03
    tdrec941.t$tamt$l           VALOR,                    --04
    tdrec941.t$qnty$l           QTDE_ITEM,                --05
    TO_CHAR(tdrec940.t$docn$l,'000000000')           
                                NF_NUMERO,                --06
    tdrec940.t$seri$l           SERIE_NF,                 --07
    tdrec941.t$line$l           ITEM_IMPRESSAO,           --08
    '1'                         SUB_ITEM_TAMANHO,         --09
    tdrec941.t$dsca$l           DESCRICAO_ITEM,           --10
    ltrim(rtrim(nvl(tcibd004.t$item,tdrec941.t$item$l)))             
				CODIGO_ITEM,              --11
    tcibd001.t$cuni             UNIDADE,                  --12
    tdrec941.t$pric$l           PRECO_UNITARIO,           --13
    0                           PORCENTAGEM_ITEM_RATEIO,  --14
    tdrec941.t$addc$l           DESCONTO_ITEM,            --15
    tcibd001.t$wght             PESO,                     --16
    tttxt010r.t$text            OBS_ITEM,                 --17
    ORIGEM.DESCR                TRIBUT_ORIGEM,            --18
    CASE WHEN REC942.BASE_ICMS = tdrec941.t$tamt$l THEN
      '00'
      WHEN REC942.BASE_ICMS < tdrec941.t$tamt$l THEN
        '20'
      WHEN REC942.VL_ICMS_ST > 0 THEN
          '10'
      ELSE '90'   END           TRIBUT_ICMS,              --19
    tdrec941.t$opfc$l           CODIGO_FISCAL_OPERACAO,   --20
    tdrec941.t$frat$l           CLASSIF_FISCAL,           --21
    ' '                         INDICADOR_CFOP,           --22    VERIFICAR
    ' '                         ID_EXCECAO_IMPOSTO,       --23
    ' '                         REFERENCIA,               --24
    ' '                         REFERENCIA_ITEM,          --25
    ' '                         REFERENCIA_PEDIDO,        --26
    ' '                         CONTA_CONTABIL,           --27
    '0'                         NAO_SOMA_VALOR,           --28
    tdrec941.t$gexp$l           VALOR_ENCARGOS,           --29
    0                           VALOR_DESCONTOS,          --30
    tdrec941.t$fght$l           VALOR_RATEIO_FRETE,       --31
    tdrec941.t$insr$l           VALOR_RATEIO_SEGURO       --32
    
FROM  baandb.ttdrec941201 tdrec941

  INNER JOIN baandb.ttdrec940201  tdrec940
          ON tdrec940.t$fire$l = tdrec941.t$fire$l
          
  INNER JOIN baandb.ttcibd001201  tcibd001
          ON tcibd001.t$item = tdrec941.t$item$l
          
  LEFT JOIN baandb.ttcibd004201   tcibd004
         ON tcibd004.t$citt = '000'
        AND tcibd004.t$bpid = ' '
        AND tcibd004.t$item = tdrec941.t$item$l
        
  LEFT JOIN baandb.ttttxt010201 tttxt010r
       ON tttxt010r.t$ctxt = tcibd001.t$txtf$c
      AND tttxt010r.t$clan = 'p'
	    AND tttxt010r.t$seqe = 1
      
   LEFT JOIN ( SELECT l.t$desc DESCR,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tc'
                AND d.t$cdom = 'sour.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tc'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) ORIGEM
        ON ORIGEM.t$cnst = tdrec941.t$sour$l 
        
        LEFT JOIN ( select  a.t$base$l  BASE_ICMS,
                            a.t$fire$l,
                            a.t$line$l,
                            a.t$brty$l
                    from baandb.ttdrec942201 a ) REC942
              ON REC942.t$fire$l = tdrec941.t$fire$l
             AND REC942.t$line$l = tdrec941.t$line$l
             AND REC942.t$brty$l = 1  --ICMS
             
        LEFT JOIN ( select  a.t$base$l  VL_ICMS_ST,
                            a.t$fire$l,
                            a.t$line$l,
                            a.t$brty$l
                    from baandb.ttdrec942201 a ) REC942
              ON REC942.t$fire$l = tdrec941.t$fire$l
             AND REC942.t$line$l = tdrec941.t$line$l
             AND REC942.t$brty$l = 2  --ICMS_ST
                
WHERE tdrec940.t$stat$l IN (4,5,6)
    
UNION

SELECT DISTINCT

    'NIKE.COM'                  FILIAL,                   --02
    ' '                         CODIGO_BARRA,             --03
    cisli941.t$gamt$l           VALOR,                    --04
    cisli941.t$dqua$l           QTDE_ITEM,                --05
    TO_CHAR(cisli940.t$docn$l,'000000000')           
                                NF_NUMERO,                --06
    cisli940.t$seri$l           SERIE_NF,                 --07
    cisli941.t$line$l           ITEM_IMPRESSAO,           --08
    '1'                         SUB_ITEM_TAMANHO,         --09
    cisli941.t$desc$l           DESCRICAO_ITEM,           --10
    ltrim(rtrim(NVL(tcibd004.t$item,tcibd001.t$item)))             
                                CODIGO_ITEM,              --11
    tcibd001.t$cuni             UNIDADE,                  --12
    cisli941.t$pric$l           PRECO_UNITARIO,           --13
    0                           PORCENTAGEM_ITEM_RATEIO,  --14
    cisli941.t$ldam$l           DESCONTO_ITEM,            --15
    tcibd001.t$wght             PESO,                     --16
    tttxt010r.t$text            OBS_ITEM,                 --17
    ORIGEM.DESCR                TRIBUT_ORIGEM,            --18
    CASE WHEN SLI943.BASE_ICMS = cisli941.t$amnt$l THEN
      '00'
      WHEN SLI943.BASE_ICMS < cisli941.t$amnt$l THEN
        '20'
      WHEN SLI943.VL_ICMS_ST > 0 THEN
          '10'
      ELSE '90'   END           TRIBUT_ICMS,              --19
    cisli941.t$ccfo$l           CODIGO_FISCAL_OPERACAO,   --20
    cisli941.t$frat$l           CLASSIF_FISCAL,           --21
    ' '                         INDICADOR_CFOP,           --22    VERIFICAR
    ' '                         ID_EXCECAO_IMPOSTO,       --23
    ' '                         REFERENCIA,               --24
    ' '                         REFERENCIA_ITEM,          --25
    ' '                         REFERENCIA_PEDIDO,        --26
    ' '                         CONTA_CONTABIL,           --27
    '0'                         NAO_SOMA_VALOR,           --28
    cisli941.t$gexp$l           VALOR_ENCARGOS,           --29
    0                           VALOR_DESCONTOS,          --30
    cisli941.t$fght$l           VALOR_RATEIO_FRETE,       --31
    cisli941.t$insr$l           VALOR_RATEIO_SEGURO       --32
    
FROM  baandb.tcisli941201 cisli941

  INNER JOIN baandb.tcisli940201 cisli940
          ON cisli940.t$fire$l = cisli941.t$fire$l
          
  INNER JOIN baandb.ttcibd001201  tcibd001
          ON tcibd001.t$item = cisli941.t$item$l
          
  LEFT JOIN baandb.ttcibd004201   tcibd004
         ON tcibd004.t$citt = '000'
        AND tcibd004.t$bpid = ' '
        AND tcibd004.t$item = cisli941.t$item$l
        
  LEFT JOIN baandb.ttttxt010201 tttxt010r
       ON tttxt010r.t$ctxt = tcibd001.t$txtf$c
      AND tttxt010r.t$clan = 'p'
	    AND tttxt010r.t$seqe = 1
      
   LEFT JOIN ( SELECT l.t$desc DESCR,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tc'
                AND d.t$cdom = 'sour.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tc'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) ORIGEM
        ON ORIGEM.t$cnst = cisli941.t$sour$l 
        
        LEFT JOIN ( select  a.t$base$l  BASE_ICMS,
                            a.t$fire$l,
                            a.t$line$l,
                            a.t$brty$l
                    from baandb.tcisli943201 a ) SLI943
              ON SLI943.t$fire$l = cisli941.t$fire$l
             AND SLI943.t$line$l = cisli941.t$line$l
             AND SLI943.t$brty$l = 1  --ICMS
             
        LEFT JOIN ( select  a.t$base$l  VL_ICMS_ST,
                            a.t$fire$l,
                            a.t$line$l,
                            a.t$brty$l
                    from baandb.tcisli943201 a ) SLI943
              ON SLI943.t$fire$l = cisli941.t$fire$l
             AND SLI943.t$line$l = cisli941.t$line$l
             AND SLI943.t$brty$l = 2  --ICMS_ST
                
 WHERE cisli940.t$stat$l IN (5,6,101)
