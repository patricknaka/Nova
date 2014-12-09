SELECT
		OS.WHSEID															ID_FILIAL,
		(select cl.UDF2
		 from ENTERPRISE.CODELKUP cl
		 where cl.listname = 'SCHEMA'
		 and UPPER(cl.UDF1) = OS.WHSEID
		 and rownum=1)														DESCR_FILIAL,
		TDSLS400.T$ORNO														ORDEM_LN,
		ZNSLS004.T$PECL$C													PEDIDO_SITE,
		OS.ORDERKEY															ORDEM_WMS,
		TDSLS400.T$OFBP														ID_CLIENTE,
		TCCOM100.T$NAMA														NOME_CLIENTE,
		CASE WHEN (	WMSPONTO.DATAPONTO>PONTO.DATAPONTO
					AND WMSPONTO.DATAPONTO IS NOT NULL)
			THEN TO_CHAR(WMSPONTO.PONTO)
			ELSE TO_CHAR(PONTO.PONTO) END									DESCR_PONTO,
      
		CASE WHEN (	WMSPONTO.DATAPONTO>PONTO.DATAPONTO
					AND WMSPONTO.DATAPONTO IS NOT NULL)
			THEN TO_CHAR(WMSPONTO.ID_PONTO)
			ELSE TO_CHAR(PONTO.ID_PONTO) END									DESCR_PONTO,
      
		CASE	WHEN	OS.ORDERKEY IS NULL
				THEN	'NÃO'
				ELSE	'SIM' END											ENVIADO_WMS,
		PONTO.DATAWMS														DATA_ENVIO_WMS,
		TDSLS400.T$DDAT														DATA_LIMITE,
		TDSLS400.T$PRDT														DATA_PROMETIDA,
		PONTO.CONTRATO														CONTRATO_TRANSP

FROM	BAANDB.TTDSLS400301@PLN01 TDSLS400
		INNER JOIN	(select	a.t$ncia$c,
							a.t$uneg$c,
							a.t$pecl$c,
							a.t$sqpd$c,
							a.t$orno$c
					 from	BAANDB.TZNSLS004301@pln01 a
					 group by	a.t$ncia$c,
					            a.t$uneg$c,
					            a.t$pecl$c,
					            a.t$sqpd$c,
                                a.t$orno$c) ZNSLS004	ON	ZNSLS004.T$ORNO$C = TDSLS400.T$ORNO
		INNER JOIN	BAANDB.TZNSLS400301@pln01		ZNSLS400	ON	ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C
		                                                AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C
		                                                AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C
		                                                AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C
		INNER JOIN	BAANDB.TTCCOM100301@pln01		TCCOM100	ON	TCCOM100.T$BPID   = TDSLS400.T$OFBP
		INNER JOIN 	(select a.t$ncia$c,
							a.t$uneg$c,
							a.t$pecl$c,
							a.t$sqpd$c,
							max(a.t$dtoc$c) DATAPONTO,
							max(a.t$cono$c) CONTRATO,
              max(a.t$poco$c) keep (dense_rank last order by a.t$dtoc$c, a.t$seqn$c) ID_PONTO,
							max(b.t$desc$c) keep (dense_rank last order by a.t$dtoc$c, a.t$seqn$c) PONTO,
							min(case when a.t$poco$c='WMS' then a.t$dtoc$c else null end) DATAWMS
					 from    BAANDB.TZNSLS410301@pln01 a
					 INNER JOIN BAANDB.TZNMCS002301@PLN01 b ON b.t$poco$c = a.t$poco$c
					 group by  	
							a.t$ncia$c,
							a.t$uneg$c,
							a.t$pecl$c,
							a.t$sqpd$c) PONTO			ON	PONTO.T$NCIA$C = ZNSLS004.T$NCIA$C
							                            AND PONTO.T$UNEG$C = ZNSLS004.T$UNEG$C
							                            AND PONTO.T$PECL$C = ZNSLS004.T$PECL$C
							                            AND PONTO.T$SQPD$C = ZNSLS004.T$SQPD$C
		LEFT JOIN	ORDERS			OS			ON	OS.REFERENCEDOCUMENT = TDSLS400.T$ORNO
		LEFT JOIN	(select
							a.orderkey,
              max(b.code) keep (dense_rank last order by a.adddate) id_ponto,
							max(b.description) ponto,
							max(a.adddate) dataponto
					 from    WMWHSE5.ORDERSTATUSHISTORY a
					 inner join  WMWHSE5.ORDERSTATUSSETUP b  on b.code = a.status
					 group by a.orderkey) WMSPONTO		ON	WMSPONTO.ORDERKEY = OS.ORDERKEY
		
WHERE				ZNSLS400.T$TPED$C = 'Q'