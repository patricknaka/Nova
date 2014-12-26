SELECT
  WD.WAVEKEY                ONDA,
  OC.ORDERKEY               ORDEM_WMS,
  LN.T$PECL$C               PEDIDO,
  LN.T$ENTR$C               ENTREGA,
  OD.SKU                    ID_ITEM,
  SK.DESCR                  DESCR_ITEM,
  sum(OD.QTYPICKED)         QTD_SEPARADA,
  sum(OD.ORIGINALQTY)       QTD_ROMANEADA,
  sum(CASE WHEN TD.FROMLOC='STAGE' THEN TD.QTY ELSE 0 END)
                            QT_DOCE,
  sum(CASE WHEN TD.FROMLOC='PICKTO' THEN TD.QTY ELSE 0 END)
                            QT_DSAI,
  sum(CASE WHEN (TD.FROMLOC='STAGE' OR TD.FROMLOC = 'PICKTO')
   THEN 0
   WHEN substr(TD.FROMLOC, LENGTH(TD.FROMLOC)-1, 2) >= 03
   THEN TD.QTY ELSE 0 END)  QT_VERT
FROM       WMWHSE5.ORDERDETAIL OD
INNER JOIN WMWHSE5.ORDERS OC
        ON OC.ORDERKEY = OD.ORDERKEY
INNER JOIN WMWHSE5.WAVEDETAIL WD
        ON WD.ORDERKEY = OC.ORDERKEY
INNER JOIN WMWHSE5.SKU SK
        ON SK.SKU = OD.SKU
INNER JOIN WMWHSE5.TASKDETAIL TD
        ON TD.ORDERKEY = OD.ORDERKEY
 LEFT JOIN ( select a.t$pecl$c,
                    a.t$entr$c,
                    a.t$orno$c
               from baandb.tznsls004301@pln01 a
           group by a.t$pecl$c,
                    a.t$entr$c,
                    a.t$orno$c ) LN
        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT
WHERE OD.STATUS = '06'
GROUP BY WD.WAVEKEY,
        OC.ORDERKEY,
        LN.T$PECL$C,
        LN.T$ENTR$C,
        OD.SKU,
        SK.DESCR
		
		
