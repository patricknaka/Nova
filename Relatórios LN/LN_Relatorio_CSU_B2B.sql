SELECT 
  
  CASE WHEN cisli940.t$fdty$l = 16 THEN         --Fatura operacao triangular
        znsls401_tri.t$pecl$c
  ELSE  znsls401.t$pecl$c END       NR_RESGATE,
  CASE WHEN cisli940.t$fdty$l = 16 THEN         --Fatura operacao triangular
        znsls401_tri.t$entr$c
  ELSE  znsls401.t$entr$c END       NR_ENTREGA,
  tccom130.t$nama                   NOME_DESTINATARIO,
  replace(replace(tccom130.t$fovn$l,'-'),'/')                 
                                    CPF_CNPJ_CLIENTE,
  trim(tccom130.t$namc) ||',' ||
  tccom130.t$hono                   ENDERECO,               
  tccom130.t$dist$l                 BAIRRO,
  tccom139.t$dsca                   CIDADE,
  tccom130.t$cste                   ESTADO,
  tccom130.t$ccty                   PAIS,
  tccom139.t$ibge$l                 COD_IBGE_MUN,
  tccom130.t$pstc                   CEP,
  tccom130.t$telp                   TELEFONE,
  cisli940.t$docn$l                 NR_NF,
  cisli940.t$seri$l                 SR_NF,
  cisli940.t$cnfe$l                 CHAVE_ACESSO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone 'America/Sao_Paulo') AS DATE)
                                    DT_EMISSAO_NF,
  cisli940.t$ccfo$l                 CFOP,
  cisli940.t$opor$l                 NATUREZA_OPERACAO,
  ICMS_NF.t$base$l                  BASE_CALCULO_ICMS_NF,
  ICMS_NF.t$amnt$l                  VALOR_ICMS_NF,
  cisli940.t$gamt$l                 VALOR_TOTAL_PRODUTOS,
  cisli940.t$fght$l                 VALOR_FRETE_NF,
  SLI941.DESCONTO                   DESCONTO_NF,
  CASE WHEN cisli940.t$fdty$l = 16 THEN         --Fatura operacao triangular
        znsls400_tri.t$cffb$c
  ELSE  znsls400.t$cffb$c END       FOB,
  PIS_NF.t$amnt$l                   VALOR_PIS_NF,
  COFINS_NF.t$amnt$l                VALOR_COFINS_NF,
  CSLL_NF.t$amnt$l                  VALOR_CSLL_NF,
  IPI_NF.t$amnt$l                   VALOR_IPI_NF,
  cisli940.t$amnt$l                 VALOR_TOTAL_NF,
  tcibd001.t$dscb$c                 NOME_PRODUTO,
  ORIGEM.DESCR                      PROCEDENCIA,
  tcibd001.t$item                   COD_PRODUTO,
  tcibd001.t$wght                   PESO_BRUTO,
  cisli941.t$dqua$l                 QUANTIDADE_ADQUIRIDA,
  cisli941.t$ldam$l                 DESCONTO_UNITARIO,
  cisli941.t$pric$l - cisli941.t$ldam$l       
                                    VALOR_UNIT_COM_DESCONTO,
  cisli941.t$fght$l                 FRETE_PRODUTO,
  SLI941.QTDE                       QTDE_FATURADA_NF,
  cisli941.t$pric$l                 VALOR_UNIT_SEM_DESCONTO,
  cisli941.t$gamt$l                 VALOR_TOTAL_MERCADORIA,
  CASE WHEN cisli940.t$fdty$l = 16 THEN         --Fatura operacao triangular
        znsls400_tri.t$vlfr$c
  ELSE  znsls400.t$vlfr$c END       VALOR_FRETE,
  cisli941.t$cuqs$l                 UNIDADE_MEDIDA,
  tcibd936.t$frat$l                 NCM_SH,
  tcibd001.t$cean                   EAN,
  CASE WHEN ICMS.t$amnt$l = 0.0 THEN
        0.0
  ELSE  ICMS.t$base$l END           BASE_CALC_ICMS,
  ICMS.t$rate$l                     ALIQUOTA_ICMS,
  ICMS.t$amnt$l                     VALOR_ICMS,
  IPI.t$base$l                      BASE_CALC_IPI,
  IPI.t$rate$l                      ALIQUOTA_IPI,
  IPI.t$amnt$l                      VALOR_IPI,
  PIS.t$base$l                      BASE_CALC_PIS,
  PIS.t$rate$l                      ALIQUOTA_PIS,
  PIS.t$amnt$l                      VALOR_PIS,
  COFINS.t$base$l                   BASE_CALC_COFINS,
  COFINS.t$rate$l                   ALIQUOTA_COFINS,
  COFINS.t$amnt$l                   VALOR_COFINS,
  case when cisli940.t$fdty$l = 16 then   --Fatura Op. Triangular
    cisli940_tri.t$docn$l
  else  NULL end                    NOTA_REMESSA,
  case when cisli940.t$fdty$l = 16 then   --Fatura Op. Triangular
    cisli940_tri.t$seri$l
  else NULL end                     SERIE_REMESSA,
  case when cisli940.t$fdty$l = 16 then   --Fatura Op. Triangular
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940_tri.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
         AT time zone 'America/Sao_Paulo') AS DATE)
  else NULL end                     EMISSAO_REMESSA,
  case when cisli940.t$fdty$l = 16 then   --Fatura Op. Triangular
    cisli940_tri.t$ccfo$l
  else  NULL end                    CFOP_REMESSA,
  case when cisli940.t$fdty$l = 16 then   --Fatura Op. Triangular
    cisli940_tri.t$opor$l
  else  NULL end                    NAT_OPER_REMESSA,
  cisli940.t$cnfe$l                 CHAVE_ACESSO,
  CASE WHEN cisli940.t$fdty$l = 16 THEN         --Fatura operacao triangular
        znint002_tri.t$desc$c
  ELSE  znint002.t$desc$c END       UNIDADE_NEGOCIO,
  CASE WHEN cisli940.t$fdty$l = 16 THEN         --Fatura operacao triangular
        znsls400_tri.t$idcp$c
  ELSE znsls400.t$idcp$c END        CAMPANHA_B2B,
  ICMS.t$pest$l                     CST,
  replace(replace(tccom130_emi.t$fovn$l,'-'),'/')             
                                    EMISSOR
   
