select
       tdrec940.t$docn$l                         NRO_DOCUMENTO,
       tdrec940.t$seri$l                         SERIE,
       tdrec940.t$fovn$l                         ID_FISCAL_CNPJ,
       tdrec940.t$fire$l                         REC_FISCAL,
       REC_FISCAL.STATUS                         STATUS,
       case when tdrec940.t$pstd$l = 1 then
            'Sim'
       else
            'Não'
       end                                       CONTABILIZADO,
       cast((from_tz(to_timestamp(to_char(tdrec940.t$date$l,
             'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_FISCAL,
       tdrec940.t$gtam$l                         VALOR
  from baandb.ttdrec940301 tdrec940
  
left join ( select l.t$desc STATUS,
                   d.t$cnst
              from baandb.tttadv401000 d,
                   baandb.tttadv140000 l
             where d.t$cpac = 'ci'
               and d.t$cdom = 'sli.stat'
               and l.t$clan = 'p'
               and l.t$cpac = 'ci'
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
                                           and l1.t$cpac = l.t$cpac ) ) REC_FISCAL
        on REC_FISCAL.t$cnst = tdrec940.t$stat$l
  
  where trunc(cast((from_tz(to_timestamp(to_char(tdrec940.t$date$l,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date))
        between :DATA_FISCAL_DE
            and :DATA_FISCAL_ATE
    and REC_FISCAL.STATUS in (:STATUS)
    and tdrec940.t$doty$l = 8  -- Conhecimento
