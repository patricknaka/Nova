SELECT
    case when zncom005.t$cdve$c = ' ' 
      then null else zncom005.t$cdve$c end                        NR_GARANTIA_ESTENDIDA,
    tdsls400.t$hdst                                               CD_STATUS_PEDIDO,                     
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)                DT_EMISSAO_GARANTIA,                      
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)                DT_PEDIDO_PRODUTO,                        
    NVL(cast(ltrim(rtrim(tdsls401p.t$item)) as varchar2(15)),' ') CD_ITEM,              
    NVL(cast(ltrim(rtrim(tdsls401.t$item)) as varchar2(15)),' ')  CD_ITEM_GARANTIA,                                  
    sum(tdsls401.t$pric)/count(tdsls401.t$qoor)                   VL_CUSTO,
    max(tdsls401.t$pric)                                          VL_GARANTIA,
    sum(zncom005.t$piof$c)                                        VL_IOF,                    
    sum(zncom005.t$ppis$c)                                        VL_PIS,
    sum(zncom005.t$pcof$c)                                        VL_COFINS,
    nvl((select a.t$amnt$l 
      from baandb.tcisli943201 a
        where a.t$fire$l=zncom005.t$fire$c
        and a.t$line$l=zncom005.t$line$c
        and a.t$brty$l=13),0)                                     VL_CSLL,                            
    sum(zncom005.t$irrf$c)                                        VL_IRPF,
    znsls400.T$PECL$C                                             NR_PEDIDO,                                                           
    to_char(znsls401.T$ENTR$C)                                    NR_ENTREGA,
    tdsls400.T$ORNO                                               NR_ORDEM,                                        
    avg(tdsls401.t$qoor)                                          QT_GARANTIA,
    znsls400.T$uneg$c                                             CD_UNIDADE_NEGOCIO,
    znsls400.T$cven$c                                             CD_VENDEDOR,
    znsls400.T$idca$c                                             CD_CANAL_VENDA,
    znsls400.t$idli$c                                             NR_LISTA_CASAMENTO,
    (select e.t$ftyp$l 
      from baandb.ttccom130201 e 
        where e.t$cadr=tdsls400.t$itbp)                           CD_TIPO_CLIENTE_FATURA,
    CASE WHEN zncom005.t$canc$c=1 
      THEN 1 ELSE 0 END                                           IN_CANCELADO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(zncom005.t$rcd_utc), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)                DT_ULT_ATUALIZACAO,
    sum(zncom005.t$igva$c)                                        VL_ITEM_GARANTIA,
    zncom005.t$enga$c                                             CD_PLANO_GARANTIA,
    tcibd001.T$NRPE$C                                             QT_PRAZO_GARANTIA 

  FROM     baandb.tznsls400201 znsls400
    
  INNER JOIN baandb.tznsls401201 znsls401
          ON znsls401.t$ncia$c = znsls400.t$ncia$c
         AND znsls401.t$uneg$c = znsls400.t$uneg$c
         AND znsls401.t$pecl$c = znsls400.t$pecl$c
         AND znsls401.t$sqpd$c = znsls400.t$sqpd$c
     
  LEFT JOIN BAANDB.tzncom005201 zncom005
         ON zncom005.t$ncia$c = znsls401.t$ncia$c
        AND zncom005.t$uneg$c = znsls401.t$uneg$c
        AND zncom005.t$pecl$c = znsls401.t$pecl$c
        AND zncom005.t$sqpd$c = znsls401.t$sqpd$c 
        AND zncom005.t$entr$c = znsls401.t$entr$c
        AND zncom005.t$sequ$c = znsls401.t$sequ$c
        AND zncom005.T$TPAP$C = 2   --Tipo Aviso PN
        
    LEFT JOIN baandb.tznsls401201 znsls401p
           ON znsls401p.t$ncia$c = znsls401.t$ncia$c
          AND znsls401p.t$uneg$c = znsls401.t$uneg$c
          AND znsls401p.t$pecl$c = znsls401.t$pcga$c
          AND znsls401p.t$sqpd$c = znsls401.t$sqpd$c
          AND znsls401p.t$entr$c = znsls401.t$entr$c
          AND znsls401p.t$sequ$c = znsls401.t$sgar$c  

    LEFT JOIN baandb.ttdsls401201 tdsls401p
           ON tdsls401p.t$orno = znsls401p.t$orno$c
          AND tdsls401p.t$pono = znsls401p.t$pono$c

    INNER JOIN baandb.ttdsls400201 tdsls400
            ON tdsls400.t$orno = zncom005.t$orno$c
    
    INNER JOIN baandb.ttdsls401201 tdsls401
            ON tdsls401.T$ORNO = znsls401.T$ORNO$C                                      
           AND tdsls401.t$pono = znsls401.T$PONO$C
    
    INNER JOIN baandb.ttcibd001201 tcibd001                                        
            ON tcibd001.T$ITEM = tdsls401.T$ITEM

  WHERE tcibd001.T$ITGA$C = 1   --Item Garantia Estendida
    
    --AND zncom005.t$avpn$c!=0  --Aviso de Parceiro
    --talvez seja necessário pegar como tabela principal vendas
    --e fazer um left join com a zncom005, pois o Aviso de Parceiro
    --é executado uma vez por mês

GROUP BY znsls400.T$uneg$c, 
         znsls400.T$PECL$C, 
         znsls401.T$ENTR$C, 
         tdsls400.T$ORNO, 
         zncom005.t$cdve$c, 
         tdsls400.t$hdst, 
         znsls400.t$dtem$c,
         tdsls400.t$odat, 
         tdsls401p.t$item, 
         tdsls401.t$item, 
         zncom005.t$fire$c, 
         zncom005.t$line$c, 
         znsls400.T$idca$c,
         znsls400.T$cven$c, 
         znsls400.t$idli$c, 
         tdsls400.t$itbp, 
         zncom005.t$canc$c, 
         zncom005.t$enga$c, 
         tcibd001.T$NRPE$C
