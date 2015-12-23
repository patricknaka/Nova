SELECT DISTINCT
    znsls412.T$TTYP$C || znsls412.t$ninv$c  CD_CHAVE_PRIMARIA,
    1                                       CD_CIA,
    znsls412.T$TTYP$C                       CD_TRANSACAO_TITULO,
    tcemm030.t$euca                         CD_FILIAL,
    znsls401.t$orno$c                       NR_ORDEM_VENDA,
    znsls401o.t$orno$c                      NR_ORDEM_VENDA_ORIGINAL,
    znsls412.t$pecl$c                       NR_PEDIDO_LOJA,
    znsls412.t$uneg$c                       CD_UNIDADE_NEGOCIO,
    znsls412.t$ninv$c                       NR_ID_TITULO,
    znsls412.t$bpid$c                       CD_PARCEIRO,
    znsls400o.t$idca$c                      CD_CANAL_VENDA,
    znsls402.t$idmp$c                       CD_MEIO_PAGAMENTO
			
FROM        baandb.tznsls412201 znsls412

INNER JOIN  baandb.ttfacp200201 tfacp200
            ON  tfacp200.t$ttyp=znsls412.t$ttyp$c
            AND tfacp200.t$ninv=znsls412.t$ninv$c
            AND tfacp200.t$docn=0

INNER JOIN  baandb.tznsls401201 znsls401
            ON  znsls401.t$ncia$c=znsls412.t$ncia$c
            AND znsls401.t$uneg$c=znsls412.t$uneg$c
            AND znsls401.t$pecl$c=znsls412.t$pecl$c
            AND znsls401.t$sqpd$c=znsls412.t$sqpd$c

INNER JOIN  baandb.tznsls401201 znsls401o
            ON  znsls401o.t$ncia$c=znsls401.t$ncia$c
            AND znsls401o.t$uneg$c=znsls401.t$uneg$c
            AND znsls401o.t$pecl$c=znsls401.t$pvdt$c
            AND znsls401o.t$entr$c=znsls401.t$endt$c
            AND znsls401o.t$sequ$c=znsls401.t$sedt$c
			
INNER JOIN  baandb.tznsls400201 znsls400o															
            ON  znsls400o.t$ncia$c=znsls401o.t$ncia$c
            AND znsls400o.t$uneg$c=znsls401o.t$uneg$c
            AND znsls400o.t$pecl$c=znsls401o.t$pecl$c
            AND znsls400o.t$sqpd$c=znsls401o.t$sqpd$c
			
INNER JOIN 	baandb.tznsls402201 znsls402
            ON  znsls402.t$ncia$c=znsls412.t$ncia$c
            AND znsls402.t$uneg$c=znsls412.t$uneg$c
            AND znsls402.t$pecl$c=znsls412.t$pecl$c
            AND znsls402.t$sqpd$c=znsls412.t$sqpd$c
            AND znsls402.t$sequ$c=znsls412.t$sequ$c														

			
INNER JOIN  baandb.ttdsls400201 tdsls400 
            ON tdsls400.t$orno=znsls401.t$orno$c

INNER JOIN  baandb.ttcemm124201 tcemm124 
            ON tcemm124.t$cwoc=tdsls400.t$cofc

INNER JOIN  baandb.ttcemm030201 tcemm030 
            ON tcemm030.t$eunt=tcemm124.t$grid

WHERE       znsls412.t$ttyp$c IN (select distinct zncmg011.t$typd$c
                                  from baandb.tzncmg011201 zncmg011
                                  where zncmg011.t$typd$c!=' ')
AND         znsls412.t$type$c=3