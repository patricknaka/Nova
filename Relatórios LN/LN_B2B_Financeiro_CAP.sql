SELECT
  DISTINCT   
    tcemm030.t$euca     FILIAL,
    znsls400b.t$idco$c  CONTRATO,
    znsls400b.t$idcp$c  CAMPANHA,
    tccom130r.t$fovn$l  CNPJ,
    tccom938.t$desa$l   RAZAO_SOCIAL,
    --Não tem no LN     JOGO_NF,
    tfacr200r.t$docn$l  NOTA_TITULO,
    tfacr200r.t$seri$l  SERIE,
    tfacr200r.t$docd    DTA_EMISSAO,
    tfacr200r.t$dued    VENCIMENTO_TITULO,
    tfacr200r.t$ninv    TITULO_CAR,
    tfacr200r.t$amnt    VL_TITULO_CAR,
    tfacr200r.t$ttyp    DOCTO_TRANSACAO,
    --Não tem no LN     PEDIDO_GRUPO,
    ZNSLS004_ORG.t$pecl$c  ID_PED_VENDA,
    --cisli940c.t$amnt$l  VL_INST_CANCELAMENTO,       -- EXCLUIR DO RELATÓRIO
    CISLI940_ORG.T$CNFE$L CHAVE_ACESSO,
    TDREC940_DEV.T$TTYP$L || TDREC940_DEV.T$INVN$L   TITULO_CAP,
    TFACR200_DEV.t$amnt    VL_TITULO_CAP,
   
    TDREC940_DEV.VALOR  VL_BOLETO,
    TCCOM100r.T$BPID     PARCEIRO
    --Não tem no LN     DESC_CAMPANHA

FROM       baandb.ttfacr200201 tfacr200r

LEFT JOIN BAANDB.TCISLI940201 CISLI940_ORG
            ON  CISLI940_ORG.T$SFCP$L  = tfacr200r.t$loco$l
            AND CISLI940_ORG.T$ITYP$L  = tfacr200r.t$ttyp
            AND CISLI940_ORG.T$IDOC$L  = tfacr200r.t$ninv
            AND CISLI940_ORG.T$DOCN$L  = tfacr200r.t$docn$l
            AND CISLI940_ORG.T$SERI$L  = tfacr200r.t$seri$l

LEFT JOIN BAANDB.TCISLI941201 CISLI941_ORG
            ON  CISLI941_ORG.T$FIRE$L = CISLI940_ORG.T$FIRE$L
            
LEFT JOIN BAANDB.TCISLI941201 CISLI941_REM                      -- REMESSA OP TRIANGULAR
            ON  CISLI941_REM.T$FIRE$L = CISLI941_ORG.T$REFR$L
            AND CISLI941_REM.T$LINE$L = CISLI941_ORG.T$RFDL$L
                        
LEFT JOIN BAANDB.TCISLI245201 CISLI245_ORG
            ON  CISLI245_ORG.T$FIRE$L = CISLI941_REM.T$FIRE$L
            AND CISLI245_ORG.T$LINE$L = CISLI941_REM.T$LINE$L
            
LEFT JOIN BAANDB.TZNSLS004201 ZNSLS004_ORG
            ON  ZNSLS004_ORG.T$ORNO$C = CISLI245_ORG.T$SLSO
            AND ZNSLS004_ORG.T$PONO$C = CISLI245_ORG.T$PONO

LEFT JOIN baandb.tznsls400201 znsls400b
            ON  znsls400b.t$ncia$c  = ZNSLS004_ORG.T$NCIA$C
            AND znsls400b.t$uneg$c  = ZNSLS004_ORG.T$UNEG$C
            AND znsls400b.t$pecl$c  = ZNSLS004_ORG.T$PECL$C
            AND znsls400b.t$sqpd$c  = ZNSLS004_ORG.T$SQPD$C

LEFT JOIN BAANDB.TTCCOM100201 TCCOM100r
            ON  TCCOM100r.T$BPID  = tfacr200r.t$itbp

LEFT JOIN baandb.ttccom130201 tccom130r
        ON tccom130r.t$cadr = TCCOM100r.t$CADR

LEFT JOIN baandb.ttccom938201 tccom938
        ON tccom938.t$ftyp$l = tccom130r.t$ftyp$l
       AND tccom938.t$fovn$l = tccom130r.t$fovn$l
       
LEFT JOIN (SELECT   A.T$SLIF$L,
                    B.T$TTYP$L,
                    B.T$INVN$L,
                    SUM(A.T$TAMT$L) VALOR
           FROM BAANDB.TTDREC941201 A
           INNER JOIN BAANDB.TTDREC940201 B
              ON  B.T$FIRE$L = A.T$FIRE$L
           WHERE    A.T$SLIF$L IS NOT NULL
           GROUP BY A.T$SLIF$L,
                    B.T$TTYP$L,
                    B.T$INVN$L) TDREC940_DEV
            ON  TDREC940_DEV.T$SLIF$L = CISLI941_ORG.T$FIRE$L

LEFT JOIN BAANDB.TTFACR200201 TFACR200_DEV
            ON  TFACR200_DEV.T$TTYP = TDREC940_DEV.T$TTYP$L
            AND TFACR200_DEV.T$NINV = TDREC940_DEV.T$INVN$L
            AND TFACR200_DEV.T$LINO = 0

LEFT JOIN BAANDB.TZNINT002201 ZNINT002
            ON  ZNINT002.T$NCIA$C = znsls400b.T$NCIA$C
            AND ZNINT002.T$UNEG$C = znsls400b.T$UNEG$C

LEFT JOIN baandb.ttcemm124201 tcemm124
        ON tcemm124.t$cwoc = cisli940_ORG.t$cofc$l

LEFT JOIN baandb.ttcemm030201 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid
 
WHERE --tfacr200r.t$balc <> 0.00
   tfacr200r.t$lino = 0
  AND tfacr200r.t$trec <> 4
  AND tcemm124.t$dtyp = 1
  AND ZNINT002.T$WSTP$C='B2B'

  AND tfacr200r.t$docd BETWEEN :EmissaoDe AND :EmissaoAte
  AND ((tccom130r.t$fovn$l like '%' || Trim(:CNPJ) || '%') OR (:CNPJ is null))
