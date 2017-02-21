--  CREATE OR REPLACE FORCE VIEW "OWN_MIS"."VW_PEV_DET" ("DT_ULT_ATUALIZACAO", "CD_CIA", "CD_UNIDADE_NEGOCIO", "NR_ORDEM", "DT_COMPRA", "DT_ENTREGA", "CD_SITUACAO_PEDIDO", "CD_CANAL_VENDA", "CD_TIPO_ENTREGA", "NR_CNPJ_REDESPACHO", "CD_ITEM", "QT_ITENS", "VL_ITEM", "VL_DESCONTO_INCONDICIONAL", "VL_FRETE_CLIENTE", "VL_FRETE_CIA", "CD_VENDEDOR", "NR_LISTA_CASAMENTO", "DS_STATUS_PAGAMENTO", "DT_PAGAMENTO", "DS_UTM_PARCEIRO", "DS_UTM_MIDIA", "DS_UTM_CAMPANHA", "VL_DESPESA_ACESSORIO", "VL_JUROS", "VL_TOTAL_ITEM", "QT_ITENS_CANCELADOS", "CD_FILIAL", "CD_UNIDADE_EMPRESARIAL", "CD_TIPO_COMBO", "NR_PEDIDO", "NR_ENTREGA", "CD_CONTRATO_B2B", "CD_CAMPANHA_B2B", "CD_ORIGEM_PEDIDO", "CD_SITUACAO_NF", "CD_PRODUTO", "SQ_ORDEM", "CD_TIPO_ORDEM_VENDA", "IN_CANCELADO", "CD_LOJISTA_MKP", "CD_PRAZO_ENTREGA_FORNECEDOR", "CD_TIPO_ESTOQUE", "DT_PLAN_RECEBIMENTO") AS 
SELECT 
      tdsls401.t$rcd_utc                                      DT_ULT_ATUALIZACAO,
      znsls400.t$ncia$c                                       CD_CIA,
      znsls401.t$uneg$c                                       CD_UNIDADE_NEGOCIO,
      tdsls401.t$orno                                         NR_ORDEM,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)              DT_COMPRA,			
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)              DT_ENTREGA,
      
      CASE 
      WHEN tdsls401.t$clyn = 1 THEN 35 -- cancelado
      WHEN tdsls401.t$term = 1 THEN 30 -- finalizado
      WHEN tdsls401.t$modi = 1 THEN 25 -- modificado
      WHEN tdsls400.t$hdst = 20 THEN	 --
        CASE WHEN nvl((Select max(atv.t$xcsq) 
        From baandb.ttdsls413301 atv 
        where atv.t$orno = tdsls401.t$orno 
        and   atv.t$pono = tdsls401.t$pono 
        and   atv.t$xcst> = 15),99) = 99 THEN 10 ELSE 20 END
        ELSE tdsls400.t$hdst END                              CD_SITUACAO_PEDIDO,
        
      znsls400.t$idca$c                                       CD_CANAL_VENDA,
      znsls401.t$itpe$c                                       CD_TIPO_ENTREGA,  
      znsls401.t$eftr$c                                       NR_CNPJ_REDESPACHO, 
      ltrim(rtrim(tdsls401.t$item))                           CD_ITEM,
      tdsls401.t$qoor                                         QT_ITENS,
      tdsls401.t$qoor * tdsls401.t$pric                       VL_ITEM,
      znsls401.t$vldi$c                                       VL_DESCONTO_INCONDICIONAL,
      znsls401.t$vlfr$c                                       VL_FRETE_CLIENTE,

      nvl(cast(nvl((select min(f.t$vlfc$c) 
                    from baandb.tznfmd630301 f 
                    where f.t$fire$c = cisli940.t$fire$l),0) * 
                          (cisli941f.t$gamt$l / ( select sum(cisli941b.t$gamt$l)
                                                  from baandb.tcisli941301 cisli941b
                                                  inner join baandb.ttcibd001301 tcibd001b
                                                          on tcibd001b.T$ITEM = cisli941b.t$item$l
                                                  where cisli941b.t$fire$l = cisli941f.t$fire$l
                                                  --and cisli941b.t$line$l = cisli941f.t$line$l
                                                  and cisli941b.t$gamt$l! = 0 --#FAF.008.n
                                                  and tcibd001b.t$kitm<3)) as numeric(12,2)),0)            
                                                              VL_FRETE_CIA,	
	
  CASE WHEN znsls400.t$cven$c = 100 
    THEN NULL 
    ELSE znsls400.t$cven$c END                                CD_VENDEDOR,
  znsls400.t$idli$c                                           NR_LISTA_CASAMENTO,
  'Aprovados'                                                 DS_STATUS_PAGAMENTO,        
   
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtap$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)              DT_PAGAMENTO,                -- **** DESCONSIDERAR - SOMENTE PGTO APROVADOS ESTÃO NO LN
  ' '                                                         DS_UTM_PARCEIRO,             -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
  ' '                                                         DS_UTM_MIDIA,                -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
  ' '                                                         DS_UTM_CAMPANHA,             -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
  znsls401.t$vlde$c                                           VL_DESPESA_ACESSORIO,

  case when sls401p.VL_PGTO_PED = 0 then 0 
    else 
      CASE WHEN znsls402.t$vlju$c IS NULL THEN cast(0.0 as numeric(12,2))
        ELSE
          cast((((znsls401.t$vlun$c*znsls401.t$qtve$c)+
                  znsls401.t$vlfr$c-znsls401.t$vldi$c+
                  znsls401.t$vlde$c)/sls401p.VL_PGTO_PED)
                  *znsls402.t$vlju$c as numeric(12,2)) END 
  end                                                         VL_JUROS,

  CASE WHEN ZNSLS402.t$vlju$c IS NULL OR sls401p.VL_PGTO_PED = 0 THEN
    cast((znsls401.t$vlun$c*znsls401.t$qtve$c)+
          znsls401.t$vlfr$c-znsls401.t$vldi$c+
          znsls401.t$vlde$c as numeric(18,2))
  ELSE
    cast((znsls401.t$vlun$c*znsls401.t$qtve$c)+
          znsls401.t$vlfr$c-znsls401.t$vldi$c+
          znsls401.t$vlde$c+(((znsls401.t$vlun$c*znsls401.t$qtve$c)
          +znsls401.t$vlfr$c-znsls401.t$vldi$c+znsls401.t$vlde$c)      
          /sls401p.VL_PGTO_PED)*znsls402.t$vlju$c as numeric(18,2)) 
  END                                                       VL_TOTAL_ITEM,
  
  (SELECT Count(lc.t$pono)
    FROM  baandb.ttdsls401301 lc
      WHERE lc.t$orno = tdsls401.t$orno
      AND   lc.t$pono = tdsls401.t$pono
      AND   lc.t$clyn = 1)                                  QT_ITENS_CANCELADOS,

  case when tcemm030.t$euca  =  ' ' 
    then substr(tcemm124.t$grid,-2,2) 
    else tcemm030.t$euca 
  end as                                                    CD_FILIAL,
  tcemm124.t$grid                                           CD_UNIDADE_EMPRESARIAL,
  znsls401.t$tpcb$c                                         CD_TIPO_COMBO,
  znsls401.t$pecl$c                                         NR_PEDIDO,
  TO_CHAR(znsls401.T$ENTR$C)                                NR_ENTREGA,
  znsls400.t$idco$c                                         CD_CONTRATO_B2B,
  znsls400.t$idCP$c                                         CD_CAMPANHA_B2B,
  znsls004.t$orig$c                                         CD_ORIGEM_PEDIDO,
  cisli940.t$stat$l                                         CD_SITUACAO_NF,	

  CASE WHEN znsls401.t$igar$c = 0 
    THEN ltrim(rtrim(tdsls401.t$item))
    ELSE TO_CHAR(znsls401.t$igar$c) END                     CD_PRODUTO,
  CAST(tdsls401.t$pono as varchar(10))                      SQ_ORDEM,	
  tdsls400.t$sotp                                           CD_TIPO_ORDEM_VENDA,
  case when znsls401.t$qtve$c<0 
    then 2 
    else 1 end                                              IN_CANCELADO,

  znsls401.t$idlo$c                                         CD_LOJISTA_MKP,
  znsls401.t$pzfo$c                                         CD_PRAZO_ENTREGA_FORNECEDOR, 
  znsls401.t$tpes$c                                         CD_TIPO_ESTOQUE,
  tdsls401.T$PRDT                                           DT_PLAN_RECEBIMENTO
  
