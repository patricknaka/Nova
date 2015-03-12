SELECT 
  DISTINCT
    tccom130.t$fovn$l   CNPJ_FILIAL,
    tccom130.t$nama     NOME,
    tccom130.t$pstc     CEP,
    tccom130.t$namc || 
    tccom130.t$namd     FILI_ENDERECO,
    tccom130.t$hono     FILI_NUMERO,
    tccom130.t$dist$l   FILI_BAIRRO,
    tccom139.t$dsca     MUNI_NOME,
    tccom130.t$cste     UF,
    tccom130.t$ccty     PAIS,
    tccom130.t$telp     FILI_TEL,
    tccom130.t$telx     FILI_TEL2,
    ' '                 TRCE_COD_SERVICO,
    znfmd630.t$etiq$c   ATVO_NUM_ETIQUETA,
    znfmd630.t$cono$c   TRCE_NUM_CONTRATO,
    znsls401.t$nome$c   CLIE_NOME,
    znsls401.t$cepe$c   CEP_DEST,
    znsls401.t$loge$c   LOGRADOURO,
    znsls401.t$nume$c   NUM_ENDERECO_DESTINATARIO,
    znsls401.t$refe$c   REFERENCIA_ENDERECO,
    znsls401.t$baie$c   BAIRRO_DESTINATARIO,
    znsls401.t$cide$c   CIDADE_DESTINATARIO,
    znsls401.t$ufen$c   UF_DESTINATARIO,
    znsls401.t$paie$c   PAIS_DESTINATARIO,
    znsls401.t$tele$c   CLIE_TEL,
    znsls401.t$te1e$c   CLIE_TEL1,
    ' '                 TRCE_STR_UND_VINCULACAO,
    znsls401.t$entr$c   PEDC_ID_PEDIDO
                
    FROM  baandb.tznsls401301 znsls401

LEFT JOIN baandb.tznfmd630301 znfmd630
       ON znfmd630.t$orno$c = znsls401.t$orno$c
                
LEFT JOIN baandb.ttdsls400301 tdsls400
       ON tdsls400.t$orno = znsls401.t$orno$c
       
LEFT JOIN baandb.ttcmcs065301 tcmcs065
       ON tcmcs065.t$cwoc = tdsls400.t$cofc
       
LEFT JOIN baandb.ttccom130301 tccom130
       ON tccom130.t$cadr = tcmcs065.t$cadr
       
LEFT JOIN baandb.ttccom139301 tccom139
       ON tccom139.t$ccty = tccom130.t$ccty
      AND tccom139.t$cste = tccom130.t$cste
      AND tccom139.t$city = tccom130.t$ccit
   
WHERE ( (:EntregaTodas = 0) or (znsls401.t$entr$c IN (:Entrega) and (:EntregaTodas = 1)) )