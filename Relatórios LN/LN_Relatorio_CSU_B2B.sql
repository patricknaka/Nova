SELECT 
  znsls401.t$pecl$c                 NR_RESGATE,
  znsls401.t$entr$c                 NR_ENTREGA,
  znsls401.t$nome$c                 NOME_DESTINATARIO,
  replace(replace(znsls401.t$fovn$c,'-'),'/')                 
                                    CPF_CNPJ_CLIENTE,
  znsls401.t$loge$c || ',' || ' ' ||               
  znsls401.t$nume$c || ',' || ' ' ||        
  znsls401.t$come$c                 ENDERECO,
  znsls401.t$baie$c                 BAIRRO,
  znsls401.t$cide$c                 CIDADE,
  znsls401.t$ufen$c                 ESTADO,
  znsls401.t$paie$c                 PAIS,
  tccom139.t$ibge$l                 COD_IBGE_MUN,
  znsls401.t$cepe$c                 CEP,
  znsls401.t$tele$c                 TELEFONE,
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
  znsls400.t$cffb$c                 FOB,
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
  cisli940.t$gamt$l                 VALOR_TOTAL_MERCADORIA,
  znsls400.t$vlfr$c                 VALOR_FRETE,
  cisli941.t$cuqs$l                 UNIDADE_MEDIDA,
  tcibd936.t$frat$l                 NCM_SH,
  tcibd001.t$cean                   EAN,
  ICMS.t$base$l                     BASE_CALC_ICMS,
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
  znint002.t$desc$c                 UNIDADE_NEGOCIO,
  znsls400.t$idcp$c                 CAMPANHA_B2B,
  ICMS.t$pest$l                     CST,
  replace(replace(tccom130_emi.t$fovn$l,'-'),'/')             
                                    EMISSOR
  
    
FROM  baandb.tcisli941201 cisli941

INNER JOIN baandb.tcisli940201 cisli940
        ON cisli940.t$fire$l = cisli941.t$fire$l

INNER JOIN (select a.t$fire$l,
                   a.t$line$l,
                   a.t$slso,
                   a.t$pono
            from   baandb.tcisli245201 a
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
            from  baandb.tznsls004201 a ) znsls004
       ON znsls004.t$orno$c = cisli245.t$slso
      AND znsls004.t$pono$c = cisli245.t$pono

LEFT JOIN baandb.tznsls401201 znsls401
       ON znsls401.t$ncia$c = znsls004.t$ncia$c
      AND znsls401.t$uneg$c = znsls004.t$uneg$c
      AND znsls401.t$pecl$c = znsls004.t$pecl$c
      AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
      AND znsls401.t$entr$c = znsls004.t$entr$c
      AND znsls401.t$sequ$c = znsls004.t$sequ$c

INNER JOIN baandb.tznsls400201 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
       
INNER JOIN baandb.ttccom100201 tccom100
        ON tccom100.t$bpid = znsls400.t$ofbp$c
        
INNER JOIN baandb.ttccom130201 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr

LEFT JOIN baandb.ttccom139201 tccom139
       ON tccom139.t$ccty = znsls401.t$paie$c
      AND tccom139.t$cste = znsls401.t$ufen$c

LEFT JOIN ( select sum(a.t$tldm$l) DESCONTO,
                   sum(a.t$dqua$l) QTDE,
                       a.t$fire$l
             from  baandb.tcisli941201 a,
                   baandb.tznsls000201 b
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
            from baandb.tcisli942201 a ) ICMS_NF
        ON ICMS_NF.t$fire$l = cisli941.t$fire$l
       AND ICMS_NF.t$brty$l = 1    --ICMS

LEFT JOIN (select a.t$fire$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli942201 a ) IPI_NF
        ON IPI_NF.t$fire$l = cisli941.t$fire$l
       AND IPI_NF.t$brty$l = 2    --IPI
       
LEFT JOIN (select a.t$fire$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli942201 a ) PIS_NF
        ON PIS_NF.t$fire$l = cisli941.t$fire$l
       AND PIS_NF.t$brty$l = 5    --PIS

LEFT JOIN (select a.t$fire$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli942201 a ) COFINS_NF
        ON COFINS_NF.t$fire$l = cisli941.t$fire$l
       AND COFINS_NF.t$brty$l = 6    --COFINS

LEFT JOIN (select a.t$fire$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli942201 a ) CSLL_NF
        ON CSLL_NF.t$fire$l = cisli941.t$fire$l
       AND CSLL_NF.t$brty$l = 13    --CSLL RETIDO
       
LEFT JOIN baandb.ttcibd001201 tcibd001
       ON tcibd001.t$item = cisli941.t$item$l

LEFT JOIN baandb.ttcibd936201 tcibd936
       ON tcibd936.t$ifgc$l = tcibd001.t$ifgc$l

LEFT JOIN baandb.ttcibd937201 tcibd937
       ON tcibd937.t$item$l = cisli941.t$item$l
      AND tcibd937.t$cpid$l = cisli940.t$sfra$l

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
            from baandb.tcisli943201 a ) ICMS
        ON ICMS.t$fire$l = cisli941.t$fire$l
       AND ICMS.t$line$l = cisli941.t$line$l
       AND ICMS.t$brty$l = 1    --ICMS

LEFT JOIN (select a.t$fire$l,
                   a.t$line$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli943201 a ) IPI
        ON IPI.t$fire$l = cisli941.t$fire$l
       AND IPI.t$line$l = cisli941.t$line$l
       AND IPI.t$brty$l = 3    --IPI

LEFT JOIN (select a.t$fire$l,
                   a.t$line$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli943201 a ) PIS
        ON PIS.t$fire$l = cisli941.t$fire$l
       AND PIS.t$line$l = cisli941.t$line$l
       AND PIS.t$brty$l = 5    --PIS
       
LEFT JOIN (select a.t$fire$l,
                   a.t$line$l,
                   a.t$brty$l,
                   a.t$base$l,
                   a.t$rate$l,
                   a.t$amnt$l
            from baandb.tcisli943201 a ) COFINS
        ON COFINS.t$fire$l = cisli941.t$fire$l
       AND COFINS.t$line$l = cisli941.t$line$l
       AND COFINS.t$brty$l = 6    --COFINS
     
LEFT JOIN baandb.tcisli940201 cisli940_tri
       ON cisli940_tri.t$fire$l = cisli941.t$fire$l
  
LEFT JOIN baandb.tznint002201 znint002
       ON znint002.t$ncia$c = znsls004.t$ncia$c
      AND znint002.t$uneg$c = znsls004.t$uneg$c
      
LEFT JOIN baandb.ttccom130201 tccom130_emi
       ON tccom130_emi.t$cadr = cisli940.t$sfra$l

LEFT JOIN baandb.tznsls000601 znsls000
       ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
                 
WHERE cisli940.t$stat$l IN (2,5,6,101)  --Cancelada, Impressa, Lançada e Estornada
   AND cisli941.t$item$l != znsls000.t$itmf$c      --ITEM FRETE
   AND cisli941.t$item$l != znsls000.t$itmd$c      --ITEM DESPESAS
   AND cisli941.t$item$l != znsls000.t$itjl$c      --ITEM JUROS
   AND cisli940.t$cnfe$l != ' '
