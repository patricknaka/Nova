select 
  distinct
    tfacr200.t$ttyp         Tipo_Transacao,
    tfacr200.t$ninv         Numero_Titulo,
    tccom130.T$FOVN$L       CNPJ,
    tfacr200.t$itbp         Fornecedor,
    min(tfacr200.t$docd)    Emissao,
    tfacr201.t$acdt$l       Vencimento,
	
    CASE WHEN sum(tfacp200t.t$balc) = 0 
           THEN ( select max(a.t$docd) 
                    from baandb.ttfacp200201 a 
                   where a.t$ttyp = tfacp200t.t$ttyp 
                     and a.t$ninv = tfacp200t.t$ninv )
         ELSE NULL END      liquidacao,
		 
    tfacp200t.t$ttyp        titulo_cap_tipo,
    tfacp200t.t$ninv        titulo_cap_numero,
    tdrec940.t$docn$l       NF,
    tdrec940.t$seri$l       Serie,
    tdrec940.t$rfdt$l       ID_Transacao,
	
    ( SELECT l.t$desc DS_TIPO_OPERACAO
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac = 'td'        
         AND d.t$cdom = 'rec.trfd.l'       
         AND d.t$vers = 'B61U'
         AND d.t$rele = 'a7'
         AND d.t$cust = 'glo1'
         AND l.t$clab = d.t$za_clab
         AND l.t$clan = 'p'
         AND l.t$cpac = 'td' 
         AND l.t$vers = 'B61U'
         AND l.t$rele = 'a7'
         AND l.t$cust = 'glo1'
         AND  d.t$cnst = tdrec940.t$rfdt$l ) 
                            Descr_ID_Transacao,
							
    tfacr200.t$docd         Data_Transacao,
    tfacr200.t$amnt         Valor_Transacao,
	
    CASE WHEN sum(tfacp200t.t$balc) = 0 THEN 'Liquidado' 
         ELSE 'Aberto' 
     END                    Situacao
      
from baandb.ttfacr200201 tfacr200,
     baandb.ttccom100201 tccom100,
     baandb.ttccom130201 tccom130,
     baandb.ttfacr201201 tfacr201,
     baandb.ttfacp200201 tfacp200,
     baandb.ttfacp200201 tfacp200t,
     baandb.ttdrec940201 tdrec940

where tccom100.t$bpid = tfacr200.t$itbp
  and tccom130.t$cadr = tccom100.t$cadr
  and tfacr201.t$ttyp = tfacr200.t$ttyp
  and tfacr201.t$ninv = tfacr200.t$ninv
  and tfacp200.t$tdoc = tfacr200.t$tdoc
  and tfacp200.t$docn = tfacr200.t$docn
  and tdrec940.t$ttyp$l = tfacp200.t$ttyp
  and tdrec940.t$invn$l = tfacp200.t$ninv
  and tfacr200.t$tdoc = 'ENC'
  and tfacr200.t$amnt < 0
  and tfacp200t.t$ttyp = tfacp200.t$ttyp
  and tfacp200t.t$ninv = tfacp200.t$ninv
  and tfacp200t.t$lino = 0

group by tfacr200.t$ttyp, 
         tfacr200.t$ninv, 
         tccom130.T$FOVN$L,
         tfacr200.t$itbp, 
         tfacr201.t$acdt$l,
         tfacp200t.t$ttyp, 
         tfacp200t.t$ninv,
         tdrec940.t$docn$l, 
         tdrec940.t$seri$l,
         tdrec940.t$rfdt$l,
         tfacr200.t$docd, 
         tfacr200.t$amnt 
