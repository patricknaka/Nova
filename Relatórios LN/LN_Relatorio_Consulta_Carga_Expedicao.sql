select 
        znfmd630.t$ncar$c     CARGA,
        znfmd630.t$pecl$c     ENTREGA,
        cisli940.t$docn$l     NOTA,
        cisli940.t$seri$l     SERIE,
        znfmd001.t$fili$c     FILIAL,
        znfmd001.t$dsca$c     NOME_FILIAL,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                              DATA_EXPEDICAO,
        cisli940.t$cfrw$l     COD_TRANSPORTADORA,
        tcmcs080.t$dsca       NOME_TRANSPORTADORA

from baandb.tcisli940301 cisli940

inner join baandb.ttccom130301 tccom130
        on tccom130.t$cadr = cisli940.t$sfra$l
        
inner join baandb.tznfmd001301 znfmd001
        on znfmd001.t$fovn$c = tccom130.t$fovn$l

inner join baandb.tznfmd630301 znfmd630
       on znfmd630.t$fire$c = cisli940.t$fire$l
       
inner join baandb.ttcmcs080301 tcmcs080
       on tcmcs080.t$cfrw = cisli940.t$cfrw$l

left join ( select  max(a.t$date$c) t$date$c,
                    a.t$fili$c,
                    a.t$etiq$c
            from    baandb.tznfmd640301 a
            where   a.t$coci$c = 'ETR' 
            group by a.t$fili$c,
                     a.t$etiq$c ) znfmd640
       on znfmd640.t$fili$c = znfmd630.t$fili$c
      and znfmd640.t$etiq$c = znfmd630.t$etiq$c
       
where cisli940.t$stat$l IN (5,6)
and   cisli940.t$fdty$l not in (14)
