SELECT
  DISTINCT
    znfmd630.t$pecl$c            ENTREGA,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                 DATA_COMPRA,
    
    ( SELECT znfmd640.t$coci$c
        FROM BAANDB.tznfmd640301 znfmd640
       WHERE znfmd640.t$date$c = ( select max(znfmd640X.t$date$c)  
                                     from BAANDB.tznfmd640301 znfmd640X
                                    where znfmd640X.t$fili$c = znfmd640.t$fili$c
                                      and znfmd640X.t$etiq$c = znfmd640.t$etiq$c)
         AND znfmd640.t$fili$c = znfmd630.t$fili$c
         AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
         AND ROWNUM = 1 )        ULT_PONTO,   
    
    ( SELECT znfmd030d.t$dsci$c
        FROM BAANDB.tznfmd640301 znfmd640d,
             BAANDB.tznfmd030301 znfmd030d
       WHERE znfmd640d.t$date$c = ( select max(znfmd640x.t$date$c) 
                                      from BAANDB.tznfmd640301 znfmd640x
                                     where znfmd640x.t$fili$c = znfmd640d.t$fili$c                                        
                                       and znfmd640x.t$etiq$c = znfmd640d.t$etiq$c)
         AND znfmd640d.t$fili$c = znfmd630.t$fili$c
         AND znfmd640d.t$etiq$c = znfmd630.t$etiq$c 
         AND znfmd030d.t$ocin$c = znfmd640d.t$coci$c
         AND ROWNUM = 1 )        DESCRICAO,
     
    ZNFMD630.T$CFRW$C            ID_TRANSPORTADORA,
    TCMCS080.T$DSCA              DESCR_TRANSPORTADORA,
    ZNFMD630.T$CONO$C            ID_CONTRATO,
    ZNFMD060.T$CDES$C            DESCR_CONTRATO,
    ZNFMD630.T$FILI$C            ID_FILIAL,
    ZNFMD001.T$DSCA$C            DESCR_FILIAL,
    ZNFMD630.T$DOCN$C            NF,
    ZNFMD630.T$SERI$C            SERIE,
    TDSLS400.T$SOTP              ID_TIPO_ORDEM,
    TDSLS094.T$DSCA              DESCR_TIPO_ORDEM,
    ZNSLS400.T$UNEG$C            ID_UNEG,
    ZNINT002.T$DESC$C            DESCR_UNEG,
 
    ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(znfmd640.t$date$c), 
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE) 
        from BAANDB.tznfmd640301 znfmd640
       where znfmd640.t$fili$c = znfmd630.t$fili$c
         and znfmd640.t$etiq$c = znfmd630.t$etiq$c ) 
                                 DATA_OCORRENCIA,

    ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(znfmd640.t$udat$c), 
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE) 
        from BAANDB.tznfmd640301 znfmd640
       where znfmd640.t$fili$c = znfmd630.t$fili$c
         and znfmd640.t$etiq$c = znfmd630.t$etiq$c ) 
                                 DATA_PROCESSAMENTO,
								 
    CASE WHEN TO_CHAR(ZNFMD630.T$STAT$C) = 'F'
           THEN 'FINALIZADO'
         ELSE   'PENDENTE' 
    END                          SITUACAO,
 
    ZNSLS401.T$CIDE$C            CIDADE,
    ZNSLS401.T$CEPE$C            CEP,
    ZNSLS401.T$UFEN$C            UF,
    ZNSLS401.T$NOME$C            DESTINATARIO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                 DATA_PROMETIDA,

    CASE WHEN ZNSLS401.T$IDPA$C = '1'
           THEN 'ManhÃ£'
         WHEN ZNSLS401.T$IDPA$C = '2'
           THEN 'Tarde'
         WHEN ZNSLS401.T$IDPA$C = '3'
           THEN 'Noite'
         ELSE Null
    END                          PERIODO,
	
    ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znfmd640.t$date$c), 
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)
        from BAANDB.tznfmd640301 znfmd640
       where znfmd640.t$fili$c = znfmd630.t$fili$c
         and znfmd640.t$etiq$c = znfmd630.t$etiq$c
         and znfmd640.t$coct$c = 'ETR')
                                 DATA_EXPED,
								 
    CISLI940.T$AMNT$L            VALOR,
    ZNSLS401.T$ITPE$C            ID_TIPO_ENTREGA,
    ZNSLS002.T$DSCA$C            DESCR_TIPO_ENTREGA,
 
    ( select znfmd061.t$dzon$c
        from baandb.tznfmd062301 znfmd062, 
             baandb.tznfmd061301 znfmd061
       where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c 
         and znfmd062.t$cono$c = znfmd630.t$cono$c
         and znfmd062.t$cepd$c <= tccom130.t$pstc
         and znfmd062.t$cepa$c >= tccom130.t$pstc
         and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c
         and znfmd061.t$cono$c = znfmd062.t$cono$c
         and znfmd061.t$creg$c = znfmd062.t$creg$c
         and rownum = 1 )        REGIAO, 
		 
    TDSLS400.T$ORNO              ORDEM_VENDA,
    
       CASE WHEN (ORDERS.STATUS = '02' or ORDERS.STATUS = '09' or ORDERS.STATUS = '04' or ORDERS.STATUS = '00') and ORDERS.wavekey is null 
              THEN 'Recebimento_host'
            WHEN (ORDERS.INVOICESTATUS = '2' and ORDERS.STATUS >  = '55') or ORDERS.STATUS = '100' 
              THEN 'Estorno'
            WHEN (ORDERS.STATUS >  = '95' or ORDERS.status2 = 6) 
              THEN 'Expedicao_concluida'
            WHEN (ORDERS.status2 = 3 or ORDERS.status2 = 4) and ORDERS.STATUS >  = '55' 
              THEN 'Fechamento_Gaiola'
            WHEN ORDERS.status2 = 5 and ORDERS.STATUS >  = '55' 
              THEN 'Entregue_Doca'
            WHEN ORDERS.orderid IS NOT NULL and ORDERS.status2 = 2 and ORDERS.STATUS >  = '55' 
              THEN 'Inclusao_Carga'
            WHEN ORDERS.INVOICESTATUS = '1' and ORDERS.STATUS >  = '55' 
              THEN 'DANFE_Solicitada'
            WHEN ORDERS.INVOICESTATUS = '3' and ORDERS.STATUS >  = '55' 
              THEN 'DANFE_Aprovada'
            WHEN ORDERS.INVOICESTATUS = '4' and ORDERS.STATUS >  = '55' 
              THEN 'Fim_Conferencia'
            WHEN (ORDERS.STATUS< = '22') and ORDERS.wavekey is not null 
              THEN 'Incluido_Onda'
            WHEN (ORDERS.STATUS = '29' and ORDERS.Released > 0 and ORDERS.InPicking = 0 and ORDERS.PartPicked = 0) 
              THEN 'Picking_Liberado'
            WHEN (ORDERS.STATUS = '29' and (ORDERS.InPicking > 0 or ORDERS.PartPicked > 0)) 
              THEN 'Inicio_Picking' 
            ELSE   'Picking_Completo'
        END                            ULT_EVENTO
 
