=

"select WMSADMIN.PL_DB.DB_ALIAS              filial,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(orders.scheduledshipdate,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE)   " &
"                                             dataLimite,  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(orders.orderdate,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                             dataPedido,  " &
"       znsls401.t$entr$c                     pedido_site,   "  &
"       ORDERS.REFERENCEDOCUMENT              pedido_ln,   "  &
"       orders.orderkey                       numeroPedido,  " &
"       tsl.description                       statusPedido,  " &
"       orders.totalqty                       qtdPecas,  " &
"       orders.susr1                          tipoEntrega,  " &
"       orders.susr2                          unidadeNegocio  " &
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
" LEFT JOIN ( select znsls004.t$entr$c,   "  &
"                      znsls004.t$orno$c,   "  &
"                      sq401.t$itpe$c,   "  &
"                      sq401.t$obet$c   "  &
"                 from BAANDB.TZNSLS401301@pln01 sq401,   "  &
"                      baandb.tznsls004301@pln01 znsls004   "  &
"                where sq401.t$ncia$c = znsls004.t$ncia$c   "  &
"                  and sq401.t$uneg$c = znsls004.t$uneg$c   "  &
"                  and sq401.t$pecl$c = znsls004.t$pecl$c   "  &
"                  and sq401.t$sqpd$c = znsls004.t$sqpd$c   "  &
"                  and sq401.t$entr$c = znsls004.t$entr$c   "  &
"                  and sq401.t$sequ$c = znsls004.t$sequ$c   "  &
"             group by znsls004.t$entr$c,   "  &
"                   znsls004.t$orno$c,   "  &
"                   sq401.t$itpe$c,   "  &
"                   sq401.t$obet$c) znsls401   "  &
"          ON znsls401.t$orno$c = ORDERS.REFERENCEDOCUMENT   "  &
"   "  &
"where Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(orders.orderdate,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)) Between '" + Parameters!dataPedidoDe.Value + "'  " &
"      AND '" + Parameters!dataPedidoAte.Value + "'  "
