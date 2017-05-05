select
    znint002.t$desc$c   UNEG,
    znsls401.t$pecl$c   PEDIDO_CLIENTE,
    znsls401.t$entr$c   ENTREGA,
    znsls401.t$cepe$c   CEP_DE_ENTREGA,
    znsls401.t$ufen$c   UF_DE_ENTREGA,
    znsls401.t$cide$c   CIDADE_DE_ENTREGA,
    znfmd001.t$dsca$c   FILIAL_DE_ORIGEM,
    znsls410.t$poco$c   ULTIMO_PONTO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                        DATA_HORA_ULTIMO_PONTO,
    tcmcs080.T$dsca     NOME_TRANSPORTADORA,
    znsls401.t$itpe$c   TIPO_DE_ENTREGA,
    znsls002.t$dsca$c   DESCRICAO_TIPO_ENTREGA,
    znsls401.t$orno$c   ORDEM_DE_VENDA_PEDIDO,
    tdsls400.t$sotp     TIPO_ORDEM_VENDAS,
    tdsls094.t$dsca     MOTIVO_TNA,
    TIPO_TRANSP.DESCR   TIPO_DE_TRANSPORTE,
    tdsls420.t$orno     ORDEM_VENDA_TNA,
    tdsls420.t$hrea     BLOQUEIO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)  
                        DATA_ENTREGA_PROMETIDA,
    znsls401.t$pzcd$c   PRAZO_DO_CD,

    znsls401.t$pztr$c   TRANSIT_TIME,

    znsls401.t$pzfo$c   PRAZO_ENTREGA_FORNECEDOR,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls401.t$ddta, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)  
                        DATA_ENTREGA_PLANEJADA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls401.t$prdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)  
                        DATA_RECEBIMENTO_PLANEJADO,
    case when tdsls400.t$fdty$l = 14 then   --OV TNA = retorno mercadoria cliente
          case when znsls400.t$idpo$c = 'TD' then
                znsls401.t$entr$c
          end
    end                 ENTREGA_DEVOLUCAO_TNA,
    case when tdsls400.t$fdty$l = 14 then   --OV TNA = retorno mercadoria cliente
        case when znsls400.t$sige$c = 1 then   --sim
            'SIGE'
        else
            NVL(znsls401_venda.t$orno$c,znsls401.t$orno$c)
        end
    else
        znsls401.t$orno$c
    end                 OV_SAIDA_TNA,
    case when tdsls400.t$fdty$l = 14 then   --OV TNA = retorno mercadoria cliente
        case when znsls400.t$sige$c = 1 then
            'SIGE'
        else
            NVL(tdsls400_venda.t$ictr$c,tdsls400_INS.t$ictr$c)
        end
    else
        tdsls400.t$ictr$c
    end                 CONTRATO_OV_SAIDA_TNA

from baandb.ttdsls420301 tdsls420

INNER join  baandb.tznsls004301 znsls004  
        on  znsls004.t$orno$c = tdsls420.t$orno
       and  znsls004.t$pono$c = 10

INNER join  baandb.tznsls400301 znsls400
        on znsls400.t$ncia$c = znsls004.t$ncia$c
       and znsls400.t$uneg$c = znsls004.t$uneg$c
       and znsls400.t$pecl$c = znsls004.t$pecl$c
       and znsls400.t$sqpd$c = znsls004.t$sqpd$c
        
INNER join  baandb.tznsls401301 znsls401
        on znsls401.t$ncia$c = znsls004.t$ncia$c
       and znsls401.t$uneg$c = znsls004.t$uneg$c
       and znsls401.t$pecl$c = znsls004.t$pecl$c
       and znsls401.t$sqpd$c = znsls004.t$sqpd$c
       and znsls401.t$entr$c = znsls004.t$entr$c
       and znsls401.t$sequ$c = znsls004.t$sequ$c

INNER join  baandb.ttdsls400301 tdsls400
        on  tdsls400.t$orno = znsls004.t$orno$c
        
INNER join  baandb.ttdsls401301 tdsls401
        on  tdsls401.t$orno = znsls004.t$orno$c
       and  tdsls401.t$pono = znsls004.t$pono$c

INNER join baandb.ttdsls094301 tdsls094
        on tdsls094.t$sotp = tdsls400.t$sotp

INNER join baandb.tznint002301 znint002
        on znint002.t$ncia$c = znsls004.t$ncia$c
       and znint002.t$uneg$c = znsls004.t$uneg$c

INNER join baandb.ttcmcs065301 tcmcs065
        on tcmcs065.t$cwoc = tdsls400.t$cofc
		
INNER join baandb.ttccom130301 tccom130
        on tccom130.t$cadr = tcmcs065.t$cadr
		
INNER join baandb.tznfmd001301 znfmd001
        on znfmd001.t$fovn$c = tccom130.t$fovn$l

LEFT join baandb.ttcmcs080301 tcmcs080 
        on tcmcs080.t$cfrw = tdsls400.t$cfrw
        
left join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    max(a.t$dtoc$c) t$dtoc$c,
                    max(a.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C,  a.T$SEQN$C) t$poco$c
               from baandb.tznsls410301 a
               group by a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$entr$c ) znsls410
        on znsls410.t$ncia$c = znsls401.t$ncia$c
       and znsls410.t$uneg$c = znsls401.t$uneg$c
       and znsls410.t$pecl$c = znsls401.t$pecl$c
       and znsls410.t$sqpd$c = znsls401.t$sqpd$c
       and znsls410.t$entr$c = znsls401.t$entr$c

left join ( select a.t$orno$c,
                   a.t$cfrw$c,
                   a.t$cono$c
            from baandb.tznfmd630301 a
            where a.t$ncte$c != ' '     --ha ordens de frete com mais de uma transportadora, por erro na base
            group by  a.t$orno$c,
                      a.t$cfrw$c,
                      a.t$cono$c ) znfmd630
        on znfmd630.t$orno$c = znsls401.t$orno$c
        
left join baandb.tznfmd060301 znfmd060
       on znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
      and znfmd060.t$cono$c = znfmd630.t$cono$c

left join baandb.tznint002301 znint002
       on znint002.t$ncia$c = znsls401.t$ncia$c
      and znint002.t$uneg$c = znsls401.t$uneg$c

left join baandb.tznsls002301 znsls002
       on znsls002.t$tpen$c = znsls401.t$itpe$c
       
left join  (  SELECT  d.t$cnst,
                      l.t$desc DESCR
              FROM  baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'zn'
                AND d.t$cdom = 'mcs.tptr.c'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'zn'
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
                                           and l1.t$cpac = l.t$cpac )) TIPO_TRANSP                               
          on TIPO_TRANSP.t$cnst = znfmd060.t$ttra$c 

left join baandb.tznsls401301 znsls401_venda
       on znsls401_venda.t$ncia$c = znsls401.t$ncia$c
      and znsls401_venda.t$uneg$c = znsls401.t$uneg$c
      and znsls401_venda.t$pecl$c = znsls401.t$pvdt$c
      and znsls401_venda.t$sqpd$c = znsls401.t$sedt$c
      and znsls401_venda.t$entr$c = znsls401.t$endt$c
      and znsls401_venda.t$sequ$c = znsls401.t$sidt$c
      
left join baandb.ttdsls400301 tdsls400_venda
       on tdsls400_venda.t$orno = znsls401_venda.t$orno$c

left join baandb.ttdsls400301 tdsls400_INS
       on tdsls400_INS.t$orno = znsls401.t$orno$c
       
where tdsls420.t$pono = 0
  and tdsls420.t$hrea = 'TNA'
  
  
