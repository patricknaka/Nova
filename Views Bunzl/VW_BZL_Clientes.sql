SELECT
--*********************************************************************************************************************
--	LISTA TODOS OS PEDIDOS INTEGRADOS INCLUSIVE TROCAS E DEVOLUÇÕES INDEPENDENTE DO STATUS
--*********************************************************************************************************************
			
		TCCOM100.T$BPID									SEQUENCIAL,			-- NO LN TEMOS UM CÓDIGO QUE IDETIFICA O REGISTRO DO CLIENTE, NÃO EXISTE UM SEQUENCIAL
		REGEXP_REPLACE(TCCOM130.T$FOVN$L, '[^0-9]', '')	CNPJ,
		CASE WHEN
			tccom130.t$ftyp$l = 'PJ'
			THEN 'J'
			ELSE 'F' END								  TP_PESSOA,
		TCCOM938.T$DESA$L								RAZAO_SOCIAL,
		TCCOM100.T$NAMA									NOME_FANTASIA,
		NVL(TCCOM966.T$STIN$D,'ISENTO') INSCR_ESTAD,
		TCCOM966.T$CTIN$D								INSCR_MUNIC,
		TCCOM130.T$NAMC									LOGRADOURO,
		TCCOM130.T$HONO									NUMERO_LOGRAD,
		TCCOM130.T$BLDG									COMPLEMENTO,
		TCCOM130.T$DIST$L								BAIRRO,
		TCCOM130.T$DSCA									CIDADE,
		TCCOM130.T$CSTE									ESTADO,
		TCCOM130.T$PSTC									CEP,
		case when SUBSTR(TCCOM130.T$TELP,1,2) = '(0'
      then SUBSTR(replace(replace(TCCOM130.T$TELP,'(',''),')',''),2,2)		
      else SUBSTR(replace(replace(TCCOM130.T$TELP,'(',''),')',''),1,2)	end DDD,
		case when SUBSTR(TCCOM130.T$TELP,1,2) = '(0'
      then LTRIM(RTRIM(SUBSTR(replace(replace(REPLACE(TCCOM130.T$TELP,'(',''),')',''),'-',''),6,13)))		
      else LTRIM(RTRIM(SUBSTR(replace(replace(REPLACE(TCCOM130.T$TELP,'(',''),')',''),'-',''),3,13)))	end TELEFONE,
		TCCOM130.T$INFO									EMAIL,
		TCCOM140.T$FULN									CONTATO,
    tccom139.t$ibge$l               COD_IBGE,
    znsls401.t$entr$c               PEDIDO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtap$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)    DATA_APROVACAO
		
		
FROM
			BAANDB.TTCCOM100602	TCCOM100
INNER JOIN	BAANDB.TTCCOM130602	TCCOM130	ON	TCCOM130.T$CADR		=	TCCOM100.T$CADR
LEFT JOIN	BAANDB.TTCCOM938602	TCCOM938	ON	TCCOM938.T$FTYP$L	=	TCCOM130.T$FTYP$L
											AND	TCCOM938.T$FOVN$L	=	TCCOM130.T$FOVN$L
LEFT JOIN 	BAANDB.TTCCOM966602	TCCOM966	ON	TCCOM966.T$COMP$D	=	TCCOM938.T$COMP$D
											AND	TCCOM966.T$COMP$D	!=	' '
LEFT JOIN	BAANDB.TTCCOM140602 TCCOM140	ON	TCCOM140.T$CCNT		=	TCCOM100.T$CCNT

LEFT JOIN baandb.ttccom139602 tccom139
       ON  tccom139.t$ccty = tccom130.t$ccty
      AND  tccom139.t$cste = tccom130.t$cste
      AND  tccom139.t$city = tccom130.t$ccit
       
LEFT JOIN (select     a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$ofbp$c
           from    baandb.tznsls400602 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$ofbp$c ) znsls400
       ON znsls400.t$ofbp$c = tccom100.t$bpid

LEFT JOIN (select a.t$ncia$c, 
                  a.t$uneg$c,
                  a.t$pecl$c,
                  a.t$sqpd$c,
                  a.t$entr$c,
                  a.t$dtap$c
          from    baandb.tznsls401602 a
          group by  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$dtap$c ) znsls401
       ON znsls401.t$ncia$c = znsls400.t$ncia$c
      AND znsls401.t$uneg$c = znsls400.t$uneg$c
      AND znsls401.t$pecl$c = znsls400.t$pecl$c
      AND znsls401.t$sqpd$c = znsls400.t$sqpd$c

          
          
WHERE tccom100.t$bprl = 2     --Cliente

ORDER BY TCCOM100.T$BPID, ZNSLS401.T$ENTR$C
