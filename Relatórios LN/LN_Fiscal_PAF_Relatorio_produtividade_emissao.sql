select  distinct
        OPERACAO.DESCR                                OPERACAO,
        znnfe011.t$fire$c                             REF_FISCAL,
        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$nfes$c = 2
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_TRANSMITIDA,
        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$nfes$c = 1
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_NENHUM,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$nfes$c = 3
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_PED_CANCELAMENTO,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$nfes$c = 4
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_PED_ESTORNO,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$nfes$c = 5
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_PROCESSADA,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$nfes$c = 6
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_PED_CONSULTA,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stfa$c = 5
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_IMPRESSO,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stfa$c = 1
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_AGUARDANDO,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stfa$c = 2
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_CANCELAR,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stfa$c = 3
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_CONFIRMADO,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stfa$c = 4
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_COMPOSTO,
          
        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stfa$c = 6
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_LANCADO,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stfa$c = 101
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_ESTORNADO,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stre$c = 1
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_ABERTO,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stre$c = 3
            and   b.t$user   = a.t$logn$c 
            and   rownum <= 1 )                      STATUS_REC_FISCAL_NAO_APROVADO,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stre$c = 4
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_APROV,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stre$c = 5
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_APROV_PROBL,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stre$c = 6
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_ESTORNADO,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stre$c = 200
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_AGUARD_WMS,

        ( select  
                  a.t$logn$c || ' - ' || b.t$name || ' em ' ||
                  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   a.t$stre$c = 201
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_ENV_WMS
          
from    baandb.tznnfe011301 znnfe011

left  join ( select 
                    l.t$desc DESCR,
                    d.t$cnst
              from baandb.tttadv401000 d,
                   baandb.tttadv140000 l
             where d.t$cpac = 'br'
               and d.t$cdom = 'fbk.topm.l'
               and l.t$clan = 'p'
               and l.t$cpac = 'br'
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
                                           and l1.t$cpac = l.t$cpac ) ) OPERACAO
        on OPERACAO.t$cnst = znnfe011.t$oper$c

where   znnfe011.t$oper$c between :OPERACAO_DE and :OPERACAO_ATE
and     trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
               between  :DATA_OCORRENCIA_DE and :DATA_OCORRENCIA_ATE
