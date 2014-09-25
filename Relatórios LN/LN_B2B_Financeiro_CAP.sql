SELECT
  DISTINCT
    tcemm030.t$euca	        FILIAL,
    znsls400b.t$idco$c	    CONTRATO,
    znsls400b.t$idcp$c	    CAMPANHA,
    tccom130r.t$fovn$l      CNPJ,
    tccom938.t$desa$l       RAZAO_SOCIAL,
--    Não tem no LN         JOGO_NF,
    tfacr200r.t$docn$l	    NOTA_TITULO,
    tfacr200r.t$seri$l	    SERIE,
    tfacr200r.t$docd        DTA_EMISSAO,
    tfacr200r.t$dued        VENCIMENTO_TITULO,
    tfacr200r.t$docn        TITULO_CAR,
    tfacr200r.t$amnt        VL_TITULO_CAR,
    tfacr200r.t$tdoc        DOCTO_TRANSACAO,
--    Não tem no LN         PEDIDO_GRUPO,
    znsls400b.t$pecl$c      ID_PED_VENDA,
    cisli940c.t$amnt$l      VL_INST_CANCELAMENTO,
    tfacr200p.t$docn        TITULO_CAP,
    tfacr200p.t$amnt        VL_TITULO_CAP,
    tfacr200r.t$amnt-
    cisli940c.t$amnt$l      VL_BOLETO
--    Não tem no LN         DESC_CAMPANHA

FROM       baandb.ttcemm030201  tcemm030,
           baandb.ttcemm124201  tcemm124,
           baandb.ttfacr200201  tfacr200r 
		   
LEFT JOIN  baandb.ttfacr200201  tfacr200p
       ON  tfacr200p.t$ttyp = tfacr200r.t$ttyp
      AND  tfacr200p.t$ninv = tfacr200r.t$ninv
      AND  tfacr200p.t$docn$l = tfacr200r.t$docn$l
      AND  tfacr200p.t$trec = 4

LEFT JOIN  baandb.tcisli940201   cisli940c
       ON  cisli940c.t$ityp$l = tfacr200r.t$ttyp
      AND  cisli940c.t$idoc$l = tfacr200r.t$ninv
      AND  cisli940c.t$docn$l = tfacr200r.t$docn$l
      AND  cisli940c.t$stat$l = 201

LEFT JOIN  baandb.tcisli940201   cisli940b
       ON  cisli940b.t$ityp$l = tfacr200r.t$ttyp
      AND  cisli940b.t$idoc$l = tfacr200r.t$ninv
      AND  cisli940b.t$docn$l = tfacr200r.t$docn$l

LEFT JOIN  baandb.tcisli941201  cisli941b
       ON  cisli941b.t$fire$l = cisli940b.t$fire$l           

LEFT JOIN  baandb.tcisli245201  cisli245b
       ON  cisli245b.t$fire$l = cisli941b.t$fire$l
      AND  cisli245b.t$line$l = cisli941b.t$line$l

LEFT JOIN  baandb.tznsls401201  znsls401b
       ON  znsls401b.t$orno$c = cisli245b.t$slso
      AND  znsls401b.t$pono$c = cisli245b.t$pono           

LEFT JOIN  baandb.tznsls400201  znsls400b
       ON  znsls400b.t$pecl$c = znsls401b.t$pecl$c

LEFT JOIN  baandb.ttccom130201  tccom130r
       ON  tccom130r.t$cadr = tfacr200r.t$itbp

LEFT JOIN  baandb.ttccom938201  tccom938
       ON  tccom938.t$ftyp$l=tccom130r.t$ftyp$l
      AND  tccom938.t$fovn$l=tccom130r.t$fovn$l	

    WHERE  tfacr200r.t$balc <> 0.00 
      AND  tfacr200r.t$lino = 0
      AND  tfacr200r.t$trec <> 4
      AND  tcemm124.t$cwoc = cisli940b.t$cofc$l 
      AND  tcemm124.t$dtyp = 1 
      AND  tcemm030.t$eunt = tcemm124.t$grid
	  
      AND tfacr200r.t$docd BETWEEN :EmissaoDe AND :EmissaoAte
      AND ((tccom130r.t$fovn$l like '%' || Trim(:CNPJ) || '%') OR (:CNPJ is null))