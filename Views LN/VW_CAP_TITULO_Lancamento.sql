
select
  distinct
    201                             CD_CIA,
    concat(concat(tdrec940.t$ttyp$l, ''), tdrec940.t$invn$l) CD_CHAVE_PRIMARIA,
    itrtp.trtpdesc                  DS_TIPO_LANCAMENTO,
    idbcr.dbcrdesc                  IN_DEBITO_CREDITO,
    tdrec952.t$amth$l$1             VL_LANCAMENTO,
    tdrec952.t$leac$l               CD_CONTA_CONTABIL,
    tfgld008.t$desc                 DS_CONTA_CONTABIL,
    tdrec952.t$line$l				NR_LINHA,
	(select l.t$desc ds_tipo_nf
		from baandb.tttadv401000 d, baandb.tttadv140000 l
		where d.t$cpac='tc' and d.t$cdom='mcs.brty.l'
		and rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
										 (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
										  from baandb.tttadv401000 l1 
										  where l1.t$cpac=d.t$cpac 
										  and l1.t$cdom=d.t$cdom)
		and l.t$clab=d.t$za_clab
		and l.t$clan='p' and l.t$cpac='tc'
		and d.t$cnst=tdrec952.t$brty$l
		and rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
										(select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
										  from baandb.tttadv140000 l1 
										  where l1.t$clab=l.t$clab 
										  and l1.t$clan=l.t$clan 
										  and l1.t$cpac=l.t$cpac)) DS_TIPO_IMPOSTO	
from
	baandb.ttdrec940201 tdrec940,
	baandb.ttdrec952201 tdrec952 
	left  join  baandb.ttfgld008201 tfgld008 
	on tfgld008.t$leac=tdrec952.t$leac$l,
      ( select  d.t$cnst trtpcode, l.t$desc trtpdesc
			from  tttadv401000 d, tttadv140000 l 
			where d.t$cpac='tf' and d.t$cdom='trtp.l'
			and rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                                       (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                                        from baandb.tttadv401000 l1 
                                        where l1.t$cpac=d.t$cpac 
                                        and l1.t$cdom=d.t$cdom)
			and l.t$clab=d.t$za_clab
			and l.t$clan='p' and l.t$cpac='tf'
			and rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                                      (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                                        from baandb.tttadv140000 l1 
                                        where l1.t$clab=l.t$clab 
                                        and l1.t$clan=l.t$clan 
                                        and l1.t$cpac=l.t$cpac) ) itrtp,
      ( select  d.t$cnst dbcrcode, l.t$desc dbcrdesc
			from tttadv401000 d, tttadv140000 l 
			where d.t$cpac='tf' and d.t$cdom='gld.dbcr'
			and rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                                       (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                                        from baandb.tttadv401000 l1 
                                        where l1.t$cpac=d.t$cpac 
                                        and l1.t$cdom=d.t$cdom)
			and l.t$clab=d.t$za_clab
			and l.t$clan='p' and l.t$cpac='tf'
			and rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                                      (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                                        from baandb.tttadv140000 l1 
                                        where l1.t$clab=l.t$clab 
                                        and l1.t$clan=l.t$clan 
                                        and l1.t$cpac=l.t$cpac) ) idbcr                                        
  
where tdrec952.t$fire$l=tdrec940.t$fire$l
and tdrec952.t$trtp$l=itrtp.trtpcode
and tdrec952.t$dbcr$l=idbcr.dbcrcode  
and tdrec940.t$invn$l>0 