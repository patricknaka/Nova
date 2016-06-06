---Financeiro CAR
SELECT Q1.* FROM
( --ref fiscal
SELECT
  DISTINCT
    znint002.t$wstp$c           TIPO_VENDA,
    tfacr200r.t$itbp            PARCEIRO_NEGOCIOS,
    tccom100r.t$nama            NOME_PARCEIRO,
    tcemm030.t$euca             FILIAL,
    znsls400b.t$idco$c          CONTRATO,
    znsls400b.t$idcp$c          CAMPANHA,
    tccom130r.t$fovn$l          CNPJ,
    tccom938.t$desa$l           RAZAO_SOCIAL,
    tfacr200r.t$docn$l          NOTA_TITULO,
    tfacr200r.t$seri$l          SERIE,
    tfacr200r.t$docd            DTA_EMISSAO,
    tfacr200r.t$dued            VENCIMENTO_TITULO,
    tfacr200r.t$ttyp            DOCTO_TRANSACAO,
    tfacr200r.t$ninv            TITULO_CAR,
    tfacr200r.t$amnt            VL_TITULO_CAR,
    ZNSLS004_ORG.t$pecl$c       ID_PED_VENDA,
    CISLI940_ORG.T$CNFE$L       CHAVE_ACESSO,

    NVL(DEV.DOCTO_TRANSACAO_DEV ||
    DEV.TITULO_DEV,' ')         TITULO_DEV,
    NVL(DEV.VL_TITULO_DEV,0)    VL_TITULO_DEV,
   
    tfacr200r.t$balc            SALDO, 
    TCCOM100r.T$BPID            PARCEIRO
    
FROM      BAANDB.ttfacr200301 tfacr200r

LEFT JOIN BAANDB.TCISLI940301 CISLI940_ORG
       ON CISLI940_ORG.T$SFCP$L = tfacr200r.t$loco$l
      AND CISLI940_ORG.T$ITYP$L = tfacr200r.t$ttyp
      AND CISLI940_ORG.T$IDOC$L = tfacr200r.t$ninv
      AND CISLI940_ORG.T$DOCN$L = tfacr200r.t$docn$l
      AND CISLI940_ORG.T$SERI$L = tfacr200r.t$seri$l

LEFT JOIN BAANDB.TCISLI941301 CISLI941_ORG
       ON CISLI941_ORG.T$FIRE$L = CISLI940_ORG.T$FIRE$L
            
LEFT JOIN BAANDB.TCISLI245301 CISLI245_ORG
       ON CISLI245_ORG.T$FIRE$L = CISLI941_org.T$FIRE$L
      AND CISLI245_ORG.T$LINE$L = CISLI941_org.T$LINE$L
            
LEFT JOIN BAANDB.TZNSLS004301 ZNSLS004_ORG
       ON ZNSLS004_ORG.T$ORNO$C = CISLI245_ORG.T$SLSO
      AND ZNSLS004_ORG.T$PONO$C = CISLI245_ORG.T$PONO

LEFT JOIN baandb.tznsls400301 znsls400b
       ON znsls400b.t$ncia$c = ZNSLS004_ORG.T$NCIA$C
      AND znsls400b.t$uneg$c = ZNSLS004_ORG.T$UNEG$C
      AND znsls400b.t$pecl$c = ZNSLS004_ORG.T$PECL$C
      AND znsls400b.t$sqpd$c = ZNSLS004_ORG.T$SQPD$C

LEFT JOIN BAANDB.TZNSLS402301 ZNSLS402_ORG  
       ON ZNSLS402_ORG.T$NCIA$C = ZNSLS004_ORG.T$NCIA$C
      AND ZNSLS402_ORG.T$UNEG$C = ZNSLS004_ORG.T$UNEG$C
      AND ZNSLS402_ORG.T$PECL$C = ZNSLS004_ORG.T$PECL$C
      AND ZNSLS402_ORG.T$SQPD$C = ZNSLS004_ORG.T$SQPD$C

LEFT JOIN BAANDB.TTCCOM100301 TCCOM100r
       ON TCCOM100r.T$BPID = tfacr200r.t$itbp

LEFT JOIN baandb.ttccom130301 tccom130r
       ON tccom130r.t$cadr = TCCOM100r.t$CADR

LEFT JOIN baandb.ttccom938301 tccom938
       ON tccom938.t$ftyp$l = tccom130r.t$ftyp$l
      AND tccom938.t$fovn$l = tccom130r.t$fovn$l

LEFT JOIN (SELECT 
              tfacr200d.t$ttyp            DOCTO_TRANSACAO_DEV,
              tfacr200d.t$ninv            TITULO_DEV,
              tfacr200d.t$docn$l || 
              tfacr200d.t$seri$l          DOCTO_DEV,
              CISLI940_DEV.t$fire$l       REF_FISCAL_DEV,
              tfacr200d.t$amnt            VL_TITULO_DEV,
              CISLI941_DEV.T$REFR$L       REF_FISCAL_RELATIVA,
              CISLI940_FAT.T$ityp$l       TRANSACAO_FAT,
              CISLI940_FAT.T$idoc$l       DOCUMENTO_FAT
          
          from BAANDB.ttfacr200301 tfacr200d
          
          LEFT JOIN BAANDB.TCISLI940301 CISLI940_DEV
                on CISLI940_DEV.T$DOCN$L = tfacr200d.t$docn$l
                AND CISLI940_DEV.T$SERI$L = tfacr200d.t$seri$l
          
          LEFT JOIN BAANDB.TCISLI941301 CISLI941_DEV
                 ON CISLI941_DEV.T$FIRE$L = CISLI940_DEV.T$FIRE$L
                 
          LEFT JOIN BAANDB.TCISLI940301 CISLI940_FAT
                on CISLI940_FAT.T$FIRE$L = CISLI941_DEV.t$REFR$l
          
          where tfacr200d.t$ttyp = 'DEV') DEV
          
    ON DEV.TRANSACAO_FAT = tfacr200r.t$ttyp
   AND DEV.DOCUMENTO_FAT = tfacr200r.t$ninv
   
LEFT JOIN BAANDB.TZNINT002301 ZNINT002
       ON ZNINT002.T$NCIA$C = znsls400b.T$NCIA$C
      AND ZNINT002.T$UNEG$C = znsls400b.T$UNEG$C

LEFT JOIN baandb.ttcemm124301 tcemm124
       ON tcemm124.t$cwoc = cisli940_ORG.t$cofc$l

LEFT JOIN baandb.ttcemm030301 tcemm030
       ON tcemm030.t$eunt = tcemm124.t$grid

WHERE tfacr200r.t$lino = 0
AND tfacr200r.t$trec <> 4
AND tcemm124.t$dtyp = 1
--ativar a restrição abaixo no ambiente de produção
--em homologação existe muita sujeira que impede esse filtro
AND znint002.t$wstp$c in ('B2B','B2C') 

UNION ALL

--ref fiscal relativa
SELECT
  DISTINCT
    znint002.t$wstp$c           TIPO_VENDA,
    tfacr200r.t$itbp            PARCEIRO_NEGOCIOS,
    tccom100r.t$nama            NOME_PARCEIRO,
    tcemm030.t$euca             FILIAL,
    znsls400b.t$idco$c          CONTRATO,
    znsls400b.t$idcp$c          CAMPANHA,
    tccom130r.t$fovn$l          CNPJ,
    tccom938.t$desa$l           RAZAO_SOCIAL,
    tfacr200r.t$docn$l          NOTA_TITULO,
    tfacr200r.t$seri$l          SERIE,
    tfacr200r.t$docd            DTA_EMISSAO,
    tfacr200r.t$dued            VENCIMENTO_TITULO,
    tfacr200r.t$ttyp            DOCTO_TRANSACAO,
    tfacr200r.t$ninv            TITULO_CAR,
    tfacr200r.t$amnt            VL_TITULO_CAR,
    ZNSLS004_ORG.t$pecl$c       ID_PED_VENDA,
    CISLI940_ORG.T$CNFE$L       CHAVE_ACESSO,

    NVL(DEV.DOCTO_TRANSACAO_DEV ||
    DEV.TITULO_DEV,' ')         TITULO_DEV,
    NVL(DEV.VL_TITULO_DEV,0)    VL_TITULO_DEV,
   
    tfacr200r.t$balc            SALDO, 
    TCCOM100r.T$BPID            PARCEIRO
    
FROM      BAANDB.ttfacr200301 tfacr200r

LEFT JOIN BAANDB.TCISLI940301 CISLI940_ORG
       ON CISLI940_ORG.T$SFCP$L = tfacr200r.t$loco$l
      AND CISLI940_ORG.T$ITYP$L = tfacr200r.t$ttyp
      AND CISLI940_ORG.T$IDOC$L = tfacr200r.t$ninv
      AND CISLI940_ORG.T$DOCN$L = tfacr200r.t$docn$l
      AND CISLI940_ORG.T$SERI$L = tfacr200r.t$seri$l

LEFT JOIN BAANDB.TCISLI941301 CISLI941_ORG
       ON CISLI941_ORG.T$FIRE$L = CISLI940_ORG.T$FIRE$L
            
LEFT JOIN BAANDB.TCISLI941301 CISLI941_REM                      -- REMESSA OP TRIANGULAR
       ON CISLI941_REM.T$FIRE$L = CISLI941_ORG.T$REFR$L
      AND CISLI941_REM.T$LINE$L = CISLI941_ORG.T$RFDL$L
                        
LEFT JOIN BAANDB.TCISLI245301 CISLI245_ORG
       ON CISLI245_ORG.T$FIRE$L = CISLI941_REM.T$FIRE$L
      AND CISLI245_ORG.T$LINE$L = CISLI941_REM.T$LINE$L
            
LEFT JOIN BAANDB.TZNSLS004301 ZNSLS004_ORG
       ON ZNSLS004_ORG.T$ORNO$C = CISLI245_ORG.T$SLSO
      AND ZNSLS004_ORG.T$PONO$C = CISLI245_ORG.T$PONO

LEFT JOIN baandb.tznsls400301 znsls400b
       ON znsls400b.t$ncia$c = ZNSLS004_ORG.T$NCIA$C
      AND znsls400b.t$uneg$c = ZNSLS004_ORG.T$UNEG$C
      AND znsls400b.t$pecl$c = ZNSLS004_ORG.T$PECL$C
      AND znsls400b.t$sqpd$c = ZNSLS004_ORG.T$SQPD$C

LEFT JOIN BAANDB.TZNSLS402301 ZNSLS402_ORG  
       ON ZNSLS402_ORG.T$NCIA$C = ZNSLS004_ORG.T$NCIA$C
      AND ZNSLS402_ORG.T$UNEG$C = ZNSLS004_ORG.T$UNEG$C
      AND ZNSLS402_ORG.T$PECL$C = ZNSLS004_ORG.T$PECL$C
      AND ZNSLS402_ORG.T$SQPD$C = ZNSLS004_ORG.T$SQPD$C

LEFT JOIN BAANDB.TTCCOM100301 TCCOM100r
       ON TCCOM100r.T$BPID = tfacr200r.t$itbp

LEFT JOIN baandb.ttccom130301 tccom130r
       ON tccom130r.t$cadr = TCCOM100r.t$CADR

LEFT JOIN baandb.ttccom938301 tccom938
       ON tccom938.t$ftyp$l = tccom130r.t$ftyp$l
      AND tccom938.t$fovn$l = tccom130r.t$fovn$l

LEFT JOIN (SELECT 
              tfacr200d.t$ttyp            DOCTO_TRANSACAO_DEV,
              tfacr200d.t$ninv            TITULO_DEV,
              tfacr200d.t$docn$l || 
              tfacr200d.t$seri$l          DOCTO_DEV,
              CISLI940_DEV.t$fire$l       REF_FISCAL_DEV,
              tfacr200d.t$amnt            VL_TITULO_DEV,
              CISLI941_DEV.T$REFR$L       REF_FISCAL_RELATIVA,
              CISLI940_FAT.T$ityp$l       TRANSACAO_FAT,
              CISLI940_FAT.T$idoc$l       DOCUMENTO_FAT
          
          from BAANDB.ttfacr200301 tfacr200d
          
          LEFT JOIN BAANDB.TCISLI940301 CISLI940_DEV
                on CISLI940_DEV.T$DOCN$L = tfacr200d.t$docn$l
                AND CISLI940_DEV.T$SERI$L = tfacr200d.t$seri$l
          
          LEFT JOIN BAANDB.TCISLI941301 CISLI941_DEV
                 ON CISLI941_DEV.T$FIRE$L = CISLI940_DEV.T$FIRE$L
                 
          LEFT JOIN BAANDB.TCISLI940301 CISLI940_FAT
                on CISLI940_FAT.T$FIRE$L = CISLI941_DEV.t$REFR$l
          
          where tfacr200d.t$ttyp = 'DEV') DEV
          
    ON DEV.TRANSACAO_FAT = tfacr200r.t$ttyp
   AND DEV.DOCUMENTO_FAT = tfacr200r.t$ninv
   
LEFT JOIN BAANDB.TZNINT002301 ZNINT002
       ON ZNINT002.T$NCIA$C = znsls400b.T$NCIA$C
      AND ZNINT002.T$UNEG$C = znsls400b.T$UNEG$C

LEFT JOIN baandb.ttcemm124301 tcemm124
       ON tcemm124.t$cwoc = cisli940_ORG.t$cofc$l

LEFT JOIN baandb.ttcemm030301 tcemm030
       ON tcemm030.t$eunt = tcemm124.t$grid

WHERE tfacr200r.t$lino = 0
AND tfacr200r.t$trec <> 4
AND tcemm124.t$dtyp = 1
AND znint002.t$wstp$c in ('B2B','B2C')) Q1

WHERE Q1.DTA_EMISSAO BETWEEN :EmissaoDe AND :EmissaoAte
AND ((Q1.CNPJ like '%' || Trim(:CNPJ) || '%') OR (:CNPJ is null))
AND SALDO != 0
