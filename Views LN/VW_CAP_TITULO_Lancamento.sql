SELECT
  DISTINCT
    201                             CD_CIA,
      CONCAT(CONCAT(      
            TDREC940.T$TTYP$L, ''), 
            TDREC940.T$INVN$L)
                                    CD_CHAVE_PRIMARIA,
    ITRTP.TRTPDESC                  DS_TIPO_LANCAMENTO,
    IDBCR.DBCRDESC                  IN_DEBITO_CREDITO,
    TDREC952.T$AMTH$L$1             VL_LANCAMENTO,
    TDREC952.T$LEAC$L               CD_CONTA_CONTABIL,
    TFGLD008.T$DESC                 DS_CONTA_CONTABIL
  
FROM
	BAANDB.TTDREC940201 TDREC940,
	BAANDB.TTDREC952201 TDREC952
                                  LEFT  JOIN  BAANDB.TTFGLD008201 TFGLD008
                                        ON                        TFGLD008.T$LEAC=TDREC952.T$LEAC$L,
      ( SELECT  D.T$CNST TRTPCODE, 
                L.T$DESC TRTPDESC
        FROM    TTTADV401000 D, 
                TTTADV140000 L 
        WHERE   D.T$CPAC='tf'
        AND     D.T$CDOM='trtp.l'
		AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                                       (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                                        from baandb.tttadv401000 l1 
                                        where l1.t$cpac=d.t$cpac 
                                        AND l1.t$cdom=d.t$cdom)
        AND     L.T$CLAB=D.T$ZA_CLAB
        AND     L.T$CLAN='p'
        AND     L.T$CPAC='tf'
		AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                                      (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                                        from baandb.tttadv140000 l1 
                                        where l1.t$clab=l.t$clab 
                                        AND l1.t$clan=l.t$clan 
                                        AND l1.t$cpac=l.t$cpac)) ITRTP,
      ( SELECT  D.T$CNST DBCRCODE, 
                L.T$DESC DBCRDESC
        FROM    TTTADV401000 D, 
                TTTADV140000 L 
        WHERE   D.T$CPAC='tf'
        AND     D.T$CDOM='gld.dbcr'
		AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                                       (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                                        from baandb.tttadv401000 l1 
                                        where l1.t$cpac=d.t$cpac 
                                        AND l1.t$cdom=d.t$cdom)
        AND     L.T$CLAB=D.T$ZA_CLAB
        AND     L.T$CLAN='p'
        AND     L.T$CPAC='tf'
		AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                                      (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                                        from baandb.tttadv140000 l1 
                                        where l1.t$clab=l.t$clab 
                                        AND l1.t$clan=l.t$clan 
                                        AND l1.t$cpac=l.t$cpac)) IDBCR                                        
  
WHERE
	TDREC952.T$FIRE$L=TDREC940.T$FIRE$L
AND
  TDREC952.T$TRTP$L=ITRTP.TRTPCODE
AND
  TDREC952.T$DBCR$L=IDBCR.DBCRCODE  
AND
  TDREC940.T$INVN$L>0 