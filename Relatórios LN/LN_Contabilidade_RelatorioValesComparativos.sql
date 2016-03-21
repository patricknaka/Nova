select 
---Busca Todos os VAD's que estão com saldos diferentes dos Vales, 
---por isso necessário reverter parcialmente os VAD'S
       tfacr200.t$ttyp     TP_TRANS_VAD, 
       tfacr200.t$ninv     DOCTO_VAD, 
       tfacr200.t$line     NR_LINHA_VAD, 
       tfacr200.t$docd     DT_DOCTO_VAD, 
       tfacr200.t$amnt     VL_PRINCIPAL_VAD, 
       tfacr200.t$balc     VL_SALDO_VAD, 
       tfacr200.t$docn$l   NR_DOCTO_VAD,
       tfacr200_1.t$ttyp   TP_TRANS_VAL, 
       tfacr200_1.t$ninv   DOCTO_VAL, 
       tfacr200_1.t$line   NR_LINHA_VAL, 
       tfacr200_1.t$docd   DT_DOCTO_VAL,
       tfacr200_1.t$amnt   VL_PRINCIPAL_VAL, 
       tfacr200_1.t$balc   VL_SALDO_VAL, 
       tfacr200_1.t$docn$l NR_DOCTO_VAL
  
  from baandb.ttfacr200301 tfacr200
  
  inner join baandb.ttfacr200301 tfacr200_1
          on tfacr200_1.t$docn$l = tfacr200.t$docn$l
         and abs(tfacr200_1.T$balc) <> abs(tfacr200.T$balc)

  where tfacr200.t$ttyp = 'VAD'
    and tfacr200.t$tdoc = ' '
    and tfacr200.T$balc <> 0
    and tfacr200_1.t$ttyp = 'VAL'
    and tfacr200.t$docd between :Data_De and :Data_Ate