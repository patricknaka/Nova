
"select WMSADMIN.PL_DB.DB_ALIAS as filial,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(orders.scheduledshipdate,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE) as dataLimite,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(orders.orderdate,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE) as dataPedido,  " &
"       orders.orderkey as numeroPedido,  " &
"       tsl.description as statusPedido,  " &
"       orders.totalqty as qtdPecas,  " &
"       orders.susr1 as tipoEntrega,  " &
"       orders.susr2 as unidadeNegocio  " &
"  " &
"from  " + Parameters!Table.Value + ".orders orders  " &
"  " &
"LEFT JOIN " + Parameters!Table.Value + ".CODELKUP cc  " &
"       ON cc.listname = 'NOVAORDSTS'  " &
"      AND cc.code = orders.novastatus  " &
"  " &
"LEFT JOIN " + Parameters!Table.Value + ".TRANSLATIONLIST tsl  " &
"       ON tsl.tblname = 'CODELKUP'  " &
"      AND tsl.locale = 'pt'  " &
"      AND tsl.code = cc.code  " &
"      AND tsl.joinkey1 = cc.listname  " &
"  " &
"LEFT JOIN WMSADMIN.PL_DB  " &
"        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID  " &
"  " &
"where Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(orders.orderdate,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!dataPedidoDe.Value + "'  " &
"      AND '" + Parameters!dataPedidoAte.Value + "'  "
