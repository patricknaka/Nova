SELECT
	301																						      CIA,
	ZNFMD001_ORG.T$FILI$C                           FILIAL_VENDA,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDSLS400.T$ODAT, 'DD-MON-YYYY HH24:MI:SS'), 
			'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)						DT_ORDEM,
	
	TDSLS400.T$ORNO					ORDEM_DEVOLUCAO,
	TDSLS400.T$SOTP					TIPO_ORDEM,
	TDSLS094.T$DSCA					DESCR_ORDEM,
	D_HDST.DSC					STATUS_ORDEM,
  CASE WHEN znsls400.t$sige$c = 1 THEN
        znmcs095.t$docn$c
  ELSE
        CISLI940_ORG.T$DOCN$L END 			NF_VENDA,
  CASE WHEN znsls400.t$sige$c = 1 THEN
        znmcs095.t$seri$c
  ELSE
      CISLI940_ORG.T$SERI$L	END			SERIE_VENDA,
  CASE WHEN znsls400.t$sige$c = 1 THEN
        znmcs095.t$trdt$C
  ELSE
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940_ORG.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 
          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)	
  END					                DT_EMISS_VENDA,
	TCCOM130C.T$FOVN$L				CPF_CNPJ,
	TCCOM130C.T$NAMA				NOME_PARCEIRO,

  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 'DD-MON-YYYY HH24:MI:SS'), 
          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)	
                                                      DT_EMISSAO_DEV,
      
	ZNFMD001.T$FILI$C			      FILIAL_DEVOLUCAO,
  case when cisli940.t$docn$l is null then
      tdrec940_rec.t$docn$l
  else
      CISLI940.T$DOCN$L 
  end							NFD,
  case when cisli940.t$seri$l is null then
      tdrec940_rec.t$seri$l
  else
      CISLI940.T$SERI$L																
  end							SERIE_ND,
	D_STAT.DSC					STATUS_NFD,
  case when tdrec940.t$fire$l is null then
      tdrec940_rec.t$fire$l
  else
      TDREC940.T$FIRE$L	end                             REF_FISCAL_REC,
	CISLI941_REL.T$FIRE$L				REF_FISCAL_DEV,
  case when tdrec940.t$date$l is null then
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940_rec.t$date$l, 'DD-MON-YYYY HH24:MI:SS'),
          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
  else
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.t$DATE$L, 'DD-MON-YYYY HH24:MI:SS'),
          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
  end                                                 DT_REC_FISCAL,
  case when D_RSTA.DSC is null then
        D_RSTA_REC.DSC
  else  D_RSTA.DSC end					STATUS_REC
	
FROM  BAANDB.TTDSLS400301 TDSLS400

INNER JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$orno$c
              from  baandb.tznsls004301 a
              group by a.t$ncia$c,
                       a.t$uneg$c,
                       a.t$pecl$c,
                       a.t$sqpd$c,
                       a.t$orno$c ) znsls004
          ON znsls004.t$orno$c = tdsls400.t$orno
          
INNER JOIN baandb.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls004.t$ncia$c
       AND znsls400.t$uneg$c = znsls004.t$uneg$c
       AND znsls400.t$pecl$c = znsls004.t$pecl$c
       AND znsls400.t$sqpd$c = znsls004.t$sqpd$c
       
LEFT JOIN baandb.tznmcs095301 znmcs095
       ON znmcs095.t$orno$c = tdsls400.t$orno
            
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

LEFT JOIN BAANDB.TTCMCS065301 TCMCS065_ORG 
        ON TCMCS065_ORG.T$CWOC  = CISLI940_ORG.T$COFC$L

LEFT JOIN BAANDB.TTCCOM130301 TCCOM130_ORG
        ON TCCOM130_ORG.T$CADR = TCMCS065_ORG.T$CADR

LEFT JOIN BAANDB.TZNFMD001301 ZNFMD001_ORG 
        ON ZNFMD001_ORG.T$FOVN$C = TCCOM130_ORG.T$FOVN$L
		
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

LEFT JOIN ( select a.t$ncmp$l,
                   a.t$oorg$l,
                   a.t$orno$l,
                   a.t$fire$l,
                   min(a.t$pono$l) t$pono$l,
                   min(a.t$seqn$l) t$seqn$l
            from baandb.ttdrec947301 a
            group by  a.t$ncmp$l,
                      a.t$oorg$l,
                      a.t$orno$l,
                      a.t$fire$l ) tdrec947
       ON tdrec947.t$ncmp$l = 301
      AND tdrec947.t$oorg$l = 1   --venda
      AND tdrec947.t$orno$l = tdsls400.t$orno

LEFT JOIN baandb.ttdrec940301 tdrec940_rec
       ON tdrec940_rec.t$fire$l = tdrec947.t$fire$l

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
												  AND l1.t$cpac=l.t$cpac)) D_RSTA_REC
		ON	D_RSTA_REC.COD	=	tdrec940_rec.T$STAT$L					
		
WHERE	TDSLS094.T$RETO	!= 2
    
