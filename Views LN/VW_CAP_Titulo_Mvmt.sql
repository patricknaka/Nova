SELECT DISTINCT
	1                                                     CD_CIA,	
  tfacP200.t$lino                                       SQ_MOVIMENTO,
	tfacp200.t$ninv                                       NR_TITULO,
  tfacp200.t$ttyp                                       CD_TRANSACAO_TITULO,
	'CAP'                                                 CD_MODULO,																		
	tfacp200.t$docn                                       NR_MOVIMENTO,
	tfacp200.t$schn                                       NR_PROGRAMACAO,	
	tfacp200.t$tdoc                                       CD_TRANSACAO_DOCUMENTO,
	tfacp200.t$tpay                                       CD_TIPO_PAGAMENTO,
	tfacp200.t$docd                                       DT_TRANSACAO,
	CASE WHEN tfacp200.t$amth$1<0 THEN '-' ELSE '+' END   IN_ENTRADA_SAIDA,
	'CAP'                                                 CD_MODULO_REFERENCIA, 
	nvl((select znacp004.t$ttyp$c || znacp004.t$ninv$c 
        from BAANDB.tznacp004201 znacp004
         where znacp004.t$tty1$c=tfacp200.t$ttyp 
         and znacp004.t$nin1$c=tfacp200.t$ninv
         and znacp004.t$tty2$c=tfacp200.t$tdoc 
         and znacp004.t$nin2$c=tfacp200.t$docn
         and rownum=1), 
      (select  rs.t$ttyp || rs.t$ninv 
        from baandb.ttfacp200201 rs
        where rs.t$tdoc=tfacp200.t$tdoc
        and rs.t$docn=tfacp200.t$docn
        and rs.t$ttyp || rs.t$ninv!=tfacp200.t$ttyp || tfacp200.t$ninv
        and rs.t$tpay!=8	
        and rs.t$amnt=tfacp200.t$amnt*-1
        and rownum=1))                                NR_TITULO_REFERENCIA,

	(select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(s.t$sdat), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
    from baandb.ttfacp600201 s 
    where s.t$payt=tfacp200.t$tdoc 
    and s.t$payd=tfacp200.t$docn)                     DT_SITUACAO,
		
	tfacp200.t$amth$1                                   VL_TRANSACAO,

	CASE WHEN tfacp200.t$rcd_utc<TO_DATE('1990-01-01', 'YYYY-MM-DD') 
    THEN tfacp200.t$rcd_utc
	ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacp200.t$rcd_utc, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) END DT_ULT_ATUALIZACAO,

	tfacp200.t$ttyp || tfacp200.t$ninv                    CD_CHAVE_PRIMARIA,

	CASE WHEN tfacp200.t$tdoc='ENC' THEN 5
	  WHEN (select a.t$catg 
            from baandb.ttfgld011201 a 
            where a.t$ttyp=tfacp200.t$tdoc)=10 THEN 3
	  WHEN tfacp200.t$tdoc='PLG' THEN 1
	  WHEN tfacp200.t$tdoc='LKF' THEN 2
	  WHEN tfacp200.t$tdoc='RKF' THEN 4
   ELSE 0 END                                           CD_TIPO_MOVIMENTO

FROM baandb.ttfacp200201 tfacp200
																			
WHERE tfacp200.t$docn>0