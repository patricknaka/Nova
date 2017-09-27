SELECT 
      tdrec940.t$fire$l     NF_REF_FISCAL,
      tdrec940.t$docn$l     NF,
      tdrec940.t$seri$l     NF_SERIE,
      tdrec940.t$fids$l     NF_NOME_FORNECEDOR,
      tdrec940.t$bpid$l     NF_COD_PARCEIRO,
      cast((from_tz(to_timestamp(to_char(tdrec940.t$date$l,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                            NF_DATA_FISCAL,                      
      CTE.t$fire$l          CTE_REF_FISCAL,
      CTE.t$docn$l          CTE,
      CTE.t$seri$l          CTE_SERIE,
      CTE_REL.t$refr$l      CTE_REF_RELATIVA,
      CTE.t$fids$l          CTE_NOME_TRANSPORTADORA,
      CTE.t$bpid$l          CTE_NR_TRANSPORTADORA,
      cast((from_tz(to_timestamp(to_char(CTE.t$date$l,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                            CTE_DATA_FISCAL
                            
FROM (select  a.t$fire$l,
              a.t$docn$l,
              a.t$seri$l,
              a.t$fids$l,
              a.t$bpid$l,
              a.t$date$l,
              cast((from_tz(to_timestamp(to_char(a.t$date$l,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE)  DATA_FILTRO
            from baandb.ttdrec940301 a 
            where a.t$date$l between to_date(:data_ini) and to_date(:data_fim)+2
       ) tdrec940

left join baandb.ttdrec944301 tdrec944
       on tdrec944.t$refr$l = tdrec940.t$fire$l
       
left join baandb.ttdrec940301 CTE
       on CTE.t$fire$l = tdrec944.t$fire$l
       
left join baandb.ttdrec944301 CTE_REL
       on CTE_REL.t$fire$l = CTE.t$fire$l
       
WHERE tdrec940.t$bpid$l IN ('100003805',
                            '100005449',
                            '100004912',
                            '100003584',
                            '100005134',
                            '109672449',
                            '100005135',
                            '100005131',
                            '100005136')
and DATA_FILTRO between :data_ini and :data_fim

ORDER BY tdrec940.t$fire$l, tdrec944.t$fire$l, CTE_REL.t$fire$l


