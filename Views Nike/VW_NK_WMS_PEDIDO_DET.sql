SELECT
--**********************************************************************************************************************************************************
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
-- para a nike os dados estão na filial WMWHSE10
-- quando migrarmos para produção será necessário mudar para WMWHSE9
-- conforme orientação do Humberto - 21/12/2016
  cast(13 as int) as                              CD_CIA,
  ORDERDETAIL.orderkey                            NR_PEDIDO_WMS, 
	ORDERDETAIL.WHSEID                              CD_ARMAZEM,
	ORDERDETAIL.sku                                 CD_ITEM,
	ORDERDETAIL.ORDERLINENUMBER                     SQ_PEDIDO,
	PKD.lot                                         CD_LOTE,
	ORDERDETAIL.ORIGINALQTY                         QT_PEDIDA,
	ORDERDETAIL.ORIGINALQTY-ORDERDETAIL.OPENQTY     QT_ATENDIDA,
	ORDERDETAIL.STATUS                              CD_SITUACAO_ITEM,	
	ORDERDETAIL.SHIPPEDQTY                          QT_LIQUIDADA,									
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(nvl((select min(orderstatushistory.ADDDATE) 
    from WMWHSE10.orderstatushistory orderstatushistory
    where orderstatushistory.ORDERKEY=ORDERDETAIL.ORDERKEY
    and orderstatushistory.ORDERLINENUMBER=ORDERDETAIL.ORDERLINENUMBER
    and orderstatushistory.STATUS=ORDERDETAIL.STATUS), ORDERDETAIL.ADDDATE), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)    DT_SITUACAO_ITEM,  
	CASE WHEN ORDERDETAIL.ADJUSTEDQTY<0 
    THEN ABS(ORDERDETAIL.ADJUSTEDQTY) 
    ELSE 0 END                                    QT_CANCELADA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERDETAIL.editdate, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
  AT time zone 'America/Sao_Paulo') AS DATE)      DT_ULT_ATUALIZACAO

FROM WMWHSE10.ORDERDETAIL ORDERDETAIL

INNER JOIN WMWHSE10.SKU SKU
        ON SKU.SKU=ORDERDETAIL.SKU

LEFT JOIN WMWHSE10.PICKDETAIL PKD
        ON  PKD.ORDERKEY = ORDERDETAIL.ORDERKEY
        AND PKD.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER