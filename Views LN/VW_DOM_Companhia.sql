SELECT  
  1                 CD_CIA,
  tcemm170.t$desc   NM_CIA,
  tccom000.t$arcc   CD_SITUACAO,
  CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
  THEN '00000000000000' 
  WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
  THEN '00000000000000'
  ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') 
  END               NR_CNPJ_CPF

FROM  baandb.ttcemm170201 tcemm170

inner join (select max(t$indt) t$indt, 
                   t$ncmp, 
                   t$arcc, 
                   t$cadr 
              FROM baandb.ttccom000201
              where t$ncmp = 201
              group by t$ncmp, t$arcc, t$cadr) tccom000 
    on tccom000.t$ncmp = tcemm170.t$comp
       
left join baandb.ttccom130201 tccom130
    on tccom130.t$cadr = tccom000.t$cadr 

order by 1