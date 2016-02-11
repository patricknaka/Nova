SELECT DISTINCT
-- detalhe alterada Rosana
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(greatest(tdsls400.t$rcd_utc, tdsls401.t$rcd_utc), 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)        DT_ULT_ATUALIZACAO,
  znsls400.t$ncia$c                                     CD_CIA,
  znsls401.t$uneg$c                                     CD_UNIDADE_NEGOCIO,
  tdsls401.t$orno                                       NR_ORDEM,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)        DT_COMPRA,			
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)        DT_ENTREGA,
  CASE 
    WHEN tdsls401.t$clyn = 1 THEN 35 -- cancelado
    WHEN tdsls401.t$term = 1 THEN 30	  -- finalizado
    WHEN tdsls401.t$modi = 1 THEN 25	  -- modificado
    WHEN tdsls400.t$hdst = 20 THEN	  --
        CASE WHEN nvl((Select max(atv.t$xcsq) 
        From baandb.ttdsls413201 atv 
        where atv.t$orno = tdsls401.t$orno 
        and   atv.t$pono = tdsls401.t$pono 
        and   atv.t$xcst> = 15),99) = 99 THEN 10 ELSE 20 END
    ELSE tdsls400.t$hdst END                          CD_SITUACAO_PEDIDO,
  znsls400.t$idca$c                                   CD_CANAL_VENDA,
  znsls401.t$itpe$c                                   CD_TIPO_ENTREGA,  
  znsls401.t$eftr$c                                   NR_CNPJ_REDESPACHO, 
  ltrim(rtrim(tdsls401.t$item))                       CD_ITEM,
  tdsls401.QTDE_TOT                                   QT_ITENS,
  tdsls401.VL_TOT                                     VL_ITEM,
  znsls401.t$vldi$c                                   VL_DESCONTO_INCONDICIONAL,
  znsls401.t$vlfr$c                                   VL_FRETE_CLIENTE,
  nvl((select sum(f.t$vlft$c) 
    from baandb.tznfmd630201 f
    where f.t$pecl$c = znsls400.t$pecl$c),0)          VL_FRETE_CIA,
  CASE WHEN znsls400.t$cven$c = 100 
    THEN NULL 
    ELSE znsls400.t$cven$c END                        CD_VENDEDOR,
  znsls400.t$idli$c                                   NR_LISTA_CASAMENTO,
  'Aprovados'                                         DS_STATUS_PAGAMENTO,        
  ' '                                                 DT_PAGAMENTO,                -- **** DESCONSIDERAR - SOMENTE PGTO APROVADOS ESTÃO NO LN
  ' '                                                 DS_UTM_PARCEIRO,             -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
  ' '                                                 DS_UTM_MIDIA,                -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
  ' '                                                 DS_UTM_CAMPANHA,             -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
  znsls401.t$vlde$c                                   VL_DESPESA_ACESSORIO,

  case when sls401p.VL_PGTO_PED = 0 then 0 
    else 
      CASE WHEN znsls402.t$vlju$c IS NULL THEN cast(0.0 as numeric(12,2))
        ELSE
          cast((((znsls401.t$vlun$c*znsls401.t$qtve$c)+
                  znsls401.t$vlfr$c-znsls401.t$vldi$c+
                  znsls401.t$vlde$c)/sls401p.VL_PGTO_PED)
                  *znsls402.t$vlju$c as numeric(12,2)) END 
  end                                                 VL_JUROS,

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
  END                                                 VL_TOTAL_ITEM,														

  (SELECT Count(lc.t$pono)
    FROM  baandb.ttdsls401201 lc
      WHERE lc.t$orno = tdsls401.t$orno
      AND   lc.t$pono = tdsls401.t$pono
      AND   lc.t$clyn = 1)                            QT_ITENS_CANCELADOS,

  case when tcemm030.t$euca  =  ' ' 
    then substr(tcemm124.t$grid,-2,2) 
    else tcemm030.t$euca 
  end as                                              CD_FILIAL,
  tcemm124.t$grid                                     CD_UNIDADE_EMPRESARIAL,
  znsls401.t$tpcb$c                                   CD_TIPO_COMBO,
  znsls401.t$pecl$c                                   NR_PEDIDO,
  TO_CHAR(znsls401.T$ENTR$C)                          NR_ENTREGA,
  znsls400.t$idco$c                                   CD_CONTRATO_B2B,
  znsls400.t$idCP$c                                   CD_CAMPANHA_B2B,
  znsls004.t$orig$c                                   CD_ORIGEM_PEDIDO,
  cisli940.t$stat$l                                   CD_SITUACAO_NF,	

  CASE WHEN znsls401.t$igar$c = 0 
    THEN ltrim(rtrim(tdsls401.t$item))
    ELSE TO_CHAR(znsls401.t$igar$c) END               CD_PRODUTO,
  CAST(tdsls401.t$pono as varchar(10))                SQ_ORDEM,	
  tdsls400.t$sotp                                     CD_TIPO_ORDEM_VENDA,
  case when znsls401.t$qtve$c<0 
    then 2 
    else 1 end                                        IN_CANCELADO,

  znsls401.t$idlo$c                                   CD_LOJISTA_MKP,
  znsls401.t$pzfo$c                                   CD_PRAZO_ENTREGA_FORNECEDOR, 
  znsls401.t$tpes$c                                   CD_TIPO_ESTOQUE
  
