SELECT DISTINCT	
  CONCAT(tfacr200.t$ttyp, 
    TO_CHAR(tfacr200.t$ninv))                       CD_CHAVE_PRIMARIA,											
  tfacr200.t$ttyp                                   CD_TRANSACAO_TITULO,																		
  1                                                 CD_CIA,
  CASE WHEN nvl((select c.t$styp 
    from baandb.tcisli205201 c
    where c.t$styp='BL ATC'
    AND c.T$ITYP=tfacr200.t$ttyp
    AND c.t$idoc=tfacr200.t$ninv
    AND rownum=1),' ') = ' ' THEN '2' ELSE '3' END  CD_FILIAL,	
  'CAR'                                             CD_MODULO,
  tfacr200.t$doct$l                                 SQ_DOCUMENTO,
  tfacr200.t$itbp                                   CD_PARCEIRO,
  tfacr200.t$docn$l                                 NR_NF,
  tfacr200.t$seri$l                                 NR_SERIE_NF,
  tfacr200.t$docd                                   DT_EMISSAO_TITULO,
  case when to_char(tfacr200.t$liqd, 'yyyy') = 4712	
    then null 
    else to_date(tfacr200.t$liqd) end               DT_VENCIMENTO,
  CASE WHEN tfacr200.t$balc=0 
    THEN																													 													
    (select max(p.t$docd) 
      from baandb.ttfacr200201 p
      where p.t$ttyp=tfacr200.t$ttyp
      and p.t$ninv=tfacr200.t$ninv) 
    ELSE NULL END                                   DT_LIQUIDACAO_TITULO,																			
  tfacr200.t$amnt                                   VL_TITULO,
  tfcmg011.t$baoc$l                                 CD_BANCO,
  tfcmg011.t$agcd$l                                 NR_AGENCIA,
  tfcmg001.t$bano                                   NR_CONTA_CORRENTE,
  tfacr200.t$dim1                                   CD_CENTRO_CUSTO,
  nvl((select min(a.t$rpst$l) 
    from baandb.ttfacr201201 a																	
    where a.t$ttyp=tfacr200.t$ttyp
    and a.t$ninv=tfacr200.t$ninv),1)                CD_SITUACAO_TITULO,
  (select min(a.t$docd) 
    from baandb.ttfacr200201 a
    where a.t$ttyp=tfacr200.t$ttyp 
    and a.t$ninv=tfacr200.t$ninv
    and a.t$docn!=0)                                DT_SITUACAO_TITULO,																			
  case when to_char(tfacr200.t$dued, 'yyyy') = 4712			
    then null 
    else to_date(tfacr200.t$dued) end               DT_VENCIMENTO_ORIGINAL,
  tfacr200.t$bank                                   NR_BANCARIO,
  tfacr200.t$balc                                   VL_SALDO,
  tfacr200.t$dc1h$1 + 
  tfacr200.t$dc2h$1 +
  tfacr200.t$dc3h$1                                 VL_DESCONTO,														
  tfacr200.t$ninv                                   NR_TITULO,																							
  nvl((select t.t$text 
    from baandb.ttttxt010201 t 
    where t$clan='p'
    and t.t$ctxt=tfacr200.t$text
    and rownum=1),' ')                              DS_OBSERVACAO_TITULO,
  tfgld100.t$user                                   DS_USUARIO_GERACAO_TITULO,
  GREATEST(                                                                                         
    nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacr200.t$rcd_utc, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE), 
      TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),
    nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(																										
      (select max(a.t$rcd_utc) from baandb.ttfacr201201 a
      where a.t$ttyp=tfacr200.t$ttyp and a.t$ninv=tfacr200.t$ninv), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE), 
      TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),
    nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfcmg001.t$rcd_utc, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE), 
      TO_DATE('01-JAN-1970', 'DD-MON-YYYY')))       DT_ULT_ATUALIZACAO, 
  (Select u.t$eunt 
    From baandb.ttcemm030201 u
    where u.t$euca!=' '
    AND TO_NUMBER(u.t$euca)=CASE WHEN tfacr200.t$dim2=' ' then 999
      WHEN tfacr200.t$dim2>to_char(0) then 999 
      else TO_NUMBER(tfacr200.t$dim2) END
      and rownum = 1)                               CD_UNIDADE_EMPRESARIAL,
  /*(select znsls401.t$pecl$c 
    from baandb.tznsls401201 znsls401, 
         baandb.tcisli940201 rf, 
         baandb.tcisli245201 ro
    where rf.t$ityp$l=tfacr200.t$ttyp
    and rf.t$idoc$l=tfacr200.t$ninv
    and ro.t$fire$l=rf.t$fire$l
    and znsls401.t$orno$c=ro.t$slso
    and znsls401.t$pono$c=ro.t$pono
    and rownum=1)                                   NR_PEDIDO,*/
      (select znsls004.t$pecl$c 
    from baandb.tznsls004201 znsls004, 
         baandb.tcisli940201 rf, 
         baandb.tcisli245201 ro,
         baandb.tcisli941201 cisli941_ft
    where rf.t$ityp$l=tfacr200.t$ttyp
    and rf.t$idoc$l=tfacr200.t$ninv
    and cisli941_ft.t$fire$l = rf.t$fire$l         
    and ro.t$fire$l=cisli941_ft.t$refr$l
    and znsls004.t$orno$c=ro.t$slso
    and znsls004.t$pono$c=ro.t$pono
    and rownum=1)                                   NR_PEDIDO,

  (select a.t$send$l 
    from baandb.ttfcmg948201 a
    where a.t$ttyp$l=tfacr200.t$ttyp
    and a.t$ninv$l=tfacr200.t$ninv
    and rownum=1																						
    and a.t$lach$l = (select max(b.t$lach$l) 
      from baandb.ttfcmg948201 b
        where b.t$ttyp$l=a.t$ttyp$l
        and a.t$ninv$l=b.t$ninv$l))                 CD_SITUACAO_PAGAMENTO,									
  tfacr200.t$leac								                    CD_CONTA_CONTROLE											

FROM
	baandb.ttfacr200201 tfacr200

	LEFT JOIN baandb.ttfcmg001201 tfcmg001
	ON  tfcmg001.t$bank=tfacr200.t$bank

	LEFT JOIN baandb.ttfcmg011201 tfcmg011
	ON  tfcmg011.t$bank=tfcmg001.t$brch

	LEFT JOIN baandb.ttfcmg401201 tfcmg401
	ON tfcmg401.t$ttyp=tfacr200.t$ttyp
	AND tfcmg401.t$ninv=tfacr200.t$ninv

	LEFT JOIN baandb.ttfcmg409201 tfcmg409
	ON  tfcmg409.t$btno=tfcmg401.t$btno,

  baandb.ttfgld100201 tfgld100

WHERE tfgld100.t$btno=tfacr200.t$btno
AND tfgld100.t$year=tfacr200.t$year
AND tfacr200.t$docn=0
AND tfacr200.t$trec!=9
