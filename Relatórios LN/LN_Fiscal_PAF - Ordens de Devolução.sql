SELECT
	301																						CIA,
	ZNFMD001.T$FILI$C																			FILIAL,
	
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDSLS400.T$ODAT, 'DD-MON-YYYY HH24:MI:SS'), 
			'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)						DT_ORDEM,
	
	TDSLS400.T$ORNO																			ORDEM_DEVOLUCAO,
	TDSLS400.T$SOTP																			TIPO_ORDEM,
	TDSLS094.T$DSCA																			DESCR_ORDEM,
	D_HDST.DSC																				STATUS_ORDEM,
	CISLI940_ORG.T$DOCN$L																		NF_VENDA,
	CISLI940_ORG.T$SERI$L																		SERIE_VENDA,
	CISLI940_ORG.T$DATE$L																		DT_EMISS_VENDA,
	TCCOM130C.T$FOVN$L																			CPF_CNPJ,
	TCCOM130C.T$NAMA																			NOME_PARCEIRO,

	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 
			'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)	DT_EMISSAO_DEV,
	
	CISLI940.T$DOCN$L																			NFD,
	CISLI940.T$SERI$L																			SERIE_ND,
	D_STAT.DSC																				STATUS_NFD,
	TDREC940.T$FIRE$L																			REF_FISCAL_REC,
	CISLI941_REL.T$FIRE$L																			REF_FISCAL_DEV,
	TDREC940.t$DATE$L																			DT_REC_FISCAL,
	D_RSTA.DSC																				STATUS_REC
	


FROM
			BAANDB.TTDSLS400301	TDSLS400

INNER JOIN BAANDB.TTCMCS065301 TCMCS065 
        ON TCMCS065.T$CWOC  = TDSLS400.T$COFC

INNER JOIN BAANDB.TTCCOM130301 TCCOM130F
        ON TCCOM130F.T$CADR = TCMCS065.T$CADR

INNER JOIN BAANDB.TZNFMD001301 ZNFMD001 
        ON ZNFMD001.T$FOVN$C = TCCOM130F.T$FOVN$L
		
INNER JOIN	BAANDB.TTDSLS094301 TDSLS094
		ON	TDSLS094.T$SOTP	=	TDSLS400.T$SOTP

INNER JOIN	BAANDB.TTCCOM130301	TCCOM130C
		ON	TCCOM130C.T$CADR	=	TDSLS400.T$OFAD
		
INNER JOIN (SELECT	DISTINCT
					A.T$ORNO,
					A.T$FIRE$L
			FROM	BAANDB.TTDSLS401301 A)	TDSLS401
		ON	TDSLS401.T$ORNO	=	TDSLS400.T$ORNO
		
LEFT JOIN	BAANDB.TCISLI940301	CISLI940_ORG
		ON	CISLI940_ORG.T$FIRE$L	=	TDSLS401.T$FIRE$L
		
LEFT JOIN (	SELECT 	DISTINCT
					A.T$SLSO,
					A.T$FIRE$L
			FROM	BAANDB.TCISLI245301 A
			WHERE	A.T$SLCP	=	301
			AND		A.T$ORTP	=	1
			AND		A.T$KOOR	=	3) CISLI245
		ON	CISLI245.T$SLSO	=	TDSLS400.T$ORNO

LEFT JOIN	BAANDB.TCISLI940301	CISLI940
		ON	CISLI940.T$FIRE$L	=	CISLI245.T$FIRE$L
		
LEFT JOIN (	SELECT	DISTINCT
					A.T$DVRF$C,
					A.T$FIRE$L
			FROM	BAANDB.TTDREC941301 A) TDREC941
		ON	TDREC941.T$DVRF$C	=	CISLI940_ORG.T$FIRE$L
		
LEFT JOIN BAANDB.TCISLI941301 CISLI941_REL
	ON	CISLI941_REL.T$REFR$L = TDREC941.T$DVRF$C

LEFT JOIN	BAANDB.TTDREC940301	TDREC940
		ON	TDREC940.T$FIRE$L	=	TDREC941.T$FIRE$L

LEFT JOIN (	SELECT d.t$cnst COD,
				   l.t$desc DSC
			FROM baandb.tttadv401000 d,
				 baandb.tttadv140000 l
			WHERE d.t$cpac='td'
			AND d.t$cdom='sls.hdst'
			AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
												 (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
												  from baandb.tttadv401000 l1 
												  where l1.t$cpac=d.t$cpac 
												  AND l1.t$cdom=d.t$cdom)
			AND l.t$clab=d.t$za_clab
			AND l.t$clan='p'
			AND l.t$cpac='td'
			AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
												(select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
												  from baandb.tttadv140000 l1 
												  where l1.t$clab=l.t$clab 
												  AND l1.t$clan=l.t$clan 
												  AND l1.t$cpac=l.t$cpac)) D_HDST
		ON	D_HDST.COD	=	TDSLS400.T$HDST							  

		
LEFT JOIN (	SELECT d.t$cnst COD,
				   l.t$desc DSC
			FROM baandb.tttadv401000 d,
				 baandb.tttadv140000 l
			WHERE d.t$cpac='ci'
			AND d.t$cdom='sli.stat'
			AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
												 (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
												  from baandb.tttadv401000 l1 
												  where l1.t$cpac=d.t$cpac 
												  AND l1.t$cdom=d.t$cdom)
			AND l.t$clab=d.t$za_clab
			AND l.t$clan='p'
			AND l.t$cpac='ci'
			AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
												(select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
												  from baandb.tttadv140000 l1 
												  where l1.t$clab=l.t$clab 
												  AND l1.t$clan=l.t$clan 
												  AND l1.t$cpac=l.t$cpac)) D_STAT
		ON	D_STAT.COD	=	CISLI940.T$STAT$L		
		

LEFT JOIN (	SELECT d.t$cnst COD,
				   l.t$desc DSC
			FROM baandb.tttadv401000 d,
				 baandb.tttadv140000 l
			WHERE d.t$cpac='td'
			AND d.t$cdom='rec.stat.l'
			AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
												 (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
												  from baandb.tttadv401000 l1 
												  where l1.t$cpac=d.t$cpac 
												  AND l1.t$cdom=d.t$cdom)
			AND l.t$clab=d.t$za_clab
			AND l.t$clan='p'
			AND l.t$cpac='td'
			AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
												(select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
												  from baandb.tttadv140000 l1 
												  where l1.t$clab=l.t$clab 
												  AND l1.t$clan=l.t$clan 
												  AND l1.t$cpac=l.t$cpac)) D_RSTA
		ON	D_RSTA.COD	=	TDREC940.T$STAT$L			
		
		
WHERE
		TDSLS094.T$RETO	!=	2
		
		
