SELECT
-- para a nike os dados estão na filial WMWHSE10
-- quando migrarmos para produção será necessário mudar para WMWHSE9
-- conforme orientação do Humberto - 21/12/2015
  cast(13 as int)                               CD_CIA,
	ORDERS.ORDERKEY                               NR_PEDIDO_WMS,
	ORDERS.REFERENCELOCATION                      CD_FILIAL,
	ORDERS.WHSEID                                 CD_ARMAZEM,
	' '                                           CD_PROGRAMA, 	              -- *** AGUARDANDO DUVIDA ***
	ORDERS.CONSIGNEEKEY                           CD_PARCEIRO,
	WAVEDETAIL.wavekey                            CD_ONDA,					
	TO_CHAR(OLN.t$entr$c)                         NR_ENTREGA,
	' '                                           CD_RESTRICAO,	              -- *** AGUARDANDO DUVIDA ***
	' '                                           CD_IDENTIFICADO_PRE_VOLUME,	-- *** AGUARDANDO DUVIDA ***
	ORDERS.ROUTE                                  CD_ROTA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDDELVDATE, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)  DT_ESTIMADA_ENTREGA,										
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ORDERDATE, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)  DT_EMISSAO_PEDIDO,											
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ORDERDATE, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)  DT_REGISTRO,														
	ORDERSTATUSSETUP.DESCRIPTION                  DS_SITUACAO,
	(SELECT 																								
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(orderstatushistory.adddate), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE)
        FROM WMWHSE10.orderstatushistory orderstatushistory																		
        WHERE orderstatushistory.ORDERKEY=ORDERS.ORDERKEY
        AND orderstatushistory.STATUS=ORDERSTATUSSETUP.CODE) DT_SITUACAO,
	orders.TOTALQTY                               QT_ITENS,
	orders.CARRIERCODE                            CD_TRANSPORTADORA,
	orders.route                                  CD_CONTRATO_TRANSPORTADORA,
	 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(orders.SCHEDULEDSHIPDATE, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)  DT_LIMITE_EXPEDICAO,
	' '                                           CD_CANAL_VENDA,						-- *** AGUARDANDO DUVIDA ***
	orders.C_ZIP                                  CD_CEP_ENTREGA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(orders.DELIVERYDATE, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)  DT_MINIMA_EXPEDICAO,										
	' '                                           CD_REGIAO,  							-- *** AGUARDANDO DUVIDA ***
  ORDERS.C_VAT                                  CD_MEGA_ROTA,				
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(orders.SCHEDULEDSHIPDATE, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)  DT_LIMITE_ORIGINAL,	
	CAST(0 AS VARCHAR(2))                         CD_ORIGEM_PEDIDO,					-- *** AGUARDANDO DUVIDA ***
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(orders.EDITDATE, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
		AT time zone 'America/Sao_Paulo') AS DATE)  DT_ULT_ATUALIZACAO

FROM 	WMWHSE10.ORDERS ORDERS 

LEFT JOIN WMWHSE10.WAVEDETAIL WAVEDETAIL 
  ON WAVEDETAIL.ORDERKEY=ORDERS.ORDERKEY, 
      
      WMWHSE10.ORDERSTATUSSETUP ORDERSTATUSSETUP,
      
      (select distinct o.t$pecl$c, o.t$entr$c, o.t$orno$c from BAANDB.TZNSLS401601@dln01 o) OLN

WHERE	ORDERSTATUSSETUP.CODE=ORDERS.STATUS
AND   OLN.t$orno$c=ORDERS.REFERENCEDOCUMENT