FROM  baandb.tcisli941301 cisli941

INNER JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = cisli941.t$fire$l

LEFT JOIN (select a.t$fire$l,
                   a.t$line$l,
                   a.t$slso,
                   a.t$pono
            from   baandb.tcisli245301 a
            group by a.t$fire$l,
                     a.t$line$l,
                     a.t$slso,
                     a.t$pono ) cisli245
        ON cisli245.t$fire$l = cisli941.t$fire$l
       AND cisli245.t$line$l = cisli941.t$line$l
       
LEFT JOIN (select a.t$ncia$c,
                  a.t$uneg$c,
                  a.t$pecl$c,
                  a.t$sqpd$c,
                  a.t$entr$c,
                  a.t$sequ$c,
                  a.t$orno$c,
                  a.t$pono$c 
            from  baandb.tznsls004301 a ) znsls004
       ON znsls004.t$orno$c = cisli245.t$slso
      AND znsls004.t$pono$c = cisli245.t$pono

LEFT JOIN baandb.tznsls401301 znsls401
       ON znsls401.t$ncia$c = znsls004.t$ncia$c
      AND znsls401.t$uneg$c = znsls004.t$uneg$c
      AND znsls401.t$pecl$c = znsls004.t$pecl$c
      AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
      AND znsls401.t$entr$c = znsls004.t$entr$c
      AND znsls401.t$sequ$c = znsls004.t$sequ$c

LEFT JOIN baandb.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
       
LEFT JOIN baandb.tznint002301 znint002
       ON znint002.t$ncia$c = znsls004.t$ncia$c
      AND znint002.t$uneg$c = znsls004.t$uneg$c
      
LEFT JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid = cisli940.t$bpid$l
        
LEFT JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = cisli940.t$stoa$l

LEFT JOIN baandb.ttccom139301 tccom139
       ON tccom139.t$ccty = tccom130.t$ccty
      AND tccom139.t$cste = tccom130.t$cste
      AND tccom139.t$city = tccom130.t$ccit

LEFT JOIN ( select sum(a.t$tldm$l) DESCONTO,
                   sum(a.t$dqua$l) QTDE,
                       a.t$fire$l
             from  baandb.tcisli941301 a,
                   baandb.tznsls000301 b
             where b.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
               and   a.t$item$l != b.t$itmf$c      --ITEM FRETE
               and   a.t$item$l != b.t$itmd$c      --ITEM DESPESAS
               and   a.t$item$l != b.t$itjl$c      --ITEM JUROS
             group by a.t$fire$l ) SLI941
        ON SLI941.t$fire$l = cisli940.t$fire$l

LEFT JOIN (select a.t$fire$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli942301 a ) ICMS_NF
        ON ICMS_NF.t$fire$l = cisli941.t$fire$l
       AND ICMS_NF.t$brty$l = 1    --ICMS

LEFT JOIN (select a.t$fire$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli942301 a ) IPI_NF
        ON IPI_NF.t$fire$l = cisli941.t$fire$l
       AND IPI_NF.t$brty$l = 3    --IPI
       
LEFT JOIN (select a.t$fire$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli942301 a ) PIS_NF
        ON PIS_NF.t$fire$l = cisli941.t$fire$l
       AND PIS_NF.t$brty$l = 5    --PIS

LEFT JOIN (select a.t$fire$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli942301 a ) COFINS_NF
        ON COFINS_NF.t$fire$l = cisli941.t$fire$l
       AND COFINS_NF.t$brty$l = 6    --COFINS

LEFT JOIN (select a.t$fire$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli942301 a ) CSLL_NF
        ON CSLL_NF.t$fire$l = cisli941.t$fire$l
       AND CSLL_NF.t$brty$l = 13    --CSLL RETIDO
       
LEFT JOIN baandb.ttcibd001301 tcibd001
       ON tcibd001.t$item = cisli941.t$item$l

LEFT JOIN baandb.ttcibd936301 tcibd936
       ON tcibd936.t$ifgc$l = tcibd001.t$ifgc$l

