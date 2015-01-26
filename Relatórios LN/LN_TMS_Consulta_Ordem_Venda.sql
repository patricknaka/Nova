SELECT DISTINCT

tdsls401.t$orno           ORDEM_DE_VENDA,
znsls004.t$pecl$c         PEDIDO,
znsls004.t$entr$c         PEDIDO_CLIENTE,
tdsls400.t$cfrw           COD_TRANSPORTADOR,
tcmcs080.t$dsca           NOME_TRANSP,
znfmd630.t$cono$c         CONTRATO_TRANSPORTADOR,
znfmd060.t$cdes$c         DESC_CONTRATO,
cisli940.t$docn$l         NF,
cisli940.t$seri$l         SERIE,
tccom130.t$fovn$l         CNPJ_TRANSPORTADOR,
TIPO.DESCR                TIPO_DE_TRANSPORTE,
tcemm030.t$eunt           FILIAL,
tcemm030.t$dsca           DESC_FILIAL

FROM baandb.ttdsls401301  tdsls401

INNER JOIN baandb.ttdsls400301  tdsls400
        ON tdsls400.t$orno=tdsls401.t$orno
        
INNER JOIN baandb.ttcmcs080301  tcmcs080
        ON tcmcs080.t$cfrw=tdsls400.t$cfrw
        
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr=tcmcs080.t$cadr$l

       LEFT JOIN ( SELECT d.t$cnst CNST, 
                          l.t$desc DESCR
                     FROM baandb.tttadv401000 d, 
                          baandb.tttadv140000 l 
                    WHERE d.t$cpac = 'tc' 
                      AND d.t$cdom = 'com.trmd'
                      AND l.t$clan = 'p'
                      AND l.t$cpac = 'tc'
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
                                                  and l1.t$cpac = l.t$cpac ) ) TIPO
              ON tcmcs080.t$trmd = TIPO.CNST

LEFT JOIN baandb.tznsls004301 znsls004
       ON znsls004.t$orno$c=tdsls401.t$orno
      AND znsls004.t$pono$c=tdsls401.t$pono
      
--LEFT JOIN ( select  znsls410.t$ncia$c,
--                    znsls410.t$uneg$c,
--                    znsls410.t$pecl$c,
--                    znsls410.t$sqpd$c,
--                    znsls410.t$entr$c,
--                    znsls410.t$fovt$c,
--                    znsls410.t$ntra$c,
--                    znsls410.t$cono$c 
--            from    baandb.tznsls410301 znsls410
--            where   znsls410.t$fovt$c != 0
--            and     znsls410.t$ntra$c != ' '
--            and     znsls410.t$cono$c != ' '
--            --and     rownum=1
--            order by znsls410.t$dtoc$c desc ) TRACK
--      ON  TRACK.t$ncia$c=znsls004.t$ncia$c
--      AND TRACK.t$uneg$c=znsls004.t$uneg$c
--      AND TRACK.t$pecl$c=znsls004.t$pecl$c
--      AND TRACK.t$sqpd$c=znsls004.t$sqpd$c
--      AND TRACK.t$entr$c=znsls004.t$entr$c
      
LEFT JOIN baandb.tcisli245301  cisli245
       ON cisli245.t$slcp=301
      AND cisli245.t$ortp=1
      AND cisli245.t$koor=3
      AND cisli245.t$slso=tdsls401.t$orno
      AND cisli245.t$pono=tdsls401.t$pono

LEFT JOIN baandb.tcisli940301 cisli940
       ON cisli940.t$fire$l=cisli245.t$fire$l
       
LEFT JOIN baandb.ttcemm124301 tcemm124
       ON tcemm124.t$loco=301
      AND tcemm124.t$dtyp=1
      AND tcemm124.t$cwoc=tdsls400.t$cofc

INNER JOIN baandb.ttcemm030301  tcemm030
        ON tcemm030.t$eunt=tcemm124.t$grid

LEFT JOIN baandb.tznfmd630301 znfmd630
       ON znfmd630.t$orno$c=tdsls400.t$orno
      AND znfmd630.t$cfrw$c=tdsls400.t$cfrw
      AND znfmd630.t$cono$c != ' '
      
LEFT JOIN baandb.tznfmd060301 znfmd060
       ON znfmd060.t$cfrw$c=znfmd630.t$cfrw$c
      AND znfmd060.t$cono$c=znfmd630.t$cono$c
      
