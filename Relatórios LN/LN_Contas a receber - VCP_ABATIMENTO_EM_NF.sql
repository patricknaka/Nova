select Q1.* from ( SELECT 
                     DISTINCT
                       tfacr200.t$ttyp         Tipo_Transacao,
                       tfacr200.t$ninv         Numero_Titulo,
                       
                       tfacr200.t$tdoc         Tipo_Transacao_mov,
                       tfacr200.t$docn         Numero_mov, 
                       
                       
                       tfacr200.t$ttyp ||
                       tfacr200.t$ninv         Transacao,
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
                       tfacp200t.t$docn$l       NF,
                       tfacp200t.t$seri$l       Serie,
                       tfacp200t.t$tpay         ID_Transacao,
                       TIPO_OPERACAO.          Descr_ID_Transacao,       
                       tfacr200.t$docd         Data_Transacao,
                       tfacr200.t$amnt         Valor_Transacao,
                     
                       CASE WHEN sum(tfacp200t.t$balc) = 0 
                              THEN 'Liquidado' 
                            ELSE   'Aberto' 
                        END                    Situacao,
                        
                        znrec007.t$cvpc$c      NUM_CARTA,
                        znrec007.t$amnt$c      VALOR_CARTA,
                        tfacp200t.t$balc       SALDO_CAP,
                        tfacp200.t$schn        PARCELA
                         
                   FROM baandb.ttfacr200201 tfacr200

             INNER JOIN baandb.ttfacr200201 tfacr200t
                     ON tfacr200t.t$ttyp = tfacr200.t$ttyp
                    AND tfacr200t.t$ninv = tfacr200.t$ninv				   
			 
                 
             INNER JOIN baandb.tznrec007201 znrec007
                     ON znrec007.t$ttyp$c = tfacr200.t$ttyp 
                    AND znrec007.t$docn$c = tfacr200.t$ninv   
             
             INNER JOIN baandb.ttccom100201 tccom100
                     ON tccom100.t$bpid = tfacr200.t$itbp
               
             INNER JOIN baandb.ttccom130201 tccom130
                     ON tccom130.t$cadr = tccom100.t$cadr
             
              LEFT JOIN baandb.ttfacr201201 tfacr301
                     ON tfacr301.t$ttyp = tfacr200.t$ttyp
                    AND tfacr301.t$ninv = tfacr200.t$ninv
             
             INNER JOIN baandb.ttfacp200201 tfacp200
                     ON tfacp200.t$tdoc = tfacr200.t$tdoc
                    AND tfacp200.t$docn = tfacr200.t$docn
             
             INNER JOIN baandb.ttfacp200201 tfacp200t
                     ON tfacp200t.t$ttyp = tfacp200.t$ttyp
                    AND tfacp200t.t$ninv = tfacp200.t$ninv
             
             
              LEFT JOIN ( select l.t$desc Descr_ID_Transacao,
                                 d.t$cnst
                            from baandb.tttadv401000 d,
                                 baandb.tttadv140000 l
                           where d.t$cpac = 'tf'        
                             and d.t$cdom = 'acp.tpay'       
                             and l.t$clan = 'p'
                             and l.t$cpac = 'tf' 
                             and l.t$clab = d.t$za_clab
                             and rpad(d.t$vers,4) ||
                                 rpad(d.t$rele,2) ||
                                 rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                                 rpad(l1.t$rele,2) ||
                                                                 rpad(l1.t$cust,4)) 
                                                        from baandb.tttadv401000 l1 
                                                       where l1.t$cpac = d.t$cpac 
                                                         and l1.t$cdom = d.t$cdom )
                             and rpad(l.t$vers,4) ||
                                 rpad(l.t$rele,2) ||
                                 rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                                 rpad(l1.t$rele,2) ||
                                                                 rpad(l1.t$cust,4)) 
                                                        from baandb.tttadv140000 l1 
                                                       where l1.t$clab = l.t$clab 
                                                         and l1.t$clan = l.t$clan 
                                                         and l1.t$cpac = l.t$cpac )) TIPO_OPERACAO
                     ON TIPO_OPERACAO.t$cnst = tfacp200t.t$tpay
                   
                  WHERE tfacr200.t$tdoc = 'ENC'
                    AND tfacr200.t$amnt < 0
                    AND tfacp200t.t$lino = 0
                    AND tfacr200t.t$lino = 0
                    
--                    AND tfacr200.t$ttyp='RVA'
--                    AND tfacr200.t$ninv=2675
                    
					
                 HAVING SUM(tfacr200t.t$balc) = 0 

               GROUP BY tfacr200.t$ttyp, 
                        tfacr200.t$ninv, 
                        tfacr200.t$tdoc,
                        tfacr200.t$docn,                         
                        tccom130.T$FOVN$L,
                        tfacr200.t$itbp,
                        tccom100.t$nama,
                        tfacr301.t$acdt$l,
                        tfacp200t.t$ttyp, 
                        tfacp200t.t$ninv,
                        tfacp200t.t$docn$l, 
                        tfacp200t.t$seri$l,
                        tfacp200t.t$tpay,
                        TIPO_OPERACAO.Descr_ID_Transacao,
                        tfacr200.t$docd, 
                        tfacr200.t$amnt,
                        znrec007.t$cvpc$c,
                        znrec007.t$amnt$c,
                        tfacp200t.t$balc,
                        tfacp200.t$schn		) Q1
                 
where Q1.Vencimento between nvl(:DataVenctoDe, Q1.Vencimento) and nvl(:DataVenctoAte, Q1.Vencimento)
  and Q1.Emissao between nvl(:DataEmissaoDe, Q1.Emissao) and nvl(:DataEmissaoAte, Q1.Emissao)
  and ( (Q1.Numero_Titulo = Trim(:Docto)) or (Trim(:Docto) is null) )
  and ( (Trim(Q1.CNPJ) Like '%' || Trim(:CNPJ) || '%') or (Trim(:CNPJ) is null) )  
  and ( (Q1.Liquidacao between :DataLiquidacaoDe and :DataLiquidacaoAte) or (:DataLiquidacaoDe is null and :DataLiquidacaoAte is null) )