FROM ( select a.t$orno,
              a.t$pono,
              a.t$item,
              a.t$clyn,
              a.t$term,
              a.t$modi,
              MAX(a.t$rcd_utc) t$rcd_utc,
              sum(a.t$qoor) QTDE_TOT,
              sum(a.t$pric * a.t$qoor) VL_TOT
        from baandb.ttdsls401201 a
        where a.t$oltp = 2  --linha da ordem/entrega
        group by a.t$orno,
                 a.t$pono,
                 a.t$item,
                 a.t$clyn,
                 a.t$term,
                 a.t$modi ) tdsls401

LEFT JOIN ( select a.t$slso,
                   a.t$pono,
                   a.t$ortp,
                   a.t$koor,
                   a.t$fire$l,
                   a.t$line$l
            from baandb.tcisli245201 a 
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
                
LEFT JOIN baandb.tcisli940201 cisli940
       ON cisli940.t$fire$l = cisli245.t$fire$l

INNER JOIN baandb.tznsls401201 znsls401
        ON znsls401.t$orno$c = tdsls401.t$orno
       AND znsls401.t$pono$c = tdsls401.t$pono
		
LEFT JOIN baandb.tznsls004201 znsls004 									
       ON	znsls004.t$ncia$c = znsls401.t$ncia$c
      AND znsls004.t$uneg$c = znsls401.t$uneg$c
      AND znsls004.t$pecl$c = znsls401.t$pecl$c
      AND znsls004.t$sqpd$c = znsls401.t$sqpd$c
      AND znsls004.t$entr$c = znsls401.t$entr$c
      AND znsls004.t$sequ$c = znsls401.t$sequ$c										
      AND znsls004.t$orno$c = znsls401.t$orno$c  						
      AND znsls004.t$pono$c = znsls401.t$pono$c										
		
INNER JOIN baandb.ttdsls400201 tdsls400
        ON tdsls400.t$orno = tdsls401.t$orno
        
INNER JOIN baandb.ttcemm124201 tcemm124
        ON tcemm124.t$cwoc = tdsls400.t$cofc

INNER JOIN baandb.ttcemm030201 tcemm030
       ON	tcemm030.t$eunt = tcemm124.t$grid

INNER JOIN baandb.tznsls400201 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c

INNER JOIN (select distinct 																									
                  znsls401t.t$ncia$c       t$ncia$c,
                  znsls401t.t$uneg$c       t$uneg$c,
                  znsls401t.t$pecl$c       t$pecl$c,
                  znsls401t.t$sqpd$c       t$sqpd$c,
                  sum((znsls401t.t$vlun$c*znsls401t.t$qtve$c)+znsls401t.t$vlfr$c-znsls401t.t$vldi$c+znsls401t.t$vlde$c) VL_PGTO_PED		
              from baandb.tznsls401201 znsls401t
            group by
                  znsls401t.t$ncia$c,																				
                  znsls401t.t$uneg$c,
                  znsls401t.t$pecl$c,
                  znsls401t.t$sqpd$c) sls401p
        ON	  sls401p.t$ncia$c = znsls401.t$ncia$c															
       AND    sls401p.t$uneg$c = znsls401.t$uneg$c
       AND    sls401p.t$pecl$c = znsls401.t$pecl$c
       AND    sls401p.t$sqpd$c = znsls401.t$sqpd$c																					

  LEFT JOIN (select	sum(znsls402t.t$vlju$c) t$vlju$c,
                    znsls402t.t$ncia$c,
                    znsls402t.t$uneg$c,
                    znsls402t.t$pecl$c,
                    znsls402t.t$sqpd$c
            from baandb.tznsls402201 znsls402t
            group by
                znsls402t.t$ncia$c,
                znsls402t.t$uneg$c,
                znsls402t.t$pecl$c,
                znsls402t.t$sqpd$c) znsls402																		
         ON	   znsls402.t$ncia$c = znsls401.t$ncia$c
        AND    znsls402.t$uneg$c = znsls401.t$uneg$c
        AND    znsls402.t$pecl$c = znsls401.t$pecl$c
        AND    znsls402.t$sqpd$c = znsls401.t$sqpd$c

WHERE tdsls400.t$fdty$l != 14 --Retorno de Mercadoria Cliente
and znsls401.t$qtve$c > 0 --não está trazendo as devoluções