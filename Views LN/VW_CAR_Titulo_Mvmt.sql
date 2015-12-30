SELECT DISTINCT
  1                                                 CD_CIA,
  CASE WHEN nvl((select c.t$styp 
    from baandb.tcisli205201 c
      where c.t$styp='BL ATC'
      AND c.T$ITYP=tfacr200.t$ttyp
      AND c.t$idoc=tfacr200.t$ninv
      AND rownum=1),' ') = ' '
  THEN '2' ELSE '3' END                             CD_FILIAL,
  tfacr200.t$docn                                   NR_MOVIMENTO,																			
  tfacr200.t$lino                                   SQ_MOVIMENTO,																			
  tfacr200.t$schn                                   NR_PARCELA,																			
  CONCAT(tfacr200.t$ttyp, 
    TO_CHAR(tfacr200.t$ninv))                       CD_CHAVE_PRIMARIA,									
  'CAR'                                             CD_MODULO,
  t.t$doct$l                                        CD_TIPO_NF,																					
  tfacr200.t$ttyp                                   CD_TRANSACAO_TITULO,																	
  tfacr200.t$trec                                   CD_TIPO_DOCUMENTO,
  CASE WHEN tfacr200.t$amnt<0 
    THEN '-' 
    ELSE '+' END                                    IN_ENTRADA_SAIDA,
  tfacr200.t$docd                                   DT_TRANSACAO,
  tfacr200.t$amnt                                   VL_TRANSACAO,																			

  (select p.t$rpst$l 
    from baandb.ttfacr201201 p
    where p.t$ttyp=tfacr200.t$ttyp
    and p.t$ninv=tfacr200.t$ninv 
    and p.t$schn=tfacr200.t$schn)                   CD_PREPARADO_PAGAMENTO,													

  CASE WHEN t.t$balc=t.t$bala -- Liquidado																
      THEN (select max(t$docd) 
            from baandb.ttfacr200201 m
            where m.t$ttyp=tfacr200.t$ttyp
            and m.t$ninv=tfacr200.t$ninv 
            and m.t$schn=tfacr200.t$schn)
    WHEN t.t$balc=t.t$amnt -- Nenhum recebimento																
      THEN tfacr200.t$docd
    ELSE (select min(t$docd) 
            from baandb.ttfacr200201 m -- Primeiro rec parcial										 
            where m.t$ttyp=tfacr200.t$ttyp
            and m.t$ninv=tfacr200.t$ninv 
            and m.t$schn=tfacr200.t$schn)
    END                                             DT_SITUACAO_MOVIMENTO, 																			

  tfcmg011.t$baoc$l                                 CD_BANCO,
  tfcmg011.t$agcd$l                                 NR_AGENCIA,
  tfcmg001.t$bano                                   NR_CONTA_CORRENTE,																			
  
  GREATEST(																									
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacr200.t$rcd_utc, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
      AT time zone 'America/Sao_Paulo') AS DATE), 
  nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfacr201.t$rcd_utc, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE), 
    TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),																							
  nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfcmg001.t$rcd_utc, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE), 
    TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),
  nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tfcmg409.t$rcd_utc, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE), 
    TO_DATE('01-JAN-1970', 'DD-MON-YYYY')))         DT_ULT_ATUALIZACAO,
  
  (Select u.t$eunt 
    From baandb.ttcemm030201 u
    where u.t$euca!=' '
    and TO_NUMBER(u.t$euca) = 
      CASE WHEN tfacr200.t$dim2 = ' ' 
        then 999
      WHEN tfacr200.t$dim2<=to_char(0) 
        then 999 
      else TO_NUMBER(tfacr200.t$dim2) END
    and rownum = 1)                                 CD_UNIDADE_EMPRESARIAL,

  nvl((select znacr005.t$ttyp$c || znacr005.t$ninv$c 
    from baandb.tznacr005201 znacr005				
      where znacr005.t$tty1$c=tfacr200.t$ttyp 
      and znacr005.t$nin1$c=tfacr200.t$ninv
      and znacr005.t$tty2$c=tfacr200.t$tdoc 
      and znacr005.t$nin2$c=tfacr200.t$docn					
      and znacr005.T$FLAG$C=1																		
      and rownum=1), 
  (select rs.t$ttyp || rs.t$ninv 
    from baandb.ttfacr200201 rs											
      where rs.t$tdoc=tfacr200.t$tdoc 
      and rs.t$docn=tfacr200.t$docn																	
      and rs.t$ttyp || rs.t$ninv!=tfacr200.t$ttyp || tfacr200.t$ninv								
      and rs.t$amnt=tfacr200.t$amnt*-1
      and rownum=1))                                NR_TITULO_REFERENCIA,												
  'CAR'                                             CD_MODULO_TITULO_REFERENCIA,																	
  tfacr200.t$ninv                                   NR_TITULO,
  tfacr200.t$tdoc                                   CD_TRANSACAO_DOCUMENTO,																	
  tfacr201.t$recd                                   DT_VENCTO_PRORROGADO,																		
  tfacr201.t$dued$l                                 DT_VENCTO_ORIGINAL_PRORROGADO,
  tfacr201.t$liqd                                   DT_LIQUIDEZ_PREVISTA,																		
  CASE 
    WHEN tfacr200.t$tdoc='ENC' THEN 5																		
    WHEN (select a.t$catg 
            from baandb.ttfgld011201 a 
            where a.t$ttyp=tfacr200.t$tdoc) = 10 THEN 3							
    WHEN tfacr200.t$tdoc='RGL' THEN 1
    WHEN tfacr200.t$tdoc='LKC' THEN 2
    WHEN tfacr200.t$tdoc='RLA' THEN 2
    WHEN tfacr200.t$tdoc='RRK' THEN 4
    WHEN tfacr200.t$tdoc='RRL' THEN 4
    ELSE 0 END	                                    CD_TIPO_MOVIMENTO																				 	
	
FROM
	baandb.ttfacr200201 tfacr200

	LEFT JOIN baandb.ttfacr201201 tfacr201 	
    ON 	tfacr201.t$ttyp=tfacr200.t$ttyp
    AND tfacr201.t$ninv=tfacr200.t$ninv
    AND tfacr201.t$schn=tfacr200.t$schn

	LEFT JOIN baandb.ttfcmg001201 tfcmg001
	ON  tfcmg001.t$bank=tfacr201.t$brel																		

	LEFT JOIN baandb.ttfcmg011201 tfcmg011
	ON  tfcmg011.t$bank=tfcmg001.t$brch

	LEFT JOIN baandb.ttfcmg409201 tfcmg409
	ON  tfcmg409.t$btno=tfacr200.t$btno,
  
	baandb.ttfacr200201 t																							
	
WHERE tfacr200.t$docn!=0
AND   t.t$ttyp=tfacr200.t$ttyp																				
AND   t.t$ninv=tfacr200.t$ninv
AND   t.t$docn=0																							