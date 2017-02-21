
--  CREATE OR REPLACE FORCE VIEW "OWN_MIS"."VW_PEV_PAGAMENTO" ("DT_ULT_ATUALIZACAO", "CD_CIA", "NR_ORDEM", "NR_PEDIDO", "NR_ENTREGA", "SQ_PAGAMENTO", "CD_MEIO_PAGAMENTO", "CD_BANDEIRA", "CD_BANCO", "NR_PARCELA", "VL_PAGAMENTO", "CD_STATUS_PAGAMENTO", "IN_VALE_LISTA_CASAMENTO", "DT_EMISSAO_PEDIDO", "CD_UNIDADE_NEGOCIO", "DT_APROVACAO", "VL_ORIGINAL", "VL_JUROS_ADMINISTRADORA", "IN_JUROS_ADMINISTRADORA", "DT_APROVACAO_PAGAMENTO_ERP", "VL_JUROS", "CD_CICLO_PAGAMENTO", "NR_TABELA_NEGOCIACAO", "NR_BIN_CARTAO_CREDITO", "NR_NSU_TRANSACAO_CARTAO", "NR_NSU_AUTOR_CARTAO", "CD_AUTOR_CARTAO_CREDITO", "NR_MAQUINETA", "NR_TERMINAL", "CD_MOTIVO_REPROVACAO", "DS_MOTIVO_REPROVACAO", "NR_AGENCIA", "NR_CONTA_CORRENTE", "CD_ADQUIRENTE", "NR_BPAG") AS 
  select
  
   tdsls400.t$rcd_utc                                                         DT_ULT_ATUALIZACAO,
   znsls400.t$ncia$c                                                          CD_CIA,
   tdsls400.t$orno                                                            NR_ORDEM,
   TRIM(sls401q.t$pecl$c)                                                     NR_PEDIDO,
   TO_CHAR(sls401q.t$entr$c)                                                  NR_ENTREGA,
   znsls402.t$sequ$c                                                          SQ_PAGAMENTO,
   znsls402.t$idmp$c                                                          CD_MEIO_PAGAMENTO,

   CASE WHEN (znsls402.t$idmp$c = 4) 
     THEN 0 
     ELSE znsls402.t$cccd$c END                                               CD_BANDEIRA,

   CASE WHEN (znsls402.t$idmp$c = 4) 
     THEN 0 
     ELSE znsls402.t$idbc$c END                                               CD_BANCO,

   znsls402.t$nupa$c                                                          NR_PARCELA,
   
   case when sls401p.VL_PGTO_PED = 0 
     then 0 
     else cast((sls401q.VL_PGTO_ENTR/sls401p.VL_PGTO_PED)*znsls402.t$vlmr$c as numeric(12,2)) 
     end                                                                      VL_PAGAMENTO,

   znsls402.t$stat$c                                                          CD_STATUS_PAGAMENTO,

   CASE WHEN (znsls402.t$idmp$c = 4 and znsls400.t$idli$c!=0) 
     THEN 1 
     ELSE 2 END                                                               IN_VALE_LISTA_CASAMENTO,

   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
     AT time zone 'America/Sao_Paulo') AS DATE)                               DT_EMISSAO_PEDIDO,

   znsls402.t$uneg$c                                                          CD_UNIDADE_NEGOCIO,	

   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$dtra$c, 
     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
     AT time zone 'America/Sao_Paulo') AS DATE)                               DT_APROVACAO,

   znsls402.t$valo$c                                                          VL_ORIGINAL,

   case when sls401p.VL_PGTO_PED = 0 
     then 0
     else cast((sls401q.VL_PGTO_ENTR/sls401p.VL_PGTO_PED)*znsls402.t$vlja$c as numeric(12,2)) 
     end                                                                      VL_JUROS_ADMINISTRADORA,

   CASE WHEN znsls402.t$vlja$c!=0 
     THEN 1
     ELSE 2
     END                                                                      IN_JUROS_ADMINISTRADORA,

   (select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(a.t$trdt), 
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
    from baandb.ttdsls451301 a
    where a.t$orno=tdsls400.t$orno)                                           DT_APROVACAO_PAGAMENTO_ERP,

   case when sls401p.VL_PGTO_PED = 0 
     then 0 
     else cast((sls401q.VL_PGTO_ENTR/sls401p.VL_PGTO_PED)*znsls402.t$vlju$c  as numeric(12,2)) 
     end                                                                      VL_JUROS,

   -- *** NÃO EXISTE ESTA INFORMAÇÃO NO LN / PENDENTE DE DUVIDA ***
   ' '                                                                        CD_CICLO_PAGAMENTO, 
   znsls402.t$cone$c                                                          NR_TABELA_NEGOCIACAO,
   znsls402.t$ncam$c                                                          NR_BIN_CARTAO_CREDITO,
   znsls402.t$nctf$c                                                          NR_NSU_TRANSACAO_CARTAO,
   znsls402.t$nsua$c                                                          NR_NSU_AUTOR_CARTAO,
   znsls402.t$auto$c                                                          CD_AUTOR_CARTAO_CREDITO,
   znsls402.t$maqu$c                                                          NR_MAQUINETA,
   TO_CHAR(znsls402.t$nute$c)                                                 NR_TERMINAL,															
   znsls402.t$mrep$c                                                          CD_MOTIVO_REPROVACAO,
   znsls402.t$txrp$c                                                          DS_MOTIVO_REPROVACAO,															
   znsls402.t$idag$c                                                          NR_AGENCIA,
   znsls402.t$idct$c                                                          NR_CONTA_CORRENTE,
   case when znsls402.t$idad$c = ' '  then null else   znsls402.t$idad$c end  CD_ADQUIRENTE,																		
   znsls402.t$bopg$c                                                          NR_BPAG

