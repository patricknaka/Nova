-- VIEW: VW_TRK_Status_Pedido
-- #FAF.050, 23-mai-2014, Fabio Ferreira,	NUM_ENTREGA_PEDIDO convertido para string
--************************************************************************************************************************************************
SELECT
    201 CD_CIA,
    tcemm030.t$euca CD_FILIAL,
	TO_CHAR(znsls410.t$entr$c) NR_ENTREGA_PEDIDO,					--#FAF.050.n
    znsls410.t$pecl$c NR_PEDIDO,
    znsls410.t$poco$c CD_STATUS,
    znsls410.t$stor$c CD_SISTEMA_FONTE,	
	CAST((FROM_TZ(CAST(TO_CHAR(znsls410.t$dtoc$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO_STATUS,
    znsls410.t$nmre$c NM_USUARIO_MODIFICACAO_STATUS,
    tcemm112.t$grid CD_UNIDADE_EMPRESARIAL,
    znsls410.T$UNEG$C CD_UNIDADE_NEGOCIO,
    znsls410.t$orno$c NR_ORDEM_VENDA
FROM
    tznsls410201 znsls410,
	ttdsls400201 tdsls400,
	ttcemm112201 tcemm112,
	ttcemm030201 tcemm030
WHERE 	tdsls400.t$orno=znsls410.t$orno$c
AND     tdsls400.t$cwar=tcemm112.t$waid
AND		tcemm030.t$eunt=tcemm112.t$grid