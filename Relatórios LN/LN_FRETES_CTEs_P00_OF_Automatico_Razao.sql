  SELECT /*+ use_concat parallel(32) no_cpu_costing */ 
        DISTINCT
        tdrec940.T$fovn$l                               CNPJ, 
        tdrec940.T$fids$l                               NOME, 
        tfgld106.t$amnt                                 VALOR_CTE,
        tfgld106.t$leac                                 CONTA_CONTABIL,
        decode(tfgld106.t$dbcr,1,'D',2,'C')             DEB_CRED,
        tfgld106.t$otyp                                 DOC,
        tfgld106.t$odoc                                 NR_DOC, 
        tfgld106.t$dcdt                                 DT_DOC,
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
        case when brnfe940.t$coct$c = 1 then
          znfmd630comp.t$cfrw$c
        else znfmd630.t$cfrw$c end                      TRANSPORTADORA,
        case when brnfe940.t$coct$c = 1 then
          znfmd630comp.t$cono$c 
        else znfmd630.t$cono$c end                       CONTRATO,
        case when brnfe940.t$coct$c = 1 then
            ( select znfmd060.t$cdes$c
              from  baandb.tznfmd060301 znfmd060
              where znfmd060.t$cfrw$c = znfmd630comp.t$cfrw$c 
                and znfmd060.t$cono$c = znfmd630comp.t$cono$c )
        else
            ( select znfmd060.t$cdes$c
              from  baandb.tznfmd060301 znfmd060
              where znfmd060.t$cfrw$c = znfmd630.t$cfrw$c 
                and znfmd060.t$cono$c = znfmd630.t$cono$c )
        end                                             NOME_CONTRATO,
        case when brnfe940.t$coct$c = 1 then
            znfmd630comp.t$fili$c
        else znfmd630.t$fili$c end                      FILIAL,
        case when brnfe940.t$coct$c = 1 then
            0
        else znfmd630.t$vlfc$c end                      FRETE_GTE,
        case when brnfe940.t$coct$c = 1 then
            0
        else znfmd630.t$vlft$c end                      FRETE_TRANSPORTADORA,
        case when brnfe940.t$coct$c = 1 then
            znfmd630comp.t$orno$c
        else znfmd630.t$orno$c end                      ORDEM_VENDA,
        case when brnfe940.t$coct$c = 1 then
            znfmd630comp.t$pecl$c 
        else znfmd630.t$pecl$c end                      NRO_ENTREGA,
        case when brnfe940.t$coct$c = 1 then
            ''''|| znfmd630comp.t$cnfe$c
        else ''''|| znfmd630.t$cnfe$c end               NFE,
        case when brnfe940.t$coct$c = 1 then
            znfmd630comp.t$docn$c
        else znfmd630.t$docn$c end                      NUM_NFE,
        case when brnfe940.t$coct$c = 1 then
            znfmd630comp.t$seri$c
        else znfmd630.t$seri$c end                      SER_NFE,
        case when brnfe940.t$coct$c = 1 then
            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630comp.t$date$c,    
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)
        else
            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c,    
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)
        end                                             DATA_EMISSAO,
        case when brnfe940.t$coct$c = 1 then
            ''''||znfmd630comp.t$ncte$c
        else ''''||znfmd630.t$ncte$c end                CTE,

        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l,    
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
        AT time zone 'America/Sao_Paulo') AS DATE)    
                                                        EMISS_CTE,
        case when brnfe940.t$coct$c = 1 then
            decode ( znfmd630comp.t$stat$c,1, 'Aberto', 2, 'Fechado',znfmd630.t$stat$c) 
        else
            decode ( znfmd630.t$stat$c,1, 'Aberto', 2, 'Fechado',znfmd630.t$stat$c) 
        end                                             STATUS,
        case when brnfe940.t$coct$c = 1 then
            decode (znfmd630comp.t$torg$c,1, 'Venda',2, 'Reversa', 7, 'Insucesso',znfmd630.t$torg$c)
        else
            decode (znfmd630.t$torg$c,1, 'Venda',2, 'Reversa', 7, 'Insucesso',znfmd630.t$torg$c)
        end                                              TIPO_OR_FRE,
        case when brnfe940.t$coct$c = 1 then
            0
        else
            ( select znfmd637.t$amnt$c
              from baandb.tznfmd637301 znfmd637
              where znfmd637.t$txre$c = znfmd630.t$txre$c
                and znfmd637.t$line$c = znfmd630.t$line$c
                and znfmd637.t$brty$c = 1 )   --ICMS
        end                                              ICMS_FRETE,
        case when brnfe940.t$coct$c = 1 then
            0
        else
          ( select znfmd637_PIS.t$amnt$c
            from    baandb.tznfmd637301 znfmd637_PIS
            where znfmd637_PIS.t$txre$c = znfmd630.t$txre$c
              and znfmd637_PIS.t$line$c = znfmd630.t$line$c
              and znfmd637_PIS.t$brty$c = 5  ) --PIS
        end                                               PIS_FRETE,
        case when brnfe940.t$coct$c = 1 then
            0
        else
          ( select znfmd637_COFINS.t$amnt$c 
            from baandb.tznfmd637301 znfmd637_COFINS
            where znfmd637_COFINS.t$txre$c = znfmd630.t$txre$c
              and znfmd637_COFINS.t$line$c = znfmd630.t$line$c
              and znfmd637_COFINS.t$brty$c = 6  ) --COFINS
        end                                                COFINS_FRETE,
    (  select nvl(a.t$dsca,'Pedido Interno') t$dsca 
       from   baandb.ttcmcs031301 a,
              baandb.tznsls004301 b,
              baandb.tznint002301 c
       where b.t$orno$c = znfmd630.t$orno$c
         and c.t$ncia$c = b.t$ncia$c
         and c.t$uneg$c = b.t$uneg$c
         and a.t$cbrn = c.t$cbrn$c
         and rownum = 1 )                               MARCA,
        case when brnfe940.t$coct$c = 1 then
            'Sim'
        else 'Nao' end                                   CTE_COMPLEMENTAR,
        case when brnfe940.t$sige$c = 1 then
            'Sim'
        else 'Nao' end                                   SIGE
    
  FROM baandb.ttfgld106301 tfgld106

  left join ( select /*+ PUSH_PRED INDEX(A TTDREC940301$IDX6)*/
                      a.t$ttyp$l,
                      a.t$invn$l,
                      a.t$fire$l,
                      a.t$cnfe$l,
                      a.t$docn$l,
                      a.t$seri$l,
                      a.t$idat$l,
                      a.t$fids$l,
                      a.t$fovn$l
              from baandb.ttdrec940301 a ) tdrec940
          on tdrec940.t$ttyp$l = tfgld106.t$otyp
         and tdrec940.t$invn$l = tfgld106.t$odoc
  
  left join ( select /*+ PUSH_PRED INDEX(A TTFACP200301$IDX1)*/
                    a.t$ttyp,
                    a.t$ninv,
                    a.t$asst$l,
                    a.t$balc
              from baandb.ttfacp200301 a
              where a.t$tdoc = ' ' 
                and a.t$docn = 0 
                and a.t$lino = 0 ) tfacp200
         on tfacp200.t$ttyp = tfgld106.t$otyp
        and tfacp200.t$ninv = tfgld106.t$odoc 
        
 left join ( select /*+ PUSH_PRED INDEX(A TTDREC945301$IDX1)*/
                     distinct
                     a.t$fire$l,
                     a.t$dcty$l
              from baandb.ttdrec945301 a ) tdrec945 
         on tdrec945.t$fire$l = tdrec940.t$fire$l
        
  left join ( select /*PUSH_PRED INDEX(A TZNFMD630301$IDX14)*/
  
                    distinct
                    a.t$ncte$c,
                    a.t$cfrw$c,
                    a.t$cono$c,
                    a.t$fili$c,
                    a.t$orno$c,
                    a.t$pecl$c,
                    a.t$cnfe$c,
                    a.t$docn$c,
                    a.t$seri$c,
                    a.t$date$c,
                    a.t$stat$c,
                    a.t$torg$c,
                    min(a.t$txre$c) t$txre$c,
                    min(a.t$line$c) t$line$c,
                    max(a.t$vlfc$c) t$vlfc$c,
                    max(a.t$vlft$c) t$vlft$c
            from baandb.tznfmd630301 a
            where a.t$ncte$c != ' '
            group by  a.t$ncte$c,
                      a.t$cfrw$c,
                      a.t$cono$c,
                      a.t$fili$c,
                      a.t$orno$c,
                      a.t$pecl$c,
                      a.t$cnfe$c,
                      a.t$docn$c,
                      a.t$seri$c,
                      a.t$date$c,
                      a.t$stat$c,
                      a.t$torg$c  ) znfmd630    --ordem frete oomplementado
         on znfmd630.t$ncte$c = tdrec940.t$cnfe$l 

  left join baandb.tbrnfe940301 brnfe940
         on brnfe940.t$frec$l = tdrec940.t$fire$l

  left join baandb.tbrnfe944301 brnfe944    --referencia relativa(ctes complementados)
         on brnfe944.t$fire$l = brnfe940.t$fire$l

  left join ( select /*PUSH_PRED INDEX(A TZNFMD630301$IDX14)*/
  
                    distinct
                    a.t$ncte$c,
                    a.t$cfrw$c,
                    a.t$cono$c,
                    a.t$fili$c,
                    a.t$orno$c,
                    a.t$pecl$c,
                    a.t$cnfe$c,
                    a.t$docn$c,
                    a.t$seri$c,
                    a.t$date$c,
                    a.t$stat$c,
                    a.t$torg$c,
                    min(a.t$txre$c) t$txre$c,
                    min(a.t$line$c) t$line$c,
                    max(a.t$vlfc$c) t$vlfc$c,
                    max(a.t$vlft$c) t$vlft$c
            from baandb.tznfmd630301 a
            where a.t$ncte$c != ' '
            group by  a.t$ncte$c,
                      a.t$cfrw$c,
                      a.t$cono$c,
                      a.t$fili$c,
                      a.t$orno$c,
                      a.t$pecl$c,
                      a.t$cnfe$c,
                      a.t$docn$c,
                      a.t$seri$c,
                      a.t$date$c,
                      a.t$stat$c,
                      a.t$torg$c  ) znfmd630comp    --ordem frete oomplementado
         on znfmd630comp.t$ncte$c = brnfe944.t$cnfe$l 

WHERE tfgld106.t$leac in('310301015','310301003')
  and tfgld106.t$fyer = 2017
  and tfgld106.t$fprd = 8
  
--group by tfgld106.t$leac, tfgld106.t$otyp, tfgld106.t$dbcr

--order by tfgld106.t$otyp, tfgld106.t$leac, DEB_CRED
