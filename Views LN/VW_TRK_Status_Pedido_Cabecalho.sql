SELECT
    201 COMPANHIA,
    tcemm030.t$euca COD_FILIAL,
    tcemm112.t$grid UNID_EMPRESARIAL,
    znsls410.t$entr$c NUM_ENTREGA_PEDIDO,
    znsls410.t$pecl$c NUM_PEDIDO,
    znsls410.t$poco$c COD_STATUS,
    znsls410.t$stor$c COD_SISTEMA_FONTE,	
	CAST((FROM_TZ(CAST(TO_CHAR(znsls410.t$dtoc$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAOO_STATUS,
    znsls410.t$nmre$c USUARIO_ALTERACAO_STATUS,
    znsls410.T$UNEG$C UNID_NEGOCIO,
    znsls410.t$orno$c ORD_VENDA
FROM
    tznsls410201 znsls410,
	ttdsls400201 tdsls400,
	ttcemm112201 tcemm112,
	ttcemm030201 tcemm030
WHERE 	tdsls400.t$orno=znsls410.t$orno$c
AND     tdsls400.t$cwar=tcemm112.t$waid
AND		tcemm030.t$eunt=tcemm112.t$grid