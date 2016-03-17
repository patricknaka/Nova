SELECT
  znfmd068.t$cfrw$c  ESTABELECIMENTO,
  tccom130.t$fovn$l  CNPJ_TRANSPORTADOR,
 
  tcmcs080.t$cfrw ||
  ' - '           ||
  Trim(tcmcs080.t$dsca)   Cod_Desc_Estabelecimento,
  tcmcs080.t$seak    APELIDO_TRANSPORTADOR,
                       znfmd068.t$cono$c  ID_CONTRATO,
  znfmd060.t$cdes$c  NM_CONTRATO,
  znfmd068.t$nlis$c ||
  ' - '             ||
  Trim(znfmd068.t$desc$c) LISTA,
  znfmd068.t$desc$c  NOME_TABELA,
  znfmd068.t$ulog$c  USER_ULTIMA_ALTERACAO,
 
  Max( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd068.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),
         'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE) )
                     DT_ULTIMA_ALTERACAO,
  znfmd068.t$reep$c  PERC_REENTREGA,
  znfmd068.t$reev$c  VLR_REENTREGA,
  znfmd068.t$devp$c  PERC_DEVOLUCAO,
  znfmd068.t$devv$c  VLR_DEVOLUCAO,
  znfmd068.t$vmin$c  VLR_MINIMO,
  znfmd068.t$vmax$c  VLR_MAXIMO,
  znfmd068.t$pmin$c  PESO_MINIMO,
  znfmd068.t$pmax$c  PESO_MAXIMO,
  znfmd068.t$adva$c  AD_VALOREM_LISTA,
  znfmd068.t$piso$c  PISO,
  znfmd068.t$cole$c  COLETA,
  znfmd068.t$peda$c  PEDAGIO_LISTA,
  znfmd068.t$frac$c  FRACAO_LISTA,
  znfmd068.t$valo$c  VALOR_LISTA,
  znfmd068.t$volm$c  VOLUME_MAXIMO,
  znfmd068.t$vers$c  VERSAO_REGRA_CALC,
  znfmd068.t$frep$c  FRETE_PESO,
  znfmd068.t$vali$c  VALIDADE_INICIO,
  znfmd068.t$valf$c  VALIDADE_FIM,
  STATLISTA.DESCR    STATUS,

  znfmd069.t$creg$c ||
   ' - '             ||
  Trim(znfmd061.t$dzon$c)  REGIAO,
  
  znfmd070.t$codf$c ||
  ' - '             ||
  Trim(znmcs083.t$dsca$c)  COD_FAIXA,

  znfmd070.t$ulog$c  USER_ULTIMA_ALTER_PRC_REGIAO,
 
  Max( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd070.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),
         'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE) )
                     DT_ALTIMA_ALTER_PRC_REGIAO,

  STATREGIAO.DESCR    STATUS_PRC_REGIAO,
 
  znfmd070.t$sreg$c  SEQUENCIAL_REGIAO,
  znfmd070.t$pesd$c  PESOS_DE,
  znfmd070.t$pesa$c  PESOS_ATE,
  znfmd070.t$valo$c  VLR_REGIAO,
  znfmd070.t$adva$c  AD_VALOREM_REGIAO,
  znfmd070.t$peda$c  PEDAGIO_REGIAO,
  znfmd070.t$frac$c  FRACAO_REGIAO

FROM       BAANDB.tznfmd068301 znfmd068

INNER JOIN BAANDB.ttcmcs080301 tcmcs080
        ON znfmd068.t$cfrw$c = tcmcs080.t$cfrw

INNER JOIN BAANDB.ttccom100301 tccom100
        ON tccom100.t$bpid   = tcmcs080.t$suno
 
INNER JOIN BAANDB.ttccom130301 tccom130
        ON tccom130.t$cadr   = tccom100.t$cadr

inner join BAANDB.tznfmd060301 znfmd060
        on znfmd060.t$cfrw$c = znfmd068.t$cfrw$c
       AND znfmd060.t$cono$c = znfmd068.t$cono$c

LEFT JOIN (SELECT d.t$cnst CODE,   
                     l.t$desc DESCR   
                FROM baandb.tttadv401000 d,   
                     baandb.tttadv140000 l   
               WHERE d.t$cpac = 'zn'   
                 AND d.t$cdom = 'mcs.stat.c'   
                 AND l.t$clan = 'p'   
                 AND l.t$cpac = 'zn'   
                 AND l.t$clab = d.t$za_clab   
                 AND rpad(d.t$vers,4) ||   
                     rpad(d.t$rele,2) ||   
                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                     rpad(l1.t$rele,2) ||   
                                                     rpad(l1.t$cust,4))   
                                            from baandb.tttadv401000 l1   
                                           where l1.t$cpac = d.t$cpac   
                                             and l1.t$cdom = d.t$cdom )   
                 AND rpad(l.t$vers,4) ||   
                     rpad(l.t$rele,2) ||   
                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                     rpad(l1.t$rele,2) ||   
                                                     rpad(l1.t$cust,4))   
                                            from baandb.tttadv140000 l1   
                                           where l1.t$clab = l.t$clab   
                                             and l1.t$clan = l.t$clan   
                                             and l1.t$cpac = l.t$cpac)) STATLISTA
           ON  znfmd068.t$ativ$c = STATLISTA.CODE
