--	#FAF.200 - 04-jul-2014, Fabio Ferreira,	Alteração da chave para tipo de transação + numero do título
--	#FAF.234 - 18-jul-2014, Fabio Ferreira,	Correção duplicidade
--****************************************************************************************************************************************************************
SELECT DISTINCT
 --           znsls412.T$TTYP$C || znsls412.t$ninv$c || znsls401.t$orno$c CD_CHAVE_PRIMARIA,			--#FAF.200.o
			znsls412.T$TTYP$C || znsls412.t$ninv$c CD_CHAVE_PRIMARIA,									--#FAF.200.n
            201 CD_CIA,
            znsls412.T$TTYP$C CD_TRANSACAO_TITULO,
            tcemm030.t$euca CD_FILIAL,
            znsls401.t$orno$c NR_ORDEM_VENDA,
            znsls401o.t$orno$c NR_ORDEM_VENDA_ORIGINAL,
            znsls412.t$pecl$c NR_PEDIDO_LOJA,
            znsls412.t$uneg$c CD_UNIDADE_NEGOCIO,
            znsls412.t$ninv$c NR_ID_TITULO,
            znsls412.t$bpid$c CD_PARCEIRO
FROM        tznsls412201 znsls412
INNER JOIN  ttfacp200201 tfacp200
            ON  tfacp200.t$ttyp=znsls412.t$ttyp$c
            AND tfacp200.t$ninv=znsls412.t$ninv$c
            AND tfacp200.t$docn=0
INNER JOIN  tznsls401201 znsls401
            ON  znsls401.t$ncia$c=znsls412.t$ncia$c
            AND znsls401.t$uneg$c=znsls412.t$uneg$c
            AND znsls401.t$pecl$c=znsls412.t$pecl$c
            AND znsls401.t$sqpd$c=znsls412.t$sqpd$c
INNER JOIN  tznsls401201 znsls401o
            ON  znsls401o.t$ncia$c=znsls401.t$ncia$c
            AND znsls401o.t$uneg$c=znsls401.t$uneg$c
            AND znsls401o.t$pecl$c=znsls401.t$pvdt$c
            AND znsls401o.t$entr$c=znsls401.t$endt$c
            AND znsls401o.t$sequ$c=znsls401.t$sedt$c
INNER JOIN  ttdsls400201 tdsls400 
            ON tdsls400.t$orno=znsls401.t$orno$c
INNER JOIN  ttcemm124201 tcemm124 
            ON tcemm124.t$cwoc=tdsls400.t$cofc
INNER JOIN  ttcemm030201 tcemm030 
            ON tcemm030.t$eunt=tcemm124.t$grid
WHERE       znsls412.t$ttyp$c IN (select distinct zncmg011.t$typd$c
                                  from tzncmg011201 zncmg011
                                  where zncmg011.t$typd$c!=' ')
AND         znsls412.t$type$c=3