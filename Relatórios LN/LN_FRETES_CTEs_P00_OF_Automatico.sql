  SELECT /*+ use_concat no_cpu_costing */ 
        DISTINCT
        tdrec940.T$fovn$l                               CNPJ, 
        tdrec940.T$fids$l                               NOME, 
        tfacp200.t$amnt                                 VALOR_CTE, 
        tfacp200.t$ttyp                                 DOC, 
        tfacp200.t$ninv                                 NR_DOC, 
        tfacp200.t$docd                                 DT_DOC,
        case 
            when tdrec945.t$dcty$l = '1' then '1'                                    
            when tdrec945.t$dcty$l = '2' then 'F'
            when tdrec945.t$dcty$l = '3' then '3'
            when tdrec945.t$dcty$l = '4' then '4'      
            when tdrec945.t$dcty$l = '100' then 'O'
            ELSE 'AUT'
        end                                             TIPO,
        tdrec940.t$docn$l                               NR_CTE, 
        tdrec940.t$seri$l                               SERIE, 
        decode (tfacp200.t$asst$l,1, 'Nao aplicavel', 2, 'Associado', 3, 'Não associado', 
        tfacp200.t$asst$l)                              ATRELADO,
        tfacp200.t$balc                                 SALDO,
        
        znfmd630.t$cfrw$c                               TRANSPORTADORA, 
        znfmd630.t$cono$c                               CONTRATO,
        ( select znfmd060.t$cdes$c
          from  baandb.tznfmd060301 znfmd060
          where znfmd060.t$cfrw$c = znfmd630.t$cfrw$c 
            and znfmd060.t$cono$c = znfmd630.t$cono$c )
                                                        NOME_CONTRATO,
        znfmd630.t$fili$c                               FILIAL, 
        znfmd630.t$vlfc$c                               FRETE_GTE,
        znfmd630.t$vlft$c                               FRETE_TRANSPORTADORA,
        znfmd630.t$orno$c                               ORDEM_VENDA, 
        znfmd630.t$pecl$c                               NRO_ENTREGA,
        ''''|| znfmd630.t$cnfe$c                        NFE,
        znfmd630.t$docn$c                               NUM_NFE,
        znfmd630.t$seri$c                               SER_NFE,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c,    
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                                        DATA_EMISSAO,
        ''''||znfmd630.t$ncte$c                         CTE,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,    
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
         AT time zone 'America/Sao_Paulo') AS DATE)    
                                                        EMISS_CTE,
        decode ( znfmd630.t$stat$c,1, 'Aberto', 2, 'Fechado',znfmd630.t$stat$c) 
                                                        STATUS,
        decode (znfmd630.t$torg$c,1, 'Venda',2, 'Reversa', 7, 'Insucesso',znfmd630.t$torg$c) 
                                                        TIPO_OR_FRE,
        ( select znfmd637.t$amnt$c
          from baandb.tznfmd637301 znfmd637
          where znfmd637.t$txre$c = znfmd630.t$txre$c
            and znfmd637.t$line$c = znfmd630.t$line$c
            and znfmd637.t$brty$c = 1 )   --ICMS
                                                        ICMS_FRETE,
        ( select znfmd637_PIS.t$amnt$c
          from    baandb.tznfmd637301 znfmd637_PIS
          where znfmd637_PIS.t$txre$c = znfmd630.t$txre$c
            and znfmd637_PIS.t$line$c = znfmd630.t$line$c
            and znfmd637_PIS.t$brty$c = 5  ) --PIS
                                                        PIS_FRETE,
        ( select znfmd637_COFINS.t$amnt$c 
          from baandb.tznfmd637301 znfmd637_COFINS
          where znfmd637_COFINS.t$txre$c = znfmd630.t$txre$c
            and znfmd637_COFINS.t$line$c = znfmd630.t$line$c
            and znfmd637_COFINS.t$brty$c = 6  ) --COFINS
                                                        COFINS_FRETE,
    (  select nvl(a.t$dsca,'Pedido Interno') t$dsca 
       from   baandb.ttcmcs031301 a,
              baandb.tznsls004301 b,
              baandb.tznint002301 c
       where b.t$orno$c = znfmd630.t$orno$c
         and c.t$ncia$c = b.t$ncia$c
         and c.t$uneg$c = b.t$uneg$c
         and a.t$cbrn = c.t$cbrn$c
         and rownum = 1 )                               MARCA
    
  FROM baandb.ttdrec940301 tdrec940
  
  inner join baandb.ttfacp200301  tfacp200
          on tfacp200.t$ttyp = tdrec940.t$ttyp$l
         and tfacp200.t$ninv = tdrec940.t$invn$l
        
  left join baandb.ttdrec945301 tdrec945
         on tdrec940.t$fire$l = tdrec945.t$fire$l 
        
  inner join baandb.tznfmd630301 znfmd630
         on znfmd630.t$ncte$c = tdrec940.t$cnfe$l
        and tdrec940.t$cnfe$l != ' '

WHERE tfacp200.t$tdoc = ' ' 
  and tfacp200.t$docn = 0 
  and tfacp200.t$lino = 0
  and tfacp200.t$ttyp = 'P00'
  and tfacp200.t$docd between :data_de and :data_ate
  and tdrec940.t$stat$l IN (4,5) -- 4-aprovado, 5-aprovado com problemas
  and tdrec940.t$doty$l = '8'  --conhecimento      
  and tdrec940.t$date$l between to_date(:data_de) and to_date(:data_ate)+2
  
  order by tdrec940.t$fovn$l,tdrec940.t$docn$l
