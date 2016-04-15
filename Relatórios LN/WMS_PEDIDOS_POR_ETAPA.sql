SELECT
  DISTINCT
   WMSADMIN.PL_DB.DB_ALIAS            DSC_PLANTA,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,
     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
       AT time zone 'America/Sao_Paulo') AS DATE)
                                        DATA_LIMITE,

    ORDERS.ORDERKEY                     PEDIDO,
    
    ZNSLS420.PED_SITE			              PEDIDO_SITE,
    ZNSLS420.OP 				                ORDEM_DE_PRODUCAO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                                       DATA_REGISTRO,

    ORDERSTATUSSETUP2.DESCRIPTION      EVENTO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                                       DATA_ULT_EVENTO,

    ORDERSTATUSHISTORY.ADDWHO          OPERADOR,
    ORDERDETAIL.SKU                    ITEM,
    SKU.DESCR                          NOME_ITEM,
    SLS400.T$IDCA$C                    CANAL,
    NVL(ORDERS.C_VAT, 'N/A')           MEGA_ROTA,
    ORDERSTATUSSETUP.DESCRIPTION       SITUACAO,
    TASKDETAIL.TASKDETAILKEY           PROGRAMA,
    WAVEDETAIL.WAVEKEY                 ONDA,
    ORDERS.CARRIERCODE                 ID_TRANSPORTADORA,
    ORDERS.CARRIERNAME                 TRANSPORTADORA,
    SLS002.T$TPEN$C                    TIPO_ENTREGA,
    NVL(ORDERS.SUSR1, 'Não aplicável') NOME_TP_ENT,
    ORDERS.INVOICENUMBER               NOTA,
    ORDERS.LANE                        SERIE,
    CAGEIDDETAIL.CAGEID                CARGA,
    CASE WHEN SKU.SUSR2 = '2'
           THEN 'PESADO'
         ELSE 'LEVE'
    END                                TP_TRANSPORTE,
    ORDERS.C_ZIP                       CEP,
    whwmd400.t$hght                    ALTURA,
    whwmd400.t$wdth                    LARGURA,
    whwmd400.t$dpth                    COMPRIMENTO,
    SKU.STDNETWGT                      PESO_UNITARIO,
    SKU.STDGROSSWGT                    PESO_BRUTO,
    ORDERS.C_CITY                      MUNICIPIO,
    ORDERS.C_STATE                     ESTADO,
    ORDERDETAIL.ORIGINALQTY            QUANTIDADE,
    sls400.                            VALOR,

    REDESPACHO.description             REDESPACHO,

    CASE WHEN sls400.t$tpes$c = 'X' THEN 'Crossdocking'
         WHEN sls400.t$tpes$c = 'F' THEN 'Fingido'
         WHEN sls400.t$tpes$c = 'P' THEN 'Pré-Venda'
         ELSE 'NORMAL'
    END                                TIPO_ESTOQ,

    CASE WHEN TO_CHAR(LL.HOLDREASON) = ' '
       THEN 'OK'
       ELSE nvl(TO_CHAR(LL.HOLDREASON), 'OK')
   END                                  RESTRICAO,

    maucLN.mauc                         VALOR_CUSTO_CMV,
    ORDERS.C_COMPANY                    DESTINATARIO,
    ORDERS.type                         COD_TIPO_PEDIDO,
    TIPO_PEDIDO.                        DSC_TIPO_PEDIDO,
    ORDERDETAIL.UOM                     UNIDADE,
    SLS400.t$eftr$c                     TRANSP_REDESPACHO

FROM       WMWHSE5.ORDERS

INNER JOIN WMWHSE5.ORDERDETAIL
        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY

INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = ORDERDETAIL.SKU

 LEFT JOIN ENTERPRISE.CODELKUP cl
        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)
       AND cl.listname = 'SCHEMA'

 LEFT JOIN ( select trim(whina113.t$item) item,
                    whina113.t$cwar cwar,
                    sum(whina113.t$mauc$1) mauc
               from BAANDB.Twhina113301@pln01 whina113
              where (whina113.t$trdt, whina113.t$seqn) = ( select max(b.t$trdt), max(b.t$seqn)
                                                             from BAANDB.Twhina113301@pln01 b
                                                            where b.t$item = whina113.t$item
                                                              and b.t$cwar = whina113.t$cwar
                                                              and b.t$trdt = ( select max(c.t$trdt)
                                                                                 from BAANDB.Twhina113301@pln01 c
                                                                                where c.t$item = b.t$item
                                                                                  and c.t$cwar = b.t$cwar ) )
           group by whina113.t$item,
                    whina113.t$cwar ) maucLN
        ON maucLN.cwar = subStr(cl.DESCRIPTION,3,6)
       AND maucLN.item = sku.sku

 LEFT JOIN WMWHSE5.WAVEDETAIL
        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY

 LEFT JOIN WMWHSE5.CAGEIDDETAIL
        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY

 LEFT JOIN WMWHSE5.CAGEID
        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID

INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID

 LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002
        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))

 LEFT JOIN BAANDB.TWHWMD400301@pln01 whwmd400
        ON TRIM(whwmd400.t$item) = TRIM(SKU.SKU)

 LEFT JOIN ( SELECT a.ORDERKEY,
                    a.ORDERLINENUMBER ,
                    max(a.STATUS) STATUS,
                    max(a.ADDDATE) ADDDATE,
                    max(a.ADDWHO) ADDWHO
               FROM WMWHSE5.ORDERSTATUSHISTORY a
              WHERE a.ADDDATE = ( select max(b.adddate)
                                    from WMWHSE5.ORDERSTATUSHISTORY b
                                   where b.ORDERKEY = a.ORDERKEY
                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER )
           GROUP BY a.ORDERKEY,
                    a.ORDERLINENUMBER ) ORDERSTATUSHISTORY
        ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY
       AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER
       AND ORDERSTATUSHISTORY.STATUS = ORDERDETAIL.STATUS

 LEFT JOIN WMWHSE5.ORDERSTATUSSETUP
        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS

 LEFT JOIN WMWHSE5.ORDERSTATUSSETUP ORDERSTATUSSETUP2
        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS

 LEFT JOIN ( select max(a.TASKDETAILKEY) keep (dense_rank last order by a.ENDTIME) TASKDETAILKEY,
                    a.ORDERKEY,
                    a.ORDERLINENUMBER,
                    max(a.LOT) LOT,
                    max(a.FROMLOC) FROMLOC
               from WMWHSE5.TASKDETAIL a
              where a.tasktype = 'PK'
           group by a.ORDERKEY,
                    a.ORDERLINENUMBER ) TASKDETAIL
        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY
       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER

 LEFT JOIN WMWHSE5.LOTXLOC LL
        ON LL.LOT = TASKDETAIL.LOT
       AND LL.LOC = TASKDETAIL.FROMLOC
       AND LL.SKU = SKU.SKU

 LEFT JOIN ( select q.T$IDCA$C,
                    ZNSLS004.T$ORNO$C,
                    znsls401.t$item$c,
                    znsls401.t$tpes$c,
                    znsls401.t$eftr$c,
                    sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -
                        znsls401.t$vldi$c +
                        znsls401.t$vlfr$c +
                        znsls401.t$vlde$c ) VALOR
               from BAANDB.TZNSLS004301@pln01 ZNSLS004
         inner join BAANDB.TZNSLS400301@pln01 q
                 on ZNSLS004.T$NCIA$C = q.T$NCIA$C
                and ZNSLS004.T$UNEG$C = q.T$UNEG$C
                and ZNSLS004.T$PECL$C = q.T$PECL$C
                and ZNSLS004.T$SQPD$C = q.T$SQPD$C
         inner join BAANDB.TZNSLS401301@pln01 ZNSLS401
                 on znsls401.T$NCIA$C = znsls004.T$NCIA$C
                and znsls401.T$UNEG$C = znsls004.T$UNEG$C
                and znsls401.T$PECL$C = znsls004.T$PECL$C
                and znsls401.T$SQPD$C = znsls004.T$SQPD$C
                and znsls401.t$entr$c = znsls004.t$entr$c
                and znsls401.t$sequ$c = znsls004.t$sequ$c
           group by q.T$IDCA$C,
                    ZNSLS004.T$ORNO$C,
                    znsls401.t$item$c,
                    znsls401.t$tpes$c,
                    znsls401.t$eftr$c ) SLS400
      ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT
     AND SLS400.t$item$c = ORDERDETAIL.SKU

 LEFT JOIN ( 	select 	s_ZNSLS004.t$ORNO$C,
					s_SLS400.t$PECL$C			PED_SITE,
					s_SLS420.t$PDNO$C		OP
			from 	BAANDB.TZNSLS004301@pln01 s_ZNSLS004 
			left join BAANDB.TZNSLS400301@pln01 s_sls400
				 on  	s_sls400.T$NCIA$C	= s_ZNSLS004.T$NCIA$C
				and 	s_sls400.T$UNEG$C	= s_ZNSLS004.T$UNEG$C
				and	s_sls400.T$PECL$C	=  s_ZNSLS004.T$PECL$C 
				and 	s_sls400.T$SQPD$C	= s_ZNSLS004.T$SQPD$C
		                           
			left join 	BAANDB.TZNSLS420301@pln01 s_SLS420
				on 	s_SLS420.T$NCIA$C	= s_ZNSLS004.T$NCIA$C
				and	s_SLS420.T$UNEG$C	= s_ZNSLS004.T$UNEG$C
				and 	s_SLS420.T$PECL$C	= s_ZNSLS004.T$PECL$C
				and 	s_SLS420.T$SQPD$C	= s_ZNSLS004.T$SQPD$C
				and 	s_SLS420.t$ENTR$C	= s_ZNSLS004.t$ENTR$C
				and 	s_SLS420.t$SEQU$C	= s_ZNSLS004.t$SEQU$C ) ZNSLS420
	ON 	ZNSLS420.T$ORNO$C 	= ORDERS.REFERENCEDOCUMENT

 LEFT JOIN ( select clkp.description,
                    clkp.code
               from WMWHSE5.codelkup clkp
              where clkp.listname = 'INCOTERMS' )  REDESPACHO
        ON REDESPACHO.code = orders.INCOTERM

 LEFT JOIN ( select clkp.code          COD_TIPO_PEDIDO,
                    NVL(trans.description,
                    clkp.description)  DSC_TIPO_PEDIDO
               from WMWHSE5.codelkup clkp
          left join WMWHSE5.translationlist trans
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP'
              where clkp.listname = 'ORDERTYPE'
                and Trim(clkp.code) is not null  ) TIPO_PEDIDO
      ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type
 
  
WHERE NVL(SLS002.T$TPEN$C, 0) IN (:TipoEntrega)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)) 
    Between :DataUltEventoDe 
      And :DataUltEventoAte
  AND ORDERSTATUSSETUP.CODE IN (:ClasseEventos)
  AND NVL(ORDERS.C_VAT, 'N/A') IN (:MegaRota)
  
ORDER BY ORDERS.ORDERKEY
