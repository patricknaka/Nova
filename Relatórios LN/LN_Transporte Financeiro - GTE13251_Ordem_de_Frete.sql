SELECT 
  DISTINCT
    znfmd630.t$date$c        DATA_EMISSAO, 
    znfmd630.t$fili$c        FILIAL,
    znfmd630.t$pecl$c        ENTREGA,
    znfmd630.t$cono$c        CONTRATO,
    znfmd060.t$cdes$c        DESCR_CONTRATO,  
    znfmd630.t$docn$c        NOTA,
    znfmd630.t$seri$c        SERIE, 
    znfmd630.t$wght$c        PESO, 
    
    nvl( ( select sum(wmd.t$hght   * 
                      wmd.t$wdth   * 
                      wmd.t$dpth   * 
                      sli.t$dqua$l * 
                      znmcs.t$cuba$c)
             from baandb.tcisli941301 sli, 
                  baandb.twhwmd400301 wmd, 
                  baandb.tznmcs080301 znmcs
            where sli.t$fire$l = cisli940.t$fire$l
              and wmd.t$item = sli.t$item$l
              and znmcs.t$cfrw$c = znfmd630.t$cfrw$c ), 0 ) 
                             VOLUME_M3,
                             
    znfmd630.t$vlmr$c        VLR_TOTAL_NF, 
    cisli942.T$RATE$L        ALIQUOTA, 
    znfmd630.t$vlfc$c        PESO_VOLUME,
    znfmd068.t$adva$c        AD_VALOREM,
    znfmd068.t$peda$c        PEDAGIO, 
    znfmd630.t$vlfa$c        ADICIONAIS, 
    znfmd630.t$vlfc$c        FRETE_TOTAL,
    znfmd170.t$fovn$c        CNPJ_TRANS, 
    tcmcs080.t$seak          APELIDO, 
    znfmd630.t$ncte$c        ID_CONHECIMENTO, 
    cisli940.t$fire$l        ID_NR,
    cisli940.t$date$l        DATA_DEV_EMISS_NR, 
    tccom130.t$fovn$l        CPF_DESTINATARIO, 
    tccom130.t$pstc          CEP,
    tccom130.t$dsca          MUNICIPIO,
    tccom130.t$cste          UF,

    ( select znfmd061.t$dzon$c
        from BAANDB.tznfmd062301  znfmd062, baandb.tznfmd061301 znfmd061
       WHERE znfmd062.t$cfrw$c = znfmd630.t$cfrw$c 
         AND znfmd062.t$cono$c = znfmd630.t$cono$c
         AND znfmd062.t$cepd$c <= tccom130.t$pstc
         AND znfmd062.t$cepa$c >= tccom130.t$pstc
         and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c
         and znfmd061.t$cono$c = znfmd062.t$cono$c
         and znfmd061.t$creg$c = znfmd062.t$creg$c
         and rownum = 1 )    REGIAO,
		 
    ( select znfmd640.t$coci$c 
        from BAANDB.tznfmd640301 znfmd640
       where znfmd640.t$date$c = ( select max(znfmd640b.t$date$c) 
                                     from BAANDB.tznfmd640301 znfmd640b
                                    where znfmd640b.t$fili$c = znfmd640.t$fili$c 
                                      AND znfmd640b.t$etiq$c = znfmd640.t$etiq$c )
         and znfmd640.t$fili$c = znfmd630.t$fili$c 
         and znfmd640.t$etiq$c = znfmd630.t$etiq$c )       
                             ID_OCORRENCIA,
							 
    ( SELECT MAX(znfmd640.t$date$c)
        FROM baandb.tznfmd640301 znfmd640
       WHERE znfmd640.t$fili$c = znfmd630.t$fili$c
         AND znfmd640.t$etiq$c = znfmd630.t$etiq$c )
                             DATA_OCORRENCIA,
							 
    cisli940.t$fdty$l        TIPO_DOCUMENTO_FIS, 
    ( SELECT l.t$desc DS_TIPO_NF
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac = 'ci'
         AND d.t$cdom = 'sli.tdff.l'
         AND l.t$clan = 'p'
         AND l.t$cpac = 'ci'
         AND l.t$clab = d.t$za_clab
         AND rpad(d.t$vers,4) || 
             rpad(d.t$rele,2) || 
             rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                             rpad(l1.t$rele,2) || 
                                             rpad(l1.t$cust,4) ) 
                                    from baandb.tttadv401000 l1 
                                   where l1.t$cpac = d.t$cpac 
                                     and l1.t$cdom = d.t$cdom )
         AND rpad(l.t$vers,4) || 
             rpad(l.t$rele,2) || 
             rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                             rpad(l1.t$rele,2) || 
                                             rpad(l1.t$cust,4) ) 
                                    from baandb.tttadv140000 l1 
                                   where l1.t$clab = l.t$clab 
                                     and l1.t$clan = l.t$clan 
                                     and l1.t$cpac = l.t$cpac )
         AND d.t$cnst = cisli940.t$fdty$l ) 
                             DESCR_TIPO_DOC_FIS,
                             
    cisli940.t$doty$l        CODE_TIPO_DOC,
    ( SELECT l.t$desc DS_TIPO_NF
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac = 'tc'
         AND d.t$cdom = 'doty.l'
         AND l.t$clan = 'p'
         AND l.t$cpac = 'tc'
         AND l.t$clab = d.t$za_clab
         AND rpad(d.t$vers,4) || 
             rpad(d.t$rele,2) || 
             rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                             rpad(l1.t$rele,2) || 
                                             rpad(l1.t$cust,4) ) 
                                    from baandb.tttadv401000 l1 
                                   where l1.t$cpac = d.t$cpac 
                                     and l1.t$cdom = d.t$cdom )
         AND rpad(l.t$vers,4) || 
             rpad(l.t$rele,2) || 
             rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                             rpad(l1.t$rele,2) || 
                                             rpad(l1.t$cust,4) ) 
                                    from baandb.tttadv140000 l1 
                                   where l1.t$clab = l.t$clab 
                                     and l1.t$clan = l.t$clan 
                                     and l1.t$cpac = l.t$cpac )
         AND d.t$cnst = cisli940.t$doty$l) 
                             DESCR_TIPO_DOC,
				  
    cisli940.t$ccfo$l        CFO_ENTREGA,
    tcmcs940.t$dsca$l        DESC_CFO_ENTREGA,  
    cisli942.t$amnt$l        VLR_ICMS
  
