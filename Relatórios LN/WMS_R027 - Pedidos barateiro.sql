SELECT
		o.whseid						ID_FILIAL,
		cl.UDF2							DESCR_FILIAL,
		znsls004.t$pecl$c				PEDIDO_SITE,
		o.referencedocument				ORDEM_LN,
		o.ORDERKEY						ORDEM_WMS,
		znsls004.t$uneg$c				ID_UNEG,
		o.SUSR4					DESCR_UNEG
FROM
		orders o
		INNER JOIN	ENTERPRISE.CODELKUP cl		ON 	UPPER(cl.UDF1)=o.whseid
												AND	cl.listname='SCHEMA'
		INNER JOIN	(	select	a.t$orno$c,
								a.t$pecl$c,
								a.t$uneg$c
						from	baandb.tznsls004301@pln01 a
						group by a.t$orno$c,
		                         a.t$pecl$c,
                                 a.t$uneg$c) znsls004 ON  ZNSLS004.T$ORNO$c = o.referencedocument
WHERE
            znsls004.t$uneg$c=13
        and o.status<95