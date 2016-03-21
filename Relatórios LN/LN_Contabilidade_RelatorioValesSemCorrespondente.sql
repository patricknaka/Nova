
select 
----Busca em todos os VAD's o equivalente em VAL, se encontrar algum Vad criado que não existe VAL, 
----irá trazer para ser analisado     
     tfacr200.t$ttyp        TP_TRANSACAO, 
     tfacr200.t$ninv        DOCTO, 
     tfacr200.t$line        NR_LINHA, 
     tfacr200.t$docd        DT_DOCTO,
     tfacr200.t$amnt        VL_PRINCIPAL, 
     tfacr200.t$balc        VL_SALDO, 
     tfacr200.t$docn$l      NR_DOCTO
    
  from baandb.ttfacr200301 tfacr200
  
  where tfacr200.t$ttyp = 'VAD'
    and tfacr200.t$tdoc = ' '
    and tfacr200.T$balc <> 0
    and not exists (select * from baandb.ttfacr200301 tfacr200_1
                     where tfacr200_1.t$ttyp = 'VAL'
                       and tfacr200_1.t$docn$l = tfacr200.t$docn$l);
