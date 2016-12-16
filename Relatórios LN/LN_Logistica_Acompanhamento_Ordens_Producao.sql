select  
        znsls401.t$pecl$c                       PEDIDO_SITE,
        cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ORDERDATE, 
                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                             AT time zone 'America/Sao_Paulo') as date)
                                                DATA_REGISTRO_OP,
        cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, 
                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                             AT time zone 'America/Sao_Paulo') as date)
                                                DATA_LIMITE_OP,
        case when to_char(to_date(tdsls400.t$prdt), 'yyyy') = 1969 then null 
             when to_char(to_date(tdsls400.t$prdt), 'yyyy') = 1970 then null 
        else
             cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt, 
                                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                  AT time zone 'America/Sao_Paulo') as date)
        end                                     DATA_LIMITE_FINAL,
        tisfc001.t$pdno                         NUMERO_OP,
        ORDERSTATUSSETUP.DESCRIPTION            EVENTO,
        cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                             AT time zone 'America/Sao_Paulo') as date)
                                                DATA_ULTIMO_EVENTO,
        znsls430.CUSTOM_1                       CUSTOMIZACAO_1,
        znsls430.CUSTOM_2                       CUSTOMIZACAO_2,
        znsls430.CUSTOM_3                       CUSTOMIZACAO_3,
        znsls430.CUSTOM_4                       CUSTOMIZACAO_4

from    baandb.tznsls401601 znsls401

inner join baandb.ttdsls400601 tdsls400
        on tdsls400.t$orno = znsls401.t$orno$c

inner join baandb.ttcmcs065601 tcmcs065
        on tcmcs065.t$cwoc = tdsls400.t$cofc

inner join baandb.ttccom130601 tccom130
        on tccom130.t$cadr = tcmcs065.t$cadr

inner join baandb.tznfmd001601 znfmd001
        on znfmd001.t$fovn$c = tccom130.t$fovn$l

inner join baandb.tznsls420601 znsls420
        on znsls420.t$ncia$c = znsls401.t$ncia$c
       and znsls420.t$uneg$c = znsls401.t$uneg$c
       and znsls420.t$pecl$c = znsls401.t$pecl$c
       and znsls420.t$sqpd$c = znsls401.t$sqpd$c
       and znsls420.t$entr$c = znsls401.t$entr$c
       and znsls420.t$sequ$c = znsls401.t$sequ$c

inner join baandb.ttisfc001601 tisfc001
        on tisfc001.t$pdno = znsls420.t$pdno$c

left join  WMWHSE9.ORDERS@DL_LN_WMS
       on  SUBSTR(ORDERS.REFERENCEDOCUMENT,3,9) = znsls420.t$pdno$c

left join  WMWHSE9.ORDERSTATUSSETUP@DL_LN_WMS
       on  ORDERSTATUSSETUP.CODE = ORDERS.STATUS

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$sequ$c,
                   a.t$cosq$c,
                   a.t$codc$c   CUSTOM_1
            from baandb.tznsls430601 a ) znsls430
       on znsls430.t$ncia$c = znsls420.t$ncia$c
      and znsls430.t$uneg$c = znsls420.t$uneg$c
      and znsls430.t$pecl$c = znsls420.t$pecl$c
      and znsls430.t$sqpd$c = znsls420.t$sqpd$c
      and znsls430.t$entr$c = znsls420.t$entr$c
      and znsls430.t$sequ$c = znsls420.t$sequ$c
      and znsls430.t$cosq$c = 1

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$sequ$c,
                   a.t$cosq$c,
                   a.t$codc$c   CUSTOM_2
            from baandb.tznsls430601 a ) znsls430
       on znsls430.t$ncia$c = znsls420.t$ncia$c
      and znsls430.t$uneg$c = znsls420.t$uneg$c
      and znsls430.t$pecl$c = znsls420.t$pecl$c
      and znsls430.t$sqpd$c = znsls420.t$sqpd$c
      and znsls430.t$entr$c = znsls420.t$entr$c
      and znsls430.t$sequ$c = znsls420.t$sequ$c
      and znsls430.t$cosq$c = 2

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$sequ$c,
                   a.t$cosq$c,
                   a.t$codc$c   CUSTOM_3
            from baandb.tznsls430601 a ) znsls430
       on znsls430.t$ncia$c = znsls420.t$ncia$c
      and znsls430.t$uneg$c = znsls420.t$uneg$c
      and znsls430.t$pecl$c = znsls420.t$pecl$c
      and znsls430.t$sqpd$c = znsls420.t$sqpd$c
      and znsls430.t$entr$c = znsls420.t$entr$c
      and znsls430.t$sequ$c = znsls420.t$sequ$c
      and znsls430.t$cosq$c = 3

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   a.t$sequ$c,
                   a.t$cosq$c,
                   a.t$codc$c   CUSTOM_4
            from baandb.tznsls430601 a ) znsls430
       on znsls430.t$ncia$c = znsls420.t$ncia$c
      and znsls430.t$uneg$c = znsls420.t$uneg$c
      and znsls430.t$pecl$c = znsls420.t$pecl$c
      and znsls430.t$sqpd$c = znsls420.t$sqpd$c
      and znsls430.t$entr$c = znsls420.t$entr$c
      and znsls430.t$sequ$c = znsls420.t$sequ$c
      and znsls430.t$cosq$c = 4

where   znfmd001.t$dsca$c in (:PLANTA)                                  
and     trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ACTUALSHIPDATE, 
                           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                             AT time zone 'America/Sao_Paulo') as date))
            between :DATA_ULTIMO_EVENTO_DE and :DATA_ULTIMO_EVENTO_ATE
and     znsls401.t$itpe$c in (:TIPO_ENTREGA)
and     ORDERSTATUSSETUP.CODE in (:TIPO_EVENTO)
order by  znsls401.t$pecl$c, tisfc001.t$pdno
