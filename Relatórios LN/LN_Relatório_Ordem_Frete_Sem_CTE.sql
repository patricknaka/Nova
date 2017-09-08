-- SDP 1480640
-- Caso ocorra alteração da query, SDP deve ser enviado para a pessoa que criou a query conforme email 
-- "SDPs Relatório" de 30/08/2017 enviado por Patrick Nakazoe
--->>>>> ###### OF SEM CTE CONSULTA DETALHE
select  
        orf.t$cfrw$c          transportadora
        ,dt.t$fovn$l          CNPJ
       , nota.t$cfrn$l         Nome_Transp
        , orf.t$cono$c        contrato
        , orf.t$fili$c        filial
        , fil.t$fovn$c        cnpj_filial             
        , orf.t$vlfc$c        valor_frete  
        , max (( select  max(imp.t$base$c)
            from    baandb.tznfmd637301 imp
            where   imp.t$txre$c = orf.t$txre$c
            and     imp.t$line$c = orf.t$line$c
            and     imp.t$brty$c = 1))
                              valor_icms
        , orf.t$orno$c        ordem_venda
        , orf.t$pecl$c        nro_entrega
        ,''''|| orf.t$cnfe$c        NFe
        ,orf.t$docn$c         Num_NFe
        ,orf.t$seri$c         SER_NFe
        ,orf.t$date$c         data_emissao
        ,''''||orf.t$ncte$c         CTe
       ,decode ( orf.t$stat$c,1, 'Aberto', 2, 'Fechado',orf.t$stat$c) Status
       ,decode (orf.t$torg$c,1, 'Venda',2, 'Reversa', 7, 'Insucesso',orf.t$torg$c) TIPO_OR_FRE
from    baandb.tznfmd630301 orf
join    baandb.tznfmd001301 fil
on fil.t$fili$c = orf.t$fili$c
join baandb.tcisli940301 nota
on nota.t$fire$l = orf.t$fire$c 
join baandb.tcisli947301 endCli --referencia cliente
on nota.t$fire$l = endCli.t$fire$l
and nota.t$stoa$l = endCli.t$cadr$l 
join baandb.tcisli947301 endNova --referencia cnova
on nota.t$fire$l = endNova.t$fire$l
and nota.t$sfra$l = endNova.t$cadr$l  
 join baandb.ttcmcs080301 DDT 
 on orf.t$cfrw$c = ddt.t$cfrw
 join baandb.ttccom130301 DT
 on dt.t$cadr = ddt.t$cadr$l
where 1=1
 
and   endCli.t$ccit$l <> endNova.t$ccit$l --cidade diferente (fixo)
and   orf.t$ncte$c < '0' --(fixo)
and   orf.t$cfrw$c not in ('T68','T69','T70','T71','T72','T73','A46','INT') -- sem empresas do correio (fixo)
and   trunc(orf.t$date$c)  between :dataDe and :dataAte
and   ((trim(dt.t$fovn$l) in (:CNPJ) and :CNPJTodos = 1) or (:CNPJTodos = 0))

group by orf.t$cfrw$c
        ,orf.t$cono$c
        ,orf.t$fili$c
        ,fil.t$fovn$c       
        ,orf.t$vlfc$c
        ,orf.t$orno$c
        ,orf.t$pecl$c
        ,orf.t$ncte$c
        ,orf.t$date$c
        ,orf.t$cfrw$c         
        ,nota.t$cfrn$l   
        ,orf.t$cnfe$c      
        ,orf.t$docn$c     
        ,orf.t$seri$c      
        ,orf.t$stat$c
        ,orf.t$torg$c
        ,dt.t$fovn$l     
order by orf.t$date$c, orf.t$fili$c
