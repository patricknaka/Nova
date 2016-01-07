select 

  znfmd630.t$cfrw$c     ID_TRANSP,
  znfmd630.t$cono$c     NR_CONTRATO,
  znfmd630.t$fili$c     CD_FILIAL,
  znfmd630.t$ngai$c     NR_GAIOLA,
  znfmd630.t$etiq$c     NR_ETIQUETA,
  znfmd630.t$ncol$c     NR_COLETA,
  znfmd630.t$ncar$c     NR_CARGA,
  znfmd630.t$pecl$c     NR_ENTREGA,
  znfmd630.t$orno$c     NR_ORDEM,
  znfmd630.t$nent$c     NR_ENTRADA_CARGA_DESCARGA,
  znfmd630.t$fire$c     NR_REFERENCIA_FISCAL,
  znfmd630.t$nrec$c     NR_RECONCILIACAO,
  znfmd630.t$rfec$c     IN_RECONCILIACAO,
  znfmd630.t$stat$c     CD_STATUS,
  znfmd630.t$frty$c     CD_NATUREZA_FRETE,
  znfmd630.t$reet$c     IN_REENTREGA,
  znfmd630.t$sqrt$c     SQ_REENTREGA,
  znfmd630.t$vlsg$c     VL_SEGURO,
  znfmd630.t$vlfr$c     VL_FRETE_CLIENTE,
  znfmd630.t$frpe$c     VL_FRETE_PESO,
  znfmd630.t$vlfc$c     VL_FRETE_TRANSP_CALCULADO,
  znfmd630.t$vlft$c     VL_FRETE_TRANSP_COBRADO,
  znfmd630.t$vlfa$c     VL_FRETE_ACERTADO,
  znfmd630.t$advc$c     VL_AD_VALOREM_CALCULADO,
  znfmd630.t$pedc$c     VL_PEDAGIO_CALCULADO,
  znfmd630.t$rfdt$c     CD_TIPO_DOCTO_FISCAL,
  znfmd630.t$potp$c     CD_TIPO_ORDEM_COMPRA,
  znfmd630.t$txre$c     CD_REFERENCIA_IMPOSTO,
  znfmd630.t$pfir$c     CD_PRE_RECEBIMENTO,
  znfmd630.t$obje$c     NR_OBJETO,
  case when to_char(to_date(znfmd630.t$dten$c), 'yyyy') = 1969 then null 
       when to_char(to_date(znfmd630.t$dten$c), 'yyyy') = 1970 then null 
  else  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dten$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)  
  END                   DT_ENTREGA,
  znfmd630.t$stpr$c     CD_STATUS_PROCESSAMENTO,
  znfmd630.t$nump$c     NR_PEDIDO_FRETE,
  znfmd630.t$torg$c     CD_ORIGEM_ORDEM_FRETE,

  case when to_char(to_date(znfmd630.t$dtco$c), 'yyyy') = 1969 then null 
       when to_char(to_date(znfmd630.t$dtco$c), 'yyyy') = 1970 then null 
  else CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) 
  end                   DT_CORRIGIDA,

  case when to_char(to_date(znfmd630.t$dtpe$c), 'yyyy') = 1969 then null 
       when to_char(to_date(znfmd630.t$dtpe$c), 'yyyy') = 1970 then null 
  else CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtpe$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) 
  end                   DT_PREVISTA_ENTREGA

from baandb.tznfmd630201 znfmd630