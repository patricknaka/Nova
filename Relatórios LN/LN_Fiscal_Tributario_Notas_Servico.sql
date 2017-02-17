select  
        tcemm030.t$dsca                             COMPANHIA,
        cisli940.t$fire$l                           REFERENCIA_FISCAL,
        cisli940.t$cofc$l                           DEPARTAMENTO,
        tcmcs065.t$dsca                             DESCRICAO_DEPTO,
        cisli940.t$bpid$l                           PARCEIRO_NEGOCIO,
        tccom130.t$fovn$l                           CNPJ,
        tccom130.t$nama                             RAZAO_SOCIAL,
        cast((from_tz(to_timestamp(to_char(cisli940.t$datg$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
                                                    DATA_GERACAO,
        cast((from_tz(to_timestamp(to_char(cisli940.t$date$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
                                                    DATA_EMISSAO,
        TP_DOC.TIPO_DOC                             TIPO_DOCUMENTO,
        cisli940.t$fdtc$l                           COD_DOC_FISCAL,
        TP_DOC_FISC.DOC_FISCAL                      DESCR_COD_DOC_FISCAL,
        cisli940.t$ingr$l                           GRUPO_NOTA_FISCAL,
        cisli940.t$seri$l                           SERIE,
        cisli940.t$docn$l                           NRO_DOCUMENTO,
        cisli940.t$ccfo$l                           CFOP,
        cisli941.t$opor$l                           NATUREZA_OPERACAO,
        cisli941.t$item$l                           ITEM,
        tcibd001.t$dscb$c                           DESCRICAO_ITEM,
        cisli941.t$dqua$l                           QUANTIDADE,
        cisli941.t$pric$l                           PRECO_UNITARIO,
        cisli940.t$amnt$l                           VALORES_MERCADORIA,
        ( select cisli942.t$amnt$l
            from baandb.tcisli942301 cisli942
           where cisli942.t$fire$l = cisli940.t$fire$l
             and cisli942.t$brty$l = 5)             PIS,
        ( select cisli942.t$amnt$l
            from baandb.tcisli942301 cisli942
           where cisli942.t$fire$l = cisli940.t$fire$l
             and cisli942.t$brty$l = 6)             COFINS,
        ( select cisli942.t$amnt$l
            from baandb.tcisli942301 cisli942
           where cisli942.t$fire$l = cisli940.t$fire$l
             and cisli942.t$brty$l = 7)             ISS,
        ( select cisli942.t$amnt$l
            from baandb.tcisli942301 cisli942
           where cisli942.t$fire$l = cisli940.t$fire$l
             and cisli942.t$brty$l = 9)             IRRF,
        STATUS_NFE.DESCR                            STATUS_NFE,
        cisli940.t$prot$l                           PROTOCOLO_NFE,
        cisli940.t$cnfe$l                           LOCALIZADOR,
        STATUS_TRANS_NFE.DESCR                      STATUS_TRANSMISSAO_NFE,
        STATUS_NFE.DESCR                            STATUS_NFSE,
        STATUS_TRANS_NFE.DESCR                      STATUS_TRANSMISSAO_NFSE,
        cisli940.t$nfss$l                           NFSE_SUBSTITUICAO,
        cast((from_tz(to_timestamp(to_char(cisli940.t$dfsi$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
                                                    DATA_EMISSAO_NFSE,
        cisli940.t$vcsi$l                           COD_VERIFICACAO_NFSE,
        cisli940.t$nfsi$l                           NRO_NFSE,
        tttxt010.t$text                             OBS_NOTA_FISCAL,
        USUARIO.t$logn$c                            USUARIO,
        ( select a.t$name
          from   baandb.tttaad200000 a
          where  a.t$user = USUARIO.t$logn$c )      NOME_USUARIO

from    baandb.tcisli940301 cisli940

inner join baandb.ttccom100301 tccom100
        on tccom100.t$bpid = cisli940.t$bpid$l

inner join baandb.ttccom130301 tccom130
        on tccom130.t$cadr = tccom100.t$cadr

inner join baandb.tcisli941301 cisli941
        on cisli941.t$fire$l = cisli940.t$fire$l

left join baandb.ttcemm124301 tcemm124
       on tcemm124.t$cwoc = cisli940.t$cofc$l

left join baandb.ttcemm030301 tcemm030
       on tcemm030.t$eunt = tcemm124.t$grid

left join baandb.ttcmcs065301 tcmcs065
       on tcmcs065.t$cwoc = cisli940.t$cofc$l

left join baandb.ttcibd001301 tcibd001
       on tcibd001.t$item = cisli941.t$item$l

left join baandb.ttttxt010301 tttxt010
       on tttxt010.t$ctxt = cisli940.t$obse$l
      and tttxt010.t$clan = 'p'

left join ( select a.t$oper$c,
                   a.t$fire$c, 
                   min(a.t$logn$c) keep (dense_rank first order by a.t$data$c, a.t$seri$c) t$logn$c,
                   min(a.t$data$c) t$data$c
            from   baandb.tznnfe011301 a
            group by a.t$oper$c,
                     a.t$fire$c ) USUARIO
       on USUARIO.t$fire$c = cisli940.t$fire$l
      and USUARIO.t$oper$c = 1  -- Faturamento

left join ( select l.t$desc STATUS_FATURA,
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
             from   baandb.tttadv401000 d,
                    baandb.tttadv140000 l
             where  d.t$cpac = 'tc'
               and  d.t$cdom = 'doty.l'
               and  l.t$clan = 'p'
               and  l.t$cpac = 'tc'
               and  l.t$clab = d.t$za_clab
               and rpad(d.t$vers,4) ||
                   rpad(d.t$rele,2) ||
                   rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                        from  baandb.tttadv401000 l1 
                                        where l1.t$cpac = d.t$cpac 
                                          and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                         from  baandb.tttadv140000 l1 
                                         where l1.t$clab = l.t$clab 
                                           and l1.t$clan = l.t$clan 
                                           and l1.t$cpac = l.t$cpac ) )
                                                                 TP_DOC
        on TP_DOC.t$cnst = cisli940.t$doty$l


left  join ( select l.t$desc DOC_FISCAL,
                    d.t$cnst
             from   baandb.tttadv401000 d,
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
                                        from  baandb.tttadv401000 l1 
                                        where l1.t$cpac = d.t$cpac 
                                          and l1.t$cdom = d.t$cdom )
               and rpad(l.t$vers,4) ||
                   rpad(l.t$rele,2) ||
                   rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                        from  baandb.tttadv140000 l1 
                                        where l1.t$clab = l.t$clab 
                                          and l1.t$clan = l.t$clan 
                                          and l1.t$cpac = l.t$cpac ) )
                                                            TP_DOC_FISC
        on TP_DOC_FISC.t$cnst = cisli940.t$fdty$l

left  join ( select l.t$desc DESCR,
                    d.t$cnst
             from   baandb.tttadv401000 d,
                    baandb.tttadv140000 l
             where d.t$cpac = 'ci'
               and d.t$cdom = 'sli.nfes.l'
               and l.t$clan = 'p'
               and l.t$cpac = 'ci'
               and l.t$clab = d.t$za_clab
               and rpad(d.t$vers,4) ||
                   rpad(d.t$rele,2) ||
                   rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                        from  baandb.tttadv401000 l1 
                                        where l1.t$cpac = d.t$cpac 
                                          and l1.t$cdom = d.t$cdom )
               and rpad(l.t$vers,4) ||
                   rpad(l.t$rele,2) ||
                   rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                        from  baandb.tttadv140000 l1 
                                        where l1.t$clab = l.t$clab 
                                          and l1.t$clan = l.t$clan 
                                          and l1.t$cpac = l.t$cpac ) )
                                                            STATUS_NFE
        on STATUS_NFE.t$cnst = cisli940.t$nfes$l

left  join ( select l.t$desc DESCR,
                    d.t$cnst
             from   baandb.tttadv401000 d,
                    baandb.tttadv140000 l
             where d.t$cpac = 'br'
               and d.t$cdom = 'nfe.tsta.l'
               and l.t$clan = 'p'
               and l.t$cpac = 'br'
               and l.t$clab = d.t$za_clab
               and rpad(d.t$vers,4) ||
                   rpad(d.t$rele,2) ||
                   rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                        from  baandb.tttadv401000 l1 
                                        where l1.t$cpac = d.t$cpac 
                                          and l1.t$cdom = d.t$cdom )
               and rpad(l.t$vers,4) ||
                   rpad(l.t$rele,2) ||
                   rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                        from  baandb.tttadv140000 l1 
                                        where l1.t$clab = l.t$clab 
                                          and l1.t$clan = l.t$clan 
                                          and l1.t$cpac = l.t$cpac ) )
                                                            STATUS_TRANS_NFE
        on STATUS_TRANS_NFE.t$cnst = cisli940.t$tsta$l

where   cisli940.t$stat$l in (5,6)  -- (Impresso, Lançado)
  and   cisli940.t$tsta$l = 1       -- Autorizada
  and   cisli940.t$nfes$l = 5       -- Processada
  and   cisli940.t$fdty$l = 3       -- Prestação de serviços
  and   trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)) 
        between :DataEmissaoDe
            and :DataEmissaoAte