=IIF(Parameters!Table.Value <> "AAA",                         
   
"SELECT                                                              " &
"  WD.WAVEKEY                ONDA,                                   " &
"  OC.ORDERKEY               ORDEM_WMS,                              " &
"  LN.T$PECL$C               PEDIDO,                                 " &
"  LN.T$ENTR$C               ENTREGA,                                " &
"  OD.SKU                    ID_ITEM,                                " &
"  SK.DESCR                  DESCR_ITEM,                             " &
"  sum(OD.QTYPICKED)         QTD_SEPARADA,                           " &
"  sum(OD.ORIGINALQTY)       QTD_ROMANEADA,                          " &
"  sum(CASE WHEN TD.FROMLOC='STAGE' THEN TD.QTY ELSE 0 END)          " &
"                            QT_DOCE,                                " &
"  sum(CASE WHEN TD.FROMLOC='PICKTO' THEN TD.QTY ELSE 0 END)         " &
"                            QT_DSAI,                                " &
"  sum(CASE WHEN (TD.FROMLOC='STAGE' OR TD.FROMLOC = 'PICKTO')       " &
"   THEN 0                                                           " &
"   WHEN substr(TD.FROMLOC, LENGTH(TD.FROMLOC)-1, 2) >= 03           " &
"   THEN TD.QTY ELSE 0 END)  QT_VERT                                 " &
"FROM       " + Parameters!Table.Value + ".ORDERDETAIL OD            " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERS OC                 " &
"        ON OC.ORDERKEY = OD.ORDERKEY                                " &
"INNER JOIN " + Parameters!Table.Value + ".WAVEDETAIL WD             " &
"        ON WD.ORDERKEY = OC.ORDERKEY                                " &
"INNER JOIN " + Parameters!Table.Value + ".SKU SK                    " &
"        ON SK.SKU = OD.SKU                                          " &
"INNER JOIN " + Parameters!Table.Value + ".TASKDETAIL TD             " &
"        ON TD.ORDERKEY = OD.ORDERKEY                                " &
" LEFT JOIN ( select a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c                                      " &
"               from baandb.tznsls004301@pln01 a                     " &
"           group by a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c ) LN                                 " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                       " &
"WHERE OD.STATUS = '06'                                              " &
"GROUP BY WD.WAVEKEY,                                                " &
"        OC.ORDERKEY,                                                " &
"        LN.T$PECL$C,                                                " &
"        LN.T$ENTR$C,                                                " &
"        OD.SKU,                                                     " &
"        SK.DESCR                                                    " &
"ORDER BY PEDIDO, ENTREGA                                            "
                                                                    
,
                                                                    
"SELECT                                                              " &
"  WD.WAVEKEY                ONDA,                                   " &
"  OC.ORDERKEY               ORDEM_WMS,                              " &
"  LN.T$PECL$C               PEDIDO,                                 " &
"  LN.T$ENTR$C               ENTREGA,                                " &
"  OD.SKU                    ID_ITEM,                                " &
"  SK.DESCR                  DESCR_ITEM,                             " &
"  sum(OD.QTYPICKED)         QTD_SEPARADA,                           " &
"  sum(OD.ORIGINALQTY)       QTD_ROMANEADA,                          " &
"  sum(CASE WHEN TD.FROMLOC='STAGE' THEN TD.QTY ELSE 0 END)          " &
"                            QT_DOCE,                                " &
"  sum(CASE WHEN TD.FROMLOC='PICKTO' THEN TD.QTY ELSE 0 END)         " &
"                            QT_DSAI,                                " &
"  sum(CASE WHEN (TD.FROMLOC='STAGE' OR TD.FROMLOC = 'PICKTO')       " &
"   THEN 0                                                           " &
"   WHEN substr(TD.FROMLOC, LENGTH(TD.FROMLOC)-1, 2) >= 03           " &
"   THEN TD.QTY ELSE 0 END)  QT_VERT                                 " &
"FROM       WMWHSE1.ORDERDETAIL OD                                   " &
"INNER JOIN WMWHSE1.ORDERS OC                                        " &
"        ON OC.ORDERKEY = OD.ORDERKEY                                " &
"INNER JOIN WMWHSE1.WAVEDETAIL WD                                    " &
"        ON WD.ORDERKEY = OC.ORDERKEY                                " &
"INNER JOIN WMWHSE1.SKU SK                                           " &
"        ON SK.SKU = OD.SKU                                          " &
"INNER JOIN WMWHSE1.TASKDETAIL TD                                    " &
"        ON TD.ORDERKEY = OD.ORDERKEY                                " &
" LEFT JOIN ( select a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c                                      " &
"               from baandb.tznsls004301@pln01 a                     " &
"           group by a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c ) LN                                 " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                       " &
"WHERE OD.STATUS = '06'                                              " &
"GROUP BY WD.WAVEKEY,                                                " &
"        OC.ORDERKEY,                                                " &
"        LN.T$PECL$C,                                                " &
"        LN.T$ENTR$C,                                                " &
"        OD.SKU,                                                     " &
"        SK.DESCR                                                    " &
"                                                                    " &
"UNION                                                               " &
"                                                                    " &
"SELECT                                                              " &
"  WD.WAVEKEY                ONDA,                                   " &
"  OC.ORDERKEY               ORDEM_WMS,                              " &
"  LN.T$PECL$C               PEDIDO,                                 " &
"  LN.T$ENTR$C               ENTREGA,                                " &
"  OD.SKU                    ID_ITEM,                                " &
"  SK.DESCR                  DESCR_ITEM,                             " &
"  sum(OD.QTYPICKED)         QTD_SEPARADA,                           " &
"  sum(OD.ORIGINALQTY)       QTD_ROMANEADA,                          " &
"  sum(CASE WHEN TD.FROMLOC='STAGE' THEN TD.QTY ELSE 0 END)          " &
"                            QT_DOCE,                                " &
"  sum(CASE WHEN TD.FROMLOC='PICKTO' THEN TD.QTY ELSE 0 END)         " &
"                            QT_DSAI,                                " &
"  sum(CASE WHEN (TD.FROMLOC='STAGE' OR TD.FROMLOC = 'PICKTO')       " &
"   THEN 0                                                           " &
"   WHEN substr(TD.FROMLOC, LENGTH(TD.FROMLOC)-1, 2) >= 03           " &
"   THEN TD.QTY ELSE 0 END)  QT_VERT                                 " &
"FROM       WMWHSE2.ORDERDETAIL OD                                   " &
"INNER JOIN WMWHSE2.ORDERS OC                                        " &
"        ON OC.ORDERKEY = OD.ORDERKEY                                " &
"INNER JOIN WMWHSE2.WAVEDETAIL WD                                    " &
"        ON WD.ORDERKEY = OC.ORDERKEY                                " &
"INNER JOIN WMWHSE2.SKU SK                                           " &
"        ON SK.SKU = OD.SKU                                          " &
"INNER JOIN WMWHSE2.TASKDETAIL TD                                    " &
"        ON TD.ORDERKEY = OD.ORDERKEY                                " &
" LEFT JOIN ( select a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                     a.t$orno$c                                     " &
"               from baandb.tznsls004301@pln01 a                     " &
"           group by a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c ) LN                                 " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                       " &
"WHERE OD.STATUS = '06'                                              " &
"GROUP BY WD.WAVEKEY,                                                " &
"        OC.ORDERKEY,                                                " &
"        LN.T$PECL$C,                                                " &
"        LN.T$ENTR$C,                                                " &
"        OD.SKU,                                                     " &
"        SK.DESCR                                                    " &
"                                                                    " &
"UNION                                                               " &
"                                                                    " &
"SELECT                                                              " &
"  WD.WAVEKEY                ONDA,                                   " &
"  OC.ORDERKEY               ORDEM_WMS,                              " &
"  LN.T$PECL$C               PEDIDO,                                 " &
"  LN.T$ENTR$C               ENTREGA,                                " &
"  OD.SKU                    ID_ITEM,                                " &
"  SK.DESCR                  DESCR_ITEM,                             " &
"  sum(OD.QTYPICKED)         QTD_SEPARADA,                           " &
"  sum(OD.ORIGINALQTY)       QTD_ROMANEADA,                          " &
"  sum(CASE WHEN TD.FROMLOC='STAGE' THEN TD.QTY ELSE 0 END)          " &
"                            QT_DOCE,                                " &
"  sum(CASE WHEN TD.FROMLOC='PICKTO' THEN TD.QTY ELSE 0 END)         " &
"                            QT_DSAI,                                " &
"  sum(CASE WHEN (TD.FROMLOC='STAGE' OR TD.FROMLOC = 'PICKTO')       " &
"   THEN 0                                                           " &
"   WHEN substr(TD.FROMLOC, LENGTH(TD.FROMLOC)-1, 2) >= 03           " &
"   THEN TD.QTY ELSE 0 END)  QT_VERT                                 " &
"FROM       WMWHSE3.ORDERDETAIL OD                                   " &
"INNER JOIN WMWHSE3.ORDERS OC                                        " &
"        ON OC.ORDERKEY = OD.ORDERKEY                                " &
"INNER JOIN WMWHSE3.WAVEDETAIL WD                                    " &
"        ON WD.ORDERKEY = OC.ORDERKEY                                " &
"INNER JOIN WMWHSE3.SKU SK                                           " &
"        ON SK.SKU = OD.SKU                                          " &
"INNER JOIN WMWHSE3.TASKDETAIL TD                                    " &
"        ON TD.ORDERKEY = OD.ORDERKEY                                " &
" LEFT JOIN ( select a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c                                      " &
"               from baandb.tznsls004301@pln01 a                     " &
"           group by a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c ) LN                                 " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                       " &
"WHERE OD.STATUS = '06'                                              " &
"GROUP BY WD.WAVEKEY,                                                " &
"        OC.ORDERKEY,                                                " &
"        LN.T$PECL$C,                                                " &
"        LN.T$ENTR$C,                                                " &
"        OD.SKU,                                                     " &
"        SK.DESCR                                                    " &
"                                                                    " &
"UNION                                                               " &
"                                                                    " &
"SELECT                                                              " &
"  WD.WAVEKEY                ONDA,                                   " &
"  OC.ORDERKEY               ORDEM_WMS,                              " &
"  LN.T$PECL$C               PEDIDO,                                 " &
"  LN.T$ENTR$C               ENTREGA,                                " &
"  OD.SKU                    ID_ITEM,                                " &
"  SK.DESCR                  DESCR_ITEM,                             " &
"  sum(OD.QTYPICKED)         QTD_SEPARADA,                           " &
"  sum(OD.ORIGINALQTY)       QTD_ROMANEADA,                          " &
"  sum(CASE WHEN TD.FROMLOC='STAGE' THEN TD.QTY ELSE 0 END)          " &
"                            QT_DOCE,                                " &
"  sum(CASE WHEN TD.FROMLOC='PICKTO' THEN TD.QTY ELSE 0 END)         " &
"                            QT_DSAI,                                " &
"  sum(CASE WHEN (TD.FROMLOC='STAGE' OR TD.FROMLOC = 'PICKTO')       " &
"   THEN 0                                                           " &
"   WHEN substr(TD.FROMLOC, LENGTH(TD.FROMLOC)-1, 2) >= 03           " &
"   THEN TD.QTY ELSE 0 END)  QT_VERT                                 " &
"FROM       WMWHSE4.ORDERDETAIL OD                                   " &
"INNER JOIN WMWHSE4.ORDERS OC                                        " &
"        ON OC.ORDERKEY = OD.ORDERKEY                                " &
"INNER JOIN WMWHSE4.WAVEDETAIL WD                                    " &
"        ON WD.ORDERKEY = OC.ORDERKEY                                " &
"INNER JOIN WMWHSE4.SKU SK                                           " &
"        ON SK.SKU = OD.SKU                                          " &
"INNER JOIN WMWHSE4.TASKDETAIL TD                                    " &
"        ON TD.ORDERKEY = OD.ORDERKEY                                " &
" LEFT JOIN ( select a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c                                      " &
"               from baandb.tznsls004301@pln01 a                     " &
"           group by a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c ) LN                                 " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                       " &
"WHERE OD.STATUS = '06'                                              " &
"GROUP BY WD.WAVEKEY,                                                " &
"        OC.ORDERKEY,                                                " &
"        LN.T$PECL$C,                                                " &
"        LN.T$ENTR$C,                                                " &
"        OD.SKU,                                                     " &
"        SK.DESCR                                                    " &
"                                                                    " &
"UNION                                                               " &
"                                                                    " &
"SELECT                                                              " &
"  WD.WAVEKEY                ONDA,                                   " &
"  OC.ORDERKEY               ORDEM_WMS,                              " &
"  LN.T$PECL$C               PEDIDO,                                 " &
"  LN.T$ENTR$C               ENTREGA,                                " &
"  OD.SKU                    ID_ITEM,                                " &
"  SK.DESCR                  DESCR_ITEM,                             " &
"  sum(OD.QTYPICKED)         QTD_SEPARADA,                           " &
"  sum(OD.ORIGINALQTY)       QTD_ROMANEADA,                          " &
"  sum(CASE WHEN TD.FROMLOC='STAGE' THEN TD.QTY ELSE 0 END)          " &
"                            QT_DOCE,                                " &
"  sum(CASE WHEN TD.FROMLOC='PICKTO' THEN TD.QTY ELSE 0 END)         " &
"                            QT_DSAI,                                " &
"  sum(CASE WHEN (TD.FROMLOC='STAGE' OR TD.FROMLOC = 'PICKTO')       " &
"   THEN 0                                                           " &
"   WHEN substr(TD.FROMLOC, LENGTH(TD.FROMLOC)-1, 2) >= 03           " &
"   THEN TD.QTY ELSE 0 END)  QT_VERT                                 " &
"FROM       WMWHSE5.ORDERDETAIL OD                                   " &
"INNER JOIN WMWHSE5.ORDERS OC                                        " &
"        ON OC.ORDERKEY = OD.ORDERKEY                                " &
"INNER JOIN WMWHSE5.WAVEDETAIL WD                                    " &
"        ON WD.ORDERKEY = OC.ORDERKEY                                " &
"INNER JOIN WMWHSE5.SKU SK                                           " &
"        ON SK.SKU = OD.SKU                                          " &
"INNER JOIN WMWHSE5.TASKDETAIL TD                                    " &
"        ON TD.ORDERKEY = OD.ORDERKEY                                " &
" LEFT JOIN ( select a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c                                      " &
"               from baandb.tznsls004301@pln01 a                     " &
"           group by a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c ) LN                                 " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                       " &
"WHERE OD.STATUS = '06'                                              " &
"GROUP BY WD.WAVEKEY,                                                " &
"        OC.ORDERKEY,                                                " &
"        LN.T$PECL$C,                                                " &
"        LN.T$ENTR$C,                                                " &
"        OD.SKU,                                                     " &
"        SK.DESCR                                                    " &
"                                                                    " &
"UNION                                                               " &
"                                                                    " &
"SELECT                                                              " &
"  WD.WAVEKEY                ONDA,                                   " &
"  OC.ORDERKEY               ORDEM_WMS,                              " &
"  LN.T$PECL$C               PEDIDO,                                 " &
"  LN.T$ENTR$C               ENTREGA,                                " &
"  OD.SKU                    ID_ITEM,                                " &
"  SK.DESCR                  DESCR_ITEM,                             " &
"  sum(OD.QTYPICKED)         QTD_SEPARADA,                           " &
"  sum(OD.ORIGINALQTY)       QTD_ROMANEADA,                          " &
"  sum(CASE WHEN TD.FROMLOC='STAGE' THEN TD.QTY ELSE 0 END)          " &
"                            QT_DOCE,                                " &
"  sum(CASE WHEN TD.FROMLOC='PICKTO' THEN TD.QTY ELSE 0 END)         " &
"                            QT_DSAI,                                " &
"  sum(CASE WHEN (TD.FROMLOC='STAGE' OR TD.FROMLOC = 'PICKTO')       " &
"   THEN 0                                                           " &
"   WHEN substr(TD.FROMLOC, LENGTH(TD.FROMLOC)-1, 2) >= 03           " &
"   THEN TD.QTY ELSE 0 END)  QT_VERT                                 " &
"FROM       WMWHSE6.ORDERDETAIL OD                                   " &
"INNER JOIN WMWHSE6.ORDERS OC                                        " &
"        ON OC.ORDERKEY = OD.ORDERKEY                                " &
"INNER JOIN WMWHSE6.WAVEDETAIL WD                                    " &
"        ON WD.ORDERKEY = OC.ORDERKEY                                " &
"INNER JOIN WMWHSE6.SKU SK                                           " &
"        ON SK.SKU = OD.SKU                                          " &
"INNER JOIN WMWHSE6.TASKDETAIL TD                                    " &
"        ON TD.ORDERKEY = OD.ORDERKEY                                " &
" LEFT JOIN ( select a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c                                      " &
"               from baandb.tznsls004301@pln01 a                     " &
"           group by a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c ) LN                                 " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                       " &
"WHERE OD.STATUS = '06'                                              " &
"GROUP BY WD.WAVEKEY,                                                " &
"        OC.ORDERKEY,                                                " &
"        LN.T$PECL$C,                                                " &
"        LN.T$ENTR$C,                                                " &
"        OD.SKU,                                                     " &
"        SK.DESCR                                                    " &
"                                                                    " &
"UNION                                                               " &
"                                                                    " &
"SELECT                                                              " &
"  WD.WAVEKEY                ONDA,                                   " &
"  OC.ORDERKEY               ORDEM_WMS,                              " &
"  LN.T$PECL$C               PEDIDO,                                 " &
"  LN.T$ENTR$C               ENTREGA,                                " &
"  OD.SKU                    ID_ITEM,                                " &
"  SK.DESCR                  DESCR_ITEM,                             " &
"  sum(OD.QTYPICKED)         QTD_SEPARADA,                           " &
"  sum(OD.ORIGINALQTY)       QTD_ROMANEADA,                          " &
"  sum(CASE WHEN TD.FROMLOC='STAGE' THEN TD.QTY ELSE 0 END)          " &
"                            QT_DOCE,                                " &
"  sum(CASE WHEN TD.FROMLOC='PICKTO' THEN TD.QTY ELSE 0 END)         " &
"                            QT_DSAI,                                " &
"  sum(CASE WHEN (TD.FROMLOC='STAGE' OR TD.FROMLOC = 'PICKTO')       " &
"   THEN 0                                                           " &
"   WHEN substr(TD.FROMLOC, LENGTH(TD.FROMLOC)-1, 2) >= 03           " &
"   THEN TD.QTY ELSE 0 END)  QT_VERT                                 " &
"FROM       WMWHSE7.ORDERDETAIL OD                                   " &
"INNER JOIN WMWHSE7.ORDERS OC                                        " &
"        ON OC.ORDERKEY = OD.ORDERKEY                                " &
"INNER JOIN WMWHSE7.WAVEDETAIL WD                                    " &
"        ON WD.ORDERKEY = OC.ORDERKEY                                " &
"INNER JOIN WMWHSE7.SKU SK                                           " &
"        ON SK.SKU = OD.SKU                                          " &
"INNER JOIN WMWHSE7.TASKDETAIL TD                                    " &
"        ON TD.ORDERKEY = OD.ORDERKEY                                " &
" LEFT JOIN ( select a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c                                      " &
"               from baandb.tznsls004301@pln01 a                     " &
"           group by a.t$pecl$c,                                     " &
"                    a.t$entr$c,                                     " &
"                    a.t$orno$c ) LN                                 " &
"        ON LN.T$ORNO$C = OC.REFERENCEDOCUMENT                       " &
"WHERE OD.STATUS = '06'                                              " &
"GROUP BY WD.WAVEKEY,                                                " &
"        OC.ORDERKEY,                                                " &
"        LN.T$PECL$C,                                                " &
"        LN.T$ENTR$C,                                                " &
"        OD.SKU,                                                     " &
"        SK.DESCR                                                    " &
"ORDER BY PEDIDO, ENTREGA                                            "
)