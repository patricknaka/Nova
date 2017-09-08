/*
Criação relatório de CTes agrupados por fatura.
Renato Ferraz - 18/07/2017 - Versao 1 SDP 1451974

*/  


  select 

  rec_fiscal.T$fovn$l cnpj, rec_fiscal.T$fids$l nome, fatura.t$fili$c filial, fatura.t$fovf$c cnpj_filial,
  fatura_conc.t$docn$c nr_fatura, fatura.t$valo$c valor_fatura,
  fatura.t$dtvc$c ven_fatura, fatura_conc.t$frtt$c frete_total, fatura_conc.t$frtn$c frete_total_nova,
  invoice.t$ttyp doc ,invoice.t$ninv nr_doc, invoice.t$docd dt_doc,
  case 
      when rec_avi.t$dcty$l = '1' then '1'                                    
      when rec_avi.t$dcty$l = '2' then 'F'
      when rec_avi.t$dcty$l = '3' then '3'
      when rec_avi.t$dcty$l = '4' then '4'      
      when rec_avi.t$dcty$l = '100' then 'O'
      ELSE 'AUT'
  end      
  as tipo ,
  rec_fiscal.t$docn$l nr_cte, rec_fiscal.t$seri$l serie, fatura_conc.t$dcte$c emiss_CTe, 
  fatura_conc.t$nota$c nr_nf, fatura_conc.t$seri$c serie_nf, fatura_conc.t$nped$c nr_pedido
  ,invoice.t$balc saldo
  FROM baandb.ttdrec940301 rec_fiscal

  left outer join 
  (
      select 
      distinct rec_avi2.t$fire$l, rec_avi2.t$dcty$l    
      from baandb.ttdrec945301 rec_avi2     
  ) rec_avi 
  on rec_fiscal.t$fire$l = rec_avi.t$fire$l

  join  baandb.tznfmd201301 fatura_conc
  on fatura_conc.t$fovt$c = rec_fiscal.T$fovn$l   -- cnpj transportador
  and fatura_conc.t$ncte$c = rec_fiscal.t$docn$l  --numero cte
  and fatura_conc.t$dcte$c = trunc(rec_fiscal.t$idat$l) --data emissao cte
  join  baandb.tznfmd200301 fatura
  on fatura.t$docn$c = fatura_conc.t$docn$c  --numero fatura
  and fatura.t$fovt$c = fatura_conc.t$fovt$c --cnpj transportador
  and fatura.t$fovf$c = fatura_conc.t$fovf$c -- cnpj filial
  join baandb.ttfacp200301 invoice
  on invoice.t$ifbp = rec_fiscal.t$bpid$l     --parceiro negocio(transportador)
  and invoice.T$docn$l = fatura_conc.t$docn$c --número da fatura
  and invoice.t$dued = fatura.t$dtvc$c        --data vencimento  
  where 1=1 
  and rec_fiscal.t$stat$l IN ('4','5') -- 4 - aprovado 5 - aprovado com problemas
  and rec_fiscal.t$doty$l = '8' --conhecimento
  and trunc(rec_fiscal.T$idat$l) >= TO_DATE('01/05/2016', 'dd/mm/yyyy') --data emissao Cte
  and invoice.t$ttyp = 'PFR'
  AND ( invoice.t$tdoc = ' ' and  invoice.t$docn = 0 and  invoice.t$lino = 0 ) 
and fatura.t$dtvc$c   between :Data_Inicial ----(obrigatório) "dd/mm/aaaa"
and   :Data_Final---- até (obrigatório) "dd/mm/aaaa"
and (SUBSTR(rec_fiscal.T$fovn$l,1, 8) in( :cnpj ) or :cnpj is null)---- "99999999/9999-99" (obrigatório, com opção de colocar mais CNPJs separado por vírgula)
order by rec_fiscal.T$fovn$l,fatura_conc.t$docn$c
