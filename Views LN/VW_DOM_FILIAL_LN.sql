select
  cast(tfgld010.t$dimx as int)  CD_FILIAL,
  tfgld010.t$desc               NM_FILIAL

from baandb.ttfgld010301 tfgld010

left join baandb.ttfgld010301	dimmae		
       on dimmae.t$dtyp = tfgld010.t$dtyp
      and dimmae.t$dimx = tfgld010.t$pdix

left join baandb.ttccom001301 tccom001	
       on tccom001.t$emno = tfgld010.t$emno

left join (select d.t$cnst cd_status, 
                  l.t$desc ds_status 
            from baandb.tttadv401000 d, 
                 baandb.tttadv140000 l
            where d.t$cpac='tf'
              and d.t$cdom='gld.bloc'
              and rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                  (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                    from baandb.tttadv401000 l1 
                      where l1.t$cpac=d.t$cpac 
                      and l1.t$cdom=d.t$cdom)
              and l.t$clab=d.t$za_clab
              and l.t$clan='p'
              and l.t$cpac='tf'
              and rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                  (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                    from baandb.tttadv140000 l1 
                      where l1.t$clab=l.t$clab 
                      and l1.t$clan=l.t$clan 
                      and l1.t$cpac=l.t$cpac)) statusdim
       on statusdim.cd_status = tfgld010.t$bloc

left join (select d.t$cnst cd_tipo,
                  l.t$desc ds_tipo
            from baandb.tttadv401000 d,
                 baandb.tttadv140000 l
            where d.t$cpac='tf'
            and d.t$cdom='gld.datp'
            and rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                  from baandb.tttadv401000 l1 
                    where l1.t$cpac=d.t$cpac 
                    and l1.t$cdom=d.t$cdom)
                    and l.t$clab=d.t$za_clab
                    and l.t$clan='p'
                    and l.t$cpac='tf'
                    and rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                        (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                          from baandb.tttadv140000 l1 
                            where l1.t$clab=l.t$clab 
                            and l1.t$clan=l.t$clan 
                            and l1.t$cpac=l.t$cpac)) tipodim
       on tipodim.cd_tipo = tfgld010.t$atyp
															
where tfgld010.t$dtyp=2