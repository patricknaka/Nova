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
    tccom139.t$ibge$l               COD_IBGE
		
		
FROM
			BAANDB.TTCCOM100602	TCCOM100
INNER JOIN	BAANDB.TTCCOM130602	TCCOM130	ON	TCCOM130.T$CADR		=	TCCOM100.T$CADR
LEFT JOIN	BAANDB.TTCCOM938602	TCCOM938	ON	TCCOM938.T$FTYP$L	=	TCCOM130.T$FTYP$L
											AND	TCCOM938.T$FOVN$L	=	TCCOM130.T$FOVN$L
LEFT JOIN 	BAANDB.TTCCOM966602	TCCOM966	ON	TCCOM966.T$COMP$D	=	TCCOM938.T$COMP$D
											AND	TCCOM966.T$COMP$D	!=	' '
LEFT JOIN	BAANDB.TTCCOM140602 TCCOM140	ON	TCCOM140.T$CCNT		=	TCCOM100.T$CCNT

 LEFT JOIN baandb.ttccom139301 tccom139
        ON  tccom139.t$ccty = tccom130.t$ccty
       AND  tccom139.t$cste = tccom130.t$cste
       AND  tccom139.t$city = tccom130.t$ccit
       
WHERE tccom100.t$bprl = 2     --Cliente
