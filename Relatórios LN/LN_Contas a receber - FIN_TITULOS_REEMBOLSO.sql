SELECT 
  DISTINCT
    tccom130.t$fovn$l       CNPJ_CLIENTE,
    tccom100.t$nama         NOME_CLIENTE,
    znsls401o.t$pecl$c      PEDIDO,
    tfacp200.t$docd         DATA_SITUAC,
    tfacp200.T$AMTH$1       VL_ESTORNADO,
    cisli940.t$docn$l       NF_FATURA,
    cisli940.t$seri$l       SERIE_FATURA, 
    znsls412o.t$ttyp$c || 
    znsls412o.t$ninv$c      TITULO_CAR,
    znsls412o.t$ttyp$c      TRANS_CAR,
    znsls412o.t$ninv$c      NUM_CAR,
    tfacr200.t$docd         EMISSAO_CAR,
 
    ( select znacr005.t$ttyp$c || znacr005.t$ninv$c 
        from baandb.tznacr005201 znacr005   
       where znacr005.t$tty1$c = tfacr200.t$ttyp 
         and znacr005.t$nin1$c = tfacr200.t$ninv
         and znacr005.T$FLAG$C = 1            
         and rownum = 1 )   TITULO_AGRUPADO,

    ( select min(tfacr201.t$recd) 
        from baandb.ttfacr201201 tfacr201
       where tfacr201.t$ttyp = tfacr200.t$ttyp 
         and tfacr201.t$ninv = tfacr200.t$ninv) 
                            DT_VCTO,

    CASE WHEN tfacr200.t$balc = 0 then ( select max(a.t$docd) 
                                           from baandb.ttfacr200201 a
                                          where a.t$ttyp = tfacr200.t$ttyp 
                                            and a.t$ninv = tfacr200.t$ninv
                                            and a.t$amnt < 0 ) 
         ELSE NULL 
     END                     DT_LIQ,
	 
    tfacp200.t$ttyp          TITULO_CAP,

    CASE WHEN tfacp200.t$balc = 0 THEN 'FECHADO' 
         ELSE 'ATIVO' 
     END                     STATUS_CAP,

    tfacp200.t$ninv          NUM_NCV_CAP,

    CASE WHEN znsls400o.t$idcp$c = 0 THEN Null
         ELSE znsls400o.t$idcp$c       
     END                     CAMPANHA,
     
    CASE WHEN znsls400o.t$idco$c = 0 THEN Null
         ELSE znsls400o.t$idco$c       
     END                     CONTRATO,
     
    CASE WHEN znsls402o.t$idag$c = 0 THEN Null
         ELSE znsls402o.t$idag$c       
     END                     AGENCIA,
    
    CASE WHEN znsls400o.t$peex$c = 0 THEN Null
         ELSE znsls400o.t$peex$c       
     END                     PED_PARCEIRO,
     
    cisli940.t$stbn$l        PREMIADO
	
FROM       baandb.tznsls412201 znsls412

INNER JOIN baandb.ttfacp200201 tfacp200
        ON tfacp200.t$ttyp = znsls412.t$ttyp$c
       AND tfacp200.t$ninv = znsls412.t$ninv$c
       AND tfacp200.t$docn = 0 
   
INNER JOIN baandb.ttccom100201 tccom100
        ON tccom100.t$bpid = tfacp200.t$ifbp
   
INNER JOIN baandb.ttccom130201 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr         
   
INNER JOIN baandb.tznsls401201 znsls401
        ON znsls401.t$ncia$c = znsls412.t$ncia$c
       AND znsls401.t$uneg$c = znsls412.t$uneg$c
       AND znsls401.t$pecl$c = znsls412.t$pecl$c
       AND znsls401.t$sqpd$c = znsls412.t$sqpd$c
   
INNER JOIN baandb.tznsls401201 znsls401o
        ON znsls401o.t$ncia$c = znsls401.t$ncia$c
       AND znsls401o.t$uneg$c = znsls401.t$uneg$c
       AND znsls401o.t$pecl$c = znsls401.t$pvdt$c
       AND znsls401o.t$entr$c = znsls401.t$endt$c
       AND znsls401o.t$sequ$c = znsls401.t$sedt$c
   
INNER JOIN baandb.tznsls400201 znsls400o
        ON znsls400o.t$ncia$c = znsls401o.t$ncia$c
       AND znsls400o.t$uneg$c = znsls401o.t$uneg$c
       AND znsls400o.t$pecl$c = znsls401o.t$pecl$c
       AND znsls400o.t$sqpd$c = znsls401o.t$sqpd$c
   
INNER JOIN baandb.tznsls402201 znsls402o
        ON znsls402o.t$ncia$c = znsls400o.t$ncia$c
       AND znsls402o.t$uneg$c = znsls400o.t$uneg$c
       AND znsls402o.t$pecl$c = znsls400o.t$pecl$c
       AND znsls402o.t$sqpd$c = znsls400o.t$sqpd$c
   
INNER JOIN baandb.tznsls412201 znsls412o
        ON znsls412o.t$ncia$c = znsls401o.t$ncia$c
       AND znsls412o.t$uneg$c = znsls401o.t$uneg$c
       AND znsls412o.t$pecl$c = znsls401o.t$pecl$c
       AND znsls412o.t$sequ$c = znsls401o.t$sequ$c
   
INNER JOIN baandb.ttfacr200201 tfacr200
        ON tfacr200.t$ttyp = znsls412o.t$ttyp$c
       AND tfacr200.t$ninv = znsls412o.t$ninv$c
   
 LEFT JOIN baandb.tcisli245201 cisli245
        ON cisli245.T$SLSO = znsls401o.T$ORNO$C
       AND cisli245.t$pono = znsls401o.T$PONO$C
   
 LEFT JOIN baandb.tcisli940201 cisli940
        ON cisli940.t$fire$l = cisli245.t$fire$l   
   
INNER JOIN baandb.ttdsls400201 tdsls400 
        ON tdsls400.t$orno = znsls401.t$orno$c
   
INNER JOIN baandb.ttcemm124201 tcemm124 
        ON tcemm124.t$cwoc = tdsls400.t$cofc
   
INNER JOIN baandb.ttcemm030201 tcemm030 
        ON tcemm030.t$eunt = tcemm124.t$grid
   
WHERE znsls412.t$ttyp$c IN ( select distinct zncmg011.t$typd$c
                               from baandb.tzncmg011201 zncmg011
                              where zncmg011.t$typd$c != ' '
                                and zncmg011.t$tpps$c IN ('P', 'R')
                                and zncmg011.t$mpgt$c = 2 )
  AND znsls412.t$type$c = 3
 
  AND tfacr200.t$docd Between :DataEmissaoDe And :DataEmissaoAte