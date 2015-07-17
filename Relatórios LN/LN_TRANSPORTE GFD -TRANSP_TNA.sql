SELECT Q2.t$uneg$c                        ID_UNEG,
     ( select a.t$desc$c
         from BAANDB.tznint002301 a
        where a.t$ncia$c = q2.t$ncia$c
          and a.t$uneg$c = q2.t$uneg$c )  DESC_UNEG, 
       Q2.T$PECL$C                        PEDIDO_CLIENTE,
       Q2.T$ENTR$C                        ENTREGA,
       ENTR.T$DTEP$C                      ENTPROM,
       TCCOM130.T$PSTC                    CEP,
       TCCOM130.T$CSTE                    UF,
       TCCOM130.T$DSCA                    CIDADE,
       ZNFMD001.T$FILI$C                  ID_FILIAL,
       ZNFMD001.T$DSCA$C                  DESC_FILIAL,
       Q2.PT_CONTR                        ULT_PONTO,
        
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Q2.DATA_OCORR, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
           AT time zone 'America/Sao_Paulo') AS DATE)
                                          HORA_ULT_PONTO,
       tdsls400.t$cfrw                    TRANSPORTADDORA,
       TCMCS080.T$DSCA                    NOME_TRANSP,
       ENTR.T$ITPE$C                      TIPO_ENT,
       ZNSLS002.T$DSCA$C                  NOME_TP_ENT

      FROM ( select TDSLS420.T$ORNO
               from BAANDB.TTDSLS420301 TDSLS420
              where TDSLS420.T$HREA = 'TNA'
           group by TDSLS420.T$ORNO ) Q1
      
INNER JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    znsls410.t$entr$c,
                    znsls410.t$orno$c,
                    MAX(znsls410.t$dten$c) DATA_ENTR,
                    max(znsls410.t$dtoc$c) DATA_OCORR,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) PT_CONTR
               from baandb.tznsls410301 znsls410
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    znsls410.t$entr$c,
                    znsls410.t$orno$c ) Q2
        ON Q2.T$ORNO$C = Q1.T$ORNO
		
INNER JOIN BAANDB.TTDSLS400301 TDSLS400
        ON TDSLS400.T$ORNO = Q1.T$ORNO
		
INNER JOIN BAANDB.TTCCOM130301 TCCOM130
        ON TCCOM130.T$CADR = TDSLS400.T$STAD
		
INNER JOIN BAANDB.TTCMCS065301 TCMCS065
        ON TCMCS065.T$CWOC = TDSLS400.T$COFC
		
INNER JOIN BAANDB.TTCCOM130301 END_FILI
        ON END_FILI.T$CADR = TCMCS065.T$CADR
		
INNER JOIN BAANDB.TZNFMD001301 ZNFMD001 
        ON ZNFMD001.T$FOVN$C = END_FILI.T$FOVN$L
		
INNER JOIN BAANDB.TTCMCS080301 TCMCS080
        ON TCMCS080.T$CFRW = TDSLS400.T$CFRW
		
INNER JOIN ( select distinct a.t$ncia$c,
                             a.t$uneg$c,
                             a.t$pecl$c,
                             a.t$sqpd$c,
                             a.t$entr$c,
                             a.t$itpe$c,
                             a.t$dtep$c
               from baandb.tznsls401301 a ) ENTR 
        ON  ENTR.T$NCIA$C = Q2.T$NCIA$C
       AND ENTR.T$UNEG$C = Q2.T$UNEG$C
       AND ENTR.T$PECL$C = Q2.T$PECL$C
       AND ENTR.T$SQPD$C = Q2.T$SQPD$C
       AND ENTR.T$ENTR$C = Q2.T$ENTR$C
	   
INNER JOIN BAANDB.TZNSLS002301 ZNSLS002 
        ON ZNSLS002.T$TPEN$C = ENTR.T$ITPE$C

WHERE ENTR.T$ITPE$C IN (:TipoEntrega)
  AND Trim(tdsls400.t$cfrw) IN (:Transportadora)