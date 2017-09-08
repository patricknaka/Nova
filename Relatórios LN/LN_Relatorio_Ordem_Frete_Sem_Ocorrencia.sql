-- SDP 1482560
-- Caso ocorra alteração da query, SDP deve ser enviado para a pessoa que criou a query conforme email 
-- "SDPs Relatório" de 30/08/2017 enviado por Patrick Nakazoe
--QUERY OFICIAL
select 

DISTINCT orf.t$cfrw$c      cod_transp
,dt.t$fovn$l               CNPJ 
,nota.t$cfrn$l             Nome_Transp 
,orf.t$orno$c              ov_ln
,orf.t$pecl$c              entrega
,orf.t$docn$c              numero_nf
,orf.t$seri$c              serie_nf
,''''||orf.t$cnfe$c        chave_nfe
,decode (orf.t$torg$c,1, 'Venda',2, 'Reversa', 7, 'Insucesso',orf.t$torg$c) TIPO_ORD_FRE   
,decode ( orf.t$stat$c,1, 'Aberto', 2, 'Fechado',orf.t$stat$c) Status
,''''||orf.t$ncte$c        chave_cte  
,orf.t$date$c              data_emissao
,orf.t$pfir$c              numero_pre_rec

from baandb.tznfmd630301 orf

join baandb.ttcmcs080301 DDT 
  on orf.t$cfrw$c = ddt.t$cfrw

join baandb.ttccom130301 DT
  on dt.t$cadr = ddt.t$cadr$l

join baandb.tcisli940301 nota
  on nota.t$fire$l = orf.t$fire$c 

left outer join baandb.tznfmd640301 orf_ocorr
  on orf.t$etiq$c = orf_ocorr.t$etiq$c

where 1=1
--and orf.t$torg$c = '2' --1, 'Venda', 2, 'Reversa', 7, 'Insucesso'
and orf.t$stat$c = 1 --1 aberta 2 fechada
and orf_ocorr.t$etiq$c is null
--and     orf.t$date$c < to_date('01/04/2017', 'dd/mm/yyyy')
