SELECT 			
		 wmsCode.ID_FILIAL                   			        FILIAL,
       sysdate                                       			DATA_CONSULTA,
        WMSCODE.FILIAL                         			  		DESC_FILIAL,
       tcibd001.t$citg                               			ID_DP,
       tcmcs023.t$dsca                               			NOME,
       SUM(tdsls401.t$oamt)                          			PR_FINAL,
       SUM(tdsls401.t$qoor)                          			QTD_PEDIDO
FROM baandb.ttdsls401301  tdsls401
INNER JOIN baandb.ttdsls400301 tdsls400
        ON tdsls400.t$orno = tdsls401.t$orno
INNER JOIN baandb.ttcemm124301 tcemm124 
        ON tcemm124.t$cwoc = tdsls400.t$cofc
INNER JOIN baandb.ttcibd001301   tcibd001
        ON tcibd001.t$item = tdsls401.t$item
INNER JOIN baandb.ttcmcs023301 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
LEFT JOIN baandb.tcisli245301  cisli245
        ON	CISLI245.T$SLCP = 301
        AND	CISLI245.T$ORTP = 1
        AND	CISLI245.T$KOOR = 3
        AND	CISLI245.T$SLSO = tdsls401.t$orno
        AND	CISLI245.T$OSET = 0
        AND	CISLI245.T$PONO = tdsls401.t$pono
        AND	CISLI245.T$SQNB = tdsls401.t$sqnb
        AND	CISLI245.T$SHPM = tdsls401.t$shpm
LEFT JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$fire$l = cisli245.t$fire$l  
LEFT JOIN (select       upper(wmsCODE.UDF1) Filial,
                        wmsCODE.UDF2 ID_FILIAL,
                        b.t$grid
            from        baandb.ttcemm300301 a
            inner join  baandb.ttcemm112301 b ON b.t$waid = a.t$code
            LEFT JOIN   ENTERPRISE.CODELKUP@DL_LN_WMS wmsCode
                          ON  UPPER(TRIM(wmsCode.DESCRIPTION)) = a.t$lctn
                          AND wmsCode.LISTNAME='SCHEMA'  
            where a.t$type=20
            group by  upper(wmsCODE.UDF1),
                      wmsCODE.UDF2,
                      b.t$grid)  wmsCODE ON wmsCODE.t$grid = tcemm124.t$grid
GROUP BY 
          WMSCODE.FILIAL,
          WMSCODE.ID_FILIAL,
          sysdate,
          tcibd001.t$citg,
          tcmcs023.t$dsca