FROM       BAANDB.tznfmd630301 znfmd630

INNER JOIN BAANDB.TTCMCS080301 TCMCS080
        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C
  
INNER JOIN BAANDB.TZNFMD060301 ZNFMD060
        ON ZNFMD060.T$CFRW$C = ZNFMD630.T$CFRW$C
       AND ZNFMD060.T$CONO$C = ZNFMD630.T$CONO$C
  
INNER JOIN BAANDB.TZNFMD001301 ZNFMD001
        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C

INNER JOIN BAANDB.TTDSLS400301 TDSLS400
        ON TDSLS400.T$ORNO  = ZNFMD630.T$ORNO$C
  
INNER JOIN BAANDB.TCISLI940301 CISLI940
        ON CISLI940.T$FIRE$L = ZNFMD630.T$FIRE$C
  
 LEFT JOIN BAANDB.TTCCOM130301 TCCOM130
        ON TCCOM130.T$CADR   =  CISLI940.T$STOA$L

INNER JOIN BAANDB.TTDSLS094301 TDSLS094
        ON TDSLS094.T$SOTP  = TDSLS400.T$SOTP

INNER JOIN ( SELECT A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$ORNO$C
               FROM BAANDB.TZNSLS004301 A
           GROUP BY A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$ORNO$C ) ZNSLS004
        ON ZNSLS004.T$ORNO$C = ZNFMD630.T$ORNO$C
    
INNER JOIN ( SELECT A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$CIDE$C,
                    A.T$CEPE$C,
                    A.T$UFEN$C,
                    A.T$NOME$C,
                    A.T$DTEP$C,
                    A.T$IDPA$C,
                    A.T$ITPE$C
               FROM BAANDB.tznsls401301 A
           GROUP BY A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$CIDE$C,
                    A.T$CEPE$C,
                    A.T$UFEN$C,
                    A.T$NOME$C,
                    A.T$DTEP$C,
                    A.T$IDPA$C,
                    A.T$ITPE$C ) znsls401
        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C    
       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C    
       
