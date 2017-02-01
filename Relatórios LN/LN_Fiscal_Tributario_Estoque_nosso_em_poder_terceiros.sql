select
        znfmd001.t$ncia$c                       COMPANHIA,
        znfmd001.t$dsca$c                       FILIAL_ORIGEM,
        tdrec955.t$fire$l                       REF_FATURAMENTO,
        tdrec955.t$line$l                       LINHA_FAT,
        tdrec955.t$sern$l                       SEQ_FAT,
        cisli940.t$docn$l                       DOC_FAT,
        cisli940.t$seri$l                       SERIE_FAT,
        tdrec955.t$fdtc$l                       TIPO_DOC_FAT,
        TIPO_DOC_O.DESCR                        TIPO_DOC_FISCAL_FAT,
        ORIG_TRANS.DESCR                        ORIGEM_TRANSACAO,
        ORD_DEV.t$lfir$l                        REF_RECEBIMENTO,
        ORD_DEV.t$llin$l                        LINHA_REC,
        ORD_DEV.t$ser2$l                        SEQ_REC,
        tdrec940.t$docn$l                       DOC_REC,
        tdrec940.t$seri$l                       SERIE_REC,
        TIPO_DOC_D.DESCR                        TIPO_DOC_FISCAL_REC,
        tdrec955.t$bpid$l                       PARCEIRO_NEGOCIOS,
        tccom100.t$nama                         DESCRICAO_PARCEIRO_NEGOCIOS,
        tdrec955.t$item$l                       ITEM,
        tdrec955.t$bala$l                       SALDO_DISPONIVEL,
        tdrec955.t$basb$l                       RETORNO_REMESSA_SIMBOLICA,
        ORD_DEV.t$qtdr$l                        QTDE_RETORNO,
        case
              when  ORD_DEV.t$lfir$l is null then
                    cisli941.t$gamt$l
              else
                    tdrec941.t$gamt$l
        end as                                  VALOR_MERCADORIA,
        znnfe011.t$logn$c                       USUARIO,
        cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec955.t$data$l, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                DATA_EMISSAO,
        tccom130.t$fovn$l                       CNPJ

from    baandb.ttdrec955301 tdrec955

inner join  baandb.tcisli940301 cisli940
        on  cisli940.t$fire$l = tdrec955.t$fire$l

inner join  baandb.tcisli941301 cisli941
        on  cisli941.t$fire$l = tdrec955.t$fire$l
       and  cisli941.t$line$l = tdrec955.t$line$l

inner join  baandb.ttccom100301 tccom100
        on  tccom100.t$bpid = tdrec955.t$bpid$l

inner join  baandb.ttcmcs065301 tcmcs065
        on  tcmcs065.t$cwoc = cisli940.t$cofc$l

inner join  baandb.ttccom130301 tccom130
        on  tccom130.t$cadr = tcmcs065.t$cadr

inner join  baandb.tznfmd001301 znfmd001
        on  znfmd001.t$fovn$c = tccom130.t$fovn$l

left  join  ( select  a_tdrec955.t$fire$l,
                      a_tdrec955.t$line$l,
                      a_tdrec955.t$sern$l,
                      a_tdrec955.t$lfir$l,
                      a_tdrec955.t$llin$l,
                      a_tdrec955.t$ser2$l,
                      a_tdrec955.t$rfdt$l,
                      a_tdrec955.t$qtdr$l
              from  baandb.ttdrec955301 a_tdrec955 )  ORD_DEV
        on  ORD_DEV.t$fire$l = tdrec955.t$fire$l
       and  ORD_DEV.t$line$l = tdrec955.t$line$l
       and  ORD_DEV.t$sern$l != 0 -- Sequencia diferente de 0 são as devoluções

left  join  baandb.ttdrec940301 tdrec940
        on  tdrec940.t$fire$l = ORD_DEV.t$lfir$l

left  join  baandb.ttdrec941301 tdrec941
        on  tdrec941.t$fire$l = ORD_DEV.t$lfir$l
       and  tdrec941.t$line$l = ORD_DEV.t$llin$l

left  join  baandb.tznnfe011301 znnfe011
        on  znnfe011.t$oper$c = 1 -- Faturamento
       and  znnfe011.t$fire$c = tdrec955.t$fire$l
       and  znnfe011.t$stfa$c = 5 -- Impresso
       and  znnfe011.t$nfes$c = 1 -- Nenhum

left  join ( select l.t$desc DESCR,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'ci'
                and d.t$cdom = 'sli.tdff.l'
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
                                            and l1.t$cpac = l.t$cpac ) )
                                                                  TIPO_DOC_O
        on TIPO_DOC_O.t$cnst = tdrec955.t$fdty$l

left  join ( select l.t$desc DESCR,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'td'
                and d.t$cdom = 'rec.trfd.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'td'
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
                                                                  TIPO_DOC_D
        on TIPO_DOC_D.t$cnst = ORD_DEV.t$rfdt$l

left  join ( select l.t$desc DESCR,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'ci'
                and d.t$cdom = 'sli.tdff.l'
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
                                            and l1.t$cpac = l.t$cpac ) )
                                                                  ORIG_TRANS
        on ORIG_TRANS.t$cnst = tdrec955.t$tror$l

where   tdrec955.t$fire$l between :REFERENCIA_FAT_ORIGEM_DE and
                                  :REFERENCIA_FAT_ORIGEM_ATE
and     trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec955.t$data$l, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date))
                          between :DATA_EMISSAO_DE and
                                  :DATA_EMISSAO_ATE
and     ORD_DEV.t$lfir$l between :REFERENCIA_RECEBIMENTO_DE and
                                 :REFERENCIA_RECEBIMENTO_ATE
and     tdrec955.t$sern$l = 0   -- Sequencia 0 é o lançamento da fatura
order by 
        tdrec955.t$fire$l, tdrec955.t$data$l,
        ORD_DEV.t$lfir$l,  tdrec955.t$bpid$l