INNER JOIN BAANDB.tznfmd069301 znfmd069
        ON znfmd069.t$cfrw$c = znfmd068.t$cfrw$c
       AND znfmd069.t$cono$c = znfmd068.t$cono$c
       AND znfmd069.t$nlis$c = znfmd068.t$nlis$c

INNER JOIN BAANDB.tznfmd070301 znfmd070
        ON znfmd070.t$cfrw$c = znfmd069.t$cfrw$c
       AND znfmd070.t$cono$c = znfmd069.t$cono$c
       AND znfmd070.t$nlis$c = znfmd069.t$nlis$c
       AND znfmd070.t$creg$c = znfmd069.t$creg$c

LEFT JOIN (SELECT d.t$cnst CODE,   
                     l.t$desc DESCR   
                FROM baandb.tttadv401000 d,   
                     baandb.tttadv140000 l   
               WHERE d.t$cpac = 'zn'   
                 AND d.t$cdom = 'mcs.stat.c'   
                 AND l.t$clan = 'p'   
                 AND l.t$cpac = 'zn'   
                 AND l.t$clab = d.t$za_clab   
                 AND rpad(d.t$vers,4) ||   
                     rpad(d.t$rele,2) ||   
                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                     rpad(l1.t$rele,2) ||   
                                                     rpad(l1.t$cust,4))   
                                            from baandb.tttadv401000 l1   
                                           where l1.t$cpac = d.t$cpac   
                                             and l1.t$cdom = d.t$cdom )   
                 AND rpad(l.t$vers,4) ||   
                     rpad(l.t$rele,2) ||   
                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   
                                                     rpad(l1.t$rele,2) ||   
                                                     rpad(l1.t$cust,4))   
                                            from baandb.tttadv140000 l1   
                                           where l1.t$clab = l.t$clab   
                                             and l1.t$clan = l.t$clan   
                                             and l1.t$cpac = l.t$cpac)) STATREGIAO
           ON  znfmd070.t$ativ$c = STATREGIAO.CODE
           

INNER JOIN BAANDB.tznmcs083301 znmcs083
        on znmcs083.t$cfrw$c = znfmd070.t$cfrw$c
       and znmcs083.t$codf$c = znfmd070.t$codf$c
       
INNER JOIN BAANDB.tznfmd061301 znfmd061
        ON znfmd069.t$cfrw$c = znfmd061.t$cfrw$c
       AND znfmd069.t$cono$c = znfmd061.t$cono$c 
       AND znfmd069.t$creg$c = znfmd061.t$creg$c

where Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd068.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),
              'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      Between :UltimaAlteracaoDe
          And :UltimaAlteracaoAte
  AND znfmd068.t$cfrw$c IN (:Transportadora)
  
GROUP BY znfmd068.t$cono$c,
         znfmd068.t$cfrw$c,
         znfmd060.t$cdes$c,
         znfmd068.t$desc$c,
         znfmd068.t$ulog$c,
         znfmd068.t$nlis$c,
         Trim(znfmd068.t$desc$c),
         znfmd068.t$reep$c, 
         znfmd068.t$reev$c, 
         znfmd068.t$devp$c, 
         znfmd068.t$devv$c,
         znfmd068.t$vmin$c,
         znfmd068.t$vmax$c,
         znfmd068.t$pmin$c,
         znfmd068.t$pmax$c,
         znfmd068.t$adva$c,
         znfmd068.t$piso$c,
         znfmd068.t$cole$c,
         znfmd068.t$peda$c,
         znfmd068.t$frac$c,
         znfmd068.t$valo$c,
         znfmd068.t$volm$c,
         znfmd068.t$vers$c,
         znfmd068.t$frep$c,
         znfmd068.t$vali$c,
         znfmd068.t$valf$c,
         znfmd068.t$ativ$c,
         tccom130.t$fovn$l,
         tcmcs080.t$cfrw,
         Trim(tcmcs080.t$dsca),
         tcmcs080.t$seak,
         STATLISTA.DESCR,
         znfmd069.t$creg$c,
         Trim(znfmd061.t$dzon$c),
         znfmd070.t$codf$c,
         Trim(znmcs083.t$dsca$c),
         znfmd070.t$ulog$c,
         STATREGIAO.DESCR,
         znfmd070.t$ativ$c,
         znfmd070.t$sreg$c,
         znfmd070.t$pesd$c,
         znfmd070.t$pesa$c,
         znfmd070.t$valo$c,
         znfmd070.t$adva$c,
         znfmd070.t$peda$c,
         znfmd070.t$frac$c
         
ORDER BY USER_ULTIMA_ALTERACAO,
         ID_CONTRATO