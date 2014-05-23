select distinct
      znfmd630.T$FILI$C dofi_filial,
      znsls400.t$uneg$c unin_nome,
      (select min(o.T$DATE$C) 
      from BAANDB.TZNFMD640201 o
      where o.T$COCI$C='ROT'
      and o.T$ETIQ$C=znfmd630.T$ETIQ$C) dofi_dt_saida_entrega,
      znfmd630.t$pecl$c dofi_pedido_cliente,
      znsls401.T$ENTR$C dofi_pedido_interno,
      znfmd630.t$vlft$c dofi_vl_frete_pagar_gte,
      znsls401.t$itpe$c tien_nome,
      (select min(o.T$DATE$C) 
      from BAANDB.TZNFMD640201 o
      where o.T$COCI$C='ENT'
      and o.T$ETIQ$C=znfmd630.T$ETIQ$C) dofi_dt_entrega_realizada,
      (select o.T$stat$C 
      from BAANDB.TZNFMD640201 o
      where o.T$date$c=(select max(o1.T$date$c) from BAANDB.TZNFMD640201 o1 where o1.T$ETIQ$C=o.T$ETIQ$C)
      and o.T$ETIQ$C=znfmd630.T$ETIQ$C
      and rownum=1) dofi_tp_estagio,
      znfmd630.t$ncar$c dofi_expedicao,
      znfmd061.t$creg$c dofi_id_regiao_transportadora,
      znfmd060.T$REFE$C dofi_id_estabelecimento,
      (select min(o.T$DATE$C) 
      from BAANDB.TZNFMD640201 o,
           BAANDB.TZNFMD030201 c
      where o.T$ETIQ$C=znfmd630.T$ETIQ$C
      and   c.t$ocin$c=o.T$COCI$C
      and   c.t$tent$c=1) peen_horario_inicial,
      (select max(o.T$DATE$C) 
      from BAANDB.TZNFMD640201 o,
           BAANDB.TZNFMD030201 c
      where o.T$ETIQ$C=znfmd630.T$ETIQ$C
      and   c.t$ocin$c=o.T$COCI$C
      and   c.t$tent$c=1) peen_horario_final,
      znsls401.t$dtep$c dofi_dt_prometida,
      tdsls400.t$ddat dofi_dt_entrega_prevista,
      znfmd060.t$cono$c dofi_id_contrato,
      znfmd630.t$fire$c dofi_id_documento_interno,
      201 dofi_cia,
      znsls400.t$dtem$c pedc_dt_emissao,
      znfmd060.t$ttra$c pedc_id_tipo_transporte,
      znsls401.t$dtep$c pedc_dt_limite_exp,
      znfmd630.t$docn$c nfca_ped_cliente,
      (select o.T$COCT$C 
      from BAANDB.TZNFMD640201 o
      where o.T$date$c=(select max(o1.T$date$c) from BAANDB.TZNFMD640201 o1 where o1.T$ETIQ$C=o.T$ETIQ$C)
      and o.T$ETIQ$C=znfmd630.T$ETIQ$C
      and rownum=1) octr_id_ocorrencia_interna,
      (select c.t$dsci$c
      from BAANDB.TZNFMD640201 o,
      BAANDB.TZNFMD030201 c
      where o.T$date$c=(select max(o1.T$date$c) from BAANDB.TZNFMD640201 o1 where o1.T$ETIQ$C=o.T$ETIQ$C)
      and o.T$ETIQ$C=znfmd630.T$ETIQ$C
      and   c.t$ocin$c=o.T$COCI$C
      and rownum=1) oces_nome,
      (select max(o.T$DATE$C) 
      from BAANDB.TZNFMD640201 o,
           BAANDB.TZNFMD030201 c
      where o.T$ETIQ$C=znfmd630.T$ETIQ$C
      and   c.t$ocin$c=o.T$COCI$C) octr_dt_ocorrencia,
      znsls401.t$ufen$c atdo_uf_destinatario,
      znsls401.t$cepe$c atdo_cep_dest,
      tcmcs080.t$seak tran_apelido,
      znfmd630.t$vlmr$c atdo_vl_total_nf,
      znfmd630.t$vlfr$c atdo_vl_frete_cli,
      (select sum(znfmd171.t$volu$c)
      from BAANDB.TZNFMD171201 znfmd171
      where znfmd171.t$nent$c=znfmd630.t$nent$c) atdo_volume_m3,
      znfmd630.t$qvol$c nfca_qt_volumes
from  BAANDB.TZNFMD630201 znfmd630,
      BAANDB.TZNSLS401201 znsls401,
      BAANDB.TZNSLS400201 znsls400,
      BAANDB.TZNFMD061201 znfmd061,
      BAANDB.TZNFMD060201 znfmd060,
      ttdsls401201 tdsls401,
      ttdsls400201 tdsls400,
      ttcmcs080201 tcmcs080
WHERE   znsls401.T$ORNO$C=znfmd630.T$ORNO$C
AND     znsls400.t$ncia$c=znsls401.t$ncia$c
AND     znsls400.t$uneg$c=znsls401.t$uneg$c
AND     znsls400.t$pecl$c=znsls401.t$pecl$c
AND     znsls400.t$sqpd$c=znsls401.t$sqpd$c
AND     znfmd061.T$CFRW$C=znfmd630.T$CFRW$C
AND     znfmd061.T$CONO$C=znfmd630.t$cono$c
AND     znfmd060.T$CFRW$C=znfmd630.T$CFRW$C
AND     znfmd060.T$CONO$C=znfmd630.t$cono$c
AND     tdsls401.t$orno=znsls401.T$ORNO$C
AND     tdsls401.t$pono=znsls401.T$PONO$C
AND     tdsls400.t$orno=tdsls401.t$orno
AND     tcmcs080.t$cfrw=znfmd630.T$CFRW$C