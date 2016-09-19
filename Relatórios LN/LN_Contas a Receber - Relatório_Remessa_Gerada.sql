select  

    znsls004.t$uneg$c           UN_NEGOCIOS,
    tfcmg948.t$bpid$l           ID_CLIENTE,
    tccom100.t$nama             NOME,
    cisli940.t$docn$l           NF_NUMERO,
    cisli940.t$seri$l           NF_SERIE,
    tfcmg948.t$ttyp$l ||
    to_char(tfcmg948.t$ninv$l)  TITULO,
    znsls004.t$pecl$c           PEDIDO,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                DATA_EMISSAO,
    tfcmg948.t$dued$l           DATA_VENCTO,
    tfcmg948.t$bank$l           ID_BANCO,
    tfcmg948.t$baof$l           ID_AGENCIA,
    tfcmg948.t$acco$l           ID_CONTA,
    tfcmg948.t$banu$l           NUM_BANCARIO,
    tfcmg948.t$ptyp$l ||
    to_char(tfcmg948.t$docn$l)  DOCUMENTO,
    tfcmg948.t$sqtl$l           ID_REMESSA,
    tfacr200.t$docd             DT_REMESSA,
    REMESSA.STATUS              SITUACAO_REMESSA,
    tfcmg948.t$amth$l           VALOR_TITULO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$dtem$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                DT_EMISSAO_NF,
    NF.STATUS                   SITUACAO_NF,
    TITULO.STATUS               STATUS_TITULO
    
from  baandb.ttfcmg948301 tfcmg948

left join baandb.tcisli940301 cisli940
       on cisli940.t$sfcp$l = 301
      and cisli940.t$ityp$l = tfcmg948.t$ttyp$l
      and cisli940.t$idoc$l = tfcmg948.t$ninv$l

left join baandb.ttccom100301 tccom100
       on tccom100.t$bpid = tfcmg948.t$bpid$l
       
left join ( select a.t$fire$l,
                   a.t$slso
             from  baandb.tcisli245301 a
             where a.t$ortp = 1
             and   a.t$koor = 3 
             group by a.t$fire$l,
                      a.t$slso ) cisli245
       on   cisli245.t$fire$l = cisli940.t$fire$l
       
left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$orno$c
            from   baandb.tznsls004301 a
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$orno$c ) znsls004
      on znsls004.t$orno$c = cisli245.t$slso

left join baandb.tznsls400301 znsls400
       on znsls400.t$ncia$c = znsls004.t$ncia$c
      and znsls400.t$uneg$c = znsls004.t$uneg$c
      and znsls400.t$pecl$c = znsls004.t$pecl$c
      and znsls400.t$sqpd$c = znsls004.t$sqpd$c
      
left join ( select a.t$ttyp,
                   a.t$ninv,
                   a.t$tdoc,
                   a.t$docn,
                   a.t$docd,
                   a.t$step
            from   baandb.ttfacr200301 a
            where  a.t$lino = 1 
            group by a.t$ttyp,
                     a.t$ninv,
                     a.t$tdoc,
                     a.t$docn,
                     a.t$docd,
                     a.t$step ) tfacr200
        on tfacr200.t$ttyp = tfcmg948.t$ttyp$l
       and tfacr200.t$ninv = tfcmg948.t$ninv$l
       and tfacr200.t$tdoc = tfcmg948.t$ptyp$l
       and tfacr200.t$docn = tfcmg948.t$docn$l

 LEFT JOIN ( select l.t$desc STATUS,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'cmg.stat.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) REMESSA
        ON REMESSA.t$cnst = tfcmg948.t$stat$l                                 

 LEFT JOIN ( select l.t$desc STATUS,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'cmg.step'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) TITULO
        ON TITULO.t$cnst = tfacr200.t$step              

 LEFT JOIN ( select l.t$desc STATUS,
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
                                            and l1.t$cpac = l.t$cpac ) ) NF
        ON NF.t$cnst = cisli940.t$stat$l
        
