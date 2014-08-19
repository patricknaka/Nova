SELECT DISTINCT
      znrec007.t$cvpc$c   Numero_Contrato,
      znrec007.t$seqn$c   Sequencia,
      znrec007.t$canc$c   Flag_Cancelamento,
      tfacr200.t$itbp     Cod_Parceiro_Negocio,
      znrec007.t$fovn$c   CNPJ,
      znrec007.t$svpc$c   Status,
      znrec007.t$fire$c   Ref_Fiscal,
      znrec007.t$ttyp$c ||znrec007.t$docn$c Cd_Chave_Primaria,
      znrec007.t$amnt$c   Valor_VPC,
      znrec007.t$logn$c   Usuario_Ult_Alteracao,
      znrec007.t$fovf$c   CNPJ_Filial,
      znrec007.t$datf$c   Data_Inicial,
      znrec007.t$datt$c   Data_Final,
      znrec007.t$datp$c   Data_Vencimento,
      znrec007.t$paym$c   Metodo_Pagamento,
      znrec007.t$dept$c   Cod_Departamento,
      znrec007.t$seto$c   Cod_Setor,
      znrec007.t$fami$c   Cod_Familia,
      znrec007.t$sfam$c   Cod_Sub_Familia,
      znrec007.t$boni$c   Flag_Pedido_Bonificado,
      znrec007.t$mvpc$c   Modalidade_VPC,
      znrec007.t$udat$c   Data_Ultima_Alteracao
FROM
      baandb.tznrec007201 znrec007,
      baandb.ttfacr200201 tfacr200
WHERE
      znrec007.t$ttyp$c = tfacr200.t$ttyp AND
      znrec007.t$docn$c = tfacr200.t$ninv
ORDER BY 1, 2
