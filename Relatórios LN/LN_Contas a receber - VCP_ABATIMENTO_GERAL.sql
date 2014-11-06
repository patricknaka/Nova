select Q1.* from (

  SELECT 
    DISTINCT
      tfacr200.t$ttyp         Tipo_Transacao,
      tfacr200.t$ninv         Numero_Titulo,
      tccom130.T$FOVN$L       CNPJ,
      tfacr200.t$itbp         Fornecedor,
      MIN(tfacr200.t$docd)    Emissao,
      tfacr301.t$acdt$l       Vencimento,
    
      CASE WHEN sum(tfacp200t.t$balc) = 0 
             THEN ( select max(a.t$docd) 
                      from baandb.ttfacp200301 a 
                     where a.t$ttyp = tfacp200t.t$ttyp 
                       and a.t$ninv = tfacp200t.t$ninv )
           ELSE NULL END      liquidacao,
       
      tfacp200t.t$ttyp        titulo_cap_tipo,
      tfacp200t.t$ninv        titulo_cap_numero,
      tdrec940.t$docn$l       NF,
      tdrec940.t$seri$l       Serie,
      tdrec940.t$rfdt$l       ID_Transacao,
      TIPO_OPERACAO.          Descr_ID_Transacao,       
      tfacr200.t$docd         Data_Transacao,
      tfacr200.t$amnt         Valor_Transacao,
    
      CASE WHEN sum(tfacp200t.t$balc) = 0 THEN 'Liquidado' 
           ELSE 'Aberto' 
       END                    Situacao
        
  FROM       baandb.ttfacr200301 tfacr200
  
  INNER JOIN baandb.ttccom100301 tccom100
          ON tccom100.t$bpid = tfacr200.t$itbp
    
  INNER JOIN baandb.ttccom130301 tccom130
          ON tccom130.t$cadr = tccom100.t$cadr
  
  INNER JOIN baandb.ttfacr201301 tfacr301
          ON tfacr301.t$ttyp = tfacr200.t$ttyp
         AND tfacr301.t$ninv = tfacr200.t$ninv
  
  INNER JOIN baandb.ttfacp200301 tfacp200
          ON tfacp200.t$tdoc = tfacr200.t$tdoc
         AND tfacp200.t$docn = tfacr200.t$docn
  
  INNER JOIN baandb.ttfacp200301 tfacp200t
          ON tfacp200t.t$ttyp = tfacp200.t$ttyp
         AND tfacp200t.t$ninv = tfacp200.t$ninv
  
  INNER JOIN baandb.ttdrec940301 tdrec940
          ON tdrec940.t$ttyp$l = tfacp200.t$ttyp
         AND tdrec940.t$invn$l = tfacp200.t$ninv
  
   LEFT JOIN ( SELECT l.t$desc Descr_ID_Transacao,
                   d.t$cnst
                 FROM baandb.tttadv401000 d,
                      baandb.tttadv140000 l
                WHERE d.t$cpac = 'td'        
                  AND d.t$cdom = 'rec.trfd.l'       
                  AND l.t$clan = 'p'
                  AND l.t$cpac = 'td' 
                  AND l.t$clab = d.t$za_clab
                  AND rpad(d.t$vers,4) ||
                      rpad(d.t$rele,2) ||
                      rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                      rpad(l1.t$rele,2) ||
                                                      rpad(l1.t$cust,4)) 
                                             from baandb.tttadv401000 l1 
                                            where l1.t$cpac = d.t$cpac 
                                              and l1.t$cdom = d.t$cdom )
                  AND rpad(l.t$vers,4) ||
                      rpad(l.t$rele,2) ||
                      rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                      rpad(l1.t$rele,2) ||
                                                      rpad(l1.t$cust,4)) 
                                             from baandb.tttadv140000 l1 
                                            where l1.t$clab = l.t$clab 
                                              and l1.t$clan = l.t$clan 
                                              and l1.t$cpac = l.t$cpac )) TIPO_OPERACAO
          ON TIPO_OPERACAO.t$cnst = tdrec940.t$rfdt$l
  
  WHERE tfacr200.t$tdoc = 'ENC'
    AND tfacr200.t$amnt < 0
    AND tfacp200t.t$lino = 0
  
  GROUP BY tfacr200.t$ttyp, 
           tfacr200.t$ninv, 
           tccom130.T$FOVN$L,
           tfacr200.t$itbp, 
           tfacr301.t$acdt$l,
           tfacp200t.t$ttyp, 
           tfacp200t.t$ninv,
           tdrec940.t$docn$l, 
           tdrec940.t$seri$l,
           tdrec940.t$rfdt$l,
           TIPO_OPERACAO.Descr_ID_Transacao,
           tfacr200.t$docd, 
           tfacr200.t$amnt ) Q1

where Vencimento between nvl(:DataVenctoDe, Vencimento) and nvl(:DataVenctoAte, Vencimento)
  and ( (Numero_Titulo = Trim(:Docto)) or (Trim(:Docto) is null) )
  and ( (Trim(CNPJ) Like '%' || Trim(:CNPJ) || '%') or (Trim(:CNPJ) is null) )  
  and ( (Liquidacao between :DataLiquidacaoDe and :DataLiquidacaoAte) or (:DataLiquidacaoDe is null and :DataLiquidacaoAte is null) )
  and Emissao between nvl(:DataEmissaoDe, Emissao) and nvl(:DataEmissaoAte, Emissao)