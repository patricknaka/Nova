select distinct
      znsls401.T$NCIA$C CD_FILIAL,
      znint002.T$DESC$C NM_UNIDADE_NEGOCIO,
      (select min(o.T$DATE$C) from BAANDB.TZNFMD640201 o
		where o.T$COCI$C='ROT' and o.T$ETIQ$C=znfmd630.T$ETIQ$C) DT_SAIDA_ENTREGA,
      znsls401.T$pecl$C NR_PEDIDO,
      znfmd630.T$pecl$C NR_ENTREGA,
      znfmd630.t$vlft$c VL_FRETE_PAGAR_GARANTIA,
      znsls002.T$DSCA$C DS_TIPO_ENTREGA,
      (select min(o.T$DATE$C) from BAANDB.TZNFMD640201 o
		where o.T$COCI$C='ENT' and o.T$ETIQ$C=znfmd630.T$ETIQ$C) DT_ENTREGA_REALIZADA,
      CASE WHEN znfmd630.t$stat$c='F' THEN 'FINALIZADO' ELSE 'EM PROCESSO' END NM_TIPO_ESTAGIO,
      --znfmd630.t$ncar$c NR_EXPEDICAO,
      --' ' CD_REGIAO_TRANSPORTADORA,
      znfmd630.T$FILI$C CD_ESTABELECIMENTO,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE) DT_PROMETIDA,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE) DT_ENTREGA_PREVISTA,
      znfmd630.t$fire$c NR_REFERENCIA_FISCAL,
      --201 CD_CIA,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE) DT_EMISSAO_PEDIDO,    
      znfmd060.t$ttra$c CD_TIPO_TRANSPORTE,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls401.t$rdta, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE) DT_LIMITE_EXPEDICAO,    
      (select o.T$COCI$C from BAANDB.TZNFMD640201 o
		where o.T$date$c=(select max(o1.T$date$c) from BAANDB.TZNFMD640201 o1 where o1.T$ETIQ$C=o.T$ETIQ$C)
		and o.T$ETIQ$C=znfmd630.T$ETIQ$C and rownum=1) CD_OCORRENCIA_INTERNA,
      (select c.t$dsci$c from BAANDB.TZNFMD640201 o, BAANDB.TZNFMD030201 c
		where o.T$date$c=(select max(o1.T$date$c) from BAANDB.TZNFMD640201 o1 where o1.T$ETIQ$C=o.T$ETIQ$C)
		and o.T$ETIQ$C=znfmd630.T$ETIQ$C and c.t$ocin$c=o.T$COCI$C and rownum=1) DS_OCORRENCIA_INTERNA,
      (select max(o.T$DATE$C) from BAANDB.TZNFMD640201 o, BAANDB.TZNFMD030201 c
		where o.T$ETIQ$C=znfmd630.T$ETIQ$C and c.t$ocin$c=o.T$COCI$C) DT_OCORRENCIA,
      znsls401.t$ufen$c NM_UF_DESTINATARIO,
      to_char(znsls401.t$cepe$c) CD_CEP_DESTINATARIO,
      tcmcs080.t$seak NM_APELIDO_TRANSPORTADORA,
      cisli940.t$amnt$l VL_TOTAL_NF,
      znfmd630.t$vlfr$c VL_TOTAL_FRETE_CLIENTE,
      (select sum(nl.t$dqua$l) from baandb.tcisli941201 nl, baandb.ttcibd001201 i
		where nl.t$fire$l=znfmd630.t$fire$c
		and i.t$item=nl.t$item$l
		and i.t$kitm<3) QT_VOLUMES
from  BAANDB.TZNFMD630201 znfmd630,
      BAANDB.TZNSLS401201 znsls401,
      BAANDB.TZNSLS400201 znsls400,
      BAANDB.TZNFMD061201 znfmd061,
      BAANDB.TZNFMD060201 znfmd060,
      baandb.ttdsls401201 tdsls401,
      baandb.ttdsls400201 tdsls400,
      baandb.ttcmcs080201 tcmcs080,
      baandb.tznint002201 znint002,
      baandb.tznsls002201 znsls002,
      BAANDB.tznfmd001201 znfmd001,
      baandb.tcisli940201 cisli940
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
AND     znint002.T$NCIA$C=znsls400.T$NCIA$C
AND     znint002.T$UNEG$C=znsls400.t$uneg$c
AND     znsls002.T$TPEN$C=znsls401.t$itpe$c
AND     cisli940.t$fire$l=znfmd630.t$fire$c