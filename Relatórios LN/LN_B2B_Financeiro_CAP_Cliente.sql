-- ID MMF:  Algumas equalizacoes para a querie ficar igual a LN_B2B_FINANCEIRO_CAR.
--          Notas de operação triangular não estavam sendo impressas
--          Novo campo: VALOR_TOTAL

SELECT
  DISTINCT
    znsls400b.t$idco$c        CONTRATO,
    znsls400b.t$idcp$c        CAMPANHA,
    znsls400b.t$fovn$c        CNPJ,
    tccom130a.t$fovn$l        CNPJ_FILIAL_EMISSORA,    
    tccom130a.t$nama          NOME,
--  Não tem no LN             JOGO_NF,
    tfacr200r.t$docn$l        NF,
    tfacr200r.t$seri$l        SERIE,  
    tfacr200r.t$docd          DTA_EMISSAO_TITULO,  
    znsls400b.t$pecl$c        PEDIDO_CLIENTE,                      
    tccom130b.t$fovn$l        CPF_CLIENTE,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400b.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE) 
                              DTA_EMISSAO_PEDIDO,  
                              
    tccom130b.t$nama          NOME_CLIENTE,                      
    Trim(cisli941.t$item$l)   ID_ITEM,
    cisli941.t$desc$l         DESC_ITEM,
    znsls401.t$qtve$c         QUANTIDADE,
    znsls401.t$vlun$c         VALOR_UNIT,
    znsls401.t$qtve$c *       
    znsls401.t$vlun$c         VLR_MERCADORIA,  
    cisli941.t$tldm$l         VLR_DESC_INCL_TOTAL,
    cisli941.t$fght$l         VLR_TOTAL_FRETE,
    cisli941.t$iprt$l         VLR_TOTAL_ITEM,
    ( znsls401.t$qtve$c * znsls401.t$vlun$c ) - cisli941.t$tldm$l + 
        cisli941.t$fght$l     VALOR_TOTAL,

    TO_CHAR(cisli940b.t$cnfe$l)  
                              ID_CHAVE_ACESSO,
--  Não tem no LN             DESC_CAMPANHA,
    znsls400b.t$peex$c        PEDIDO_PARCEIRO,
 
    ( SELECT cisli943.t$sbas$l 
        FROM baandb.tcisli943201 cisli943 
       WHERE cisli943.t$fire$l=cisli941.t$fire$l 
         AND cisli943.t$line$l=cisli941.t$line$l 
         AND cisli943.t$brty$l=1 )
                              BASE_ICMS,  
       
    ( SELECT cisli943.t$amnt$l 
        FROM baandb.tcisli943201 cisli943 
       WHERE cisli943.t$fire$l=cisli941.t$fire$l 
         AND cisli943.t$line$l=cisli941.t$line$l 
         AND cisli943.t$brty$l=1 )
                              VLR_ICMS,
                              
    cisli943b.t$base$l        VLR_BASE_RAT_ANT,
    cisli943b.t$amnt$l        VLR_ICMS_RAT_ANT,
    cisli943b.t$base$l/       
    cisli941.t$dqua$l         VLR_BASE_RAT,
    cisli943b.t$amnt$l/       
    cisli941.t$dqua$l         VLR_ICMS_RAT,
	znsls400b.t$tped$c		  ID_TIPO_PEDIDO,
	znsls407.t$dscs$c		  DESCR_TIPO_PEDIDO,
	cisli940b.t$bpid$l		  COD_PARCEIRO

FROM       baandb.ttfacr200201  tfacr200r 

 LEFT JOIN baandb.tcisli940201  cisli940b
--        ON cisli940b.t$ityp$l = tfacr200r.t$ttyp
        ON CISLI940b.T$SFCP$L = tfacr200r.t$loco$l 	-- MMF	equalizando com LN_B2B_FINANCEIRO_CAR	
       AND cisli940b.t$ityp$l = tfacr200r.t$ttyp
       AND cisli940b.t$idoc$l = tfacr200r.t$ninv
       AND cisli940b.t$docn$l = tfacr200r.t$docn$l
       AND CISLI940b.T$SERI$L = tfacr200r.t$seri$l 	-- MMF	equalizando com LN_B2B_FINANCEIRO_CAR

INNER JOIN baandb.ttcemm124201  tcemm124
        ON tcemm124.t$cwoc    = cisli940b.t$cofc$l

