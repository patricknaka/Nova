-- SDP 1480655
-- Caso ocorra alteração da query, SDP deve ser enviado para a pessoa que criou a query conforme email 
-- "SDPs Relatório" de 30/08/2017 enviado por Patrick Nakazoe
-->>>>>>###### OF COM CTE PRE-REC CONSULTA DETALHE COM ERRO 
select 
  orf.t$cfrw$c cod_transp
  , pre_rec.t$fovn$l cnpj
  , ''''||pre_rec.t$fire$l numero_pre_rec 
  , pre_rec.t$docn$l nr_cte_pre_rec
  , pre_rec.t$seri$l serie_pre_rec
  , ''''||pre_rec.t$cnfe$l chave_cte_pre_rec
  , ''''||orf.t$ncte$c chave_cte_of
  , orf.t$docn$c nr_nota_fiscal_of
  , orf.t$seri$c serie_nf_of
  , orf.t$fili$c filial
  , fil.t$fovn$c cnpj_filial 
  , orf.t$pecl$c entrega  
  , 'NF com erro' status_erro_pre
  , decode (orf.t$torg$c,1, 'Venda',2, 'Reversa', 7, 'Insucesso',orf.t$torg$c) tipo_of 
  , orf.t$vlfc$c valor_Frete
  , max (( select  max(imp.t$base$c)
            from    baandb.tznfmd637301 imp
            where   imp.t$txre$c = orf.t$txre$c
            and     imp.t$line$c = orf.t$line$c
            and     imp.t$brty$c = 1))
                              valor_frete_icms  
  , pre_rec.t$tfda$l          valor_frete_transp                            
  , pre_rec.t$idat$l data_emiss_cte  
  ,erro.t$mess$c msg_erro
  
  from baandb.tznfmd630301 orf

join    baandb.tznfmd001301 fil
on fil.t$fili$c = orf.t$fili$c
join baandb.tbrnfe940301 pre_rec
on orf.T$pfir$c = pre_rec.t$fire$l

left outer join baandb.tznnfe004301 erro     
on erro.t$fire$c = pre_rec.t$fire$l
and erro.t$mess$c <> 'Foram encontrados erros durante a geracaoo do recebimento fiscal.'

where 1=1
and pre_rec.t$stpr$c = '3' -- 3 NF com erro (fixo)
and pre_rec.t$fdmo$l = '57' --modelo do documento fiscal(cte) (fixo)
and ((trim(pre_rec.T$fovn$l) in (:CNPJ) and :CNPJTodos = 1) or (:CNPJTodos = 0))
--and pre_rec.T$fovn$l = '19727878/0002-32' 

group by orf.t$cfrw$c 
        , pre_rec.t$fovn$l
        , pre_rec.t$fire$l
        , pre_rec.t$docn$l
        , pre_rec.t$seri$l
        , pre_rec.t$cnfe$l
        , orf.t$ncte$c
        , orf.t$docn$c
        , orf.t$seri$c
        , orf.t$fili$c
        , fil.t$fovn$c
        , orf.t$pecl$c
        , orf.t$torg$c
        , orf.t$vlfc$c
        , pre_rec.t$tfda$l
        , pre_rec.t$idat$l
        , erro.t$mess$c
order by pre_rec.t$fovn$l, pre_rec.t$docn$l,pre_rec.t$seri$l
