SELECT
  znfmd068.t$cono$c  ID_CONTRATO,
  tccom130.t$fovn$l  CNPJ_TRANSPORTADOR,
  znfmd068.t$cfrw$c  ESTABELECIMENTO,
 
  tcmcs080.t$cfrw ||
  ' - '           ||
  Trim(tcmcs080.t$dsca)   Cod_Desc_Estabelecimento,
 
  tcmcs080.t$seak    APELIDO_TRANSPORTADOR,
  znfmd068.t$desc$c  NOME_TABELA,
  znfmd068.t$ulog$c  USER_ULTIMA_ALTERACAO,
 
  Max( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd068.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),
         'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE) )
                     DT_ALTIMA_ALTERACAO
                               
FROM       BAANDB.tznfmd068301 znfmd068
 
INNER JOIN BAANDB.ttcmcs080301 tcmcs080
        ON znfmd068.t$cfrw$c = tcmcs080.t$cfrw

INNER JOIN BAANDB.ttccom100301 tccom100
        ON tccom100.t$bpid   = tcmcs080.t$suno
 
INNER JOIN BAANDB.ttccom130301 tccom130
        ON tccom130.t$cadr   = tccom100.t$cadr
 
WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd068.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),
              'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      Between :UltimaAlteracaoDe
          And :UltimaAlteracaoAte
  AND znfmd068.t$cfrw$c IN (:Transportadora)
 
GROUP BY znfmd068.t$cono$c,
         tccom130.t$fovn$l,
         znfmd068.t$cfrw$c,
         tcmcs080.t$cfrw,
         Trim(tcmcs080.t$dsca),
         tcmcs080.t$seak,
         znfmd068.t$desc$c,
         znfmd068.t$ulog$c
 
ORDER BY USER_ULTIMA_ALTERACAO,
         ID_CONTRATO