INNER JOIN baandb.ttcemm030201  tcemm030
        ON tcemm030.t$eunt    = tcemm124.t$grid

 LEFT JOIN baandb.ttfacr200201  tfacr200p
        ON tfacr200p.t$ttyp   = tfacr200r.t$ttyp
       AND tfacr200p.t$ninv   = tfacr200r.t$ninv
       AND tfacr200p.t$docn$l = tfacr200r.t$docn$l
       AND tfacr200p.t$trec   = 4

       -- MMF.sn
LEFT JOIN baandb.tcisli941201   cisli941
       ON cisli941.t$fire$l   = cisli940b.t$fire$l   

LEFT JOIN BAANDB.TCISLI941201 CISLI941_REM                      -- REMESSA OP TRIANGULAR
       ON CISLI941_REM.T$FIRE$L = CISLI941.T$REFR$L
      AND CISLI941_REM.T$LINE$L = CISLI941.T$RFDL$L
       -- MMF.en
       
--LEFT JOIN baandb.tcisli245201   cisli245b			-- MMF.so
--       ON cisli245b.t$fire$l  = cisli941.t$fire$l
--      AND cisli245b.t$line$l  = cisli941.t$line$l 		-- MMF.eo

LEFT JOIN BAANDB.TCISLI245201 cisli245b 			           -- MMF.sn
       ON CISLI245b.T$FIRE$L = CISLI941_REM.T$FIRE$L
      AND CISLI245b.T$LINE$L = CISLI941_REM.T$LINE$L 		-- MMF.enl

LEFT JOIN baandb.tcisli943201   cisli943b
       ON cisli943b.t$fire$l  = cisli941.t$fire$l
      AND cisli943b.t$line$l  = cisli941.t$line$l
	  AND cisli943b.t$brty$l  = 1
	  
LEFT JOIN baandb.tznsls004201   znsls004
       ON znsls004.t$orno$c   = cisli245b.t$slso
      AND znsls004.t$pono$c   = cisli245b.t$pono
--      AND cisli943b.t$brty$l  = 1

INNER JOIN baandb.tznsls401201   znsls401
       ON znsls401.t$ncia$c   = znsls004.t$ncia$c
      AND znsls401.t$uneg$c   = znsls004.t$uneg$c
      AND znsls401.t$pecl$c   = znsls004.t$pecl$c
      AND znsls401.t$sqpd$c   = znsls004.t$sqpd$c
      AND znsls401.t$entr$c   = znsls004.t$entr$c
      AND znsls401.t$sequ$c   = znsls004.t$sequ$c

INNER JOIN baandb.tznsls400201  znsls400b
       ON znsls400b.t$ncia$c   = znsls004.t$ncia$c
      AND znsls400b.t$uneg$c   = znsls004.t$uneg$c
      AND znsls400b.t$pecl$c   = znsls004.t$pecl$c
      AND znsls400b.t$sqpd$c   = znsls004.t$sqpd$c

LEFT JOIN baandb.tznsls407201   znsls407
       ON znsls407.t$tpst$c   = znsls400b.t$tped$c

 LEFT JOIN baandb.ttccom130201  tccom130a
        ON tccom130a.t$cadr   = cisli940b.t$sfra$l

 LEFT JOIN baandb.ttccom130201  tccom130b
        ON tccom130b.t$cadr   = cisli940b.t$stoa$l

INNER JOIN baandb.tznsls000201 znsls000                  -- Excluir itens frete / seguro / outras despesas
        ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')
       AND cisli941.t$item$l != znsls000.t$itmf$c      --ITEM FRETE
       AND cisli941.t$item$l != znsls000.t$itmd$c      --ITEM DESPESAS
       AND cisli941.t$item$l != znsls000.t$itjl$c      --ITEM JUROS

--WHERE  tfacr200r.t$balc <> 0.00 AND tfacr200r.t$lino = 0  
WHERE  tfacr200r.t$lino = 0                             -- MMF  equalizando com LN_B2B_FINANCEIRO_CAR 
   AND tfacr200r.t$trec <> 4
   AND tcemm124.t$dtyp   = 1 
   AND znsls400b.t$idca$c = 'B2B'

   AND TRUNC(tfacr200r.t$docd) BETWEEN :EmissaoDe AND :EmissaoAte
   AND ((tccom130a.t$fovn$l like '%' || Trim(:CNPJ) || '%') OR (:CNPJ is null)) 
