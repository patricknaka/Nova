SELECT znsls401.t$ncia$c                                CIA,
       znsls401.t$pecl$c                                PEDIDO,
       znsls401.t$entr$c                                ENTREGA,
       znsls401.t$qtve$c                                QTD_PECAS,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)   DATA_VENDA,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtap$c, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)   DATA_PAGTO,   -- o pedido entra pago no LN
       --x znsls401.t$orno$c          ORNO_ZNSLS401,
       -- PedidoWMS.REFERENCEDOCUMENT REFERENCEDOC,
       PedidoWMS.ADDDATE                                DATA_WMS,
       PedidoAuditWMS.ADDDATE                           DATA_CONFERENCIA,
       PedidoWMS.SCHEDULEDSHIPDATE                      DATA_LIMITE,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)   ENTREGA_PROMETIDA,
       znsls410.t$poco$c    PONTO_LN,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)   DATA_PONTO_LN,
       -- PedidoWMS.STATUS            STATUSDEBUG,
       CODELKUP.DESCRIPTION                             PONTO_WMS,
       cisli940.t$docn$l                                NOTA_FISCAL,
       cisli940.t$seri$l                                SERIE_NF,
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)   EMISSAO_NF

FROM      baandb.tznsls401601  znsls401

LEFT JOIN baandb.tznsls400601  znsls400
       ON znsls400.t$ncia$c = znsls401.t$ncia$c
      AND znsls400.t$uneg$c = znsls401.t$uneg$c
      AND znsls400.t$pecl$c = znsls401.t$pecl$c
      AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
      
LEFT JOIN baandb.tcisli245601 cisli245
       ON cisli245.t$slso = znsls401.t$orno$c
      AND cisli245.t$pono = znsls401.t$pono$c
      
LEFT JOIN baandb.tcisli940601  cisli940
       ON cisli940.t$fire$l = cisli245.t$fire$l
      
LEFT JOIN WMWHSE9.ORDERS@DL_LN_WMS PedidoWMS
       ON PedidoWMS.REFERENCEDOCUMENT = znsls401.t$orno$c

LEFT JOIN ( SELECT a.ORDERNUMBER, 
                   max(a.ADDDATE) as ADDDATE
              FROM WMWHSE9.ORDERINVOICEAUDIT@DL_LN_WMS a 
             WHERE a.INVOICESTATUS = 4      -- conferencia concluida
          GROUP BY a.ORDERNUMBER ) PedidoAuditWMS 
       ON PedidoAuditWMS.ORDERNUMBER = PedidoWMS.ORDERKEY

LEFT JOIN ( select znsls410int.t$ncia$c,      
                   znsls410int.t$uneg$c,
                   znsls410int.t$pecl$c,
                   znsls410int.t$entr$c,
                   znsls410int.t$sqpd$c,
                   max(znsls410int.t$dtoc$c) t$dtoc$c,
                   MAX(znsls410int.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410int.T$DTOC$C,  znsls410int.T$SEQN$C)t$poco$c
              from baandb.tznsls410601 znsls410int
          group by znsls410int.t$ncia$c,      
                   znsls410int.t$uneg$c,
                   znsls410int.t$pecl$c,
                   znsls410int.t$entr$c,
                   znsls410int.t$sqpd$c ) znsls410
       ON znsls410.t$ncia$c = znsls401.t$ncia$c
      AND znsls410.t$uneg$c = znsls401.t$uneg$c
      AND znsls410.t$pecl$c = znsls401.t$pecl$c
      AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
      AND znsls410.t$entr$c = znsls401.t$entr$c 

LEFT JOIN WMWHSE9.CODELKUP@DL_LN_WMS 
       ON LISTNAME = 'OBACTSTSOH' 
      AND CODE = PedidoWMS.STATUS

WHERE znsls401.t$qtve$c > 0
  AND PedidoAuditWMS.ADDDATE 
      Between :ConferenciaDe 
          And :ConferenciaAte


