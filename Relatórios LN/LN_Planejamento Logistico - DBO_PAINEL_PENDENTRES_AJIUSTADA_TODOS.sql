SELECT
  DISTINCT
    tcmcs080.t$dsca		DESC_TRANSP, 
    znfmd060.t$cdes$c   DESC_CONTRATO,
    znsls401.t$entr$c	NUME_ENTREGA,
    znfmd630.t$fili$c   NUME_FILIAL, 
    cisli940.t$docn$l	NUME_NOTA,  
    cisli940.t$seri$l	NUME_SERIE,     
    cisli940.t$fdty$l	TIPO_ORDEM, DESC_TIPO_ORDEM,    
    cisli940.t$gamt$l   VL_MERCADORIA,
    znsls401.t$uneg$c   UNINEG,
    ( SELECT  znfmd640.t$coct$c
        FROM  BAANDB.tznfmd640201 znfmd640
       WHERE  znfmd640.t$date$c =  ( SELECT  MAX(znfmd640.t$date$c)	
                                       FROM  BAANDB.tznfmd640201 znfmd640
                                      WHERE  znfmd640.t$fili$c = znfmd630.t$fili$c
                                        AND  znfmd640.t$etiq$c = znfmd630.t$etiq$c )
         AND ROWNUM = 1
         AND znfmd640.t$coct$c NOT IN ('ENT', 'EXT', 'ROU', 'AVA', 'DEV', 'EXF', 'RIE', 'RTD')
         AND znfmd640.t$fili$c=znfmd630.t$fili$c
         AND znfmd640.t$etiq$c=znfmd630.t$etiq$c )
                        OCORRENCIA,   
    ( SELECT  znfmd040d.t$dotr$c
        FROM  BAANDB.tznfmd640201 znfmd640d,
              BAANDB.tznfmd040201 znfmd040d
       WHERE  znfmd640d.t$date$c = ( SELECT  MAX(znfmd640x.t$date$c) 
                                       FROM  BAANDB.tznfmd640201 znfmd640x
                                      WHERE  znfmd640x.t$fili$c = znfmd630.t$fili$c                                        
                                        AND  znfmd640x.t$etiq$c = znfmd630.t$etiq$c
                                        AND  znfmd040d.t$octr$c = znfmd640d.t$coct$c )
         AND ROWNUM = 1	
         AND znfmd640d.t$fili$c=znfmd630.t$fili$c
         AND znfmd640d.t$etiq$c=znfmd630.t$etiq$c )
                        DESCRICAO,
    ( SELECT  znfmd640.t$date$c
        FROM  BAANDB.tznfmd640201 znfmd640
       WHERE  znfmd640.t$date$c =  ( SELECT  MAX(znfmd640.t$date$c)	
                                       FROM  BAANDB.tznfmd640201 znfmd640
                                      WHERE  znfmd640.t$fili$c = znfmd630.t$fili$c
                                        AND  znfmd640.t$etiq$c = znfmd630.t$etiq$c) 
         AND ROWNUM = 1
         AND znfmd640.t$fili$c=znfmd630.t$fili$c
         AND znfmd640.t$etiq$c=znfmd630.t$etiq$c )
                        DATA_OCORRENCIA,                       
    znfmd630.t$stat$c   SITUACAO,
    znsls401.t$cide$c	CIDADE,
    znsls401.t$cepe$c	CEP,  
    znsls401.t$ufen$c	UF,                      
    znsls401.t$nome$c	DESTINATARIO,
    znsls401.t$dtep$c   DATA_PROMETIDA,
    cisli940.t$dats$l   DATA_EXPEDICAO,                      
    cisli940.t$dats$l-znsls401.t$pzcd$c
                        DATA_PREVISTA,
	cisli940.t$amnt$l	VALOR
	
FROM BAANDB.tznsls401201  znsls401,
     BAANDB.tznfmd630201  znfmd630
LEFT JOIN  BAANDB. tznfmd060201  znfmd060
       ON                        znfmd060.t$cfrw$c = znfmd630.t$cfrw$c 
      AND                        znfmd060.t$cono$c = znfmd630.t$cono$c
LEFT JOIN  BAANDB. ttcmcs080201	 tcmcs080
       ON                        tcmcs080.t$cfrw = znfmd630.t$cfrw$c,
     tcisli940201  cisli940,        
    ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_ORDEM
        FROM  tttadv401000 d, tttadv140000 l 
       WHERE d.t$cpac='ci' 
         AND   d.t$cdom='sli.tdff.l'
         AND   d.t$vers='B61U'
         AND   d.t$rele='a7'
         AND   l.t$clab=d.t$za_clab
         AND   l.t$clan='p'
         AND   l.t$cpac='ci'
         AND   l.t$vers=( SELECT  max(l1.t$vers) 
                            from  tttadv140000 l1 
                           WHERE  l1.t$clab=l.t$clab 
                             AND  l1.t$clan=l.t$clan 
                             AND  l1.t$cpac=l.t$cpac ) 
	) FGET

WHERE znfmd630.t$orno$c=znsls401.t$orno$c
  AND cisli940.t$fire$l=znfmd630.t$fire$c
  AND cisli940.t$docn$l = znfmd630.t$docn$c 
  AND cisli940.t$seri$l = znfmd630.t$seri$c         
  AND cisli940.t$fdty$l = FGET.CNST
  AND ( SELECT znfmd640.t$coci$c 
          FROM BAANDB.tznfmd640201 znfmd640
         WHERE znfmd640.t$coct$c='ETR'        	
           AND znfmd640.t$fili$c=znfmd630.t$fili$c
           AND znfmd640.t$etiq$c=znfmd630.t$etiq$c
           AND ROWNUM = 1) IS NOT NULL
  AND cisli940.t$fdty$l=1