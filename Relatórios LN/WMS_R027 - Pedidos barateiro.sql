SELECT ORDERS.whseid                ID_FILIAL,
       CODELKUP.UDF2                DESCR_FILIAL,
       znsls004.t$pecl$c            PEDIDO_SITE,
       ORDERS.referencedocument     ORDEM_LN,
       ORDERS.ORDERKEY              ORDEM_WMS,
       znsls004.t$uneg$c            ID_UNEG,
       ORDERS.SUSR4                 DESCR_UNEG
       
FROM       WMWHSE5.ORDERS 
  
INNER JOIN ENTERPRISE.CODELKUP
        ON UPPER(CODELKUP.UDF1) = ORDERS.whseid

INNER JOIN ( select a.t$orno$c,
                    a.t$pecl$c,
                    a.t$uneg$c
               from baandb.tznsls004301@pln01 a
           group by a.t$orno$c,
                    a.t$pecl$c,
                    a.t$uneg$c ) znsls004 
        ON ZNSLS004.T$ORNO$c = ORDERS.referencedocument
		
WHERE znsls004.t$uneg$c = 13
  AND ORDERS.status < 95
  AND CODELKUP.listname = 'SCHEMA'
  AND znsls004.t$uneg$c IN (:UniNegocio)

  
IIF(Parameters!Table.Value <> "AAA",
  
"SELECT ORDERS.whseid                ID_FILIAL,                                " &
"       CODELKUP.UDF2                DESCR_FILIAL,                             " &
"       znsls004.t$pecl$c            PEDIDO_SITE,                              " &
"       ORDERS.referencedocument     ORDEM_LN,                                 " &
"       ORDERS.ORDERKEY              ORDEM_WMS,                                " &
"       znsls004.t$uneg$c            ID_UNEG,                                  " &
"       ORDERS.SUSR4                 DESCR_UNEG                                " &
"                                                                              " &
"FROM       "+ Parameters!Table.Value + ".ORDERS                               " &
"                                                                              " &
"INNER JOIN ENTERPRISE.CODELKUP                                                " &
"        ON UPPER(CODELKUP.UDF1) = ORDERS.whseid                               " &
"                                                                              " &
"INNER JOIN ( select a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c                                                " &
"               from baandb.tznsls004301@pln01 a                               " &
"           group by a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c ) znsls004                                     " &
"        ON ZNSLS004.T$ORNO$c = ORDERS.referencedocument                       " &
"		                                                                       " &
"WHERE znsls004.t$uneg$c = 13                                                  " &
"  AND ORDERS.status < 95                                                      " &
"  AND CODELKUP.listname = 'SCHEMA'                                            " &
"  AND znsls004.t$uneg$c IN (" + JOIN(Parameters!UniNegocio.Value, ", ") + ")  " &
"                                                                              " &
"ORDER BY 2,3,7                                                                "

,  
  
"SELECT ORDERS.whseid                ID_FILIAL,                                " &
"       CODELKUP.UDF2                DESCR_FILIAL,                             " &
"       znsls004.t$pecl$c            PEDIDO_SITE,                              " &
"       ORDERS.referencedocument     ORDEM_LN,                                 " &
"       ORDERS.ORDERKEY              ORDEM_WMS,                                " &
"       znsls004.t$uneg$c            ID_UNEG,                                  " &
"       ORDERS.SUSR4                 DESCR_UNEG                                " &
"                                                                              " &
"FROM       WMWHSE1.ORDERS                                                     " &
"                                                                              " &
"INNER JOIN ENTERPRISE.CODELKUP                                                " &
"        ON UPPER(CODELKUP.UDF1) = ORDERS.whseid                               " &
"                                                                              " &
"INNER JOIN ( select a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c                                                " &
"               from baandb.tznsls004301@pln01 a                               " &
"           group by a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c ) znsls004                                     " &
"        ON ZNSLS004.T$ORNO$c = ORDERS.referencedocument                       " &
"		                                                                       " &
"WHERE znsls004.t$uneg$c = 13                                                  " &
"  AND ORDERS.status < 95                                                      " &
"  AND CODELKUP.listname = 'SCHEMA'                                            " &
"  AND znsls004.t$uneg$c IN (" + JOIN(Parameters!UniNegocio.Value, ", ") + ")  " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT ORDERS.whseid                ID_FILIAL,                                " &
"       CODELKUP.UDF2                DESCR_FILIAL,                             " &
"       znsls004.t$pecl$c            PEDIDO_SITE,                              " &
"       ORDERS.referencedocument     ORDEM_LN,                                 " &
"       ORDERS.ORDERKEY              ORDEM_WMS,                                " &
"       znsls004.t$uneg$c            ID_UNEG,                                  " &
"       ORDERS.SUSR4                 DESCR_UNEG                                " &
"                                                                              " &
"FROM       WMWHSE2.ORDERS                                                     " &
"                                                                              " &
"INNER JOIN ENTERPRISE.CODELKUP                                                " &
"        ON UPPER(CODELKUP.UDF1) = ORDERS.whseid                               " &
"                                                                              " &
"INNER JOIN ( select a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c                                                " &
"               from baandb.tznsls004301@pln01 a                               " &
"           group by a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c ) znsls004                                     " &
"        ON ZNSLS004.T$ORNO$c = ORDERS.referencedocument                       " &
"		                                                                       " &
"WHERE znsls004.t$uneg$c = 13                                                  " &
"  AND ORDERS.status < 95                                                      " &
"  AND CODELKUP.listname = 'SCHEMA'                                            " &
"  AND znsls004.t$uneg$c IN (" + JOIN(Parameters!UniNegocio.Value, ", ") + ")  " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT ORDERS.whseid                ID_FILIAL,                                " &
"       CODELKUP.UDF2                DESCR_FILIAL,                             " &
"       znsls004.t$pecl$c            PEDIDO_SITE,                              " &
"       ORDERS.referencedocument     ORDEM_LN,                                 " &
"       ORDERS.ORDERKEY              ORDEM_WMS,                                " &
"       znsls004.t$uneg$c            ID_UNEG,                                  " &
"       ORDERS.SUSR4                 DESCR_UNEG                                " &
"                                                                              " &
"FROM       WMWHSE3.ORDERS                                                     " &
"                                                                              " &
"INNER JOIN ENTERPRISE.CODELKUP                                                " &
"        ON UPPER(CODELKUP.UDF1) = ORDERS.whseid                               " &
"                                                                              " &
"INNER JOIN ( select a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c                                                " &
"               from baandb.tznsls004301@pln01 a                               " &
"           group by a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c ) znsls004                                     " &
"        ON ZNSLS004.T$ORNO$c = ORDERS.referencedocument                       " &
"		                                                                       " &
"WHERE znsls004.t$uneg$c = 13                                                  " &
"  AND ORDERS.status < 95                                                      " &
"  AND CODELKUP.listname = 'SCHEMA'                                            " &
"  AND znsls004.t$uneg$c IN (" + JOIN(Parameters!UniNegocio.Value, ", ") + ")  " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT ORDERS.whseid                ID_FILIAL,                                " &
"       CODELKUP.UDF2                DESCR_FILIAL,                             " &
"       znsls004.t$pecl$c            PEDIDO_SITE,                              " &
"       ORDERS.referencedocument     ORDEM_LN,                                 " &
"       ORDERS.ORDERKEY              ORDEM_WMS,                                " &
"       znsls004.t$uneg$c            ID_UNEG,                                  " &
"       ORDERS.SUSR4                 DESCR_UNEG                                " &
"                                                                              " &
"FROM       WMWHSE4.ORDERS                                                     " &
"                                                                              " &
"INNER JOIN ENTERPRISE.CODELKUP                                                " &
"        ON UPPER(CODELKUP.UDF1) = ORDERS.whseid                               " &
"                                                                              " &
"INNER JOIN ( select a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c                                                " &
"               from baandb.tznsls004301@pln01 a                               " &
"           group by a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c ) znsls004                                     " &
"        ON ZNSLS004.T$ORNO$c = ORDERS.referencedocument                       " &
"		                                                                       " &
"WHERE znsls004.t$uneg$c = 13                                                  " &
"  AND ORDERS.status < 95                                                      " &
"  AND CODELKUP.listname = 'SCHEMA'                                            " &
"  AND znsls004.t$uneg$c IN (" + JOIN(Parameters!UniNegocio.Value, ", ") + ")  " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT ORDERS.whseid                ID_FILIAL,                                " &
"       CODELKUP.UDF2                DESCR_FILIAL,                             " &
"       znsls004.t$pecl$c            PEDIDO_SITE,                              " &
"       ORDERS.referencedocument     ORDEM_LN,                                 " &
"       ORDERS.ORDERKEY              ORDEM_WMS,                                " &
"       znsls004.t$uneg$c            ID_UNEG,                                  " &
"       ORDERS.SUSR4                 DESCR_UNEG                                " &
"                                                                              " &
"FROM       WMWHSE5.ORDERS                                                     " &
"                                                                              " &
"INNER JOIN ENTERPRISE.CODELKUP                                                " &
"        ON UPPER(CODELKUP.UDF1) = ORDERS.whseid                               " &
"                                                                              " &
"INNER JOIN ( select a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c                                                " &
"               from baandb.tznsls004301@pln01 a                               " &
"           group by a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c ) znsls004                                     " &
"        ON ZNSLS004.T$ORNO$c = ORDERS.referencedocument                       " &
"		                                                                       " &
"WHERE znsls004.t$uneg$c = 13                                                  " &
"  AND ORDERS.status < 95                                                      " &
"  AND CODELKUP.listname = 'SCHEMA'                                            " &
"  AND znsls004.t$uneg$c IN (" + JOIN(Parameters!UniNegocio.Value, ", ") + ")  " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT ORDERS.whseid                ID_FILIAL,                                " &
"       CODELKUP.UDF2                DESCR_FILIAL,                             " &
"       znsls004.t$pecl$c            PEDIDO_SITE,                              " &
"       ORDERS.referencedocument     ORDEM_LN,                                 " &
"       ORDERS.ORDERKEY              ORDEM_WMS,                                " &
"       znsls004.t$uneg$c            ID_UNEG,                                  " &
"       ORDERS.SUSR4                 DESCR_UNEG                                " &
"                                                                              " &
"FROM       WMWHSE6.ORDERS                                                     " &
"                                                                              " &
"INNER JOIN ENTERPRISE.CODELKUP                                                " &
"        ON UPPER(CODELKUP.UDF1) = ORDERS.whseid                               " &
"                                                                              " &
"INNER JOIN ( select a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c                                                " &
"               from baandb.tznsls004301@pln01 a                               " &
"           group by a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c ) znsls004                                     " &
"        ON ZNSLS004.T$ORNO$c = ORDERS.referencedocument                       " &
"		                                                                       " &
"WHERE znsls004.t$uneg$c = 13                                                  " &
"  AND ORDERS.status < 95                                                      " &
"  AND CODELKUP.listname = 'SCHEMA'                                            " &
"  AND znsls004.t$uneg$c IN (" + JOIN(Parameters!UniNegocio.Value, ", ") + ")  " &
"                                                                              " &
"Union                                                                         " &
"                                                                              " &
"SELECT ORDERS.whseid                ID_FILIAL,                                " &
"       CODELKUP.UDF2                DESCR_FILIAL,                             " &
"       znsls004.t$pecl$c            PEDIDO_SITE,                              " &
"       ORDERS.referencedocument     ORDEM_LN,                                 " &
"       ORDERS.ORDERKEY              ORDEM_WMS,                                " &
"       znsls004.t$uneg$c            ID_UNEG,                                  " &
"       ORDERS.SUSR4                 DESCR_UNEG                                " &
"                                                                              " &
"FROM       WMWHSE7.ORDERS                                                     " &
"                                                                              " &
"INNER JOIN ENTERPRISE.CODELKUP                                                " &
"        ON UPPER(CODELKUP.UDF1) = ORDERS.whseid                               " &
"                                                                              " &
"INNER JOIN ( select a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c                                                " &
"               from baandb.tznsls004301@pln01 a                               " &
"           group by a.t$orno$c,                                               " &
"                    a.t$pecl$c,                                               " &
"                    a.t$uneg$c ) znsls004                                     " &
"        ON ZNSLS004.T$ORNO$c = ORDERS.referencedocument                       " &
"		                                                                       " &
"WHERE znsls004.t$uneg$c = 13                                                  " &
"  AND ORDERS.status < 95                                                      " &
"  AND CODELKUP.listname = 'SCHEMA'                                            " &
"  AND znsls004.t$uneg$c IN (" + JOIN(Parameters!UniNegocio.Value, ", ") + ")  " &
"                                                                              " &
"ORDER BY 2,3,7                                                                "