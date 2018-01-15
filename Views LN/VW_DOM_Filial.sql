SELECT  
  cast(case when tcemm030.t$euca = ' ' 
    then substr(tcemm030.T$EUNT,5,2) 
  else tcemm030.t$euca end as int)  CD_FILIAL,
  1                                 CD_CIA,
  tcemm030.t$dsca                   NM_FILIAL,
  
  CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
  WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
    THEN '00000000000000'
  ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') 
    END                             NR_CNPJ_FILIAL,							
  
  tcemm030.T$EUNT                   CD_UNIDADE_EMPRESARIAL,
  tfgld010.t$desc                   DS_FILIAL,
  tccom100.t$bpid                   CD_PARCEIRO,
  ttccom139.t$dsca                  DS_MUNICIPIO,
  ttcmcs010.t$dsca                  DS_PAIS,
  ttccom139.t$cste                  CD_UF

FROM  baandb.ttcemm030201 tcemm030

LEFT JOIN baandb.ttcemm122201 tcemm122
       ON tcemm122.t$grid=tcemm030.t$eunt
      AND tcemm122.t$loco=tcemm030.t$lcmp        

LEFT JOIN baandb.ttccom100201 tccom100
       ON tccom100.t$bpid=tcemm122.t$bupa        

LEFT JOIN baandb.ttccom130201 tccom130
       ON tccom130.t$cadr=tccom100.t$cadr
       
LEFT JOIN baandb.ttfgld010201 tfgld010
       ON tfgld010.t$dimx=lpad(tcemm030.t$euca,3,'0')
      AND tfgld010.t$dtyp=2
      
LEFT JOIN baandb.ttccom139201 ttccom139
       ON tccom130.t$ccit = ttccom139.t$city
       
LEFT JOIN baandb.ttcmcs010201 ttcmcs010
       ON ttccom139.t$ccty = ttcmcs010.t$ccty

--somente Nova Pontocom
where tcemm030.t$lcmp = 201

ORDER BY 5,1
