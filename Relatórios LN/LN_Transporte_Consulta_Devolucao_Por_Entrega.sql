select Q1.* 
  from  ( SELECT 
            DISTINCT
              znsls401.t$entr$c                               ENTREGA,
              NVL(znfmd640.t$coci$c, znsls410.PT_CONTR)       INSTANCIA,
              cisli940v.t$docn$l                              NFS,
              cisli940v.t$seri$l                              SERIE_NFS,
              cisli940d.t$docn$l                              NFE,
              cisli940d.t$seri$l                              SERIE_NFE,
              znsls401.t$pecl$c                               PEDIDO,
              tcmcs080.t$cfrw                                 ID_TRANSPORTADORA,
              tcmcs080.t$dsca                                 TRANSPORTADOR,
              cisli245d.t$slso                                ID_DEVOLUCAO,
              cisli940d.t$fire$l                              ID_NR,
              cisli940d.t$stat$l                              DEV_SITUACAO, 
              iTABLE.                                         DESC_STAT,
              NVL(OCORRENCIA.DATO, znsls410.DATA_OCORR)       DATA_SITUACAO,
              NVL(znfmd630.t$fili$c, znfmd001.t$fili$c)       ID_FILIAL,
              NVL(znfmd001a.t$dsca$c, znfmd001.t$dsca$c)      FILIAL
          
          FROM  baandb.ttdsls401301 tdsls401       

INNER JOIN baandb.tcisli245301 cisli245v 
        ON cisli245v.t$slcp = 301
       AND cisli245v.t$ortp = 1
       AND cisli245v.t$koor = 3
       AND cisli245v.t$slso = tdsls401.t$orno
       AND cisli245v.t$pono = tdsls401.t$pono
       AND cisli245v.t$oset = tdsls401.t$sqnb          
          
INNER JOIN baandb.tcisli940301 cisli940v
        ON cisli940v.t$fire$l = cisli245v.t$fire$l
         
           LEFT JOIN BAANDB.tznfmd630301 znfmd630
                  ON znfmd630.t$fire$c = cisli940v.t$fire$l 
         
           LEFT JOIN baandb.ttcmcs080301 tcmcs080
                  ON tcmcs080.t$cfrw   = cisli940v.T$cfrw$l

          INNER JOIN baandb.tcisli245301 cisli245d  
                  ON cisli245d.t$fire$l = tdsls401.t$fire$l
                 AND cisli245d.t$line$l = tdsls401.t$line$l
          
          INNER JOIN baandb.tcisli940301 cisli940d
                  ON cisli940d.t$fire$l = cisli245d.t$fire$l
         
           LEFT JOIN (  select distinct 
                                a.t$ncia$c,
                                a.t$uneg$c,
                                a.t$pecl$c,
                                a.t$sqpd$c,
                                a.t$entr$c,
                                a.t$orno$c,
                                a.t$pono$c
                        from baandb.tznsls004301 a) znsls401
                  ON tdsls401.t$orno   = znsls401.t$orno$c
                 AND tdsls401.t$pono   = znsls401.t$pono$c
        
           LEFT JOIN baandb.ttdsls400301 tdsls400
                  ON tdsls400.t$orno   = cisli245d.t$slso
        
           LEFT JOIN baandb.ttcmcs065301 tcmcs065
                  ON tcmcs065.t$cwoc   = tdsls400.t$cofc
        
           LEFT JOIN baandb.ttccom130301 tccom130
                  ON tccom130.t$cadr   = tcmcs065.t$cadr
        
           LEFT JOIN baandb.tznfmd001301 znfmd001
                  ON znfmd001.t$fovn$c = tccom130.t$fovn$l
        
           LEFT JOIN baandb.tznfmd001301 znfmd001a
                  ON znfmd001a.t$fili$c = znfmd630.t$fili$c
        
           LEFT JOIN ( select znfmd640.t$coci$c,
                              znfmd640.t$fili$c,
                              znfmd640.t$etiq$c
                         from BAANDB.tznfmd640301 znfmd640
                        where znfmd640.t$date$c = ( SELECT max(znfmd640b.t$date$c) 
                                                      FROM BAANDB.tznfmd640301 znfmd640b
                                                     WHERE znfmd640b.t$fili$c = znfmd640.t$fili$c 
                                                       AND znfmd640b.t$etiq$c = znfmd640.t$etiq$c ) ) znfmd640
                  ON znfmd640.t$fili$c = znfmd630.t$fili$c 
                 AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
                  
           LEFT JOIN ( select znfmd640b.t$fili$c,
                              znfmd640b.t$etiq$c,
                              max(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640b.t$date$c, 'DD-MON-YYYY HH24:MI:SS'), 
                                    'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) DATO
                         from BAANDB.tznfmd640301 znfmd640b 
                     group by znfmd640b.t$fili$c,
                              znfmd640b.t$etiq$c )  OCORRENCIA
                  ON OCORRENCIA.t$fili$c = znfmd630.t$fili$c 
                 AND OCORRENCIA.t$etiq$c = znfmd630.t$etiq$c
          
           LEFT JOIN ( select znsls410.t$ncia$c,
                              znsls410.t$uneg$c,
                              znsls410.t$pecl$c,
                              znsls410.t$sqpd$c,
                              max(znsls410.t$dtoc$c) DATA_OCORR,
                              max(znsls410.t$poco$c) PT_CONTR
                         from baandb.tznsls410301 znsls410
                     group by znsls410.t$ncia$c,
                              znsls410.t$uneg$c,
                              znsls410.t$pecl$c,
                              znsls410.t$sqpd$c ) znsls410
                  ON znsls410.t$ncia$c = znsls401.t$ncia$c
                 AND znsls410.t$uneg$c = znsls401.t$uneg$c
                 AND znsls410.t$pecl$c = znsls401.t$pecl$c
                 AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
        
           LEFT JOIN ( select d.t$cnst CODE_STAT, 
                              l.t$desc DESC_STAT
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
                                                     and l1.t$cpac = l.t$cpac ) ) iTABLE
                  ON cisli940d.t$stat$l = iTABLE.CODE_STAT
           
          WHERE cisli940v.t$fdty$l = 14 ) Q1

where Trunc(NVL(DATA_SITUACAO,SYSDATE)) 
      between NVL(:DataSituacaoDe, Trunc(NVL(DATA_SITUACAO,SYSDATE))) 
          and NVL(:DataSituacaoAte,Trunc(NVL(DATA_SITUACAO,SYSDATE))) 
  and ( (:EntregaTodas = 0) or (ENTREGA in (:NumEntrega) and (:EntregaTodas = 1)) )
  and ID_TRANSPORTADORA in (:Transportadora)
  and ID_FILIAL in (:FILIAL)