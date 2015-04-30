SELECT 
  DISTINCT
    SHO.WHSEID             ID_PLANTA,  
    CL.UDF2                NOME_PLANTA,  
    ZNFMD630.T$FILI$C      ID_FILIAL,
    ZNFMD001.T$DSCA$C      DESCR_FILIAL,
    ZNSLS401.T$UNEG$C      ID_UNEG,
    ZNINT002.T$DESC$C      DESCR_UNEG,
    ZNSLS401.T$ENTR$C      ENTREGA,
    ZNSLS401.T$PECL$C      PEDIDO,
    SHO.INVOICENUMBER      NOTA,
    SHO.LANE               SERIE,
    OXV.NOTES1             ETIQUETA,
    ZNSLS401.T$NOME$C      CLIENTE,
    ZNSLS401.T$ICLE$C      CPF_CNPJ,
    ZNSLS401.T$LOGE$C      ENDERECO,
    ZNSLS401.T$NUME$C      NUMERO,
    ZNSLS401.T$BAIE$C      BAIRRO,
    ZNSLS401.T$REFE$C      REFERENCIA,
    ZNSLS401.T$EMAE$C      EMAIL,
    ZNSLS401.T$TELE$C      TELEFONE_1,
    ZNSLS401.T$TE1E$C      TELEFONE_2,
    ZNSLS401.T$TE2E$C      TELEFONE_3,
    ZNSLS410.T$CONO$C      CONTRATO,
    SHD.ORIGINALQTY        QTD_VOL,
    ZNSLS401.T$ITPE$C      ID_TIPO_ENFTREGA,
    ZNSLS002.T$DSCA$C      DESCR_TIPO_ENTREGA,
    SHD.PRODUCT_WEIGHT     PESO,
    SHD.PRODUCT_CUBE       VOLUME,
    ZNSLS401.T$VLUN$C *
    SHD.ORIGINALQTY        VL_SEM_FRETE,
    ZNFMD630.T$VLFC$C      FRETE,
    ZNSLS401.T$VLFR$C      FRETE_SITE,
    ( ZNSLS401.T$VLUN$C *
      SHD.ORIGINALQTY ) + 
      ZNSLS401.T$VLFR$C +
      ZNSLS401.T$VLDE$C -
      ZNSLS401.T$VLDI$C    VL_TOTAL,
    TCMCS080.T$DSCA        TRANSPORTADORA,
    TCMCS080.T$SEAK        APELIDO,
    ZNSLS401.T$CEPE$C      CEP,
    ZNSLS401.T$CIDE$C      CIDADE,
    ZNSLS401.T$UFEN$C      UF,
    ZNSLS400.T$IDCA$C      CANAL,
    ZNFMD630.T$CFRW$C      ID_TRANSP,     
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C - ZNSLS401.T$PZCD$C,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE)  
                           DT_LIMITE,
    ZNSLS401.T$PZCD$C      PZ_CD,
    ZNSLS401.T$PZTR$C      PZ_TRANSIT,  
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE)
                           DT_PROMET,  
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410_ENT.T$DTOC$C, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE)
                           DT_ENT,													--	DATA DE ENTREGA
    ZNFMD630.T$NCAR$C      CARGA,
    znfmd062.t$creg$c      CAPITAL_INTERIOR,
    znfmd061.t$dzon$c      REGIAO,
    SKU.DESCR              DESCRICAO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE)
                           DT_ETR,													--	DATA ETR (ENTREGUE A TRANSPORTADORA)
	ZNSLS410_ULT.PT_CONTR  ULTUMO_PONTO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410_ULT.T$DTOC$C, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE)
                           DT_ULTUMO_PONTO											--	DATA ULTIMO PONTO


FROM       WMWHSE5.ORDERDETAIL SHD

INNER JOIN WMWHSE5.ORDERDETAILXVAS OXV 
        ON OXV.ORDERKEY = SHD.ORDERKEY
       AND OXV.ORDERLINENUMBER = SHD.ORDERLINENUMBER

INNER JOIN WMWHSE5.ORDERS SHO 
        ON SHO.ORDERKEY = SHD.ORDERKEY

INNER JOIN WMWHSE5.SKU SKU 
        ON SKU.SKU = SHD.SKU

 LEFT JOIN BAANDB.TWHINH431301@pLN01 WHINH431 
        ON WHINH431.T$SHPM = SUBSTR(SHD.EXTERNORDERKEY,5,9)
       AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(SHD.EXTERNLINENO)

 LEFT JOIN BAANDB.TZNSLS004301@pLN01 ZNSLS004 
        ON ZNSLS004.T$ORNO$C = WHINH431.T$WORN
       AND ZNSLS004.T$PONO$C = WHINH431.T$WPON

 LEFT JOIN BAANDB.TZNSLS401301@pLN01 ZNSLS401 
        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C
       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C
       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C

 LEFT JOIN BAANDB.TZNSLS400301@pLN01 ZNSLS400 
        ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C

 LEFT JOIN ( select A.T$NCIA$C, 
                    A.T$UNEG$C, 
                    A.T$PECL$C,
                    A.T$SQPD$C, 
                    A.T$ENTR$C, 
                    MIN(A.T$DTOC$C) T$DTOC$C, 
                    MIN(A.T$CONO$C) T$CONO$C
               from BAANDB.TZNSLS410301@pLN01 A
              where A.T$POCO$C = 'ETR'
           group by A.T$NCIA$C, 
                    A.T$UNEG$C, 
                    A.T$PECL$C, 
                    A.T$SQPD$C, 
                    A.T$ENTR$C ) ZNSLS410 
        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C
       AND ZNSLS410.T$ENTR$C = ZNSLS004.T$ENTR$C

 LEFT JOIN ( select A.T$NCIA$C, 
                    A.T$UNEG$C, 
                    A.T$PECL$C,
                    A.T$SQPD$C, 
                    A.T$ENTR$C, 
                    MIN(A.T$DTOC$C) T$DTOC$C
               from BAANDB.TZNSLS410301@pLN01 A
              where A.T$POCO$C = 'ENT'
           group by A.T$NCIA$C, 
                    A.T$UNEG$C, 
                    A.T$PECL$C, 
                    A.T$SQPD$C, 
                    A.T$ENTR$C ) ZNSLS410_ENT 
        ON ZNSLS410_ENT.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS410_ENT.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS410_ENT.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS410_ENT.T$SQPD$C = ZNSLS004.T$SQPD$C
       AND ZNSLS410_ENT.T$ENTR$C = ZNSLS004.T$ENTR$C	   

 LEFT JOIN ( select A.T$NCIA$C, 
                    A.T$UNEG$C, 
                    A.T$PECL$C,
                    A.T$SQPD$C, 
                    A.T$ENTR$C, 
                    MAX(A.T$DTOC$C) T$DTOC$C,
					MAX(A.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY A.T$DTOC$C,  A.T$SEQN$C) PT_CONTR
               from BAANDB.TZNSLS410301@pLN01 A
			group by A.T$NCIA$C, 
                    A.T$UNEG$C, 
                    A.T$PECL$C, 
                    A.T$SQPD$C, 
                    A.T$ENTR$C ) ZNSLS410_ULT
        ON ZNSLS410_ULT.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS410_ULT.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS410_ULT.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS410_ULT.T$SQPD$C = ZNSLS004.T$SQPD$C
       AND ZNSLS410_ULT.T$ENTR$C = ZNSLS004.T$ENTR$C	   
	   
 LEFT JOIN BAANDB.TZNFMD630301@pLN01 ZNFMD630 
        ON ZNFMD630.T$ORNO$C = WHINH431.T$WORN

 LEFT JOIN BAANDB.TZNFMD001301@pLN01 ZNFMD001 
        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C
		
 LEFT JOIN BAANDB.TZNINT002301@pLN01 ZNINT002 
        ON ZNINT002.T$NCIA$C = ZNSLS401.T$NCIA$C
       AND ZNINT002.T$UNEG$C = ZNSLS401.T$UNEG$C
	   
 LEFT JOIN BAANDB.TZNSLS002301@pLN01 ZNSLS002 
        ON ZNSLS002.T$TPEN$C = ZNSLS401.T$ITPE$C
		
 LEFT JOIN BAANDB.TTCMCS080301@pLN01 TCMCS080 
        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C
		