INNER JOIN BAANDB.TZNSLS002301 ZNSLS002
        ON ZNSLS002.T$TPEN$C  = ZNSLS401.T$ITPE$C
       
INNER JOIN BAANDB.tznsls400301 znsls400
        ON znsls401.t$ncia$c = znsls400.t$ncia$c
       AND znsls401.t$uneg$c = znsls400.t$uneg$c
       AND znsls401.t$pecl$c = znsls400.t$pecl$c
       AND znsls401.t$sqpd$c = znsls400.t$sqpd$c
    
INNER JOIN BAANDB.TZNINT002301 ZNINT002
        ON ZNINT002.T$NCIA$C = ZNSLS400.T$NCIA$C
       AND ZNINT002.T$UNEG$C = ZNSLS400.T$UNEG$C
       
 LEFT JOIN BAANDB.tznsls401301 ZNSLS401b
        ON ZNSLS401b.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS401b.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS401b.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS401b.T$SQPD$C = ZNSLS004.T$SQPD$C    
       AND ZNSLS401b.T$ENTR$C = ZNSLS004.T$ENTR$C   
LEFT JOIN
	( SELECT	ORD.ORDERKEY,
			ORD.REFERENCEDOCUMENT,
			ORD.INVOICESTATUS, 
			ORD.STATUS,
			w.WAVEKEY,
			sq2.ORDERID,
			sq2.status STATUS2,
			sq1.released,
			sq1.inPicking,
			sq1.PartPicked,
			sq1.PickedComplete,
			ORD_DET.SKU
	  FROM 	WMWHSE5.ORDERS@DL_LN_WMS ORD
	  LEFT JOIN ( select 	wv.orderkey,
					max(wv.wavekey) wavekey
			    from	WMWHSE5.wavedetail@DL_LN_WMS wv
			    group by wv.orderkey ) w
		    ON w.orderkey = ORD.orderkey
		    
	  LEFT JOIN ( select distinct 
				    cd.orderid, 
				    cg.CAGEID, 
				    max(cg.status) status,
				    max(cg.closedate) closedate,
				    max(cd.adddate) adddate,
				    max(cg.editdate) editdate
			  from 	WMWHSE5.CAGEID@DL_LN_WMS cg, 
					WMWHSE5.CAGEIDDETAIL@DL_LN_WMS cd 
			  where cd.CAGEID = cg.CAGEID 
			  group by cd.orderid, 
					cg.CAGEID ) sq2
		    ON sq2.orderid = ORD.orderkey	
		    
	  INNER JOIN ( SELECT o1.orderkey, 
				  ( select count(*) 
				      from WMWHSE5.orderdetail@DL_LN_WMS od1 
				     where od1.orderkey = o1.orderkey 
				       and od1.status = '29' ) Released, 
				  ( select count(*) 
				      from WMWHSE5.orderdetail@DL_LN_WMS od1 
				     where od1.orderkey = o1.orderkey 
				       and od1.status = '51' ) InPicking, 
				  ( select count(*) 
				      from WMWHSE5.orderdetail@DL_LN_WMS od1 
				     where od1.orderkey = o1.orderkey 
				       and od1.status = '52' ) PartPicked, 
				  ( select count(*) 
				      from WMWHSE5.orderdetail@DL_LN_WMS od1 
				     where od1.orderkey = o1.orderkey 
				       and od1.status = '55' ) PickedComplete 
			  FROM WMWHSE5.orders@DL_LN_WMS o1 ) sq1
		    ON sq1.orderkey = ORD.orderkey
	  INNER JOIN WMWHSE5.ORDERDETAIL@DL_LN_WMS ORD_DET
			ON ORD_DET.ORDERKEY = ORD.ORDERKEY) ORDERS
ON ORDERS.REFERENCEDOCUMENT = znfmd630.t$orno$c
AND trim(ORDERS.SKU) = trim(znsls401b.t$item$c) 
  
 WHERE znsls401.t$itpe$c = 5 --Agendado
  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      BETWEEN :DataPrometida_De
          AND :DataPrometida_Ate
  AND CASE WHEN TO_CHAR(ZNFMD630.T$STAT$C) = 'F'
             THEN 'F'
           ELSE   'P'
      END IN (:Status)
