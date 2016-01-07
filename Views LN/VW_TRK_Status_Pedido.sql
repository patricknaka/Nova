SELECT
    1 CD_CIA,
    --tcemm030.t$euca CD_FILIAL,
	TO_CHAR(znsls410.t$entr$c) NR_ENTREGA_PEDIDO,					--#FAF.050.n
    znsls410.t$pecl$c NR_PEDIDO,
    znsls410.t$poco$c CD_STATUS,
    znsls410.t$stor$c CD_SISTEMA_FONTE,	
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ATUALIZACAO,
    znsls410.t$nmre$c NM_USUARIO_MODIFICACAO_STATUS,
    --tcemm112.t$grid CD_UNIDADE_EMPRESARIAL,
    znsls410.T$UNEG$C CD_UNIDADE_NEGOCIO,
    znsls410.t$orno$c NR_ORDEM_VENDA,
    znsls410.t$seqn$c as SQ_PONTO_CONTROLE,
    znsls410.t$sqpd$c as SQ_PEDIDO,
    tdsls400.t$cwar
FROM
    baandb.tznsls410201 znsls410
    inner join baandb.ttdsls400201 tdsls400
    on tdsls400.t$orno=znsls410.t$orno$c
    /*left join  baandb.ttcemm112201 tcemm112
    on tdsls400.t$cwar=tcemm112.t$waid
    left join    baandb.ttcemm030201 tcemm030
    on tcemm030.t$eunt=tcemm112.t$grid*/
