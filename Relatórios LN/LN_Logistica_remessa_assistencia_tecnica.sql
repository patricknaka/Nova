select
        cisli940.t$docn$l                   NF,
        cisli940.t$seri$l                   SERIE,
        znfmd001.t$dsca$c                   FILIAL,
        cast((from_tz(to_timestamp(to_char(cisli940.t$datg$l,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                AT time zone 'America/Sao_Paulo') as date)
                                            DATA,
        ENDER.FOVN                          CNPJ,
        ENDER.NOME                          FORNECEDOR,
        cisli940.t$ccfo$l                   CFOP,
        cisli940.t$opor$l                   SEQ_CFOP,
        STATUS.ST                           SITUACAO_NF,
        trim(cisli941.t$item$l)             ID,
        cisli941.t$desc$l                   DESCRICAO,
        cisli941.t$dqua$l                   QTD,
        cisli941.t$pric$l                   PRECO_UNIT,
        cisli941.t$iprt$l                   VL_TOTAL,
        ITM.TIPO_ITEM                       TIPO

from    baandb.tcisli940301 cisli940

inner join  baandb.tcisli941301 cisli941
        on  cisli941.t$fire$l = cisli940.t$fire$l

inner join  baandb.ttcibd001301 tcibd001
        on  tcibd001.t$item = cisli941.t$item$l

inner join  baandb.ttccom100301 tccom100
        on  tccom100.t$bpid = cisli940.t$bpid$l

inner join  (select  a.t$fovn$l FOVN,
                     a.t$nama   NOME,
                     a.t$cadr
             from    baandb.ttccom130301 a) ENDER
        on  ENDER.t$cadr = tccom100.t$cadr

inner join baandb.ttcmcs065301 tcmcs065
        on tcmcs065.t$cwoc = cisli940.t$cofc$l

inner join baandb.ttccom130301 tccom130
        on  tccom130.t$cadr = tcmcs065.t$cadr

left  join baandb.tznfmd001301 znfmd001
        on znfmd001.t$fovn$c = tccom130.t$fovn$l

left  join ( select l.t$desc ST,
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
                                            and l1.t$cpac = l.t$cpac ) ) STATUS
        on STATUS.t$cnst = cisli940.t$stat$l

left  join ( select l.t$desc TIPO_ITEM,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tc'
                and d.t$cdom = 'kitm'
                and l.t$clan = 'p'
                and l.t$cpac = 'tc'
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
                                            and l1.t$cpac = l.t$cpac ) ) ITM
        on ITM.t$cnst = tcibd001.t$kitm

where   trunc(cast((from_tz(to_timestamp(to_char(cisli940.t$datg$l,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
                          between :DATA_DE and :DATA_ATE
and     znfmd001.t$fili$c between :ID_FILIAL_DE and :ID_FILIAL_ATE
and     STATUS.ST between :SITUACAO_NF_DE and :SITUACAO_NF_ATE
and     cisli940.t$fdty$l = 17            -- Remessa para Terceiros
and     not exists ( select tdrec955.t$lfir$l
                     from   baandb.ttdrec955301 tdrec955
                     where  tdrec955.t$fire$l = cisli941.t$fire$l
                     and    tdrec955.t$line$l = cisli941.t$line$l
                     and    tdrec955.t$lfir$l != ' ' )
