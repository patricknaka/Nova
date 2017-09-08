-- SDP 1480637
-- Caso ocorra alteração da query, SDP deve ser enviado para a pessoa que criou a query conforme email 
-- "SDPs Relatório" de 30/08/2017 enviado por Patrick Nakazoe
-->>>>>>###### OF COM CTE REC FISCAL CONSULTA DETALHE
select  distinct
        orf.t$cfrw$c          transportadora
        , rec.t$fovn$l        cnpj
        , orf.t$cono$c        contrato
        , orf.t$fili$c        filial 
        , fil.t$fovn$c        cnpj_filial        
        , orf.t$vlfc$c valor_Frete
        , max( ( select  max(imp.t$base$c)
            from    baandb.tznfmd637301 imp
            where   imp.t$txre$c = orf.t$txre$c
            and     imp.t$line$c = orf.t$line$c
            and     imp.t$brty$c = 1) )
                              valor_icms
        , rec.t$tfda$l        valor_Frete_transp                                                    
        , orf.t$orno$c        ordem_venda
        , orf.t$pecl$c        nro_entrega
        , rec.t$docn$l        nr_cte
        , rec.t$seri$l        serie
        , ''''||orf.t$ncte$c  CTe
        , orf.t$docn$c nr_nota_fiscal_of
        , orf.t$seri$c serie_nf_of
        , orf.t$date$c        data_cte  
        , ''''||rec.t$fire$l        recebimento_fiscal
        , decode(rec.t$stat$l,
          1, 'Aberto',
          3, 'Nao Aprovado',
          4, 'Aprovado',
          5, 'Aprovado com problemas',
          6, 'Estornado',
          7, 'Nao aplicavel',
          200, 'Aguardando WMS',
          201, 'Pronto para enviar para WMS',
          null, '')           status
        , rec.t$rfdt$l        tipo_doc_fiscal-- 13 estorno
        , decode (orf.t$torg$c,1, 'Venda',2, 'Reversa', 7, 'Insucesso',orf.t$torg$c) TIPO_OR_FRE
from    baandb.tznfmd630301 orf
        join    baandb.tznfmd001301 fil
          on fil.t$fili$c = orf.t$fili$c
        join baandb.ttdrec940301 rec
          on  rec.t$cnfe$l = orf.t$ncte$c --numero chave cte          
where   orf.t$ncte$c <> ' ' 
and     (rec.t$stat$l = 1 or rec.t$stat$l = 3 or rec.t$stat$l is null)--1 aberto 3 n�o aprovado
and     rec.t$doty$l = '8' --conhecimento

and     trunc(orf.t$date$c)  between :dataDe and :dataAte
and     ((trim(rec.T$fovn$l) in (:CNPJ) and :CNPJTodos = 1) or (:CNPJTodos = 0))


group by orf.t$cfrw$c
        , rec.t$fovn$l
        , orf.t$cono$c
        , orf.t$fili$c
        , fil.t$fovn$c          
        , orf.t$vlfc$c
        , rec.t$tfda$l 
        , orf.t$orno$c
        , orf.t$pecl$c
        , rec.t$docn$l
        , rec.t$seri$l
        , orf.t$ncte$c
        , orf.t$docn$c
        , orf.t$seri$c
        , orf.t$date$c
        , rec.t$fire$l
        , rec.t$stat$l
        , rec.t$rfdt$l
        , orf.t$torg$c