" SELECT znsls401.t$ncia$c                                CIA,  " &
"        znsls401.t$pecl$c                                PEDIDO,  " &
"        znsls401.t$entr$c                                ENTREGA,  " &
"        znsls401.t$qtve$c                                QTD_PECAS,  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE)   DATA_VENDA,  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtap$c,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE)   DATA_PAGTO,  " &
"        PedidoWMS.ADDDATE                                DATA_WMS,  " &
"        PedidoAuditWMS.ADDDATE                           DATA_CONFERENCIA,  " &
"        PedidoWMS.SCHEDULEDSHIPDATE                      DATA_LIMITE,  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE)   ENTREGA_PROMETIDA,  " &
"        znsls410.t$poco$c    PONTO_LN,  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE)   DATA_PONTO_LN,  " &
"        CODELKUP.DESCRIPTION                             PONTO_WMS,  " &
"        cisli940.t$docn$l                                NOTA_FISCAL,  " &
"        cisli940.t$seri$l                                SERIE_NF,  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE)   EMISSAO_NF  " &
"  " &
" FROM      baandb.tznsls401" + Parameters!Compania.Value + "  znsls401  " &
"  " &
" LEFT JOIN baandb.tznsls400" + Parameters!Compania.Value + "  znsls400  " &
"        ON znsls400.t$ncia$c = znsls401.t$ncia$c  " &
"       AND znsls400.t$uneg$c = znsls401.t$uneg$c  " &
"       AND znsls400.t$pecl$c = znsls401.t$pecl$c  " &
"       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c  " &
"  " &
" LEFT JOIN baandb.tcisli245" + Parameters!Compania.Value + " cisli245  " &
"        ON cisli245.t$slso = znsls401.t$orno$c  " &
"       AND cisli245.t$pono = znsls401.t$pono$c  " &
"  " &
" LEFT JOIN baandb.tcisli940" + Parameters!Compania.Value + "  cisli940  " &
"        ON cisli940.t$fire$l = cisli245.t$fire$l  " &
"  " &
" LEFT JOIN " + IIF(Parameters!Compania.Value = 601, "WMWHSE9", "WMWHSE10") + ".ORDERS@DL_LN_WMS PedidoWMS  " &
"        ON PedidoWMS.REFERENCEDOCUMENT = znsls401.t$orno$c  " &
"  " &
" LEFT JOIN ( SELECT a.ORDERNUMBER,  " &
"                    max(a.ADDDATE) as ADDDATE  " &
"               FROM " + IIF(Parameters!Compania.Value = 601, "WMWHSE9", "WMWHSE10") + ".ORDERINVOICEAUDIT@DL_LN_WMS a  " &
"              WHERE a.INVOICESTATUS = 4  " &
"           GROUP BY a.ORDERNUMBER ) PedidoAuditWMS  " &
"        ON PedidoAuditWMS.ORDERNUMBER = PedidoWMS.ORDERKEY  " &
"  " &
" LEFT JOIN ( select znsls410int.t$ncia$c,  " &
"                    znsls410int.t$uneg$c,  " &
"                    znsls410int.t$pecl$c,  " &
"                    znsls410int.t$entr$c,  " &
"                    znsls410int.t$sqpd$c,  " &
"                    max(znsls410int.t$dtoc$c) t$dtoc$c,  " &
"                    MAX(znsls410int.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410int.T$DTOC$C,  " &
"                                                                             znsls410int.T$SEQN$C)t$poco$c  " &
"               from baandb.tznsls410" + Parameters!Compania.Value + " znsls410int  " &
"           group by znsls410int.t$ncia$c,  " &
"                    znsls410int.t$uneg$c,  " &
"                    znsls410int.t$pecl$c,  " &
"                    znsls410int.t$entr$c,  " &
"                    znsls410int.t$sqpd$c ) znsls410  " &
"        ON znsls410.t$ncia$c = znsls401.t$ncia$c  " &
"       AND znsls410.t$uneg$c = znsls401.t$uneg$c  " &
"       AND znsls410.t$pecl$c = znsls401.t$pecl$c  " &
"       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c  " &
"       AND znsls410.t$entr$c = znsls401.t$entr$c  " &
"  " &
" LEFT JOIN " + IIF(Parameters!Compania.Value = 601, "WMWHSE9", "WMWHSE10") + ".CODELKUP@DL_LN_WMS  " &
"        ON LISTNAME = 'OBACTSTSOH'  " &
"       AND CODE = PedidoWMS.STATUS  " &
"  " &
" WHERE znsls401.t$qtve$c > 0  " &
"   AND PedidoAuditWMS.ADDDATE  " &
"       Between :ConferenciaDe  " &
"           And :ConferenciaAte  " &
"  " &