LEFT JOIN ( select  a.t$item$l,
                    a.t$sour$l
            from    baandb.ttcibd937301 a
            group by a.t$item$l,
                     a.t$sour$l ) tcibd937
       ON tcibd937.t$item$l = cisli941.t$item$l

 LEFT JOIN ( select l.t$desc DESCR,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tc'
                and d.t$cdom = 'sour.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'tc'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) ORIGEM
        ON ORIGEM.t$cnst = tcibd937.t$sour$l
      
LEFT JOIN (select a.t$fire$l,
                   a.t$line$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l,
                   a.t$pest$l
            from baandb.tcisli943301 a ) ICMS
        ON ICMS.t$fire$l = cisli941.t$fire$l
       AND ICMS.t$line$l = cisli941.t$line$l
       AND ICMS.t$brty$l = 1    --ICMS

LEFT JOIN (select a.t$fire$l,
                   a.t$line$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli943301 a ) IPI
        ON IPI.t$fire$l = cisli941.t$fire$l
       AND IPI.t$line$l = cisli941.t$line$l
       AND IPI.t$brty$l = 3    --IPI

LEFT JOIN (select a.t$fire$l,
                   a.t$line$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli943301 a ) PIS
        ON PIS.t$fire$l = cisli941.t$fire$l
       AND PIS.t$line$l = cisli941.t$line$l
       AND PIS.t$brty$l = 5    --PIS
       
LEFT JOIN (select a.t$fire$l,
                   a.t$line$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli943301 a ) COFINS
        ON COFINS.t$fire$l = cisli941.t$fire$l
       AND COFINS.t$line$l = cisli941.t$line$l
       AND COFINS.t$brty$l = 6    --COFINS


LEFT JOIN baandb.tcisli941301 cisli941_tri        --busca da nota triangular de remessa
       ON cisli941_tri.t$fire$l = cisli941.t$refr$l
      AND cisli941_tri.t$line$l = cisli941.t$rfdl$l
      
LEFT JOIN baandb.tcisli940301 cisli940_tri        --busca da nota triangular de remessa
       ON cisli940_tri.t$fire$l = cisli941_tri.t$fire$l 
       
LEFT JOIN (select a.t$fire$l,
                   a.t$line$l,
                   a.t$slso,
                   a.t$pono
            from   baandb.tcisli245301 a
            group by a.t$fire$l,
                     a.t$line$l,
                     a.t$slso,
                     a.t$pono ) cisli245_tri
        ON cisli245_tri.t$fire$l = cisli941_tri.t$fire$l
       AND cisli245_tri.t$line$l = cisli941_tri.t$line$l
       
LEFT JOIN (select a.t$ncia$c,
                  a.t$uneg$c,
                  a.t$pecl$c,
                  a.t$sqpd$c,
                  a.t$entr$c,
                  a.t$sequ$c,
                  a.t$orno$c,
                  a.t$pono$c 
            from  baandb.tznsls004301 a ) znsls004_tri
       ON znsls004_tri.t$orno$c = cisli245_tri.t$slso
      AND znsls004_tri.t$pono$c = cisli245_tri.t$pono

LEFT JOIN baandb.tznsls401301 znsls401_tri
       ON znsls401_tri.t$ncia$c = znsls004_tri.t$ncia$c
      AND znsls401_tri.t$uneg$c = znsls004_tri.t$uneg$c
      AND znsls401_tri.t$pecl$c = znsls004_tri.t$pecl$c
      AND znsls401_tri.t$sqpd$c = znsls004_tri.t$sqpd$c
      AND znsls401_tri.t$entr$c = znsls004_tri.t$entr$c
      AND znsls401_tri.t$sequ$c = znsls004_tri.t$sequ$c
  
LEFT JOIN baandb.tznint002301 znint002_tri
       ON znint002_tri.t$ncia$c = znsls004_tri.t$ncia$c
      AND znint002_tri.t$uneg$c = znsls004_tri.t$uneg$c

LEFT JOIN baandb.tznsls400301 znsls400_tri
       ON znsls400_tri.t$ncia$c = znsls004_tri.t$ncia$c
      AND znsls400_tri.t$uneg$c = znsls004_tri.t$uneg$c
      AND znsls400_tri.t$pecl$c = znsls004_tri.t$pecl$c
      AND znsls400_tri.t$sqpd$c = znsls004_tri.t$sqpd$c
       
LEFT JOIN baandb.ttccom130301 tccom130_emi
       ON tccom130_emi.t$cadr = cisli940.t$sfra$l

LEFT JOIN baandb.tznsls000601 znsls000
       ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
                    
WHERE cisli940.t$stat$l IN (2,5,6,101)  --Cancelada, Impressa, Lançada e Estornada
   AND cisli941.t$item$l != znsls000.t$itmf$c      --ITEM FRETE
   AND cisli941.t$item$l != znsls000.t$itmd$c      --ITEM DESPESAS
   AND cisli941.t$item$l != znsls000.t$itjl$c      --ITEM JUROS
   AND cisli940.t$cnfe$l != ' '
   
ORDER BY cisli941.t$fire$l, cisli941.t$line$l
   