FROM  BAANDB.ttcmcs080301  tcmcs080,
      BAANDB.tznfmd630301  znfmd630 

LEFT JOIN BAANDB.tcisli940301  cisli940
       ON cisli940.t$fire$l = znfmd630.t$fire$c

LEFT JOIN BAANDB.tcisli942301 cisli942
       ON cisli942.t$fire$l = cisli940.t$fire$l
      AND cisli942.t$brty$l = 1
		  
LEFT JOIN BAANDB.tznfmd060301 znfmd060
       ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
      AND znfmd060.t$cono$c = znfmd630.t$cono$c
          
LEFT JOIN BAANDB.tznfmd068301 znfmd068
       ON znfmd068.t$cfrw$c = znfmd630.t$cfrw$c 
      AND znfmd068.t$cono$c = znfmd630.t$cono$c

LEFT JOIN BAANDB.tznfmd170301 znfmd170
       ON znfmd170.t$fili$c = znfmd630.t$fili$c 
      AND znfmd170.t$cfrw$c = znfmd630.t$cfrw$c

LEFT JOIN BAANDB.tcisli940301  cisli940
       ON cisli940.t$fire$l = znfmd630.t$fire$c 

LEFT JOIN BAANDB.ttcmcs940301  tcmcs940
       ON tcmcs940.t$ofso$l = cisli940.t$ccfo$l 
                                
LEFT JOIN BAANDB.ttccom130301 tccom130
       ON tccom130.t$cadr = cisli940.t$stoa$l
	   
WHERE tcmcs080.t$cfrw = znfmd630.t$cfrw$c 
  AND znfmd630.T$STAT$C = 'F'

  AND Trunc(znfmd630.t$date$c) BETWEEN :DataDe AND :DataAte
  AND cisli940.t$doty$l IN (:TipoDoc) -- NF, NFS ou NFE
  AND ( (znfmd170.t$fovn$c like '%' || :CNPJ  || '%') OR (:CNPJ is null) )
