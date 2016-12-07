select  cisli940.t$fire$l                         REFERENCIA_FISCAL,
        ORDEM.STATUS_FATURA                       STATUS_FATURA,
        cisli940.t$bpid$l                         PARCEIRO_NEGOCIOS,
        cisli940.t$brid$l                         REQ_FATURAMENTO,
        cisli940.t$ityp$l                         TIPO_TRANSACAO,
        cisli940.t$nfsi$l                         NRO_RPS,
        cast((from_tz(to_timestamp(to_char(cisli940.t$date$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
                                                  DATA_EMISSAO,
        TP_DOC.TIPO_DOC                           TIPO_DE_DOC,
        cisli940.t$fdtc$l                         COD_DOC_FISCAL,
        cisli940.t$nfsi$l                         NRO_NOTA_SERVICOS,
        cast((from_tz(to_timestamp(to_char(cisli940.t$dfsi$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
                                                  DATA_EMISSAO_SERV,
        cisli940.t$ingr$l                         GRUPO_NOTA_FISCAL,
        cisli940.t$seri$l                         SERIE,
        cisli941.t$desc$l                         DESCRICAO_SERVICO,
        TP_DOC_FISC.DOC_FISCAL                    TIPO_DOC_FISCAL,
        cisli940.t$amnt$l                         VALORES,
        ( select cisli942.t$amnt$l
            from baandb.tcisli942301 cisli942
           where cisli942.t$fire$l = cisli940.t$fire$l
             and cisli942.t$brty$l = 5)           PIS,
        ( select cisli942.t$amnt$l
            from baandb.tcisli942301 cisli942
           where cisli942.t$fire$l = cisli940.t$fire$l
             and cisli942.t$brty$l = 6)           COFINS,
        ( select cisli942.t$amnt$l
            from baandb.tcisli942301 cisli942
           where cisli942.t$fire$l = cisli940.t$fire$l
             and cisli942.t$brty$l = 7)           ISS,
        ( select cisli942.t$amnt$l
            from baandb.tcisli942301 cisli942
           where cisli942.t$fire$l = cisli940.t$fire$l
             and cisli942.t$brty$l = 9)           IRRF,
        tccom130.t$fovn$l                         CNPJ

from  baandb.tcisli940301 cisli940

inner join baandb.ttccom100301  tccom100
on tccom100.t$bpid = cisli940.t$bpid$l

inner join baandb.ttccom130301  tccom130
on tccom130.t$cadr = tccom100.t$cadr

inner  join  baandb.tcisli941301 cisli941
         on  cisli941.t$fire$l = cisli940.t$fire$l

left  join ( select l.t$desc STATUS_FATURA,
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
                                            and l1.t$cpac = l.t$cpac ) )
                                                                  ORDEM
        on ORDEM.t$cnst = cisli940.t$stat$l

left  join ( select l.t$desc TIPO_DOC,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tc'
                and d.t$cdom = 'doty.l'
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
                                            and l1.t$cpac = l.t$cpac ) )
                                                                 TP_DOC
        on TP_DOC.t$cnst = cisli940.t$doty$l


left  join ( select l.t$desc DOC_FISCAL,
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
                                                            TP_DOC_FISC
        on TP_DOC_FISC.t$cnst = cisli940.t$fdty$l

where cisli940.t$stat$l in (5,6)  -- (Impresso, Lançado)
and   cisli940.t$tsta$l = 1       -- Autorizada
and   cisli940.t$nfes$l = 5       -- Processada
and   cisli940.t$fdty$l = 3       -- Prestação de serviços
and   trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)) 
      between :DataEmissaoDe and :DataEmissaoAte
order by  cisli940.t$nfsi$l, cisli940.t$dfsi$l
