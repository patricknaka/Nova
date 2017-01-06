select
        ORD_ARM.ORIGEM_ORDEM                         ORIGEM_ORDEM,
        whinh200.t$orno                              ORDEM,
        ORD_ARM.TIPO_TRANSACAO                       TIPO_TRANSACAO,
        ORD_ARM.STATUS                               STATUS,
        cast((from_tz(to_timestamp(to_char(whinh200.t$pddt,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
                                                     DT_ENTRADA,
        cast((from_tz(to_timestamp(to_char(whinh200.t$prdt,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
                                                     DT_RECEBIMENTO,
        znfmd001.t$dsca$c                            FILIAL,
        whinh220.t$item                              ITEM,
        whinh220.t$qord                              QUANTIDADE

from    baandb.twhinh200601 whinh200

inner join baandb.ttcmcs065601 tcmcs065
        on tcmcs065.t$cwoc = whinh200.t$wdep

inner join  (select a.t$fovn$l,
                    a.t$cadr
             from   baandb.ttccom130601 a) tccom130
        on  tccom130.t$cadr = tcmcs065.t$cadr

inner join baandb.tznfmd001601 znfmd001
        on znfmd001.t$fovn$c = tccom130.t$fovn$l

inner join  baandb.twhinh220601 whinh220
        on  whinh220.t$oorg = whinh200.t$oorg
       and  whinh220.t$orno = whinh200.t$orno

left  join ( select l.t$desc ORIGEM_ORDEM,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'wh'
                and d.t$cdom = 'inh.oorg'
                and l.t$clan = 'p'
                and l.t$cpac = 'wh'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) )
                                                                  ORD_ARM
        on ORD_ARM.t$cnst = whinh200.t$oorg

left  join ( select l.t$desc TIPO_TRANSACAO,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'wh'
                and d.t$cdom = 'inh.ittp'
                and l.t$clan = 'p'
                and l.t$cpac = 'wh'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) )
                                                                  ORD_ARM
        on ORD_ARM.t$cnst = whinh200.t$ittp

left  join ( select l.t$desc STATUS,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'wh'
                and d.t$cdom = 'inh.hsta'
                and l.t$clan = 'p'
                and l.t$cpac = 'wh'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) )
                                                                  ORD_ARM
        on ORD_ARM.t$cnst = whinh200.t$hsta

where   trunc(cast((from_tz(to_timestamp(to_char(whinh200.t$pddt,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date))
        between :DT_ENTRADA_DE and :DT_ENTRADA_ATE
and     trunc(cast((from_tz(to_timestamp(to_char(whinh200.t$prdt,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date))
        between :DT_RECEBIMENTO_DE and :DT_RECEBIMENTO_ATE