FROM baandb.ttdsls401301 tdsls401

LEFT JOIN ( select  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$sequ$c,
                    a.t$orno$c,
                    a.t$pono$c,
                    a.t$orig$c
          from baandb.tznsls004301 a
          group by  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$sequ$c,
                    a.t$orno$c,
                    a.t$pono$c,
                    a.t$orig$c ) znsls004 									
      ON znsls004.t$orno$c = tdsls401.t$orno
     AND znsls004.t$pono$c = tdsls401.t$pono

INNER JOIN baandb.tznsls401301 znsls401
        ON znsls401.t$ncia$c = znsls004.t$ncia$c
       AND znsls401.t$uneg$c = znsls004.t$uneg$c
       AND znsls401.t$pecl$c = znsls004.t$pecl$c
       AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
       AND znsls401.t$entr$c = znsls004.t$entr$c
       AND znsls401.t$sequ$c = znsls004.t$sequ$c
      
LEFT JOIN ( select a.t$slso,
                   a.t$pono,
                   a.t$ortp,
                   a.t$koor,
                   a.t$fire$l,
                   a.t$line$l
            from baandb.tcisli245301 a 
            group by a.t$slso,
                     a.t$pono,
                     a.t$ortp,
                     a.t$koor,
                     a.t$fire$l,
                     a.t$line$l) cisli245   
       ON cisli245.t$slso = tdsls401.t$orno
      AND cisli245.t$pono = tdsls401.t$pono
      AND cisli245.t$ortp = 1   -- Ordem/programação de Venda
      AND cisli245.t$koor = 3   -- Ordem de Venda
                
