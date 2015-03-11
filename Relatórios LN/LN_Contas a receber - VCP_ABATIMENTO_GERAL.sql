select Q1.* from (

  SELECT 
    DISTINCT
      tfacr200.t$ttyp         Tipo_Transacao,
      tfacr200.t$ninv         Numero_Titulo,
      tccom130.T$FOVN$L       CNPJ,
      tfacr200.t$itbp         Fornecedor,
      tccom100.t$nama         Razao_Social,
      MIN(tfacr200.t$docd)    Emissao,
      tfacr301.t$acdt$l       Vencimento,
    
      CASE WHEN sum(tfacp200t.t$balc) = 0 
             THEN ( select max(a.t$docd) 
                      from baandb.ttfacp200201 a 
                     where a.t$ttyp = tfacp200t.t$ttyp 
                       and a.t$ninv = tfacp200t.t$ninv )
           ELSE NULL END      liquidacao,
       
      tfacp200t.t$ttyp        titulo_cap_tipo,
      tfacp200t.t$ninv        titulo_cap_numero,
      cisli940.t$docn$l       NF,
      cisli940.t$seri$l       Serie,
      cisli940.t$fdty$l       ID_Transacao,
      TIPO_OPERACAO.          Descr_ID_Transacao,       
      tfacr200.t$docd         Data_Transacao,
      tfacr200.t$amnt         Valor_Transacao,
    
      CASE WHEN sum(tfacp200t.t$balc) = 0 THEN 'Liquidado' 
           ELSE 'Aberto' 
       END                    Situacao,
       
       znrec007.t$cvpc$c      NUM_CARTA,
       znrec007.t$amnt$c      VALOR_CARTA
        
  FROM       baandb.ttfacr200201 tfacr200

  INNER JOIN baandb.tznrec007201 znrec007
          ON  znrec007.t$ttyp$c = tfacr200.t$ttyp 
          AND znrec007.t$docn$c = tfacr200.t$docn   
  
  INNER JOIN baandb.ttccom100201 tccom100
          ON tccom100.t$bpid = tfacr200.t$itbp
    
  INNER JOIN baandb.ttccom130201 tccom130
          ON tccom130.t$cadr = tccom100.t$cadr
  
  INNER JOIN baandb.ttfacr201201 tfacr301
          ON tfacr301.t$ttyp = tfacr200.t$ttyp
         AND tfacr301.t$ninv = tfacr200.t$ninv
  
  INNER JOIN baandb.ttfacp200201 tfacp200
          ON tfacp200.t$tdoc = tfacr200.t$tdoc
         AND tfacp200.t$docn = tfacr200.t$docn
  
  INNER JOIN baandb.ttfacp200201 tfacp200t
          ON tfacp200t.t$ttyp = tfacp200.t$ttyp
         AND tfacp200t.t$ninv = tfacp200.t$ninv
  
  INNER JOIN baandb.tcisli940201 cisli940
          ON cisli940.t$fire$l = znrec007.t$fire$c

  
   LEFT JOIN ( SELECT l.t$desc Descr_ID_Transacao,
                   d.t$cnst
                 FROM baandb.tttadv401000 d,
                      baandb.tttadv140000 l
                WHERE d.t$cpac = 'ci'        
                  AND d.t$cdom = 'sli.tdff.l'       
                  AND l.t$clan = 'p'
                  AND l.t$cpac = 'ci' 
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
          ON TIPO_OPERACAO.t$cnst = cisli940.t$fdty$l
  
  WHERE tfacr200.t$tdoc = 'ENC'
    AND tfacr200.t$amnt < 0
    AND tfacp200t.t$lino = 0
  
  GROUP BY tfacr200.t$ttyp, 
           tfacr200.t$ninv, 
           tccom130.T$FOVN$L,
           tfacr200.t$itbp,
           tccom100.t$nama,
           tfacr301.t$acdt$l,
           tfacp200t.t$ttyp, 
           tfacp200t.t$ninv,
           cisli940.t$docn$l, 
           cisli940.t$seri$l,
           cisli940.t$fdty$l,
           TIPO_OPERACAO.Descr_ID_Transacao,
           tfacr200.t$docd, 
           tfacr200.t$amnt,
           znrec007.t$cvpc$c,
            znrec007.t$amnt$c ) Q1

where Vencimento between nvl(:DataVenctoDe, Vencimento) and nvl(:DataVenctoAte, Vencimento)
  and ( (Numero_Titulo = Trim(:Docto)) or (Trim(:Docto) is null) )
  and ( (Trim(CNPJ) Like '%' || Trim(:CNPJ) || '%') or (Trim(:CNPJ) is null) )  
  and ( (Liquidacao between :DataLiquidacaoDe and :DataLiquidacaoAte) or (:DataLiquidacaoDe is null and :DataLiquidacaoAte is null) )
  and Emissao between nvl(:DataEmissaoDe, Emissao) and nvl(:DataEmissaoAte, Emissao)