INNER JOIN ENTERPRISE.CODELKUP CL      
        ON UPPER(CL.UDF1) = SHO.WHSEID    
       AND CL.LISTNAME = 'SCHEMA'  
       
 LEFT JOIN ( select znfmd062.t$creg$c,
                    znfmd062.t$cfrw$c,
                    znfmd062.t$cono$c,
                    znfmd062.t$cepd$c,
                    znfmd062.t$cepa$c
               from baandb.tznfmd062301@pLN01 znfmd062 ) znfmd062
        ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd062.t$cono$c = znfmd630.t$cono$c
       AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c
       AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c
 
 LEFT JOIN baandb.tznfmd061301@pLN01 znfmd061
        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd061.t$cono$c = znfmd630.t$cono$c
       AND znfmd061.t$creg$c = znfmd062.t$creg$c
        
WHERE ZNSLS410.T$DTOC$C IS NOT NULL 
  AND OXV.NOTES1 IS NOT NULL
  
  AND NVL(TCMCS080.t$cfrw, 'N/A') IN (:Transportadora)
  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                AT time zone 'America/Sao_Paulo') AS DATE))
      BETWEEN :DataETRDe
          AND :DataETRAte
		  
ORDER BY DT_ETR, 
         DESCR_UNEG

		 
=IIF(Parameters!Table.Values <> "AAA",	 

"SELECT  " &
"  DISTINCT  " &
"    SHO.WHSEID             ID_PLANTA,  " &
"    CL.UDF2                NOME_PLANTA,  " &
"    ZNFMD630.T$FILI$C      ID_FILIAL,  " &
"    ZNFMD001.T$DSCA$C      DESCR_FILIAL,  " &
"    ZNSLS401.T$UNEG$C      ID_UNEG,  " &
"    ZNINT002.T$DESC$C      DESCR_UNEG,  " &
"    ZNSLS401.T$ENTR$C      ENTREGA,  " &
"    ZNSLS401.T$PECL$C      PEDIDO,  " &
"    SHO.INVOICENUMBER      NOTA,  " &
"    SHO.LANE               SERIE,  " &
"    OXV.NOTES1             ETIQUETA,  " &
"    ZNSLS401.T$NOME$C      CLIENTE,  " &
"    ZNSLS401.T$ICLE$C      CPF_CNPJ,  " &
"    ZNSLS401.T$LOGE$C      ENDERECO,  " &
"    ZNSLS401.T$NUME$C      NUMERO,  " &
"    ZNSLS401.T$BAIE$C      BAIRRO,  " &
"    ZNSLS401.T$REFE$C      REFERENCIA,  " &
"    ZNSLS401.T$EMAE$C      EMAIL,  " &
"    ZNSLS401.T$TELE$C      TELEFONE_1,  " &
"    ZNSLS401.T$TE1E$C      TELEFONE_2,  " &
"    ZNSLS401.T$TE2E$C      TELEFONE_3,  " &
"    ZNSLS410.T$CONO$C      CONTRATO,  " &
"    SHD.ORIGINALQTY        QTD_VOL,  " &
"    ZNSLS401.T$ITPE$C      ID_TIPO_ENFTREGA,  " &
"    ZNSLS002.T$DSCA$C      DESCR_TIPO_ENTREGA,  " &
"    SHD.PRODUCT_WEIGHT     PESO,  " &
"    SHD.PRODUCT_CUBE       VOLUME,  " &
"    ZNSLS401.T$VLUN$C *  " &
"    SHD.ORIGINALQTY        VL_SEM_FRETE,  " &
"    ZNFMD630.T$VLFC$C      FRETE,  " &
"    ZNSLS401.T$VLFR$C      FRETE_SITE,  " &
"    ( ZNSLS401.T$VLUN$C *  " &
"      SHD.ORIGINALQTY ) +  " &
"      ZNSLS401.T$VLFR$C +  " &
"      ZNSLS401.T$VLDE$C -  " &
"      ZNSLS401.T$VLDI$C    VL_TOTAL,  " &
"    TCMCS080.T$DSCA        TRANSPORTADORA,  " &
"    TCMCS080.T$SEAK        APELIDO,  " &
"    ZNSLS401.T$CEPE$C      CEP,  " &
"    ZNSLS401.T$CIDE$C      CIDADE,  " &
"    ZNSLS401.T$UFEN$C      UF,  " &
"    ZNSLS400.T$IDCA$C      CANAL,  " &
"    ZNFMD630.T$CFRW$C      ID_TRANSP,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C -  " &
"                                       ZNSLS401.T$PZCD$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_LIMITE,  " &
"    ZNSLS401.T$PZCD$C      PZ_CD,  " &
"    ZNSLS401.T$PZTR$C      PZ_TRANSIT,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_PROMET,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_ETR,  " &
"    ZNFMD630.T$NCAR$C      CARGA,  " &
"    znfmd062.t$creg$c      CAPITAL_INTERIOR,  " &
"    znfmd061.t$dzon$c      REGIAO,  " &
"    SKU.DESCR              DESCRICAO  " &
"FROM       " + Parameters!Table.Value + ".ORDERDETAIL SHD  " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERDETAILXVAS OXV  " &
"        ON OXV.ORDERKEY = SHD.ORDERKEY  " &
"       AND OXV.ORDERLINENUMBER = SHD.ORDERLINENUMBER  " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERS SHO  " &
"        ON SHO.ORDERKEY = SHD.ORDERKEY  " &
"INNER JOIN " + Parameters!Table.Value + ".SKU SKU  " &
"        ON SKU.SKU = SHD.SKU  " &
" LEFT JOIN BAANDB.TWHINH431301@pLN01 WHINH431  " &
"        ON WHINH431.T$SHPM = SUBSTR(SHD.EXTERNORDERKEY,5,9)  " &
"       AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(SHD.EXTERNLINENO)  " &
" LEFT JOIN BAANDB.TZNSLS004301@pLN01 ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = WHINH431.T$WORN  " &
"       AND ZNSLS004.T$PONO$C = WHINH431.T$WPON  " &
" LEFT JOIN BAANDB.TZNSLS401301@pLN01 ZNSLS401  " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C  " &
" LEFT JOIN BAANDB.TZNSLS400301@pLN01 ZNSLS400  " &
"        ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    MIN(A.T$DTOC$C) T$DTOC$C,  " &
"                    MIN(A.T$CONO$C) T$CONO$C  " &
"               from BAANDB.TZNSLS410301@pLN01 A  " &
"              where A.T$POCO$C = 'ETR'  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C ) ZNSLS410  " &
"        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS410.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
" LEFT JOIN BAANDB.TZNFMD630301@pLN01 ZNFMD630  " &
"        ON ZNFMD630.T$ORNO$C = WHINH431.T$WORN  " &
" LEFT JOIN BAANDB.TZNFMD001301@pLN01 ZNFMD001  " &
"        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C  " &
" LEFT JOIN BAANDB.TZNINT002301@pLN01 ZNINT002  " &
"        ON ZNINT002.T$NCIA$C = ZNSLS401.T$NCIA$C  " &
"       AND ZNINT002.T$UNEG$C = ZNSLS401.T$UNEG$C  " &
" LEFT JOIN BAANDB.TZNSLS002301@pLN01 ZNSLS002  " &
"        ON ZNSLS002.T$TPEN$C = ZNSLS401.T$ITPE$C  " &
" LEFT JOIN BAANDB.TTCMCS080301@pLN01 TCMCS080  " &
"        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C  " &
"INNER JOIN ENTERPRISE.CODELKUP CL  " &
"        ON UPPER(CL.UDF1) = SHO.WHSEID  " &
"       AND CL.LISTNAME = 'SCHEMA'  " &
" LEFT JOIN ( select znfmd062.t$creg$c,  " &
"                    znfmd062.t$cfrw$c,  " &
"                    znfmd062.t$cono$c,  " &
"                    znfmd062.t$cepd$c,  " &
"                    znfmd062.t$cepa$c  " &
"               from baandb.tznfmd062301@pLN01 znfmd062 ) znfmd062  " &
"        ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c  " &
"       AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c  " &
" LEFT JOIN baandb.tznfmd061301@pLN01 znfmd061  " &
"        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd061.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"WHERE ZNSLS410.T$DTOC$C IS NOT NULL  " &
"  AND OXV.NOTES1 IS NOT NULL  " &
"  AND NVL(TCMCS080.t$cfrw, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!Transportadora.Value, "',") + "'"),",",",'") + ")  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataETRDe.Value + "'  " &
"          And '" + Parameters!DataETRAte.Value + "'  " &
"ORDER BY DT_ETR,  " &
"         DESCR_UNEG  "

,

"SELECT  " &
"  DISTINCT  " &
"    SHO.WHSEID             ID_PLANTA,  " &
"    CL.UDF2                NOME_PLANTA,  " &
"    ZNFMD630.T$FILI$C      ID_FILIAL,  " &
"    ZNFMD001.T$DSCA$C      DESCR_FILIAL,  " &
"    ZNSLS401.T$UNEG$C      ID_UNEG,  " &
"    ZNINT002.T$DESC$C      DESCR_UNEG,  " &
"    ZNSLS401.T$ENTR$C      ENTREGA,  " &
"    ZNSLS401.T$PECL$C      PEDIDO,  " &
"    SHO.INVOICENUMBER      NOTA,  " &
"    SHO.LANE               SERIE,  " &
"    OXV.NOTES1             ETIQUETA,  " &
"    ZNSLS401.T$NOME$C      CLIENTE,  " &
"    ZNSLS401.T$ICLE$C      CPF_CNPJ,  " &
"    ZNSLS401.T$LOGE$C      ENDERECO,  " &
"    ZNSLS401.T$NUME$C      NUMERO,  " &
"    ZNSLS401.T$BAIE$C      BAIRRO,  " &
"    ZNSLS401.T$REFE$C      REFERENCIA,  " &
"    ZNSLS401.T$EMAE$C      EMAIL,  " &
"    ZNSLS401.T$TELE$C      TELEFONE_1,  " &
"    ZNSLS401.T$TE1E$C      TELEFONE_2,  " &
"    ZNSLS401.T$TE2E$C      TELEFONE_3,  " &
"    ZNSLS410.T$CONO$C      CONTRATO,  " &
"    SHD.ORIGINALQTY        QTD_VOL,  " &
"    ZNSLS401.T$ITPE$C      ID_TIPO_ENFTREGA,  " &
"    ZNSLS002.T$DSCA$C      DESCR_TIPO_ENTREGA,  " &
"    SHD.PRODUCT_WEIGHT     PESO,  " &
"    SHD.PRODUCT_CUBE       VOLUME,  " &
"    ZNSLS401.T$VLUN$C *  " &
"    SHD.ORIGINALQTY        VL_SEM_FRETE,  " &
"    ZNFMD630.T$VLFC$C      FRETE,  " &
"    ZNSLS401.T$VLFR$C      FRETE_SITE,  " &
"    ( ZNSLS401.T$VLUN$C *  " &
"      SHD.ORIGINALQTY ) +  " &
"      ZNSLS401.T$VLFR$C +  " &
"      ZNSLS401.T$VLDE$C -  " &
"      ZNSLS401.T$VLDI$C    VL_TOTAL,  " &
"    TCMCS080.T$DSCA        TRANSPORTADORA,  " &
"    TCMCS080.T$SEAK        APELIDO,  " &
"    ZNSLS401.T$CEPE$C      CEP,  " &
"    ZNSLS401.T$CIDE$C      CIDADE,  " &
"    ZNSLS401.T$UFEN$C      UF,  " &
"    ZNSLS400.T$IDCA$C      CANAL,  " &
"    ZNFMD630.T$CFRW$C      ID_TRANSP,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C -  " &
"                                       ZNSLS401.T$PZCD$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_LIMITE,  " &
"    ZNSLS401.T$PZCD$C      PZ_CD,  " &
"    ZNSLS401.T$PZTR$C      PZ_TRANSIT,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_PROMET,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_ETR,  " &
"    ZNFMD630.T$NCAR$C      CARGA,  " &
"    znfmd062.t$creg$c      CAPITAL_INTERIOR,  " &
"    znfmd061.t$dzon$c      REGIAO,  " &
"    SKU.DESCR              DESCRICAO  " &
"FROM       WMWHSE1.ORDERDETAIL SHD  " &
"INNER JOIN WMWHSE1.ORDERDETAILXVAS OXV  " &
"        ON OXV.ORDERKEY = SHD.ORDERKEY  " &
"       AND OXV.ORDERLINENUMBER = SHD.ORDERLINENUMBER  " &
"INNER JOIN WMWHSE1.ORDERS SHO  " &
"        ON SHO.ORDERKEY = SHD.ORDERKEY  " &
"INNER JOIN WMWHSE1.SKU SKU  " &
"        ON SKU.SKU = SHD.SKU  " &
" LEFT JOIN BAANDB.TWHINH431301@pLN01 WHINH431  " &
"        ON WHINH431.T$SHPM = SUBSTR(SHD.EXTERNORDERKEY,5,9)  " &
"       AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(SHD.EXTERNLINENO)  " &
" LEFT JOIN BAANDB.TZNSLS004301@pLN01 ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = WHINH431.T$WORN  " &
"       AND ZNSLS004.T$PONO$C = WHINH431.T$WPON  " &
" LEFT JOIN BAANDB.TZNSLS401301@pLN01 ZNSLS401  " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C  " &
" LEFT JOIN BAANDB.TZNSLS400301@pLN01 ZNSLS400  " &
"        ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    MIN(A.T$DTOC$C) T$DTOC$C,  " &
"                    MIN(A.T$CONO$C) T$CONO$C  " &
"               from BAANDB.TZNSLS410301@pLN01 A  " &
"              where A.T$POCO$C = 'ETR'  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C ) ZNSLS410  " &
"        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS410.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
" LEFT JOIN BAANDB.TZNFMD630301@pLN01 ZNFMD630  " &
"        ON ZNFMD630.T$ORNO$C = WHINH431.T$WORN  " &
" LEFT JOIN BAANDB.TZNFMD001301@pLN01 ZNFMD001  " &
"        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C  " &
" LEFT JOIN BAANDB.TZNINT002301@pLN01 ZNINT002  " &
"        ON ZNINT002.T$NCIA$C = ZNSLS401.T$NCIA$C  " &
"       AND ZNINT002.T$UNEG$C = ZNSLS401.T$UNEG$C  " &
" LEFT JOIN BAANDB.TZNSLS002301@pLN01 ZNSLS002  " &
"        ON ZNSLS002.T$TPEN$C = ZNSLS401.T$ITPE$C  " &
" LEFT JOIN BAANDB.TTCMCS080301@pLN01 TCMCS080  " &
"        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C  " &
"INNER JOIN ENTERPRISE.CODELKUP CL  " &
"        ON UPPER(CL.UDF1) = SHO.WHSEID  " &
"       AND CL.LISTNAME = 'SCHEMA'  " &
" LEFT JOIN ( select znfmd062.t$creg$c,  " &
"                    znfmd062.t$cfrw$c,  " &
"                    znfmd062.t$cono$c,  " &
"                    znfmd062.t$cepd$c,  " &
"                    znfmd062.t$cepa$c  " &
"               from baandb.tznfmd062301@pLN01 znfmd062 ) znfmd062  " &
"        ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c  " &
"       AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c  " &
" LEFT JOIN baandb.tznfmd061301@pLN01 znfmd061  " &
"        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd061.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"WHERE ZNSLS410.T$DTOC$C IS NOT NULL  " &
"  AND OXV.NOTES1 IS NOT NULL  " &
"  AND NVL(TCMCS080.t$cfrw, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!Transportadora.Value, "',") + "'"),",",",'") + ")  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataETRDe.Value + "'  " &
"          And '" + Parameters!DataETRAte.Value + "'  " &
"Union  " &
"SELECT  " &
"  DISTINCT  " &
"    SHO.WHSEID             ID_PLANTA,  " &
"    CL.UDF2                NOME_PLANTA,  " &
"    ZNFMD630.T$FILI$C      ID_FILIAL,  " &
"    ZNFMD001.T$DSCA$C      DESCR_FILIAL,  " &
"    ZNSLS401.T$UNEG$C      ID_UNEG,  " &
"    ZNINT002.T$DESC$C      DESCR_UNEG,  " &
"    ZNSLS401.T$ENTR$C      ENTREGA,  " &
"    ZNSLS401.T$PECL$C      PEDIDO,  " &
"    SHO.INVOICENUMBER      NOTA,  " &
"    SHO.LANE               SERIE,  " &
"    OXV.NOTES1             ETIQUETA,  " &
"    ZNSLS401.T$NOME$C      CLIENTE,  " &
"    ZNSLS401.T$ICLE$C      CPF_CNPJ,  " &
"    ZNSLS401.T$LOGE$C      ENDERECO,  " &
"    ZNSLS401.T$NUME$C      NUMERO,  " &
"    ZNSLS401.T$BAIE$C      BAIRRO,  " &
"    ZNSLS401.T$REFE$C      REFERENCIA,  " &
"    ZNSLS401.T$EMAE$C      EMAIL,  " &
"    ZNSLS401.T$TELE$C      TELEFONE_1,  " &
"    ZNSLS401.T$TE1E$C      TELEFONE_2,  " &
"    ZNSLS401.T$TE2E$C      TELEFONE_3,  " &
"    ZNSLS410.T$CONO$C      CONTRATO,  " &
"    SHD.ORIGINALQTY        QTD_VOL,  " &
"    ZNSLS401.T$ITPE$C      ID_TIPO_ENFTREGA,  " &
"    ZNSLS002.T$DSCA$C      DESCR_TIPO_ENTREGA,  " &
"    SHD.PRODUCT_WEIGHT     PESO,  " &
"    SHD.PRODUCT_CUBE       VOLUME,  " &
"    ZNSLS401.T$VLUN$C *  " &
"    SHD.ORIGINALQTY        VL_SEM_FRETE,  " &
"    ZNFMD630.T$VLFC$C      FRETE,  " &
"    ZNSLS401.T$VLFR$C      FRETE_SITE,  " &
"    ( ZNSLS401.T$VLUN$C *  " &
"      SHD.ORIGINALQTY ) +  " &
"      ZNSLS401.T$VLFR$C +  " &
"      ZNSLS401.T$VLDE$C -  " &
"      ZNSLS401.T$VLDI$C    VL_TOTAL,  " &
"    TCMCS080.T$DSCA        TRANSPORTADORA,  " &
"    TCMCS080.T$SEAK        APELIDO,  " &
"    ZNSLS401.T$CEPE$C      CEP,  " &
"    ZNSLS401.T$CIDE$C      CIDADE,  " &
"    ZNSLS401.T$UFEN$C      UF,  " &
"    ZNSLS400.T$IDCA$C      CANAL,  " &
"    ZNFMD630.T$CFRW$C      ID_TRANSP,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C -  " &
"                                       ZNSLS401.T$PZCD$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_LIMITE,  " &
"    ZNSLS401.T$PZCD$C      PZ_CD,  " &
"    ZNSLS401.T$PZTR$C      PZ_TRANSIT,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_PROMET,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_ETR,  " &
"    ZNFMD630.T$NCAR$C      CARGA,  " &
"    znfmd062.t$creg$c      CAPITAL_INTERIOR,  " &
"    znfmd061.t$dzon$c      REGIAO,  " &
"    SKU.DESCR              DESCRICAO  " &
"FROM       WMWHSE2.ORDERDETAIL SHD  " &
"INNER JOIN WMWHSE2.ORDERDETAILXVAS OXV  " &
"        ON OXV.ORDERKEY = SHD.ORDERKEY  " &
"       AND OXV.ORDERLINENUMBER = SHD.ORDERLINENUMBER  " &
"INNER JOIN WMWHSE2.ORDERS SHO  " &
"        ON SHO.ORDERKEY = SHD.ORDERKEY  " &
"INNER JOIN WMWHSE2.SKU SKU  " &
"        ON SKU.SKU = SHD.SKU  " &
" LEFT JOIN BAANDB.TWHINH431301@pLN01 WHINH431  " &
"        ON WHINH431.T$SHPM = SUBSTR(SHD.EXTERNORDERKEY,5,9)  " &
"       AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(SHD.EXTERNLINENO)  " &
" LEFT JOIN BAANDB.TZNSLS004301@pLN01 ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = WHINH431.T$WORN  " &
"       AND ZNSLS004.T$PONO$C = WHINH431.T$WPON  " &
" LEFT JOIN BAANDB.TZNSLS401301@pLN01 ZNSLS401  " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C  " &
" LEFT JOIN BAANDB.TZNSLS400301@pLN01 ZNSLS400  " &
"        ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    MIN(A.T$DTOC$C) T$DTOC$C,  " &
"                    MIN(A.T$CONO$C) T$CONO$C  " &
"               from BAANDB.TZNSLS410301@pLN01 A  " &
"              where A.T$POCO$C = 'ETR'  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C ) ZNSLS410  " &
"        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS410.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
" LEFT JOIN BAANDB.TZNFMD630301@pLN01 ZNFMD630  " &
"        ON ZNFMD630.T$ORNO$C = WHINH431.T$WORN  " &
" LEFT JOIN BAANDB.TZNFMD001301@pLN01 ZNFMD001  " &
"        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C  " &
" LEFT JOIN BAANDB.TZNINT002301@pLN01 ZNINT002  " &
"        ON ZNINT002.T$NCIA$C = ZNSLS401.T$NCIA$C  " &
"       AND ZNINT002.T$UNEG$C = ZNSLS401.T$UNEG$C  " &
" LEFT JOIN BAANDB.TZNSLS002301@pLN01 ZNSLS002  " &
"        ON ZNSLS002.T$TPEN$C = ZNSLS401.T$ITPE$C  " &
" LEFT JOIN BAANDB.TTCMCS080301@pLN01 TCMCS080  " &
"        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C  " &
"INNER JOIN ENTERPRISE.CODELKUP CL  " &
"        ON UPPER(CL.UDF1) = SHO.WHSEID  " &
"       AND CL.LISTNAME = 'SCHEMA'  " &
" LEFT JOIN ( select znfmd062.t$creg$c,  " &
"                    znfmd062.t$cfrw$c,  " &
"                    znfmd062.t$cono$c,  " &
"                    znfmd062.t$cepd$c,  " &
"                    znfmd062.t$cepa$c  " &
"               from baandb.tznfmd062301@pLN01 znfmd062 ) znfmd062  " &
"        ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c  " &
"       AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c  " &
" LEFT JOIN baandb.tznfmd061301@pLN01 znfmd061  " &
"        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd061.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"WHERE ZNSLS410.T$DTOC$C IS NOT NULL  " &
"  AND OXV.NOTES1 IS NOT NULL  " &
"  AND NVL(TCMCS080.t$cfrw, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!Transportadora.Value, "',") + "'"),",",",'") + ")  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataETRDe.Value + "'  " &
"          And '" + Parameters!DataETRAte.Value + "'  " &
"Union  " &
"SELECT  " &
"  DISTINCT  " &
"    SHO.WHSEID             ID_PLANTA,  " &
"    CL.UDF2                NOME_PLANTA,  " &
"    ZNFMD630.T$FILI$C      ID_FILIAL,  " &
"    ZNFMD001.T$DSCA$C      DESCR_FILIAL,  " &
"    ZNSLS401.T$UNEG$C      ID_UNEG,  " &
"    ZNINT002.T$DESC$C      DESCR_UNEG,  " &
"    ZNSLS401.T$ENTR$C      ENTREGA,  " &
"    ZNSLS401.T$PECL$C      PEDIDO,  " &
"    SHO.INVOICENUMBER      NOTA,  " &
"    SHO.LANE               SERIE,  " &
"    OXV.NOTES1             ETIQUETA,  " &
"    ZNSLS401.T$NOME$C      CLIENTE,  " &
"    ZNSLS401.T$ICLE$C      CPF_CNPJ,  " &
"    ZNSLS401.T$LOGE$C      ENDERECO,  " &
"    ZNSLS401.T$NUME$C      NUMERO,  " &
"    ZNSLS401.T$BAIE$C      BAIRRO,  " &
"    ZNSLS401.T$REFE$C      REFERENCIA,  " &
"    ZNSLS401.T$EMAE$C      EMAIL,  " &
"    ZNSLS401.T$TELE$C      TELEFONE_1,  " &
"    ZNSLS401.T$TE1E$C      TELEFONE_2,  " &
"    ZNSLS401.T$TE2E$C      TELEFONE_3,  " &
"    ZNSLS410.T$CONO$C      CONTRATO,  " &
"    SHD.ORIGINALQTY        QTD_VOL,  " &
"    ZNSLS401.T$ITPE$C      ID_TIPO_ENFTREGA,  " &
"    ZNSLS002.T$DSCA$C      DESCR_TIPO_ENTREGA,  " &
"    SHD.PRODUCT_WEIGHT     PESO,  " &
"    SHD.PRODUCT_CUBE       VOLUME,  " &
"    ZNSLS401.T$VLUN$C *  " &
"    SHD.ORIGINALQTY        VL_SEM_FRETE,  " &
"    ZNFMD630.T$VLFC$C      FRETE,  " &
"    ZNSLS401.T$VLFR$C      FRETE_SITE,  " &
"    ( ZNSLS401.T$VLUN$C *  " &
"      SHD.ORIGINALQTY ) +  " &
"      ZNSLS401.T$VLFR$C +  " &
"      ZNSLS401.T$VLDE$C -  " &
"      ZNSLS401.T$VLDI$C    VL_TOTAL,  " &
"    TCMCS080.T$DSCA        TRANSPORTADORA,  " &
"    TCMCS080.T$SEAK        APELIDO,  " &
"    ZNSLS401.T$CEPE$C      CEP,  " &
"    ZNSLS401.T$CIDE$C      CIDADE,  " &
"    ZNSLS401.T$UFEN$C      UF,  " &
"    ZNSLS400.T$IDCA$C      CANAL,  " &
"    ZNFMD630.T$CFRW$C      ID_TRANSP,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C -  " &
"                                       ZNSLS401.T$PZCD$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_LIMITE,  " &
"    ZNSLS401.T$PZCD$C      PZ_CD,  " &
"    ZNSLS401.T$PZTR$C      PZ_TRANSIT,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_PROMET,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_ETR,  " &
"    ZNFMD630.T$NCAR$C      CARGA,  " &
"    znfmd062.t$creg$c      CAPITAL_INTERIOR,  " &
"    znfmd061.t$dzon$c      REGIAO,  " &
"    SKU.DESCR              DESCRICAO  " &
"FROM       WMWHSE2.ORDERDETAIL SHD  " &
"INNER JOIN WMWHSE2.ORDERDETAILXVAS OXV  " &
"        ON OXV.ORDERKEY = SHD.ORDERKEY  " &
"       AND OXV.ORDERLINENUMBER = SHD.ORDERLINENUMBER  " &
"INNER JOIN WMWHSE2.ORDERS SHO  " &
"        ON SHO.ORDERKEY = SHD.ORDERKEY  " &
"INNER JOIN WMWHSE2.SKU SKU  " &
"        ON SKU.SKU = SHD.SKU  " &
" LEFT JOIN BAANDB.TWHINH431301@pLN01 WHINH431  " &
"        ON WHINH431.T$SHPM = SUBSTR(SHD.EXTERNORDERKEY,5,9)  " &
"       AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(SHD.EXTERNLINENO)  " &
" LEFT JOIN BAANDB.TZNSLS004301@pLN01 ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = WHINH431.T$WORN  " &
"       AND ZNSLS004.T$PONO$C = WHINH431.T$WPON  " &
" LEFT JOIN BAANDB.TZNSLS401301@pLN01 ZNSLS401  " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C  " &
" LEFT JOIN BAANDB.TZNSLS400301@pLN01 ZNSLS400  " &
"        ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    MIN(A.T$DTOC$C) T$DTOC$C,  " &
"                    MIN(A.T$CONO$C) T$CONO$C  " &
"               from BAANDB.TZNSLS410301@pLN01 A  " &
"              where A.T$POCO$C = 'ETR'  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C ) ZNSLS410  " &
"        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS410.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
" LEFT JOIN BAANDB.TZNFMD630301@pLN01 ZNFMD630  " &
"        ON ZNFMD630.T$ORNO$C = WHINH431.T$WORN  " &
" LEFT JOIN BAANDB.TZNFMD001301@pLN01 ZNFMD001  " &
"        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C  " &
" LEFT JOIN BAANDB.TZNINT002301@pLN01 ZNINT002  " &
"        ON ZNINT002.T$NCIA$C = ZNSLS401.T$NCIA$C  " &
"       AND ZNINT002.T$UNEG$C = ZNSLS401.T$UNEG$C  " &
" LEFT JOIN BAANDB.TZNSLS002301@pLN01 ZNSLS002  " &
"        ON ZNSLS002.T$TPEN$C = ZNSLS401.T$ITPE$C  " &
" LEFT JOIN BAANDB.TTCMCS080301@pLN01 TCMCS080  " &
"        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C  " &
"INNER JOIN ENTERPRISE.CODELKUP CL  " &
"        ON UPPER(CL.UDF1) = SHO.WHSEID  " &
"       AND CL.LISTNAME = 'SCHEMA'  " &
" LEFT JOIN ( select znfmd062.t$creg$c,  " &
"                    znfmd062.t$cfrw$c,  " &
"                    znfmd062.t$cono$c,  " &
"                    znfmd062.t$cepd$c,  " &
"                    znfmd062.t$cepa$c  " &
"               from baandb.tznfmd062301@pLN01 znfmd062 ) znfmd062  " &
"        ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c  " &
"       AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c  " &
" LEFT JOIN baandb.tznfmd061301@pLN01 znfmd061  " &
"        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd061.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"WHERE ZNSLS410.T$DTOC$C IS NOT NULL  " &
"  AND OXV.NOTES1 IS NOT NULL  " &
"  AND NVL(TCMCS080.t$cfrw, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!Transportadora.Value, "',") + "'"),",",",'") + ")  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataETRDe.Value + "'  " &
"          And '" + Parameters!DataETRAte.Value + "'  " &
"Union  " &

"SELECT  " &
"  DISTINCT  " &
"    SHO.WHSEID             ID_PLANTA,  " &
"    CL.UDF2                NOME_PLANTA,  " &
"    ZNFMD630.T$FILI$C      ID_FILIAL,  " &
"    ZNFMD001.T$DSCA$C      DESCR_FILIAL,  " &
"    ZNSLS401.T$UNEG$C      ID_UNEG,  " &
"    ZNINT002.T$DESC$C      DESCR_UNEG,  " &
"    ZNSLS401.T$ENTR$C      ENTREGA,  " &
"    ZNSLS401.T$PECL$C      PEDIDO,  " &
"    SHO.INVOICENUMBER      NOTA,  " &
"    SHO.LANE               SERIE,  " &
"    OXV.NOTES1             ETIQUETA,  " &
"    ZNSLS401.T$NOME$C      CLIENTE,  " &
"    ZNSLS401.T$ICLE$C      CPF_CNPJ,  " &
"    ZNSLS401.T$LOGE$C      ENDERECO,  " &
"    ZNSLS401.T$NUME$C      NUMERO,  " &
"    ZNSLS401.T$BAIE$C      BAIRRO,  " &
"    ZNSLS401.T$REFE$C      REFERENCIA,  " &
"    ZNSLS401.T$EMAE$C      EMAIL,  " &
"    ZNSLS401.T$TELE$C      TELEFONE_1,  " &
"    ZNSLS401.T$TE1E$C      TELEFONE_2,  " &
"    ZNSLS401.T$TE2E$C      TELEFONE_3,  " &
"    ZNSLS410.T$CONO$C      CONTRATO,  " &
"    SHD.ORIGINALQTY        QTD_VOL,  " &
"    ZNSLS401.T$ITPE$C      ID_TIPO_ENFTREGA,  " &
"    ZNSLS002.T$DSCA$C      DESCR_TIPO_ENTREGA,  " &
"    SHD.PRODUCT_WEIGHT     PESO,  " &
"    SHD.PRODUCT_CUBE       VOLUME,  " &
"    ZNSLS401.T$VLUN$C *  " &
"    SHD.ORIGINALQTY        VL_SEM_FRETE,  " &
"    ZNFMD630.T$VLFC$C      FRETE,  " &
"    ZNSLS401.T$VLFR$C      FRETE_SITE,  " &
"    ( ZNSLS401.T$VLUN$C *  " &
"      SHD.ORIGINALQTY ) +  " &
"      ZNSLS401.T$VLFR$C +  " &
"      ZNSLS401.T$VLDE$C -  " &
"      ZNSLS401.T$VLDI$C    VL_TOTAL,  " &
"    TCMCS080.T$DSCA        TRANSPORTADORA,  " &
"    TCMCS080.T$SEAK        APELIDO,  " &
"    ZNSLS401.T$CEPE$C      CEP,  " &
"    ZNSLS401.T$CIDE$C      CIDADE,  " &
"    ZNSLS401.T$UFEN$C      UF,  " &
"    ZNSLS400.T$IDCA$C      CANAL,  " &
"    ZNFMD630.T$CFRW$C      ID_TRANSP,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C -  " &
"                                       ZNSLS401.T$PZCD$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_LIMITE,  " &
"    ZNSLS401.T$PZCD$C      PZ_CD,  " &
"    ZNSLS401.T$PZTR$C      PZ_TRANSIT,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_PROMET,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_ETR,  " &
"    ZNFMD630.T$NCAR$C      CARGA,  " &
"    znfmd062.t$creg$c      CAPITAL_INTERIOR,  " &
"    znfmd061.t$dzon$c      REGIAO,  " &
"    SKU.DESCR              DESCRICAO  " &
"FROM       WMWHSE2.ORDERDETAIL SHD  " &
"INNER JOIN WMWHSE2.ORDERDETAILXVAS OXV  " &
"        ON OXV.ORDERKEY = SHD.ORDERKEY  " &
"       AND OXV.ORDERLINENUMBER = SHD.ORDERLINENUMBER  " &
"INNER JOIN WMWHSE2.ORDERS SHO  " &
"        ON SHO.ORDERKEY = SHD.ORDERKEY  " &
"INNER JOIN WMWHSE2.SKU SKU  " &
"        ON SKU.SKU = SHD.SKU  " &
" LEFT JOIN BAANDB.TWHINH431301@pLN01 WHINH431  " &
"        ON WHINH431.T$SHPM = SUBSTR(SHD.EXTERNORDERKEY,5,9)  " &
"       AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(SHD.EXTERNLINENO)  " &
" LEFT JOIN BAANDB.TZNSLS004301@pLN01 ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = WHINH431.T$WORN  " &
"       AND ZNSLS004.T$PONO$C = WHINH431.T$WPON  " &
" LEFT JOIN BAANDB.TZNSLS401301@pLN01 ZNSLS401  " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C  " &
" LEFT JOIN BAANDB.TZNSLS400301@pLN01 ZNSLS400  " &
"        ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    MIN(A.T$DTOC$C) T$DTOC$C,  " &
"                    MIN(A.T$CONO$C) T$CONO$C  " &
"               from BAANDB.TZNSLS410301@pLN01 A  " &
"              where A.T$POCO$C = 'ETR'  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C ) ZNSLS410  " &
"        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS410.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
" LEFT JOIN BAANDB.TZNFMD630301@pLN01 ZNFMD630  " &
"        ON ZNFMD630.T$ORNO$C = WHINH431.T$WORN  " &
" LEFT JOIN BAANDB.TZNFMD001301@pLN01 ZNFMD001  " &
"        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C  " &
" LEFT JOIN BAANDB.TZNINT002301@pLN01 ZNINT002  " &
"        ON ZNINT002.T$NCIA$C = ZNSLS401.T$NCIA$C  " &
"       AND ZNINT002.T$UNEG$C = ZNSLS401.T$UNEG$C  " &
" LEFT JOIN BAANDB.TZNSLS002301@pLN01 ZNSLS002  " &
"        ON ZNSLS002.T$TPEN$C = ZNSLS401.T$ITPE$C  " &
" LEFT JOIN BAANDB.TTCMCS080301@pLN01 TCMCS080  " &
"        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C  " &
"INNER JOIN ENTERPRISE.CODELKUP CL  " &
"        ON UPPER(CL.UDF1) = SHO.WHSEID  " &
"       AND CL.LISTNAME = 'SCHEMA'  " &
" LEFT JOIN ( select znfmd062.t$creg$c,  " &
"                    znfmd062.t$cfrw$c,  " &
"                    znfmd062.t$cono$c,  " &
"                    znfmd062.t$cepd$c,  " &
"                    znfmd062.t$cepa$c  " &
"               from baandb.tznfmd062301@pLN01 znfmd062 ) znfmd062  " &
"        ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c  " &
"       AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c  " &
" LEFT JOIN baandb.tznfmd061301@pLN01 znfmd061  " &
"        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd061.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"WHERE ZNSLS410.T$DTOC$C IS NOT NULL  " &
"  AND OXV.NOTES1 IS NOT NULL  " &
"  AND NVL(TCMCS080.t$cfrw, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!Transportadora.Value, "',") + "'"),",",",'") + ")  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataETRDe.Value + "'  " &
"          And '" + Parameters!DataETRAte.Value + "'  " &
"Union  " &
"SELECT  " &
"  DISTINCT  " &
"    SHO.WHSEID             ID_PLANTA,  " &
"    CL.UDF2                NOME_PLANTA,  " &
"    ZNFMD630.T$FILI$C      ID_FILIAL,  " &
"    ZNFMD001.T$DSCA$C      DESCR_FILIAL,  " &
"    ZNSLS401.T$UNEG$C      ID_UNEG,  " &
"    ZNINT002.T$DESC$C      DESCR_UNEG,  " &
"    ZNSLS401.T$ENTR$C      ENTREGA,  " &
"    ZNSLS401.T$PECL$C      PEDIDO,  " &
"    SHO.INVOICENUMBER      NOTA,  " &
"    SHO.LANE               SERIE,  " &
"    OXV.NOTES1             ETIQUETA,  " &
"    ZNSLS401.T$NOME$C      CLIENTE,  " &
"    ZNSLS401.T$ICLE$C      CPF_CNPJ,  " &
"    ZNSLS401.T$LOGE$C      ENDERECO,  " &
"    ZNSLS401.T$NUME$C      NUMERO,  " &
"    ZNSLS401.T$BAIE$C      BAIRRO,  " &
"    ZNSLS401.T$REFE$C      REFERENCIA,  " &
"    ZNSLS401.T$EMAE$C      EMAIL,  " &
"    ZNSLS401.T$TELE$C      TELEFONE_1,  " &
"    ZNSLS401.T$TE1E$C      TELEFONE_2,  " &
"    ZNSLS401.T$TE2E$C      TELEFONE_3,  " &
"    ZNSLS410.T$CONO$C      CONTRATO,  " &
"    SHD.ORIGINALQTY        QTD_VOL,  " &
"    ZNSLS401.T$ITPE$C      ID_TIPO_ENFTREGA,  " &
"    ZNSLS002.T$DSCA$C      DESCR_TIPO_ENTREGA,  " &
"    SHD.PRODUCT_WEIGHT     PESO,  " &
"    SHD.PRODUCT_CUBE       VOLUME,  " &
"    ZNSLS401.T$VLUN$C *  " &
"    SHD.ORIGINALQTY        VL_SEM_FRETE,  " &
"    ZNFMD630.T$VLFC$C      FRETE,  " &
"    ZNSLS401.T$VLFR$C      FRETE_SITE,  " &
"    ( ZNSLS401.T$VLUN$C *  " &
"      SHD.ORIGINALQTY ) +  " &
"      ZNSLS401.T$VLFR$C +  " &
"      ZNSLS401.T$VLDE$C -  " &
"      ZNSLS401.T$VLDI$C    VL_TOTAL,  " &
"    TCMCS080.T$DSCA        TRANSPORTADORA,  " &
"    TCMCS080.T$SEAK        APELIDO,  " &
"    ZNSLS401.T$CEPE$C      CEP,  " &
"    ZNSLS401.T$CIDE$C      CIDADE,  " &
"    ZNSLS401.T$UFEN$C      UF,  " &
"    ZNSLS400.T$IDCA$C      CANAL,  " &
"    ZNFMD630.T$CFRW$C      ID_TRANSP,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C -  " &
"                                       ZNSLS401.T$PZCD$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_LIMITE,  " &
"    ZNSLS401.T$PZCD$C      PZ_CD,  " &
"    ZNSLS401.T$PZTR$C      PZ_TRANSIT,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_PROMET,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_ETR,  " &
"    ZNFMD630.T$NCAR$C      CARGA,  " &
"    znfmd062.t$creg$c      CAPITAL_INTERIOR,  " &
"    znfmd061.t$dzon$c      REGIAO,  " &
"    SKU.DESCR              DESCRICAO  " &
"FROM       WMWHSE5.ORDERDETAIL SHD  " &
"INNER JOIN WMWHSE5.ORDERDETAILXVAS OXV  " &
"        ON OXV.ORDERKEY = SHD.ORDERKEY  " &
"       AND OXV.ORDERLINENUMBER = SHD.ORDERLINENUMBER  " &
"INNER JOIN WMWHSE5.ORDERS SHO  " &
"        ON SHO.ORDERKEY = SHD.ORDERKEY  " &
"INNER JOIN WMWHSE5.SKU SKU  " &
"        ON SKU.SKU = SHD.SKU  " &
" LEFT JOIN BAANDB.TWHINH431301@pLN01 WHINH431  " &
"        ON WHINH431.T$SHPM = SUBSTR(SHD.EXTERNORDERKEY,5,9)  " &
"       AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(SHD.EXTERNLINENO)  " &
" LEFT JOIN BAANDB.TZNSLS004301@pLN01 ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = WHINH431.T$WORN  " &
"       AND ZNSLS004.T$PONO$C = WHINH431.T$WPON  " &
" LEFT JOIN BAANDB.TZNSLS401301@pLN01 ZNSLS401  " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C  " &
" LEFT JOIN BAANDB.TZNSLS400301@pLN01 ZNSLS400  " &
"        ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    MIN(A.T$DTOC$C) T$DTOC$C,  " &
"                    MIN(A.T$CONO$C) T$CONO$C  " &
"               from BAANDB.TZNSLS410301@pLN01 A  " &
"              where A.T$POCO$C = 'ETR'  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C ) ZNSLS410  " &
"        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS410.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
" LEFT JOIN BAANDB.TZNFMD630301@pLN01 ZNFMD630  " &
"        ON ZNFMD630.T$ORNO$C = WHINH431.T$WORN  " &
" LEFT JOIN BAANDB.TZNFMD001301@pLN01 ZNFMD001  " &
"        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C  " &
" LEFT JOIN BAANDB.TZNINT002301@pLN01 ZNINT002  " &
"        ON ZNINT002.T$NCIA$C = ZNSLS401.T$NCIA$C  " &
"       AND ZNINT002.T$UNEG$C = ZNSLS401.T$UNEG$C  " &
" LEFT JOIN BAANDB.TZNSLS002301@pLN01 ZNSLS002  " &
"        ON ZNSLS002.T$TPEN$C = ZNSLS401.T$ITPE$C  " &
" LEFT JOIN BAANDB.TTCMCS080301@pLN01 TCMCS080  " &
"        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C  " &
"INNER JOIN ENTERPRISE.CODELKUP CL  " &
"        ON UPPER(CL.UDF1) = SHO.WHSEID  " &
"       AND CL.LISTNAME = 'SCHEMA'  " &
" LEFT JOIN ( select znfmd062.t$creg$c,  " &
"                    znfmd062.t$cfrw$c,  " &
"                    znfmd062.t$cono$c,  " &
"                    znfmd062.t$cepd$c,  " &
"                    znfmd062.t$cepa$c  " &
"               from baandb.tznfmd062301@pLN01 znfmd062 ) znfmd062  " &
"        ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c  " &
"       AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c  " &
" LEFT JOIN baandb.tznfmd061301@pLN01 znfmd061  " &
"        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd061.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"WHERE ZNSLS410.T$DTOC$C IS NOT NULL  " &
"  AND OXV.NOTES1 IS NOT NULL  " &
"  AND NVL(TCMCS080.t$cfrw, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!Transportadora.Value, "',") + "'"),",",",'") + ")  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataETRDe.Value + "'  " &
"          And '" + Parameters!DataETRAte.Value + "'  " &
"Union  " &
"SELECT  " &
"  DISTINCT  " &
"    SHO.WHSEID             ID_PLANTA,  " &
"    CL.UDF2                NOME_PLANTA,  " &
"    ZNFMD630.T$FILI$C      ID_FILIAL,  " &
"    ZNFMD001.T$DSCA$C      DESCR_FILIAL,  " &
"    ZNSLS401.T$UNEG$C      ID_UNEG,  " &
"    ZNINT002.T$DESC$C      DESCR_UNEG,  " &
"    ZNSLS401.T$ENTR$C      ENTREGA,  " &
"    ZNSLS401.T$PECL$C      PEDIDO,  " &
"    SHO.INVOICENUMBER      NOTA,  " &
"    SHO.LANE               SERIE,  " &
"    OXV.NOTES1             ETIQUETA,  " &
"    ZNSLS401.T$NOME$C      CLIENTE,  " &
"    ZNSLS401.T$ICLE$C      CPF_CNPJ,  " &
"    ZNSLS401.T$LOGE$C      ENDERECO,  " &
"    ZNSLS401.T$NUME$C      NUMERO,  " &
"    ZNSLS401.T$BAIE$C      BAIRRO,  " &
"    ZNSLS401.T$REFE$C      REFERENCIA,  " &
"    ZNSLS401.T$EMAE$C      EMAIL,  " &
"    ZNSLS401.T$TELE$C      TELEFONE_1,  " &
"    ZNSLS401.T$TE1E$C      TELEFONE_2,  " &
"    ZNSLS401.T$TE2E$C      TELEFONE_3,  " &
"    ZNSLS410.T$CONO$C      CONTRATO,  " &
"    SHD.ORIGINALQTY        QTD_VOL,  " &
"    ZNSLS401.T$ITPE$C      ID_TIPO_ENFTREGA,  " &
"    ZNSLS002.T$DSCA$C      DESCR_TIPO_ENTREGA,  " &
"    SHD.PRODUCT_WEIGHT     PESO,  " &
"    SHD.PRODUCT_CUBE       VOLUME,  " &
"    ZNSLS401.T$VLUN$C *  " &
"    SHD.ORIGINALQTY        VL_SEM_FRETE,  " &
"    ZNFMD630.T$VLFC$C      FRETE,  " &
"    ZNSLS401.T$VLFR$C      FRETE_SITE,  " &
"    ( ZNSLS401.T$VLUN$C *  " &
"      SHD.ORIGINALQTY ) +  " &
"      ZNSLS401.T$VLFR$C +  " &
"      ZNSLS401.T$VLDE$C -  " &
"      ZNSLS401.T$VLDI$C    VL_TOTAL,  " &
"    TCMCS080.T$DSCA        TRANSPORTADORA,  " &
"    TCMCS080.T$SEAK        APELIDO,  " &
"    ZNSLS401.T$CEPE$C      CEP,  " &
"    ZNSLS401.T$CIDE$C      CIDADE,  " &
"    ZNSLS401.T$UFEN$C      UF,  " &
"    ZNSLS400.T$IDCA$C      CANAL,  " &
"    ZNFMD630.T$CFRW$C      ID_TRANSP,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C -  " &
"                                       ZNSLS401.T$PZCD$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_LIMITE,  " &
"    ZNSLS401.T$PZCD$C      PZ_CD,  " &
"    ZNSLS401.T$PZTR$C      PZ_TRANSIT,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_PROMET,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_ETR,  " &
"    ZNFMD630.T$NCAR$C      CARGA,  " &
"    znfmd062.t$creg$c      CAPITAL_INTERIOR,  " &
"    znfmd061.t$dzon$c      REGIAO,  " &
"    SKU.DESCR              DESCRICAO  " &
"FROM       WMWHSE6.ORDERDETAIL SHD  " &
"INNER JOIN WMWHSE6.ORDERDETAILXVAS OXV  " &
"        ON OXV.ORDERKEY = SHD.ORDERKEY  " &
"       AND OXV.ORDERLINENUMBER = SHD.ORDERLINENUMBER  " &
"INNER JOIN WMWHSE6.ORDERS SHO  " &
"        ON SHO.ORDERKEY = SHD.ORDERKEY  " &
"INNER JOIN WMWHSE6.SKU SKU  " &
"        ON SKU.SKU = SHD.SKU  " &
" LEFT JOIN BAANDB.TWHINH431301@pLN01 WHINH431  " &
"        ON WHINH431.T$SHPM = SUBSTR(SHD.EXTERNORDERKEY,5,9)  " &
"       AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(SHD.EXTERNLINENO)  " &
" LEFT JOIN BAANDB.TZNSLS004301@pLN01 ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = WHINH431.T$WORN  " &
"       AND ZNSLS004.T$PONO$C = WHINH431.T$WPON  " &
" LEFT JOIN BAANDB.TZNSLS401301@pLN01 ZNSLS401  " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C  " &
" LEFT JOIN BAANDB.TZNSLS400301@pLN01 ZNSLS400  " &
"        ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    MIN(A.T$DTOC$C) T$DTOC$C,  " &
"                    MIN(A.T$CONO$C) T$CONO$C  " &
"               from BAANDB.TZNSLS410301@pLN01 A  " &
"              where A.T$POCO$C = 'ETR'  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C ) ZNSLS410  " &
"        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS410.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
" LEFT JOIN BAANDB.TZNFMD630301@pLN01 ZNFMD630  " &
"        ON ZNFMD630.T$ORNO$C = WHINH431.T$WORN  " &
" LEFT JOIN BAANDB.TZNFMD001301@pLN01 ZNFMD001  " &
"        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C  " &
" LEFT JOIN BAANDB.TZNINT002301@pLN01 ZNINT002  " &
"        ON ZNINT002.T$NCIA$C = ZNSLS401.T$NCIA$C  " &
"       AND ZNINT002.T$UNEG$C = ZNSLS401.T$UNEG$C  " &
" LEFT JOIN BAANDB.TZNSLS002301@pLN01 ZNSLS002  " &
"        ON ZNSLS002.T$TPEN$C = ZNSLS401.T$ITPE$C  " &
" LEFT JOIN BAANDB.TTCMCS080301@pLN01 TCMCS080  " &
"        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C  " &
"INNER JOIN ENTERPRISE.CODELKUP CL  " &
"        ON UPPER(CL.UDF1) = SHO.WHSEID  " &
"       AND CL.LISTNAME = 'SCHEMA'  " &
" LEFT JOIN ( select znfmd062.t$creg$c,  " &
"                    znfmd062.t$cfrw$c,  " &
"                    znfmd062.t$cono$c,  " &
"                    znfmd062.t$cepd$c,  " &
"                    znfmd062.t$cepa$c  " &
"               from baandb.tznfmd062301@pLN01 znfmd062 ) znfmd062  " &
"        ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c  " &
"       AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c  " &
" LEFT JOIN baandb.tznfmd061301@pLN01 znfmd061  " &
"        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd061.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"WHERE ZNSLS410.T$DTOC$C IS NOT NULL  " &
"  AND OXV.NOTES1 IS NOT NULL  " &
"  AND NVL(TCMCS080.t$cfrw, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!Transportadora.Value, "',") + "'"),",",",'") + ")  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataETRDe.Value + "'  " &
"          And '" + Parameters!DataETRAte.Value + "'  " &
"Union  " &
"SELECT  " &
"  DISTINCT  " &
"    SHO.WHSEID             ID_PLANTA,  " &
"    CL.UDF2                NOME_PLANTA,  " &
"    ZNFMD630.T$FILI$C      ID_FILIAL,  " &
"    ZNFMD001.T$DSCA$C      DESCR_FILIAL,  " &
"    ZNSLS401.T$UNEG$C      ID_UNEG,  " &
"    ZNINT002.T$DESC$C      DESCR_UNEG,  " &
"    ZNSLS401.T$ENTR$C      ENTREGA,  " &
"    ZNSLS401.T$PECL$C      PEDIDO,  " &
"    SHO.INVOICENUMBER      NOTA,  " &
"    SHO.LANE               SERIE,  " &
"    OXV.NOTES1             ETIQUETA,  " &
"    ZNSLS401.T$NOME$C      CLIENTE,  " &
"    ZNSLS401.T$ICLE$C      CPF_CNPJ,  " &
"    ZNSLS401.T$LOGE$C      ENDERECO,  " &
"    ZNSLS401.T$NUME$C      NUMERO,  " &
"    ZNSLS401.T$BAIE$C      BAIRRO,  " &
"    ZNSLS401.T$REFE$C      REFERENCIA,  " &
"    ZNSLS401.T$EMAE$C      EMAIL,  " &
"    ZNSLS401.T$TELE$C      TELEFONE_1,  " &
"    ZNSLS401.T$TE1E$C      TELEFONE_2,  " &
"    ZNSLS401.T$TE2E$C      TELEFONE_3,  " &
"    ZNSLS410.T$CONO$C      CONTRATO,  " &
"    SHD.ORIGINALQTY        QTD_VOL,  " &
"    ZNSLS401.T$ITPE$C      ID_TIPO_ENFTREGA,  " &
"    ZNSLS002.T$DSCA$C      DESCR_TIPO_ENTREGA,  " &
"    SHD.PRODUCT_WEIGHT     PESO,  " &
"    SHD.PRODUCT_CUBE       VOLUME,  " &
"    ZNSLS401.T$VLUN$C *  " &
"    SHD.ORIGINALQTY        VL_SEM_FRETE,  " &
"    ZNFMD630.T$VLFC$C      FRETE,  " &
"    ZNSLS401.T$VLFR$C      FRETE_SITE,  " &
"    ( ZNSLS401.T$VLUN$C *  " &
"      SHD.ORIGINALQTY ) +  " &
"      ZNSLS401.T$VLFR$C +  " &
"      ZNSLS401.T$VLDE$C -  " &
"      ZNSLS401.T$VLDI$C    VL_TOTAL,  " &
"    TCMCS080.T$DSCA        TRANSPORTADORA,  " &
"    TCMCS080.T$SEAK        APELIDO,  " &
"    ZNSLS401.T$CEPE$C      CEP,  " &
"    ZNSLS401.T$CIDE$C      CIDADE,  " &
"    ZNSLS401.T$UFEN$C      UF,  " &
"    ZNSLS400.T$IDCA$C      CANAL,  " &
"    ZNFMD630.T$CFRW$C      ID_TRANSP,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C -  " &
"                                       ZNSLS401.T$PZCD$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_LIMITE,  " &
"    ZNSLS401.T$PZCD$C      PZ_CD,  " &
"    ZNSLS401.T$PZTR$C      PZ_TRANSIT,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_PROMET,  " &
"    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"        AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DT_ETR,  " &
"    ZNFMD630.T$NCAR$C      CARGA,  " &
"    znfmd062.t$creg$c      CAPITAL_INTERIOR,  " &
"    znfmd061.t$dzon$c      REGIAO,  " &
"    SKU.DESCR              DESCRICAO  " &
"FROM       WMWHSE7.ORDERDETAIL SHD  " &
"INNER JOIN WMWHSE7.ORDERDETAILXVAS OXV  " &
"        ON OXV.ORDERKEY = SHD.ORDERKEY  " &
"       AND OXV.ORDERLINENUMBER = SHD.ORDERLINENUMBER  " &
"INNER JOIN WMWHSE7.ORDERS SHO  " &
"        ON SHO.ORDERKEY = SHD.ORDERKEY  " &
"INNER JOIN WMWHSE7.SKU SKU  " &
"        ON SKU.SKU = SHD.SKU  " &
" LEFT JOIN BAANDB.TWHINH431301@pLN01 WHINH431  " &
"        ON WHINH431.T$SHPM = SUBSTR(SHD.EXTERNORDERKEY,5,9)  " &
"       AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(SHD.EXTERNLINENO)  " &
" LEFT JOIN BAANDB.TZNSLS004301@pLN01 ZNSLS004  " &
"        ON ZNSLS004.T$ORNO$C = WHINH431.T$WORN  " &
"       AND ZNSLS004.T$PONO$C = WHINH431.T$WPON  " &
" LEFT JOIN BAANDB.TZNSLS401301@pLN01 ZNSLS401  " &
"        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
"       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C  " &
" LEFT JOIN BAANDB.TZNSLS400301@pLN01 ZNSLS400  " &
"        ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
" LEFT JOIN ( select A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C,  " &
"                    MIN(A.T$DTOC$C) T$DTOC$C,  " &
"                    MIN(A.T$CONO$C) T$CONO$C  " &
"               from BAANDB.TZNSLS410301@pLN01 A  " &
"              where A.T$POCO$C = 'ETR'  " &
"           group by A.T$NCIA$C,  " &
"                    A.T$UNEG$C,  " &
"                    A.T$PECL$C,  " &
"                    A.T$SQPD$C,  " &
"                    A.T$ENTR$C ) ZNSLS410  " &
"        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C  " &
"       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"       AND ZNSLS410.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
" LEFT JOIN BAANDB.TZNFMD630301@pLN01 ZNFMD630  " &
"        ON ZNFMD630.T$ORNO$C = WHINH431.T$WORN  " &
" LEFT JOIN BAANDB.TZNFMD001301@pLN01 ZNFMD001  " &
"        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C  " &
" LEFT JOIN BAANDB.TZNINT002301@pLN01 ZNINT002  " &
"        ON ZNINT002.T$NCIA$C = ZNSLS401.T$NCIA$C  " &
"       AND ZNINT002.T$UNEG$C = ZNSLS401.T$UNEG$C  " &
" LEFT JOIN BAANDB.TZNSLS002301@pLN01 ZNSLS002  " &
"        ON ZNSLS002.T$TPEN$C = ZNSLS401.T$ITPE$C  " &
" LEFT JOIN BAANDB.TTCMCS080301@pLN01 TCMCS080  " &
"        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C  " &
"INNER JOIN ENTERPRISE.CODELKUP CL  " &
"        ON UPPER(CL.UDF1) = SHO.WHSEID  " &
"       AND CL.LISTNAME = 'SCHEMA'  " &
" LEFT JOIN ( select znfmd062.t$creg$c,  " &
"                    znfmd062.t$cfrw$c,  " &
"                    znfmd062.t$cono$c,  " &
"                    znfmd062.t$cepd$c,  " &
"                    znfmd062.t$cepa$c  " &
"               from baandb.tznfmd062301@pLN01 znfmd062 ) znfmd062  " &
"        ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c  " &
"       AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c  " &
" LEFT JOIN baandb.tznfmd061301@pLN01 znfmd061  " &
"        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c  " &
"       AND znfmd061.t$cono$c = znfmd630.t$cono$c  " &
"       AND znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"WHERE ZNSLS410.T$DTOC$C IS NOT NULL  " &
"  AND OXV.NOTES1 IS NOT NULL  " &
"  AND NVL(TCMCS080.t$cfrw, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!Transportadora.Value, "',") + "'"),",",",'") + ")  " &
"  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                AT time zone 'America/Sao_Paulo') AS DATE))  " &
"      Between '" + Parameters!DataETRDe.Value + "'  " &
"          And '" + Parameters!DataETRAte.Value + "'  " &
"ORDER BY DT_ETR,  " &
"         DESCR_UNEG  "

)