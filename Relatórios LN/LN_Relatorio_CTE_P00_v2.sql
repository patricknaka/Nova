-- SDP 1480671
-- Caso ocorra alteração da query, SDP deve ser enviado para a pessoa que criou a query conforme email 
-- "SDPs Relatório" de 30/08/2017 enviado por Patrick Nakazoe

  select 
    DISTINCT
    rec_fiscal.T$fovn$l cnpj
  , rec_fiscal.T$fids$l nome
  , invoice.t$amnt valor
  , invoice.t$ttyp doc 
  , invoice.t$ninv nr_doc
  , invoice.t$docd dt_doc
  , case 
      when rec_avi.t$dcty$l = '1' then '1'                                    
      when rec_avi.t$dcty$l = '2' then 'F'
      when rec_avi.t$dcty$l = '3' then '3'
      when rec_avi.t$dcty$l = '4' then '4'      
      when rec_avi.t$dcty$l = '100' then 'O'
      ELSE 'AUT'
    end      
  as tipo 
  , rec_fiscal.t$docn$l nr_cte
  , rec_fiscal.t$seri$l serie
  , ''''||rec_fiscal.t$cnfe$l CTE
  , rec_fiscal.t$idat$l emiss_CTe 
  , orf.t$docn$c nr_nota_fiscal
  , orf.t$seri$c serie_nf  
  , decode (orf.t$torg$c,1, 'Venda',2, 'Reversa', 7, 'Insucesso',orf.t$torg$c) TIPO_OR_FRE
  , decode (invoice.t$asst$l,1, 'Nao aplicavel', 2, 'Associado', 3, 'Não associado', invoice.t$asst$l) ATRELADO
  , invoice.t$balc saldo
  
  FROM baandb.ttfacp200301 invoice
  
  left outer join baandb.ttdrec940301 rec_fiscal
  on invoice.t$ifbp = rec_fiscal.t$bpid$l --parceiro negocio(transportador)
  and invoice.T$docn$l = rec_fiscal.t$docn$l --numero cte (quando � p00)
  and invoice.T$seri$l = rec_fiscal.t$seri$l -- serie do CTE (quando � p00) 
  and rec_fiscal.t$stat$l IN ('4','5') -- 4 - aprovado 5 - aprovado com problemas
  and rec_fiscal.t$doty$l = '8' --conhecimento      
  
  left outer join 
  (
      select 
      distinct rec_avi2.t$fire$l, rec_avi2.t$dcty$l    
      from baandb.ttdrec945301 rec_avi2     
  ) rec_avi 
  on rec_fiscal.t$fire$l = rec_avi.t$fire$l 
  
  left outer join  baandb.tznfmd630301 orf
  on  rec_fiscal.t$cnfe$l = orf.t$ncte$c --numero chave cte          
  
  where 1=1   
  and invoice.t$ttyp = 'P00'
  AND ( invoice.t$tdoc = ' ' and  invoice.t$docn = 0 and  invoice.t$lino = 0 ) 
  and trunc(rec_fiscal.T$idat$l)  between :dataDe and :dataAte
  and ((trim(rec_fiscal.T$fovn$l) in (:CNPJ) and :CNPJTodos = 1) or (:CNPJTodos = 0))
  and ((trim(invoice.t$ifbp) in (:CodPN) and :CodPNTodos = 1) or (:CodPNTodos = 0))

order by rec_fiscal.T$fovn$l,rec_fiscal.t$docn$l