LEFT JOIN baandb.tcisli940301 cisli940
       ON cisli940.t$fire$l = cisli245.t$fire$l

LEFT JOIN baandb.tcisli941301 cisli941f
       ON cisli941f.t$fire$l = cisli245.t$fire$l
      AND cisli941f.t$line$l = cisli245.t$line$l  	   
   
INNER JOIN baandb.ttdsls400301 tdsls400
        ON tdsls400.t$orno = tdsls401.t$orno
        
INNER JOIN baandb.ttcemm124301 tcemm124
        ON tcemm124.t$cwoc = tdsls400.t$cofc

INNER JOIN baandb.ttcemm030301 tcemm030
       ON	tcemm030.t$eunt = tcemm124.t$grid

INNER JOIN baandb.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c

INNER JOIN (select																
                  a.t$ncia$c,
                  a.t$uneg$c,
                  a.t$pecl$c,
                  a.t$sqpd$c,
                  sum((a.t$vlun$c*a.t$qtve$c)+a.t$vlfr$c-a.t$vldi$c+a.t$vlde$c) VL_PGTO_PED		
              from baandb.tznsls401301 a
              group by
                  a.t$ncia$c,																				
                  a.t$uneg$c,
                  a.t$pecl$c,
                  a.t$sqpd$c) sls401p
        ON	  sls401p.t$ncia$c = znsls401.t$ncia$c															
       AND    sls401p.t$uneg$c = znsls401.t$uneg$c
       AND    sls401p.t$pecl$c = znsls401.t$pecl$c
       AND    sls401p.t$sqpd$c = znsls401.t$sqpd$c																					

  LEFT JOIN (select	sum(a.t$vlju$c) t$vlju$c,
                    a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c
            from baandb.tznsls402301 a
            group by
                a.t$ncia$c,
                a.t$uneg$c,
                a.t$pecl$c,
                a.t$sqpd$c) znsls402																		
         ON	   znsls402.t$ncia$c = znsls401.t$ncia$c
        AND    znsls402.t$uneg$c = znsls401.t$uneg$c
        AND    znsls402.t$pecl$c = znsls401.t$pecl$c
        AND    znsls402.t$sqpd$c = znsls401.t$sqpd$c

LEFT JOIN baandb.tznsls000301 znsls000
       ON trunc(znsls000.t$indt$c) = TO_DATE('01-01-1970', 'DD-MM-YYYY')
       
WHERE tdsls400.t$fdty$l != 14 --Retorno de Mercadoria Cliente
  AND znsls401.t$qtve$c > 0 --não está trazendo as devoluções
  AND tdsls401.t$oltp = 2  --linha da ordem/entrega
  AND tdsls401.t$item not in (znsls000.t$itmf$c, znsls000.t$itmd$c, znsls000.t$itjl$c)    --Frete, Juros, Despesas
;