FROM  baandb.tznsls400301 znsls400

INNER JOIN   (select  znsls401.t$ncia$c t$ncia$c,
                      znsls401.t$uneg$c t$uneg$c,
                      znsls401.t$pecl$c t$pecl$c,
                      znsls401.t$sqpd$c t$sqpd$c,
                      znsls401.t$entr$c t$entr$c,
                      znsls401.t$orno$c t$orno$c,
                      sum((znsls401.t$vlun$c*znsls401.t$qtve$c)+
                      znsls401.t$vlfr$c-znsls401.t$vldi$c+
                      znsls401.t$vlde$c) VL_PGTO_ENTR	
              from baandb.tznsls401301 znsls401
              group by  znsls401.t$ncia$c, znsls401.t$uneg$c,
                        znsls401.t$pecl$c, znsls401.t$sqpd$c,
                        znsls401.t$entr$c, znsls401.t$orno$c) sls401q
      ON sls401q.t$ncia$c = znsls400.t$ncia$c
     AND sls401q.t$uneg$c = znsls400.t$uneg$c
     AND sls401q.t$pecl$c = znsls400.t$pecl$c
     AND sls401q.t$sqpd$c = znsls400.t$sqpd$c
		
INNER JOIN   (select  znsls401.t$ncia$c t$ncia$c,
                      znsls401.t$uneg$c t$uneg$c,
                      znsls401.t$pecl$c t$pecl$c,
                      znsls401.t$sqpd$c t$sqpd$c,
                      sum(( znsls401.t$vlun$c*znsls401.t$qtve$c)+
                            znsls401.t$vlfr$c-znsls401.t$vldi$c+
                            znsls401.t$vlde$c) VL_PGTO_PED		
              from baandb.tznsls401301 znsls401
              group by  znsls401.t$ncia$c, znsls401.t$uneg$c,
                        znsls401.t$pecl$c, znsls401.t$sqpd$c) sls401p
        ON sls401p.t$ncia$c=znsls400.t$ncia$c																			
       AND sls401p.t$uneg$c=znsls400.t$uneg$c
       AND sls401p.t$pecl$c=znsls400.t$pecl$c
       AND sls401p.t$sqpd$c=znsls400.t$sqpd$c
  
INNER JOIN baandb.ttdsls400301 tdsls400
        ON tdsls400.t$orno = sls401q.t$orno$c

INNER JOIN baandb.tznsls402301 znsls402
        ON znsls402.t$ncia$c = znsls400.t$ncia$c
       AND znsls402.t$uneg$c = znsls400.t$uneg$c
       AND znsls402.t$pecl$c = znsls400.t$pecl$c
       AND znsls402.t$sqpd$c = znsls400.t$sqpd$c    
;
